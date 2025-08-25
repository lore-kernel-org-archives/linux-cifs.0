Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F50827AC3E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155664; cv=none; b=q2Z1xajYdj+VEk3CfLzoEvlcbm8hOgPJythivGnbjV571EXHuPKlmlIbhqw6bpKbdkX5PBhYlupXBDW4/mV63fb3FDrIMw+qTsS1bh/JLgQkKalMX54tk3fRSweIyhva6PZYoCPtnyyC6vdPPQOcFx1BvLDN9IHWiFuZKIe544w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155664; c=relaxed/simple;
	bh=g53U4lcknUxMxnnwDjsuUWDGzZFnjdcqv0szGTmsxQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOLRrNWaNWW5wHy1eglwyYELE5vkkxPDvYdzUeaD1LLNaH9r28K3IegDKPJ36xwPeISdz/uNL2C+if8vCWq8rHVQK5w8sfwpCD/uIXuoXivYvYyDTXNilOi5CZ6tS3mdtV+xMyJ5G+7FdZxZOsWPlrtCABK6q8tnuQxgcwVmUFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=D2VxBKbj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="D2VxBKbj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1LfGV8QwOkPBL/0Sw7z+g85leojC0X/rZoq3/gFpAZU=; b=D2VxBKbjJ+Kt7D8Z1y6v90Vx24
	ZazSlzxZM+w0oVpxXiLGCjvd99jnl++9jkOhfBCBDtP3G1VpjgkAceuVgUREcP8BH5XvOS7uBYvSv
	vE/hv/irc8YEd5pjD5lK95WlnaoIF6ZMDLv6s+hl7JG0nfRXIg3I49LbgbBr1HZ4C5xl52D3prwDj
	MJBNOmgUch8iJvIgBrlin4JSCLqsJeve6gi2l9NLrZpr5Hhty9dzNNLIvpaMSzBuIwt7JxnWm5HRW
	29XOxycpAyI6gvafLQl2Canx6EQYs4WmNHtnv65PdOS1gAgsdl5802Hu7ZJQbyUvnau1nhLrs1Fa8
	dgSWJ7a15pTLAr8dsrSzaSfEbMMHGuz625oh/CK5jKCDhlUZuSX3f7k7norxcPd+ti/MdiZNqr4hf
	QuY1Oz1T+4Gbd951rqUrz/hdfKsEhzq0UB8KVjuipHgfY3VnFYJZ2RHFTBZ1HZ7cEvZ8IdvOa3/FI
	aAtws5x+TpR02zM9cYtXMSUZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeJF-000n1L-1v;
	Mon, 25 Aug 2025 21:00:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 115/142] smb: server: make use of smbdirect_socket.workqueue
Date: Mon, 25 Aug 2025 22:41:16 +0200
Message-ID: <465f0666cf9c5053546eabd38947d0c261fcacd2.1756139607.git.metze@samba.org>
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

We still use the single global workqueue, but this
will allow us to share common code soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index fb007963e281..9c2f0edab604 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -180,7 +180,7 @@ static void put_recvmsg(struct smb_direct_transport *t,
 	list_add(&recvmsg->list, &sc->recv_io.free.list);
 	spin_unlock(&sc->recv_io.free.lock);
 
-	queue_work(smb_direct_wq, &sc->recv_io.posted.refill_work);
+	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 }
 
 static void enqueue_reassembly(struct smb_direct_transport *t,
@@ -267,7 +267,7 @@ smb_direct_disconnect_rdma_connection(struct smb_direct_transport *t)
 {
 	struct smbdirect_socket *sc = &t->socket;
 
-	queue_work(smb_direct_wq, &sc->disconnect_work);
+	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
 static void smb_direct_send_immediate_work(struct work_struct *work)
@@ -304,9 +304,9 @@ static void smb_direct_idle_connection_timer(struct work_struct *work)
 	 * in order to wait for a response
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_timeout_msec));
-	queue_work(smb_direct_wq, &sc->idle.immediate_work);
+	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
@@ -323,6 +323,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	smbdirect_socket_init(sc);
 	sp = &sc->parameters;
 
+	sc->workqueue = smb_direct_wq;
+
 	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
 
 	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
@@ -534,7 +536,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	 * order to trigger our next keepalive message.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->keepalive_interval_msec));
 
 	switch (sc->recv_io.expected) {
@@ -596,14 +598,14 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (le16_to_cpu(data_transfer->flags) &
 		    SMBDIRECT_FLAG_RESPONSE_REQUESTED)
-			queue_work(smb_direct_wq, &sc->idle.immediate_work);
+			queue_work(sc->workqueue, &sc->idle.immediate_work);
 
 		if (atomic_read(&sc->send_io.credits.count) > 0)
 			wake_up(&sc->send_io.credits.wait_queue);
 
 		if (data_length) {
 			if (sc->recv_io.credits.target > old_recv_credit_target)
-				queue_work(smb_direct_wq, &sc->recv_io.posted.refill_work);
+				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
 			enqueue_reassembly(t, recvmsg, (int)data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
@@ -812,7 +814,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 	}
 
 	if (credits)
-		queue_work(smb_direct_wq, &sc->idle.immediate_work);
+		queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -884,7 +886,7 @@ static int manage_keep_alive_before_sending(struct smb_direct_transport *t)
 		 * Now use the keepalive timeout (instead of keepalive interval)
 		 * in order to wait for a response
 		 */
-		mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
 				 msecs_to_jiffies(sp->keepalive_timeout_msec));
 		return 1;
 	}
@@ -1703,7 +1705,7 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 	 * so that the timer will cause a disconnect.
 	 */
 	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(smb_direct_wq, &sc->idle.timer_work,
+	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
-- 
2.43.0

