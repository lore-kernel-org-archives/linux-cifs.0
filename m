From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/8] CIFS: Make SMB2_open use cifs_open_parms struct
Date: Wed, 10 Jul 2013 13:59:59 +0400
Message-ID: <1373450401-4135-8-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to prepare it for further durable handle reconnect processing.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2file.c  |    5 +----
 fs/cifs/smb2inode.c |   35 +++++++++++++++++++++--------------
 fs/cifs/smb2ops.c   |   51 +++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2pdu.c   |   19 +++++++++----------
 fs/cifs/smb2proto.h |    6 ++----
 5 files changed, 66 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 5bab192..3989929 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -85,10 +85,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	if (oparms->tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		memcpy(smb2_oplock + 1, fid->lease_key, SMB2_LEASE_KEY_SIZE);
 
-	rc = SMB2_open(xid, oparms->tcon, smb2_path, &fid->persistent_fid,
-		       &fid->volatile_fid, oparms->desired_access,
-		       oparms->disposition, oparms->create_options, smb2_oplock,
-		       smb2_data);
+	rc = SMB2_open(xid, oparms, smb2_path, smb2_oplock, smb2_data);
 	if (rc)
 		goto out;
 
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index f50eefd..9841df7 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -44,17 +44,22 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		   __u32 create_options, void *data, int command)
 {
 	int rc, tmprc = 0;
-	u64 persistent_fid, volatile_fid;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
-		       desired_access, create_disposition, create_options,
-		       &oplock, NULL);
+	oparms.tcon = tcon;
+	oparms.desired_access = desired_access;
+	oparms.disposition = create_disposition;
+	oparms.create_options = create_options;
+	oparms.fid = &fid;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
@@ -64,8 +69,8 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 	case SMB2_OP_DELETE:
 		break;
 	case SMB2_OP_QUERY_INFO:
-		tmprc = SMB2_query_info(xid, tcon, persistent_fid,
-					volatile_fid,
+		tmprc = SMB2_query_info(xid, tcon, fid.persistent_fid,
+					fid.volatile_fid,
 					(struct smb2_file_all_info *)data);
 		break;
 	case SMB2_OP_MKDIR:
@@ -75,19 +80,21 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		 */
 		break;
 	case SMB2_OP_RENAME:
-		tmprc = SMB2_rename(xid, tcon, persistent_fid, volatile_fid,
-				    (__le16 *)data);
+		tmprc = SMB2_rename(xid, tcon, fid.persistent_fid,
+				    fid.volatile_fid, (__le16 *)data);
 		break;
 	case SMB2_OP_HARDLINK:
-		tmprc = SMB2_set_hardlink(xid, tcon, persistent_fid,
-					  volatile_fid, (__le16 *)data);
+		tmprc = SMB2_set_hardlink(xid, tcon, fid.persistent_fid,
+					  fid.volatile_fid, (__le16 *)data);
 		break;
 	case SMB2_OP_SET_EOF:
-		tmprc = SMB2_set_eof(xid, tcon, persistent_fid, volatile_fid,
-				     current->tgid, (__le64 *)data);
+		tmprc = SMB2_set_eof(xid, tcon, fid.persistent_fid,
+				     fid.volatile_fid, current->tgid,
+				     (__le64 *)data);
 		break;
 	case SMB2_OP_SET_INFO:
-		tmprc = SMB2_set_info(xid, tcon, persistent_fid, volatile_fid,
+		tmprc = SMB2_set_info(xid, tcon, fid.persistent_fid,
+				      fid.volatile_fid,
 				      (FILE_BASIC_INFO *)data);
 		break;
 	default:
@@ -95,7 +102,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		break;
 	}
 
-	rc = SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	rc = SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	if (tmprc)
 		rc = tmprc;
 	kfree(utf16_path);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 85b15e0..86954b0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -213,22 +213,28 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
 	int rc;
-	__u64 persistent_fid, volatile_fid;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, &oplock, NULL);
+	oparms.tcon = tcon;
+	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.disposition = FILE_OPEN;
+	oparms.create_options = 0;
+	oparms.fid = &fid;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	if (rc) {
 		kfree(utf16_path);
 		return rc;
 	}
 
-	rc = SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	rc = SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	kfree(utf16_path);
 	return rc;
 }
@@ -443,15 +449,19 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	__le16 *utf16_path;
 	int rc;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	__u64 persistent_fid, volatile_fid;
