Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86CE27F756
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362449; cv=none; b=WUu4EcZKIEZ19oQpM7+G4M3pXV5tRfeq7B2Q7RZV2eUbaih88AZpAFG9siY9sJPz2KQCkT3Sf4oqEZY0R1iEF3U/qcGNTjuei7DwS+Y5azgyufKEXuEdZq8y6NOcIPJHJERc1ViaUk2zM2e0LLJyc/oh+RCm74gIkTovzI0oStU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362449; c=relaxed/simple;
	bh=bo80Ja+o0l/98yCJ1kz8ky8eoTQfzYd8ycJn8d9kVpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=URxV73Bjex+8l5zcPA1NC+8mgl+4Hkfzz8/w29nQAXLfU5tK7qlkucOtTAaFctyhDlkf7J2wj6NDMLP1r3WVrpH8Y+ttDMEC3CVoTPeUhXHq7Ir3brLl5Whf9BC3pwiJxsQLYwXQS66s3TLrKIlZLH6GvAAHAknoCuxIghIxpiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BDDe2QTq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BDDe2QTq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=w/NVHqcrzUAG2B/brguXK3B4iUlzuDL9fzQbj7/gWPQ=; b=BDDe2QTqZyyKBkwFQMUypOicl8
	pNU+zlesejKaourFLsDzf7OzhG4F+gqwy6/tkmUJKoABF6w0R2SMNH1AMGdE20hxdSgnhRBu940g/
	OchKNDOds+nJhc0awI80gxf+P2UtPXHnVDoGUfMcy22TjodcMejkygUYxomREZ3bHUnGuRm+00loV
	Y0WbEEeTMRHjL3I0KIgYokYbIR7NWxEirqtDbOQ+T/tpzziqTA/oy1alGKOUmM1pMfmPdDD3A7qxv
	6NOYAVbI9RlTkiIn74BnhcSL10KivVeexbluodPnRqEvIJ+lKz+ecTfh/TtuCbeIUVGSpl0a5Ar3H
	Ltzouc+MOHMoX0zmaoj4M8uLqM65pKXf/d7Zl2rzrrP62os4qcDrpvaDQnWPKNhpLdZ9+D7TvljgB
	c7QNTJ890Xpc6dfhEx72lzIzqKzoQbXLjpKXLgQ6ZkaPagsZvzz7aefABjQjjGuKAbEl9DXNQDOsQ
	7UkIqZ3PguJJ89bLDh6ZeYr/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJwwG-007Vkj-2x;
	Tue, 27 May 2025 16:14:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH 2/5] smb: client: make use of common smb_direct headers
Date: Tue, 27 May 2025 18:12:59 +0200
Message-Id: <bb4d9fc0edd73878022c30f9d84e7488fcc1844c.1748362221.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748362221.git.metze@samba.org>
References: <cover.1748362221.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 22 ++++++++++----------
 fs/smb/client/smbdirect.h | 43 ++-------------------------------------
 2 files changed, 13 insertions(+), 52 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b0b7254661e9..ec307faa94d2 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -299,7 +299,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	mempool_free(request, request->info->request_mempool);
 }
 
