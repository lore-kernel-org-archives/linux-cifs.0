Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140A325713
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744612; cv=none; b=Y2o3tnN3cexPSf8bFVOc3kWFniu5fa9rs6wz/R579nsRbShUJdokVtlC52CNgmk8+LwI2cXCXVTJWpUq1H8VPdTRpjMK9ECHYCkd1YaXFD+Wdmt5S9Egq5EpCmb6MN4B/528NL9Y3J/3rpfRkE9R/X2Oeom4hftv2moEFHm9VkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744612; c=relaxed/simple;
	bh=VATFqdn1nDgUKiTvfuXVJhjC9iAu4AseFDSp1oYdIqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVeUuRZnOWfF8VAppHoAKH+AWd+Z6VP087TD3IfGDrLfFl3vlzaIHGHfE2KKLMf+PJPbzlz/UC2klMlU+4C+2RqvwcJaBWy8gXjnkWItmUam7qwcPwGkoT3EeYtOfltDOvAWmIJN50JneGSOKphqSGenDJXRc09l6/yiQbiwIZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ku3dj6xG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ku3dj6xG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rANleGC/Y/8204Ru4by8qJkhUIdMHzrFbzxaZTJiSZY=; b=ku3dj6xGkzeekUpKH5+5ebfqf6
	MTucG5U4H38j+6HTRfC2OggGzFMhGJ91yA3FnCAP8s2rt2rWINcT/oOeZlwZ3bHaMRxeu1sbzhb23
	YwSVPIdrdnvBLGvzk3RjgH36rAWZs8kche6nl+oGjViCj9svhR2x8N3E9zLeOnLXLgcGkoey1Kae9
	OcbWZ+HucrhW3y0OK8kbiJi/vbJP+dt7EtU5JQlXgr4gkiB2LKii+gIEy76SJ5NbkaN9qfjeglv10
	Jq6/vl4CCMtX6lHKA434rMiRMK72guBaWR42iy0XBBSMIYUWyVSjCHctCZeXH5xzbWjfKO3zXAGC6
	r6RVjuS5I1oGj/bfEikkKH1cw2UOk5q2/mL2vrhfUiuG4jlhnF25Ds8W/tz0zYl4Fattmgyr2EOJJ
	iT0IcKzvG7X19Kbz/c56MXL8k7vetcgP5QYbGG95XQ1ILp215AnCkYjLWasfq29hBcRwPeGlc3Knl
	tDVUzi38Uh8NZ3Geb+G9aRNB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6FW-00BcLI-38;
	Wed, 29 Oct 2025 13:30:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 077/127] smb: client: make use of smbdirect_connection_destroy_sync()
Date: Wed, 29 Oct 2025 14:20:55 +0100
Message-ID: <15ff885cb93591d78f4c03417151a3b882428624.1761742839.git.metze@samba.org>
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

This is basically the same logic as before, but we now
use common code, which will also be used by the server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 63 +--------------------------------------
 1 file changed, 1 insertion(+), 62 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0e393f6ab835..7d786d119184 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1076,8 +1076,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc;
-	struct smbdirect_recv_io *response;
-	unsigned long flags;
 
 	if (!info) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
@@ -1085,68 +1083,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	}
 	sc = &info->socket;
 
-	log_rdma_event(INFO, "cancelling and disable disconnect_work\n");
-	disable_work_sync(&sc->disconnect_work);
-
-	log_rdma_event(INFO, "destroying rdma session\n");
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
-		log_rdma_event(INFO, "wait for transport being disconnected\n");
-		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-		log_rdma_event(INFO, "waited for transport being disconnected\n");
-	}
-
-	/*
-	 * Wake up all waiters in all wait queues
-	 * in order to notice the broken connection.
-	 *
-	 * Most likely this was already called via
-	 * smbdirect_connection_disconnect_work(), but call it again...
-	 */
-	smbdirect_connection_wake_up_all(sc);
-
-	log_rdma_event(INFO, "cancelling recv_io.posted.refill_work\n");
-	disable_work_sync(&sc->recv_io.posted.refill_work);
-
-	log_rdma_event(INFO, "drain qp\n");
-	ib_drain_qp(sc->ib.qp);
-
-	log_rdma_event(INFO, "cancelling idle timer\n");
-	disable_delayed_work_sync(&sc->idle.timer_work);
-	log_rdma_event(INFO, "cancelling send immediate work\n");
-	disable_work_sync(&sc->idle.immediate_work);
-
-	/* It's not possible for upper layer to get to reassembly */
-	log_rdma_event(INFO, "drain the reassembly queue\n");
-	do {
-		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		response = smbdirect_connection_reassembly_first_recv_io(sc);
-		if (response) {
-			list_del(&response->list);
-			spin_unlock_irqrestore(
-				&sc->recv_io.reassembly.lock, flags);
-			smbdirect_connection_put_recv_io(response);
-		} else
-			spin_unlock_irqrestore(
-				&sc->recv_io.reassembly.lock, flags);
-	} while (response);
-	sc->recv_io.reassembly.data_length = 0;
-
-	log_rdma_event(INFO, "freeing mr list\n");
-	smbdirect_connection_destroy_mr_list(sc);
-
-	log_rdma_event(INFO, "destroying qp\n");
-	smbdirect_connection_destroy_qp(sc);
-	rdma_destroy_id(sc->rdma.cm_id);
-
-	/* free mempools */
-	smbdirect_connection_destroy_mem_pools(sc);
-
-	sc->status = SMBDIRECT_SOCKET_DESTROYED;
+	smbdirect_connection_destroy_sync(sc);
 
 	destroy_workqueue(sc->workqueue);
-	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
 	server->smbd_conn = NULL;
 }
-- 
2.43.0

