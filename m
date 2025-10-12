Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6384534BA41
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296334; cv=none; b=DaUcY1Cb7pwCYVAKquzHwSlFrEpyXNdls9byywBU8pwYj2e/ba17EgYjhYiBqPiY7qFgea3+MAEdL1Af6knjI4uL+SOUxOuGTfk4+EAoM2XrsYvJPg95Hh8/ig5o9r9bmYn2eq6h4YznrxAWFg9Dq+3uMWG4c8qlBNLwgGuHoX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296334; c=relaxed/simple;
	bh=OxN6Ssie30Bp9oMaAuFs6597E5S4gc8/ABcZPdBMeTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqr1ILQ8tPPZyd9RVrLvVE4j8Cg7Eg0KRHmxYte9aE3vJh0y5ac4Gk+lG7crLhYyU3ysYf425tfo5TVmecHPkVvdjD8Z6bYRtYIEWg20XflCGb6W/KVIErb23e4fuq8w6d8veCbxQ1l9UY2qKGxI+b4DAFXStfEnlRyRfxLFdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CDGwdUHs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CDGwdUHs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=voBS6RyuUxPMBSH2R7pCqkqRRHrWZabO6HsTgzBzjSE=; b=CDGwdUHsC0XSbmszsSQ2K3LQWE
	S7zttLS58/Bj51myyefohs/JIrrFsTYUx8qi39Y8oQGaLU4Eu/ciZPWhKdVIijGbA69d23G+I535f
	h0tc0hf+WV96d2/P5bQJ49CW+f3SUNh3ol2KHLPS6tIHrUSB6sPnMfB/bOLJe7RfSEJo1dD/2Qr1J
	KwT+KbduRGiB1Vzjy97Hxqn3vv9T6tJ5N+ZBy/OfneRnQDNUaLjEZdBxgfausAkHMijQzNBKSPZhJ
	Le/VuhP7LMSbj/ugZi0OTCyfvT4htVYDwbjBS0LpFDCbgwNdnlgRs0BUvIUIfK14QKizOkTL1RuCg
	oRtU8J1mvMOmqvJYL0Sj6Ts1rVJ6nWUXcBtw0TKm0ltQZJMJivGkM7XvgILE8SEPMqDpHi+jP7Td5
	fDtesqR/sZb1mc47Aq14J6VF7C1gpJ+xKyJ54bR2K1R7xYNnRseqyV6tmel7eoH98wePqzUG/8j0e
	Z3BCvAU2hYShB2oZAWv+e9yP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81UH-008oEB-1M;
	Sun, 12 Oct 2025 19:12:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 09/10] smb: client: let destroy_mr_list() call ib_dereg_mr() before ib_dma_unmap_sg()
Date: Sun, 12 Oct 2025 21:10:29 +0200
Message-ID: <dbfcd599ca86c5fb47099d2d8ed22f7520f26c90.1760295528.git.metze@samba.org>
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

This is more consistent as we call ib_dma_unmap_sg() only
when the memory is no longer registered.

This is the same pattern as calling ib_dma_unmap_sg() after
IB_WR_LOCAL_INV.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 21dcd326af3d..c3330e43488f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2365,9 +2365,10 @@ static void destroy_mr_list(struct smbdirect_socket *sc)
 	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
 
 	list_for_each_entry_safe(mr, tmp, &all_list, list) {
+		if (mr->mr)
+			ib_dereg_mr(mr->mr);
 		if (mr->sgt.nents)
 			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-		ib_dereg_mr(mr->mr);
 		kfree(mr->sgt.sgl);
 		list_del(&mr->list);
 		kfree(mr);
-- 
2.43.0

