Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000C224677C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744602; cv=none; b=plyiXj4QcUtce+e7s7hgJ8Ca7DDzcLts66jxaEMyzA9QkpsRZLdlF9NGubXT1emekNC0/9IlchhPlYwoO/0CrqaKyZcYCtxAYkzGmQoA9UaUgbEgamPIFPANku64Vdzg4+oiTJW+XMQdwyVGx4LPcKXaDfnzdnBAYqv8lIWRZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744602; c=relaxed/simple;
	bh=L4tkqQO0waxq4mP8cWnVrvBfY/g0lekvcKsLqngHF4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEtUYBV5I9qvLibO8/b6liGge6dXavvtLHPuPN5t5VWYUUSQDV1CxHZES6QCuRaUvOlQfZbYGsbuMHZEdhphRZayThie66Qx7TVCxTfnTwR/io2n39HOOlDWezVADQqOeb8GH9apSWZpQGJwZAarYvZLyRw503fxPhbVxt0Fth4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aXfby+j7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aXfby+j7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6rhN0AdFwwfnhaLPTmP4QCHGWUa1+KG69Xt4v9PpNUs=; b=aXfby+j7R2WMg8r7nWeeScTa5j
	CX82Z1R27jL4mgK+H70rC31AZrryIcW9R6F5u74xavnb8p+Qa4u7iPkT+gQKUiWlKzXKIYBOc9TNr
	hPAdAox1lUjsd6CSbTe7TuHP+g3g+O063tZjFexwnTxxSy6L4BkOBiKcp9Eirmb8J3bNZrOxg28hP
	Mine2KLVUNTTHL9sXgH9Uxe5fItsrOBp/SBacBJsnh/R8TSDNPA7hCRlPtA5MYcJiEeLmrBgOihqj
	lA6upTzxBa60HsXgceM2DELvV2HNBQ+qHok6stYWb52gcwBRABkG1T0uHEJEfVYS5GN1Lp7Z7Q0sT
	1ReESq1X4/bk8XOM9cnSUZclFxJ0OsoPLQHnIApLQQjNhcfORXhJURn+YyBntc0uGVbbi7rBOvZNm
	rgh7CcFGWXfwpifOo7esYK21G2IlSnrWX6eDMV7HF2IMPEDaNFPlC0X/fX/VJJpiYZdM1NMjZoBDQ
	kFROeVNRfcAS4as6txAQ/YgF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6FQ-00BcKP-25;
	Wed, 29 Oct 2025 13:29:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 076/127] smb: client: make use of functions from smbdirect_mr.c
Date: Wed, 29 Oct 2025 14:20:54 +0100
Message-ID: <629c092f9f86c7f0ea6226d974ca7f30269d01dc.1761742839.git.metze@samba.org>
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

The copied code only got new names, some indentation/formatting changes,
some variable names are changed too.

They also only use struct smbdirect_socket instead of
struct smbd_connection.

But the logic is still the same.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 496 +-------------------------------------
 1 file changed, 4 insertions(+), 492 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 41149203e4ff..0e393f6ab835 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -25,9 +25,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 
 static int smbd_post_send_empty(struct smbdirect_socket *sc);
 
-static void destroy_mr_list(struct smbdirect_socket *sc);
-static int allocate_mr_list(struct smbdirect_socket *sc);
-
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
 #define SMBD_PORT	5445
@@ -1137,7 +1134,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->recv_io.reassembly.data_length = 0;
 
 	log_rdma_event(INFO, "freeing mr list\n");
-	destroy_mr_list(sc);
+	smbdirect_connection_destroy_mr_list(sc);
 
 	log_rdma_event(INFO, "destroying qp\n");
 	smbdirect_connection_destroy_qp(sc);
@@ -1330,7 +1327,7 @@ static struct smbd_connection *_smbd_get_connection(
 		goto negotiation_failed;
 	}
 
