From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 52/53] CIFS: Add statfs support for SMB2
Date: Tue, 25 Oct 2011 10:12:25 +0400
Message-ID: <1319523146-2859-53-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   52 +++++++++++++++++++++++++++++++-------------------
 fs/cifs/smb2glob.h  |    2 +
 fs/cifs/smb2pdu.c   |   18 +++++++++++++++++
 fs/cifs/smb2proto.h |    2 +
 4 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3683384..844ea94 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -169,31 +169,14 @@ static void cifs_kill_sb(struct super_block *sb)
 	cifs_umount(cifs_sb);
 }
 
-static int
-cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
+static void
+cifs_queryfs(int xid, struct cifs_tcon *tcon, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	int rc = -EOPNOTSUPP;
-	int xid;
-
-	xid = GetXid();
 
 	buf->f_type = CIFS_MAGIC_NUMBER;
 
 	/*
-	 * PATH_MAX may be too long - it would presumably be total path,
-	 * but note that some servers (includinng Samba 3) have a shorter
-	 * maximum path.
-	 *
-	 * Instead could get the real value via SMB_QUERY_FS_ATTRIBUTE_INFO.
-	 */
-	buf->f_namelen = PATH_MAX;
-	buf->f_files = 0;	/* undefined */
-	buf->f_ffree = 0;	/* unlimited */
-
-	/*
 	 * We could add a second check for a QFS Unix capability bit
 	 */
 	if ((tcon->ses->capabilities & CAP_UNIX) &&
@@ -214,8 +197,37 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	if (rc)
 		rc = SMBOldQFSInfo(xid, tcon, buf);
+}
+
+static int
+cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	int xid;
+
+	xid = GetXid();
+
+	/*
+	 * PATH_MAX may be too long - it would presumably be total path,
+	 * but note that some servers (includinng Samba 3) have a shorter
+	 * maximum path.
+	 *
+	 * Instead could get the real value via SMB_QUERY_FS_ATTRIBUTE_INFO.
+	 */
+	buf->f_namelen = PATH_MAX;
+	buf->f_files = 0;	/* undefined */
+	buf->f_ffree = 0;	/* unlimited */
+
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2)
+		smb2_open_queryfs_close(xid, tcon, buf);
+	else
+#endif
+		cifs_queryfs(xid, tcon, buf);
 
-	FreeXid(xid);
+	_FreeXid(xid);
 	return 0;
 }
 
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 9e42f71..49634d4 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -25,6 +25,8 @@
 #include <linux/workqueue.h>
 #include "smb2pdu.h"
 
+#define SMB2_MAGIC_NUMBER 0xFE534D42
+
 /*
  * The sizes of various internal tables and strings
  */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f025b4..aded068 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1920,6 +1920,24 @@ qfsdev_exit:
 	return rc;
 }
 
+void
+smb2_open_queryfs_close(int xid, struct cifs_tcon *tcon, struct kstatfs *buf)
+{
+	int rc;
+	u64 persist_fid, volatile_fid;
+	__le16 srch_path = 0; /* Null - open root of share */
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+
+	rc = SMB2_open(xid, tcon, &srch_path, &persist_fid, &volatile_fid,
+			FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock);
+	if (!rc) {
+		buf->f_type = SMB2_MAGIC_NUMBER;
+		SMB2_QFS_info(xid, tcon, persist_fid, volatile_fid,
+					  buf);
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+	}
+}
+
 int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 		    u64 persistent_fid, u64 volatile_fid,
 		    FILE_ALL_INFO_SMB2 *pdata)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index edaff24..37198c5 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -111,6 +111,8 @@ extern int smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 			      __le32 desired_access, __le32 create_disposition,
 			      __le32 file_attributes, __le32 create_options,
 			      void *data, int command);
+extern void smb2_open_queryfs_close(int xid, struct cifs_tcon *tcon,
+				    struct kstatfs *buf);
 extern void smb2_set_ops(struct inode *inode);
 extern bool smb2_is_size_safe_to_change(struct smb2_inode *smb2_ind,
 					__u64 end_of_file);
-- 
1.7.1
