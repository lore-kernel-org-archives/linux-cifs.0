From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Fri, 21 Mar 2014 08:41:28 -0400
Message-ID: <20140321084128.3f499e5c@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
	<20140321081706.271e390c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140321081706.271e390c-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Mar 2014 08:17:06 -0400
Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:

> On Fri, 21 Mar 2014 12:32:12 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 
> 
> > Read and write codepaths both obtain lock_sem for read and then wait
> > for cifsiod_wq to complete and release lock_sem. They don't do any
> > lock_sem operations inside their work task queued to cifsiod_wq. But
> > oplock code can obtain/release lock_sem in its work task. So, that's
> > why I agree with Jeff and suggest to move the oplock code to a
> > different work queue (cifsioopd_wq?) but leave read and write
> > codepaths use cifsiod_wq.
> 
> OK, how about I submit a second patch that moves the reader and writer
> to its own "safe" workqueue?
> 
> -- Steve
> 

That'd probably work fine too. The main point is to make sure oplock
breaks run on a different workqueue from where read or write completion
jobs run since they are operating on the lock_sem. The other jobs that
get queued to cifsiod_wq don't touch the lock_sem and shouldn't be a
problem.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
