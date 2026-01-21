Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C83563F7
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025146; cv=none; b=AD0YB6iceVTzPU2lD74TyIvhG+lpIZ4gYDCkJ1sj71yIYOlRMF8yNy4RzvS4UTKaDCMuf9ObD/fB9lqyIiKb44OjRCA6n+2iwmFUA26w8IxOdLBCQAzUJf6uIiGeqg5AlxwbrGSdiDOUxKUVkPcaUW+bapkePDxK6mVmd8+dgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025146; c=relaxed/simple;
	bh=jl4gnuDG2bW0GCA3CbbExYYE6wG2/yaUaR32Nm8MnC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csySKKxZqsRCI82W7VuOkr91787BvOwU4Zzd7yFZlUPB+/n/1llz1DS9cO+8STyXzaOVoFAeOTECS3qU+GcrM9xXISxHzOquYFOUK6Mvtm1W6r/G962SdLC9ciDamGEQKLfUzSwygZpUcjz0vM+Kh/oO23CMPfnBtzZqy+bDb8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WvwBCAbD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WvwBCAbD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=s3XOyawmFs4PP57VHYNiJnVcgRS7E5x8BckNECMgTCg=; b=WvwBCAbDyZqfgNvoQJytDbCSG/
	OE3oQGy1pHky6StLF7JjVNlUBjymOHwKStODQMblet8hMEerSLfRblCFxRdo3oqovjZwIvq8+Nn8g
	a8fNjOlt0u/tAPVekjev7mqG9xBBKfaOiseSBJD/aBwLRdilqZLq0ZGAKvr+2uqaoFFKAbu31ZY3g
	YVMqWmooM9hOANHmWV6BmP7WOUnT86u9GSTUw+1lwImFoL382Jv7aamcritLJeSjIZAjuXLl+fr1H
	k+WT8E14n3GOtVbrEEJxus82n2KMrVzTl4cXwOVpSQy/IO2W/ToHaWh3llgCtOWZo/fwd5pHUz/WF
	WaRIz3QrZU74GgH/5bbz7Ky7rLiZu81cQCQQ9bEbLTkkZooEBbfsjFVcrFtRdueGm/DrFuIATSl0y
	NAIC/EicapPePLA8vxPMc2WCD04KGDLKtt868OBag6JRlKqvc+8DW8DM3IoSgBXL0ZyTpjnc3ESlU
	lZFV5KAuWIJ0Hl4Fj1lOJcKu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFY-00000001eAo-2W4s;
	Wed, 21 Jan 2026 19:52:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 16/19] smb: client: use smbdirect_send_batch processing
Date: Wed, 21 Jan 2026 20:50:26 +0100
Message-ID: <b73794c63b12ff982b1a4705d8ff94aea4a99196.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow us to use similar logic as we have in
the server soon, so that we can share common code later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 149 ++++++++++++++++++++++++++++++++++----
 1 file changed, 135 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 53076b3987f0..46741fcd39b4 100644
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
@@ -1323,7 +1432,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
-	rc = smbd_post_send(sc, request);
+	rc = smbd_post_send(sc, batch, request);
 	if (!rc)
 		return 0;
 
@@ -1352,10 +1461,11 @@ static int smbd_post_send_empty(struct smbdirect_socket *sc)
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
@@ -1368,7 +1478,7 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(sc, iter, _remaining_data_length);
+		rc = smbd_post_send_iter(sc, batch, iter, _remaining_data_length);
 		if (rc < 0)
 			break;
 	}
@@ -2290,8 +2400,10 @@ int smbd_send(struct TCP_Server_Info *server,
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
+	struct smbdirect_send_batch batch;
 	unsigned int remaining_data_length, klen;
 	int rc, i, rqst_idx;
+	int error = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -EAGAIN;
@@ -2316,6 +2428,7 @@ int smbd_send(struct TCP_Server_Info *server,
 			num_rqst, remaining_data_length);
 
 	rqst_idx = 0;
+	smbd_send_batch_init(&batch, false, 0);
 	do {
 		rqst = &rqst_array[rqst_idx];
 
@@ -2334,20 +2447,28 @@ int smbd_send(struct TCP_Server_Info *server,
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
2.43.0

