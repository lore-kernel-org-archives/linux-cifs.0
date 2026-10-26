Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053576;
	b=2tuzkd6QloIDWUMZola6A0MSo2TJa+Jz9jTapJc0idKbi+Uyf67+zLCj0ZG2MJmwMzS4
	 CZXyFIkuQ/aU6XbPyKa3vOpLSfY20q0dqLDiuhwfF8o5pH+jXT4tWY3l/oKNsHY57p417
	 UN8Wdy7M81qj9OJck92zvYXV5poL9PtZd0dQCDtpQ/V8xjjohsejX1c/3rJs9g4G/dcex
	 RI9EHcVnNLQI+nZKo1gNGgbWID6kft308qzIOL8WkPY+CVGeESNhcmAdan305IKsEkuKe
	 /ghEKoxh0DZn01dqrRzTgRff5uWGXH/2azALLMl5EJpabSln1atde3ZT7XfxSLrHV5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053576;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=o0aeiiZRBS3bGP/IkMniaJCC77A2dEdOKfevjU6ljxE=;
	b=pVe+hffE62wuhvo6HAS93KHQYjNZ/dA3fRpsoaue05v/PpIDFThPm+y+8IpsqUm0KKzO
	 +Bq8iGItVvfZ4TChNOrTtD5Xc/cjsS4fHpcm6RY/107OJmo8BLtyQvOfcP/XLBw4v98We
	 zzZno3L/hfBA6v2wv4TqWO8Z02rLrrsrc+kbhHKFY9MTvwTHHSyZf4zmOkqybbcw5XWox
	 sfqHaBuDEtfS2TN60HOP3SJvsqnj9Huu0Ddy0/3BQUEK9GRVJpl73YsdcfbLxoF2XgaHQ
	 mRDbxU52etF1cdkYPFzEJBB2VBg7yC04ntSPPqdgQ3YO2QTJKDc3kKxzV8elBZ6ZWOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SIH9/mxn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4AE606A322;
	Mon, 26 Oct 2026 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SIH9/mxn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74911F031E1;
	Mon, 26 Oct 2026 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053576;
	bh=o0aeiiZRBS3bGP/IkMniaJCC77A2dEdOKfevjU6ljxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIH9/mxnWm/6IT45FBSUPtsNDl3Ku1h31N+RQLVSKRjWAJx6IlK6zXN9wDv1c9+ac
	 JjEIknme9Ud2k05aL2Rk139++wKg1fKn4LDkrqTGyMqLNX1gSj43XBxyvt0mnBAPHx
	 zczBEAcJYXZ3RoGitkd+SG9prFVMaoUNtdfP9WAeVxUprfNBBHly7Mp3nVz9Nbojyp
	 BwjbOifTSsLXR29A7rBw9rt7XjzvuC2VOJnkUVFg/n3ZzX7ZBp5vpC6ku8jRMl/tol
	 imZfC3xsojThSVw0Ggh5Cq6J5+bIbdm28R6ChjK1CKt76j9Aw/VWK2Mwc+YsBAXA6A
	 eITt5QWWOcwwA==
Received: by pali.im (Postfix)
	id EBFE8129B; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 8/9] cifs: Add support for parsing WSL symlinks in version 1 format
Date: Mon, 26 Oct 2026 23:25:59 +0100
Message-Id: <20261026222600.17323-9-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

MS-FSCC 2.1.2.7 for IO_REPARSE_TAG_LX_SYMLINK reparse points currently
documents only layout version 2 format.

IO_REPARSE_TAG_LX_SYMLINK reparse point buffer of layout version 1 format
is documented in the newly released Microsoft WSL source code at github:
https://github.com/microsoft/WSL/blob/2.5.8/test/windows/DrvFsTests.cpp#L775-L815

Difference between version 1 and version 2 is that version 1 stores the
symlink target location into data section of the file, but version 2 stores
it directly into the reparse point buffer.

This change implements support for parsing WSL symlinks in this layout
version 1 format by Linux SMB client and so allow to recognize these type
of symlinks like Windows WSL.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h |   1 +
 fs/smb/client/inode.c     |   1 +
 fs/smb/client/reparse.c   | 122 ++++++++++++++++++++++++++++++++------
 fs/smb/common/fscc.h      |   5 +-
 4 files changed, 109 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 00168839c123..1202934d7b94 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -390,6 +390,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf, u32 plen,
