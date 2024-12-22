Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F5619068E;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734888268; cv=none; b=PfvvB5Jv6vSpvJszvVQOgskLZkQDunHnk0Zo7mU5ixg9VI3mILEELJWqDeTQ0tM8w3+nh1u2wxRXulCnx4sLvJwYWn43cyl6AnhJsZCx/hPjc+157h9xbDoa+U47gnfYef9JuGjbFJMFqAzLFa6rhqma53tolYtpV87idBQp15A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734888268; c=relaxed/simple;
	bh=WJK7TY5E0PYn0ZjBtJv7A7+wKin7P2WriV5KcJ0M7wI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDygbBnziwtMfasdWz85rShZb8lEyA3NuThITE+LGMn2CuXYiOuGFjbW1E6KLM3uToa83A2czyGUImwEAvQ2o48KcyeaibiqkUB5GTh0JPVdygJ+PbSIDc42wyUToRfEoX/l2dBNokXcB0p5qSWjQbUGoOckpSEOPpihT5U1Sq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku0M9Pjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku0M9Pjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379C2C4CEDC;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734888267;
	bh=WJK7TY5E0PYn0ZjBtJv7A7+wKin7P2WriV5KcJ0M7wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ku0M9PjtDm2y1KBc5U9oR2mll+PMczTz99Fvfu7WeF4TJD3sE6eyxByvWOHk+KBPi
	 H/vwYk4j+vIvFBGwVbV7ZYt8pFbAHHf5/3HsGoEsjX6IiqUkuojjkkxZb27KpICHA3
	 yJfy5sSnPV1kwruoBCI+LVepDeQqaODuCmlbiWGfgwdSt81ZSd6LP+jOEdXV0XW9kt
	 DUE1u2qOWQSIGqmCp18ZOmjBJVUOzjG2dnEHHQK3z3K2hMN0Q8JHcXs813L0hIGBOf
	 Q/U1UrQpfzKZk4rJs3A4br4VnpAcyUWQoIY4CGOoJMil5js86bkoB6HmTaJdfXbkhN
	 U+2yuOqN0OKSA==
Received: by pali.im (Postfix)
	id ABD3ED48; Sun, 22 Dec 2024 18:24:17 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cifs: Rename struct reparse_posix_data to reparse_nfs_data_buffer and move to common/smb2pdu.h
Date: Sun, 22 Dec 2024 18:24:04 +0100
Message-Id: <20241222172404.24755-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222172404.24755-1-pali@kernel.org>
References: <20241222172404.24755-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function parse_reparse_posix() parses NFS-style reparse points, which are
used only by Windows NFS server since Windows Server 2012 version. This
style is not understood by Microsoft POSIX/Interix/SFU/SUA subsystems.

So make it clear that parse_reparse_posix() function and reparse_posix_data
structure are not POSIX general, but rather NFS specific.

All reparse buffer structures are defined in common/smb2pdu.h and have
_buffer suffix. So move struct reparse_posix_data from client/cifspdu.h to
common/smb2pdu.h and rename it to reparse_nfs_data_buffer for consistency.
Note that also SMB specification in [MS-FSCC] document, section 2.1.2.6
defines it under name "Network File System (NFS) Reparse Data Buffer".
So use this name for consistency.

Having this structure in common/smb2pdu.h can be useful for ksmbd server
code as NFS-style reparse points is the preferred way for implementing
support for special files.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h | 14 --------------
 fs/smb/client/reparse.c | 12 ++++++------
 fs/smb/common/smb2pdu.h | 14 +++++++++++++-
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 2a29fa31c927..f4c348b5c4f1 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1485,20 +1485,6 @@ struct file_notify_information {
 	__u8  FileName[];
 } __attribute__((packed));
 
-/* For IO_REPARSE_TAG_NFS */
-#define NFS_SPECFILE_LNK	0x00000000014B4E4C
-#define NFS_SPECFILE_CHR	0x0000000000524843
-#define NFS_SPECFILE_BLK	0x00000000004B4C42
-#define NFS_SPECFILE_FIFO	0x000000004F464946
-#define NFS_SPECFILE_SOCK	0x000000004B434F53
-struct reparse_posix_data {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le64	InodeType; /* LNK, FIFO, CHR etc. */
-	__u8	DataBuffer[];
-} __attribute__((packed));
-
 struct cifs_quota_data {
 	__u32	rsrvd1;  /* 0 */
 	__u32	sid_size;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 40070e99fc8a..9fe9dd71a6fa 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -407,7 +407,7 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
+static int nfs_set_reparse_buf(struct reparse_nfs_data_buffer *buf,
 			       mode_t mode, dev_t dev,
 			       __le16 *symname_utf16,
 			       int symname_utf16_len,
@@ -454,7 +454,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_open_info_data data;
-	struct reparse_posix_data *p = NULL;
+	struct reparse_nfs_data_buffer *p = NULL;
 	__le16 *symname_utf16 = NULL;
 	int symname_utf16_len = 0;
 	struct inode *new;
@@ -478,7 +478,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 			goto out;
 		}
 	} else {
-		p = (struct reparse_posix_data *)buf;
+		p = (struct reparse_nfs_data_buffer *)buf;
 	}
 	rc = nfs_set_reparse_buf(p, mode, dev, symname_utf16, symname_utf16_len, &iov);
 	if (rc)
@@ -716,7 +716,7 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 }
 
 /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
-static int parse_reparse_posix(struct reparse_posix_data *buf,
+static int parse_reparse_nfs(struct reparse_nfs_data_buffer *buf,
 			       struct cifs_sb_info *cifs_sb,
 			       struct cifs_open_info_data *data)
 {
@@ -1069,7 +1069,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	/* See MS-FSCC 2.1.2 */
 	switch (le32_to_cpu(buf->ReparseTag)) {
 	case IO_REPARSE_TAG_NFS:
-		return parse_reparse_posix((struct reparse_posix_data *)buf,
+		return parse_reparse_nfs((struct reparse_nfs_data_buffer *)buf,
 					   cifs_sb, data);
 	case IO_REPARSE_TAG_SYMLINK:
 		return parse_reparse_native_symlink(
@@ -1165,7 +1165,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_fattr *fattr,
 				   struct cifs_open_info_data *data)
 {
-	struct reparse_posix_data *buf = (struct reparse_posix_data *)data->reparse.buf;
+	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
 
 	if (buf == NULL)
 		return true;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 3c7c706c797d..3336df2ea5d4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1550,7 +1550,19 @@ struct reparse_symlink_data_buffer {
 	__u8	PathBuffer[]; /* Variable Length */
 } __packed;
 
-/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
+/* For IO_REPARSE_TAG_NFS - see MS-FSCC 2.1.2.6 */
+#define NFS_SPECFILE_LNK	0x00000000014B4E4C
+#define NFS_SPECFILE_CHR	0x0000000000524843
+#define NFS_SPECFILE_BLK	0x00000000004B4C42
+#define NFS_SPECFILE_FIFO	0x000000004F464946
+#define NFS_SPECFILE_SOCK	0x000000004B434F53
+struct reparse_nfs_data_buffer {
+	__le32	ReparseTag;
+	__le16	ReparseDataLength;
+	__u16	Reserved;
+	__le64	InodeType; /* NFS_SPECFILE_* */
+	__u8	DataBuffer[];
+} __packed;
 
 /* For IO_REPARSE_TAG_LX_SYMLINK */
 struct reparse_wsl_symlink_data_buffer {
-- 
2.20.1

