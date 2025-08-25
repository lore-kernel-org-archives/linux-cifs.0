Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511532882BD
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155096; cv=none; b=PBG11Cuz0kCbSfsWwDga8vDUqxuK4SPx/MVHY9EUq3wq97kY09Upr4G1bNJP5OABjSBQHDBFyxDW4+brjJaB6T7yEKhouJBVLGJNH/HWoH8YkRAdWKNJ/olluvg9B5M+JD3JTSwp/300bvc9m4qtFyBOK0QdqSwu5sSne+2icB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155096; c=relaxed/simple;
	bh=CXFQKojdjUtgpRfdCS29wiJftb6puWsR2K+ov5AXGU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anxhLzjhbjfbja/+YbbV/eUS1h0xHSdHh9i0CxaC5lCh+WErRIKxyo1x/qA1CIKsgGCw3zjLDsNkmwQtxU2i09ct9ymeLhrqwY0vrE4WHm0WS0fQvg/Zv9sJ+RHybAkVLuqp1hlTY2c4tYGdcGJ9HEpJ24OM2hKFuYoG9GTHVTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=X5RiTVGG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="X5RiTVGG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ObE/uXWu142QwpSq/YLaFomoshUhKZCHOqgm3rPJDQU=; b=X5RiTVGG+KNBWAyvRYw/Do5YBU
	qeD+ICypVj4fWtOOXebfoQVjZPn3y8i035ME3kgKOkxwAbu/U1z7/SFal0FzIQBbXimwqZ0m3zpPE
	JnQV61inYGRUiMkjeSEfAoq7dYKFKocSt/kJbtvTnQwhmt4bw36/31isA5ib+Kvjn3VQbFV2abt3Z
	Bl2/5HjcmwkbY9fR4P9iGu/Emx2Qd3d8TQn0go1vzligNP2RfGAuIzAz+kwvRQLZrL5NlYWDWTO8m
	n9j/3TJ7BJTdROeZhc1W69z9JwUsoRl3ifHNp378sqPFu7gsKlGSLJTEvROLLGzL/B95f+5ltr358
	mo7MR14avyqxsO+BNmykdcELgnJyWsx8BgY/DMqNT1lpZvj3gX5CWc48bBGJaFtGCUR2LFwAUYKOo
	QK1XCwOdmh2kx6PZL/FhKF6Xez32dhYnzYJl3f0uzwz/jWR8b03q96vpFtU+Dl7mz52UBKo++C3fl
	MCIG0T43FT7n6oFwUb+eEwer;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeA7-000lAN-0i;
	Mon, 25 Aug 2025 20:51:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 058/142] smb: client: pass struct smbdirect_socket to {enqueue,_get_first}_reassembly()
Date: Mon, 25 Aug 2025 22:40:19 +0200
Message-ID: <64139a3dd2c20b6083ddbbe03e17dbbe8d974870.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d7ed5534669a..0f68c35bef2a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -29,10 +29,10 @@ static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf);
 static void destroy_receive_buffers(struct smbdirect_socket *sc);
 
 static void enqueue_reassembly(
-		struct smbd_connection *info,
+		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response, int data_length);
 static struct smbdirect_recv_io *_get_first_reassembly(
-		struct smbd_connection *info);
+		struct smbdirect_socket *sc);
 
 static int smbd_post_recv(
 		struct smbd_connection *info,
@@ -659,7 +659,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
-			enqueue_reassembly(info, response, data_length);
+			enqueue_reassembly(sc, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			put_receive_buffer(sc, response);
@@ -1272,12 +1272,10 @@ static int smbd_negotiate(struct smbd_connection *info)
  * data_length: the size of payload in this packet
  */
 static void enqueue_reassembly(
-	struct smbd_connection *info,
+	struct smbdirect_socket *sc,
 	struct smbdirect_recv_io *response,
 	int data_length)
 {
-	struct smbdirect_socket *sc = &info->socket;
-
 	spin_lock(&sc->recv_io.reassembly.lock);
 	list_add_tail(&response->list, &sc->recv_io.reassembly.list);
 	sc->recv_io.reassembly.queue_length++;
@@ -1298,9 +1296,8 @@ static void enqueue_reassembly(
  * Caller is responsible for locking
  * return value: the first entry if any, NULL if queue is empty
  */
-static struct smbdirect_recv_io *_get_first_reassembly(struct smbd_connection *info)
+static struct smbdirect_recv_io *_get_first_reassembly(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_recv_io *ret = NULL;
 
 	if (!list_empty(&sc->recv_io.reassembly.list)) {
@@ -1492,7 +1489,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "drain the reassembly queue\n");
 	do {
 		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		response = _get_first_reassembly(info);
+		response = _get_first_reassembly(sc);
 		if (response) {
 			list_del(&response->list);
 			spin_unlock_irqrestore(
@@ -1968,7 +1965,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		to_read = size;
 		offset = sc->recv_io.reassembly.first_entry_offset;
 		while (data_read < size) {
-			response = _get_first_reassembly(info);
+			response = _get_first_reassembly(sc);
 			data_transfer = smbdirect_recv_io_payload(response);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
-- 
2.43.0

