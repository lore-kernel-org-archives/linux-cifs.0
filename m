Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5C17839E;
	Sun,  6 Oct 2024 10:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208873; cv=none; b=elwDZ+OxfotexymjiGIbeqZGRp+RAvmFwMIaIsdLwl+JkELbfPnhU5TSzu/CjpVW4OVQ4TFAY2RIZrPdGoVySZTYAAMhdprRfJ9ZMS5xB1rESOOP6nbXr6WFl8hlbTwO9JVipvNPBTinwjJ/T6GxOKjgvzZldG8ZYi+j9dW+qiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208873; c=relaxed/simple;
	bh=kOEasaYZhqGKSFx9kxpk6Zl3ATmAw3rrmXbQDYZOl90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emqvmY0+j5aT/QE2LrYWUoPYOf3/8g8MuSKv/wfvp9gbJiT6ZiCgPTGGHg71DV1t5+KMEaw6HCPmuWR3C0WBXETeHsSvosEUceosYr1aJeXlKvtnPJ3bVgj1XUBvp6ymgODIE6ExKNc5c9S8eq4aO6D2bs0SCTtDJdwQ0jZJfJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlxGLgFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlxGLgFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E980C4CEC5;
	Sun,  6 Oct 2024 10:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208872;
	bh=kOEasaYZhqGKSFx9kxpk6Zl3ATmAw3rrmXbQDYZOl90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlxGLgFY/LxlnoWpD8k6vPI0CvZBEebvwDUYYlidbU/BHWT4tZJfN4E43eU07/V9f
	 ldRt+YxKNyEdf/t/Ui635qwIGj1eCTigWUMW6N107+grJxxSKb5gNJLhqs3n+uk+FX
	 yJnRV4LzJK2hfguR115T+908prm903zEsrqt0Stel6Z/vim+QzYiX64nS3r7SOS3gK
	 c1HTIzXFl60nl3SMXuQrUKL0XDHfwOvUWq92lHzh4EdgBbU6XLIQHQzgiEaG3jg3Vm
	 FpN8n7FOXEQYkpmwFl0ZEQYahtQBZwl7vMj/qdZOuj1/tLbyZMO1bwKarRClhAs6jz
	 wc+swRFi+tq2Q==
Received: by pali.im (Postfix)
	id CECB5C84; Sun,  6 Oct 2024 12:01:02 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] cifs: Add support for creating NFS-style symlinks
Date: Sun,  6 Oct 2024 12:00:43 +0200
Message-Id: <20241006100046.30772-5-pali@kernel.org>
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

CIFS client is currently able to parse NFS-style symlinks, but is not able
to create them. This functionality is useful when the mounted SMB share is
used also by Windows NFS server (on Windows Server 2012 or new). It allows
interop of symlinks between SMB share mounted by Linux CIFS client and same
export from Windows NFS server mounted by some NFS client.

New symlinks would be created in NFS-style only in case the mount option
-o reparse=nfs is specified, which is not by default. So default CIFS
mounts are not affected by this change.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 47 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index f1488f870320..41f91613e7f2 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -410,6 +410,8 @@ static int create_native_socket(const unsigned int xid, struct inode *inode,
 
 static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 			       mode_t mode, dev_t dev,
+			       __le16 *symname_utf16,
+			       int symname_utf16_len,
 			       struct kvec *iov)
 {
 	u64 type;
@@ -420,13 +422,18 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	switch ((type = reparse_mode_nfs_type(mode))) {
 	case NFS_SPECFILE_BLK:
 	case NFS_SPECFILE_CHR:
-		dlen = sizeof(__le64);
+		dlen = 2 * sizeof(__le32);
+		((__le32 *)buf->DataBuffer)[0] = MAJOR(dev);
+		((__le32 *)buf->DataBuffer)[1] = MINOR(dev);
+		break;
+	case NFS_SPECFILE_LNK:
+		dlen = symname_utf16_len;
+		memcpy(buf->DataBuffer, symname_utf16, symname_utf16_len);
 		break;
 	case NFS_SPECFILE_FIFO:
 	case NFS_SPECFILE_SOCK:
 		dlen = 0;
 		break;
-	case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -436,8 +443,6 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	buf->InodeType = cpu_to_le64(type);
 	buf->ReparseDataLength = cpu_to_le16(len + dlen -
 					     sizeof(struct reparse_data_buffer));
-	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) << 32) |
-						 MAJOR(dev));
 	iov->iov_base = buf;
 	iov->iov_len = len + dlen;
 	return 0;
@@ -448,21 +453,42 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 		     const char *full_path, umode_t mode, dev_t dev,
 		     const char *symname)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_open_info_data data;
-	struct reparse_posix_data *p;
+	struct reparse_posix_data *p = NULL;
+	__le16 *symname_utf16 = NULL;
+	int symname_utf16_len = 0;
 	struct inode *new;
 	struct kvec iov;
 	__u8 buf[sizeof(*p) + sizeof(__le64)];
 	int rc;
 
-	p = (struct reparse_posix_data *)buf;
-	rc = nfs_set_reparse_buf(p, mode, dev, &iov);
+	if (S_ISLNK(mode)) {
+		symname_utf16 = cifs_strndup_to_utf16(symname, strlen(symname),
+						      &symname_utf16_len,
+						      cifs_sb->local_nls,
+						      NO_MAP_UNI_RSVD);
+		if (!symname_utf16) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		symname_utf16_len -= 2; /* symlink is without trailing wide-nul */
+		p = kzalloc(sizeof(*p) + symname_utf16_len, GFP_KERNEL);
+		if (!p) {
+			rc = -ENOMEM;
+			goto out;
+		}
+	} else {
+		p = (struct reparse_posix_data *)buf;
+	}
+	rc = nfs_set_reparse_buf(p, mode, dev, symname_utf16, symname_utf16_len, &iov);
 	if (rc)
-		return rc;
+		goto out;
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
 		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+		.symlink_target = kstrdup(symname, GFP_KERNEL),
 	};
 
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
@@ -472,6 +498,11 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 	else
 		rc = PTR_ERR(new);
 	cifs_free_open_info(&data);
+out:
+	if (S_ISLNK(mode)) {
+		kfree(symname_utf16);
+		kfree(p);
+	}
 	return rc;
 }
 
-- 
2.20.1

