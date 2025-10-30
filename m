Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAC51AF4D5
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 06:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806864; cv=none; b=ikmJuVWC5LwJOrmG4lsKc3UBqFUIZfLqOmU5fvYGduv/AlPvyM0P3hY7KqaR/6PPN0Xxvq6KDe+lYqAz3O8yMuWxpUnptV79IBcHZcWlrdVmm82ohxxrvBI7piA8DEDDziz5k0WwAptQBAOkY9BknBGMM1rA+c7PNtHYCe2YPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806864; c=relaxed/simple;
	bh=Me3DvE2ugI06H5NnuFqscw90MT7ZGQysOgv6CrNFg7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pbM/MrW3D0luVObwbOhSfkdFA+BM6qx1Pp2QzwfHfs7mEZj+7SS3+ohwKYDcQIgCecnrMFf64S93fB+A8ZcqXlU2LfL4neMKXWv7VZ9oL8cxwJFiXK9KvVE6VLmZQVoRJ1ql8vm82EwCWc5qCs/M20PigVMI23szzbsRzzduQoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xzb/iaxs; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xzb/iaxs"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-78af743c232so644999b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 23:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761806862; x=1762411662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Am9qB9+YZXgr5yZPmS0eVlJwMZhmLJXC12be2I9616g=;
        b=Xzb/iaxsuyLAEW7w2FsEl0n1/OdunvACjnQh157BAyjM53zFU8BfAcqqWmqSyNCibg
         Ed7SZNruy6V3HgTi2miNhDG3vE+MXp7qtR1W4d3eQEW/dQFGbaqjd8yV8JjwMGkfi3c9
         WFWD5tzoXRCOaC7o05O1kh4bV7JaBtGA0TCJAYdmGh30h0PnxveZNPbek+yhOhXGT9Cr
         DoBG2Rjy5ZbgyEyN9q9JaOHH2LY86iRd/bGO5wBSeOadD2YpGAI205f2Mhqe/AWQwUC3
         ZJfxqsnSI27j83LkDhn+lP/Ab69hDP+2QZ1EEeGkB1qItKA9M6CviK4CB9wtZUt4mNfC
         pj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761806862; x=1762411662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Am9qB9+YZXgr5yZPmS0eVlJwMZhmLJXC12be2I9616g=;
        b=QOLgCht7UYRCh/c5NPCiN/8TkSez5l2mMKQWoFkCL+BMvFp89EtuItbHvDBcHLDI6H
         stv0hscJknNdgX4XCvz6Rw73Cdxx6SqinctNp8YgW+8l/xC50cQaHOwYV+sb7G0fbANO
         QFh6dBLyVVO6E7L2oJs4Lqdr1VAzaqk0iZ1iBHVzqvJP9siFL7tNQv7o5WRtKKBWWpW7
         5pokQpRaQsYk36x2giPFYpCvmh20F9GeDhFp+o6uTf1DjLc/xLN8wrB5n87s9SoCC7J6
         CxR/6kYR/DoS/WAmM6Kzz83pa77JlKjFi1r3VtTvozX7uKdt1i8c8i7bZKRsVAXNr3uy
         AW+g==
X-Forwarded-Encrypted: i=1; AJvYcCV86cxe7t7Tiq5oEsyw3FKpMFJ3j9A+KFe0kk40VmTGmUNXnTrRMULzI8JCo8JyJNyWTs37QTaRPUsL@vger.kernel.org
X-Gm-Message-State: AOJu0YyuhKIk830UaRZgJcfWl5YPaUqU3YXKW73nn5W7st4rmbOe58BC
	HVxSBOy2Bisvljz3Yi10CTGu7MbnnjkMKKV5zWsVG4C9F2i8y6kk6fZg
