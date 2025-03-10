Received: from ksmg01.maxima.ru (ksmg01.maxima.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F47511CBA;
	Mon, 10 Mar 2025 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741615495; cv=none; b=Z+DbP1HBWM89DgHrcDY2cuJQL80ciG2uSdUmuQRzsDfCLMbiq/G1QTXlxam1CicuDHRbRaWtI1PbISI7+Miax6t1SgzwyN0o/gm0LmSdW25v4Ynhg9XmhI/K9BJqaQ0ISddId2xZlAMfqIdRItLYjFMSBN+2fd/rfdLi6kFDLXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741615495; c=relaxed/simple;
	bh=olkjS179wimSfxtgPV3Vx41TMpO0BQoPcjRSzc89dpE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZE8QRq94iuDTQaMgXnlzBcWslYGfW1HhSluFoMNXa1kkuY9KB45dgEDtEbDfTHH7GzL0378ANW2pkXaKber3w8WLXLP3/p0K8HbwGdmq4EMIqjFEWBaBQG2jHheBQKez3fmcDpmPOk/cZhl3Z/mxD0igxET29DuCzw90dONbF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=jA/gkYzi; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="jA/gkYzi"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id 2A785C000C;
	Mon, 10 Mar 2025 17:04:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru 2A785C000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1741615480; bh=UHlBnklIHur729VNFScUIRdriOCA2AaGF+3TlDhQgts=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=jA/gkYzidS4ivy916DokGVn5s6hu5xv8pNro9jewPcciz568XJs1lF9ROz2ltiLRj
	 FjVm8ZE8Jm3aQkrWrxilSVz/KF13m6Z3WTBGP1PWIPiZ5MfHakOtluaHI75el9iu0M
	 vG+zm1lyQM4ebIuHhqXYzGNRQbjvjC90XzQ8zZEkoPYqX5YDffUwFrDTtcg8m5Jq0T
	 ElDlNrWx1He1+qr1UIwor0vMGJkIRI309UWtILeKLOvmP67RlBLVrUk0y2S941JwS2
	 O/no1jWmcgQVCQCMnWucIbmRnknIoo8WG0p79d13uLj3kAzh/uYogDCSLpyPnKOX7i
	 HpugK1+m0JHqg==
Received: from ksmg01.maxima.ru (mail.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Mon, 10 Mar 2025 17:04:40 +0300 (MSK)
Received: from db126-1-abramov-14-d-mosos.mti-lab.com (172.25.20.118) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 10 Mar 2025 17:04:38 +0300
From: Ivan Abramov <i.abramov@mt-integration.ru>
To: Steve French <sfrench@samba.org>
CC: Ivan Abramov <i.abramov@mt-integration.ru>, Paulo Alcantara
	<pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] smb: client: Remove redundant check in cifs_oplock_break()
Date: Mon, 10 Mar 2025 17:04:06 +0300
Message-ID: <20250310140406.249169-1-i.abramov@mt-integration.ru>
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

There is an unnecessary NULL check of inode in cifs_oplock_break(), since
there are multiple dereferences of cinode prior to it.

Based on usage of cifs_oplock_break() in cifs_new_fileinfo() we can safely
assume that inode is not NULL, so there is no need to check inode in
cifs_oplock_break() at all.

Therefore, this redundant check can be removed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8582cf61242c..66b775ae2f82 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3082,7 +3082,7 @@ void cifs_oplock_break(struct work_struct *work)
 		cinode->oplock = 0;
 	}
 
-	if (inode && S_ISREG(inode->i_mode)) {
+	if (S_ISREG(inode->i_mode)) {
 		if (CIFS_CACHE_READ(cinode))
 			break_lease(inode, O_RDONLY);
 		else
-- 
2.39.5