-static void dump_smbd_negotiate_resp(struct smbd_negotiate_resp *resp)
+static void dump_smb_direct_negotiate_resp(struct smb_direct_negotiate_resp *resp)
 {
 	log_rdma_event(INFO, "resp message min_version %u max_version %u negotiated_version %u credits_requested %u credits_granted %u status %u max_readwrite_size %u preferred_send_size %u max_receive_size %u max_fragmented_size %u\n",
 		       resp->min_version, resp->max_version,
@@ -318,9 +318,9 @@ static bool process_negotiation_response(
 		struct smbd_response *response, int packet_length)
 {
 	struct smbd_connection *info = response->info;
-	struct smbd_negotiate_resp *packet = smbd_response_payload(response);
+	struct smb_direct_negotiate_resp *packet = smbd_response_payload(response);
 
-	if (packet_length < sizeof(struct smbd_negotiate_resp)) {
+	if (packet_length < sizeof(struct smb_direct_negotiate_resp)) {
 		log_rdma_event(ERR,
 			"error: packet_length=%d\n", packet_length);
 		return false;
@@ -448,7 +448,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct smbd_data_transfer *data_transfer;
+	struct smb_direct_data_transfer *data_transfer;
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
@@ -474,7 +474,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	switch (response->type) {
 	/* SMBD negotiation response */
 	case SMBD_NEGOTIATE_RESP:
-		dump_smbd_negotiate_resp(smbd_response_payload(response));
+		dump_smb_direct_negotiate_resp(smbd_response_payload(response));
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
@@ -686,7 +686,7 @@ static int smbd_post_send_negotiate_req(struct smbd_connection *info)
 	struct ib_send_wr send_wr;
 	int rc = -ENOMEM;
 	struct smbd_request *request;
-	struct smbd_negotiate_req *packet;
+	struct smb_direct_negotiate_req *packet;
 
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request)
@@ -837,7 +837,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	int header_length;
 	int data_length;
 	struct smbd_request *request;
-	struct smbd_data_transfer *packet;
+	struct smb_direct_data_transfer *packet;
 	int new_credits = 0;
 
 wait_credit:
@@ -938,10 +938,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 		     le32_to_cpu(packet->remaining_data_length));
 
 	/* Map the packet to DMA */
-	header_length = sizeof(struct smbd_data_transfer);
+	header_length = sizeof(struct smb_direct_data_transfer);
 	/* If this is a packet without payload, don't send padding */
 	if (!data_length)
-		header_length = offsetof(struct smbd_data_transfer, padding);
+		header_length = offsetof(struct smb_direct_data_transfer, padding);
 
 	request->sge[0].addr = ib_dma_map_single(info->id->device,
 						 (void *)packet,
@@ -1432,7 +1432,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 		kmem_cache_create(
 			name,
 			sizeof(struct smbd_request) +
-				sizeof(struct smbd_data_transfer),
+				sizeof(struct smb_direct_data_transfer),
 			0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!info->request_cache)
 		return -ENOMEM;
@@ -1735,7 +1735,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
 		unsigned int size)
 {
 	struct smbd_response *response;
-	struct smbd_data_transfer *data_transfer;
+	struct smb_direct_data_transfer *data_transfer;
 	int to_copy, to_read, data_read, offset;
 	u32 data_length, remaining_data_length, data_offset;
 	int rc;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index c08e3665150d..9c5b78a33311 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -15,6 +15,8 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+#include "../common/smb_direct/smb_direct.h"
+
 extern int rdma_readwrite_threshold;
 extern int smbd_max_frmr_depth;
 extern int smbd_keep_alive_interval;
@@ -177,47 +179,6 @@ enum smbd_message_type {
 	SMBD_TRANSFER_DATA,
 };
 
-#define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
-
-/* SMBD negotiation request packet [MS-SMBD] 2.2.1 */
-struct smbd_negotiate_req {
-	__le16 min_version;
-	__le16 max_version;
-	__le16 reserved;
-	__le16 credits_requested;
-	__le32 preferred_send_size;
-	__le32 max_receive_size;
-	__le32 max_fragmented_size;
-} __packed;
-
-/* SMBD negotiation response packet [MS-SMBD] 2.2.2 */
-struct smbd_negotiate_resp {
-	__le16 min_version;
-	__le16 max_version;
-	__le16 negotiated_version;
-	__le16 reserved;
-	__le16 credits_requested;
-	__le16 credits_granted;
-	__le32 status;
-	__le32 max_readwrite_size;
-	__le32 preferred_send_size;
-	__le32 max_receive_size;
-	__le32 max_fragmented_size;
-} __packed;
-
-/* SMBD data transfer packet with payload [MS-SMBD] 2.2.3 */
-struct smbd_data_transfer {
-	__le16 credits_requested;
-	__le16 credits_granted;
-	__le16 flags;
-	__le16 reserved;
-	__le32 remaining_data_length;
-	__le32 data_offset;
-	__le32 data_length;
-	__le32 padding;
-	__u8 buffer[];
-} __packed;
-
 /* The packet fields for a registered RDMA buffer */
 struct smbd_buffer_descriptor_v1 {
 	__le64 offset;
-- 
2.34.1

