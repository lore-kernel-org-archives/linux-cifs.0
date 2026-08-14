Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CF33ADBB4
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675048; cv=none; b=lJm6HfHIUQmI2sRCJBP8Fv7231mjVDqYPJUhT6t9y1/fJ/AlO8PelR61BfjQEE6X33w9disecIAKdbg4r5HW9P5B2T0MnFjv+L3UicCsFZ3T9tblMk8zSL6KBvXfce+3QgLwAh5kyQXE1Y7+fsDLMOrQkB6o2PMnhlLW6jYcA3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675048; c=relaxed/simple;
	bh=3mP90nEPSvzgKn26ggqipLAS4Ti+7gWqYAdvkLjr5iY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gqFol01n7pxtU3N5PQ2+yi3JdUd5eQtVXrQGYMgqF7oVAOivVub1k10zKXv67figkaid5PXLv66fYRoS9rYpOKPmDNih/SI0xZf0MrA4bt6NHyGX6xu3bg/135jmOuvwBhX+qmiRzo/DmzH77haHyQu/pBZqHQ2lp86spW9UGnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0f6beb12978911f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:82fb176c-ffc1-427d-8bae-32e1bee4f3e2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:82fb176c-ffc1-427d-8bae-32e1bee4f3e2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:8cdf90c157222993a513813ebd6cba50,BulkI
	D:260814103719UYJ8EOVC,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0f6beb12978911f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 742143364; Fri, 14 Aug 2026 10:37:15 +0800
From: Ze Tan <tanze@kylinos.cn>
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	constant.lee@samsung.com,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 0/3] smb/server: fix some bugs
Date: Fri, 14 Aug 2026 10:36:28 +0800
Message-ID: <cover.1786674373.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ze Tan (3):
  smb/server: fix tree connection leak in smb2_tree_connect()
  smb/server: check create_proc_sessions() failure
  smb/server: check create_proc_shares() failure

 fs/smb/server/server.c  |  9 +++++++--
 fs/smb/server/smb2pdu.c | 10 +++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)


base-commit: e7317f3e411724b3e8ba813bb2c09a5c7d381327
-- 
2.43.0

