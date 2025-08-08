Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B4D283CB1
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666960; cv=none; b=pmNHQEGkAxrdUgDtpjckJq58ia1cT+fC2cFoyjpNAW3iWEGXeiPWbMk4U2sIZ9NUhXbnO57X+8asbVCdEActd/JfBLuxmG/44FeZ2cw9OCPdy7kjIcpobwtCpXb0M2QEJVR5gwAPDQ1vHRJq+utsZHSC7oLkJTX4IA/+0rZNl1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666960; c=relaxed/simple;
	bh=qGKTtrgIgwGDDZjGb/ILI3TInB24v+IlTdkiHu2NUUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inofXMJnS0XoOEEdb2LjWxREaiZsnljaquAwX/xsgbHKUGhqCEZVnHx5abjd6AyP/qL+cznkqAxo2Q+I6URbz8eB+YhRhk6lPR/ZAzwimY6tFrNbZRYU/okYOixZocjO1VqvSkuinofWYjLLCwmwJX5w0Y2enlPQsO0U9qNyA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Sq65tt12; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Sq65tt12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=l5oOqLTsy+nfiyBURJBUeqBlNMQO0TVC/lARK6OqHmM=; b=Sq65tt122+Jd3ejpuRgFtcYPZ2
	QUv9zwD0XAxPyxh8LDzjzbhMMKEA4dwk329dG1p1V0NHthM8Q+yjm4Fu1CSvxOdYtqw8OM/qsE428
	jLBDMfXDa+NiqQh/IOeJx3B3bpOywEksnd2XAfXfu43ZAUyzaw6ZIqWoqCvAf6DW36aD2pHLVYsAv
	gmQ8E7kfDQmZX9JiNRbx7JDCPaNcJJbfMBBEh2FXAocjpJfXBeZ30QYPztGORZRz74awmSsB5rTXM
	sdrR3llvSah86UXQ/NS/JopJD+m8ed1fwvdQ/9S7RdbV6qxNxx/9ruv32bKxS1ugPRwMI9ZVkGoJ8
	Uy2x+QvFEGliR70ezzuZ4GZN4G7V7nv+ej+6ABlmbPsQa8ej3ArQtogXTs6BwnmSSjqePdNiBB10b
	iEsPSMplux4ClhFdfXN9DsSzmEkz1Qu32SKDslOkmXpLXA77X2dqjLuTTDQHGoljTFGhscbOn2eTN
	uTUmwYINU0IhH8vZI0fZ/A66;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP1w-001pY1-1M;
	Fri, 08 Aug 2025 15:29:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 9/9] smb: client: make use of smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 17:28:07 +0200
Message-ID: <4b9d18e9e42045dd407ef99dea44787f4477b9c5.1754666549.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754666549.git.metze@samba.org>
References: <cover.1754666549.git.metze@samba.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 32 ++++++++++++++++----------------
 fs/smb/client/smbdirect.h |  2 --
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6e0ef7ca8ab8..15bb8e8460ee 100644
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
 		else
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 
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
 
@@ -1578,7 +1578,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
-	init_waitqueue_head(&info->status_wait);
+	init_waitqueue_head(&sc->status_wait);
 
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
@@ -1701,7 +1701,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
@@ -1758,7 +1758,7 @@ static struct smbd_connection *_smbd_get_connection(
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

