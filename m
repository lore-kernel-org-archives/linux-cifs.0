Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD7314B66
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 23:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778800728; cv=none; b=oBgNr3HdfKOodpl3dbEUKPGPOH4T+rZaDI0V337aBDMnsWHYlVPEq6m0QDrUlIa3Ls6VMkzuV1/HYS8wDAe4mO5/9+Qhm9HO3cOBKaed6BEJtNn/wrgTKcAo0/tjvK/2wGOfDwlZnGb/a9fvh8ipiauuoPgPCLMNifmgkQ4xqMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778800728; c=relaxed/simple;
	bh=XrMkBdpZfBfrwl18U5Iyv7buDmPxsRiikfLipF72/lA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCkKeQg8CkhLRmSMVcBhqNywxIORVXug8NS9VWiaxFOcU+zpu/zAPAS5T6YxT5laQUVeFMcqm4JFwIMbGkcSl6NrpRExBCmlKO3UyJ+95JKj1IsF0Mb2X6dn6PeLSwK2fzlxa9yuImPCDhPoZwV4Iy9ri32nabZ09nKb7p715bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DbA82i2m; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DbA82i2m"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fde648a71so2369135e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 16:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778800725; x=1779405525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CEcjccSetUkCfvsraURt9Kb/3DzTCF6WDljez4BNutw=;
        b=DbA82i2m76lPU415o65a4Wj2eDHXwLy8koNmiLqy6Khr1ZNPAcdiP/nSpL2gcmIiDU
         wqxgYYptZYOkSLJi2Mv5rRBREtZ/Jkcs0hwB+tkU7fJp9WZ1d7oFT80OCtga/Q1OCPvw
         iw0QG6fo3S08CpgSSY+gXqfityvBy9BD0eHIIdCwppvji2XRDQBMA66y1sEj6+BPDESG
         m+IQxo80B40q5NIF0t6acurC7OEOzSS4MtixeJYglmbS0RU2tVqLbQQ084P/ip7Za7sA
         Pr8g4CQxqacIPGLal5UzW3t1MdcvCAVrI/9Zrrw+v+T38eB5LQ6/dkQo9GCj9m8cH/D3
         Sypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778800725; x=1779405525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEcjccSetUkCfvsraURt9Kb/3DzTCF6WDljez4BNutw=;
        b=H4tDKk+4qPhWUbB3zTNw7Ol44VvToJSsEe6t3nYb8qxS2v1OWburNOkZRh78NMZCNa
         fm2MsyxFQcCkTWg+3vRHEZeW2P2JNPX9dBfKBSih+STw0iwdIoniJsfZfsb4sxDD6u9f
         EWBLWeBDO8oo7VayA5JzKSM//HkVGeJus2j4SOIF1XHhtcDO2rcbmuRjJvJZH8NGGenA
         t0akPNR1ZtNte7ZeqqbXNybVkZyl7tkyBTBYwGP0Wvyr4V4PbxnpPeRA1UhLrFPTFKtY
         hsgHiTk/LEHRM9HRntS5MO5T/qdmkdZbTgIM1uzaKnQDlTESpoXW1dj5sL2XB6K7XvaL
         5VfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/OxVKYTeiqsRwMTjl7XcNCpa57ylfAbCS+udSSz1VI7FxGRRZKLqX21rWeJZRqZ2oT9B2YlKsYnuy3@vger.kernel.org
X-Gm-Message-State: AOJu0YyWe9aM835KqlCkdjOMV3UzuwLYnqPtyYwsAEx/NuvFOZzH/4hq
	rf8bCvXmNph4B7ydHaiMBlxpGh6U/JWzOCWiSpElemQLvzHgLEmHAnziow+0J0/f+Pw=
X-Gm-Gg: Acq92OHeIuUH1DyyrN6hjPkgx2TZmhhiD1wfcbVI4BCjcJmrqY+TQ1A+nrm4EtkK4lI
	3Ng0HTzqgXt8IAV1zV1Bamibj9jPfAFi/dvyh3doZzBZ3cLexDLCgSMslbpq4v07fsosAeOvSAu
	5hTy5pcIGVJO9zQNMp476oWDiCRPmtcA/aGQME2eEOOxwqUCGvkERItt6Uqb/3USovqWXeuYl/F
	WNJz7J4/2A8NE3ySy7HKND0T9oOBJVIsDh0xupXhgUx6Ust1IT1tD55ch03rhUH8v4hpPGFW1I4
	J2JZ4Uhd7wZowqbJpLwBJRaqiAVb6jdBMaLt3veYAxKmZSGetFg9yMSjVUAB8Co4bu7kDjXEcLp
	iCb7YtOTIo34pYIhabqugNNSzTMmEC9IFuXH4+B+QdqRdYQINNBYJ9s7A8/x3yHfcK8UYOsKUFx
	Smd19Y8TvJbD4//0L3bseJlK9bHzCa2NhFT18qf3S4pNMTIweBqFUrHSrd7vnG6s+4S1SGqOpKh
	GwN
X-Received: by 2002:a05:600c:a406:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48fe4fa1902mr15869515e9.6.1778800724991;
        Thu, 14 May 2026 16:18:44 -0700 (PDT)
Received: from precision (ppp-88-217-117-152.dynamic.mnet-online.de. [88.217.117.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm39314595e9.1.2026.05.14.16.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 16:18:44 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
Date: Thu, 14 May 2026 20:18:25 -0300
Message-ID: <20260514231825.63211-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 96c4af418586 ("cifs: Fix locking usage for tcon fields")
refactored cifs code to change cifs_tcp_ses_lock for tc_lock around
tc_count changes.

There was missing lock around tc_count increment inside
smb2_find_smb_sess_tcon_unlocked().

Cc: stable@vger.kernel.org
Fixes: 96c4af418586 ("cifs: Fix locking usage for tcon fields")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index e8eeff9e50d6..1143ee52470a 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -169,7 +169,9 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *ses, __u32  tid)
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (tcon->tid != tid)
 			continue;
+		spin_lock(&tcon->tc_lock);
 		++tcon->tc_count;
+		spin_unlock(&tcon->tc_lock);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_get_find_sess_tcon);
 		return tcon;
-- 
2.54.0

