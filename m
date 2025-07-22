Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A62EA75A;
	Tue, 22 Jul 2025 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193754; cv=none; b=jNfCgPWyfpLQi6+CvDrhAo9V3JzoXP1lGKlxFO65YEdav62nbwMIXFI2m9j9WWswePM5cAkHH60PEXOv7AqpjFs9YScR3D5Uj/1GFBLmQY9g4a9bEiCYA58dYzfglv9asAE1zCIjafp4ZcFloc5CQccIelzLOst3RyT/nraY7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193754; c=relaxed/simple;
	bh=1nNnm3KFpPtUYdHu1C/MtcJC/WaXveE1ta4fvUVn6j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIMsMb+j2Dx9bx9WwiK4xjhjbDf9hSXbreXtlBDw3MqYb2nwHDT1SArVuEnW16BJOlnqsA2JjV8LNQMyX0LeHmNO2hR7xPt7GD0G6nwXCHT1MMYVwwzGvMPNwQOj2LzVIvOmmyQpyZDEoIlmGtUkB8zcSQv3vfY9bIpU1NY6fIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rO+UK7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rO+UK7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3A8C4CEEB;
	Tue, 22 Jul 2025 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193754;
	bh=1nNnm3KFpPtUYdHu1C/MtcJC/WaXveE1ta4fvUVn6j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rO+UK7hRL0YkNpgRBM/g0kIZxM14+HCDtnGD9CMpVdX1kpy4gK0gpVsT0X/labEN
	 rcDJaaF44sDlrijSc67EHpUWB3XXvXe+jL8Yeet1+KU34hNng9M2SeMnKD6Qu2zMUY
	 LbQ9J9QndDFe6Kekng8WEA1bm0LfNmOZfnbUv0+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 175/187] smb: client: make use of common smbdirect_pdu.h
Date: Tue, 22 Jul 2025 15:45:45 +0200
Message-ID: <20250722134352.290231507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 64946d5be665ddac6b5bf11f5b5ff319aae0f4c6 upstream.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   40 +++++++++++++++++++---------------------
 fs/smb/client/smbdirect.h |   41 -----------------------------------------
 2 files changed, 19 insertions(+), 62 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
+#include "../common/smbdirect/smbdirect_pdu.h"
 #include "smbdirect.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
@@ -50,9 +51,6 @@ struct smb_extract_to_rdma {
 static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
 					struct smb_extract_to_rdma *rdma);
 
-/* SMBD version number */
-#define SMBD_V1	0x0100
-
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
 #define SMBD_PORT	5445
@@ -299,7 +297,7 @@ static void send_done(struct ib_cq *cq,
 	mempool_free(request, request->info->request_mempool);
 }
 
