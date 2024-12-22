Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816218FC85;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734882290; cv=none; b=jv9v0SuzvZMzF3nrpalhkZqJvocBQ6/msO+IxtEsuWu44kWlY3ljdnHd+TD9NEBTXJHf8zI3PfEpIMYzkyxQCOsLnUuvwWcxJCeuBiKtdcJTOxUPj7tKLZkYw0TzUN2GbhcEZPqE5LcxuDMXlI6eOlJ1ES1O3/bBpzuRRppjr/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734882290; c=relaxed/simple;
	bh=3onlQYxHbJn5sSsJa75CcVW58TTix8UZLOMI9JMW5UY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBfQUgsNrX611VVeHBrT1cffe16Vh+cmUDYxqA6/BQsMH/N2DEz+GK/PukRRpWZb3mOk53ikfrU/k2G1r913ojwf7VccdCA+N7WXIOuggk91h0oIJtQacQvOEVZ1IS4PoVjba6oHCNeBelUr/uhJiIRBdl8d1glxxqAGOI+mRPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yu9ec+k7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu9ec+k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF67BC4CEDD;
	Sun, 22 Dec 2024 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734882290;
	bh=3onlQYxHbJn5sSsJa75CcVW58TTix8UZLOMI9JMW5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yu9ec+k73YXeoiaYK8q4DDiLAxjwNaTRYBdnAy2F8Tq59EsWQ6H8KnZmjw1UcPh/6
	 +6Jn/BAhbN/gk0zoOZ5Rs6Lz8xRlBFeQKzvNDWhKlglS9L/Nb1bX2CQpx+2ABOHect
	 r+/DFGWJp4uESrbHLXZuMAcds3e7L7Y4z8UdD2U3dJctK3wQKpVnh3CMcWuCd5yjpA
	 9HqRkkXG8ulmAd1YbQMB3oHzRUOApCaLg7Fx2eWQKRNXLVWYPrCH+u03T7HQmtMYXL
	 tZO8tvUSQVAMwDooTStBwp2hZ+v4y8tUew3evBEvQ4+M0+ypjVXmsPuVdfu9qa+NCH
	 zwh3YZinIsoyw==
Received: by pali.im (Postfix)
	id 17DC2982; Sun, 22 Dec 2024 16:44:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cifs: Split parse_reparse_point callback to functions: get buffer and parse buffer
Date: Sun, 22 Dec 2024 16:43:37 +0100
Message-Id: <20241222154340.24104-2-pali@kernel.org>
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

Parsing reparse point buffer is generic for all SMB versions and is already
implemented by global function parse_reparse_point().

Getting reparse point buffer from the SMB response is SMB version specific,
so introduce for it a new callback get_reparse_point_buffer.

