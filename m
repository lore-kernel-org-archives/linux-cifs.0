Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Va3tQflg"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E557AC
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 16:50:05 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701823803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=v8sgLZ7IkF/CcmF2qmev306MzV+PBVT4v7hJm1of5Lw=;
	b=Va3tQflgkXzKPzm51mhVpEgmXYiNx8pxAHnwMM8Ebn3jn+Ly0Byvyb3xzW2M+8xO/68mxx
	rm9kHLzV9JA0xybmnHH4B5S69vvuxGdct1luwICjgLYl+VJ8q9SHmtOzNzpWeeASaCvKH1
	0yufTTzuTb+B44iWhQ1R2bhH7bVKczXUG3syIfzdsMXGz8bA2dhkU5xbShsyJRUmiTSDq3
	ztvu72anGM00xhDOM8Bzx5YYiLpjx6MCdti5HADfFF1yyHzixZ8a60lKb2RyUJhPmZtMjX
	+7iYhUfUMAAmtgJuB9OpTcwcgPMtGFRUTokUzIZCDJxMwS2kjohClZ+inedAOA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701823803; a=rsa-sha256;
	cv=none;
	b=bJvtc1q3edBCo9FYysLJOFUuqvecCcH9bTmX21j2ash0iU0Noru9WpYUZ+C19DGBhBjn41
	O1irWSH2HYwSkF1IVYe36DHaVRK6xHTAmO2dzu3TkgKAcZqwCYtX0f7ViupTIUZbO+tOjm
	SI/uPupKG2mZGFq5B9ld4p/WnPMmmpu53iwpG0OiUrdPA+RMiym3tu204OFOpq/lcSQUse
	vxqThAGR54+zevO1gVFJTwgXRRCO7SnAR/1l3zRQ6E3Y42IPN4L05apG7Lro51e5IZPVXt
	aPT96Y8ZA3alDJmeZTK0xey2nNfIFUa83JFAxi7pcFDkBzdq3SilXP1AcW7cPA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701823803; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=v8sgLZ7IkF/CcmF2qmev306MzV+PBVT4v7hJm1of5Lw=;
	b=iADwnHx7qhRSts0hJStqjSpsBEWE+sJDJ3rrYLF8YvvxgG4MBmKZizDZk865NgA3Ze+/K2
	jztF8W546BXuR6nr3tlkFZvgYRsEjVzY2Yh2BPZy0gtBaHwSOnYYY7+IzE+BtNFCq3aSAD
	CigAh7MADYSTjnkj93ndNqG6epSTwddzk/upBGNJtAzLR3cPGZpIc568PwTxzkIAfE6DQc
	HEkgATXCKxRbsSgoA2AEPmis4MjcXw8iEDWMWdqWo/AniFC1xXaxewc3srb5fVgVRY0gUs
	lXCOefWxIVYuNynoiKqYY0HBCqyn3krcbNaopjoEboSfdrVsoXYLTSzd0TTiBg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH] smb: client: fix potential NULL deref in parse_dfs_referrals()
Date: Tue,  5 Dec 2023 21:49:29 -0300
Message-ID: <20231206004929.8199-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If server returned no data for FSCTL_DFS_GET_REFERRALS, @dfs_rsp will
remain NULL and then parse_dfs_referrals() will dereference it.

Fix this by returning -EIO when no output data is returned.

Besides, we can't fix it in SMB2_ioctl() as some FSCTLs are allowed to
return no data as per MS-SMB2 2.2.32.

Fixes: 9d49640a21bf ("CIFS: implement get_dfs_refer for SMB2+")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 45931115f475..fcfb6566b899 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2836,6 +2836,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 		usleep_range(512, 2048);
 	} while (++retry_count < 5);
 
+	if (!rc && !dfs_rsp)
+		rc = -EIO;
 	if (rc) {
 		if (!is_retryable_error(rc) && rc != -ENOENT && rc != -EOPNOTSUPP)
 			cifs_tcon_dbg(VFS, "%s: ioctl error: rc=%d\n", __func__, rc);
-- 
2.43.0

