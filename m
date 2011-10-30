From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/3] CIFS: Fix the VFS brlock cache usage in posix
 locking case
Date: Sun, 30 Oct 2011 01:48:35 -0400
Message-ID: <20111030014835.12928ab3@corrin.poochiereds.net>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319894279-7723-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Oct 2011 17:17:57 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Request to the cache in FL_POSIX case only.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 91e05f2..c1f063c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -793,6 +793,9 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
>  	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
>  	unsigned char saved_type = flock->fl_type;
>  
> +	if ((flock->fl_flags & FL_POSIX) == 0)
> +		return 1;
> +
>  	mutex_lock(&cinode->lock_mutex);
>  	posix_test_lock(file, flock);
>  
> @@ -809,12 +812,15 @@ static int
>  cifs_posix_lock_set(struct file *file, struct file_lock *flock)
>  {
>  	struct cifsInodeInfo *cinode = CIFS_I(file->f_path.dentry->d_inode);
> -	int rc;
> +	int rc = 1;
> +
> +	if ((flock->fl_flags & FL_POSIX) == 0)
> +		return rc;
>  
>  	mutex_lock(&cinode->lock_mutex);
>  	if (!cinode->can_cache_brlcks) {
>  		mutex_unlock(&cinode->lock_mutex);
> -		return 1;
> +		return rc;
>  	}
>  	rc = posix_lock_file_wait(file, flock);
>  	mutex_unlock(&cinode->lock_mutex);

Hmm... I do have an open samba.org bug to allow flock() to work on cifs
as well. Would that be doable with your new locking code? In any case,
this seems ok:

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
