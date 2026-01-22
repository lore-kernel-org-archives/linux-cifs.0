Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0480636EAA3;
	Thu, 22 Jan 2026 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102342; cv=none; b=pc/fbAjjourKQEVkYCH1If37x2dgE00NR+sGrGhPS4oIqC+JDrqlGMrx5pHMgXUJeudvnAz3M5tgq1ui4w+SgGdpo25bkVpt2lSUCR4tvZJjHxiE2jEiOdLmIrwkjCFeNl5/ih1Pa/fi6RNarpIou5u10lYw02y5qpke6DKvjnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102342; c=relaxed/simple;
	bh=KeRWXEN4tFPALVTtYKTQeDmW9nYJXTe5gIBZ2Um2Ed4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRLcMMmDE1bL/teAwTE+hX16lJPAqUoxOytFFvPP8wYGTTVpRwNBeJjJYhKl6wXoImmLsxPFpgMxaRU13jeI5fnN074scsP29B8eOTk/MuFibjLtHfQcIgtUDHUNWfaDNw8DyoJaUE4SeGRN+C7eZ583L7s6p+eNRYQDC4o9owU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NP/l+1OH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NP/l+1OH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gJ9Y0Q9YLvvffsluWpN2R5HFvbpyTRdSQOw1IPJbCXU=; b=NP/l+1OHME9t+u6w+tngy8cE0c
	xUugmb2+4fqCpCi1+oCzeoQOGk0eVX0jBxAr8AJpTdg7038E07X8iT56w0Baol5Ooc37GBX5ojsyI
	jCEEkq5CGo+0eKzySA0iUwaEE8tJOWOUYR9vUCm43ZVtmlN1yCzGESurIBPpt6+3/mvWQ1L6QPzHd
	W4lDZwE0AHoHclaQPIE3yY5/E7Gf+eD6bfLfEBVfUUzKDF20YRDbpZpceDODym9U5kdRUBJwC3dEt
	gd4Ekqd8C20jXJhUuyAobmv3Wl45Ooccnri1d6qD4VGjVScxbjtSgJvZltP53ELnwGuf8tG7XBs00
	kwSokNXAPIIWVVgev7cmyp4l/4LlrCxfDzwdpC2G+KrYmur+B2T0AfiysvzOtsu07JfJ683YpDP3r
	lmMiHj4AWcyfOhImvhLF5PunqtUyBC16ciQEk7jwgYd5Hh2F2Atv2wI3T2d+D5NtcTKeu6kx6EgEq
	SE8nMAlMFoMSov/dAq4iaeb8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKQ-00000001px8-1OgC;
	Thu, 22 Jan 2026 17:18:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 16/20] smb: client: use smbdirect_send_batch processing
Date: Thu, 22 Jan 2026 18:16:56 +0100
Message-ID: <bfefb0f8eaf0a59eb763b844c1c6c51e6bb639b8.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.43.0

