Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175EF355037
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744688; cv=none; b=Lnf4oYes9Etgg43HKGHMF7vIeBn4/DLgIIeiCn2xxlYKlvquX7blOIG49Kr9NDiUEtukY2eFqQPWILfESSKZlV1RrfulbXKEOU+gmD9eRI+NABAgVSbk3WvoxBlYgvm/tjceLhSP9OH/fnrsbcFpEmM6FhHCims0lHgeWeRRrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744688; c=relaxed/simple;
	bh=pPFVu0A3U5knh8Cn+HlNoWA2+fA64NIl4JuCUEbd8mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAemn2g0HGnPfjvC9J6TMlsZuVU5jIfciuVEZfw8T7FFacJC5dSZhF8KZoCUfHhYHqXiVeYsbA8J/Mh2GIEO6sDa3Uwr13hpaBDzHrSFgDvB1zkGGcIpuF5l2mUqYs3KqnJz2SB7nj0tiynIujNloRO6OIOrfBOCllWKVmuwxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WnOmIhMs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WnOmIhMs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=GlWzhUU++hbW+z/6BFypjNvatwtpgLi7+SXCbSOn5FU=; b=WnOmIhMsT2Phz/Rh2RaVDfhGYx
	J279crkcBOl3tMJpa8i1zx7l978rWAR0spMUTyyXJGMkL7bGxC5YQzXy3odYuUSYOLAlevIuKV5Rv
	c7fIKp4M423UMBIigXBDyMqytpdyI7o06VILEIlnRnzRRPCb+VukbcKHF0By/jKx/MiBAZKRAh0FG
	RO+5aZI4ysvgoDFpT/AGKzNCOZ7XI6nh5x+L1JCyrfaVinaffbDJ6/PEj1XzSka6+0iI91R9Yfmv/
	aP2qERhthl7E1Yaz65LSZkbWKmVCCYrD7q/EF5O9OfqEyse3nXya5h8gJP7+z0XF9pZf2xRkCORPc
	OQ14diKxLKMzux7yqFNf5zn8mRHswxnqdB1Tx1DlUB++BPowsCpzJ07pXP0tblcqyjGqU3dQkTTQC
	cFySXxupmNTqJTRkwHZ2oMfUlzrOZglDEwgK+0xXzhQANDP7VvY10FgjPEWW+05SFC1nwn0I0gHoy
	vsXOoCTQmE8kZ4rIfOEDJd5S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Gn-00BcXE-1d;
	Wed, 29 Oct 2025 13:31:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 088/127] smb: client: make use of smbdirect_socket_init_new() and smbdirect_connect_sync()
Date: Wed, 29 Oct 2025 14:21:06 +0100
Message-ID: <8131cc22e6c387b9c5c094a3d6c61c2412b866a1.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This means we finally only use common functions in the client.

We still use the embedded struct smbdirect_socket and are
able to access internals, but the will be removed in the
next commits as well.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 797 +++-----------------------------------
 fs/smb/client/smbdirect.h |   1 +
 2 files changed, 56 insertions(+), 742 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 745879bf3a3f..922001875d9b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -10,19 +10,12 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
-#include "../common/smbdirect/smbdirect_pdu.h"
+#include <linux/errname.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
-{
-	struct smbdirect_socket *sc = &conn->socket;
-
-	return &sc->parameters;
-}
-
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
 #define SMBD_PORT	5445
@@ -36,21 +29,12 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 /* The timeout to wait for a keepalive message from peer in seconds */
 #define KEEPALIVE_RECV_TIMEOUT 5
 
-/* SMBD minimum receive size and fragmented sized defined in [MS-SMBD] */
-#define SMBD_MIN_RECEIVE_SIZE		128
-#define SMBD_MIN_FRAGMENTED_SIZE	131072
-
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
  * This value is possibly decreased during QP creation on hardware limit
  */
 #define SMBD_CM_RESPONDER_RESOURCES	32
 
