Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB72D949C
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715541; cv=none; b=XJAYSwW9czlZPq8MkYZqAyV3MCjAJRseaZIpvTRATJ0thsJnAFwSq9Cs9ddN4XT+qLS2b/jjxO12OG0nQZcMII5mPES49qQ+Fh+KzvGlTg4srYsi45FKvvTllVamyCT4FO3wz00ilyxyvEjdD3AoAMcy07Bzgb8VHLMs7BdQjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715541; c=relaxed/simple;
	bh=ji4c89hovT3PANHSgY85FJSeJpOlwH5xRD/By3cEMuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hidxjpHRiHcSztsSXLu4YNvwjuHICb6xuA0XlqjXV2JcLY+B37eCFbK5ckI+J89F2ACNpegN9R2KRUrCReMroA0+vv7jHl5I9ck18w1Dw6Pyz5ncPF7gmorm45gc7n/295Aq6ywgPgYuTcNt3HdDofc2gWaw/0ByWNQcQBSFxng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 576ca65097e711f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:90696e61-4475-439e-bcbf-d8312cbf52b6,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:90696e61-4475-439e-bcbf-d8312cbf52b6,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:972e5b98a957de2f5efdd9fff602736c,BulkI
	D:2608142152131JPR6VMI,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 576ca65097e711f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from workspace-fedora [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 562877826; Fri, 14 Aug 2026 21:52:08 +0800
From: Ze Tan <tanze@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ze Tan <tanze@kylinos.cn>
Subject: [PATCH v2 0/4] smb/server: fix some bugs
Date: Fri, 14 Aug 2026 13:51:40 +0000
Message-ID: <20260814135144.302443-1-tanze@kylinos.cn>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1->v2:
  - Patch #01: Print a warning instead of aborting initialization when ksmbd_proc_create() fails.
  - Add patch #02 #03 #04.

v1: https://lore.kernel.org/linux-cifs/cover.1786674373.git.tanze@kylinos.cn/

The following patches from v1 have already been merged into ksmbd.git ksmbd-for-next-next:
  - smb/server: fix tree connection leak in smb2_tree_connect()

Ze Tan (4):
  smb/server: warn if ksmbd_proc_create() fails
  smb/server: fix session leak in ksmbd_session_register()
  smb/server: update session counter under sessions table lock
  smb/server: fix session counter on session removal

 fs/smb/server/connection.c        |  3 ++-
 fs/smb/server/mgmt/user_session.c | 32 +++++++++++++++++++++++++------
 fs/smb/server/server.c            |  8 ++++++--
 fs/smb/server/vfs_cache.c         |  6 ++++--
 4 files changed, 38 insertions(+), 11 deletions(-)

-- 
2.55.0

