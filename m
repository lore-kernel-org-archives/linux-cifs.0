Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91529A30A
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154729; cv=none; b=M2aUM3K2gl7xY9lQGTfIRKfNp/krEHNFE34P2N89IL3Qw34DhyKCLHztBDeULZ0RwRP7+2jkYkTB7q+5ljOdgpcLVBwBuEuGrfmkFnFxablM9oXFnvvDiRNB0PvvdMF6bQkVQlFNMMg2zykhU9vfCyr07CzOgAFr4OBxPNq39v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154729; c=relaxed/simple;
	bh=DKDPVODinnrik9OQ8LHPf87zFCFp14CqcKWfhToqFTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk1euVBxoJ2FToF+uue3YtQkw6dBOPGq2HWAUKz9hu9YyucilNZi7ncCmGcx0Ydwwassa2TvVqETs+sn+Lf606RNmiSIP/rA/tu0d8HZH5k4nk8ZrVrpZv1eMJ4lRb6y1Cgm2H/YjrTWOULnjh4IFyj9dLWNINaEbGDwCJnADYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mx3uJuHI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mx3uJuHI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=VcNkH8FpkCWOrLZAhWj0KooWen/Zr5IRwqFZK++aEQg=; b=mx3uJuHIXj6A76q65p9rIJCTuW
	LDPHGu1tOBYkwiPOjbwjm9EBtoc+p57wYEO2oVO2gh+ARhuzpmgfjySyX5za6fKWfBYyQVEFgp5ns
	4zMoSG2UTRnDSfsX7OkkkI63bMArWgjdniNyD/HqVUXd2T/TNxKV9X71lJldP9ckTjMdQ8DvYJAjf
	9omvUEmJ6rVJYEjr4ryYbxbhUw9iQj5sC4bgjwb+74yMyTSmqJrcwg+ENa2rl4OgQryHMZurU/Wzr
	hsbMGlnqlU7jdc6ieIfF/fQDtJOqL57T7eDL21DgiV7Hv+MUR8GLomuhaooPyIhwBId3AIRA2Sqqd
	kvoElBS3MWxgAZxJ4zet6GPw/gYvT0i3BO9Rs73Kv/FT2MNj4Z61oHJwBM1MtkLzrCJcCSzf+uwOx
	2XJV58Wma3Wn6CJCK6QFuVRB58LchW5LWPlgMwKyA9mqje6wD/3wWPz0O5PoHWEfWv9PDtT92tKfx
	kgjbasgzSxrn9sYn0VS1qjaO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe48-000jsR-2V;
	Mon, 25 Aug 2025 20:45:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 021/142] smb: client: use status_wait and SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
Date: Mon, 25 Aug 2025 22:39:42 +0200
Message-ID: <9c2c8dd0d75007515c4ad096df16e3d2d5bd4b04.1756139607.git.metze@samba.org>
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

We can use the state change from
SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING
to the next state in order to wake the caller to do the next step.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 49 ++++++++++++++++++++++-----------------
 fs/smb/client/smbdirect.h |  2 --
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c94b7d4f2dc2..8d1b6e36412c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -216,31 +216,27 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
-		info->ri_rc = 0;
-		complete(&info->ri_done);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
-		info->ri_rc = 0;
-		complete(&info->ri_done);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		info->ri_rc = -EHOSTUNREACH;
-		complete(&info->ri_done);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		info->ri_rc = -ENETUNREACH;
-		complete(&info->ri_done);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
@@ -679,9 +675,6 @@ static struct rdma_cm_id *smbd_create_id(
 
 	*sport = htons(port);
 
-	init_completion(&info->ri_done);
-	info->ri_rc = -ETIMEDOUT;
-
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
@@ -690,20 +683,26 @@ static struct rdma_cm_id *smbd_create_id(
 		log_rdma_event(ERR, "rdma_resolve_addr() failed %i\n", rc);
 		goto out;
 	}
-	rc = wait_for_completion_interruptible_timeout(
-		&info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+	rc = wait_event_interruptible_timeout(
+		info->status_wait,
+		sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
+		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
 	if (rc < 0) {
 		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
 		goto out;
 	}
-	rc = info->ri_rc;
-	if (rc) {
+	if (sc->status == SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING) {
+		rc = -ETIMEDOUT;
+		log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
+		goto out;
+	}
+	if (sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED) {
+		rc = -EHOSTUNREACH;
 		log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
 		goto out;
 	}
 
-	info->ri_rc = -ETIMEDOUT;
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
 	rc = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
@@ -711,15 +710,22 @@ static struct rdma_cm_id *smbd_create_id(
 		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
 		goto out;
 	}
-	rc = wait_for_completion_interruptible_timeout(
-		&info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
+	rc = wait_event_interruptible_timeout(
+		info->status_wait,
+		sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
+		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 	/* e.g. if interrupted returns -ERESTARTSYS */
 	if (rc < 0)  {
 		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
 		goto out;
 	}
-	rc = info->ri_rc;
-	if (rc) {
+	if (sc->status == SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING) {
+		rc = -ETIMEDOUT;
+		log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);
+		goto out;
+	}
+	if (sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED) {
+		rc = -ENETUNREACH;
 		log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);
 		goto out;
 	}
@@ -1653,6 +1659,8 @@ static struct smbd_connection *_smbd_get_connection(
 	info->initiator_depth = 1;
 	info->responder_resources = SMBD_CM_RESPONDER_RESOURCES;
 
+	init_waitqueue_head(&info->status_wait);
+
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
@@ -1763,7 +1771,6 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index c9b0c6b61e7e..82b1d936e800 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -45,8 +45,6 @@ enum keep_alive_status {
 struct smbd_connection {
 	struct smbdirect_socket socket;
 
-	int ri_rc;
-	struct completion ri_done;
 	wait_queue_head_t status_wait;
 
 	struct work_struct disconnect_work;
-- 
2.43.0

