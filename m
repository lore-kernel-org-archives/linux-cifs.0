From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] cifs: make cifs_send_async take a kvec array
Date: Mon,  2 May 2011 10:04:23 -0400
Message-ID: <1304345069-2441-3-git-send-email-jlayton@redhat.com>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304345069-2441-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need this for async writes, so convert the call to take a kvec
array. CIFSSMBEcho is changed to put a kvec on the stack and pass
in the SMB buffer using that.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++--
 fs/cifs/cifssmb.c   |    6 ++++--
 fs/cifs/transport.c |   13 +++++++------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4af7db8..e255a2b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -65,8 +65,8 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int wait_for_free_request(struct TCP_Server_Info *sv, const int long_op);
-extern int cifs_call_async(struct TCP_Server_Info *server,
-			   struct smb_hdr *in_buf, mid_callback_t *callback,
+extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
+			   unsigned int nvec, mid_callback_t *callback,
 			   void *cbdata);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0e3834d..418b3b2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -725,6 +725,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 {
 	ECHO_REQ *smb;
 	int rc = 0;
+	struct kvec iov;
 
 	cFYI(1, "In echo request");
 
@@ -739,9 +740,10 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	put_bcc(1, &smb->hdr);
 	smb->Data[0] = 'a';
 	inc_rfc1001_len(smb, 3);
+	iov.iov_base = smb;
+	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
-	rc = cifs_call_async(server, (struct smb_hdr *)smb,
-				cifs_echo_callback, server);
+	rc = cifs_call_async(server, &iov, 1, cifs_echo_callback, server);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d9833fc..7ccf292 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -349,11 +349,12 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
  * the result. Caller is responsible for dealing with timeouts.
  */
 int
-cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
-		mid_callback_t *callback, void *cbdata)
+cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
+		unsigned int nvec, mid_callback_t *callback, void *cbdata)
 {
 	int rc;
 	struct mid_q_entry *mid;
+	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
 
 	rc = wait_for_free_request(server, CIFS_ASYNC_OP);
 	if (rc)
@@ -361,10 +362,10 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 
 	/* enable signing if server requires it */
 	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-		in_buf->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	mutex_lock(&server->srv_mutex);
-	mid = AllocMidQEntry(in_buf, server);
+	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
 		return -ENOMEM;
@@ -375,7 +376,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 	list_add_tail(&mid->qhead, &server->pending_mid_q);
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
+	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
 		goto out_err;
@@ -385,7 +386,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 	mid->callback_data = cbdata;
 	mid->midState = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(server);
-	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
+	rc = smb_sendv(server, iov, nvec);
 	cifs_in_send_dec(server);
 	cifs_save_when_sent(mid);
 	mutex_unlock(&server->srv_mutex);
-- 
1.7.4.4
