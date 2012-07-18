From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 34/45] CIFS: Add SMB2 support for hardlink operation
Date: Wed, 18 Jul 2012 19:48:50 +0400
Message-ID: <1342626541-29872-35-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2glob.h  |    1 +
 fs/cifs/smb2inode.c |   34 ++++++++++++++++++++++++++++------
 fs/cifs/smb2ops.c   |    1 +
 fs/cifs/smb2pdu.c   |   31 +++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |    9 +++++++++
 fs/cifs/smb2proto.h |    6 ++++++
 6 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 8635574..21555d8 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -40,6 +40,7 @@
 #define SMB2_OP_MKDIR 5
 #define SMB2_OP_RENAME 6
 #define SMB2_OP_DELETE 7
+#define SMB2_OP_HARDLINK 8
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a6952ba..1921c9c 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -78,6 +78,10 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		tmprc = SMB2_rename(xid, tcon, persistent_fid, volatile_fid,
 				    (__le16 *)data);
 		break;
+	case SMB2_OP_HARDLINK:
+		tmprc = SMB2_set_hardlink(xid, tcon, persistent_fid,
+					  volatile_fid, (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -175,10 +179,10 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 				  SMB2_OP_DELETE);
 }
 
-int
-smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
-		 const char *from_name, const char *to_name,
-		 struct cifs_sb_info *cifs_sb)
+static int
+smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
+		   const char *from_name, const char *to_name,
+		   struct cifs_sb_info *cifs_sb, __u32 access, int command)
 {
 	__le16 *smb2_to_name = NULL;
 	int rc;
@@ -189,9 +193,27 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 		goto smb2_rename_path;
 	}
 
-	rc = smb2_open_op_close(xid, tcon, cifs_sb, from_name, DELETE,
-				FILE_OPEN, 0, 0, smb2_to_name, SMB2_OP_RENAME);
+	rc = smb2_open_op_close(xid, tcon, cifs_sb, from_name, access,
+				FILE_OPEN, 0, 0, smb2_to_name, command);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
 }
+
+int
+smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
+		 const char *from_name, const char *to_name,
+		 struct cifs_sb_info *cifs_sb)
+{
+	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+				  DELETE, SMB2_OP_RENAME);
+}
+
+int
+smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *from_name, const char *to_name,
+		     struct cifs_sb_info *cifs_sb)
+{
+	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
+				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK);
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index da13a60..f9e3a13 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -443,6 +443,7 @@ struct smb_version_operations smb21_operations = {
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
+	.create_hardlink = smb2_create_hardlink,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 515c141..4d9ef2c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1704,3 +1704,34 @@ SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 	kfree(data);
 	return rc;
 }
+
+int
+SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
+		  u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
+{
+	struct smb2_file_link_info info;
+	void **data;
+	unsigned int size[2];
+	int rc;
+	int len = (2 * UniStrnlen((wchar_t *)target_file, PATH_MAX));
+
+	data = kmalloc(sizeof(void *) * 2, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	info.ReplaceIfExists = 0; /* 1 = replace existing link with new */
+			      /* 0 = fail if link already exists */
+	info.RootDirectory = 0;  /* MBZ for network ops (why does spec say?) */
+	info.FileNameLength = cpu_to_le32(len);
+
+	data[0] = &info;
+	size[0] = sizeof(struct smb2_file_link_info);
+
+	data[1] = target_file;
+	size[1] = len + 2 /* null */;
+
+	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			   FILE_LINK_INFORMATION, 2, data, size);
+	kfree(data);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e2c7887..34a9329 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -651,6 +651,15 @@ struct smb2_file_rename_info { /* encoding of request for level 10 */
 	char   FileName[0];     /* New name to be assigned */
 } __packed; /* level 10 Set */
 
+struct smb2_file_link_info { /* encoding of request for level 11 */
+	__u8   ReplaceIfExists; /* 1 = replace existing link with new */
+				/* 0 = fail if link already exists */
+	__u8   Reserved[7];
+	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+	__le32 FileNameLength;
+	char   FileName[0];     /* Name to be assigned to new link */
+} __packed; /* level 11 Set */
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b43036e..99f6945 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -68,6 +68,9 @@ extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *from_name, const char *to_name,
 			    struct cifs_sb_info *cifs_sb);
+extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
+				const char *from_name, const char *to_name,
+				struct cifs_sb_info *cifs_sb);
 
 extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
 			  const char *full_path, int disposition,
@@ -112,5 +115,8 @@ extern int SMB2_echo(struct TCP_Server_Info *server);
 extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       __le16 *target_file);
+extern int SMB2_set_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
+			     u64 persistent_fid, u64 volatile_fid,
+			     __le16 *target_file);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
