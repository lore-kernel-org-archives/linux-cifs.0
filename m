Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8E1DF248
	for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369952; cv=none; b=rgilpVwscpIKJ7LvcDtfAQ+yFod+SNLQYpHxGk3HTe3thd5KV3swyT48r5sHlQT4ypLYtUmdLDMo+tJ8d006UEgU8KTuiX0wPtCSuAOMCEfgOKWDlaaTDEmleTHaAmYDt8r3vYC7114no7vbGDcWnTFbpLusotT+WQdhX88DRxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369952; c=relaxed/simple;
	bh=VZVYXZiasLZnAdgwiZQjRFK6cFmwg476sxAlwN9WXyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8rUxpCKMz0LhA+Qby9EKDR1h1bogIuM5BYmxXEKF8SMv3mjBlsd39Ivvn9bAvfwCD3uVLL0P4BXEVqklIuoZQmUoE25hW2NSogDfzo3JDrItGrmJ494cdcmi4E5MGdmSfyaWNUDbGlR50mzf2uLpeLwjvZBdvVUlr4u3MhNT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWBuz3RO; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWBuz3RO"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso662882a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 00:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763369949; x=1763974749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YuJplMGmt4Z1RMroFnaRWRB664GXXcGAXvTcG99zx6o=;
        b=AWBuz3ROOTHrZEJQOhE1ewWTUTXnThNRc6tjzybuMCSHswuSyV7siYK5tqqy+PRnwp
         Wq2SYrx2KSCKXRikf/QN63i95jzmb+dLHTqs/letcXKmuErzIp8xNdGkIDcaGcF25nX6
         rVoU/x9eDBK8tJP7KO7U1lu0sAnmc9lffzsIMZl3tpgY5EuyAPVuLPO0UJDwL7IZokHe
         b4UFctK5GRkrHn9X4og3Cr7JsPvhY6oIgaybPQ0BRim2rOOlKNz+5nty0glZm6/a3g/k
         v8MGuK4ImZ3y1pE9tcKZpRkTJHS0ATjc2DsjcIdzbkjRr7c/T3qNQs5H+7M1jyztIcQ9
         UIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763369949; x=1763974749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuJplMGmt4Z1RMroFnaRWRB664GXXcGAXvTcG99zx6o=;
        b=DOqIcceshckxRUWfOvUblMuGas7eCHQeg4Fz8E6RCzF/YVlsFDszhvEQ+vttbQuA+9
         oviIKeXrjD3R3R6/dXKwv2hpwv/Pf2WVpRTt9E+oDvEclx5kKUPTywhw2VYpcWUX3xRw
         ISoI9uNURU73nmV/6S6qzwO26qCYI15jTStYtCk+Fh2D0yKByWAHsXy/OA6yuBGctpXt
         dZ2dhIECUHHI5h5y0JHeUdW2lWZPt4+AHrZ9c1nb8fEBcVSDHKHUicjxCtd5TAWaR3UR
         y5gXma1b/df0lVfvDuqPQqw6/IIm0Xjx9ZMDReduJEZkFpnkyNPNmGk1pH6+UC7HkHv8
         FM3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXcGyxi4DhgwLOoc5JMo37DuPB9xt4PlnavZ5Pvdw2oigewIl20W7omX8PGYyXjruXdWTXyQsf/o6eP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1xs3J377ZtO/4bcBH89I7et96V5COsRxeSFzVw2Mz8dZmCicM
	H7aQaKWzlf/Fmbv0vas6zXJ8Z5w9UKZKx0/VkviMZHBEL8RG6oSgUWef
X-Gm-Gg: ASbGncueArF6n8o69WJax9xXdMiuvv6q1CI7yKVx1WZ5x030ge4RyS0hEV0vxEYVG/Q
	0OQcUYFkC78XFNDHc95R+QTpgG6spUH80R/flVaIrOzQSXD4qlgTeGFrAs/6xY6R4C8NaYrzaxw
	kBumK1ai7JiS7jqY89+sLOdQunSJ3wHXvZtpJlP1ekz1osKI46ZGlJOkZ8XmqrynQv0s7RBJHhJ
	gmHYuftC+PctRtEm5cUyD6EWt0FV1Rn83Q+JCT0J/PahClMQ2nTJuzJz1eHkJecg7z475t759bL
	n4Guo9dn62blxZBWMADKUw5BP+KLJ1O0IzoxC+TtJwXa13t3Z+8nzz7duT37YTMdicgVGedo19s
	arGlPq1VpHrJim5Sz3KHCTPHF7ZBuMZb77P4CaNMzkw+uLRDjbZIlxuxx
X-Google-Smtp-Source: AGHT+IGp2eFIcvLZaV/ERruGqC1K/JzVyco8Knc+w5+BBpuOr4rj5S1fp6JgJARKZIMqdZXObbFw4w==
X-Received: by 2002:a05:693c:60c6:b0:2a4:86e5:6b2a with SMTP id 5a478bee46e88-2a49af801a3mr4072122eec.14.1763369949408;
        Mon, 17 Nov 2025 00:59:09 -0800 (PST)
