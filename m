Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962BE367F41;
	Thu, 22 Jan 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102267; cv=none; b=FH5ovWximfZrkXS6lvD/2X+fyx2bY7ossLFsgRl6Yfv0rW4pDN6TqltPY4ITk6RgzLPK+Yp4SSavGjgy14YTcwkHM51LpF4ZGdOnYL/SkLgPPZTh5WgKdEQ8EU7TwNzOuzRYCUINzDIasWV6ysaTQYp+yAroOtWWgJN1xKEHyGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102267; c=relaxed/simple;
	bh=WVpmwjVL4ytXaU0uq3a1Vzf+bxlwpRv3OkJSfOYqmFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPBs6VhyVBURBWhP9vbdPRdPwJpMXJ9018lJWWcabxlKtQLhWS1hoUL70/xU4/8UXcyTpehvKNw+uPRta4gOkzfsKr2UNCY+ZEEjcQs9n08mkkv1WR3q1LK6BUntzKuaRZq2V2Vu8HSvydXVafX6ZcN6UWm+Z1rjAAQ2IAk53SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yUfiiA8G; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yUfiiA8G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4EO8bAl8gFEWGeHfVG9voc/P6l0oJJbWHuwJLQ0bovE=; b=yUfiiA8GMN/zFPQ7hbto1LNKku
	6EsNVKizcbcSEfdZwACw6bomRpu9nGEvLiXyNARCj5VpQEh2Z3cAKc5COmvDYDUjfBPl3+IcwYvAW
	xzV/ib34nSgPSiCceErReCM0d9E5PmRkWnFIZyyi0yrPOKQJ+vRW15IIwxhCwy27hKU2kWmA2aaOI
	yw7GHkg/YBoMiaMRjZ45QCGo9B5cPOuUs7QGZflQA5ebz17urCPvIluXLRh7+aw429arTgpstyuRj
	38PqH5U4k8L8GDcSCzBWm/FFIWCpOiqCmGv2w6cVz08H/boQVQ23Tq0bltodSYFfYPcFQjGXPaEFd
	Rk0XrAstbZYd1v73Lb02VWXJSQZsmXPl/vFwjLiLrQRBwuehmXDYOnvIl3ykyAHIUHMMqo3EuFJAW
	4bn5P1gC5ahNc3OjsGvGmM14FrZxHZu9MVFSj/StdBJwV/4ieP5XaMoiK/Eqolts6sh/v9Z3Cm/cN
	LZ2qBlsVnsXh0ESJ2UuXiRHx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJO-00000001pl9-20O9;
	Thu, 22 Jan 2026 17:17:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 05/20] smb: server: make use of smbdirect_socket.send_io.bcredits
Date: Thu, 22 Jan 2026 18:16:45 +0100
Message-ID: <a8099fb9dc892cc82e83aa703379b71719019073.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 53 ++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index fc29b4c3b645..84a654715ed5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -221,6 +221,7 @@ static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.bcredits.wait_queue);
 	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
@@ -1152,6 +1153,7 @@ static void smb_direct_send_ctx_init(struct smbdirect_send_batch *send_ctx,
 	send_ctx->wr_cnt = 0;
 	send_ctx->need_invalidate_rkey = need_invalidate_rkey;
 	send_ctx->remote_key = remote_key;
+	send_ctx->credit = 0;
 }
 
 static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
@@ -1159,10 +1161,10 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 				      bool is_last)
 {
 	struct smbdirect_send_io *first, *last;
-	int ret;
+	int ret = 0;
 
 	if (list_empty(&send_ctx->msg_list))
-		return 0;
+		goto release_credit;
 
 	first = list_first_entry(&send_ctx->msg_list,
 				 struct smbdirect_send_io,
@@ -1204,6 +1206,13 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 		smb_direct_free_sendmsg(sc, last);
 	}
 
+release_credit:
+	if (is_last && !ret && send_ctx->credit) {
+		atomic_add(send_ctx->credit, &sc->send_io.bcredits.count);
+		send_ctx->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
 	return ret;
 }
 
@@ -1229,6 +1238,25 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+static int wait_for_send_bcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *send_ctx)
+{
+	int ret;
+
+	if (send_ctx->credit)
+		return 0;
+
+	ret = wait_for_credits(sc,
+			       &sc->send_io.bcredits.wait_queue,
+			       &sc->send_io.bcredits.count,
+			       1);
+	if (ret)
+		return ret;
+
+	send_ctx->credit = 1;
+	return 0;
+}
+
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
 {
@@ -1432,6 +1460,16 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	struct smbdirect_send_io *msg;
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
+	struct smbdirect_send_batch _send_ctx;
+
+	if (!send_ctx) {
+		smb_direct_send_ctx_init(&_send_ctx, false, 0);
+		send_ctx = &_send_ctx;
+	}
+
+	ret = wait_for_send_bcredit(sc, send_ctx);
+	if (ret)
+		goto bcredit_failed;
 
 	ret = wait_for_send_lcredit(sc, send_ctx);
 	if (ret)
@@ -1483,6 +1521,13 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	ret = post_sendmsg(sc, send_ctx, msg);
 	if (ret)
 		goto err;
+
+	if (send_ctx == &_send_ctx) {
+		ret = smb_direct_flush_send_list(sc, send_ctx, true);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 err:
 	smb_direct_free_sendmsg(sc, msg);
@@ -1491,6 +1536,9 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 credit_failed:
 	atomic_inc(&sc->send_io.lcredits.count);
 lcredit_failed:
+	atomic_add(send_ctx->credit, &sc->send_io.bcredits.count);
+	send_ctx->credit = 0;
+bcredit_failed:
 	return ret;
 }
 
@@ -1962,6 +2010,7 @@ static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 		resp->max_fragmented_size =
 				cpu_to_le32(sp->max_fragmented_recv_size);
 
+		atomic_set(&sc->send_io.bcredits.count, 1);
 		sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 	}
-- 
2.43.0

