From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Do not kmalloc under the flocks spinlock
Date: Wed, 22 Feb 2012 07:34:46 -0500
Message-ID: <20120222073446.1fbdddac@tlielax.poochiereds.net>
References: <1329901855-11683-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329901855-11683-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Feb 2012 12:10:55 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Reorganize the code to make the memory already allocated before
> spinlock'ed loop.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   49 ++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b5e38b1..aa2581e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -926,10 +926,10 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	struct file_lock *flock, **before;
> -	struct cifsLockInfo *lck, *tmp;
> +	struct cifsLockInfo *lcks, *lck;
> +	unsigned int count = 0, i = 0;
>  	int rc = 0, xid, type;
>  	__u64 length;
> -	struct list_head locks_to_send;
>  
>  	xid = GetXid();
>  
> @@ -940,7 +940,19 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  		return rc;
>  	}
>  
> -	INIT_LIST_HEAD(&locks_to_send);
> +	lock_flocks();
> +	cifs_for_each_lock(cfile->dentry->d_inode, before)
> +		count++;
> +	unlock_flocks();
> +
> +	/*
> +	 * We can safely allocate count locks, because the hold lock_mutex.
> +	 * Allocate (count + 1) * 2 locks to be more safe.
> +	 */
> +	count = (count + 1) * 2;
> +	lcks = kmalloc(count * sizeof(struct cifsLockInfo), GFP_KERNEL);
> +	if (!lcks)
> +		goto out;
>  

Hmm...looking at my machine:

(gdb) p sizeof(struct cifsLockInfo)
$1 = 144

So that's 144 bytes per struct...what's the upper limit on "count"?

It seems like that could potentially be a large allocation, and we have
to do this in the oplock break codepath.

Instead of doing this, would it be better to allocate these when
the VFS first calls ->lock, and attach them to a new member of
file_lock.fl_u? 

>  	lock_flocks();
>  	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> @@ -950,35 +962,38 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  			type = CIFS_RDLCK;
>  		else
>  			type = CIFS_WRLCK;
> -
> -		lck = cifs_lock_init(flock->fl_start, length, type,
> -				     cfile->netfid);
> -		if (!lck) {
> -			rc = -ENOMEM;
> -			goto send_locks;
> -		}
> +		lck = &lcks[i];
>  		lck->pid = flock->fl_pid;
> -
> -		list_add_tail(&lck->llist, &locks_to_send);
> +		lck->netfid = cfile->netfid;
> +		lck->length = length;
> +		lck->type = type;
> +		lck->offset = flock->fl_start;
> +		i++;
> +		if (i == count)
> +			break;
>  	}
> -
> -send_locks:
>  	unlock_flocks();
>  
> -	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
> +	if (i == count)
> +		cERROR(1, "Can't push all brlocks!");
> +

This sort of thing always makes me a little worried. Sure, you're
allocating a bunch of extra locks, but what's the potential effect
of not being able to push all the locks here? The user is going to
see this message and have no clue of what it means.

Even I'm not sure what this means in practice. The VFS will have a
record of this lock, but the server won't...

> +	count = i;
> +
> +	for (i = 0; i < count; i++) {
>  		struct file_lock tmp_lock;
>  		int stored_rc;
>  
> +		lck = &lcks[i];
>  		tmp_lock.fl_start = lck->offset;
>  		stored_rc = CIFSSMBPosixLock(xid, tcon, lck->netfid, lck->pid,
>  					     0, lck->length, &tmp_lock,
>  					     lck->type, 0);
>  		if (stored_rc)
>  			rc = stored_rc;
> -		list_del(&lck->llist);
> -		kfree(lck);
>  	}
>  
> +	kfree(lcks);
> +out:
>  	cinode->can_cache_brlcks = false;
>  	mutex_unlock(&cinode->lock_mutex);
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
