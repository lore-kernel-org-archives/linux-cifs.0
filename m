Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73311386DA;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137030; cv=none; b=QAZkuOBigNrIOJG6jcpHPIwl44aJHRoFFZBq0RQxyOilgzpWMNmThzb67ZTK+mu6skZ8CVdQcmLX5PjFvt++/62Urz8xim3JaLIxaWWDckSgpp8NH9zAA0k94KqCSE4NsogScAmagJ7Ftq79r52PuVLtaXpD0z8pCgPqykhrErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137030; c=relaxed/simple;
	bh=hck5M9wUtffvOEh9wksTxAhJ0N0lXGbIC6gxgJiS+hQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYyxZJlRFP2nVEUJ2UzateqARWvpFK95NaiLVIipYLNzqHvQUxMCxAM76qLf08XrdRypVSEuUPm+mRQqV/VKrsPnrrD/7rL8AnUT5dPtZMeGWgSrKmgrupyyWw3Jq8PLe09i9veb0xTQIe0jCXVXKOvCW4fZPdRAq6fKST21iYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJQHR4BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJQHR4BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66089C4CED1;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=hck5M9wUtffvOEh9wksTxAhJ0N0lXGbIC6gxgJiS+hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJQHR4BY3S1Pp4nP3vbtIOI9l2NkGfVVxAT6/y6d1lrp9DKvD2CfnVAPKUVr765Q+
	 tCzUmJYkhLmfSIl1uk3y4VrMpMxmpXrXjE7nnzT3x6EzMgxc4MRUUbgdVPR25XBm74
	 fjl3SsmHa2yuXnvoxN834oBPCFrq1M5gRX/IpDHl/6bzVE0sgoE8zgsjn+YmzmHODG
	 qFQHNoH29E4sdrX+rwfGJw7b5TCI59zjbhiOk/xOBzs9tNsD2kO0g91a978EexjhDf
	 Y+ImCTruKzBUPl83hFBdZAxvw4CSn+PaRhgRHl+26R7UGW6eV1PqyF+oefkh0F5YrD
	 CQqNDtJBfDwjQ==
Received: by pali.im (Postfix)
	id 37086B64; Sat,  5 Oct 2024 16:03:43 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] cifs: Fix parsing native symlinks directory/file type
Date: Sat,  5 Oct 2024 16:02:58 +0200
Message-Id: <20241005140300.19416-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005140300.19416-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
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

As POSIX server does not distinguish between symlinks to file and symlink
directory, do not apply this change for symlinks from POSIX SMB server. For
POSIX SMB servers, this change does nothing.

This mimics Windows behavior of native SMB symlinks.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c     |  5 ++++
 fs/smb/client/smb2file.c  | 55 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2inode.c |  4 +++
 fs/smb/client/smb2proto.h |  1 +
 4 files changed, 65 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0fe54b2d2561..aa38a3935f8f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1110,6 +1110,11 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 							      full_path,
 							      iov, data);
 		}
+
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
+			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
+		}
 		break;
 	}
 
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index dc52995f5591..149449d9c1c0 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -63,6 +63,56 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 	return sym;
 }
 
+int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb)
+{
+	char *buf;
+	int len;
+
+	/*
+	 * POSIX server does not distinguish between symlinks to file and
+	 * symlink directory. So nothing is needed to fix on the client side.
+	 */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+		return 0;
+
+	len = strlen(*target);
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
+		    (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* or ".." */
+			return -EIO;
+	}
+
+	return 0;
+}
+
 int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec *iov,
 				const char *full_path, char **path)
 {
@@ -133,6 +183,11 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 					       NULL, NULL, NULL);
 				oparms->create_options &= ~OPEN_REPARSE_POINT;
 			}
+			if (!rc) {
+				bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+				rc = smb2_fix_symlink_target_type(&data->symlink_target,
+								  directory, oparms->cifs_sb);
+			}
 		}
 	}
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 9a28a30ec1a3..06bb6f7fbf0f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      &oparms, in_iov, cmds, num_cmds,
 				      cfile, NULL, NULL, NULL);
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
+			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
+			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
+		}
 		break;
 	case -EREMOTE:
 		break;
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index aa01ae234732..1828b825c7d3 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
 			  const unsigned char *path, char *pbuf,
 			  unsigned int *pbytes_read);
+int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_info *cifs_sb);
 int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			      bool unicode, bool relative,
 			      const char *full_path,
-- 
2.20.1