-static void dump_smbd_negotiate_resp(struct smbd_negotiate_resp *resp)
+static void dump_smbdirect_negotiate_resp(struct smbdirect_negotiate_resp *resp)
 {
 	log_rdma_event(INFO, "resp message min_version %u max_version %u negotiated_version %u credits_requested %u credits_granted %u status %u max_readwrite_size %u preferred_send_size %u max_receive_size %u max_fragmented_size %u\n",
 		       resp->min_version, resp->max_version,
@@ -318,15 +316,15 @@ static bool process_negotiation_response
 		struct smbd_response *response, int packet_length)
 {
 	struct smbd_connection *info = response->info;
-	struct smbd_negotiate_resp *packet = smbd_response_payload(response);
+	struct smbdirect_negotiate_resp *packet = smbd_response_payload(response);
 
-	if (packet_length < sizeof(struct smbd_negotiate_resp)) {
+	if (packet_length < sizeof(struct smbdirect_negotiate_resp)) {
 		log_rdma_event(ERR,
 			"error: packet_length=%d\n", packet_length);
 		return false;
 	}
 
-	if (le16_to_cpu(packet->negotiated_version) != SMBD_V1) {
+	if (le16_to_cpu(packet->negotiated_version) != SMBDIRECT_V1) {
 		log_rdma_event(ERR, "error: negotiated_version=%x\n",
 			le16_to_cpu(packet->negotiated_version));
 		return false;
@@ -448,7 +446,7 @@ static void smbd_post_send_credits(struc
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct smbd_data_transfer *data_transfer;
+	struct smbdirect_data_transfer *data_transfer;
 	struct smbd_response *response =
 		container_of(wc->wr_cqe, struct smbd_response, cqe);
 	struct smbd_connection *info = response->info;
@@ -474,7 +472,7 @@ static void recv_done(struct ib_cq *cq,
 	switch (response->type) {
 	/* SMBD negotiation response */
 	case SMBD_NEGOTIATE_RESP:
-		dump_smbd_negotiate_resp(smbd_response_payload(response));
+		dump_smbdirect_negotiate_resp(smbd_response_payload(response));
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
@@ -531,7 +529,7 @@ static void recv_done(struct ib_cq *cq,
 		/* Send a KEEP_ALIVE response right away if requested */
 		info->keep_alive_requested = KEEP_ALIVE_NONE;
 		if (le16_to_cpu(data_transfer->flags) &
-				SMB_DIRECT_RESPONSE_REQUESTED) {
+				SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
@@ -686,7 +684,7 @@ static int smbd_post_send_negotiate_req(
 	struct ib_send_wr send_wr;
 	int rc = -ENOMEM;
 	struct smbd_request *request;
-	struct smbd_negotiate_req *packet;
+	struct smbdirect_negotiate_req *packet;
 
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request)
@@ -695,8 +693,8 @@ static int smbd_post_send_negotiate_req(
 	request->info = info;
 
 	packet = smbd_request_payload(request);
-	packet->min_version = cpu_to_le16(SMBD_V1);
-	packet->max_version = cpu_to_le16(SMBD_V1);
+	packet->min_version = cpu_to_le16(SMBDIRECT_V1);
+	packet->max_version = cpu_to_le16(SMBDIRECT_V1);
 	packet->reserved = 0;
 	packet->credits_requested = cpu_to_le16(info->send_credit_target);
 	packet->preferred_send_size = cpu_to_le32(info->max_send_size);
@@ -774,10 +772,10 @@ static int manage_credits_prior_sending(
 /*
  * Check if we need to send a KEEP_ALIVE message
  * The idle connection timer triggers a KEEP_ALIVE message when expires
- * SMB_DIRECT_RESPONSE_REQUESTED is set in the message flag to have peer send
+ * SMBDIRECT_FLAG_RESPONSE_REQUESTED is set in the message flag to have peer send
  * back a response.
  * return value:
- * 1 if SMB_DIRECT_RESPONSE_REQUESTED needs to be set
+ * 1 if SMBDIRECT_FLAG_RESPONSE_REQUESTED needs to be set
  * 0: otherwise
  */
 static int manage_keep_alive_before_sending(struct smbd_connection *info)
@@ -837,7 +835,7 @@ static int smbd_post_send_iter(struct sm
 	int header_length;
 	int data_length;
 	struct smbd_request *request;
-	struct smbd_data_transfer *packet;
+	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
 
 wait_credit:
@@ -919,7 +917,7 @@ wait_send_queue:
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(info))
-		packet->flags |= cpu_to_le16(SMB_DIRECT_RESPONSE_REQUESTED);
+		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
 	if (!data_length)
@@ -938,10 +936,10 @@ wait_send_queue:
 		     le32_to_cpu(packet->remaining_data_length));
 
 	/* Map the packet to DMA */
-	header_length = sizeof(struct smbd_data_transfer);
+	header_length = sizeof(struct smbdirect_data_transfer);
 	/* If this is a packet without payload, don't send padding */
 	if (!data_length)
-		header_length = offsetof(struct smbd_data_transfer, padding);
+		header_length = offsetof(struct smbdirect_data_transfer, padding);
 
 	request->sge[0].addr = ib_dma_map_single(info->id->device,
 						 (void *)packet,
@@ -1432,7 +1430,7 @@ static int allocate_caches_and_workqueue
 		kmem_cache_create(
 			name,
 			sizeof(struct smbd_request) +
-				sizeof(struct smbd_data_transfer),
+				sizeof(struct smbdirect_data_transfer),
 			0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!info->request_cache)
 		return -ENOMEM;
@@ -1735,7 +1733,7 @@ static int smbd_recv_buf(struct smbd_con
 		unsigned int size)
 {
 	struct smbd_response *response;
-	struct smbd_data_transfer *data_transfer;
+	struct smbdirect_data_transfer *data_transfer;
 	int to_copy, to_read, data_read, offset;
 	u32 data_length, remaining_data_length, data_offset;
 	int rc;
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -177,47 +177,6 @@ enum smbd_message_type {
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


