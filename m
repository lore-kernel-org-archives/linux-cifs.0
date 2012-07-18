From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 32/45] CIFS: Add SMB2 support for rename operation
Date: Wed, 18 Jul 2012 19:48:48 +0400
Message-ID: <1342626541-29872-33-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |   25 ++++++++++++
 fs/cifs/smb2ops.c   |    1 +
 fs/cifs/smb2pdu.c   |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   28 +++++++++++++
 fs/cifs/smb2proto.h |    6 +++
 5 files changed, 167 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index ee3a1ef..a6952ba 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -74,6 +74,10 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 		 * SMB2_open() call.
 		 */
 		break;
+	case SMB2_OP_RENAME:
+		tmprc = SMB2_rename(xid, tcon, persistent_fid, volatile_fid,
+				    (__le16 *)data);
+		break;
 	default:
 		cERROR(1, "Invalid command");
 		break;
@@ -170,3 +174,24 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 				  0, CREATE_DELETE_ON_CLOSE, NULL,
 				  SMB2_OP_DELETE);
 }
+
+int
+smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
+		 const char *from_name, const char *to_name,
+		 struct cifs_sb_info *cifs_sb)
+{
+	__le16 *smb2_to_name = NULL;
+	int rc;
+
+	smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
+	if (smb2_to_name == NULL) {
+		rc = -ENOMEM;
+		goto smb2_rename_path;
+	}
+
+	rc = smb2_open_op_close(xid, tcon, cifs_sb, from_name, DELETE,
+				FILE_OPEN, 0, 0, smb2_to_name, SMB2_OP_RENAME);
+smb2_rename_path:
+	kfree(smb2_to_name);
+	return rc;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 82852fc..da13a60 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -442,6 +442,7 @@ struct smb_version_operations smb21_operations = {
 	.mkdir_setinfo = smb2_mkdir_setinfo,
 	.rmdir = smb2_rmdir,
 	.unlink = smb2_unlink,
+	.rename = smb2_rename_path,
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 46829c6..515c141 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1597,3 +1597,110 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	}
 	return rc;
 }
+
+static int
+send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
+	       u64 persistent_fid, u64 volatile_fid, int info_class,
+	       unsigned int num, void **data, unsigned int *size)
+{
+	struct smb2_set_info_req *req;
+	struct smb2_set_info_rsp *rsp = NULL;
+	struct kvec *iov;
+	int rc = 0;
+	int resp_buftype;
+	unsigned int i;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	if (!num)
+		return -EINVAL;
+
+	iov = kmalloc(sizeof(struct kvec) * num, GFP_KERNEL);
+	if (!iov)
+		return -ENOMEM;
+
+	rc = small_smb2_init(SMB2_SET_INFO, tcon, (void **) &req);
+	if (rc) {
+		kfree(iov);
+		return rc;
+	}
+
+	req->InfoType = SMB2_O_INFO_FILE;
+	req->FileInfoClass = info_class;
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+
+	/* 4 for RFC1001 length and 1 for Buffer */
+	req->BufferOffset =
+			cpu_to_le16(sizeof(struct smb2_set_info_req) - 1 - 4);
+	req->BufferLength = cpu_to_le32(*size);
+
+	inc_rfc1001_len(req, *size - 1 /* Buffer */);
+
+	memcpy(req->Buffer, *data, *size);
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for RFC1001 length */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+
+	for (i = 1; i < num; i++) {
+		inc_rfc1001_len(req, size[i]);
+		le32_add_cpu(&req->BufferLength, size[i]);
+		iov[i].iov_base = (char *)data[i];
+		iov[i].iov_len = size[i];
+	}
+
+	rc = SendReceive2(xid, ses, iov, num, &resp_buftype, 0);
+	rsp = (struct smb2_set_info_rsp *)iov[0].iov_base;
+
+	if (rc != 0) {
+		cifs_stats_fail_inc(tcon, SMB2_SET_INFO_HE);
+		goto out;
+	}
+
+	if (rsp == NULL) {
+		rc = -EIO;
+		goto out;
+	}
+
+out:
+	free_rsp_buf(resp_buftype, rsp);
+	kfree(iov);
+	return rc;
+}
+
+int
+SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
+	    u64 persistent_fid, u64 volatile_fid, __le16 *target_file)
+{
+	struct smb2_file_rename_info info;
+	void **data;
+	unsigned int size[2];
+	int rc;
+	int len = (2 * UniStrnlen((wchar_t *)target_file, PATH_MAX));
+
+	data = kmalloc(sizeof(void *) * 2, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	info.ReplaceIfExists = 1; /* 1 = replace existing target with new */
+			      /* 0 = fail if target already exists */
+	info.RootDirectory = 0;  /* MBZ for network ops (why does spec say?) */
+	info.FileNameLength = cpu_to_le32(len);
+
+	data[0] = &info;
+	size[0] = sizeof(struct smb2_file_rename_info);
+
+	data[1] = target_file;
+	size[1] = len + 2 /* null */;
+
+	rc = send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			   FILE_RENAME_INFORMATION, 2, data, size);
+	kfree(data);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 4712273..e2c7887 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -566,6 +566,25 @@ struct smb2_query_info_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+struct smb2_set_info_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 33 */
+	__u8   InfoType;
+	__u8   FileInfoClass;
+	__le32 BufferLength;
+	__le16 BufferOffset;
+	__u16  Reserved;
+	__le32 AdditionalInformation;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_set_info_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 2 */
+} __packed;
+
 /*
  *	PDU infolevel structure definitions
  *	BB consider moving to a different header
@@ -623,6 +642,15 @@ struct smb2_file_internal_info {
 	__le64 IndexNumber;
 } __packed; /* level 6 Query */
 
+struct smb2_file_rename_info { /* encoding of request for level 10 */
+	__u8   ReplaceIfExists; /* 1 = replace existing target with new */
+				/* 0 = fail if target already exists */
+	__u8   Reserved[7];
+	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+	__le32 FileNameLength;
+	char   FileName[0];     /* New name to be assigned */
+} __packed; /* level 10 Set */
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index dbbdc39..b43036e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -65,6 +65,9 @@ extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
 		       const char *name, struct cifs_sb_info *cifs_sb);
+extern int smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
+			    const char *from_name, const char *to_name,
+			    struct cifs_sb_info *cifs_sb);
 
 extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
 			  const char *full_path, int disposition,
@@ -106,5 +109,8 @@ extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec);
 extern int SMB2_echo(struct TCP_Server_Info *server);
+extern int SMB2_rename(const unsigned int xid, struct cifs_tcon *tcon,
+		       u64 persistent_fid, u64 volatile_fid,
+		       __le16 *target_file);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