This functionality split is needed for next change - getting reparse point
buffer without parsing it.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h |  6 ++----
 fs/smb/client/inode.c    | 11 +++++++----
 fs/smb/client/reparse.c  | 15 +++++----------
 fs/smb/client/reparse.h  |  5 +----
 fs/smb/client/smb1ops.c  | 17 ++++++-----------
 fs/smb/client/smb2ops.c  |  8 ++++----
 6 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 369458d37f99..d4c60d85d7a4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -629,10 +629,8 @@ struct smb_version_operations {
 	bool (*is_status_io_timeout)(char *buf);
 	/* Check for STATUS_NETWORK_NAME_DELETED */
 	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
-	int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
-				   const char *full_path,
-				   struct kvec *rsp_iov,
-				   struct cifs_open_info_data *data);
+	struct reparse_data_buffer * (*get_reparse_point_buffer)(const struct kvec *rsp_iov,
+								 u32 *plen);
 	int (*create_reparse_symlink)(const unsigned int xid,
 				      struct inode *inode,
 				      struct dentry *dentry,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ed32d78971f8..b295d161373c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1207,10 +1207,13 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		/* Check for cached reparse point data */
 		if (data->symlink_target || data->reparse.buf) {
 			rc = 0;
-		} else if (iov && server->ops->parse_reparse_point) {
-			rc = server->ops->parse_reparse_point(cifs_sb,
-							      full_path,
-							      iov, data);
+		} else if (iov && server->ops->get_reparse_point_buffer) {
+			struct reparse_data_buffer *reparse_buf;
+			u32 reparse_len;
+
+			reparse_buf = server->ops->get_reparse_point_buffer(iov, &reparse_len);
+			rc = parse_reparse_point(reparse_buf, reparse_len,
+						 cifs_sb, full_path, data);
 			/*
 			 * If the reparse point was not handled but it is the
 			 * name surrogate which points to directory, then treat
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 6ffda4455f9b..f01214d6c5d4 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1096,18 +1096,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	}
 }
 
-int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-			     const char *full_path,
-			     struct kvec *rsp_iov,
-			     struct cifs_open_info_data *data)
+struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp_iov,
+							  u32 *plen)
 {
-	struct reparse_data_buffer *buf;
 	struct smb2_ioctl_rsp *io = rsp_iov->iov_base;
-	u32 plen = le32_to_cpu(io->OutputCount);
-
-	buf = (struct reparse_data_buffer *)((u8 *)io +
-					     le32_to_cpu(io->OutputOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, data);
+	*plen = le32_to_cpu(io->OutputCount);
+	return (struct reparse_data_buffer *)((u8 *)io +
+					      le32_to_cpu(io->OutputOffset));
 }
 
 static void wsl_to_fattr(struct cifs_open_info_data *data,
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 5a753fec7e2c..c17130657def 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -119,9 +119,6 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
-int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-			     const char *full_path,
-			     struct kvec *rsp_iov,
-			     struct cifs_open_info_data *data);
+struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp_iov, u32 *len);
 
 #endif /* _CIFS_REPARSE_H */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 3667fb94cbf5..01a7d6b23c7e 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -993,18 +993,13 @@ static int cifs_query_symlink(const unsigned int xid,
 	return rc;
 }
 
-static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-				    const char *full_path,
-				    struct kvec *rsp_iov,
-				    struct cifs_open_info_data *data)
+static struct reparse_data_buffer *cifs_get_reparse_point_buffer(const struct kvec *rsp_iov,
+								 u32 *plen)
 {
-	struct reparse_data_buffer *buf;
 	TRANSACT_IOCTL_RSP *io = rsp_iov->iov_base;
-	u32 plen = le16_to_cpu(io->ByteCount);
-
-	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
-					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, data);
+	*plen = le16_to_cpu(io->ByteCount);
+	return (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
+					      le32_to_cpu(io->DataOffset));
 }
 
 static bool
@@ -1139,7 +1134,7 @@ struct smb_version_operations smb1_operations = {
 	.rename = CIFSSMBRename,
 	.create_hardlink = CIFSCreateHardLink,
 	.query_symlink = cifs_query_symlink,
-	.parse_reparse_point = cifs_parse_reparse_point,
+	.get_reparse_point_buffer = cifs_get_reparse_point_buffer,
 	.open = cifs_open_file,
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 87cb1872db28..0a91f18d4a54 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5270,7 +5270,7 @@ struct smb_version_operations smb20_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.parse_reparse_point = smb2_parse_reparse_point,
+	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.create_reparse_symlink = smb2_create_reparse_symlink,
@@ -5373,7 +5373,7 @@ struct smb_version_operations smb21_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.parse_reparse_point = smb2_parse_reparse_point,
+	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.create_reparse_symlink = smb2_create_reparse_symlink,
@@ -5480,7 +5480,7 @@ struct smb_version_operations smb30_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.parse_reparse_point = smb2_parse_reparse_point,
+	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.create_reparse_symlink = smb2_create_reparse_symlink,
@@ -5596,7 +5596,7 @@ struct smb_version_operations smb311_operations = {
 	.unlink = smb2_unlink,
 	.rename = smb2_rename_path,
 	.create_hardlink = smb2_create_hardlink,
-	.parse_reparse_point = smb2_parse_reparse_point,
+	.get_reparse_point_buffer = smb2_get_reparse_point_buffer,
 	.query_mf_symlink = smb3_query_mf_symlink,
 	.create_mf_symlink = smb3_create_mf_symlink,
 	.create_reparse_symlink = smb2_create_reparse_symlink,
-- 
2.20.1

