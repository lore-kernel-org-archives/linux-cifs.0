Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF676026;
	Sun,  1 Mar 2026 01:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330083; cv=none; b=Bdr4NH+nES1BDuoi4y0sMpYZ51xPzzneCR1+Lapi4/BuWV3REVv8E4DZl8D0qi4JR36v6Tp2HpgthtiCDCLfEzvM0z1peFTQmZdZmAANBHrPPHtXWRcD+auIXT912qIK9Hf1s8QPVoNFM8lLhZkFyoHMWcsEk88sPOC+tpnNoGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330083; c=relaxed/simple;
	bh=fh/VfEzNeWJBSvG+TqWd9BbBG2ZqA4cHRDoDv5SWD44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ekjR4KR2lKKKCgtDxV/g7n+gnmiq9Esr/CwVWsAmvtAk9dUqW7nv0Y0JgopZ+nzcnWWslzRRrIpNQ/dTfiv7mF9xH9uxB6d3Scu2qNkcjBqmbpghh/d/JC009VSg/znk6N6pOCdO5+c/ewpOWrO/8p7Cd82wPQQBKjjZmCGBzvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evn9UK33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evn9UK33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AEFC19421;
	Sun,  1 Mar 2026 01:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330083;
	bh=fh/VfEzNeWJBSvG+TqWd9BbBG2ZqA4cHRDoDv5SWD44=;
	h=From:To:Cc:Subject:Date:From;
	b=evn9UK33CtPIf8pPQr7b6oYkxbXIQ9x1q70hVuroHYAjXxoPrU+xAxPCLHc0iQ/E7
	 1u8X0WAZoXR3hIC2Xa7KVTGXuuJ+T+9UDOPbAouJ36cW4XxBn6OuIaMAytq4mPF4dB
	 GdDlvw1VXjshlhZw6GVTUmL+r2w64eTap+4D6NZCawWAEQvR9+RRwIYHDFcC3lwbTe
	 toKCD0UVwdf56pn4UF6ciriaG/08tzBcHL7L8rn/NAiFesEPngAeRNWWLJK9r565fc
	 X1cxKCnBlsJnWePk/D3GRIn0DpK8pbfeyExfUN6u2IptOLDnSwLRkRx41qarRFrRKq
	 YlxCkJqj/ii0g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: use smbdirect_send_batch processing" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:54:40 -0500
Message-ID: <20260301015441.1721730-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 2c1ac39ce9cd4112f406775c626eef7f3eb4c481 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:56 +0100
Subject: [PATCH] smb: client: use smbdirect_send_batch processing

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
---
 fs/smb/client/smbdirect.c | 149 ++++++++++++++++++++++++++++++++++----
 1 file changed, 135 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6cb40da7e5897..ef3b237bccc13 100644
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
2.51.0




