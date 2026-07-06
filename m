Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB213D47D4;
	Mon,  6 Jul 2026 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363732; cv=none; b=EUCS0FTQeeuD1wN/nVRVIiiC8iqtAlgaixENw8rOXupGIfQHUZfV2MfSjgVepfJazSngNZU7iDU+B7tBlum+sQeRetmcOdmA+4TJHAsyKe4FHgzm9tAKSXFsKMCQj153QdX4N5F7jCLNwrq1yuumLqs1rmvDWTUM55aQDkokLgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363732; c=relaxed/simple;
	bh=0oma+8WAFIFchIgzml0KZGGOiT/D1qeDhClredlaJds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0frQNIYIQ3qPnuPe9NaU+8bGOOkazkcrWZNRG7XmUZGwtQ9/8w6qlBVODLUVLqZ7jOsg0QFKkQwSvIRaLq3Ko4xtEE0xJtIpWsDlf6AO6xWoPJlCGd98lL+HMNEYFeVtN5837tX2DIHOGqZclY5s8sr+JklYmMt4E/LbED2/T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJLXGtp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJLXGtp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19691F00ADE;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363719;
	bh=exVPpdivLJB6KdGUNdQfFBsVNbClGzHvAoJmWXs3Mio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJLXGtp83jyZ+cPQELx8p7boL8YmmQDchG+9FfGeKkb3ZfGRU6EmgcdxrpaHbInkc
	 iRwXNK1uZbK8HE9jIRvdI5SU3vqaLfYQGzdUKPUEM4qxeOFK+mG6qV3vNo9isllh7+
	 DYzvbO3xXWHC1PWXqjz34TSBt0mr9Obk3kPDcsbRkGrRebGwbml1jpVY/3XH7AV7nj
	 zVFAI71R4ko2Nl8gTIWaXIHsJ2T0zHJgI9EkWubBJe3uYhNZPeRPTpCO0vlSnm+ZwN
	 Iyvc0S1lx7BQpwd2fAI15tJkhY8S+ocuF8j3/oqh1i9pFdp6O3GEftSHjCWIAzSQLa
	 gKg+RNRUsenQg==
Received: by pali.im (Postfix)
	id A66FD10E9; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 10/11] cifs: Add support for parsing WSL symlinks in version 1 format
Date: Mon,  6 Jul 2026 20:48:18 +0200
Message-Id: <20260706184819.22124-11-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
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
 fs/smb/client/reparse.c   | 118 ++++++++++++++++++++++++++++++++------
 fs/smb/common/fscc.h      |   5 +-
 4 files changed, 105 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c4ababcb51a3..1ed97957038f 100644
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
index 6f82aa9bd033..002a2ec85db5 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1171,6 +1171,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 
 			reparse_buf = server->ops->get_reparse_point_buffer(iov, &reparse_len);
 			rc = parse_reparse_point(reparse_buf, reparse_len,
+						 xid, tcon,
 						 cifs_sb, full_path, data);
 			/*
 			 * If the reparse point was not handled but it is the
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 50eeea127a42..0402a30d0d53 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1045,51 +1045,124 @@ static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
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
 
-	if (version != 2) {
+		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
+				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+				     ACL_NO_MODE);
+		oparms.fid = &fid;
+		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
+		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+		if (rc)
+			goto out;
+
+		free_symname_utf8 = true;
+		symname_utf8_len = le64_to_cpu(data->fi.EndOfFile);
+		symname_utf8 = kmalloc(symname_utf8_len, GFP_KERNEL);
+		if (!symname_utf8) {
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		buf_type = CIFS_NO_BUFFER;
+		io_parms = (struct cifs_io_parms) {
+			.netfid = fid.netfid,
+			.pid = current->tgid,
+			.tcon = tcon,
+			.offset = 0,
+			.length = symname_utf8_len,
+		};
+		rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
+						       &symname_utf8_len,
+						       &symname_utf8,
+						       &buf_type);
+		if (!rc && symname_utf8_len != le64_to_cpu(data->fi.EndOfFile))
+			rc = -EIO;
+
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
 
@@ -1097,14 +1170,23 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
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
@@ -1122,7 +1204,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		return parse_reparse_wsl_symlink(
 			(struct reparse_wsl_symlink_data_buffer *)buf,
-			cifs_sb, data);
+			xid, tcon, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 859849a42fec..f5ec6b203c42 100644
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

