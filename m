Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509E431717D;
	Wed, 15 Jul 2026 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101806; cv=none; b=YBMScG32U5P/pxFlbo46/0S0PDP9Z6PDXGd6LJBYr/x0JcfRHNrYRAjEmnWFDz4784I73XIiWyzZqFQfGcy0G7j5be76BkN4lgLjNIX0C/SP0fedippgm0r98zfESDnrAdss5EBzA/sBsLG33UbgjMSPmSw6p/ryggH/v+/uze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101806; c=relaxed/simple;
	bh=DZj8s6Ln7mw3so2haOwnn8cVq1Da7OXD8zddUwTWwqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLIy3qvIw1+W2RYAWnb9fqIPrXOgsgpBtaVcTiatMv/VAoYi12JSHNLXyqkgMljHQEQXzeoj0DlWJn1atopcEA1wIRLSgWLGeFgxBFf7Zu7SgQ/ZRTuiT7ylJ0l9bXf+I5LsENcFOrwKRk6QSjRs1x9psZTteEBmWmsylBBuBtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c6b3894e802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:77d4415b-50ab-441a-86c6-481842331b69,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:77d4415b-50ab-441a-86c6-481842331b69,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:ff46711be7168bf101d865fe438439db,BulkI
	D:260715154958FNRAKQM7,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c6b3894e802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1193017124; Wed, 15 Jul 2026 15:49:58 +0800
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
Subject: [RFC PATCH 8/9] ksmbd: support trusted EAs
Date: Wed, 15 Jul 2026 15:48:49 +0800
Message-ID: <20260715074908.641940-9-tanze@kylinos.cn>
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

generic/093 uses "setfattr -n trusted.name" and getfattr to check that a
write does not clear the trusted xattr. ksmbd stores the attribute as
user.trusted.name on the backing filesystem.

Map trusted names to the trusted xattr namespace for set, get, and list
operations. Filter the internal POSIX ACL xattrs.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ea622798f34e..649aa9f484b7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2734,6 +2734,19 @@ static bool smb2_is_private_ea(const char *name, size_t name_len)
 	return false;
 }
 
+static bool ksmbd_is_internal_acl_ea_name(const char *name, size_t name_len)
+{
+	return (name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
+		!strncmp(name, XATTR_NAME_POSIX_ACL_ACCESS, name_len)) ||
+	       (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
+		!strncmp(name, XATTR_NAME_POSIX_ACL_DEFAULT, name_len)) ||
+	       (name_len == sizeof(XATTR_TRUSTED_PREFIX "SGI_ACL_FILE") - 1 &&
+		!strncmp(name, XATTR_TRUSTED_PREFIX "SGI_ACL_FILE", name_len)) ||
+	       (name_len == sizeof(XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT") - 1 &&
+		!strncmp(name, XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT",
+			 name_len));
+}
+
 static bool ksmbd_is_security_capability_ea_name(const char *name,
 						 size_t name_len)
 {
@@ -2756,6 +2769,18 @@ static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len)
 	if (ksmbd_is_security_xfstests_ea_name(name, name_len))
 		return true;
 
+	/*
+	 * POSIX ACL xattrs are filesystem-internal ACL records, not
+	 * user-visible EAs.  XFS may also expose trusted.SGI_ACL_* aliases
+	 * through listxattr(), so filter those as well.
+	 */
+	if (ksmbd_is_internal_acl_ea_name(name, name_len))
+		return false;
+
+	if (name_len > XATTR_TRUSTED_PREFIX_LEN &&
+	    !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+		return true;
+
 	return false;
 }
 
@@ -2763,6 +2788,9 @@ static int ksmbd_map_ea_name_to_xattr(bool posix_extensions,
 				      const char *ea_name, size_t ea_name_len,
 				      char *attr_name)
 {
+	if (ksmbd_is_internal_acl_ea_name(ea_name, ea_name_len))
+		return -EINVAL;
+
 	if (posix_extensions &&
 	    ksmbd_is_posix_ea_name(ea_name, ea_name_len)) {
 		if (ea_name_len > XATTR_NAME_MAX)
-- 
2.43.0

