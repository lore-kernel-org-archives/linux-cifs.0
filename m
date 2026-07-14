Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CADD43E48A;
	Tue, 14 Jul 2026 09:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784021383; cv=none; b=XsehWi0ZyMe9Jg0Qzzk1LJDu+MfQL6kNF95HHGhOPCHSZttCQiMSEXn4/a1FHRJ//eXSxxfYOGD0+vscLm7mUV+O9Z91NJYtIAOMGLjZrywVR97OFZpuNjcRnrxZjTEiIVGZZaED0cFNrqRjo4GxnKIMTFFY+TgeEwCRQ0TkyZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784021383; c=relaxed/simple;
	bh=cCDY3akBv7/501LYZZGqSoRvzSr5eMZfStF5vZk58R4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZKazio2fM3+QmZHt596CqGQrQ0D8BNvoH1Bhn/TlCZCvNsCCshbjts5LlHObwq2hhjkQdTRgWT07KFTe3nGPaUKHIAWXCj978/8ppJulVFSdS3rQdAjPNq7H6UAqWgzPOzuzUzZnKY6oitX1VpyHItBnJiKFcZ3j7LNkX9ZLn00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=LVpLLynt; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="LVpLLynt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784021195;
	bh=IAa6Kqy15zp25vlqCr0XB7iKjOAzuVDj52r/pNe20qQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=LVpLLyntXd3QBx/9gJeAVII1Am0aDWGgApkS72vFLIofANuRhDQAfIuGvVpzf3O24
	 8wXFW5MpgoTl9EG+FTLI92b8QZ8d5sdwocftMUrcaYz97rnQpc0RzOw/iMJNMsfbPR
	 XoX4sCNG+QZM3SbFGcs8f2W7dX7CNUxThttyRnHo=
X-QQ-mid: zesmtpsz3t1784021176t79a314c2
X-QQ-Originating-IP: t0naW89qkMbvML/n66hLkJdv1DXkqG3bIILJjZO5XP4=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 14 Jul 2026 17:26:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1337859893869426288
EX-QQ-RecipientCnt: 11
From: Yichong Chen <chenyichong@uniontech.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eugene Korenevsky <ekorenevsky@aliyun.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] smb: client: validate DFS referral offsets
Date: Tue, 14 Jul 2026 17:26:07 +0800
Message-Id: <20260714092607.1057963-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OO87pPbfd04f6g8/MAEhSPtYYhPFKGFsqJUcVECPTVDRnRPNmtIApkPI
	VtRL/Ha54I1whRG4PgQ4jSEzkU/6pTsd/BrxUQOLJhM4rB02RbClA87dVGpAK58eM4il6Z9
	4v3s7CjbWmcWsY0l1K/JSLLIKbIqFtrAKXEHFxx9os3GJ+twt4NRiQ1T0BFHRIdFsah3+St
	eC7okPGUrYP+a669Pjd0P170dxP/1xhP4kkCPyig5sl5JZzT1b1zrg9PhrgghEDEvlwbZCl
	1rYM7PbgrLpagYz8lnwKfZWtGaII2pW+de+XPCC4DHBv/sEEWYijmlJr/qaE5NB69s8oxdC
	fOMYsPYld00w5dURhbQhp502l27AEd0AkSYMzUCYfK3lMhxTUodVUaMDgJcIWR4it+m29oc
	7EHgaeZZhfayNfmawdJK3SUO2826Z1DId6gyk2uVCPxrKiO/reyuUTNXzMm/31MngVLRdTI
	5ZJhMvAvWPjKhmuUO/WScZAoF420HTxqqvSyQhu1t9h3nPt86ycEe8cn2C9YZY+88Wvy7Do
	wegN671yxw5CYM1iLbtzPYByerXEOkka+FVvQvQ5hXQTG+Co5zqqaKgtOw51lumkZXVirrF
	tI3Vacie4fm/rvz3lwM9Yk5E4cRnZDxSBLNLUGa6fWq9RkdBxTQmbbFRlLwPcR2tlJq8ZUD
	eVRNBNCTZy8qSpwFiqHXhgMbQkJmiEZm09GHy1jOFmQ8+CpgQJSdFYycoi+8e/6qHJMlolC
	sh4iq94CPhB8Ha0Cq5QX4SkZgfTTUdGUtJcTtjkYWWgiWnIK/ebKZ7vJcXPS4VQ0P/ZgFvV
	IZT17CFKf7bNmD+Jq744LWwYt6wPnWiJpcbly9wY43oBLUiqrAQPyyk+rPUCFhwZcZNAn98
	eaDzPmOTPbEFYVu7T/LIb+3qC9q/OnV9FpH+HqEDMAjRGmLBoE39VBQGBBEYfwHAhnx5arX
	V9+xcWQDwaXsXQp/CwEHyPeu7/9pqlHkYwDxZAXaYoA4a/zfG5v0UibSPXtEJp2jfaruT53
	vNtFRugrc3ef6aG5PiqWmLmgErhkg=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

