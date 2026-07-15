Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EC73C5837;
	Wed, 15 Jul 2026 07:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101805; cv=none; b=JzjbSrquQAZYcY6FqIvit7FWZBnAtPLQuU0XptCUcBu9z54U+gsD+YTIr+i4CCXcdURsqrPjy6a017RmAmZKEe+OOTN5O58HeDr0cZkF7PpZGzqCtxdOJ9HA6x66GJP63LN5ZJ3R/aGHlu019NjWnQxAT9K3o4vDxE31gGjPZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101805; c=relaxed/simple;
	bh=sMW/eSg6SUKX0VdP07zsSqXpyL7C0nvSQ3GxGpNahjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAyXtL8TIFRkhQmwUwqBuk0uAdG91Q9nLeOLCXll5QoCocw5CacgKoEfIApxXDRCh5PknF7I340klBDvLsxz5XYCkvskNAFqiZURvfC30ggyzxXu8GYWCc3aKq37V2oFcfiBIMd68ZNzNAPz82g9ahe1HXmLtHpFrEXJLdmukZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c4107742802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4b72f488-e7a6-43c2-b4ab-d521fb7614af,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:4b72f488-e7a6-43c2-b4ab-d521fb7614af,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:dbaca5684c4ae5c397ed63075caacf68,BulkI
	D:260715154955AVPAJO36,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c4107742802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1576581277; Wed, 15 Jul 2026 15:49:53 +0800
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
Subject: [RFC PATCH 4/9] ksmbd: extract SMB EA backing xattr name mapping
Date: Wed, 15 Jul 2026 15:48:45 +0800
Message-ID: <20260715074908.641940-5-tanze@kylinos.cn>
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

smb2_set_ea() directly adds the user prefix when it builds the backing
xattr name. This mixes name conversion with the set operation.

Extract ksmbd_map_ea_name_to_xattr() and keep the existing behavior
unchanged.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 295cca6cf3ae..1e4ea33d7001 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2734,6 +2734,18 @@ static bool smb2_is_private_ea(const char *name, size_t name_len)
 	return false;
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
@@ -2749,7 +2761,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	char *attr_name = NULL, *value;
-	int rc = 0;
+	int rc = 0, attr_name_len;
 	unsigned int next = 0;
 
 	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
@@ -2770,8 +2782,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
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
@@ -2780,18 +2794,13 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
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

