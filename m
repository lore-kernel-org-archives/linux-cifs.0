Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCAA1C8603
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410361; cv=none; b=OemOg+7jfZZMORxf78retDdU1Cx2aD8A4WHvxF1tciWwzpw6DYEwqDP+gw9louTpPZvGyLwUWvImu2WH4S7ToNlhosNzxGu7+g+rEfWR9Aaru4VK14brezEidyuriBFp/tJv9KDeM56MHxD4KEi+31Kg4QXUXV507ThIx0+IpCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410361; c=relaxed/simple;
	bh=fxQJIQ1B+CREBHGJd6BJdfFevJZzxzKkpw3qj/XlvH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psRrRfCnzlns2xh6m1bCKPN/Z0B21D4zi9Yh3mT19rKe2CMrQIv50XWoEwUgvX/Iqzue7WOohcuyM6ux6mvn72HREdMNMm2u2b3LgllNu65SugniX/+qlR2HUUHc54MO4GRdLXyiZAh7W68QBvJvZpJLonZeRnV/rucnX07mjyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z4wWKE3z; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z4wWKE3z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HcvTXoQ/7jT1iu4p1y9ert6mGqxk394+fF3cwFnruhk=; b=Z4wWKE3zkJe0SpZ9wIrBjfZ6D1
	eyILb99J3aQZ8ekm6G2USOCM9z/X0sUAglgCmQI6jK6smrhRQ5JhugXe7ERF4JBjhx1oI1TkMLmJy
	VDUBIhK/G0y8JbcuVm7A54AuMX2uK3ssKEG837lSVKwJRItRdVJnjeRHFGknwB0Kr7556PzuvL+gg
	i4VHY7WZjRJnYmDZr6fFF3GQ23zZoyv8ewbHx+54SyX5tFBuN8Q9mSMTkBmQ1Z6qGdAiND7FjIKW4
	FyaRBvnhVIXB/q2jibdTgTq0FsbbfCdMh5TR3aieqAPRudRE7MyU4TSREmu1x3j50v1lMDgpl2vBq
	lMHv9qat3BbVQ10ZufGICSWJnxpfqjoHMz/aHrURNW0j1djW3K5yqHe3ISYITWFFLtjsks5DuozbC
	Zr4qBzL1VyJbJesE+ZpvOTC03i0ivSw+iK/x5KDpdTX+QigqTyNj/UBFZ6ivgaKgWH/Vcd8S5X68n
	BQaa/5rJjb3blF1RdDCje3ZC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKHA-0019eZ-1Z;
	Tue, 05 Aug 2025 16:12:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 05/17] smb: client: make use of struct smbdirect_recv_io
Date: Tue,  5 Aug 2025 18:11:33 +0200
Message-ID: <d5ca0a54848a93bd99f0dd83801bd01a6ea9973f.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the shared structure that will be used in
the server too and will allow us to move helper functions
into common code soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 79 ++++++++++++++++++++-------------------
 fs/smb/client/smbdirect.h | 16 --------
 2 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index db3ca03ac90d..0acd576863a6 100644
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
@@ -1456,17 +1459,17 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
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
@@ -1756,7 +1759,7 @@ struct smbd_connection *smbd_get_connection(
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	struct smbdirect_socket *sc = &info->socket;
-	struct smbd_response *response;
+	struct smbdirect_recv_io *response;
 	struct smbdirect_data_transfer *data_transfer;
 	size_t size = iov_iter_count(&msg->msg_iter);
 	int to_copy, to_read, data_read, offset;
@@ -1792,7 +1795,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		offset = info->first_entry_offset;
 		while (data_read < size) {
 			response = _get_first_reassembly(info);
-			data_transfer = smbd_response_payload(response);
+			data_transfer = smbdirect_recv_io_payload(response);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
 				le32_to_cpu(
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index dbb138900973..f53781f98e64 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -175,22 +175,6 @@ struct smbd_request {
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
2.43.0

