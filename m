Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E5421239
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889685; cv=none; b=O2eVdpGluwkDFThrA0opHR5VZIEtQMS3TDUSjA1v9fgBKC9ldNVo4dkZgI+bzKkG8nyi0uVPBOILg2I3mReOi2XOlTnSqjSnAFkPBkDFQvTbD2R/CLUV5oqBGqo3mrC2v26V835QEng3JvNt/0KCWXPoFl4lwSpZbvzRZ5biCRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889685; c=relaxed/simple;
	bh=48azHsZJSzNiWQkTivQqz14iDlPq6JCCsd+eWwbmjT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh4I+aUf2Ke12AlmNEVPIfwYiJ2fnIFmUbTX9GW6rcxXeVVk9dXC7atAdH96oSXMpvfotFAam/roFv4ku3BVSlwEVlLy9DtGT118YFiyTVT1d/yISJ/9bG/pLo+q6+7DlTWuqV2SETKUspwKPTVQm0mzNk3M4PCsgtm15+HI8wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 348442ca874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:3a93957a-db1c-41d1-94c9-727201369932,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:3a93957a-db1c-41d1-94c9-727201369932,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:67ad2c1d8f4dc667eebe4e8611277bf6,BulkI
	D:260724184121TVPKQO90,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 348442ca874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 957359716; Fri, 24 Jul 2026 18:41:19 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	slow@samba.org,
	pc@manguebit.org,
	jra@samba.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 14/15] smb: client: support security.xfstests on POSIX mounts
Date: Fri, 24 Jul 2026 18:40:08 +0800
Message-ID: <65c72d30f4146ed46a9ec05d7dbc6fa913569671.1784888897.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784888897.git.tanze@kylinos.cn>
References: <cover.1784888897.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add security.xfstests to the exact native xattr table. The existing
security handler can then send and receive it without a user prefix on
POSIX mounts, reject the colliding user.security.xfstests spelling, and
preserve the native name in listxattr output.

The mapping can be checked from a POSIX-mounted client:

  $ CIFS_MNT=/path/to/cifs-mount
  $ file="$CIFS_MNT/security-xfstests"
  $ touch "$file"
  $ setfattr -n security.xfstests -v attr "$file"

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index f975bccf98a5..59f6655a1b34 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -43,6 +43,7 @@ enum { XATTR_USER, XATTR_SECURITY,
 
 static const char * const cifs_native_xattr_names[] = {
 	XATTR_NAME_CAPS,
+	XATTR_SECURITY_PREFIX "xfstests",
 };
 
 enum cifs_ea_name_type
-- 
2.43.0

