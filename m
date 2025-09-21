Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152FC49620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491202; cv=none; b=fs4Bioi5+H1LuZKuKmJxQXlH+FUYJk9QEmnpvHSWIdt27EqitedRrCEaaraTb1symRuFofSmrDDBAFmmeMffpx5rz98Gdi7bvzXf5P4ddgry7202Wh9/LBIMwcD5rja2qsnveczSdMztOTlKtZqx0MbXJPcym2Q7MD8yltFpLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491202; c=relaxed/simple;
	bh=aZsGPigOxM7mg6WUpY2lAivBF/fM344ZqbpIMqh1Yog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnnzLy2sWe2yyrCHLaucTRgmyQt/ZuBqKtBdeLRJ70DFwBZwMlyIRMVuAE+cRCmxgotDjCY5mcpaGq1lYj64Tqz5uMsq3DuDRwa753IVGNtvrhucI3QcHzStLuufTFIpDyUttvbZt1qim3JMNtzTYF/5cdU+J+AQdmgzoz+khbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wy9KfWiz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wy9KfWiz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QAgou3ftDUWmD4kZL5Jx3dhyC0z8+wfb9pgA7mCZHWs=; b=wy9KfWizES3S7+2U/xZzbTON4p
	HKQDp9XdFURvFJsewXPhOYEMRPrcw64M1IxYfqwUXZgZzbl35J4hCUZoqZKzwNHln0IqK/AWWkp2X
	9dqMa+NccS/vK0xlSjt8+PU8JCYjSEcWg91D3REYWdBciwrg+O7/Y/aMOZ1OhsGIfUZl8sz9Yyb8O
	tNPL5/XlzetX/G4uuMb0dv5oMwMLjEKmQUk0Jg+e3JipQksrrOHtkI0h/GLmQ0ulDsXxtW9bonT84
	pcVKjjfxwhTj0pR9n9M427lezZMJw4J2eYGV9l+3bkrLlnDCf+Z7m+7own04SN93UjFZuamHWhMVE
	HAVoe3LaW4nHFx5MXoRkYRaCtEvlBReXR+etayWa5L7+hBOgnoiXU/EmrzbainUCyPLJwGlxODe0t
	FgMagYO1IdQyCr5y+Px8dcH/2MJK6VhLz/G5qeFe84qZKKcHEb5QZgBF/mPGVvPMJUw62fkrW+Bt8
	Wo+H2/Rr/sKVmSco5/0CWtG2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RtD-005GWZ-1e;
	Sun, 21 Sep 2025 21:46:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 09/18] smb: client: allocate smbdirect workqueue at the beginning of _smbd_get_connection()
Date: Sun, 21 Sep 2025 23:44:56 +0200
Message-ID: <05f221d13c02e1b6a9aa5a116f9d704ae9f74591.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will simplify further changes when moving to common code.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5bc316248058..e6012523e422 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1703,10 +1703,9 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	return -ENOENT;
 }
 
-static void destroy_caches_and_workqueue(struct smbdirect_socket *sc)
+static void destroy_caches(struct smbdirect_socket *sc)
 {
 	destroy_receive_buffers(sc);
-	destroy_workqueue(sc->workqueue);
 	mempool_destroy(sc->recv_io.mem.pool);
 	kmem_cache_destroy(sc->recv_io.mem.cache);
 	mempool_destroy(sc->send_io.mem.pool);
@@ -1714,7 +1713,7 @@ static void destroy_caches_and_workqueue(struct smbdirect_socket *sc)
 }
 
 #define MAX_NAME_LEN	80
-static int allocate_caches_and_workqueue(struct smbdirect_socket *sc)
+static int allocate_caches(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[MAX_NAME_LEN];
@@ -1760,21 +1759,14 @@ static int allocate_caches_and_workqueue(struct smbdirect_socket *sc)
 	if (!sc->recv_io.mem.pool)
 		goto out3;
 
-	scnprintf(name, MAX_NAME_LEN, "smbd_%p", sc);
-	sc->workqueue = create_workqueue(name);
-	if (!sc->workqueue)
-		goto out4;
-
 	rc = allocate_receive_buffers(sc, sp->recv_credit_max);
 	if (rc) {
 		log_rdma_event(ERR, "failed to allocate receive buffers\n");
-		goto out5;
+		goto out4;
 	}
 
 	return 0;
 
-out5:
-	destroy_workqueue(sc->workqueue);
 out4:
 	mempool_destroy(sc->recv_io.mem.pool);
 out3:
@@ -1799,12 +1791,19 @@ static struct smbd_connection *_smbd_get_connection(
 	struct sockaddr_in *addr_in = (struct sockaddr_in *) dstaddr;
 	struct ib_port_immutable port_immutable;
 	__be32 ird_ord_hdr[2];
+	char wq_name[80];
+	struct workqueue_struct *workqueue;
 
 	info = kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);
 	if (!info)
 		return NULL;
 	sc = &info->socket;
+	scnprintf(wq_name, ARRAY_SIZE(wq_name), "smbd_%p", sc);
+	workqueue = create_workqueue(wq_name);
+	if (!workqueue)
+		goto create_wq_failed;
 	smbdirect_socket_init(sc);
+	sc->workqueue = workqueue;
 	sp = &sc->parameters;
 
 	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
@@ -1946,7 +1945,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	log_rdma_event(INFO, "rdma_connect connected\n");
 
-	rc = allocate_caches_and_workqueue(sc);
+	rc = allocate_caches(sc);
 	if (rc) {
 		log_rdma_event(ERR, "cache allocation failed\n");
 		goto allocate_cache_failed;
@@ -1986,7 +1985,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 negotiation_failed:
 	disable_delayed_work_sync(&sc->idle.timer_work);
-	destroy_caches_and_workqueue(sc);
+	destroy_caches(sc);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(sc->status_wait,
@@ -2008,6 +2007,8 @@ static struct smbd_connection *_smbd_get_connection(
 	rdma_destroy_id(sc->rdma.cm_id);
 
 create_id_failed:
+	destroy_workqueue(sc->workqueue);
+create_wq_failed:
 	kfree(info);
 	return NULL;
 }
-- 
2.43.0

