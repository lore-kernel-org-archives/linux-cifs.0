From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Wed, 2 Nov 2011 16:13:54 +0100
Message-ID: <20111102151354.GA28527@redhat.com>
References: <20111101065958.50addab5@tlielax.poochiereds.net> <20111101163059.GR18855@google.com> <20111101175953.GB5358@redhat.com> <20111101180601.GV18855@google.com> <20111101181329.GA6739@redhat.com> <20111101182753.GW18855@google.com> <20111101193923.GA9444@redhat.com> <20111101194601.GB9444@redhat.com> <20111101215710.GA13803@google.com> <20111102074257.7174691c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111102074257.7174691c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On 11/02, Jeff Layton wrote:
>
> On Tue, 1 Nov 2011 14:57:10 -0700
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> > For now, let's go with the count/dont_count.  Can you please write up
> > a patch for that?  Jeff, does this seem okay to you?
> >
>
> Let me make sure I understand since I don't have a great grasp of the
> freezer internals...
>
> This will set the PF_FREEZER_SKIP flag on the task, which prevents
> try_to_freeze_tasks from incrementing the "todo" var for this process
> and should let the suspend proceed.
>
> So this really makes try_to_freeze_tasks set PF_FREEZING on the task,
> but not get upset that it doesn't actually call try_to_freeze().

Yes. PF_FREEZER_SKIP means, "please count me as frozen". This task can
do nothing except refrigerator() after wakeup.

> Is that sufficient for a process that's just sleeping here?

I think this should work... but this is the question to you ;)

Oleg.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
