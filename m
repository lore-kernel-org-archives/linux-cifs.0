Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D228688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155263; cv=none; b=k0U3pS54GD360PC9Il9UTmFAgoXS2sBTKfqUdctBmJtm2ImYSNhrJSk2T8AI+u45I37FUpIWRHzP542GOFze1CqTyjM7Uc+vBJxVqbrSAb1G/VgRaLKnXml+xWSi7Cwoty7WdROjrxnGkf3jHTtsAagd5JDGb1gjigd1DqKjLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155263; c=relaxed/simple;
	bh=3cwvaabQ6nOln8cDlyj7o4V+g9KaGFRnJ0QsIFdix2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHvs2yuc1HB4owGNK//knt0zDiNyw8BpVv1pIfc+bGPUR/TpxOMGCxHkUAlfR11NyepWZV/8DH6kYWpfxGM8MBLfZspeiAJieatsf6BMnS++39ip13ueSWwWe1wEvE6U6rN8sAEurAUg7858bcLMTMUD4FKC8U4+td/VKT6+Asc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=enfKGYRp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="enfKGYRp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=x8OsJE/W1lEUAFXssSWU3xsHKu/axgP/3qd1XffcU+Y=; b=enfKGYRpV/pQcwVjZbSjXOWdDx
	CyaDL8Cb8XbwN7yw9gRNHZXjisatjSH4jEqPlKmMJLL2NQsEluYnBWqa19lXVNxNx+yqeQDtMdsaQ
	GwZBBere4qEi7z7bQbD2+zqKtCY62c8vb+UQofa7VBcTvNJwK2TYu9UsoRlilgdPP0wUOdF5GqrEl
	4FZHeCYpr2+Dyl4RUQr+yGPDCgSFbupDfChd/YZ94x3MaZdr+U1zXOH4/GngMwe4sT5ZKpsYAJmfh
	iqbFLsvgy0KS+e/6yc2XpmPqbmrIqZps6ic9tFOxWxVvq5OpQqPytrUBktcjWziJUlqgGP0bjEqZi
	W00pRjXEYMCKG+Lz4XO8EKGIIb5Z0IYIuKFKMexe1bs45yONkWEqYKjliZPd40YIpdgqpIwFSrYw7
	0g2xczG/vy4KwF1oMOMRhg42j1X7j9tDii7F2Qvyp246obq2a4HXdvwwlAAav3tYNhLrGglzBygPY
	U3rJ8qSYQiGhbMADDprS3emE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeCm-000liw-24;
	Mon, 25 Aug 2025 20:54:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 075/142] smb: client: remove unused struct smbdirect_socket argument of smbd_iter_to_mr()
Date: Mon, 25 Aug 2025 22:40:36 +0200
Message-ID: <9cfd603f478d090bb4d2099e34d754917e0aca5a.1756139607.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8033be07bc77..d3cd89bd2cc7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2321,8 +2321,7 @@ static struct smbdirect_mr_io *get_mr(struct smbdirect_socket *sc)
 /*
  * Transcribe the pages from an iterator into an MR scatterlist.
  */
-static int smbd_iter_to_mr(struct smbd_connection *info,
-			   struct iov_iter *iter,
+static int smbd_iter_to_mr(struct iov_iter *iter,
 			   struct sg_table *sgt,
 			   unsigned int max_sg)
 {
@@ -2377,7 +2376,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 
 	log_rdma_mr(INFO, "num_pages=0x%x count=0x%zx depth=%u\n",
 		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-	smbd_iter_to_mr(info, iter, &smbdirect_mr->sgt, sp->max_frmr_depth);
+	smbd_iter_to_mr(iter, &smbdirect_mr->sgt, sp->max_frmr_depth);
 
 	rc = ib_dma_map_sg(sc->ib.dev, smbdirect_mr->sgt.sgl,
 			   smbdirect_mr->sgt.nents, dir);
-- 
2.43.0

