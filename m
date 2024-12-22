Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8541190051;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734882290; cv=none; b=YDvYxZ8O2RKYIwszWkHMLV8Z+G40OI/J5BYDu3ZGjiWEkLebrXG6xlheQTH/TbRfhnR9prZ9JkErGaa+5ymqnS+hrM6ITA41fQWjKzQT7gWrCy9pefC1ErMgTg/BgV3g0F9OqDvpeORRzQLJQNqGy0kXXBLnNaaWPOtkvZlS/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734882290; c=relaxed/simple;
	bh=vZKFm2ZEqacVyuVEfxw0+dRyd+24gQiBndfQn3r89J0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRovRknQznlJ58V24nfExyRaFKuHjWU9+DKyCF13xas92eah70Tsj5gYtQA0eo7Asvb/DYSiEpKEokiapBYvlA6gzIT6rB58voXyiFqUQbFsyKxM4ysNq9tazAD21KCCvr31maelXw24NnT7o9Fy5Rjd1yBhCgo6UAL7o8jX2tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsoE+Ehf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsoE+Ehf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70380C4CEDE;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734882290;
	bh=vZKFm2ZEqacVyuVEfxw0+dRyd+24gQiBndfQn3r89J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsoE+Ehf+u7SurXPtfe8LCch7VJqvwIp/F96oTySu30g3WMryazETaNVFDcUAZg61
	 oWoWUo1cLNHcJygfH2x6iXgOVJ0cI0M3PybzgG1ckEKqVQ/1SzemCiA0MMnsCk0J2o
	 qFEXs/acyckSrNiyWOmvjIv/e5mlADgVcgAEt+dklyMCnUb4GYgIWZePaFPEnC+bMU
	 Gg20U5q9fgjVZ4ntTld00+kGzOdC1XtuyEGEY/Oa7OefUOoAkJD2a8LN5Vu4hZsWZa
	 0jO7Y2lTEG/DQX1yejwJUiA13C3L84cuCFHini+Bwy+NanwtW8BAdGthfeqbh4TrQK
	 4oEy1ZmZqiYVA==
Received: by pali.im (Postfix)
	id 9ADD1EEC; Sun, 22 Dec 2024 16:44:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: Check if server supports reparse points before using them
Date: Sun, 22 Dec 2024 16:43:40 +0100
Message-Id: <20241222154340.24104-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222154340.24104-1-pali@kernel.org>
References: <20241222154340.24104-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not attempt to query or create reparse point when server fs does not
support it. This will prevent creating unusable empty object on the server.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c   | 3 +++
 fs/smb/client/link.c      | 3 ++-
 fs/smb/client/smb2inode.c | 8 ++++++++
 fs/smb/client/smb2ops.c   | 4 ++--
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2763db49b155..83365861a99c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2695,6 +2695,9 @@ int cifs_query_reparse_point(const unsigned int xid,
 	if (cap_unix(tcon->ses))
 		return -EOPNOTSUPP;
 
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+		return -EOPNOTSUPP;
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 6e6c09cc5ce7..a88253668286 100644
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
index 379ac3cbad1f..818537c83d41 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1289,6 +1289,14 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
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
index 0a91f18d4a54..50adb5cdfce9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5202,7 +5202,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	int rc;
+	int rc = -EOPNOTSUPP;
 
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
@@ -5213,7 +5213,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
-	} else {
+	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
 		rc = smb2_mknod_reparse(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	}
-- 
2.20.1

