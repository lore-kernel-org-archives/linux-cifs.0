Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B21280328;
	Mon,  5 May 2025 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483320; cv=none; b=OhNB+OnRz2hSVInvsM1hUXm+V3igT5WWsADSoH+PtQ9BFaQHv3QVLww1MlpCxMjPDQBsjIxpwUZVoWPwQ4BvoPz2nOBZaDt3VtbpwWkV8pRIQceL9Ky2MUJLtFSpbcgOa/SwxpxNwpQAesYwBG++mKx/1P3GaJJLqv0TRl1qULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483320; c=relaxed/simple;
	bh=KcCEG4ZE5zmmu9pu5BQAehFvFS9TizRYvtQ5ov4o12s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4bdZU0ufE9//K1X5xj0xvYd8c3e4ZyehX+E9V1N0QWV3d9J+FJHgchuQDz2bDlUNCQWLkp3/llYfmgdbuQXqv2vhZG7BhvhFw4iba9BK0oLRyazDDTCVtjkRp1fFhB47/3hFNadjGVhkTM5RwITuazV1Wnt+tCGCl7Imo6vTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODiT/fpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODiT/fpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D087C4CEED;
	Mon,  5 May 2025 22:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483320;
	bh=KcCEG4ZE5zmmu9pu5BQAehFvFS9TizRYvtQ5ov4o12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODiT/fpQY7mss01RGnQnX/ASHqspeOYch5+4/DBIK8Lg7t24qqwjHBjBOi8FJeYUX
	 qe3vgLogHHM4PrGXfLUJl1vzENlLGrtUW4UtGDigZF82s1ZOtlv00J7ewpH5KfRXxD
	 TG4a1izF1iRnl2AJVazwhldSgzq21jEKUZXDVhw8kaonzRGoAd+rA+VDfJzdQSa4ab
	 oEW7rSwSJZcUQHFfquQwmKL7J++zfju/2mDc2fCysW5xtW3rPjhJkd/CTGX+JBDDX1
	 0xSLYFsTY/WfJh2LXTefWl9L3YdN4cWbMWm2S+xKYYQb8fEy2IJwY/Uc207N+M0b0m
	 XEpvqqEtApHvA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 031/642] cifs: Check if server supports reparse points before using them
Date: Mon,  5 May 2025 18:04:07 -0400
Message-Id: <20250505221419.2672473-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6c06be908ca190e2d8feae1cf452d78598cd0b94 ]

Do not attempt to query or create reparse point when server fs does not
support it. This will prevent creating unusable empty object on the server.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c   | 3 +++
 fs/smb/client/link.c      | 3 ++-
 fs/smb/client/smb2inode.c | 8 ++++++++
 fs/smb/client/smb2ops.c   | 4 ++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e90811f321944..53e3e8282cb2a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2725,6 +2725,9 @@ int cifs_query_reparse_point(const unsigned int xid,
 	if (cap_unix(tcon->ses))
 		return -EOPNOTSUPP;
 
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return -EOPNOTSUPP;
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 34a026243287f..769752ad2c5ce 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -643,7 +643,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
 	case CIFS_SYMLINK_TYPE_WSL:
-		if (server->ops->create_reparse_symlink) {
+		if (server->ops->create_reparse_symlink &&
+		    (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)) {
 			rc = server->ops->create_reparse_symlink(xid, inode,
 								 direntry,
 								 pTcon,
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 826b57a5a2a8d..e9fd3e204a6f4 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1273,6 +1273,14 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	int rc;
 	int i;
 
+	/*
+	 * If server filesystem does not support reparse points then do not
+	 * attempt to create reparse point. This will prevent creating unusable
+	 * empty object on the server.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
 			     FILE_READ_ATTRIBUTES |
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6795970d4de6e..fbb3686292134 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5237,7 +5237,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	int rc;
+	int rc = -EOPNOTSUPP;
 
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
@@ -5248,7 +5248,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
-	} else {
+	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
 		rc = smb2_mknod_reparse(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	}
-- 
2.39.5

