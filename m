From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 33/45] CIFS: Move hardlink to ops struct
Date: Wed, 18 Jul 2012 19:48:49 +0400
Message-ID: <1342626541-29872-34-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    4 +++
 fs/cifs/cifsproto.h |    8 ++---
 fs/cifs/cifssmb.c   |   20 +++++++------
 fs/cifs/link.c      |   74 ++++++++++++++++++++++++++++++--------------------
 fs/cifs/smb1ops.c   |    1 +
 5 files changed, 63 insertions(+), 44 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0f8a466..de11b1f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -278,6 +278,10 @@ struct smb_version_operations {
 	/* send rename request */
 	int (*rename)(const unsigned int, struct cifs_tcon *, const char *,
 		      const char *, struct cifs_sb_info *);
+	/* send create hardlink request */
+	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
+			       const char *, const char *,
+			       struct cifs_sb_info *);
 	/* open a file for non-posix mounts */
 	int (*open)(const unsigned int, struct cifs_tcon *, const char *, int,
 		    int, int, struct cifs_fid *, __u32 *, FILE_ALL_INFO *,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ef94f36..06b90bb 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -316,11 +316,9 @@ extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
 				 int remap_special_chars);
-extern int CIFSCreateHardLink(const unsigned int xid,
-			struct cifs_tcon *tcon,
-			const char *fromName, const char *toName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+extern int CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
+			      const char *from_name, const char *to_name,
+			      struct cifs_sb_info *cifs_sb);
 extern int CIFSUnixCreateHardLink(const unsigned int xid,
 			struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c1a18a6..3029bf8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2921,8 +2921,8 @@ createHardLinkRetry:
 
 int
 CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
-		   const char *fromName, const char *toName,
-		   const struct nls_table *nls_codepage, int remap)
+		   const char *from_name, const char *to_name,
+		   struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	NT_RENAME_REQ *pSMB = NULL;
@@ -2930,6 +2930,7 @@ CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len, name_len2;
 	__u16 count;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSCreateHardLink");
 winCreateHardLinkRetry:
@@ -2949,8 +2950,8 @@ winCreateHardLinkRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, fromName,
-				       PATH_MAX, nls_codepage, remap);
+		    cifsConvertToUTF16((__le16 *) pSMB->OldFileName, from_name,
+				       PATH_MAX, cifs_sb->local_nls, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 
@@ -2959,17 +2960,18 @@ winCreateHardLinkRetry:
 		pSMB->OldFileName[name_len + 1] = 0x00; /* pad */
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
 		pSMB->OldFileName[name_len] = 0x04;	/* 2nd buffer format */
-		strncpy(&pSMB->OldFileName[name_len + 1], toName, name_len2);
+		strncpy(&pSMB->OldFileName[name_len + 1], to_name, name_len2);
 		name_len2++;	/* trailing null */
 		name_len2++;	/* signature byte */
 	}
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index d08b76c..169fa74 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -391,70 +391,84 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
 {
 	int rc = -EACCES;
 	unsigned int xid;
-	char *fromName = NULL;
-	char *toName = NULL;
+	char *from_name = NULL;
+	char *to_name = NULL;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifsInodeInfo *cifsInode;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
 
 	xid = get_xid();
 
-	fromName = build_path_from_dentry(old_file);
-	toName = build_path_from_dentry(direntry);
-	if ((fromName == NULL) || (toName == NULL)) {
+	from_name = build_path_from_dentry(old_file);
+	to_name = build_path_from_dentry(direntry);
+	if ((from_name == NULL) || (to_name == NULL)) {
 		rc = -ENOMEM;
 		goto cifs_hl_exit;
 	}
 
-	if (pTcon->unix_ext)
-		rc = CIFSUnixCreateHardLink(xid, pTcon, fromName, toName,
+	if (tcon->unix_ext)
+		rc = CIFSUnixCreateHardLink(xid, tcon, from_name, to_name,
 					    cifs_sb->local_nls,
 					    cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 	else {
-		rc = CIFSCreateHardLink(xid, pTcon, fromName, toName,
-					cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		server = tcon->ses->server;
+		if (!server->ops->create_hardlink)
+			return -ENOSYS;
+		rc = server->ops->create_hardlink(xid, tcon, from_name, to_name,
+						  cifs_sb);
 		if ((rc == -EIO) || (rc == -EINVAL))
 			rc = -EOPNOTSUPP;
 	}
 
 	d_drop(direntry);	/* force new lookup from server of target */
 
-	/* if source file is cached (oplocked) revalidate will not go to server
-	   until the file is closed or oplock broken so update nlinks locally */
+	/*
+	 * if source file is cached (oplocked) revalidate will not go to server
+	 * until the file is closed or oplock broken so update nlinks locally
+	 */
 	if (old_file->d_inode) {
 		cifsInode = CIFS_I(old_file->d_inode);
 		if (rc == 0) {
 			inc_nlink(old_file->d_inode);
-/* BB should we make this contingent on superblock flag NOATIME? */
-/*			old_file->d_inode->i_ctime = CURRENT_TIME;*/
-			/* parent dir timestamps will update from srv
-			within a second, would it really be worth it
-			to set the parent dir cifs inode time to zero
-			to force revalidate (faster) for it too? */
+			/*
+			 * BB should we make this contingent on superblock flag
+			 * NOATIME?
+			 */
+			/* old_file->d_inode->i_ctime = CURRENT_TIME; */
+			/*
+			 * parent dir timestamps will update from srv within a
+			 * second, would it really be worth it to set the parent
+			 * dir cifs inode time to zero to force revalidate
+			 * (faster) for it too?
+			 */
 		}
-		/* if not oplocked will force revalidate to get info
-		   on source file from srv */
+		/*
+		 * if not oplocked will force revalidate to get info on source
+		 * file from srv
+		 */
 		cifsInode->time = 0;
 
-		/* Will update parent dir timestamps from srv within a second.
-		   Would it really be worth it to set the parent dir (cifs
-		   inode) time field to zero to force revalidate on parent
-		   directory faster ie
-			CIFS_I(inode)->time = 0;  */
+		/*
+		 * Will update parent dir timestamps from srv within a second.
+		 * Would it really be worth it to set the parent dir (cifs
+		 * inode) time field to zero to force revalidate on parent
+		 * directory faster ie
+		 *
+		 * CIFS_I(inode)->time = 0;
+		 */
 	}
 
 cifs_hl_exit:
-	kfree(fromName);
-	kfree(toName);
+	kfree(from_name);
+	kfree(to_name);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
 	return rc;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3773920..e5d6344 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -801,6 +801,7 @@ struct smb_version_operations smb1_operations = {
 	.unlink = CIFSSMBDelFile,
 	.rename_pending_delete = cifs_rename_pending_delete,
 	.rename = CIFSSMBRename,
+	.create_hardlink = CIFSCreateHardLink,
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
-- 
1.7.1
