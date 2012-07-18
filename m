From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 04/45] CIFS: Add SMB2 support for mkdir operation
Date: Wed, 18 Jul 2012 19:48:20 +0400
Message-ID: <1342626541-29872-5-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |   30 ++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |    2 ++
 fs/cifs/smb2proto.h |    6 ++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1ba5c40..e129527 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -122,3 +122,33 @@ out:
 	kfree(smb2_data);
 	return rc;
 }
+
+int
+smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	   struct cifs_sb_info *cifs_sb)
+{
+	return smb2_open_op_close(xid, tcon, cifs_sb, name,
+				  FILE_WRITE_ATTRIBUTES, FILE_CREATE, 0,
+				  CREATE_NOT_FILE, NULL, SMB2_OP_MKDIR);
+}
+
+void
+smb2_mkdir_setinfo(struct inode *inode, const char *name,
+		   struct cifs_sb_info *cifs_sb, struct cifs_tcon *tcon,
+		   const unsigned int xid)
+{
+	FILE_BASIC_INFO data;
+	struct cifsInodeInfo *cifs_i;
+	u32 dosattrs;
+	int tmprc;
+
+	memset(&data, 0, sizeof(data));
+	cifs_i = CIFS_I(inode);
+	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
+	data.Attributes = cpu_to_le32(dosattrs);
+	tmprc = smb2_open_op_close(xid, tcon, cifs_sb, name,
+				   FILE_WRITE_ATTRIBUTES, FILE_CREATE, 0,
+				   CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO);
+	if (tmprc == 0)
+		cifs_i->cifsAttrs = dosattrs;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 410cf92..cc74871 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -318,6 +318,8 @@ struct smb_version_operations smb21_operations = {
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.build_path_to_root = smb2_build_path_to_root,
+	.mkdir = smb2_mkdir,
+	.mkdir_setinfo = smb2_mkdir_setinfo,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 902bbe2..f992508 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -52,6 +52,12 @@ extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
 				const char *full_path, FILE_ALL_INFO *data,
 				bool *adjust_tz);
+extern int smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon,
+		      const char *name, struct cifs_sb_info *cifs_sb);
+extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
+			       struct cifs_sb_info *cifs_sb,
+			       struct cifs_tcon *tcon, const unsigned int xid);
+
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
  * are contained within these calls.
-- 
1.7.1
