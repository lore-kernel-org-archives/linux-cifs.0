From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 31/45] CIFS: Move rename to ops struct
Date: Wed, 18 Jul 2012 19:48:47 +0400
Message-ID: <1342626541-29872-32-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 ++
 fs/cifs/cifsproto.h |    5 +--
 fs/cifs/cifssmb.c   |   22 +++++++-----
 fs/cifs/inode.c     |   92 ++++++++++++++++++++++++++------------------------
 fs/cifs/smb1ops.c   |    1 +
 5 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 78ce424..0f8a466 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -275,6 +275,9 @@ struct smb_version_operations {
 	/* open, rename and delete file */
 	int (*rename_pending_delete)(const char *, struct dentry *,
 				     const unsigned int);
+	/* send rename request */
+	int (*rename)(const unsigned int, struct cifs_tcon *, const char *,
+		      const char *, struct cifs_sb_info *);
 	/* open a file for non-posix mounts */
 	int (*open)(const unsigned int, struct cifs_tcon *, const char *, int,
 		    int, int, struct cifs_fid *, __u32 *, FILE_ALL_INFO *,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 722dba8..ef94f36 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -310,9 +310,8 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			  const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			 const char *from_name, const char *to_name,
+			 struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 666535c..c1a18a6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2528,8 +2528,8 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 
 int
 CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
-	      const char *fromName, const char *toName,
-	      const struct nls_table *nls_codepage, int remap)
+	      const char *from_name, const char *to_name,
+	      struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	RENAME_REQ *pSMB = NULL;
@@ -2537,6 +2537,7 @@ CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len, name_len2;
 	__u16 count;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBRename");
 renameRetry:
@@ -2551,9 +2552,9 @@ renameRetry:
 			ATTR_DIRECTORY);
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, fromName,
-				       PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
+					      from_name, PATH_MAX,
+					      cifs_sb->local_nls, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 		pSMB->OldFileName[name_len] = 0x04;	/* pad */
@@ -2561,17 +2562,18 @@ renameRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00;
 		name_len2 =
 		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
-				       toName, PATH_MAX, nls_codepage, remap);
+				       to_name, PATH_MAX, cifs_sb->local_nls,
+				       remap);
 		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
 		name_len2 *= 2;	/* convert to bytes */
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(fromName, PATH_MAX);
+		name_len = strnlen(from_name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->OldFileName, fromName, name_len);
-		name_len2 = strnlen(toName, PATH_MAX);
+		strncpy(pSMB->OldFileName, from_name, name_len);
+		name_len2 = strnlen(to_name, PATH_MAX);
 		name_len2++;	/* trailing null */
 		pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
-		strncpy(&pSMB->OldFileName[name_len + 1], toName, name_len2);
+		strncpy(&pSMB->OldFileName[name_len + 1], to_name, name_len2);
 		name_len2++;	/* trailing null */
 		name_len2++;	/* signature byte */
 	}
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 39ef1a6..f1448d9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1512,29 +1512,32 @@ rmdir_exit:
 }
 
 static int
-cifs_do_rename(unsigned int xid, struct dentry *from_dentry,
-	       const char *fromPath, struct dentry *to_dentry,
-	       const char *toPath)
+cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
+	       const char *from_path, struct dentry *to_dentry,
+	       const char *to_path)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(from_dentry->d_sb);
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	__u16 srcfid;
 	int oplock, rc;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	if (!server->ops->rename)
+		return -ENOSYS;
 
 	/* try path-based rename first */
-	rc = CIFSSMBRename(xid, pTcon, fromPath, toPath, cifs_sb->local_nls,
-			   cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb);
 
 	/*
-	 * don't bother with rename by filehandle unless file is busy and
-	 * source Note that cross directory moves do not work with
+	 * Don't bother with rename by filehandle unless file is busy and
+	 * source. Note that cross directory moves do not work with
 	 * rename by filehandle to various Windows servers.
 	 */
 	if (rc == 0 || rc != -ETXTBSY)
