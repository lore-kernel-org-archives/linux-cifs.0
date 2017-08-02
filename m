From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 29/37] [CIFS] SMBD: Disconnect RDMA connection on QP errors
Date: Wed,  2 Aug 2017 13:10:40 -0700
Message-ID: <1501704648-20159-30-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Sometime Queue Pair may have errors if hardware is having trouble with connectivity issues. In this case, SMBD should terminate the RDMA connetion.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 18 ++++++++++++++++++
 fs/cifs/cifsrdma.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index fb94975..01cb006 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -202,6 +202,22 @@ static int cifs_rdma_process_disconnected(struct cifs_rdma_info *info)
 	return 0;
 }
 
+static void cifs_disconnect_rdma_work(struct work_struct *work)
+{
+	struct cifs_rdma_info *info =
+		container_of(work, struct cifs_rdma_info, disconnect_work);
+
+	if (info->transport_status == CIFS_RDMA_CONNECTED) {
+		info->transport_status = CIFS_RDMA_DISCONNECTING;
+		rdma_disconnect(info->id);
+	}
+}
+
+static void cifs_disconnect_rdma_session(struct cifs_rdma_info *info)
+{
+	schedule_work(&info->disconnect_work);
+}
+
 /* Upcall from RDMA CM */
 static int cifs_rdma_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
@@ -264,6 +280,7 @@ cifs_rdma_qp_async_error_upcall(struct ib_event *event, void *context)
 	case IB_EVENT_QP_FATAL:
 	case IB_EVENT_QP_REQ_ERR:
 	case IB_EVENT_QP_ACCESS_ERR:
+		cifs_disconnect_rdma_session(info);
 
 	default:
 		break;
@@ -1494,6 +1511,7 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	init_waitqueue_head(&info->wait_recv_pending);
 	atomic_set(&info->recv_pending, 0);
 
+	INIT_WORK(&info->disconnect_work, cifs_disconnect_rdma_work);
 	INIT_WORK(&info->destroy_work, cifs_destroy_rdma_work);
 
 	rc = cifs_rdma_negotiate(info);
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 424ea8e..9306622 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -68,6 +68,7 @@ struct cifs_rdma_info {
 	bool negotiate_done;
 
 	struct work_struct destroy_work;
+	struct work_struct disconnect_work;
 
 	//connection paramters
 	int receive_credit_max;
-- 
2.7.4
