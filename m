Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5593234
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448144; cv=none; b=QLT2S/ITD+6/fVxhkgrT0FActgNcrPCuhm4mT0KIeamaxYTrEuv9G+AZF3ZGk0LnNynj3OvRlpOwo+Y4xq+TcWkcRovoSOFpvjje4J6ZtRsuv8Ju196bhpt+9uCnK3EtX4iFp89mda+k50ZoR9SJ7KTAYIsVTBnN6Y7fADTNrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448144; c=relaxed/simple;
	bh=GMWGScGzGKH/ui/jz/+Lv82eCqKONgqWJ2/swXPzyhE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ihU6njzVbp66PvG9h8M7wU3hyXLTXait7lc2lkPAC17f8WjO7ySvPqE6VY/NLXJKHrZmiLVGfvgDPuXqtIRCzvu6wa8bhQq7rcEIy+6clxsQYgZRB3j073dVejzpkoyZoyRCy5nYAZdqKVGjLQRfJq37ogxnmJGa0nGG6HtxBKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UxIbdHZF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UxIbdHZF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=O01SWwVuSMP+0nns8JXSUueJocw8KmVt+OZNrfzjOI4=; b=UxIbdHZF1GbNjWJkkW0LKzZqcq
	kY4Viwdul526PL7Bk8S6j98fg2IfZH6c8M/NybLI5TP65ONrXn/0GO8iRn1BgE68qhCC68uSutARW
	xe/Zxmk4KBlf/lCIZ3ugNMiGwCo4VUg5kZvLDHAsa/Lii4gfNz2LxWw00Siy0Ov4zmxGWjgcjy2jQ
	Cqr5fMjWXEdHOqeDNswuxGEGAuHkXL+46c/NvYwqxtKviuRyqZ7hJ5amXtYB6AdJqsMI7uLQDqPVv
	BPC07R1KqE+utPV2+33ym2Ffyu6raNMRg49pbZ4ZO3bYX/ldIrQxK9XwiLYBmkT2hTSxkq+ERriQj
	CaU0fL+tD++5rnJ79FKGRdVNssWGfmv6FuT5S4j/HM0dmbq/MSAIxrfA3ELtrlm8VHPx0owSlJqlM
	QrwhAbGFjXTA8vHz+XmcoV9YAh0YVsX5eIRdU4O2fFn5aDM08V8NvQpXxCObNOh8QQBYjxiVxWmzT
	zawFpZ3g7s0HHys1at7QBlVG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJER-007hHt-1T;
	Wed, 28 May 2025 16:02:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 03/12] smb: server: make use of common smbdirect_pdu.h
Date: Wed, 28 May 2025 18:01:32 +0200
Message-Id: <f6395f1ed2d5ffdb15c5de84a4fda2709118d519.1748446473.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1748446473.git.metze@samba.org>
References: <cover.1748446473.git.metze@samba.org>
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
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 49 +++++++++++++++++-----------------
 fs/smb/server/transport_rdma.h | 41 ----------------------------
 2 files changed, 25 insertions(+), 65 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4998df04ab95..55fda2585583 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -23,12 +23,13 @@
 #include "connection.h"
 #include "smb_common.h"
 #include "../common/smb2status.h"
+#include "../common/smbdirect/smbdirect_pdu.h"
 #include "transport_rdma.h"
 
 #define SMB_DIRECT_PORT_IWARP		5445
 #define SMB_DIRECT_PORT_INFINIBAND	445
 
