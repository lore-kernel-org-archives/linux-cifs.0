Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCC01C69D
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 09:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768685; cv=none; b=LwBbIGmPRxmPnCI2ga6xLqHVqzARiq3pbRPgEfLFG2DDqjtYkAdE/emBUUagHAZsDhmcrkQzUSivApPrVxezwd9pR1vatrYaKzs3cjAmCJKJWIfwIx9iNPzkRCalp/5EpJo1606kp4z6fF0eiaVjwwx/pOh41GGQoHTKsS0k97I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768685; c=relaxed/simple;
	bh=wLGw6Rk+V9varmcNtA7AZtnR+y0qyosrDhJU8Dm+KPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h9/u1yo/wEL00YevbhR9EGsgjtVKUem9dRoUwVR4OgHtKV6M0jiE2wEVs24f1M2V7e355CTRHP1twuti57WzDaBWvmoWH9q/G4QkrqD+9klhQGaJE6oJ6P7bmfRr5jdzexMw3TS6UX0IoiHYhmO2A0iis0Cs5wR11wLT816ebMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aNUMsRB2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aNUMsRB2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NEKUTh4Y4A04p6YQwVEgv0Dg7WZs+8YMlzFfW4jtZYE=; b=aNUMsRB22u6iHzfeQGr4BwRAbk
	JXM9DJIOskLcT0Y8icxsKvGXwRDVnvO+m28TUSxRJcMNt7JWbMBU60N2gBEIX4jAO1oBQB86h9Sbu
	Mg/IaCbIxm/PB0xOWfivBcVMdGJuftRS1SebjWF5zA9+xemgt2O2g5wUM4ghrQozTzj8bh4CRCc0S
	vi6ONnB10hcOlrvX3v/zl04I+n/CLFl0qEqqMz4LPxpTz6kbI+byan4Urk0PWjPG8XUEjYxLibp5J
	80ZOfLQP8NUELjXHBm6JELI4csZ51DIErQDCf6mlyiAXy//Wb6gTP/VQtCLFEB1SLPG4sWPqnpBgr
	Mqrc12Adr28j7KbHMr1vIWWr34jk9YnvwBqFM2UtAL1rEuiEYA/9RC6Fj/GKd4rsu8VKpPSG+F+Xg
	8zvI3OaHK/fYvWKyp0ybZZn3qPqtSmXZoIrxMD9x8oNwY/i861Dth0kOOakGzErPU242JyBawp0kc
	8C4YQa3SpZ85qVZUsjU+IS99;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1up1dg-00034v-21;
	Thu, 21 Aug 2025 09:31:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH] smb: client: fix sending the iwrap custom IRD/ORD negotiation messages
Date: Thu, 21 Aug 2025 11:31:13 +0200
Message-ID: <20250821093113.36212-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do a real negotiation and check the servers initiator_depth and responder_resources.

This should use big endian in order to be useful.
I have captures of windows clients showing this.

