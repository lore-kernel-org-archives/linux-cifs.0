From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Thu, 20 Mar 2014 17:02:39 -0400
Message-ID: <20140320170239.51d20a0e@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140320165703.522c7c5c-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Mar 2014 16:57:03 -0400
Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:

> On Thu, 20 Mar 2014 15:28:33 -0400
> Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
>  
> > Nice analysis! I think eventually we'll need to overhaul this code not
> 
> Note, Ulrich Obergfell helped a bit in the initial analysis. He found
> from a customer core dump that the kworker thread was blocked on the
> cinode->lock_sem, and the reader was blocked as well. That was enough
> for me to find where the problem laid.
> 

Kudos to Uli, then ;)

> > to use rw semaphores, but that's going to take some redesign. (Wonder
> > if we could change it to use seqlocks or something?)
> > 
> > Out of curiousity, does this eventually time out and unwedge itself?
> > Usually when the server doesn't get a response to an oplock break in
> > around a minute or so it gives up and allows the thing that caused the
> > oplock break to proceed anyway. Not great for performance but it out to
> > eventually make progress due to that.
> 
> No, I believe it's hard locked. Nothing is going to wake up the oplock
> break  if it is blocked on a down_read(). Only the release of the rwsem
> will do that. It's the subtle way the kworker threads are done.
> 

Eventually the server should just allow the read to complete even if
the client doesn't respond to the oplock break. It has to since clients
can suddenly drop off the net while holding an oplock. That should
allow everything to unwedge eventually (though it may take a while).

If that's not happening then I'd be curious as to why...

> > 
> > In any case, this looks like a reasonable fix for now, but I suspect you
> > can hit similar problems in the write codepath too. What may be best is
> > turn this around and queue the oplock break to the new workqueue
> > instead of the read completion job.
> 
> Or perhaps give both the read and write their own workqueues? We have
> to look at all the work queue handlers, and be careful about any users
> that take the lock_sem, and separate them out.
> 

Yeah, I haven't looked closely yet but I'm fairly sure that you could
hit the same situation in the write codepath as well. Whether adding
more workqueues will really help, I'm not sure of yet...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
