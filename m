Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A753246F0
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080547; cv=none; b=oHCPSQwwm6UULwdLxc9F8rz38+g/QRgYpbHonQktr5s1HWpLOJNbMY5wreJerizFNXdudl6L6Eht1W1aIOqaKHeR4fiFlOpzpdSKMeT9RrmLvZ/AQwc9D1Lo+BBrKt/GbW/JdlqOXX/wwQkEih4XWg1JBn/VEk4/Ho/hGHEk1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080547; c=relaxed/simple;
	bh=TdbutTI7C0tq6G+sJucUPu/PzOgtd2NSPp8Nk0d+O7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj7Y84ydW7zNs4m8NHEYaAUd5V12V1SioB+tuXAWRaUvAez42izsOZjLqgm1FQ6ttbqjRVrBJugZRqztfKy0oC1vYSJX3z7mjBM9BQ0zLWBTZa7SO5OawHIW0EpCf/y071vHarfTQeL/oOBBa3OxIYNT74Rn7qDCDmdoUWk47bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=f/hfujGu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="f/hfujGu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ckxi+Ny6Ssn+nYf4B+DC4jJuzF+9RijXAfEiulV6/fc=; b=f/hfujGuOo18/8CyHkWp5Bngvu
	ch1SouJpzEyOEbSyHOdZPQ1K8MEeewUSiwHus2Fi51CbrVWGFOMca2tH7PAr3yA91SxfQ6eVXz5ty
	pC1A2mFPfRUpdgLgKqscwbFzglthq+D5qWKSG8jCntDWlyZQWtv+5aaXyIlU28kSrUXuVQXI3jGJ0
	SUMuWFlOKtIEY9SBIDW2OTU4UP+Cm3zHkA64F5iNI/h4/mW59odk9RmgCi7Pl2Z0LEjfnvtGMR2K7
	keNEO/9fCb+Br+TEw0vuflIF+VEEnC45fPHIZoxFqpuIisAq3x/uzMdG+4z3MmYOLz2rr7O+j+Vn7
	hIusIPvzXbtiRoahxnwvbag/hnK28kYeRBKT0rLkp1VcyaR1KYlKutJX+vUz2HOe3KEftT3ixgs/B
	7SeXzaQ1+/m7Xoj+AuaZ2zBLJyBHrn79hysmJ1Mxad2TkG/RCr8QGXr8jKWLgf5A4AD7hmSW/Cc01
	fEfCVrp8zBasFEYwLOCy5S+q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNtvz-00Fatr-01;
	Tue, 25 Nov 2025 14:22:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH v3 4/4] smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done() and smbd_conn_upcall()
Date: Tue, 25 Nov 2025 15:21:54 +0100
Message-ID: <e4daffdf71686facd6aeaa87534584ae33f7a712.1764080338.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764080338.git.metze@samba.org>
References: <cover.1764080338.git.metze@samba.org>
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
the server. And there it was already very useful in order
to find the problem when we have a meaningful WARN_ONCE()
that prints details about the connection.

This is much more useful:

[  309.560973] expected[NEGOTIATE_NEEDED] != RDMA_CONNECT_RUNNING
first_error=0 local=192.168.0.200:445 remote=192.168.0.100:60445
[  309.561034] WARNING: CPU: 2 PID: 78 at transport_rdma.c:643
recv_done+0x2fa/0x3d0 [ksmbd]

than what we had before (only):

[  894.140316] WARNING: CPU: 1 PID: 116 at
fs/smb/server/transport_rdma.c:642 recv_done+0x308/0x360 [ksmbd]

Fixes: 58dfba8a2d4e ("smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more detailed states")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c6c428c2e08d..788a0670c4a8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
+#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smbd_disconnect_rdma_connection(__sc)
 #include "../common/smbdirect/smbdirect_pdu.h"
 #include "smbdirect.h"
 #include "cifs_debug.h"
@@ -186,6 +187,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
 
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	/*
 	 * make sure this and other work is not queued again
 	 * but here we don't block and avoid
@@ -197,9 +201,6 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
 
-	if (sc->first_error == 0)
-		sc->first_error = -ECONNABORTED;
-
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
@@ -242,6 +243,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 
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

