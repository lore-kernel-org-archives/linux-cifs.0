Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636F037A3A2
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744551; cv=none; b=bvptyCAFcvNYNYuN9BIKtsRkDV90jcxg/dnE9uVYQ/cpvUSEuaDUpI6oUw/Sveo5GTNC1D8dEEAXyohGzuptguljIrPm6RHBGIuRFiemA+3SA8AESJeWv6eWqGO1gvrz/LS4dfACCgidrjx+mY13gqxjnDuC5M+BbFnJ145+d28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744551; c=relaxed/simple;
	bh=njGjZQ0rOCSYXUNtD81rslahwGjEqk8AiSOoboZtShw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzFrT5HRxViyF4hkkDksculuqGwosfAUCEgoYdWtl1wYWeHNKke7raRJy54zxa70yxbC7C3iydCqVteSSbDjIQU6KLoSZ7RbH68e5s+tWjJYrDeRfiFONFiWc5fxLBXVmvX2Cq5pffKv3fGVbmN0t/2YjtuaQMrRYgdcnOho9jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=SWptCPkR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="SWptCPkR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3GRMQzqPED2TUKbgwtiPX5lwV4uGy6u4Gjr2nPPJ8wk=; b=SWptCPkRcnZt19BC0y5hFZuR4E
	9gXpPFCPmwpgLnkw31Ux76b1N3/o4dBd31EvuJibMXG2psM1VeNGuHlLW6GY2vBUZAnyDFmMl0Tii
	gciS4Lrl8JgqT3GKosXD8qKuyzmXbFa3f6dw45sVETB2o4CYdXPz5XL8ySXNQmddrcSsQeiaEsiM7
	kPQs5TGcezDUTz4zCRy1Ahda3gOmzGp961fgWwcGG9Roh+RFjqTPjVZQHLui8c97MD28a4x0ZEIHn
	/hHT0d0Ww3NDSepfDWyeEYacFAcZcTSGedReF/y0Njv6LAeAtIyjc8ELpwXtTQks/N7olo7vdsXJ4
	xHfE7FBv8SYMNmqammEfNkKt0reDY/RCQGGxpPG02WM1yzJNnLKwUUJEvymUXKbteyu3eqoYBWWKs
	jtZ8Qqr3vdDfwX6ElvrIcRp2snhy57aywSNKkPLH0YmNCi9AcZuXF2w5NGCrpDY1F+3zvPPysCvA4
	OdYzeMON8bqJM1hJKfSzTtH4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Eb-00BcC1-1k;
	Wed, 29 Oct 2025 13:29:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 067/127] smb: client: make use of smbdirect_connection_send_io_done()
Date: Wed, 29 Oct 2025 14:20:45 +0100
Message-ID: <93518a8f18698c563bd4c24af6c77130464b0e08.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This handles freeing of siblings too, which is used on
the client yet, but that might follow later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1eed0686a34d..ba6f88e8f33c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -387,38 +387,6 @@ static inline void *smbdirect_recv_io_payload(struct smbdirect_recv_io *response
 	return (void *)response->packet;
 }
 
-/* Called when a RDMA send is done */
-static void send_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct smbdirect_send_io *request =
-		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
-	struct smbdirect_socket *sc = request->socket;
-	int lcredits = 0;
-
-	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
-		request, ib_wc_status_msg(wc->status));
-
-	/* Note this frees wc->wr_cqe, but not wc */
-	smbdirect_connection_free_send_io(request);
-	lcredits += 1;
-
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
-				ib_wc_status_msg(wc->status), wc->opcode);
-		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-		return;
-	}
-
-	atomic_add(lcredits, &sc->send_io.lcredits.count);
-	wake_up(&sc->send_io.lcredits.wait_queue);
-
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-}
-
 static void dump_smbdirect_negotiate_resp(struct smbdirect_negotiate_resp *resp)
 {
 	log_rdma_event(INFO, "resp message min_version %u max_version %u negotiated_version %u credits_requested %u credits_granted %u status %u max_readwrite_size %u preferred_send_size %u max_receive_size %u max_fragmented_size %u\n",
@@ -864,7 +832,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 		sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
-	request->cqe.done = send_done;
+	request->cqe.done = smbdirect_connection_send_io_done;
 
 	send_wr.next = NULL;
 	send_wr.wr_cqe = &request->cqe;
@@ -963,7 +931,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 			DMA_TO_DEVICE);
 	}
 
-	request->cqe.done = send_done;
+	request->cqe.done = smbdirect_connection_send_io_done;
 
 	send_wr.next = NULL;
 	send_wr.wr_cqe = &request->cqe;
-- 
2.43.0

