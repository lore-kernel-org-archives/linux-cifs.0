Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=C1oXhZ+WTIyiyc3LE7b4ul+VcFWsoytRj2DvuCY7iiS1HRxuOnpDDoQ5g8kOgNkOjxSJ
	 Ia4mKhlIih0d8gXLUGd7KRBmrpZwI+cRDzmIfeUx78Owr5+IEGPGFOEfoI0spI0EIUbXi
	 SYXooaSVyQ+Ye+j7L7YWiYlVqQNTNYhOAIMT5s/1yHqh8d0u2MhsWwCb/pHwk9+zTqBEC
	 pULe78BB1x3sq1mTJA3V32Dwb1pQttNLbqklUS6rz50hrtL0mLXCbDpgKiVFqe/fLDzPz
	 BM6FdkLWjy40nyZHjNsnG19UyMWCF0bmgNREay1AV+sEeRE4765dFGugx1CtpnBLpsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZHvaWtNSF66Lh7HeuZ/XTf34+bd7VMRO/0S5MpgBnZQ=;
	b=TfNjqSVPOv9d8mYXqGnWI1IY9XQk94QkfE9Lg+VLSFsDa8Fcv+fysnbWDC4gE9RHdSgE
	 6EmtlCQRUizwlGCh85DX2yhv6TIB/yCjP6+o+LvpaegaRgfdiIPfafGGqQY+JKy6OsOPU
	 Q3v03mRhTVafuW8ZeSMeUWII2hy1z63Lv973DYtrsrvkayFFKxOqpNvPBwE6TiTDOR/sU
	 FgbYdkc/XMAEB4P9tNd4lPtYJhzyOATKecThfKINI1AkMQI7i4U85O6pBllcgLcPDfy3+
	 JvxF7BD3Jv5W98LCzmvsGcxWMcWqZ1xDP9ngvm16PQoaCzzAXGLfnIIdQHL1grZQvjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfxQ8Qsy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F82606A32E;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfxQ8Qsy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257301F01825;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053574;
	bh=ZHvaWtNSF66Lh7HeuZ/XTf34+bd7VMRO/0S5MpgBnZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfxQ8QsyEsi4tITS42ADpzqcHkc3JqxDkWZlJqkjBfz8ozZFG4AecksBfwMuDDqln
	 cW8GNpQY6qXu/Zk3yl207lAuly1itV2PKV4Q5p8mk4vpkn2sUE5Cdln6lBa0pnBH+C
	 nRuT9bX1y5t6QgAgfQhDO7OBXNek18zFE1Hw+Qgodmh8weVIlXBz4cgmOTqKIdL4ju
	 A+DUV2x3bnaFbqeuKx0ITPoK5rvjwLBuLAfUwdaILmByNdDZG11D9ergkNGBgYN7Bs
	 PqTUNMd1Y62jgwrXfUSTuOe9LuPcfKFErfvFcauqZxxwIlv/2umeAlfO2cukKjGinV
	 H/ze9uZVRSTjQ==
Received: by pali.im (Postfix)
	id 1F54A1390; Mon, 26 Oct 2026 23:26:11 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 9/9] cifs: Add support for creating WSL symlinks in version 1 format
Date: Mon, 26 Oct 2026 23:26:00 +0100
Message-Id: <20261026222600.17323-10-pali@kernel.org>
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

Add a new mount option -o symlink=wsl1 which cause that all newly created
symlinks would be of WSL style in layout version 1 format. This type of
symlinks is supported by all WSL versions.

Existing mount option -o symlink=wsl will be now an alias to -o
symlink=wsl2 which creates symlinks in layout version 2 format.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   |  9 +++--
 fs/smb/client/fs_context.c | 11 ++++--
 fs/smb/client/fs_context.h |  3 +-
 fs/smb/client/link.c       |  3 +-
 fs/smb/client/reparse.c    | 73 ++++++++++++++++++++++++++++++++------
 5 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d5faef5f3a73..d828ad0b466b 100644
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
index 8d5d6aca742a..fd7203aa0917 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -604,7 +604,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
-	case CIFS_SYMLINK_TYPE_WSL:
+	case CIFS_SYMLINK_TYPE_WSL1:
+	case CIFS_SYMLINK_TYPE_WSL2:
 		if (CIFS_REPARSE_SUPPORT(pTcon)) {
 			rc = create_reparse_symlink(xid, inode, direntry, pTcon,
 						    full_path, symname);
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 93c0c95d2202..4dcd3fa0d6a2 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -23,7 +23,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
 		     const char *full_path, umode_t mode, dev_t dev,
-		     const char *symname);
+		     const char *symname, int symver);
 
 static int create_native_symlink(const unsigned int xid, struct inode *inode,
 				 struct dentry *dentry, struct cifs_tcon *tcon,
@@ -44,8 +44,10 @@ int create_reparse_symlink(const unsigned int xid, struct inode *inode,
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
@@ -564,6 +566,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 
 static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
 			       mode_t mode, const char *symname,
+			       int symver,
 			       struct cifs_sb_info *cifs_sb,
 			       struct kvec *iov)
 {
@@ -599,15 +602,20 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer **buf,
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
@@ -708,7 +716,7 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
 		     const char *full_path, umode_t mode, dev_t dev,
-		     const char *symname)
+		     const char *symname, int symver)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_open_info_data data;
@@ -717,6 +725,12 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
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
@@ -726,7 +740,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
 		return -EOPNOTSUPP;
 
-	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
+	rc = wsl_set_reparse_buf(&buf, mode, symname, symver, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
 
@@ -751,6 +765,45 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
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
+				.pid = current->tgid,
+				.tcon = tcon,
+				.offset = 0,
+				.length = symv1_iov[1].iov_len,
+			};
+			rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
+								&bytes_written,
+								symv1_iov,
+								ARRAY_SIZE(symv1_iov)-1);
+			if (!rc && bytes_written != symv1_iov[1].iov_len)
+				rc = -EIO;
+			tcon->ses->server->ops->close(xid, tcon, &fid);
+		}
+		if (rc) {
+			tcon->ses->server->ops->unlink(xid, tcon, full_path, cifs_sb, NULL);
+			iput(new);
+			new = ERR_PTR(rc);
+		}
+	}
 	if (!IS_ERR(new))
 		d_instantiate(dentry, new);
 	else
@@ -774,7 +827,7 @@ int mknod_reparse(unsigned int xid, struct inode *inode,
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

