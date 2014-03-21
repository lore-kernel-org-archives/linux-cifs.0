From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Fri, 21 Mar 2014 07:59:56 -0400
Message-ID: <20140321075956.500fe42d@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Mar 2014 12:32:12 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2014-03-21 6:23 GMT+04:00 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>:
> > On Thu, 20 Mar 2014 17:02:39 -0400
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> Eventually the server should just allow the read to complete even if
> >> the client doesn't respond to the oplock break. It has to since clients
> >> can suddenly drop off the net while holding an oplock. That should
> >> allow everything to unwedge eventually (though it may take a while).
> >>
> >> If that's not happening then I'd be curious as to why...
> >
> > The problem is that the data is being filled in the page and the reader
> > is waiting for the page lock to be released. The kworker for the reader
> > will issue the complete() and unlock the page to wake up the reader.
> >
> > But because the other workqueue callback calls down_read(), and there
> > can be a down_write() waiting for the reader to finish, this
> > down_read() will block on the lock as well (rwsems are fair locks).
> > This blocks the other workqueue callback from issuing the complete and
> > page_unlock() that will wake up the reader that is holding the rwsem
> > with down_read().
> >
> > DEADLOCK.
> 
> Thank you for reporting and clarifying the issue!
> 
> Read and write codepaths both obtain lock_sem for read and then wait
> for cifsiod_wq to complete and release lock_sem. They don't do any
> lock_sem operations inside their work task queued to cifsiod_wq. But
> oplock code can obtain/release lock_sem in its work task. So, that's
> why I agree with Jeff and suggest to move the oplock code to a
> different work queue (cifsioopd_wq?) but leave read and write
> codepaths use cifsiod_wq.
> 

Yes, thanks for the clarification. I missed the fact that a 3rd task
was blocked on a down_write. I think that fix will help prevent the
full-blown deadlock, but it'll still be susceptible to long stalls in
some situations.

In Steven's example the work on CPU0 is blocked on a SMB_READ. That
read may not be completing because the server has issued an oplock
break to the client and is waiting on the response. That oplock break
response is blocked because it's blocked on the down_write.

In that situation, what breaks the deadlock is that the server
eventually gives up waiting on the oplock break response, but that can
take on the order of a minute.

So yeah, I think we should add a dedicated workqueue for oplock breaks
as an interim fix, but I also think we need to consider revamping the
lock pushing code such that oplock breaks are not subject to being
blocked like that.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
