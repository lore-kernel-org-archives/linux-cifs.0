Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8EC256C91
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583160; cv=none; b=texOGBD27IER1YzGzbJ3fhMk07f1z7wVWP2F/eUl/7e1+u6k3PgDyWI6d0JQ5yezVXeg8mDoszP/gCOGUpbLPrDmRlYwoTtr3U9B0wE4P2fJrws2TD8E3UaYRmB6jXGqVZFt4UfojaUaAoqpki4nqeHdy0ql2uCokyaus/ccwgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583160; c=relaxed/simple;
	bh=UMIjQwLu9xP0mo5feWAie9xDwQ/Rr9OyuJrNPb/ZTFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cchfjuq6u7NHfgo5B9NpXI6cuXUp8dWJj8MqiIojZyFBc5fWijjthm5ukwx+0W/e6ZS2xaDi0ft4vHxq6jjFkXie0aY43a2L+83Xbde6HvnxKHbhJSlSRo9HUrfwWAREEYM2i1GC7DFuLm+P7Y08gYHVtQUEfSMN/ZLIMNfmOWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BKtJX2AQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BKtJX2AQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sI3eL0Rtx4HNu2EQ1ZC18nllq7Jk3jVNNHRdn65ROhI=; b=BKtJX2AQjNTuNG9RNW9/YrF57W
	SzXDorhDndsnQv2ne9zdD2aNuCIIt7uQZGCp4VZqOlZUJVd+387yZnqyr3hslABthSG52LTFHCAHx
	GNlq/RpBFqtU1PAnW6y+e2kzmkhXNiM140YB5j8gWEN+JpK/kgU0R4kgXCzmXLBrCMwjmcVMwDAcL
	eGoSLCNmgQwhaqG0fid8ZfBKRa2tt3x2h+FIrsWRZgOu2n9IngbkcapzDmfSNE5ZykAdYxw968Zep
	TXpZbjEBWNTgaMU/3ay7yWJxjnARiuSNxdpGuWFI6vXO4uWp0hhtzZOQG9niE58HUu1+3R45zR/yE
	YtlHLJENOpspGg5CUwHGFV5O7wAqNHOS92/wrET5yHkzogO+vUcSkxYazVNOOzOFA/T66IWFlam0b
	knfj5mgJRVKZPIfVRd///0Zjupj0edfzCfhEMiMWGyZB0m+CefnH1sfbn/x9R9TezhPhEaecMnDUO
	CbIaZmxC41EfqTpUUgKFNI4E;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3EK-001cZO-2i;
	Thu, 07 Aug 2025 16:12:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 2/9] smb: client: improve logging in smbd_conn_upcall()
Date: Thu,  7 Aug 2025 18:12:12 +0200
Message-ID: <23d24b1a252380f0af4bed416b7af48e86e3fbc9.1754582143.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 181349eda7a3..8ed4ab6f1d3a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -178,9 +178,10 @@ static int smbd_conn_upcall(
 {
 	struct smbd_connection *info = id->context;
 	struct smbdirect_socket *sc = &info->socket;
+	const char *event_name = rdma_event_msg(event->event);
 
-	log_rdma_event(INFO, "event=%d status=%d\n",
-		event->event, event->status);
+	log_rdma_event(INFO, "event=%s status=%d\n",
+		event_name, event->status);
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
@@ -190,17 +191,19 @@ static int smbd_conn_upcall(
 		break;
 
 	case RDMA_CM_EVENT_ADDR_ERROR:
+		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		info->ri_rc = -EHOSTUNREACH;
 		complete(&info->ri_done);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
+		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		info->ri_rc = -ENETUNREACH;
 		complete(&info->ri_done);
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
-		log_rdma_event(INFO, "connected event=%d\n", event->event);
+		log_rdma_event(INFO, "connected event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		wake_up_interruptible(&info->conn_wait);
 		break;
@@ -208,7 +211,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
-		log_rdma_event(INFO, "connecting failed event=%d\n", event->event);
+		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		wake_up_interruptible(&info->conn_wait);
 		break;
@@ -217,6 +220,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_DISCONNECTED:
 		/* This happens when we fail the negotiation */
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
+			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
 			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 			wake_up(&info->conn_wait);
 			break;
@@ -229,6 +233,8 @@ static int smbd_conn_upcall(
 		break;
 
 	default:
+		log_rdma_event(ERR, "unexpected event=%s status=%d\n",
+			       event_name, event->status);
 		break;
 	}
 
-- 
2.43.0

