Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8FA32C921
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093609; cv=none; b=ikI9bnd62Kt+NkSKaC/ta+pZwttAhBds9xZfqOtFPv30l7CT2hGymtZ5xeKL5oQSWRwdR5RUrLduKnupaPsz/gcPNWCpuNgQD58nJl2wYrNUrGm+VCur8hplHv8T/7elriycLY3JTAsH+COcnW49FfB03Y+RhcHgIiaJcU5gho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093609; c=relaxed/simple;
	bh=69yk4+Po+oWqTKLGdoUJGURXpXfX7adaosJ41Sj851g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWEKENc1RpS4U7sL2fEKDRW1ytR4py52pRoM50/mqEwVObtnVeR7TW+o/NW+n7PSF8elDw6f+UAyRxyN1ChzcUoF80M9OLvl1C141tjrphkXhMSFOmlMcAICT2lqghxqefZf07Aes7C/eluTQkbLgfSkOVs+FDYPQb+FbdRpxho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mCJZi3G4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mCJZi3G4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8xdr63nZHK8XZKB8DFvV2Tlr+ffnVwEQUTUj7w3AR/c=; b=mCJZi3G4E85hbp+QERXCkpPNv6
	BPoxAg2q4qRv6DC9ugvwmKJJwFCGni3vwpprgyfl+CZLZUoLOBtB2B+naaFBt2ebG0q6LS5a7kWXr
	51GqAY4gBZUQFYoSwxjddSe1H85SemZfvfx7PM6LOi2AAJ/FR6dID7AELDi5I/9Zjsz+zWVzTM1rf
	+wNsnbJ5ALSZKZpfEFN6ZrhBq8i3+u7LHzJg7T7YwFZFhK7fwUcog6KhJF+6JJZNTQsMeWwkIKBEY
	gA91OsxNg6rkEhX8nopACfjWOZC1uSO+b7CTrgUL4ydjtNeM3rceC+bL7NiNimcSkAX/Hp0ixU5Wz
	r2lNNuYxmUtgnHPMU/tVZ6erlaeGA3xGQiSpydxi8mbqVoawxNkYrvVyfW60PpMLKp1BCbjK8XSU5
	piyXAxTk/jWKhBSF69YUUpXX9+308CK4OnQnCsQIQQi8sBNmDRi/ADDhhTjxK9mSd9bFo4IhXsN4D
	e7Hgqd9n9iY/OeqKi2eUQXpE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKd-00Fd0x-2n;
	Tue, 25 Nov 2025 18:00:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 034/145] smb: smbdirect: introduce smbdirect_mr.c with client mr code
Date: Tue, 25 Nov 2025 18:54:40 +0100
Message-ID: <68502cfff00b43dfd780cf55d0e6dec5bae460e3.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically contains the following functions copied from
the client: destroy_mr_list, allocate_mr_list, register_mr_done,
smbd_mr_recovery_work, get_mr, smbd_iter_to_mr, smbd_register_mr
and smbd_deregister_mr.

They got new names, some indentation/formatting changes,
some variable names are changed too.

They also only use struct smbdirect_socket instead of
struct smbd_connection.

But the logic is still the same. They will be used
by the client soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_all_c_files.c  |   1 +
 fs/smb/common/smbdirect/smbdirect_mr.c        | 544 ++++++++++++++++++
 2 files changed, 545 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_mr.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 93098598fbdc..f1afc1120753 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -17,3 +17,4 @@
 #endif
 #include "smbdirect_socket.c"
 #include "smbdirect_connection.c"
