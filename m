From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add descriptions to the brlock cache functions
Date: Mon, 7 Nov 2011 08:01:53 -0500
Message-ID: <20111107080153.56682005@tlielax.poochiereds.net>
References: <1320671484-6222-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320671484-6222-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  7 Nov 2011 16:11:24 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index cf0b153..4dd9283 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -702,6 +702,13 @@ cifs_find_lock_conflict(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
>  					 lock->type, lock->netfid, conf_lock);
>  }
>  
> +/*
> + * Check if there is another lock that prevents us to set the lock (mandatory
> + * style). If such a lock exists, update the flock structure with its
> + * properties. Otherwise, set the flock type to F_UNLCK if we can cache brlocks
> + * or leave it the same if we can't. Returns 0 if we don't need to request to
> + * the server or 1 otherwise.
> + */
>  static int
>  cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 length,
>  	       __u8 type, __u16 netfid, struct file_lock *flock)
> @@ -739,6 +746,12 @@ cifs_lock_add(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock)
>  	mutex_unlock(&cinode->lock_mutex);
>  }
>  
> +/*
> + * Set the byte-range lock (mandatory style). Returns:
> + * 1) 0, if we set the lock and don't need to request to the server;
> + * 2) 1, if no locks prevent us but we need to request to the server;
> + * 3) -EACCESS, if there is a lock that prevents us and wait is false.
> + */
>  static int
>  cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo *lock,
>  		 bool wait)
> @@ -778,6 +791,13 @@ try_again:
>  	return rc;
>  }
>  
> +/*
> + * Check if there is another lock that prevents us to set the lock (posix
> + * style). If such a lock exists, update the flock structure with its
> + * properties. Otherwise, set the flock type to F_UNLCK if we can cache brlocks
> + * or leave it the same if we can't. Returns 0 if we don't need to request to
> + * the server or 1 otherwise.
> + */
>  static int
>  cifs_posix_lock_test(struct file *file, struct file_lock *flock)
>  {
> @@ -800,6 +820,12 @@ cifs_posix_lock_test(struct file *file, struct file_lock *flock)
>  	return rc;
>  }
>  
> +/*
> + * Set the byte-range lock (posix style). Returns:
> + * 1) 0, if we set the lock and don't need to request to the server;
> + * 2) 1, if we need to request to the server;
> + * 3) <0, if the error occurs while setting the lock.
> + */
>  static int
>  cifs_posix_lock_set(struct file *file, struct file_lock *flock)
>  {

Thanks for doing that.

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
