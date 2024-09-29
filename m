Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BF664A8F;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=u5x3zdpGqT/RrmQfGhPJRrXxdZdL3Lqtgsrylo1Wfvslry/rf7q2cCcBJMAcKNzSl/ULC4bqJXjwwzx7y9ca+zZXlqxTQLqHWPsU6IJQwmBdaJ58lx4kgUJeofxl3JY9YTL5CgHVbheWF71Kf+yOpVwfBvWzZTpqbnhhOsG0XMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=8lNwbhZLqMkizGfxdOcD83bcxKPbRqUTAFdELuazLtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crpikpo3x7DMYlu+wWRnEbQUHIk9joFWXmgu5bLvA6s1NaNj3rTgykydSa7rcX4TXIUY8Ul/pJdq90Zb2mx/pWg2XeIOoH2SwMeHubmmMD2bXwoocxQ00YBNrAiOAWfkPF1640tA62j0Rhr4TRwbN169Qy7FNCetXpxf4iYK3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvPJjVis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvPJjVis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B10C4CECF;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635864;
	bh=8lNwbhZLqMkizGfxdOcD83bcxKPbRqUTAFdELuazLtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvPJjViseUcxI6RNmcu+wGfrWuisuQ1FW98/TT6uIwXnABQr+hI7Z2VNM9szrr1L3
	 oLVb4CCKN89vMQrtzW5MIFdUQaJBSxYX3QIuyScMWuD48ZBh65LNKoMx9BrCcu5+cH
	 a4hqd1yk1DDXN+WfP4l+uH5kf86TQTXlnFvf9nHe1xgp7/v4OioPV0LBw+ZWDrG+lM
	 VCRIZCezH7ixR3Eq+WaNEpCCh+lEEv3I9c7iFaB6uUtn7sY5Bg68nPWEeF8ClFmnLj
	 xmtKWy13ILbdixCMqC5OoV3UP1Lntu5Ax0JrJ/rLc0JTlorm4/7tMIkL3vNhahRj0o
	 pfWkgNNEeUHRQ==
Received: by pali.im (Postfix)
	id BEA7CCB5; Sun, 29 Sep 2024 20:50:57 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] cifs: Fix parsing native symlinks directory/file type
Date: Sun, 29 Sep 2024 20:50:51 +0200
Message-Id: <20240929185053.10554-6-pali@kernel.org>
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

As SMB protocol distinguish between symlink to directory and symlink to
file, add some mechanism to disallow resolving incompatible types.

When SMB symlink is of the directory type, ensure that its target path ends
with slash. This forces Linux to not allow resolving such symlink to file.

And when SMB symlink is of the file type and its target path ends with
slash then returns an error as such symlink is unresolvable. Such symlink
always points to invalid location as file cannot end with slash.

This mimics Windows behavior of native SMB symlinks.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c   |  4 ++++
 fs/smb/client/smb2file.c  | 46 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2inode.c |  4 ++++
 fs/smb/client/smb2proto.h |  1 +
 4 files changed, 55 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index d8edb513556f..5a738f65b190 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -589,6 +589,10 @@ static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
 				       le32_to_cpu(sym->Flags) & SYMLINK_FLAG_RELATIVE,
 				       full_path,
 				       cifs_sb);
+	if (!rc) {
+		bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+		rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
+	}
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index dc52995f5591..8a1a1b2a1c81 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -63,6 +63,48 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 	return sym;
 }
 
+int smb2_fix_symlink_target_type(char **target, bool directory)
+{
+	char *buf;
+	int len = strlen(*target);
+
+	if (!len)
+		return -EIO;
+
+	/*
+	 * If this is directory symlink and it does not have trailing slash then
+	 * append it. Trailing slash simulates Windows/SMB behavior which do not
+	 * allow resolving directory symlink to file.
+	 */
+	if (directory && (*target)[len-1] != '/') {
+		buf = kzalloc(len+2, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		memcpy(buf, *target, len);
+		buf[len] = '/';
+		kfree(*target);
+		*target = buf;
+	}
+
+	/*
+	 * If this is a symlink which points to file name with trailing slash,
+	 * or to file named "." or file named ".." then this symlink cannot be
+	 * resolved on Linux because Linux does not allow files with such names.
+	 * So return an error to prevent resolving this file type symlink to
+	 * directory, as it do not point to directory at all.
+	 */
+	if (!directory) {
+		const char *basename = kbasename(*target);
+		int basename_len = strlen(basename);
+		if (basename_len == 0 || /* symname ends with slash */
+		    (basename_len == 1 && basename[0] == '.') || /* last component is "." */
+		    (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* last component is ".." */
+			return -EIO;
+	}
+
+	return 0;
+}
+
 int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
 				const char *full_path, char **path)
 {
@@ -132,6 +174,10 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 				rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data,
 					       NULL, NULL, NULL);
 				oparms->create_options &= ~OPEN_REPARSE_POINT;
+				if (!rc) {
+					bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+					rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
+				}
 			}
 		}
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c9cdac7d2d50..faf0a8344faa 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      &oparms, in_iov, cmds, num_cmds,
 				      cfile, NULL, NULL, NULL);
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
+			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory);
+		}
 		break;
 	case -EREMOTE:
 		break;
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 11cef65fa831..d308f3c2f8df 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
 			  const unsigned char *path, char *pbuf,
 			  unsigned int *pbytes_read);
+int smb2_fix_symlink_target_type(char **target, bool directory);
 int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			      bool unicode, bool relative,
 			      const char *full_path,
-- 
2.20.1

