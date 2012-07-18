From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 41/45] CIFS: Process oplocks for SMB2
Date: Wed, 18 Jul 2012 19:48:57 +0400
Message-ID: <1342626541-29872-42-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/connect.c   |    4 ++++
 fs/cifs/smb2file.c  |   24 ++++++++++++++++++++++--
 fs/cifs/smb2inode.c |    3 ++-
 fs/cifs/smb2ops.c   |   29 +++++++++++++++++++++++++----
 fs/cifs/smb2pdu.c   |    8 +++++---
 fs/cifs/smb2proto.h |    3 ++-
 7 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 406ad6d..133cd0c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -328,6 +328,7 @@ struct smb_version_operations {
 			 struct cifs_fid *);
 	/* calculate a size of SMB message */
 	unsigned int (*calc_smb_size)(void *);
+	bool (*is_status_pending)(char *, struct TCP_Server_Info *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bd4dcdd..34f46d0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -818,6 +818,10 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
+	if (server->ops->is_status_pending &&
+	    server->ops->is_status_pending(buf, server, length))
+		return -1;
+
 	if (!mid)
 		return length;
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index a7618df..5ff25e0 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -34,6 +34,26 @@
 #include "fscache.h"
 #include "smb2proto.h"
 
+void
+smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
+{
+	oplock &= 0xFF;
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		cinode->clientCanCacheAll = true;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+		     &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock granted on inode %p",
+		    &cinode->vfs_inode);
+	} else {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = false;
+	}
+}
+
 int
 smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	       int disposition, int desired_access, int create_options,
@@ -58,10 +78,11 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	}
 
 	desired_access |= FILE_READ_ATTRIBUTES;
+	*oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
 
 	rc = SMB2_open(xid, tcon, smb2_path, &fid->persistent_fid,
 		       &fid->volatile_fid, desired_access, disposition,
-		       0, 0, smb2_data);
+		       0, 0, (__u8 *)oplock, smb2_data);
 	if (rc)
 		goto out;
 
@@ -79,7 +100,6 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 	}
 
 out:
-	*oplock = 0;
 	kfree(smb2_data);
 	kfree(smb2_path);
 	return rc;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1bd6b0f..7064824 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -47,6 +47,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc, tmprc = 0;
 	u64 persistent_fid, volatile_fid;
 	__le16 *utf16_path;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
@@ -54,7 +55,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
 		       desired_access, create_disposition, file_attributes,
-		       create_options, NULL);
+		       create_options, &oplock, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0ea6cfe..25f4263 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -22,6 +22,7 @@
 #include "smb2proto.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "smb2status.h"
 
 static int
 change_conf(struct TCP_Server_Info *server)
@@ -198,13 +199,14 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	__u64 persistent_fid, volatile_fid;
 	__le16 *utf16_path;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
 	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, NULL);
+		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -349,10 +351,10 @@ smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
 static void
 smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 {
-	/* struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode); */
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
-	/* cifs_set_oplock_level(cinode, oplock); */
+	smb2_set_oplock_level(cinode, oplock);
 	/* cinode->can_cache_brlcks = cinode->clientCanCacheAll; */
 }
 
@@ -423,6 +425,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	__le16 *utf16_path;
 	int rc;
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	__u64 persistent_fid, volatile_fid;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
@@ -431,7 +434,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
 		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0,
-		       NULL);
+		       &oplock, NULL);
 	kfree(utf16_path);
 	if (rc) {
 		cERROR(1, "open dir failed");
@@ -468,6 +471,23 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
+/*
+* If we negotiate SMB2 protocol and get STATUS_PENDING - update
+* the number of credits and return true. Otherwise - return false.
+*/
+static bool
+smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
+{
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+
+	if (le32_to_cpu(hdr->Status) != STATUS_PENDING)
+		return false;
+
+	if (!length)
+		add_credits(server, le16_to_cpu(hdr->CreditRequest), 0);
+	return true;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -521,6 +541,7 @@ struct smb_version_operations smb21_operations = {
 	.query_dir_next = smb2_query_dir_next,
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
+	.is_status_pending = smb2_is_status_pending,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 181b4db..58c1e91 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -872,7 +872,7 @@ int
 SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
 	  __u32 create_disposition, __u32 file_attributes, __u32 create_options,
-	  struct smb2_file_all_info *buf)
+	  __u8 *oplock, struct smb2_file_all_info *buf)
 {
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
@@ -895,9 +895,9 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	/* if (server->oplocks)
+	if (server->oplocks)
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_BATCH;
-	else */
+	else
 		req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
 	req->ImpersonationLevel = IL_IMPERSONATION;
 	req->DesiredAccess = cpu_to_le32(desired_access);
@@ -954,6 +954,8 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		buf->NumberOfLinks = cpu_to_le32(1);
 		buf->DeletePending = 0;
 	}
+
+	*oplock = rsp->OplockLevel;
 creat_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 0d29db2..d18339f 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -82,6 +82,7 @@ extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
 			  int desired_access, int create_options,
 			  struct cifs_fid *fid, __u32 *oplock,
 			  FILE_ALL_INFO *buf, struct cifs_sb_info *cifs_sb);
+extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
@@ -99,7 +100,7 @@ extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
 		     __le16 *path, u64 *persistent_fid, u64 *volatile_fid,
 		     __u32 desired_access, __u32 create_disposition,
 		     __u32 file_attributes, __u32 create_options,
-		     struct smb2_file_all_info *buf);
+		     __u8 *oplock, struct smb2_file_all_info *buf);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
-- 
1.7.1
