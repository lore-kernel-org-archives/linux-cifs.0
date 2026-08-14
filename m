Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7DB3D5643
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675047; cv=none; b=tP/DFOWKIV6dZA8ZyEbipsiO/j2D03cflzpZtyNb473ITrSD/i9dQANbfx2gfM9XG8K/+d2hpYaZhMrYcpzwvTwEid9c+YbwHNnEttHlmmL582Z7iZKKJvC47/EbwYu4+O3H7tOJPtZ5EHP8o19ODL4Hkqnmo5eN2PxSEo17TTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675047; c=relaxed/simple;
	bh=sgxk7zssiev+fgPjcyfdQiDP4YBPIKsyKoYp6vIECZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T16UAi807YjNMpdpRQhA7HvKwcqbZz1zuKYNEeMyAtylCZKjK/o+e3he0AEm1uiM5F90xHUmIXDQrZw8hASz5NXAN/ArIkfjIQHv1EU7ADtRV8R1Twak8RZ3vW4OdUi2ODK4DV8u8D1U9c/eQ6amCDeVQamYAQDO64z2OMVUNx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 10605c9c978911f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b5f99b02-6c2f-49ea-af7e-de431b5ca8c7,IP:10,
	URL:0,TC:0,Content:100,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:90
X-CID-INFO: VERSION:1.3.12,REQID:b5f99b02-6c2f-49ea-af7e-de431b5ca8c7,IP:10,UR
	L:0,TC:0,Content:100,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,AC
	TION:quarantine,TS:90
X-CID-META: VersionHash:e7bac3a,CLOUDID:c4386f4f5b3c34354f6d9af1d9b18910,BulkI
	D:260814103719Y8ILKDGL,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|127|1
	36|865|898,TC:nil,Content:3|15|50,EDM:1|-100,IP:-2|1,URL:0,File:nil,RT:nil
	,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 10605c9c978911f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 173292910; Fri, 14 Aug 2026 10:37:16 +0800
From: Ze Tan <tanze@kylinos.cn>
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	constant.lee@samsung.com,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 3/3] smb/server: check create_proc_shares() failure
Date: Fri, 14 Aug 2026 10:36:31 +0800
Message-ID: <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786674373.git.tanze@kylinos.cn>
References: <cover.1786674373.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_proc_shares() returns -ENOMEM when its procfs entry
cannot be created.

Fixes: b02a77726ed0 ("ksmbd: add procfs monitoring for active shares")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/server.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 14431adce9b8..3c318f529927 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -627,7 +627,9 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_proc_cleanup;
 
-	create_proc_shares();
+	ret = create_proc_shares();
+	if (ret)
+		goto err_proc_cleanup;
 
 	ksmbd_server_tcp_callbacks_init();
 
-- 
2.43.0