@@ -1545,29 +1548,28 @@ cifs_do_rename(unsigned int xid, struct dentry *from_dentry,
 		goto do_rename_exit;
 
 	/* open the file to be renamed -- we need DELETE perms */
-	rc = CIFSSMBOpen(xid, pTcon, fromPath, FILE_OPEN, DELETE,
+	rc = CIFSSMBOpen(xid, tcon, from_path, FILE_OPEN, DELETE,
 			 CREATE_NOT_DIR, &srcfid, &oplock, NULL,
 			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
-
 	if (rc == 0) {
-		rc = CIFSSMBRenameOpenFile(xid, pTcon, srcfid,
+		rc = CIFSSMBRenameOpenFile(xid, tcon, srcfid,
 				(const char *) to_dentry->d_name.name,
 				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
-
-		CIFSSMBClose(xid, pTcon, srcfid);
+		CIFSSMBClose(xid, tcon, srcfid);
 	}
 do_rename_exit:
 	cifs_put_tlink(tlink);
 	return rc;
 }
 
-int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
-	struct inode *target_dir, struct dentry *target_dentry)
+int
+cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
+	    struct inode *target_dir, struct dentry *target_dentry)
 {
-	char *fromName = NULL;
-	char *toName = NULL;
+	char *from_name = NULL;
+	char *to_name = NULL;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
@@ -1588,25 +1590,25 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	 * we already have the rename sem so we do not need to
 	 * grab it again here to protect the path integrity
 	 */
-	fromName = build_path_from_dentry(source_dentry);
-	if (fromName == NULL) {
+	from_name = build_path_from_dentry(source_dentry);
+	if (from_name == NULL) {
 		rc = -ENOMEM;
 		goto cifs_rename_exit;
 	}
 
-	toName = build_path_from_dentry(target_dentry);
-	if (toName == NULL) {
+	to_name = build_path_from_dentry(target_dentry);
+	if (to_name == NULL) {
 		rc = -ENOMEM;
 		goto cifs_rename_exit;
 	}
 
-	rc = cifs_do_rename(xid, source_dentry, fromName,
-			    target_dentry, toName);
+	rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
+			    to_name);
 
 	if (rc == -EEXIST && tcon->unix_ext) {
 		/*
-		 * Are src and dst hardlinks of same inode? We can
-		 * only tell with unix extensions enabled
+		 * Are src and dst hardlinks of same inode? We can only tell
+		 * with unix extensions enabled.
 		 */
 		info_buf_source =
 			kmalloc(2 * sizeof(FILE_UNIX_BASIC_INFO),
@@ -1617,19 +1619,19 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 		}
 
 		info_buf_target = info_buf_source + 1;
-		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, fromName,
-					info_buf_source,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, from_name,
+					     info_buf_source,
+					     cifs_sb->local_nls,
+					     cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if (tmprc != 0)
 			goto unlink_target;
 
-		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, toName,
-					info_buf_target,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
+		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, to_name,
+					     info_buf_target,
+					     cifs_sb->local_nls,
+					     cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
 
 		if (tmprc == 0 && (info_buf_source->UniqueId ==
 				   info_buf_target->UniqueId)) {
@@ -1637,8 +1639,11 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 			rc = 0;
 			goto cifs_rename_exit;
 		}
-	} /* else ... BB we could add the same check for Windows by
-		     checking the UniqueId via FILE_INTERNAL_INFO */
+	}
+	/*
+	 * else ... BB we could add the same check for Windows by
+	 * checking the UniqueId via FILE_INTERNAL_INFO
+	 */
 
 unlink_target:
 	/* Try unlinking the target dentry if it's not negative */
@@ -1646,15 +1651,14 @@ unlink_target:
 		tmprc = cifs_unlink(target_dir, target_dentry);
 		if (tmprc)
 			goto cifs_rename_exit;
-
-		rc = cifs_do_rename(xid, source_dentry, fromName,
-				    target_dentry, toName);
+		rc = cifs_do_rename(xid, source_dentry, from_name,
+				    target_dentry, to_name);
 	}
 
 cifs_rename_exit:
 	kfree(info_buf_source);
-	kfree(fromName);
-	kfree(toName);
+	kfree(from_name);
+	kfree(to_name);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
 	return rc;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index aa55c2f..3773920 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -800,6 +800,7 @@ struct smb_version_operations smb1_operations = {
 	.rmdir = CIFSSMBRmDir,
 	.unlink = CIFSSMBDelFile,
 	.rename_pending_delete = cifs_rename_pending_delete,
+	.rename = CIFSSMBRename,
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
-- 
1.7.1