The fact that we used little endian up to now
means that we sent very large numbers and the
negotiation with the server truncated them to the
server limits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 84 ++++++++++++++++++++++++++++++++++-----
 fs/smb/client/smbdirect.h |  4 +-
 2 files changed, 77 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 02d6db431fd4..669408b113cb 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -179,6 +179,8 @@ static int smbd_conn_upcall(
 	struct smbd_connection *info = id->context;
 	struct smbdirect_socket *sc = &info->socket;
 	const char *event_name = rdma_event_msg(event->event);
+	u8 peer_initiator_depth;
+	u8 peer_responder_resources;
 
 	log_rdma_event(INFO, "event=%s status=%d\n",
 		event_name, event->status);
@@ -204,6 +206,59 @@ static int smbd_conn_upcall(
 
 	case RDMA_CM_EVENT_ESTABLISHED:
 		log_rdma_event(INFO, "connected event=%s\n", event_name);
+
+		peer_initiator_depth = event->param.conn.initiator_depth;
+		peer_responder_resources = event->param.conn.responder_resources;
+		if (rdma_protocol_iwarp(id->device, id->port_num) &&
+		    event->param.conn.private_data_len == 8)
+		{
+			/*
+			 * Legacy clients with only iWarp MPA v1 support
+			 * need a private blob in order to negotiate
+			 * the IRD/ORD values.
+			 */
+			const __be32 *ird_ord_hdr = event->param.conn.private_data;
+			u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
+			u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
+
+			/*
+			 * cifs.ko sends the legacy IRD/ORD negotiation
+			 * event if iWarp MPA v2 was used.
+			 *
+			 * Here we check that the values match and only
+			 * mark the client as legacy if they don't match.
+			 */
+			if ((u32)peer_initiator_depth != ird32 ||
+			    (u32)peer_responder_resources != ord32)
+			{
+				/*
+				 * There are broken clients (old cifs.ko)
+				 * using little endian and also
+				 * struct rdma_conn_param only uses u8
+				 * for initiator_depth and responder_resources,
+				 * so we truncate the value to U8_MAX.
+				 *
+				 * smb_direct_accept_client() will then
+				 * do the real negotiation in order to
+				 * select the minimum between client and
+				 * server.
+				 */
+				ird32 = min_t(u32, ird32, U8_MAX);
+				ord32 = min_t(u32, ord32, U8_MAX);
+
+				info->legacy_iwarp = true;
+				peer_initiator_depth = (u8)ird32;
+				peer_responder_resources = (u8)ord32;
+			}
+		}
+
+		info->initiator_depth =
+				min_t(u8, info->initiator_depth,
+				      peer_initiator_depth);
+		info->responder_resources =
+				min_t(u8, info->responder_resources,
+				      peer_responder_resources);
+
 		sc->status = SMBDIRECT_SOCKET_CONNECTED;
 		wake_up_interruptible(&info->status_wait);
 		break;
@@ -1528,7 +1583,7 @@ static struct smbd_connection *_smbd_get_connection(
 	struct ib_qp_init_attr qp_attr;
 	struct sockaddr_in *addr_in = (struct sockaddr_in *) dstaddr;
 	struct ib_port_immutable port_immutable;
-	u32 ird_ord_hdr[2];
+	__be32 ird_ord_hdr[2];
 
 	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
 	if (!info)
@@ -1536,6 +1591,9 @@ static struct smbd_connection *_smbd_get_connection(
 	sc = &info->socket;
 	sp = &sc->parameters;
 
+	info->initiator_depth = 1;
+	info->responder_resources = SMBD_CM_RESPONDER_RESOURCES;
+
 	sc->status = SMBDIRECT_SOCKET_CONNECTING;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
@@ -1616,22 +1674,22 @@ static struct smbd_connection *_smbd_get_connection(
 	}
 	sc->ib.qp = sc->rdma.cm_id->qp;
 
-	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = 0;
-
-	conn_param.responder_resources =
-		min(sc->ib.dev->attrs.max_qp_rd_atom,
-		    SMBD_CM_RESPONDER_RESOURCES);
-	info->responder_resources = conn_param.responder_resources;
+	info->responder_resources =
+		min_t(u8, info->responder_resources,
+		      sc->ib.dev->attrs.max_qp_rd_atom);
 	log_rdma_mr(INFO, "responder_resources=%d\n",
 		info->responder_resources);
 
+	memset(&conn_param, 0, sizeof(conn_param));
+	conn_param.initiator_depth = info->initiator_depth;
+	conn_param.responder_resources = info->responder_resources;
+
 	/* Need to send IRD/ORD in private data for iWARP */
 	sc->ib.dev->ops.get_port_immutable(
 		sc->ib.dev, sc->rdma.cm_id->port_num, &port_immutable);
 	if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
-		ird_ord_hdr[0] = info->responder_resources;
-		ird_ord_hdr[1] = 1;
+		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
+		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
 		conn_param.private_data = ird_ord_hdr;
 		conn_param.private_data_len = sizeof(ird_ord_hdr);
 	} else {
@@ -2098,6 +2156,12 @@ static int allocate_mr_list(struct smbd_connection *info)
 	atomic_set(&info->mr_used_count, 0);
 	init_waitqueue_head(&info->wait_for_mr_cleanup);
 	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
+
+	if (info->responder_resources == 0) {
+		log_rdma_mr(ERR, "responder_resources negotiated as 0\n");
+		return -EINVAL;
+	}
+
 	/* Allocate more MRs (2x) than hardware responder_resources */
 	for (i = 0; i < info->responder_resources * 2; i++) {
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index e45aa9ddd71d..4ca9b2b2c57f 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -67,7 +67,9 @@ struct smbd_connection {
 
 	/* Memory registrations */
 	/* Maximum number of RDMA read/write outstanding on this connection */
-	int responder_resources;
+	bool legacy_iwarp;
+	u8 initiator_depth;
+	u8 responder_resources;
 	/* Maximum number of pages in a single RDMA write/read on this connection */
 	int max_frmr_depth;
 	/*
-- 
2.43.0

