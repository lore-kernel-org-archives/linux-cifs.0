Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61E442049
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744531; cv=none; b=lkJPw2pDII4gTJyF8YkjYU1s2urngfd9h1eXGUdYjtuy42zGe0uQGp+vl0Y9KZ/iZA/OzcrY7JgFUAbq08xkDKvcYE7o+JPAs5fKTdj6/09vx8OdpP70XYlap8LBw+jBVDFZxAjMYuDJfUk8lPHSbOyzHLUoRhNA1wfUzRPJZQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744531; c=relaxed/simple;
	bh=EVwolVBqZn3nlXJMQHWNvj4g+Kisvi9KUfQwodltEs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9Lviras9S7GAGFn3H1NVKw3n4DRokaqJ73ow9SDALFOnirX5rZ/DWqPEDFYQ3Z+cAmzsTtVQPYQvtnV4oRt7+NPneqGBiJRimYPZbx0cRatpebatKTYV/hWvSH06s5gxubnQWn/TMEZqkz/ETkihl7cSorkOCmDRR/q+EUnGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dgCaeW1I; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dgCaeW1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=V+FFBxArbo21Cd1+L6rEQqlYekt/GGgHyQFuMb14eAY=; b=dgCaeW1I5P9X6PZdcO1169+pfP
	iioQt9obPO8rq1lDsCBbsJMZpCGHP68+b+kVbUhdP3R3gxM88pXV13xPlymcpis8AhJ353aZ7Ymek
	yOMF7jrhv7aahKUDoKcsiT/mQcMU3x/fQysVhM+P9NGzCDtM/NdCzoI/oBjeSRqdz+Uf3gsjF8v1v
	ItM+wxTYFnRPxLsKhX8EcrjEuxdJ9ICZfjM9g0Pr0RAOQ7ZXag3sA/d3DdIojjuI8DnRXz5q5wtEl
	rQCca5fJF7Zg1pg4E5caur6MFHXIPzl+q6qtuxg2Qh7isR9otm8lFtuG+hU6xm2opE/uuHaiJrXkH
	Xml9ZmrB9siIk2k9xye5Ui/AGL6oKMiMs1O4DUlO250r3zipNTa5/nlkj1T6FpxWA1fULNaXG+2Hk
	b4bqUCIv5K3q3vc/9gw9nDcMJ2U4IGI6C62kflgsYyUkH5V5o63SnLt09JhWLT7XjQtxD9g8Ro1GP
	gQUOimYnCzgf9+0J91vu0p9B;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6EI-00Bc9K-2Z;
	Wed, 29 Oct 2025 13:28:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 064/127] smb: client: make use of smbdirect_connection_idle_timer_work()
Date: Wed, 29 Oct 2025 14:20:42 +0100
Message-ID: <f6616b76e34975c9a133cd97b591e598d9152397.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of idle_connection_timer().

Note smbdirect_socket_prepare_create() already calls INIT_DELAYED_WORK().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cf2f63696f85..e61f41fd020b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1339,35 +1339,6 @@ static void send_immediate_empty_message(struct work_struct *work)
 	smbd_post_send_empty(sc);
 }
 
-/* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
-static void idle_connection_timer(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, idle.timer_work.work);
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive != SMBDIRECT_KEEPALIVE_NONE) {
-		log_keep_alive(ERR,
-			"error status sc->idle.keepalive=%d\n",
-			sc->idle.keepalive);
-		smbdirect_connection_schedule_disconnect(sc, -ETIMEDOUT);
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
-	log_keep_alive(INFO, "schedule send of empty idle message\n");
-	queue_work(sc->workqueue, &sc->idle.immediate_work);
-}
-
 /*
  * Destroy the transport and related RDMA and memory resources
  * Need to go through all the pending counters and make sure on one is using
@@ -1771,7 +1742,6 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 
 	INIT_WORK(&sc->idle.immediate_work, send_immediate_empty_message);
-	INIT_DELAYED_WORK(&sc->idle.timer_work, idle_connection_timer);
 	/*
 	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
 	 * so that the timer will cause a disconnect.
-- 
2.43.0

