Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6304632C927
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094214; cv=none; b=s5DEbZ3i9y2nKY0xSPoDvUBbdbjXbTKCAC0DnswdqMW24opQ1VkB0LwO88fFFTxV6ZJFWwvf4/S4sjT+LMsitOoVWubbGErvxFnE3Rzt88oWgm6G/JaLWmlSiR7GhB8qCnIBuo0tMlQoY4KcYf97LqNTAMvSQ21JHDnohW0lsRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094214; c=relaxed/simple;
	bh=Ziyhy8SFZgTapu80P6LhrxV8GFKLc9bWrVHW8Vt2dCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIzZpguglKXeHpj89Koez39CV6g0uq2xTxo+aBfqSNa2bQBn2LrTY+Ex860CblLgmVhZInYSmAgt20cVEmp3KQFChkDLfQKTa/WHmxcqVcGk4sRvFi8cVaAWxfHTmXKgSfKvwQxEhB7+4ynCzrOzZKrOpYfL8wuwoAmrmkEtQuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=w6I3/ZBB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="w6I3/ZBB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=idw1C0nEA3EojNDx3c5+pPmnlfxkPYYpaS6zKJCIOvk=; b=w6I3/ZBBPeDY9HLH6Ib3R+Mtdr
	igXwIu+T5saafLQeoCzSybOmlmsC6hZHT0Diuj2okAU6OMrCs3zn2SK4QAkdC8bjLny14py8UwGyT
	CUDmU9i2ZFoEKD8qV7I2efI2Ua6YJ94Iko27gcGzldhfbNRdHy0DGeAnAASKDQWGaSft3gxNqhd3A
	dDRomxHjTP4QwqdInTPecgluTn2oya8blnVbOte4UeVvwj1OiXhyqFh210QM02FR9drudmKa0zM1n
	FIYG8APD+wKdt99g2KhbDdZVJ4zZCxe1PgijUe+unyr1lAQAyaYI3jPoeZ0/3OYO0h2G4tozzdvCA
	lY0DAb/lUpEL1iy3uqlDAVHWa94GC+0ahffEiRZz84eXST11E/HnBf/f97vmkGAaYS8tC9fZjQ2hi
	jmXaGetldbSXzA3frNycw2D2QfMDKLZQd6MxMgnLmvaf1k1TZuD53R7oaTJCwoiXnPRfX9P8+cwW4
	+YXG526n0ZlN1wiMMHXb50Xd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxRR-00FdtN-2D;
	Tue, 25 Nov 2025 18:07:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 082/145] smb: client: make use of smbdirect_socket_destroy_sync()
Date: Tue, 25 Nov 2025 18:55:28 +0100
Message-ID: <c2a295e5a82c76e6894d0eda230cf19d6e016dcc.1764091285.git.metze@samba.org>
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

This is basically the same logic as before, but we now
use common code, which will also be used by the server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 63 +--------------------------------------
 1 file changed, 1 insertion(+), 62 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 489553456fcc..a240f3545f9a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1077,8 +1077,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc;
-	struct smbdirect_recv_io *response;
-	unsigned long flags;
 
 	if (!info) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
@@ -1086,68 +1084,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	}
 	sc = &info->socket;
 
-	log_rdma_event(INFO, "cancelling and disable disconnect_work\n");
-	disable_work_sync(&sc->disconnect_work);
-
-	log_rdma_event(INFO, "destroying rdma session\n");
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smbdirect_socket_cleanup_work(&sc->disconnect_work);
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
-	 * smbdirect_socket_cleanup_work(), but call it again...
-	 */
-	smbdirect_socket_wake_up_all(sc);
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
+	smbdirect_socket_destroy_sync(sc);
 
 	destroy_workqueue(sc->workqueue);
-	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
 	server->smbd_conn = NULL;
 }
-- 
2.43.0

