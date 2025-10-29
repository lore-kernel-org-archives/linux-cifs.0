Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3892D23BC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744411; cv=none; b=IvnPX01UvawOpXg4GtrVVKJaK1yrOZdn9KX03olLgLiTN3BYwKysZbKvzDvR5WG7zUJwQWQUWZNLn0Ualj3TJlwfI8nNfSlnGsUpn/DvXbmWXxu2qeiMTG5Rh33tYBc4e8Z0AzgD+3NtrR+SOL3DmKFgfMxcwv/2oeDSA4SrV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744411; c=relaxed/simple;
	bh=+ixDmoiNyJxKL9xJNBL0SMOeWtAjcaR61rRfyfL3h9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOQ4nnhX8xFucq1fnbVciCAR89NFpxenqpFGPVLRkncQtv08ECoa9P6yNUd2wV9avDmi29PA2k6dSwnQzhTdNlFY250p/rdtNNH54WSCmo6wWXK5jVbiFczN/0FNOG7ZbzuiFBAV499ZN2KEv5gBSov29lGBcCl9jaPoX3Hwk9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nT6YL1+5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nT6YL1+5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=V6WW9+8oFW2mMprJbZddgqMFsI8UKSNSzqDGgOC3xLs=; b=nT6YL1+5zFkT8jJHv5gYS7/0+C
	pZtBaI2sGJD8QR8UTIuECzYMxqpgWvnCkxsm8jMRewhRQ7hNXmfeFNI166EMe9ObjkNrgU6QIyAgP
	iOO5LxHTkmiToyqb+PBIBo4gd98qpEvon1bqyG1JqvM2VUMc+JtkdPVKoEQVVMbdiijWkZGnC6ct3
	dYSPZ6aHkeUHGjvOrbYLTiytI6ePsf82D3OBj+7KegGo+lJz7AuPqhNKuQOxT8kAHPH9XftHMog5b
	3IuuMoCETj0gRwBAe43vqOZu3Q2MT53MW8d8zPivDNMVWmc3FmaBPPMMG35PFal8lqcUUoFfwZINE
	7+A8+9Gh4QsChptsCrmOfThNXkbxkcSlaWrQ/I3XizQQASlea5hjx1hbxr7RZ61XBulCOlFb890ot
	Y8r0qZvIOA+ow4ORGSkR60qxaoF5aZJKv/49XbM+CYoVlO51G8TRJxkHh6btzCbgmRGMIdahEfOFC
	xW4+O6s0ggctkS1gqdrQWIEn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6CM-00Bbpq-0K;
	Wed, 29 Oct 2025 13:26:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 043/127] smb: smbdirect: introduce smbdirect_connection_negotiation_done()
Date: Wed, 29 Oct 2025 14:20:21 +0100
Message-ID: <9c0a6bdaa10d2701484b061f25a37b07e43b9083.1761742839.git.metze@samba.org>
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

This will be used by client and server in order to turn the
connection into a usable state.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 47 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index cb977f014c3a..daab8b5eba49 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -23,6 +23,8 @@ static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc
 						     int error);
 static void smbdirect_connection_disconnect_work(struct work_struct *work);
 static void smbdirect_connection_idle_timer_work(struct work_struct *work);
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work);
+static void smbdirect_connection_send_immediate_work(struct work_struct *work);
 
 static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
@@ -216,6 +218,49 @@ static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
+{
+	if (unlikely(sc->first_error))
+		return;
+
+	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
+		/*
+		 * Something went wrong...
+		 */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe local: %pISpsfc remote: %pISpsfc\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			&sc->rdma.cm_id->route.addr.src_addr,
+			&sc->rdma.cm_id->route.addr.dst_addr);
+		return;
+	}
+
+	/*
+	 * We are done, so we can wake up the waiter.
+	 */
+	WARN_ONCE(sc->status == SMBDIRECT_SOCKET_CONNECTED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+	sc->status = SMBDIRECT_SOCKET_CONNECTED;
+
+	/*
+	 * We need to setup the refill and send immediate work
+	 * in order to get a working connection.
+	 */
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
+	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"negotiated: local: %pISpsfc remote: %pISpsfc\n",
+		&sc->rdma.cm_id->route.addr.src_addr,
+		&sc->rdma.cm_id->route.addr.dst_addr);
+
+	wake_up(&sc->status_wait);
+}
+
 static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 				      const struct ib_qp_init_attr *attr)
 {
@@ -1522,7 +1567,6 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -1840,7 +1884,6 @@ static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 	return posted;
 }
 
-__maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

