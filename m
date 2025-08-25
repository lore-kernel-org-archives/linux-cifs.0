Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D26929A9C3
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155480; cv=none; b=I8IhM+HhtVf+/lB8Janny1bqtOhzqaKO+yj3ZaBl2wv/82RT/m3jtchNMGy2KaH1MK/GF8X7lW6lMHsKAsNnur0O0h5NEfvarPdq0jNvsYisB/hQ8+9e9yUhQZDotnuYCGTHP6McE+dTnfV/q8P4LinxB453nTlp79/FU7jSLwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155480; c=relaxed/simple;
	bh=BXN+PQzOm8rluejl26+Fdxl7cPGsFfRSffQ8JOuKUTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noXvf+JZtx9fC/zSNLlpg5uaAhtPrZ5sYPnESVTc+n+UpcBr4uNl8GXceju6va9sYQqnd8ct3nRkS/wYDu7UJKjbwUHluxi3ttT2ks1ojw0VciWLSQYhnt/I+g+S6Xr1OTcBr++N5o+wQ0iTJNhWflm4OQJ3FktDlQNft46eChQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=p+duxvzq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="p+duxvzq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1G+SuiQDh9Qg+QNby5Ycgy3s5ACzLtb3Ohy88mwNxUs=; b=p+duxvzq3zmoIBenKE3yLFm0vJ
	bdi4LXcGzPHijJqtsJB9DxKbQnbujsHPFVNxEh6sTA+YS/0zrX1JIuO4Ad3qsfhvKu60aA05Nzedo
	C+eR6RrIMbI59tQB18ix5KX+oxo6XrbTwxbzLNoX8h8jpVzg0JU4BIDBgaJa7sve8Lha2rdkT27hg
	fwKfTKw+q+k8oOm6hlwbd1zN7a/nN8vosNMazCBboxydFHbMy2s2VHwCp8QRRN0bc+G8/7aXKRTOE
	iRilUzT1b7rxaJbxififUBYVtUkLpQUrkKePvvd2cySJTuQvEsHVW8Kjim99mXkt22QQosp2lmGQQ
	mhoUiXxTsa0342rbGzlRJdv5z6lHRC5+eSHcYTfJGTkL9cIgZ02/Dz8bp6SqrXIKEI6a//+lviKpE
	04h+t4ml03jFtLNiQMrJ83MymUEeikdpcEm7wZXzRYBGivvBmsMu2RgIUYPyzobHpf5mDMx4tij9i
	P9ZswVka4GkYXFvV66nNWObJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeGJ-000mRu-3C;
	Mon, 25 Aug 2025 20:57:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 097/142] smb: server: make use of smbdirect_socket.disconnect_work
Date: Mon, 25 Aug 2025 22:40:58 +0200
Message-ID: <b1ac53d300f4c48d108534193b15c18eafa12364.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f41c82598e3c..62e13112a2b6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -111,7 +111,6 @@ struct smb_direct_transport {
 
 	struct work_struct	post_recv_credits_work;
 	struct work_struct	send_immediate_work;
-	struct work_struct	disconnect_work;
 
 	bool			legacy_iwarp;
 	u8			initiator_depth;
@@ -248,17 +247,17 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smb_direct_transpor
 
 static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 {
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, disconnect_work);
 	struct smb_direct_transport *t =
-		container_of(work, struct smb_direct_transport,
-			     disconnect_work);
-	struct smbdirect_socket *sc = &t->socket;
+		container_of(sc, struct smb_direct_transport, socket);
 
 	/*
 	 * make sure this and other work is not queued again
 	 * but here we don't block and avoid
 	 * disable[_delayed]_work_sync()
 	 */
-	disable_work(&t->disconnect_work);
+	disable_work(&sc->disconnect_work);
 	disable_work(&t->post_recv_credits_work);
 	disable_work(&t->send_immediate_work);
 
@@ -298,7 +297,9 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 static void
 smb_direct_disconnect_rdma_connection(struct smb_direct_transport *t)
 {
-	queue_work(smb_direct_wq, &t->disconnect_work);
+	struct smbdirect_socket *sc = &t->socket;
+
+	queue_work(smb_direct_wq, &sc->disconnect_work);
 }
 
 static void smb_direct_send_immediate_work(struct work_struct *work)
@@ -325,6 +326,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sc = &t->socket;
 	smbdirect_socket_init(sc);
 
+	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
+
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
 
@@ -346,7 +349,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	INIT_WORK(&t->post_recv_credits_work,
 		  smb_direct_post_recv_credits);
 	INIT_WORK(&t->send_immediate_work, smb_direct_send_immediate_work);
-	INIT_WORK(&t->disconnect_work, smb_direct_disconnect_rdma_work);
 
 	conn = ksmbd_conn_alloc();
 	if (!conn)
@@ -370,9 +372,9 @@ static void free_transport(struct smb_direct_transport *t)
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg;
 
-	disable_work_sync(&t->disconnect_work);
+	disable_work_sync(&sc->disconnect_work);
 	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
-		smb_direct_disconnect_rdma_work(&t->disconnect_work);
+		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
 		wait_event_interruptible(sc->status_wait,
 					 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
@@ -1493,7 +1495,7 @@ static void smb_direct_shutdown(struct ksmbd_transport *t)
 
 	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", sc->rdma.cm_id);
 
-	smb_direct_disconnect_rdma_work(&st->disconnect_work);
+	smb_direct_disconnect_rdma_work(&sc->disconnect_work);
 }
 
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
-- 
2.43.0

