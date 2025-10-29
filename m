Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9A334C03
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744841; cv=none; b=tYKXVLdRGzLsUhX6a/Das9Y5+9tHgogS5KKMEx/oKcqglblwP5WnUlb8O9pkvOZkP3kZxSV8vLinrCvWEf8WGTkku8BDy7C/AUiPscpLwWSmOIqVPv+xOtKRdSfXiwL42KqtDW64QVuSioBhzXhGdCJXsSIEMQzpJVKcQgmnq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744841; c=relaxed/simple;
	bh=quL0r9dPWDbbXdn7pZ16O58bRoI2wijkWepZ2IHDBUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrF+B16iyqUpJXe4FNIe9/NUIjz+H3Flk3H0w3OsXYS49pItEKrSKp9BN+Wec4VfP7Knj3Ir7r3+g4+z0+cayoZyevJLEwOe6yRdl/vJKE0Pn8XNlGZTdI4F1wCGmQTrva6FaGoEoC39F+nFPMh+G3ZApa2lXPsqz4pnYpFlLxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GKU9Por+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GKU9Por+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=dZ7/3JmtMicIkuY/mNocOEJnKEpBBOv/T562l3U5sgI=; b=GKU9Por+h4F8aZfCwW8ovTWluV
	vhf6PcJXO4ITluQy0IqjcXl5umtpklX6lWIVkHBqXXSqfjDQu5dJQ6SLB9+zmnHRRWUwc+EiryZuZ
	jE+b9R3tvtr9HKrUqB9nl5MmpOXciSWR7jXfSsnnGFpo6WjEk2ICDRVc+k8mWTa6RBxrcOH9+vK28
	t/AYq8KugnjAyYwrZErTJTdkw5lt9srKs6ebulhGrEEjeu1lE9+ITlVn3fZOOoFessR+I9N7hashy
	WIX83/tbGTX6o3mEhxVDD+TwrE0z1IDO3PAdqqGM9HipqJfRWfCDxAMzGGoPcvxtuxwaF5OBdPohN
	3evMDGeavOAMSfg+a+JV/w+0XhPN8xwGQVOxhQaaDWS8L1DHuIRb0mbl0aJHgC6KF14lfRjEVIbrv
	YFdiiBM905aoJdey7JDREaNAmy720+LEB2gH0bK38l58N3pkLoUoAG4pDGFtpuQwWAgGnnN7yPDUN
	E2j+WxKHgFDON1clz/XCVsU3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6JI-00Bcza-26;
	Wed, 29 Oct 2025 13:33:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 114/127] smb: server: make use of smbdirect_connection_destroy_sync()
Date: Wed, 29 Oct 2025 14:21:32 +0100
Message-ID: <5f209aceb9b8b1a59350ba0c764f424244941c79.1761742839.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 49 +---------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 2845f58301fb..98ecc9f7f482 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -289,56 +289,9 @@ static void smb_direct_free_transport(struct ksmbd_transport *kt)
 static void free_transport(struct smb_direct_transport *t)
 {
 	struct smbdirect_socket *sc = &t->socket;
-	struct smbdirect_recv_io *recvmsg;
-
-	disable_work_sync(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED)
-		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
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
-	disable_work_sync(&sc->recv_io.posted.refill_work);
-	disable_delayed_work_sync(&sc->idle.timer_work);
-	disable_work_sync(&sc->idle.immediate_work);
-
-	if (sc->rdma.cm_id)
-		rdma_lock_handler(sc->rdma.cm_id);
 
-	if (sc->ib.qp)
-		ib_drain_qp(sc->ib.qp);
-
-	ksmbd_debug(RDMA, "drain the reassembly queue\n");
-	do {
-		unsigned long flags;
-
-		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		recvmsg = smbdirect_connection_reassembly_first_recv_io(sc);
-		if (recvmsg) {
-			list_del(&recvmsg->list);
-			spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-			smbdirect_connection_put_recv_io(recvmsg);
-		} else {
-			spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-		}
-	} while (recvmsg);
-	sc->recv_io.reassembly.data_length = 0;
-
-	smbdirect_connection_destroy_qp(sc);
-	if (sc->rdma.cm_id) {
-		rdma_unlock_handler(sc->rdma.cm_id);
-		rdma_destroy_id(sc->rdma.cm_id);
-	}
+	smbdirect_connection_destroy_sync(sc);
 
-	smbdirect_connection_destroy_mem_pools(sc);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
-- 
2.43.0

