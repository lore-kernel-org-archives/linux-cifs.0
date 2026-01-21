Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E7296BCB;
	Wed, 21 Jan 2026 19:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025104; cv=none; b=PahaeFXIJneNDmMlN5hRk2ZXQNvGa12kMmaPSD2OZ86p9mNMVnJs0VjASjsvs59jm0pBUiS89NDWKzk9jKdQlH0H03hgQziWnRIjFGJR9ApPzxlja5Ss011lb/yfPzeYAxEzSqVg3BgjHpCjF8qxRKFHOExumTilQCl0Hdo+vXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025104; c=relaxed/simple;
	bh=YKjVdlxgX+k07RFxcJp6qev4ppXt6i2yFYvMHLcm9cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMAhgtfyOFFwy9W3xUNna7syYxeUbKzvCoKNg20AqPmXfH8MWm2R/7keaWbxsBLFU/22zwphmPjK8kuZz0uAxzLwgPGUgLYcV/fjsckVh/4Im5Ip5b/GZgLkLvgNpYQgCHh+nonfyRNtGauJ00XJ4GsyX3XPsBF7/Fi2v72EL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Kcj1Xy+D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Kcj1Xy+D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/wzSvU1gIr44MtYwR8Jcfl+CclA6K5KajKRwe3nfuiM=; b=Kcj1Xy+DUKR3fj+MXDf4r5ZkaV
	reYIeym6bG2QLetAZjjQ/fGXeNIebZLKKStJJjsj87A/2s0hckQWkjOMcIhqNX3Sy5tBACkqEKG3C
	VUtXXTm8hVEkEgBpEb9WYusRO92sD/GLFW5jlEfV/xapIucupRnLCE3AnjKA97LUlXRbJEKJVUPDb
	15/kktg6eufmDZTWtfhy/T1rGxs71WBUf+maJWsAdodADke6bDrT6bRGqbQz3baAVrgxHfeLon71S
	uJpZaJmR+TsJf7QtIbNjM0aqNNn+aFfm47943CJHP70AUe/O9wCpLlQTVG+0pIZEI3DqByCXh3pMB
	ee9ry86tuzF8EhJIHG+2EGE78mm5EJfZDgCrzFXHBbp6erEb4uBEOPl/XPboBDtOf8MP/D9FIKZTe
	eOt2uz9JIXCCfonEagJ8bP2xc/u5FQINURPQxJqnisb4j2+axsd8AieUdVHR0zIid8bKLVjERzDyR
	BI+XhdO6DcyEqxb7hmR2Um2N;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEt-00000001e3E-204n;
	Wed, 21 Jan 2026 19:51:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 09/19] smb: client: let recv_done() queue a refill when the peer is low on credits
Date: Wed, 21 Jan 2026 20:50:19 +0100
Message-ID: <d99a54d035d8e0f6b1a6a0eea14b29c6bc2c114d.1769024269.git.metze@samba.org>
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

In captures I saw that Windows was granting 191 credits in a batch
when its peer posted a lot of messages. We are asking for a
credit target of 255 and 191 is 252*3/4.

So we also use that logic in order to fill the
recv buffers available to the peer.

Fixes: 02548c477a90 ("smb: client: queue post_recv_credits_work also if the peer raises the credit target")
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 797dcf6e29bc..826fe7cc6ab6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -663,6 +663,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	struct smbdirect_socket *sc = response->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	int current_recv_credits;
 	u16 old_recv_credit_target;
 	u32 data_offset = 0;
 	u32 data_length = 0;
@@ -747,7 +748,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 
 		atomic_dec(&sc->recv_io.posted.count);
-		atomic_dec(&sc->recv_io.credits.count);
+		current_recv_credits = atomic_dec_return(&sc->recv_io.credits.count);
+
 		old_recv_credit_target = sc->recv_io.credits.target;
 		sc->recv_io.credits.target =
 			le16_to_cpu(data_transfer->credits_requested);
@@ -783,7 +785,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		 * reassembly queue and wake up the reading thread
 		 */
 		if (data_length) {
-			if (sc->recv_io.credits.target > old_recv_credit_target)
+			if (current_recv_credits <= (sc->recv_io.credits.target / 4) ||
+			    sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
 			enqueue_reassembly(sc, response, data_length);
-- 
2.43.0

