Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC953C4B68;
	Wed, 15 Jul 2026 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101798; cv=none; b=HQ4wIOm4FLJJHS3FE8SvamFvLESFGaPNqV2wGfHJ8dv2HgydxP455H9Q+MntTOPgmGca+hMBBREs6Un4PBUe7jsJKXWqc1CyhqAvSr/IEijSirAv0faK0EjVz/25wfUtBBhcdXWqTuk27aZR7rONnwqmKO7hw9Gr6uxAbxltv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101798; c=relaxed/simple;
	bh=vAmiKnsfWp7wv6ZkV/CdavOJ2+yMtMAuPwQaPuy88B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+9Fr2JgHF9s2T8uebmkUEXddpIhY/JCpet0Sa9GgxiXlFC3D1sd0DiS/pGvBtZ7xU7GduBhILNbaFnhZ0KrHggRqPBEv/yz+rl1Ci9MR66OpLh4cxvc91W3qG2kBSBmkleXx4zjYI+gBHlfmA79xIeasyy2+e4sBM9EmZAO7Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c2bf64f2802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:35c74c98-cd0c-409c-93ec-7ae468a829bf,IP:10,
	URL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:35c74c98-cd0c-409c-93ec-7ae468a829bf,IP:10,UR
	L:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,ACTI
	ON:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:73218a2bdec76720b204af9bb3a158e8,BulkI
	D:260715154952KC247HY3,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c2bf64f2802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 234420161; Wed, 15 Jul 2026 15:49:51 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	pc@manguebit.org,
	sprasad@microsoft.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/9] smb: client: support security.xfstests over EAs
Date: Wed, 15 Jul 2026 15:48:43 +0800
Message-ID: <20260715074908.641940-3-tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715074908.641940-1-tanze@kylinos.cn>
References: <20260715074908.641940-1-tanze@kylinos.cn>
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
index d58185f676a4..bfa089511b9b 100644
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

