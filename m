Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459332C320
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095360; cv=none; b=sCj2nwtyu2KLhQMpS+bztpMsRgeYaVbgKMYmoa9mmSBYX30xkXRF+pVmiViKVgvawQ9jyzyQIFznlF+nBK9G0V9IHt+Hq36KbJxhBEP9TSypdva0a7tyu0yNo+RNa8FIZsSe0Dig0QLwajepAFdIVZHKDznn5S1colXEamwRZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095360; c=relaxed/simple;
	bh=t4b7HaoHH2b2DPSeuxSaVZlWb13dFhJpLmv/7E6ITpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhGof20Ou7n4/y1W3TkOACHB+rBvIUk1T+b4z9jk8wSpBYVxdEhI+TazllPbqDDpuftP4JuUs2hxwhYdyprULPv9VGfuAZIac/8RsXwfzn1i/Wsppl6nFM93qkXFWWEHox6EWLlTna5SKCX3XoQ7hZMcEq5LPK0vg/0VGGQafJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xU9RkpQg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xU9RkpQg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=YxIk446sp5RtKXzMpY46d++oqnke4cLjpBRcP2qXPAM=; b=xU9RkpQg+LYaQl/QuCmq80pbZq
	cGjuCWYGREmbqVf6s0qccDN19UvItIYYq5i2Oh2Kt1l6BiMVu7NprFEs/Zt03IC2n3svhk5c4IK0f
	+FP4CQV1Qqn8c6dD961mTKl3M8Q1qD+Q1TMEYIuPyBCM9FZR9NYLxdquVtRu4U/N+0BymRJPO+7Oe
	gAWOmUc1m5bHJWijNhCjLZLFeze5qaX57qCLIUa1zEVB9vmNHP7DrgBpeG0/JFDl2sDKANgdhV7ic
	QgSaZALz26ATSuWzG9JrR56t9uGEINzVGVhDXmTKqhbtwuktk7YauS0iTOfIFPnm4vdSSMliD9+8U
	DtTO33D1P1mqdsM0HAzb/2GV/SG9hA3HHW4fziDThl2OiXDqpfrLr5+dAkWQ3zu6mqg5LOwwNiKPw
	whs0e4hgGsDFtxwDvJuctkiGPAlv8RS+UvKtCbrqxntgNGr81F+LBDEveQkMc0KiduYpj7R9yjT8B
	llPHEfPbv2fTe/++HH/n4LIz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxgc-00FfXL-1M;
	Tue, 25 Nov 2025 18:22:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 123/145] smb: server: make use of smbdirect_connection_request_keep_alive()
Date: Tue, 25 Nov 2025 18:56:09 +0100
Message-ID: <c71eaa1d7f1f2b9f7754294af6dfa668a0d55708.1764091285.git.metze@samba.org>
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

This will help to share more common code soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index eb3189a0b7df..8062759efc9e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -503,23 +503,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	return ret;
 }
 
-static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
-		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
-		/*
-		 * Now use the keepalive timeout (instead of keepalive interval)
-		 * in order to wait for a response
-		 */
-		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-				 msecs_to_jiffies(sp->keepalive_timeout_msec));
-		return 1;
-	}
-	return 0;
-}
-
 static int smb_direct_post_send(struct smbdirect_socket *sc,
 				struct ib_send_wr *wr)
 {
@@ -659,7 +642,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(sc))
+	if (smbdirect_connection_request_keep_alive(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

