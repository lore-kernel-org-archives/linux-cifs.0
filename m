Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C42DF714;
	Mon, 22 Sep 2025 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570417; cv=none; b=qK/dd8bdCv5yjGIdFZ9XDLwxd68LImWWtSoXWrECOnRq1mLtN8WwlgdhC3F+/p9wc5WyWzoolcektUHW2/8grrlQuufQdJEv4WLIk2UIliwpIRbZB6wLlbxX7XNyj821FpDmTa+tlI6Z/2GJNyl+FtsUWFjdWVcudxbp8bF7vNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570417; c=relaxed/simple;
	bh=/Cjtc1tpJpffRQlXG+byk/p6b+Yov1cn/Molb5Y6KEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvZTt382Gds9q3tSN/cTtjKyiay8ZoYF5hKAmqA97hTpTbxr5Rmt64hakDI28ZASf1UT4rTuzrRSNEvEu1Wnb8gCn+ohK+d7w4HWWxwZtydYHm5aGlV7y0maRZOfi0RKm+WZP8is+kDfMBDX7wOZYR65XHgOpyP8nHJUmyYNYn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb1ZP4rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb1ZP4rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08147C4CEF0;
	Mon, 22 Sep 2025 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570417;
	bh=/Cjtc1tpJpffRQlXG+byk/p6b+Yov1cn/Molb5Y6KEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb1ZP4rnqQGiEu+hpS5mTf88JLTWmzXCcL8IncOuyZbINxkq4VWOTGp+ckRMKGK5C
	 nXzVIuxZ6QXRWt/69RhWa09yJhCWYDejMcTcIzulys/vvF2nu/B+IjJOdN71u1YKAK
	 ISLe7zc4sh17io62Fqz2MIHT2rPwWlYq1a6R9a1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 129/149] smb: client: make use of struct smbdirect_recv_io
Date: Mon, 22 Sep 2025 21:30:29 +0200
Message-ID: <20250922192416.127605508@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 5dddf0497445d247e995306daf3b76dd0633831c ]

This is the shared structure that will be used in
the server too and will allow us to move helper functions
into common code soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f57e53ea2523 ("smb: client: let recv_done verify data_offset, data_length and remaining_data_length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 79 ++++++++++++++++++++-------------------
 fs/smb/client/smbdirect.h | 16 --------
 2 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a6aa2c609dc3b..18702c67c8484 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -13,23 +13,23 @@
 #include "cifsproto.h"
 #include "smb2proto.h"
 
-static struct smbd_response *get_receive_buffer(
+static struct smbdirect_recv_io *get_receive_buffer(
 		struct smbd_connection *info);
 static void put_receive_buffer(
 		struct smbd_connection *info,
-		struct smbd_response *response);
+		struct smbdirect_recv_io *response);
 static int allocate_receive_buffers(struct smbd_connection *info, int num_buf);
 static void destroy_receive_buffers(struct smbd_connection *info);
 
 static void enqueue_reassembly(
 		struct smbd_connection *info,
-		struct smbd_response *response, int data_length);
-static struct smbd_response *_get_first_reassembly(
+		struct smbdirect_recv_io *response, int data_length);
+static struct smbdirect_recv_io *_get_first_reassembly(
 		struct smbd_connection *info);
 
 static int smbd_post_recv(
 		struct smbd_connection *info,
-		struct smbd_response *response);
+		struct smbdirect_recv_io *response);
 
 static int smbd_post_send_empty(struct smbd_connection *info);
 
@@ -260,7 +260,7 @@ static inline void *smbd_request_payload(struct smbd_request *request)
 	return (void *)request->packet;
 }
 
-static inline void *smbd_response_payload(struct smbd_response *response)
+static inline void *smbdirect_recv_io_payload(struct smbdirect_recv_io *response)
 {
 	return (void *)response->packet;
 }
