From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a spurious error in cifs_push_posix_locks
Date: Sat, 17 Mar 2012 06:10:06 -0400
Message-ID: <20120317061006.68c0305e@tlielax.poochiereds.net>
References: <1331966815-3124-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331966815-3124-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 17 Mar 2012 09:46:55 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4aa6080..159fcc5 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -960,9 +960,9 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  	INIT_LIST_HEAD(&locks_to_send);
>  
>  	/*
> -	 * Allocating count locks is enough because no locks can be added to
> -	 * the list while we are holding cinode->lock_mutex that protects
> -	 * locking operations of this inode.
> +	 * Allocating count locks is enough because no FL_POSIX locks can be
> +	 * added to the list while we are holding cinode->lock_mutex that
> +	 * protects locking operations of this inode.
>  	 */
>  	for (; i < count; i++) {
>  		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
> @@ -973,18 +973,20 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  		list_add_tail(&lck->llist, &locks_to_send);
>  	}
>  
> -	i = 0;
>  	el = locks_to_send.next;
>  	lock_flocks();
>  	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> +		flock = *before;
> +		if ((flock->fl_flags & FL_POSIX) == 0)
> +			continue;
>  		if (el == &locks_to_send) {

Nit: a clearer way to do this would be to list_del the locks as you use
them, and then check for list_empty(&locks_to_send). This works too,
but is not as self documenting. It's not a big deal though...

> -			/* something is really wrong */
> +			/*
> +			 * The list ended. We don't have enough allocated
> +			 * structures - something is really wrong.
> +			 */
>  			cERROR(1, "Can't push all brlocks!");
>  			break;
>  		}
> -		flock = *before;
> -		if ((flock->fl_flags & FL_POSIX) == 0)
> -			continue;
>  		length = 1 + flock->fl_end - flock->fl_start;
>  		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
>  			type = CIFS_RDLCK;
> @@ -996,7 +998,6 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  		lck->length = length;
>  		lck->type = type;
>  		lck->offset = flock->fl_start;
> -		i++;
>  		el = el->next;
>  	}
>  	unlock_flocks();


Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

...you might also want to add:

Reported-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
