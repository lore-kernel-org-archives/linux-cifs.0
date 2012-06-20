From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 17/24] CIFS: Move query inode info code to ops struct
Date: Wed, 20 Jun 2012 18:30:57 +0400
Message-ID: <1340202664-28696-18-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    9 +++++
 fs/cifs/cifsproto.h |   14 +++----
 fs/cifs/cifssmb.c   |   11 +++---
 fs/cifs/inode.c     |   92 ++++++++++++++++++++-------------------------------
 fs/cifs/smb1ops.c   |   50 +++++++++++++++++++++++++++
 5 files changed, 106 insertions(+), 70 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9ce2d4c..ba372a5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -163,6 +163,7 @@ struct cifsFileInfo;
 struct cifs_ses;
 struct cifs_tcon;
 struct dfs_info3_param;
+struct cifs_fattr;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -218,6 +219,14 @@ struct smb_version_operations {
 	/* check if a path is accessible or not */
 	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
 				  struct cifs_sb_info *, const char *);
+	/* query path data from the server */
+	int (*query_path_info)(const unsigned int, struct cifs_tcon *,
+			       struct cifs_sb_info *, const char *,
+			       FILE_ALL_INFO *, bool *);
+	/* get server index number */
+	int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
+			    struct cifs_sb_info *, const char *,
+			    struct cifs_fattr *, FILE_ALL_INFO *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f0641ce..d5599cf 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -138,11 +138,9 @@ extern struct inode *cifs_iget(struct super_block *sb,
 			       struct cifs_fattr *fattr);
 
 extern int cifs_get_file_info(struct file *filp);
-extern int cifs_get_inode_info(struct inode **pinode,
-			const unsigned char *search_path,
-			FILE_ALL_INFO *pfile_info,
-			struct super_block *sb, unsigned int xid,
-			const __u16 *pfid);
+extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
+			       FILE_ALL_INFO *data, struct super_block *sb,
+			       int xid, const __u16 *fid);
 extern int cifs_get_file_info_unix(struct file *filp);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
@@ -376,9 +374,9 @@ extern int CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 			unsigned int *nbytes, struct kvec *iov, const int nvec,
 			const int long_op);
 extern int CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
-			const unsigned char *searchName, __u64 *inode_number,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+				 const char *search_name, __u64 *inode_number,
+				 const struct nls_table *nls_codepage,
+				 int remap);
 
 extern int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		      const __u16 netfid, const __u8 lock_type,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 177ea5e..6dc0686 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4540,8 +4540,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
-		      const unsigned char *searchName,
-		      __u64 *inode_number,
+		      const char *search_name, __u64 *inode_number,
 		      const struct nls_table *nls_codepage, int remap)
 {
 	int rc = 0;
@@ -4550,7 +4549,7 @@ CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len, bytes_returned;
 	__u16 params, byte_count;
 
-	cFYI(1, "In GetSrvInodeNum for %s", searchName);
+	cFYI(1, "In GetSrvInodeNum for %s", search_name);
 	if (tcon == NULL)
 		return -ENODEV;
 
@@ -4563,14 +4562,14 @@ GetInodeNumberRetry:
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
 			cifsConvertToUTF16((__le16 *) pSMB->FileName,
-					   searchName, PATH_MAX, nls_codepage,
+					   search_name, PATH_MAX, nls_codepage,
 					   remap);
 		name_len++;     /* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(searchName, PATH_MAX);
+		name_len = strnlen(search_name, PATH_MAX);
 		name_len++;     /* trailing null */
-		strncpy(pSMB->FileName, searchName, name_len);
+		strncpy(pSMB->FileName, search_name, name_len);
 	}
 
 	params = 2 /* level */  + 4 /* rsrvd */  + name_len /* incl null */ ;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 089939c..000c9f9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -600,61 +600,54 @@ cgfi_exit:
 	return rc;
 }
 
