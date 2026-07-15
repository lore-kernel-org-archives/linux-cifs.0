Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8073C4B68;
	Wed, 15 Jul 2026 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101807; cv=none; b=Lk/ZR4Iv/MeFe6lM4h5zElZBEuObeBAhLlTGJ5/6w+F3rVpgEDS314+9jWwAT2Dj8SwysUj24mob8w4sxrrceXkeOtmd+gWG15GBEMCUYe9d3inqJo264yGLmgd1HF7iZfsg29wUbHF1ozGc0OBnFZhuVHET1c5CFj9/Gvh010I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101807; c=relaxed/simple;
	bh=XZXKlqRS/cY/YNids5hA2j+jGQRjGANbv4nolwgmkm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dndh4cbaCPYSbRoC4qJII8ACBa5dZ0DJq3deKsUnmBIvcclnx8jZl7o1SAjBuiTodQMHEvJrOqxGQHuQWFqf5yPf0bEWsjndKEiGGXkbv+s1tetwIjehZT+q00YGAOYathHpCvUuBmdCPyvKzoHHGt3xSSYFiKyiB4mdGlwDyWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c558d478802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:903d867d-f580-477e-943e-b204f429e428,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:903d867d-f580-477e-943e-b204f429e428,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:2d2cae620ba2258eaed2616406164464,BulkI
	D:2607151549586ZRS8Q7S,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c558d478802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1132277852; Wed, 15 Jul 2026 15:49:55 +0800
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
Subject: [RFC PATCH 6/9] ksmbd: support security.capability EAs
Date: Wed, 15 Jul 2026 15:48:47 +0800
Message-ID: <20260715074908.641940-7-tanze@kylinos.cn>
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

generic/093 uses setcap and getcap to check that a write clears the file
capability. ksmbd adds the user prefix to every SMB EA name, so setcap
stores security.capability as user.security.capability and getcap cannot
read it as a file capability.

When SMB3 POSIX extensions are available, map security.capability to the
same backing xattr name. Use this mapping for set, get, and list
operations.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 71 +++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 757dee9afaa4..255300501af3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2734,9 +2734,35 @@ static bool smb2_is_private_ea(const char *name, size_t name_len)
 	return false;
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
 
@@ -2746,20 +2772,26 @@ static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
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
 
-	*ea_name = name + XATTR_USER_PREFIX_LEN;
-	*ea_name_len = name_len - XATTR_USER_PREFIX_LEN;
+		if (smb2_is_private_ea(*ea_name, *ea_name_len))
+			return false;
+
+		return true;
+	}
 
-	if (smb2_is_private_ea(*ea_name, *ea_name_len))
+	if (!posix_extensions || !ksmbd_is_posix_ea_name(name, name_len))
 		return false;
 
+	*ea_name = name;
+	*ea_name_len = name_len;
 	return true;
 }
 
@@ -2770,11 +2802,13 @@ static bool ksmbd_is_visible_ea_name(const char *name, const char **ea_name,
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
@@ -2799,7 +2833,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			    le16_to_cpu(eabuf->EaValueLength),
 			    le32_to_cpu(eabuf->NextEntryOffset));
 
-		attr_name_len = ksmbd_map_ea_name_to_xattr(eabuf->name,
+		attr_name_len = ksmbd_map_ea_name_to_xattr(posix_extensions,
+							   eabuf->name,
 							   eabuf->EaNameLength,
 							   attr_name);
 		if (attr_name_len < 0) {
@@ -3886,7 +3921,8 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path, false);
+					 &path, false,
+					 work->tcon->posix_extensions);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5580,7 +5616,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 
 	path = &fp->filp->f_path;
-	/* single EA entry is requested with given user.* name */
+	/* single EA entry is requested with a client-visible EA name */
 	if (req->InputBufferLength) {
 		if (le32_to_cpu(req->InputBufferLength) <=
 		    sizeof(struct smb2_ea_info_req))
@@ -5633,14 +5669,16 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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
@@ -7618,7 +7656,8 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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