+			unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path,
 			struct cifs_open_info_data *data);
 int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 3620eb378deb..399b7f602a84 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1182,6 +1182,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 
 			reparse_buf = server->ops->get_reparse_point_buffer(iov, &reparse_len);
 			rc = parse_reparse_point(reparse_buf, reparse_len,
+						 xid, tcon,
 						 cifs_sb, full_path, data);
 			/*
 			 * If the reparse point was not handled but it is the
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 6a7e6d9ad375..93c0c95d2202 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1071,51 +1071,128 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
 }
 
 static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf,
+				     unsigned int xid,
+				     struct cifs_tcon *tcon,
 				     struct cifs_sb_info *cifs_sb,
+				     const char *full_path,
 				     struct cifs_open_info_data *data)
 {
 	int len = le16_to_cpu(buf->ReparseDataLength);
 	int data_offset = offsetof(typeof(*buf), Target) - offsetof(typeof(*buf), Version);
-	int symname_utf8_len;
+	bool free_symname_utf8 = false;
+	struct cifs_open_parms oparms;
+	struct cifs_io_parms io_parms;
+	unsigned int symname_utf8_len;
+	char *symname_utf8 = NULL;
 	__le16 *symname_utf16;
 	int symname_utf16_len;
+	struct cifs_fid fid;
+	u64 file_size;
+	__u32 oplock;
+	int buf_type;
+	int rc = 0;
 
-	if (len <= data_offset) {
+	if (len < data_offset) {
 		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
-		return smb_EIO2(smb_eio_trace_reparse_wsl_symbuf,
+		rc = smb_EIO2(smb_eio_trace_reparse_wsl_symbuf,
 				len, data_offset);
+		goto out;
 	}
 
-	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
 	u32 version = le32_to_cpu(buf->Version);
+	switch (version) {
+	case 1:
+		/*
+		 * Layout version 1 stores the symlink target in the data section of
+		 * the file encoded in UTF-8 without trailing null-term byte.
+		 */
+
+		file_size = data->contains_posix_file_info ?
+			le64_to_cpu(data->posix_fi.EndOfFile) :
+			le64_to_cpu(data->fi.EndOfFile);
+
+		free_symname_utf8 = true;
+		symname_utf8_len = file_size;
+		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
+		if (!symname_utf8) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
+				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+				     ACL_NO_MODE);
+		oparms.fid = &fid;
+		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
+		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+		if (rc)
+			goto out;
+
+		buf_type = CIFS_NO_BUFFER;
+		io_parms = (struct cifs_io_parms) {
+			.pid = current->tgid,
+			.tcon = tcon,
+			.offset = 0,
+			.length = symname_utf8_len,
+		};
+		rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
+						       &symname_utf8_len,
+						       &symname_utf8,
+						       &buf_type);
+		if (!rc && symname_utf8_len != file_size)
+			rc = -EIO;
 
-	if (version != 2) {
+		tcon->ses->server->ops->close(xid, tcon, &fid);
+
+		if (rc) {
+			cifs_dbg(VFS, "cannot read wsl symlink target location: %d\n", rc);
+			goto out;
+		}
+
+		break;
+	case 2:
+		/*
+		 * Layout version 2 stores the symlink target in the reparse buffer
+		 * field Target encoded in UTF-8 without trailing null-term byte.
+		 */
+		symname_utf8_len = len - data_offset;
+		symname_utf8 = buf->Target;
+		break;
+	default:
 		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", version);
 		return smb_EIO1(smb_eio_trace_reparse_wsl_ver, version);
 	}
 
-	/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
-	symname_utf8_len = len - data_offset;
+	if (symname_utf8_len == 0) {
+		cifs_dbg(VFS, "srv returned empty wsl symlink target location\n");
+		rc = -EIO;
+		goto out;
+	}
+
 	/*
 	 * Check that buffer does not contain null byte
 	 * because Linux cannot process symlink with null byte.
 	 */
-	size_t ulen = strnlen(buf->Target, symname_utf8_len);
+	size_t ulen = strnlen(symname_utf8, symname_utf8_len);
 
 	if (ulen != symname_utf8_len) {
 		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
-		return smb_EIO2(smb_eio_trace_reparse_wsl_ver,
+		rc = smb_EIO2(smb_eio_trace_reparse_wsl_ver,
 				ulen, symname_utf8_len);
+		goto out;
 	}
 	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
-	if (!symname_utf16)
-		return -ENOMEM;
-	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
+	if (!symname_utf16) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	symname_utf16_len = utf8s_to_utf16s(symname_utf8, symname_utf8_len,
 					    UTF16_LITTLE_ENDIAN,
 					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
 	if (symname_utf16_len < 0) {
 		kfree(symname_utf16);
-		return symname_utf16_len;
+		rc = symname_utf16_len;
+		goto out;
 	}
 	symname_utf16_len *= 2; /* utf8s_to_utf16s() returns number of u16 items, not byte length */
 
@@ -1123,14 +1200,23 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 						       symname_utf16_len, true,
 						       cifs_sb->local_nls);
 	kfree(symname_utf16);
-	if (!data->symlink_target)
-		return -ENOMEM;
+	if (!data->symlink_target) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
-	return 0;
+out:
+	if (free_symname_utf8)
+		kfree(symname_utf8);
+
+	return rc;
 }
 
 int parse_reparse_point(struct reparse_data_buffer *buf,
-			u32 plen, struct cifs_sb_info *cifs_sb,
+			u32 plen,
+			unsigned int xid,
+			struct cifs_tcon *tcon,
+			struct cifs_sb_info *cifs_sb,
 			const char *full_path,
 			struct cifs_open_info_data *data)
 {
@@ -1148,7 +1234,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		return parse_reparse_wsl_symlink(
 			(struct reparse_wsl_symlink_data_buffer *)buf,
-			cifs_sb, data);
+			xid, tcon, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index e46d3379b779..dee4fb6af16a 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -69,12 +69,13 @@ struct reparse_nfs_data_buffer {
 	__u8	DataBuffer[];
 } __packed;
 
-/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
+/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 and
+ * https://github.com/microsoft/WSL/blob/2.5.8/test/windows/DrvFsTests.cpp#L775-L815 */
 struct reparse_wsl_symlink_data_buffer {
 	__le32	ReparseTag;
 	__le16	ReparseDataLength;
 	__u16	Reserved;
-	__le32	Version; /* Always 2 */
+	__le32	Version; /* 1 - stores symlink path in file data section; 2 - stores symlink path in Target[] field */
 	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
 } __packed;
 
-- 
2.20.1

