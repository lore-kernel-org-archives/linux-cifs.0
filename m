Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AB41DEDC
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889683; cv=none; b=HJ0SopYSZPXl7Qzfm/+tUvfEzA21dquv1O/+jaX+BzRrNZlnTYkYE4TfHLCAwzJoA/Nwead3J6OBBAaxfoQ55st3pVYcKXqwMwm3uf+sPe8Sj2oIq+1eY4jG8F1vLx5HPMHHcB4iKW/smQ3k+2OgwrcxVfcWHgzqdW9DsvfPSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889683; c=relaxed/simple;
	bh=gytiQ75G1e1eHGd9mgNOWNEcTVy97wR3WPQMkSbJ/r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfzuod09FvrTrFAdIjdJm/kgSpFb/QUz8SQsj3wPD88tEJaIBzi+8XfPjMZaOOvjMRILrYMnxEjtmcB6sQN/dqJV4L1sFxzOMzT6SZ7IODnFBUT3rhhr4UVt17DQQNKgL4xj+T8IU6F2dJktfoWZJUbGZkzLmhIwCbm/JmOWDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 330c4442874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:da6e9ea4-fd8b-47f3-91f1-45d79e30486d,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:da6e9ea4-fd8b-47f3-91f1-45d79e30486d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:120df42b350df370e3023fa3b9684859,BulkI
	D:260724184118MVCJMPG0,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 330c4442874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2020852932; Fri, 24 Jul 2026 18:41:16 +0800
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
Subject: [PATCH 10/15] ksmbd: support trusted xattrs on POSIX EA handles
Date: Fri, 24 Jul 2026 18:40:04 +0800
Message-ID: <703ff8a1e057b079f5169cd31d953eb78923f5ba.1784888897.git.tanze@kylinos.cn>
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

Add trusted.* to the native prefix allowlist. Use the same per-open
POSIX activation and root or admin authorization for set, remove, get,
and list operations.

Check the unsupported exact-name table before the prefix table so the
XFS trusted.SGI_ACL_* xattrs remain inaccessible.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dba97df7b29f..d3c4434f8eb3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2648,6 +2648,15 @@ static const char * const ksmbd_native_xattr_names[] = {
 	XATTR_SECURITY_PREFIX "xfstests",
 };
 
+static const char * const ksmbd_native_xattr_prefixes[] = {
+	XATTR_TRUSTED_PREFIX,
+};
+
+static const char * const ksmbd_unsupported_xattr_names[] = {
+	XATTR_TRUSTED_PREFIX "SGI_ACL_FILE",
+	XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT",
+};
+
 static bool ksmbd_native_xattrs_allowed(struct ksmbd_work *work)
 {
 	return uid_eq(current_fsuid(), GLOBAL_ROOT_UID) ||
@@ -2664,6 +2673,15 @@ static int ksmbd_check_native_xattr(struct ksmbd_work *work,
 	if (memchr(name, '\0', name_len))
 		return -EINVAL;
 
+	for (i = 0; i < ARRAY_SIZE(ksmbd_unsupported_xattr_names); i++) {
+		size_t xattr_len = strlen(ksmbd_unsupported_xattr_names[i]);
+
+		if (name_len == xattr_len &&
+		    !memcmp(name, ksmbd_unsupported_xattr_names[i],
+			    name_len))
+			return -EOPNOTSUPP;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ksmbd_native_xattr_names); i++) {
 		size_t xattr_len = strlen(ksmbd_native_xattr_names[i]);
 
@@ -2674,6 +2692,21 @@ static int ksmbd_check_native_xattr(struct ksmbd_work *work,
 		}
 	}
 
+	if (!native) {
+		for (i = 0; i < ARRAY_SIZE(ksmbd_native_xattr_prefixes);
+		     i++) {
+			size_t prefix_len;
+
+			prefix_len = strlen(ksmbd_native_xattr_prefixes[i]);
+			if (name_len > prefix_len &&
+			    !memcmp(name, ksmbd_native_xattr_prefixes[i],
+				    prefix_len)) {
+				native = true;
+				break;
+			}
+		}
+	}
+
 	if (!native)
 		return 0;
 	if (!ksmbd_native_xattrs_allowed(work))
-- 
2.43.0