+	struct cifs_open_parms oparms;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
 
-	rc = SMB2_open(xid, tcon, utf16_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0,
-		       &oplock, NULL);
+	oparms.tcon = tcon;
+	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
+	oparms.disposition = FILE_OPEN;
+	oparms.create_options = 0;
+	oparms.fid = fid;
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL);
 	kfree(utf16_path);
 	if (rc) {
 		cifs_dbg(VFS, "open dir failed\n");
@@ -460,14 +470,12 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 0;
-	fid->persistent_fid = persistent_fid;
-	fid->volatile_fid = volatile_fid;
 
-	rc = SMB2_query_directory(xid, tcon, persistent_fid, volatile_fid, 0,
-				  srch_inf);
+	rc = SMB2_query_directory(xid, tcon, fid->persistent_fid,
+				  fid->volatile_fid, 0, srch_inf);
 	if (rc) {
 		cifs_dbg(VFS, "query directory failed\n");
-		SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+		SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 	}
 	return rc;
 }
@@ -528,17 +536,24 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	     struct kstatfs *buf)
 {
 	int rc;
-	u64 persistent_fid, volatile_fid;
 	__le16 srch_path = 0; /* Null - open root of share */
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	struct cifs_open_parms oparms;
+	struct cifs_fid fid;
+
+	oparms.tcon = tcon;
+	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.disposition = FILE_OPEN;
+	oparms.create_options = 0;
+	oparms.fid = &fid;
 
-	rc = SMB2_open(xid, tcon, &srch_path, &persistent_fid, &volatile_fid,
-		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, &oplock, NULL);
+	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL);
 	if (rc)
 		return rc;
 	buf->f_type = SMB2_MAGIC_NUMBER;
-	rc = SMB2_QFS_info(xid, tcon, persistent_fid, volatile_fid, buf);
-	SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	rc = SMB2_QFS_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+			   buf);
+	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 140a613..9d7341d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -946,14 +946,13 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec)
 }
 
 int
-SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
-	  u64 *persistent_fid, u64 *volatile_fid, __u32 desired_access,
-	  __u32 create_disposition, __u32 create_options, __u8 *oplock,
-	  struct smb2_file_all_info *buf)
+SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
+	  __u8 *oplock, struct smb2_file_all_info *buf)
 {
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
 	struct TCP_Server_Info *server;
+	struct cifs_tcon *tcon = oparms->tcon;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[4];
 	int resp_buftype;
@@ -975,16 +974,16 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	if (rc)
 		return rc;
 
-	if (create_options & CREATE_OPTION_READONLY)
+	if (oparms->create_options & CREATE_OPTION_READONLY)
 		file_attributes |= ATTR_READONLY;
 
 	req->ImpersonationLevel = IL_IMPERSONATION;
-	req->DesiredAccess = cpu_to_le32(desired_access);
+	req->DesiredAccess = cpu_to_le32(oparms->desired_access);
 	/* File attributes ignored on open (used in create though) */
 	req->FileAttributes = cpu_to_le32(file_attributes);
 	req->ShareAccess = FILE_SHARE_ALL_LE;
-	req->CreateDisposition = cpu_to_le32(create_disposition);
-	req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
+	req->CreateDisposition = cpu_to_le32(oparms->disposition);
+	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
 	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
 	/* do not count rfc1001 len field */
 	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
@@ -1055,8 +1054,8 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		goto creat_exit;
 	}
 
-	*persistent_fid = rsp->PersistentFileId;
-	*volatile_fid = rsp->VolatileFileId;
+	oparms->fid->persistent_fid = rsp->PersistentFileId;
+	oparms->fid->volatile_fid = rsp->VolatileFileId;
 
 	if (buf) {
 		memcpy(buf, &rsp->CreationTime, 32);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 206efde..1a5ecbe 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -104,10 +104,8 @@ extern int SMB2_tcon(const unsigned int xid, struct cifs_ses *ses,
 		     const char *tree, struct cifs_tcon *tcon,
 		     const struct nls_table *);
 extern int SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon);
-extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
-		     __le16 *path, u64 *persistent_fid, u64 *volatile_fid,
-		     __u32 desired_access, __u32 create_disposition,
-		     __u32 create_options, __u8 *oplock,
+extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
+		     __le16 *path, __u8 *oplock,
 		     struct smb2_file_all_info *buf);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
-- 
1.7.10.4
