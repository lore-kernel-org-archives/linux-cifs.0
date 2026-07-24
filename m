Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C71248893
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889690; cv=none; b=FaBgkNofcr0u3KPVNYQ0SPq5SKmz6K14R5CUSFcQtCQ2tKw4Wip/gCtRcjJAprG9746pWCaBgWTNJtc2mPm77RY1vrJ+96OnUsDOPoncKchRvEZaaGokGX7GFQv04wq/YP47YUY7lKvV3pLODkku9NCDPBwNljAScKmQHJhgS20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889690; c=relaxed/simple;
	bh=d7Qm9Y263p7hN5bGMBl/lfEzBcpgCEwfjjl9zJY5YyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV3LWbOzZE3rtee434VKDMyTZjsnLphafz9pUqj6sqTA+2oKdBlU+T0q7OuOYyzZk0bdPDEbXKtmdRnrMVJbOJqfukU00B19h9S8qxumbaARe+VKygYnU7ewvHK9tqsqC7H7FkWSkZ3ve/MRSzgkKTSE66WHcXPziIuvmSjzFto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 34443d1a874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:4921c607-c133-42d9-bfc7-471edd1589ff,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:4921c607-c133-42d9-bfc7-471edd1589ff,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:f2fd86b34136e924bd3e6d3c9fbf9ffe,BulkI
	D:260724184121QII20UBZ,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34443d1a874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 929504896; Fri, 24 Jul 2026 18:41:18 +0800
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
Subject: [PATCH 13/15] smb: client: gate security.capability EA on POSIX mounts
Date: Fri, 24 Jul 2026 18:40:07 +0800
Message-ID: <2d0f64ba1e8f0fa18b67696281b39eec93e908e2.1784888897.git.tanze@kylinos.cn>
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

Register the security xattr handler, but allow security.capability to
use its native SMB EA name only after SMB3 POSIX extensions have been
requested and negotiated. Non-POSIX mounts retain the existing user EA
mapping.

On a POSIX mount, reject the colliding user.security.capability spelling
and preserve security.capability in listxattr output.

The native xattr and killpriv behavior can be checked as root:

  $ CIFS_MNT=/path/to/cifs-mount
  $ file="$CIFS_MNT/capability"
  $ touch "$file"
  $ setcap cap_chown+ep "$file"
  $ getcap "$file" | grep -q 'cap_chown=ep'
  $ printf 'data\n' >> "$file"
  $ test -z "$(getcap "$file")"

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/cifsfs.h  |   7 +++
 fs/smb/client/smb2ops.c |  22 +++++---
 fs/smb/client/xattr.c   | 112 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 854e672a4e37..4ab1a203be3e 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -133,6 +133,13 @@ int cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 		 struct dentry *direntry, const char *symname);
 
 #ifdef CONFIG_CIFS_XATTR
