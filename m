Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C255733122E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095577; cv=none; b=bG2V7q/HtkghRm/hZbGZntEy5ZHf8HHUlRJlbmlYkTjGPz4Xs4kaCcPNTFQt4y0SutSEbh44J80yaAk+wxL2UPsVg7v63s8dWqN4WvlgPNjpVAhSmVPe5kRu6JG95DhVid8eZiQmJk4lYDJyk3qW17413i5McZYS8cOmxHlyBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095577; c=relaxed/simple;
	bh=griLO+a+75t0E6HgRX9c6Q8UFj1/DECKqAG1faHFnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+GHcMNjj/ieoPBmjQoFZOuonLDX3KBg0hwHnvJToNJjnYYRTnyIrlsmDyMm9boqbDEvxr2b7IiCpOCeZCWU5PDchWk19JqPUuwhUS0GgMraj++WYPIgzQw1oIQytV14tQCRdlyg7ctJDlyNO56WXxkzd3iCUumB9ZnEUPihXlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2CASUOol; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2CASUOol"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RftOhh8zRpQCGuzMIbzv6LoLSx1/6NHlh7oxQ6tix2g=; b=2CASUOolr9wn4DSgjNVu6/hIkS
	GFGoHPBLar6DDEAKaI+FA+xxt+JQBAXP7CQx2/U8eMVNZi0n9uSXCW0kqRyI7bjCqcfpp7Dlzqerd
	qNjhWcLVNqByjX3sQeur8ux1AiqQxQ48lvslp3RuOQZL2x1UmLW9i62sdXZOKiFqmyYXTGc16/oxW
	qM7Gkeyo3CpCsSWcT568+AlFp+BrBekFKYE62fLtHFSVxWAdSY/XxARelFTaR0XSEv9qeDF4pul+N
	ff2B85WtlZwtLxihk/99NLUZcx0t7002mgaZGB6EVwI9cXTBJX6Gxomi96zBd98cjjnZ/15RPCu23
	jY88J6vrajkCFEtcQBeOgMslehwJXWvB5DYHiYqqPYQ4lt8DVV+icu3ahK9ppQCREJLcUIqur/kqk
	N7q7Uyxm8+RK8eJMSBG6hMwUXixX7TOZ2yYc1wouHl5BH6WMp8W4aaqNBSFqjbZlLzJej4zZed6s3
	ZoLzp+Kn12zaVlf+p6B+AqDD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxlB-00FfrJ-0Y;
	Tue, 25 Nov 2025 18:27:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 135/145] smb: smbdirect: remove unused smbdirect_connection_mr_io_recovery_work()
Date: Tue, 25 Nov 2025 18:56:21 +0100
Message-ID: <85a8461eb198803b93dfd693ded7c1163de9be8a.1764091285.git.metze@samba.org>
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

This would actually never be used as we only move to
SMBDIRECT_MR_ERROR when we directly call
smbdirect_socket_schedule_cleanup().

Doing an ib_dereg_mr/ib_alloc_mr dance on
working connection is not needed and
it's also pointless on a broken connection
as we don't reuse any ib_pd.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_mr.c | 94 +++-----------------------
 1 file changed, 10 insertions(+), 84 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index ad95ee841c14..a4beaa706117 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -6,8 +6,6 @@
 
 #include "smbdirect_internal.h"
 
-static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work);
-
 /*
  * Allocate MRs used for RDMA read/write
  * The number of MRs will not exceed hardware capability in responder_resources
@@ -67,8 +65,6 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
 		atomic_inc(&sc->mr_io.ready.count);
 	}
 
-	INIT_WORK(&sc->mr_io.recovery_work, smbdirect_connection_mr_io_recovery_work);
-
 	return 0;
 
 kcalloc_sgl_failed:
@@ -128,8 +124,6 @@ void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 	LIST_HEAD(all_list);
 	unsigned long flags;
 
-	disable_work_sync(&sc->mr_io.recovery_work);
-
 	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
 	list_splice_tail_init(&sc->mr_io.all.list, &all_list);
 	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
@@ -165,11 +159,8 @@ void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 
 /*
  * Get a MR from mr_list. This function waits until there is at least one MR
- * available in the list. It may access the list while the
- * smbdirect_connection_mr_io_recovery_work is recovering the MR list. This
- * doesn't need a lock as they never modify the same places. However, there may
- * be several CPUs issuing I/O trying to get MR at the same time, mr_list_lock
- * is used to protect this situation.
+ * available in the list. There may be several CPUs issuing I/O trying to get MR
+ * at the same time, mr_list_lock is used to protect this situation.
  */
 static struct smbdirect_mr_io *
 smbdirect_connection_get_mr_io(struct smbdirect_socket *sc)
