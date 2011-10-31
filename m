From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 00:24:16 +0100
Message-ID: <201111010024.16659.rjw@sisk.pl>
References: <20111031221743.GA18855@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111031221743.GA18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Monday, October 31, 2011, Tejun Heo wrote:
> Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
> TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
> sleep too citing non-interruptible but killable sleeps in cifs and
> nfs.
> 
> I don't think we can do this.  We should not send spurious unsolicited
> non-interruptible wakeups.  Most synchornization constructs are built
> to cope with spurious wakeups and any INTERRUPTIBLE sleep must be able
> to handle spurious wakeups but that's not true for KILLABLE sleeps -
> KILLABLE condition cannot be cancelled.
> 
> This is probably okay for most cases but circumventing fundamental
> wakeup condition like this is asking for trouble.  Furthermore, I'm
> not sure the behavior change brought on by this change - breaking
> nfs/cifs uninterruptible operation guarantee - is correct.  If such
> behavior is desirable, the right thing to do is using intr mount
> option, not circumventing it from PM layer.

Do you have any specific examples of breakage, or is it just that you _think_
it's not quite right?

One patch depending on that change has been merged already and I have two
more in the queue, so I'd like to clarify this ASAP.  Jeff, Steve?

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> Neil, Steve, do the network filesystems need a way to indicate "I can
> either be killed or enter freezer"?
> 
> Thanks.
> 
>  kernel/freezer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 66a594e..7b01de9 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -67,7 +67,7 @@ static void fake_signal_wake_up(struct task_struct *p)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&p->sighand->siglock, flags);
> -	signal_wake_up(p, 1);
> +	signal_wake_up(p, 0);
>  	spin_unlock_irqrestore(&p->sighand->siglock, flags);
>  }

Thanks,
Rafael
