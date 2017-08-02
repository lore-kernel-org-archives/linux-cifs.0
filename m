From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 24/37] [CIFS] SMBD: Support for SMBD keep alive protocol
Date: Wed,  2 Aug 2017 13:10:35 -0700
Message-ID: <1501704648-20159-25-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

SMBD uses a keep alive protocol to help peers detect if the remote is dead. When peer request keep alive, the transport needs to respond accordingly.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 30 ++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 4681cda..e275834 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -372,6 +372,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (atomic_read(&info->send_credits))
 			wake_up(&info->wait_send_queue);
 
+		// send an emtpy response right away if requested
+		if (le16_to_cpu(data_transfer->flags) |
+				le16_to_cpu(SMB_DIRECT_RESPONSE_REQUESTED)) {
+			info->keep_alive_requested = KEEP_ALIVE_PENDING;
+		}
+
 		// process receive queue
 		if (le32_to_cpu(data_transfer->data_length)) {
 			if (info->full_packet_received) {
@@ -627,6 +633,24 @@ static int manage_credits_prior_sending(struct cifs_rdma_info *info)
 }
 
 /*
+ * Check if we need to send a KEEP_ALIVE message
+ * The idle connection timer triggers a KEEP_ALIVE message when expires
+ * In this case, we need to set SMB_DIRECT_RESPONSE_REQUESTED in the message
+ * flag to have peer send back a KEEP_ALIVE
+ * return value:
+ * 1 if SMB_DIRECT_RESPONSE_REQUESTED needs to be set
+ * 0: otherwise
+ */
+static int manage_keep_alive_before_sending(struct cifs_rdma_info *info)
+{
+	if (info->keep_alive_requested == KEEP_ALIVE_PENDING) {
+		info->keep_alive_requested = KEEP_ALIVE_SENT;
+		return 1;
+	}
+	return 0;
+}
+
+/*
  * Send a page
  * page: the page to send
  * offset: offset in the page to send
@@ -662,6 +686,8 @@ static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *pa
 	packet->credits_granted =
 		cpu_to_le16(manage_credits_prior_sending(info));
 	packet->flags = cpu_to_le16(0);
+	if (manage_keep_alive_before_sending(info))
+		packet->flags |= cpu_to_le16(SMB_DIRECT_RESPONSE_REQUESTED);
 
 	packet->reserved = cpu_to_le16(0);
 	packet->data_offset = cpu_to_le32(24);
@@ -773,6 +799,8 @@ static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info)
 	packet = (struct smbd_data_transfer_no_data *) request->packet;
 
 	credits_granted = manage_credits_prior_sending(info);
+	if (manage_keep_alive_before_sending(info))
+		flags = SMB_DIRECT_RESPONSE_REQUESTED;
 
 	/* nothing to do? */
 	if (credits_granted==0 && flags==0) {
@@ -885,6 +913,8 @@ static int cifs_rdma_post_send_data(
 	packet->credits_requested = cpu_to_le16(info->send_credit_target);
 	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(info));
 	packet->flags = cpu_to_le16(0);
+	if (manage_keep_alive_before_sending(info))
+		packet->flags |= cpu_to_le16(SMB_DIRECT_RESPONSE_REQUESTED);
 	packet->reserved = cpu_to_le16(0);
 
 	packet->data_offset = cpu_to_le32(24);
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index c27db6f..62d0bb8 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -25,6 +25,12 @@
 #include <rdma/rdma_cm.h>
 #include <linux/mempool.h>
 
+enum keep_alive_status {
+	KEEP_ALIVE_NONE,
+	KEEP_ALIVE_PENDING,
+	KEEP_ALIVE_SENT,
+};
+
 enum cifs_rdma_transport_status {
 	CIFS_RDMA_CREATED,
 	CIFS_RDMA_CONNECTING,
@@ -68,6 +74,7 @@ struct cifs_rdma_info {
 	int max_fragmented_send_size;
 	int max_receive_size;
 	int max_readwrite_size;
+	enum keep_alive_status keep_alive_requested;
 	int protocol;
 	atomic_t send_credits;
 	atomic_t receive_credits;
-- 
2.7.4
