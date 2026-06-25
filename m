Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2284A3E6DCA
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782398493; cv=none; b=itm+XeZoqacCPuHqGSo80HTwFInI1hXGXtB/WsyIhYdKmnTT9OC8kS6WTpr9LYTUWqW7NalYJuI1TrIzPfQhp/af6sMXyUp66LeIfBwbHKFPSalOLIDmVtPW3V/6ZkaMABX0K/3195wTpafLXTR1om5S2MzkK9o6hFO9F7Ui3ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782398493; c=relaxed/simple;
	bh=9YXjCMLXSo33ltYRRRm9Ca2s85quhAo8agLEJ2Y3knw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rNarpOVV1QOhlqHuBnQAZBGfpgEqh6c48ImcU3toi3i6n5q8Xr9kJu+CBN0CWTt/Z6XtSZKrDKwO7Tlgj3I78dSmNgRYZoYU1F6/OcfsiRU4RemtNoZCjYnDDCvsPD317UhfTYLgcv6Y4wRpPjnYZhaF1+x4vKaW0R/wTvjWH5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ea81b81a70a311f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IT, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_GENE_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f7d81874-9ff8-48db-baf0-c129b85c5c89,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:f7d81874-9ff8-48db-baf0-c129b85c5c89,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:0705773ce050a04873417197ebc6025d,BulkI
	D:260625173419LWF974YU,BulkQuantity:3,Recheck:0,SF:10|38|66|78|85|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:
	40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ea81b81a70a311f1aa26b74ffac11d73-20260625
X-User: lihaofeng@kylinos.cn
Received: from workspace-fedora [(139.162.59.143)] by mailgw.kylinos.cn
	(envelope-from <lihaofeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1163104723; Thu, 25 Jun 2026 22:41:14 +0800
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
	samba-technical@lists.samba.org,
	chenxiaosong@chenxiaosong.com,
	Haofeng Li <lihaofeng@kylinos.cn>
Subject: [PATCH v2 0/2] ksmbd: harden DACL/ACE parsing against malformed SDs
Date: Thu, 25 Jun 2026 14:40:19 +0000
Message-ID: <20260625144021.513613-1-lihaofeng@kylinos.cn>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes since v1 [1]:
  - Use goto instead of break in this version
  - Send the two related ksmbd hardening fixes as one series.

[1] https://lore.kernel.org/all/tencent_160379D932900C07E87A916577DA03F73609@qq.com/

Haofeng Li (2):
  ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
  ksmbd: reject undersized DACLs before parsing ACEs

 fs/smb/server/smbacl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--
2.25.1
