Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454378248C
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491185; cv=none; b=rT94+t5WIpo3N/2/x0L6pWZXWfwBUhnDEk9WHnZ9OtKZ6CQELbWrWrv1wo9hZMF5wsJ5G4AiEETbzKG77z7hT8K5GkoO0ZuRvYX/zco58m+77S1H6b53YIkxVpBzzvBibYQliXZGfyooTA3HQ2W23/QDi6tBdLbSpI4aKsks9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491185; c=relaxed/simple;
	bh=/jeH3ed95fiYN+PQMDfzl7btdRWY5w2cMO3RFQmuTZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHw0bkKMZcmmDmWjr5xxj7J0Vgc7brLrleUcoewqgVBPa9xIRklykEdkvIdatkDcPhLvXATMvie+KurJrFzAfTqhwTZ0Z/GnbSN0eBwP8pJMO00eUBwTqkSECEccv3ndZlGsx5LC6FSo/iDP5Ew+r9c3LxOvVPeS+4eUzN9ILHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2YaBsuw1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2YaBsuw1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cqNNOMho8SV1atOpkRN++KJYsALCgtilk2qHYxIbGu8=; b=2YaBsuw18KBpuKCifnEvYBE/Ve
	yQ6247iRbBRupF6wyopIYBdzU/nFnGzpwT7zLPfIeeT7NLyu8Ta3Yr2AURWWYhdNx1bY0j6i2ax1f
	+v1OnXtBYnMpVfM0TjwxB3XEtIzJVpboITefnLRR+TGzOhjnxo+pwpNqGFAMWiP+GEp3p9LkWnGk7
	bnIfo6Qezo9BlHT7SynRemCG7D5suQpiDjOMZndGUV4mGu+QDADupyMmXkfkhHMF6tzzXJB5AwQ4k
	+oqlL0E50LCbz9g6GU6vZaa6hPzYKN/NMpvudN9aHi1nTUlFXBnfczwJ9nZ/V4prOiZlBCOjE6cBn
	wpUIl86An3WzuEqWzdg2Mt51wETYhAOHSKQtzEznyJPYeah0kzKmUdnAN5o1leYN92RLmk6PGGE5a
	+T5UHkH56ejAKogRpPrlLeZBDz029U6qxYmO44VYIG0UibcmIt5MrHTZe5exXMoSNt5rH6ySGKXIU
	19jPFSF1AxHbq9QFaBg7wS2A;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rsw-005GTz-1u;
	Sun, 21 Sep 2025 21:46:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 07/18] smb: client: let smbd_{destroy,disconnect_rdma_{work,connection}}() wake up all wait queues
Date: Sun, 21 Sep 2025 23:44:54 +0200
Message-ID: <55c4a9d9357cf4c67fdd6c8e4a465d4b06f05e26.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is important in order to let all waiters notice a broken connection.

We also go via smbd_disconnect_rdma_{work,connection}() for broken
connections.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 52 ++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b39e60086c6a..00be4afaee52 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -165,6 +165,21 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
+static void smbd_disconnect_wake_up_all(struct smbdirect_socket *sc)
+{
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.credits.wait_queue);
+	wake_up_all(&sc->send_io.pending.dec_wait_queue);
+	wake_up_all(&sc->send_io.pending.zero_wait_queue);
+	wake_up_all(&sc->recv_io.reassembly.wait_queue);
+	wake_up_all(&sc->mr_io.ready.wait_queue);
+	wake_up_all(&sc->mr_io.cleanup.wait_queue);
+}
+
 static void smbd_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -216,6 +231,12 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	case SMBDIRECT_SOCKET_DESTROYED:
 		break;
 	}
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smbd_disconnect_wake_up_all(sc);
 }
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
@@ -273,6 +294,12 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 		break;
 	}
 
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smbd_disconnect_wake_up_all(sc);
+
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
@@ -306,14 +333,14 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		wake_up_all(&sc->status_wait);
+		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		wake_up_all(&sc->status_wait);
+		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
@@ -408,7 +435,7 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		wake_up_all(&sc->status_wait);
+		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -416,17 +443,10 @@ static int smbd_conn_upcall(
 		/* This happens when we fail the negotiation */
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
 			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
-			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-			smbd_disconnect_rdma_work(&sc->disconnect_work);
-			wake_up_all(&sc->status_wait);
-			break;
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		smbd_disconnect_rdma_work(&sc->disconnect_work);
-		wake_up_all(&sc->status_wait);
-		wake_up_all(&sc->recv_io.reassembly.wait_queue);
-		wake_up_all(&sc->send_io.credits.wait_queue);
 		break;
 
 	default:
@@ -674,7 +694,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
 		if (!negotiate_done) {
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-			wake_up_all(&sc->status_wait);
+			smbd_disconnect_rdma_connection(sc);
 		} else {
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 			wake_up(&sc->status_wait);
@@ -1569,6 +1589,15 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 *
+	 * Most likely this was already called via
+	 * smbd_disconnect_rdma_work(), but call it again...
+	 */
+	smbd_disconnect_wake_up_all(sc);
+
 	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 
@@ -1609,7 +1638,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * path when sending data, and then release memory registrations.
 	 */
 	log_rdma_event(INFO, "freeing mr list\n");
-	wake_up_all(&sc->mr_io.ready.wait_queue);
 	while (atomic_read(&sc->mr_io.used.count)) {
 		cifs_server_unlock(server);
 		msleep(1000);
-- 
2.43.0

