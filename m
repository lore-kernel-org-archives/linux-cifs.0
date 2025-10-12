Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2CD34BA41
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296298; cv=none; b=ue8rayoCb+O0UmaHBqFL0pgbLVhzp5K6hJjp6Cb3LD5tyHYNRT/Evy72QCFq3/ps5h5hwoXVydiI6IZZb65kbdcOt+NlbHbSHJ3wwGstG6xmTM5dDLe0dlVzOstJpP2v/S1urDDuLEpxijSu/fDt+kVS1mSRJ19WkC3AXplXlkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296298; c=relaxed/simple;
	bh=SqJt+mCpeb5SsHxuZsrOw75mHNYGpe6OP2d8+LpwVpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHqg8IrV0lVH7UWccd6UFwHcayJ6/ansu8GSSKXKNENzv8pnpRKaHuXLE1AJBaEXZ4WulypCycxAyurxhQf1D+fsBtDzWax+pj8OvhOMWXRm/dGxdlx8l5XRD22PBOgN6ftgQkXgOT4THIrhujCs6Phh1tyAdniRX8QQxasSk9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ixK7HQeI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ixK7HQeI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lJCi4Hk9QDTf9aY+XaWUxFV5eRwrEv0hIGBWeX2PTG0=; b=ixK7HQeIBEGPAG7u6ZTDYyD14w
	MQh8cI7uHIiVtc+66V7+B3NSSUF20HXCiYHXfZEjeaEDgPtG86jVkuHHlAj3NKqDSGDTtDvuaRmRx
	UCzu21Yn02RxyfPHQbrW6MIRoCjZQqhhwI6pEVoVpTCdm4Lirwq0yNxxlrQIQ+HD1ZdHNDsbqjJXB
	Qy4822m4k+q3LfSDPZ9eesAIsqUdsLbuVixka7oXyZt44lFpmESOPOX6A6M7IoYMz3/0tiZEiuAFz
	arx8xs8/pPdCurXI3XaQInbrREklHLvlydO+gTCHU5njKZEbE3cNcRG7VhjSgRSSIATdlPrWcWFtR
	fLTxoKDY9aeQ0oFoSl4WGVW4P3iaLfaCOMAtsvefnBLs7l+tmM/U6QScTzLDIw7Yrt16hV4Hg04BH
	sOd7YDXDZTPOwj7UZSNeMTzB0BQwx1q8bkLez6PLgrFapX+a6Cnpm2PcpqRNfIT98A04RMx+6q11m
	NnAw3G6cZfMBGiXDJkI+IvyQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81Tg-008o5O-3D;
	Sun, 12 Oct 2025 19:11:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 07/10] smb: client: improve logic in smbd_deregister_mr()
Date: Sun, 12 Oct 2025 21:10:27 +0200
Message-ID: <12476629448862849bbc483ba57aabd02e80b8e3.1760295528.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760295528.git.metze@samba.org>
References: <cover.1760295528.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- use 'mr' as variable name
- style fixes

This will make further changes easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a863b6fff87a..af0642e94d7e 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2619,44 +2619,41 @@ static void local_inv_done(struct ib_cq *cq, struct ib_wc *wc)
  * and we have to locally invalidate the buffer to prevent data is being
  * modified by remote peer after upper layer consumes it
  */
-void smbd_deregister_mr(struct smbdirect_mr_io *smbdirect_mr)
+void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 {
-	struct ib_send_wr *wr;
-	struct smbdirect_socket *sc = smbdirect_mr->socket;
-	int rc = 0;
+	struct smbdirect_socket *sc = mr->socket;
+
+	if (mr->need_invalidate) {
+		struct ib_send_wr *wr = &mr->inv_wr;
+		int rc;
 
-	if (smbdirect_mr->need_invalidate) {
 		/* Need to finish local invalidation before returning */
-		wr = &smbdirect_mr->inv_wr;
 		wr->opcode = IB_WR_LOCAL_INV;
-		smbdirect_mr->cqe.done = local_inv_done;
-		wr->wr_cqe = &smbdirect_mr->cqe;
+		mr->cqe.done = local_inv_done;
+		wr->wr_cqe = &mr->cqe;
 		wr->num_sge = 0;
-		wr->ex.invalidate_rkey = smbdirect_mr->mr->rkey;
+		wr->ex.invalidate_rkey = mr->mr->rkey;
 		wr->send_flags = IB_SEND_SIGNALED;
 
-		init_completion(&smbdirect_mr->invalidate_done);
+		init_completion(&mr->invalidate_done);
 		rc = ib_post_send(sc->ib.qp, wr, NULL);
 		if (rc) {
 			log_rdma_mr(ERR, "ib_post_send failed rc=%x\n", rc);
 			smbd_disconnect_rdma_connection(sc);
 			goto done;
 		}
-		wait_for_completion(&smbdirect_mr->invalidate_done);
-		smbdirect_mr->need_invalidate = false;
+		wait_for_completion(&mr->invalidate_done);
+		mr->need_invalidate = false;
 	} else
 		/*
 		 * For remote invalidation, just set it to SMBDIRECT_MR_INVALIDATED
 		 * and defer to mr_recovery_work to recover the MR for next use
 		 */
-		smbdirect_mr->state = SMBDIRECT_MR_INVALIDATED;
+		mr->state = SMBDIRECT_MR_INVALIDATED;
 
-	if (smbdirect_mr->state == SMBDIRECT_MR_INVALIDATED) {
-		ib_dma_unmap_sg(
-			sc->ib.dev, smbdirect_mr->sgt.sgl,
-			smbdirect_mr->sgt.nents,
-			smbdirect_mr->dir);
-		smbdirect_mr->state = SMBDIRECT_MR_READY;
+	if (mr->state == SMBDIRECT_MR_INVALIDATED) {
+		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+		mr->state = SMBDIRECT_MR_READY;
 		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
 			wake_up(&sc->mr_io.ready.wait_queue);
 	} else
-- 
2.43.0

