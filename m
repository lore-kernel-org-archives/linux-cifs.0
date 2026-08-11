Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB95B23BD17
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428109; cv=none; b=UKURUi8xXa1LvTx2EOFPLSyhYad4MLXI/0NtShu1pqnGtwfcQysu1O937uCRYy9XKPJrXooj3dh+rGGTFgxo229MjE/fCfPNsDeQJ6/M0YvMAv9QOoSREVs5NR0XNXhirqIUSkkm5tgxVE/c6MDxFx85g+hvNq8pEk1M+NPI+Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428109; c=relaxed/simple;
	bh=ejkg21qymPJoJCbG87TlOTK5vHqHI3CpWNg1FKB4k/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIubrAJEc7hofyKwJN5lsSANFmAmGIfdNUhOnlA0Sxtd6bKRoxFPL/I7W/urUkfmBzjUIF1D/Up+Gny+zPUOkA4+B9XMGIFgcq050ezGDy0rQmuVOYRjBwxvNHqLXXOqrIsJTxlX8QpX1LUYb72UZuACEuz0EaxbNiy7X1DgMls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1b2e8748954a11f1aa26b74ffac11d73-20260811
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
X-CID-O-INFO: VERSION:1.3.12,REQID:137cffc9-88c7-4b2b-a532-cec631117bc4,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:137cffc9-88c7-4b2b-a532-cec631117bc4,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:0c0057b975c5381be3a772572a8610a5,BulkI
	D:2608111401379Z338HBF,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b2e8748954a11f1aa26b74ffac11d73-20260811
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1579145258; Tue, 11 Aug 2026 14:01:34 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	ronniesahlberg@gmail.com,
	pc@manguebit.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	hehuiwen@kylinos.cn,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 3/3] smb/client: decode reparse metadata using its payload type
Date: Tue, 11 Aug 2026 14:00:47 +0800
Message-ID: <7b52e561833274ffb64fc48d49a5da84fb9d90ae.1786427463.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786427463.git.tanze@kylinos.cn>
References: <cover.1786427463.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_open_info_data stores FILE_ALL_INFORMATION and SMB3 POSIX query
information in a union. reparse_info_to_fattr() selects a union member
from the mount mode, while several directory checks always read
fi.Attributes.

The metadata can instead come from an SMB2 CREATE response on a POSIX
mount, or from a POSIX query while processing a reparse point. In those
cases the mount mode and hard-coded fi accesses select the wrong union
member.

See the procedures below:

  cifs_nt_open
    smb2_open_file
      SMB2_open
        data->fi = SMB2 CREATE response
        data->contains_posix_file_info = false
    cifs_get_inode_info
      reparse_info_to_fattr
        if (tcon->posix_extensions) // true
          smb311_posix_info_to_fattr
            data->posix_fi // wrong union member

  smb311_posix_get_fattr
    smb2_query_path_info
      smb2_compound_op
        data->posix_fi = SMB3 POSIX query response
        data->contains_posix_file_info = true
    reparse_info_to_fattr
      data->fi.Attributes // wrong union member

Add a common DOS attribute accessor and use contains_posix_file_info
both for attribute reads and for the final fattr conversion.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/inode.c     |  9 +++++----
 fs/smb/client/reparse.h   | 17 ++++++++++-------
 fs/smb/client/smb2inode.c |  6 ++++--
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0afff761aab9..e7ef50b74378 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1215,7 +1215,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		break;
 	case IO_REPARSE_TAG_INTERNAL:
 		rc = 0;
-		if (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY) {
+		if (cifs_open_data_attrs(data) & ATTR_DIRECTORY) {
 			cifs_create_junction_fattr(fattr, sb);
 			goto out;
 		}
@@ -1239,7 +1239,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			 */
 			if (rc == -EOPNOTSUPP &&
 			    IS_REPARSE_TAG_NAME_SURROGATE(data->reparse.tag) &&
-			    (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY)) {
+			    (cifs_open_data_attrs(data) & ATTR_DIRECTORY)) {
 				rc = 0;
 				cifs_create_junction_fattr(fattr, sb);
 				goto out;
@@ -1257,13 +1257,14 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		}
 
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
-			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+			bool directory = cifs_open_data_attrs(data) & ATTR_DIRECTORY;
+
 			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
 		}
 		break;
 	}
 
-	if (tcon->posix_extensions)
+	if (data->contains_posix_file_info)
 		smb311_posix_info_to_fattr(fattr, data, sb);
 	else
 		cifs_open_info_to_fattr(fattr, data, sb);
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 0164dc47bdfd..49efd85b1e94 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -98,15 +98,21 @@ static inline bool reparse_inode_match(struct inode *inode,
 		timespec64_equal(&ctime, &fattr->cf_ctime);
 }
 
+static inline u32 cifs_open_data_attrs(const struct cifs_open_info_data *data)
+{
+	if (data->contains_posix_file_info)
+		return le32_to_cpu(data->posix_fi.DosAttributes);
+
+	return le32_to_cpu(data->fi.Attributes);
+}
+
 static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 {
-	u32 attrs;
-	bool ret;
+	u32 attrs = cifs_open_data_attrs(data);
 
 	if (data->contains_posix_file_info) {
 		struct smb311_posix_qinfo *fi = &data->posix_fi;
 
-		attrs = le32_to_cpu(fi->DosAttributes);
 		if (data->reparse_point) {
 			attrs |= ATTR_REPARSE_POINT;
 			fi->DosAttributes = cpu_to_le32(attrs);
@@ -115,16 +121,13 @@ static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 	} else {
 		struct smb2_file_all_info *fi = &data->fi;
 
-		attrs = le32_to_cpu(fi->Attributes);
 		if (data->reparse_point) {
 			attrs |= ATTR_REPARSE_POINT;
 			fi->Attributes = cpu_to_le32(attrs);
 		}
 	}
 
-	ret = attrs & ATTR_REPARSE_POINT;
-
-	return ret;
+	return attrs & ATTR_REPARSE_POINT;
 }
 
 bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 058b05f7a3e5..bcaa44814b71 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -22,6 +22,7 @@
 #include "smb2glob.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
+#include "reparse.h"
 #include "../common/smb2status.h"
 #include "../common/smbfsctl.h"
 
@@ -1002,12 +1003,13 @@ int smb2_query_path_info(const unsigned int xid,
 		/*
 		 * If the symlink was already parsed in create response then it is needed to fix
 		 * its type now (after the second call with OPEN_REPARSE_POINT which filled the
-		 * data->fi.Attributes). If the symlink was not parsed in create response then
+		 * metadata attributes). If the symlink was not parsed in create response then
 		 * the data->symlink_target was not filled yet and then the type will be fixed
 		 * later after data->symlink_target is filled.
 		 */
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc && data->symlink_target) {
-			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+			bool directory = cifs_open_data_attrs(data) & ATTR_DIRECTORY;
+
 			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
 		}
 		break;
-- 
2.43.0

