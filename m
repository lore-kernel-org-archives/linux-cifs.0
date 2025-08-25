Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA07622128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155489; cv=none; b=QcfsOmlEsFao7egBB2Aq2hFQ6vDv+F3j30IF4mgPsVQjE/tDiGkjmSGY9EYwNvERSpLCBPBZ4+yeM4wjv7fF0qrLdTCAu0ahIBPP45ucpYK6Fho4NrBEn22YM6DaPvxtUF6HyAaRkYIAYXd1/A+vQTteNrfPT61fGsNEuS+2xco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155489; c=relaxed/simple;
	bh=O9ZaFM0ChEsohR/ntOwICnGWQvSLGgWfAVy8Ik7r77s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxnKfieCQr3tGsel6m/ybb+2569qZDf8MpDoFhoZ8UzCy5Ty6VtXxn9DAdkBmxxU9OsRibqGFNXWjeMxeVCM8zDWfmqdgznU5o4xFaWfEojSqjs1XFNd7S7d0OeQMJ0yagyZkq1Ko1twvGQHW7qEZcyNfMjtY9rDZlqv3Pj1Bqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RMgFnhuI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RMgFnhuI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=npZ7k2MO6CPbmHylc1eLNv+ws+xfZTRY6vmvyvF/acg=; b=RMgFnhuIOEjNzIK9oFsqf2kP8j
	3hBhipo3ziPZI0FmcH4oFHKh50bW4c/JYPasXIC8m1HlJDZRpVZKKM+Hq5KQaYSD+CEgYjOoQm/p+
	kfN9lCNHdgxRtIoPigc6DWZQ07yfu8suO8kennzOPVJf2fRut37dCmfpfwCJp/IpgPaX0Uv2iZ+O6
	YjPs4FP2Dc0JXXr5NB10dVjlXbYD82XnguFVvMJfSdnuJaE3TJxAk82FFjRczKYJALfaEfjirNMwf
	h1zzSV7oRwx6uNXm2Em2TfXiIOu3ZP9OU53DNIN6tqZXtu3M/220WMZvR3DORPB40PVVM4egMJh52
	Pa4Q3g+OdGDLrX2RO/au+xDcus3C55sQt6XlhnnOHSdu+5cDh0/ySzTjvjWQHc0z79qOTbqTskEiP
	IGzXS5cEz8EnU5I0XIO/4Cmq8t40OiUCRkjqaRj5iIiwdVCI6Dcdo791O4xuO8NpNWRVE1VHxfNnx
	HhTGYw2YfEfyPQ+Lww2/Woq4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeGT-000mTq-0F;
	Mon, 25 Aug 2025 20:58:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 098/142] smb: server: make use of smbdirect_socket.send_io.pending.{count,wait_queue}
Date: Mon, 25 Aug 2025 22:40:59 +0200
Message-ID: <15e99e9490c6562e81d0f525526a91ee05f822a1.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will is used by the client already and will allow to create
common helper functions.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 62e13112a2b6..fd8d3fbdfa6c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -106,9 +106,6 @@ struct smb_direct_transport {
 	wait_queue_head_t	wait_send_credits;
 	wait_queue_head_t	wait_rw_credits;
 
-	wait_queue_head_t	wait_send_pending;
-	atomic_t		send_pending;
-
 	struct work_struct	post_recv_credits_work;
 	struct work_struct	send_immediate_work;
 
@@ -341,9 +338,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	spin_lock_init(&t->receive_credit_lock);
 
-	init_waitqueue_head(&t->wait_send_pending);
-	atomic_set(&t->send_pending, 0);
-
 	spin_lock_init(&t->lock_new_recv_credits);
 
 	INIT_WORK(&t->post_recv_credits_work,
@@ -380,7 +374,7 @@ static void free_transport(struct smb_direct_transport *t)
 	}
 
 	wake_up_all(&t->wait_send_credits);
-	wake_up_all(&t->wait_send_pending);
+	wake_up_all(&sc->send_io.pending.wait_queue);
 
 	disable_work_sync(&t->post_recv_credits_work);
 	disable_work_sync(&t->send_immediate_work);
@@ -834,8 +828,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (atomic_dec_and_test(&t->send_pending))
-		wake_up(&t->wait_send_pending);
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.wait_queue);
 
 	/* iterate and free the list of messages in reverse. the list's head
 	 * is invalid.
@@ -868,12 +862,12 @@ static int smb_direct_post_send(struct smb_direct_transport *t,
 	struct smbdirect_socket *sc = &t->socket;
 	int ret;
 
-	atomic_inc(&t->send_pending);
+	atomic_inc(&sc->send_io.pending.count);
 	ret = ib_post_send(sc->ib.qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
-		if (atomic_dec_and_test(&t->send_pending))
-			wake_up(&t->wait_send_pending);
+		if (atomic_dec_and_test(&sc->send_io.pending.count))
+			wake_up(&sc->send_io.pending.wait_queue);
 		smb_direct_disconnect_rdma_connection(t);
 	}
 	return ret;
@@ -1279,8 +1273,8 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
-	wait_event(st->wait_send_pending,
-		   atomic_read(&st->send_pending) == 0 ||
+	wait_event(sc->send_io.pending.wait_queue,
+		   atomic_read(&sc->send_io.pending.count) == 0 ||
 		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && ret == 0)
 		ret = -ENOTCONN;
@@ -1616,8 +1610,8 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 		return ret;
 	}
 
-	wait_event(t->wait_send_pending,
-		   atomic_read(&t->send_pending) == 0 ||
+	wait_event(sc->send_io.pending.wait_queue,
+		   atomic_read(&sc->send_io.pending.count) == 0 ||
 		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return -ENOTCONN;
-- 
2.43.0

