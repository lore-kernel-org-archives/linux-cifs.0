Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4FD1DE3A5;
	Mon, 28 Oct 2024 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730113466; cv=none; b=a+P6UTGP8HA30brzclWO3MhWyG0cN7xJebeeSF8t7CMmSAu+nLel30/k7P+kcFLFidz0Z4rjfkt+cvzYomFuLoWNo6q4Y3AM6fUtEqgdM2wFk+bWblMETWg9XqDdV4o1RBDxp0I3xC19gg1QgDRnS/4ppcmv8B8LUVOX5mMjWFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730113466; c=relaxed/simple;
	bh=DSYo+AMOz9V76UAeqSyE83YB2PapFnpd3VyO1UD2pp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Trn4AQu9e7VRsE2GxBsGjRc6NZ0727b6DIfuLkwQ4gt2BjOkr2R5kq7AS5+BaXttwE5s23ahAwBF9jSj4NrDnCHb2wPFmKG68OxPK8NnH59hk+zVSuorMAh11X3Q8xkzEvzUFq0nABMyg6bHr6UjLPCT3TP3ApOIQfGrH88QRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If6dcUvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If6dcUvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0E7C4CEE8;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730113466;
	bh=DSYo+AMOz9V76UAeqSyE83YB2PapFnpd3VyO1UD2pp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=If6dcUvXcpr9DbEotD3tkvORgL/EMBq6sDBfGuIkicUczKXxXiwLGrVENDJ9nqQtR
	 o4GtNOA9MyCRuvxjZvhvSfpT7ZmAMeNQFvNYOoIs8jtJH4mgQ349iA+UaqFQFqA/I2
	 TDG4RiPUsgW+6fs9wEctQ5b3DzBbiVXwkxvcW93YTtOceWb9La24vxVCuVvKUnfkqW
	 9SeTF6VrP6ZoEe8uRGym+E1CD3dxQhw1sBXokvxz0WF82gXKpTkEOtFYc6wBlJpgZO
	 P9X0PNK1Dl7b9njoF7bbaPtDEBpS80CBNAsPw1h05acL9tlBvDK80gmwxciDTldnJC
	 gp+AwpY9L418A==
Received: by pali.im (Postfix)
	id 02ACADEC; Mon, 28 Oct 2024 12:04:19 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] cifs: Remove unicode parameter from parse_reparse_point() function
Date: Mon, 28 Oct 2024 12:03:40 +0100
Message-Id: <20241028110340.29911-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028110340.29911-1-pali@kernel.org>
References: <20241028110340.29911-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This parameter is always true, so remove it and also remove dead code which
is never called (for all false code paths).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h |  2 +-
 fs/smb/client/reparse.c   | 25 +++++++++++--------------
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2file.c  |  1 -
 fs/smb/client/smb2proto.h |  2 +-
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index a7906c193647..31445d40f179 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -667,7 +667,7 @@ char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			const char *full_path,
-			bool unicode, struct cifs_open_info_data *data);
+			struct cifs_open_info_data *data);
 int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 			 struct dentry *dentry, struct cifs_tcon *tcon,
 			 const char *full_path, umode_t mode, dev_t dev,
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3de91331c96c..50720142813e 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -775,7 +775,7 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 }
 
 int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
-			      bool unicode, bool relative,
+			      bool relative,
 			      const char *full_path,
 			      struct cifs_sb_info *cifs_sb)
 {
@@ -789,26 +789,24 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	int rc;
 	int i;
 
-	/* Check that length it valid for unicode/non-unicode mode */
-	if (!len || (unicode && (len % 2))) {
+	/* Check that length it valid */
+	if (!len || (len % 2)) {
 		cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
 		rc = -EIO;
 		goto out;
 	}
 
 	/*
-	 * Check that buffer does not contain UTF-16 null codepoint in unicode
-	 * mode or null byte in non-unicode mode because Linux cannot process
-	 * symlink with null byte.
+	 * Check that buffer does not contain UTF-16 null codepoint
+	 * because Linux cannot process symlink with null byte.
 	 */
-	if ((unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) ||
-	    (!unicode && strnlen(buf, len) != len)) {
+	if (UniStrnlen((wchar_t *)buf, len/2) != len/2) {
 		cifs_dbg(VFS, "srv returned null byte in native symlink target location\n");
 		rc = -EIO;
 		goto out;
 	}
 
-	smb_target = cifs_strndup_from_utf16(buf, len, unicode, cifs_sb->local_nls);
+	smb_target = cifs_strndup_from_utf16(buf, len, true, cifs_sb->local_nls);
 	if (!smb_target) {
 		rc = -ENOMEM;
 		goto out;
@@ -985,7 +983,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 }
 
 static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
-				 u32 plen, bool unicode,
+				 u32 plen,
 				 struct cifs_sb_info *cifs_sb,
 				 const char *full_path,
 				 struct cifs_open_info_data *data)
@@ -1005,7 +1003,6 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
 	return smb2_parse_native_symlink(&data->symlink_target,
 					 sym->PathBuffer + offs,
 					 len,
-					 unicode,
 					 le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
 					 full_path,
 					 cifs_sb);
@@ -1060,7 +1057,7 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			const char *full_path,
-			bool unicode, struct cifs_open_info_data *data)
+			struct cifs_open_info_data *data)
 {
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
@@ -1074,7 +1071,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_SYMLINK:
 		return parse_reparse_native_symlink(
 			(struct reparse_symlink_data_buffer *)buf,
-			plen, unicode, cifs_sb, full_path, data);
+			plen, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		return parse_reparse_wsl_symlink(
 			(struct reparse_wsl_symlink_data_buffer *)buf,
@@ -1108,7 +1105,7 @@ int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 
 	buf = (struct reparse_data_buffer *)((u8 *)io +
 					     le32_to_cpu(io->OutputOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, data);
 }
 
 static void wsl_to_fattr(struct cifs_open_info_data *data,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index f552951cfc04..3667fb94cbf5 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1004,7 +1004,7 @@ static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 
 	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
 					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, data);
 }
 
 static bool
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 91b8d00fb88e..b0037058e8d9 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -132,7 +132,6 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 	return smb2_parse_native_symlink(path,
 					 (char *)sym->PathBuffer + sub_offs,
 					 sub_len,
-					 true,
 					 le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
 					 full_path,
 					 cifs_sb);
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5390d5a61039..c62493c0afc7 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -115,7 +115,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  unsigned int *pbytes_read);
 int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb);
 int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
-			      bool unicode, bool relative,
+			      bool relative,
 			      const char *full_path,
 			      struct cifs_sb_info *cifs_sb);
 int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb,
-- 
2.20.1

