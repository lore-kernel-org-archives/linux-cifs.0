Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A3336885;
	Fri, 17 Jul 2026 03:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259621; cv=none; b=tD+jik+pLW/8cPZ2n1loO91NJBIPK97Z4icqEHCyZ6cE/HCxInzv368kDEeNSUQTI4+fVuk8qiB/TTUmXxgs8CBd26Tb9+91lTih3cIH8b9BZumS/EiFMHiAd/7ovU2MmY5puvShoXFtEH0GAnZqBkbC3lQHCYIsz+EPhY/rDyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259621; c=relaxed/simple;
	bh=lM1MSQ5L02emZtiqItD1xTXqMgay7VhVfxmkufp3YDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbwXlnmCFiwFedAwYao9dAciaWktOP5HYCH78MoV/suk9sFRow8JTHvHz8qbgsIBMbkxA6+PPfeXqHbikJZe71dJ2LBroj/riyAEnp+VvCbuZLZaCMDYSjADJG6evV6KMgBmKSKbcGr6jiFJ5VDwgXw9O9Gn3A/MbV0S/84hHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 36bc0f52819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:ded62745-69b6-4883-ab40-dc04ca609f8a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:ded62745-69b6-4883-ab40-dc04ca609f8a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:a9776d581f648ce9a76f91ba9cc687bf,BulkI
	D:260717114011CVIIBNWL,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 36bc0f52819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 656593735; Fri, 17 Jul 2026 11:40:11 +0800
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
Subject: [RFC PATCH v2 3/9] smb: client: support trusted xattrs over EAs
Date: Fri, 17 Jul 2026 11:39:21 +0800
Message-ID: <3d7836d5df4b9e65e834caf6f1ba3f1aa1bc59fd.1784258165.git.tanze@kylinos.cn>
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

generic/093 uses setfattr and getfattr to check that a write does not
clear trusted.name. The CIFS client does not have a trusted xattr handler,
so these commands cannot set or read trusted xattrs through SMB EAs.

Register a trusted xattr handler and build the complete trusted EA name
for SET_INFO and QUERY_INFO. Keep the trusted prefix in EA lists.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/smb2ops.c |  4 ++++
 fs/smb/client/xattr.c   | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9638fdad93cc..c3a18fafbfa0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1046,6 +1046,10 @@ static int smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 #ifdef CONFIG_CIFS_XATTR
 static bool cifs_passthrough(const char *name, size_t name_len)
 {
+	if (name_len > XATTR_TRUSTED_PREFIX_LEN &&
+	    !memcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+		return true;
+
 	if (name_len == sizeof(XATTR_NAME_CAPS) - 1 &&
 	    !memcmp(name, XATTR_NAME_CAPS, name_len))
 		return true;
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 42db6920901e..3dae8b23aca7 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -36,7 +36,7 @@
 #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
 #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
-enum { XATTR_USER, XATTR_SECURITY,
+enum { XATTR_USER, XATTR_TRUSTED, XATTR_SECURITY,
 	XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
 	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
@@ -64,6 +64,16 @@ static int cifs_build_ea_name(int xattr_flag, const char *name, char *ea_name,
 		memcpy(ea_name + XATTR_SECURITY_PREFIX_LEN, name,
 		       name_len + 1);
 		return XATTR_SECURITY_PREFIX_LEN + name_len;
+	case XATTR_TRUSTED:
+		name_len = strlen(name);
+		if (ea_name_size <= XATTR_TRUSTED_PREFIX_LEN ||
+		    name_len > ea_name_size - XATTR_TRUSTED_PREFIX_LEN - 1)
+			return -ERANGE;
+		memcpy(ea_name, XATTR_TRUSTED_PREFIX,
+		       XATTR_TRUSTED_PREFIX_LEN);
+		memcpy(ea_name + XATTR_TRUSTED_PREFIX_LEN, name,
+		       name_len + 1);
+		return XATTR_TRUSTED_PREFIX_LEN + name_len;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -160,6 +170,16 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	}
 
 	switch (handler->flags) {
+	case XATTR_TRUSTED:
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		cifs_dbg(FYI, "%s: setting trusted xattr %s\n",
+			 __func__, name);
+		goto set_ea;
+
 	case XATTR_SECURITY:
 		rc = cifs_build_ea_name(handler->flags, name, ea_name,
 					sizeof(ea_name));
@@ -339,6 +359,16 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 
 	/* return alt name if available as pseudo attr */
 	switch (handler->flags) {
+	case XATTR_TRUSTED:
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		cifs_dbg(FYI, "%s: querying trusted xattr %s\n",
+			 __func__, name);
+		goto query_ea;
+
 	case XATTR_SECURITY:
 		rc = cifs_build_ea_name(handler->flags, name, ea_name,
 					sizeof(ea_name));
@@ -491,6 +521,13 @@ static const struct xattr_handler cifs_user_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler cifs_trusted_xattr_handler = {
+	.prefix = XATTR_TRUSTED_PREFIX,
+	.flags = XATTR_TRUSTED,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 static const struct xattr_handler cifs_security_xattr_handler = {
 	.prefix = XATTR_SECURITY_PREFIX,
 	.flags = XATTR_SECURITY,
@@ -582,6 +619,7 @@ static const struct xattr_handler smb3_ntsd_full_xattr_handler = {
 
 const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_user_xattr_handler,
+	&cifs_trusted_xattr_handler,
 	&cifs_security_xattr_handler,
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
-- 
2.43.0

