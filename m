Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777904F8A0;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=rKmoK6klby0ehf1eByb/nVXzDdhOL5zY4Twb083MHTBYlTX14BTivFwhmAZhoIsK6MSBJVpR9fbnGna7loM3jh70U66wnNs3SqLLBk8ybSmGvIdp9fnMkFsRYOru1OHJ7hnGgSxbkr1FK32QnZ+NYfjWguyusr5duVLL5Pv+1lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=cj10ep1gPlsUYj3PVruGSEFXLq/JujQahcOckuQVlpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRnw2wg1f98dTR+ScgIZ0NxDq5nP0ezkbjZG3yGmlrs9KBk1vRpoNC5P9teHmfEpipcJ4BsMVklMkUwvxkNVVLLKjuviRtecIWwsQLxkj0L7n7Xh8fce5BmrCtrb7xNgTeB53yWcd5E2FaHMKe4KdDE3gHqFM8FYT8m5HlLpty8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QksgGl/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QksgGl/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F420EC4CED0;
	Sun, 29 Sep 2024 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635864;
	bh=cj10ep1gPlsUYj3PVruGSEFXLq/JujQahcOckuQVlpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QksgGl/i71D23dyiAksfR2sYzImV4SGkQ27vF14eYGx9owQjNJGVsK+3YWlFcgyRK
	 PbXWixr/C93a+mrwkbWD0dVYgojLpUsl8dKuIvGt5wDMCOxjcIo9Lny5rGEIp3zXxD
	 TDBbZ4Rzk2G4vwOKCibQZg+WdZxhU9ZUvINMB5cpFhabuLfkr7c5GOS+b58QHzNXND
	 fic7LWNJLfATSrW084nFmKY5A+gRMS+Ny5uvapmxKTZnHcylXxq+0MgHv8TlfueBXn
	 0OlEYclcNKwgD3S6u4gM5GQavKcdxkSMYhQVMhpEODHxdYqliraeU8uUEXCaKT6b7y
	 IlBT52DTK+XQg==
Received: by pali.im (Postfix)
	id EC32092C; Sun, 29 Sep 2024 20:50:56 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] cifs: Rename smb2_get_reparse_inode to smb2_create_reparse_inode
Date: Sun, 29 Sep 2024 20:50:47 +0200
Message-Id: <20240929185053.10554-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This function creates a new reparse point, so put "create" into its name.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c   | 6 +++---
 fs/smb/client/smb2inode.c | 2 +-
 fs/smb/client/smb2proto.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a23ea2f78c09..507e17244ed3 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -68,7 +68,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	convert_delimiter(sym, '/');
 	iov.iov_base = buf;
 	iov.iov_len = len;
-	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+	new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
 				     tcon, full_path, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
@@ -136,7 +136,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 		.reparse = { .tag = IO_REPARSE_TAG_NFS, .nfs = p, },
 	};
 
-	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+	new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
 				     tcon, full_path, &iov, NULL);
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
@@ -282,7 +282,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	memcpy(data.wsl.eas, &cc->ea, len);
 	data.wsl.eas_len = len;
 
-	new = smb2_get_reparse_inode(&data, inode->i_sb,
+	new = smb2_create_reparse_inode(&data, inode->i_sb,
 				     xid, tcon, full_path,
 				     &reparse_iov, &xattr_iov);
 	if (!IS_ERR(new))
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6e69a3b98be3..0fc73035d6dc 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1193,7 +1193,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	return rc;
 }
 
-struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b208232b12a2..4ac30d29d5a1 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -56,7 +56,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb, const char *path,
 				__u32 *reparse_tag);
-struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 				     struct super_block *sb,
 				     const unsigned int xid,
 				     struct cifs_tcon *tcon,
-- 
2.20.1

