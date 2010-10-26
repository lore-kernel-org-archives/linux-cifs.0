From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] CIFS: Invalidate inode pages on the last close
Date: Tue, 26 Oct 2010 10:25:18 -0400
Message-ID: <20101026102518.5d6bea89@tlielax.poochiereds.net>
References: <AANLkTimEwyZkxat-yq8pg3-MCVsnURowe-di2D2YBZhR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimEwyZkxat-yq8pg3-MCVsnURowe-di2D2YBZhR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 26 Oct 2010 17:01:26 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> When we close the last file handle of the inode we should invalidate it
> to prevent data coherency problem when we open it again but it has been
> modified by other clients.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d7c212a..02a045e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -150,8 +150,14 @@ client_can_cache:
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

The oplock handling in cifs is rather ad-hoc. There's a lot of
cut-and-pasted code that sets that clientCanCache flags. The flags
themselves are also sort of hard to understand -- i.e. why is is "All"
and not "Write"?

This would be good opportunity to consolidate that code into helper
functions and just call them from the appropriate places.

Perhaps a helper function that takes an oplock value and sets the
clientCanCache flags appropriately? Or...maybe consider doing away with
the canCache flags and just store the oplock value in the inode and
have helper macros or something that read that value and tell you what
can be done with it.

   i.e.: CLIENT_CAN_CACHE_READ(inode), CLIENT_CAN_CACHE_WRITE(inode)



>  	return rc;
>  }
> @@ -271,8 +277,10 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
>   */
>  void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  {
> +	struct inode *inode = cifs_file->dentry->d_inode;
>  	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
> -	struct cifsInodeInfo *cifsi = CIFS_I(cifs_file->dentry->d_inode);
> +	struct cifsInodeInfo *cifsi = CIFS_I(inode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifsLockInfo *li, *tmp;
> 
>  	spin_lock(&cifs_file_list_lock);
> @@ -290,6 +298,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  			cifs_file->dentry->d_inode);
>  		cifsi->clientCanCacheRead = false;
>  		cifsi->clientCanCacheAll  = false;
> +		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> +			invalidate_remote_inode(inode);
				^^^^^^^^
		I don't think it's safe to call this under a spinlock.
		It would probably be better instead to flag the inode
		as needing invalidation by setting the
		invalidate_mapping flag to true.

>  	}
>  	spin_unlock(&cifs_file_list_lock);
> 

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
