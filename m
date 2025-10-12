Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A72EDD6F
	for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296285; cv=none; b=pXNsQ1JPuoq2qPPSPYYZEwJPqDJpHD629LVG698XuF0NVUUEDV6+6+yfl9diwzz1/fOzLd0tpQS18n6wbkBYlq2PuiZgGIGDffj7M6a4YzmgHJa/EwM7RdiXaEXZcZPg24oyhzwfElC811ISinCh/jj1KLBDUj4pFmdg9NgRRp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296285; c=relaxed/simple;
	bh=Nn7YRr63Irr+55T29cLX7rrgJATUzLK6M4+5dX6mKvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPwKu/f5i36i6aQtYzGYo276mHA9aHjlvvyei0NNdpZ28booSrQLJKySmOs6qJvu+7sXp13hxHCdgjYq6zeoQx39WUcNI4VATE6jr3QDU2bGvNJKPaxNM5X9ezBf8WMvmFwQ6u1+9ulc2IM6XJ1Y2boA31cNtTVtHXMJPOhBS6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AtrHBwJb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AtrHBwJb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=J5xVmUA3KCPaGqEsG6IKVE9aw/iJe0sBfnOQw+nA7xs=; b=AtrHBwJbrZ26MSRPepzruRd604
	xH1Yv+DjJDXoFIlSJMByGbA4idOE5P1NxgLfQipkoe0kSw4KC3QWVjK1ZNzUmcXTIOjzDROAUo/2b
	X90AufBi0uTHUmHjLO7TlC/meyFGkeKgUTA1T2VEwNuvGGErDgl1FeSSxEsEE0u5pjTuTHqsImQGa
	qt8MfonjZ4E6v1xW4ILXU1L0WKqrpQJuhT4lqO7DOVQi1yRH6cLJvMssiKCxqGZJv2hRuPqEofb1x
	kbs5iHzK7IF49QMjCf76WfF34x8qI/N3dvaclERU408NLH7KfnIR08rsLunHp8AbHcoewJMvKn0l7
	/FNtkqAeR2fozLkQ1wsmhKNQKKbsuUUVI4+mVqHKvn62qrYe9FQsdfvKpxLTER9NVKRSFC5WdT8fA
	1UeX6b9+KJVCGA7xVtbJj25EqfEjmzUa7PEzUUiF9UZofnGHhFBv6Gba1Nome9Z03UjYbQU50SaeU
	oUJklscSmH8d7Clb/3QDYYjm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v81TR-008o1o-1N;
	Sun, 12 Oct 2025 19:11:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 05/10] smb: client: improve logic in allocate_mr_list()
Date: Sun, 12 Oct 2025 21:10:25 +0200
Message-ID: <e23ae6bd4e63c6486a36f6e50543ff2aa4982ad9.1760295528.git.metze@samba.org>
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
- use goto lables for easier cleanup
- use destroy_mr_list()
- style fixes
- INIT_WORK(&sc->mr_io.recovery_work, smbd_mr_recovery_work) on success

This will make further changes easier.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 65 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b974ca4e0b2e..658ca11cb26c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2385,10 +2385,9 @@ static void destroy_mr_list(struct smbdirect_socket *sc)
 static int allocate_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	int i;
-	struct smbdirect_mr_io *smbdirect_mr, *tmp;
-
-	INIT_WORK(&sc->mr_io.recovery_work, smbd_mr_recovery_work);
+	struct smbdirect_mr_io *mr;
+	int ret;
+	u32 i;
 
 	if (sp->responder_resources == 0) {
 		log_rdma_mr(ERR, "responder_resources negotiated as 0\n");
@@ -2397,42 +2396,48 @@ static int allocate_mr_list(struct smbdirect_socket *sc)
 
 	/* Allocate more MRs (2x) than hardware responder_resources */
 	for (i = 0; i < sp->responder_resources * 2; i++) {
-		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
-		if (!smbdirect_mr)
-			goto cleanup_entries;
-		smbdirect_mr->mr = ib_alloc_mr(sc->ib.pd, sc->mr_io.type,
-					sp->max_frmr_depth);
-		if (IS_ERR(smbdirect_mr->mr)) {
+		mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+		if (!mr) {
+			ret = -ENOMEM;
+			goto kzalloc_mr_failed;
+		}
+
+		mr->mr = ib_alloc_mr(sc->ib.pd,
+				     sc->mr_io.type,
+				     sp->max_frmr_depth);
+		if (IS_ERR(mr->mr)) {
+			ret = PTR_ERR(mr->mr);
 			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 				    sc->mr_io.type, sp->max_frmr_depth);
-			goto out;
+			goto ib_alloc_mr_failed;
 		}
-		smbdirect_mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
-						sizeof(struct scatterlist),
-						GFP_KERNEL);
-		if (!smbdirect_mr->sgt.sgl) {
+
+		mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
+				      sizeof(struct scatterlist),
+				      GFP_KERNEL);
+		if (!mr->sgt.sgl) {
+			ret = -ENOMEM;
 			log_rdma_mr(ERR, "failed to allocate sgl\n");
-			ib_dereg_mr(smbdirect_mr->mr);
-			goto out;
+			goto kcalloc_sgl_failed;
 		}
-		smbdirect_mr->state = SMBDIRECT_MR_READY;
-		smbdirect_mr->socket = sc;
+		mr->state = SMBDIRECT_MR_READY;
+		mr->socket = sc;
 
-		list_add_tail(&smbdirect_mr->list, &sc->mr_io.all.list);
+		list_add_tail(&mr->list, &sc->mr_io.all.list);
 		atomic_inc(&sc->mr_io.ready.count);
 	}
+
+	INIT_WORK(&sc->mr_io.recovery_work, smbd_mr_recovery_work);
+
 	return 0;
 
-out:
-	kfree(smbdirect_mr);
-cleanup_entries:
-	list_for_each_entry_safe(smbdirect_mr, tmp, &sc->mr_io.all.list, list) {
-		list_del(&smbdirect_mr->list);
-		ib_dereg_mr(smbdirect_mr->mr);
-		kfree(smbdirect_mr->sgt.sgl);
-		kfree(smbdirect_mr);
-	}
-	return -ENOMEM;
+kcalloc_sgl_failed:
+	ib_dereg_mr(mr->mr);
+ib_alloc_mr_failed:
+	kfree(mr);
+kzalloc_mr_failed:
+	destroy_mr_list(sc);
+	return ret;
 }
 
 /*
-- 
2.43.0

