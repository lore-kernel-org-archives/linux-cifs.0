Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A28C343216;
	Fri,  8 May 2026 08:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778229339; cv=none; b=b0HhkwjMNtCfpLXoaxxnemIMXX64wmA8Ccsee6xnjpQ0gzXxudFMuTxDT3ixI2mWgFtd/WncEbwP2y+jJ3X1q0ZQkVXEKojO5iXcUQ/aTb8XfQ84IsEVJGPZ9WQqqJ5YQTme7a5keifCO/FhQtxdeY+kkFBV4jdeL0vW/CWqIZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778229339; c=relaxed/simple;
	bh=tOoofxWe9ttsXO+WyHJ2DFzxNs1G8mDg+R0zmIa5v4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dfdG5C2HJrco1ukH2WrOTFk+Vh+0va6AK3tA7ofBbjObS+nSe2xR6rjBCr+tmvFE1J/D6NQlablC76W0Nx0EZfw6YibO31JD6iGWq9VoFozu4ZvK/Q8D+dcmg9lKUhusAHtI0H67MZLNccNIeGOIxa+mt+76z/6k5+O7djgQnFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uvj4z7sT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uvj4z7sT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=h4Oz5sDHc98VrM9jcrU2QxrS0yTu0FuamcBVTJQWxVE=; b=uvj4z7sTQo0Mjh2oFFOXEO+hL9
	6TsLMw7QXFVOQEXRyEyfCsHDWdjdbB3Sdf1Yn1hhIihZjhjtaezLxXW39R/EPLZQPhum6/5MSKGLj
	LFrDYA5tHWFzmlw0ByeRMN9aJjjIbiFqGFxEbCg1XC1S6fsp0RXZpD2fCBTc6FsKA2hxF0sO6oetm
	T9E6bw7niqm8LYJPT/W4Yj0ykZnAdzsLjbJTHkvgK5Uj/+Y3NutOpD8JqxE51P0uuQE9cst80xTVu
	zMamjBxGtS+8NPNzrGoGcY4VcDSYlIhtKszGn+E5nOj6O5AOFVsj4KEeNC0qFOgwXed9cjnsuMk5i
	y2gzGCRlOPFJoA1g0ViqRTy6YJuKu4ayQNeXhAuv+JWb4MmMMaeMejnPruTNPdQ7cZNe/KAKlNcPd
	yuIpZgmKCXJc2RkJsqsVavp3O+0YdE5H13fx03qkB9CGMTVEhx8vYxw+s26YDkWYZYaGTw1B4JcFT
	ksaKrtZhBZQh8Ydu29j+S5xl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wLGNf-00000007Esd-1mrL;
	Fri, 08 May 2026 08:16:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: stable@vger.kernel.org
Cc: metze@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Yi Kuo <yi@yikuo.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH for stable] smb: client/smbdirect: fix MR registration for coalesced SG lists
Date: Fri,  8 May 2026 10:15:47 +0200
Message-ID: <20260508081546.4177429-2-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Kuo <yi@yikuo.dev>

commit 9900b9fee5a0e0f72d7c744b37c7c851d5785ac6 upstream.
The stable backport to < 7.1 a different file gets the
fix. Also the Fixes tag below is adjusted for the old code path.

ib_dma_map_sg() modifies the provided scatterlist and returns the
number of mapped entries, which can be fewer than the requested
mr->sgt.nents if the DMA controller coalesces contiguous memory
segments. Passing the original, uncoalesced count to ib_map_mr_sg()
causes memory registration failures if coalescing actually occurs.

Capture the actual mapped count returned by ib_dma_map_sg() and pass it
to ib_map_mr_sg() to ensure correct MR registration.

Also update the ib_dma_map_sg() error logging to drop the error
pointer formatting, since the return value is an integer count
rather than an error code.

Ensure a proper error code (-EIO) is assigned when DMA mapping or
MR registration fails.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221408
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Yi Kuo <yi@yikuo.dev>
Signed-off-by: Steve French <stfrench@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 461658105013..d0fcc7779415 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2920,7 +2920,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *mr;
-	int rc, num_pages;
+	int rc, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -2948,18 +2948,21 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
 	smbd_iter_to_mr(iter, &mr->sgt, sp->max_frmr_depth);
 
-	rc = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	if (!rc) {
-		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x rc=%x\n",
-			    num_pages, mr->dir, rc);
+	num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
+	if (!num_mapped) {
+		log_rdma_mr(ERR, "ib_dma_map_sg num_pages=%x dir=%x num_mapped=%x\n",
+			    num_pages, mr->dir, num_mapped);
+		rc = -EIO;
 		goto dma_map_error;
 	}
 
-	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
-	if (rc != mr->sgt.nents) {
+	rc = ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
+	if (rc != num_mapped) {
 		log_rdma_mr(ERR,
-			    "ib_map_mr_sg failed rc = %d nents = %x\n",
-			    rc, mr->sgt.nents);
+			    "ib_map_mr_sg failed rc = %d num_mapped = %x\n",
+			    rc, num_mapped);
+		if (rc >= 0)
+			rc = -EIO;
 		goto map_mr_error;
 	}
 
-- 
2.43.0