Received: from gmail.com ([2a09:bac5:1f0a:281e::3ff:5a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49db102f5sm35562982eec.4.2025.11.17.00.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 00:59:08 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v3] ksmbd: server: avoid busy polling in accept loop
Date: Mon, 17 Nov 2025 16:59:00 +0800
Message-ID: <20251117085900.466432-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ksmbd listener thread was using busy waiting on a listening socket by
calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
-EAGAIN. Since this thread is dedicated to accepting new connections,
there is no need for non-blocking mode.

Switch to a blocking accept() call instead, allowing the thread to sleep
until a new connection arrives. This avoids unnecessary wakeups and CPU
usage. During teardown, call shutdown() on the listening socket so that
accept() returns -EINVAL and the thread exits cleanly.

The socket release mutex is redundant because kthread_stop() blocks until
the listener thread returns, guaranteeing safe teardown ordering.

Also remove sk_rcvtimeo and sk_sndtimeo assignments, which only caused
accept() to return -EAGAIN prematurely.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
v2 -> v3: https://lore.kernel.org/linux-cifs/20251111104750.25739-1-dqfext@gmail.com
 Remove unused functions.

v1 -> v2: https://lore.kernel.org/linux-cifs/20251030064736.24061-1-dqfext@gmail.com
 Do not remove TCP_NODELAY, as accepted sockets inherits from it.
 Fix accept() blocking forever on older kernel versions.
 Remove a redundant mutex

 fs/smb/server/transport_tcp.c | 41 +++++------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 6e03e93321b8..4bb07937d7ef 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -22,7 +22,6 @@ struct interface {
 	struct socket		*ksmbd_socket;
 	struct list_head	entry;
 	char			*name;
-	struct mutex		sock_release_lock;
 	int			state;
 };
 
@@ -56,19 +55,6 @@ static inline void ksmbd_tcp_reuseaddr(struct socket *sock)
 	sock_set_reuseaddr(sock->sk);
 }
 
-static inline void ksmbd_tcp_rcv_timeout(struct socket *sock, s64 secs)
-{
-	if (secs && secs < MAX_SCHEDULE_TIMEOUT / HZ - 1)
-		WRITE_ONCE(sock->sk->sk_rcvtimeo, secs * HZ);
-	else
-		WRITE_ONCE(sock->sk->sk_rcvtimeo, MAX_SCHEDULE_TIMEOUT);
-}
-
-static inline void ksmbd_tcp_snd_timeout(struct socket *sock, s64 secs)
-{
-	sock_set_sndtimeo(sock->sk, secs);
-}
-
 static struct tcp_transport *alloc_transport(struct socket *client_sk)
 {
 	struct tcp_transport *t;
@@ -236,20 +222,14 @@ static int ksmbd_kthread_fn(void *p)
 	unsigned int max_ip_conns;
 
 	while (!kthread_should_stop()) {
-		mutex_lock(&iface->sock_release_lock);
 		if (!iface->ksmbd_socket) {
-			mutex_unlock(&iface->sock_release_lock);
 			break;
 		}
-		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
-				    SOCK_NONBLOCK);
-		mutex_unlock(&iface->sock_release_lock);
-		if (ret) {
-			if (ret == -EAGAIN)
-				/* check for new connections every 100 msecs */
-				schedule_timeout_interruptible(HZ / 10);
+		ret = kernel_accept(iface->ksmbd_socket, &client_sk, 0);
+		if (ret == -EINVAL)
+			break;
+		if (ret)
 			continue;
-		}
 
 		if (!server_conf.max_ip_connections)
 			goto skip_max_ip_conns_limit;
@@ -458,10 +438,6 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
 	if (!ksmbd_socket)
 		return;
 
-	/* set zero to timeout */
-	ksmbd_tcp_rcv_timeout(ksmbd_socket, 0);
-	ksmbd_tcp_snd_timeout(ksmbd_socket, 0);
-
 	ret = kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR);
 	if (ret)
 		pr_err("Failed to shutdown socket: %d\n", ret);
@@ -532,9 +508,6 @@ static int create_socket(struct interface *iface)
 		goto out_error;
 	}
 
-	ksmbd_socket->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
-	ksmbd_socket->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
-
 	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
 	if (ret) {
 		pr_err("Port listen() error: %d\n", ret);
@@ -604,12 +577,11 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
 			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
 					iface->name);
+			kernel_sock_shutdown(iface->ksmbd_socket, SHUT_RDWR);
 			tcp_stop_kthread(iface->ksmbd_kthread);
 			iface->ksmbd_kthread = NULL;
-			mutex_lock(&iface->sock_release_lock);
-			tcp_destroy_socket(iface->ksmbd_socket);
+			sock_release(iface->ksmbd_socket);
 			iface->ksmbd_socket = NULL;
-			mutex_unlock(&iface->sock_release_lock);
 
 			iface->state = IFACE_STATE_DOWN;
 			break;
@@ -672,7 +644,6 @@ static struct interface *alloc_iface(char *ifname)
 	iface->name = ifname;
 	iface->state = IFACE_STATE_DOWN;
 	list_add(&iface->entry, &iface_list);
-	mutex_init(&iface->sock_release_lock);
 	return iface;
 }
 
-- 
2.43.0

