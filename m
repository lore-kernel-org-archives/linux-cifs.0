Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A013C9C4
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583214; cv=none; b=mJUR7dnZj+SU90TDOsOqCrL3ldQCqSdgueXPhhK+9jQvogh/0UPJhSiiG5OqFzM0+b89DFLzKXRfOcE01h8bJju84JbG4q12QznYwYcNf8Sqa3CC2drglbp1bp6folN1owSfHQjyE8h458GJBt4vyaBmhWhYm8utW70qsh/1kc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583214; c=relaxed/simple;
	bh=u7Vt+64zR8c9ahvLJcfIBtpc/rs5NkitVHE8XlWOb4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFd30joiS01VP6QKCJLmUtKeg8U1QWusmFKG9GCf1CD3dPtWyeKySrzQKn6k12DBqgvbrkkAC9GKZbsc+7X5ubHCKVUlD3hkHUSROJeUTU+HffFZ8mmZYMO+Bsz2ynlBJBPFLd2GEu/edfOg3xdHqlpvi4k4z6rTkFnJsqEOoQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=lKiG0r7t; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lKiG0r7t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NWCSVeBNe1rqapfmodbNCa+OE5Vv7tjGHzRw3N3SDV0=; b=lKiG0r7tehqK2g+9euwjCx2io1
	A4FdjQgxwd3l3a/Zu2NCRA58gplWkZBV0pQSxqfKXbaxjFae/Z/8S+FzSkElVGI11qKVehfxBvGMm
	aVYIi94GYZyTc57aPPwbON0/xM0m17azi9SnelAg2rx8uT3MjibVoFlUfBQtkp8pctU8lchfwcZ18
	MLv3MJbKRP1eMVVM4840KBh+KuK+Q+auEpTNvtBcnTkmTxCZW2ArFe2SAO4p1DB9YyZ1tAsMF2e9g
	8nK23THmPxpG/eCK5btWVNiEn+xPU99eJ+r1qdb1oABVju2iYOlfeNbaWOiaDOEIMb1ueM9AKmJgN
	QE3RWVRZ54DRaSRyPg9AfJFCAQgO8f8QGoc2PkOLWhR65IhNCv9PgyEWR/27ipAbkNlpChNLyaki5
	DNCceUoHJzwAJo+gnLYyxn4xo1PAuPeMUAg248GzUZ3tJs52H9Zg8OJ7ChZ4sKdLK7RKn4TtMDfSN
	zINcec/PlIBsDafb8Qdz/lCg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3FB-001ckI-2l;
	Thu, 07 Aug 2025 16:13:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 9/9] smb: client: make use of smbdirect_socket.status_wait
Date: Thu,  7 Aug 2025 18:12:19 +0200
Message-ID: <c1dd7da5ea65b9867693eb9ecfedf9f35f71b5d3.1754582143.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754582143.git.metze@samba.org>
References: <cover.1754582143.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow us to have common helper functions soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 32 ++++++++++++++++----------------
 fs/smb/client/smbdirect.h |  2 --
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ab5b7ae04032..f36226e0331b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -187,34 +187,34 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
 		log_rdma_event(INFO, "connected event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_CONNECT_ERROR:
@@ -223,7 +223,7 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -232,12 +232,12 @@ static int smbd_conn_upcall(
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
 			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
 			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-			wake_up(&info->status_wait);
+			wake_up(&sc->status_wait);
 			break;
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
 		wake_up_interruptible_all(&info->wait_send_queue);
 		break;
@@ -498,7 +498,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		} else {
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		}
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		return;
 
 	/* SMBD data transfer packet */
@@ -602,7 +602,7 @@ static struct rdma_cm_id *smbd_create_id(
 		goto out;
 	}
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
@@ -629,7 +629,7 @@ static struct rdma_cm_id *smbd_create_id(
 		goto out;
 	}
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
@@ -1136,7 +1136,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 		return rc;
 
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
 		secs_to_jiffies(SMBD_NEGOTIATE_TIMEOUT));
 	log_rdma_event(INFO, "wait_event_interruptible_timeout rc=%d\n", rc);
@@ -1363,7 +1363,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		rdma_disconnect(sc->rdma.cm_id);
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event_interruptible(
-			info->status_wait,
+			sc->status_wait,
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
@@ -1688,7 +1688,7 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&info->status_wait);
+	init_waitqueue_head(&sc->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
@@ -1700,7 +1700,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
@@ -1757,7 +1757,7 @@ static struct smbd_connection *_smbd_get_connection(
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
-	wait_event(info->status_wait,
+	wait_event(sc->status_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
 allocate_cache_failed:
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 62458a8fd109..79ab43b7ac19 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -45,8 +45,6 @@ enum keep_alive_status {
 struct smbd_connection {
 	struct smbdirect_socket socket;
 
-	wait_queue_head_t status_wait;
-
 	struct work_struct disconnect_work;
 	struct work_struct post_send_credits_work;
 
-- 
2.43.0

