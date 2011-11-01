From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 09:30:59 -0700
Message-ID: <20111101163059.GR18855@google.com>
References: <20111031221743.GA18855@google.com>
 <201111010024.16659.rjw@sisk.pl>
 <20111031233059.GI18855@google.com>
 <20111101005505.GO18855@google.com>
 <20111101041337.39077229@tlielax.poochiereds.net>
 <20111101065958.50addab5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111101065958.50addab5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello, Jeff.

On Tue, Nov 01, 2011 at 06:59:58AM -0400, Jeff Layton wrote:
> > I suppose we could look at going back to the world of complicated
> > signal handling and TASK_INTERRUPTIBLE, but that's not a trivial change
> > either. The TASK_WAKE_FREEZABLE flag you mention might make more sense
> > than doing that.

I see.

> Also, since task state and signal handling clearly isn't my forte...can
> you clarify what the main difference is in using a TASK_KILLABLE sleep
> vs. TASK_INTERRUPTIBLE with all signals but SIGKILL blocked?
>
> I know that the process state would end up different (S vs. D state).
> Is there anything else we'd need to be concerned with if we converted
> all these call sites to use such a scheme in lieu of a new
> TASK_WAKE_FREEZABLE flag or similar?

Manipulating sigmask would work in most cases but there are corner
cases (e.g. debug signals will force the mask off) and diddling with
sigmask in kernel generally isn't a good idea.

If TASK_KILLABLE is only used for killable && freezable, that probably
would be the cleanest solution but given the name and the fact that
people are in general much more aware of SIGKILL's then freezer, I
think adding such assumption is likely to cause very subtle bugs.  For
example, mem_cgroup_handle_oom() seems to assume that if it's waken
from TASK_KILLABLE either the condition it was waiting for is true or
it is dying.

If there are only a handful sites which need this type of behavior,
wouldn't something like the following work?

#define wait_event_freezekillable(wq, condition)			\
do {									\
	DEFINE_WAIT(__wait);						\
	for (;;) {							\
		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
		if (condition || fatal_signal_pending(current))		\
			break;						\
		schedule();						\
		try_to_freeze();					\
	}								\
	finish_wait(&wq, &__wait);					\
} while (0)

Thanks.

-- 
tejun
