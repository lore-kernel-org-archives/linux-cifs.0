Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904A41DDF6
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889681; cv=none; b=aJYMoHEEMuDTAz3/J4al6BGmHjkgRIS31yVk8QafvzVeq2ktDi0mjs5RUxLtXT8rOnG1bimqW/8aczvr9v7IYAQgKJnTDzXStfn7gqJLN0snKMVywDRUU1fV0Srkas2N2zK6evmENI885UV+agrCb62Pk6d8tMQU3CyxGua7BAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889681; c=relaxed/simple;
	bh=yAcKsrLAsTmiDoEIuBjHvi+6e2e6c6+Gbd9uoSqjhnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeqMsyxdyaiNl6c7cm/3fbmr64pyvHGWwpc5niByeM3PEmhGJx9kvEWFB02OBHQj7j+zeV3lfIOSYZYgAb9iFOKaspyQRIWIyPY7Bl68iO72hZB0i5JOj7sYtHXxHsQLY+6hmE1tZux+Xtw40fUVTx76jA0kNnY9vJCZlNliT10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 306ec7d2874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:58917920-aa30-4e5e-af21-b8f6793355dc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:58917920-aa30-4e5e-af21-b8f6793355dc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:6690d4b2eb769453474803dd7ac42261,BulkI
	D:260724184112ZOIYPDF6,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 306ec7d2874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 986850080; Fri, 24 Jul 2026 18:41:12 +0800
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
Subject: [PATCH 02/15] ksmbd: extract SMB EA response name handling
Date: Fri, 24 Jul 2026 18:39:56 +0800
Message-ID: <12e1caaa708edeedb2cd1edb3c71f13cd6ecd7d2.1784888897.git.tanze@kylinos.cn>
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

smb2_get_ea() exposes only backing xattrs in the user namespace and
removes the "user." prefix from their SMB EA names. Move that filtering
and name conversion into ksmbd_is_visible_ea_name() so response
construction is independent of namespace policy.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 53 ++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0cef7dab453a..baa6e8f0eba4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2655,6 +2655,27 @@ static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
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
+	if (!strncmp(*ea_name, STREAM_PREFIX, STREAM_PREFIX_LEN))
+		return false;
+
+	if (!strncmp(*ea_name, DOS_ATTRIBUTE_PREFIX,
+		     DOS_ATTRIBUTE_PREFIX_LEN))
+		return false;
+
+	return true;
+}
+
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
@@ -5203,36 +5224,25 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
-			     STREAM_PREFIX_LEN))
-			continue;
+		name_len = visible_name_len;
 
 		if (req->InputBufferLength &&
-		    strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
-			    ea_req->EaNameLength))
+		    strncmp(ea_name, ea_req->name, ea_req->EaNameLength))
 			continue;
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN],
-			     DOS_ATTRIBUTE_PREFIX, DOS_ATTRIBUTE_PREFIX_LEN))
-			continue;
-
-		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-			name_len -= XATTR_USER_PREFIX_LEN;
-
 		ptr = eainfo->name + name_len + 1;
 		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
 				name_len + 1);
@@ -5257,12 +5267,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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

