Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC3E1F30A9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094971; cv=none; b=kshibJ+lcYG3Vp9qUBMI6bUjoG7yCeaYeZgOMSyjd6AFpMRtIU5nJXwjXQS2+0nBR1wZYlQNBY63jAwM3VgZPwufrEZw9vxozPOyfxLW/pYQTuFKzome9c+aKLnHHaZPBUefQrLgp1GdyLo5w3RQZvsVhTS51D9COsDdBKTeNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094971; c=relaxed/simple;
	bh=qNvhLbnMGcxL3uQ+mgcsrSmuXeMAdTonpGmYkpmWrKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMIQeI5UM3aXTtbD2vrgz36r6uJCJ27sNktmSwPCLX04G9IQ7a5h++EX4WKuowtUR2sfoPZ1+PgpukCkJagLIU9uo/ra2LYjVFNmWDsPDe8VJR9qIaBugb0DNq77OLzp5DQSyIUk2K4bz8VytxUsi2FZUzbq1o6/w3i60EH8w20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TcEGlYxU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TcEGlYxU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=25Y2bje89bkmFk93rvd5Xg4/YUiURq3x5QZeqV+uznM=; b=TcEGlYxULnfTEmQDY9yX95ypUN
	A8Kdpb7oK0MiYzIUcMbRTmjTOlRtJi8U4xcAzk9P8+KTakPcV5J/75alHxEpSQFNNdVY2RNjPDAyH
	IoOdE6+HHUiVMwSSxiN9h80/ABR1msr1xQzmv/3FocxspxB7MjHt26PIoMAYQBcfyvzrFPV7IJJDX
	5USdQZmoOqJfT7EWCglSJrfudbU5ceRuC2U+1dJV7K/b0RryXrFLnUn1xRTHXQpUlqPKvCwEUmZ1i
	dPdZsXu/6NxDheDK0soKrz7zqtEl9fDmGYRlQFZuFA9c2ORyKT7tTo7QxU8FGkF4UWyXw/CXAazVt
	sjMNQeMDnuSPB2PrVz+4mM6fduIetxe47H9XFk8UZp3RdBgYLYsqUAIPwv767M9tLzWXeDfspnD5m
	K/aggoB2a4oRSwaqHH1VFZMur1h5jBqV2LaeNmPT3vfmprlSm+dR1rn/r0RMYGgXhb3G6rXaW9F8A
	kZ572kmuJVBHEcxy6loHzinP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxg4-00FfLC-2Q;
	Tue, 25 Nov 2025 18:22:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 120/145] smb: server: make use of smbdirect_socket_destroy_sync()
Date: Tue, 25 Nov 2025 18:56:06 +0100
Message-ID: <8508ad34a578c48db2481cffbb758bc151858992.1764091285.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 49 +---------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a6afa7eefa20..19522fc4af38 100644
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
-		smbdirect_socket_cleanup_work(&sc->disconnect_work);
-	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED)
-		wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
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
+	smbdirect_socket_destroy_sync(sc);
 
-	smbdirect_connection_destroy_mem_pools(sc);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
-- 
2.43.0

