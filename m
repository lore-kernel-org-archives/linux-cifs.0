From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 37/45] CIFS: Move set_file_info to ops struct
Date: Wed, 18 Jul 2012 19:48:53 +0400
Message-ID: <1342626541-29872-38-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 ++
 fs/cifs/inode.c    |   79 ++++------------------------------------------------
 fs/cifs/smb1ops.c  |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 73 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3f7a53d..7c20d5a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -258,6 +258,9 @@ struct smb_version_operations {
 	/* set size by file handle */
 	int (*set_file_size)(const unsigned int, struct cifs_tcon *,
 			     struct cifsFileInfo *, __u64, bool);
+	/* set attributes */
+	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
+			     const unsigned int);
 	/* build a full path to the root of the mount */
 	char * (*build_path_to_root)(struct smb_vol *, struct cifs_sb_info *,
 				     struct cifs_tcon *);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 16101a0..92c6c27 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -888,21 +888,18 @@ int
 cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 		   char *full_path, __u32 dosattr)
 {
-	int rc;
-	int oplock = 0;
-	__u16 netfid;
-	__u32 netpid;
 	bool set_time = false;
-	struct cifsFileInfo *open_file;
-	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct tcon_link *tlink = NULL;
-	struct cifs_tcon *pTcon;
+	struct TCP_Server_Info *server;
 	FILE_BASIC_INFO	info_buf;
 
 	if (attrs == NULL)
 		return -EINVAL;
 
+	server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+	if (!server->ops->set_file_info)
+		return -ENOSYS;
+
 	if (attrs->ia_valid & ATTR_ATIME) {
 		set_time = true;
 		info_buf.LastAccessTime =
@@ -933,71 +930,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	info_buf.CreationTime = 0;	/* don't change */
 	info_buf.Attributes = cpu_to_le32(dosattr);
 
-	/*
-	 * If the file is already open for write, just use that fileid
-	 */
-	open_file = find_writable_file(cifsInode, true);
-	if (open_file) {
-		netfid = open_file->fid.netfid;
-		netpid = open_file->pid;
-		pTcon = tlink_tcon(open_file->tlink);
-		goto set_via_filehandle;
-	}
-
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
-		rc = PTR_ERR(tlink);
-		tlink = NULL;
-		goto out;
-	}
-	pTcon = tlink_tcon(tlink);
-
-	/*
-	 * NT4 apparently returns success on this call, but it doesn't
-	 * really work.
-	 */
-	if (!(pTcon->ses->flags & CIFS_SES_NT4)) {
-		rc = CIFSSMBSetPathInfo(xid, pTcon, full_path,
-				     &info_buf, cifs_sb->local_nls,
-				     cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-		if (rc == 0) {
-			cifsInode->cifsAttrs = dosattr;
-			goto out;
-		} else if (rc != -EOPNOTSUPP && rc != -EINVAL)
-			goto out;
-	}
-
-	cFYI(1, "calling SetFileInfo since SetPathInfo for "
-		 "times not supported by this server");
-	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN,
-			 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
-			 CREATE_NOT_DIR, &netfid, &oplock,
-			 NULL, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags &
-				CIFS_MOUNT_MAP_SPECIAL_CHR);
-
-	if (rc != 0) {
-		if (rc == -EIO)
-			rc = -EINVAL;
-		goto out;
-	}
-
-	netpid = current->tgid;
-
-set_via_filehandle:
-	rc = CIFSSMBSetFileInfo(xid, pTcon, &info_buf, netfid, netpid);
-	if (!rc)
-		cifsInode->cifsAttrs = dosattr;
-
-	if (open_file == NULL)
-		CIFSSMBClose(xid, pTcon, netfid);
-	else
-		cifsFileInfo_put(open_file);
-out:
-	if (tlink != NULL)
-		cifs_put_tlink(tlink);
-	return rc;
+	return server->ops->set_file_info(inode, full_path, &info_buf, xid);
 }
 
 /*
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b73d275..ed31196 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -758,6 +758,84 @@ cifs_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 	return CIFSSMBWrite2(xid, parms, written, iov, nr_segs);
 }
 
+static int
+smb_set_file_info(struct inode *inode, const char *full_path,
+		  FILE_BASIC_INFO *buf, const unsigned int xid)
+{
+	int oplock = 0;
+	int rc;
+	__u16 netfid;
+	__u32 netpid;
+	struct cifsFileInfo *open_file;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct tcon_link *tlink = NULL;
+	struct cifs_tcon *tcon;
+	FILE_BASIC_INFO info_buf;
+
+	/* if the file is already open for write, just use that fileid */
+	open_file = find_writable_file(cinode, true);
+	if (open_file) {
+		netfid = open_file->fid.netfid;
+		netpid = open_file->pid;
+		tcon = tlink_tcon(open_file->tlink);
+		goto set_via_filehandle;
+	}
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		tlink = NULL;
+		goto out;
+	}
+	tcon = tlink_tcon(tlink);
+
+	/*
+	 * NT4 apparently returns success on this call, but it doesn't really
+	 * work.
+	 */
+	if (!(tcon->ses->flags & CIFS_SES_NT4)) {
+		rc = CIFSSMBSetPathInfo(xid, tcon, full_path, buf,
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (rc == 0) {
+			cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
+			goto out;
+		} else if (rc != -EOPNOTSUPP && rc != -EINVAL)
+			goto out;
+	}
+
+	cFYI(1, "calling SetFileInfo since SetPathInfo for times not supported "
+		"by this server");
+	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
+			 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
+			 &netfid, &oplock, NULL, cifs_sb->local_nls,
+			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc != 0) {
+		if (rc == -EIO)
+			rc = -EINVAL;
+		goto out;
+	}
+
+	netpid = current->tgid;
+
+set_via_filehandle:
+	rc = CIFSSMBSetFileInfo(xid, tcon, &info_buf, netfid, netpid);
+	if (!rc)
+		cinode->cifsAttrs = le32_to_cpu(buf->Attributes);
+
+	if (open_file == NULL)
+		CIFSSMBClose(xid, tcon, netfid);
+	else
+		cifsFileInfo_put(open_file);
+out:
+	if (tlink != NULL)
+		cifs_put_tlink(tlink);
+	return rc;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -795,6 +873,7 @@ struct smb_version_operations smb1_operations = {
 	.get_srv_inum = cifs_get_srv_inum,
 	.set_path_size = CIFSSMBSetEOF,
 	.set_file_size = CIFSSMBSetFileSize,
+	.set_file_info = smb_set_file_info,
 	.build_path_to_root = cifs_build_path_to_root,
 	.echo = CIFSSMBEcho,
 	.mkdir = CIFSSMBMkDir,
-- 
1.7.1
