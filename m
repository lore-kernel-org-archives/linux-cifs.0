From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Simplify setlk error handling for mandatory
 locking
Date: Tue, 08 Nov 2011 18:42:53 +0000
Message-ID: <1320777775.1690.41.camel@sprabhu.fab.redhat.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	 <1319894279-7723-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319894279-7723-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,

I may have found a bug in this patch. I've commented inline.

On Sat, 2011-10-29 at 17:17 +0400, Pavel Shilovsky wrote:
> Now we allocate a lock structure at first, then we request to the server
> and save the lock if server returned OK though void function - it prevents
> the situation when we locked a file on the server and then return -ENOMEM
> from setlk.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   64 ++++++++++++++++++++++++++++----------------------------
>  1 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c1f063c..d9cc07f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -672,7 +672,7 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
>  }
>  
>  static bool
> -cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
> +__cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
>  			__u64 length, __u8 type, __u16 netfid,
>  			struct cifsLockInfo **conf_lock)
>  {
> @@ -694,6 +694,14 @@ cifs_find_lock_conflict(struct cifsInodeInfo *cinode, __u64 offset,
>  	return false;
>  }
>  
> +static bool
> +cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
> +			struct cifsLockInfo **conf_lock)
> +{
> +	return __cifs_find_lock_conflict(cinode, lock->offset, lock->length,
> +					 lock->type, lock->netfid, conf_lock);
> +}
> +
>  static int
>  cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
>  	       __u8 type, __u16 netfid, struct file_lock *flock)
> @@ -704,8 +712,8 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
>  
>  	mutex_lock(&cinode->lock_mutex);
>  
> -	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
> -					&conf_lock);
> +	exist = __cifs_find_lock_conflict(cinode, offset, length, type, netfid,
> +					  &conf_lock);
>  	if (exist) {
>  		flock->fl_start = conf_lock->offset;
>  		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
> @@ -723,40 +731,27 @@ cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
>  	return rc;
>  }
>  
> -static int
> -cifs_lock_add(struct cifsInodeInfo *cinode, __u64 len, __u64 offset,
> -	      __u8 type, __u16 netfid)
> +static void
> +cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
>  {
> -	struct cifsLockInfo *li;
> -
> -	li = cifs_lock_init(len, offset, type, netfid);
> -	if (!li)
> -		return -ENOMEM;
> -
>  	mutex_lock(&cinode->lock_mutex);
> -	list_add_tail(&li->llist, &cinode->llist);
> +	list_add_tail(&lock->llist, &cinode->llist);
>  	mutex_unlock(&cinode->lock_mutex);
> -	return 0;
>  }
>  
>  static int
> -cifs_lock_add_if(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
> -		 __u8 type, __u16 netfid, bool wait)
> +cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
> +		 bool wait)
>  {
> -	struct cifsLockInfo *lock, *conf_lock;
> +	struct cifsLockInfo *conf_lock;
>  	bool exist;
>  	int rc = 0;
>  
> -	lock = cifs_lock_init(length, offset, type, netfid);
> -	if (!lock)
> -		return -ENOMEM;
> -
>  try_again:
>  	exist = false;
>  	mutex_lock(&cinode->lock_mutex);
>  
> -	exist = cifs_find_lock_conflict(cinode, offset, length, type, netfid,
> -					&conf_lock);
> +	exist = cifs_find_lock_conflict(cinode, lock, &conf_lock);
>  	if (!exist && cinode->can_cache_brlcks) {
>  		list_add_tail(&lock->llist, &cinode->llist);
>  		mutex_unlock(&cinode->lock_mutex);
> @@ -781,7 +776,6 @@ try_again:
>  		}
>  	}
>  
> -	kfree(lock);
>  	mutex_unlock(&cinode->lock_mutex);
>  	return rc;
>  }
> @@ -1254,20 +1248,26 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
>  	}
>  
>  	if (lock) {
> -		rc = cifs_lock_add_if(cinode, flock->fl_start, length,
> -				      type, netfid, wait_flag);
> +		struct cifsLockInfo *lock;
> +
> +		lock = cifs_lock_init(length, flock->fl_start, type, netfid);
> +		if (!lock)
> +			return -ENOMEM;
> +
> +		rc = cifs_lock_add_if(cinode, lock, wait_flag);
>  		if (rc < 0)
> -			return rc;
> -		else if (!rc)
> +			kfree(lock);
> +		if (rc <= 0)
>  			goto out;

The return values for cifs_lock_add_if could be
0 - If no locks exist and we can cache byte range locks
1 - If lock doesn't exist and we do not cache byte range locks.
< 0 in case of an error

In case of an error, ie. return value < 0, shouldn't we just return rc
and skip the call to posix_lock_file_wait below?

This should be 
                if (rc < 0) {
                        kfree(lock);
			return rc;
                if (!rc)
                        goto out;

Sachin Prabhu


>  
>  		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
>  				 flock->fl_start, 0, 1, type, wait_flag, 0);
> -		if (rc == 0) {
> -			/* For Windows locks we must store them. */
> -			rc = cifs_lock_add(cinode, length, flock->fl_start,
> -					   type, netfid);
> +		if (rc) {
> +			kfree(lock);
> +			goto out;
>  		}
> +
> +		cifs_lock_add(cinode, lock);
>  	} else if (unlock)
>  		rc = cifs_unlock_range(cfile, flock, xid);
>  
