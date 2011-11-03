From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Thu, 3 Nov 2011 16:10:33 +0100
Message-ID: <20111103151033.GA26843@redhat.com>
References: <20111101041337.39077229@tlielax.poochiereds.net> <20111101215710.GA13803@google.com> <20111102162331.GA31947@redhat.com> <201111030011.24062.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201111030011.24062.rjw-KKrjLPT3xs0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/03, Rafael J. Wysocki wrote:
>
> On Wednesday, November 02, 2011, Oleg Nesterov wrote:
> >
> > Rafael, could you remind why freezer_do_not_count/freezer_count check
> > ->mm != NULL ?
>
> You're asking difficult questions. ;-)

I am trying ;)

> The intention was to prevent PF_FREEZER_SKIP from having any effect on
> kernel threads, IIRC.  Anyway, there are only two legitimate users of it
> (vfork and apm_ioctl) and in both cases the task in question is user space.

Actually CLONE_VFORK is used by call_usermodehelper() paths but this case
is fine. The caller is the PF_NOFREEZE workqueue thread.

> > The comment says "However, we don't want kernel threads to be frozen",
> > but it is not clear anyway. A kernel thread simply shouldn't use this
> > interface if it doesn't want to freeze.
> >
> > And in any case, PF_KTHREAD looks better if we really need to filter
> > out the kernel threads.
>
> PF_FREEZER_SKIP was introduced specifically with vfork in mind and I'm not
> sure if it's a good idea to re-use it for something else (at least not for
> something entirely obvious).

Indeed! So why do we check ->mm != NULL?

We can remove this check, right now it doesn't matter. And we are trying
to avoid the new users of this interface.

Oleg.
