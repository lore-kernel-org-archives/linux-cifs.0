From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 08/11] locks: convert fl_link to a hlist_node
Date: Wed, 5 Jun 2013 08:46:11 -0400
Message-ID: <20130605124611.GB24193@fieldses.org>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
 <1370056054-25449-9-git-send-email-jlayton@redhat.com>
 <20130604215950.GE15594@fieldses.org>
 <20130605074309.051ff75f@corrin.poochiereds.net>
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
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130605074309.051ff75f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Jun 05, 2013 at 07:43:09AM -0400, Jeff Layton wrote:
> On Tue, 4 Jun 2013 17:59:50 -0400
> "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> 
> > On Fri, May 31, 2013 at 11:07:31PM -0400, Jeff Layton wrote:
> > > Testing has shown that iterating over the blocked_list for deadlock
> > > detection turns out to be a bottleneck. In order to alleviate that,
> > > begin the process of turning it into a hashtable. We start by turning
> > > the fl_link into a hlist_node and the global lists into hlists. A later
> > > patch will do the conversion of the blocked_list to a hashtable.
> > 
> > Even simpler would be if we could add a pointer to the (well, a) lock
> > that a lockowner is blocking on, and then we'd just have to follow a
> > pointer.  I haven't thought that through, though, perhaps that's hard ot
> > make work....
> > 
> > --b.
> > 
> 
> I considered that as well and it makes sense for the simple local
> filesystem case where you just track ownership based on fl_owner_t.
> 
> But...what about lockd? It considers ownership to be a tuple of the
> nlm_host and the pid sent in a lock request. I can't seem to wrap my
> brain around how to make such an approach work there.

I wonder if we could do something vaguely like

	struct lock_owner_common {
		struct file_lock *blocker;
	};

	struct nlmsvc_lock_owner {
		struct lock_owner_common owner;
		unsigned int client_pid;
	};

and make fl_owner a (struct lock_owner_common *) and have lockd create
nlmsvc_lock_owners as necessary on the fly.  The lm_compare_owner
callback could then be replaced by a pointer comparison.  I'm not sure
what kind of locking or refcounting might be needed.  But...

> I'll confess though that I haven't tried *too* hard yet

... me neither, so...

> though since I had bigger problems to sort through at the time. Maybe
> we can consider that for a later set?

sounds fine.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
