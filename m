From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 02/45] CIFS: Simpliify cifs_mkdir call
Date: Wed, 18 Jul 2012 19:48:18 +0400
Message-ID: <1342626541-29872-3-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/cifssmb.c   |    8 +-
 fs/cifs/inode.c     |  295 ++++++++++++++++++++++++++++-----------------------
 3 files changed, 167 insertions(+), 140 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 5aadeec..51fbdf2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -289,10 +289,10 @@ extern int CIFSSMBUnixSetFileInfo(const unsigned int xid,
 				  u16 fid, u32 pid_of_opener);
 
 extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
-				  struct cifs_tcon *tcon, char *file_name,
+				  struct cifs_tcon *tcon, const char *file_name,
 				  const struct cifs_unix_set_info_args *args,
 				  const struct nls_table *nls_codepage,
-				  int remap_special_chars);
+				  int remap);
 
 extern int CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *newName,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 846b803..ed472aa 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5945,7 +5945,7 @@ CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBUnixSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
-		       char *fileName,
+		       const char *file_name,
 		       const struct cifs_unix_set_info_args *args,
 		       const struct nls_table *nls_codepage, int remap)
 {
@@ -5966,14 +5966,14 @@ setPermsRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->FileName, fileName,
+		    cifsConvertToUTF16((__le16 *) pSMB->FileName, file_name,
 				       PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(fileName, PATH_MAX);
+		name_len = strnlen(file_name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->FileName, fileName, name_len);
+		strncpy(pSMB->FileName, file_name, name_len);
 	}
 
 	params = 6 + name_len;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 35cb6a3..e9ba1a1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1219,16 +1219,165 @@ unlink_out:
 	return rc;
 }
 
