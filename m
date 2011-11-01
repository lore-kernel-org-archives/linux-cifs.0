From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 20:39:23 +0100
Message-ID: <20111101193923.GA9444@redhat.com>
References: <201111010024.16659.rjw@sisk.pl> <20111031233059.GI18855@google.com> <20111101005505.GO18855@google.com> <20111101041337.39077229@tlielax.poochiereds.net> <20111101065958.50addab5@tlielax.poochiereds.net> <20111101163059.GR18855@google.com> <20111101175953.GB5358@redhat.com> <20111101180601.GV18855@google.com> <20111101181329.GA6739@redhat.com> <20111101182753.GW18855@google.com>
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
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111101182753.GW18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On 11/01, Tejun Heo wrote:
>
> Hello,
>
> On Tue, Nov 01, 2011 at 07:13:29PM +0100, Oleg Nesterov wrote:
> > On 11/01, Tejun Heo wrote:
> > >
> > > Yeah yeah, Trond already pointed it out.  I forgot about the
> > > sigpending special case in schedule(), which I think is rather odd,
> >
> > I disagree with "rather odd" ;)
> >
> > We have a lot of examples of
> >
> > 	current->state = TASK_INTERRUPTIBLE;
> > 	...
> > 	if (signal_pending())
> > 		break;
> > 	schedule();
> >
> > Without that special case in schedule() the code above becomes racy.
> > Just consider __wait_event_interruptible().
>
> But __wait_event_interruptible() does proper set-TASK_*, check
> sigpending and schedule() sequence.  As long as the waker performs
> seg-sigpending, wakeup sequence in the correct order, nothing is
> broken (as w/ any other wakeup conditions).  The special case deals
> with callers which don't check sigpending between set-TASK_* and
> schedule() and that's the part I think is a bit odd.

OK, agreed, __wait_event_interruptible() was a bad example.

Yes, this is only needed for the code which doesn't check
signal_pending() "properly", or doesn't check it at all before
schedule(). OK, say, wait_for_completion_interruptible().
Or schedule_timeout_interruptible().

I suspect we have a lot more examples. Historically linux allows to
set TASK_INTERRUPTIBLE and schedule() without any checks.

> Whether I feel
> odd or not is irrelevant tho - it's already there.

Yes, I don't think we can remove it.

> > > Any better ideas?
> >
> > Well. As a simple (probably temporary) fix, I'd suggest
> >
> > 	#define wait_event_freezekillable(wq, condition)
> > 	{
> > 		freezer_do_not_count();
> > 		__retval = wait_event_killable(condition);
> > 		freezer_count();
> > 		__retval;
> > 	}
> >
> > Do you think it can work?
>
> Yeah, probably.  I was hoping to remove count/do_not_count tho.

Or at least rename it ;)

> Hmmm... maybe we can just flip PF_NOFREEZE instead with a bit of
> modification, I think.

Perhaps.

Or we can add TASK_FREEZABLE (like TASK_WAKEKILL), iirc we already
discussed this some time ago. And probably it makes sense to add the
generic wait_event_state().

Oleg.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
