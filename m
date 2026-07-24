Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8B423770
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889684; cv=none; b=o0oTrFy8T1kVrqQsD1U0FRIQQZ2YC0X7ErAdJviuq7qQz8htdh4SkAd2tZAe/7QqBRJ5prvCvZueEG72Jl/V6OwWzbb/i7/edFOF2Hf+gEmGQ2NoJkKOhZNeVUbDAiY84HKsEnzPVYmMuBE7i9ZYc29t7hyY0k+mBuZ4uX/jmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889684; c=relaxed/simple;
	bh=fHOskDirRW0nRkfRfRdzsUd+pVPhP9vU/kXCCLmR0ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mohfpQnRJtGCW1+NtyzaTdfdqu8+NM9UJIJyieHcTaIsOk+tSfMFJtlxvvbYWst21T9TVtscfg4w501C+3foJFrVyGZl+p7eP1joCY98Vl+0kX/ReerffBDyYUSdR5xhJqrB9UgI/h1GPnxJVP059v9Ab79sPrFe1M3dwn+Z0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 31fdd246874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:f1d54eb5-8df3-4b8e-9eff-327d99ea5f86,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:f1d54eb5-8df3-4b8e-9eff-327d99ea5f86,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:45afe7dada6fdd13d3e6fdaabc59447b,BulkI
	D:260724184115VTBBH4T8,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 31fdd246874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 114617829; Fri, 24 Jul 2026 18:41:15 +0800
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
Subject: [PATCH 07/15] ksmbd: query security.capability on POSIX EA handles
Date: Fri, 24 Jul 2026 18:40:01 +0800
Message-ID: <e24e14bf49f1749d8caa863980263b7307441f85.1784888897.git.tanze@kylinos.cn>
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

Treat security.capability as a native xattr only for a file handle
opened with an SMB3 POSIX create context. Non-POSIX handles retain the
existing user namespace mapping.

Allow native queries when the mapped fsuid is root or the tree
connection has KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT. In native mode,
return security.capability without a prefix and hide a colliding
user.security.capability backing xattr. Reject embedded NUL bytes before
classifying a requested SMB EA name.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 80 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1f0872bf11ae..7fdc6df6310a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2643,6 +2643,43 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
+static const char * const ksmbd_native_xattr_names[] = {
+	XATTR_NAME_CAPS,
+};
+
+static bool ksmbd_native_xattrs_allowed(struct ksmbd_work *work)
+{
+	return uid_eq(current_fsuid(), GLOBAL_ROOT_UID) ||
+	       test_tree_conn_flag(work->tcon,
+				   KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT);
+}
+
+static int ksmbd_check_native_xattr(struct ksmbd_work *work,
+				    const char *name, size_t name_len)
+{
+	bool native = false;
+	size_t i;
+
+	if (memchr(name, '\0', name_len))
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ksmbd_native_xattr_names); i++) {
+		size_t xattr_len = strlen(ksmbd_native_xattr_names[i]);
+
+		if (name_len == xattr_len &&
+		    !memcmp(name, ksmbd_native_xattr_names[i], name_len)) {
+			native = true;
+			break;
+		}
+	}
+
+	if (!native)
+		return 0;
+	if (!ksmbd_native_xattrs_allowed(work))
+		return -EACCES;
+	return 1;
+}
+
 static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
 				      size_t ea_name_len, char *attr_name)
 {
@@ -2655,24 +2692,36 @@ static int ksmbd_map_ea_name_to_xattr(const char *ea_name,
 	return XATTR_USER_PREFIX_LEN + ea_name_len;
 }
 
-static bool ksmbd_is_visible_ea_name(const char *name, const char **ea_name,
-				     size_t *ea_name_len)
+static bool ksmbd_is_visible_ea_name(struct ksmbd_work *work,
+				     bool native_xattrs, const char *name,
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
+		if (!strncmp(*ea_name, STREAM_PREFIX, STREAM_PREFIX_LEN))
+			return false;
 
-	if (!strncmp(*ea_name, STREAM_PREFIX, STREAM_PREFIX_LEN))
-		return false;
+		if (!strncmp(*ea_name, DOS_ATTRIBUTE_PREFIX,
+			     DOS_ATTRIBUTE_PREFIX_LEN))
+			return false;
 
-	if (!strncmp(*ea_name, DOS_ATTRIBUTE_PREFIX,
-		     DOS_ATTRIBUTE_PREFIX_LEN))
+		if (native_xattrs &&
+		    ksmbd_check_native_xattr(work, *ea_name, *ea_name_len))
+			return false;
+
+		return true;
+	}
+
+	if (!native_xattrs ||
+	    ksmbd_check_native_xattr(work, name, name_len) <= 0)
 		return false;
 
+	*ea_name = name;
+	*ea_name_len = name_len;
 	return true;
 }
 
@@ -5181,7 +5230,6 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 
 	path = &fp->filp->f_path;
-	/* single EA entry is requested with given user.* name */
 	if (req->InputBufferLength) {
 		if (le32_to_cpu(req->InputBufferLength) <=
 		    sizeof(struct smb2_ea_info_req))
@@ -5194,6 +5242,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		    offsetof(struct smb2_ea_info_req, name) +
 		    ea_req->EaNameLength)
 			return -EINVAL;
+
+		if (fp->is_posix_ctxt) {
+			rc = ksmbd_check_native_xattr(work, ea_req->name,
+						     ea_req->EaNameLength);
+			if (rc < 0)
+				return rc;
+		}
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
 		if (le32_to_cpu(req->Flags) & SL_RETURN_SINGLE_ENTRY)
@@ -5234,7 +5289,8 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		ksmbd_debug(SMB, "%s, len %d\n", name, name_len);
 		idx += name_len + 1;
 
-		if (!ksmbd_is_visible_ea_name(name, &ea_name,
+		if (!ksmbd_is_visible_ea_name(work, fp->is_posix_ctxt, name,
+					      &ea_name,
 					      &visible_name_len))
 			continue;
 
-- 
2.43.0

