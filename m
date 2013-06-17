From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/13] locks: protect most of the file_lock handling
 with i_lock
Date: Mon, 17 Jun 2013 11:46:09 -0400
Message-ID: <20130617114609.708a336b@tlielax.poochiereds.net>
References: <1371482036-15958-1-git-send-email-jlayton@redhat.com>
	<1371482036-15958-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371482036-15958-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 17 Jun 2013 11:13:49 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Having a global lock that protects all of this code is a clear
> scalability problem. Instead of doing that, move most of the code to be
> protected by the i_lock instead. The exceptions are the global lists
> that the ->fl_link sits on, and the ->fl_block list.
> 
> ->fl_link is what connects these structures to the
> global lists, so we must ensure that we hold those locks when iterating
> over or updating these lists.
> 
> Furthermore, sound deadlock detection requires that we hold the
> blocked_list state steady while checking for loops. We also must ensure
> that the search and update to the list are atomic.
> 
> For the checking and insertion side of the blocked_list, push the
> acquisition of the global lock into __posix_lock_file and ensure that
> checking and update of the  blocked_list is done without dropping the
> lock in between.
> 
> On the removal side, when waking up blocked lock waiters, take the
> global lock before walking the blocked list and dequeue the waiters from
> the global list prior to removal from the fl_block list.
> 
> With this, deadlock detection should be race free while we minimize
> excessive file_lock_lock thrashing.
> 
> Finally, in order to avoid a lock inversion problem when handling
> /proc/locks output we must ensure that manipulations of the fl_block
> list are also protected by the file_lock_lock.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/filesystems/Locking |   21 ++++--
>  fs/afs/flock.c                    |    5 +-
>  fs/ceph/locks.c                   |    2 +-
>  fs/ceph/mds_client.c              |    8 +-
>  fs/cifs/cifsfs.c                  |    2 +-
>  fs/cifs/file.c                    |   13 ++--
>  fs/gfs2/file.c                    |    2 +-
>  fs/lockd/svcsubs.c                |   12 ++--
>  fs/locks.c                        |  151 ++++++++++++++++++++++---------------
>  fs/nfs/delegation.c               |   10 +-
>  fs/nfs/nfs4state.c                |    8 +-
>  fs/nfsd/nfs4state.c               |    8 +-
>  include/linux/fs.h                |   11 ---
>  13 files changed, 140 insertions(+), 113 deletions(-)
> 

[...]

> @@ -1231,7 +1254,7 @@ int __break_lease(struct inode *inode, unsigned int mode)
>  	if (IS_ERR(new_fl))
>  		return PTR_ERR(new_fl);
>  
> -	lock_flocks();
> +	spin_lock(&inode->i_lock);
>  
>  	time_out_leases(inode);
>  
> @@ -1281,11 +1304,11 @@ restart:
>  			break_time++;
>  	}
>  	locks_insert_block(flock, new_fl);
> -	unlock_flocks();
> +	spin_unlock(&inode->i_lock);
>  	error = wait_event_interruptible_timeout(new_fl->fl_wait,
>  						!new_fl->fl_next, break_time);
> -	lock_flocks();
> -	__locks_delete_block(new_fl);
> +	spin_lock(&inode->i_lock);
> +	locks_delete_block(new_fl);

Doh -- bug here. This should not have been changed to
locks_delete_block(). My apologies.

>  	if (error >= 0) {
>  		if (error == 0)
>  			time_out_leases(inode);

[...]

>  posix_unblock_lock(struct file *filp, struct file_lock *waiter)
>  {
> +	struct inode *inode = file_inode(filp);
>  	int status = 0;
>  
> -	lock_flocks();
> +	spin_lock(&inode->i_lock);
>  	if (waiter->fl_next)
> -		__locks_delete_block(waiter);
> +		locks_delete_block(waiter);


Ditto here...

>  	else
>  		status = -ENOENT;
> -	unlock_flocks();
> +	spin_unlock(&inode->i_lock);
>  	return status;
>  }
>  

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
