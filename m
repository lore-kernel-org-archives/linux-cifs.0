From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/24] CIFS: Rename Get/FreeXid and make them work
 with unsigned int
Date: Wed, 20 Jun 2012 17:58:25 -0700
Message-ID: <20120620175825.164f48e8@corrin.poochiereds.net>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Jun 2012 18:30:41 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifs_dfs_ref.c |    7 +-
>  fs/cifs/cifsacl.c      |   21 ++++---
>  fs/cifs/cifsfs.c       |    6 +-
>  fs/cifs/cifsproto.h    |  169 +++++++++++++++++++++++++-----------------------
>  fs/cifs/cifssmb.c      |  146 ++++++++++++++++++++++--------------------
>  fs/cifs/connect.c      |   40 ++++++------
>  fs/cifs/dir.c          |   24 ++++----
>  fs/cifs/file.c         |  133 +++++++++++++++++++------------------
>  fs/cifs/inode.c        |   87 +++++++++++++------------
>  fs/cifs/ioctl.c        |    6 +-
>  fs/cifs/link.c         |   24 ++++----
>  fs/cifs/misc.c         |    4 +-
>  fs/cifs/readdir.c      |   15 ++--
>  fs/cifs/xattr.c        |   24 ++++----
>  14 files changed, 365 insertions(+), 341 deletions(-)
> 
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 6873bb6..ce5cbd7 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -275,7 +275,8 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_ses *ses;
>  	char *full_path;
> -	int xid, i;
> +	unsigned int xid;
> +	int i;
>  	int rc;
>  	struct vfsmount *mnt;
>  	struct tcon_link *tlink;
> @@ -302,11 +303,11 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
>  	}
>  	ses = tlink_tcon(tlink)->ses;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
>  		&num_referrals, &referrals,
>  		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> -	FreeXid(xid);
> +	free_xid(xid);
>  
>  	cifs_put_tlink(tlink);
>  
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 3cc1b25..f8c8464 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1153,15 +1153,16 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>  		__u16 fid, u32 *pacllen)
>  {
>  	struct cifs_ntsd *pntsd = NULL;
> -	int xid, rc;
> +	unsigned int xid;
> +	int rc;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
>  
>  	if (IS_ERR(tlink))
>  		return ERR_CAST(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pntsd, pacllen);
> -	FreeXid(xid);
> +	free_xid(xid);
>  
>  	cifs_put_tlink(tlink);
>  
> @@ -1176,7 +1177,8 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  {
>  	struct cifs_ntsd *pntsd = NULL;
>  	int oplock = 0;
> -	int xid, rc, create_options = 0;
> +	unsigned int xid;
> +	int rc, create_options = 0;
>  	__u16 fid;
>  	struct cifs_tcon *tcon;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> @@ -1185,7 +1187,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  		return ERR_CAST(tlink);
>  
>  	tcon = tlink_tcon(tlink);
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (backup_cred(cifs_sb))
>  		create_options |= CREATE_OPEN_BACKUP_INTENT;
> @@ -1199,7 +1201,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  	}
>  
>  	cifs_put_tlink(tlink);
> -	FreeXid(xid);
> +	free_xid(xid);
>  
>  	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
>  	if (rc)
> @@ -1230,7 +1232,8 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>  			struct inode *inode, const char *path, int aclflag)
>  {
>  	int oplock = 0;
> -	int xid, rc, access_flags, create_options = 0;
> +	unsigned int xid;
> +	int rc, access_flags, create_options = 0;
>  	__u16 fid;
>  	struct cifs_tcon *tcon;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> @@ -1240,7 +1243,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>  		return PTR_ERR(tlink);
>  
>  	tcon = tlink_tcon(tlink);
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (backup_cred(cifs_sb))
>  		create_options |= CREATE_OPEN_BACKUP_INTENT;
> @@ -1263,7 +1266,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>  
>  	CIFSSMBClose(xid, tcon, fid);
>  out:
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8b6e344..4018da5 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -158,9 +158,9 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>  	int rc = -EOPNOTSUPP;
> -	int xid;
> +	unsigned int xid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	buf->f_type = CIFS_MAGIC_NUMBER;
>  
> @@ -197,7 +197,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	if (rc)
>  		rc = SMBOldQFSInfo(xid, tcon, buf);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return 0;
>  }
>  
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e1689e7..7ae25c2 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -37,20 +37,20 @@ extern struct smb_hdr *cifs_small_buf_get(void);
>  extern void cifs_small_buf_release(void *);
>  extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
>  			unsigned int /* length */);
> -extern unsigned int _GetXid(void);
> -extern void _FreeXid(unsigned int);
> -#define GetXid()						\
> +extern unsigned int _get_xid(void);
> +extern void _free_xid(unsigned int);
> +#define get_xid()						\
>  ({								\
> -	int __xid = (int)_GetXid();				\
> -	cFYI(1, "CIFS VFS: in %s as Xid: %d with uid: %d",	\
> +	unsigned int __xid = _get_xid();				\
> +	cFYI(1, "CIFS VFS: in %s as Xid: %u with uid: %d",	\
>  	     __func__, __xid, current_fsuid());			\
>  	__xid;							\
>  })
>  
> -#define FreeXid(curr_xid)					\
> +#define free_xid(curr_xid)					\
>  do {								\
> -	_FreeXid(curr_xid);					\
> -	cFYI(1, "CIFS VFS: leaving %s (xid = %d) rc = %d",	\
> +	_free_xid(curr_xid);					\
> +	cFYI(1, "CIFS VFS: leaving %s (xid = %u) rc = %d",	\
>  	     __func__, curr_xid, (int)rc);			\
>  } while (0)
>  extern int init_cifs_idmap(void);
> @@ -123,10 +123,10 @@ extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
>  extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
>  				struct file *file, struct tcon_link *tlink,
>  				__u32 oplock);
> -extern int cifs_posix_open(char *full_path, struct inode **pinode,
> -				struct super_block *sb,
> -				int mode, unsigned int f_flags,
> -				__u32 *poplock, __u16 *pnetfid, int xid);
> +extern int cifs_posix_open(char *full_path, struct inode **inode,
> +			   struct super_block *sb, int mode,
> +			   unsigned int f_flags, __u32 *oplock, __u16 *netfid,
> +			   unsigned int xid);
>  void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
>  extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
>  				     FILE_UNIX_BASIC_INFO *info,
> @@ -139,11 +139,12 @@ extern int cifs_get_file_info(struct file *filp);
>  extern int cifs_get_inode_info(struct inode **pinode,
>  			const unsigned char *search_path,
>  			FILE_ALL_INFO *pfile_info,
> -			struct super_block *sb, int xid, const __u16 *pfid);
> +			struct super_block *sb, unsigned int xid,
> +			const __u16 *pfid);
>  extern int cifs_get_file_info_unix(struct file *filp);
>  extern int cifs_get_inode_info_unix(struct inode **pinode,
>  			const unsigned char *search_path,
> -			struct super_block *sb, int xid);
> +			struct super_block *sb, unsigned int xid);
>  extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>  			      struct cifs_fattr *fattr, struct inode *inode,
>  			      const char *path, const __u16 *pfid);
> @@ -188,88 +189,90 @@ extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>  		    const char *tree, struct cifs_tcon *tcon,
>  		    const struct nls_table *);
>  
> -extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
>  		const char *searchName, const struct nls_table *nls_codepage,
>  		__u16 *searchHandle, __u16 search_flags,
>  		struct cifs_search_info *psrch_inf,
>  		int map, const char dirsep);
>  
> -extern int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
>  		__u16 searchHandle, __u16 search_flags,
>  		struct cifs_search_info *psrch_inf);
>  
> -extern int CIFSFindClose(const int, struct cifs_tcon *tcon,
> +extern int CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
>  			const __u16 search_handle);
>  
> -extern int CIFSSMBQFileInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			u16 netfid, FILE_ALL_INFO *pFindData);
> -extern int CIFSSMBQPathInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			FILE_ALL_INFO *findData,
>  			int legacy /* whether to use old info level */,
>  			const struct nls_table *nls_codepage, int remap);
> -extern int SMBQueryInformation(const int xid, struct cifs_tcon *tcon,
> +extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			FILE_ALL_INFO *findData,
>  			const struct nls_table *nls_codepage, int remap);
>  
> -extern int CIFSSMBUnixQFileInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			u16 netfid, FILE_UNIX_BASIC_INFO *pFindData);
> -extern int CIFSSMBUnixQPathInfo(const int xid,
> +extern int CIFSSMBUnixQPathInfo(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			FILE_UNIX_BASIC_INFO *pFindData,
>  			const struct nls_table *nls_codepage, int remap);
>  
> -extern int CIFSGetDFSRefer(const int xid, struct cifs_ses *ses,
> +extern int CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
>  			const unsigned char *searchName,
>  			struct dfs_info3_param **target_nodes,
>  			unsigned int *number_of_nodes_in_array,
>  			const struct nls_table *nls_codepage, int remap);
>  
> -extern int get_dfs_path(int xid, struct cifs_ses *pSesInfo,
> +extern int get_dfs_path(unsigned int xid, struct cifs_ses *pSesInfo,
>  			const char *old_path,
>  			const struct nls_table *nls_codepage,
>  			unsigned int *pnum_referrals,
>  			struct dfs_info3_param **preferrals,
>  			int remap);
> -extern void reset_cifs_unix_caps(int xid, struct cifs_tcon *tcon,
> +extern void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
>  				 struct cifs_sb_info *cifs_sb,
>  				 struct smb_vol *vol);
> -extern int CIFSSMBQFSInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			struct kstatfs *FSData);
> -extern int SMBOldQFSInfo(const int xid, struct cifs_tcon *tcon,
> +extern int SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			struct kstatfs *FSData);
> -extern int CIFSSMBSetFSUnixInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			__u64 cap);
>  
> -extern int CIFSSMBQFSAttributeInfo(const int xid,
> +extern int CIFSSMBQFSAttributeInfo(const unsigned int xid,
>  			struct cifs_tcon *tcon);
> -extern int CIFSSMBQFSDeviceInfo(const int xid, struct cifs_tcon *tcon);
> -extern int CIFSSMBQFSUnixInfo(const int xid, struct cifs_tcon *tcon);
> -extern int CIFSSMBQFSPosixInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon);
> +extern int CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon);
> +extern int CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			struct kstatfs *FSData);
>  
> -extern int CIFSSMBSetPathInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fileName, const FILE_BASIC_INFO *data,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBSetFileInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			const FILE_BASIC_INFO *data, __u16 fid,
>  			__u32 pid_of_opener);
> -extern int CIFSSMBSetFileDisposition(const int xid, struct cifs_tcon *tcon,
> -			bool delete_file, __u16 fid, __u32 pid_of_opener);
> +extern int CIFSSMBSetFileDisposition(const unsigned int xid,
> +				     struct cifs_tcon *tcon,
> +				     bool delete_file, __u16 fid,
> +				     __u32 pid_of_opener);
>  #if 0
> -extern int CIFSSMBSetAttrLegacy(int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon,
>  			char *fileName, __u16 dos_attributes,
>  			const struct nls_table *nls_codepage);
>  #endif /* possibly unneeded function */
> -extern int CIFSSMBSetEOF(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fileName, __u64 size,
>  			bool setAllocationSizeFlag,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBSetFileSize(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
>  			 __u64 size, __u16 fileHandle, __u32 opener_pid,
>  			bool AllocSizeFlag);
>  
> @@ -283,108 +286,110 @@ struct cifs_unix_set_info_args {
>  	dev_t	device;
>  };
>  
> -extern int CIFSSMBUnixSetFileInfo(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
> +				  struct cifs_tcon *tcon,
>  				  const struct cifs_unix_set_info_args *args,
>  				  u16 fid, u32 pid_of_opener);
>  
> -extern int CIFSSMBUnixSetPathInfo(const int xid, struct cifs_tcon *pTcon,
> -			char *fileName,
> -			const struct cifs_unix_set_info_args *args,
> -			const struct nls_table *nls_codepage,
> -			int remap_special_chars);
> +extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
> +				  struct cifs_tcon *tcon, char *file_name,
> +				  const struct cifs_unix_set_info_args *args,
> +				  const struct nls_table *nls_codepage,
> +				  int remap_special_chars);
>  
> -extern int CIFSSMBMkDir(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *newName,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBRmDir(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *name, const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSPOSIXDelFile(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *name, __u16 type,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBDelFile(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *name,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBRename(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fromName, const char *toName,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
> -			int netfid, const char *target_name,
> -			const struct nls_table *nls_codepage,
> -			int remap_special_chars);
> -extern int CIFSCreateHardLink(const int xid,
> +extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
> +				 int netfid, const char *target_name,
> +				 const struct nls_table *nls_codepage,
> +				 int remap_special_chars);
> +extern int CIFSCreateHardLink(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const char *fromName, const char *toName,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSUnixCreateHardLink(const int xid,
> +extern int CIFSUnixCreateHardLink(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const char *fromName, const char *toName,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSUnixCreateSymLink(const int xid,
> +extern int CIFSUnixCreateSymLink(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const char *fromName, const char *toName,
>  			const struct nls_table *nls_codepage);
> -extern int CIFSSMBUnixQuerySymLink(const int xid,
> +extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const unsigned char *searchName, char **syminfo,
>  			const struct nls_table *nls_codepage);
>  #ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
> -extern int CIFSSMBQueryReparseLinkInfo(const int xid,
> +extern int CIFSSMBQueryReparseLinkInfo(const unsigned int xid,
>  			struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			char *symlinkinfo, const int buflen, __u16 fid,
>  			const struct nls_table *nls_codepage);
>  #endif /* temporarily unused until cifs_symlink fixed */
> -extern int CIFSSMBOpen(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fileName, const int disposition,
>  			const int access_flags, const int omode,
>  			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
>  			const struct nls_table *nls_codepage, int remap);
> -extern int SMBLegacyOpen(const int xid, struct cifs_tcon *tcon,
> +extern int SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
>  			const char *fileName, const int disposition,
>  			const int access_flags, const int omode,
>  			__u16 *netfid, int *pOplock, FILE_ALL_INFO *,
>  			const struct nls_table *nls_codepage, int remap);
> -extern int CIFSPOSIXCreate(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
>  			u32 posix_flags, __u64 mode, __u16 *netfid,
>  			FILE_UNIX_BASIC_INFO *pRetData,
>  			__u32 *pOplock, const char *name,
>  			const struct nls_table *nls_codepage, int remap);
> -extern int CIFSSMBClose(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon,
>  			const int smb_file_id);
>  
> -extern int CIFSSMBFlush(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon,
>  			const int smb_file_id);
>  
> -extern int CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms,
> +extern int CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
>  			unsigned int *nbytes, char **buf,
>  			int *return_buf_type);
> -extern int CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
> +extern int CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
>  			unsigned int *nbytes, const char *buf,
>  			const char __user *ubuf, const int long_op);
> -extern int CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
> +extern int CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
>  			unsigned int *nbytes, struct kvec *iov, const int nvec,
>  			const int long_op);
> -extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName, __u64 *inode_number,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
>  
> -extern int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
> -		      const __u8 lock_type, const __u32 num_unlock,
> -		      const __u32 num_lock, LOCKING_ANDX_RANGE *buf);
> -extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
> +extern int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
> +		      const __u16 netfid, const __u8 lock_type,
> +		      const __u32 num_unlock, const __u32 num_lock,
> +		      LOCKING_ANDX_RANGE *buf);
> +extern int CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
>  			const __u16 netfid, const __u32 netpid, const __u64 len,
>  			const __u64 offset, const __u32 numUnlock,
>  			const __u32 numLock, const __u8 lockType,
>  			const bool waitFlag, const __u8 oplock_level);
> -extern int CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
>  			const __u16 smb_file_id, const __u32 netpid,
>  			const int get_flag, const __u64 len, struct file_lock *,
>  			const __u16 lock_type, const bool waitFlag);
> @@ -416,46 +421,46 @@ extern int calc_lanman_hash(const char *password, const char *cryptkey,
>  				bool encrypt, char *lnm_session_key);
>  #endif /* CIFS_WEAK_PW_HASH */
>  #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
> -extern int CIFSSMBNotify(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
>  			const int notify_subdirs, const __u16 netfid,
>  			__u32 filter, struct file *file, int multishot,
>  			const struct nls_table *nls_codepage);
>  #endif /* was needed for dnotify, and will be needed for inotify when VFS fix */
> -extern int CIFSSMBCopy(int xid,
> +extern int CIFSSMBCopy(unsigned int xid,
>  			struct cifs_tcon *source_tcon,
>  			const char *fromName,
>  			const __u16 target_tid,
>  			const char *toName, const int flags,
>  			const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern ssize_t CIFSSMBQAllEAs(const int xid, struct cifs_tcon *tcon,
> +extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			const unsigned char *ea_name, char *EAData,
>  			size_t bufsize, const struct nls_table *nls_codepage,
>  			int remap_special_chars);
> -extern int CIFSSMBSetEA(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
>  		const char *fileName, const char *ea_name,
>  		const void *ea_value, const __u16 ea_value_len,
>  		const struct nls_table *nls_codepage, int remap_special_chars);
> -extern int CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
>  			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
>  extern int CIFSSMBSetCIFSACL(const int, struct cifs_tcon *, __u16,
>  			struct cifs_ntsd *, __u32, int);
> -extern int CIFSSMBGetPosixACL(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
>  		const unsigned char *searchName,
>  		char *acl_inf, const int buflen, const int acl_type,
>  		const struct nls_table *nls_codepage, int remap_special_chars);
> -extern int CIFSSMBSetPosixACL(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
>  		const unsigned char *fileName,
>  		const char *local_acl, const int buflen, const int acl_type,
>  		const struct nls_table *nls_codepage, int remap_special_chars);
> -extern int CIFSGetExtAttr(const int xid, struct cifs_tcon *tcon,
> +extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
>  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
>  extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
>  extern bool CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr);
>  extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>  		const unsigned char *path,
> -		struct cifs_sb_info *cifs_sb, int xid);
> +		struct cifs_sb_info *cifs_sb, unsigned int xid);
>  extern int mdfour(unsigned char *, unsigned char *, int);
>  extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
>  			const struct nls_table *codepage);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 90f7de8..b24ee86 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -804,8 +804,9 @@ session_already_dead:
>  }
>  
>  int
> -CIFSPOSIXDelFile(const int xid, struct cifs_tcon *tcon, const char *fileName,
> -		 __u16 type, const struct nls_table *nls_codepage, int remap)
> +CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
> +		 const char *fileName, __u16 type,
> +		 const struct nls_table *nls_codepage, int remap)
>  {
>  	TRANSACTION2_SPI_REQ *pSMB = NULL;
>  	TRANSACTION2_SPI_RSP *pSMBr = NULL;
> @@ -879,8 +880,9 @@ PsxDelete:
>  }
>  
>  int
> -CIFSSMBDelFile(const int xid, struct cifs_tcon *tcon, const char *fileName,
> -	       const struct nls_table *nls_codepage, int remap)
> +CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
> +	       const char *fileName, const struct nls_table *nls_codepage,
> +	       int remap)
>  {
>  	DELETE_FILE_REQ *pSMB = NULL;
>  	DELETE_FILE_RSP *pSMBr = NULL;
> @@ -924,8 +926,9 @@ DelFileRetry:
>  }
>  
>  int
> -CIFSSMBRmDir(const int xid, struct cifs_tcon *tcon, const char *dirName,
> -	     const struct nls_table *nls_codepage, int remap)
> +CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
> +	     const char *dirName, const struct nls_table *nls_codepage,
> +	     int remap)
>  {
>  	DELETE_DIRECTORY_REQ *pSMB = NULL;
>  	DELETE_DIRECTORY_RSP *pSMBr = NULL;
> @@ -967,7 +970,7 @@ RmDirRetry:
>  }
>  
>  int
> -CIFSSMBMkDir(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
>  	     const char *name, const struct nls_table *nls_codepage, int remap)
>  {
>  	int rc = 0;
> @@ -1010,10 +1013,11 @@ MkDirRetry:
>  }
>  
>  int
> -CIFSPOSIXCreate(const int xid, struct cifs_tcon *tcon, __u32 posix_flags,
> -		__u64 mode, __u16 *netfid, FILE_UNIX_BASIC_INFO *pRetData,
> -		__u32 *pOplock, const char *name,
> -		const struct nls_table *nls_codepage, int remap)
> +CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
> +		__u32 posix_flags, __u64 mode, __u16 *netfid,
> +		FILE_UNIX_BASIC_INFO *pRetData, __u32 *pOplock,
> +		const char *name, const struct nls_table *nls_codepage,
> +		int remap)
>  {
>  	TRANSACTION2_SPI_REQ *pSMB = NULL;
>  	TRANSACTION2_SPI_RSP *pSMBr = NULL;
> @@ -1176,7 +1180,7 @@ access_flags_to_smbopen_mode(const int access_flags)
>  }
>  
>  int
> -SMBLegacyOpen(const int xid, struct cifs_tcon *tcon,
> +SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
>  	    const char *fileName, const int openDisposition,
>  	    const int access_flags, const int create_options, __u16 *netfid,
>  	    int *pOplock, FILE_ALL_INFO *pfile_info,
> @@ -1283,7 +1287,7 @@ OldOpenRetry:
>  }
>  
>  int
> -CIFSSMBOpen(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
>  	    const char *fileName, const int openDisposition,
>  	    const int access_flags, const int create_options, __u16 *netfid,
>  	    int *pOplock, FILE_ALL_INFO *pfile_info,
> @@ -1631,8 +1635,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
>  }
>  
>  int
> -CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
> -	    char **buf, int *pbuf_type)
> +CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
> +	    unsigned int *nbytes, char **buf, int *pbuf_type)
>  {
>  	int rc = -EACCES;
>  	READ_REQ *pSMB = NULL;
> @@ -1743,7 +1747,7 @@ CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
>  
>  
>  int
> -CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
> +CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
>  	     unsigned int *nbytes, const char *buf,
>  	     const char __user *ubuf, const int long_op)
>  {
> @@ -2108,7 +2112,7 @@ async_writev_out:
>  }
>  
>  int
> -CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
> +CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
>  	      unsigned int *nbytes, struct kvec *iov, int n_vec,
>  	      const int long_op)
>  {
> @@ -2216,8 +2220,8 @@ CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
>  	return rc;
>  }
>  
> -int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
> -	       const __u8 lock_type, const __u32 num_unlock,
> +int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
> +	       const __u16 netfid, const __u8 lock_type, const __u32 num_unlock,
>  	       const __u32 num_lock, LOCKING_ANDX_RANGE *buf)
>  {
>  	int rc = 0;
> @@ -2258,7 +2262,7 @@ int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
>  }
>  
>  int
> -CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
>  	    const __u16 smb_file_id, const __u32 netpid, const __u64 len,
>  	    const __u64 offset, const __u32 numUnlock,
>  	    const __u32 numLock, const __u8 lockType,
> @@ -2328,7 +2332,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  int
> -CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
>  		const __u16 smb_file_id, const __u32 netpid, const int get_flag,
>  		const __u64 len, struct file_lock *pLockData,
>  		const __u16 lock_type, const bool waitFlag)
> @@ -2466,7 +2470,7 @@ plk_err_exit:
>  
>  
>  int
> -CIFSSMBClose(const int xid, struct cifs_tcon *tcon, int smb_file_id)
> +CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
>  {
>  	int rc = 0;
>  	CLOSE_REQ *pSMB = NULL;
> @@ -2499,7 +2503,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *tcon, int smb_file_id)
>  }
>  
>  int
> -CIFSSMBFlush(const int xid, struct cifs_tcon *tcon, int smb_file_id)
> +CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
>  {
>  	int rc = 0;
>  	FLUSH_REQ *pSMB = NULL;
> @@ -2520,7 +2524,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *tcon, int smb_file_id)
>  }
>  
>  int
> -CIFSSMBRename(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
>  	      const char *fromName, const char *toName,
>  	      const struct nls_table *nls_codepage, int remap)
>  {
> @@ -2587,7 +2591,7 @@ renameRetry:
>  	return rc;
>  }
>  
> -int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
> +int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
>  		int netfid, const char *target_name,
>  		const struct nls_table *nls_codepage, int remap)
>  {
> @@ -2669,9 +2673,9 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
>  }
>  
>  int
> -CIFSSMBCopy(const int xid, struct cifs_tcon *tcon, const char *fromName,
> -	    const __u16 target_tid, const char *toName, const int flags,
> -	    const struct nls_table *nls_codepage, int remap)
> +CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
> +	    const char *fromName, const __u16 target_tid, const char *toName,
> +	    const int flags, const struct nls_table *nls_codepage, int remap)
>  {
>  	int rc = 0;
>  	COPY_REQ *pSMB = NULL;
> @@ -2737,7 +2741,7 @@ copyRetry:
>  }
>  
>  int
> -CIFSUnixCreateSymLink(const int xid, struct cifs_tcon *tcon,
> +CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		      const char *fromName, const char *toName,
>  		      const struct nls_table *nls_codepage)
>  {
> @@ -2826,7 +2830,7 @@ createSymLinkRetry:
>  }
>  
>  int
> -CIFSUnixCreateHardLink(const int xid, struct cifs_tcon *tcon,
> +CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		       const char *fromName, const char *toName,
>  		       const struct nls_table *nls_codepage, int remap)
>  {
> @@ -2911,7 +2915,7 @@ createHardLinkRetry:
>  }
>  
>  int
> -CIFSCreateHardLink(const int xid, struct cifs_tcon *tcon,
> +CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const char *fromName, const char *toName,
>  		   const struct nls_table *nls_codepage, int remap)
>  {
> @@ -2983,7 +2987,7 @@ winCreateHardLinkRetry:
>  }
>  
>  int
> -CIFSSMBUnixQuerySymLink(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName, char **symlinkinfo,
>  			const struct nls_table *nls_codepage)
>  {
> @@ -3088,7 +3092,7 @@ querySymLinkRetry:
>   *	it is not compiled in by default until callers fixed up and more tested.
>   */
>  int
> -CIFSSMBQueryReparseLinkInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			char *symlinkinfo, const int buflen, __u16 fid,
>  			const struct nls_table *nls_codepage)
> @@ -3325,7 +3329,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>  }
>  
>  int
> -CIFSSMBGetPosixACL(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const unsigned char *searchName,
>  		   char *acl_inf, const int buflen, const int acl_type,
>  		   const struct nls_table *nls_codepage, int remap)
> @@ -3414,7 +3418,7 @@ queryAclRetry:
>  }
>  
>  int
> -CIFSSMBSetPosixACL(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const unsigned char *fileName,
>  		   const char *local_acl, const int buflen,
>  		   const int acl_type,
> @@ -3494,7 +3498,7 @@ setACLerrorExit:
>  
>  /* BB fix tabs in this function FIXME BB */
>  int
> -CIFSGetExtAttr(const int xid, struct cifs_tcon *tcon,
> +CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
>  	       const int netfid, __u64 *pExtAttrBits, __u64 *pMask)
>  {
>  	int rc = 0;
> @@ -3669,7 +3673,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
>  
>  /* Get Security Descriptor (by handle) from remote server for a file or dir */
>  int
> -CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid,
> +CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
>  		  struct cifs_ntsd **acl_inf, __u32 *pbuflen)
>  {
>  	int rc = 0;
> @@ -3761,7 +3765,7 @@ qsec_out:
>  }
>  
>  int
> -CIFSSMBSetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid,
> +CIFSSMBSetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
>  			struct cifs_ntsd *pntsd, __u32 acllen, int aclflag)
>  {
>  	__u16 byte_count, param_count, data_count, param_offset, data_offset;
> @@ -3825,7 +3829,7 @@ setCifsAclRetry:
>  
>  /* Legacy Query Path Information call for lookup to old servers such
>     as Win9x/WinME */
> -int SMBQueryInformation(const int xid, struct cifs_tcon *tcon,
> +int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
>  			const unsigned char *searchName,
>  			FILE_ALL_INFO *pFinfo,
>  			const struct nls_table *nls_codepage, int remap)
> @@ -3894,7 +3898,7 @@ QInfRetry:
>  }
>  
>  int
> -CIFSSMBQFileInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		 u16 netfid, FILE_ALL_INFO *pFindData)
>  {
>  	struct smb_t2_qfi_req *pSMB = NULL;
> @@ -3961,7 +3965,7 @@ QFileInfoRetry:
>  }
>  
>  int
> -CIFSSMBQPathInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		 const unsigned char *searchName,
>  		 FILE_ALL_INFO *pFindData,
>  		 int legacy /* old style infolevel */,
> @@ -4062,7 +4066,7 @@ QPathInfoRetry:
>  }
>  
>  int
> -CIFSSMBUnixQFileInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		 u16 netfid, FILE_UNIX_BASIC_INFO *pFindData)
>  {
>  	struct smb_t2_qfi_req *pSMB = NULL;
> @@ -4131,7 +4135,7 @@ UnixQFileInfoRetry:
>  }
>  
>  int
> -CIFSSMBUnixQPathInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		     const unsigned char *searchName,
>  		     FILE_UNIX_BASIC_INFO *pFindData,
>  		     const struct nls_table *nls_codepage, int remap)
> @@ -4217,7 +4221,7 @@ UnixQPathInfoRetry:
>  
>  /* xid, tcon, searchName and codepage are input parms, rest are returned */
>  int
> -CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
> +CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
>  	      const char *searchName,
>  	      const struct nls_table *nls_codepage,
>  	      __u16 *pnetfid, __u16 search_flags,
> @@ -4362,8 +4366,9 @@ findFirstRetry:
>  	return rc;
>  }
>  
> -int CIFSFindNext(const int xid, struct cifs_tcon *tcon, __u16 searchHandle,
> -		 __u16 search_flags, struct cifs_search_info *psrch_inf)
> +int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
> +		 __u16 searchHandle, __u16 search_flags,
> +		 struct cifs_search_info *psrch_inf)
>  {
>  	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
>  	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
> @@ -4497,7 +4502,7 @@ FNext2_err_exit:
>  }
>  
>  int
> -CIFSFindClose(const int xid, struct cifs_tcon *tcon,
> +CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
>  	      const __u16 searchHandle)
>  {
>  	int rc = 0;
> @@ -4529,7 +4534,7 @@ CIFSFindClose(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  int
> -CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
> +CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
>  		      const unsigned char *searchName,
>  		      __u64 *inode_number,
>  		      const struct nls_table *nls_codepage, int remap)
> @@ -4736,7 +4741,7 @@ parse_DFS_referrals_exit:
>  }
>  
>  int
> -CIFSGetDFSRefer(const int xid, struct cifs_ses *ses,
> +CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
>  		const unsigned char *searchName,
>  		struct dfs_info3_param **target_nodes,
>  		unsigned int *num_of_nodes,
> @@ -4851,7 +4856,8 @@ GetDFSRefExit:
>  
>  /* Query File System Info such as free space to old servers such as Win 9x */
>  int
> -SMBOldQFSInfo(const int xid, struct cifs_tcon *tcon, struct kstatfs *FSData)
> +SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
> +	      struct kstatfs *FSData)
>  {
>  /* level 0x01 SMB_QUERY_FILE_SYSTEM_INFO */
>  	TRANSACTION2_QFSI_REQ *pSMB = NULL;
> @@ -4930,7 +4936,8 @@ oldQFSInfoRetry:
>  }
>  
>  int
> -CIFSSMBQFSInfo(const int xid, struct cifs_tcon *tcon, struct kstatfs *FSData)
> +CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
> +	       struct kstatfs *FSData)
>  {
>  /* level 0x103 SMB_QUERY_FILE_SYSTEM_INFO */
>  	TRANSACTION2_QFSI_REQ *pSMB = NULL;
> @@ -5009,7 +5016,7 @@ QFSInfoRetry:
>  }
>  
>  int
> -CIFSSMBQFSAttributeInfo(const int xid, struct cifs_tcon *tcon)
> +CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
>  {
>  /* level 0x105  SMB_QUERY_FILE_SYSTEM_INFO */
>  	TRANSACTION2_QFSI_REQ *pSMB = NULL;
> @@ -5079,7 +5086,7 @@ QFSAttributeRetry:
>  }
>  
>  int
> -CIFSSMBQFSDeviceInfo(const int xid, struct cifs_tcon *tcon)
> +CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
>  {
>  /* level 0x104 SMB_QUERY_FILE_SYSTEM_INFO */
>  	TRANSACTION2_QFSI_REQ *pSMB = NULL;
> @@ -5150,7 +5157,7 @@ QFSDeviceRetry:
>  }
>  
>  int
> -CIFSSMBQFSUnixInfo(const int xid, struct cifs_tcon *tcon)
> +CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
>  {
>  /* level 0x200  SMB_QUERY_CIFS_UNIX_INFO */
>  	TRANSACTION2_QFSI_REQ *pSMB = NULL;
> @@ -5220,7 +5227,7 @@ QFSUnixRetry:
>  }
>  
>  int
> -CIFSSMBSetFSUnixInfo(const int xid, struct cifs_tcon *tcon, __u64 cap)
> +CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon, __u64 cap)
>  {
>  /* level 0x200  SMB_SET_CIFS_UNIX_INFO */
>  	TRANSACTION2_SETFSI_REQ *pSMB = NULL;
> @@ -5294,7 +5301,7 @@ SETFSUnixRetry:
>  
>  
>  int
> -CIFSSMBQFSPosixInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		   struct kstatfs *FSData)
>  {
>  /* level 0x201  SMB_QUERY_CIFS_POSIX_INFO */
> @@ -5387,8 +5394,8 @@ QFSPosixRetry:
>     in Samba which this routine can run into */
>  
>  int
> -CIFSSMBSetEOF(const int xid, struct cifs_tcon *tcon, const char *fileName,
> -	      __u64 size, bool SetAllocation,
> +CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
> +	      const char *fileName, __u64 size, bool SetAllocation,
>  	      const struct nls_table *nls_codepage, int remap)
>  {
>  	struct smb_com_transaction2_spi_req *pSMB = NULL;
> @@ -5476,7 +5483,7 @@ SetEOFRetry:
>  }
>  
>  int
> -CIFSSMBSetFileSize(const int xid, struct cifs_tcon *tcon, __u64 size,
> +CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon, __u64 size,
>  		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
>  {
>  	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
> @@ -5558,7 +5565,7 @@ CIFSSMBSetFileSize(const int xid, struct cifs_tcon *tcon, __u64 size,
>     time and resort to the original setpathinfo level which takes the ancient
>     DOS time format with 2 second granularity */
>  int
> -CIFSSMBSetFileInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		    const FILE_BASIC_INFO *data, __u16 fid, __u32 pid_of_opener)
>  {
>  	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
> @@ -5621,7 +5628,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  int
> -CIFSSMBSetFileDisposition(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
>  			  bool delete_file, __u16 fid, __u32 pid_of_opener)
>  {
>  	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
> @@ -5677,7 +5684,7 @@ CIFSSMBSetFileDisposition(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  int
> -CIFSSMBSetPathInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const char *fileName, const FILE_BASIC_INFO *data,
>  		   const struct nls_table *nls_codepage, int remap)
>  {
> @@ -5761,7 +5768,7 @@ SetTimesRetry:
>  	  handling it anyway and NT4 was what we thought it would be needed for
>  	  Do not delete it until we prove whether needed for Win9x though */
>  int
> -CIFSSMBSetAttrLegacy(int xid, struct cifs_tcon *tcon, char *fileName,
> +CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon, char *fileName,
>  		__u16 dos_attrs, const struct nls_table *nls_codepage)
>  {
>  	SETATTR_REQ *pSMB = NULL;
> @@ -5849,7 +5856,7 @@ cifs_fill_unix_set_info(FILE_UNIX_BASIC_INFO *data_offset,
>  }
>  
>  int
> -CIFSSMBUnixSetFileInfo(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
>  		       const struct cifs_unix_set_info_args *args,
>  		       u16 fid, u32 pid_of_opener)
>  {
> @@ -5913,7 +5920,8 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  int
> -CIFSSMBUnixSetPathInfo(const int xid, struct cifs_tcon *tcon, char *fileName,
> +CIFSSMBUnixSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
> +		       char *fileName,
>  		       const struct cifs_unix_set_info_args *args,
>  		       const struct nls_table *nls_codepage, int remap)
>  {
> @@ -6000,7 +6008,7 @@ setPermsRetry:
>   * the data isn't copied to it, but the length is returned.
>   */
>  ssize_t
> -CIFSSMBQAllEAs(const int xid, struct cifs_tcon *tcon,
> +CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
>  		const unsigned char *searchName, const unsigned char *ea_name,
>  		char *EAData, size_t buf_size,
>  		const struct nls_table *nls_codepage, int remap)
> @@ -6183,8 +6191,8 @@ QAllEAsOut:
>  }
>  
>  int
> -CIFSSMBSetEA(const int xid, struct cifs_tcon *tcon, const char *fileName,
> -	     const char *ea_name, const void *ea_value,
> +CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
> +	     const char *fileName, const char *ea_name, const void *ea_value,
>  	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
>  	     int remap)
>  {
> @@ -6310,7 +6318,7 @@ SetEARetry:
>   *	incompatible for network fs clients, we could instead simply
>   *	expose this config flag by adding a future cifs (and smb2) notify ioctl.
>   */
> -int CIFSSMBNotify(const int xid, struct cifs_tcon *tcon,
> +int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
>  		  const int notify_subdirs, const __u16 netfid,
>  		  __u32 filter, struct file *pfile, int multishot,
>  		  const struct nls_table *nls_codepage)
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b91f64d..718bbea 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2266,9 +2266,9 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	if (ses->status == CifsGood && server->ops->logoff) {
> -		xid = GetXid();
> +		xid = get_xid();
>  		server->ops->logoff(xid, ses);
> -		_FreeXid(xid);
> +		_free_xid(xid);
>  	}
>  	sesInfoFree(ses);
>  	cifs_put_tcp_session(server);
> @@ -2411,7 +2411,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
>  	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	ses = cifs_find_smb_ses(server, volume_info);
>  	if (ses) {
> @@ -2423,7 +2423,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  			mutex_unlock(&ses->session_mutex);
>  			/* problem -- put our ses reference */
>  			cifs_put_smb_ses(ses);
> -			FreeXid(xid);
> +			free_xid(xid);
>  			return ERR_PTR(rc);
>  		}
>  		if (ses->need_reconnect) {
> @@ -2434,7 +2434,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  				mutex_unlock(&ses->session_mutex);
>  				/* problem -- put our reference */
>  				cifs_put_smb_ses(ses);
> -				FreeXid(xid);
> +				free_xid(xid);
>  				return ERR_PTR(rc);
>  			}
>  		}
> @@ -2442,7 +2442,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  
>  		/* existing SMB ses has a server reference already */
>  		cifs_put_tcp_session(server);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return ses;
>  	}
>  
> @@ -2501,12 +2501,12 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  	list_add(&ses->smb_ses_list, &server->smb_ses_list);
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return ses;
>  
>  get_ses_fail:
>  	sesInfoFree(ses);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return ERR_PTR(rc);
>  }
>  
> @@ -2554,10 +2554,10 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>  	list_del_init(&tcon->tcon_list);
>  	spin_unlock(&cifs_tcp_ses_lock);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	if (ses->server->ops->tree_disconnect)
>  		ses->server->ops->tree_disconnect(xid, tcon);
> -	_FreeXid(xid);
> +	_free_xid(xid);
>  
>  	cifs_fscache_release_super_cookie(tcon);
>  	tconInfoFree(tcon);
> @@ -2612,10 +2612,10 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>  	 * BB Do we need to wrap session_mutex around this TCon call and Unix
>  	 * SetFS as we do on SessSetup and reconnect?
>  	 */
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = ses->server->ops->tree_connect(xid, ses, volume_info->UNC, tcon,
>  					    volume_info->local_nls);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cFYI(1, "Tcon rc = %d", rc);
>  	if (rc)
>  		goto out_fail;
> @@ -2763,7 +2763,7 @@ out:
>  }
>  
>  int
> -get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
> +get_dfs_path(unsigned int xid, struct cifs_ses *ses, const char *old_path,
>  	     const struct nls_table *nls_codepage, unsigned int *num_referrals,
>  	     struct dfs_info3_param **referrals, int remap)
>  {
> @@ -3066,7 +3066,7 @@ ip_connect(struct TCP_Server_Info *server)
>  	return generic_ip_connect(server);
>  }
>  
> -void reset_cifs_unix_caps(int xid, struct cifs_tcon *tcon,
> +void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
>  			  struct cifs_sb_info *cifs_sb, struct smb_vol *vol_info)
>  {
>  	/* if we are reconnecting then should we check to see if
> @@ -3383,7 +3383,7 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
>  }
>  
>  static int
> -is_path_accessible(int xid, struct cifs_tcon *tcon,
> +is_path_accessible(unsigned int xid, struct cifs_tcon *tcon,
>  		   struct cifs_sb_info *cifs_sb, const char *full_path)
>  {
>  	int rc;
> @@ -3469,7 +3469,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
>   * determine whether there were referrals.
>   */
>  static int
> -expand_dfs_referral(int xid, struct cifs_ses *pSesInfo,
> +expand_dfs_referral(unsigned int xid, struct cifs_ses *pSesInfo,
>  		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
>  		    int check_prefix)
>  {
> @@ -3579,7 +3579,7 @@ int
>  cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>  {
>  	int rc;
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_ses *pSesInfo;
>  	struct cifs_tcon *tcon;
>  	struct TCP_Server_Info *srvTcp;
> @@ -3602,7 +3602,7 @@ try_mount_again:
>  		else if (pSesInfo)
>  			cifs_put_smb_ses(pSesInfo);
>  
> -		FreeXid(xid);
> +		free_xid(xid);
>  	}
>  #endif
>  	rc = 0;
> @@ -3612,7 +3612,7 @@ try_mount_again:
>  	full_path = NULL;
>  	tlink = NULL;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	/* get a reference to a tcp session */
>  	srvTcp = cifs_get_tcp_session(volume_info);
> @@ -3765,7 +3765,7 @@ mount_fail_check:
>  	}
>  
>  out:
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index ec4e9a2..9d73354 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -140,7 +140,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
>  		struct nameidata *nd)
>  {
>  	int rc = -ENOENT;
> -	int xid;
> +	unsigned int xid;
>  	int create_options = CREATE_NOT_DIR;
>  	__u32 oplock = 0;
>  	int oflags;
> @@ -161,12 +161,12 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
>  	struct inode *newinode = NULL;
>  	int disposition = FILE_OVERWRITE_IF;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cifs_sb = CIFS_SB(inode->i_sb);
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink)) {
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return PTR_ERR(tlink);
>  	}
>  	tcon = tlink_tcon(tlink);
> @@ -351,7 +351,7 @@ cifs_create_out:
>  	kfree(buf);
>  	kfree(full_path);
>  	cifs_put_tlink(tlink);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -359,7 +359,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>  		dev_t device_number)
>  {
>  	int rc = -EPERM;
> -	int xid;
> +	unsigned int xid;
>  	int create_options = CREATE_NOT_DIR | CREATE_OPTION_SPECIAL;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
> @@ -383,7 +383,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>  
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -431,7 +431,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>  	if (buf == NULL) {
>  		kfree(full_path);
>  		rc = -ENOMEM;
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -481,7 +481,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>  mknod_out:
>  	kfree(full_path);
>  	kfree(buf);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -490,7 +490,7 @@ struct dentry *
>  cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	    struct nameidata *nd)
>  {
> -	int xid;
> +	unsigned int xid;
>  	int rc = 0; /* to get around spurious gcc warning, set to zero here */
>  	__u32 oplock;
>  	__u16 fileHandle = 0;
> @@ -503,7 +503,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	char *full_path = NULL;
>  	struct file *filp;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
>  	      parent_dir_inode, direntry->d_name.name, direntry);
> @@ -513,7 +513,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink)) {
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return (struct dentry *)tlink;
>  	}
>  	pTcon = tlink_tcon(tlink);
> @@ -653,7 +653,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>  lookup_out:
>  	kfree(full_path);
>  	cifs_put_tlink(tlink);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return ERR_PTR(rc);
>  }
>  
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 513adbc..ea1bb66 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -107,7 +107,7 @@ static inline int cifs_get_disposition(unsigned int flags)
>  
>  int cifs_posix_open(char *full_path, struct inode **pinode,
>  			struct super_block *sb, int mode, unsigned int f_flags,
> -			__u32 *poplock, __u16 *pnetfid, int xid)
> +			__u32 *poplock, __u16 *pnetfid, unsigned int xid)
>  {
>  	int rc;
>  	FILE_UNIX_BASIC_INFO *presp_data;
> @@ -170,7 +170,7 @@ posix_open_ret:
>  static int
>  cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
>  	     struct cifs_tcon *tcon, unsigned int f_flags, __u32 *poplock,
> -	     __u16 *pnetfid, int xid)
> +	     __u16 *pnetfid, unsigned int xid)
>  {
>  	int rc;
>  	int desiredAccess;
> @@ -324,11 +324,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  	cancel_work_sync(&cifs_file->oplock_break);
>  
>  	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> -		int xid, rc;
> -
> -		xid = GetXid();
> +		unsigned int xid;
> +		int rc;
> +		xid = get_xid();
>  		rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
> -		FreeXid(xid);
> +		free_xid(xid);
>  	}
>  
>  	/* Delete any outstanding lock records. We'll lose them when the file
> @@ -350,7 +350,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  int cifs_open(struct inode *inode, struct file *file)
>  {
>  	int rc = -EACCES;
> -	int xid;
> +	unsigned int xid;
>  	__u32 oplock;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_tcon *tcon;
> @@ -360,12 +360,12 @@ int cifs_open(struct inode *inode, struct file *file)
>  	bool posix_open_ok = false;
>  	__u16 netfid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cifs_sb = CIFS_SB(inode->i_sb);
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink)) {
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return PTR_ERR(tlink);
>  	}
>  	tcon = tlink_tcon(tlink);
> @@ -445,7 +445,7 @@ int cifs_open(struct inode *inode, struct file *file)
>  
>  out:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -464,7 +464,7 @@ static int cifs_relock_file(struct cifsFileInfo *cifsFile)
>  static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  {
>  	int rc = -EACCES;
> -	int xid;
> +	unsigned int xid;
>  	__u32 oplock;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_tcon *tcon;
> @@ -476,12 +476,12 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	int create_options = CREATE_NOT_DIR;
>  	__u16 netfid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	mutex_lock(&pCifsFile->fh_mutex);
>  	if (!pCifsFile->invalidHandle) {
>  		mutex_unlock(&pCifsFile->fh_mutex);
>  		rc = 0;
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -497,7 +497,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	if (full_path == NULL) {
>  		rc = -ENOMEM;
>  		mutex_unlock(&pCifsFile->fh_mutex);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -583,7 +583,7 @@ reopen_success:
>  
>  reopen_error_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -601,13 +601,13 @@ int cifs_close(struct inode *inode, struct file *file)
>  int cifs_closedir(struct inode *inode, struct file *file)
>  {
>  	int rc = 0;
> -	int xid;
> +	unsigned int xid;
>  	struct cifsFileInfo *pCFileStruct = file->private_data;
>  	char *ptmp;
>  
>  	cFYI(1, "Closedir inode = 0x%p", inode);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (pCFileStruct) {
>  		struct cifs_tcon *pTcon = tlink_tcon(pCFileStruct->tlink);
> @@ -639,7 +639,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
>  		file->private_data = NULL;
>  	}
>  	/* BB can we lock the filestruct while this is going on? */
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -872,7 +872,8 @@ try_again:
>  static int
>  cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
>  {
> -	int xid, rc = 0, stored_rc;
> +	unsigned int xid;
> +	int rc = 0, stored_rc;
>  	struct cifsLockInfo *li, *tmp;
>  	struct cifs_tcon *tcon;
>  	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
> @@ -882,13 +883,13 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
>  		       LOCKING_ANDX_SHARED_LOCK | LOCKING_ANDX_LARGE_FILES};
>  	int i;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	tcon = tlink_tcon(cfile->tlink);
>  
>  	mutex_lock(&cinode->lock_mutex);
>  	if (!cinode->can_cache_brlcks) {
>  		mutex_unlock(&cinode->lock_mutex);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -899,7 +900,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
>  	max_buf = tcon->ses->server->maxBuf;
>  	if (!max_buf) {
>  		mutex_unlock(&cinode->lock_mutex);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return -EINVAL;
>  	}
>  
> @@ -908,7 +909,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
>  	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
>  	if (!buf) {
>  		mutex_unlock(&cinode->lock_mutex);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -947,7 +948,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
>  	mutex_unlock(&cinode->lock_mutex);
>  
>  	kfree(buf);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -977,12 +978,12 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
>  	struct lock_to_push *lck, *tmp;
>  	__u64 length;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	mutex_lock(&cinode->lock_mutex);
>  	if (!cinode->can_cache_brlcks) {
>  		mutex_unlock(&cinode->lock_mutex);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -1056,7 +1057,7 @@ out:
>  	cinode->can_cache_brlcks = false;
>  	mutex_unlock(&cinode->lock_mutex);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  err_out:
>  	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
> @@ -1128,7 +1129,7 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
>  }
>  
>  static int
> -cifs_mandatory_lock(int xid, struct cifsFileInfo *cfile, __u64 offset,
> +cifs_mandatory_lock(unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
>  		    __u64 length, __u32 type, int lock, int unlock, bool wait)
>  {
>  	return CIFSSMBLock(xid, tlink_tcon(cfile->tlink), cfile->netfid,
> @@ -1138,7 +1139,7 @@ cifs_mandatory_lock(int xid, struct cifsFileInfo *cfile, __u64 offset,
>  
>  static int
>  cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
> -	   bool wait_flag, bool posix_lck, int xid)
> +	   bool wait_flag, bool posix_lck, unsigned int xid)
>  {
>  	int rc = 0;
>  	__u64 length = 1 + flock->fl_end - flock->fl_start;
> @@ -1223,7 +1224,8 @@ cifs_free_llist(struct list_head *llist)
>  }
>  
>  static int
> -cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
> +cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
> +		  unsigned int xid)
>  {
>  	int rc = 0, stored_rc;
>  	int types[] = {LOCKING_ANDX_LARGE_FILES,
> @@ -1328,7 +1330,8 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
>  
>  static int
>  cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
> -	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
> +	   bool wait_flag, bool posix_lck, int lock, int unlock,
> +	   unsigned int xid)
>  {
>  	int rc = 0;
>  	__u64 length = 1 + flock->fl_end - flock->fl_start;
> @@ -1402,7 +1405,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>  	__u32 type;
>  
>  	rc = -EACCES;
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x start: %lld "
>  		"end: %lld", cmd, flock->fl_flags, flock->fl_type,
> @@ -1428,7 +1431,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>  	 */
>  	if (IS_GETLK(cmd)) {
>  		rc = cifs_getlk(file, flock, type, wait_flag, posix_lck, xid);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -1437,13 +1440,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>  		 * if no lock or unlock then nothing to do since we do not
>  		 * know what it is
>  		 */
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return -EOPNOTSUPP;
>  	}
>  
>  	rc = cifs_setlk(file, flock, type, wait_flag, posix_lck, lock, unlock,
>  			xid);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -1470,7 +1473,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
>  	unsigned int total_written;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_tcon *pTcon;
> -	int xid;
> +	unsigned int xid;
>  	struct dentry *dentry = open_file->dentry;
>  	struct cifsInodeInfo *cifsi = CIFS_I(dentry->d_inode);
>  	struct cifs_io_parms io_parms;
> @@ -1482,7 +1485,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
>  
>  	pTcon = tlink_tcon(open_file->tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	for (total_written = 0; write_size > total_written;
>  	     total_written += bytes_written) {
> @@ -1518,7 +1521,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
>  			if (total_written)
>  				break;
>  			else {
> -				FreeXid(xid);
> +				free_xid(xid);
>  				return rc;
>  			}
>  		} else {
> @@ -1538,7 +1541,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
>  		spin_unlock(&dentry->d_inode->i_lock);
>  	}
>  	mark_inode_dirty_sync(dentry->d_inode);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return total_written;
>  }
>  
> @@ -1937,9 +1940,9 @@ static int
>  cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
>  {
>  	int rc;
> -	int xid;
> +	unsigned int xid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  /* BB add check for wbc flags */
>  	page_cache_get(page);
>  	if (!PageUptodate(page))
> @@ -1968,7 +1971,7 @@ retry_write:
>  		SetPageUptodate(page);
>  	end_page_writeback(page);
>  	page_cache_release(page);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -2007,9 +2010,9 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  	if (!PageUptodate(page)) {
>  		char *page_data;
>  		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
> -		int xid;
> +		unsigned int xid;
>  
> -		xid = GetXid();
> +		xid = get_xid();
>  		/* this is probably better than directly calling
>  		   partialpage_write since in this function the file handle is
>  		   known which we might as well	leverage */
> @@ -2020,7 +2023,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  		/* if (rc < 0) should we set writebehind rc? */
>  		kunmap(page);
>  
> -		FreeXid(xid);
> +		free_xid(xid);
>  	} else {
>  		rc = copied;
>  		pos += copied;
> @@ -2043,7 +2046,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>  		      int datasync)
>  {
> -	int xid;
> +	unsigned int xid;
>  	int rc = 0;
>  	struct cifs_tcon *tcon;
>  	struct cifsFileInfo *smbfile = file->private_data;
> @@ -2055,7 +2058,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>  		return rc;
>  	mutex_lock(&inode->i_mutex);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
>  		file->f_path.dentry->d_name.name, datasync);
> @@ -2072,14 +2075,14 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>  	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
>  		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	mutex_unlock(&inode->i_mutex);
>  	return rc;
>  }
>  
>  int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> -	int xid;
> +	unsigned int xid;
>  	int rc = 0;
>  	struct cifs_tcon *tcon;
>  	struct cifsFileInfo *smbfile = file->private_data;
> @@ -2091,7 +2094,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  		return rc;
>  	mutex_lock(&inode->i_mutex);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
>  		file->f_path.dentry->d_name.name, datasync);
> @@ -2100,7 +2103,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
>  		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	mutex_unlock(&inode->i_mutex);
>  	return rc;
>  }
> @@ -2745,14 +2748,14 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  	unsigned int rsize;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_tcon *pTcon;
> -	int xid;
> +	unsigned int xid;
>  	char *current_offset;
>  	struct cifsFileInfo *open_file;
>  	struct cifs_io_parms io_parms;
>  	int buf_type = CIFS_NO_BUFFER;
>  	__u32 pid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
>  
>  	/* FIXME: set up handlers for larger reads and/or convert to async */
> @@ -2760,7 +2763,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  
>  	if (file->private_data == NULL) {
>  		rc = -EBADF;
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  	open_file = file->private_data;
> @@ -2805,7 +2808,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  			if (total_read) {
>  				break;
>  			} else {
> -				FreeXid(xid);
> +				free_xid(xid);
>  				return rc;
>  			}
>  		} else {
> @@ -2813,7 +2816,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  			*poffset += bytes_read;
>  		}
>  	}
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return total_read;
>  }
>  
> @@ -2840,7 +2843,7 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
>  	int rc, xid;
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (!CIFS_I(inode)->clientCanCacheRead) {
>  		rc = cifs_invalidate_mapping(inode);
> @@ -2851,7 +2854,7 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
>  	rc = generic_file_mmap(file, vma);
>  	if (rc == 0)
>  		vma->vm_ops = &cifs_file_vm_ops;
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -2859,17 +2862,17 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	int rc, xid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = cifs_revalidate_file(file);
>  	if (rc) {
>  		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  	rc = generic_file_mmap(file, vma);
>  	if (rc == 0)
>  		vma->vm_ops = &cifs_file_vm_ops;
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -3159,13 +3162,13 @@ static int cifs_readpage(struct file *file, struct page *page)
>  {
>  	loff_t offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
>  	int rc = -EACCES;
> -	int xid;
> +	unsigned int xid;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (file->private_data == NULL) {
>  		rc = -EBADF;
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -3176,7 +3179,7 @@ static int cifs_readpage(struct file *file, struct page *page)
>  
>  	unlock_page(page);
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 745da3d..089939c 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -289,7 +289,7 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
>  int cifs_get_file_info_unix(struct file *filp)
>  {
>  	int rc;
> -	int xid;
> +	unsigned int xid;
>  	FILE_UNIX_BASIC_INFO find_data;
>  	struct cifs_fattr fattr;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
> @@ -297,7 +297,7 @@ int cifs_get_file_info_unix(struct file *filp)
>  	struct cifsFileInfo *cfile = filp->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, &find_data);
>  	if (!rc) {
>  		cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
> @@ -307,13 +307,13 @@ int cifs_get_file_info_unix(struct file *filp)
>  	}
>  
>  	cifs_fattr_to_inode(inode, &fattr);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
>  int cifs_get_inode_info_unix(struct inode **pinode,
>  			     const unsigned char *full_path,
> -			     struct super_block *sb, int xid)
> +			     struct super_block *sb, unsigned int xid)
>  {
>  	int rc;
>  	FILE_UNIX_BASIC_INFO find_data;
> @@ -367,7 +367,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
>  
>  static int
>  cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
> -	      struct cifs_sb_info *cifs_sb, int xid)
> +	      struct cifs_sb_info *cifs_sb, unsigned int xid)
>  {
>  	int rc;
>  	int oplock = 0;
> @@ -466,7 +466,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
>   * FIXME: Doesn't this clobber the type bit we got from cifs_sfu_type ?
>   */
>  static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
> -			 struct cifs_sb_info *cifs_sb, int xid)
> +			 struct cifs_sb_info *cifs_sb, unsigned int xid)
>  {
>  #ifdef CONFIG_CIFS_XATTR
>  	ssize_t rc;
> @@ -557,7 +557,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  int cifs_get_file_info(struct file *filp)
>  {
>  	int rc;
> -	int xid;
> +	unsigned int xid;
>  	FILE_ALL_INFO find_data;
>  	struct cifs_fattr fattr;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
> @@ -565,7 +565,7 @@ int cifs_get_file_info(struct file *filp)
>  	struct cifsFileInfo *cfile = filp->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
>  	switch (rc) {
>  	case 0:
> @@ -596,13 +596,13 @@ int cifs_get_file_info(struct file *filp)
>  	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
>  	cifs_fattr_to_inode(inode, &fattr);
>  cgfi_exit:
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
>  int cifs_get_inode_info(struct inode **pinode,
>  	const unsigned char *full_path, FILE_ALL_INFO *pfindData,
> -	struct super_block *sb, int xid, const __u16 *pfid)
> +	struct super_block *sb, unsigned int xid, const __u16 *pfid)
>  {
>  	int rc = 0, tmprc;
>  	struct cifs_tcon *pTcon;
> @@ -885,13 +885,13 @@ retry_iget5_locked:
>  /* gets root inode */
>  struct inode *cifs_root_iget(struct super_block *sb)
>  {
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct inode *inode = NULL;
>  	long rc;
>  	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  	if (tcon->unix_ext)
>  		rc = cifs_get_inode_info_unix(&inode, "", sb, xid);
>  	else
> @@ -921,15 +921,15 @@ struct inode *cifs_root_iget(struct super_block *sb)
>  	}
>  
>  out:
> -	/* can not call macro FreeXid here since in a void func
> +	/* can not call macro free_xid here since in a void func
>  	 * TODO: This is no longer true
>  	 */
> -	_FreeXid(xid);
> +	_free_xid(xid);
>  	return inode;
>  }
>  
>  static int
> -cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
> +cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
>  		    char *full_path, __u32 dosattr)
>  {
>  	int rc;
> @@ -1050,7 +1050,8 @@ out:
>   * anything else.
>   */
>  static int
> -cifs_rename_pending_delete(char *full_path, struct dentry *dentry, int xid)
> +cifs_rename_pending_delete(char *full_path, struct dentry *dentry,
> +			   unsigned int xid)
>  {
>  	int oplock = 0;
>  	int rc;
> @@ -1170,7 +1171,7 @@ undo_setattr:
>  int cifs_unlink(struct inode *dir, struct dentry *dentry)
>  {
>  	int rc = 0;
> -	int xid;
> +	unsigned int xid;
>  	char *full_path = NULL;
>  	struct inode *inode = dentry->d_inode;
>  	struct cifsInodeInfo *cifs_inode;
> @@ -1188,7 +1189,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	/* Unlink can be called from rename so we can not take the
>  	 * sb->s_vfs_rename_mutex here */
> @@ -1264,7 +1265,7 @@ out_reval:
>  unlink_out:
>  	kfree(full_path);
>  	kfree(attrs);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -1272,7 +1273,7 @@ unlink_out:
>  int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
>  {
>  	int rc = 0, tmprc;
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -1288,7 +1289,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -1445,7 +1446,7 @@ mkdir_out:
>  	 */
>  	CIFS_I(inode)->time = 0;
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -1453,7 +1454,7 @@ mkdir_out:
>  int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  {
>  	int rc = 0;
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -1462,7 +1463,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  
>  	cFYI(1, "cifs_rmdir, inode = 0x%p", inode);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -1505,13 +1506,14 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  
>  rmdir_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
>  static int
> -cifs_do_rename(int xid, struct dentry *from_dentry, const char *fromPath,
> -		struct dentry *to_dentry, const char *toPath)
> +cifs_do_rename(unsigned int xid, struct dentry *from_dentry,
> +	       const char *fromPath, struct dentry *to_dentry,
> +	       const char *toPath)
>  {
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
>  	struct tcon_link *tlink;
> @@ -1570,7 +1572,8 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
>  	struct cifs_tcon *tcon;
>  	FILE_UNIX_BASIC_INFO *info_buf_source = NULL;
>  	FILE_UNIX_BASIC_INFO *info_buf_target;
> -	int xid, rc, tmprc;
> +	unsigned int xid;
> +	int rc, tmprc;
>  
>  	cifs_sb = CIFS_SB(source_dir->i_sb);
>  	tlink = cifs_sb_tlink(cifs_sb);
> @@ -1578,7 +1581,7 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	/*
>  	 * we already have the rename sem so we do not need to
> @@ -1651,7 +1654,7 @@ cifs_rename_exit:
>  	kfree(info_buf_source);
>  	kfree(fromName);
>  	kfree(toName);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -1726,7 +1729,7 @@ int cifs_revalidate_file_attr(struct file *filp)
>  
>  int cifs_revalidate_dentry_attr(struct dentry *dentry)
>  {
> -	int xid;
> +	unsigned int xid;
>  	int rc = 0;
>  	struct inode *inode = dentry->d_inode;
>  	struct super_block *sb = dentry->d_sb;
> @@ -1738,7 +1741,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
>  	if (!cifs_inode_needs_reval(inode))
>  		return rc;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	/* can not safely grab the rename sem here if rename calls revalidate
>  	   since that would deadlock */
> @@ -1760,7 +1763,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
>  
>  out:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> @@ -1868,7 +1871,7 @@ static void cifs_setsize(struct inode *inode, loff_t offset)
>  
>  static int
>  cifs_set_file_size(struct inode *inode, struct iattr *attrs,
> -		   int xid, char *full_path)
> +		   unsigned int xid, char *full_path)
>  {
>  	int rc;
>  	struct cifsFileInfo *open_file;
> @@ -1970,7 +1973,7 @@ static int
>  cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
>  {
>  	int rc;
> -	int xid;
> +	unsigned int xid;
>  	char *full_path = NULL;
>  	struct inode *inode = direntry->d_inode;
>  	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
> @@ -1983,7 +1986,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
>  	cFYI(1, "setattr_unix on file %s attrs->ia_valid=0x%x",
>  		 direntry->d_name.name, attrs->ia_valid);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
>  		attrs->ia_valid |= ATTR_FORCE;
> @@ -2103,14 +2106,14 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
>  out:
>  	kfree(args);
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
>  static int
>  cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  {
> -	int xid;
> +	unsigned int xid;
>  	uid_t uid = NO_CHANGE_32;
>  	gid_t gid = NO_CHANGE_32;
>  	struct inode *inode = direntry->d_inode;
> @@ -2121,7 +2124,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  	__u32 dosattr = 0;
>  	__u64 mode = NO_CHANGE_64;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "setattr on file %s attrs->iavalid 0x%x",
>  		 direntry->d_name.name, attrs->ia_valid);
> @@ -2131,14 +2134,14 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  
>  	rc = inode_change_ok(inode, attrs);
>  	if (rc < 0) {
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
>  		rc = -ENOMEM;
> -		FreeXid(xid);
> +		free_xid(xid);
>  		return rc;
>  	}
>  
> @@ -2264,7 +2267,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  
>  cifs_setattr_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 6d2667f..ae082a6 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -34,7 +34,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  {
>  	struct inode *inode = filep->f_dentry->d_inode;
>  	int rc = -ENOTTY; /* strange error - but the precedent */
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  #ifdef CONFIG_CIFS_POSIX
>  	struct cifsFileInfo *pSMBFile = filep->private_data;
> @@ -44,7 +44,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  	__u64   caps;
>  #endif /* CONFIG_CIFS_POSIX */
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
>  
> @@ -105,6 +105,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  			break;
>  	}
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 6b0e064..77d781a 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -181,7 +181,7 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  }
>  
>  static int
> -CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
> +CIFSCreateMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		    const char *fromName, const char *toName,
>  		    struct cifs_sb_info *cifs_sb)
>  {
> @@ -238,7 +238,7 @@ CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
>  }
>  
>  static int
> -CIFSQueryMFSymLink(const int xid, struct cifs_tcon *tcon,
> +CIFSQueryMFSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>  		   const unsigned char *searchName, char **symlinkinfo,
>  		   const struct nls_table *nls_codepage, int remap)
>  {
> @@ -307,7 +307,7 @@ CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr)
>  int
>  CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>  		   const unsigned char *path,
> -		   struct cifs_sb_info *cifs_sb, int xid)
> +		   struct cifs_sb_info *cifs_sb, unsigned int xid)
>  {
>  	int rc;
>  	int oplock = 0;
> @@ -390,7 +390,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
>  	      struct dentry *direntry)
>  {
>  	int rc = -EACCES;
> -	int xid;
> +	unsigned int xid;
>  	char *fromName = NULL;
>  	char *toName = NULL;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> @@ -403,7 +403,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	fromName = build_path_from_dentry(old_file);
>  	toName = build_path_from_dentry(direntry);
> @@ -455,7 +455,7 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
>  cifs_hl_exit:
>  	kfree(fromName);
>  	kfree(toName);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  	return rc;
>  }
> @@ -465,14 +465,14 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
>  {
>  	struct inode *inode = direntry->d_inode;
>  	int rc = -ENOMEM;
> -	int xid;
> +	unsigned int xid;
>  	char *full_path = NULL;
>  	char *target_path = NULL;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct tcon_link *tlink = NULL;
>  	struct cifs_tcon *tcon;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink)) {
> @@ -529,7 +529,7 @@ out:
>  		target_path = ERR_PTR(rc);
>  	}
>  
> -	FreeXid(xid);
> +	free_xid(xid);
>  	if (tlink)
>  		cifs_put_tlink(tlink);
>  	nd_set_link(nd, target_path);
> @@ -540,14 +540,14 @@ int
>  cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  {
>  	int rc = -EOPNOTSUPP;
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
>  	char *full_path = NULL;
>  	struct inode *newinode = NULL;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	tlink = cifs_sb_tlink(cifs_sb);
>  	if (IS_ERR(tlink)) {
> @@ -594,7 +594,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  symlink_exit:
>  	kfree(full_path);
>  	cifs_put_tlink(tlink);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 557506a..6460114 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -40,7 +40,7 @@ extern mempool_t *cifs_req_poolp;
>     since the cifs fs was mounted */
>  
>  unsigned int
> -_GetXid(void)
> +_get_xid(void)
>  {
>  	unsigned int xid;
>  
> @@ -58,7 +58,7 @@ _GetXid(void)
>  }
>  
>  void
> -_FreeXid(unsigned int xid)
> +_free_xid(unsigned int xid)
>  {
>  	spin_lock(&GlobalMid_Lock);
>  	/* if (GlobalTotalActiveXid == 0)
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 0a8224d..5cb2c37 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -190,7 +190,7 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
>        we try to do FindFirst on (NTFS) directory symlinks */
>  /*
>  int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
> -			     int xid)
> +			     unsigned int xid)
>  {
>  	__u16 fid;
>  	int len;
> @@ -217,7 +217,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
>  }
>   */
>  
> -static int initiate_cifs_search(const int xid, struct file *file)
> +static int initiate_cifs_search(const unsigned int xid, struct file *file)
>  {
>  	__u16 search_flags;
>  	int rc = 0;
> @@ -504,7 +504,7 @@ static int cifs_save_resume_key(const char *current_entry,
>     assume that they are located in the findfirst return buffer.*/
>  /* We start counting in the buffer with entry 2 and increment for every
>     entry (do not increment for . or .. entry) */
> -static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
> +static int find_cifs_entry(const unsigned int xid, struct cifs_tcon *pTcon,
>  	struct file *file, char **ppCurrentEntry, int *num_to_ret)
>  {
>  	__u16 search_flags;
> @@ -718,7 +718,8 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
>  int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  {
>  	int rc = 0;
> -	int xid, i;
> +	unsigned int xid;
> +	int i;
>  	struct cifs_tcon *pTcon;
>  	struct cifsFileInfo *cifsFile = NULL;
>  	char *current_entry;
> @@ -727,7 +728,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  	char *end_of_smb;
>  	unsigned int max_len;
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	/*
>  	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
> @@ -765,7 +766,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  
>  		if (file->private_data == NULL) {
>  			rc = -EINVAL;
> -			FreeXid(xid);
> +			free_xid(xid);
>  			return rc;
>  		}
>  		cifsFile = file->private_data;
> @@ -837,6 +838,6 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  	} /* end switch */
>  
>  rddir2_exit:
> -	FreeXid(xid);
> +	free_xid(xid);
>  	return rc;
>  }
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 10d92cf..5142f2c 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -39,7 +39,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>  {
>  	int rc = -EOPNOTSUPP;
>  #ifdef CONFIG_CIFS_XATTR
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -60,7 +60,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -88,7 +88,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>  	}
>  remove_ea_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  #endif
>  	return rc;
> @@ -99,7 +99,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>  {
>  	int rc = -EOPNOTSUPP;
>  #ifdef CONFIG_CIFS_XATTR
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -120,7 +120,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -221,7 +221,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>  
>  set_ea_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  #endif
>  	return rc;
> @@ -232,7 +232,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>  {
>  	ssize_t rc = -EOPNOTSUPP;
>  #ifdef CONFIG_CIFS_XATTR
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -253,7 +253,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -355,7 +355,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
>  
>  get_ea_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  #endif
>  	return rc;
> @@ -365,7 +365,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
>  {
>  	ssize_t rc = -EOPNOTSUPP;
>  #ifdef CONFIG_CIFS_XATTR
> -	int xid;
> +	unsigned int xid;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -389,7 +389,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
>  		return PTR_ERR(tlink);
>  	pTcon = tlink_tcon(tlink);
>  
> -	xid = GetXid();
> +	xid = get_xid();
>  
>  	full_path = build_path_from_dentry(direntry);
>  	if (full_path == NULL) {
> @@ -409,7 +409,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
>  
>  list_ea_exit:
>  	kfree(full_path);
> -	FreeXid(xid);
> +	free_xid(xid);
>  	cifs_put_tlink(tlink);
>  #endif
>  	return rc;

Looks fine. I'd still prefer to just get rid of this junk, but if we
have to keep it this at least looks better.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
