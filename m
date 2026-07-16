Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83C273D8D;
	Thu, 16 Jul 2026 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784179543; cv=none; b=pAi+LceAr3XXuHgJUZ7sTqhuDVJvByX01Bjm1JVmUB9i/BJQxoOC1dwnyM61N0BKFuSEjZaoI3b6txcUyAx8dHggk/J6o/v3uelVqw5EzNeUPPYezUMSouHEHmjU1LogxNMhJJ7+EYC6jqvwrzxWNRMM0FC1xmNL6xjcAbjDpLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784179543; c=relaxed/simple;
	bh=Eg4rs88Pvs97dZrxC8Uhs2lELhman4wIA8YuP3rvSLE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hq4qEeyiQCvigrKFWyP+tjLvzaIM2MsFmHCX0mjrFt+i34YzngVJ6MsZUfGI5TwUjl+77MJYRR1TKR5F6Y18+fLfFDdA7Q6a9kXqAElcFEO1ZbeDcfuhzaACun+DTWTapzFRB20DsngyPPyPYG96gy1l2I8wUFCKTUHl8QEaSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CikEi481; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CikEi481"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784179532;
	bh=aPD9rbRNLvaQykrfBzm9byOJM2AMPbtidS7K12itR/U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CikEi481yjfvdGuFvVBcJQgXEZSn/mAcSn41xbLa6swThqpKZfQM49DDtGc12mxwc
	 NQ97yxMzER7gUpXEsf0qkJFZOD+AuHoH44XriJDcvJSrAl5TLKLWpSJERliL6h38mA
	 hY5WYf/ZJ+dlt44YnfymjgHrX/a+AtVH1KO3z1xs=
X-QQ-mid: esmtpsz20t1784179527td28ff0b5
X-QQ-Originating-IP: mQL1zNIW6T2XEH3+cBUN1vvkt5rd14wZIBMz7g2v3Lw=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 16 Jul 2026 13:25:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16989616786992538532
EX-QQ-RecipientCnt: 13
From: Yichong Chen <chenyichong@uniontech.com>
To: Steve French <sfrench@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v3] smb: client: validate DFS referral PathConsumed
Date: Thu, 16 Jul 2026 13:25:23 +0800
Message-Id: <20260716052523.1159415-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NjLCcymN2JBy85Ke+e5H9OIpE1CY3E3rknVG22g0bUUL4Ft63MER0Nfi
	vRdPhQzRfDkzxAkH18jvdSN8AtrKLnqoi3aZwbQyvg+Zv3amES5VN0P4Z5BySxHPZpK0eyq
	u9tU8CfECUChHHW1PPBWazc6C4Go+XOcKOzijPQqEsM9QpJzVbKoIIwPhfrgkTNcbDkiQXS
	2rXTgv4fBPIxl1zntAqFD016FiudvHbWFiwCdNjW3X12YL8xGIZO9cIFmSJSoiOoBtk7Xjr
	7a3bq0ARBGMMpAewt3Yjudpn9gvBZLBByF+X7/hB7labM9ckSc9h9W4eMLCuIJNlJgkEDvc
	GhQ6exf77JY+A8uBBBOMkTygB1AkCGitKqS+wSjkkHfUYLZSNAUkYB64ZhdopFCZdn/FfI0
	5DOJLE+ece2zswTcgKspM5QYSd3ogpSvOpr8DHZcZBB+EUHBISrxB1Y2OHO7WRxGygvr9da
	ozG1P16qplIvMoJb75x70nVDOHayQS5HqofV2ps7fX33NqItworixpg9ER9EpSeRC0NQ724
	pqdWow+be1puN5X+M01439MhtVDI0y6yS8efqjBDSmP+EDfRO/lknpEJhuN8kH0Lr8cJvQy
	A5kGST+FaqfSdcB/OVWxCi+Rd6ue1+fzREu41RfAYCB2NbEPG5cMiKKYxfGy22nlmYI/2TY
	n9E+Vu04w8gD5PpROic7+mDR3AIeyuebhaARuAlAI/UUxKc6yVxcjOL/luNLynKwXfE9OE0
	6ysLtf+GdAA92L7FlVkTIxRd6apBMXKDtO95/h8j60aJPlaPRpFTF8s/j3qBCyetMUchdCP
	vJfGK/2KLNNNODa54sC1NkMhkoaUZ0OUAyzCnl2YJFilNSMOnieiyemeaPM1hrwzjmiWUYQ
	GTNy6kZZGaIo20LThceCuwBewPiiLjRSOhDsvQbRJZLPYggJHtMdg3/aAMBEmIg9c/vgXYI
	DEkLut0aMOSuV/aOQzm1Nomu7La3Ujfkw63pG+JRY4lMW9W6bfH1S5HTlMw4+UTdjnhbAzn
	qmbx4AZJsWaCZ+IQqLMshsTR7/3Pe3UmhifofFUw==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

