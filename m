Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE37285412
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666947; cv=none; b=kgHs2vGFmSh9W6obQ0F1rj459uF6d4944r69NgauPGO8FvgaQvr+MM1H3FboLVKBZH0JHOOmwxKERvKea8HHZgst5eicGTWm53ooHDmWagOA6GPJbTZv9eo29hUVdNpj5Uq0YDPAac8Xpuheu3MzKBHPPSZlNEA/0A4B+jXwC1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666947; c=relaxed/simple;
	bh=EbSDqIkH18b5ExV7PaFAnVGdentARsU/PLM2dC4UP+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdU/PzKRG6xz1ktdppD87rotzCvzbaBsmjZG2sTMC98l/eANcYqCbu1GImugbIBQ8m+J1zMgbh7I/2hZ7LFtDzFT4mShAfSM06JuTHtBou+vTf8uZOb2x3eTw4m7HkWUAtluKXayR/KDaSrJ9SArYRgB9vrIhaGQ8LpsIZ+cv7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hGzpLQ0q; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hGzpLQ0q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=z+zdMCUD12DaBxn5oxFio99UaueIqxXtriP1oBtF0Qc=; b=hGzpLQ0qchUYxMVvnWC5Y0t4hI
	7HIIEgZFakspHWJhLqffAhchNxhYwbX4klV07bibXNr0TpDVoLbPQ0kfF3CxTboL+h8luzWCGS/lN
	vMkIt2p3Mg6wL4MReETgPHtwoxZD4y5BM3D6RSMaTw/SOYN40EEdfs1wMGX/uoJiosXdy9RVyN5Vs
	SrlLsL5s2sarO/D90/foQdvll518G9PbSejVECimMRAg9UfhFzWZT3O9KznR6WPT+MzWrG+C52drJ
	Z6SPY1b+soX6Wb1pZain6keJ8n26dgTzRKyjn+MstRvd/cql8RzmF+umUrix1T3Y1Np6G1NaucJa1
	oz+BEQIkDBkDhNDdM0N8QDG5g0aZB8FewAVwn9pXbTm5rmQCDoBuYqT+Sa7tfELzhjRFKoJk5u2Z6
	zXuBlYaaa6F8KpMbqwOb5TJ6lfkN7Pd3WwZ6/zHaRtyZ3Fd2DZdRe1IXVPIDnlgWHShn7j1EZTIyn
	wosa4R9DqAW7fMAm4VsE2pUQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP1h-001pTY-1x;
	Fri, 08 Aug 2025 15:29:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 7/9] smb: client: use status_wait and SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
Date: Fri,  8 Aug 2025 17:28:05 +0200
Message-ID: <0e7f6c3f3ca208a86f86d55f76cf5f50af20fb5a.1754666549.git.metze@samba.org>
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
index 2057dae51e7b..6e0ef7ca8ab8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -187,31 +187,27 @@ static int smbd_conn_upcall(
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
@@ -597,9 +593,6 @@ static struct rdma_cm_id *smbd_create_id(
 
 	*sport = htons(port);
 
-	init_completion(&info->ri_done);
-	info->ri_rc = -ETIMEDOUT;
-
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
 	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
@@ -608,20 +601,26 @@ static struct rdma_cm_id *smbd_create_id(
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
@@ -629,15 +628,22 @@ static struct rdma_cm_id *smbd_create_id(
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
@@ -1572,6 +1578,8 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
+	init_waitqueue_head(&info->status_wait);
+
 	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
@@ -1682,7 +1690,6 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 82505df4a751..62458a8fd109 100644
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

