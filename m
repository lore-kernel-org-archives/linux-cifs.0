From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 07/15] cifs: change cifs_call_async to use smb_rqst structs
Date: Mon,  6 Aug 2012 07:31:04 -0400
Message-ID: <1344252672-15244-8-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For now, none of the callers populate rq_pages. That will be done for
writes in a later patch. While we're at it, change the prototype of
setup_async_request not to need a return pointer argument. Just
return the pointer to the mid_q_entry or an ERR_PTR.

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  8 ++++----
 fs/cifs/cifsproto.h     | 16 +++++++--------
 fs/cifs/cifssmb.c       | 20 ++++++++++++-------
 fs/cifs/smb2pdu.c       | 15 ++++++++++----
 fs/cifs/smb2proto.h     |  9 ++++-----
 fs/cifs/smb2transport.c | 40 ++++++++++++++++---------------------
 fs/cifs/transport.c     | 52 ++++++++++++++++++++++++-------------------------
 7 files changed, 83 insertions(+), 77 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0841f2a..1fd99bc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -201,11 +201,11 @@ struct smb_version_operations {
 			   struct mid_q_entry *);
 	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
 	/* setup request: allocate mid, sign message */
-	int (*setup_request)(struct cifs_ses *, struct kvec *, unsigned int,
-			     struct mid_q_entry **);
+	struct mid_q_entry *(*setup_request)(struct cifs_ses *,
+						struct smb_rqst *);
 	/* setup async request: allocate mid, sign message */
-	int (*setup_async_request)(struct TCP_Server_Info *, struct kvec *,
-				   unsigned int, struct mid_q_entry **);
+	struct mid_q_entry *(*setup_async_request)(struct TCP_Server_Info *,
+						struct smb_rqst *);
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e97a184..3b628f2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -70,20 +70,20 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
-extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
-			   unsigned int nvec, mid_receive_t *receive,
-			   mid_callback_t *callback, void *cbdata,
-			   const int flags);
+extern int cifs_call_async(struct TCP_Server_Info *server,
+			struct smb_rqst *rqst,
+			mid_receive_t *receive, mid_callback_t *callback,
+			void *cbdata, const int flags);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
 			int * /* bytes returned */ , const int);
 extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 			    char *in_buf, int flags);
-extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsigned int,
-			      struct mid_q_entry **);
-extern int cifs_setup_async_request(struct TCP_Server_Info *, struct kvec *,
-				    unsigned int, struct mid_q_entry **);
+extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
+				struct smb_rqst *);
+extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
+						struct smb_rqst *);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6786b5e..2f86c84 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -725,6 +725,8 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	ECHO_REQ *smb;
 	int rc = 0;
 	struct kvec iov;
+	struct smb_rqst rqst = { .rq_iov = &iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "In echo request");
 
@@ -742,7 +744,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_base = smb;
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
-	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
+	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback,
 			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
@@ -1585,6 +1587,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	READ_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
 		rdata->offset, rdata->bytes);
@@ -1628,9 +1632,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	kref_get(&rdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
-			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, 0);
+	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
+			     cifs_readv_callback, rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
@@ -2035,6 +2038,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct kvec *iov = NULL;
+	struct smb_rqst rqst = { };
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
 		wct = 14;
@@ -2051,11 +2055,13 @@ cifs_async_writev(struct cifs_writedata *wdata)
 		goto async_writev_out;
 
 	/* 1 iov per page + 1 for header */
-	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
+	rqst.rq_nvec = wdata->nr_pages + 1;
+	iov = kzalloc((rqst.rq_nvec) * sizeof(*iov), GFP_NOFS);
 	if (iov == NULL) {
 		rc = -ENOMEM;
 		goto async_writev_out;
 	}
+	rqst.rq_iov = iov;
 
 	smb->hdr.Pid = cpu_to_le16((__u16)wdata->pid);
 	smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
@@ -2104,8 +2110,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	}
 
 	kref_get(&wdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, 0);
+	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
+				cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8c70c04..1084dc7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1171,6 +1171,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	struct smb2_echo_req *req;
 	int rc = 0;
 	struct kvec iov;
+	struct smb_rqst rqst = { .rq_iov = &iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "In echo request");
 
@@ -1184,7 +1186,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	/* 4 for rfc1002 length field */
 	iov.iov_len = get_rfc1002_length(req) + 4;
 
-	rc = cifs_call_async(server, &iov, 1, NULL, smb2_echo_callback, server,
+	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, server,
 			     CIFS_ECHO_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
@@ -1340,6 +1342,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	int rc;
 	struct smb2_hdr *buf;
 	struct cifs_io_parms io_parms;
+	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
 		rdata->offset, rdata->bytes);
@@ -1359,7 +1363,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_len = get_rfc1002_length(rdata->iov[0].iov_base) + 4;
 
 	kref_get(&rdata->refcount);
-	rc = cifs_call_async(io_parms.tcon->ses->server, rdata->iov, 1,
+	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
 			     rdata, 0);
 	if (rc)
@@ -1480,6 +1484,7 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	struct smb2_write_req *req = NULL;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct kvec *iov = NULL;
+	struct smb_rqst rqst;
 
 	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
 	if (rc)
@@ -1491,6 +1496,8 @@ smb2_async_writev(struct cifs_writedata *wdata)
 		rc = -ENOMEM;
 		goto async_writev_out;
 	}
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = wdata->nr_pages + 1;
 
 	req->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
@@ -1526,8 +1533,8 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
 	kref_get(&wdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, smb2_writev_callback, wdata, 0);
