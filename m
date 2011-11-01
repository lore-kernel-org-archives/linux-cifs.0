From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Tue, 1 Nov 2011 04:13:37 -0400
Message-ID: <20111101041337.39077229@tlielax.poochiereds.net>
References: <20111031221743.GA18855@google.com>
	<201111010024.16659.rjw@sisk.pl>
	<20111031233059.GI18855@google.com>
	<20111101005505.GO18855@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101005505.GO18855-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 31 Oct 2011 17:55:05 -0700
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hey, again.
> 
> On Mon, Oct 31, 2011 at 04:30:59PM -0700, Tejun Heo wrote:
> > I can't remember one off the top of my head but I'm pretty sure there
> > at least are few which expect tight inter-locking between sleeps and
> > wakeups.  I'll look for examples and post reply.  ISTR them being
> > kernel threads so this might not apply directly but it's still a
> > dangerous game to play.
> 
> Hmm... I couldn't find KILLABLE used like that but here are two
> UNINTERRUPTIBLE sleep examples.
> 
> * kthread_start() depends on the fact that a kthread won't be woken up
>   from UNINTERRUPTIBLE sleep spuriously.
> 
> * jfs_flush_journal() doesn't check whether the wakeup was spurious
>   after waiting if !tblkGC_COMMITTED.
> 
> Maybe we can re-define KILLABLE as killable && freezable but IMHO that
> requires pretty strong rationales.  If at all possible, let's not
> diddle with that if it can be worked around some other way.
> 
> Thank you.
> 

(cc'ing Trond and the linux-nfs mailing list -- fwiw, he maintains the
NFS client code -- Bruce is the NFS server maintainer and probably has
little interest in this thread).

The main reason for this change is primarily that we have people with
laptops and nfs and cifs mounts that sometimes fail to suspend.

IIUC, the TASK_KILLABLE was mostly added to ensure that file-store
writes would be uninterruptible, but still allow those tasks to be
killed if the process is going down anyway.

The intr/nointr mount options in NFS have been deprecated since
TASK_KILLABLE was added. The scheme now is basically that those sleeps
ignore any signals except for fatal ones. So, that knob is meaningless
and has been for a long time now.

cifs never had a working intr/nointr knob, but signal handling while
waiting for replies was always a difficult thing to handle correctly. I
don't think the right answer is to go back to using such a knob in cifs
or nfs.

I suppose we could look at going back to the world of complicated
signal handling and TASK_INTERRUPTIBLE, but that's not a trivial change
either. The TASK_WAKE_FREEZABLE flag you mention might make more sense
than doing that.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
