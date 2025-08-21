Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705631E47A5
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768493; cv=none; b=gRF4g/8TxFUTebYI5P9K8Ra5y0LmxFKp2ZzxnSpjNr/Ol98/sqX1TYdUnr9nS9ENaI/8+l4cW1MlpU7MUm+JQ3BzSeMcT8cxZB0gA+N5UjiM27sJJ2K+OGQaEH5ZTOltAC/GfyQoTn9c+HYYwfVAI+jwC3b24++xPdua7dScHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768493; c=relaxed/simple;
	bh=ULUNNtXkr7TVaCNcFaJ3+7bLUw43UcVzGG/lUI7ZKac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tYOpzVhURY4UaJ8XDr3TjxVjzqALy/K/dmg9efamSrhYurHjw/KV1LY1l5N6eXP3I8MZYaIZl09kYYyHArnHAv0nPa8DyJHF0e1CSZW+XbrK1nJIf2KVXwaK5kQSLhEYcQG7YYNIkMW7tYSAucTCUv7IoB29ZiQpEfkecvt3Nds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rdvXOaHc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rdvXOaHc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gVg57MG7EfHADLIgfauckXcgeTFmxDFiDyqpHAzKoeg=; b=rdvXOaHcax4CoqR3vRi5ziiBpq
	KIdAiSJpebYFVt7r3l5tdDCNjz3PvRwyvRMA6eBCpLmT+XJRoh+DcZtrcNeTSFSqK8qnxQ5TPyRDb
	Z8Li6X8ygfCnMrOIBtzVMoGw7TfG0AL1JK282TqIAU7HSAGD3BIIf3og62s7TTQEt8jabdqluuGPm
	sm42x+FPYzCd1HGBEP1TbEMjCaOUPosRvDDtyIM+dz8GNGChp46/cmb+kKkN2PLkg+fHIIhLBn6VH
	d1F2nl+g58zcbPpqmeUnplycZt8zOu+wWaFiw2l0nzMQ5jjdto+rX+ZoixhepxMqbFKvoWL20/NIF
	a6KoqAelQ7XMpw5T5chAV2XaF9rDFDnqQ8wG3mp6ca0/5aMmOJL5H+xHf5yiRU+RPgDkTvedk7wwf
	aP1UiWfS0W+mn+YnFCE1HaD+wuzivvrTaLKg4SvtEXDPrcn2BLlwTPAeM0ashQFUUfRTBePdLuHPO
	/j1PzovVbtgbatjIBAyjVddA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1up1aY-0002z8-2S;
	Thu, 21 Aug 2025 09:28:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2] smb: server: fix IRD/ORD negotiation with the client
Date: Thu, 21 Aug 2025 11:27:51 +0200
Message-ID: <20250821092751.35815-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Already do real negotiation in smb_direct_handle_connect_request()
where we see the requested initiator_depth and responder_resources
from the client.

We should should detect legacy iwarp clients using MPA v1
with the custom IRD/ORD negotiation.

We need to send the custom IRD/ORD in big endian,
but we need to try to let clients with broken requests
using little endian (older cifs.ko) to work.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 101 ++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5466aa8c39b1..20d1f53ca989 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -153,6 +153,10 @@ struct smb_direct_transport {
 	struct work_struct	disconnect_work;
 
 	bool			negotiation_requested;
+
+	bool			legacy_iwarp;
+	u8			initiator_depth;
+	u8			responder_resources;
 };
 
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
@@ -347,6 +351,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	t->cm_id = cm_id;
 	cm_id->context = t;
 
+	t->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
+	t->responder_resources = 1;
+
 	t->status = SMB_DIRECT_CS_NEW;
 	init_waitqueue_head(&t->wait_status);
 
