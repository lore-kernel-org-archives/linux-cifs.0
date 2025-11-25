Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3732BF4B
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094175; cv=none; b=ZlMFnlFLoi9HRQulg9SVVoG8IauvjHdCI1CBx4BjEukcev6ZOhvRaA+FF86QZGQu2trQa06lwfneC7uETwLVZyxqsB15F/UQb5H+79PC+R7t9LLvvGbNBjkpxgY0jYBdFtkK/vJN6JfGwb7IKld4vyZJxgbKScokiBPJIc5IRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094175; c=relaxed/simple;
	bh=r7POawP5SuD4BoS8hMMP7w4NGBMKawJVr9oRRwlCwa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHHdVISI7+1Masapozjsgn1EbHflNdDXCM/8HQ6HUnsdNC0+or2WKeOi6BR0HSwdnXAXOzki+qDUwsD92QnpXszTaE5Nf0OjHFocjQiqMegJIs8KyKcL9LOjUEhhmvV5wVIjvHVpQ0fNscvvzfgs6diW45FSnHLiE0XpyQpQou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=FzZ/KaxW; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="FzZ/KaxW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mrEmNSi61tqKa8cGV5xxsIC9zqbONXr7PvMRMMgcgd8=; b=FzZ/KaxWZpugFFQtWwbmUX5Dtw
	wLdePV+IQzjGqXIc/CZh84BOk0aCqhzgpuOBi7tcKaiHnF1Y67weXBlJzu4ebPypJLEOdkqkdhpWc
	O7NypZhH5VBXFN2Osj//nL6tSM8drX1z6tHxWgosjKHlDCUNYpftKWaB5L/sf7m4A8JK+WHJf4SVX
	laSPKee7+d19OzLX51bbxzHUvyQnNoDdRF8kpyLZ2sKe59Glvj+dOv71pwjbGra/p/d8U7ylE0c9m
	uObLjTYH6lfEDtTJ5TsB81llN10+jzsOWhqDMDPfkEf0uVwiyUh9w+2q8qdczruXG8Zm1BRO2S0Bt
	1x5Psmso8AaUi38hLodv8wFXnDW70CMrI5AWDMhsVpfrbfsU4RXjAqIDQnmVrOEOANWnfZlkTGdGl
	X1YWN+YDBY62Lx7ry0lb5zA/9Q49n2BzrGWYEI3Gp+Zl8a9TprYw8xSwwjIjU3H6Qh8TWfKCqexMe
	eeGl6JyfH+rmQmbjnLJks2O6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxQE-00FdhY-1y;
	Tue, 25 Nov 2025 18:05:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 072/145] smb: client: make use of smbdirect_connection_send_io_done()
Date: Tue, 25 Nov 2025 18:55:18 +0100
Message-ID: <bbd53c94fe680e96119c15bd67f4989259ec870c.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
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
index e1a2238d249a..6c8844c4edce 100644
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
-		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
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
@@ -865,7 +833,7 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 		sc->ib.dev, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
-	request->cqe.done = send_done;
+	request->cqe.done = smbdirect_connection_send_io_done;
 
 	send_wr.next = NULL;
 	send_wr.wr_cqe = &request->cqe;
@@ -964,7 +932,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 			DMA_TO_DEVICE);
 	}
 
-	request->cqe.done = send_done;
+	request->cqe.done = smbdirect_connection_send_io_done;
 
 	send_wr.next = NULL;
 	send_wr.wr_cqe = &request->cqe;
-- 
2.43.0