parse_dfs_referrals() validates that the response contains the fixed
referral entry array and, on for-next, the per-referral string offsets.
However, the response also contains a PathConsumed value that is later
used for DFS path parsing.

If a malformed response provides a PathConsumed value larger than the
search name, later DFS parsing can advance beyond the end of the path.

Validate PathConsumed against the search name length before storing it in
the parsed referral.

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
Base:
- Tree: git://git.samba.org/sfrench/cifs-2.6.git
- Branch: for-next
- Commit: d7d2adcd022b ("smb/client: flush dirty data before punching a hole")

Changes in v3:
- Rebase on cifs-2.6.git for-next.
- Keep the string offset checks already present in for-next and only add
  the remaining PathConsumed validation.
- Rename the subject to describe the remaining PathConsumed fix.

Changes in v2:
- Validate non-Unicode PathConsumed against strlen(searchName), as pointed
  out by Sashiko and Steve.

Changes in v1:
- Validate DFS referral string offsets and Unicode PathConsumed.

 fs/smb/client/misc.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index e4bac2a0b85d..b9c59b2cf76a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -682,6 +682,8 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	int i, rc = 0;
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
+	unsigned int path_consumed;
+	size_t search_name_len;
 
 	if (rsp_size < sizeof(*rsp)) {
 		cifs_dbg(VFS | ONCE,
@@ -728,6 +730,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
+	search_name_len = strlen(searchName);
 
 	/* collect necessary data from referrals */
 	for (i = 0; i < *num_of_nodes; i++) {
@@ -736,21 +739,34 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		struct dfs_info3_param *node = (*target_nodes)+i;
 
 		node->flags = le32_to_cpu(rsp->DFSFlags);
+		path_consumed = le16_to_cpu(rsp->PathConsumed);
 		if (is_unicode) {
-			__le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
-						GFP_KERNEL);
-			if (tmp == NULL) {
+			size_t search_name_utf16_len = search_name_len * 2 + 2;
+			__le16 *tmp;
+
+			if (path_consumed > search_name_utf16_len) {
+				rc = -EINVAL;
+				goto parse_DFS_referrals_exit;
+			}
+
+			tmp = kmalloc(search_name_utf16_len, GFP_KERNEL);
+			if (!tmp) {
 				rc = -ENOMEM;
 				goto parse_DFS_referrals_exit;
 			}
-			cifsConvertToUTF16((__le16 *) tmp, searchName,
+			cifsConvertToUTF16((__le16 *)tmp, searchName,
 					   PATH_MAX, nls_codepage, remap);
-			node->path_consumed = cifs_utf16_bytes(tmp,
-					le16_to_cpu(rsp->PathConsumed),
-					nls_codepage);
+			node->path_consumed = cifs_utf16_bytes(tmp, path_consumed,
+							       nls_codepage);
 			kfree(tmp);
-		} else
-			node->path_consumed = le16_to_cpu(rsp->PathConsumed);
+		} else {
+			if (path_consumed > search_name_len) {
+				rc = -EINVAL;
+				goto parse_DFS_referrals_exit;
+			}
+
+			node->path_consumed = path_consumed;
+		}
 
 		node->server_type = le16_to_cpu(ref->ServerType);
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
-- 
2.51.0