@@ -1616,21 +1623,21 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 static int smb_direct_accept_client(struct smb_direct_transport *t)
 {
 	struct rdma_conn_param conn_param;
-	struct ib_port_immutable port_immutable;
-	u32 ird_ord_hdr[2];
+	__be32 ird_ord_hdr[2];
 	int ret;
 
+	/*
+	 * smb_direct_handle_connect_request()
+	 * already negotiated t->initiator_depth
+	 * and t->responder_resources
+	 */
 	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
-					   SMB_DIRECT_CM_INITIATOR_DEPTH);
-	conn_param.responder_resources = 0;
-
-	t->cm_id->device->ops.get_port_immutable(t->cm_id->device,
-						 t->cm_id->port_num,
-						 &port_immutable);
-	if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
-		ird_ord_hdr[0] = conn_param.responder_resources;
-		ird_ord_hdr[1] = 1;
+	conn_param.initiator_depth = t->initiator_depth;
+	conn_param.responder_resources = t->responder_resources;
+
+	if (t->legacy_iwarp) {
+		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
+		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
 		conn_param.private_data = ird_ord_hdr;
 		conn_param.private_data_len = sizeof(ird_ord_hdr);
 	} else {
@@ -2016,10 +2023,13 @@ static bool rdma_frwr_is_supported(struct ib_device_attr *attrs)
 	return true;
 }
 
-static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
+static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
+					     struct rdma_cm_event *event)
 {
 	struct smb_direct_transport *t;
 	struct task_struct *handler;
+	u8 peer_initiator_depth;
+	u8 peer_responder_resources;
 	int ret;
 
 	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
@@ -2033,6 +2043,69 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 	if (!t)
 		return -ENOMEM;
 
+	peer_initiator_depth = event->param.conn.initiator_depth;
+	peer_responder_resources = event->param.conn.responder_resources;
+	if (rdma_protocol_iwarp(new_cm_id->device, new_cm_id->port_num) &&
+	    event->param.conn.private_data_len == 8)
+	{
+		/*
+		 * Legacy clients with only iWarp MPA v1 support
+		 * need a private blob in order to negotiate
+		 * the IRD/ORD values.
+		 */
+		const __be32 *ird_ord_hdr = event->param.conn.private_data;
+		u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
+		u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
+
+		/*
+		 * cifs.ko sends the legacy IRD/ORD negotiation
+		 * event if iWarp MPA v2 was used.
+		 *
+		 * Here we check that the values match and only
+		 * mark the client as legacy if they don't match.
+		 */
+		if ((u32)peer_initiator_depth != ird32 ||
+		    (u32)peer_responder_resources != ord32)
+		{
+			/*
+			 * There are broken clients (old cifs.ko)
+			 * using little endian and also
+			 * struct rdma_conn_param only uses u8
+			 * for initiator_depth and responder_resources,
+			 * so we truncate the value to U8_MAX.
+			 *
+			 * smb_direct_accept_client() will then
+			 * do the real negotiation in order to
+			 * select the minimum between client and
+			 * server.
+			 */
+			ird32 = min_t(u32, ird32, U8_MAX);
+			ord32 = min_t(u32, ord32, U8_MAX);
+
+			t->legacy_iwarp = true;
+			peer_initiator_depth = (u8)ird32;
+			peer_responder_resources = (u8)ord32;
+		}
+	}
+
+	/*
+	 * First set what the we as server are able to support
+	 */
+	t->initiator_depth = min_t(u8, t->initiator_depth,
+				   new_cm_id->device->attrs.max_qp_rd_atom);
+
+	/*
+	 * negotiate the value by using the minimum
+	 * between client and server if the client provided
+	 * non 0 values.
+	 */
+	if (peer_initiator_depth != 0)
+		t->initiator_depth = min_t(u8, t->initiator_depth,
+					   peer_initiator_depth);
+	if (peer_responder_resources != 0)
+		t->responder_resources = min_t(u8, t->responder_resources,
+					       peer_responder_resources);
+
 	ret = smb_direct_connect(t);
 	if (ret)
 		goto out_err;
@@ -2057,7 +2130,7 @@ static int smb_direct_listen_handler(struct rdma_cm_id *cm_id,
 {
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST: {
-		int ret = smb_direct_handle_connect_request(cm_id);
+		int ret = smb_direct_handle_connect_request(cm_id, event);
 
 		if (ret) {
 			pr_err("Can't create transport: %d\n", ret);
-- 
2.43.0

