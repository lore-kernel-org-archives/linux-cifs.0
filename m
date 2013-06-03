From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 00/11] locks: scalability improvements for file locking
Date: Mon, 3 Jun 2013 17:31:01 -0400
Message-ID: <20130603213101.GC2109@fieldses.org>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
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
In-Reply-To: <1370056054-25449-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 31, 2013 at 11:07:23PM -0400, Jeff Layton wrote:
> Executive summary (tl;dr version): This patchset represents an overhaul
> of the file locking code with an aim toward improving its scalability
> and making the code a bit easier to understand.

Thanks for working on this, that code could use some love!

> Longer version:
> 
> When the BKL was finally ripped out of the kernel in 2010, the strategy
> taken for the file locking code was to simply turn it into a new
> file_lock_locks spinlock. It was an expedient way to deal with the file
> locking code at the time, but having a giant spinlock around all of this
> code is clearly not great for scalability. Red Hat has bug reports that
> go back into the 2.6.18 era that point to BKL scalability problems in
> the file locking code and the file_lock_lock suffers from the same
> issues.
> 
> This patchset is my first attempt to make this code less dependent on
> global locking. The main change is to switch most of the file locking
> code to be protected by the inode->i_lock instead of the file_lock_lock.
> 
> While that works for most things, there are a couple of global data
> structures (lists in the current code) that need a global lock to
> protect them. So we still need a global lock in order to deal with
> those. The remaining patches are intended to make that global locking
> less painful. The big gain is made by turning the blocked_list into a
> hashtable, which greatly speeds up the deadlock detection code.
> 
> I rolled a couple of small programs in order to test this code. The
> first one just forks off 128 children and has them lock and unlock the
> same file 10k times. Running this under "time" against a file on tmpfs
> gives typical values like this:

What kind of hardware was this?

> 
> Unpatched (3.10-rc3-ish):
> real	0m5.283s
> user	0m0.380s
> sys	0m20.469s
> 
> Patched (same base kernel):
> real	0m5.099s
> user	0m0.478s
> sys	0m19.662s
> 
> ...so there seems to be some modest performance gain in this test. I
> think that's almost entirely due to the change to a hashtable and to
> optimize removing and readding blocked locks to the global lists. Note
> that with this code we have to take two spinlocks instead of just one,
> and that has some performance impact too. So the real peformance gain
> from that hashtable conversion is eaten up to some degree by this.

Might be nice to look at some profiles to confirm all of that.  I'd also
be curious how much variation there was in the results above, as they're
pretty close.

> The next test just forks off a bunch of children that each create their
> own file and then lock and unlock it 20k times. Obviously, the locks in
> this case are uncontended. Running that under "time" typically gives
> these rough numbers.
> 
> Unpatched (3.10-rc3-ish):
> real	0m8.836s
> user	0m1.018s
> sys	0m34.094s
> 
> Patched (same base kernel):
> real	0m4.965s
> user	0m1.043s
> sys	0m18.651s
> 
> In this test, we see the real benefit of moving to the i_lock for most
> of this code. The run time is almost cut in half in this test. With
> these changes locking different inodes needs very little serialization.
> 
> If people know of other file locking performance tests, then I'd be
> happy to try them out too. It's possible that this might make some
> workloads slower, and it would be helpful to know what they are (and
> address them) if so.
> 
> This is not the first attempt at doing this. The conversion to the
> i_lock was originally attempted by Bruce Fields a few years ago. His
> approach was NAK'ed since it involved ripping out the deadlock
> detection. People also really seem to like /proc/locks for debugging, so
> keeping that in is probably worthwhile.

Yes, there's already code that depends on it.

The deadlock detection, though--I still wonder if we could get away with
ripping it out.  Might be worth at least giving an option to configure
it out as a first step.

--b.

> There's more work to be done in this area and this patchset is just a
> start. There's a horrible thundering herd problem when a blocking lock
> is released, for instance. There was also interest in solving the goofy
> "unlock on any close" POSIX lock semantics at this year's LSF. I think
> this patchset will help lay the groundwork for those changes as well.
> 
> Comments and suggestions welcome.
> 
> Jeff Layton (11):
>   cifs: use posix_unblock_lock instead of locks_delete_block
>   locks: make generic_add_lease and generic_delete_lease static
>   locks: comment cleanups and clarifications
>   locks: make "added" in __posix_lock_file a bool
>   locks: encapsulate the fl_link list handling
>   locks: convert to i_lock to protect i_flock list
>   locks: only pull entries off of blocked_list when they are really
>     unblocked
>   locks: convert fl_link to a hlist_node
>   locks: turn the blocked_list into a hashtable
>   locks: add a new "lm_owner_key" lock operation
>   locks: give the blocked_hash its own spinlock
> 
>  Documentation/filesystems/Locking |   27 +++-
>  fs/afs/flock.c                    |    5 +-
>  fs/ceph/locks.c                   |    2 +-
>  fs/ceph/mds_client.c              |    8 +-
>  fs/cifs/cifsfs.c                  |    2 +-
>  fs/cifs/file.c                    |   15 +-
>  fs/gfs2/file.c                    |    2 +-
>  fs/lockd/svclock.c                |   12 ++
>  fs/lockd/svcsubs.c                |   12 +-
>  fs/locks.c                        |  254 +++++++++++++++++++++++++------------
>  fs/nfs/delegation.c               |   11 +-
>  fs/nfs/nfs4state.c                |    8 +-
>  fs/nfsd/nfs4state.c               |    8 +-
>  include/linux/fs.h                |   25 +---
>  14 files changed, 249 insertions(+), 142 deletions(-)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