-#define SMB_DIRECT_VERSION_LE		cpu_to_le16(0x0100)
+#define SMB_DIRECT_VERSION_LE		cpu_to_le16(SMBDIRECT_V1)
 
 /* SMB_DIRECT negotiation timeout in seconds */
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
@@ -493,8 +494,8 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
 {
 	switch (recvmsg->type) {
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
-		struct smb_direct_data_transfer *req =
-			(struct smb_direct_data_transfer *)recvmsg->packet;
+		struct smbdirect_data_transfer *req =
+			(struct smbdirect_data_transfer *)recvmsg->packet;
 		struct smb2_hdr *hdr = (struct smb2_hdr *)(recvmsg->packet
 				+ le32_to_cpu(req->data_offset));
 		ksmbd_debug(RDMA,
@@ -506,8 +507,8 @@ static int smb_direct_check_recvmsg(struct smb_direct_recvmsg *recvmsg)
 		break;
 	}
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ: {
-		struct smb_direct_negotiate_req *req =
-			(struct smb_direct_negotiate_req *)recvmsg->packet;
+		struct smbdirect_negotiate_req *req =
+			(struct smbdirect_negotiate_req *)recvmsg->packet;
 		ksmbd_debug(RDMA,
 			    "MinVersion: %u, MaxVersion: %u, CreditRequested: %u, MaxSendSize: %u, MaxRecvSize: %u, MaxFragmentedSize: %u\n",
 			    le16_to_cpu(req->min_version),
@@ -561,7 +562,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	switch (recvmsg->type) {
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
-		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
+		if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
 			put_empty_recvmsg(t, recvmsg);
 			return;
 		}
@@ -572,20 +573,20 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		wake_up_interruptible(&t->wait_status);
 		break;
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
-		struct smb_direct_data_transfer *data_transfer =
-			(struct smb_direct_data_transfer *)recvmsg->packet;
+		struct smbdirect_data_transfer *data_transfer =
+			(struct smbdirect_data_transfer *)recvmsg->packet;
 		unsigned int data_length;
 		int avail_recvmsg_count, receive_credits;
 
 		if (wc->byte_len <
-		    offsetof(struct smb_direct_data_transfer, padding)) {
+		    offsetof(struct smbdirect_data_transfer, padding)) {
 			put_empty_recvmsg(t, recvmsg);
 			return;
 		}
 
 		data_length = le32_to_cpu(data_transfer->data_length);
 		if (data_length) {
-			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
+			if (wc->byte_len < sizeof(struct smbdirect_data_transfer) +
 			    (u64)data_length) {
 				put_empty_recvmsg(t, recvmsg);
 				return;
@@ -621,7 +622,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			   &t->send_credits);
 
 		if (le16_to_cpu(data_transfer->flags) &
-		    SMB_DIRECT_RESPONSE_REQUESTED)
+		    SMBDIRECT_FLAG_RESPONSE_REQUESTED)
 			queue_work(smb_direct_wq, &t->send_immediate_work);
 
 		if (atomic_read(&t->send_credits) > 0)
@@ -674,7 +675,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 			   unsigned int size, int unused)
 {
 	struct smb_direct_recvmsg *recvmsg;
-	struct smb_direct_data_transfer *data_transfer;
+	struct smbdirect_data_transfer *data_transfer;
 	int to_copy, to_read, data_read, offset;
 	u32 data_length, remaining_data_length, data_offset;
 	int rc;
@@ -1021,7 +1022,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 				    struct smb_direct_sendmsg **sendmsg_out)
 {
 	struct smb_direct_sendmsg *sendmsg;
-	struct smb_direct_data_transfer *packet;
+	struct smbdirect_data_transfer *packet;
 	int header_length;
 	int ret;
 
@@ -1030,7 +1031,7 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 		return PTR_ERR(sendmsg);
 
 	/* Fill in the packet header */
-	packet = (struct smb_direct_data_transfer *)sendmsg->packet;
+	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(t->send_credit_target);
 	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(t));
 
@@ -1053,11 +1054,11 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 		    le32_to_cpu(packet->remaining_data_length));
 
 	/* Map the packet to DMA */
-	header_length = sizeof(struct smb_direct_data_transfer);
+	header_length = sizeof(struct smbdirect_data_transfer);
 	/* If this is a packet without payload, don't send padding */
 	if (!size)
 		header_length =
-			offsetof(struct smb_direct_data_transfer, padding);
+			offsetof(struct smbdirect_data_transfer, padding);
 
 	sendmsg->sge[0].addr = ib_dma_map_single(t->cm_id->device,
 						 (void *)packet,
@@ -1232,7 +1233,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	int remaining_data_length;
 	int start, i, j;
 	int max_iov_size = st->max_send_size -
-			sizeof(struct smb_direct_data_transfer);
+			sizeof(struct smbdirect_data_transfer);
 	int ret;
 	struct kvec vec;
 	struct smb_direct_send_ctx send_ctx;
@@ -1580,18 +1581,18 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 					      int failed)
 {
 	struct smb_direct_sendmsg *sendmsg;
-	struct smb_direct_negotiate_resp *resp;
+	struct smbdirect_negotiate_resp *resp;
 	int ret;
 
 	sendmsg = smb_direct_alloc_sendmsg(t);
 	if (IS_ERR(sendmsg))
 		return -ENOMEM;
 
-	resp = (struct smb_direct_negotiate_resp *)sendmsg->packet;
+	resp = (struct smbdirect_negotiate_resp *)sendmsg->packet;
 	if (failed) {
 		memset(resp, 0, sizeof(*resp));
-		resp->min_version = cpu_to_le16(0x0100);
-		resp->max_version = cpu_to_le16(0x0100);
+		resp->min_version = SMB_DIRECT_VERSION_LE;
+		resp->max_version = SMB_DIRECT_VERSION_LE;
 		resp->status = STATUS_NOT_SUPPORTED;
 	} else {
 		resp->status = STATUS_SUCCESS;
@@ -1825,7 +1826,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 	snprintf(name, sizeof(name), "smb_direct_rqst_pool_%p", t);
 	t->sendmsg_cache = kmem_cache_create(name,
 					     sizeof(struct smb_direct_sendmsg) +
-					      sizeof(struct smb_direct_negotiate_resp),
+					      sizeof(struct smbdirect_negotiate_resp),
 					     0, SLAB_HWCACHE_ALIGN, NULL);
 	if (!t->sendmsg_cache)
 		return -ENOMEM;
@@ -1957,7 +1958,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
 	struct smb_direct_recvmsg *recvmsg;
-	struct smb_direct_negotiate_req *req;
+	struct smbdirect_negotiate_req *req;
 	int ret;
 
 	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
@@ -1976,7 +1977,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	if (ret == -ECONNABORTED)
 		goto out;
 
-	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
+	req = (struct smbdirect_negotiate_req *)recvmsg->packet;
 	st->max_recv_size = min_t(int, st->max_recv_size,
 				  le32_to_cpu(req->preferred_send_size));
 	st->max_send_size = min_t(int, st->max_send_size,
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 77aee4e5c9dc..0fb692c40e21 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -11,47 +11,6 @@
 #define SMBD_MIN_IOSIZE (512 * 1024)
 #define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
 
-/* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
-struct smb_direct_negotiate_req {
-	__le16 min_version;
-	__le16 max_version;
-	__le16 reserved;
-	__le16 credits_requested;
-	__le32 preferred_send_size;
-	__le32 max_receive_size;
-	__le32 max_fragmented_size;
-} __packed;
-
-/* SMB DIRECT negotiation response packet [MS-SMBD] 2.2.2 */
-struct smb_direct_negotiate_resp {
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
-#define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
-
-/* SMB DIRECT data transfer packet with payload [MS-SMBD] 2.2.3 */
-struct smb_direct_data_transfer {
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
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
-- 
2.34.1

