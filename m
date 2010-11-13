From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache
 mode
Date: Sat, 13 Nov 2010 07:07:35 -0500
Message-ID: <20101113070735.060ac5ca@tlielax.poochiereds.net>
References: <1289403711-12965-1-git-send-email-piastryyy@gmail.com>
	<1289403711-12965-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289403711-12965-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 10 Nov 2010 18:41:46 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On strict cache mode when we close the last file handle of the inode we
> should set invalidate flag on the inode and check it during open to prevent
> data coherency problem when we open it again but it has been modified by
> other clients.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/file.c       |   14 ++++++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index e9a393c..be7b159 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -40,6 +40,7 @@
>  #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
>  #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
>  #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
> +#define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
>  
>  struct cifs_sb_info {
>  	struct rb_root tlink_tree;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06c3e83..88bb366 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -148,6 +148,9 @@ client_can_cache:
>  
>  	cifs_set_oplock_level(pCifsInode, oplock);
>  
> +	if (pCifsInode->invalid_mapping)
> +		invalidate_remote_inode(inode);
> +
>  	return rc;
>  }
>  
> @@ -250,6 +253,9 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
>  
>  	cifs_set_oplock_level(pCifsInode, oplock);
>  
> +	if (pCifsInode->invalid_mapping)
> +		invalidate_remote_inode(inode);
> +
>  	file->private_data = pCifsFile;
>  	return pCifsFile;
>  }

I don't see why the above is necessary. cifs_revalidate_dentry should
have taken care of invalidating the mapping when it revalidated the
dentry.

Also, you're leaving invalid_mapping set so you're almost certainly
going to end up invalidating the mapping unnecessarily again.

Finally, you're not considering the fscache case here. I think you need
to look closely at how dentry/inode revalidation is handled -- in
particular cifs_revalidate_dentry and cifs_invalidate_mapping.

> @@ -264,6 +270,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	struct inode *inode = cifs_file->dentry->d_inode;
>  	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
>  	struct cifsInodeInfo *cifsi = CIFS_I(inode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifsLockInfo *li, *tmp;
>  
>  	spin_lock(&cifs_file_list_lock);
> @@ -279,6 +286,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	if (list_empty(&cifsi->openFileList)) {
>  		cFYI(1, "closing last open instance for inode %p",
>  			cifs_file->dentry->d_inode);
> +
> +		/* in strict cache mode we need invalidate mapping on the last
> +		   close  because it may cause a error when we open this file
> +		   again and get at least level II oplock */
> +		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> +			CIFS_I(inode)->invalid_mapping = true;
> +
>  		cifs_set_oplock_level(cifsi, 0);
>  	}
>  	spin_unlock(&cifs_file_list_lock);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