@@ -247,64 +238,6 @@ static void smbdirect_connection_mr_io_local_inv_done(struct ib_cq *cq, struct i
 	complete(&mr->invalidate_done);
 }
 
-/*
- * The work queue function that recovers MRs
- * We need to call ib_dereg_mr() and ib_alloc_mr() before this MR can be used
- * again. Both calls are slow, so finish them in a workqueue. This will not
- * block I/O path.
- * There is one workqueue that recovers MRs, there is no need to lock as the
- * I/O requests calling smbd_register_mr will never update the links in the
- * mr_list.
- */
-static void smbdirect_connection_mr_io_recovery_work(struct work_struct *work)
-{
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, mr_io.recovery_work);
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_mr_io *mr;
-	int ret;
-
-	list_for_each_entry(mr, &sc->mr_io.all.list, list) {
-		if (mr->state != SMBDIRECT_MR_ERROR)
-			/* This MR is being used, don't recover it */
-			continue;
-
-		/* recover this MR entry */
-		ret = ib_dereg_mr(mr->mr);
-		if (ret) {
-			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-				"ib_dereg_mr failed ret=%u (%s)\n",
-				ret, errname(ret));
-			smbdirect_socket_schedule_cleanup(sc, ret);
-			continue;
-		}
-
-		mr->mr = ib_alloc_mr(sc->ib.pd,
-				     sc->mr_io.type,
-				     sp->max_frmr_depth);
-		if (IS_ERR(mr->mr)) {
-			ret = PTR_ERR(mr->mr);
-			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-				"ib_alloc_mr failed ret=%d (%s) type=0x%x depth=%u\n",
-				ret, errname(ret), sc->mr_io.type, sp->max_frmr_depth);
-			smbdirect_socket_schedule_cleanup(sc, ret);
-			continue;
-		}
-
-		mr->state = SMBDIRECT_MR_READY;
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
 /*
  * Transcribe the pages from an iterator into an MR scatterlist.
  */
@@ -421,15 +354,13 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		"ib_post_send failed ret=%d (%s) reg_wr->key=0x%x\n",
 		ret, errname(ret), reg_wr->key);
 
-	/* If all failed, attempt to recover this MR by setting it SMBDIRECT_MR_ERROR*/
 map_mr_error:
 	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 
 dma_map_error:
 	mr->sgt.nents = 0;
 	mr->state = SMBDIRECT_MR_ERROR;
-	if (atomic_dec_and_test(&sc->mr_io.used.count))
-		wake_up(&sc->mr_io.cleanup.wait_queue);
+	atomic_dec(&sc->mr_io.used.count);
 
 	smbdirect_socket_schedule_cleanup(sc, ret);
 
@@ -529,20 +460,15 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 		mr->sgt.nents = 0;
 	}
 
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
+	WARN_ONCE(mr->state != SMBDIRECT_MR_INVALIDATED,
+		  "mr->state[%u] != SMBDIRECT_MR_INVALIDATED[%u]\n",
+		  mr->state, SMBDIRECT_MR_INVALIDATED);
+	mr->state = SMBDIRECT_MR_READY;
+	if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
+		wake_up(&sc->mr_io.ready.wait_queue);
 
 done:
-	if (atomic_dec_and_test(&sc->mr_io.used.count))
-		wake_up(&sc->mr_io.cleanup.wait_queue);
+	atomic_dec(&sc->mr_io.used.count);
 
 put_kref:
 	/*
-- 
2.43.0