-/* Maximum number of retries on data transfer operations */
-#define SMBD_CM_RETRY			6
-/* No need to retry on Receiver Not Ready since SMBD manages credits */
-#define SMBD_CM_RNR_RETRY		0
-
 /*
  * User configurable initial values per SMBD transport connection
  * as defined in [MS-SMBD] 3.1.1.1
@@ -179,555 +163,6 @@ do {									\
 #define log_rdma_mr(level, fmt, args...) \
 		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
 
-/* Upcall from RDMA CM */
-static int smbd_conn_upcall(
-		struct rdma_cm_id *id, struct rdma_cm_event *event)
-{
-	struct smbdirect_socket *sc = id->context;
-	const char *event_name = rdma_event_msg(event->event);
-	u8 peer_initiator_depth;
-	u8 peer_responder_resources;
-
-	log_rdma_event(INFO, "event=%s status=%d\n",
-		event_name, event->status);
-
-	switch (event->event) {
-	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
-		wake_up(&sc->status_wait);
-		break;
-
-	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
-		wake_up(&sc->status_wait);
-		break;
-
-	case RDMA_CM_EVENT_ADDR_ERROR:
-		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-		break;
-
-	case RDMA_CM_EVENT_ROUTE_ERROR:
-		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-		break;
-
-	case RDMA_CM_EVENT_ESTABLISHED:
-		log_rdma_event(INFO, "connected event=%s\n", event_name);
-
-		/*
-		 * Here we work around an inconsistency between
-		 * iWarp and other devices (at least rxe and irdma using RoCEv2)
-		 */
-		if (rdma_protocol_iwarp(id->device, id->port_num)) {
-			/*
-			 * iWarp devices report the peer's values
-			 * with the perspective of the peer here.
-			 * Tested with siw and irdma (in iwarp mode)
-			 * We need to change to our perspective here,
-			 * so we need to switch the values.
-			 */
-			peer_initiator_depth = event->param.conn.responder_resources;
-			peer_responder_resources = event->param.conn.initiator_depth;
-		} else {
-			/*
-			 * Non iWarp devices report the peer's values
-			 * already changed to our perspective here.
-			 * Tested with rxe and irdma (in roce mode).
-			 */
-			peer_initiator_depth = event->param.conn.initiator_depth;
-			peer_responder_resources = event->param.conn.responder_resources;
-		}
-		smbdirect_connection_negotiate_rdma_resources(sc,
-							      peer_initiator_depth,
-							      peer_responder_resources,
-							      &event->param.conn);
-
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
-		wake_up(&sc->status_wait);
-		break;
-
-	case RDMA_CM_EVENT_CONNECT_ERROR:
-	case RDMA_CM_EVENT_UNREACHABLE:
-	case RDMA_CM_EVENT_REJECTED:
-		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
-		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-		break;
-
-	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-	case RDMA_CM_EVENT_DISCONNECTED:
-		/* This happens when we fail the negotiation */
-		if (sc->status == SMBDIRECT_SOCKET_NEGOTIATE_FAILED) {
-			log_rdma_event(ERR, "event=%s during negotiation\n", event_name);
-		}
-
-		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		smbdirect_connection_disconnect_work(&sc->disconnect_work);
-		break;
-
-	default:
-		log_rdma_event(ERR, "unexpected event=%s status=%d\n",
-			       event_name, event->status);
-		break;
-	}
-
-	return 0;
-}
-
-static inline void *smbdirect_send_io_payload(struct smbdirect_send_io *request)
-{
-	return (void *)request->packet;
-}
-
-static inline void *smbdirect_recv_io_payload(struct smbdirect_recv_io *response)
-{
-	return (void *)response->packet;
-}
-
-static void dump_smbdirect_negotiate_resp(struct smbdirect_negotiate_resp *resp)
-{
-	log_rdma_event(INFO, "resp message min_version %u max_version %u negotiated_version %u credits_requested %u credits_granted %u status %u max_readwrite_size %u preferred_send_size %u max_receive_size %u max_fragmented_size %u\n",
-		       resp->min_version, resp->max_version,
-		       resp->negotiated_version, resp->credits_requested,
-		       resp->credits_granted, resp->status,
-		       resp->max_readwrite_size, resp->preferred_send_size,
-		       resp->max_receive_size, resp->max_fragmented_size);
-}
-
-/*
- * Process a negotiation response message, according to [MS-SMBD]3.1.5.7
- * response, packet_length: the negotiation response message
- * return value: true if negotiation is a success, false if failed
- */
-static bool process_negotiation_response(
-		struct smbdirect_recv_io *response, int packet_length)
-{
-	struct smbdirect_socket *sc = response->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_negotiate_resp *packet = smbdirect_recv_io_payload(response);
-
-	if (packet_length < sizeof(struct smbdirect_negotiate_resp)) {
-		log_rdma_event(ERR,
-			"error: packet_length=%d\n", packet_length);
-		return false;
-	}
-
-	if (le16_to_cpu(packet->negotiated_version) != SMBDIRECT_V1) {
-		log_rdma_event(ERR, "error: negotiated_version=%x\n",
-			le16_to_cpu(packet->negotiated_version));
-		return false;
-	}
-
-	if (packet->credits_requested == 0) {
-		log_rdma_event(ERR, "error: credits_requested==0\n");
-		return false;
-	}
-	sc->recv_io.credits.target = le16_to_cpu(packet->credits_requested);
-	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
-
-	if (packet->credits_granted == 0) {
-		log_rdma_event(ERR, "error: credits_granted==0\n");
-		return false;
-	}
-	atomic_set(&sc->send_io.lcredits.count, sp->send_credit_target);
-	atomic_set(&sc->send_io.credits.count, le16_to_cpu(packet->credits_granted));
-
-	if (le32_to_cpu(packet->preferred_send_size) > sp->max_recv_size) {
-		log_rdma_event(ERR, "error: preferred_send_size=%d\n",
-			le32_to_cpu(packet->preferred_send_size));
-		return false;
-	}
-	sp->max_recv_size = le32_to_cpu(packet->preferred_send_size);
-
-	if (le32_to_cpu(packet->max_receive_size) < SMBD_MIN_RECEIVE_SIZE) {
-		log_rdma_event(ERR, "error: max_receive_size=%d\n",
-			le32_to_cpu(packet->max_receive_size));
-		return false;
-	}
-	sp->max_send_size = min_t(u32, sp->max_send_size,
-				  le32_to_cpu(packet->max_receive_size));
-
-	if (le32_to_cpu(packet->max_fragmented_size) <
-			SMBD_MIN_FRAGMENTED_SIZE) {
-		log_rdma_event(ERR, "error: max_fragmented_size=%d\n",
-			le32_to_cpu(packet->max_fragmented_size));
-		return false;
-	}
-	sp->max_fragmented_send_size =
-		le32_to_cpu(packet->max_fragmented_size);
-
-
-	sp->max_read_write_size = min_t(u32,
-			le32_to_cpu(packet->max_readwrite_size),
-			sp->max_frmr_depth * PAGE_SIZE);
-	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
-
-	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
-	return true;
-}
-
-/* Called from softirq, when recv is done */
-static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct smbdirect_data_transfer *data_transfer;
-	struct smbdirect_recv_io *response =
-		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
-	struct smbdirect_socket *sc = response->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	u16 old_recv_credit_target;
-	u32 data_offset = 0;
-	u32 data_length = 0;
-	u32 remaining_data_length = 0;
-	bool negotiate_done = false;
-
-	log_rdma_recv(INFO,
-		      "response=0x%p type=%d wc status=%s wc opcode %d byte_len=%d pkey_index=%u\n",
-		      response, sc->recv_io.expected,
-		      ib_wc_status_msg(wc->status), wc->opcode,
-		      wc->byte_len, wc->pkey_index);
-
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
-		if (wc->status != IB_WC_WR_FLUSH_ERR)
-			log_rdma_recv(ERR, "wc->status=%s opcode=%d\n",
-				ib_wc_status_msg(wc->status), wc->opcode);
-		goto error;
-	}
-
-	ib_dma_sync_single_for_cpu(
-		wc->qp->device,
-		response->sge.addr,
-		response->sge.length,
-		DMA_FROM_DEVICE);
-
-	/*
-	 * Reset timer to the keepalive interval in
-	 * order to trigger our next keepalive message.
-	 */
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->keepalive_interval_msec));
-
-	switch (sc->recv_io.expected) {
-	/* SMBD negotiation response */
-	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
-		dump_smbdirect_negotiate_resp(smbdirect_recv_io_payload(response));
-		sc->recv_io.reassembly.full_packet_received = true;
-		negotiate_done =
-			process_negotiation_response(response, wc->byte_len);
-		smbdirect_connection_put_recv_io(response);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
-		if (!negotiate_done) {
-			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-			smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-		} else {
-			sc->status = SMBDIRECT_SOCKET_CONNECTED;
-			wake_up(&sc->status_wait);
-		}
-
-		return;
-
-	/* SMBD data transfer packet */
-	case SMBDIRECT_EXPECT_DATA_TRANSFER:
-		data_transfer = smbdirect_recv_io_payload(response);
-
-		if (wc->byte_len <
-		    offsetof(struct smbdirect_data_transfer, padding))
-			goto error;
-
-		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
-		data_offset = le32_to_cpu(data_transfer->data_offset);
-		data_length = le32_to_cpu(data_transfer->data_length);
-		if (wc->byte_len < data_offset ||
-		    (u64)wc->byte_len < (u64)data_offset + data_length)
-			goto error;
-
-		if (remaining_data_length > sp->max_fragmented_recv_size ||
-		    data_length > sp->max_fragmented_recv_size ||
-		    (u64)remaining_data_length + (u64)data_length > (u64)sp->max_fragmented_recv_size)
-			goto error;
-
-		if (data_length) {
-			if (sc->recv_io.reassembly.full_packet_received)
-				response->first_segment = true;
-
-			if (le32_to_cpu(data_transfer->remaining_data_length))
-				sc->recv_io.reassembly.full_packet_received = false;
-			else
-				sc->recv_io.reassembly.full_packet_received = true;
-		}
-
-		atomic_dec(&sc->recv_io.posted.count);
-		atomic_dec(&sc->recv_io.credits.count);
-		old_recv_credit_target = sc->recv_io.credits.target;
-		sc->recv_io.credits.target =
-			le16_to_cpu(data_transfer->credits_requested);
-		sc->recv_io.credits.target =
-			min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
-		sc->recv_io.credits.target =
-			max_t(u16, sc->recv_io.credits.target, 1);
-		if (le16_to_cpu(data_transfer->credits_granted)) {
-			atomic_add(le16_to_cpu(data_transfer->credits_granted),
-				&sc->send_io.credits.count);
-			/*
-			 * We have new send credits granted from remote peer
-			 * If any sender is waiting for credits, unblock it
-			 */
-			wake_up(&sc->send_io.credits.wait_queue);
-		}
-
-		log_incoming(INFO, "data flags %d data_offset %d data_length %d remaining_data_length %d\n",
-			     le16_to_cpu(data_transfer->flags),
-			     le32_to_cpu(data_transfer->data_offset),
-			     le32_to_cpu(data_transfer->data_length),
-			     le32_to_cpu(data_transfer->remaining_data_length));
-
-		/* Send an immediate response right away if requested */
-		if (le16_to_cpu(data_transfer->flags) &
-				SMBDIRECT_FLAG_RESPONSE_REQUESTED) {
-			log_keep_alive(INFO, "schedule send of immediate response\n");
-			queue_work(sc->workqueue, &sc->idle.immediate_work);
-		}
-
-		/*
-		 * If this is a packet with data playload place the data in
-		 * reassembly queue and wake up the reading thread
-		 */
-		if (data_length) {
-			if (sc->recv_io.credits.target > old_recv_credit_target)
-				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
-
-			smbdirect_connection_reassembly_append_recv_io(sc, response, data_length);
-			wake_up(&sc->recv_io.reassembly.wait_queue);
-		} else
-			smbdirect_connection_put_recv_io(response);
-
-		return;
-
-	case SMBDIRECT_EXPECT_NEGOTIATE_REQ:
-		/* Only server... */
-		break;
-	}
-
-	/*
-	 * This is an internal error!
-	 */
-	log_rdma_recv(ERR, "unexpected response type=%d\n", sc->recv_io.expected);
-	WARN_ON_ONCE(sc->recv_io.expected != SMBDIRECT_EXPECT_DATA_TRANSFER);
-error:
-	smbdirect_connection_put_recv_io(response);
-	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-}
-
-static struct rdma_cm_id *smbd_create_id(
-		struct smbdirect_socket *sc,
-		struct sockaddr *dstaddr, int port)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct rdma_cm_id *id;
-	int rc;
-	__be16 *sport;
-
-	id = rdma_create_id(&init_net, smbd_conn_upcall, sc,
-		RDMA_PS_TCP, IB_QPT_RC);
-	if (IS_ERR(id)) {
-		rc = PTR_ERR(id);
-		log_rdma_event(ERR, "rdma_create_id() failed %i\n", rc);
-		return id;
-	}
-
-	if (dstaddr->sa_family == AF_INET6)
-		sport = &((struct sockaddr_in6 *)dstaddr)->sin6_port;
-	else
-		sport = &((struct sockaddr_in *)dstaddr)->sin_port;
-
-	*sport = htons(port);
-
-	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED);
-	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
-	rc = rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
-		sp->resolve_addr_timeout_msec);
-	if (rc) {
-		log_rdma_event(ERR, "rdma_resolve_addr() failed %i\n", rc);
-		goto out;
-	}
-	rc = wait_event_interruptible_timeout(
-		sc->status_wait,
-		sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
-		msecs_to_jiffies(sp->resolve_addr_timeout_msec));
-	/* e.g. if interrupted returns -ERESTARTSYS */
-	if (rc < 0) {
-		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
-		goto out;
-	}
-	if (sc->status == SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING) {
-		rc = -ETIMEDOUT;
-		log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
-		goto out;
-	}
-	if (sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED) {
-		rc = -EHOSTUNREACH;
-		log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
-		goto out;
-	}
-
-	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED);
-	sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
-	rc = rdma_resolve_route(id, sp->resolve_route_timeout_msec);
-	if (rc) {
-		log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
-		goto out;
-	}
-	rc = wait_event_interruptible_timeout(
-		sc->status_wait,
-		sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
-		msecs_to_jiffies(sp->resolve_route_timeout_msec));
-	/* e.g. if interrupted returns -ERESTARTSYS */
-	if (rc < 0)  {
-		log_rdma_event(ERR, "rdma_resolve_addr timeout rc: %i\n", rc);
-		goto out;
-	}
-	if (sc->status == SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING) {
-		rc = -ETIMEDOUT;
-		log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);
-		goto out;
-	}
-	if (sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED) {
-		rc = -ENETUNREACH;
-		log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);
-		goto out;
-	}
-
-	return id;
-
-out:
-	rdma_destroy_id(id);
-	return ERR_PTR(rc);
-}
-
-static int smbd_ia_open(
-		struct smbdirect_socket *sc,
-		struct sockaddr *dstaddr, int port)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int rc;
-
-	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
-	sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
-
-	sc->rdma.cm_id = smbd_create_id(sc, dstaddr, port);
-	if (IS_ERR(sc->rdma.cm_id)) {
-		rc = PTR_ERR(sc->rdma.cm_id);
-		goto out1;
-	}
-	sc->ib.dev = sc->rdma.cm_id->device;
-
-	if (!smbdirect_frwr_is_supported(&sc->ib.dev->attrs)) {
-		log_rdma_event(ERR, "Fast Registration Work Requests (FRWR) is not supported\n");
-		log_rdma_event(ERR, "Device capability flags = %llx max_fast_reg_page_list_len = %u\n",
-			       sc->ib.dev->attrs.device_cap_flags,
-			       sc->ib.dev->attrs.max_fast_reg_page_list_len);
-		rc = -EPROTONOSUPPORT;
-		goto out2;
-	}
-	sp->max_frmr_depth = min_t(u32,
-		sp->max_frmr_depth,
-		sc->ib.dev->attrs.max_fast_reg_page_list_len);
-	sc->mr_io.type = IB_MR_TYPE_MEM_REG;
-	if (sc->ib.dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
-		sc->mr_io.type = IB_MR_TYPE_SG_GAPS;
-
-	return 0;
-
-out2:
-	rdma_destroy_id(sc->rdma.cm_id);
-	sc->rdma.cm_id = NULL;
-
-out1:
-	return rc;
-}
-
-/*
- * Send a negotiation request message to the peer
- * The negotiation procedure is in [MS-SMBD] 3.1.5.2 and 3.1.5.3
- * After negotiation, the transport is connected and ready for
- * carrying upper layer SMB payload
- */
-static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_send_wr send_wr;
-	int rc;
-	struct smbdirect_send_io *request;
-	struct smbdirect_negotiate_req *packet;
-
-	request = smbdirect_connection_alloc_send_io(sc);
-	if (IS_ERR(request))
-		return PTR_ERR(request);
-
-	packet = smbdirect_send_io_payload(request);
-	packet->min_version = cpu_to_le16(SMBDIRECT_V1);
-	packet->max_version = cpu_to_le16(SMBDIRECT_V1);
-	packet->reserved = 0;
-	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->preferred_send_size = cpu_to_le32(sp->max_send_size);
-	packet->max_receive_size = cpu_to_le32(sp->max_recv_size);
-	packet->max_fragmented_size =
-		cpu_to_le32(sp->max_fragmented_recv_size);
-
-	request->sge[0].addr = ib_dma_map_single(
-				sc->ib.dev, (void *)packet,
-				sizeof(*packet), DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(sc->ib.dev, request->sge[0].addr)) {
-		rc = -EIO;
-		goto dma_mapping_failed;
-	}
-
-	request->sge[0].length = sizeof(*packet);
-	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
-	request->num_sge = 1;
-
-	ib_dma_sync_single_for_device(
-		sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
-
-	request->cqe.done = smbdirect_connection_send_io_done;
-
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
-
-	log_rdma_send(INFO, "sge addr=0x%llx length=%u lkey=0x%x\n",
-		request->sge[0].addr,
-		request->sge[0].length, request->sge[0].lkey);
-
-	atomic_inc(&sc->send_io.pending.count);
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
-	if (!rc)
-		return 0;
-
-	/* if we reach here, post send failed */
-	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-	atomic_dec(&sc->send_io.pending.count);
-
-	smbdirect_connection_schedule_disconnect(sc, rc);
-
-dma_mapping_failed:
-	smbdirect_connection_free_send_io(request);
-	return rc;
-}
-
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
 				    u32 remaining_data_length)
