Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6832F29993E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094743; cv=none; b=uVLnIS6asC6+cJ/XHnX9awNUQFSyLxq1mFZKuQCLGPe8raT2QrZJkk39W9dCO/zaPbteIeqR9/83Y490eR99i4eclUYu2S+mNLvPbDenfAkzHAKjRtNaRIEx47qs2Jf/Zmj7aDy6nb2PsFS7VcuP2oRvWztcioI/5/w+ImwqEIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094743; c=relaxed/simple;
	bh=VYEHICllgsWzbSIOi71M6ODZpLVRxAtUr3TQlzrUJgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDjv5mNeonbd02zAucW9OjHKycfTgkpas0XYCmDcHWI5I1RqkpD+8UYwDyN4PeLBevRDS+uQqjw69We4Y2h0McBiAJ+ECFqQdP+6ckAfo7g0A5rFVBTeqjb/e8/XdHmaj3gF3z6gWFS+PmuIo4iwG8omqOTghrnA+n0/CjiSrgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eOadA08D; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eOadA08D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HfI9BGiqMOLq+PwQ5c+N5/JmcJ0PIkF36wcCfSceNhc=; b=eOadA08DR7f0ZNk7YHlysq2hP7
	AisD3WwJYBmJAe//1p2WSuNURotTKsPXnxM8rH6g/XNRqVKrCIQdp16et6tQ3bYbERsFc0fhU0K+D
	q1mcB4Q9BKBg/w2r9SESegFW6FsSh9cYw0tE8MJ6huqzW5QtXkR2PW1IrsjG1oYv3kEcBpcavFo5Z
	6fY+qcoW/lGUPoBtpbWfZJ4PuhitzcV3d7BVbvK6dKTz6yEmg5dy2l95jPUvDyE+nPr0qtEjPGZ72
	WDHhJRvqei/a9OUUK2iSpIpm9ndxDy9cwpL7hcDY3LdMRYedki7AbuCmaDBm5Vp2uUbQyODDWVL6k
	JNY5TAPzwdBblRB1/eZ3J64tb6N46aaKI7/cipwMMoGkXbeUT/wO+zV3sWk5TeVub2gDpi6jlK2G4
	w39bTZ16OxZaUTxAZ7CaH+X0goig6rj+WvvJxPyCiIyGH+b1r9N4VpBpLndCxaKSseJTGrCsmSwd/
	58+jUqUhhp2bR6Lnp0fG6fMd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxVR-00FeKo-0i;
	Tue, 25 Nov 2025 18:11:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 104/145] smb: server: make use of smbdirect_connection_reassembly_{append,first}_recv_io()
Date: Tue, 25 Nov 2025 18:55:50 +0100
Message-ID: <bf052532a92bd20337f10c04af5d709749f90fbc.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are basically copies of enqueue_reassembly() and
get_first_reassembly().  The only difference is that
sc->statistics.enqueue_reassembly_queue now updated.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 41 +++++-----------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1c926e46a354..0b86df43449c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -215,35 +215,6 @@ static inline void
 	return (void *)recvmsg->packet;
 }
 
-static void enqueue_reassembly(struct smbdirect_socket *sc,
-			       struct smbdirect_recv_io *recvmsg,
-			       int data_length)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-	list_add_tail(&recvmsg->list, &sc->recv_io.reassembly.list);
-	sc->recv_io.reassembly.queue_length++;
-	/*
-	 * Make sure reassembly_data_length is updated after list and
-	 * reassembly_queue_length are updated. On the dequeue side
-	 * reassembly_data_length is checked without a lock to determine
-	 * if reassembly_queue_length and list is up to date
-	 */
-	virt_wmb();
-	sc->recv_io.reassembly.data_length += data_length;
-	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-}
-
-static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *sc)
-{
-	if (!list_empty(&sc->recv_io.reassembly.list))
-		return list_first_entry(&sc->recv_io.reassembly.list,
-				struct smbdirect_recv_io, list);
-	else
-		return NULL;
-}
-
 static void smb_direct_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -383,7 +354,7 @@ static void free_transport(struct smb_direct_transport *t)
 		unsigned long flags;
 
 		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		recvmsg = get_first_reassembly(sc);
+		recvmsg = smbdirect_connection_reassembly_first_recv_io(sc);
 		if (recvmsg) {
 			list_del(&recvmsg->list);
 			spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
@@ -552,7 +523,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			return;
 		}
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
-		enqueue_reassembly(sc, recvmsg, 0);
+		smbdirect_connection_reassembly_append_recv_io(sc, recvmsg, 0);
 		wake_up(&sc->status_wait);
 		return;
 	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
@@ -620,7 +591,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
-			enqueue_reassembly(sc, recvmsg, (int)data_length);
+			smbdirect_connection_reassembly_append_recv_io(sc, recvmsg, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			smbdirect_connection_put_recv_io(recvmsg);
@@ -706,7 +677,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 		/*
 		 * Need to make sure reassembly_data_length is read before
 		 * reading reassembly_queue_length and calling
-		 * get_first_reassembly. This call is lock free
+		 * smbdirect_connection_reassembly_first_recv_io. This call is lock free
 		 * as we never read at the end of the queue which are being
 		 * updated in SOFTIRQ as more data is received
 		 */
@@ -716,7 +687,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 		to_read = size;
 		offset = sc->recv_io.reassembly.first_entry_offset;
 		while (data_read < size) {
-			recvmsg = get_first_reassembly(sc);
+			recvmsg = smbdirect_connection_reassembly_first_recv_io(sc);
 			data_transfer = smbdirect_recv_io_payload(recvmsg);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
@@ -2181,7 +2152,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	if (ret <= 0 || sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
-	recvmsg = get_first_reassembly(sc);
+	recvmsg = smbdirect_connection_reassembly_first_recv_io(sc);
 	if (!recvmsg)
 		return -ECONNABORTED;
 
-- 
2.43.0

