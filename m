Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F94C2FB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760969281; cv=none; b=EwidISJBWYwV8ysfHZOpaKqpZMWYua9QfXge/Vn6kFF4oJ/ggLZTkmYzgUp3cUP9gJ/N/yT3LrL5zQafmB4qeKHoLCoF26M3GfZMYoIZH1APqAoCTAFVfhjJ0OWDG9T8G++t8EoBYN6CuiW1skrN+Dk6EY1jhsjtLLSYfVTaAnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760969281; c=relaxed/simple;
	bh=cSduVqCAB7x+1h3f1Dj7q7LKD68vOZtsh3UlhPPdpEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=boc5dcWgTk5FIFtU7ZoronYEoJgzrYP4KtszGhp11e23ctif6HlQPOv4c3zyUtgiY1LCGQEmtqRiSTSPV8nj4Ia3/VqF6CtHnYiO/xl34QeYrKGrFjM5HrTVlS/PDaNyV8BJDtPBLqrj31G88vTjCfScOJgt6Fu9m+BgDJ2JGBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=y0aKVQAs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="y0aKVQAs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ed4fK+ZnP6nEhONReVTtgBkffmW6wnsU1RMQraJBj68=; b=y0aKVQAsEyh/XBpYCaBN4HL+dH
	nVuugCGriBiJ6yE/8Tysgv7RqZFBEHr1pES6oZ8oWX9JLF3l7uj8JwmLYYPRkYujgZmeJmDWOE0zM
	V5FYoEDtoB/NnUABK/2kHmKauumhYNLq6FcsaA4wAlok1J+Y21YWhehg+1b0CxwkttKJ+9PRNgny8
	s72bvtXCMzPSAc3SMR5x5vwsN0msXZRWNugYdKMUhtTMp7/km2RBqqXPUFU9shuIG/MCNnfsJMzFJ
	xjcTo8o0zX07ffk2nWGrlomRoTVkRqWKosZ8wr99Zd70E6NLGfFkPmj/3GaMY1QSXZ3epcKBIJ0On
	RoovSgGc+54osy+o5alY0ZIslvWKShitcZyFyy8dl/TERZi5ypFlCQdv5sSawIm7VIJnu2RHp1zRd
	PI/ATF91N7W0IigjcvCuw+eUP91GgxEyLttD+2+XccqUAGAOPDdKcvAkmJbPZo2yfD0Ldxn+CW4qZ
	JDQ7rGqBFqAxjHLjG4AD598n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAqYG-00AATl-2J;
	Mon, 20 Oct 2025 14:07:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: let smb_direct_cm_handler() call ib_drain_qp() after smb_direct_disconnect_rdma_work()
Date: Mon, 20 Oct 2025 16:07:53 +0200
Message-ID: <20251020140753.155159-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All handlers triggered by ib_drain_qp() should already see the
broken connection.

smb_direct_cm_handler() is called under a mutex of the rdma_cm,
we should make sure ib_drain_qp() and all rdma layer logic completes
and unlocks the mutex.

It means free_transport() will also already see the connection
as SMBDIRECT_SOCKET_DISCONNECTED, so we need to call
crdma_[un]lock_handler(sc->rdma.cm_id) around
ib_drain_qp(), rdma_destroy_qp(), ib_free_cq() and ib_dealloc_pd().

Otherwise we free resources while the ib_drain_qp() within
smb_direct_cm_handler() is still running.

We have to unlock before rdma_destroy_id() as it locks again.

Fixes: 141fa9824c0f ("ksmbd: call ib_drain_qp when disconnected")
Fixes: 4c564f03e23b ("smb: server: make use of common smbdirect_socket")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1b597f9f85e3..019e5f70d7b3 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -465,6 +465,9 @@ static void free_transport(struct smb_direct_transport *t)
 	disable_delayed_work_sync(&sc->idle.timer_work);
 	disable_work_sync(&sc->idle.immediate_work);
 
+	if (sc->rdma.cm_id)
+		rdma_lock_handler(sc->rdma.cm_id);
+
 	if (sc->ib.qp) {
 		ib_drain_qp(sc->ib.qp);
 		sc->ib.qp = NULL;
@@ -493,8 +496,10 @@ static void free_transport(struct smb_direct_transport *t)
 		ib_free_cq(sc->ib.recv_cq);
 	if (sc->ib.pd)
 		ib_dealloc_pd(sc->ib.pd);
-	if (sc->rdma.cm_id)
+	if (sc->rdma.cm_id) {
+		rdma_unlock_handler(sc->rdma.cm_id);
 		rdma_destroy_id(sc->rdma.cm_id);
+	}
 
 	smb_direct_destroy_pools(sc);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
@@ -1682,10 +1687,10 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
-		ib_drain_qp(sc->ib.qp);
-
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
+		if (sc->ib.qp)
+			ib_drain_qp(sc->ib.qp);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
-- 
2.43.0

