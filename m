Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463A932B110
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787234096; cv=none; b=K7LGv7uJ6fTjE+bU8AvSke745CaTQ9oAWM/y6VyGotANwIYhJ3jcH+H+3fwWT6tm8SGv8L04k7HPjhh70k82LJXEek/23npZ7ogmoBaej2Wp6vgReYf3u5g35IhWQKqmNJuRULE0Y7nAP7jxXc6NnxINZCq1t74Hsn3FI7p7nmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787234096; c=relaxed/simple;
	bh=YUdup3So6t+AXBDBieLghG+PHj07RDaX8hB3j5MgFWo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nGYds9M0O4xOJNItC+uhVFLWe6N1r0MJ7jf4wIVzwd9Wn5rid891EEzQK5k73/R7pMaSJw7jpBZdOpkjocfXdZat5QJCbXS2NaD6dyJ+jj/I4JD/KfzzIFsVOnTR9uJ6kjWlfkud4RvqGcREE+HfFVd3WGudwgY+clQACjke3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDAXE6im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDAXE6im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73461F000E9;
	Thu, 20 Aug 2026 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787234095;
	bh=mV6f77mNgKHXjClbcssGvslASdpKR8gHgPxkni92B98=;
	h=From:To:Cc:Subject:Date;
	b=GDAXE6imyVIxbIS/JcSbQVE9RZ7x7FVE7NthFVTPfTTra+zNiY3PMycWo8gNv56LL
	 RHdACn03dc8PaD5X4kfeGeCGQN68+mVhTl+nm0Gz14O4sNdMMrnim7u+pwxd3mvBm0
	 6XgPip34q/p/9cNmoKkRqP9PldRIyyAlixMRX3xBCYt/qtLDuIaOnRd+JWcLDeEJ9W
	 W8VwKTSCN+ozsJj91p6Kd928INTLc6KFL8Udzn4imITCXovLFmZH0jJfYGJk0c5l3A
	 VRQXd7hGyG5leKgmxF/2hTwqm0tMRZW1n5degdBjUVhoZSoPHi6Y86hu8kHEHUZ2dS
	 KjSkKSvxeuGhg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: enable TCP keepalive for accepted connections
Date: Thu, 20 Aug 2026 22:54:18 +0900
Message-Id: <20260820135420.5634-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A client that disappears without sending a FIN or RST can leave its
ksmbd connection in ESTABLISHED indefinitely. ksmbd sets a socket
receive timeout, but the connection receive loop retries timeout errors
without a limit, so the connection remains in conn_list and consumes the
per-IP connection quota.

Enable SO_KEEPALIVE on accepted TCP sockets so the TCP stack can detect a
silent peer failure. The keepalive idle time, interval, and probe count
remain controlled by the existing TCP sysctl settings.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 0ae5f145a332..921e4e86d01c 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -292,6 +292,12 @@ static int ksmbd_kthread_fn(void *p)
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
+		/*
+		 * Detect peers that disappear without sending a FIN or RST.
+		 * Otherwise the connection handler can retry receive timeouts
+		 * indefinitely and keep the connection in conn_list.
+		 */
+		sock_set_keepalive(client_sk->sk);
 
 		ksmbd_tcp_new_connection(client_sk);
 	}
-- 
2.25.1

