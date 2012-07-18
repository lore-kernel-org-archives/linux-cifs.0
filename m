From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 19/45] CIFS: Add SMB2 support for flush
Date: Wed, 18 Jul 2012 19:48:35 +0400
Message-ID: <1342626541-29872-20-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c   |    8 ++++++++
 fs/cifs/smb2pdu.c   |   38 ++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   15 +++++++++++++++
 fs/cifs/smb2proto.h |    2 ++
 4 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0fd5801..d81e1da 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -329,6 +329,13 @@ smb2_close_file(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
+static int
+smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
+		struct cifs_fid *fid)
+{
+	return SMB2_flush(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -363,6 +370,7 @@ struct smb_version_operations smb21_operations = {
 	.open = smb2_open_file,
 	.set_fid = smb2_set_fid,
 	.close = smb2_close_file,
+	.flush = smb2_flush_file,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 231e970..ff37406 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1152,3 +1152,41 @@ SMB2_echo(struct TCP_Server_Info *server)
 	cifs_small_buf_release(req);
 	return rc;
 }
+
+int
+SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+	   u64 volatile_fid)
+{
+	struct smb2_flush_req *req;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[1];
+	int resp_buftype;
+	int rc = 0;
+
+	cFYI(1, "Flush");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov[0].iov_len = get_rfc1002_length(req) + 4;
+
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
+
+	if ((rc != 0) && tcon)
+		cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
+
+	free_rsp_buf(resp_buftype, iov[0].iov_base);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 7f1caff..af2c996 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -451,6 +451,21 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+struct smb2_flush_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 24 */
+	__le16 Reserved1;
+	__le32 Reserved2;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+} __packed;
+
+struct smb2_flush_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;
+	__le16 Reserved;
+} __packed;
+
 struct smb2_echo_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 624d344..51e6cd1 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -89,6 +89,8 @@ extern int SMB2_open(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct smb2_file_all_info *buf);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
+extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
+		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
-- 
1.7.1
