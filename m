From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount options for backup intent (try #4)
Date: Fri, 23 Sep 2011 14:56:56 -0400
Message-ID: <20110923145656.441bb3c5@tlielax.poochiereds.net>
References: <1316705351-31289-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316705351-31289-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 22 Sep 2011 10:29:11 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add mount options backupuid and backugid.
> 
> It allows an authenticated user to access files with the intent to back them
> up including their ACLs, who may not have access permission but has
> "Backup files and directories user right" on them (by virtue of being part
> of the built-in group Backup Operators.
> 
> When mount options backupuid is specified, cifs client restricts the
> use of backup intents to the user whose effective user id is specified
> along with the mount option.
> 
> When mount options backupgid is specified, cifs client restricts the
> use of backup intents to the users whose effective user id belongs to the
> group id specified along with the mount option.
> 
> If an authenticated user is not part of the built-in group Backup Operators
> at the server, access to such files is denied, even if allowed by the client.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    5 +++++
>  fs/cifs/cifsacl.c    |   18 ++++++++++++------
>  fs/cifs/cifsglob.h   |    7 ++++++-
>  fs/cifs/cifsproto.h  |    1 +
>  fs/cifs/connect.c    |   16 ++++++++++++++++
>  fs/cifs/dir.c        |   10 ++++++++--
>  fs/cifs/file.c       |   12 ++++++++++--
>  fs/cifs/link.c       |   17 ++++++++++++-----
>  fs/cifs/misc.c       |   13 +++++++++++++
>  9 files changed, 83 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 7260e11..a1f904e 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -43,6 +43,7 @@
>  #define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
>  #define CIFS_MOUNT_RWPIDFORWARD	0x80000 /* use pid forwarding for rw */
>  #define CIFS_MOUNT_POSIXACL	0x100000 /* mirror of MS_POSIXACL in mnt_cifs_flags */
> +#define CIFS_MOUNT_CIFS_BACKUP	0x200000 /* open file with backup intent bit */
>  
>  struct cifs_sb_info {
>  	struct rb_root tlink_tree;
> @@ -55,11 +56,15 @@ struct cifs_sb_info {
>  	atomic_t active;
>  	uid_t	mnt_uid;
>  	gid_t	mnt_gid;
> +	uid_t	backupuid;
> +	gid_t	backupgid;
>  	mode_t	mnt_file_mode;
>  	mode_t	mnt_dir_mode;
>  	unsigned int mnt_cifs_flags;
>  	char   *mountdata; /* options received at mount time or via DFS refs */
>  	struct backing_dev_info bdi;
>  	struct delayed_work prune_tlinks;
> +	bool mnt_backupuid:1;
> +	bool mnt_backupgid:1;

Instead of the bools and the flag, why not just declare 2 new flags?
Say, CIFS_MOUNT_BACKUP_UID and CIFS_MOUNT_BACKUP_GID, then check for
those in backup_cred(). That would make this simpler to follow. I don't
see the point in having both.

>  };
>  #endif				/* _CIFS_FS_SB_H */
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index d0f59fa..b244e07 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -945,7 +945,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  {
>  	struct cifs_ntsd *pntsd = NULL;
>  	int oplock = 0;
> -	int xid, rc;
> +	int xid, rc, create_options = 0;
>  	__u16 fid;
>  	struct cifs_tcon *tcon;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> @@ -956,9 +956,12 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>  	tcon = tlink_tcon(tlink);
>  	xid = GetXid();
>  
> -	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONTROL, 0,
> -			 &fid, &oplock, NULL, cifs_sb->local_nls,
> -			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
> +	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONTROL,
> +			create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
> +			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	if (!rc) {
>  		rc = CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
>  		CIFSSMBClose(xid, tcon, fid);
> @@ -995,7 +998,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
>  		struct cifs_ntsd *pnntsd, u32 acllen)
>  {
>  	int oplock = 0;
> -	int xid, rc;
> +	int xid, rc, create_options = 0;
>  	__u16 fid;
>  	struct cifs_tcon *tcon;
>  	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
> @@ -1006,7 +1009,10 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
>  	tcon = tlink_tcon(tlink);
>  	xid = GetXid();
>  
> -	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DAC, 0,
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
> +	rc = CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DAC, create_options,
>  			 &fid, &oplock, NULL, cifs_sb->local_nls,
>  			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	if (rc) {
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 95dad9d..5290f6a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -167,6 +167,8 @@ struct smb_vol {
>  	uid_t cred_uid;
>  	uid_t linux_uid;
>  	gid_t linux_gid;
> +	uid_t backupuid;
> +	gid_t backupgid;
>  	mode_t file_mode;
>  	mode_t dir_mode;
>  	unsigned secFlg;
> @@ -179,6 +181,8 @@ struct smb_vol {
>  	bool noperm:1;
>  	bool no_psx_acl:1; /* set if posix acl support should be disabled */
>  	bool cifs_acl:1;
> +	bool cifs_backupuid:1; /* backupuid mount option is specified */
> +	bool cifs_backupgid:1; /* backupgid mount option is specified */

No need for the length qualifiers on bools. The same is true for the
other flags here as well.

>  	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
>  	bool server_ino:1; /* use inode numbers from server ie UniqueId */
>  	bool direct_io:1;
> @@ -219,7 +223,8 @@ struct smb_vol {
>  			 CIFS_MOUNT_OVERR_GID | CIFS_MOUNT_DYNPERM | \
>  			 CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC | \
>  			 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
> -			 CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO)
> +			 CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
> +			 CIFS_MOUNT_CIFS_BACKUP)
>  
>  #define CIFS_MS_MASK (MS_RDONLY | MS_MANDLOCK | MS_NOEXEC | MS_NOSUID | \
>  		      MS_NODEV | MS_SYNCHRONOUS)
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8df28e9..937c78e 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -90,6 +90,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
>  extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
>  extern bool is_valid_oplock_break(struct smb_hdr *smb,
>  				  struct TCP_Server_Info *);
> +extern bool backup_cred(struct cifs_sb_info *);
>  extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
>  extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
>  			    unsigned int bytes_written);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f4af4cc..f40764c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -883,6 +883,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			cFYI(1, "Null separator not allowed");
>  		}
>  	}
> +	vol->cifs_backupuid = 0; /* no backup intent */
> +	vol->cifs_backupgid = 0; /* no backup intent */
>  

These should be set to "false" not "0". I'd have also called these
something more descriptive -- "backupuid_specified" or something.

>  	while ((data = strsep(&options, separator)) != NULL) {
>  		if (!*data)
> @@ -1442,6 +1444,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			vol->mfsymlinks = true;
>  		} else if (strnicmp(data, "multiuser", 8) == 0) {
>  			vol->multiuser = true;
> +		} else if (!strnicmp(data, "backupuid", 9) && value && *value) {
> +			kstrtouint(value, 0, &vol->backupuid);
> +			vol->cifs_backupuid = 1;
> +		} else if (!strnicmp(data, "backupgid", 9) && value && *value) {
> +			kstrtouint(value, 0, &vol->backupgid);
> +			vol->cifs_backupgid = 1;

		Should be set to "true".

>  		} else
>  			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
>  						data);
> @@ -2733,6 +2741,12 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  
>  	cifs_sb->mnt_uid = pvolume_info->linux_uid;
>  	cifs_sb->mnt_gid = pvolume_info->linux_gid;
> +	cifs_sb->mnt_backupuid = pvolume_info->cifs_backupuid;
> +	if (cifs_sb->mnt_backupuid)
> +		cifs_sb->backupuid = pvolume_info->backupuid;
> +	cifs_sb->mnt_backupgid = pvolume_info->cifs_backupgid;
> +	if (cifs_sb->mnt_backupgid)
> +		cifs_sb->backupgid = pvolume_info->backupgid;
>  	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
>  	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
>  	cFYI(1, "file mode: 0x%x  dir mode: 0x%x",
> @@ -2763,6 +2777,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
>  	if (pvolume_info->cifs_acl)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
> +	if (pvolume_info->cifs_backupuid || pvolume_info->cifs_backupgid)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUP;
>  	if (pvolume_info->override_uid)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
>  	if (pvolume_info->override_gid)
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 72d448b..0a818a6 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -244,6 +244,9 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
>  	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
>  		create_options |= CREATE_OPTION_READONLY;
>  
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
>  	if (tcon->ses->capabilities & CAP_NT_SMBS)
>  		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
>  			 desiredAccess, create_options,
> @@ -357,6 +360,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
>  {
>  	int rc = -EPERM;
>  	int xid;
> +	int create_options = CREATE_NOT_DIR | CREATE_OPTION_SPECIAL;
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *pTcon;
> @@ -431,9 +435,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
>  		return rc;
>  	}
>  
> -	/* FIXME: would WRITE_OWNER | WRITE_DAC be better? */
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
>  	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
> -			 GENERIC_WRITE, CREATE_NOT_DIR | CREATE_OPTION_SPECIAL,
> +			 GENERIC_WRITE, create_options,
>  			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
>  			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	if (rc)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9f41a10..97e4be3 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -174,6 +174,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
>  	int rc;
>  	int desiredAccess;
>  	int disposition;
> +	int create_options = CREATE_NOT_DIR;
>  	FILE_ALL_INFO *buf;
>  
>  	desiredAccess = cifs_convert_flags(f_flags);
> @@ -210,9 +211,12 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
>  	if (!buf)
>  		return -ENOMEM;
>  
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
>  	if (tcon->ses->capabilities & CAP_NT_SMBS)
>  		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
> -			 desiredAccess, CREATE_NOT_DIR, pnetfid, poplock, buf,
> +			 desiredAccess, create_options, pnetfid, poplock, buf,
>  			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
>  				 & CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	else
> @@ -465,6 +469,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	char *full_path = NULL;
>  	int desiredAccess;
>  	int disposition = FILE_OPEN;
> +	int create_options = CREATE_NOT_DIR;
>  	__u16 netfid;
>  
>  	xid = GetXid();
> @@ -524,6 +529,9 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  
>  	desiredAccess = cifs_convert_flags(pCifsFile->f_flags);
>  
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
>  	/* Can not refresh inode by passing in file_info buf to be returned
>  	   by SMBOpen and then calling get_inode_info with returned buf
>  	   since file might have write behind data that needs to be flushed
> @@ -531,7 +539,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	   that inode was not dirty locally we could do this */
>  
>  	rc = CIFSSMBOpen(xid, tcon, full_path, disposition, desiredAccess,
> -			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
> +			 create_options, &netfid, &oplock, NULL,
>  			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
>  				CIFS_MOUNT_MAP_SPECIAL_CHR);
>  	if (rc) {
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index db3f18c..8693b5d 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -183,14 +183,20 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
>  static int
>  CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
>  		    const char *fromName, const char *toName,
> -		    const struct nls_table *nls_codepage, int remap)
> +		    struct cifs_sb_info *cifs_sb)
>  {
>  	int rc;
>  	int oplock = 0;
> +	int remap;
> +	int create_options = CREATE_NOT_DIR;
>  	__u16 netfid = 0;
>  	u8 *buf;
>  	unsigned int bytes_written = 0;
>  	struct cifs_io_parms io_parms;
> +	struct nls_table *nls_codepage;
> +
> +	nls_codepage = cifs_sb->local_nls;
> +	remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>  
>  	buf = kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL);
>  	if (!buf)
> @@ -202,8 +208,11 @@ CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
>  		return rc;
>  	}
>  
> +	if (backup_cred(cifs_sb))
> +		create_options |= CREATE_OPEN_BACKUP_INTENT;
> +
>  	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
> -			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
> +			 create_options, &netfid, &oplock, NULL,
>  			 nls_codepage, remap);
>  	if (rc != 0) {
>  		kfree(buf);
> @@ -559,9 +568,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
>  	/* BB what if DFS and this volume is on different share? BB */
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>  		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
> -					 cifs_sb->local_nls,
> -					 cifs_sb->mnt_cifs_flags &
> -						CIFS_MOUNT_MAP_SPECIAL_CHR);
> +					cifs_sb);
>  	else if (pTcon->unix_ext)
>  		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
>  					   cifs_sb->local_nls);
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 7c16933..b68d2d5 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -676,3 +676,16 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
>  		cinode->clientCanCacheRead = false;
>  	}
>  }
> +
> +bool
> +backup_cred(struct cifs_sb_info *cifs_sb)
> +{
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> +		if ((cifs_sb->mnt_backupuid &&
> +				cifs_sb->backupuid == current_fsuid()) ||
> +				(cifs_sb->mnt_backupgid &&
> +					in_group_p(cifs_sb->backupgid)))
> +			return true;
> +	}
> +	return false;
> +}


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
