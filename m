Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4298241665;
	Fri, 13 Feb 2026 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990782; cv=none; b=PSfHLVLhIGJLooGQ3+jTE8PCNK1WF9GD0m2xt8QTWHlvVMZZbIjdnvNf6DOzGN5MttB6xoBzE6nQ3WByHZBAyvLu3iFzZSNuGTNRqGgZUDE2dhA+2taL2KqznBbyQn5RubaK2LL8pKx2INR5Wbd4k1w+Q3inD7/LB0nEgH5zqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990782; c=relaxed/simple;
	bh=PoYWuw4wZyacohPAsD+5yte+okFTVGd4iEeyVvfJsYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZjayf57lNI21TYRVWLvxb4+RBUnW0NOZlAPoNRPd4dvqq2izcxs5sOBIuRZY6TSANNuk6Qe3v3GbuUfLesjmuixDf6kZXylFYvuN2fqKhMJST6CGUoP5sl5FLp8ALc8BHUyPT3n3pEapDQQEg1q0BesM3+CA1MMAtpd8ySkVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oosdo5rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oosdo5rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA48C116C6;
	Fri, 13 Feb 2026 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990781;
	bh=PoYWuw4wZyacohPAsD+5yte+okFTVGd4iEeyVvfJsYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oosdo5rvAK1rcLaCGh2PgLotipT59T1K6XPcT4NsQG0aoRdYWNNR2bz8RTS2vSpX+
	 ywQ89HLlsqC7rKsFP9tCV2X0tFL6ZdGUjPdgg1d9bOTiHBTJ3yf+92VYh+TyXIMCGS
	 l4dhL2j18Y0ceWoTxAxuEITrzjURA2dG0eL48guQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 22/49] smb: client: use smbdirect_send_batch processing
Date: Fri, 13 Feb 2026 14:48:06 +0100
Message-ID: <20260213134709.700172085@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 2c1ac39ce9cd4112f406775c626eef7f3eb4c481 upstream.

This will allow us to use similar logic as we have in
the server soon, so that we can share common code later.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c | 149 ++++++++++++++++++++++++++++++++++----
 1 file changed, 135 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6cb40da7e589..ef3b237bccc1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -544,11 +544,20 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_send_io *request =
 		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	struct smbdirect_socket *sc = request->socket;
+	struct smbdirect_send_io *sibling, *next;
 	int lcredits = 0;
 
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
 
+	/*
+	 * Free possible siblings and then the main send_io
+	 */
+	list_for_each_entry_safe(sibling, next, &request->sibling_list, sibling_list) {
+		list_del_init(&sibling->sibling_list);
+		smbd_free_send_io(sibling);
+		lcredits += 1;
+	}
 	/* Note this frees wc->wr_cqe, but not wc */
 	smbd_free_send_io(request);
 	lcredits += 1;
@@ -1154,7 +1163,8 @@ static int smbd_ib_post_send(struct smbdirect_socket *sc,
 
 /* Post the send request */
 static int smbd_post_send(struct smbdirect_socket *sc,
-		struct smbdirect_send_io *request)
+			  struct smbdirect_send_batch *batch,
+			  struct smbdirect_send_io *request)
 {
 	int i;
 
@@ -1170,16 +1180,95 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	}
 
 	request->cqe.done = send_done;
-
 	request->wr.next = NULL;
-	request->wr.wr_cqe = &request->cqe;
 	request->wr.sg_list = request->sge;
 	request->wr.num_sge = request->num_sge;
 	request->wr.opcode = IB_WR_SEND;
+
+	if (batch) {
+		request->wr.wr_cqe = NULL;
+		request->wr.send_flags = 0;
+		if (!list_empty(&batch->msg_list)) {
+			struct smbdirect_send_io *last;
+
+			last = list_last_entry(&batch->msg_list,
+					       struct smbdirect_send_io,
+					       sibling_list);
+			last->wr.next = &request->wr;
+		}
+		list_add_tail(&request->sibling_list, &batch->msg_list);
+		batch->wr_cnt++;
+		return 0;
+	}
+
+	request->wr.wr_cqe = &request->cqe;
 	request->wr.send_flags = IB_SEND_SIGNALED;
 	return smbd_ib_post_send(sc, &request->wr);
 }
 
+static void smbd_send_batch_init(struct smbdirect_send_batch *batch,
+				 bool need_invalidate_rkey,
+				 unsigned int remote_key)
+{
+	INIT_LIST_HEAD(&batch->msg_list);
+	batch->wr_cnt = 0;
+	batch->need_invalidate_rkey = need_invalidate_rkey;
+	batch->remote_key = remote_key;
+}
+
+static int smbd_send_batch_flush(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *batch,
+				 bool is_last)
+{
+	struct smbdirect_send_io *first, *last;
+	int ret = 0;
+
+	if (list_empty(&batch->msg_list))
+		return 0;
+
+	first = list_first_entry(&batch->msg_list,
+				 struct smbdirect_send_io,
+				 sibling_list);
+	last = list_last_entry(&batch->msg_list,
+			       struct smbdirect_send_io,
+			       sibling_list);
+
+	if (batch->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = batch->remote_key;
+		batch->need_invalidate_rkey = false;
+		batch->remote_key = 0;
+	}
+
+	last->wr.send_flags = IB_SEND_SIGNALED;
+	last->wr.wr_cqe = &last->cqe;
+
+	/*
+	 * Remove last from batch->msg_list
+	 * and splice the rest of batch->msg_list
+	 * to last->sibling_list.
+	 *
+	 * batch->msg_list is a valid empty list
+	 * at the end.
+	 */
+	list_del_init(&last->sibling_list);
+	list_splice_tail_init(&batch->msg_list, &last->sibling_list);
+	batch->wr_cnt = 0;
+
+	ret = smbd_ib_post_send(sc, &first->wr);
+	if (ret) {
+		struct smbdirect_send_io *sibling, *next;
+
+		list_for_each_entry_safe(sibling, next, &last->sibling_list, sibling_list) {
+			list_del_init(&sibling->sibling_list);
+			smbd_free_send_io(sibling);
+		}
+		smbd_free_send_io(last);
+	}
+
+	return ret;
+}
+
 static int wait_for_credits(struct smbdirect_socket *sc,
 			    wait_queue_head_t *waitq, atomic_t *total_credits,
 			    int needed)
