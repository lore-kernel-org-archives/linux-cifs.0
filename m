From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 03/45] CIFS: Separate protocol specific part from mkdir
Date: Wed, 18 Jul 2012 19:48:19 +0400
Message-ID: <1342626541-29872-4-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    7 +++++++
 fs/cifs/cifsproto.h |    4 +---
 fs/cifs/cifssmb.c   |    8 +++++---
 fs/cifs/inode.c     |   32 +++++++++++++-------------------
 fs/cifs/smb1ops.c   |   23 +++++++++++++++++++++++
 5 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5695693..1ae7531 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -246,6 +246,13 @@ struct smb_version_operations {
 	bool (*can_echo)(struct TCP_Server_Info *);
 	/* send echo request */
 	int (*echo)(struct TCP_Server_Info *);
+	/* create directory */
+	int (*mkdir)(const unsigned int, struct cifs_tcon *, const char *,
+		     struct cifs_sb_info *);
+	/* set info on created directory */
+	void (*mkdir_setinfo)(struct inode *, const char *,
+			      struct cifs_sb_info *, struct cifs_tcon *,
+			      const unsigned int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 51fbdf2..7e02362 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -295,9 +295,7 @@ extern int CIFSSMBUnixSetPathInfo(const unsigned int xid,
 				  int remap);
 
 extern int CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
-			const char *newName,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
+			const char *name, struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon,
 			const char *name, const struct nls_table *nls_codepage,
 			int remap_special_chars);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ed472aa..d49eedf 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -992,14 +992,15 @@ RmDirRetry:
 }
 
 int
-CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon,
-	     const char *name, const struct nls_table *nls_codepage, int remap)
+CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	     struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	CREATE_DIRECTORY_REQ *pSMB = NULL;
 	CREATE_DIRECTORY_RSP *pSMBr = NULL;
 	int bytes_returned;
 	int name_len;
+	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	cFYI(1, "In CIFSSMBMkDir");
 MkDirRetry:
@@ -1010,7 +1011,8 @@ MkDirRetry:
 
 	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
 		name_len = cifsConvertToUTF16((__le16 *) pSMB->DirName, name,
-					      PATH_MAX, nls_codepage, remap);
+					      PATH_MAX, cifs_sb->local_nls,
+					      remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {		/* BB improve check for buffer overruns BB */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index e9ba1a1..d7e74b1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1272,24 +1272,11 @@ cifs_mkdir_qinfo(struct inode *inode, struct dentry *dentry, umode_t mode,
 				       cifs_sb->mnt_cifs_flags &
 				       CIFS_MOUNT_MAP_SPECIAL_CHR);
 	} else {
+		struct TCP_Server_Info *server = tcon->ses->server;
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
-		    (mode & S_IWUGO) == 0) {
-			FILE_BASIC_INFO info;
-			struct cifsInodeInfo *cifsInode;
-			u32 dosattrs;
-			int tmprc;
-
-			memset(&info, 0, sizeof(info));
-			cifsInode = CIFS_I(newinode);
-			dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
-			info.Attributes = cpu_to_le32(dosattrs);
-			tmprc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info,
-						   cifs_sb->local_nls,
-						   cifs_sb->mnt_cifs_flags &
-						   CIFS_MOUNT_MAP_SPECIAL_CHR);
-			if (tmprc == 0)
-				cifsInode->cifsAttrs = dosattrs;
-		}
+		    (mode & S_IWUGO) == 0 && server->ops->mkdir_setinfo)
+			server->ops->mkdir_setinfo(newinode, full_path, cifs_sb,
+						   tcon, xid);
 		if (dentry->d_inode) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 				dentry->d_inode->i_mode = (mode | S_IFDIR);
@@ -1377,6 +1364,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	char *full_path;
 
 	cFYI(1, "In cifs_mkdir, mode = 0x%hx inode = 0x%p", mode, inode);
@@ -1403,9 +1391,15 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 			goto mkdir_out;
 	}
 
+	server = tcon->ses->server;
+
+	if (!server->ops->mkdir) {
+		rc = -ENOSYS;
+		goto mkdir_out;
+	}
+
 	/* BB add setting the equivalent of mode via CreateX w/ACLs */
-	rc = CIFSSMBMkDir(xid, tcon, full_path, cifs_sb->local_nls,
-			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	rc = server->ops->mkdir(xid, tcon, full_path, cifs_sb);
 	if (rc) {
 		cFYI(1, "cifs_mkdir returned 0x%x", rc);
 		d_drop(direntry);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index c40356d..861e2df 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -586,6 +586,27 @@ cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 #endif
 }
 
+static void
+cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
+		   struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
+		   const unsigned int xid)
+{
+	FILE_BASIC_INFO info;
+	struct cifsInodeInfo *cifsInode;
+	u32 dosattrs;
+	int rc;
+
+	memset(&info, 0, sizeof(info));
+	cifsInode = CIFS_I(inode);
+	dosattrs = cifsInode->cifsAttrs|ATTR_READONLY;
+	info.Attributes = cpu_to_le32(dosattrs);
+	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb->local_nls,
+				cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc == 0)
+		cifsInode->cifsAttrs = dosattrs;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -620,6 +641,8 @@ struct smb_version_operations smb1_operations = {
 	.get_srv_inum = cifs_get_srv_inum,
 	.build_path_to_root = cifs_build_path_to_root,
 	.echo = CIFSSMBEcho,
+	.mkdir = CIFSSMBMkDir,
+	.mkdir_setinfo = cifs_mkdir_setinfo,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
