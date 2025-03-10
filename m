Received: from ksmg01.maxima.ru (ksmg01.maxima.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F50522A7FD;
	Mon, 10 Mar 2025 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741615519; cv=none; b=YId4cFCma2wabJ2ckR0pv3AhEl/DZUilDGFgAiEx3KDkR3/s8gy6OGjJ/KIG43LdQwr0I9ndSvJ9P+6wp04JT8FMKiw4TrJY/1lE+eQFX4pbqSgN00bxm5NisOXPsVVIfQzLnTbZLaPmnpr3InXyqF/ADqQaZuikCbq7RekjrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741615519; c=relaxed/simple;
	bh=whtOw1E43xFawjustlXCPBOoe7oWD2o0R5JAIJpkqio=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s+OPRDALon8dC47a9HiQgTGWQIgVSPqybDy0vFoGmxT0uDImR726LlFCv3YjxOuUFii0cOU0I0ddBfzLVKBopDik5Fhn0rTXKwkBIfjWkakOzYxNC2JTwBNnVJTdMyqhSLLmHxFLuSF6i0ux0iIdq2EL+EF9dM4flj0ULb8XTYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=rRVWAj1p; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="rRVWAj1p"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id 78827C000F;
	Mon, 10 Mar 2025 17:05:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru 78827C000F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1741615513; bh=o7zdU8UMQ+WdZBl+qEXuspEhObBUPmPtiONVmKcSePo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=rRVWAj1pAOGJm7g6UNt7TNoe6U5ybY2vyab9gGGa/l+HDVlsg4AG/H9OQyQqv+fov
	 xNcUZji2io/ygj9pY7n446MohPLqbyras8NbU8jfBkgx/AYo9zHwguC+VasNM3wJAR
	 G/gxiO4LSpD4iGfFs9RxMt3+JhvXFjy8P0vmzAZsHvoFBoyusSupKsGND+Q6f+lxHp
	 J42nxt2FTIj2LvQdGxCcTPAadacKcb1wj1zljc45NRpOyQa0B3te9pBAK8Nwmirt0u
	 Q1/r8TR9KihmM62WzFP9jSuGbkVX589E6HLiRXQWi6vSyhIOwIMcLiVrU2MXd/zuOn
	 dCIRqGjnqF1Ng==
Received: from ksmg01.maxima.ru (autodiscover.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Mon, 10 Mar 2025 17:05:13 +0300 (MSK)
Received: from db126-1-abramov-14-d-mosos.mti-lab.com (172.25.20.118) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 10 Mar 2025 17:05:11 +0300
From: Ivan Abramov <i.abramov@mt-integration.ru>
To: Steve French <sfrench@samba.org>
CC: Ivan Abramov <i.abramov@mt-integration.ru>, Paulo Alcantara
	<pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] smb: client: Remove redundant check in smb2_is_path_accessible()
Date: Mon, 10 Mar 2025 17:04:58 +0300
Message-ID: <20250310140458.249202-1-i.abramov@mt-integration.ru>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mmail-p-exch02.mt.ru (81.200.124.62) To
 mmail-p-exch01.mt.ru (81.200.124.61)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: i.abramov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {rep_avail}, {Tracking_from_domain_doesnt_match_to}, 81.200.124.61:7.1.2;mt-integration.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;ksmg01.maxima.ru:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.61
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191623 [Mar 10 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/03/10 05:18:00 #27694722
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

There is an unnecessary NULL check of cifs_sb in smb2_is_path_accessible(),
since cifs_sb is dereferenced multiple times prior to it.

It seems that there is no need to introduce any NULL checks of cifs_sb, 
since arguments of smb2_is_path_accessible() are assumed to be non-NULL.

Therefore, this redundant check can be removed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
---
 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4dd11eafb69d..6958825431af 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -969,7 +969,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			if (islink)
 				rc = -EREMOTE;
 		}
-		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;
 		goto out;
-- 
2.39.5

