Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2587C246BB7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744818; cv=none; b=uh18DRsbEAtHuyuGfw1pIPPmb4IBFyNITySFOt0jMI+j7MPOjcCK8KRVW1uIEMwlX6MjPo82ug0oC7DMC9wxK7Zb+IXLHJNEPdZvWCNB77wqRMSJtpJnwlvQV2rO43VCAwIhxa5xPI0X+pUV6JSM6a0vQ3bkEHkN/EAUmZ9/elA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744818; c=relaxed/simple;
	bh=eoBn0VNHEOrua3Q25LwOZINNpIn4cJkQBiTKrNyzJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN0zvOL885DFJeotnKsAbjNPLchC3zhziXfYmUrmn41+bSnJGGv72FIGYN9hDP8pBiqT7ZZuJTE0+Nuu/Ywl3eALugjNiVN2GbOC8P/ciqwMyyVxtYx5K+F02d+DFWf0sbxHPhNHSo/v509qiwjO9TYaX7dk8kq/dRbmvkisWU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Q1DCPJcJ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Q1DCPJcJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xYLqMtiJaEyl40ynYo3GXRyJ4Z/DmCJcNoPUA+BC/6A=; b=Q1DCPJcJBYfVdB8iVm6hUA7qkj
	MgmsU3juj2kjVuXnAs5SvXHPJqV19vYeC6t+rgHFuvJVTRlo9CipZGN7dNpkidJPMrkVup+mY0Zzx
	tf5h1xChmbrrP5wAaexVla8QsG793JCo3PxNzvAITpGDjeur95LQv+6AOuYvKBX8rzqYmB6kwSH2Y
	4u5jw8vUE85z77GIpml538c+tC7zrkmyHaJ6Mnhrst157ps31DG0KH+JxsKkiML5xVr59IywCu5Ih
	13yAVDWKuqLtWGBNf/Z6LsCd3ifSE0ZkBc3SrUXpmbb+44muCKV0z1a7nJDJMjNNMysocucbqrj22
	J2mSmyfRI5kv+s+TZOqf3Ajib077UdJM5efcupW6oOTMXxZc+KICxwUuespNBSE3wVadd7flPTgew
	8n81f0QErqOqW6+WRjq6hqQ1QEuhzTSvnodGH6lGr5zjAEKfF6qgtMH7+RBoH+8NiYUxhdSz20jRh
	KjRa7gnoij6OlNzBbKQXtuVR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Iv-00BcwV-1E;
	Wed, 29 Oct 2025 13:33:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 110/127] smb: server: make use of smbdirect_connection_recv_io_refill[_work]()
Date: Wed, 29 Oct 2025 14:21:28 +0100
Message-ID: <1707f35c930189212413116b933d345418bddc5b.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of smb_direct_post_recv_credits(), but
there are several improvements compared to the existing function:

1. We calculate the number of missing posted buffers by getting the
   difference between recv_io.credits.target and recv_io.posted.count.

   Instead of the difference between recv_io.credits.target
   and recv_io.credits.count, because recv_io.credits.count is
   only updated once a message is send to the peer.

   It was not really a problem before, because we have
   a fixed number smbdirect_recv_io buffers, so the
   loop terminated when smbdirect_connection_get_recv_io()
   returns NULL.

   But using recv_io.posted.count makes it easier to
   understand.

2. In order to tell the peer about the newly posted buffer
   and grant the credits, we only trigger the send immediate
   when we're not granting only the last possible credit.

   This is mostly a difference relative to the servers
   smb_direct_post_recv_credits() implementation,
   which should avoid useless ping pong messages.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 53 +++++++---------------------------
 1 file changed, 10 insertions(+), 43 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4acae8e43b76..9cc8cffcc6e9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -202,7 +202,6 @@ static inline int get_buf_page_count(void *buf, int size)
 		(uintptr_t)buf / PAGE_SIZE;
 }
 
-static void smb_direct_post_recv_credits(struct work_struct *work);
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct kvec *iov, int niov,
@@ -651,38 +650,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 	goto again;
 }
 
-static void smb_direct_post_recv_credits(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
-	struct smbdirect_recv_io *recvmsg;
-	int credits = 0;
-	int ret;
-
-	if (atomic_read(&sc->recv_io.credits.count) < sc->recv_io.credits.target) {
-		while (true) {
-			recvmsg = smbdirect_connection_get_recv_io(sc);
-			if (!recvmsg)
-				break;
-
-			recvmsg->first_segment = false;
-
-			ret = smbdirect_connection_post_recv_io(recvmsg);
-			if (ret) {
-				pr_err("Can't post recv: %d\n", ret);
-				smbdirect_connection_put_recv_io(recvmsg);
-				break;
-			}
-			credits++;
-
-			atomic_inc(&sc->recv_io.posted.count);
-		}
-	}
-
-	if (credits)
-		queue_work(sc->workqueue, &sc->idle.immediate_work);
-}
-
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
 	int new_credits;
@@ -1703,24 +1670,24 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 
 	/*
 	 * We negotiated with success, so we need to refill the recv queue.
-	 * We do that with sc->idle.immediate_work still being disabled
-	 * via smbdirect_socket_init(), so that queue_work(sc->workqueue,
-	 * &sc->idle.immediate_work) in smb_direct_post_recv_credits()
-	 * is a no-op.
 	 *
 	 * The message that grants the credits to the client is
 	 * the negotiate response.
 	 */
-	INIT_WORK(&sc->recv_io.posted.refill_work, smb_direct_post_recv_credits);
-	smb_direct_post_recv_credits(&sc->recv_io.posted.refill_work);
-	if (unlikely(sc->first_error))
-		return sc->first_error;
-	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+	ret = smbdirect_connection_recv_io_refill(sc);
+	if (ret < 0)
+		return ret;
+	ret = 0;
 
 respond:
 	ret = smb_direct_send_negotiate_response(sc, ret);
+	if (ret)
+		return ret;
 
-	return ret;
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
+	INIT_WORK(&sc->idle.immediate_work, smb_direct_send_immediate_work);
+
+	return 0;
 }
 
 static int smb_direct_connect(struct smbdirect_socket *sc)
-- 
2.43.0

