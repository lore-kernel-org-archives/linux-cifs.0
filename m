Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F5118C2C;
	Mon, 22 Sep 2025 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570412; cv=none; b=TrKsyEsO2OYae8mC7xrKVmo6fG90eBX5PVCP8VPu3E7+tw6EaNhKFskswG0V2NNTomvMwzaUgCuEyFYRasltoPY9KDIu+3N/8AFy3BMHcpJ3S//Z/npY5nSWVfIG7ArVU4yW/eAx3iip2qziOoBtmaDNeWwKwIifMGsMQuzTrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570412; c=relaxed/simple;
	bh=vyz8fwbwgyLHVuFCkwQBjEuq92S9vukhPRQTjoPXXuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIbcjUZY/nLkl+xTUuwEYtdnNEDtID8XhKG+rdbT5ZtRZ7MzzLJk6p/mFXfJDkpOxk7Ovd7CudWbI8O6nSUdT5H3KiUQZgLlI0hN79Pr57s9iNVkN7HiyZm1NpITVpiVM846D/zqOrzPC4+u3fcqINI8v5FTnBAdQScSBJ8Aisc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWals01x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWals01x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1A5C4CEF0;
	Mon, 22 Sep 2025 19:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570412;
	bh=vyz8fwbwgyLHVuFCkwQBjEuq92S9vukhPRQTjoPXXuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWals01xCayvuviRMxThsXYExsgk/dUC/vjHzlbPjD0rF4rTFR4eRi2czOi9IeOC8
	 WlIxFzQ8opWDZ/nsm4YMUkg+FnnurdK/yycQ7q2MPHmckI5emyQH/ihJ/jG4q1mz7G
	 0/KcAwf2Duv+AlWOBo1DG02rodBK+lXhOFiHZ5LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 127/149] smb: client: make use of smbdirect_socket->recv_io.expected
Date: Mon, 22 Sep 2025 21:30:27 +0200
Message-ID: <20250922192416.077695912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit bbdbd9ae47155da65aa0c1641698a44d85c2faa2 ]

The expected incoming message type can be per connection.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f57e53ea2523 ("smb: client: let recv_done verify data_offset, data_length and remaining_data_length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 22 ++++++++++++++--------
 fs/smb/client/smbdirect.h |  7 -------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b9bb531717a65..a6aa2c609dc3b 100644
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
index ea04ce8a9763a..bf50544eaf02d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -157,11 +157,6 @@ struct smbd_connection {
 	unsigned int count_send_empty;
 };
 
-enum smbd_message_type {
-	SMBD_NEGOTIATE_RESP,
-	SMBD_TRANSFER_DATA,
-};
-
 /* Maximum number of SGEs used by smbdirect.c in any send work request */
 #define SMBDIRECT_MAX_SEND_SGE	6
 
@@ -187,8 +182,6 @@ struct smbd_response {
 	struct ib_cqe cqe;
 	struct ib_sge sge;
 
-	enum smbd_message_type type;
-
 	/* Link to receive queue or reassembly queue */
 	struct list_head list;
 
-- 
2.51.0



