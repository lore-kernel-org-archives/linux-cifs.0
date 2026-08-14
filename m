Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6EB3D5643
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675049; cv=none; b=sC+BNRPJHUAyH9VMAxV44NVNlfXFnVJJb65bX5tObJ4KUhxpra0nwRdY4LyNBmupBz69jBaOSKqyhDMHS3Mzb0ZaeszzLaZ+L4fEQvj9LV7iNR0MUnwTCvZm/qqxbkZNO4IrbEG7NMH/S8J6xuin/tRVTtwt3EA5kNJXKnIh1C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675049; c=relaxed/simple;
	bh=KywhqDIkC7E3nsU7ExGw3J7qBmG3OF6XntW6QXfWPYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj7u1UENmDCUZjPWNmMSNWEh9BtUWLzKcBqaKvKw5jCTvJaj9vo4ecQZAw/4hOKS4H8OuGhrCYXFboL1sNWs7KgKyfeBhqqcojCyHAZbnF8Pem3RV1J/24s9ZCtc6HNzgNYrwQFLz2JUY3XzRQFanRVw7bq7C2svUqzGsxp5beQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1015605c978911f1aa26b74ffac11d73-20260814
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
X-CID-O-INFO: VERSION:1.3.12,REQID:48a6af2d-757f-4938-b8d7-76fe5b462e05,IP:10,
	URL:0,TC:0,Content:100,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:110
X-CID-INFO: VERSION:1.3.12,REQID:48a6af2d-757f-4938-b8d7-76fe5b462e05,IP:10,UR
	L:0,TC:0,Content:100,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:110
X-CID-META: VersionHash:e7bac3a,CLOUDID:43db352d855bb06b059609cd6b9577f9,BulkI
	D:260814103719OF0COB70,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|127|1
	36|865|898,TC:nil,Content:3|15|50,EDM:-3|-100,IP:-2|1,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1015605c978911f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1736824982; Fri, 14 Aug 2026 10:37:16 +0800
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
Subject: [PATCH 2/3] smb/server: check create_proc_sessions() failure
Date: Fri, 14 Aug 2026 10:36:30 +0800
Message-ID: <66350fc01028af59c6cf7976a7fb9040361347cf.1786674373.git.tanze@kylinos.cn>
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

create_proc_sessions() returns -ENOMEM when its procfs entry
cannot be created.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/server.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0ccd123ba418..14431adce9b8 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -623,7 +623,10 @@ static int __init ksmbd_server_init(void)
 	ret = ksmbd_proc_init();
 	if (ret)
 		goto err_unregister;
-	create_proc_sessions();
+	ret = create_proc_sessions();
+	if (ret)
+		goto err_proc_cleanup;
+
 	create_proc_shares();
 
 	ksmbd_server_tcp_callbacks_init();
-- 
2.43.0

