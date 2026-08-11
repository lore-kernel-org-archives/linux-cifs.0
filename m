Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13448233933
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 06:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428108; cv=none; b=Veg5fLaQo3jrXJiDP/zmHs1x4tUOYy9aVTQJivqEle8B4oNJq546AzXwdLHxto2cSk4hxKNJC1QdAQjyyS7SVx6S+vdpysPU+mJZ3kM8tBjyQlrXT/tCDs8geXZNLQoM3mhvGZjOx3Sj1caXfGqOJfV5k31HKYlugwsch3NOm1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428108; c=relaxed/simple;
	bh=mUrryR+QjSC9t2gzsWT14ZSLCIEreNSKBA4BbRAvMrs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lpidFxAcRFVgQNlVX6X7XZieSup6WcSAplYcix7r4MBGyLpza6o68T3ntmouuLe5A6PbbidZuORRTL2+7/3IwoP6a3s9MXJSlxAL45/xFdN7taL0tHWIVX567QYzpAjX+hosJHCApH38/rmzl5cGE23X9NBu6GF70VlmU2zBZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1a765100954a11f1aa26b74ffac11d73-20260811
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:70c9462f-3a3a-45ee-95f7-68620a6df8eb,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:70c9462f-3a3a-45ee-95f7-68620a6df8eb,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5e7896394b5c551333d75147eff74617,BulkI
	D:2608111401375OCKQP2Z,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1a765100954a11f1aa26b74ffac11d73-20260811
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 734321179; Tue, 11 Aug 2026 14:01:32 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	ronniesahlberg@gmail.com,
	pc@manguebit.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	hehuiwen@kylinos.cn,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 0/3] smb/client: Fix some issues
Date: Tue, 11 Aug 2026 14:00:44 +0800
Message-ID: <cover.1786427463.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on the analysis from Sashiko, fix some issues.

Ze Tan (3):
  smb/client: mark missing nlink values as unknown
  smb/client: preserve open info type across compound queries
  smb/client: decode reparse metadata using its payload type

 fs/smb/client/inode.c     |  9 +++++----
 fs/smb/client/reparse.h   | 17 ++++++++++-------
 fs/smb/client/smb1ops.c   |  8 +++++++-
 fs/smb/client/smb2inode.c | 16 ++++++++++------
 fs/smb/client/smb2pdu.c   |  1 +
 5 files changed, 33 insertions(+), 18 deletions(-)


base-commit: c0a27675eaf08255017b3cabc28c99c0cd71f468
-- 
2.43.0

