From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 06/45] CIFS: Add SMB2 support for rmdir
Date: Wed, 18 Jul 2012 19:48:22 +0400
Message-ID: <1342626541-29872-7-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2inode.c |    9 +++++++++
 fs/cifs/smb2ops.c   |    1 +
 fs/cifs/smb2proto.h |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index e129527..2aa5cb0 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -152,3 +152,12 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	if (tmprc == 0)
 		cifs_i->cifsAttrs = dosattrs;
 }
+
+int
+smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	   struct cifs_sb_info *cifs_sb)
+{
+	return smb2_open_op_close(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
+				  0, CREATE_NOT_FILE | CREATE_DELETE_ON_CLOSE,
+				  NULL, SMB2_OP_DELETE);
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index cc74871..826209b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -320,6 +320,7 @@ struct smb_version_operations smb21_operations = {
 	.build_path_to_root = smb2_build_path_to_root,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
+	.rmdir = smb2_rmdir,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f992508..bfaa7b1 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -57,6 +57,8 @@ extern int smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon,
 extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
 			       struct cifs_sb_info *cifs_sb,
 			       struct cifs_tcon *tcon, const unsigned int xid);
+extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
+		      const char *name, struct cifs_sb_info *cifs_sb);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
