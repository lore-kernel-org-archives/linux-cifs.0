Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637961632C8
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155055; cv=none; b=aoPdgPBGW+a0OdtxS83sWRQjAP1UJIT7fU7n3LmcRCYDo4DQBRKvY30AqWAZ014LGtbF0DPhPKBdA5agnN0P7opgMyBCtMAR7QubLdyxa5hY1mG3R9iokeKe2LCuaePE+ttHbLvnnyltREgsaAPrHUoQoMMFJmyANarZ2TtuGXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155055; c=relaxed/simple;
	bh=S33E2CCruqK0njI14p1HS0/3Kqkh1d+SiqYZCHAmgRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spy7zmwcY2ux0ziNyXHJQt4c7YaOs0srbs8Pn+TtUytQvRnKY+scRc8iCDrce83RfkO/dzja40tKjoGmuNzE8Ai/JiKYYxaX75ge3HsR4PopzsmE9IAVIJ3RdCLl17yqi3JCeWliAaSb4od6O5aeSz42iCDJmY+M0PTBIoMUvsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=u0LUMWSp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="u0LUMWSp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MbxkYhs+Afm2yTTOmCLSdqffFUHSTvVEjCpyIf1W91A=; b=u0LUMWSpFrwjVtIS5+WL6dJ/yh
	j5PE8J9gTpn4yASZghDG+s+SH2p8EWavaJcsJfWLOv7dVJA1YTM+UTbfOzmCGDy8a19pS+6vyD+YD
	8iLrcYlNzlLartomBKR8rKW1DgVaWytwEUn9fMK/uVVUNFx1CkkQW0rUN6k/l8A6jrNKj82L3VHFM
	tBmAYcao/6nAGCq+sbbYGQigIPufgsZuNi5R5OfwcRLZ6vpk/m10wZN0Gw8p4jeB8GxX6DhcYhGmj
	iiUS9tWTMdQzs2QXZqBTlEiM/r1ZWkR5Vqnk/12PXQ4EkfQ6gv+4yz5cOBfMUtZxEMb6pvQdCJ1AN
	Wi5j4VoA6/sreU+7hECuyyAPRxisS11AMVn4dwOJhcYd70wd4/fS5rmWsn5Yli4So7J7JztDvN9sR
	xawqgRXlE6JblM5NyVa01+9CIY9RZaWa7X4lqd1Ol2MuiC0ls6hLGwgAU1dSZV18EWhl+lbSRYLLN
	CFlsJfSluBrOPA3JoWoqfkzO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe9P-000kyz-2r;
	Mon, 25 Aug 2025 20:50:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 054/142] smb: client: make use of smbdirect_socket.mr_io
Date: Mon, 25 Aug 2025 22:40:15 +0200
Message-ID: <c239e46452545956bc18e3ab1f684a05ef634fb4.1756139607.git.metze@samba.org>
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

Now struct smbd_connection only contains struct smbdirect_socket,
this is an important step towards having common functions as well.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  6 +--
 fs/smb/client/smbdirect.c  | 81 +++++++++++++++++---------------------
 fs/smb/client/smbdirect.h  | 13 ------
 3 files changed, 40 insertions(+), 60 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 060d47ccec2a..69343bf9cf1b 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -485,10 +485,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			"max_frmr_depth: %x mr_type: %x",
 			sp->responder_resources,
 			sp->max_frmr_depth,
-			server->smbd_conn->mr_type);
+			sc->mr_io.type);
 		seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
-			atomic_read(&server->smbd_conn->mr_ready_count),
-			atomic_read(&server->smbd_conn->mr_used_count));
+			atomic_read(&sc->mr_io.ready.count),
+			atomic_read(&sc->mr_io.used.count));
 skip_rdma:
 #endif
 		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index db6e8b5e8352..205fd57272fa 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -169,8 +169,6 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, disconnect_work);
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 
 	/*
 	 * make sure this and other work is not queued again
@@ -179,7 +177,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	 */
 	disable_work(&sc->disconnect_work);
 	disable_work(&sc->recv_io.posted.refill_work);
-	disable_work(&info->mr_recovery_work);
+	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
 
