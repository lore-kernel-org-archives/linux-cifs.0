From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 18/45] CIFS: Make flush code use ops struct
Date: Wed, 18 Jul 2012 19:48:34 +0400
Message-ID: <1342626541-29872-19-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/file.c     |   20 ++++++++++++++++----
 fs/cifs/smb1ops.c  |    8 ++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0467e38..3d94397 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -274,6 +274,8 @@ struct smb_version_operations {
 	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
 	/* close a file */
 	int (*close)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
+	/* send a flush request to the server */
+	int (*flush)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e8cca00..3f2cfb3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2055,6 +2055,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	unsigned int xid;
 	int rc = 0;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -2078,8 +2079,13 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->fid.netfid);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+		server = tcon->ses->server;
+		if (server->ops->flush)
+			rc = server->ops->flush(xid, tcon, &smbfile->fid);
+		else
+			rc = -ENOSYS;
+	}
 
 	free_xid(xid);
 	mutex_unlock(&inode->i_mutex);
@@ -2091,6 +2097,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	unsigned int xid;
 	int rc = 0;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct inode *inode = file->f_mapping->host;
@@ -2106,8 +2113,13 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		file->f_path.dentry->d_name.name, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->fid.netfid);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+		server = tcon->ses->server;
+		if (server->ops->flush)
+			rc = server->ops->flush(xid, tcon, &smbfile->fid);
+		else
+			rc = -ENOSYS;
+	}
 
 	free_xid(xid);
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index dd64754..df20dd9 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -648,6 +648,13 @@ cifs_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 	return CIFSSMBClose(xid, tcon, fid->netfid);
 }
 
+static int
+cifs_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
+		struct cifs_fid *fid)
+{
+	return CIFSSMBFlush(xid, tcon, fid->netfid);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -691,6 +698,7 @@ struct smb_version_operations smb1_operations = {
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
+	.flush = cifs_flush_file,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