parse_dfs_referrals() checks that the response contains the fixed
referral entries, but it still trusts offsets stored inside each referral.
A malformed server response can set DfsPathOffset or NetworkAddressOffset
past the end of the received buffer.  The resulting pointer is then used
to derive a remaining length and passed to cifs_strndup_from_utf16().

Validate the per-referral offsets before using them.  Also validate the
Unicode PathConsumed value against the converted search name length before
passing it to cifs_utf16_bytes(), and only publish the parsed referral
array to the caller after the number of referrals has been validated.

Fixes: 6447b0e35556 ("cifs: parse_dfs_referrals: prevent oob on malformed input")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/smb/client/misc.c | 94 +++++++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 0c54b9b..73676d2 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -678,6 +678,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	int i, rc = 0;
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
+	unsigned int num_refs, path_consumed;
+	size_t search_name_len;
+
+	*target_nodes = NULL;
+	*num_of_nodes = 0;
 
 	if (rsp_size < sizeof(*rsp)) {
 		cifs_dbg(VFS | ONCE,
@@ -687,85 +692,112 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		goto parse_DFS_referrals_exit;
 	}
 
-	*num_of_nodes = le16_to_cpu(rsp->NumberOfReferrals);
+	num_refs = le16_to_cpu(rsp->NumberOfReferrals);
 
-	if (*num_of_nodes < 1) {
+	if (num_refs < 1) {
 		cifs_dbg(VFS | ONCE, "%s: [path=%s] num_referrals must be at least > 0, but we got %d\n",
-			 __func__, searchName, *num_of_nodes);
+			 __func__, searchName, num_refs);
 		rc = -ENOENT;
 		goto parse_DFS_referrals_exit;
 	}
 
-	if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) {
+	if (sizeof(*rsp) + num_refs * sizeof(REFERRAL3) > rsp_size) {
 		cifs_dbg(VFS | ONCE,
 			 "%s: malformed buffer (size is %u, must be at least %zu)\n",
 			 __func__, rsp_size,
-			 sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3));
+			 sizeof(*rsp) + num_refs * sizeof(REFERRAL3));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
 
 	ref = (struct dfs_referral_level_3 *) &(rsp->referrals);
-	if (ref->VersionNumber != cpu_to_le16(3)) {
-		cifs_dbg(VFS, "Referrals of V%d version are not supported, should be V3\n",
-			 le16_to_cpu(ref->VersionNumber));
-		rc = -EINVAL;
-		goto parse_DFS_referrals_exit;
-	}
 
 	/* get the upper boundary of the resp buffer */
 	data_end = (char *)rsp + rsp_size;
 
 	cifs_dbg(FYI, "num_referrals: %d dfs flags: 0x%x ...\n",
-		 *num_of_nodes, le32_to_cpu(rsp->DFSFlags));
+		 num_refs, le32_to_cpu(rsp->DFSFlags));
 
-	*target_nodes = kzalloc_objs(struct dfs_info3_param, *num_of_nodes);
-	if (*target_nodes == NULL) {
+	*target_nodes = kzalloc_objs(struct dfs_info3_param, num_refs);
+	if (!*target_nodes) {
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
+	*num_of_nodes = num_refs;
+	search_name_len = strlen(searchName);
 
 	/* collect necessary data from referrals */
-	for (i = 0; i < *num_of_nodes; i++) {
+	for (i = 0; i < num_refs; i++) {
 		char *temp;
 		int max_len;
-		struct dfs_info3_param *node = (*target_nodes)+i;
+		unsigned int offset, remaining;
+		struct dfs_info3_param *node = (*target_nodes) + i;
+
+		if (ref->VersionNumber != cpu_to_le16(3)) {
+			cifs_dbg(VFS,
+				 "Referrals of V%d version are not supported, should be V3\n",
+				 le16_to_cpu(ref->VersionNumber));
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 
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
+			node->path_consumed = path_consumed;
+		}
 
 		node->server_type = le16_to_cpu(ref->ServerType);
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
+		remaining = data_end - (char *)ref;
+
 		/* copy DfsPath */
-		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
-		max_len = data_end - temp;
+		offset = le16_to_cpu(ref->DfsPathOffset);
+		if (offset > remaining) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
+		temp = (char *)ref + offset;
+		max_len = remaining - offset;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
-						is_unicode, nls_codepage);
+							  is_unicode,
+							  nls_codepage);
 		if (!node->path_name) {
 			rc = -ENOMEM;
 			goto parse_DFS_referrals_exit;
 		}
 
 		/* copy link target UNC */
-		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
-		max_len = data_end - temp;
+		offset = le16_to_cpu(ref->NetworkAddressOffset);
+		if (offset > remaining) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
+		temp = (char *)ref + offset;
+		max_len = remaining - offset;
 		node->node_name = cifs_strndup_from_utf16(temp, max_len,
-						is_unicode, nls_codepage);
+							  is_unicode,
+							  nls_codepage);
 		if (!node->node_name) {
 			rc = -ENOMEM;
 			goto parse_DFS_referrals_exit;
-- 
2.51.0
