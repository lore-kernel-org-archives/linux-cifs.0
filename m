Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5E728C5AA
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155622; cv=none; b=tC66iMmlEC1RbCtegc0M+BJM1k3INPTwG5Ye3nqV8DfLnKZH5YG7DUoZtRJHNjvGmqPzDdgywGpAWnJXuHuPHSR5HKfp2mCdTVovYBbHUUv5V/Bkbj6rc1jVtU8PaW8em85jWPsY+O/LmfkN3bmxomTI4DvntKifUzI7u4kFD64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155622; c=relaxed/simple;
	bh=rVoheXe1457QXWl+VTPj64aWu9QkIO5lYnkvvozjUhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9cIznrbjagdL9AmE6XwcvUJU1HE8TNPCLygVgxaMEBDB7ryKYGA3nw0c3uoer95vj0p+LXT9NRiNQMfUmQRB43LnsxjE+YER51+9DiAjUY17bHjQDB599x2Bohj8gOo+oUhh0T+to+U09e3eVPUmx4ouAuoL+FZQEeudZAcH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=laMUru+t; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="laMUru+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=coJjRgSblF+dfkXKMXLxqlaVihhTEjQ1mmXj1twOixs=; b=laMUru+ttWqHinlosdIJ0dMxdd
	qU4NwGp1FI9nT6qZbUKtQfUy4yRhGfzButo7n2XOcjCrX/07tsz8ensIHhZix7WOgSL2kzcet8sDe
	gdaOb/NvcxWIM6ZmOCZJV9eGw9xCxeLCd86ni3B5jvMgYS8XPIaXYz/aZ6bwZg2o6U2FHTUScKy15
	NWgOobb/VUIhXZ+ibkRFNvK2fomG77RlbJAi//fmmI8lNkl3Nlb1OuzcPF71TG3d52t2Ukiu2mG0X
	bdG0FLfdieBI99yRzKutD+1FyYm6kP6BWxwCB1bk9MlOX1ciC0gCdZkyKu5wfkvDEW+TnegtiswHB
	nxmXeo4pZdlkKMhACNCvklYsk/Oe1WQ7P6lj5x8Ytz4pbTmTxO+BTuhQCEEh/cM1ZkSdFWb2uP1Pz
	1XqUQnrVAVmYmgU2j23hHkeVcLs/Bd2MskjrJsu2odIQbzogjD/ieUpKdADtHntMf8ccbjaxyB6Zl
	K4HDzs4/XjdY7NBSZZzJOO53;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeIY-000muG-0N;
	Mon, 25 Aug 2025 21:00:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 111/142] smb: server: make use of smbdirect_socket_parameters.{initiator_depth,responder_resources}
Date: Mon, 25 Aug 2025 22:41:12 +0200
Message-ID: <355622c0bf2e8ec7a8e01ccd5d1a9e41f337a021.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to specify these from the outside of the core
code first and then negotiate the value with the peer.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 9bc8431821b6..100ac189b47e 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -95,8 +95,6 @@ struct smb_direct_transport {
 	struct work_struct	send_immediate_work;
 
 	bool			legacy_iwarp;
-	u8			initiator_depth;
-	u8			responder_resources;
 };
 
 #define KSMBD_TRANS(t) (&(t)->transport)
@@ -300,6 +298,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
 
 	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
+	sp->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
+	sp->responder_resources = 1;
 	sp->recv_credit_max = smb_direct_receive_credit_max;
 	sp->send_credit_target = smb_direct_send_credit_target;
 	sp->max_send_size = smb_direct_max_send_size;
@@ -310,9 +310,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = t;
 
-	t->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
-	t->responder_resources = 1;
-
 	sc->ib.dev = sc->rdma.cm_id->device;
 
 	INIT_WORK(&sc->recv_io.posted.refill_work,
@@ -1613,18 +1610,19 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 static int smb_direct_accept_client(struct smb_direct_transport *t)
 {
 	struct smbdirect_socket *sc = &t->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct rdma_conn_param conn_param;
 	__be32 ird_ord_hdr[2];
 	int ret;
 
 	/*
 	 * smb_direct_handle_connect_request()
-	 * already negotiated t->initiator_depth
-	 * and t->responder_resources
+	 * already negotiated sp->initiator_depth
+	 * and sp->responder_resources
 	 */
 	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = t->initiator_depth;
-	conn_param.responder_resources = t->responder_resources;
+	conn_param.initiator_depth = sp->initiator_depth;
+	conn_param.responder_resources = sp->responder_resources;
 
 	if (t->legacy_iwarp) {
 		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
@@ -2035,6 +2033,8 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 					     struct rdma_cm_event *event)
 {
 	struct smb_direct_transport *t;
+	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters *sp;
 	struct task_struct *handler;
 	u8 peer_initiator_depth;
 	u8 peer_responder_resources;
@@ -2050,6 +2050,8 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	t = alloc_transport(new_cm_id);
 	if (!t)
 		return -ENOMEM;
+	sc = &t->socket;
+	sp = &sc->parameters;
 
 	peer_initiator_depth = event->param.conn.initiator_depth;
 	peer_responder_resources = event->param.conn.responder_resources;
@@ -2099,7 +2101,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	/*
 	 * First set what the we as server are able to support
 	 */
-	t->initiator_depth = min_t(u8, t->initiator_depth,
+	sp->initiator_depth = min_t(u8, sp->initiator_depth,
 				   new_cm_id->device->attrs.max_qp_rd_atom);
 
 	/*
@@ -2108,10 +2110,10 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	 * non 0 values.
 	 */
 	if (peer_initiator_depth != 0)
-		t->initiator_depth = min_t(u8, t->initiator_depth,
+		sp->initiator_depth = min_t(u8, sp->initiator_depth,
 					   peer_initiator_depth);
 	if (peer_responder_resources != 0)
-		t->responder_resources = min_t(u8, t->responder_resources,
+		sp->responder_resources = min_t(u8, sp->responder_resources,
 					       peer_responder_resources);
 
 	ret = smb_direct_connect(t);
-- 
2.43.0