@@ -757,49 +192,6 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	return bytes;
 }
 
-/* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
-static int smbd_negotiate(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int rc;
-	struct smbdirect_recv_io *response = smbdirect_connection_get_recv_io(sc);
-
-	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
-	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
-
-	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
-	rc = smbdirect_connection_post_recv_io(response);
-	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
-		       rc, response->sge.addr,
-		       response->sge.length, response->sge.lkey);
-	if (rc) {
-		smbdirect_connection_put_recv_io(response);
-		return rc;
-	}
-
-	rc = smbd_post_send_negotiate_req(sc);
-	if (rc)
-		return rc;
-
-	rc = wait_event_interruptible_timeout(
-		sc->status_wait,
-		sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
-		msecs_to_jiffies(sp->negotiate_timeout_msec));
-	log_rdma_event(INFO, "wait_event_interruptible_timeout rc=%d\n", rc);
-
-	if (sc->status == SMBDIRECT_SOCKET_CONNECTED)
-		return 0;
-
-	if (rc == 0)
-		rc = -ETIMEDOUT;
-	else if (rc == -ERESTARTSYS)
-		rc = -EINTR;
-	else
-		rc = -ENOTCONN;
-
-	return rc;
-}
-
 /*
  * Destroy the transport and related RDMA and memory resources
  * Need to go through all the pending counters and make sure on one is using
@@ -818,7 +210,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	smbdirect_connection_destroy_sync(sc);
 
-	destroy_workqueue(sc->workqueue);
+	destroy_workqueue(info->workqueue);
 	kfree(info);
 	server->smbd_conn = NULL;
 }
@@ -840,10 +232,8 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	 * This is possible if transport is disconnected and we haven't received
 	 * notification from RDMA, but upper layer has detected timeout
 	 */
