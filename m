From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 22/24] CIFS: Add echo request support for SMB2
Date: Wed, 20 Jun 2012 18:31:02 +0400
Message-ID: <1340202664-28696-23-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/connect.c   |    3 ---
 fs/cifs/smb2ops.c   |    8 ++++++++
 fs/cifs/smb2pdu.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   12 ++++++++++++
 fs/cifs/smb2proto.h |    2 ++
 6 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 21dea33..80906e9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -73,6 +73,9 @@
 /*           (max path length + 1 for null) * 2 for unicode    */
 #define MAX_NAME 514
 
+/* SMB echo "timeout" -- FIXME: tunable? */
+#define SMB_ECHO_INTERVAL (60 * HZ)
+
 #include "cifspdu.h"
 
 #ifndef XATTR_DOS_ATTRIB
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e45c605..f3f5da4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -56,9 +56,6 @@
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
 
-/* SMB echo "timeout" -- FIXME: tunable? */
-#define SMB_ECHO_INTERVAL (60 * HZ)
-
 extern mempool_t *cifs_req_poolp;
 
 /* FIXME: should these be tunable? */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 654b1d9..985780f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -205,6 +205,12 @@ smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 	return NULL;
 }
 
+static bool
+smb2_can_echo(struct TCP_Server_Info *server)
+{
+	return server->echos;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -223,6 +229,8 @@ struct smb_version_operations smb21_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.is_path_accessible = smb2_is_path_accessible,
+	.can_echo = smb2_can_echo,
+	.echo = SMB2_echo,
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
 	.build_path_to_root = smb2_build_path_to_root,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bc14fc8..e5e2cf0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1077,3 +1077,51 @@ qinf_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
+
+/*
+ * This is a no-op for now. We're not really interested in the reply, but
+ * rather in the fact that the server sent one and that server->lstrp
+ * gets updated.
+ *
+ * FIXME: maybe we should consider checking that the reply matches request?
+ */
+static void
+smb2_echo_callback(struct mid_q_entry *mid)
+{
+	struct TCP_Server_Info *server = mid->callback_data;
+	struct smb2_echo_rsp *smb2 = (struct smb2_echo_rsp *)mid->resp_buf;
+	unsigned int credits_received = 1;
+
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		credits_received = le16_to_cpu(smb2->hdr.CreditRequest);
+
+	DeleteMidQEntry(mid);
+	add_credits(server, credits_received, CIFS_ECHO_OP);
+}
+
+int
+SMB2_echo(struct TCP_Server_Info *server)
+{
+	struct smb2_echo_req *req;
+	int rc = 0;
+	struct kvec iov;
+
+	cFYI(1, "In echo request");
+
+	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
+	if (rc)
+		return rc;
+
+	req->hdr.CreditRequest = cpu_to_le16(1);
+
+	iov.iov_base = (char *)req;
+	iov.iov_len = be32_to_cpu(req->hdr.smb2_buf_length) + 4;
+
+	rc = cifs_call_async(server, &iov, 1, NULL, smb2_echo_callback, server,
+			     CIFS_ECHO_OP);
+	if (rc)
+		cFYI(1, "Echo request failed: %d", rc);
+
+	cifs_small_buf_release(req);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 3f379f7..7398a2f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -442,6 +442,18 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+struct smb2_echo_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__u16  Reserved;
+} __packed;
+
+struct smb2_echo_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__u16  Reserved;
+} __packed;
+
 /* Possible InfoType values */
 #define SMB2_O_INFO_FILE	0x01
 #define SMB2_O_INFO_FILESYSTEM	0x02
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3868079..0f6eaac 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -43,6 +43,7 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
+extern void smb2_echo_request(struct work_struct *work);
 
 extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
@@ -69,5 +70,6 @@ extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
+extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
