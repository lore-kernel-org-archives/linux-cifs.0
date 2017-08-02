From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper layer to create SMBD transport and establish RDMA connection
Date: Wed,  2 Aug 2017 13:10:16 -0700
Message-ID: <1501704648-20159-6-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Implement the code for connecting to SMBD server. The client and server are connected using RC Queue Pair over RDMA API, which suppports Infiniband, RoCE and iWARP. Upper layer code can call cifs_create_rdma_session to establish a SMBD RDMA connection.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.c | 257 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |  14 +++
 2 files changed, 271 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 7c4c178..b18fb79 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -120,3 +120,260 @@ do {									\
 			atomic_read(&info->send_credits),		\
 			info->send_credit_target);			\
 } while (0)
+
+/* Upcall from RDMA CM */
+static int cifs_rdma_conn_upcall(
+		struct rdma_cm_id *id, struct rdma_cm_event *event)
+{
+	struct cifs_rdma_info *info = id->context;
+
+	log_rdma_event("event=%d status=%d\n", event->event, event->status);
+
+	switch (event->event) {
+	case RDMA_CM_EVENT_ADDR_RESOLVED:
+	case RDMA_CM_EVENT_ROUTE_RESOLVED:
+		info->ri_rc = 0;
+		complete(&info->ri_done);
+		break;
+
+	case RDMA_CM_EVENT_ADDR_ERROR:
+		info->ri_rc = -EHOSTUNREACH;
+		complete(&info->ri_done);
+		break;
+
+	case RDMA_CM_EVENT_ROUTE_ERROR:
+		info->ri_rc = -ENETUNREACH;
+		complete(&info->ri_done);
+		break;
+
+	case RDMA_CM_EVENT_ESTABLISHED:
+	case RDMA_CM_EVENT_CONNECT_ERROR:
+	case RDMA_CM_EVENT_UNREACHABLE:
+	case RDMA_CM_EVENT_REJECTED:
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
+		log_rdma_event("connected event=%d\n", event->event);
+		info->connect_state = event->event;
+		break;
+
+	case RDMA_CM_EVENT_DISCONNECTED:
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/* Upcall from RDMA QP */
+static void
+cifs_rdma_qp_async_error_upcall(struct ib_event *event, void *context)
+{
+	struct cifs_rdma_info *info = context;
+	log_rdma_event("%s on device %s info %p\n",
+		ib_event_msg(event->event), event->device->name, info);
+
+	switch (event->event)
+	{
+	case IB_EVENT_CQ_ERR:
+	case IB_EVENT_QP_FATAL:
+	case IB_EVENT_QP_REQ_ERR:
+	case IB_EVENT_QP_ACCESS_ERR:
+
+	default:
+		break;
+	}
+}
+
+static struct rdma_cm_id* cifs_rdma_create_id(
+		struct cifs_rdma_info *info, struct sockaddr *dstaddr)
+{
+	struct rdma_cm_id *id;
+	int rc;
+	struct sockaddr_in *addr_in = (struct sockaddr_in*) dstaddr;
+	__be16 *sport;
+
+	log_rdma_event("connecting to IP %pI4 port %d\n",
+		&addr_in->sin_addr, ntohs(addr_in->sin_port));
+
+	id = rdma_create_id(&init_net, cifs_rdma_conn_upcall, info,
+		RDMA_PS_TCP, IB_QPT_RC);
+	if (IS_ERR(id)) {
+		rc = PTR_ERR(id);
+		log_rdma_event("rdma_create_id() failed %i\n", rc);
+		return id;
+	}
+
+	if (dstaddr->sa_family == AF_INET6)
+		sport = &((struct sockaddr_in6 *)dstaddr)->sin6_port;
+	else
+		sport = &((struct sockaddr_in *)dstaddr)->sin_port;
+
+	*sport = htons(445);
+try_again:
+	init_completion(&info->ri_done);
+	info->ri_rc = -ETIMEDOUT;
+	rc = rdma_resolve_addr(id, NULL, (struct sockaddr*)dstaddr, 5000);
+	if (rc) {
+		log_rdma_event("rdma_resolve_addr() failed %i\n", rc);
+		goto out;
+	}
+	wait_for_completion_interruptible_timeout(
+		&info->ri_done, msecs_to_jiffies(8000));
+	rc = info->ri_rc;
+	if (rc) {
+		log_rdma_event("rdma_resolve_addr() completed %i\n", rc);
+		goto out;
+	}
+
+	info->ri_rc = -ETIMEDOUT;
+	rc = rdma_resolve_route(id, 5000);
+	if (rc) {
+		log_rdma_event("rdma_resolve_route() failed %i\n", rc);
+		goto out;
+	}
+	wait_for_completion_interruptible_timeout(
+		&info->ri_done, msecs_to_jiffies(8000));
+	rc = info->ri_rc;
+	if (rc) {
+		log_rdma_event("rdma_resolve_route() completed %i\n", rc);
+		goto out;
+	}
+
+	return id;
+
+out:
+	// try port number 5445 if port 445 doesn't work
+	if (*sport == htons(445)) {
+		*sport = htons(5445);
+		goto try_again;
+	}
+	rdma_destroy_id(id);
+	return ERR_PTR(rc);
+}
+
+static int cifs_rdma_ia_open(
+		struct cifs_rdma_info *info, struct sockaddr *dstaddr)
+{
+	int rc;
+
+	info->id = cifs_rdma_create_id(info, dstaddr);
+	if (IS_ERR(info->id)) {
+		rc = PTR_ERR(info->id);
+		goto out1;
+	}
+
+	info->pd = ib_alloc_pd(info->id->device, 0);
+	if (IS_ERR(info->pd)) {
+		rc = PTR_ERR(info->pd);
+		log_rdma_event("ib_alloc_pd() returned %d\n", rc);
+		goto out2;
+	}
+
+	return 0;
+
+out2:
+	rdma_destroy_id(info->id);
+	info->id = NULL;
+
+out1:
+	return rc;
+}
+
+struct cifs_rdma_info* cifs_create_rdma_session(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
+{
+	int rc;
+	struct cifs_rdma_info *info;
+	struct rdma_conn_param conn_param;
+	struct ib_qp_init_attr qp_attr;
+	int max_pending = receive_credit_max + send_credit_target;
+
+	info = kzalloc(sizeof(struct cifs_rdma_info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	info->server_info = server;
+
+	rc = cifs_rdma_ia_open(info, dstaddr);
+	if (rc) {
+		log_rdma_event("cifs_rdma_ia_open rc=%d\n", rc);
+		goto out1;
+	}
+
+	if (max_pending > info->id->device->attrs.max_cqe ||
+	    max_pending > info->id->device->attrs.max_qp_wr) {
+		log_rdma_event("consider lowering receive_credit_max and "
+			"send_credit_target. Possible CQE overrun, device "
+			"reporting max_cpe %d max_qp_wr %d\n",
+			info->id->device->attrs.max_cqe,
+			info->id->device->attrs.max_qp_wr);
+		goto out2;
+	}
+
+	info->receive_credit_max = receive_credit_max;
+	info->send_credit_target = send_credit_target;
+	info->max_send_size = max_send_size;
+	info->max_fragmented_recv_size = max_fragmented_recv_size;
+	info->max_receive_size = max_receive_size;
+
+	max_send_sge = min_t(int, max_send_sge,
+		info->id->device->attrs.max_sge);
+	max_recv_sge = min_t(int, max_recv_sge,
+		info->id->device->attrs.max_sge_rd);
+
+	info->cq = ib_alloc_cq(info->id->device, info,
+			info->receive_credit_max + info->send_credit_target,
+			0, IB_POLL_SOFTIRQ);
+	if (IS_ERR(info->cq))
+		goto out2;
+
+	memset(&qp_attr, 0, sizeof qp_attr);
+	qp_attr.event_handler = cifs_rdma_qp_async_error_upcall;
+	qp_attr.qp_context = info;
+	qp_attr.cap.max_send_wr = info->send_credit_target;
+	qp_attr.cap.max_recv_wr = info->receive_credit_max;
+	qp_attr.cap.max_send_sge = max_send_sge;
+	qp_attr.cap.max_recv_sge = max_recv_sge;
+	qp_attr.cap.max_inline_data = 0;
+	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
+	qp_attr.qp_type = IB_QPT_RC;
+	qp_attr.send_cq = info->cq;
+	qp_attr.recv_cq = info->cq;
+	qp_attr.port_num = ~0;
+
+	rc = rdma_create_qp(info->id, info->pd, &qp_attr);
+	if (rc) {
+		log_rdma_event("rdma_create_qp failed %i\n", rc);
+		rc = -ENETUNREACH;
+		goto out2;
+	}
+
+	memset(&conn_param, 0, sizeof(conn_param));
+	conn_param.private_data = NULL;
+	conn_param.private_data_len = 0;
+	conn_param.initiator_depth = 0;
+	conn_param.responder_resources = 32;
+	if (info->id->device->attrs.max_qp_rd_atom < 32)
+		conn_param.responder_resources =
+			info->id->device->attrs.max_qp_rd_atom;
+	conn_param.retry_count = 6;
+	conn_param.rnr_retry_count = 6;
+	conn_param.flow_control = 0;
+	rc = rdma_connect(info->id, &conn_param);
+	if (rc) {
+		log_rdma_event("rdma_connect() failed with %i\n", rc);
+		goto out2;
+	}
+
+	if (info->connect_state != RDMA_CM_EVENT_ESTABLISHED)
+		goto out2;
+
+	log_rdma_event("rdma_connect connected\n");
+out2:
+	rdma_destroy_id(info->id);
+
+out1:
+	kfree(info);
+	return NULL;
+}
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 9979fd4..71ea380 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -36,6 +36,16 @@
 struct cifs_rdma_info {
 	struct TCP_Server_Info *server_info;
 
+	// RDMA related
+	struct rdma_cm_id *id;
+	struct ib_qp_init_attr qp_attr;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_device_attr dev_attr;
+	int connect_state;
+	int ri_rc;
+	struct completion ri_done;
+
 	//connection paramters
 	int receive_credit_max;
 	int send_credit_target;
@@ -55,4 +65,8 @@ struct cifs_rdma_info {
 	unsigned int count_put_receive_buffer;
 	unsigned int count_send_empty;
 };
+
+// Create a SMBDirect session
+struct cifs_rdma_info* cifs_create_rdma_session(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 #endif
-- 
2.7.4