-	if (server->smbd_conn->socket.status == SMBDIRECT_SOCKET_CONNECTED) {
-		log_rdma_event(INFO, "disconnecting transport\n");
-		smbd_destroy(server);
-	}
+	log_rdma_event(INFO, "disconnecting transport\n");
+	smbd_destroy(server);
 
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
@@ -863,18 +253,14 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 static struct smbd_connection *_smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
 {
-	int rc;
+	struct net *net = cifs_net_ns(server);
 	struct smbd_connection *info;
 	struct smbdirect_socket *sc;
 	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
-	struct rdma_conn_param conn_param;
-	struct sockaddr_in *addr_in = (struct sockaddr_in *) dstaddr;
-	struct ib_port_immutable port_immutable;
-	__be32 ird_ord_hdr[2];
+	__be16 *sport;
 	char wq_name[80];
-	struct workqueue_struct *workqueue;
-	struct smbdirect_recv_io *recv_io;
+	int ret;
 
 	/*
 	 * Create the initial parameters
@@ -898,143 +284,64 @@ static struct smbd_connection *_smbd_get_connection(
 	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
 	if (!info)
 		return NULL;
-	sc = &info->socket;
-	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", sc);
-	workqueue = create_workqueue(wq_name);
-	if (!workqueue)
+	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", info);
+	info->workqueue = create_workqueue(wq_name);
+	if (!info->workqueue)
 		goto create_wq_failed;
-	smbdirect_socket_prepare_create(sc, sp, workqueue);
+	sc = &info->socket;
+	ret = smbdirect_socket_init_new(net, sc);
+	if (ret)
+		goto socket_init_failed;
 	smbdirect_socket_set_logging(sc, NULL, smbd_logging_needed, smbd_logging_vaprintf);
-	sc->ib.poll_ctx = IB_POLL_SOFTIRQ;
-	/*
-	 * from here we operate on the copy.
-	 */
-	sp = &sc->parameters;
-
-	rc = smbd_ia_open(sc, dstaddr, port);
-	if (rc) {
-		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
-		goto create_id_failed;
-	}
-
-	sp->responder_resources =
-		min_t(u8, sp->responder_resources,
-		      sc->ib.dev->attrs.max_qp_rd_atom);
-	log_rdma_mr(INFO, "responder_resources=%d\n",
-		sp->responder_resources);
-
-	rc = smbdirect_connection_create_qp(sc);
-	if (rc) {
-		log_rdma_event(ERR, "smbdirect_connection_create_qp failed %i\n", rc);
-		goto create_qp_failed;
-	}
-
-	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = sp->initiator_depth;
-	conn_param.responder_resources = sp->responder_resources;
-
-	/* Need to send IRD/ORD in private data for iWARP */
-	sc->ib.dev->ops.get_port_immutable(
-		sc->ib.dev, sc->rdma.cm_id->port_num, &port_immutable);
-	if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
-		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
-		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);
-		conn_param.private_data = ird_ord_hdr;
-		conn_param.private_data_len = sizeof(ird_ord_hdr);
-	} else {
-		conn_param.private_data = NULL;
-		conn_param.private_data_len = 0;
-	}
-
-	conn_param.retry_count = SMBD_CM_RETRY;
-	conn_param.rnr_retry_count = SMBD_CM_RNR_RETRY;
-	conn_param.flow_control = 0;
-
-	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
-		&addr_in->sin_addr, port);
-
-	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
-	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
-	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
-	if (rc) {
-		log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc);
-		goto rdma_connect_failed;
-	}
-
-	wait_event_interruptible_timeout(
-		sc->status_wait,
-		sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
-		msecs_to_jiffies(sp->rdma_connect_timeout_msec));
-
-	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED) {
-		log_rdma_event(ERR, "rdma_connect failed port=%d\n", port);
-		goto rdma_connect_failed;
-	}
-
-	log_rdma_event(INFO, "rdma_connect connected\n");
-
-	rc = smbdirect_connection_create_mem_pools(sc);
-	if (rc) {
-		log_rdma_event(ERR, "cache allocation failed\n");
-		goto allocate_cache_failed;
-	}
+	ret = smbdirect_socket_set_initial_parameters(sc, sp);
+	if (ret)
+		goto set_params_failed;
+	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_SOFTIRQ, GFP_KERNEL);
+	if (ret)
+		goto set_settings_failed;
+	ret = smbdirect_socket_set_custom_workqueue(sc, info->workqueue);
+	if (ret)
+		goto set_workqueue_failed;
 
