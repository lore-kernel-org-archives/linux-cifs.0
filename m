Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362D342376B
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889684; cv=none; b=OD1ZkxCPYPHKfeeh1C6kJ/6GblReriCF8lk6runccipxfAT8/m4DmoSvGY6HDXbqO6dxHfWfGLY9vHLjp+ZuE6BnvqYJgfZbNr+Pq+DwOgV2LSyJExHd8dzuPt/Kh5+LmBSVWnCZev6Qi6FRPLpnd/uIaQ4KCFcXQ7/9m9pI0x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889684; c=relaxed/simple;
	bh=EbBNTAQ7xt9uLiUdtYNratdRpkrcNEwmqomkcEl6zdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3l7Mxv6YAJvh7UvlRHisyjnF9rQnM82Vt3z2fzIxo8TMV/KfppCwTwUKtOs/vuKsLIdcB1toXaDOYWi4eua5wAZA6lYQ8Vo0y3VmDUxgdb6hnXyw+qd1dUcJBTGUoM3Dh7Sb6FV8QNt06hDB4ZEf87fGkSwdmDpezKiCse5FRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 30ef5014874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:e10262ad-52e1-4a86-8bc0-d2652be7d325,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:e10262ad-52e1-4a86-8bc0-d2652be7d325,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c9425c395a84a9f241f75eb93365c062,BulkI
	D:2607241841155ZVSFUJC,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 30ef5014874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1480272632; Fri, 24 Jul 2026 18:41:13 +0800
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
Subject: [PATCH 04/15] ksmbd: handle empty and disappearing EAs
Date: Fri, 24 Jul 2026 18:39:58 +0800
Message-ID: <6965627419a93f2ed0d9f14b437a136ebbcdfd9c.1784888897.git.tanze@kylinos.cn>
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

A zero-length xattr value is valid, but smb2_get_ea() currently treats
every non-positive result from ksmbd_vfs_getxattr() as a missing EA.
Accept zero and encode an empty value in the response.

An xattr can also disappear between listxattr() and getxattr(). Skip an
entry that returns -ENODATA without consuming response space, while
preserving other errors.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2131625dbc2d..39a72cda6704 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5245,24 +5245,26 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 			continue;
 
 		ptr = eainfo->name + name_len + 1;
-		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
-				name_len + 1);
-		/* bailout if xattr can't fit in buf_free_len */
 		value_len = ksmbd_vfs_getxattr(idmap, path->dentry,
 					       name, &buf);
-		if (value_len <= 0) {
-			rc = -ENOENT;
+		if (value_len == -ENODATA)
+			continue;
+		if (value_len < 0) {
+			rc = value_len;
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
 			goto out;
 		}
 
+		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
+				name_len + 1);
 		buf_free_len -= value_len;
 		if (buf_free_len < 0) {
 			kfree(buf);
 			break;
 		}
 
-		memcpy(ptr, buf, value_len);
+		if (value_len)
+			memcpy(ptr, buf, value_len);
 		kfree(buf);
 
 		ptr += value_len;
-- 
2.43.0

