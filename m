Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A631B838
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787234111; cv=none; b=k9BjzoHPp1lJRYor2dKyj6k0Pcw1EJLcjwWyfbuYih2FpzO9FNpS639Idg/wEipSusf01q2JqUENDuU24p+lPvEiBxE/f+N0iDhTiNZsbne+FiVHZtDbzPS4s0fUyD/ao3Kz7MJlrSBJAKuzEbG3CitMbfqI2zF86AIQGi0BirU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787234111; c=relaxed/simple;
	bh=WuJIJRdwj6QL1eo1xjdj0I1kjtpqvJJoJB/FRtw3kPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOzkrCNzfGQlwSsGZ+SkkaufUneorOTTf31vvAkBZdCBfOpxixt3qQBcgkO6Ngr779xLwB1Bkjh9JMLaLWbImQsZvYhYeEG+kx2AdF9LiYsZSDftgRtiQRqZnItJjpwXhR9DAZKAmjOzMyzVt/vq/sJAYnqRdTD1RAuYD27iFO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbTF6sfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbTF6sfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C71F00A3A;
	Thu, 20 Aug 2026 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787234110;
	bh=9CGepuoCINLwBGG6rIuDEN0hFSjMSsi27zZU4u16MIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbTF6sfXT9Md4MJ5cj4dm04FU0ltTxzHSKGOzTLLbgnosZVS+37+/ZrfmfxKfXvop
	 TlhiXdyPoxYjDwWsnf5NiDYDIVZJ/iiU2dZO394XmVwrNwxcHZ1CXLW34F7ieHAGjS
	 sg3hxX/xssKpbi65Tggz66rzIFmV6ajG0Pa/4ycv8NmXEM6sLe41ay/IDYc35H+xR+
	 iY+3nvTyAXkiJhtyg+J++astx0VJe+xlcnn7lKOY/qICHY3Kvd7kd8LBD/1w5vME3J
	 ej3glm5A6NfCXSTpx5kGf1T3n32frHfI0cXFYF3OK1xWbC1810u7LJFc4ZA1cQZtHk
	 8oD4O/9x6tI5w==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: keep TCP timers alive for kernel sockets
Date: Thu, 20 Aug 2026 22:54:19 +0900
Message-Id: <20260820135420.5634-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820135420.5634-1-linkinjeon@kernel.org>
References: <20260820135420.5634-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd creates its listening socket with sock_create_kern(). Kernel
sockets do not hold a network namespace reference by default. Accepted
sockets inherit this state.

When an accepted socket is released, tcp_close() clears its pending TCP
timers for a kernel socket after the socket enters an orphaned state. If
the peer is unreachable while ksmbd sends a FIN, this can leave a
FIN-WAIT-1 orphan without a retransmission timer.

Upgrade the listening socket's network namespace reference before
kernel_listen(). Accepted sockets inherit the reference, so the TCP
stack can keep the retransmission timer active and apply its normal
orphan retry policy.

Preserve the existing graceful shutdown behavior.

Link: https://github.com/openwrt/openwrt/issues/24744
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 921e4e86d01c..832e93084605 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -523,6 +523,12 @@ static int create_socket(struct interface *iface)
 		goto out_error;
 	}
 
+	/*
+	 * Accepted sockets inherit the listener's net reference. Keep TCP
+	 * timers alive after a kernel socket is released.
+	 */
+	sk_net_refcnt_upgrade(ksmbd_socket->sk);
+
 	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
 	if (ret) {
 		pr_err("Port listen() error: %d\n", ret);
-- 
2.25.1