-	list_for_each_entry(recv_io, &sc->recv_io.free.list, list)
-		recv_io->cqe.done = recv_done;
-
-	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
-	/*
-	 * start with the negotiate timeout and SMBDIRECT_KEEPALIVE_PENDING
-	 * so that the timer will cause a disconnect.
-	 */
-	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_PENDING;
-	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-			 msecs_to_jiffies(sp->negotiate_timeout_msec));
-
-	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
+	if (dstaddr->sa_family == AF_INET6)
+		sport = &((struct sockaddr_in6 *)dstaddr)->sin6_port;
+	else
+		sport = &((struct sockaddr_in *)dstaddr)->sin_port;
 
-	rc = smbd_negotiate(sc);
-	if (rc) {
-		log_rdma_event(ERR, "smbd_negotiate rc=%d\n", rc);
-		goto negotiation_failed;
-	}
+	*sport = htons(port);
 
-	rc = smbdirect_connection_create_mr_list(sc);
-	if (rc) {
-		log_rdma_mr(ERR, "memory registration allocation failed\n");
-		goto allocate_mr_failed;
+	ret = smbdirect_connect_sync(sc, dstaddr);
+	if (ret) {
+		log_rdma_event(ERR, "smbdirect_connect_sync(%pISpsfc) failed with %d %s\n",
+			       dstaddr, ret, errname(ret));
+		goto connect_failed;
 	}
 
 	return info;
 
-allocate_mr_failed:
+connect_failed:
+set_workqueue_failed:
+set_settings_failed:
+set_params_failed:
 	/* At this point, need to a full transport shutdown */
 	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
-negotiation_failed:
-	disable_delayed_work_sync(&sc->idle.timer_work);
-	smbdirect_connection_destroy_mem_pools(sc);
-	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	rdma_disconnect(sc->rdma.cm_id);
-	wait_event(sc->status_wait,
-		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-
-allocate_cache_failed:
-rdma_connect_failed:
-	smbdirect_connection_destroy_qp(sc);
-
-create_qp_failed:
-	rdma_destroy_id(sc->rdma.cm_id);
-
-create_id_failed:
-	destroy_workqueue(sc->workqueue);
+socket_init_failed:
+	destroy_workqueue(info->workqueue);
 create_wq_failed:
 	kfree(info);
 	return NULL;
 }
 
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
+{
+	struct smbdirect_socket *sc = &conn->socket;
+
+	return smbdirect_socket_get_current_parameters(sc);
+}
+
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
 {
@@ -1053,7 +360,7 @@ struct smbd_connection *smbd_get_connection(
 	if (!ret)
 		return NULL;
 
-	sp = &ret->socket.parameters;
+	sp = smbd_get_parameters(ret);
 
 	server->rdma_readwrite_threshold =
 		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
@@ -1081,6 +388,9 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	struct smbdirect_socket *sc = &info->socket;
 
+	if (!smbdirect_connection_is_connected(sc))
+		return -ENOTCONN;
+
 	return smbdirect_connection_recvmsg(sc, msg, 0);
 }
 
@@ -1095,14 +405,14 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = &info->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	unsigned int remaining_data_length, klen;
 	int rc, i, rqst_idx;
 	int error = 0;
 
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+	if (!smbdirect_connection_is_connected(sc))
 		return -EAGAIN;
 
 	/*
@@ -1192,6 +502,9 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 {
 	struct smbdirect_socket *sc = &info->socket;
 
+	if (!smbdirect_connection_is_connected(sc))
+		return NULL;
+
 	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
 }
 
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 7986e87bf384..3f623a37aedc 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -38,6 +38,7 @@ extern int smbd_receive_credit_max;
  */
 struct smbd_connection {
 	struct smbdirect_socket socket;
+	struct workqueue_struct *workqueue;
 };
 
 /* Create a SMBDirect session */
-- 
2.43.0

