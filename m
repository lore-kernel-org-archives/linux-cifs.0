From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 05/45] CIFS: Move rmdir code to ops struct
Date: Wed, 18 Jul 2012 19:48:21 +0400
Message-ID: <1342626541-29872-6-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/cifsproto.h |    3 +--
 fs/cifs/cifssmb.c   |   15 ++++++++-------
 fs/cifs/inode.c     |   15 +++++++++++----
 fs/cifs/smb1ops.c   |    1 +
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1ae7531..a5b4e82 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -253,6 +253,9 @@ struct smb_version_operations {
 	void (*mkdir_setinfo)(struct inode *, const char *,
 			      struct cifs_sb_info *, struct cifs_tcon *,
 			      const unsigned int);
+	/* remove directory */
+	int (*rmdir)(const unsigned int, struct cifs_tcon *, const char *,
+		     struct cifs_sb_info *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7e02362..43784ee 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -297,8 +297,7 @@ extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
 extern int CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *name, const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, __u16 type,
 			const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d49eedf..9fb21cd 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -948,15 +948,15 @@ DelFileRetry:
 }
 
 int
-CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *dirName, const struct nls_table *nls_codepage,
-	     int remap)
+CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	     struct cifs_sb_info *cifs_sb)
 {
 	DELETE_DIRECTORY_REQ *pSMB = NULL;
 	DELETE_DIRECTORY_RSP *pSMBr = NULL;
 	int rc = 0;
 	int bytes_returned;
 	int name_len;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBRmDir");
 RmDirRetry:
@@ -966,14 +966,15 @@ RmDirRetry:
 		return rc;
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, dirName,
-					      PATH_MAX, nls_codepage, remap);
+		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, name,
+					      PATH_MAX, cifs_sb->local_nls,
+					      remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
-		name_len = strnlen(dirName, PATH_MAX);
+		name_len = strnlen(name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->DirName, dirName, name_len);
+		strncpy(pSMB->DirName, name, name_len);
 	}
 
 	pSMB->BufferFormat = 0x04;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index d7e74b1..7354877 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1426,7 +1426,8 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	char *full_path = NULL;
 	struct cifsInodeInfo *cifsInode;
 
@@ -1446,10 +1447,16 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 		rc = PTR_ERR(tlink);
 		goto rmdir_exit;
 	}
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	if (!server->ops->rmdir) {
+		rc = -ENOSYS;
+		cifs_put_tlink(tlink);
+		goto rmdir_exit;
+	}
 
-	rc = CIFSSMBRmDir(xid, pTcon, full_path, cifs_sb->local_nls,
-			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
 	cifs_put_tlink(tlink);
 
 	if (!rc) {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 861e2df..3129ac7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -643,6 +643,7 @@ struct smb_version_operations smb1_operations = {
 	.echo = CIFSSMBEcho,
 	.mkdir = CIFSSMBMkDir,
 	.mkdir_setinfo = cifs_mkdir_setinfo,
+	.rmdir = CIFSSMBRmDir,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
