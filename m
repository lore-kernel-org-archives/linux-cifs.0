Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F136492C
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782398923; cv=none; b=iB/hUqpguzqA1rDaLWzXxNR2zJerlxXjRT21EphXh7O9mUBLNFTC/+QSFXVh7yVUn4QHkQp7yyUGvh9OVp9hT66otQmX09XIzvmBz3Iyi8yL4TL5L8laGU3jwepzF4n/IamD8+q76wgCsbV/Q9+UaBUP6DNPWLhgx9H6ZakZYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782398923; c=relaxed/simple;
	bh=frJoAekn4K8WN1lavbtbzGT+EIF5gF/B/3M1mmXo020=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIL2zpNEOjk4TXXYxZoW3Z5r0CPqV27N8SFoCU8JFoErmMeUGfEIIhA9nBWtS/AZ/8159YGRL+MZGmPfMTe0acst6/rEhwlrWpIfzQ+PP/mOLQlbWbII5KD6omUx5Yn4h1+ADzYYs1BRtXmlXLsMQtzChdr2JTesg/TBAaf0LbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f224d40c70a411f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fc763ab2-c841-42f1-a7f0-8ac42985259b,IP:5,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:fc763ab2-c841-42f1-a7f0-8ac42985259b,IP:5,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:re
	lease,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:54e686895bd1fdd515811ba40e63d6f0,BulkI
	D:260625180602AIG42LQ7,BulkQuantity:4,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f224d40c70a411f1aa26b74ffac11d73-20260625
X-User: lihaofeng@kylinos.cn
Received: from workspace-fedora [(216.195.204.48)] by mailgw.kylinos.cn
	(envelope-from <lihaofeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1096525333; Thu, 25 Jun 2026 22:48:36 +0800
From: Haofeng Li <lihaofeng@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 resend 2/2] ksmbd: reject undersized DACLs before parsing ACEs
Date: Thu, 25 Jun 2026 14:48:07 +0000
Message-ID: <20260625144807.513701-2-lihaofeng@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625144021.513613-1-lihaofeng@kylinos.cn>
References: <20260625144021.513613-1-lihaofeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dacl() limits the attacker-controlled ACE count by comparing it
with the number of minimal ACEs that fit in the DACL size. The DACL size
field is 16 bits, but the expression subtracts sizeof(struct smb_acl).
Because sizeof() is unsigned, a DACL size smaller than the ACL header
underflows to a large size_t.

A malicious client can reach this with:

SMB2_SET_INFO (InfoType=SMB2_O_INFO_SECURITY)
  -> smb2_set_info_sec()
  -> set_info_sec()
  -> parse_sec_desc()
  -> parse_dacl()
     -> init_acl_state(..., 0xffff)
     -> init_acl_state(..., 0xffff)
     -> kmalloc_objs(..., 0xffff)

Thus a malformed security descriptor can make num_aces pass the guard
and drive large temporary ACL state and pointer-array allocations.

Reject DACLs smaller than struct smb_acl before doing the subtraction,
so the ACE count check cannot be bypassed by the underflow.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 693a550fbe34..b135133c2609 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -374,6 +374,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 {
 	int i, ret;
 	u16 num_aces = 0;
+	u16 dacl_size;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -403,7 +404,11 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+	dacl_size = le16_to_cpu(pdacl->size);
+	if (dacl_size < sizeof(struct smb_acl))
+		return;
+
+	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
 			(offsetof(struct smb_ace, sid) +
 			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
-- 
2.25.1