+static int
+cifs_mkdir_qinfo(struct inode *inode, struct dentry *dentry, umode_t mode,
+		 const char *full_path, struct cifs_sb_info *cifs_sb,
+		 struct cifs_tcon *tcon, const unsigned int xid)
+{
+	int rc = 0;
+	struct inode *newinode = NULL;
+
+	if (tcon->unix_ext)
+		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
+					      xid);
+	else
+		rc = cifs_get_inode_info(&newinode, full_path, NULL,
+					 inode->i_sb, xid, NULL);
+	if (rc)
+		return rc;
+
+	d_instantiate(dentry, newinode);
+	/*
+	 * setting nlink not necessary except in cases where we failed to get it
+	 * from the server or was set bogus
+	 */
+	if ((dentry->d_inode) && (dentry->d_inode->i_nlink < 2))
+		set_nlink(dentry->d_inode, 2);
+
+	mode &= ~current_umask();
+	/* must turn on setgid bit if parent dir has it */
+	if (inode->i_mode & S_ISGID)
+		mode |= S_ISGID;
+
+	if (tcon->unix_ext) {
+		struct cifs_unix_set_info_args args = {
+			.mode	= mode,
+			.ctime	= NO_CHANGE_64,
+			.atime	= NO_CHANGE_64,
+			.mtime	= NO_CHANGE_64,
+			.device	= 0,
+		};
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+			args.uid = (__u64)current_fsuid();
+			if (inode->i_mode & S_ISGID)
+				args.gid = (__u64)inode->i_gid;
+			else
+				args.gid = (__u64)current_fsgid();
+		} else {
+			args.uid = NO_CHANGE_64;
+			args.gid = NO_CHANGE_64;
+		}
+		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
+				       cifs_sb->local_nls,
+				       cifs_sb->mnt_cifs_flags &
+				       CIFS_MOUNT_MAP_SPECIAL_CHR);
+	} else {
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+		    (mode & S_IWUGO) == 0) {
+			FILE_BASIC_INFO info;
+			struct cifsInodeInfo *cifsInode;
+			u32 dosattrs;
+			int tmprc;
+
+			memset(&info, 0, sizeof(info));
+			cifsInode = CIFS_I(newinode);
+			dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
+			info.Attributes = cpu_to_le32(dosattrs);
+			tmprc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info,
+						   cifs_sb->local_nls,
+						   cifs_sb->mnt_cifs_flags &
+						   CIFS_MOUNT_MAP_SPECIAL_CHR);
+			if (tmprc == 0)
+				cifsInode->cifsAttrs = dosattrs;
+		}
+		if (dentry->d_inode) {
+			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+				dentry->d_inode->i_mode = (mode | S_IFDIR);
+
+			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+				dentry->d_inode->i_uid = current_fsuid();
+				if (inode->i_mode & S_ISGID)
+					dentry->d_inode->i_gid = inode->i_gid;
+				else
+					dentry->d_inode->i_gid =
+								current_fsgid();
+			}
+		}
+	}
+	return rc;
+}
+
+static int
+cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
+		 const char *full_path, struct cifs_sb_info *cifs_sb,
+		 struct cifs_tcon *tcon, const unsigned int xid)
+{
+	int rc = 0;
+	u32 oplock = 0;
+	FILE_UNIX_BASIC_INFO *info = NULL;
+	struct inode *newinode = NULL;
+	struct cifs_fattr fattr;
+
+	info = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
+	if (info == NULL) {
+		rc = -ENOMEM;
+		goto posix_mkdir_out;
+	}
+
+	mode &= ~current_umask();
+	rc = CIFSPOSIXCreate(xid, tcon, SMB_O_DIRECTORY | SMB_O_CREAT, mode,
+			     NULL /* netfid */, info, &oplock, full_path,
+			     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+			     CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc == -EOPNOTSUPP)
+		goto posix_mkdir_out;
+	else if (rc) {
+		cFYI(1, "posix mkdir returned 0x%x", rc);
+		d_drop(dentry);
+		goto posix_mkdir_out;
+	}
+
+	if (info->Type == cpu_to_le32(-1))
+		/* no return info, go query for it */
+		goto posix_mkdir_get_info;
+	/*
+	 * BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if
+	 * need to set uid/gid.
+	 */
+
+	cifs_unix_basic_to_fattr(&fattr, info, cifs_sb);
+	cifs_fill_uniqueid(inode->i_sb, &fattr);
+	newinode = cifs_iget(inode->i_sb, &fattr);
+	if (!newinode)
+		goto posix_mkdir_get_info;
+
+	d_instantiate(dentry, newinode);
+
+#ifdef CONFIG_CIFS_DEBUG2
+	cFYI(1, "instantiated dentry %p %s to inode %p", dentry,
+	     dentry->d_name.name, newinode);
+
+	if (newinode->i_nlink != 2)
+		cFYI(1, "unexpected number of links %d", newinode->i_nlink);
+#endif
+
+posix_mkdir_out:
+	kfree(info);
+	return rc;
+posix_mkdir_get_info:
+	rc = cifs_mkdir_qinfo(inode, dentry, mode, full_path, cifs_sb, tcon,
+			      xid);
+	goto posix_mkdir_out;
+}
+
 int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 {
-	int rc = 0, tmprc;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	char *full_path = NULL;
-	struct inode *newinode = NULL;
-	struct cifs_fattr fattr;
+	char *full_path;
 
 	cFYI(1, "In cifs_mkdir, mode = 0x%hx inode = 0x%p", mode, inode);
 
@@ -1248,145 +1397,23 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 
 	if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		u32 oplock = 0;
-		FILE_UNIX_BASIC_INFO *pInfo =
-			kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
-		if (pInfo == NULL) {
-			rc = -ENOMEM;
+		rc = cifs_posix_mkdir(inode, direntry, mode, full_path, cifs_sb,
+				      tcon, xid);
+		if (rc != -EOPNOTSUPP)
 			goto mkdir_out;
-		}
-
-		mode &= ~current_umask();
-		rc = CIFSPOSIXCreate(xid, tcon, SMB_O_DIRECTORY | SMB_O_CREAT,
-				mode, NULL /* netfid */, pInfo, &oplock,
-				full_path, cifs_sb->local_nls,
-				cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (rc == -EOPNOTSUPP) {
-			kfree(pInfo);
-			goto mkdir_retry_old;
-		} else if (rc) {
-			cFYI(1, "posix mkdir returned 0x%x", rc);
-			d_drop(direntry);
-		} else {
-			if (pInfo->Type == cpu_to_le32(-1)) {
-				/* no return info, go query for it */
-				kfree(pInfo);
-				goto mkdir_get_info;
-			}
-/*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if need
-	to set uid/gid */
-
-			cifs_unix_basic_to_fattr(&fattr, pInfo, cifs_sb);
-			cifs_fill_uniqueid(inode->i_sb, &fattr);
-			newinode = cifs_iget(inode->i_sb, &fattr);
-			if (!newinode) {
-				kfree(pInfo);
-				goto mkdir_get_info;
-			}
-
-			d_instantiate(direntry, newinode);
-
-#ifdef CONFIG_CIFS_DEBUG2
-			cFYI(1, "instantiated dentry %p %s to inode %p",
-				direntry, direntry->d_name.name, newinode);
-
-			if (newinode->i_nlink != 2)
-				cFYI(1, "unexpected number of links %d",
-					newinode->i_nlink);
-#endif
-		}
-		kfree(pInfo);
-		goto mkdir_out;
 	}
-mkdir_retry_old:
+
 	/* BB add setting the equivalent of mode via CreateX w/ACLs */
 	rc = CIFSSMBMkDir(xid, tcon, full_path, cifs_sb->local_nls,
 			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
 		cFYI(1, "cifs_mkdir returned 0x%x", rc);
 		d_drop(direntry);
-	} else {
-mkdir_get_info:
-		if (tcon->unix_ext)
-			rc = cifs_get_inode_info_unix(&newinode, full_path,
-						      inode->i_sb, xid);
-		else
-			rc = cifs_get_inode_info(&newinode, full_path, NULL,
-						 inode->i_sb, xid, NULL);
-
-		d_instantiate(direntry, newinode);
-		 /* setting nlink not necessary except in cases where we
-		  * failed to get it from the server or was set bogus */
-		if ((direntry->d_inode) && (direntry->d_inode->i_nlink < 2))
-			set_nlink(direntry->d_inode, 2);
-
-		mode &= ~current_umask();
-		/* must turn on setgid bit if parent dir has it */
-		if (inode->i_mode & S_ISGID)
-			mode |= S_ISGID;
-
-		if (tcon->unix_ext) {
-			struct cifs_unix_set_info_args args = {
-				.mode	= mode,
-				.ctime	= NO_CHANGE_64,
-				.atime	= NO_CHANGE_64,
-				.mtime	= NO_CHANGE_64,
-				.device	= 0,
-			};
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-				args.uid = (__u64)current_fsuid();
-				if (inode->i_mode & S_ISGID)
-					args.gid = (__u64)inode->i_gid;
-				else
-					args.gid = (__u64)current_fsgid();
-			} else {
-				args.uid = NO_CHANGE_64;
-				args.gid = NO_CHANGE_64;
-			}
-			CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
-					       cifs_sb->local_nls,
-					       cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-		} else {
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
-			    (mode & S_IWUGO) == 0) {
-				FILE_BASIC_INFO pInfo;
-				struct cifsInodeInfo *cifsInode;
-				u32 dosattrs;
-
-				memset(&pInfo, 0, sizeof(pInfo));
-				cifsInode = CIFS_I(newinode);
-				dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
-				pInfo.Attributes = cpu_to_le32(dosattrs);
-				tmprc = CIFSSMBSetPathInfo(xid, tcon,
-						full_path, &pInfo,
-						cifs_sb->local_nls,
-						cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-				if (tmprc == 0)
-					cifsInode->cifsAttrs = dosattrs;
-			}
-			if (direntry->d_inode) {
-				if (cifs_sb->mnt_cifs_flags &
-				     CIFS_MOUNT_DYNPERM)
-					direntry->d_inode->i_mode =
-						(mode | S_IFDIR);
-
-				if (cifs_sb->mnt_cifs_flags &
-				     CIFS_MOUNT_SET_UID) {
-					direntry->d_inode->i_uid =
-						current_fsuid();
-					if (inode->i_mode & S_ISGID)
-						direntry->d_inode->i_gid =
-							inode->i_gid;
-					else
-						direntry->d_inode->i_gid =
-							current_fsgid();
-				}
-			}
-		}
+		goto mkdir_out;
 	}
+
+	rc = cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb, tcon,
+			      xid);
 mkdir_out:
 	/*
 	 * Force revalidate to get parent dir info when needed since cached
-- 
1.7.1