@@ -813,9 +811,9 @@ static int smbd_ia_open(
 	sp->max_frmr_depth = min_t(u32,
 		sp->max_frmr_depth,
 		sc->ib.dev->attrs.max_fast_reg_page_list_len);
-	info->mr_type = IB_MR_TYPE_MEM_REG;
+	sc->mr_io.type = IB_MR_TYPE_MEM_REG;
 	if (sc->ib.dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
-		info->mr_type = IB_MR_TYPE_SG_GAPS;
+		sc->mr_io.type = IB_MR_TYPE_SG_GAPS;
 
 	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
 	if (IS_ERR(sc->ib.pd)) {
@@ -1521,8 +1519,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	 * path when sending data, and then release memory registrations.
 	 */
 	log_rdma_event(INFO, "freeing mr list\n");
-	wake_up_all(&info->wait_mr);
-	while (atomic_read(&info->mr_used_count)) {
+	wake_up_all(&sc->mr_io.ready.wait_queue);
+	while (atomic_read(&sc->mr_io.used.count)) {
 		cifs_server_unlock(server);
 		msleep(1000);
 		cifs_server_lock(server);
@@ -2188,14 +2186,15 @@ static void register_mr_done(struct ib_cq *cq, struct ib_wc *wc)
  */
 static void smbd_mr_recovery_work(struct work_struct *work)
 {
-	struct smbd_connection *info =
-		container_of(work, struct smbd_connection, mr_recovery_work);
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, mr_io.recovery_work);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbd_connection *info =
+		container_of(sc, struct smbd_connection, socket);
 	struct smbdirect_mr_io *smbdirect_mr;
 	int rc;
 
-	list_for_each_entry(smbdirect_mr, &info->mr_list, list) {
+	list_for_each_entry(smbdirect_mr, &sc->mr_io.all.list, list) {
 		if (smbdirect_mr->state == SMBDIRECT_MR_ERROR) {
 
 			/* recover this MR entry */
@@ -2209,11 +2208,11 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 			}
 
 			smbdirect_mr->mr = ib_alloc_mr(
-				sc->ib.pd, info->mr_type,
+				sc->ib.pd, sc->mr_io.type,
 				sp->max_frmr_depth);
 			if (IS_ERR(smbdirect_mr->mr)) {
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
-					    info->mr_type,
+					    sc->mr_io.type,
 					    sp->max_frmr_depth);
 				smbd_disconnect_rdma_connection(info);
 				continue;
@@ -2231,8 +2230,8 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 		 * value is updated before waking up any calls to
 		 * get_mr() from the I/O issuing CPUs
 		 */
-		if (atomic_inc_return(&info->mr_ready_count) == 1)
-			wake_up(&info->wait_mr);
+		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
+			wake_up(&sc->mr_io.ready.wait_queue);
 	}
 }
 
@@ -2241,8 +2240,8 @@ static void destroy_mr_list(struct smbd_connection *info)
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_mr_io *mr, *tmp;
 
-	disable_work_sync(&info->mr_recovery_work);
-	list_for_each_entry_safe(mr, tmp, &info->mr_list, list) {
+	disable_work_sync(&sc->mr_io.recovery_work);
+	list_for_each_entry_safe(mr, tmp, &sc->mr_io.all.list, list) {
 		if (mr->state == SMBDIRECT_MR_INVALIDATED)
 			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl,
 				mr->sgt.nents, mr->dir);
@@ -2266,13 +2265,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 	int i;
 	struct smbdirect_mr_io *smbdirect_mr, *tmp;
 
-	INIT_LIST_HEAD(&info->mr_list);
-	init_waitqueue_head(&info->wait_mr);
-	spin_lock_init(&info->mr_list_lock);
-	atomic_set(&info->mr_ready_count, 0);
-	atomic_set(&info->mr_used_count, 0);
-	init_waitqueue_head(&info->wait_for_mr_cleanup);
-	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
+	INIT_WORK(&sc->mr_io.recovery_work, smbd_mr_recovery_work);
 
 	if (sp->responder_resources == 0) {
 		log_rdma_mr(ERR, "responder_resources negotiated as 0\n");
@@ -2284,11 +2277,11 @@ static int allocate_mr_list(struct smbd_connection *info)
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
 		if (!smbdirect_mr)
 			goto cleanup_entries;
-		smbdirect_mr->mr = ib_alloc_mr(sc->ib.pd, info->mr_type,
+		smbdirect_mr->mr = ib_alloc_mr(sc->ib.pd, sc->mr_io.type,
 					sp->max_frmr_depth);
 		if (IS_ERR(smbdirect_mr->mr)) {
 			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
-				    info->mr_type, sp->max_frmr_depth);
+				    sc->mr_io.type, sp->max_frmr_depth);
 			goto out;
 		}
 		smbdirect_mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
@@ -2302,15 +2295,15 @@ static int allocate_mr_list(struct smbd_connection *info)
 		smbdirect_mr->state = SMBDIRECT_MR_READY;
 		smbdirect_mr->socket = sc;
 
-		list_add_tail(&smbdirect_mr->list, &info->mr_list);
-		atomic_inc(&info->mr_ready_count);
+		list_add_tail(&smbdirect_mr->list, &sc->mr_io.all.list);
+		atomic_inc(&sc->mr_io.ready.count);
 	}
 	return 0;
 
 out:
 	kfree(smbdirect_mr);
 cleanup_entries:
-	list_for_each_entry_safe(smbdirect_mr, tmp, &info->mr_list, list) {
+	list_for_each_entry_safe(smbdirect_mr, tmp, &sc->mr_io.all.list, list) {
 		list_del(&smbdirect_mr->list);
 		ib_dereg_mr(smbdirect_mr->mr);
 		kfree(smbdirect_mr->sgt.sgl);
@@ -2333,8 +2326,8 @@ static struct smbdirect_mr_io *get_mr(struct smbd_connection *info)
 	struct smbdirect_mr_io *ret;
 	int rc;
 again:
-	rc = wait_event_interruptible(info->wait_mr,
-		atomic_read(&info->mr_ready_count) ||
+	rc = wait_event_interruptible(sc->mr_io.ready.wait_queue,
+		atomic_read(&sc->mr_io.ready.count) ||
 		sc->status != SMBDIRECT_SOCKET_CONNECTED);
 	if (rc) {
 		log_rdma_mr(ERR, "wait_event_interruptible rc=%x\n", rc);
@@ -2346,18 +2339,18 @@ static struct smbdirect_mr_io *get_mr(struct smbd_connection *info)
 		return NULL;
 	}
 
-	spin_lock(&info->mr_list_lock);
-	list_for_each_entry(ret, &info->mr_list, list) {
+	spin_lock(&sc->mr_io.all.lock);
+	list_for_each_entry(ret, &sc->mr_io.all.list, list) {
 		if (ret->state == SMBDIRECT_MR_READY) {
 			ret->state = SMBDIRECT_MR_REGISTERED;
-			spin_unlock(&info->mr_list_lock);
-			atomic_dec(&info->mr_ready_count);
-			atomic_inc(&info->mr_used_count);
+			spin_unlock(&sc->mr_io.all.lock);
+			atomic_dec(&sc->mr_io.ready.count);
+			atomic_inc(&sc->mr_io.used.count);
 			return ret;
 		}
 	}
 
-	spin_unlock(&info->mr_list_lock);
+	spin_unlock(&sc->mr_io.all.lock);
 	/*
 	 * It is possible that we could fail to get MR because other processes may
 	 * try to acquire a MR at the same time. If this is the case, retry it.
@@ -2476,8 +2469,8 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 
 dma_map_error:
 	smbdirect_mr->state = SMBDIRECT_MR_ERROR;
-	if (atomic_dec_and_test(&info->mr_used_count))
-		wake_up(&info->wait_for_mr_cleanup);
+	if (atomic_dec_and_test(&sc->mr_io.used.count))
+		wake_up(&sc->mr_io.cleanup.wait_queue);
 
 	smbd_disconnect_rdma_connection(info);
 
@@ -2545,18 +2538,18 @@ int smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
 			smbdirect_mr->sgt.nents,
 			smbdirect_mr->dir);
 		smbdirect_mr->state = SMBDIRECT_MR_READY;
-		if (atomic_inc_return(&info->mr_ready_count) == 1)
-			wake_up(&info->wait_mr);
+		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
+			wake_up(&sc->mr_io.ready.wait_queue);
 	} else
 		/*
 		 * Schedule the work to do MR recovery for future I/Os MR
 		 * recovery is slow and don't want it to block current I/O
 		 */
-		queue_work(sc->workqueue, &info->mr_recovery_work);
+		queue_work(sc->workqueue, &sc->mr_io.recovery_work);
 
 done:
-	if (atomic_dec_and_test(&info->mr_used_count))
-		wake_up(&info->wait_for_mr_cleanup);
+	if (atomic_dec_and_test(&sc->mr_io.used.count))
+		wake_up(&sc->mr_io.cleanup.wait_queue);
 
 	return rc;
 }
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index c88ba6e11dd1..d67ac5ddaff4 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -38,19 +38,6 @@ extern int smbd_receive_credit_max;
  */
 struct smbd_connection {
 	struct smbdirect_socket socket;
-
-
-	/* Memory registrations */
-	enum ib_mr_type mr_type;
-	struct list_head mr_list;
-	spinlock_t mr_list_lock;
-	/* The number of available MRs ready for memory registration */
-	atomic_t mr_ready_count;
-	atomic_t mr_used_count;
-	wait_queue_head_t wait_mr;
-	struct work_struct mr_recovery_work;
-	/* Used by transport to wait until all MRs are returned */
-	wait_queue_head_t wait_for_mr_cleanup;
 };
 
 /* Create a SMBDirect session */
-- 
2.43.0

