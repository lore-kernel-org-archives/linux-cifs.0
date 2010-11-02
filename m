From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Add cifs_set_oplock_level
Date: Tue, 2 Nov 2010 11:25:10 -0400
Message-ID: <20101102112510.0c30a82b@tlielax.poochiereds.net>
References: <AANLkTin1ZFcZoC3A4iRrWaFpHghdG2hkbyEopQnJpA2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin1ZFcZoC3A4iRrWaFpHghdG2hkbyEopQnJpA2f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2 Nov 2010 12:00:42 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Simplify many places when we need to set oplock level on an inode.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |    1 +
>  fs/cifs/file.c      |   38 +++++++++-----------------------------
>  fs/cifs/misc.c      |   23 ++++++++++++++++++++---
>  3 files changed, 30 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index edb6d90..7f050f4 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -104,6 +104,7 @@ extern struct timespec cifs_NTtimeToUnix(__le64
> utc_nanoseconds_since_1601);
>  extern u64 cifs_UnixTimeToNT(struct timespec);
>  extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
>  				      int offset);
> +extern void cifs_set_oplock_level(struct inode *inode, __u32 oplock);
> 
>  extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
>  				struct file *file, struct tcon_link *tlink,
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5d06eb3..a566f15 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -146,12 +146,7 @@ client_can_cache:
>  		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
>  					 xid, NULL);
> 
> -	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
> -		pCifsInode->clientCanCacheAll = true;
> -		pCifsInode->clientCanCacheRead = true;
> -		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
> -	} else if ((oplock & 0xF) == OPLOCK_READ)
> -		pCifsInode->clientCanCacheRead = true;
> +	cifs_set_oplock_level(inode, oplock);
> 
>  	return rc;
>  }
> @@ -253,12 +248,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
>  		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
>  	spin_unlock(&cifs_file_list_lock);
> 
> -	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
> -		pCifsInode->clientCanCacheAll = true;
> -		pCifsInode->clientCanCacheRead = true;
> -		cFYI(1, "Exclusive Oplock inode %p", inode);
> -	} else if ((oplock & 0xF) == OPLOCK_READ)
> -		pCifsInode->clientCanCacheRead = true;
> +	cifs_set_oplock_level(inode, oplock);
> 
>  	file->private_data = pCifsFile;
>  	return pCifsFile;
> @@ -271,8 +261,10 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
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
> @@ -288,8 +280,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	if (list_empty(&cifsi->openFileList)) {
>  		cFYI(1, "closing last open instance for inode %p",
>  			cifs_file->dentry->d_inode);
> -		cifsi->clientCanCacheRead = false;
> -		cifsi->clientCanCacheAll  = false;
> +		cifs_set_oplock_level(inode, 0);
>  	}
>  	spin_unlock(&cifs_file_list_lock);
> 
> @@ -607,8 +598,6 @@ reopen_success:
>  		rc = filemap_write_and_wait(inode->i_mapping);
>  		mapping_set_error(inode->i_mapping, rc);
> 
> -		pCifsInode->clientCanCacheAll = false;
> -		pCifsInode->clientCanCacheRead = false;
>  		if (tcon->unix_ext)
>  			rc = cifs_get_inode_info_unix(&inode,
>  				full_path, inode->i_sb, xid);
> @@ -622,18 +611,9 @@ reopen_success:
>  	     invalidate the current end of file on the server
>  	     we can not go to the server to get the new inod
>  	     info */
> -	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
> -		pCifsInode->clientCanCacheAll = true;
> -		pCifsInode->clientCanCacheRead = true;
> -		cFYI(1, "Exclusive Oplock granted on inode %p",
> -			 pCifsFile->dentry->d_inode);
> -	} else if ((oplock & 0xF) == OPLOCK_READ) {
> -		pCifsInode->clientCanCacheRead = true;
> -		pCifsInode->clientCanCacheAll = false;
> -	} else {
> -		pCifsInode->clientCanCacheRead = false;
> -		pCifsInode->clientCanCacheAll = false;
> -	}
> +
> +	cifs_set_oplock_level(inode, oplock);
> +
>  	cifs_relock_file(pCifsFile);
> 
>  reopen_error_exit:
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index c4e296f..d3b9dde 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -569,10 +569,9 @@ is_valid_oplock_break(struct smb_hdr *buf, struct
> TCP_Server_Info *srv)
> 
>  				cFYI(1, "file id match, oplock break");
>  				pCifsInode = CIFS_I(netfile->dentry->d_inode);
> -				pCifsInode->clientCanCacheAll = false;
> -				if (pSMB->OplockLevel == 0)
> -					pCifsInode->clientCanCacheRead = false;
> 
> +				cifs_set_oplock_level(netfile->dentry->d_inode,
> +						      pSMB->OplockLevel);
>  				/*
>  				 * cifs_oplock_break_put() can't be called
>  				 * from here.  Get reference after queueing
> @@ -722,3 +721,21 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
>  			   cifs_sb_master_tcon(cifs_sb)->treeName);
>  	}
>  }
> +
> +void cifs_set_oplock_level(struct inode *inode, __u32 oplock)
> +{
> +	struct cifsInodeInfo *cinode = CIFS_I(inode);
> +
> +	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
		^^^^^^^^^
		nit: might be better to just do the & once. But that
		can be fixed later.

> +		cinode->clientCanCacheAll = true;
> +		cinode->clientCanCacheRead = true;
> +		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
> +	} else if ((oplock & 0xF) == OPLOCK_READ) {
> +		cinode->clientCanCacheAll = false;
> +		cinode->clientCanCacheRead = true;
> +		cFYI(1, "Level II Oplock granted on inode %p", inode);
> +	} else {
> +		cinode->clientCanCacheAll = false;
> +		cinode->clientCanCacheRead = false;
> +	}
> +}

Looks good to me. Nice cleanup:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
