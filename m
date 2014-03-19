From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work queues
Date: Wed, 19 Mar 2014 20:47:29 +0100
Message-ID: <20140319194729.GB11257@laptop.programming.kicks-ass.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
 <20140319193407.GA11257@laptop.programming.kicks-ass.net>
 <20140319154339.44c327e3@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140319154339.44c327e3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 19, 2014 at 03:43:39PM -0400, Steven Rostedt wrote:
> On Wed, 19 Mar 2014 20:34:07 +0100
> Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > On Wed, Mar 19, 2014 at 03:12:52PM -0400, Steven Rostedt wrote:
> > > My question to Tejun is, if we create another workqueue, to add the
> > > rdata->work to, would that prevent the above problem? Or what other
> > > fixes can we do?
> > 
> > The way I understand workqueues is that we cannot guarantee concurrency
> > like this. It tries, but there's no guarantee.
> > 
> > WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
> > given 511 other blocked works, the described problem will always happen.
> > 
> > Creating another workqueue doesn't actually create more threads.
> 
> But I noticed this:
> 
>  Before patch:
> 
> # ps aux |grep cifs
> root      3119  0.0  0.0      0     0 ?        S<   14:17   0:00 [cifsiod]
> 
>  After patch:
> 
> # ps aux |grep cifs
> root      1109  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiod]
> root      1111  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiord]
> 
> It looks to me that it does create new threads.

Ah, I think that's because of the MEM_RECLAIM, not sure if that will
normally participate in running works. Its been a long time since I
looked at any of that.

Lets wait for TJ to wake up.
