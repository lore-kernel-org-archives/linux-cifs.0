From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Mon, 31 Oct 2011 16:17:30 -0700
Message-ID: <20111031231730.GH18855@google.com>
References: <20111031221743.GA18855@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111031221743.GA18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 31, 2011 at 03:17:43PM -0700, Tejun Heo wrote:
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
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> Neil, Steve, do the network filesystems need a way to indicate "I can
> either be killed or enter freezer"?

Hmm... okay, so commit f06ac72e929 "cifs, freezer: add
wait_event_freezekillable and have cifs use it" added freezable &
killable sleep.  If this is necessary, the right thing to do is adding
another waking state, not modifying existing one's behavior.

But, before going there, is this *really* necessary?  Do we really
have to choose among different combinations of interruptible, killable
and freezable?  If something doesn't want to be bothered than being
killed, assuming it doesn't want to go hibernating is kinda natural.

IOW, can we please update cifs, if it wants to allow hibernation, to
use interruptible sleep in wait_for_response() than trying to modify
basic sleep mechanism?

Thank you.

-- 
tejun
