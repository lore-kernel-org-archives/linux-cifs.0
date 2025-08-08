Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FCC186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671725; cv=none; b=f4ur4qr8QqMLkbLXusDh1es8yENloz20XfP+jSX61SKmVYYER/PznSgCVccFTq7w4y+hK36xnkOTAb8mpsB5hxIbnhqzL7IKOd1ozNg5U5TBY1iNaxqpq6UXe2WNn86j373mXqdGyRjucYCFhBkI0jOW4CZqXE5CYyuCE65JwJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671725; c=relaxed/simple;
	bh=ZfvlHb5AspgDHQdOHj5yKD2o4/whbXbm0weNv5OGAVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9Rub/Pni2aMDmMUUBiJ0augEAVl1uSt3bILL1609D0CZQyMsBDY5E/JK2ndSwY5T9iFSCPnBksgeZVxoV2c2Db/P4S5Q+DzDUyv1S1AnOgPIn9ykXJDzUoKnU6MGj9UAtSXUYFjKiVE7ePrbtgMmOxumq5LWDnIm2gEvPbCkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Vyeh3dVj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Vyeh3dVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Qm57wk1qEdpcrVDBfLhRBpoucjNgZxf0N/Dk21wNWRQ=; b=Vyeh3dVjV3KkwVC2q3YnHAJR94
	v5FAi/AltCFbiYmaBochqFwSRuH6ftXrFzf+A0fft2tEZwIAXd95vRzDxbm/AHi++/2lhMw10vfs/
	NAgJDVNDcS36RbYTCp535lNWPGVgH0Cnb/QdmBe69Odda80sbw860sUikg43jvuGfC9cU/ZD2HvRE
	bP7oDUaqf1WmLanXeFQpNDjV3RFoItdveqXDOCyxiePIHce19UWkJpeuF7MmK174f7GcQvCfFM+/Z
	i8iNhW93MIIrnvOHt0n1Zuknxad9Ws/7JAw7mMY0RU3zG3APe5yHcG1op7hto7jrdTAssK+d7hSPw
	UhsPwWK+MvVUEj9khBNFo+a0+QNOpr9mZAAO+qNWqmgP1MzD8Z7H0OwRGeq//8ys0VsG6MKO57HCB
	e1zIN4eq92UwWMGGkZBHxqpYs2tziNfc9cKejNJ860DfJuY1Il2uw1uSDIsxgFM2qljfXPWaBPNTP
	RT/BlNGDzq6grT3va0evS6vh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQGm-001qMz-2j;
	Fri, 08 Aug 2025 16:48:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 2/9] smb: client: improve logging in smbd_conn_upcall()
Date: Fri,  8 Aug 2025 18:48:10 +0200
Message-ID: <4260099ac5a1b2feeda4b98743b5bbe51d28ec89.1754671444.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
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

