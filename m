Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4541F09A5
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491209; cv=none; b=onWuENCTwLXKJjeWaG6STkkxNj2sDDDLudWWM+7ujPNbo66cIkXAvCLbR7LniFK/gYSm3ruyzPYS45JEAH2aBllalOudvoZknnjg+RKYd1qCsMGldIyEKf3BxK0QyhpPMFXqaHFDOLqQGCewuCFg2yc/oDYO8NczOEdcjznXO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491209; c=relaxed/simple;
	bh=26L7SQING/IT3XvBAdZNPi86RyL9LUOZBIbNeBWgJUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqlWgYsszPr110IIDlwicA9DPymAi2GDudcsxI0qV/Ls4fNVrh88Zd3afJMHI3REroFFHQrgIateNzRXoeo9UiWLbouboM0O/aBKoVC22Yo7mJB1YT2b93CW/7s96+0y0q0NuMKZ5Yx0OvilsfOsCC8YC+ssFsyyse+h571kI08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yp/vTsbd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yp/vTsbd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FKCaanVH/HKvXnWdBLFPgsTvOJnaQFL3U6ZUGyyEI1c=; b=yp/vTsbdKDeGg4q4tZVSrQlVnw
	wB3B4wEGXnqxmWeyJOWVqPhEtCCwgWU75Uk6Apo+7LFs5gevw9+NW54lG/gTADGFlscIoNPIcE6YY
	UfgCLSD2CT8wrODWHL/cfhuvaVkRu5jpHk5DMG3qIaXg12svbdM/3g+YtNqXJ+v9ASfbCHWpNCHRi
	xP3N/HMq+/Aoog7YV1RwR/BsASvd2JzU/2Qlxo6XZafguYAwtj+nA1f/z7x75En77BTvyfbbYBLOU
	GjPO3omNml9/Y8fx1jOlUgdtBTrGMJ7Qbl/WjoW2SpkhP+ivJ3FOjymaBz2DgN94xEY4PZnnd/xVY
	eLWjTVvZWX/2g3c8pHeXcg7Sl7AP9wkgx7IByas/ABEERySbjC4KjLdRFXEcokfQGmW7oGLPJjp2U
	BDsvuxoLTdQgXGVXI65MD/VC3I7nItgi9rV43wuJLKxdCoE12gPGQehcaIQuekpCvSFwVI1RatxFt
	bvinik/gQjFsacc4SVX0bmoJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RtL-005GXJ-0y;
	Sun, 21 Sep 2025 21:46:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 10/18] smb: client: defer calling ib_alloc_pd() after we are connected
Date: Sun, 21 Sep 2025 23:44:57 +0200
Message-ID: <cc7324dd64bc7267a21b2dec956448f32d10d315.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The protection domain is not needed until we're connected.

This makes further changes easier to follow...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e6012523e422..d5e2b3009294 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -926,13 +926,6 @@ static int smbd_ia_open(
 	if (sc->ib.dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
 		sc->mr_io.type = IB_MR_TYPE_SG_GAPS;
 
-	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
-	if (IS_ERR(sc->ib.pd)) {
-		rc = PTR_ERR(sc->ib.pd);
-		log_rdma_event(ERR, "ib_alloc_pd() returned %d\n", rc);
-		goto out2;
-	}
-
 	return 0;
 
 out2:
@@ -1858,6 +1851,14 @@ static struct smbd_connection *_smbd_get_connection(
 		goto config_failed;
 	}
 
+	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
+	if (IS_ERR(sc->ib.pd)) {
+		rc = PTR_ERR(sc->ib.pd);
+		sc->ib.pd = NULL;
+		log_rdma_event(ERR, "ib_alloc_pd() returned %d\n", rc);
+		goto alloc_pd_failed;
+	}
+
 	sc->ib.send_cq =
 		ib_alloc_cq_any(sc->ib.dev, sc,
 				sp->send_credit_target, IB_POLL_SOFTIRQ);
@@ -2002,8 +2003,10 @@ static struct smbd_connection *_smbd_get_connection(
 	if (sc->ib.recv_cq)
 		ib_free_cq(sc->ib.recv_cq);
 
-config_failed:
 	ib_dealloc_pd(sc->ib.pd);
+
+alloc_pd_failed:
+config_failed:
 	rdma_destroy_id(sc->rdma.cm_id);
 
 create_id_failed:
-- 
2.43.0

