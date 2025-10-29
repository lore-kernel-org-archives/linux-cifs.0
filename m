Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2602139CE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744754; cv=none; b=lnV5fTi8eEwA2MXN96sbCfLdDTLd4ZQAUCrBvVnYGpeqoztqGPH6/DrfKc+CpcnXEYxHxtYSDYWJirZiUf419jgGajOr0IyxD6D9fvcu53+ZVkBpMGIuC8j4ssBpJnr2qkN/M15u+qSb9mEF+//FlsLrUjLrUCJzCnmVhW/d0jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744754; c=relaxed/simple;
	bh=0hhyQVsJ9WUFfO8vcLLGX1FqJ53W5rVBCRHP9E8KjyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgqeopOjizNrwlADj996yGrHkE99sLkw9UmSXI1CssgVxZIe1KbK78Q+hgbbFYWOtBrZ+53RdDXhUXuk2Z8W01d0o2t1TS9D7R9sSGuf7kcEJL7t28CVRcNPc9pNkupEyC8XRZSQp2HZuyX26yQeblieIkQ8L62q3TZnt2OrkUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Tb/vKqtx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Tb/vKqtx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=N+dm26HGsmDHJkyCTAFFE7J5g6K/mZTJdw+CJZJm9qY=; b=Tb/vKqtxdR4lKitvf3rQTY20jf
	tQCbdKAnQLELGey9HHLsDdc96Zlj7IpscEyzXj6e4rdzM4tnuSA+rGPwixJ3lIPq4ddvurEK8Ufze
	DGDgq7oM1qT50ETYstt3wWqoFQLc0TiyyCjCyCuDJzLMebHqQmN/ROoaJZGx0fpJNf3wj/xvPWMOX
	peHsXtOj4nELutiNzzd1hVAUbUYsDpbszeCcLGAg7BXbSrUtZu757ooDIP09qLeBEzBZi9H5edd5f
	V3DHB62QyUYimty0WVI7xPldPYBXd3RZpcrcN0Zoxm0kCaJ18b/S0luvpJ5z3F/1AYGfH/iVeyUR2
	mVI9AAWOgy/e0EBSfzjChERc/8kCtsOhI3JViVRXze1pu0jR4arHyPSeACcDyx9XXvDIb3sOmiZQL
	kTYa+c60u/FZ4lU0Cwod2AZswrV5r260Q6y8HhzY19MZHRVt/OL8Ly/2vEF3/iqq9MbjACpQjqWy8
	Li7cGi/n0uUs/uXnX4mg5bzA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Hs-00Bcjl-2R;
	Wed, 29 Oct 2025 13:32:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 099/127] smb: server: make use of smbdirect_connection_idle_timer_work()
Date: Wed, 29 Oct 2025 14:21:17 +0100
Message-ID: <a0ae8721b60ffe5644fa4c00489c7d2f588683a2.1761742839.git.metze@samba.org>
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
index fdf8ac7d5d34..886a350819bf 100644
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

