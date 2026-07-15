Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1D3D9548
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105821; cv=none; b=UwkJ1oLjBpiSVDSyuC9V2lxMSMxH/TZhPh7rB6Qu1cpXbRD0EZnX9Kn9AaPz/O8aRFYlUTFr24J7HGmxIBk73XriE8W9m3APDlDnNiSyeJ/LQFjXtqKlOTtp8jkEIbrNjFN0zNtcF8n8GTmM9e+C1ru6387fvJaPUbb1nvdETx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105821; c=relaxed/simple;
	bh=herC1JR+1OIaFj4SZ6r+g/uw9EKF52Ycl0C4tswFzdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MMXUlhKk+8P1opzSgP1kJ6HJMIOzN9xgMSpu14HWHPyKJZrGIBqIvAg/DCh3OOorVC3uiX0HExkyjHOs5y3GNPEXW3Tza7qWUpU1ZvuUB8bFdiRxhXwd6I8mW5uNh4JOdlOIx/BukvmInjdqr9LYbiXoEEpxdbGKRlkqt97ug+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=F9dFXZeB; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="F9dFXZeB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784105666;
	bh=TTnyldGWSibnHxV29c8TSmMDt9bw7jVpq7zj38Ch8TI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=F9dFXZeB5iPoFuSxq6CKbanYOQICfVRUOfv7CstPYyu7KuUzy52TFgANU8Cj0TNIn
	 fAdvfmv1fQyRC0AsSbawJnyWf9gEqPbgH9XFBDHPhLPF9z8Jd+J50eW2BjLVm46EA0
	 tjQvhoAxnHgjKghi/k/MVIYidvT5XZmbW7wtxCf8=
X-QQ-mid: esmtpgz13t1784105659t52b38a68
X-QQ-Originating-IP: 5a+leSHTGtzLtw45jE+ZvxRVCZOI0Ql5w8e4XAdMahQ=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 15 Jul 2026 16:54:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10317123681680029359
EX-QQ-RecipientCnt: 12
From: Yichong Chen <chenyichong@uniontech.com>
To: Steve French <sfrench@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eugene Korenevsky <ekorenevsky@aliyun.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH v2] smb: client: validate DFS referral offsets
Date: Wed, 15 Jul 2026 16:54:16 +0800
Message-Id: <20260715085416.1112469-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Nn+88S7+9wlcsAe/WLNrPtGGnFelAnlqy1/oHZd5KuU0jVQzFaORRtRy
	eyox//ouplXQh6GIkMfs3+whLVh/T+812V3VrGm+a5z1EnvXk3n1opRFiJWAYQHKeb0RyF/
	/KlDnTELetjroC+DlNdn0bLxjWIFx+Dkk7NfxnT3N5R18NkVuR1QaFIhlNkdtz07utC+Obu
	ZzG/Dp2vO6FyuiF/QS5pfH1VR/saIsXgkXnfb2m//32jYCrV8Gz8Yl/NlqJHX9GIDer/JQN
	EzSXBbu8zccJdVrJ9krLuekbVQk48l5dPQNQ8m3W3mzKaqpSbu8Y6eydzKh9ROuem93BZlF
	Wr0XVbmXtWbUdksCrNqEe2bIXKKU4V0Csp2AbXg3GfjjabA0afBB5FLhqzAcl4I1aPBbBTl
	udeey7YQDT9lKyjqgdQu33mZaA5+J3QG1sLCKgbGq9V6fo2iT5INH5IX0NzqjKLyL49C1GL
	rHK7KDfQ9hU6T+Mzq1ByHnoabzAz9QaBlDqYNrAYa+Q3thrQzk0rsGGeE+HVty0dK5pUPpf
	JbuqCr+3qg2iMQYv3tF06NPEGlf1xOVnlWUgYxoaf1BetL3v2FXbxLQtmgNXSON5GmaKrOE
	lYhNdad3ekiXGnaY4c32B3YeysSW0HsZEnjtIJ6MREDnTDdeEBpGPUCW/4lwXkkwFX47SPZ
	B7gWFY1ImsKUSvFK7O06xQh8+dnd84iaWuBfWBQTNUHKmv8pb7Ka/Luuf4IqHBlklv/XNFw
	o5IWmSS8mFRKurhqtZl+9O7ECq5Y+fHaQGKCfucZKWC9HVRWEOhYoNu3uHRIcCAeqpoQiSu
	HxI8nNcAJj83/0+qKOwmKgyTasE+fD2cvuJXZc5K06ETCHitxFn5C/kPcKpxjfcJ3HzcYtA
	V48h7CJzF/KkY8ZQcoD/bRnMRD9UKHA/CkyP8ewgH9ITqR9HPey2ry1NHZ+jIanUv49Yk48
	+CjqwNe4yR7MQ3eif6EMu2QUPnpYXEHIBymuDfpPBLH3dS2jLaG96tFGdo4jB5X8x0ncpjO
	trgUtUdVT9SGqlicXk2ixB6jnZors6KSArF4O12oAfdlzLNzpN4i6NiGx29kQ=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

parse_dfs_referrals() validates that the response contains the fixed
referral entry array, but it still trusts offsets stored inside each
referral entry.

A malformed server response can set DfsPathOffset or NetworkAddressOffset
past the end of the received buffer.  The resulting pointer is then used
to derive a remaining length and passed to cifs_strndup_from_utf16().

The response also contains a PathConsumed value that is later used for DFS
path parsing.  If it is larger than the search name, the parser can
advance beyond the end of the path.

Validate the per-referral offsets before using them, and reject
PathConsumed values that exceed the search name length.

Fixes: 6447b0e35556 ("cifs: parse_dfs_referrals: prevent oob on malformed input")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
Changes in v2:
- Validate non-Unicode PathConsumed against strlen(searchName), as pointed
  out by Sashiko and Steve.

 fs/smb/client/misc.c | 99 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 0c54b9b79a2c..9d84cc718557 100644
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
@@ -687,85 +692,117 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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
+			if (path_consumed > search_name_len) {
+				rc = -EINVAL;
+				goto parse_DFS_referrals_exit;
+			}
+
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
