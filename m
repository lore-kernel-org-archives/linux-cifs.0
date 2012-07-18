From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 08/45] CIFS: Move unlink code to ops struct
Date: Wed, 18 Jul 2012 19:48:24 +0400
Message-ID: <1342626541-29872-9-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 ++++++
 fs/cifs/cifsproto.h |    9 ++++++---
 fs/cifs/cifssmb.c   |   16 ++++++++--------
 fs/cifs/inode.c     |   32 +++++++++++++++++++++-----------
 fs/cifs/smb1ops.c   |    2 ++
 5 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a5b4e82..bd53d97 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -256,6 +256,12 @@ struct smb_version_operations {
 	/* remove directory */
 	int (*rmdir)(const unsigned int, struct cifs_tcon *, const char *,
 		     struct cifs_sb_info *);
+	/* unlink file */
+	int (*unlink)(const unsigned int, struct cifs_tcon *, const char *,
+		      struct cifs_sb_info *);
+	/* open, rename and delete file */
+	int (*rename_pending_delete)(const char *, struct dentry *,
+				     const unsigned int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 43784ee..e9349af 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -144,6 +144,11 @@ extern int cifs_get_file_info_unix(struct file *filp);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
 			struct super_block *sb, unsigned int xid);
+extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
+			      unsigned int xid, char *full_path, __u32 dosattr);
+extern int cifs_rename_pending_delete(const char *full_path,
+				      struct dentry *dentry,
+				      const unsigned int xid);
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
@@ -303,9 +308,7 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			const struct nls_table *nls_codepage,
 			int remap_special_chars);
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *name,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			  const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *fromName, const char *toName,
 			const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9fb21cd..395f3e2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -902,15 +902,15 @@ PsxDelete:
 }
 
 int
-CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-	       const char *fileName, const struct nls_table *nls_codepage,
-	       int remap)
+CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	       struct cifs_sb_info *cifs_sb)
 {
 	DELETE_FILE_REQ *pSMB = NULL;
 	DELETE_FILE_RSP *pSMBr = NULL;
 	int rc = 0;
 	int bytes_returned;
 	int name_len;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 DelFileRetry:
 	rc = smb_init(SMB_COM_DELETE, 1, tcon, (void **) &pSMB,
@@ -919,15 +919,15 @@ DelFileRetry:
 		return rc;
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->fileName, fileName,
-				       PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->fileName, name,
+					      PATH_MAX, cifs_sb->local_nls,
+					      remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
-		name_len = strnlen(fileName, PATH_MAX);
+		name_len = strnlen(name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->fileName, fileName, name_len);
+		strncpy(pSMB->fileName, name, name_len);
 	}
 	pSMB->SearchAttributes =
 	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 88afb1a..9685eb1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -878,9 +878,9 @@ out:
 	return inode;
 }
 
-static int
+int
 cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
-		    char *full_path, __u32 dosattr)
+		   char *full_path, __u32 dosattr)
 {
 	int rc;
 	int oplock = 0;
@@ -995,13 +995,13 @@ out:
 }
 
 /*
- * open the given file (if it isn't already), set the DELETE_ON_CLOSE bit
+ * Open the given file (if it isn't already), set the DELETE_ON_CLOSE bit
  * and rename it to a random name that hopefully won't conflict with
  * anything else.
  */
-static int
-cifs_rename_pending_delete(char *full_path, struct dentry *dentry,
-			   unsigned int xid)
+int
+cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
+			   const unsigned int xid)
 {
 	int oplock = 0;
 	int rc;
@@ -1138,6 +1138,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
 
@@ -1147,6 +1148,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	xid = get_xid();
 
@@ -1169,8 +1171,12 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 retry_std_delete:
-	rc = CIFSSMBDelFile(xid, tcon, full_path, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (!server->ops->unlink) {
+		rc = -ENOSYS;
+		goto psx_del_no_retry;
+	}
+
+	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb);
 
 psx_del_no_retry:
 	if (!rc) {
@@ -1179,9 +1185,13 @@ psx_del_no_retry:
 	} else if (rc == -ENOENT) {
 		d_drop(dentry);
 	} else if (rc == -ETXTBSY) {
-		rc = cifs_rename_pending_delete(full_path, dentry, xid);
-		if (rc == 0)
-			cifs_drop_nlink(inode);
+		if (server->ops->rename_pending_delete) {
+			rc = server->ops->rename_pending_delete(full_path,
+								dentry, xid);
+			if (rc == 0)
+				cifs_drop_nlink(inode);
+		} else
+			rc = -ENOSYS;
 	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
 		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
 		if (attrs == NULL) {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3129ac7..725fa61 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -644,6 +644,8 @@ struct smb_version_operations smb1_operations = {
 	.mkdir = CIFSSMBMkDir,
 	.mkdir_setinfo = cifs_mkdir_setinfo,
 	.rmdir = CIFSSMBRmDir,
+	.unlink = CIFSSMBDelFile,
+	.rename_pending_delete = cifs_rename_pending_delete,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
