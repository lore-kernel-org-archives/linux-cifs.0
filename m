Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2641DEDC
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889686; cv=none; b=DRinFWXA/5JcevkLBFQowYQRdaNrOFYUZZpF/j8TeIy7aneLG7/WxBDK05nIHr84F0NhDtnMscvqkwSbMFSt08ooOg12caWDI23nyacfdkEzt4sEiZ1UDbY01p93rG4ox6h3GHKytkhGkw8KB/N7l0m4tv9l2kB+e23152xpJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889686; c=relaxed/simple;
	bh=g4JoQaY7d9aaLY3g+ODbeL4zOpTgXOot5ansXw0kEVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AasY+ntZg6bKBqDSVddrtWLNoCiXyA/9KeG/lQTQK2+ZLV9j8x0jJKLJcXpZ3KZTQfS/PPiIcMF2z3DsLEfhFvoe8C/ZnsUjnKTyHlw01o6mLRvfK7v22oOFniikChgGUwY5OARg2iC3lzevs+vMgGGV3Psae4eL9AmLf4vM2wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 34c395c4874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:a371b97a-1fd8-4981-a875-47f10e0ce16f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:a371b97a-1fd8-4981-a875-47f10e0ce16f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:6d5c73ab168c6e5d0984b13ef8cc2ba6,BulkI
	D:2607241841229URBD944,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34c395c4874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1276971046; Fri, 24 Jul 2026 18:41:19 +0800
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
Subject: [PATCH 15/15] smb: client: support trusted EAs on POSIX mounts
Date: Fri, 24 Jul 2026 18:40:09 +0800
Message-ID: <492de6f2817478ffee14dadea67822060b6f15c9.1784888897.git.tanze@kylinos.cn>
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

Register the trusted xattr handler and add trusted.* to the native
prefix table. The handler sends native trusted names only on negotiated
SMB3 POSIX mounts; non-POSIX user.trusted.* EAs retain their existing
user namespace mapping.

Hide native trusted names from listxattr callers without CAP_SYS_ADMIN.
Reject the XFS trusted.SGI_ACL_* names before matching the trusted
prefix.

Run the following as root on a POSIX mount to check that a write clears
security.capability without removing trusted.name:

  $ CIFS_MNT=/path/to/cifs-mount
  $ file="$CIFS_MNT/trusted-preserve"
  $ touch "$file"
  $ setfattr -n trusted.name -v value "$file"
  $ printf 'data\n' >> "$file"

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/cifsfs.h  |  1 +
 fs/smb/client/smb2ops.c |  3 +++
 fs/smb/client/xattr.c   | 51 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 4ab1a203be3e..1c04dc07a2ff 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -136,6 +136,7 @@ int cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 enum cifs_ea_name_type {
 	CIFS_EA_USER,
 	CIFS_EA_NATIVE,
+	CIFS_EA_HIDDEN,
 };
 
 enum cifs_ea_name_type
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index fd778d903e93..f38230e4c31d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1103,6 +1103,8 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 
 			name_type = cifs_ea_name_type(name, name_len,
 						     posix_extensions);
+			if (name_type == CIFS_EA_HIDDEN)
+				goto next;
 			if (name_type == CIFS_EA_NATIVE)
 				user_name_len = name_len + 1;
 			else
@@ -1130,6 +1132,7 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 			}
 		}
 
+next:
 		if (!src->next_entry_offset)
 			break;
 
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 59f6655a1b34..4b6736a6b375 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/capability.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/slab.h>
 #include <linux/xattr.h>
@@ -36,7 +37,7 @@
 #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
 #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
-enum { XATTR_USER, XATTR_SECURITY,
+enum { XATTR_USER, XATTR_TRUSTED, XATTR_SECURITY,
 	XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
 	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
@@ -46,6 +47,15 @@ static const char * const cifs_native_xattr_names[] = {
 	XATTR_SECURITY_PREFIX "xfstests",
 };
 
+static const char * const cifs_native_xattr_prefixes[] = {
+	XATTR_TRUSTED_PREFIX,
+};
+
+static const char * const cifs_unsupported_xattr_names[] = {
+	XATTR_TRUSTED_PREFIX "SGI_ACL_FILE",
+	XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT",
+};
+
 enum cifs_ea_name_type
 cifs_ea_name_type(const char *name, size_t name_len, bool posix_extensions)
 {
@@ -54,6 +64,14 @@ cifs_ea_name_type(const char *name, size_t name_len, bool posix_extensions)
 	if (!posix_extensions)
 		return CIFS_EA_USER;
 
+	for (i = 0; i < ARRAY_SIZE(cifs_unsupported_xattr_names); i++) {
+		size_t xattr_len = strlen(cifs_unsupported_xattr_names[i]);
+
+		if (name_len == xattr_len &&
+		    !memcmp(name, cifs_unsupported_xattr_names[i], name_len))
+			return CIFS_EA_HIDDEN;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(cifs_native_xattr_names); i++) {
 		size_t xattr_len = strlen(cifs_native_xattr_names[i]);
 
@@ -62,6 +80,15 @@ cifs_ea_name_type(const char *name, size_t name_len, bool posix_extensions)
 			return CIFS_EA_NATIVE;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(cifs_native_xattr_prefixes); i++) {
+		size_t prefix_len = strlen(cifs_native_xattr_prefixes[i]);
+
+		if (name_len > prefix_len &&
+		    !memcmp(name, cifs_native_xattr_prefixes[i], prefix_len))
+			return capable(CAP_SYS_ADMIN) ? CIFS_EA_NATIVE :
+						       CIFS_EA_HIDDEN;
+	}
+
 	return CIFS_EA_USER;
 }
 
@@ -76,6 +103,10 @@ static int cifs_build_ea_name(int xattr_flag, const char *name, char *ea_name,
 		prefix = XATTR_SECURITY_PREFIX;
 		prefix_len = XATTR_SECURITY_PREFIX_LEN;
 		break;
+	case XATTR_TRUSTED:
+		prefix = XATTR_TRUSTED_PREFIX;
+		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -186,6 +217,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	}
 
 	switch (handler->flags) {
+	case XATTR_TRUSTED:
 	case XATTR_SECURITY:
 		if (!pTcon->posix_extensions)
 			goto out;
@@ -195,8 +227,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			goto out;
 		server_ea_name = ea_name;
 		lease_inode = inode;
-		cifs_dbg(FYI, "%s: setting security xattr %s\n",
-			 __func__, name);
+		cifs_dbg(FYI, "%s: setting native xattr %s\n",
+			 __func__, server_ea_name);
 		goto set_ea;
 
 	case XATTR_USER:
@@ -372,6 +404,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 
 	/* return alt name if available as pseudo attr */
 	switch (handler->flags) {
+	case XATTR_TRUSTED:
 	case XATTR_SECURITY:
 		if (!pTcon->posix_extensions)
 			goto out;
@@ -381,8 +414,8 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			goto out;
 		server_ea_name = ea_name;
 		lease_inode = inode;
-		cifs_dbg(FYI, "%s: querying security xattr %s\n",
-			 __func__, name);
+		cifs_dbg(FYI, "%s: querying native xattr %s\n",
+			 __func__, server_ea_name);
 		goto query_ea;
 
 	case XATTR_USER:
@@ -531,6 +564,13 @@ static const struct xattr_handler cifs_user_xattr_handler = {
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
@@ -622,6 +662,7 @@ static const struct xattr_handler smb3_ntsd_full_xattr_handler = {
 
 const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_user_xattr_handler,
+	&cifs_trusted_xattr_handler,
 	&cifs_security_xattr_handler,
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
-- 
2.43.0

