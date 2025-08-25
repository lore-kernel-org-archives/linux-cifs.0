Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE62393DE3
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155387; cv=none; b=r3agH52DzxNwyO5tA44RkiT1aiddvgfQQ/u4+5wqNwMBsZN1vjN4aBulF5ODuT9LskrFNnu3JZ/hOVzWhN1H5ItTn3z0mmuee7+1tcFJ5DlpvM5nrsoM/Po+xlNKeot0QRgRKgNNzmZFMJWSQNFboGgQv/duXO/rGHkf2syoLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155387; c=relaxed/simple;
	bh=GssJzmK/EXhOHtjui+oW8Or6iqNEakN6UJiQAvEWJys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYirx0KWMNSRl9ZVh687DVSSpdB1J4L7DTKWE3F8ctO6CrpoDT1adZg3xZj1q1/ZP0504iKAd2Uvp7ZkFO2ZHXgUKGeh2DHsazbDjCGVWeoS9z23W6CBHNT6RmJjyhw5k1L+Px/16afZPyPCmNujUVsQsKbMdJxkxa/c63j8NM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hSmpsx/s; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hSmpsx/s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=y8JbVoDFG0A8XP8wI/id1OhRnnlRYHyalizXakUkX+o=; b=hSmpsx/szEUi+AzRykUVf61eor
	fSLVm5nhFciP9t9Iyl1w84aVyRaxB9dS2nHFQDdiQtd1srHhy6wPkM99pP2B8p3Tp3vp39fqJAC9L
	uQN4khhytKd+2NS9Upht9QYDC5G7sQipx6oR1sPkTL7BGrJHLJZL9CXKTJBfSmQrUr7dj/nfcZr68
	kAWLZQM8+49T9YW+yW+/AhbSWoUKz5xQJKGQ2rNRVQ4/ECRI6alcWtMcV0UatWTFyJVoQ5b1muZgT
	LC30XYGzlCCwxN4NDor5990eRYdv8VjmEyIlhltfyt1ORVqHXWQ5Vslsc+ZxmwlucDTVABQIuz7dC
	XnZSjW6qC1TqQ/uFScTjB6PzLKL8xXbyvSkPpHnDxm38WBl8+ydQMItEKZjuGRaVO1VH/ME3I7Tgj
	jJeeXiDUZETKlCmwp16C/mjZtATDo5oQi/MBpNqhozi2MxiyrepxenrS1xEZSklROFBLwrXmLrHAQ
	2Sy1WLLbuFRzzuEZPYVfMnUk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeEo-000m7b-2K;
	Mon, 25 Aug 2025 20:56:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 087/142] smb: server: make only use of wake_up[_all]() in transport_rdma.c
Date: Mon, 25 Aug 2025 22:40:48 +0200
Message-ID: <cb2ffc057d81c0a1e148c3c551c211df84c05e02.1756139607.git.metze@samba.org>
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

wake_up_interruptible(() doesn't wake up tasks waiting with wait_event().

So we better wake_up[_all]() in order to wake up all tasks in order
to simplify the logic.

As we currently don't use any wait_event_*_exclusive() it
doesn't really matter if we use wake_up() or wake_up_all().
But in this patch I try to use wake_up() for expected situations
and wake_up_all() for situations of a broken connection.
So don't need to adjust things in future when we
may use wait_event_*_exclusive() in order to wake up
only one process that should make progress.

Changing the wait_event_*() code in order to keep
wait_event(), wait_event_interruptible() and
wait_event_interruptible_timeout() or
changing them to wait_event_killable(),
wait_event_killable_timeout(),
wait_event_killable_exclusive()
is something to think about in a future patch.

The goal here is to avoid that some tasks are not
woken and freeze forever.

Also note that this patch only changes the existing
wake_up*() calls. Adding more wake_up*() calls for
other wait queues is also deferred to a future patch.

Link: https://lore.kernel.org/linux-cifs/13851363-0dc9-465c-9ced-3ede4904eef0@samba.org/T/#t
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c20052093b36..5e773da90316 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -357,7 +357,7 @@ static void free_transport(struct smb_direct_transport *t)
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg;
 
-	wake_up_interruptible(&t->wait_send_credits);
+	wake_up_all(&t->wait_send_credits);
 
 	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
 	wait_event(t->wait_send_pending,
@@ -522,7 +522,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		sc->recv_io.reassembly.full_packet_received = true;
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
-		wake_up_interruptible(&t->wait_status);
+		wake_up(&t->wait_status);
 		return;
 	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *data_transfer =
@@ -575,7 +575,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			queue_work(smb_direct_wq, &t->send_immediate_work);
 
 		if (atomic_read(&t->send_credits) > 0)
-			wake_up_interruptible(&t->wait_send_credits);
+			wake_up(&t->wait_send_credits);
 
 		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
 			mod_delayed_work(smb_direct_wq,
@@ -583,7 +583,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (data_length) {
 			enqueue_reassembly(t, recvmsg, (int)data_length);
-			wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
+			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			put_recvmsg(t, recvmsg);
 
@@ -1508,7 +1508,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	switch (event->event) {
 	case RDMA_CM_EVENT_ESTABLISHED: {
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
-		wake_up_interruptible(&t->wait_status);
+		wake_up(&t->wait_status);
 		break;
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -1516,14 +1516,14 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 		ib_drain_qp(sc->ib.qp);
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&t->wait_status);
-		wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
-		wake_up(&t->wait_send_credits);
+		wake_up_all(&t->wait_status);
+		wake_up_all(&sc->recv_io.reassembly.wait_queue);
+		wake_up_all(&t->wait_send_credits);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&t->wait_status);
+		wake_up_all(&t->wait_status);
 		break;
 	}
 	default:
-- 
2.43.0