X-Gm-Gg: ASbGnctU8uLDRsW2X/YpXUqG237eXR2M6r9JA/ATYYTsG8Y/NHDhz7R/F3YnTYg8Fmv
	R9VLd1NrDhcMBQ9hh1vlKamfRhU7HNcZ7SX20EzQU9GN6ZmEjXthXKEUdSZu/xAiBXn/CHudQiH
	6fHRrAPuEdMbhcSV0rhbIC8DaUzcw6jZUKf1MxvQ1k/f5WHzqd0oPlcA/L5uFgtRDNM5RHYHjmR
	89nrTreOKofExpXZNmQ3s5ApL8dq+WDvKdQYb/NkujLegGM7Y3kw+BXw0sHpVafTyAoZYjzhnt1
	rAKyuUXBj9ygeXlJ8nV3KpDeVNHDKcdSLC290vaJLmkZo2lz68Y+RXOa2waeHV8D6cQGXmckOQQ
	vmkt/z5+LivGXAUbeiuy9qEKyd1xAJOcyqwe9Im5bEcatQIeB8psB
X-Google-Smtp-Source: AGHT+IGoeDNjZsXbO3LdK/V2YvdvGX0ZgT9GuusUDEYT4fkoC2bi4mVxlbYzrfAWfqpRdk3dt9E7Mg==
X-Received: by 2002:a05:6a20:3d86:b0:33b:625:36be with SMTP id adf61e73a8af0-34654ee8c72mr7062588637.38.1761806862086;
        Wed, 29 Oct 2025 23:47:42 -0700 (PDT)
Received: from gmail.com ([2a09:bac5:1f0a:28::4:372])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414012c40sm17799563b3a.6.2025.10.29.23.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 23:47:41 -0700 (PDT)
From: Qingfang Deng <dqfext@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] ksmbd: server: avoid busy polling in accept loop
Date: Thu, 30 Oct 2025 14:47:36 +0800
Message-ID: <20251030064736.24061-1-dqfext@gmail.com>
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
usage.

Also remove:
  - TCP_NODELAY, which has no effect on a listening socket.
  - sk_rcvtimeo and sk_sndtimeo assignments, which only caused accept()
    to return -EAGAIN prematurely.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
 fs/smb/server/transport_tcp.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7a1e3dcc2cde..57a6aa98e7de 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -46,11 +46,6 @@ static struct interface *alloc_iface(char *ifname);
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
 				struct tcp_transport, transport))
 
-static inline void ksmbd_tcp_nodelay(struct socket *sock)
-{
-	tcp_sock_set_nodelay(sock->sk);
-}
-
 static inline void ksmbd_tcp_reuseaddr(struct socket *sock)
 {
 	sock_set_reuseaddr(sock->sk);
@@ -241,15 +236,10 @@ static int ksmbd_kthread_fn(void *p)
 			mutex_unlock(&iface->sock_release_lock);
 			break;
 		}
-		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
-				    SOCK_NONBLOCK);
+		ret = kernel_accept(iface->ksmbd_socket, &client_sk, 0);
 		mutex_unlock(&iface->sock_release_lock);
-		if (ret) {
-			if (ret == -EAGAIN)
-				/* check for new connections every 100 msecs */
-				schedule_timeout_interruptible(HZ / 10);
+		if (ret)
 			continue;
-		}
 
 		if (!server_conf.max_ip_connections)
 			goto skip_max_ip_conns_limit;
@@ -455,10 +445,6 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
 	if (!ksmbd_socket)
 		return;
 
-	/* set zero to timeout */
-	ksmbd_tcp_rcv_timeout(ksmbd_socket, 0);
-	ksmbd_tcp_snd_timeout(ksmbd_socket, 0);
-
 	ret = kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR);
 	if (ret)
 		pr_err("Failed to shutdown socket: %d\n", ret);
@@ -505,7 +491,6 @@ static int create_socket(struct interface *iface)
 		release_sock(ksmbd_socket->sk);
 	}
 
-	ksmbd_tcp_nodelay(ksmbd_socket);
 	ksmbd_tcp_reuseaddr(ksmbd_socket);
 
 	ret = sock_setsockopt(ksmbd_socket,
@@ -529,9 +514,6 @@ static int create_socket(struct interface *iface)
 		goto out_error;
 	}
 
-	ksmbd_socket->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
-	ksmbd_socket->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
-
 	ret = kernel_listen(ksmbd_socket, KSMBD_SOCKET_BACKLOG);
 	if (ret) {
 		pr_err("Port listen() error: %d\n", ret);
-- 
2.43.0