@@ -1202,16 +1291,35 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
-static int wait_for_send_lcredit(struct smbdirect_socket *sc)
+static int wait_for_send_lcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *batch)
 {
+	if (batch && (atomic_read(&sc->send_io.lcredits.count) <= 1)) {
+		int ret;
+
+		ret = smbd_send_batch_flush(sc, batch, false);
+		if (ret)
+			return ret;
+	}
+
 	return wait_for_credits(sc,
 				&sc->send_io.lcredits.wait_queue,
 				&sc->send_io.lcredits.count,
 				1);
 }
 
-static int wait_for_send_credits(struct smbdirect_socket *sc)
+static int wait_for_send_credits(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *batch)
 {
+	if (batch &&
+	    (batch->wr_cnt >= 16 || atomic_read(&sc->send_io.credits.count) <= 1)) {
+		int ret;
+
+		ret = smbd_send_batch_flush(sc, batch, false);
+		if (ret)
+			return ret;
+	}
+
 	return wait_for_credits(sc,
 				&sc->send_io.credits.wait_queue,
 				&sc->send_io.credits.count,
@@ -1219,6 +1327,7 @@ static int wait_for_send_credits(struct smbdirect_socket *sc)
 }
 
 static int smbd_post_send_iter(struct smbdirect_socket *sc,
+			       struct smbdirect_send_batch *batch,
 			       struct iov_iter *iter,
 			       int *_remaining_data_length)
 {
@@ -1230,14 +1339,14 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
 
-	rc = wait_for_send_lcredit(sc);
+	rc = wait_for_send_lcredit(sc, batch);
 	if (rc) {
 		log_outgoing(ERR, "disconnected not sending on wait_lcredit\n");
 		rc = -EAGAIN;
 		goto err_wait_lcredit;
 	}
 
-	rc = wait_for_send_credits(sc);
+	rc = wait_for_send_credits(sc, batch);
 	if (rc) {
 		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
 		rc = -EAGAIN;
@@ -1322,7 +1431,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
-	rc = smbd_post_send(sc, request);
+	rc = smbd_post_send(sc, batch, request);
 	if (!rc)
 		return 0;
 
@@ -1351,10 +1460,11 @@ static int smbd_post_send_empty(struct smbdirect_socket *sc)
 	int remaining_data_length = 0;
 
 	sc->statistics.send_empty++;
-	return smbd_post_send_iter(sc, NULL, &remaining_data_length);
+	return smbd_post_send_iter(sc, NULL, NULL, &remaining_data_length);
 }
 
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
+				    struct smbdirect_send_batch *batch,
 				    struct iov_iter *iter,
 				    int *_remaining_data_length)
 {
@@ -1367,7 +1477,7 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(sc, iter, _remaining_data_length);
+		rc = smbd_post_send_iter(sc, batch, iter, _remaining_data_length);
 		if (rc < 0)
 			break;
 	}
@@ -2289,8 +2399,10 @@ int smbd_send(struct TCP_Server_Info *server,
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
+	struct smbdirect_send_batch batch;
 	unsigned int remaining_data_length, klen;
 	int rc, i, rqst_idx;
+	int error = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -EAGAIN;
@@ -2315,6 +2427,7 @@ int smbd_send(struct TCP_Server_Info *server,
 			num_rqst, remaining_data_length);
 
 	rqst_idx = 0;
+	smbd_send_batch_init(&batch, false, 0);
 	do {
 		rqst = &rqst_array[rqst_idx];
 
@@ -2333,20 +2446,28 @@ int smbd_send(struct TCP_Server_Info *server,
 			klen += rqst->rq_iov[i].iov_len;
 		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
 
-		rc = smbd_post_send_full_iter(sc, &iter, &remaining_data_length);
-		if (rc < 0)
+		rc = smbd_post_send_full_iter(sc, &batch, &iter, &remaining_data_length);
+		if (rc < 0) {
+			error = rc;
 			break;
+		}
 
 		if (iov_iter_count(&rqst->rq_iter) > 0) {
 			/* And then the data pages if there are any */
-			rc = smbd_post_send_full_iter(sc, &rqst->rq_iter,
+			rc = smbd_post_send_full_iter(sc, &batch, &rqst->rq_iter,
 						      &remaining_data_length);
-			if (rc < 0)
+			if (rc < 0) {
+				error = rc;
 				break;
+			}
 		}
 
 	} while (++rqst_idx < num_rqst);
 
+	rc = smbd_send_batch_flush(sc, &batch, true);
+	if (unlikely(!rc && error))
+		rc = error;
+
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
 	 * before sending the next one.
-- 
2.53.0



