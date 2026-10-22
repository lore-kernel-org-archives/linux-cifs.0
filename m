Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661177;
	b=N0IaC/abniigQwMoj2W5FNGPYU4pqahYlpCNM1sAKNF1N4At7x3Z8/5kqS10If6RVcYI
	 HzQO0UY1IpreSvGuqm/aLcdzHLTxhsNwUeLsxKNCnXroYUVym57wgjHgQi/R1nIN6S/hu
	 Z64/t5LL9Hm5MseD6ovPbLI+Cgjb/i48bWK1UXaR947mreF4CfQbdnoQHHVDCS20Z0mSP
	 alrgLfkXdC/gOHzzTJBOJu0j9uNF1UMBG7qwoEughW/Xg6ETYndYiiilpRaM4OWVj2a8r
	 Dd4cIEk0i/YvCL5jyJ8Vo4rbgGX0olJ14QgrwSX5j4LXDLhYJFSck2vOs+bOwBqkqMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661177;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ghkMz/g3tejAvAT/rxExuil1ohhPdSLUMsWHQYHwMIY=;
	b=Kq8Ned6MQpjSzQumcweO3cXSpSBXmlzgHnjEV/7mZCEME8+TetBaS2Ttp47CKuIufXO5
	 EX/oY7yUA275sY17BdkJMdr5wydgiFnRelkwRBKd28yYAmBCXAZCJJFKxX8yQ/dNOgbpz
	 wQBgTAhHU3MPEdChjIghyxwnkeWMJ3uwCGunRimDbDc9TjCGD0npaZ/K2wDa0kGEJ8LEf
	 HD95robXKST9GpPrb83PeIQRUbZ3vLEJMQ+CDnz5hw/XBpFS75aiBZ54VR5ea71iplJTr
	 aseqWkCwS9+4ijlzm2xRn8KnWJI9SOvde2b5Wb9ojGQGP+D1X168Xizi0wo5D+ru7Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d7JDnC01;
	arc=none smtp.remote-ip=91.218.175.213
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C91606A321
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 09:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8C91606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d7JDnC01
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Jx7cDYVsfvdW3m5n+iUO6RUEFcRkrv2E6s7JGfmFJWg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792661173; v=1; x=1793265973;
 b=d7JDnC01jkydth9gxEtcMK2aTrlQ0h7E7giIHQXzVM4IV1DXpy1X9IgM/eJQlLAWVqemfy9f
 Gz5zpe8LbgkQOZipHVY6LE9Kpuzu6maRGxYQ/0G0u2DZyl4ndON88hs7omIbkB96KjlW9SVE2rH
 jW+PMHyK9RPQnIqANa9vEwfo=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d39b9d4e59737096;
	Thu, 22 Oct 2026 09:26:13 +0000
X-Mizu-Trace-ID: d39b9d4e59737096
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	tj@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4] ksmbd: complete TCP frames before reporting send success
Date: Thu, 22 Oct 2026 17:25:13 +0800
Message-ID: <20261022092514.2590010-4-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022092514.2590010-1-huiwen.he@linux.dev>
References: <20261022092514.2590010-1-huiwen.he@linux.dev>
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

From: Huiwen He <hehuiwen@kylinos.cn>

A positive kernel_sendmsg() return may cover only part of an SMB frame.
Reporting success lets the next response follow an incomplete frame.

Retry short sends with the same iterator while holding srv_mutex.
On zero progress or error, shut down the socket before releasing the
lock so no later response can follow an incomplete frame.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 fs/smb/server/transport_tcp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 5a2aad35739d..1183bb75aa24 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -437,9 +437,22 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 	struct msghdr smb_msg = {
 		.msg_flags = MSG_NOSIGNAL | tx->msg_flags,
 	};
+	struct socket *sock = TCP_TRANS(t)->sock;
+	int ret;
+
+	iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, tx->iov,
+		      tx->iov_cnt, tx->size);
+	/* The caller holds srv_mutex across the entire frame. */
+	while (iov_iter_count(&smb_msg.msg_iter)) {
+		ret = sock_sendmsg(sock, &smb_msg);
+		if (ret <= 0) {
+			/* Never append another SMB frame to an incomplete one. */
+			kernel_sock_shutdown(sock, SHUT_RDWR);
+			return ret ?: -EIO;
+		}
+	}
 
-	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, tx->iov,
-			      tx->iov_cnt, tx->size);
+	return tx->size;
 }
 
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
-- 
2.43.0

