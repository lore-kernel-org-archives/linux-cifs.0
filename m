Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15635E1B6;
	Fri, 17 Jul 2026 03:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259624; cv=none; b=g8D8B/Q3zUlDWUssuf+l+6lg4jG2CChb+lp4iPuhsl3bpBJCrlN9yYI9fQUlbxxnpYZWYq7gdYQKcClMT8P9EIvpphksrraNKJBi8/2XkH/tvIgaxmXiUXwc/iYR7Ij1e2s/DvZjykyV25l+xvxmjeChlqZPHwfqQ+b9MX/D7Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259624; c=relaxed/simple;
	bh=40tQVUGguIMo+rYrW6EopcfqeMB8VsaWYVsx+ZaaH0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWpEPygQ6joaaTJjE8KxVRw7lebqylUhasAcmuZZcHJyqu22XFyChhqV0gtfQQ24wKZc/lFMiGxBtaLZYIsGhS4baaXk9MGp64Ml4Im7F8VcbBHQm9uE6CZlrkfeQ9Wl6KorNpDaOwhAjWXEvUndS6tBEeyDcz30/JwDHVMkYi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3631c324819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:cc988db7-5a3e-4162-8937-0ed8dad00081,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:cc988db7-5a3e-4162-8937-0ed8dad00081,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:fef1a97aa70561e02a143726fc1c0fa0,BulkI
	D:260717114012IGR8LSBE,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3631c324819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1188837533; Fri, 17 Jul 2026 11:40:10 +0800
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
Subject: [RFC PATCH v2 1/9] smb: client: support security.capability over EAs
Date: Fri, 17 Jul 2026 11:39:19 +0800
Message-ID: <03e3fb98415d9e861588b165d78a22f18e14eb9c.1784258165.git.tanze@kylinos.cn>
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

generic/093 uses setcap and getcap to check that a write clears the file
capability. The CIFS client does not have a security xattr handler, so
these commands cannot set or read security.capability through SMB EAs.

Register a security xattr handler and build the complete EA name for
SET_INFO and QUERY_INFO. Keep security.capability unchanged in EA lists.
Reject other security xattrs.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 26 ++++++++++++---
 fs/smb/client/xattr.c   | 70 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cbd51a08e97e..320742ec3ed8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -14,6 +14,7 @@
 #include <crypto/aead.h>
 #include <linux/fiemap.h>
 #include <linux/folio_queue.h>
+#include <linux/xattr.h>
 #include <uapi/linux/magic.h>
 #include "cifsfs.h"
 #include "cifsglob.h"
@@ -1043,6 +1044,15 @@ static int smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 #ifdef CONFIG_CIFS_XATTR
+static bool cifs_passthrough(const char *name, size_t name_len)
+{
+	if (name_len == sizeof(XATTR_NAME_CAPS) - 1 &&
+	    !memcmp(name, XATTR_NAME_CAPS, name_len))
+		return true;
+
+	return false;
+}
+
 static ssize_t
 move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		     struct smb2_file_full_ea_info *src, size_t src_size,
@@ -1085,16 +1095,24 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 				goto out;
 			}
 		} else {
-			/* 'user.' plus a terminating null */
-			user_name_len = 5 + 1 + name_len;
+			bool passthrough_name;
+
+			passthrough_name = cifs_passthrough(name, name_len);
+			if (passthrough_name)
+				user_name_len = name_len + 1;
+			else
+				/* 'user.' plus a terminating null */
+				user_name_len = 5 + 1 + name_len;
 
 			if (buf_size == 0) {
 				/* skip copy - calc size only */
 				rc += user_name_len;
 			} else if (dst_size >= user_name_len) {
 				dst_size -= user_name_len;
-				memcpy(dst, "user.", 5);
-				dst += 5;
+				if (!passthrough_name) {
+					memcpy(dst, "user.", 5);
+					dst += 5;
+				}
 				memcpy(dst, src->ea_data, name_len);
 				dst += name_len;
 				*dst = 0;
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 5091f6c0d7fe..8fa40593bc93 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -36,12 +36,38 @@
 #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
 #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
-/* BB need to add server (Samba e.g) support for security and trusted prefix */
-
-enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
+enum { XATTR_USER, XATTR_SECURITY,
+	XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
 	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
 
+static int cifs_build_ea_name(int xattr_flag, const char *name, char *ea_name,
+			      size_t ea_name_size)
+{
+	size_t name_len;
+
+	switch (xattr_flag) {
+	case XATTR_SECURITY:
+		/*
+		 * Only security.capability has native Linux security xattr
+		 * semantics on POSIX-capable servers.
+		 */
+		if (strcmp(name, XATTR_CAPS_SUFFIX))
+			return -EOPNOTSUPP;
+		name_len = strlen(name);
+		if (ea_name_size <= XATTR_SECURITY_PREFIX_LEN ||
+		    name_len > ea_name_size - XATTR_SECURITY_PREFIX_LEN - 1)
+			return -ERANGE;
+		memcpy(ea_name, XATTR_SECURITY_PREFIX,
+		       XATTR_SECURITY_PREFIX_LEN);
+		memcpy(ea_name + XATTR_SECURITY_PREFIX_LEN, name,
+		       name_len + 1);
+		return XATTR_SECURITY_PREFIX_LEN + name_len;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
 			   struct inode *inode, const char *full_path,
 			   const void *value, size_t size)
@@ -104,6 +130,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	struct cifs_tcon *pTcon;
 	const char *full_path;
 	void *page;
+	char ea_name[XATTR_NAME_MAX + 1];
+	const char *server_ea_name = name;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -131,6 +159,16 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	}
 
 	switch (handler->flags) {
+	case XATTR_SECURITY:
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		cifs_dbg(FYI, "%s: setting security xattr %s\n",
+			 __func__, name);
+		goto set_ea;
+
 	case XATTR_USER:
 		cifs_dbg(FYI, "%s:setting user xattr %s\n", __func__, name);
 		if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
@@ -149,12 +187,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
+set_ea:
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, name, value, (__u16)size,
+				full_path, server_ea_name, value, (__u16)size,
 				cifs_sb->local_nls, cifs_sb);
 			if (rc == 0)
 				inode_set_ctime_current(inode);
@@ -280,6 +319,8 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 	struct cifs_tcon *pTcon;
 	const char *full_path;
 	void *page;
+	char ea_name[XATTR_NAME_MAX + 1];
+	const char *server_ea_name = name;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -297,6 +338,16 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 
 	/* return alt name if available as pseudo attr */
 	switch (handler->flags) {
+	case XATTR_SECURITY:
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		cifs_dbg(FYI, "%s: querying security xattr %s\n",
+			 __func__, name);
+		goto query_ea;
+
 	case XATTR_USER:
 		cifs_dbg(FYI, "%s:querying user xattr %s\n", __func__, name);
 		if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
@@ -309,12 +360,13 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
+query_ea:
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
 			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
-				full_path, name, value, size, cifs_sb);
+				full_path, server_ea_name, value, size, cifs_sb);
 		break;
 
 	case XATTR_CIFS_ACL:
@@ -438,6 +490,13 @@ static const struct xattr_handler cifs_user_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler cifs_security_xattr_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.flags = XATTR_SECURITY,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 /* os2.* attributes are treated like user.* attributes */
 static const struct xattr_handler cifs_os2_xattr_handler = {
 	.prefix = XATTR_OS2_PREFIX,
@@ -522,6 +581,7 @@ static const struct xattr_handler smb3_ntsd_full_xattr_handler = {
 
 const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_user_xattr_handler,
+	&cifs_security_xattr_handler,
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
-- 
2.43.0