-int cifs_get_inode_info(struct inode **pinode,
-	const unsigned char *full_path, FILE_ALL_INFO *pfindData,
-	struct super_block *sb, unsigned int xid, const __u16 *pfid)
+int
+cifs_get_inode_info(struct inode **inode, const char *full_path,
+		    FILE_ALL_INFO *data, struct super_block *sb, int xid,
+		    const __u16 *fid)
 {
 	int rc = 0, tmprc;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	char *buf = NULL;
-	bool adjustTZ = false;
+	bool adjust_tz = false;
 	struct cifs_fattr fattr;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	cFYI(1, "Getting info on %s", full_path);
 
-	if ((pfindData == NULL) && (*pinode != NULL)) {
-		if (CIFS_I(*pinode)->clientCanCacheRead) {
+	if ((data == NULL) && (*inode != NULL)) {
+		if (CIFS_I(*inode)->clientCanCacheRead) {
 			cFYI(1, "No need to revalidate cached inode sizes");
 			goto cgii_exit;
 		}
 	}
 
-	/* if file info not passed in then get it from server */
-	if (pfindData == NULL) {
+	/* if inode info is not passed, get it from server */
+	if (data == NULL) {
+		if (!server->ops->query_path_info) {
+			rc = -ENOSYS;
+			goto cgii_exit;
+		}
 		buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 		if (buf == NULL) {
 			rc = -ENOMEM;
 			goto cgii_exit;
 		}
-		pfindData = (FILE_ALL_INFO *)buf;
-
-		/* could do find first instead but this returns more info */
-		rc = CIFSSMBQPathInfo(xid, pTcon, full_path, pfindData,
-			      0 /* not legacy */,
-			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-		/* BB optimize code so we do not make the above call
-		when server claims no NT SMB support and the above call
-		failed at least once - set flag in tcon or mount */
-		if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
-			rc = SMBQueryInformation(xid, pTcon, full_path,
-					pfindData, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					  CIFS_MOUNT_MAP_SPECIAL_CHR);
-			adjustTZ = true;
-		}
+		data = (FILE_ALL_INFO *)buf;
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path,
+						  data, &adjust_tz);
 	}
 
 	if (!rc) {
-		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *) pfindData,
-				       cifs_sb, adjustTZ);
+		cifs_all_info_to_fattr(&fattr, (FILE_ALL_INFO *)data, cifs_sb,
+				       adjust_tz);
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, sb);
 		rc = 0;
@@ -668,28 +661,16 @@ int cifs_get_inode_info(struct inode **pinode,
 	 * Is an i_ino of zero legal? Can we use that to check if the server
 	 * supports returning inode numbers?  Are there other sanity checks we
 	 * can use to ensure that the server is really filling in that field?
-	 *
-	 * We can not use the IndexNumber field by default from Windows or
-	 * Samba (in ALL_INFO buf) but we can request it explicitly. The SNIA
-	 * CIFS spec claims that this value is unique within the scope of a
-	 * share, and the windows docs hint that it's actually unique
-	 * per-machine.
-	 *
-	 * There may be higher info levels that work but are there Windows
-	 * server or network appliances for which IndexNumber field is not
-	 * guaranteed unique?
 	 */
-	if (*pinode == NULL) {
+	if (*inode == NULL) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-			int rc1 = 0;
-
-			rc1 = CIFSGetSrvInodeNumber(xid, pTcon,
-					full_path, &fattr.cf_uniqueid,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			if (rc1 || !fattr.cf_uniqueid) {
-				cFYI(1, "GetSrvInodeNum rc %d", rc1);
+			if (server->ops->get_srv_inum)
+				tmprc = server->ops->get_srv_inum(xid, tcon,
+					cifs_sb, full_path, &fattr, data);
+			else
+				tmprc = -ENOSYS;
+			if (tmprc || !fattr.cf_uniqueid) {
+				cFYI(1, "GetSrvInodeNum rc %d", tmprc);
 				fattr.cf_uniqueid = iunique(sb, ROOT_I);
 				cifs_autodisable_serverino(cifs_sb);
 			}
@@ -697,7 +678,7 @@ int cifs_get_inode_info(struct inode **pinode,
 			fattr.cf_uniqueid = iunique(sb, ROOT_I);
 		}
 	} else {
-		fattr.cf_uniqueid = CIFS_I(*pinode)->uniqueid;
+		fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
 	}
 
 	/* query for SFU type info if supported and needed */
@@ -711,8 +692,7 @@ int cifs_get_inode_info(struct inode **pinode,
 #ifdef CONFIG_CIFS_ACL
 	/* fill in 0777 bits from ACL */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path,
-						pfid);
+		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, full_path, fid);
 		if (rc) {
 			cFYI(1, "%s: Getting ACL failed with error: %d",
 				__func__, rc);
@@ -732,12 +712,12 @@ int cifs_get_inode_info(struct inode **pinode,
 			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
 	}
 
-	if (!*pinode) {
-		*pinode = cifs_iget(sb, &fattr);
-		if (!*pinode)
+	if (!*inode) {
+		*inode = cifs_iget(sb, &fattr);
+		if (!*inode)
 			rc = -ENOMEM;
 	} else {
-		cifs_fattr_to_inode(*pinode, &fattr);
+		cifs_fattr_to_inode(*inode, &fattr);
 	}
 
 cgii_exit:
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 43f3881..9241300 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -441,6 +441,54 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int
+cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
+		     struct cifs_sb_info *cifs_sb, const char *full_path,
+		     FILE_ALL_INFO *data, bool *adjustTZ)
+{
+	int rc;
+
+	/* could do find first instead but this returns more info */
+	rc = CIFSSMBQPathInfo(xid, tcon, full_path, data, 0 /* not legacy */,
+			      cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	/*
+	 * BB optimize code so we do not make the above call when server claims
+	 * no NT SMB support and the above call failed at least once - set flag
+	 * in tcon or mount.
+	 */
+	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
+		rc = SMBQueryInformation(xid, tcon, full_path, data,
+					 cifs_sb->local_nls,
+					 cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		*adjustTZ = true;
+	}
+	return rc;
+}
+
+static int
+cifs_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
+		  struct cifs_sb_info *cifs_sb, const char *full_path,
+		  struct cifs_fattr *fattr, FILE_ALL_INFO *data)
+{
+	/*
+	 * We can not use the IndexNumber field by default from Windows or
+	 * Samba (in ALL_INFO buf) but we can request it explicitly. The SNIA
+	 * CIFS spec claims that this value is unique within the scope of a
+	 * share, and the windows docs hint that it's actually unique
+	 * per-machine.
+	 *
+	 * There may be higher info levels that work but are there Windows
+	 * server or network appliances for which IndexNumber field is not
+	 * guaranteed unique?
+	 */
+	return CIFSGetSrvInodeNumber(xid, tcon, full_path, &fattr->cf_uniqueid,
+				     cifs_sb->local_nls,
+				     cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -468,6 +516,8 @@ struct smb_version_operations smb1_operations = {
 	.get_dfs_refer = CIFSGetDFSRefer,
 	.qfs_tcon = cifs_qfs_tcon,
 	.is_path_accessible = cifs_is_path_accessible,
+	.query_path_info = cifs_query_path_info,
+	.get_srv_inum = cifs_get_srv_inum,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
