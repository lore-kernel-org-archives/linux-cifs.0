From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 19/37] [CIFS] SMBD: Manage credits on SMBD client and server
Date: Wed,  2 Aug 2017 13:10:30 -0700
Message-ID: <1501704648-20159-20-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

SMB client and server maintain a credit system on the SMBD transport. Credits are used to tell when the client or server can send a packet to the peer, based on current memory or resource usage.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index eb48651..97cde3f 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -575,6 +575,46 @@ static int cifs_rdma_post_send_negotiate_req(struct cifs_rdma_info *info)
 }
 
 /*
+ * Extend the credits to remote peer
+ * This implements [MS-SMBD] 3.1.5.9
+ * The idea is that we should extend credits to remote peer as quickly as
+ * it's allowed, to maintain data flow. We allocate as much as receive
+ * buffer as possible, and extend the receive credits to remote peer
+ * return value: the new credtis being granted.
+ */
+static int manage_credits_prior_sending(struct cifs_rdma_info *info)
+{
+	int ret = 0;
+	struct cifs_rdma_response *response;
+	int rc;
+
+	if (atomic_read(&info->receive_credit_target) >
+	    atomic_read(&info->receive_credits)) {
+		while (true) {
+			response = get_receive_buffer(info);
+			if (!response)
+				break;
+
+			response->type = SMBD_TRANSFER_DATA;
+			response->first_segment = false;
+			rc = cifs_rdma_post_recv(info, response);
+			if (rc) {
+				log_rdma_recv("post_recv failed rc=%d\n", rc);
+				put_receive_buffer(info, response);
+				break;
+			}
+
+			ret++;
+		}
+	}
+
+	atomic_add(ret, &info->receive_credits);
+	log_transport_credit(info);
+
+	return ret;
+}
+
+/*
  * Send a page
  * page: the page to send
  * offset: offset in the page to send
@@ -607,6 +647,8 @@ static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *pa
 
 	packet = (struct smbd_data_transfer *) request->packet;
 	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->credits_granted =
+		cpu_to_le16(manage_credits_prior_sending(info));
 	packet->flags = cpu_to_le16(0);
 
 	packet->reserved = cpu_to_le16(0);
@@ -718,6 +760,8 @@ static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info)
 	request->info = info;
 	packet = (struct smbd_data_transfer_no_data *) request->packet;
 
+	credits_granted = manage_credits_prior_sending(info);
+
 	/* nothing to do? */
 	if (credits_granted==0 && flags==0) {
 		mempool_free(request, info->request_mempool);
@@ -827,6 +871,7 @@ static int cifs_rdma_post_send_data(
 
 	packet = (struct smbd_data_transfer *) request->packet;
 	packet->credits_requested = cpu_to_le16(info->send_credit_target);
+	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(info));
 	packet->flags = cpu_to_le16(0);
 	packet->reserved = cpu_to_le16(0);
 
-- 
2.7.4