-	rc = allocate_mr_list(sc);
+	rc = smbdirect_connection_create_mr_list(sc);
 	if (rc) {
 		log_rdma_mr(ERR, "memory registration allocation failed\n");
 		goto allocate_mr_failed;
@@ -1633,292 +1630,6 @@ int smbd_send(struct TCP_Server_Info *server,
 	return rc;
 }
 
-static void register_mr_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct smbdirect_mr_io *mr =
-		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
-	struct smbdirect_socket *sc = mr->socket;
-
-	if (wc->status) {
-		log_rdma_mr(ERR, "status=%d\n", wc->status);
-		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-	}
-}
-
-/*
- * The work queue function that recovers MRs
- * We need to call ib_dereg_mr() and ib_alloc_mr() before this MR can be used
- * again. Both calls are slow, so finish them in a workqueue. This will not
- * block I/O path.
- * There is one workqueue that recovers MRs, there is no need to lock as the
- * I/O requests calling smbd_register_mr will never update the links in the
- * mr_list.
- */
-static void smbd_mr_recovery_work(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, mr_io.recovery_work);
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_mr_io *smbdirect_mr;
-	int rc;
-
-	list_for_each_entry(smbdirect_mr, &sc->mr_io.all.list, list) {
-		if (smbdirect_mr->state == SMBDIRECT_MR_ERROR) {
-
-			/* recover this MR entry */
-			rc = ib_dereg_mr(smbdirect_mr->mr);
-			if (rc) {
-				log_rdma_mr(ERR,
-					"ib_dereg_mr failed rc=%x\n",
-					rc);
-				smbdirect_connection_schedule_disconnect(sc, rc);
-				continue;
-			}
-
-			smbdirect_mr->mr = ib_alloc_mr(
-				sc->ib.pd, sc->mr_io.type,
-				sp->max_frmr_depth);
-			if (IS_ERR(smbdirect_mr->mr)) {
-				rc = PTR_ERR(smbdirect_mr->mr);
-				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
-					    sc->mr_io.type,
-					    sp->max_frmr_depth);
-				smbdirect_connection_schedule_disconnect(sc, rc);
-				continue;
-			}
-		} else
-			/* This MR is being used, don't recover it */
-			continue;
-
-		smbdirect_mr->state = SMBDIRECT_MR_READY;
-
-		/* smbdirect_mr->state is updated by this function
-		 * and is read and updated by I/O issuing CPUs trying
-		 * to get a MR, the call to atomic_inc_return
-		 * implicates a memory barrier and guarantees this
-		 * value is updated before waking up any calls to
-		 * get_mr() from the I/O issuing CPUs
-		 */
-		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
-			wake_up(&sc->mr_io.ready.wait_queue);
-	}
-}
-
-static void smbd_mr_disable_locked(struct smbdirect_mr_io *mr)
-{
-	struct smbdirect_socket *sc = mr->socket;
-
-	lockdep_assert_held(&mr->mutex);
-
-	if (mr->state == SMBDIRECT_MR_DISABLED)
-		return;
-
-	if (mr->mr)
-		ib_dereg_mr(mr->mr);
-	if (mr->sgt.nents)
-		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	kfree(mr->sgt.sgl);
-
-	mr->mr = NULL;
-	mr->sgt.sgl = NULL;
-	mr->sgt.nents = 0;
-
-	mr->state = SMBDIRECT_MR_DISABLED;
-}
-
-static void smbd_mr_free_locked(struct kref *kref)
-{
-	struct smbdirect_mr_io *mr =
-		container_of(kref, struct smbdirect_mr_io, kref);
-
-	lockdep_assert_held(&mr->mutex);
-
-	/*
-	 * smbd_mr_disable_locked() should already be called!
-	 */
-	if (WARN_ON_ONCE(mr->state != SMBDIRECT_MR_DISABLED))
-		smbd_mr_disable_locked(mr);
-
-	mutex_unlock(&mr->mutex);
-	mutex_destroy(&mr->mutex);
-	kfree(mr);
-}
-
-static void destroy_mr_list(struct smbdirect_socket *sc)
-{
-	struct smbdirect_mr_io *mr, *tmp;
-	LIST_HEAD(all_list);
-	unsigned long flags;
-
-	disable_work_sync(&sc->mr_io.recovery_work);
-
-	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
-	list_splice_tail_init(&sc->mr_io.all.list, &all_list);
-	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
-
-	list_for_each_entry_safe(mr, tmp, &all_list, list) {
-		mutex_lock(&mr->mutex);
-
-		smbd_mr_disable_locked(mr);
-		list_del(&mr->list);
-		mr->socket = NULL;
-
-		/*
-		 * No kref_put_mutex() as it's already locked.
-		 *
-		 * If smbd_mr_free_locked() is called
-		 * and the mutex is unlocked and mr is gone,
-		 * in that case kref_put() returned 1.
-		 *
-		 * If kref_put() returned 0 we know that
-		 * smbd_mr_free_locked() didn't
-		 * run. Not by us nor by anyone else, as we
-		 * still hold the mutex, so we need to unlock.
-		 *
-		 * If the mr is still registered it will
-		 * be dangling (detached from the connection
-		 * waiting for smbd_deregister_mr() to be
-		 * called in order to free the memory.
-		 */
-		if (!kref_put(&mr->kref, smbd_mr_free_locked))
-			mutex_unlock(&mr->mutex);
-	}
-}
-
-/*
- * Allocate MRs used for RDMA read/write
- * The number of MRs will not exceed hardware capability in responder_resources
- * All MRs are kept in mr_list. The MR can be recovered after it's used
- * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
- * as MRs are used and recovered for I/O, but the list links will not change
- */
-static int allocate_mr_list(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_mr_io *mr;
-	int ret;
-	u32 i;
-
-	if (sp->responder_resources == 0) {
-		log_rdma_mr(ERR, "responder_resources negotiated as 0\n");
-		return -EINVAL;
-	}
-
-	/* Allocate more MRs (2x) than hardware responder_resources */
-	for (i = 0; i < sp->responder_resources * 2; i++) {
-		mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-		if (!mr) {
-			ret = -ENOMEM;
-			goto kzalloc_mr_failed;
-		}
-
-		kref_init(&mr->kref);
-		mutex_init(&mr->mutex);
-
-		mr->mr = ib_alloc_mr(sc->ib.pd,
-				     sc->mr_io.type,
-				     sp->max_frmr_depth);
-		if (IS_ERR(mr->mr)) {
-			ret = PTR_ERR(mr->mr);
-			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
-				    sc->mr_io.type, sp->max_frmr_depth);
-			goto ib_alloc_mr_failed;
-		}
-
-		mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
-				      sizeof(struct scatterlist),
-				      GFP_KERNEL);
-		if (!mr->sgt.sgl) {
-			ret = -ENOMEM;
-			log_rdma_mr(ERR, "failed to allocate sgl\n");
-			goto kcalloc_sgl_failed;
-		}
-		mr->state = SMBDIRECT_MR_READY;
-		mr->socket = sc;
-
-		list_add_tail(&mr->list, &sc->mr_io.all.list);
-		atomic_inc(&sc->mr_io.ready.count);
-	}
-
-	INIT_WORK(&sc->mr_io.recovery_work, smbd_mr_recovery_work);
-
-	return 0;
-
-kcalloc_sgl_failed:
-	ib_dereg_mr(mr->mr);
-ib_alloc_mr_failed:
-	mutex_destroy(&mr->mutex);
-	kfree(mr);
-kzalloc_mr_failed:
-	destroy_mr_list(sc);
-	return ret;
-}
-
-/*
- * Get a MR from mr_list. This function waits until there is at least one
- * MR available in the list. It may access the list while the
- * smbd_mr_recovery_work is recovering the MR list. This doesn't need a lock
- * as they never modify the same places. However, there may be several CPUs
- * issuing I/O trying to get MR at the same time, mr_list_lock is used to
- * protect this situation.
- */
-static struct smbdirect_mr_io *get_mr(struct smbdirect_socket *sc)
-{
-	struct smbdirect_mr_io *ret;
-	unsigned long flags;
-	int rc;
-again:
-	rc = wait_event_interruptible(sc->mr_io.ready.wait_queue,
-		atomic_read(&sc->mr_io.ready.count) ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc) {
-		log_rdma_mr(ERR, "wait_event_interruptible rc=%x\n", rc);
-		return NULL;
-	}
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_rdma_mr(ERR, "sc->status=%x\n", sc->status);
-		return NULL;
-	}
-
-	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
-	list_for_each_entry(ret, &sc->mr_io.all.list, list) {
-		if (ret->state == SMBDIRECT_MR_READY) {
-			ret->state = SMBDIRECT_MR_REGISTERED;
-			kref_get(&ret->kref);
-			spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
-			atomic_dec(&sc->mr_io.ready.count);
-			atomic_inc(&sc->mr_io.used.count);
-			return ret;
-		}
-	}
-
-	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
-	/*
-	 * It is possible that we could fail to get MR because other processes may
-	 * try to acquire a MR at the same time. If this is the case, retry it.
-	 */
-	goto again;
-}
-
-/*
- * Transcribe the pages from an iterator into an MR scatterlist.
- */
-static int smbd_iter_to_mr(struct iov_iter *iter,
-			   struct sg_table *sgt,
-			   unsigned int max_sg)
-{
-	int ret;
-
-	memset(sgt->sgl, 0, max_sg * sizeof(struct scatterlist));
-
-	ret = extract_iter_to_sg(iter, iov_iter_count(iter), sgt, max_sg, 0);
-	WARN_ON(ret < 0);
-	if (sgt->nents > 0)
-		sg_mark_end(&sgt->sgl[sgt->nents - 1]);
-	return ret;
-}
-
 /*
  * Register memory for RDMA read/write
  * iter: the buffer to register memory with
@@ -1931,131 +1642,8 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 				 bool writing, bool need_invalidate)
 {
 	struct smbdirect_socket *sc = &info->socket;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_mr_io *mr;
-	int rc, num_pages;
-	struct ib_reg_wr *reg_wr;
-
-	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
-	if (num_pages > sp->max_frmr_depth) {
-		log_rdma_mr(ERR, "num_pages=%d max_frmr_depth=%d\n",
-			num_pages, sp->max_frmr_depth);
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-
-	mr = get_mr(sc);
-	if (!mr) {
-		log_rdma_mr(ERR, "get_mr returning NULL\n");
-		return NULL;
-	}
-
-	mutex_lock(&mr->mutex);
-
-	mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	mr->need_invalidate = need_invalidate;
-	mr->sgt.nents = 0;
-	mr->sgt.orig_nents = 0;
-
-	log_rdma_mr(INFO, "num_pages=0x%x count=0x%zx depth=%u\n",
-		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-	smbd_iter_to_mr(iter, &mr->sgt, sp->max_frmr_depth);
-
-	rc = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	if (!rc) {
-		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
-			    num_pages, mr->dir, rc);
-		goto dma_map_error;
-	}
-
-	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
-	if (rc != mr->sgt.nents) {
-		log_rdma_mr(ERR,
-			    "ib_map_mr_sg failed rc = %d nents = %x\n",
-			    rc, mr->sgt.nents);
-		goto map_mr_error;
-	}
-
-	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
-	reg_wr = &mr->wr;
-	reg_wr->wr.opcode = IB_WR_REG_MR;
-	mr->cqe.done = register_mr_done;
-	reg_wr->wr.wr_cqe = &mr->cqe;
-	reg_wr->wr.num_sge = 0;
-	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
-	reg_wr->mr = mr->mr;
-	reg_wr->key = mr->mr->rkey;
-	reg_wr->access = writing ?
-			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
-			IB_ACCESS_REMOTE_READ;
-
-	/*
-	 * There is no need for waiting for complemtion on ib_post_send
-	 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
-	 * on the next ib_post_send when we actually send I/O to remote peer
-	 */
-	rc = ib_post_send(sc->ib.qp, &reg_wr->wr, NULL);
-	if (!rc) {
-		/*
-		 * get_mr() gave us a reference
-		 * via kref_get(&mr->kref), we keep that and let
-		 * the caller use smbd_deregister_mr()
-		 * to remove it again.
-		 */
-		mutex_unlock(&mr->mutex);
-		return mr;
-	}
-
-	log_rdma_mr(ERR, "ib_post_send failed rc=%x reg_wr->key=%x\n",
-		rc, reg_wr->key);
-
-	/* If all failed, attempt to recover this MR by setting it SMBDIRECT_MR_ERROR*/
-map_mr_error:
-	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-
-dma_map_error:
-	mr->sgt.nents = 0;
-	mr->state = SMBDIRECT_MR_ERROR;
-	if (atomic_dec_and_test(&sc->mr_io.used.count))
-		wake_up(&sc->mr_io.cleanup.wait_queue);
-
-	smbdirect_connection_schedule_disconnect(sc, rc);
 
