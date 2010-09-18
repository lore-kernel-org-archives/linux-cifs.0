From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Invaldate remote inode on the last close
Date: Sat, 18 Sep 2010 07:37:18 -0400
Message-ID: <20100918073718.17c04a83@corrin.poochiereds.net>
References: <AANLkTinQO5yM7uSPFhz3NYrQNAiyWbHcEi_3o4mBMUZy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinQO5yM7uSPFhz3NYrQNAiyWbHcEi_3o4mBMUZy-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 18 Sep 2010 10:37:53 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> When we close the last file handle of the inode we should invalidate it
> to prevent data coherency problem when we open it again but it has been
> modified by other clients.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 60061b9..babe574 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -211,8 +211,14 @@ client_can_cache:
>  		pCifsInode->clientCanCacheAll = true;
>  		pCifsInode->clientCanCacheRead = true;
>  		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
> -	} else if ((oplock & 0xF) == OPLOCK_READ)
> +	} else if ((oplock & 0xF) == OPLOCK_READ) {
> +		pCifsInode->clientCanCacheAll = false;
>  		pCifsInode->clientCanCacheRead = true;
> +		cFYI(1, "Level II Oplock franted on inode %p", inode);
> +	} else {
> +		pCifsInode->clientCanCacheAll = false;
> +		pCifsInode->clientCanCacheRead = false;
> +	}
> 
>  	return rc;
>  }
> @@ -633,6 +639,7 @@ int cifs_close(struct inode *inode, struct file *file)
>  		   on this inode, much less write behind and read ahead */
>  		CIFS_I(inode)->clientCanCacheRead = false;
>  		CIFS_I(inode)->clientCanCacheAll  = false;
> +		invalidate_remote_inode(inode);
>  	}
>  	read_unlock(&GlobalSMBSeslock);
>  	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)

This doesn't look complete. cifs_open_inode_helper will not get called
in the POSIX open case. It would also be good to accompany this change
with a cleanup patch that definitively sets the clientCanCache flags in
single place (or places). Right now, it gets set in both the
*open_inode_helper routines and in cifs_new_fileinfo. One of those
places should be eliminated.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
