Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783542D5957
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764016946; cv=none; b=n8ct+pm0ipDIfOh0rkVDv5ZVHFENC6Llt/HR6RMKUnR+M9w/cr5WFQzmZv88RNi1OPOe4cNe+JXmBtfwUjfWO4M4TQhn1CNqQ45P6feg776bDYHFo5TO7Kxd2LTme+7KKOy3sqId91ygDvIIyUXXTgFIeoaZ91ZD1j7lzBMJxxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764016946; c=relaxed/simple;
	bh=5ECjDb/5k+vK6mbHMjkyF0TqD3sf4sONRzJdt9xzqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyMoe2kW2PXhDY27+x/RSinvM7RG2gtxZRKmzxAHdeht5o+b/V/6uOraYao/7ArXsabdgFRoy/IE3pc4qTGjt4S1iSXAAs1sqTPF+JzIndhn9E6lNhdCz8pBJu6DnIVBRqiR3o/F8XXqWOBax17y8UB08qZ9XlDEmtwhLoACk3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dq9jEMWs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dq9jEMWs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=XELbXaTPcjg7+L6ZX0pKWH/1KECuCVBKSK+p9ghQvPE=; b=dq9jEMWsW4asklurBIziWTJem8
	GV/sWYQabO7vFN1l1kMgYv4VrolKqOvdQOlJtymjlYUKoBo+bWYVPp5wKYOyMudvx//Qg8k8q4ZJC
	lWAmI/Ltosb8oEYnv91yEpNFmPbjvA9uqeii2vkUnc/z8JFpMZFj+Qkcs0QsEZHzFwn7K57ckO90e
	Ht4bPRE5xY7Wa/410slLrMTZ8neMdKbvaW9YLygptnLLYl4KxcB9Ijy8+sTNFPj7a3/+sXHu4Y2fQ
	MEDMNmUZyYFPnBLdZDHQ63hVbkC82cXwMo8ghKwfA07/lVSMCtEG2A4wn7E1KRGkWijeQL05shvJc
	LEslKEzwprsYuXFzTk6ToqNNhjRak1G9jqsWRqEs+uIpu3RR4T/FqXO5qJhD+l8UZd2B2wPooQ10y
	Qt9uTtNgKc0p4rRgwGdXLUpW8h0NvXZxyILiRCAffFn/3hwvRn3Ux2aXppHNiR/A5iTMrcrA8eqz9
	/DrqkOefaA0blUNMAFU3yg3S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNdO9-00FSX2-2R;
	Mon, 24 Nov 2025 20:42:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/4] smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done() and smbd_conn_upcall()
Date: Mon, 24 Nov 2025 21:41:47 +0100
Message-ID: <ee3c63c225df40d542f85205f983ae4cd70a7182.1764016346.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764016346.git.metze@samba.org>
References: <cover.1764016346.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sc->first_error might already be set and sc->status
is thus unexpected, so this should avoid the WARN[_ON]_ONCE()
if sc->first_error is already set and have a usable error path.

While there set sc->first_error as soon as possible.

This is done based on a problem seen in similar places on
the server.

Fixes: 58dfba8a2d4e ("smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c6c428c2e08d..9ee8d1048284 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -186,6 +186,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
 
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	/*
 	 * make sure this and other work is not queued again
 	 * but here we don't block and avoid
@@ -197,9 +200,6 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
 
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
@@ -240,8 +240,12 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	smbd_disconnect_wake_up_all(sc);
 }
 
+#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smbd_disconnect_rdma_connection(__sc)
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	/*
 	 * make sure other work (than disconnect_work) is
 	 * not queued again but here we don't block and avoid
@@ -252,9 +256,6 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
 
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
 	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
@@ -322,27 +323,27 @@ static int smbd_conn_upcall(
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING))
+			break;
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
 		wake_up(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING))
+			break;
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
 		wake_up(&sc->status_wait);
 		break;
 
 	case RDMA_CM_EVENT_ADDR_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
 		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
 		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
@@ -428,7 +429,8 @@ static int smbd_conn_upcall(
 					min_t(u8, sp->responder_resources,
 					      peer_responder_resources);
 
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
+		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING))
+			break;
 		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
 		wake_up(&sc->status_wait);
 		break;
@@ -437,7 +439,6 @@ static int smbd_conn_upcall(
 	case RDMA_CM_EVENT_UNREACHABLE:
 	case RDMA_CM_EVENT_REJECTED:
 		log_rdma_event(ERR, "connecting failed event=%s\n", event_name);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING);
 		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
 		smbd_disconnect_rdma_work(&sc->disconnect_work);
 		break;
@@ -699,7 +700,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
 		put_receive_buffer(sc, response);
-		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
+		if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_NEGOTIATE_RUNNING))
+			negotiate_done = false;
 		if (!negotiate_done) {
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 			smbd_disconnect_rdma_connection(sc);
-- 
2.43.0

