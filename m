Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5D028EC;
	Sun,  6 Oct 2024 09:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728205621; cv=none; b=qqj2UI64cB9BCfcI6HK6P/1BTobPaY6T50XHP02QlrJo4pOxhiGHSvNCiAajR+c0ikAoXX5rKt6hraUsykBT3mjPDurr9BpH+oD35JdKVcLNazhO+xg9Z5eot7y8i3ty4uuiN1F/KkI4rMQeWvoCYC+gISf8gXuz4EfqT4u1ld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728205621; c=relaxed/simple;
	bh=JDcqnQNF8JJFhiKpQYt3uez/euJmc6ELDxIoi1C3h3E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=k97f8Jft/0fGrCwyu0hyguyEFQRXD2TVvVbDY7KQ0Q746YdCV14Eoke8uKK9UDcqbQyrmZvQ0RK3nYIyZPyWizlVFtXLy9cMQjkiOFp6JcuHo2EAfd2YBiHxmE+r3XHgaV5NHAwiIwIAJr0xub23001ETyf0jXR/uLjvtKKpNPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyFHfzLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyFHfzLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5EDC4CEC5;
	Sun,  6 Oct 2024 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728205620;
	bh=JDcqnQNF8JJFhiKpQYt3uez/euJmc6ELDxIoi1C3h3E=;
	h=From:To:Cc:Subject:Date:From;
	b=XyFHfzLFLpq4bSmUt+b7c8yelZfw63WP++muuxzTCWall+wqU9VqjK4ilzH+/s+i+
	 wEKB6Lb2m6bp522z9LayGMBtIjAwo+EF8WVsLLZGZuf3ZL1/y/QKnX3EeXvs+tNCyy
	 ZFZco2qoBRfrACfLO1kz4NSL7MVTdnsh1vOiSbfG3McuCs+obDqVhKjMdPfY0Ylvhq
	 IlwVDKtG5rNUYuu83o1wRdNMhWg7+4X95Lc6fMnmJZCgk6JGX+5aGbjo88WddKFnWf
	 eN+XDlc8IQ+3bdiRJgRHzgNvteQ8ghPN+iX3dPTuRK2utN6ue4AEkt2YSLiLIgjh4N
	 BUQFGCwaYy1jg==
Received: by pali.im (Postfix)
	id 03D7581A; Sun,  6 Oct 2024 11:06:53 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Add support for parsing WSL-style symlinks
Date: Sun,  6 Oct 2024 11:05:48 +0200
Message-Id: <20241006090548.30053-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux CIFS client currently does not implement readlink() for WSL-style
symlinks. It is only able to detect that file is of WSL-style symlink, but
is not able to read target symlink location.

Add this missing functionality and implement support for parsing content of
WSL-style symlink.

The important note is that symlink target location stored for WSL symlink
reparse point (IO_REPARSE_TAG_LX_SYMLINK) is in UTF-8 encoding instead of
UTF-16 (which is used in whole SMB protocol and also in all other symlink
styles). So for proper locale/cp support it is needed to do conversion from
UTF-8 to local_nls.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 49 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h |  9 ++++++++
 2 files changed, 58 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a577b2d2a4fc..6e9d914bac41 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -875,6 +875,52 @@ static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
 					 cifs_sb);
 }
 
+static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf,
+				     struct cifs_sb_info *cifs_sb,
+				     struct cifs_open_info_data *data)
+{
+	int len = le16_to_cpu(buf->ReparseDataLength);
+	int symname_utf8_len;
+	__le16 *symname_utf16;
+	int symname_utf16_len;
+
+	if (len <= sizeof(buf->Flags)) {
+		cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
+		return -EIO;
+	}
+
+	/* PathBuffer is in UTF-8 but without trailing null-term byte */
+	symname_utf8_len = len - sizeof(buf->Flags);
+	/*
+	 * Check that buffer does not contain null byte
+	 * because Linux cannot process symlink with null byte.
+	 */
+	if (strnlen(buf->PathBuffer, symname_utf8_len) != symname_utf8_len) {
+		cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
+		return -EIO;
+	}
+	symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
+	if (!symname_utf16)
+		return -ENOMEM;
+	symname_utf16_len = utf8s_to_utf16s(buf->PathBuffer, symname_utf8_len,
+					    UTF16_LITTLE_ENDIAN,
+					    symname_utf16, symname_utf8_len * 2);
+	if (symname_utf16_len < 0) {
+		kfree(symname_utf16);
+		return symname_utf16_len;
+	}
+	symname_utf16_len *= 2; /* utf8s_to_utf16s() returns number of u16 items, not byte length */
+
+	data->symlink_target = cifs_strndup_from_utf16((u8 *)symname_utf16,
+						       symname_utf16_len, true,
+						       cifs_sb->local_nls);
+	kfree(symname_utf16);
+	if (!data->symlink_target)
+		return -ENOMEM;
+
+	return 0;
+}
+
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			const char *full_path,
@@ -894,6 +940,9 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			(struct reparse_symlink_data_buffer *)buf,
 			plen, unicode, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_LX_SYMLINK:
+		return parse_reparse_wsl_symlink(
+			(struct reparse_wsl_symlink_data_buffer *)buf,
+			cifs_sb, data);
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c769f9dbc0b4..275184c31a89 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1552,6 +1552,15 @@ struct reparse_symlink_data_buffer {
 
 /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
 
+/* For IO_REPARSE_TAG_LX_SYMLINK */
+struct reparse_wsl_symlink_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le32	Flags;
+	__u8	PathBuffer[]; /* Variable Length UTF-8 string without nul-term */
+} __packed;
+
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
-- 
2.20.1

