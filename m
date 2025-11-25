Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0D827510E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094742; cv=none; b=bwGuNNMuEjxAvOndPy1w7bRQ6uhMKjdbUjcaW2/ur9PIgONIC3OEcbRtaoX1JscI0GR0NR0hEQy2PLUxcc9KrGGf+QEwRDgxkxi+EB7Muez/W9OqIPyTdHkqYusbU8y3ZBoxWH6OH8OXtNRToPqr/YQPiHnosl00U8o0o5BuDt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094742; c=relaxed/simple;
	bh=vAkcm+IWkfORTupuWNY/EsU5GPg9wrvXHNDUCN5GUXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0LohUKmkEQ7SADiUpIzWutrcvUPdtriNW5Q8EwiS5iuElUCtRcsjGS/hDP3Vk4ddRieL89r6q5KjTcrSbAgTuZCRqbuAzpo91OKT4vm5iQbHVMHZZPRMJp1X9XqhwYWbyXuzH4QIu7qCmHBrkYNod/r3NudtPfmIfpmMVPuGx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dzJzxe3o; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dzJzxe3o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zoH+4XP8FyGpKdv2ioBMYnBqRm0WPYwl16h+r30AreI=; b=dzJzxe3o3R7GpvZHlzMcxGh/Sr
	T7TMP7CKHsU6jd0OFO8o2DveIyyd1wXPWKZcUOET06p+ciAzNXDkmNsTfi38hws0smncbl0IWRugQ
	q3QiA4LNdzIcZNz7FIoOK3Yaw0nvzpMeSIXnqQZ0otcsIqUfHpuNZ318ZDRzNPLmi97r64kbgM9MY
	sTnxlqNC99w2FxRR0L9/L4WQg7knncbtbig1gobwrq9tLwRsJmHC5IPaXljdlRdszPr26jM9AaJiU
	hXhl6BTXskHixx0PrHivvvgl8aCmuCDv/sDy2iIgp8tNh286gP3zTMDew9rV3daMG5Tor2teDEiuw
	3HWc1crQM54XaOovCrhf1I6NT98LdEcGf9ITLJV00niHsDQoHYWPzxUxAoR9iXZGgP5WmeXeGw/VE
	YU7IssihGHLqDRk7AgEpBEgSIjkdtYZeL5emz4l5fqnTPPKaD9rKGU3do1WUPweUX/WcIWAtsRI8a
	lQfOn9VdAxNWZrDd6x8KuiOj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxVY-00FeMl-0j;
	Tue, 25 Nov 2025 18:11:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 105/145] smb: server: make use of smbdirect_connection_idle_timer_work()
Date: Tue, 25 Nov 2025 18:55:51 +0100
Message-ID: <fbb3d876816e20d09bd4f22cd3aa2e118af9bc39.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of smb_direct_idle_connection_timer().
The only difference is that we had no logging before.

Note smbdirect_socket_prepare_create() already calls INIT_DELAYED_WORK().

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 0b86df43449c..9ebf19c5fa80 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -226,30 +226,6 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 	smb_direct_post_send_data(sc, NULL, NULL, 0, 0);
 }
 
-static void smb_direct_idle_connection_timer(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, idle.timer_work.work);
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
-		smbdirect_socket_schedule_cleanup(sc, -ETIMEDOUT);
-		return;
-	}
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-		return;
-
-	/*
-	 * Now use the keepalive timeout (instead of keepalive interval)
-	 * in order to wait for a response
-	 */
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->keepalive_timeout_msec));
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
-}
-
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
@@ -292,8 +268,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	INIT_DELAYED_WORK(&sc->idle.timer_work, smb_direct_idle_connection_timer);
-
 	conn = ksmbd_conn_alloc();
 	if (!conn)
 		goto err;
-- 
2.43.0

