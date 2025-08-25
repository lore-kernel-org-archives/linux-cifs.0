Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E081E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155423; cv=none; b=INkAbPpIFE0hPqZF4tf8g3xX4gPuNedg3PT54HHPCawjzlRAhFc5IQS+cqtG7IjJsVuGoZECOK548GGnMilajvyortKyrYDlO1vFj8486ZdvOo/araFRkkmSgg0camJtph5J2e19l7SCK4CDRy3fh1ETwrsb3CkXLZQ1UDHXHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155423; c=relaxed/simple;
	bh=rnTcb+MbgNKGz0Wb+D9BcGQJjt5V9Y4Z2/FvyWSO5jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYhD9ZEW9GJ67V62kgX+SZ9LigBMWxGxnT/1Bh3AMxFCng06TwSjXWFAD3iWPm2Hl/L7o9r6CfhVTet8UbCby+x4sHEkBvY2gSSMIQ0JwsDYj7g/FTaLuHH9/Hu5F91UCiyMtvTvExgzaRn+WrJ4x1O1WJbJae4Jz2jWjCjgfQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ag1KxWQf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ag1KxWQf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=YT629rrj6zYtwgxCKfuuU3IQs13JsbJ61roDIgiUG0M=; b=ag1KxWQf3VHpF96FlmxEKMFSr4
	3DlQQbiEbHANRCrPKuvsrJ6qmqpYretfK+qRTXvOVQFBscxn4mstQ4nhGIZIrYsR3o4pyVYFyS59l
	SShzVsfgdcLQEtcnKOG975GiRWR8j6EePQV8q9HcdhpDxHvINkjpPM+SkrfMg7YCMcxtbU/CwNyI+
	zKN6+1TBmrKYudoaKzPSs7b2GyRs+WaRr7/1xy2ZWl2OYHgEuIVP0YSUcYSvsNxjnS/u4lzoozu16
	YLIo42yyYXaq/z9jySLGZnnFocQ4levHWXGBIadGob4Sph8THYCDPxL6qMfI5y+yBtu3kvk2E02WW
	qQ8FSlQ4cu+sNzMBSLJq+8IlVoSSQlJN3RfnpYWC7KeeORfjonQgmMahrUC1kVDE0GfZC+aNSEDWf
	oCZLUY98RkdJSL4fGwA5QxIAiEeEPqBYHtKa5Nq3DBAahO6vFtLCuyJEBldL+65xcF0pHniUj75j0
	7Yv6N3yJyNJlqWrBHYxLjleh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeFO-000mFw-0g;
	Mon, 25 Aug 2025 20:56:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 091/142] smb: server: make use of smbdirect_socket.status_wait
Date: Mon, 25 Aug 2025 22:40:52 +0200
Message-ID: <cddac861eccf6d4589062470788abb1e45170b43.1756139607.git.metze@samba.org>
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

This will allow us to have common helper functions soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4f0c7c8cb041..adab3f0e19e5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -92,8 +92,6 @@ struct smb_direct_transport {
 
 	struct smbdirect_socket socket;
 
-	wait_queue_head_t	wait_status;
-
 	spinlock_t		receive_credit_lock;
 	int			recv_credits;
 	int			recv_credit_target;
@@ -307,7 +305,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	spin_lock_init(&sc->recv_io.free.lock);
 
 	sc->status = SMBDIRECT_SOCKET_CREATED;
-	init_waitqueue_head(&t->wait_status);
+	init_waitqueue_head(&sc->status_wait);
 
 	spin_lock_init(&sc->recv_io.reassembly.lock);
 	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
@@ -516,7 +514,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		sc->recv_io.reassembly.full_packet_received = true;
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
-		wake_up(&t->wait_status);
+		wake_up(&sc->status_wait);
 		return;
 	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
 		struct smbdirect_data_transfer *data_transfer =
@@ -1458,7 +1456,7 @@ static void smb_direct_disconnect(struct ksmbd_transport *t)
 	ksmbd_debug(RDMA, "Disconnecting cm_id=%p\n", sc->rdma.cm_id);
 
 	smb_direct_disconnect_rdma_work(&st->disconnect_work);
-	wait_event_interruptible(st->wait_status,
+	wait_event_interruptible(sc->status_wait,
 				 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	free_transport(st);
 }
@@ -1485,7 +1483,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	switch (event->event) {
 	case RDMA_CM_EVENT_ESTABLISHED: {
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
-		wake_up(&t->wait_status);
+		wake_up(&sc->status_wait);
 		break;
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -1493,14 +1491,14 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 		ib_drain_qp(sc->ib.qp);
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_all(&t->wait_status);
+		wake_up_all(&sc->status_wait);
 		wake_up_all(&sc->recv_io.reassembly.wait_queue);
 		wake_up_all(&t->wait_send_credits);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_all(&t->wait_status);
+		wake_up_all(&sc->status_wait);
 		break;
 	}
 	default:
@@ -1928,7 +1926,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	int ret;
 
 	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
-	ret = wait_event_interruptible_timeout(st->wait_status,
+	ret = wait_event_interruptible_timeout(sc->status_wait,
 					       st->negotiation_requested ||
 					       sc->status == SMBDIRECT_SOCKET_DISCONNECTED,
 					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
-- 
2.43.0

