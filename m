From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work queues
Date: Wed, 19 Mar 2014 16:28:39 -0400
Message-ID: <20140319202839.GA3656@mtj.dyndns.org>
References: <20140319151252.16ed3ac6@gandalf.local.home>
 <20140319193407.GA11257@laptop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140319193407.GA11257-RM5+C6weyIYnLiPH7yDmwOa11wxjtiyuLtmvbW2Dspo@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello, Steven, Peter.

On Wed, Mar 19, 2014 at 08:34:07PM +0100, Peter Zijlstra wrote:
> The way I understand workqueues is that we cannot guarantee concurrency
> like this. It tries, but there's no guarantee.

So, the guarantee is that if a workqueue has WQ_MEM_RECLAIM, it'll
always have at least one worker thread working on it, so workqueues
which may be depended upon during memory reclaim should have the flag
set and must not require more than single level of concurrency to make
forward progress.  Workqueues w/o memory reclaim set depend on the
fact that eventually memory will be reclaimed and enough number of
workers necessary to make forward progress will be made available.

> WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
> given 511 other blocked works, the described problem will always happen.

That actually is per-workqueue limit and workqueue core will try to
create as many workers as possible to satisfy the demanded
concurrency.  ie. having two workqueues with the same max_active means
that the total number of workers may reach 2 * max_active; however,
this is no guarantee.  If the system is under memory pressure and the
workqueues don't have MEM_RECLAIM set, they may not get any
concurrency until more memory is made available.

> Creating another workqueue doesn't actually create more threads.

It looks like the issue Steven is describing is caused by having a
dependency chain longer than 1 through rwsem in a MEM_RECLAIM
workqueue.  Moving the write work items to a separate workqueue breaks
the r-w-r chain and ensures that forward progress can be made with
single level of concurrency on both workqueues, so, yeah, it looks
like the correct fix to me.  It it scarily subtle tho and quite likely
to present in other code paths too. :(

Thanks.

-- 
tejun
