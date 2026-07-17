Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D59237AA8C;
	Fri, 17 Jul 2026 03:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259622; cv=none; b=LFv6aIyMZWz/7UzUQQ+qVom3+lmbhrMGtLA8DjT5GS6A/k9pdAmO+7YocN9TVf8peDBKrtzp/tlS1Pv8CpCk6lzMTao97H5gae4XooxJdTDHEMhMmQkkn4wha6UsMf5N8GWSULCZ4lIwo7aKxk+KkPdJKurCVXLeTNHry/ZNZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259622; c=relaxed/simple;
	bh=S2PJ9TQ6CSK/i30KBfyB5QWhwJ0KurmhlpTRvnPvlIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeRSRmRADdip83PbFela+QxEONjz31pPiNNvELB+pTaaMviJno0GvMFAztxOITN3AteMcfWrBBMtrYqxK+4pMwie+on9XHJUJzVGOYJMmT/msoDo3nmHOB3T/gnQaUaF/cy59MTd7AznFEPmFedLmABApNgg7JRDwe0t7NoIsRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3825ea3e819111f1aa26b74ffac11d73-20260717
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
X-CID-O-INFO: VERSION:1.3.12,REQID:81402134-0a88-4cbc-a0cf-3500cf1bcf98,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:81402134-0a88-4cbc-a0cf-3500cf1bcf98,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:f8ffe0a57a6fa949b9d4653810794a4f,BulkI
	D:26071711401402TO5L99,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3825ea3e819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1222735318; Fri, 17 Jul 2026 11:40:13 +0800
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
Subject: [RFC PATCH v2 8/9] ksmbd: support trusted EAs
Date: Fri, 17 Jul 2026 11:39:26 +0800
Message-ID: <44a69ab54011239b84fc4afcdaf7869863d052bb.1784258165.git.tanze@kylinos.cn>
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

generic/093 uses "setfattr -n trusted.name" and getfattr to check that a
write does not clear the trusted xattr. ksmbd stores the attribute as
user.trusted.name on the backing filesystem.

Map trusted names to the trusted xattr namespace for set, get, and list
operations. Filter the internal POSIX ACL xattrs.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da3d5c217577..7b2baa317888 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2643,6 +2643,19 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
+static bool ksmbd_is_internal_acl_ea_name(const char *name, size_t name_len)
+{
+	return (name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
+		!strncmp(name, XATTR_NAME_POSIX_ACL_ACCESS, name_len)) ||
+	       (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
+		!strncmp(name, XATTR_NAME_POSIX_ACL_DEFAULT, name_len)) ||
+	       (name_len == sizeof(XATTR_TRUSTED_PREFIX "SGI_ACL_FILE") - 1 &&
+		!strncmp(name, XATTR_TRUSTED_PREFIX "SGI_ACL_FILE", name_len)) ||
+	       (name_len == sizeof(XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT") - 1 &&
+		!strncmp(name, XATTR_TRUSTED_PREFIX "SGI_ACL_DEFAULT",
+			 name_len));
+}
+
 static bool ksmbd_is_security_capability_ea_name(const char *name,
 						 size_t name_len)
 {
@@ -2665,6 +2678,18 @@ static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len)
 	if (ksmbd_is_security_xfstests_ea_name(name, name_len))
 		return true;
 
+	/*
+	 * POSIX ACL xattrs are filesystem-internal ACL records, not
+	 * user-visible EAs.  XFS may also expose trusted.SGI_ACL_* aliases
+	 * through listxattr(), so filter those as well.
+	 */
+	if (ksmbd_is_internal_acl_ea_name(name, name_len))
+		return false;
+
+	if (name_len > XATTR_TRUSTED_PREFIX_LEN &&
+	    !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+		return true;
+
 	return false;
 }
 
@@ -2672,6 +2697,9 @@ static int ksmbd_map_ea_name_to_xattr(bool posix_extensions,
 				      const char *ea_name, size_t ea_name_len,
 				      char *attr_name)
 {
+	if (ksmbd_is_internal_acl_ea_name(ea_name, ea_name_len))
+		return -EINVAL;
+
 	if (posix_extensions &&
 	    ksmbd_is_posix_ea_name(ea_name, ea_name_len)) {
 		if (ea_name_len > XATTR_NAME_MAX)
-- 
2.43.0

