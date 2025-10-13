Received: from out30-70.freemail.mail.aliyun.com (out30-70.freemail.mail.aliyun.com [115.124.30.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816B19E97F;
	Mon, 13 Oct 2025 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760380780; cv=none; b=lQpo5CGQ6Kh8fQpdwNR9gVlx0aIY/L3K4qqIhntG8ASEILP0gQ3XSbRCXaj493s8xxBMUGxm789evDmWj2JoIThMDBSdwFNYIvxDTqjC4z+9VZX7uJK5QKKNKemagm7v2BtpxQRQn4NOMlbk7div8TF00XqbAXbpnHzCB35rJ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760380780; c=relaxed/simple;
	bh=XI6DVdLntb6R4qoOaS2upp4XWyIXX5rNJx3CTEhQFGw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=j8LJMlTwosMFpwHYiKaVU9Ghpsyjo5+Nhq8WO7PBmA1fht8e6Ycgvjpx23wWDmBIDRgJ2To1CA3Yh9HseHQzhUxmmi1rmFcZYaZ7jwWcDtWa/RFUI94rii4QvHgCjaDB7Hqgh3Z8SxVP14LT/V167vWfqz2wrqG4te93Z6fPjkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=NTzBdXrk; arc=none smtp.client-ip=115.124.30.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="NTzBdXrk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1760380775; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=hJT3+5P8A7+gC+ICBcdEHgIa1WBr64RUEoIO9RCBP90=;
	b=NTzBdXrk6mjnpV2kOFc9YxB8CQNFBEB83a+BhXMfF/j4wDRuHmXGJfBlSPTxFhyjxHasVzSufFyGWded8MeGfZ1O5UnIk23lwAtrm+IkfwP5ijSUCaXHY4xC/wGAq7J5+BPK1jAE/zXEdOMdL6uvVr5z0hKolCERjCdMtuEJCWE=
Received: from aliyun.com(mailfrom:ekorenevsky@aliyun.com fp:SMTPD_---0Wq8mI-M_1760380772 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 02:39:34 +0800
Date: Mon, 13 Oct 2025 21:39:30 +0300
From: Eugene Korenevsky <ekorenevsky@aliyun.com>
To: linux-cifs@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: parse_dfs_referrals: prevent oob on malformed input
Message-ID: <aO1HYr97mEwWZWkB@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Malicious SMB server can send invalid reply to FSCTL_DFS_GET_REFERRALS

- reply smaller than sizeof(struct get_dfs_referral_rsp)
- reply with number of referrals smaller than NumberOfReferrals in the
header

Processing of such replies will cause oob.

Return -EINVAL error on such replies to prevent oob-s.

Signed-off-by: Eugene Korenevsky <ekorenevsky@aliyun.com>
---
 fs/smb/client/misc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dda6dece802a..987f0ca73123 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -916,6 +916,14 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
 
+	if (rsp_size < sizeof(*rsp)) {
+		cifs_dbg(VFS | ONCE,
+			 "%s: header is malformed (size is %u, must be %lu)\n",
+			 __func__, rsp_size, sizeof(*rsp));
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
 	*num_of_nodes = le16_to_cpu(rsp->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
@@ -925,6 +933,15 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		goto parse_DFS_referrals_exit;
 	}
 
+	if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) {
+		cifs_dbg(VFS | ONCE,
+			 "%s: malformed buffer (size is %u, must be at least %lu)\n",
+			 __func__, rsp_size,
+			 sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3));
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
 	ref = (struct dfs_referral_level_3 *) &(rsp->referrals);
 	if (ref->VersionNumber != cpu_to_le16(3)) {
 		cifs_dbg(VFS, "Referrals of V%d version are not supported, should be V3\n",
-- 
2.47.3

