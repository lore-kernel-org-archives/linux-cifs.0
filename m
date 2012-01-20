From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 33/50] CIFS: Add echo request support for SMB2
Date: Fri, 20 Jan 2012 12:34:54 +0400
Message-ID: <1327048511-2342-33-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/connect.c   |   19 +++++++------------
 fs/cifs/smb2misc.c  |   25 +++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   12 ++++++++++++
 fs/cifs/smb2proto.h |    2 ++
 6 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dc88667..887765c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -80,6 +80,9 @@
 /*           (max path length + 1 for null) * 2 for unicode    */
 #define MAX_NAME 514
 
+/* SMB echo "timeout" -- FIXME: tunable? */
+#define SMB_ECHO_INTERVAL (60 * HZ)
+
 #include "cifspdu.h"
 
 #ifndef XATTR_DOS_ATTRIB
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3a217d7..86f13a3 100644
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
@@ -317,14 +314,7 @@ cifs_echo_request(struct work_struct *work)
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-#ifdef CONFIG_CIFS_SMB2
-	if (server->is_smb2)
-		/* temporarilly disable echo requests for SMB2 */
-		rc = 0;
-	else
-#endif
-		rc = CIFSSMBEcho(server);
-
+	rc = CIFSSMBEcho(server);
 	if (rc)
 		cFYI(1, "Unable to send echo request to server: %s",
 			server->hostname);
@@ -2040,7 +2030,12 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->lstrp = jiffies;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
-	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
+#ifdef CONFIG_CIFS_SMB2
+	if (volume_info->use_smb2)
+		INIT_DELAYED_WORK(&tcp_ses->echo, smb2_echo_request);
+	else
+#endif
+		INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 
 	/*
 	 * at this point we are the only ones with the pointer
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d63987c..52b68fb 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -330,3 +330,28 @@ calc_size_exit:
 	cFYI(1, "smb2 len %d", len);
 	return len;
 }
+
+void
+smb2_echo_request(struct work_struct *work)
+{
+	int rc = 0;
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, echo.work);
+
+	/*
+	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is
+	 * done, which is indicated by max_read != 0. Also, no need to ping
+	 * if we got a response recently.
+	 */
+	if (server->max_read == 0 ||
+	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
+		goto requeue_echo;
+
+	rc = SMB2_echo(server);
+	if (rc)
+		cFYI(1, "Unable to send echo request to server: %s",
+			server->hostname);
+
+requeue_echo:
+	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dfb17fd..0bb7877 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1493,3 +1493,50 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	cifs_small_buf_release(buf);
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
+	atomic_add(credits_received, &server->credits);
+	wake_up(&server->request_q);
+}
+
+int
+SMB2_echo(struct TCP_Server_Info *server)
+{
+	struct smb2_echo_req *smb2;
+	int rc = 0;
+	struct kvec iov;
+
+	cFYI(1, "In echo request");
+
+	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&smb2);
+	if (rc)
+		return rc;
+
+	iov.iov_base = smb2;
+	iov.iov_len = be32_to_cpu(smb2->hdr.smb2_buf_length) + 4;
+
+	rc = smb2_call_async(server, &iov, 1, NULL, smb2_echo_callback, server,
+			     false);
+	if (rc)
+		cFYI(1, "Echo request failed: %d", rc);
+
+	cifs_small_buf_release(smb2);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 92d0982..81bd490 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -499,6 +499,18 @@ struct smb2_write_rsp {
 	__u8   Buffer[1];
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
index 6e7eed0..c64362e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -71,6 +71,7 @@ extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
 			      struct smb2_hdr *in_buf, int flags);
 extern int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
 			      struct nls_table *nls_info);
+extern void smb2_echo_request(struct work_struct *work);
 
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
 				   struct smb2_file_all_info *src);
@@ -139,5 +140,6 @@ extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 		     unsigned int *nbytes, char **buf, int *pbuf_type,
 		     unsigned int remaining_bytes);
 extern int smb2_async_readv(struct cifs_readdata *rdata);
+extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
