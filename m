Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D7D231830
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 01:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782090770; cv=none; b=cvX0gw2oTVqb/9raC98sZs+YIi8VlNLn52yzYj7Wd+v23WSUBN46pzOwC4T7LH/LrTrpFvnZ8KgZ55PwmsRNFbci5rlm9vzgdNgqPKce2kkOcnSN7f4Rz9yuCeVINxHBUnEzjESDWbDcO/9EK7oHZOsmrgmrvtyChPoU/NB+XC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782090770; c=relaxed/simple;
	bh=ZL0RsJXsDva/kSoEAE4s0ZBcbHLvQidFRB14CuzXEyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDAKAdL5VA3306eKLpHdtHygf8WM6zJE7awviik23Y4guCddOxHRnf6BG5tBHj8oGSjgJiqHNuGPETjJzVKRyjmTn+G2mfcNiaaZw8tDFAlOMOMkUVQ6Vrw4WJbiwSXOP2DyYscZA2FcfqadDC4BtQyX4RNzfrwEG+Abb9MTBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OR4Zw9cN; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OR4Zw9cN"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6a0eb19ff49so1184707eaf.1
        for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 18:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782090769; x=1782695569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cde+RaWC7cPslHMTXY6U3ICGFU8ZJ4GFM5kTVThp5hY=;
        b=OR4Zw9cNsLQDGXmthgqHEXBxq53OR4mTP0YDsDv/WaB899R+17BU6M/tG9StoWkJan
         EHO1XYOAHCN9FlG04pBhLTlQ8VhNKaWHsdbtLuAhvJ425WN+9ge61SpT7CdJJZ4g6kex
         XJ+GdRktDxmS0vAqY+/JevE4brxl7axb+s4gkK4lV6/41CAzWxG75s5wBFTiwUr27rQk
         UNzRSZKtTZsT4mzBawuomKPFL1bK1tRuyPqilIUNBHU0zQWODS6pbE51BUe9jGnlitaC
         BsVQUcYf+sbWJfADYUUpr4jfXaOQlaKLkJeg9jKSyknLwcv0OmKrNC3pJ8Rh6RUh6DhM
         X1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090769; x=1782695569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cde+RaWC7cPslHMTXY6U3ICGFU8ZJ4GFM5kTVThp5hY=;
        b=aofNQ0B6qp2r+JVKMjU42pZ4FBNc0se5sdXkTxnLhYmeCCy1fhSHOASKc4q6CiyeNB
         WWsVk8RTLqkgmACTQGmCLZIiriqDQgLQIxdyWsigqbffog9M99DPq+uiSS0hjqPG3VhW
         bIQjo3DbX5EVjpCv3so2Xe5IU5Fb13KqJxUk2dbJkVfCIFy6Yy6evy6ss7AK1phaHKWn
         iRO6OqHjpIjByatfFnE0TJXhb29BHBcQ2SqRtukbuyzSA189J8sLioW71Nv5L0eAFOEb
         jt2td4XbtTOFtnzXQ7w7U2hpFxLJCu887S6+6070DN8KC5jNpvP4uJFNzQA1+eAP0eUe
         eTRw==
X-Gm-Message-State: AOJu0YxZ1WolmfhO3IK6PTnfFmqOWsCKVDY1CVYfDDmsvB1hhO1BCvkq
	QY3z5VJA5vRXzTYhNxCLOimle51X76CFk+R1arSApgacZRGdQN/AjjKx40VLRUjo
X-Gm-Gg: AfdE7cmVjBp/fyxIgNfEUxkAg9JnLDjqdQaaSuyemrlX8byBPrv2Q+ZolMELlQSvIQk
	x2+P0XGDoiOa1n6/1unxfv63zbQjuE+8di5i5R/2NhxuxCQbtwitpoD4rI7Gu9uynqnOoNNu95d
	kdvezA5g+G/E1X5dYt6BZB2Ez0/tadQpNWOMcbe2NwVlDT1y8uz1gJ9A0EQb/ZXkd91daCiJzpx
	tKG7hK+1nMYG88rYzQ8jM3YMQAbNGbBs/W6i5Igsql4PuOyBNHyszrEQdIMuB0toPFiKxuEDS1y
	Q1nuanasIK4UmiQoujKtEBP+80C0btwAATfTShgZ1TJYhsWtnNvazKMEeJhyYpabqkSfhzWNoKj
	O/MevRV1Z2ebMYf9Vevg1WcOPLFv19pgNK4h+K7zroOZ73XxGuHB3jbydC2pMkjOIZHsfM/mnH8
	2CtTrUZz/a207JiPKWUmu4P0n46AyO2rHSchuMnAqJxaN/pFfRdDF4+9sTAwrFaEirjFfxI32GG
	CDy7ERCRRKdUjJNWPlF1rpzYboW/DCW/TaxN6IZ+rlb6oV3N77+7RNoOqGBpPSSDrj+y9ProFDQ
	5c8CYUhj8Dsi0pXnTd6Uwvss2Uc=
X-Received: by 2002:a05:6820:200a:b0:6a0:f2b9:c318 with SMTP id 006d021491bc7-6a0f2b9cef0mr5991000eaf.7.1782090768735;
        Sun, 21 Jun 2026 18:12:48 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:fe9d:7f65:95c3:3c73])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ec52815sm5206853fac.1.2026.06.21.18.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 18:12:47 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 2/3] smb/client: fix security flag calculation when setting security descriptors
Date: Sun, 21 Jun 2026 20:08:16 -0500
Message-ID: <20260622010838.107524-2-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622010838.107524-1-stfrench@microsoft.com>
References: <smfrench@gmail.com>
 <20260622010838.107524-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ralph Boehme <slow@samba.org>

In id_mode_to_cifs_acl(), aclflag was initialized to CIFS_ACL_DACL by default.
This forced the client to request setting the DACL even when only an ownership
(chown) or group (chgrp) change was being performed.

Let build_sec_desc() do the proper flag calculation by initializing aclflag
to 0. build_sec_desc() sets the appropriate bits (CIFS_ACL_OWNER, CIFS_ACL_GROUP,
or CIFS_ACL_DACL) depending on what actually changed.

If build_sec_desc() results in aclflag being 0 (meaning no changes were mapped),
exit early to avoid sending an empty security descriptor update to the server.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifsacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 5bbf73736358..535f3e8d6b92 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1738,7 +1738,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 			kuid_t uid, kgid_t gid)
 {
 	int rc = 0;
-	int aclflag = CIFS_ACL_DACL; /* default flag to set */
+	int aclflag = 0;
 	__u32 secdesclen = 0;
 	__u32 nsecdesclen = 0;
 	__u32 dacloffset = 0;
@@ -1837,6 +1837,11 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	if (rc != 0)
 		goto id_mode_to_cifs_acl_exit;
 
+	if (aclflag == 0) {
+		cifs_dbg(FYI, "set_cifs_acl aclflag=0, no change mapped\n");
+		goto id_mode_to_cifs_acl_exit;
+	}
+
 	if (ops->set_acl == NULL) {
 		rc = -EOPNOTSUPP;
 		goto id_mode_to_cifs_acl_exit;
-- 
2.53.0

