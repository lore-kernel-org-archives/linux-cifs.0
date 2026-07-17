Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A9137BE86;
	Fri, 17 Jul 2026 03:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259623; cv=none; b=mazACR7rT8+opk1BGepKb6vA7oB0WEs074vmg/86RBWylqz9u0R0Fwyl7NgBmKuxSkFbS5BkrKeszRKAieJ50bAieaCj3/AaCZEnN2vLy1NhI5xXzfFbipjoBvEVFifko8B2qhrY+EolZScOxzsMsfNQP2Oohkl7YGRkx31Zjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259623; c=relaxed/simple;
	bh=ZkpygTwRItgn8bWH4gpGTeqgrJjF7Qb0Ne6+eXCUbQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3w9JRFOyK59BTlz9vPBh7th6pNyxHn/BEtNkBbwgQ68r0NMV9TvzZ14JR8LrUIIBkqSRIFQcxXlhoaj7JqHADCJgJUPU65fFIfFys2IqmvyKNEbOvpCqB5ISA6CFOCplnwRz2x5sOR3e9mEgV2QYo+eBbmGuwrmkIXnYPmJJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 379367ea819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:6ce1b119-44eb-49c1-8394-d1e68cb96f3d,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:6ce1b119-44eb-49c1-8394-d1e68cb96f3d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:5ff049a8155971ca430d7d51686aefd8,BulkI
	D:260717114015J3ZNR2H6,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 379367ea819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1689766807; Fri, 17 Jul 2026 11:40:12 +0800
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
Subject: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
Date: Fri, 17 Jul 2026 11:39:24 +0800
Message-ID: <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
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
capability. ksmbd adds the user prefix to every SMB EA name, so setcap
stores security.capability as user.security.capability and getcap cannot
read it as a file capability.

When SMB3 POSIX extensions are available, map security.capability to the
same backing xattr name. Use this mapping for set, get, and list
operations.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 77 +++++++++++++++++++++++++++++++----------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f0422e9c6a3a..2159b45c80a6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2643,9 +2643,35 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
-static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
-				      size_t ea_name_len, char *attr_name)
+static bool ksmbd_is_security_capability_ea_name(const char *name,
+						 size_t name_len)
 {
+	return name_len == sizeof(XATTR_NAME_CAPS) - 1 &&
+	       !strncmp(name, XATTR_NAME_CAPS, name_len);
+}
+
+static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len)
+{
+	if (ksmbd_is_security_capability_ea_name(name, name_len))
+		return true;
+
+	return false;
+}
+
+static int ksmbd_map_ea_name_to_xattr(bool posix_extensions,
+				      const char *ea_name, size_t ea_name_len,
+				      char *attr_name)
+{
+	if (posix_extensions &&
+	    ksmbd_is_posix_ea_name(ea_name, ea_name_len)) {
+		if (ea_name_len > XATTR_NAME_MAX)
+			return -EINVAL;
+
+		memcpy(attr_name, ea_name, ea_name_len);
+		attr_name[ea_name_len] = '\0';
+		return ea_name_len;
+	}
+
 	if (ea_name_len > XATTR_NAME_MAX - XATTR_USER_PREFIX_LEN)
 		return -EINVAL;
 
@@ -2655,24 +2681,30 @@ static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
 	return XATTR_USER_PREFIX_LEN + ea_name_len;
 }
 
-static bool ksmbd_is_visible_ea_name(const char *name, const char **ea_name,
-				     size_t *ea_name_len)
+static bool ksmbd_is_visible_ea_name(bool posix_extensions, const char *name,
+				     const char **ea_name, size_t *ea_name_len)
 {
 	size_t name_len = strlen(name);
 
-	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-		return false;
+	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
+		*ea_name = name + XATTR_USER_PREFIX_LEN;
+		*ea_name_len = name_len - XATTR_USER_PREFIX_LEN;
+
+		if (!strncmp(*ea_name, STREAM_PREFIX, STREAM_PREFIX_LEN))
+			return false;
 
-	*ea_name = name + XATTR_USER_PREFIX_LEN;
-	*ea_name_len = name_len - XATTR_USER_PREFIX_LEN;
+		if (!strncmp(*ea_name, DOS_ATTRIBUTE_PREFIX,
+			     DOS_ATTRIBUTE_PREFIX_LEN))
+			return false;
 
-	if (!strncmp(*ea_name, STREAM_PREFIX, STREAM_PREFIX_LEN))
-		return false;
+		return true;
+	}
 
-	if (!strncmp(*ea_name, DOS_ATTRIBUTE_PREFIX,
-		     DOS_ATTRIBUTE_PREFIX_LEN))
+	if (!posix_extensions || !ksmbd_is_posix_ea_name(name, name_len))
 		return false;
 
+	*ea_name = name;
+	*ea_name_len = name_len;
 	return true;
 }
 
@@ -2683,11 +2715,13 @@ static bool ksmbd_is_visible_ea_name(const char *name, const char **ea_name,
  * @buf_len:	set info command buffer length
  * @path:	dentry path for get ea
  * @get_write:	get write access to a mount
+ * @posix_extensions:	client negotiated SMB3 POSIX extensions
  *
  * Return:	0 on success, otherwise error
  */
 static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
-		       const struct path *path, bool get_write)
+		       const struct path *path, bool get_write,
+		       bool posix_extensions)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
@@ -2712,7 +2746,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			    le16_to_cpu(eabuf->EaValueLength),
 			    le32_to_cpu(eabuf->NextEntryOffset));
 
-		attr_name_len = ksmbd_map_ea_name_to_xattr(eabuf->name,
+		attr_name_len = ksmbd_map_ea_name_to_xattr(posix_extensions,
+							   eabuf->name,
 							   eabuf->EaNameLength,
 							   attr_name);
 		if (attr_name_len < 0) {
@@ -3694,7 +3729,8 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path, false);
+					 &path, false,
+					 work->tcon->posix_extensions);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5180,7 +5216,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 
 	path = &fp->filp->f_path;
-	/* single EA entry is requested with given user.* name */
+	/* single EA entry is requested with a client-visible EA name */
 	if (req->InputBufferLength) {
 		if (le32_to_cpu(req->InputBufferLength) <=
 		    sizeof(struct smb2_ea_info_req))
@@ -5233,14 +5269,16 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		ksmbd_debug(SMB, "%s, len %d\n", name, name_len);
 		idx += name_len + 1;
 
-		if (!ksmbd_is_visible_ea_name(name, &ea_name,
+		if (!ksmbd_is_visible_ea_name(work->tcon->posix_extensions, name,
+					      &ea_name,
 					      &visible_name_len))
 			continue;
 
 		name_len = visible_name_len;
 
 		if (req->InputBufferLength &&
-		    strncmp(ea_name, ea_req->name, ea_req->EaNameLength))
+		    (name_len != ea_req->EaNameLength ||
+		     strncmp(ea_name, ea_req->name, ea_req->EaNameLength)))
 			continue;
 
 		ptr = eainfo->name + name_len + 1;
@@ -7061,7 +7099,8 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			return -EMSGSIZE;
 
 		return smb2_set_ea((struct smb2_ea_info *)buffer,
-				   buf_len, &fp->filp->f_path, true);
+				   buf_len, &fp->filp->f_path, true,
+				   work->tcon->posix_extensions);
 	}
 	case FILE_POSITION_INFORMATION:
 	{
-- 
2.43.0

