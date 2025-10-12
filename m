Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B87234BA41
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296310; cv=none; b=HwguTlM0sdFnodd4LZoZjRdsSwUuKcaPkQWCEJzVqKAo5kN+0CWjcBohW7FTmfcwAZ+aLR/W+awZINY3MXM7KVynTq39V15vB3g0E9kmFPdibw4cTSMu9R/zzdNdjJeVTNTIQ9IVUH9Te6Q6OUwD41Y7aNnzNxJ3ocb0wNF5o04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296310; c=relaxed/simple;
	bh=7CdY+zjDt8hofF/vEUOf6DbYWO7SMv0i6aPPcnC+Udw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCeNWySV4KJ7T6F5dIGjHHLn0ax0NXBycZzD605J2D62rSshkR5duva5DUdv7GhyDTdXVZ2Qd3GeumXM+lnfshPwB1OuuOq99wjvmZbHnuhA5jUxV3p/avUeSww8vmahZ6IrwTlFIgUMIkCTQlCedE/96Ayz4bI1Zhb2V/E/L1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VZc/gnZq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VZc/gnZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TTG87p9EX6OEbiHnb0VOAY5QcJqelTnSevzVHSKWU8s=; b=VZc/gnZq4vj6ongz0B8eq+SAJF
	WFqmi83p6cqmw5NObUt5uSS+jhY6CnvCCAJkdYJIA7uLEV9gq0zwXd1pac4pA2krW5pwOyTLiH6xR
	saiYp+lznsxknUp8H+OUnxT/+VRbEfravZhu6h/M35WnuzeBucaId+o2Y7FgNakMnsU6zv5zNKYmr
	waHNA/l7xZyZ8v/2b/OO/cbGEeWwQMqfxHKTyvjb8OAD0JhROUH429LaCh8Cpy4mDHB3AhWNkgVIp
	OX0KEZRXVKynGV0UNynI0+H1J/veZAJ2JbIMApfuRsBZaSjopPzRhSR8EW37iIL9+GaPG6tP7hUdu
	CEyPus/caHxRvpDcj5mqD8PRog4iDdNH1acdiYPq/ejfcWthgRjFpdyPT9imc9ydtCF2r7pQ0cfeM
	Xzk2XYyo3F5pRs6IhfA+diyyxFrAe9uLledEO3YL7V81zY4Z/MFORKiez12plxcacOrfb6EnSeYGG
	psTwTOY1PD59RqPwVsWMiQL8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81To-008o7C-1G;
	Sun, 12 Oct 2025 19:11:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/10] smb: client: call ib_dma_unmap_sg if mr->sgt.nents is not 0
Date: Sun, 12 Oct 2025 21:10:28 +0200
Message-ID: <80fd0da52841a169d780af362d928d25cb948134.1760295528.git.metze@samba.org>
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

This seems to be the more reliable way to check if we need to
call ib_dma_unmap_sg().

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index af0642e94d7e..21dcd326af3d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2365,9 +2365,8 @@ static void destroy_mr_list(struct smbdirect_socket *sc)
 	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
 
 	list_for_each_entry_safe(mr, tmp, &all_list, list) {
-		if (mr->state == SMBDIRECT_MR_INVALIDATED)
-			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl,
-				mr->sgt.nents, mr->dir);
+		if (mr->sgt.nents)
+			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 		ib_dereg_mr(mr->mr);
 		kfree(mr->sgt.sgl);
 		list_del(&mr->list);
@@ -2589,6 +2588,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 
 dma_map_error:
+	mr->sgt.nents = 0;
 	mr->state = SMBDIRECT_MR_ERROR;
 	if (atomic_dec_and_test(&sc->mr_io.used.count))
 		wake_up(&sc->mr_io.cleanup.wait_queue);
@@ -2651,8 +2651,12 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 		 */
 		mr->state = SMBDIRECT_MR_INVALIDATED;
 
-	if (mr->state == SMBDIRECT_MR_INVALIDATED) {
+	if (mr->sgt.nents) {
 		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+		mr->sgt.nents = 0;
+	}
+
+	if (mr->state == SMBDIRECT_MR_INVALIDATED) {
 		mr->state = SMBDIRECT_MR_READY;
 		if (atomic_inc_return(&sc->mr_io.ready.count) == 1)
 			wake_up(&sc->mr_io.ready.wait_queue);
-- 
2.43.0

