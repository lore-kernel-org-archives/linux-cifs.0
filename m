Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446B83D090E;
	Mon,  6 Jul 2026 18:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363736; cv=none; b=luuIY/eJfqyTFMG15bZ7nw0HYbiCED1GZB4lPxU9Sv83jVbI/v91PNY+AZriUgAGs92VaS19nT8c1u+v/TPaJNjVPl++scCCH5gnSmlP7TDfroe0v2lBp1Lgdsft6wzkZRcvbxwNvnymuLek1luboMLFpCxWFekz6wRmRIrD5fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363736; c=relaxed/simple;
	bh=dkaZ1zX19B+i6UCCJgDytE9D+aVDWdQRI12wFvv8XyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lyoB7j2nCppwjd7UTEmvOpa5ixTooeiVI0dveN5T1oo3rIhAMukLqDVrxrrHYlkLMTHVholOhm+aykCWxsjfKxJpLnNqL1uE7xm9LYN1q+E9Efq8hhsv3K/gdTquocj0P6iWP9OEiWBET/s8PMAjoe7jnwuI3IptDPHwoXPEqYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPBCHIS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPBCHIS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27BA1F01558;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363719;
	bh=JL6jnxiY9Nv6KWmHoBYibi6LDsYgWLWGNyfiHnQZT2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPBCHIS2/1TcDF+usu/99qWXpJh1EHqwYDcKp9EmfV7EtdJQIB0xn1c5JizQDjvuV
	 BDzI0mNpxN9Ok0eUEapExO6ra4UcRjY/ykeM1UO7OKjDWz2c/f9GSxReM8/CWLZc+F
	 GndBq9TOgDLPbZXE9MsZxh3IUGkGxKOmXbc7c32AzSCkwnn2wwUDnxev0p/UYngJkP
	 smX+bCCNk1fQYyUbaI1uMd+DFrJ94Gth7nh6gCW2H0or+2FOos7RhBtlR9zjJtgUVK
	 1HFi0ZV0hWqZisZoUA1WI7ZCbzarrD9kG4UCfa+RJOLYvXJmvihBQhVnF9HRffRFi5
	 vaOJEa8rm3MOw==
Received: by pali.im (Postfix)
	id E73791101; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 11/11] cifs: Add support for creating WSL symlinks in version 1 format
Date: Mon,  6 Jul 2026 20:48:19 +0200
Message-Id: <20260706184819.22124-12-pali@kernel.org>
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

Add a new mount option -o symlink=wsl1 which cause that all newly created
symlinks would be of WSL style in layout version 1 format. This type of
symlinks is supported by all WSL versions.

Existing mount option -o symlink=wsl will be now an alias to -o
symlink=wsl2 which creates symlinks in layour version 2 format.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   |  9 +++--
 fs/smb/client/fs_context.c | 11 ++++--
 fs/smb/client/fs_context.h |  3 +-
 fs/smb/client/link.c       |  3 +-
 fs/smb/client/reparse.c    | 73 ++++++++++++++++++++++++++++++++------
 5 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 36a2e807f1c9..ca6f1be8e7d4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -190,7 +190,8 @@ enum cifs_symlink_type {
 	CIFS_SYMLINK_TYPE_MFSYMLINKS,
 	CIFS_SYMLINK_TYPE_SFU,
 	CIFS_SYMLINK_TYPE_NFS,
-	CIFS_SYMLINK_TYPE_WSL,
+	CIFS_SYMLINK_TYPE_WSL1,
+	CIFS_SYMLINK_TYPE_WSL2,
 };
 
 static inline const char *cifs_symlink_type_str(enum cifs_symlink_type type)
@@ -208,8 +209,10 @@ static inline const char *cifs_symlink_type_str(enum cifs_symlink_type type)
 		return "sfu";
 	case CIFS_SYMLINK_TYPE_NFS:
 		return "nfs";
-	case CIFS_SYMLINK_TYPE_WSL:
-		return "wsl";
+	case CIFS_SYMLINK_TYPE_WSL1:
+		return "wsl1";
+	case CIFS_SYMLINK_TYPE_WSL2:
+		return "wsl2";
 	default:
 		return "unknown";
 	}
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index abc29500a664..3e8e4b43690a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -376,7 +376,9 @@ static const match_table_t symlink_flavor_tokens = {
 	{ Opt_symlink_mfsymlinks,	"mfsymlinks" },
 	{ Opt_symlink_sfu,		"sfu" },
 	{ Opt_symlink_nfs,		"nfs" },
-	{ Opt_symlink_wsl,		"wsl" },
+	{ Opt_symlink_wsl1,		"wsl1" },
+	{ Opt_symlink_wsl2,		"wsl2" },
+	{ Opt_symlink_wsl2,		"wsl" }, /* wsl - alias for wsl2 */
 	{ Opt_symlink_err,		NULL },
 };
 
