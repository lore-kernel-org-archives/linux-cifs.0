Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668928F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155705; cv=none; b=e4CY+kT8kqqALD69qGjFPq3jm6vQ2M6KSHHFR1UIEt7zQeApRJzgk9Bt1tuorOj9IUdSiPswQEHkE5FoW/7FUAe8z1x+OW/0lRERWnMSlok+hXFBR84PZSN5B1XSipxTgACIM0Mp9WA7bCjIdkDc7kbEz/OYIEaakYVZ64LOBdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155705; c=relaxed/simple;
	bh=QCP2gjTNPgCKOMyTHHyphZaqFiIOamYgdlYwOcVHcJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/0ptfTsHkWcCDvwV1aP8GyM3QklG+7+MAqDwp6kktpSxLMTjNiip6gH/uTNXvDj3CnLOJrVGAV7msTJE4sOxRyKJcIBs6yZKnWwVDYYXSlEvLDmkqisyHm1Q4MEOXNI4TggE2QrpG8yGqFEY9xYX+M1vtjv04lpxhdSv+qRwW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=d3qF8p31; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="d3qF8p31"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=tMWGZkN/PbaU4m2MFYuigvG7W/x4WH+HCJ9x27lTSGU=; b=d3qF8p31N6uaQiVMA+m77KD9qI
	KmtR6y7lNJ6aMApBJAsmAr7/ZrPRD7AniBHBDO967xrRSv++l3QXlKzv9SvhsADaqOWlZF7dHdM04
	3JVBwkrsglcefhx/tHuDYBrBOb4RSUY4/xroGcMl05MMvTakY/e1VAUukiqGPxWT8x98J39s0vm9a
	1cBT0lPthnhhzZq2bvY17BSoeryJ//9HwblRQ6kDmdCTdWrQcBaZyaI7dWb1Kw5IjSqloxhmB+x21
	vND792YGYeePAuNx7TE7AP/+lLsA5YJb6z+F5wViro8hnhnWvoCjWcvBYie/6/AG98YCDshhmoQEQ
	74ssyuUH84FdU2Th0UAE1On6vwehHug00eVMl/MysaV6mxORbmX6cV8vH/0oyJE1/h5nOh1trDl73
	9M3NgbC4eI4p+eL2nELgduKOIXdZS1hPaDO8buajbPBvDSYc2TvGFrCx8R21ojYwEzVeWpKU9vFCp
	SLmp/mednIQxNGnXTOwO4fpl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeJt-000nBJ-2t;
	Mon, 25 Aug 2025 21:01:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 119/142] smb: server: pass struct smbdirect_socket to smb_direct_init_params()
Date: Mon, 25 Aug 2025 22:41:20 +0200
Message-ID: <4911df95f1dab48b26becb8dd19b8c027ee8503f.1756139607.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 08f0128c804c..64af3e3b373a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1756,10 +1756,9 @@ static unsigned int smb_direct_get_max_fr_pages(struct smbdirect_socket *sc)
 		     256);
 }
 
-static int smb_direct_init_params(struct smb_direct_transport *t,
+static int smb_direct_init_params(struct smbdirect_socket *sc,
 				  struct ib_qp_cap *cap)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_device *device = sc->ib.dev;
 	int max_send_sges, max_rw_wrs, max_send_wrs;
@@ -2059,7 +2058,7 @@ static int smb_direct_connect(struct smb_direct_transport *st)
 	int ret;
 	struct ib_qp_cap qp_cap;
 
-	ret = smb_direct_init_params(st, &qp_cap);
+	ret = smb_direct_init_params(sc, &qp_cap);
 	if (ret) {
 		pr_err("Can't configure RDMA parameters\n");
 		return ret;
-- 
2.43.0