-	/*
-	 * get_mr() gave us a reference
-	 * via kref_get(&mr->kref), we need to remove it again
-	 * on error.
-	 *
-	 * No kref_put_mutex() as it's already locked.
-	 *
-	 * If smbd_mr_free_locked() is called
-	 * and the mutex is unlocked and mr is gone,
-	 * in that case kref_put() returned 1.
-	 *
-	 * If kref_put() returned 0 we know that
-	 * smbd_mr_free_locked() didn't
-	 * run. Not by us nor by anyone else, as we
-	 * still hold the mutex, so we need to unlock.
-	 */
-	if (!kref_put(&mr->kref, smbd_mr_free_locked))
-		mutex_unlock(&mr->mutex);
-
-	return NULL;
-}
-
-static void local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct smbdirect_mr_io *smbdirect_mr;
-	struct ib_cqe *cqe;
-
-	cqe = wc->wr_cqe;
-	smbdirect_mr = container_of(cqe, struct smbdirect_mr_io, cqe);
-	smbdirect_mr->state = SMBDIRECT_MR_INVALIDATED;
-	if (wc->status != IB_WC_SUCCESS) {
-		log_rdma_mr(ERR, "invalidate failed status=%x\n", wc->status);
-		smbdirect_mr->state = SMBDIRECT_MR_ERROR;
-	}
-	complete(&smbdirect_mr->invalidate_done);
+	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
 }
 
 /*
@@ -2066,81 +1654,5 @@ static void local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
  */
 void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 {
-	struct smbdirect_socket *sc = mr->socket;
-
-	mutex_lock(&mr->mutex);
-	if (mr->state == SMBDIRECT_MR_DISABLED)
-		goto put_kref;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		smbd_mr_disable_locked(mr);
-		goto put_kref;
-	}
-
-	if (mr->need_invalidate) {
-		struct ib_send_wr *wr = &mr->inv_wr;
-		int rc;
-
-		/* Need to finish local invalidation before returning */
-		wr->opcode = IB_WR_LOCAL_INV;
-		mr->cqe.done = local_inv_done;
-		wr->wr_cqe = &mr->cqe;
-		wr->num_sge = 0;
-		wr->ex.invalidate_rkey = mr->mr->rkey;
-		wr->send_flags = IB_SEND_SIGNALED;
-
-		init_completion(&mr->invalidate_done);
-		rc = ib_post_send(sc->ib.qp, wr, NULL);
-		if (rc) {
-			log_rdma_mr(ERR, "ib_post_send failed rc=%x\n", rc);
-			smbd_mr_disable_locked(mr);
-			smbdirect_connection_schedule_disconnect(sc, rc);
-			goto done;
-		}
-		wait_for_completion(&mr->invalidate_done);
-		mr->need_invalidate = false;
-	} else
-		/*
-		 * For remote invalidation, just set it to SMBDIRECT_MR_INVALIDATED
-		 * and defer to mr_recovery_work to recover the MR for next use
-		 */
-		mr->state = SMBDIRECT_MR_INVALIDATED;
-
-	if (mr->sgt.nents) {
-		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-		mr->sgt.nents = 0;
-	}
-
-	if (mr->state == SMBDIRECT_MR_INVALIDATED) {
-		mr->state = SMBDIRECT_MR_READY;
-		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
-			wake_up(&sc->mr_io.ready.wait_queue);
-	} else
-		/*
-		 * Schedule the work to do MR recovery for future I/Os MR
-		 * recovery is slow and don't want it to block current I/O
-		 */
-		queue_work(sc->workqueue, &sc->mr_io.recovery_work);
-
-done:
-	if (atomic_dec_and_test(&sc->mr_io.used.count))
-		wake_up(&sc->mr_io.cleanup.wait_queue);
-
-put_kref:
-	/*
-	 * No kref_put_mutex() as it's already locked.
-	 *
-	 * If smbd_mr_free_locked() is called
-	 * and the mutex is unlocked and mr is gone,
-	 * in that case kref_put() returned 1.
-	 *
-	 * If kref_put() returned 0 we know that
-	 * smbd_mr_free_locked() didn't
-	 * run. Not by us nor by anyone else, as we
-	 * still hold the mutex, so we need to unlock
-	 * and keep the mr in SMBDIRECT_MR_READY or
-	 * SMBDIRECT_MR_ERROR state.
-	 */
-	if (!kref_put(&mr->kref, smbd_mr_free_locked))
-		mutex_unlock(&mr->mutex);
+	smbdirect_connection_deregister_mr_io(mr);
 }
-- 
2.43.0