@@ -407,8 +409,11 @@ static int parse_symlink_flavor(struct fs_context *fc, char *value,
 	case Opt_symlink_nfs:
 		ctx->symlink_type = CIFS_SYMLINK_TYPE_NFS;
 		break;
-	case Opt_symlink_wsl:
-		ctx->symlink_type = CIFS_SYMLINK_TYPE_WSL;
+	case Opt_symlink_wsl1:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_WSL1;
+		break;
+	case Opt_symlink_wsl2:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_WSL2;
 		break;
 	default:
 		cifs_errorf(fc, "bad symlink= option: %s\n", value);
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index a80a5caff23c..56bbb20a30a3 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -72,7 +72,8 @@ enum cifs_symlink_parm {
 	Opt_symlink_mfsymlinks,
 	Opt_symlink_sfu,
 	Opt_symlink_nfs,
-	Opt_symlink_wsl,
+	Opt_symlink_wsl1,
+	Opt_symlink_wsl2,
 	Opt_symlink_err
 };
 
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index dd127917a340..4c61d6b64cae 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -613,7 +613,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
-	case CIFS_SYMLINK_TYPE_WSL:
+	case CIFS_SYMLINK_TYPE_WSL1:
+	case CIFS_SYMLINK_TYPE_WSL2:
 		if (CIFS_REPARSE_SUPPORT(pTcon)) {
 			rc = create_reparse_symlink(xid, inode, direntry, pTcon,
 						    full_path, symname);
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 0402a30d0d53..3418e4b66022 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -22,7 +22,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
 		     const char *full_path, umode_t mode, dev_t dev,
-		     const char *symname);
+		     const char *symname, int symver);
 
 static int create_native_symlink(const unsigned int xid, struct inode *inode,
 				 struct dentry *dentry, struct cifs_tcon *tcon,
@@ -43,8 +43,10 @@ int create_reparse_symlink(const unsigned int xid, struct inode *inode,
 		return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
 	case CIFS_SYMLINK_TYPE_NFS:
 		return mknod_nfs(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
-	case CIFS_SYMLINK_TYPE_WSL:
-		return mknod_wsl(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
+	case CIFS_SYMLINK_TYPE_WSL1:
+		return mknod_wsl(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname, 1);
+	case CIFS_SYMLINK_TYPE_WSL2:
+		return mknod_wsl(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname, 2);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -539,6 +541,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 
 static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
 			       mode_t mode, const char *symname,
+			       int symver,
 			       struct cifs_sb_info *cifs_sb,
 			       struct kvec *iov)
 {
@@ -574,15 +577,20 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
 			kfree(symname_utf16);
 			return -ENOMEM;
 		}
-		/* Version field must be set to 2 (MS-FSCC 2.1.2.7) */
-		symlink_buf->Version = cpu_to_le32(2);
-		/* Target for Version 2 is in UTF-8 but without trailing null-term byte */
+		symlink_buf->Version = cpu_to_le32(symver);
+		/* Target is in UTF-8 but without trailing null-term byte */
 		symname_utf8_len = utf16s_to_utf8s((wchar_t *)symname_utf16, symname_utf16_len/2,
 						   UTF16_LITTLE_ENDIAN,
 						   symlink_buf->Target,
 						   symname_utf8_maxlen);
 		*buf = (struct reparse_data_buffer *)symlink_buf;
-		buf_len = sizeof(struct reparse_wsl_symlink_data_buffer) + symname_utf8_len;
+		buf_len = sizeof(struct reparse_wsl_symlink_data_buffer);
+		/*
+		 * Layout version 2 stores the symlink target in the reparse point buffer.
+		 * Layout version 1 stores the symlink target in the data section of the file.
+		 */
+		if (symver == 2)
+			buf_len += symname_utf8_len;
 		kfree(symname_utf16);
 		break;
 	default:
@@ -683,7 +691,7 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
 		     const char *full_path, umode_t mode, dev_t dev,
-		     const char *symname)
+		     const char *symname, int symver)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_open_info_data data;
@@ -692,6 +700,12 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	struct inode *new;
 	unsigned int len;
 	struct kvec reparse_iov, xattr_iov;
+	struct cifs_open_parms oparms;
+	struct cifs_io_parms io_parms;
+	unsigned int bytes_written;
+	struct kvec symv1_iov[2];
+	struct cifs_fid fid;
+	__u32 oplock;
 	int rc;
 
 	/*
@@ -701,7 +715,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
 		return -EOPNOTSUPP;
 
-	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
+	rc = wsl_set_reparse_buf(&buf, mode, symname, symver, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
 
@@ -726,6 +740,45 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 				     &data, inode->i_sb,
 				     xid, tcon, full_path, false,
 				     &reparse_iov, &xattr_iov);
+	if (!IS_ERR(new) && mode == S_IFLNK && symver == 1) {
+		/*
+		 * WSL symlink layout version 1 stores the symlink target
+		 * location into the data section of the file.
+		 * Store it now after the reparse point file was created.
+		 * The target location was allocated into the buf but iov
+		 * size filled in reparse_iov by wsl_set_reparse_buf() was
+		 * set to smaller so the created reparse point does not
+		 * contain it.
+		 */
+		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
+				     FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+				     ACL_NO_MODE);
+		oparms.fid = &fid;
+		oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
+		rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
+		if (!rc) {
+			symv1_iov[1].iov_base = ((struct reparse_wsl_symlink_data_buffer *)buf)->Target;
+			symv1_iov[1].iov_len = strlen((const char *)symv1_iov[1].iov_base);
+			io_parms = (struct cifs_io_parms) {
+				.netfid = fid.netfid,
+				.pid = current->tgid,
+				.tcon = tcon,
+				.offset = 0,
+				.length = symv1_iov[1].iov_len,
+			};
+			rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
+								&bytes_written,
+								symv1_iov,
+								ARRAY_SIZE(symv1_iov)-1);
+			if (bytes_written != symv1_iov[1].iov_len)
+				rc = -EIO;
+			tcon->ses->server->ops->close(xid, tcon, &fid);
+		}
+		if (rc) {
+			tcon->ses->server->ops->unlink(xid, tcon, full_path, cifs_sb, NULL);
+			new = ERR_PTR(rc);
+		}
+	}
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -749,7 +802,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
 	case CIFS_REPARSE_TYPE_NFS:
 		return mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
 	case CIFS_REPARSE_TYPE_WSL:
-		return mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
+		return mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev, NULL, 0);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