+enum cifs_ea_name_type {
+	CIFS_EA_USER,
+	CIFS_EA_NATIVE,
+};
+
+enum cifs_ea_name_type
+cifs_ea_name_type(const char *name, size_t name_len, bool posix_extensions);
 extern const struct xattr_handler * const cifs_xattr_handlers[];
 ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size);
 #else
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e85d6b5a4564..fd778d903e93 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1060,7 +1060,7 @@ static void smb2_reuse_inode_lease(struct cifs_tcon *tcon,
 static ssize_t
 move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		     struct smb2_file_full_ea_info *src, size_t src_size,
-		     const unsigned char *ea_name)
+		     const unsigned char *ea_name, bool posix_extensions)
 {
 	int rc = 0;
 	unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
@@ -1099,16 +1099,25 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 				goto out;
 			}
 		} else {
-			/* 'user.' plus a terminating null */
-			user_name_len = 5 + 1 + name_len;
+			enum cifs_ea_name_type name_type;
+
+			name_type = cifs_ea_name_type(name, name_len,
+						     posix_extensions);
+			if (name_type == CIFS_EA_NATIVE)
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
+				if (name_type == CIFS_EA_USER) {
+					memcpy(dst, "user.", 5);
+					dst += 5;
+				}
 				memcpy(dst, src->ea_data, name_len);
 				dst += name_len;
 				*dst = 0;
@@ -1184,7 +1193,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 	info = (struct smb2_file_full_ea_info *)(
 			le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
 	rc = move_smb2_ea_to_cifs(ea_data, buf_size, info,
-			le32_to_cpu(rsp->OutputBufferLength), ea_name);
+			le32_to_cpu(rsp->OutputBufferLength), ea_name,
+			tcon->posix_extensions);
 
  qeas_exit:
 	free_rsp_buf(buftype, rsp_iov.iov_base);
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index d52c52866651..f975bccf98a5 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -36,12 +36,63 @@
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
 
+static const char * const cifs_native_xattr_names[] = {
+	XATTR_NAME_CAPS,
+};
+
+enum cifs_ea_name_type
+cifs_ea_name_type(const char *name, size_t name_len, bool posix_extensions)
+{
+	size_t i;
+
+	if (!posix_extensions)
+		return CIFS_EA_USER;
+
+	for (i = 0; i < ARRAY_SIZE(cifs_native_xattr_names); i++) {
+		size_t xattr_len = strlen(cifs_native_xattr_names[i]);
+
+		if (name_len == xattr_len &&
+		    !memcmp(name, cifs_native_xattr_names[i], name_len))
+			return CIFS_EA_NATIVE;
+	}
+
+	return CIFS_EA_USER;
+}
+
+static int cifs_build_ea_name(int xattr_flag, const char *name, char *ea_name,
+			      size_t ea_name_size)
+{
+	const char *prefix;
+	size_t name_len, prefix_len;
+
+	switch (xattr_flag) {
+	case XATTR_SECURITY:
+		prefix = XATTR_SECURITY_PREFIX;
+		prefix_len = XATTR_SECURITY_PREFIX_LEN;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	name_len = strlen(name);
+	if (ea_name_size <= prefix_len ||
+	    name_len > ea_name_size - prefix_len - 1)
+		return -ERANGE;
+
+	memcpy(ea_name, prefix, prefix_len);
+	memcpy(ea_name + prefix_len, name, name_len + 1);
+
+	if (cifs_ea_name_type(ea_name, prefix_len + name_len, true) !=
+	    CIFS_EA_NATIVE)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
 			   struct inode *inode, const char *full_path,
 			   const void *value, size_t size)
@@ -104,6 +155,9 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	struct cifs_tcon *pTcon;
 	const char *full_path;
 	void *page;
+	char ea_name[XATTR_NAME_MAX + 1];
+	const char *server_ea_name = name;
+	struct inode *lease_inode = NULL;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -131,8 +185,24 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	}
 
 	switch (handler->flags) {
+	case XATTR_SECURITY:
+		if (!pTcon->posix_extensions)
+			goto out;
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		lease_inode = inode;
+		cifs_dbg(FYI, "%s: setting security xattr %s\n",
+			 __func__, name);
+		goto set_ea;
+
 	case XATTR_USER:
 		cifs_dbg(FYI, "%s:setting user xattr %s\n", __func__, name);
+		if (cifs_ea_name_type(name, strlen(name),
+				      pTcon->posix_extensions) != CIFS_EA_USER)
+			goto out;
 		if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
 		    (strcmp(name, SMB3_XATTR_ATTRIB) == 0)) {
 			rc = cifs_attrib_set(xid, pTcon, inode, full_path,
@@ -149,13 +219,14 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
+set_ea:
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
-				full_path, name, value, (__u16)size,
-				cifs_sb->local_nls, cifs_sb, NULL);
+				full_path, server_ea_name, value, (__u16)size,
+				cifs_sb->local_nls, cifs_sb, lease_inode);
 			if (rc == 0)
 				inode_set_ctime_current(inode);
 		}
@@ -280,6 +351,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 	struct cifs_tcon *pTcon;
 	const char *full_path;
 	void *page;
+	char ea_name[XATTR_NAME_MAX + 1];
+	const char *server_ea_name = name;
+	struct inode *lease_inode = NULL;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -297,8 +371,24 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 
 	/* return alt name if available as pseudo attr */
 	switch (handler->flags) {
+	case XATTR_SECURITY:
+		if (!pTcon->posix_extensions)
+			goto out;
+		rc = cifs_build_ea_name(handler->flags, name, ea_name,
+					sizeof(ea_name));
+		if (rc < 0)
+			goto out;
+		server_ea_name = ea_name;
+		lease_inode = inode;
+		cifs_dbg(FYI, "%s: querying security xattr %s\n",
+			 __func__, name);
+		goto query_ea;
+
 	case XATTR_USER:
 		cifs_dbg(FYI, "%s:querying user xattr %s\n", __func__, name);
+		if (cifs_ea_name_type(name, strlen(name),
+				      pTcon->posix_extensions) != CIFS_EA_USER)
+			goto out;
 		if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
 		    (strcmp(name, SMB3_XATTR_ATTRIB) == 0)) {
 			rc = cifs_attrib_get(dentry, inode, value, size);
@@ -309,12 +399,14 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
+query_ea:
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
 			rc = pTcon->ses->server->ops->query_all_EAs(xid, pTcon,
-				full_path, name, value, size, cifs_sb, NULL);
+				full_path, server_ea_name, value, size, cifs_sb,
+				lease_inode);
 		break;
 
 	case XATTR_CIFS_ACL:
@@ -438,6 +530,13 @@ static const struct xattr_handler cifs_user_xattr_handler = {
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
@@ -522,6 +621,7 @@ static const struct xattr_handler smb3_ntsd_full_xattr_handler = {
 
 const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_user_xattr_handler,
+	&cifs_security_xattr_handler,
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
-- 
2.43.0