+#include "smbdirect_mr.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
new file mode 100644
index 000000000000..d52e5b8ab71c
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+
+static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
+static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
+
+/*
+ * Allocate MRs used for RDMA read/write
+ * The number of MRs will not exceed hardware capability in responder_resources
+ * All MRs are kept in mr_list. The MR can be recovered after it's used
+ * Recovery is done in smbd_mr_recovery_work. The content of list entry changes
+ * as MRs are used and recovered for I/O, but the list links will not change
+ */
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_mr_io *mr;
+	int ret;
+	u32 i;
+
+	if (sp->responder_resources == 0) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"responder_resources negotiated as 0\n");
+		return -EINVAL;
+	}
+
+	/* Allocate more MRs (2x) than hardware responder_resources */
+	for (i = 0; i < sp->responder_resources * 2; i++) {
+		mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+		if (!mr) {
+			ret = -ENOMEM;
+			goto kzalloc_mr_failed;
+		}
+
+		kref_init(&mr->kref);
+		mutex_init(&mr->mutex);
+
+		mr->mr = ib_alloc_mr(sc->ib.pd,
+				     sc->mr_io.type,
+				     sp->max_frmr_depth);
+		if (IS_ERR(mr->mr)) {
+			ret = PTR_ERR(mr->mr);
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"ib_alloc_mr failed ret=%d (%s) type=0x%x max_frmr_depth=%u\n",
+				ret, errname(ret), sc->mr_io.type, sp->max_frmr_depth);
+			goto ib_alloc_mr_failed;
+		}
+		mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
+				      sizeof(struct scatterlist),
+				      GFP_KERNEL);
+		if (!mr->sgt.sgl) {
+			ret = -ENOMEM;
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"failed to allocate sgl, max_frmr_depth=%u\n",
+				sp->max_frmr_depth);
+			goto kcalloc_sgl_failed;
+		}
+		mr->state = SMBDIRECT_MR_READY;
+		mr->socket = sc;
+
+		list_add_tail(&mr->list, &sc->mr_io.all.list);
+		atomic_inc(&sc->mr_io.ready.count);
+	}
+
+	INIT_WORK(&sc->mr_io.recovery_work, smbdirect_connection_mr_io_recovery_work);
+
+	return 0;
+
+kcalloc_sgl_failed:
+	ib_dereg_mr(mr->mr);
+ib_alloc_mr_failed:
+	mutex_destroy(&mr->mutex);
+	kfree(mr);
+kzalloc_mr_failed:
+	smbdirect_connection_destroy_mr_list(sc);
+	return ret;
+}
+
+static void smbdirect_mr_io_disable_locked(struct smbdirect_mr_io *mr)
+{
+	struct smbdirect_socket *sc = mr->socket;
+
+	lockdep_assert_held(&mr->mutex);
+
+	if (mr->state == SMBDIRECT_MR_DISABLED)
+		return;
+
+	if (mr->mr)
+		ib_dereg_mr(mr->mr);
+	if (mr->sgt.nents)
+		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+	kfree(mr->sgt.sgl);
+
+	mr->mr = NULL;
+	mr->sgt.sgl = NULL;
+	mr->sgt.nents = 0;
+
+	mr->state = SMBDIRECT_MR_DISABLED;
+}
+
+static void smbdirect_mr_io_free_locked(struct kref *kref)
+{
+	struct smbdirect_mr_io *mr =
+		container_of(kref, struct smbdirect_mr_io, kref);
+
+	lockdep_assert_held(&mr->mutex);
+
+	/*
+	 * smbdirect_mr_io_disable_locked() should already be called!
+	 */
+	if (WARN_ON_ONCE(mr->state != SMBDIRECT_MR_DISABLED))
+		smbdirect_mr_io_disable_locked(mr);
+
+	mutex_unlock(&mr->mutex);
+	mutex_destroy(&mr->mutex);
+	kfree(mr);
+}
+
+static void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
+{
+	struct smbdirect_mr_io *mr, *tmp;
+	LIST_HEAD(all_list);
+	unsigned long flags;
+
+	disable_work_sync(&sc->mr_io.recovery_work);
+
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	list_splice_tail_init(&sc->mr_io.all.list, &all_list);
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+
+	list_for_each_entry_safe(mr, tmp, &all_list, list) {
+		mutex_lock(&mr->mutex);
+
+		smbdirect_mr_io_disable_locked(mr);
+		list_del(&mr->list);
+		mr->socket = NULL;
+
+		/*
+		 * No kref_put_mutex() as it's already locked.
+		 *
+		 * If smbdirect_mr_io_free_locked() is called
+		 * and the mutex is unlocked and mr is gone,
+		 * in that case kref_put() returned 1.
+		 *
+		 * If kref_put() returned 0 we know that
+		 * smbdirect_mr_io_free_locked() didn't
+		 * run. Not by us nor by anyone else, as we
+		 * still hold the mutex, so we need to unlock.
+		 *
+		 * If the mr is still registered it will
+		 * be dangling (detached from the connection
+		 * waiting for smbd_deregister_mr() to be
+		 * called in order to free the memory.
+		 */
+		if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
+			mutex_unlock(&mr->mutex);
+	}
+}
+
+/*
+ * Get a MR from mr_list. This function waits until there is at least one MR
+ * available in the list. It may access the list while the
+ * smbdirect_connection_mr_io_recovery_work is recovering the MR list. This
+ * doesn't need a lock as they never modify the same places. However, there may
+ * be several CPUs issuing I/O trying to get MR at the same time, mr_list_lock
+ * is used to protect this situation.
+ */
+static struct smbdirect_mr_io *
+smbdirect_connection_get_mr_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_mr_io *mr;
+	unsigned long flags;
+	int ret;
+
+again:
+	ret = wait_event_interruptible(sc->mr_io.ready.wait_queue,
+				       atomic_read(&sc->mr_io.ready.count) ||
+				       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	if (ret) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"wait_event_interruptible ret=%d (%s)\n",
+			ret, errname(ret));
+		return NULL;
+	}
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"sc->status=%s sc->first_error=%1pe\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+		return NULL;
+	}
+
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
+	list_for_each_entry(mr, &sc->mr_io.all.list, list) {
+		if (mr->state == SMBDIRECT_MR_READY) {
+			mr->state = SMBDIRECT_MR_REGISTERED;
+			kref_get(&mr->kref);
+			spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+			atomic_dec(&sc->mr_io.ready.count);
+			atomic_inc(&sc->mr_io.used.count);
+			return mr;
+		}
+	}
+
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
+	/*
+	 * It is possible that we could fail to get MR because other processes may
+	 * try to acquire a MR at the same time. If this is the case, retry it.
+	 */
+	goto again;
+}
+
+static void smbdirect_connection_mr_io_register_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_mr_io *mr =
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+	struct smbdirect_socket *sc = mr->socket;
+
+	if (wc->status != IB_WC_SUCCESS) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"wc->status=%s opcode=%d\n",
+			ib_wc_status_msg(wc->status), wc->opcode);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	}
+}
+
+static void smbdirect_connection_mr_io_local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_mr_io *mr =
+		container_of(wc->wr_cqe, struct smbdirect_mr_io, cqe);
+	struct smbdirect_socket *sc = mr->socket;
+
+	mr->state = SMBDIRECT_MR_INVALIDATED;
+	if (wc->status != IB_WC_SUCCESS) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"invalidate failed status=%s\n",
+			ib_wc_status_msg(wc->status));
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	}
+	complete(&mr->invalidate_done);
+}
+
+/*
+ * The work queue function that recovers MRs
+ * We need to call ib_dereg_mr() and ib_alloc_mr() before this MR can be used
+ * again. Both calls are slow, so finish them in a workqueue. This will not
+ * block I/O path.
+ * There is one workqueue that recovers MRs, there is no need to lock as the
+ * I/O requests calling smbd_register_mr will never update the links in the
+ * mr_list.
+ */
+static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, mr_io.recovery_work);
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_mr_io *mr;
+	int ret;
+
+	list_for_each_entry(mr, &sc->mr_io.all.list, list) {
+		if (mr->state != SMBDIRECT_MR_ERROR)
+			/* This MR is being used, don't recover it */
+			continue;
+
+		/* recover this MR entry */
+		ret = ib_dereg_mr(mr->mr);
+		if (ret) {
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"ib_dereg_mr failed ret=%u (%s)\n",
+				ret, errname(ret));
+			smbdirect_socket_schedule_cleanup(sc, ret);
+			continue;
+		}
+
+		mr->mr = ib_alloc_mr(sc->ib.pd,
+				     sc->mr_io.type,
+				     sp->max_frmr_depth);
+		if (IS_ERR(mr->mr)) {
+			ret = PTR_ERR(mr->mr);
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"ib_alloc_mr failed ret=%d (%s) type=0x%x depth=%u\n",
+				ret, errname(ret), sc->mr_io.type, sp->max_frmr_depth);
+			smbdirect_socket_schedule_cleanup(sc, ret);
+			continue;
+		}
+
+		mr->state = SMBDIRECT_MR_READY;
+
+		/* smbdirect_mr->state is updated by this function
+		 * and is read and updated by I/O issuing CPUs trying
+		 * to get a MR, the call to atomic_inc_return
+		 * implicates a memory barrier and guarantees this
+		 * value is updated before waking up any calls to
+		 * get_mr() from the I/O issuing CPUs
+		 */
+		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
+			wake_up(&sc->mr_io.ready.wait_queue);
+	}
+}
+
+/*
+ * Transcribe the pages from an iterator into an MR scatterlist.
+ */
+static int smbdirect_iter_to_sgt(struct iov_iter *iter,
+				 struct sg_table *sgt,
+				 unsigned int max_sg)
+{
+	int ret;
+
+	memset(sgt->sgl, 0, max_sg * sizeof(struct scatterlist));
+
+	ret = extract_iter_to_sg(iter, iov_iter_count(iter), sgt, max_sg, 0);
+	WARN_ON(ret < 0);
+	if (sgt->nents > 0)
+		sg_mark_end(&sgt->sgl[sgt->nents - 1]);
+
+	return ret;
+}
+
+/*
+ * Register memory for RDMA read/write
+ * iter: the buffer to register memory with
+ * writing: true if this is a RDMA write (SMB read), false for RDMA read
+ * need_invalidate: true if this MR needs to be locally invalidated after I/O
+ * return value: the MR registered, NULL if failed.
+ */
+__maybe_unused /* this is temporary while this file is included in others */
+static struct smbdirect_mr_io *
+smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
+				    struct iov_iter *iter,
+				    bool writing,
+				    bool need_invalidate)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct smbdirect_mr_io *mr;
+	int ret, num_pages;
+	struct ib_reg_wr *reg_wr;
+
+	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
+	if (num_pages > sp->max_frmr_depth) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"num_pages=%d max_frmr_depth=%d\n",
+			num_pages, sp->max_frmr_depth);
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	mr = smbdirect_connection_get_mr_io(sc);
+	if (!mr) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_get_mr_io returning NULL\n");
+		return NULL;
+	}
+
+	mutex_lock(&mr->mutex);
+
+	mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	mr->need_invalidate = need_invalidate;
+	mr->sgt.nents = 0;
+	mr->sgt.orig_nents = 0;
+
+	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
+		"num_pages=%u count=%zu depth=%u\n",
+		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
+	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
+
+	ret = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+	if (!ret) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"ib_dma_map_sg num_pages=%u dir=%x ret=%d (%s)\n",
+			num_pages, mr->dir, ret, errname(ret));
+		goto dma_map_error;
+	}
+
+	ret = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
+	if (ret != mr->sgt.nents) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"ib_map_mr_sg failed ret = %d nents = %u\n",
+			ret, mr->sgt.nents);
+		goto map_mr_error;
+	}
+
+	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
+	reg_wr = &mr->wr;
+	reg_wr->wr.opcode = IB_WR_REG_MR;
+	mr->cqe.done = smbdirect_connection_mr_io_register_done;
+	reg_wr->wr.wr_cqe = &mr->cqe;
+	reg_wr->wr.num_sge = 0;
+	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
+	reg_wr->mr = mr->mr;
+	reg_wr->key = mr->mr->rkey;
+	reg_wr->access = writing ?
+			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
+			IB_ACCESS_REMOTE_READ;
+
+	/*
+	 * There is no need for waiting for complemtion on ib_post_send
+	 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
+	 * on the next ib_post_send when we actually send I/O to remote peer
+	 */
+	ret = ib_post_send(sc->ib.qp, &reg_wr->wr, NULL);
+	if (!ret) {
+		/*
+		 * smbdirect_connection_get_mr_io() gave us a reference
+		 * via kref_get(&mr->kref), we keep that and let
+		 * the caller use smbdirect_connection_deregister_mr_io()
+		 * to remove it again.
+		 */
+		mutex_unlock(&mr->mutex);
+		return mr;
+	}
+
+	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+		"ib_post_send failed ret=%d (%s) reg_wr->key=0x%x\n",
+		ret, errname(ret), reg_wr->key);
+
+	/* If all failed, attempt to recover this MR by setting it SMBDIRECT_MR_ERROR*/
+map_mr_error:
+	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+
+dma_map_error:
+	mr->sgt.nents = 0;
+	mr->state = SMBDIRECT_MR_ERROR;
+	if (atomic_dec_and_test(&sc->mr_io.used.count))
+		wake_up(&sc->mr_io.cleanup.wait_queue);
+
+	smbdirect_socket_schedule_cleanup(sc, ret);
+
+	/*
+	 * smbdirect_connection_get_mr_io() gave us a reference
+	 * via kref_get(&mr->kref), we need to remove it again
+	 * on error.
+	 *
+	 * No kref_put_mutex() as it's already locked.
+	 *
+	 * If smbdirect_mr_io_free_locked() is called
+	 * and the mutex is unlocked and mr is gone,
+	 * in that case kref_put() returned 1.
+	 *
+	 * If kref_put() returned 0 we know that
+	 * smbdirect_mr_io_free_locked() didn't
+	 * run. Not by us nor by anyone else, as we
+	 * still hold the mutex, so we need to unlock.
+	 */
+	if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
+		mutex_unlock(&mr->mutex);
+	return NULL;
+}
+/*
+ * Deregister a MR after I/O is done
+ * This function may wait if remote invalidation is not used
+ * and we have to locally invalidate the buffer to prevent data is being
+ * modified by remote peer after upper layer consumes it
+ */
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
+{
+	struct smbdirect_socket *sc = mr->socket;
+	int ret = 0;
+
+	mutex_lock(&mr->mutex);
+	if (mr->state == SMBDIRECT_MR_DISABLED)
+		goto put_kref;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_mr_io_disable_locked(mr);
+		goto put_kref;
+	}
+
+	if (mr->need_invalidate) {
+		struct ib_send_wr *wr = &mr->inv_wr;
+
+		/* Need to finish local invalidation before returning */
+		wr->opcode = IB_WR_LOCAL_INV;
+		mr->cqe.done = smbdirect_connection_mr_io_local_inv_done;
+		wr->wr_cqe = &mr->cqe;
+		wr->num_sge = 0;
+		wr->ex.invalidate_rkey = mr->mr->rkey;
+		wr->send_flags = IB_SEND_SIGNALED;
+
+		init_completion(&mr->invalidate_done);
+		ret = ib_post_send(sc->ib.qp, wr, NULL);
+		if (ret) {
+			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+				"ib_post_send failed ret=%d (%s)\n",
+				ret, errname(ret));
+			smbdirect_mr_io_disable_locked(mr);
+			smbdirect_socket_schedule_cleanup(sc, ret);
+			goto done;
+		}
+		wait_for_completion(&mr->invalidate_done);
+		mr->need_invalidate = false;
+	} else
+		/*
+		 * For remote invalidation, just set it to SMBDIRECT_MR_INVALIDATED
+		 * and defer to mr_recovery_work to recover the MR for next use
+		 */
+		mr->state = SMBDIRECT_MR_INVALIDATED;
+
+	if (mr->sgt.nents) {
+		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+		mr->sgt.nents = 0;
+	}
+
+	if (mr->state == SMBDIRECT_MR_INVALIDATED) {
+		mr->state = SMBDIRECT_MR_READY;
+		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
+			wake_up(&sc->mr_io.ready.wait_queue);
+	} else
+		/*
+		 * Schedule the work to do MR recovery for future I/Os MR
+		 * recovery is slow and don't want it to block current I/O
+		 */
+		queue_work(sc->workqueue, &sc->mr_io.recovery_work);
+
+done:
+	if (atomic_dec_and_test(&sc->mr_io.used.count))
+		wake_up(&sc->mr_io.cleanup.wait_queue);
+
+put_kref:
+	/*
+	 * No kref_put_mutex() as it's already locked.
+	 *
+	 * If smbdirect_mr_io_free_locked() is called
+	 * and the mutex is unlocked and mr is gone,
+	 * in that case kref_put() returned 1.
+	 *
+	 * If kref_put() returned 0 we know that
+	 * smbdirect_mr_io_free_locked() didn't
+	 * run. Not by us nor by anyone else, as we
+	 * still hold the mutex, so we need to unlock
+	 * and keep the mr in SMBDIRECT_MR_READY or
+	 * SMBDIRECT_MR_ERROR state.
+	 */
+	if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
+		mutex_unlock(&mr->mutex);
+}
-- 
2.43.0

