Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C826D21CC55;
	Tue, 14 Oct 2025 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760466810; cv=none; b=r4v2WSoC8054OluRE2slYbUejPKotwg1RSX3quDW/s+RWXnJFuAKnixQ5Iij0xbWJkD2aBqROnjtGpWgvzYFIpuhFO3qiVpNYHGMw1PsyUV1wT83KkFyu1bJkkn1kyTeerYFrQHROGXjzaLPVcB7Gwk56PD3EuW83ebHLCvFujE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760466810; c=relaxed/simple;
	bh=gc2IwG9tmS2hKkPI8UqDHKu2rWpkYqhLBY0pYc2U35A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JXWB+901C52P6Rk6mmCbouJyq7QxCMg+fklnHBpOZzfqWVcZ7oZd+jt6XdnbHPZ2uL/uVH3CWS58XquPR9QO1euWqI3/n9ZyE7Dm9NSFtOV86CKNtGZ8ANjcihvLRljA1TwxI8XhgPQ+bGUVg7b7nwdg0bmLwDmL3/A//CG9CiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msiXROmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msiXROmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50751C4CEE7;
	Tue, 14 Oct 2025 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760466810;
	bh=gc2IwG9tmS2hKkPI8UqDHKu2rWpkYqhLBY0pYc2U35A=;
	h=From:Date:Subject:To:Cc:From;
	b=msiXROmAxVufeVB7FI18NDkDlJrhv2g01nkypl+p+2bcEEC8Tx3coCc7xe5Pfq+WL
	 hweHBL+G48HhdY4FcukbKBVcSRQ6oXSpyMxhZcw8fGuQ3H62SNoVRnLPRWMrO2FYqK
	 k4tmjNPjmUdlWwN5QmQ36UVsx+n02C+LghgGZZi7wBD5c/erHSl5+gBj218iGLVIhy
	 tUlmi5+LEokk5YFSjiNz0qnnEDcQKkf3qQZOLcdGslicIFXtpdt8GKRnRgj/tEn4gT
	 Qr6EUt11myDy3GXI7sM/oPI87fHbO9GSRuceP5qCXqcIy9DrNX8BWJFh0gnO52itVI
	 y8lFYXElmCHhQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 14 Oct 2025 11:33:23 -0700
Subject: [PATCH] smb: client: Fix format specifiers for size_t in
 parse_dfs_referrals()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-v1-1-47fa7db66b71@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHKX7mgC/x2N0QqDMAwAf0XyvIDt5ub2KzKktckW0CqJbIL47
 yt7PA7udjBSIYNHtYPSR0zmXMCdKhjeIb8IJRUGX/vG1e6CNkUcRqG8IsuGX551CiuefcQlqFG
 f2HolJtUwGrr2HtvhyolvDZToUpRs/2H3PI4fLRC10IAAAAA=
X-Change-ID: 20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-189b8c6fdf75
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Eugene Korenevsky <ekorenevsky@aliyun.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Ccm Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, patches@lists.linux.dev, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2930; i=nathan@kernel.org;
 h=from:subject:message-id; bh=gc2IwG9tmS2hKkPI8UqDHKu2rWpkYqhLBY0pYc2U35A=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnvppfX9tpsFKycryZmKWtao2fqzGSkPOPKTr2oDbavX
 zQlrvzcUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYSGcHIMLev7VLMBY7e7WWt
 E1Z1z7//4rP7pDXVi3ZwPuDadcRhcx8jw8+dp+d5XIv2uW/BFix3pe/e4SK5bab+tQ0PDP5UpSu
 95wcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for 32-bit platforms, for which 'size_t' is
'unsigned int', there are a couple instances of -Wformat:

  fs/smb/client/misc.c:922:25: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
    921 |                          "%s: header is malformed (size is %u, must be %lu)\n",
        |                                                                        ~~~
        |                                                                        %u
    922 |                          __func__, rsp_size, sizeof(*rsp));
        |                                              ^~~~~~~~~~~~
  fs/smb/client/misc.c:940:5: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
    938 |                          "%s: malformed buffer (size is %u, must be at least %lu)\n",
        |                                                                              ~~~
        |                                                                              %u
    939 |                          __func__, rsp_size,
    940 |                          sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3));
        |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the proper 'size_t' format specifier, '%zu', to clear up these
warnings.

Cc: stable@vger.kernel.org
Fixes: c1047752ed9f ("cifs: parse_dfs_referrals: prevent oob on malformed input")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Feel free to squash this into the original change to make backporting
easier. I included the tags in case rebasing was not an option.
---
 fs/smb/client/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 987f0ca73123..e10123d8cd7d 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -918,7 +918,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 
 	if (rsp_size < sizeof(*rsp)) {
 		cifs_dbg(VFS | ONCE,
-			 "%s: header is malformed (size is %u, must be %lu)\n",
+			 "%s: header is malformed (size is %u, must be %zu)\n",
 			 __func__, rsp_size, sizeof(*rsp));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
@@ -935,7 +935,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 
 	if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) {
 		cifs_dbg(VFS | ONCE,
-			 "%s: malformed buffer (size is %u, must be at least %lu)\n",
+			 "%s: malformed buffer (size is %u, must be at least %zu)\n",
 			 __func__, rsp_size,
 			 sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3));
 		rc = -EINVAL;

---
base-commit: 4e47319b091f90d5776efe96d6c198c139f34883
change-id: 20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-189b8c6fdf75

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

