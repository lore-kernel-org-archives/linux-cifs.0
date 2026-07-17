Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4819366546;
	Fri, 17 Jul 2026 03:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259620; cv=none; b=Ueqh9cmAtk8Axy3HStJkMYHUCr77dHjtMaKcjDabxSAo3zVjG4m4PAQK+J4X7ykYrBop32CSY7LD8XU/i2+tpqupQjQj5IfpW130OF5HcxqCUzL5/mZPYn8TiWoxXGYepWln/3f8/j1QCb+niyTXaX6aYpoI1Nj3lUOaxLsoBGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259620; c=relaxed/simple;
	bh=nXBdRjbaI9gRFhKJhB2YAOMV2Zr9IovA+yBBL5HhhUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTv3xTHVouGquEK653UJmzd1nFlRzA2/U5qGus0GzwYOucABEQuErHVEktIEsEcSESyiaKQt2I5jXzFkVHmvAdAaeCaRrQwdpVJxfRQ8vKRMfnqv4D09u04cRsleD4kFujxq3UxW04G4F0EqxghKkERg6o6XoTnjcZ5HwS67qBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 36770c0e819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:7601579a-c055-4d07-9f4a-c4c2178ff5bf,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:7601579a-c055-4d07-9f4a-c4c2178ff5bf,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:0236b6c31d5989cde7818ff7bc1f5005,BulkI
	D:260717114011SLZ3X0PY,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 36770c0e819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 385014376; Fri, 17 Jul 2026 11:40:10 +0800
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
Subject: [RFC PATCH v2 2/9] smb: client: support security.xfstests over EAs
Date: Fri, 17 Jul 2026 11:39:20 +0800
Message-ID: <a062d9ed54283285a74511b136c1b064d1c36ff7.1784258165.git.tanze@kylinos.cn>
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
security. This helper runs "setfattr -n security.xfstests" to check the
security xattr namespace. The security handler supports only
security.capability, so this command returns "Operation not supported".

Add security.xfstests as another exact security EA name. Keep this name
unchanged in EA lists. Continue to reject other security xattrs.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 4 ++++
 fs/smb/client/xattr.c   | 7 ++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 320742ec3ed8..9638fdad93cc 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1050,6 +1050,10 @@ static bool cifs_passthrough(const char *name, size_t name_len)
 	    !memcmp(name, XATTR_NAME_CAPS, name_len))
 		return true;
 
+	if (name_len == sizeof(XATTR_SECURITY_PREFIX "xfstests") - 1 &&
+	    !memcmp(name, XATTR_SECURITY_PREFIX "xfstests", name_len))
+		return true;
+
 	return false;
 }
 
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 8fa40593bc93..42db6920901e 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -49,10 +49,11 @@ static int cifs_build_ea_name(int xattr_flag, const char *name, char *ea_name,
 	switch (xattr_flag) {
 	case XATTR_SECURITY:
 		/*
-		 * Only security.capability has native Linux security xattr
-		 * semantics on POSIX-capable servers.
+		 * Only security.capability and the xfstests security namespace
+		 * probe are supported on POSIX-capable servers.
 		 */
-		if (strcmp(name, XATTR_CAPS_SUFFIX))
+		if (strcmp(name, XATTR_CAPS_SUFFIX) &&
+		    strcmp(name, "xfstests"))
 			return -EOPNOTSUPP;
 		name_len = strlen(name);
 		if (ea_name_size <= XATTR_SECURITY_PREFIX_LEN ||
-- 
2.43.0

