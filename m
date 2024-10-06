Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68411173331;
	Sun,  6 Oct 2024 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208870; cv=none; b=hGEidSNNzhvK52obAt9Ve8LcktORTatN1GIcTP57fl40wpkk2dRc4XSi8C8F8qjsuG9Mr7vjnxN2l+YnhL34DeoJ18qECxOCg+3ZefhtEwz7TrYZy0jlerFm3SPdQRR2BmIljwp/2dZc0CTsLvI+Q7+odQUcVrDc1Dl/u+aAHvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208870; c=relaxed/simple;
	bh=W6n5Jr77kjwOeKY8KnGZDlpMZFxE5WYz+WvM1VpLAzY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lcKbGf6bNW18VaQXmaiY1nWCQQlvZTTCqBs18Zqox9jfEIO8N6KGFNYAbu4FTT5Z4Zt3YxtluLPAmyKnJwja5HpCypSRPYwL5/Nj11ZhU7NRCsQQ44Uq0ctidxk+vNJjP44qBDFVKdEqHTPZ40l9yqzleHH++0qdK/3Y+/kpmRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNNOTwKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNNOTwKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2990C4CED2;
	Sun,  6 Oct 2024 10:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208870;
	bh=W6n5Jr77kjwOeKY8KnGZDlpMZFxE5WYz+WvM1VpLAzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNNOTwKT0bAcL2JTYDL9wCV2e4ZD9kDuEisPj6bmYxyv5hl/HzZni89atOmRPBWxx
	 7cCmME901Fdw8dBYjFPqVkHmHOp8k7abXD+XJg1zjJxPTLldTe6u0P6dOHisUkm45v
	 WT3GBQoOhKBNyJMgxC5iM+eFnzhrkT00+l67zKxfqp7ANhjDJpTzR82X2jIUkwa4yF
	 bd70lXIuHpvyR+FJkABipFQI/k50q8iXxAvOVW/qOdOnkBwT+Lx/mHkFIo2xlcpNPA
	 PWeC5B2DoI7I7mY55JtVD1PC+cWpQC2u3PkMHRuLRnePI4HLdh6PJHeYuFg7GCfeJR
	 Ic4ebWfvDPTGw==
Received: by pali.im (Postfix)
	id 735E4D0E; Sun,  6 Oct 2024 12:01:03 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] cifs: Add support for creating WSL-style symlinks
Date: Sun,  6 Oct 2024 12:00:45 +0200
Message-Id: <20241006100046.30772-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
References: <20241006100046.30772-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This change implements support for creating new symlink in WSL-style by
Linux cifs client when -o reparse=wsl mount option is specified. WSL-style
symlink uses reparse point with tag IO_REPARSE_TAG_LX_SYMLINK and symlink
target location is stored in reparse buffer in UTF-8 encoding prefixed by
32-bit flags. Flags bits are unknown, but it was observed that WSL always
sets flags to value 0x02000000. Do same in Linux cifs client.

New symlinks would be created in WSL-style only in case the mount option
-o reparse=wsl is specified, which is not by default. So default CIFS
mounts are not affected by this change.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 65 +++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 402eb568f466..6606c40487ae 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -506,9 +506,17 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-static int wsl_set_reparse_buf(struct reparse_data_buffer *buf,
-			       mode_t mode, struct kvec *iov)
+static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
+			       mode_t mode, const char *symname,
+			       struct cifs_sb_info *cifs_sb,
+			       struct kvec *iov)
 {
+	struct reparse_wsl_symlink_data_buffer *symlink_buf;
+	__le16 *symname_utf16;
+	int symname_utf16_len;
+	int symname_utf8_maxlen;
+	int symname_utf8_len;
+	size_t buf_len;
 	u32 tag;
 
 	switch ((tag = reparse_mode_wsl_tag(mode))) {
@@ -516,17 +524,45 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_AF_UNIX:
+		buf_len = sizeof(struct reparse_data_buffer);
+		*buf = kzalloc(buf_len, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+		break;
+	case IO_REPARSE_TAG_LX_SYMLINK:
+		symname_utf16 = cifs_strndup_to_utf16(symname, strlen(symname),
+						      &symname_utf16_len,
+						      cifs_sb->local_nls,
+						      NO_MAP_UNI_RSVD);
+		if (!symname_utf16)
+			return -ENOMEM;
+		symname_utf8_maxlen = symname_utf16_len/2*3;
+		symlink_buf = kzalloc(sizeof(struct reparse_wsl_symlink_data_buffer) +
+				      symname_utf8_maxlen, GFP_KERNEL);
+		if (!symlink_buf) {
+			kfree(symname_utf16);
+			return -ENOMEM;
+		}
+		/* Flag 0x02000000 is unknown, but all wsl symlinks have this value */
+		symlink_buf->Flags = cpu_to_le32(0x02000000);
+		/* PathBuffer is in UTF-8 but without trailing null-term byte */
+		symname_utf8_len = utf16s_to_utf8s(symname_utf16, symname_utf16_len/2,
+						   UTF16_LITTLE_ENDIAN,
+						   symlink_buf->PathBuffer,
+						   symname_utf8_maxlen);
+		*buf = (struct reparse_data_buffer *)symlink_buf;
+		buf_len = sizeof(struct reparse_wsl_symlink_data_buffer) + symname_utf8_len;
+		kfree(symname_utf16);
 		break;
-	case IO_REPARSE_TAG_LX_SYMLINK: /* TODO: add support for WSL symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	buf->ReparseTag = cpu_to_le32(tag);
-	buf->Reserved = 0;
-	buf->ReparseDataLength = 0;
-	iov->iov_base = buf;
-	iov->iov_len = sizeof(*buf);
+	(*buf)->ReparseTag = cpu_to_le32(tag);
+	(*buf)->Reserved = 0;
+	(*buf)->ReparseDataLength = buf_len - sizeof(struct reparse_data_buffer);
+	iov->iov_base = *buf;
+	iov->iov_len = buf_len;
 	return 0;
 }
 
@@ -618,25 +654,29 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     const char *full_path, umode_t mode, dev_t dev,
 		     const char *symname)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_open_info_data data;
-	struct reparse_data_buffer buf;
+	struct reparse_data_buffer *buf;
 	struct smb2_create_ea_ctx *cc;
 	struct inode *new;
 	unsigned int len;
 	struct kvec reparse_iov, xattr_iov;
 	int rc;
 
-	rc = wsl_set_reparse_buf(&buf, mode, &reparse_iov);
+	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
 
 	rc = wsl_set_xattrs(inode, mode, dev, &xattr_iov);
-	if (rc)
+	if (rc) {
+		kfree(buf);
 		return rc;
+	}
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
-		.reparse = { .tag = le32_to_cpu(buf.ReparseTag), .buf = &buf, },
+		.reparse = { .tag = le32_to_cpu(buf->ReparseTag), .buf = buf, },
+		.symlink_target = kstrdup(symname, GFP_KERNEL),
 	};
 
 	cc = xattr_iov.iov_base;
@@ -653,6 +693,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 		rc = PTR_ERR(new);
 	cifs_free_open_info(&data);
 	kfree(xattr_iov.iov_base);
+	kfree(buf);
 	return rc;
 }
 
-- 
2.20.1

