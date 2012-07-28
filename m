From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 07/45] CIFS: Protect i_nlink from being negative
Date: Sat, 28 Jul 2012 07:48:08 -0400
Message-ID: <20120728074808.6333c325@tlielax.poochiereds.net>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-8-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-8-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jul 2012 19:48:23 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> that can cause warning messages.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/inode.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 7354877..88afb1a 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1110,6 +1110,15 @@ undo_setattr:
>  	goto out_close;
>  }
>  
> +/* copied from fs/nfs/dir.c with small changes */
> +static void
> +cifs_drop_nlink(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	if (inode->i_nlink > 0)
> +		drop_nlink(inode);
> +	spin_unlock(&inode->i_lock);
> +}
>  

As I mentioned to Steve yesterday, the spinlocking above doesn't really
do you any good. Other updates to i_nlink are not serialized by the
i_lock. It's easily possible for another thread to race in and set
i_nlink to 0 after you check it but before calling drop_nlink.

The above change looks reasonable if you also fix those places to be
done under the i_lock as well. In fact, what might be best is a patch
that fixes the code to do all inode attribute updates under the i_lock.

If a CPU ends up reordering some of the stores, then you could end up
with an inode that represents some attributes from one update and some
from another.

>  /*
>   * If dentry->d_inode is null (usually meaning the cached dentry
> @@ -1166,13 +1175,13 @@ retry_std_delete:
>  psx_del_no_retry:
>  	if (!rc) {
>  		if (inode)
> -			drop_nlink(inode);
> +			cifs_drop_nlink(inode);
>  	} else if (rc == -ENOENT) {
>  		d_drop(dentry);
>  	} else if (rc == -ETXTBSY) {
>  		rc = cifs_rename_pending_delete(full_path, dentry, xid);
>  		if (rc == 0)
> -			drop_nlink(inode);
> +			cifs_drop_nlink(inode);
>  	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
>  		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
>  		if (attrs == NULL) {


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