@@ -315,12 +315,13 @@ static void dump_smbdirect_negotiate_resp(struct smbdirect_negotiate_resp *resp)
  * return value: true if negotiation is a success, false if failed
  */
 static bool process_negotiation_response(
-		struct smbd_response *response, int packet_length)
+		struct smbdirect_recv_io *response, int packet_length)
 {
-	struct smbd_connection *info = response->info;
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = response->socket;
+	struct smbd_connection *info =
+		container_of(sc, struct smbd_connection, socket);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_negotiate_resp *packet = smbd_response_payload(response);
+	struct smbdirect_negotiate_resp *packet = smbdirect_recv_io_payload(response);
 
 	if (packet_length < sizeof(struct smbdirect_negotiate_resp)) {
 		log_rdma_event(ERR,
@@ -391,7 +392,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 {
 	int ret = 0;
 	int rc;
-	struct smbd_response *response;
+	struct smbdirect_recv_io *response;
 	struct smbd_connection *info =
 		container_of(work, struct smbd_connection,
 			post_send_credits_work);
@@ -442,10 +443,11 @@ static void smbd_post_send_credits(struct work_struct *work)
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct smbdirect_data_transfer *data_transfer;
-	struct smbd_response *response =
-		container_of(wc->wr_cqe, struct smbd_response, cqe);
-	struct smbd_connection *info = response->info;
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_recv_io *response =
+		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
+	struct smbdirect_socket *sc = response->socket;
+	struct smbd_connection *info =
+		container_of(sc, struct smbd_connection, socket);
 	int data_length = 0;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
@@ -467,7 +469,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	switch (sc->recv_io.expected) {
 	/* SMBD negotiation response */
 	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
-		dump_smbdirect_negotiate_resp(smbd_response_payload(response));
+		dump_smbdirect_negotiate_resp(smbdirect_recv_io_payload(response));
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
@@ -477,7 +479,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	/* SMBD data transfer packet */
 	case SMBDIRECT_EXPECT_DATA_TRANSFER:
-		data_transfer = smbd_response_payload(response);
+		data_transfer = smbdirect_recv_io_payload(response);
 		data_length = le32_to_cpu(data_transfer->data_length);
 
 		if (data_length) {
@@ -1034,7 +1036,7 @@ static int smbd_post_send_full_iter(struct smbd_connection *info,
  * The interaction is controlled by send/receive credit system
  */
 static int smbd_post_recv(
-		struct smbd_connection *info, struct smbd_response *response)
+		struct smbd_connection *info, struct smbdirect_recv_io *response)
 {
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -1074,7 +1076,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 {
 	struct smbdirect_socket *sc = &info->socket;
 	int rc;
-	struct smbd_response *response = get_receive_buffer(info);
+	struct smbdirect_recv_io *response = get_receive_buffer(info);
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
 	rc = smbd_post_recv(info, response);
@@ -1119,7 +1121,7 @@ static int smbd_negotiate(struct smbd_connection *info)
  */
 static void enqueue_reassembly(
 	struct smbd_connection *info,
-	struct smbd_response *response,
+	struct smbdirect_recv_io *response,
 	int data_length)
 {
 	spin_lock(&info->reassembly_queue_lock);
@@ -1143,14 +1145,14 @@ static void enqueue_reassembly(
  * Caller is responsible for locking
  * return value: the first entry if any, NULL if queue is empty
  */
-static struct smbd_response *_get_first_reassembly(struct smbd_connection *info)
+static struct smbdirect_recv_io *_get_first_reassembly(struct smbd_connection *info)
 {
-	struct smbd_response *ret = NULL;
+	struct smbdirect_recv_io *ret = NULL;
 
 	if (!list_empty(&info->reassembly_queue)) {
 		ret = list_first_entry(
 			&info->reassembly_queue,
-			struct smbd_response, list);
+			struct smbdirect_recv_io, list);
 	}
 	return ret;
 }
@@ -1161,16 +1163,16 @@ static struct smbd_response *_get_first_reassembly(struct smbd_connection *info)
  * pre-allocated in advance.
  * return value: the receive buffer, NULL if none is available
  */
-static struct smbd_response *get_receive_buffer(struct smbd_connection *info)
+static struct smbdirect_recv_io *get_receive_buffer(struct smbd_connection *info)
 {
-	struct smbd_response *ret = NULL;
+	struct smbdirect_recv_io *ret = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->receive_queue_lock, flags);
 	if (!list_empty(&info->receive_queue)) {
 		ret = list_first_entry(
 			&info->receive_queue,
-			struct smbd_response, list);
+			struct smbdirect_recv_io, list);
 		list_del(&ret->list);
 		info->count_receive_queue--;
 		info->count_get_receive_buffer++;
@@ -1187,7 +1189,7 @@ static struct smbd_response *get_receive_buffer(struct smbd_connection *info)
  * receive buffer is returned.
  */
 static void put_receive_buffer(
-	struct smbd_connection *info, struct smbd_response *response)
+	struct smbd_connection *info, struct smbdirect_recv_io *response)
 {
 	struct smbdirect_socket *sc = &info->socket;
 	unsigned long flags;
@@ -1212,8 +1214,9 @@ static void put_receive_buffer(
 /* Preallocate all receive buffer on transport establishment */
 static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 {
+	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_recv_io *response;
 	int i;
-	struct smbd_response *response;
 
 	INIT_LIST_HEAD(&info->reassembly_queue);
 	spin_lock_init(&info->reassembly_queue_lock);
@@ -1231,7 +1234,7 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 		if (!response)
 			goto allocate_failed;
 
-		response->info = info;
+		response->socket = sc;
 		response->sge.length = 0;
 		list_add_tail(&response->list, &info->receive_queue);
 		info->count_receive_queue++;
@@ -1243,7 +1246,7 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 	while (!list_empty(&info->receive_queue)) {
 		response = list_first_entry(
 				&info->receive_queue,
-				struct smbd_response, list);
+				struct smbdirect_recv_io, list);
 		list_del(&response->list);
 		info->count_receive_queue--;
 
@@ -1254,7 +1257,7 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 
 static void destroy_receive_buffers(struct smbd_connection *info)
 {
-	struct smbd_response *response;
+	struct smbdirect_recv_io *response;
 
 	while ((response = get_receive_buffer(info)))
 		mempool_free(response, info->response_mempool);
@@ -1295,7 +1298,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc;
 	struct smbdirect_socket_parameters *sp;
-	struct smbd_response *response;
+	struct smbdirect_recv_io *response;
 	unsigned long flags;
 
 	if (!info) {
@@ -1452,17 +1455,17 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (!info->request_mempool)
 		goto out1;
 
-	scnprintf(name, MAX_NAME_LEN, "smbd_response_%p", info);
+	scnprintf(name, MAX_NAME_LEN, "smbdirect_recv_io_%p", info);
 
 	struct kmem_cache_args response_args = {
-		.align		= __alignof__(struct smbd_response),
-		.useroffset	= (offsetof(struct smbd_response, packet) +
+		.align		= __alignof__(struct smbdirect_recv_io),
+		.useroffset	= (offsetof(struct smbdirect_recv_io, packet) +
 				   sizeof(struct smbdirect_data_transfer)),
 		.usersize	= sp->max_recv_size - sizeof(struct smbdirect_data_transfer),
 	};
 	info->response_cache =
 		kmem_cache_create(name,
-				  sizeof(struct smbd_response) + sp->max_recv_size,
+				  sizeof(struct smbdirect_recv_io) + sp->max_recv_size,
 				  &response_args, SLAB_HWCACHE_ALIGN);
 	if (!info->response_cache)
 		goto out2;
@@ -1753,7 +1756,7 @@ struct smbd_connection *smbd_get_connection(
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	struct smbdirect_socket *sc = &info->socket;
-	struct smbd_response *response;
+	struct smbdirect_recv_io *response;
 	struct smbdirect_data_transfer *data_transfer;
 	size_t size = iov_iter_count(&msg->msg_iter);
 	int to_copy, to_read, data_read, offset;
@@ -1789,7 +1792,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		offset = info->first_entry_offset;
 		while (data_read < size) {
 			response = _get_first_reassembly(info);
-			data_transfer = smbd_response_payload(response);
+			data_transfer = smbdirect_recv_io_payload(response);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
 				le32_to_cpu(
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index bf50544eaf02d..d60e445da2256 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -176,22 +176,6 @@ struct smbd_request {
 /* Maximum number of SGEs used by smbdirect.c in any receive work request */
 #define SMBDIRECT_MAX_RECV_SGE	1
 
-/* The context for a SMBD response */
-struct smbd_response {
-	struct smbd_connection *info;
-	struct ib_cqe cqe;
-	struct ib_sge sge;
-
-	/* Link to receive queue or reassembly queue */
-	struct list_head list;
-
-	/* Indicate if this is the 1st packet of a payload */
-	bool first_segment;
-
-	/* SMBD packet header and payload follows this structure */
-	u8 packet[];
-};
-
 /* Create a SMBDirect session */
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
-- 
2.51.0



