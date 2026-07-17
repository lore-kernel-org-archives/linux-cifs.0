Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED7931AAA3;
	Fri, 17 Jul 2026 03:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259620; cv=none; b=EjL/VsW2gmV6uBw14fqGtM/KJPjFG1i3wKBdgZvSc+jz+4ZcH4uhgMqKF4RzVb+pXXcmVlNFyz8tz3aDfNNDEeDKMLGu7fOQ25KM5yDSXfsvHzP1tCctkJLD7jSVe+WUY7ycQ02/T569WZHVeUoHo3C/l+6D4Vzqse8egFtsaQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259620; c=relaxed/simple;
	bh=Hiniuf4AIr6LxacTvnC9Z/RDP+E2v2Wdlz/P+kmSW2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izcuiDtp9un3VM7jmVXyn6m2sh0hd2skfYcoJz72PUyj56twALpKXpiBlvXL1Y41CW634k9jvIQTnPrJ+pjzqpH17UnZmC86Uge87hF1PNA1RU+8wB27ji9o31VuXhYV1i0DZLvj/BaNOoCvhPM1k43iWfsFKnbnFP4+cVVkpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 37de98c8819111f1aa26b74ffac11d73-20260717
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:bfa9cc7e-afcf-4b40-a944-caf785eb3d5c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:bfa9cc7e-afcf-4b40-a944-caf785eb3d5c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:b7b59803eb17251e364d3ab59795065e,BulkI
	D:260717114014KCEMWS01,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 37de98c8819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 445671329; Fri, 17 Jul 2026 11:40:13 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	sprasad@microsoft.com,
	tom@talpey.comm,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tanze@kylinos.cn
Subject: [RFC PATCH v2 7/9] ksmbd: support security.xfstests EAs
Date: Fri, 17 Jul 2026 11:39:25 +0800
Message-ID: <a5a362d962c22a0f447c1398db5256be5399488c.1784258165.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784258165.git.tanze@kylinos.cn>
References: <cover.1784258165.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before checking file capabilities, generic/093 calls _require_attrs
security. This helper runs "setfattr -n security.xfstests". ksmbd
recognizes only security.capability as a native security EA, so it stores
the attribute as user.security.xfstests.

Add security.xfstests as another exact security EA name. Use this name
directly for set, get, and list operations. Do not support other security
xattrs.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2159b45c80a6..da3d5c217577 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2650,11 +2650,21 @@ static bool ksmbd_is_security_capability_ea_name(const char *name,
 	       !strncmp(name, XATTR_NAME_CAPS, name_len);
 }
 
+static bool ksmbd_is_security_xfstests_ea_name(const char *name,
+					       size_t name_len)
+{
+	return name_len == sizeof(XATTR_SECURITY_PREFIX "xfstests") - 1 &&
+	       !strncmp(name, XATTR_SECURITY_PREFIX "xfstests", name_len);
+}
+
 static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len)
 {
 	if (ksmbd_is_security_capability_ea_name(name, name_len))
 		return true;
 
+	if (ksmbd_is_security_xfstests_ea_name(name, name_len))
+		return true;
+
 	return false;
 }
 
-- 
2.43.0

