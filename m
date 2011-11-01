From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 18:59:53 +0100
Message-ID: <20111101175953.GB5358@redhat.com>
References: <20111031221743.GA18855@google.com> <201111010024.16659.rjw@sisk.pl> <20111031233059.GI18855@google.com> <20111101005505.GO18855@google.com> <20111101041337.39077229@tlielax.poochiereds.net> <20111101065958.50addab5@tlielax.poochiereds.net> <20111101163059.GR18855@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111101163059.GR18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/01, Tejun Heo wrote:
>
> diddling with
> sigmask in kernel generally isn't a good idea.

Agreed.

> If there are only a handful sites which need this type of behavior,
> wouldn't something like the following work?
>
> #define wait_event_freezekillable(wq, condition)			\
> do {									\
> 	DEFINE_WAIT(__wait);						\
> 	for (;;) {							\
> 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
> 		if (condition || fatal_signal_pending(current))		\
> 			break;						\
> 		schedule();						\

No, this can't work, afaics.

Once the caller recieves a non-fatal signal (gets TIF_SIGPENDING),
schedule() won't block in TASK_INTERRUPTIBLE state.

IOW, wait_event_freezekillable() becomes a busy-wait loop.

Oleg.
