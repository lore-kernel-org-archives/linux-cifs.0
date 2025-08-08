Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407D5186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671775; cv=none; b=VL6hlKAd2xUv9FbQSZE/qI6BJMJiCNmQqWhyPy2yrqzxnqzneKrqyaCHEa1whpeZOFnOU4tUB1uNf7aC9p84YCv+t6B7mySwd9gqNz9kzt6ZDWfdFDWl+/eH0UaELIbZ7FEev6KOeX5konTdAvC79z8nJqsyPXQl6dKgmgnpXTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671775; c=relaxed/simple;
	bh=QxmQD343aWoOPJZAq94nj4TlFaZYdfDGeqsRneVsIoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqfSGdNhI+QxyWH/njYAelnM9JgEpBNqOsfB/LgIFlhYpO+7Pulewvf5Lhz/ITcIq16tPtvegf2dXGiX/V1jM3zMZWXvHxy+w/8zBAuKY8NEfoeKptR/fnsax8ZFhVILH3oZhKWLtBFwQaHp74Wm5AFqvM2x0FO4SHeDoIqkIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vtpoPwFB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vtpoPwFB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4U9yVf7xCG+R85tXYmz34DCnjBOg8a8T4oiGQkIjSmo=; b=vtpoPwFBrQxyRLLaKRR7ygfiGs
	LsuGcMnMz0s3OiFWasEFM61xSQc8PGg/G2fMgf1E2AWUcwIyPRRGaotuwKa3IZWtvB1dQhlW9i9BP
	nc4l+hVkxyw2aqrRX1Eal9xylFJW/Lm+/v6nhz6mg9xEGZ0pze/UcfdB9xjqwhpcun7rjmwgZ6OCv
	9cLR8GBqLHZQp8bEOm+J7jFbJkhEe8MFkbuqNdHFO8ALaeGLWDeIg4NoCufzfoe90QJCOdppP4TAb
	ntLktUeg8jap+vMr8SKos/S96n4iEG9yvhtBtH8eNrqqG08jgWvWESBr2lyS1Ww+aJumkByzWAnqi
	U5UflG9Vd1mAPbEAxYMzA1iQPQz3VkMqtSXAeZmedEzLaOiOuD17bOfm9rJRB91fs8HU2luVMjDMm
	pP0pjvEhfAlCznHelR0zm0kRiRkTVT1+dzT7V3d1CrnP8gYwGEq/XunCHSXITnrUYjFdJL+J1Nrgs
	1BtgR62DcAxO/GUHLKh66ChL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQHa-001qWI-1H;
	Fri, 08 Aug 2025 16:49:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 9/9] smb: client: make use of smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 18:48:17 +0200
Message-ID: <f11c9dcd074d5806e1feb76393d93c7800172f88.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
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
index ca6aa298d577..fe7e138704fc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -214,34 +214,34 @@ static int smbd_conn_upcall(
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
@@ -250,7 +250,7 @@ static int smbd_conn_upcall(
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -259,12 +259,12 @@ static int smbd_conn_upcall(
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
@@ -525,7 +525,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		else
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 
-		wake_up_interruptible(&info->status_wait);
+		wake_up_interruptible(&sc->status_wait);
 		return;
 
 	/* SMBD data transfer packet */
@@ -629,7 +629,7 @@ static struct rdma_cm_id *smbd_create_id(
 		goto out;
 	}
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
@@ -656,7 +656,7 @@ static struct rdma_cm_id *smbd_create_id(
 		goto out;
 	}
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
@@ -1163,7 +1163,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 		return rc;
 
 	rc = wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
 		secs_to_jiffies(SMBD_NEGOTIATE_TIMEOUT));
 	log_rdma_event(INFO, "wait_event_interruptible_timeout rc=%d\n", rc);
@@ -1390,7 +1390,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		rdma_disconnect(sc->rdma.cm_id);
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event_interruptible(
-			info->status_wait,
+			sc->status_wait,
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
@@ -1605,7 +1605,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
-	init_waitqueue_head(&info->status_wait);
+	init_waitqueue_head(&sc->status_wait);
 
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
@@ -1728,7 +1728,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	wait_event_interruptible_timeout(
-		info->status_wait,
+		sc->status_wait,
 		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
@@ -1785,7 +1785,7 @@ static struct smbd_connection *_smbd_get_connection(
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

