Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748EB219E8
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 00:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782435180; cv=none; b=JaGxb9pkowA41Ns+rkJSCYpOBahD8BaoLF6H9rrpNgenYgfPL8iy5KQ91j9gxB14wHyU3RYs3kL0jISyo52fSnDd7Fq6d6RR0KQE6tD6phEldM/DE/3w22131FO6Awv16Z+igc6To5buhMlK4ZjCHirOOVq/V87Glv/irirxeoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782435180; c=relaxed/simple;
	bh=8tg6y+X8NVm6inppC7TkfCSZ8/ND25Khpw+71PNAXSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EcMBrerQL7h8/13jq6rSgUwMbhoylaXhp+iuTf6VcobagXJlgkQ8wy7hL7dJ78JQbY3UyMAWgtBI9fZXYDEimZx95/bsS9wVGtjNq9KjjOwbp0zZOgCGcpurbZJ0kWPMmlMwvdf/X2DQBLDCxhkR6YwnqKo4vgnJmcEUPteZaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5c6979e070f911f1aa26b74ffac11d73-20260626
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:20483105-5980-462d-94fe-7bcb1f409fbe,IP:5,U
	RL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:20483105-5980-462d-94fe-7bcb1f409fbe,IP:5,URL
	:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:3e3538ca53c71e81ce3743315d6ef9cf,BulkI
	D:260626085253M1NTGV0W,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5c6979e070f911f1aa26b74ffac11d73-20260626
X-User: lihaofeng@kylinos.cn
Received: from workspace-fedora [(216.195.204.48)] by mailgw.kylinos.cn
	(envelope-from <lihaofeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1190606433; Fri, 26 Jun 2026 08:52:52 +0800
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
	Haofeng Li <lihaofeng@kylinos.cn>
Subject: [PATCH v3 0/1] ksmbd: harden DACL/ACE parsing against malformed SDs
Date: Fri, 26 Jun 2026 00:52:16 +0000
Message-ID: <20260626005217.524940-1-lihaofeng@kylinos.cn>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2: move `num_aces++` to before `next_ace` label.

The following patches from v2 have already been merged into ksmbd.git ksmbd-for-next-next:
  - ksmbd: reject undersized DACLs before parsing ACEs

v2: https://lore.kernel.org/linux-cifs/20260625144021.513613-1-lihaofeng@kylinos.cn/

Two ksmbd paths trusted attacker-controlled fields from a stored security
descriptor and lacked the validation their sibling functions already
enforce. Both are reachable by an authenticated client via SMB2_SET_INFO /
SMB2_QUERY_INFO and both are fixed by adding the same gate the surrounding
code uses. The patches are independent and can be applied in either order

Patch 1 rejects DACLs smaller than struct smb_acl before a size subtraction
that underflows (sizeof() is unsigned), which otherwise let a malformed SD
bypass the ACE-count guard and drive oversized allocations.

Patch 2 validates sid.num_subauth in set_ntacl_dacl() before copying each
ACE verbatim into the response DACL, the lone path missing the check that
parse_dacl(), parse_sid() and smb_copy_sid() already perform. A crafted
num_subauth otherwise drove an out-of-bounds heap read in
set_posix_acl_entries_dacl().

Haofeng Li (1):
  ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl

 fs/smb/server/smbacl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.54.0

