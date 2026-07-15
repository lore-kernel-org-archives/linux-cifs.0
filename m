Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8564D39CD14;
	Wed, 15 Jul 2026 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101799; cv=none; b=g11RDL8UJ53noi5IqNsnx4CRROur6FyW/g8+XHlBKM8jTwRcaIq/pn7E/GNoDUP+Jc4Xgvq3pnOdFnEbsmYgoFOW1u9WD6gTz2wjt7zoSQby/aJltbeynK3mlnD03g8cAeeNjc8BVb+Zy3U/unq8bDLQEXV82fF289BSqsAAvZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101799; c=relaxed/simple;
	bh=/5WCWfYXAq8EntAMv6/6cGSOGkG7ba26sQTuaQ77KLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMKvS1lYcFly7lzQOEyte012clozmn4WLoaqUN8UwETIgV+bG2d2b4hS5ltRd+gGRzHObpV1XX/7NqzpMSVcU0ssDGFkYZdbxE01CzdNHEzm5CBB7K2q9dRNkW+jIIXzvajfF73lAMD6HzJeN0FH8vlvKJHX+heSiSlXkAZQt30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c36bc0d0802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1a0a254a-9fba-45ea-b256-bbfd0b4f55a4,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:1a0a254a-9fba-45ea-b256-bbfd0b4f55a4,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c2186a120d102ddcbeeff3a3ab9d219b,BulkI
	D:2607151549528UYP0MYR,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c36bc0d0802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 304849699; Wed, 15 Jul 2026 15:49:52 +0800
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
Subject: [RFC PATCH 3/9] smb: client: support trusted xattrs over EAs
Date: Wed, 15 Jul 2026 15:48:44 +0800
Message-ID: <20260715074908.641940-4-tanze@kylinos.cn>
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
index bfa089511b9b..e1f88a0c6842 100644
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

