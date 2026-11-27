Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797683;
	b=iEkTgcvAu9tRpyFOEYeWcWmM+HJ4TiQiR4XbibnWRubhvfJ+Nor/6D2qr+aZLpMh+zwb
	 WbCWIdLi/ZA6Rk/QT/IKInjz/F9Kd6ubcdWBo0+TNYS645pHGS83x4641OnxI5xlmHny9
	 DAhWvKb/pVUo7LiPOY75cuofS5ryG4+TWdHJuRC1wNhm56jOVYOfgKUOLf3695GWHyjv2
	 yl1CDyyExUwEcqxeY2b11DD6l4GOK1CwVilg2YCoKCvqm22RnUdkmoH3oIED4ksSPniJC
	 D062HKYIyDmirbZOie/rsYVPNsntZ50USMZGWh4bJ1zXJt9TReaMwXD6FGaFPKCt+Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797683;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nONdiAUy2Umd1HR/3H3eDz2F0J8MgIQCkXdnCOHopVA=;
	b=YXI+dy/1deLZV+0+q7C7KM3Z0BWB7c9OTrhJ0lm93YJ+boTLSQpRfT0a10V+kxpQbmKZ
	 5bJ4fPu6vNorrEUrhaN6wIh+vYXKKd9rTX0KRtRgsN+/tr+NY15SKeATHl9aFSwcPO0Uy
	 DoLz6aiG0NS5ENrSuzTgyUeWTJ5EeGFUULngu9HGTIFfy4g/Bu+tHYmUd5pQCt3vhf6HB
	 sj/8LSBMv7txEww4A6mrgc6OMZa5oNAbRsSjxs5FBVsYScKM0UQhoTNSP7K3770CFEgtw
	 dqjmsw82vYl0gV1vziGpayO3Vvd6E0t2EohJxM/wWMOaleFl39bfK51hTHg/VX4OrVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=IHaP8T9y;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E5606A6A5;
	Fri, 27 Nov 2026 16:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E72E5606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=IHaP8T9y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nONdiAUy2Umd1HR/3H3eDz2F0J8MgIQCkXdnCOHopVA=; b=IHaP8T9yNfDqLV8kqOiurRxiyP
	TVYZUmGeTZkeusRUyFZHtq/ARjKdBXuDKUzKt6WlqmxCqzH9jMnCOjyYZ5BfJol0+U3Cr5KKYx/Sq
	t6BP5FiZtitHiy5VIX08dko9f9TyNsq7xufkgpa9oadHj0dWDKMY6ujAj3O2nTlbgHzP907cGAPyl
	yrL6oqmX9W9H64pYzSpqp+/AAothp3MD9HmahdgS3949WN9m1eK2XcFe/IZyLKX8cd0Oet+GS4dL9
	gqWAz4n/ycpCEIFk/ZlZQlNNloXuA2zhN4zKlLdL2KU3+ZXVvptb/y8L1Tf02iglhxK//yvSGZaVQ
	hUT7uL0UbmpfHbbkGM/LMdgwhVie9Wk9fOnhqyC3SETknADpv5bBUksYCeD5fz44JsdI8HH0IyS3h
	d4/1eNi7Cmwk8PCEDxSYV8Vu8J+Xq0IXcci8Y4mjwOWVUllRKq0fkoyceJkBD3jUHSg5R2BSgfVhd
	UWKQmT9N5vA9PL+SUtTwl1sP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0f-00000001Pxb-30ed;
	Fri, 27 Nov 2026 16:41:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH v2 07/13] smb: smbdirect: use separate cqes for MR registration and invalidation
Date: Fri, 27 Nov 2026 17:40:26 +0100
Message-ID: <e811c1a4d6cc1dcac3784af0b500950c216a5faa.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbdirect_connection_register_mr_io() posts a signaled IB_WR_REG_MR
with mr->cqe.done = smbdirect_connection_mr_io_register_done, and
smbdirect_connection_deregister_mr_io() reused the same mr->cqe for
IB_WR_LOCAL_INV, overwriting cqe.done with
smbdirect_connection_mr_io_local_inv_done.

If the deregistration happens before the REG_MR completion was
polled, that completion already ran local_inv_done(): it set the mr
to SMBDIRECT_MR_INVALIDATED and completed invalidate_done too early,
so the mr went back to SMBDIRECT_MR_READY (and ready.count++) while
the LOCAL_INV was still outstanding. Its real completion later set the
already reused mr to SMBDIRECT_MR_INVALIDATED again, leaving
ready.count counting mrs that are no longer READY, which can make
smbdirect_connection_get_mr_io() spin forever.

Rename mr->cqe to mr->reg_cqe and add a separate mr->inv_cqe for the
LOCAL_INV.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/mr.c     | 12 ++++++------
 fs/smb/smbdirect/socket.h |  9 ++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 7c7607c26b0b..68b9ae5ec0c1 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -242,7 +242,7 @@ smbdirect_connection_get_mr_io(struct smbdirect_socket *sc)
 static void smbdirect_connection_mr_io_register_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_mr_io *mr =
-		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, reg_cqe);
 	struct smbdirect_socket *sc = mr->socket;
 
 	if (wc->status != IB_WC_SUCCESS) {
@@ -256,7 +256,7 @@ static void smbdirect_connection_mr_io_register_done(struct ib_cq *cq, struct ib
 static void smbdirect_connection_mr_io_local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_mr_io *mr =
-		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, inv_cqe);
 	struct smbdirect_socket *sc = mr->socket;
 
 	mr->state = SMBDIRECT_MR_INVALIDATED;
@@ -389,8 +389,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	reg_wr = &mr->wr;
 	reg_wr->wr.opcode = IB_WR_REG_MR;
-	mr->cqe.done = smbdirect_connection_mr_io_register_done;
-	reg_wr->wr.wr_cqe = &mr->cqe;
+	mr->reg_cqe.done = smbdirect_connection_mr_io_register_done;
+	reg_wr->wr.wr_cqe = &mr->reg_cqe;
 	reg_wr->wr.num_sge = 0;
 	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
 	reg_wr->mr = mr->mr;
@@ -511,8 +511,8 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 
 		/* Need to finish local invalidation before returning */
 		wr->opcode = IB_WR_LOCAL_INV;
-		mr->cqe.done = smbdirect_connection_mr_io_local_inv_done;
-		wr->wr_cqe = &mr->cqe;
+		mr->inv_cqe.done = smbdirect_connection_mr_io_local_inv_done;
+		wr->wr_cqe = &mr->inv_cqe;
 		wr->num_sge = 0;
 		wr->ex.invalidate_rkey = mr->mr->rkey;
 		wr->send_flags = IB_SEND_SIGNALED;
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 4dcbd9c86aaf..1fc4aebcdda5 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -826,7 +826,14 @@ enum smbdirect_mr_state {
 
 struct smbdirect_mr_io {
 	struct smbdirect_socket *socket;
-	struct ib_cqe cqe;
+	/*
+	 * Separate completion entries for IB_WR_REG_MR and IB_WR_LOCAL_INV:
+	 * smbdirect_connection_deregister_mr_io() can post the LOCAL_INV
+	 * before the REG_MR completion was polled, and with a shared entry
+	 * that completion would then already run the LOCAL_INV handler.
+	 */
+	struct ib_cqe reg_cqe;
+	struct ib_cqe inv_cqe;
 
 	/*
 	 * We can have up to two references:
-- 
2.43.0

