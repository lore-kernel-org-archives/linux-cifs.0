From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Don't let read only caching for mandatory
 byte-range locked files
Date: Tue, 1 Jan 2013 06:18:25 -0500
Message-ID: <20130101061825.0d1f00ae@tlielax.poochiereds.net>
References: <1356537234-11507-1-git-send-email-piastry@etersoft.ru>
	<1356537234-11507-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356537234-11507-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 26 Dec 2012 19:53:54 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> If we have mandatory byte-range locks on a file we can't cache reads
> because pagereading may have conflicts with these locks on the server.
> That's why we should allow level2 oplocks for files without mandatory
> locks only.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  1 +
>  fs/cifs/file.c     | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/cifs/smb1ops.c  |  1 +
>  fs/cifs/smb2ops.c  |  3 +++
>  4 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index dfab450..e6899ce 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -386,6 +386,7 @@ struct smb_version_values {
>  	unsigned int	cap_unix;
>  	unsigned int	cap_nt_find;
>  	unsigned int	cap_large_files;
> +	unsigned int	oplock_read;
>  };
>  
>  #define HEADER_SIZE(server) (server->vals->header_size)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 22c3725..8ea6ca5 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -238,6 +238,23 @@ out:
>  	return rc;
>  }
>  
> +static bool
> +cifs_has_mand_locks(struct cifsInodeInfo *cinode)
> +{
> +	struct cifs_fid_locks *cur;
> +	bool has_locks = false;
> +
> +	down_read(&cinode->lock_sem);
> +	list_for_each_entry(cur, &cinode->llist, llist) {
> +		if (!list_empty(&cur->locks)) {
> +			has_locks = true;
> +			break;
> +		}
> +	}
> +	up_read(&cinode->lock_sem);
> +	return has_locks;
> +}
> +
>  struct cifsFileInfo *
>  cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>  		  struct tcon_link *tlink, __u32 oplock)
> @@ -248,6 +265,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>  	struct cifsFileInfo *cfile;
>  	struct cifs_fid_locks *fdlocks;
>  	struct cifs_tcon *tcon = tlink_tcon(tlink);
> +	struct TCP_Server_Info *server = tcon->ses->server;
>  
>  	cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
>  	if (cfile == NULL)
> @@ -276,12 +294,22 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>  	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
>  	mutex_init(&cfile->fh_mutex);
>  
> +	/*
> +	 * If the server returned a read oplock and we have mandatory brlocks,
> +	 * set oplock level to None.
> +	 */
> +	if (oplock == server->vals->oplock_read &&
> +						cifs_has_mand_locks(cinode)) {
> +		cFYI(1, "Reset oplock val from read to None due to mand locks");
> +		oplock = 0;
> +	}
> +
>  	spin_lock(&cifs_file_list_lock);
> -	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE)
> +	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
>  		oplock = fid->pending_open->oplock;
>  	list_del(&fid->pending_open->olist);
>  
> -	tlink_tcon(tlink)->ses->server->ops->set_fid(cfile, fid, oplock);
> +	server->ops->set_fid(cfile, fid, oplock);
>  
>  	list_add(&cfile->tlist, &tcon->openFileList);
>  	/* if readable file instance put first in list*/
> @@ -1422,6 +1450,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	struct TCP_Server_Info *server = tcon->ses->server;
> +	struct inode *inode = cfile->dentry->d_inode;
>  
>  	if (posix_lck) {
>  		int posix_lock_type;
> @@ -1459,6 +1488,21 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>  		if (!rc)
>  			goto out;
>  
> +		/*
> +		 * Windows 7 server can delay breaking lease from read to None
> +		 * if we set a byte-range lock on a file - break it explicitly
> +		 * before sending the lock to the server to be sure the next
> +		 * read won't conflict with non-overlapted locks due to
> +		 * pagereading.
> +		 */
> +		if (!CIFS_I(inode)->clientCanCacheAll &&
> +					CIFS_I(inode)->clientCanCacheRead) {
> +			cifs_invalidate_mapping(inode);
> +			cFYI(1, "Set no oplock for inode=%p due to mand locks",
> +			     inode);
> +			CIFS_I(inode)->clientCanCacheRead = false;
> +		}
> +
>  		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
>  					    type, 1, 0, wait_flag);
>  		if (rc) {
> @@ -3537,6 +3581,13 @@ void cifs_oplock_break(struct work_struct *work)
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	int rc = 0;
>  
> +	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead &&
> +						cifs_has_mand_locks(cinode)) {
> +		cFYI(1, "Reset oplock to None for inode=%p due to mand locks",
> +		     inode);
> +		cinode->clientCanCacheRead = false;
> +	}
> +
>  	if (inode && S_ISREG(inode->i_mode)) {
>  		if (cinode->clientCanCacheRead)
>  			break_lease(inode, O_RDONLY);
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index a5d234c..a1de86c 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -952,4 +952,5 @@ struct smb_version_values smb1_values = {
>  	.cap_unix = CAP_UNIX,
>  	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
>  	.cap_large_files = CAP_LARGE_FILES,
> +	.oplock_read = OPLOCK_READ,
>  };
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d79de7b..bceffe7 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -708,6 +708,7 @@ struct smb_version_values smb20_values = {
>  	.cap_unix = 0,
>  	.cap_nt_find = SMB2_NT_FIND,
>  	.cap_large_files = SMB2_LARGE_FILES,
> +	.oplock_read = SMB2_OPLOCK_LEVEL_II,
>  };
>  
>  struct smb_version_values smb21_values = {
> @@ -725,6 +726,7 @@ struct smb_version_values smb21_values = {
>  	.cap_unix = 0,
>  	.cap_nt_find = SMB2_NT_FIND,
>  	.cap_large_files = SMB2_LARGE_FILES,
> +	.oplock_read = SMB2_OPLOCK_LEVEL_II,
>  };
>  
>  struct smb_version_values smb30_values = {
> @@ -742,4 +744,5 @@ struct smb_version_values smb30_values = {
>  	.cap_unix = 0,
>  	.cap_nt_find = SMB2_NT_FIND,
>  	.cap_large_files = SMB2_LARGE_FILES,
> +	.oplock_read = SMB2_OPLOCK_LEVEL_II,
>  };

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
