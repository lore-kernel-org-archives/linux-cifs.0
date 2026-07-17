Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15CE37A826;
	Fri, 17 Jul 2026 03:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259622; cv=none; b=mFVlCGxtIkiC76xpb5TvT2HjldNHgL/ybc6vmgznCeLI94Z2D5md4F18Os8fdU7H6Q1DehO3+g+wsfPX0OPOc9LudutnhGdQVXQJYEGwUvGeKw+hC34XCWUV0P8bHfmxefZNeHgW79Qf8TWgJIZxkBEc6hXmTpBIy3rR9ic1or0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259622; c=relaxed/simple;
	bh=JZ99owPIk1R993ZTs7gkcuK9kecx7wMozlLeaeVjx+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keWbGHVi0k+NCq9VNg5gKKb6n7Nq0i53/AYRdGj21JsWKTEWKl4rCGX5kmLTvdNIPWeFsQslNtQxTIOuDF21Hha0m7S6VTqPsaUfn70nrqZ6Pk6UKGnde84+NySsuBZAOXkQ18ScTlZ9rTbJB/SJLkB/2geEe9eU4mz2KpsMi3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3702ae12819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:827a2fa4-d77f-49f2-9125-f39c5a65b292,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:827a2fa4-d77f-49f2-9125-f39c5a65b292,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:50d958c8e477cc9271204cd5095665ed,BulkI
	D:260717114014LEEY44NE,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3702ae12819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 534809498; Fri, 17 Jul 2026 11:40:11 +0800
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
Subject: [RFC PATCH v2 4/9] ksmbd: extract SMB EA backing xattr name mapping
Date: Fri, 17 Jul 2026 11:39:22 +0800
Message-ID: <b35f52f2647bde20007243b4185344fc62622b3a.1784258165.git.tanze@kylinos.cn>
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

smb2_set_ea() directly adds the user prefix when it builds the backing
xattr name. This mixes name conversion with the set operation.

Extract ksmbd_map_ea_name_to_xattr() and keep the existing behavior
unchanged.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b73167785e87..dad3427a584e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2643,6 +2643,18 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
+static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
+				      size_t ea_name_len, char *attr_name)
+{
+	if (ea_name_len > XATTR_NAME_MAX - XATTR_USER_PREFIX_LEN)
+		return -EINVAL;
+
+	memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
+	memcpy(&attr_name[XATTR_USER_PREFIX_LEN], ea_name, ea_name_len);
+	attr_name[XATTR_USER_PREFIX_LEN + ea_name_len] = '\0';
+	return XATTR_USER_PREFIX_LEN + ea_name_len;
+}
+
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
@@ -2658,7 +2670,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
-	int rc = 0;
+	int rc = 0, attr_name_len;
 	unsigned int next = 0;
 
 	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
@@ -2679,24 +2691,21 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			    le16_to_cpu(eabuf->EaValueLength),
 			    le32_to_cpu(eabuf->NextEntryOffset));
 
-		if (eabuf->EaNameLength >
-		    (XATTR_NAME_MAX - XATTR_USER_PREFIX_LEN)) {
+		attr_name_len = ksmbd_map_ea_name_to_xattr(eabuf->name,
+							   eabuf->EaNameLength,
+							   attr_name);
+		if (attr_name_len < 0) {
 			rc = -EINVAL;
 			break;
 		}
 
-		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
-		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
-		       eabuf->EaNameLength);
-		attr_name[XATTR_USER_PREFIX_LEN + eabuf->EaNameLength] = '\0';
 		value = (char *)&eabuf->name + eabuf->EaNameLength + 1;
 
 		if (!eabuf->EaValueLength) {
 			rc = ksmbd_vfs_casexattr_len(idmap,
 						     path->dentry,
 						     attr_name,
-						     XATTR_USER_PREFIX_LEN +
-						     eabuf->EaNameLength);
+						     attr_name_len);
 
 			/* delete the EA only when it exits */
 			if (rc > 0) {
-- 
2.43.0

