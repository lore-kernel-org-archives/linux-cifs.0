Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7D2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154834; cv=none; b=U87sHpzA3100aXsGliu7O+J9k/k5LEfMZLFJpS0Q+GO3LLvjonqWlPIEPLjtPPwd8xoYJFP012jxJGaLwGo6RcYO0ir26eD2bUXU078ysuqik1rtgG3ZUf2Wg8nrFOPWxFdyGTBL5xoES7zlFLzXMiy20rK46jF1wDt1jPWGSts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154834; c=relaxed/simple;
	bh=fcW/6wiTpyuYU+k0QtiQFmQfpDkBI24yS80dYWEJqQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhMyj9vkZ11e8yc5BGRCXxKZ1mfgH8ewbjUzwmq6Cw2G4GPinIQNRns+yYsiXYNI8hwxWac+O0uagSmmpCQ5hzT1gPtDLrzqtAXWbdFM4mnV8+sHo+7aXS/WpUyH9l49LKJwve82owzIIE5bj5wiDaPMyMF24NOuTD3zQY5pJpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=O+pzgjfo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O+pzgjfo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WY7FlQ1xdCbSs80M6oO3Fud5yDCsPp1VxliFdR5dWe0=; b=O+pzgjfoswqUXpncAB8WtuxYcK
	bImNCgOuiVCA8q408FjDRMpdgTG4rCGrnNh9bGLzPuroZzMJFjFuEczxr358Mae/06MZsWPav6/EO
	QRwIF2g8otkTJrdvwkny2qMdk90PuVs8UahdGW/6SkhU5WwsQuXyFgdQNB+AXDhUde59q6tMyt67+
	kXs9VNHNAZfSsxRQow1joB81CdCbVAOnyQTQ9ZRFcehHBXvhFlP3E0unqMyuKfkkT7d+CWfooEKIq
	kyNNLm0wCOBICjJq7otGVZBxOSO2FCx+rIOt5htH5MCykr/AEvU4/wRP4OyUfqqob8B3kE/q+0jAw
	RlBoc7jQfHtg2FdtRnqYZetqttZr/SHF5dKl4h8xnUxRD19BTQyewuzvWnAxg7OCQJBXXbL3i4xj9
	ABd5TAbwz92GmOvZMuYlURRUHp96eVn3zpZFv1Ecs0w3hdDb7DQ5RI0OyxLJHxDGMnlSUkVdWqAu9
	VXOGHjLvnOWj7tj/H8GbRWQf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe5t-000kGv-2q;
	Mon, 25 Aug 2025 20:47:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 032/142] smb: client: make use of ib_wc_status_msg() and skip IB_WC_WR_FLUSH_ERR logging
Date: Mon, 25 Aug 2025 22:39:53 +0200
Message-ID: <a3fb8f061368a0f2fa6cc40b64ea8d744a0eabb0.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to get log message for every IB_WC_WR_FLUSH_ERR
completion, but any other error should be logged at level ERR.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 40aafc606ac8..ec3ebf6e3c88 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -388,8 +388,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
 
-	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%d\n",
-		request, wc->status);
+	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
+		request, ib_wc_status_msg(wc->status));
 
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(sc->ib.dev,
@@ -398,8 +398,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
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
@@ -566,13 +567,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	int data_length = 0;
 	bool negotiate_done = false;
 
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
2.43.0

