Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2411C8603
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410341; cv=none; b=WWdlgPUGwFIcRddT1ECEI9iq5K3YZQhJtk2F9oEviMM0trDVMxpAsqSt8IQasldzNOaFQmZY0z5fMoC4W+2BC/LikLpPaszJNaI/YKXmM9aK/hPOYxADA51iugjKuKTE2ZRxIaMo87RJxZaXH0yZ5fGXas3WoPn98rYKFBkgd7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410341; c=relaxed/simple;
	bh=Gx9aZgVdIoMryvyQSxDDvkHlR/8g3XInBmsfw4fG/do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLkbDaDTJky7Xk4i2umFtW5PTZGTcRIRXqqZkh3I6aUnx5uaXH6XFF/KV8TuV6aI67COI+p9hiL0ABcrEOcDFibRPL5xv3rMMzdJ8P4xSbMwVl+iMr5f0w0woiPu3xBF8sk4MFXFY2wcYD6I+vkYzhpz2AXMlawLqhTAGZxcih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=njWtkBLp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="njWtkBLp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8GwEC7hRFHKsviZ32lm5plSOJQJSPboCtc2hziEAOsM=; b=njWtkBLpdfrt2zUecw/WNGVo43
	zfK+ZKS0GmyxZgdIEmRjEHTyNz5+XejRz3fyIfPHzGmNfdvt76a0ULsDx4BHapgHltEIFHnclJVVq
	4WOKRCoL7iCgG2FkEQ+ZNKXhCPFWbmNmcVHa+/vjPL/2Krb7bTQ4sdpiv8zqR/sNnzWXn1X6kj0+5
	Mt4ONpvH02LE5Ma94DD3Nem9DkFo9r1CwtlQH+pTJ+yAcLuXLGlHwTr0ZQ3nBVKJyf5hVi+Sak34P
	p1hd6Np+lU2/v0/Xyb+nJMDhi8g7NUA4TG2J2TLWi10TZ/1P+JX9FUf4cl4rws8bEVhWZIQja5YLU
	aCUBdL2Cx9GwbBlMS6dQpc5SByfLwDfn8+ejn2fnu4t7FSAlH0M00BsWgkCI6EjRqFl441ntEssLM
	VKI/tIGGKVRVzus3DusHNZ1IJCRTGgBJMGFIjqix2x8FjhRLWSUZo5XYbTxwN/EE+JyevaHZVJV8u
	YV05nze3TItzZoFKsNQpU/Hr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKGt-0019a4-0k;
	Tue, 05 Aug 2025 16:12:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 03/17] smb: client: make use of smbdirect_socket->recv_io.expected
Date: Tue,  5 Aug 2025 18:11:31 +0200
Message-ID: <62e9aec0798c3161fb91d78e988a9bdcfedf70a7.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expected incoming message type can be per connection.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 22 ++++++++++++++--------
 fs/smb/client/smbdirect.h |  7 -------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 58321e483a1a..db3ca03ac90d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -383,6 +383,7 @@ static bool process_negotiation_response(
 			info->max_frmr_depth * PAGE_SIZE);
 	info->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
 
+	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	return true;
 }
 
@@ -408,7 +409,6 @@ static void smbd_post_send_credits(struct work_struct *work)
 			if (!response)
 				break;
 
-			response->type = SMBD_TRANSFER_DATA;
 			response->first_segment = false;
 			rc = smbd_post_recv(info, response);
 			if (rc) {
@@ -445,10 +445,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
+	struct smbdirect_socket *sc = &info->socket;
 	int data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
-		      response, response->type, wc->status, wc->opcode,
+		      response, sc->recv_io.expected, wc->status, wc->opcode,
 		      wc->byte_len, wc->pkey_index);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
@@ -463,9 +464,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		response->sge.length,
 		DMA_FROM_DEVICE);
 
-	switch (response->type) {
+	switch (sc->recv_io.expected) {
 	/* SMBD negotiation response */
-	case SMBD_NEGOTIATE_RESP:
+	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
 		dump_smbdirect_negotiate_resp(smbd_response_payload(response));
 		info->full_packet_received = true;
 		info->negotiate_done =
@@ -475,7 +476,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 
 	/* SMBD data transfer packet */
-	case SMBD_TRANSFER_DATA:
+	case SMBDIRECT_EXPECT_DATA_TRANSFER:
 		data_transfer = smbd_response_payload(response);
 		data_length = le32_to_cpu(data_transfer->data_length);
 
@@ -526,13 +527,17 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			put_receive_buffer(info, response);
 
 		return;
+
+	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
+		/* Only server... */
+		break;
 	}
 
 	/*
 	 * This is an internal error!
 	 */
-	log_rdma_recv(ERR, "unexpected response type=%d\n", response->type);
-	WARN_ON_ONCE(response->type != SMBD_TRANSFER_DATA);
+	log_rdma_recv(ERR, "unexpected response type=%d\n", sc->recv_io.expected);
+	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
 error:
 	put_receive_buffer(info, response);
 	smbd_disconnect_rdma_connection(info);
@@ -1067,10 +1072,11 @@ static int smbd_post_recv(
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
 static int smbd_negotiate(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	int rc;
 	struct smbd_response *response = get_receive_buffer(info);
 
-	response->type = SMBD_NEGOTIATE_RESP;
+	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
 	rc = smbd_post_recv(info, response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index a2026c542989..dbb138900973 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -156,11 +156,6 @@ struct smbd_connection {
 	unsigned int count_send_empty;
 };
 
-enum smbd_message_type {
-	SMBD_NEGOTIATE_RESP,
-	SMBD_TRANSFER_DATA,
-};
-
 /* Maximum number of SGEs used by smbdirect.c in any send work request */
 #define SMBDIRECT_MAX_SEND_SGE	6
 
@@ -186,8 +181,6 @@ struct smbd_response {
 	struct ib_cqe cqe;
 	struct ib_sge sge;
 
-	enum smbd_message_type type;
-
 	/* Link to receive queue or reassembly queue */
 	struct list_head list;
 
-- 
2.43.0

