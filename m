Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D1C3C584B;
	Wed, 15 Jul 2026 07:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101807; cv=none; b=jjRaGmiKY6EAz/PjLkx0vcWqCOP7rkNOKGJPE8/yTpC0re9NJoW9ClHRNs22o0ehLflmVR8rxfVaUNllr9RplYv3vKtL8x8VflmrhbZTRFnPSS/qdCpf9gFjF2PXn8j1W7MEp9uEA+5OZ5NLBOTv451BEACLeTjdriTc/DjpAA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101807; c=relaxed/simple;
	bh=6vumLtg+NSqh9KEl72aJmIZBwm1412P2yAKu432IMf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRahH/X9rXQ+DlvWLRqPneu0ESbeZVjo72yYbqX6PVkzqW0B5H4yDQag26AykgjN2gmjNEfSG/QKEpxQOIbOpNdCU00tJkps9xFKqJexuY4M2xgBkAqG2WmXhYqEQnWMOrae0vyu0FH26LJ0FN+eTaJl1O/EKAWMm78EwXaXU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c4bd38ec802111f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c279df7d-e89e-44c8-b280-42f78d5151b2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:c279df7d-e89e-44c8-b280-42f78d5151b2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:7fbfefa8f87fb27be22ea853464ba6a9,BulkI
	D:2607151549556KBJRHNX,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c4bd38ec802111f1aa26b74ffac11d73-20260715
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 959226334; Wed, 15 Jul 2026 15:49:54 +0800
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
Subject: [RFC PATCH 5/9] ksmbd: extract SMB EA response name handling
Date: Wed, 15 Jul 2026 15:48:46 +0800
Message-ID: <20260715074908.641940-6-tanze@kylinos.cn>
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

smb2_get_ea() directly checks the user namespace, filters internal EAs,
and removes the user prefix.

Extract ksmbd_is_visible_ea_name() and keep the existing behavior
unchanged.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1e4ea33d7001..757dee9afaa4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2746,6 +2746,23 @@ static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
 	return XATTR_USER_PREFIX_LEN + ea_name_len;
 }
 
+static bool ksmbd_is_visible_ea_name(const char *name, const char **ea_name,
+				     size_t *ea_name_len)
+{
+	size_t name_len = strlen(name);
+
+	if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
+		return false;
+
+	*ea_name = name + XATTR_USER_PREFIX_LEN;
+	*ea_name_len = name_len - XATTR_USER_PREFIX_LEN;
+
+	if (smb2_is_private_ea(*ea_name, *ea_name_len))
+		return false;
+
+	return true;
+}
+
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
@@ -5607,32 +5624,25 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	idx = 0;
 
 	while (idx < xattr_list_len) {
+		const char *ea_name;
+		size_t visible_name_len;
+
 		name = xattr_list + idx;
 		name_len = strlen(name);
 
 		ksmbd_debug(SMB, "%s, len %d\n", name, name_len);
 		idx += name_len + 1;
 
-		/*
-		 * CIFS does not support EA other than user.* namespace,
-		 * still keep the framework generic, to list other attrs
-		 * in future.
-		 */
-		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
+		if (!ksmbd_is_visible_ea_name(name, &ea_name,
+					      &visible_name_len))
 			continue;
 
-		if (req->InputBufferLength &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
-			    ea_req->EaNameLength))
-			continue;
+		name_len = visible_name_len;
 
-		if (smb2_is_private_ea(&name[XATTR_USER_PREFIX_LEN],
-				       name_len - XATTR_USER_PREFIX_LEN))
+		if (req->InputBufferLength &&
+		    strncmp(ea_name, ea_req->name, ea_req->EaNameLength))
 			continue;
 
-		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-			name_len -= XATTR_USER_PREFIX_LEN;
-
 		ptr = eainfo->name + name_len + 1;
 		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
 				name_len + 1);
@@ -5657,12 +5667,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		ptr += value_len;
 		eainfo->Flags = 0;
 		eainfo->EaNameLength = name_len;
-
-		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-			memcpy(eainfo->name, &name[XATTR_USER_PREFIX_LEN],
-			       name_len);
-		else
-			memcpy(eainfo->name, name, name_len);
+		memcpy(eainfo->name, ea_name, name_len);
 
 		eainfo->name[name_len] = '\0';
 		eainfo->EaValueLength = cpu_to_le16(value_len);
-- 
2.43.0

