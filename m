Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9375320C48A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094146; cv=none; b=VQ48VPiLvh0J/xxGxBXAsjbjEEDTf3muIITuuBW2cfr5PrkmasMNex0H+CyrkfHsDCZ6Esza6FldRgXA5ParesYNmKxuMcRwyiC8H104ZY3RvFvfm62tZqtGvfUOlUr8amHoG4fwpJLn3ZjnnLEntLc0J2d3uanDI62SsdCImg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094146; c=relaxed/simple;
	bh=A1wzk0p3uG5LTDx+rHZPFInDeq6LsRxrvluctRygiPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hifsC6buMSkt2828EI80mDw74BRpXljixB/Owt2QnU2w+mdgTv5His+fzyXNZQfSVcVUHGDMczhkqOZrJOVPMUHdg91DLoHvRmUF2UvjiyehjloypblO916lLzbcV2iRN2oJrZFmqLNZTwfGWPTlJ/kzxQvHRkP27DFr1EyUvws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pRfAjVAt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pRfAjVAt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wOnXOIAXm1j8QawORK0SKlEutsnHaqh1y2eOYjmixi4=; b=pRfAjVAtnbxu4budRCylsuv7+C
	2t0YMdV1PVqzv2C3JSGFDKxkrz1HRD+99QbFaEV1b9BI9IGDdKfoAK9YXk7asIu1dqPq9tKnE0cms
	ZTTN8Z+ZSrmxa4FaeWEmy9b7RCDnAKImclqLDFeQ7TYcX0rKT4y4+O7FP7ZQvDY4+MDbBMMrxn3pz
	Iz5q8/+ZOT2/xRszbqWfe4tYuYdGRiPaPpFNiXAi1lsSK3w7vpKDWtDNimnF1FaVQ3PP9BVnzTlqg
	KYpn1NVAIYkhyk/oefXEXdXoye1dlDZtvtVEpfkxns0DM9bW/HBDv97s3hUjCDoEG5oZBW5iYFf5z
	mOlmnPJ8Cbn3ECcL2GzVJIc2WBm2bHGkgfaXzcJ2pc8W4QjGOfSNRFLDUCnFqweMMZT50UHoVC7Bc
	sUsU9GMHJwqOlXyATyvmgz7wJ/aA6HHeBSTiJfYsXU788qMEbPyPd7bVieg7UVCII3VDSkS/dau7V
	vi0P4r/LmuTHIRfhCjwcDoC7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxOo-00Fdg2-3C;
	Tue, 25 Nov 2025 18:04:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 070/145] smb: client: make use of smbdirect_frwr_is_supported()
Date: Tue, 25 Nov 2025 18:55:16 +0100
Message-ID: <10a7ab588dbc3e3a63aabd4dbbd094ecd726caff.1764091285.git.metze@samba.org>
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

This an exact copy of frwr_is_supported().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d2359d6b18ba..11c72871981d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -784,20 +784,6 @@ static struct rdma_cm_id *smbd_create_id(
 	return ERR_PTR(rc);
 }
 
-/*
- * Test if FRWR (Fast Registration Work Requests) is supported on the device
- * This implementation requires FRWR on RDMA read/write
- * return value: true if it is supported
- */
-static bool frwr_is_supported(struct ib_device_attr *attrs)
-{
-	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
-		return false;
-	if (attrs->max_fast_reg_page_list_len == 0)
-		return false;
-	return true;
-}
-
 static int smbd_ia_open(
 		struct smbdirect_socket *sc,
 		struct sockaddr *dstaddr, int port)
@@ -815,7 +801,7 @@ static int smbd_ia_open(
 	}
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	if (!frwr_is_supported(&sc->ib.dev->attrs)) {
+	if (!smbdirect_frwr_is_supported(&sc->ib.dev->attrs)) {
 		log_rdma_event(ERR, "Fast Registration Work Requests (FRWR) is not supported\n");
 		log_rdma_event(ERR, "Device capability flags = %llx max_fast_reg_page_list_len = %u\n",
 			       sc->ib.dev->attrs.device_cap_flags,
-- 
2.43.0

