Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B24253B65;
	Tue,  8 Apr 2025 22:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744151403; cv=none; b=H4MbDTs27n2pIXfVvAWY9t1hODmLfsh1rNI31sMK//SC0XzeNTUN4bSDMs+UsSiiqJibGpO6sh/5CQ5Yq1m/SrbWNDCdqU0RqXhcY+WbW0pqVSkl59suH4ITZjQz0mTvZVAsPvGthfFD1geXg+d2ObdRAXag847XZwe9sWOtZQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744151403; c=relaxed/simple;
	bh=hlugUo1L7n2ZEpibyxatVdZ+3CCdhHbHYfCeaNjQIac=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Eu3PDFRjE7vAoiegpCiMcpkDcPXsXyACwdwDTMaJCmgkbItNbVig1rS8/8HMtxGtZQIPqPP/GUTzQAsXHO25uLLKIe/kSyn8Kmd1Fgf6jmXp6OWe7+vQmNocANW2nMbTl8SmaAdlxu2aotaZMEF73NUESSAsCRe8118c5zaAniA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZC0+UeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZC0+UeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EA5C4CEE7;
	Tue,  8 Apr 2025 22:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744151402;
	bh=hlugUo1L7n2ZEpibyxatVdZ+3CCdhHbHYfCeaNjQIac=;
	h=From:To:Cc:Subject:Date:From;
	b=rZC0+UeM3MNnbhnEgmQz9IXUlsF5rH93vI2Cpza1wNz11+FqzPzUEEm4wfnMVopg3
	 VmCbeeIdoepRx1n6undnG/UPtz8Thmhte00G6jCzdXhzBaS4bJ7cF1hHVnGm7Z3Cdu
	 /c56UY73+qQk2OjeTTcssxRUPwu6PN+PborqmM8YQJfHC+4jeOesOaIZysAyAfRoMY
	 ToaSJogsuESzIXzVsFOfwoFYpMAQ8KwO3/EgxQBcGmoTqKKJm3o0qSUWUYR48Z4Hbl
	 kmOOLOImQrnfGHpTkZ5hQRkBtH2meA+zhP75uZVfo6SWnsAUBNLD6cE95zVFtGEqYF
	 7H47bb7RoiY8g==
Received: by pali.im (Postfix)
	id 5095D968; Wed,  9 Apr 2025 00:29:59 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix support for WSL-style symlinks
Date: Wed,  9 Apr 2025 00:29:49 +0200
Message-Id: <20250408222949.5041-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

MS-FSCC in section 2.1.2.7 LX SYMLINK REPARSE_DATA_BUFFER now contains
documentation about WSL symlink reparse point buffers.

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/68337353-9153-4ee1-ac6b-419839c3b7ad

Fix the struct reparse_wsl_symlink_data_buffer to reflect buffer fields
according to the MS-FSCC documentation.

Fix the Linux SMB client to correctly fill the WSL symlink reparse point
buffer when creaing new WSL-style symlink. There was a mistake during
filling the data part of the reparse point buffer. It should starts with
bytes "\x02\x00\x00\x00" (which represents version 2) but this constant was
written as number 0x02000000 encoded in little endian, which resulted bytes
"\x00\x00\x00\x02". This change is fixing this mistake.

Fixes: 4e2043be5c14 ("cifs: Add support for creating WSL-style symlinks")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 25 ++++++++++++++++---------
 fs/smb/common/smb2pdu.h |  6 +++---
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 7cefe903edb5..dbd3dd9b678f 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -520,12 +520,12 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
 			kfree(symname_utf16);
 			return -ENOMEM;
 		}
-		/* Flag 0x02000000 is unknown, but all wsl symlinks have this value */
-		symlink_buf->Flags = cpu_to_le32(0x02000000);
-		/* PathBuffer is in UTF-8 but without trailing null-term byte */
+		/* Version field must be set to 2 (MS-FSCC 2.1.2.7) */
+		symlink_buf->Version = cpu_to_le32(2);
+		/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
 		symname_utf8_len = utf16s_to_utf8s((wchar_t *)symname_utf16, symname_utf16_len/2,
 						   UTF16_LITTLE_ENDIAN,
-						   symlink_buf->PathBuffer,
+						   symlink_buf->Target,
 						   symname_utf8_maxlen);
 		*buf = (struct reparse_data_buffer *)symlink_buf;
 		buf_len = sizeof(struct reparse_wsl_symlink_data_buffer) + symname_utf8_len;
@@ -995,29 +995,36 @@ static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf
 				     struct cifs_open_info_data *data)
 {
 	int len = le16_to_cpu(buf->ReparseDataLength);
+	int data_offset = offsetof(typeof(*buf), Target) - offsetof(typeof(*buf), Version);
 	int symname_utf8_len;
 	__le16 *symname_utf16;
 	int symname_utf16_len;
 
-	if (len <= sizeof(buf->Flags)) {
+	if (len <= data_offset) {
 		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
 		return -EIO;
 	}
 
-	/* PathBuffer is in UTF-8 but without trailing null-term byte */
-	symname_utf8_len = len - sizeof(buf->Flags);
+	/* MS-FSCC 2.1.2.7 defines layout of the Target field only for Version 2. */
+	if (le32_to_cpu(buf->Version) != 2) {
+		cifs_dbg(VFS, "srv returned unsupported wsl symlink version %u\n", le32_to_cpu(buf->Version));
+		return -EIO;
+	}
+
+	/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
+	symname_utf8_len = len - data_offset;
 	/*
 	 * Check that buffer does not contain null byte
 	 * because Linux cannot process symlink with null byte.
 	 */
-	if (strnlen(buf->PathBuffer, symname_utf8_len) != symname_utf8_len) {
+	if (strnlen(buf->Target, symname_utf8_len) != symname_utf8_len) {
 		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
 		return -EIO;
 	}
 	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
 	if (!symname_utf16)
 		return -ENOMEM;
-	symname_utf16_len = utf8s_to_utf16s(buf->PathBuffer, symname_utf8_len,
+	symname_utf16_len = utf8s_to_utf16s(buf->Target, symname_utf8_len,
 					    UTF16_LITTLE_ENDIAN,
 					    (wchar_t *) symname_utf16, symname_utf8_len * 2);
 	if (symname_utf16_len < 0) {
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 764dca80c15c..f79a5165a7cc 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1567,13 +1567,13 @@ struct reparse_nfs_data_buffer {
 	__u8	DataBuffer[];
 } __packed;
 
-/* For IO_REPARSE_TAG_LX_SYMLINK */
+/* For IO_REPARSE_TAG_LX_SYMLINK - see MS-FSCC 2.1.2.7 */
 struct reparse_wsl_symlink_data_buffer {
 	__le32	ReparseTag;
 	__le16	ReparseDataLength;
 	__u16	Reserved;
-	__le32	Flags;
-	__u8	PathBuffer[]; /* Variable Length UTF-8 string without nul-term */
+	__le32	Version; /* Always 2 */
+	__u8	Target[]; /* Variable Length UTF-8 string without nul-term */
 } __packed;
 
 struct validate_negotiate_info_req {
-- 
2.20.1

