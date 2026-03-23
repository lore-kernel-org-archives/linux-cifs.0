Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5832F28FF
	for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 09:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774256926; cv=none; b=pRHdZ8pluIT/xy+7XWmWfAlfnROCRq1t16+zERiofEeSQp4Hn6EZWUJgBaS1wWN8G7bC5ulR0Y3+Cmokh1//scMjU0aLOCaM8xnL4NrHZJuhdWoJOGBaMr4ML9SLlmu3ObuWmy79brmQlKt63QF1qaMCpalYILJH9hCqizAVfR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774256926; c=relaxed/simple;
	bh=2q1v7HMKGNN4tMttPFFVVqzYRID9mWhOedrXWROXxdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxBCvWoISbKOyRIbCS5xm+xOr5ddfTJL1heNb21dZQLaPcbI5q6mW9WcubD6A/9v8Dqgkvl9sKirMfqvCniDjTbn8nc8aNAxvEgzLYODa+D1iOlfNaHL6OTDsKlIJI7+Yw+XeJZWM6GZsODcrxthKOqfIdyl0GnCjqPTbY8Iz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e11997b2269711f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:7f559bc3-1227-49b9-88e1-328c51209e80,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.11,REQID:7f559bc3-1227-49b9-88e1-328c51209e80,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:89c9d04,CLOUDID:df98d1e882067e557fde354e737cef48,BulkI
	D:260323170839666POMG2,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e11997b2269711f1a21c59e7364eecb8-20260323
X-User: hehuiwen@kylinos.cn
Received: from harry-wujie-series.. [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 546897551; Mon, 23 Mar 2026 17:08:38 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] smb/client: ensure smb2_mapping_table rebuild on cmd changes
Date: Mon, 23 Mar 2026 17:08:12 +0800
Message-ID: <20260323090812.918663-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current rule for smb2_mapping_table.c uses `$(call cmd,...)`, which
fails to track command line modifications in the Makefile (e.g., modifying
the command to `perl -d` or `perl -w` for debug will not trigger a rebuild)
and does not generate the required .cmd file for Kbuild.

Fix this by transitioning to the standard `$(call if_changed,...)` macro.
This includes adding the `FORCE` prerequisite and appending the output
file to the `targets` variable so Kbuild can track it properly.

As a result, Kbuild now automatically handles the cleaning of the
generated file, allowing us to safely drop the redundant `clean-files`
assignment.

Fixes: c527e13a7a66 ("cifs: Autogenerate SMB2 error mapping table")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 26b6105f04d1..1a6e1e1c9764 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -48,8 +48,8 @@ cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
 # Build the SMB2 error mapping table from smb2status.h
 #
 $(obj)/smb2_mapping_table.c: $(src)/../common/smb2status.h \
-			    $(src)/gen_smb2_mapping
-	$(call cmd,gen_smb2_mapping)
+			     $(src)/gen_smb2_mapping FORCE
+	$(call if_changed,gen_smb2_mapping)
 
 $(obj)/smb2maperror.o: $(obj)/smb2_mapping_table.c
 
@@ -58,4 +58,5 @@ quiet_cmd_gen_smb2_mapping = GEN     $@
 
 obj-$(CONFIG_SMB_KUNIT_TESTS) += smb2maperror_test.o
 
-clean-files	+= smb2_mapping_table.c
+# Let Kbuild handle tracking and cleaning
+targets += smb2_mapping_table.c
-- 
2.43.0

