From: Steve French <smfrench@gmail.com>
Subject: [PATCH] [SMB3] remove directory incorrectly tries to set delete on close on non-empty directories
Date: Thu, 12 May 2016 21:30:32 -0500
Message-ID: <1463106632-88753-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench@gmail.com>,
	Steve French <steve.french@primarydata.com>,
	Stable <stable@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

For SMB3 (unlike for cifs), we attempt to delete a directory by
set of delete on close flag on the open. Windows clients set
this flag via a set info (SET_FILE_DISPOSITION to set this flag)
which properly checks if the directory is empty.

With this patch on smb3 mounts we correctly return
 "DIRECTORY NOT EMPTY"
on attempts to remove a non-empty directory.

Signed-off-by: Steve French <steve.french@primarydata.com>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/smb2glob.h  |  1 +
 fs/cifs/smb2inode.c |  8 ++++++--
 fs/cifs/smb2pdu.c   | 16 ++++++++++++++++
 fs/cifs/smb2proto.h |  2 ++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index bc0bb9c..0ffa180 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -44,6 +44,7 @@
 #define SMB2_OP_DELETE 7
 #define SMB2_OP_HARDLINK 8
 #define SMB2_OP_SET_EOF 9
+#define SMB2_OP_RMDIR 10
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 899bbc8..4f0231e 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -80,6 +80,10 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		 * SMB2_open() call.
 		 */
 		break;
+	case SMB2_OP_RMDIR:
+		tmprc = SMB2_rmdir(xid, tcon, fid.persistent_fid,
+				   fid.volatile_fid);
+		break;
 	case SMB2_OP_RENAME:
 		tmprc = SMB2_rename(xid, tcon, fid.persistent_fid,
 				    fid.volatile_fid, (__le16 *)data);
@@ -191,8 +195,8 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	   struct cifs_sb_info *cifs_sb)
 {
 	return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
-				  CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE,
-				  NULL, SMB2_OP_DELETE);
+				  CREATE_NOT_FILE,
+				  NULL, SMB2_OP_RMDIR);
 }
 
 int
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 42e1f44..8f38e33 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2575,6 +2575,22 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
+SMB2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
+		  u64 persistent_fid, u64 volatile_fid)
+{
+	__u8 delete_pending = 1;
+	void *data;
+	unsigned int size;
+
+	data = &delete_pending;
+	size = 1; /* sizeof __u8 */
+
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			current->tgid, FILE_DISPOSITION_INFORMATION, 1, &data,
+			&size);
+}
+
+int
 SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 		  u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
 {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 4f07dc9..eb2cde2 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -141,6 +141,8 @@ extern int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       __le16 *target_file);
+extern int SMB2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
+		      u64 persistent_fid, u64 volatile_fid);
 extern int SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 			     u64 persistent_fid, u64 volatile_fid,
 			     __le16 *target_file);
-- 
1.9.1
