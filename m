From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache
 mode
Date: Mon, 15 Nov 2010 07:34:30 -0500
Message-ID: <20101115073430.2254b19c@tlielax.poochiereds.net>
References: <1289459222-8210-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289459222-8210-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 11 Nov 2010 10:07:02 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On strict cache mode when we close the last file handle of the inode we
> should set invalidate flag on the inode and check it during open to prevent
> data coherency problem when we open it again but it has been modified by
> other clients.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


When I send multiple versions of the same patch, I usually add "(try
#X)" to the subject. That makes it easier for reviewers to tell which
patch is the latest version.

> ---
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.h     |    1 +
>  fs/cifs/file.c       |   27 +++++++++++++++------------
>  fs/cifs/inode.c      |    3 +--
>  4 files changed, 18 insertions(+), 14 deletions(-)
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
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 897b2b2..b8d783c 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -61,6 +61,7 @@ extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
>  		       struct dentry *);
>  extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
> +extern void cifs_invalidate_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>  
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06c3e83..d604e09 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -124,19 +124,11 @@ static inline int cifs_open_inode_helper(struct inode *inode,
>  	temp = cifs_NTtimeToUnix(buf->LastWriteTime);
>  	if (timespec_equal(&inode->i_mtime, &temp) &&
>  			   (inode->i_size ==
> -			    (loff_t)le64_to_cpu(buf->EndOfFile))) {
> +			    (loff_t)le64_to_cpu(buf->EndOfFile)) &&
> +			    !pCifsInode->invalid_mapping) {
>  		cFYI(1, "inode unchanged on server");
> -	} else {
> -		if (inode->i_mapping) {
> -			/* BB no need to lock inode until after invalidate
> -			since namei code should already have it locked? */
> -			rc = filemap_write_and_wait(inode->i_mapping);
> -			mapping_set_error(inode->i_mapping, rc);
> -		}
> -		cFYI(1, "invalidating remote inode since open detected it "
> -			 "changed");
> -		invalidate_remote_inode(inode);
> -	}
> +	} else
> +		cifs_invalidate_mapping(inode);
>  

Not directly related to your patch, but what exactly is the purpose of
the "open_inode_helper"? It looks like "pile o' random junk that we do
for non-posix opens". Maybe it would be best to eliminate that function
altogether and further unify the posix and non-posix open code. Steve,
care to comment?

Now that I'm done ranting, I don't think the invalidate mapping call
here is unnecessary. We will likely have already invalidated the cache
during the d_revalidate phase, and you're going to do it again below in
cifs_new_fileinfo.

>  client_can_cache:
>  	if (pTcon->unix_ext)
> @@ -250,6 +242,9 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
>  
>  	cifs_set_oplock_level(pCifsInode, oplock);
>  
> +	if (pCifsInode->invalid_mapping)
> +		cifs_invalidate_mapping(inode);
> +
>  	file->private_data = pCifsFile;
>  	return pCifsFile;
>  }
> @@ -264,6 +259,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	struct inode *inode = cifs_file->dentry->d_inode;
>  	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
>  	struct cifsInodeInfo *cifsi = CIFS_I(inode);
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct cifsLockInfo *li, *tmp;
>  
>  	spin_lock(&cifs_file_list_lock);
> @@ -279,6 +275,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
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
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ef3a55b..518514e 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1671,8 +1671,7 @@ cifs_inode_needs_reval(struct inode *inode)
>  }
>  
>  /* check invalid_mapping flag and zap the cache if it's set */
> -static void
> -cifs_invalidate_mapping(struct inode *inode)
> +void cifs_invalidate_mapping(struct inode *inode)
>  {
>  	int rc;
>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