+	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
+				smb2_writev_callback, wdata, 0);
 
 	if (rc)
 		kref_put(&wdata->refcount, cifs_writedata_release);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a9bda04..aeb30db 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -43,11 +43,10 @@ extern __le16 *cifs_convert_path_to_utf16(const char *from,
 extern int smb2_verify_signature(struct smb_rqst *, struct TCP_Server_Info *);
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
-extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
-			      unsigned int nvec, struct mid_q_entry **ret_mid);
-extern int smb2_setup_async_request(struct TCP_Server_Info *server,
-				    struct kvec *iov, unsigned int nvec,
-				    struct mid_q_entry **ret_mid);
+extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
+			      struct smb_rqst *rqst);
+extern struct mid_q_entry *smb2_setup_async_request(
+			struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern void smb2_echo_request(struct work_struct *work);
 extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index a8e5559..f60ca2c 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -277,50 +277,44 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
 }
 
-int
-smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
-		   unsigned int nvec, struct mid_q_entry **ret_mid)
+struct mid_q_entry *
+smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = nvec };
 
 	smb2_seq_num_into_buf(ses->server, hdr);
 
 	rc = smb2_get_mid_entry(ses, hdr, &mid);
 	if (rc)
-		return rc;
-	rc = smb2_sign_rqst(&rqst, ses->server);
-	if (rc)
+		return ERR_PTR(rc);
+	rc = smb2_sign_rqst(rqst, ses->server);
+	if (rc) {
 		cifs_delete_mid(mid);
-	*ret_mid = mid;
-	return rc;
+		return ERR_PTR(rc);
+	}
+	return mid;
 }
 
-int
-smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
-			 unsigned int nvec, struct mid_q_entry **ret_mid)
+struct mid_q_entry *
+smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
-	int rc = 0;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+	int rc;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = nvec };
 
 	smb2_seq_num_into_buf(server, hdr);
 
 	mid = smb2_mid_entry_alloc(hdr, server);
 	if (mid == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	rc = smb2_sign_rqst(&rqst, server);
+	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		DeleteMidQEntry(mid);
-		return rc;
+		return ERR_PTR(rc);
 	}
 
-	*ret_mid = mid;
-	return rc;
+	return mid;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b609734..0844b03 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -454,12 +454,11 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	return 0;
 }
 
-int
-cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
-			 unsigned int nvec, struct mid_q_entry **ret_mid)
+struct mid_q_entry *
+cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
+	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	/* enable signing if server requires it */
@@ -468,16 +467,15 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	rc = cifs_sign_smbv(iov, nvec, server, &mid->sequence_number);
+	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
 		DeleteMidQEntry(mid);
-		return rc;
+		return ERR_PTR(rc);
 	}
 
-	*ret_mid = mid;
-	return 0;
+	return mid;
 }
 
 /*
@@ -485,9 +483,9 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
  * the result. Caller is responsible for dealing with timeouts.
  */
 int
-cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
-		unsigned int nvec, mid_receive_t *receive,
-		mid_callback_t *callback, void *cbdata, const int flags)
+cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
+		mid_receive_t *receive, mid_callback_t *callback,
+		void *cbdata, const int flags)
 {
 	int rc, timeout, optype;
 	struct mid_q_entry *mid;
@@ -500,12 +498,12 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		return rc;
 
 	mutex_lock(&server->srv_mutex);
-	rc = server->ops->setup_async_request(server, iov, nvec, &mid);
-	if (rc) {
+	mid = server->ops->setup_async_request(server, rqst);
+	if (IS_ERR(mid)) {
 		mutex_unlock(&server->srv_mutex);
 		add_credits(server, 1, optype);
 		wake_up(&server->request_q);
-		return rc;
+		return PTR_ERR(mid);
 	}
 
 	mid->receive = receive;
@@ -520,7 +518,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 
 
 	cifs_in_send_inc(server);
-	rc = smb_sendv(server, iov, nvec);
+	rc = smb_send_rqst(server, rqst);
 	cifs_in_send_dec(server);
 	cifs_save_when_sent(mid);
 	mutex_unlock(&server->srv_mutex);
@@ -630,22 +628,22 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	return map_smb_to_linux_error(mid->resp_buf, log_error);
 }
 
-int
-cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
-		   unsigned int nvec, struct mid_q_entry **ret_mid)
+struct mid_q_entry *
+cifs_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
+	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	rc = allocate_mid(ses, hdr, &mid);
 	if (rc)
-		return rc;
-	rc = cifs_sign_smbv(iov, nvec, ses->server, &mid->sequence_number);
-	if (rc)
+		return ERR_PTR(rc);
+	rc = cifs_sign_rqst(rqst, ses->server, &mid->sequence_number);
+	if (rc) {
 		cifs_delete_mid(mid);
-	*ret_mid = mid;
-	return rc;
+		return ERR_PTR(rc);
+	}
+	return mid;
 }
 
 int
@@ -658,6 +656,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	struct mid_q_entry *midQ;
 	char *buf = iov[0].iov_base;
 	unsigned int credits = 1;
+	struct smb_rqst rqst = { .rq_iov = iov,
+				 .rq_nvec = n_vec };
 
 	timeout = flags & CIFS_TIMEOUT_MASK;
 	optype = flags & CIFS_OP_MASK;
@@ -695,7 +695,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	rc = ses->server->ops->setup_request(ses, iov, n_vec, &midQ);
+	midQ = ses->server->ops->setup_request(ses, &rqst);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
-- 
1.7.11.2
