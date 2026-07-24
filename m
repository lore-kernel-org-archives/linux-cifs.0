Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CEF342538
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889684; cv=none; b=B0JCUYH5mPgDZJvAzcVUgFVhzELJCOK9whzpfOJ1Ey7XXMrKZFsLpeeI0mEnwpWFZt4abmvG1UQAkPBurb1amCN4NLbjhKt1n0iSjZ2OIx/KBeq658uzCU3U10pNNYjYN+XXzDKYMHY2BP6MtF1R0GjVS/W+AM1h9dWKMtJ0G0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889684; c=relaxed/simple;
	bh=7nbUL9zqoPzEP8gnpCVWQeWu9dHdaRdl/tz0CUVUgeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRm//8Mxai6jD6O9qJMyLXQmYv5mNe5askQ9zIkH+l/MbBzv2KBir6SOO3w5buQcjA/EgkxweX95760+MR/f1SeeODczZGCpnLJK51VSd11EFBEsEIPbaVn3iGPCFZtDjfdQ7VdRCVBiFmIYwAiaZjIC8viROHGv39rHJPhcTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 32a962dc874c11f1aa26b74ffac11d73-20260724
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
X-CID-O-INFO: VERSION:1.3.12,REQID:7d1eca15-8b42-43da-ad7c-6f7709360439,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:7d1eca15-8b42-43da-ad7c-6f7709360439,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:61b05ecfd9a4c3f88fca63f03696c3af,BulkI
	D:260724184118GNA9U1IQ,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32a962dc874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1403921068; Fri, 24 Jul 2026 18:41:16 +0800
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
Subject: [PATCH 09/15] ksmbd: support security.xfstests on POSIX EA handles
Date: Fri, 24 Jul 2026 18:40:03 +0800
Message-ID: <6b25ed84002643c3e324f76da8da018f7ad20144.1784888897.git.tanze@kylinos.cn>
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

Add security.xfstests to the exact native xattr allowlist. It uses the
same per-open POSIX activation, root or admin authorization, collision
handling, and list filtering as security.capability.

With the matching POSIX client support applied, the mapping can be
checked with CIFS_MNT set on the client and SHARE_ROOT set on the
server:

  $ file="$CIFS_MNT/security-xfstests"
  $ touch "$file"
  $ setfattr -n security.xfstests -v attr "$file"
  $ test "$(getfattr --only-values -n security.xfstests "$file")" = attr

On the server:

  $ file="$SHARE_ROOT/security-xfstests"
  $ test "$(getfattr --only-values -n security.xfstests "$file")" = attr

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6baeac99b12f..dba97df7b29f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2645,6 +2645,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 
 static const char * const ksmbd_native_xattr_names[] = {
 	XATTR_NAME_CAPS,
+	XATTR_SECURITY_PREFIX "xfstests",
 };
 
 static bool ksmbd_native_xattrs_allowed(struct ksmbd_work *work)
-- 
2.43.0

