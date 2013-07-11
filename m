From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a deadlock when a file is reopened
Date: Thu, 11 Jul 2013 11:02:18 -0400
Message-ID: <20130711110218.1a6ef244@tlielax.poochiereds.net>
References: <CAKywueQXGN+W6eMyZ-eQD+pCpgRz86Dpxht+YiMVKAGXVebPFg@mail.gmail.com>
	<1373547244-5048-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373547244-5048-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 11 Jul 2013 16:54:04 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> If we request reading or writing on a file that needs to be
> reopened, it causes the deadlock: we are already holding rw
> semaphore for reading and then we try to acquire it for writing
> in cifs_relock_file. Fix this by acquiring the semaphore for
> reading in cifs_relock_file due to we don't make any changes in
> locks and don't need a write access.
> 
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b149ae4..be24f09 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -561,11 +561,10 @@ cifs_relock_file(struct cifsFileInfo *cfile)
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	int rc = 0;
>  
> -	/* we are going to update can_cache_brlcks here - need a write access */
> -	down_write(&cinode->lock_sem);
> +	down_read(&cinode->lock_sem);
>  	if (cinode->can_cache_brlcks) {
> -		/* can cache locks - no need to push them */
> -		up_write(&cinode->lock_sem);
> +		/* can cache locks - no need to relock */
> +		up_read(&cinode->lock_sem);
>  		return rc;
>  	}
>  
> @@ -576,7 +575,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
>  	else
>  		rc = tcon->ses->server->ops->push_mand_locks(cfile);
>  
> -	up_write(&cinode->lock_sem);
> +	up_read(&cinode->lock_sem);
>  	return rc;
>  }
>  

Ok, I think this will work, but I'm a little leery of recursively
taking the same semaphore twice for read. This really could use a
rethink as getting this locking wrong is a great source of subtle bugs.

Maybe you could consider using RCU instead?

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
