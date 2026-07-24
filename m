Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7879E402BA1
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889685; cv=none; b=f1Mw1eIUt/hbj7oWWO7T3/4buM7WKt1rulYa8AoEqIrX7hhJ8yHA6GMsn48LWbKa8Vh9CjD/tFDdzhDFIHdyqJ1UUFwLwN64MRALtlg7/cSDDKUye7ey4f+08SU06EROqfW/mz4LwBP4QcAXU0RW7Zt1MmQzYPu/635LBqMjR9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889685; c=relaxed/simple;
	bh=/06oBG+wYNONqnL2AMGwbSz1mKSnWc8CNM4pSEY6Jvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFdWldns7ASr2zGgUtOoM6nJFUIuG4vM5WnwzCnVkvK/G0d/I8l2xR+FNE4gGNhpD6wHTZgfwx0C/wtl1VGaS2d1D/BJQPQbSLLJEinZgT7zEKKJfZceasyCd8HCviWwoI2DJtebkFdi2sYUHTODfFs7KfzGRUPtf5CXEAVCRIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 32459590874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:c5dfccc9-ab84-4483-a7a9-396676ce3780,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:c5dfccc9-ab84-4483-a7a9-396676ce3780,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:db2e8db26b0f6609bec61d3208db2909,BulkI
	D:260724184118U3C570AA,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32459590874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 943136306; Fri, 24 Jul 2026 18:41:15 +0800
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
Subject: [PATCH 08/15] ksmbd: set security.capability on POSIX EA handles
Date: Fri, 24 Jul 2026 18:40:02 +0800
Message-ID: <47538d9ace8608e24cae15c2ad7c20cf3ec7df8b.1784888897.git.tanze@kylinos.cn>
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

Map security.capability directly to its native backing xattr when the
file handle was opened with an SMB3 POSIX create context. Ordinary EAs
and non-POSIX handles retain the existing user namespace mapping.

Pass the ksmbd_work and per-open POSIX state through smb2_set_ea() from
both the CREATE and SET_INFO paths. This lets
ksmbd_map_ea_name_to_xattr() apply the same root or admin authorization
used by native queries.

Return native mapping errors to the caller instead of replacing them
with -EINVAL.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 43 +++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7fdc6df6310a..6baeac99b12f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2680,9 +2680,27 @@ static int ksmbd_check_native_xattr(struct ksmbd_work *work,
 	return 1;
 }
 
-static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
-				      size_t ea_name_len, char *attr_name)
+static int ksmbd_map_ea_name_to_xattr(struct ksmbd_work *work,
+				      bool native_xattrs,
+				      const char *ea_name, size_t ea_name_len,
+				      char *attr_name)
 {
+	int rc;
+
+	if (native_xattrs) {
+		rc = ksmbd_check_native_xattr(work, ea_name, ea_name_len);
+		if (rc < 0)
+			return rc;
+		if (rc) {
+			if (ea_name_len > XATTR_NAME_MAX)
+				return -EINVAL;
+
+			memcpy(attr_name, ea_name, ea_name_len);
+			attr_name[ea_name_len] = '\0';
+			return ea_name_len;
+		}
+	}
+
 	if (ea_name_len > XATTR_NAME_MAX - XATTR_USER_PREFIX_LEN)
 		return -EINVAL;
 
@@ -2728,15 +2746,18 @@ static bool ksmbd_is_visible_ea_name(struct ksmbd_work *work,
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
+ * @work:	smb work containing session and tree information
  * @eabuf:	set info command buffer
  * @buf_len:	set info command buffer length
  * @path:	dentry path for get ea
  * @get_write:	get write access to a mount
+ * @native_xattrs:	the open included an SMB3 POSIX create context
  *
  * Return:	0 on success, otherwise error
  */
-static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
-		       const struct path *path, bool get_write)
+static int smb2_set_ea(struct ksmbd_work *work, struct smb2_ea_info *eabuf,
+		       unsigned int buf_len, const struct path *path,
+		       bool get_write, bool native_xattrs)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
@@ -2762,11 +2783,12 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			    le16_to_cpu(eabuf->EaValueLength),
 			    le32_to_cpu(eabuf->NextEntryOffset));
 
-		attr_name_len = ksmbd_map_ea_name_to_xattr(eabuf->name,
+		attr_name_len = ksmbd_map_ea_name_to_xattr(work, native_xattrs,
+							   eabuf->name,
 							   eabuf->EaNameLength,
 							   attr_name);
 		if (attr_name_len < 0) {
-			rc = -EINVAL;
+			rc = attr_name_len;
 			break;
 		}
 
@@ -3742,9 +3764,9 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out;
 			}
 
-			rc = smb2_set_ea(&ea_buf->ea,
+			rc = smb2_set_ea(work, &ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path, true);
+					 &path, true, posix_ctxt);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -7132,8 +7154,9 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (buf_len < sizeof(struct smb2_ea_info))
 			return -EMSGSIZE;
 
-		return smb2_set_ea((struct smb2_ea_info *)buffer,
-				   buf_len, &fp->filp->f_path, true);
+		return smb2_set_ea(work, (struct smb2_ea_info *)buffer,
+				   buf_len, &fp->filp->f_path, true,
+				   fp->is_posix_ctxt);
 	}
 	case FILE_POSITION_INFORMATION:
 	{
-- 
2.43.0

