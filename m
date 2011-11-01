From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 18:50:35 +0100
Message-ID: <20111101175035.GA5358@redhat.com>
References: <20111031221743.GA18855@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111031221743.GA18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/31, Tejun Heo wrote:
>
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

Agreed.

For example. sys_read() or page can sleep in TASK_KILLABLE assuming that
wait/down/whatever _killable can only fail if we can not return to the
usermode.

TASK_TRACED case is obviously wrong too.

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

Agreed, this looks like a bug fix to me.

Acked-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
