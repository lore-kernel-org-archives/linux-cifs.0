From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 6/9] cifs: change cifs_call_async to use smb_rqst structs
Date: Wed, 25 Jul 2012 11:54:09 -0400
Message-ID: <1343231652-10459-7-git-send-email-jlayton@redhat.com>
References: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343231652-10459-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For now, none of the callers populate rq_pages. That will be done for
writes in a later patch. While we're at it, change the prototype of
setup_async_request not to need a return pointer argument. Just
return the pointer to the mid_q_entry or an ERR_PTR.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  4 ++--
 fs/cifs/cifsproto.h     | 12 ++++++------
 fs/cifs/cifssmb.c       | 20 +++++++++++++-------
 fs/cifs/smb2proto.h     |  4 +---
 fs/cifs/smb2transport.c | 14 ++++++--------
 fs/cifs/transport.c     | 30 ++++++++++++++----------------
 6 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2a7e4b8..a0bb713 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -194,8 +194,8 @@ struct smb_version_operations {
 	int (*setup_request)(struct cifs_ses *, struct kvec *, unsigned int,
 			     struct mid_q_entry **);
 	/* setup async request: allocate mid, sign message */
-	int (*setup_async_request)(struct TCP_Server_Info *, struct kvec *,
-				   unsigned int, struct mid_q_entry **);
+	struct mid_q_entry *(*setup_async_request)(struct TCP_Server_Info *,
+						struct smb_rqst *);
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3620bec..8075f23 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -69,10 +69,10 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
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
@@ -81,8 +81,8 @@ extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 			    char *in_buf, int flags);
 extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsigned int,
 			      struct mid_q_entry **);
-extern int cifs_setup_async_request(struct TCP_Server_Info *, struct kvec *,
-				    unsigned int, struct mid_q_entry **);
+extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
+						struct smb_rqst *);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ce5f75c..7365460 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -751,6 +751,8 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	ECHO_REQ *smb;
 	int rc = 0;
 	struct kvec iov;
+	struct smb_rqst rqst = { .rq_iov = &iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "In echo request");
 
@@ -768,7 +770,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_base = smb;
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
-	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
+	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback,
 			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
@@ -1604,6 +1606,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	READ_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+				 .rq_nvec = 1 };
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
 		rdata->offset, rdata->bytes);
@@ -1647,9 +1651,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	kref_get(&rdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
-			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, 0);
+	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
+			     cifs_readv_callback, rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
@@ -2052,6 +2055,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct kvec *iov = NULL;
+	struct smb_rqst rqst = { };
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
 		wct = 14;
@@ -2068,11 +2072,13 @@ cifs_async_writev(struct cifs_writedata *wdata)
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
@@ -2121,8 +2127,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	}
 
 	kref_get(&wdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, 0);
+	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
+				cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 902bbe2..dbb798c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -43,9 +43,7 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
-extern int smb2_setup_async_request(struct TCP_Server_Info *server,
-				    struct kvec *iov, unsigned int nvec,
-				    struct mid_q_entry **ret_mid);
+extern struct mid_q_entry *smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern void smb2_echo_request(struct work_struct *work);
 
 extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 31f5d42..c0a7a42 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -148,25 +148,23 @@ smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 	return rc;
 }
 
-int
-smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
-			 unsigned int nvec, struct mid_q_entry **ret_mid)
+struct mid_q_entry *
+smb2_setup_async_request(struct TCP_Server_Info *server,
+			struct smb_rqst *rqst)
 {
-	int rc = 0;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)smb_rqst->iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(server, hdr);
 
 	mid = smb2_mid_entry_alloc(hdr, server);
 	if (mid == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* rc = smb2_sign_smb2(iov, nvec, server);
 	if (rc) {
 		DeleteMidQEntry(mid);
 		return rc;
 	}*/
-	*ret_mid = mid;
-	return rc;
+	return mid;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5673ef1..73cfa6f 100644
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
-- 
1.7.11.2
