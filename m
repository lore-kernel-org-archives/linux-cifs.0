From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.11+ Problem with cifs links, bisected
Date: Tue, 29 Oct 2013 10:11:34 -0400
Message-ID: <20131029101134.12ddea20@tlielax.poochiereds.net>
References: <CAKywueRsvO7mpJ1B6wUJgEGceQ-7wWyk7wtLZQKbTnx3yWns=Q@mail.gmail.com>
	<1382539375-9871-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382539375-9871-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Oct 2013 18:42:54 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> I created a slightly tested patch below but can't test with deduplicated files now.
> 
> Joao, can you check if it fixes your problem, please?
> 
> --------------------------------------------------------------------------
> 
> Distinguish reparse point types into two groups:
> 1) that can be accessed directly through a reparse point
> (junctions, deduplicated files, NFS symlinks);
> 2) that need to be processed manually (Windows symbolic links, DFS).
> 
> In this case we map only Windows symbolic links to Unix ones.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    2 +-
>  fs/cifs/inode.c     |   23 +++++++++++++----------
>  fs/cifs/readdir.c   |   40 ++++++++--------------------------------
>  fs/cifs/smb1ops.c   |   27 ++++++++++++++++++++++-----
>  fs/cifs/smb2inode.c |   15 +++++++++++----
>  fs/cifs/smb2proto.h |    2 +-
>  6 files changed, 56 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a67cf12..b688f2b 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -261,7 +261,7 @@ struct smb_version_operations {
>  	/* query path data from the server */
>  	int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>  			       struct cifs_sb_info *, const char *,
> -			       FILE_ALL_INFO *, bool *);
> +			       FILE_ALL_INFO *, bool *, bool *);
>  	/* query file data from the server */
>  	int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>  			       struct cifs_fid *, FILE_ALL_INFO *);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 867b7cd..36f9ebb 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -542,7 +542,8 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
>  /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
>  static void
>  cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
> -		       struct cifs_sb_info *cifs_sb, bool adjust_tz)
> +		       struct cifs_sb_info *cifs_sb, bool adjust_tz,
> +		       bool symlink)
>  {
>  	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>  
> @@ -569,7 +570,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
>  
>  	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> -	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
> +
> +	if (symlink) {
> +		fattr->cf_mode = S_IFLNK;
> +		fattr->cf_dtype = DT_LNK;
> +	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>  		fattr->cf_dtype = DT_DIR;
>  		/*
> @@ -578,10 +583,6 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  		 */
>  		if (!tcon->unix_ext)
>  			fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
> -	} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
> -		fattr->cf_mode = S_IFLNK;
> -		fattr->cf_dtype = DT_LNK;
> -		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
>  	} else {
>  		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
>  		fattr->cf_dtype = DT_REG;
> @@ -626,7 +627,8 @@ cifs_get_file_info(struct file *filp)
>  	rc = server->ops->query_file_info(xid, tcon, &cfile->fid, &find_data);
>  	switch (rc) {
>  	case 0:
> -		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
> +		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false,
> +				       false);
>  		break;
>  	case -EREMOTE:
>  		cifs_create_dfs_fattr(&fattr, inode->i_sb);
> @@ -673,6 +675,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  	bool adjust_tz = false;
>  	struct cifs_fattr fattr;
>  	struct cifs_search_info *srchinf = NULL;
> +	bool symlink = false;
>  
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink))
> @@ -702,12 +705,12 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>  		}
>  		data = (FILE_ALL_INFO *)buf;
>  		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path,
> -						  data, &adjust_tz);
> +						  data, &adjust_tz, &symlink);
>  	}
>  
>  	if (!rc) {
> -		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *)data, cifs_sb,
> -				       adjust_tz);
> +		cifs_all_info_to_fattr(&fattr, data, cifs_sb, adjust_tz,
> +				       symlink);
>  	} else if (rc == -EREMOTE) {
>  		cifs_create_dfs_fattr(&fattr, sb);
>  		rc = 0;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 53a75f3..5940eca 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -134,22 +134,6 @@ out:
>  	dput(dentry);
>  }
>  
> -/*
> - * Is it possible that this directory might turn out to be a DFS referral
> - * once we go to try and use it?
> - */
> -static bool
> -cifs_dfs_is_possible(struct cifs_sb_info *cifs_sb)
> -{
> -#ifdef CONFIG_CIFS_DFS_UPCALL
> -	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> -
> -	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
> -		return true;
> -#endif
> -	return false;
> -}
> -
>  static void
>  cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  {
> @@ -159,27 +143,19 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>  		fattr->cf_dtype = DT_DIR;
> -		/*
> -		 * Windows CIFS servers generally make DFS referrals look
> -		 * like directories in FIND_* responses with the reparse
> -		 * attribute flag also set (since DFS junctions are
> -		 * reparse points). We must revalidate at least these
> -		 * directory inodes before trying to use them (if
> -		 * they are DFS we will get PATH_NOT_COVERED back
> -		 * when queried directly and can then try to connect
> -		 * to the DFS target)
> -		 */
> -		if (cifs_dfs_is_possible(cifs_sb) &&
> -		    (fattr->cf_cifsattrs & ATTR_REPARSE))
> -			fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
> -	} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
> -		fattr->cf_mode = S_IFLNK;
> -		fattr->cf_dtype = DT_LNK;
>  	} else {
>  		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
>  		fattr->cf_dtype = DT_REG;
>  	}
>  
> +	/*
> +	 * We need to revalidate it further to make a decision about whether it
> +	 * is a symbolic link, DFS referral or a reparse point with a direct
> +	 * access like junctions, deduplicated files, NFS symlinks.
> +	 */
> +	if (fattr->cf_cifsattrs & ATTR_REPARSE)
> +		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
> +
>  	/* non-unix readdir doesn't provide nlink */
>  	fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
>  
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index ea99efe..3bb41cf 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -534,26 +534,43 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
>  static int
>  cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  		     struct cifs_sb_info *cifs_sb, const char *full_path,
> -		     FILE_ALL_INFO *data, bool *adjustTZ)
> +		     FILE_ALL_INFO *data, bool *adjustTZ, bool *symlink)
>  {
>  	int rc;
> +	int oplock = 0;
> +	__u16 netfid;
> +
> +	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN, FILE_READ_ATTRIBUTES,
> +			 0, &netfid, &oplock, NULL, cifs_sb->local_nls,
> +			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (rc == -EOPNOTSUPP) {
> +		*symlink = true;
> +		/* Failed on a symbolic link - query a reparse point info */
> +		rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
> +				 FILE_READ_ATTRIBUTES, OPEN_REPARSE_POINT,
> +				 &netfid, &oplock, NULL, cifs_sb->local_nls,
> +			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	}
> +
> +	if (!rc) {
> +		rc = CIFSSMBQFileInfo(xid, tcon, netfid, data);
> +		CIFSSMBClose(xid, tcon, netfid);
> +	}

Blech...

So basically for any normal, non-symlink file you'll end up breaking
any oplocks that might be held just by stat()'ing it? I sincerely hope
there's a better way to solve this problem...

>  
> -	/* could do find first instead but this returns more info */
> -	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
> -			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	/*
>  	 * BB optimize code so we do not make the above call when server claims
>  	 * no NT SMB support and the above call failed at least once - set flag
>  	 * in tcon or mount.
>  	 */
>  	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
> +		*symlink = false;
>  		rc = SMBQueryInformation(xid, tcon, full_path, data,
>  					 cifs_sb->local_nls,
>  					 cifs_sb->mnt_cifs_flags &
>  						CIFS_MOUNT_MAP_SPECIAL_CHR);
>  		*adjustTZ = true;
>  	}
> +
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 78ff88c..58283dd 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -123,7 +123,7 @@ move_smb2_info_to_cifs(FILE_ALL_INFO *dst, struct smb2_file_all_info *src)
>  int
>  smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  		     struct cifs_sb_info *cifs_sb, const char *full_path,
> -		     FILE_ALL_INFO *data, bool *adjust_tz)
> +		     FILE_ALL_INFO *data, bool *adjust_tz, bool *symlink)
>  {
>  	int rc;
>  	struct smb2_file_all_info *smb2_data;
> @@ -136,9 +136,16 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  		return -ENOMEM;
>  
>  	rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
> -				FILE_READ_ATTRIBUTES, FILE_OPEN,
> -				OPEN_REPARSE_POINT, smb2_data,
> -				SMB2_OP_QUERY_INFO);
> +				FILE_READ_ATTRIBUTES, FILE_OPEN, 0,
> +				smb2_data, SMB2_OP_QUERY_INFO);
> +	if (rc == -EOPNOTSUPP) {
> +		*symlink = true;
> +		/* Failed on a symbolic link - query a reparse point info */
> +		rc = smb2_open_op_close(xid, tcon, cifs_sb, full_path,
> +					FILE_READ_ATTRIBUTES, FILE_OPEN,
> +					OPEN_REPARSE_POINT, smb2_data,
> +					SMB2_OP_QUERY_INFO);
> +	}
>  	if (rc)
>  		goto out;
>  
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 313813e..b4eea10 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -61,7 +61,7 @@ extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
>  extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>  				struct cifs_sb_info *cifs_sb,
>  				const char *full_path, FILE_ALL_INFO *data,
> -				bool *adjust_tz);
> +				bool *adjust_tz, bool *symlink);
>  extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
>  			      const char *full_path, __u64 size,
>  			      struct cifs_sb_info *cifs_sb, bool set_alloc);


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
