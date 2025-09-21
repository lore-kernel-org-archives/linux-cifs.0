Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB80A2D8DA6
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491159; cv=none; b=mfm9ayvixmoiCKKKGK5UFIaIFhbMg2EVaXTblDCOh5LbyFus0XPoDWO65T7T/0wTaw/lhI/TPd0P17uNnnG2PYJkYP7p5Dx5tV4OuZ8qovU1s+syZwBQi7JIiRb60xyOS6eGRtsNC8XJbtpRhZFVvNcWplKOh31gxf/qx5t7fbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491159; c=relaxed/simple;
	bh=mF1xk/jIhPEoOJM+mx5O2nh904+d25vFtrGxCqIzUCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvaB9amascU6U6h1uBAUHt5s9yzZtntuXIu8cJBjs8PjdJZKv3MqpjUk3VJZ7fnUu4d1/z7Yy9A6iG2zFyb5paqajTGIUfe65w48oDLxMnSNfVdnvJ1x8JrbLgO8LcoBIpIym2zpP+a+2fDywZLeTo1CpnAmIIgRPahOgG4HyTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=u/PNzepI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="u/PNzepI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WLxyOl5j/c8NCJ8mJdA4JT68+6H8fxh8I+yKIFPCgw4=; b=u/PNzepISAhA6XzAJqxyebzUVA
	30GdARbuogVoirVcSmLVAGqC7u9Vs9edwGWjzlD/Z5HLcV/87/dOLBxFW9qljrykGMTVbccc/sung
	amVrh+ljWeZkT35QVaVAxrI+oiKAGFuIvGyUhxWA7sjBfRq3QxV1uaB9eH9+/7nUPePwEK6Wpfj74
	R0ZgOrBJSvBJzLQtY9WT7/gKVQ7BARjHIHyt/y6RqQhX7KGcCpBlLWio2Ti5gWXbn7S/UTkch/Zo+
	dxaqayVduxze1MgbbOosoqZeZ16aojttxx/xvS/AfJ+8cUBSDs4yCjLRJS4GR7CgY0jSdi4GlTur8
	qfkwiqpHwhJIvVl5D4hmeoTXkSHqRcBdtGSWJxs6EnauSxdRN48Svb9syxcveDC+Sc5K7jrXODv0D
	7BmYTleK13LlIRLBwmvtqYHP4RAzQ9U1Bf9TQ+0KqUg89ncbaNjrB/mFmhi6gCh8/en5YYuHKF+GC
	Wazcl/gHB8rg4xFybPq3eVZ9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RsY-005GMs-2e;
	Sun, 21 Sep 2025 21:45:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 04/18] smb: client: let smbd_disconnect_rdma_connection() set SMBDIRECT_SOCKET_ERROR...
Date: Sun, 21 Sep 2025 23:44:51 +0200
Message-ID: <336b5baaf425b2eacf3001d4157ef04ca4622392.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbd_disconnect_rdma_connection() should turn the status into
an error state instead of leaving it as is until
smbd_disconnect_rdma_work() is running.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7e0d2ecaa37e..38934e330096 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -217,6 +217,46 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	switch (sc->status) {
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_ERROR:
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		/*
+		 * Keep the current error status
+		 */
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_CONNECTED:
+		sc->status = SMBDIRECT_SOCKET_ERROR;
+		break;
+	}
+
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
-- 
2.43.0

