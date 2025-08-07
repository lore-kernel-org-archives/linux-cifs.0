Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733813C9C4
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583176; cv=none; b=quPITyWRisFnmSu2Hm9ybfsZXOwrt76XgVhQYlayS2sTkGFraBurgFu4C/J2qYXrn5hA9tN+p+lBGK+NwAH3zCeICaqXsAZ3Uc3bqHwZDFZAvRcSl7rPkpD10RmvR2h3bGkOQc9C49KLcbpxxiw37oaVhF3b7cXs99jP7+m2ll0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583176; c=relaxed/simple;
	bh=6AgUyotjAPOowb/IgW/O1mOAs2/bB3p8YyKW1ON6Ob8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORNudOesPoX+oNl5XhTl375drVWyyOYgi4H12Ljh6d7UqyMblCHf30suBEE2XjrRKQ636Jp05tC6QrMFCXzPRqX8I3EDWvuhsGZpKCO2Md/3e0hUTWl4edKX5AdTcvX+hnHOis2Hwa5rSBFYcrJ+F6oMj7xf8HVGocXyrg6c4Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PpBhubLV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PpBhubLV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/0Dta7j8E66CmRRUd8dfUuvgrQE9moF7DWL2g53oqyU=; b=PpBhubLVUn+VAMKwIspD6Df7eA
	Y3GO0REWxzp0GedGqlhc4fpzvMkzU7/konJaOaSj3u+9jy0SJylY6SpgvxkDZJL4fd5npC1cKLJNq
	M4EjQiLrOCxcqRXC5qNX+V5ArrXpFQdcztEAyEicDGE2hIyOt65QHmPuS0kmCHCzf3a+PuIWvczmM
	MKvj868+YuqfQehOBRI6DqTSMjY43/IgbRas4SSi1S8ntCzvJcoJlLnHv9QYKqwMcbsw0VYY8vTqx
	e3ZDIYMCWnP0eHHRODq98ULkd0HJm/0LDqJ/AGKatKB+/hG4JT93BLON8AFjlEURLid+4UZArFb4v
	uHsaAxqSmyiJnmaorN4i3Nazm/Elb8MynLQnXpWb3b6Na+c9rsthaL/YdwvxEWXeHP//oG9SGStCg
	2NWSHq2E7fZuv+CU/1p1s1ZXyfOzTenLUU3b6G8MH6UnW5xktH230zGiT0RdET5Q7q4C43Vx7csSD
	loC9JhR/fBfBbPKQdScU9FXW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3EX-001cb7-2B;
	Thu, 07 Aug 2025 16:12:50 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 4/9] smb: client: only use a single wait_queue to monitor smbdirect connection status
Date: Thu,  7 Aug 2025 18:12:14 +0200
Message-ID: <8666cfae9d4c1601171ec12d48b99e002d249ac6.1754582143.git.metze@samba.org>
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

There's no need for separate conn_wait and disconn_wait queues.

This will simplify the move to common code, the server code
already a single wait_queue for this.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 17 ++++++++---------
 fs/smb/client/smbdirect.h |  3 +--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c819cc6dcc4f..c628e91c328b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -205,7 +205,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_ESTABLISHED:
 		log_rdma_event(INFO, "connected event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
-		wake_up_interruptible(&info->conn_wait);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_CONNECT_ERROR:
@@ -213,7 +213,7 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&info->conn_wait);
+		wake_up_interruptible(&info->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
@@ -222,12 +222,12 @@ static int smbd_conn_upcall(
 		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
 			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
 			sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-			wake_up(&info->conn_wait);
+			wake_up(&info->status_wait);
 			break;
 		}
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_interruptible(&info->disconn_wait);
+		wake_up_interruptible(&info->status_wait);
 		wake_up_interruptible(&sc->recv_io.reassembly.wait_queue);
 		wake_up_interruptible_all(&info->wait_send_queue);
 		break;
@@ -1325,7 +1325,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 		rdma_disconnect(sc->rdma.cm_id);
 		log_rdma_event(INFO, "wait for transport being disconnected\n");
 		wait_event_interruptible(
-			info->disconn_wait,
+			info->status_wait,
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
@@ -1650,8 +1650,7 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&info->conn_wait);
-	init_waitqueue_head(&info->disconn_wait);
+	init_waitqueue_head(&info->status_wait);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
 	if (rc) {
@@ -1660,7 +1659,7 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	wait_event_interruptible_timeout(
-		info->conn_wait,
+		info->status_wait,
 		sc->status != SMBDIRECT_SOCKET_CONNECTING,
 		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
@@ -1717,7 +1716,7 @@ static struct smbd_connection *_smbd_get_connection(
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
-	wait_event(info->conn_wait,
+	wait_event(info->status_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 
 allocate_cache_failed:
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 0d4d45428c85..e45aa9ddd71d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -47,8 +47,7 @@ struct smbd_connection {
 
 	int ri_rc;
 	struct completion ri_done;
-	wait_queue_head_t conn_wait;
-	wait_queue_head_t disconn_wait;
+	wait_queue_head_t status_wait;
 
 	struct completion negotiate_completion;
 	bool negotiate_done;
-- 
2.43.0

