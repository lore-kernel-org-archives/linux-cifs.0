Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF632145A;
	Mon, 27 Oct 2025 19:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593164; cv=none; b=gCVvKmpyOaSg+I25nMhnWHYop2NKOIZrMoqLyhdpTIzAZgx7P1klvMEUX4hM1GlUNZGxDpB/n0MNfiDQB9Evn+PiI9hsGA2z82RBcI8Y6YDCu6TqUWJfhhjw2vg4vE1/ghqe9JP3voNiHfxO33jq+S6AL3H47kiiT0fy2sext1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593164; c=relaxed/simple;
	bh=sYpNS3X6C6KrnX4bYMsptICUZskOho3g0XIx57p4h9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uloqgkbPdQ0I4xfmuSBagM1TO+JAMjUL2CccXSbmeoSMU77+IVBrQPh8GrpSKHv49MrcieZNsSBisiJFpkSkkGjkCi/teUYWicN1NOI9SfbSoNHpC5eC4NTOWwQFtVcss2LxpqTL/ovQERgTSGzSTTrr+ByVPfCqGzTKVFFDQdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUeNxS/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUeNxS/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21CCC4CEF1;
	Mon, 27 Oct 2025 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593164;
	bh=sYpNS3X6C6KrnX4bYMsptICUZskOho3g0XIx57p4h9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUeNxS/BNcraHVAk1X5uqOOSeIjqqa0KnI6PTlasAaNO583U02/b7SgIin4bsavBG
	 NFTTFDg2u7vxAmuk461XTj+n5EWMWJhmh25Mvh1If+18FTMjubydm3DqPO3N5g6xta
	 2Yi3LZJ6LeoqGhZTFRntTJxO2AKs0KChhuhfXwwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/184] smb: client: make use of ib_wc_status_msg() and skip IB_WC_WR_FLUSH_ERR logging
Date: Mon, 27 Oct 2025 19:35:12 +0100
Message-ID: <20251027183515.735545706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit a8e970358b31a5abba8b5737a67ba7b8d26f4258 ]

There's no need to get log message for every IB_WC_WR_FLUSH_ERR
completion, but any other error should be logged at level ERR.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cbf1deff11065..99fad70356c57 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -362,8 +362,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
 
-	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%d\n",
-		request, wc->status);
+	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
+		request, ib_wc_status_msg(wc->status));
 
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(sc->ib.dev,
@@ -372,8 +372,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 			DMA_TO_DEVICE);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
-			wc->status, wc->opcode);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->opcode);
 		mempool_free(request, sc->send_io.mem.pool);
 		smbd_disconnect_rdma_connection(info);
 		return;
@@ -543,13 +544,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	u32 data_length = 0;
 	u32 remaining_data_length = 0;
 
-	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
-		      response, sc->recv_io.expected, wc->status, wc->opcode,
+	log_rdma_recv(INFO,
+		      "response=0x%p type=%d wc status=%s wc opcode %d byte_len=%d pkey_index=%u\n",
+		      response, sc->recv_io.expected,
+		      ib_wc_status_msg(wc->status), wc->opcode,
 		      wc->byte_len, wc->pkey_index);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
-		log_rdma_recv(INFO, "wc->status=%d opcode=%d\n",
-			wc->status, wc->opcode);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			log_rdma_recv(ERR, "wc->status=%s opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->opcode);
 		goto error;
 	}
 
-- 
2.51.0



