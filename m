Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C231E9B37
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296291; cv=none; b=E2h8MPwaMYtodz3QnCnwZuTjUA4koBf1ZbI+4EE7foygyZCF5gYGOKw/d9wcgRx0bBl5CMFWANRTc7S5m/lMABEz2LFta4ru9LUN9lAjd6Kf8dA5vfX9SW2YikZWgWmuNdufcEXk6aSPyj7vulkpCQkfZx7L+J1bNZJRf8ywHwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296291; c=relaxed/simple;
	bh=9/IR+R+aDyOvmG1vBCqWSaKv0o5RqcX3zTOxu4vX/s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4Sjp+UY7Ft/dV9BvKpllDevV5rJ6fcbR7A0+YgchVutiYYZEyPlhM/wiWfrvd1aYbHhxAS2VwDPmtE5GO4UjapowLyDhKl5LVtY+e0/2YkNIihNO91YVG5lLvFpQNVwRMMC527PnMvm5D7wyN4HRMeO06yDFOJnJkBPVcznQeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rtuldjPD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rtuldjPD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EC1JRAlDaE4wzWv/7yvn+mOJ56o1wu7vAbh1Jj9ZKEk=; b=rtuldjPD6tyy0/ZRvVXoEKofZr
	EbKSJUpYLnvs9yDfHoMGOs3pV5QE0CXZriTkBEK3NF6cSNZ/MkPz4WiWqjzQUmvdz3lBbr9lC7JTe
	5MqhzXe+hwouoOCJrg+gr1/vzjZqu3Eje8Ofetgv7yi9VF0TglaazkB/fXtz/J1EnvB7LdxezcfCQ
	5ItTXkvccWL2EBM6OZZjLSaa4s/h0pvNy9UPfmZRfe4XTIrqPY0U3CO2Qlp1/Ml3J/nzUJCPkBQ0A
	gYo9gPRRYYP0HxbHD26Fk1q4vtYTe7tg2ijAMliA9goPJFRItDmVUU4I4qmhqahCafHfhzC8QbK7F
	4Fl2M3EwNGlS9FQ/66i6CmOzbMs1EFReERHE+812iWVnMH4OF292CMkFAIeRYht8XN2GqNSJD+54D
	4BKi6edT0MEca32taRMT4ajHzZ1S8PVdwLu7oyY6cb4/R4QRIvC3PJeKxqwPGU0mOYbOdZNThSqCf
	SW6XB1EusCJ1VAxURbH0eNAG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81TZ-008o3i-27;
	Sun, 12 Oct 2025 19:11:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 06/10] smb: client: improve logic in smbd_register_mr()
Date: Sun, 12 Oct 2025 21:10:26 +0200
Message-ID: <599c7fba7a97545005222775e8ac13cf5f457532.1760295528.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 52 +++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 658ca11cb26c..a863b6fff87a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2517,9 +2517,8 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 {
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct smbdirect_mr_io *smbdirect_mr;
+	struct smbdirect_mr_io *mr;
 	int rc, num_pages;
-	enum dma_data_direction dir;
 	struct ib_reg_wr *reg_wr;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -2530,49 +2529,45 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 		return NULL;
 	}
 
-	smbdirect_mr = get_mr(sc);
-	if (!smbdirect_mr) {
+	mr = get_mr(sc);
+	if (!mr) {
 		log_rdma_mr(ERR, "get_mr returning NULL\n");
 		return NULL;
 	}
 
-	dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-	smbdirect_mr->dir = dir;
-	smbdirect_mr->need_invalidate = need_invalidate;
-	smbdirect_mr->sgt.nents = 0;
-	smbdirect_mr->sgt.orig_nents = 0;
+	mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	mr->need_invalidate = need_invalidate;
+	mr->sgt.nents = 0;
+	mr->sgt.orig_nents = 0;
 
 	log_rdma_mr(INFO, "num_pages=0x%x count=0x%zx depth=%u\n",
 		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-	smbd_iter_to_mr(iter, &smbdirect_mr->sgt, sp->max_frmr_depth);
+	smbd_iter_to_mr(iter, &mr->sgt, sp->max_frmr_depth);
 
-	rc = ib_dma_map_sg(sc->ib.dev, smbdirect_mr->sgt.sgl,
-			   smbdirect_mr->sgt.nents, dir);
+	rc = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 	if (!rc) {
 		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
-			num_pages, dir, rc);
+			    num_pages, mr->dir, rc);
 		goto dma_map_error;
 	}
 
-	rc = ib_map_mr_sg(smbdirect_mr->mr, smbdirect_mr->sgt.sgl,
-			  smbdirect_mr->sgt.nents, NULL, PAGE_SIZE);
-	if (rc != smbdirect_mr->sgt.nents) {
+	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
+	if (rc != mr->sgt.nents) {
 		log_rdma_mr(ERR,
-			"ib_map_mr_sg failed rc = %d nents = %x\n",
-			rc, smbdirect_mr->sgt.nents);
+			    "ib_map_mr_sg failed rc = %d nents = %x\n",
+			    rc, mr->sgt.nents);
 		goto map_mr_error;
 	}
 
-	ib_update_fast_reg_key(smbdirect_mr->mr,
-		ib_inc_rkey(smbdirect_mr->mr->rkey));
-	reg_wr = &smbdirect_mr->wr;
+	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
+	reg_wr = &mr->wr;
 	reg_wr->wr.opcode = IB_WR_REG_MR;
-	smbdirect_mr->cqe.done = register_mr_done;
-	reg_wr->wr.wr_cqe = &smbdirect_mr->cqe;
+	mr->cqe.done = register_mr_done;
+	reg_wr->wr.wr_cqe = &mr->cqe;
 	reg_wr->wr.num_sge = 0;
 	reg_wr->wr.send_flags = IB_SEND_SIGNALED;
-	reg_wr->mr = smbdirect_mr->mr;
-	reg_wr->key = smbdirect_mr->mr->rkey;
+	reg_wr->mr = mr->mr;
+	reg_wr->key = mr->mr->rkey;
 	reg_wr->access = writing ?
 			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 			IB_ACCESS_REMOTE_READ;
@@ -2584,18 +2579,17 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	 */
 	rc = ib_post_send(sc->ib.qp, &reg_wr->wr, NULL);
 	if (!rc)
-		return smbdirect_mr;
+		return mr;
 
 	log_rdma_mr(ERR, "ib_post_send failed rc=%x reg_wr->key=%x\n",
 		rc, reg_wr->key);
 
 	/* If all failed, attempt to recover this MR by setting it SMBDIRECT_MR_ERROR*/
 map_mr_error:
-	ib_dma_unmap_sg(sc->ib.dev, smbdirect_mr->sgt.sgl,
-			smbdirect_mr->sgt.nents, smbdirect_mr->dir);
+	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 
 dma_map_error:
-	smbdirect_mr->state = SMBDIRECT_MR_ERROR;
+	mr->state = SMBDIRECT_MR_ERROR;
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
 
-- 
2.43.0

