From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 12/14] locks: give the blocked_hash its own spinlock
Date: Thu, 13 Jun 2013 11:20:36 -0400
Message-ID: <20130613152036.GC20666@fieldses.org>
References: <1370948948-31784-1-git-send-email-jlayton@redhat.com>
 <1370948948-31784-13-git-send-email-jlayton@redhat.com>
 <20130613150247.GB20666@fieldses.org>
 <20130613111844.59421622@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130613111844.59421622-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jun 13, 2013 at 11:18:44AM -0400, Jeff Layton wrote:
> On Thu, 13 Jun 2013 11:02:47 -0400
> "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> 
> > On Tue, Jun 11, 2013 at 07:09:06AM -0400, Jeff Layton wrote:
> > > There's no reason we have to protect the blocked_hash and file_lock_list
> > > with the same spinlock. With the tests I have, breaking it in two gives
> > > a barely measurable performance benefit, but it seems reasonable to make
> > > this locking as granular as possible.
> > 
> > Out of curiosity...  In the typical case when adding/removing a lock,
> > aren't both lists being modified in rapid succession?
> > 
> > I wonder if it would be better to instead stick with one lock and take
> > care to acquire it only once to cover both manipulations.
> > 
> > --b.
> > 
> 
> That's not really the case...
> 
> Typically, when doing a call into __posix_lock_file with FL_SLEEP set,
> we either end up blocking on the lock or acquiring it. In either case,
> we'll only end up taking one of the global spinlocks. The reason for
> this is that blocker is what dequeues a waiter from the blocked_hash
> before waking it up (in locks_wake_up_posix_blocks).
> 
> Also, while this patch description doesn't spell it out, we require a
> truly global lock for deadlock detection. In a later patch though, I
> convert the file_lock_lock to a per-cpu spinlock. So we really do need
> to separate the locks here in order to make the per-cpu file_lock_list
> worthwhile.

Oh, right, got it!

--b.
