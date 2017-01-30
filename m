From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 11/15] CIFS: Add mid handle callback
Date: Mon, 30 Jan 2017 13:39:40 -0800
Message-ID: <1485812384-28870-12-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We need to process read responses differently because the data
should go directly into preallocated pages. This can be done
by specifying a mid handle callback.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  8 ++++++++
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/cifssmb.c   |  6 +++---
 fs/cifs/smb2pdu.c   | 10 +++++-----
 fs/cifs/transport.c |  5 +++--
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1d1cdea..dc41ae4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1310,6 +1310,13 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
  */
 typedef void (mid_callback_t)(struct mid_q_entry *mid);
 
+/*
+ * This is the protopyte for mid handle function. This is called once the mid
+ * has been recognized after decryption of the message.
+ */
+typedef int (mid_handle_t)(struct TCP_Server_Info *server,
+			    struct mid_q_entry *mid);
+
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
@@ -1324,6 +1331,7 @@ struct mid_q_entry {
 #endif
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
+	mid_handle_t *handle; /* call handle mid callback */
 	void *callback_data;	  /* general purpose pointer for callback */
 	void *resp_buf;		/* pointer to received SMB header */
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 117d1df..fe874dc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -77,7 +77,7 @@ extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server,
 			struct smb_rqst *rqst,
 			mid_receive_t *receive, mid_callback_t *callback,
-			void *cbdata, const int flags);
+			mid_handle_t *handle, void *cbdata, const int flags);
 extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			  struct smb_rqst *rqst, int *resp_buf_type,
 			  const int flags, struct kvec *resp_iov);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index be261a3..8326212 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -731,7 +731,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov[1].iov_len = get_rfc1002_length(smb);
 	iov[1].iov_base = (char *)smb + 4;
 
-	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback,
+	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
 			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
@@ -1654,7 +1654,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
-			     cifs_readv_callback, rdata, 0);
+			     cifs_readv_callback, NULL, rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
@@ -2168,7 +2168,7 @@ cifs_async_writev(struct cifs_writedata *wdata,
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
-				cifs_writev_callback, wdata, 0);
+				cifs_writev_callback, NULL, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b088c50..12dee85 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2144,8 +2144,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	iov[1].iov_len = get_rfc1002_length(req);
 	iov[1].iov_base = (char *)req + 4;
 
-	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, server,
-			     CIFS_ECHO_OP);
+	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, NULL,
+			     server, CIFS_ECHO_OP);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
@@ -2384,7 +2384,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
-			     rdata, flags);
+			     NULL, rdata, flags);
 	if (rc) {
 		kref_put(&rdata->refcount, cifs_readdata_release);
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
@@ -2595,8 +2595,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	}
 
 	kref_get(&wdata->refcount);
-	rc = cifs_call_async(server, &rqst, NULL, smb2_writev_callback, wdata,
-			     flags);
+	rc = cifs_call_async(server, &rqst, NULL, smb2_writev_callback, NULL,
+			     wdata, flags);
 
 	if (rc) {
 		kref_put(&wdata->refcount, release);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index bc5f55f..65060c5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -503,8 +503,8 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
  */
 int
 cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		mid_receive_t *receive, mid_callback_t *callback, void *cbdata,
-		const int flags)
+		mid_receive_t *receive, mid_callback_t *callback,
+		mid_handle_t *handle, void *cbdata, const int flags)
 {
 	int rc, timeout, optype;
 	struct mid_q_entry *mid;
@@ -531,6 +531,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
+	mid->handle = handle;
 	mid->mid_state = MID_REQUEST_SUBMITTED;
 
 	/* put it on the pending_mid_q */
-- 
2.7.4
