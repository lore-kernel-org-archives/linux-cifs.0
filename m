Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF111EB36;
	Sun,  6 Oct 2024 10:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208869; cv=none; b=H2+fr4RBksew+lyxnSpffl0xL+agVMVFCFfn71ASWDB3BaN1wj05/EwCRBub2NrH1qahcAK+SnIfDdUx9MUvGrC2S192nUGe5EWrU0ieAsnl7nrSDGQ4cVtXU1MVl7EO6DsP2ZtGX5MUIfRxStINVSHiQkmD1F9tCP+8ceVqVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208869; c=relaxed/simple;
	bh=wQDjDxaOIJ2QMPx/RGAlRjXH23pYiR7J647kSjFOiiE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H083Yd8gmfIFSUt2kErQrRczECD6VID3Np1TpMms5uomz4zg9xPTRGSAk/UkTIeCmihdo1Ja0gsbiJfUpyGwvQ59UWIpU49vptrKV3sVJ35GO9e9FG22d1t46bujY/k6yMa0hu3l2j5CBsA+F+YxaxeBn7mm2VNvgZqvwK8kix4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfzw/tcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfzw/tcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BC7C4CEC5;
	Sun,  6 Oct 2024 10:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208869;
	bh=wQDjDxaOIJ2QMPx/RGAlRjXH23pYiR7J647kSjFOiiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfzw/tcK3yAJsl/IeGZnvchmujoxE4xQ3BXUiPW8JcEOpJ+SpDJA8h6NoYcr4Fbbd
	 N2FY88m4QbpON2LAQMhfXu8Q+dH2igl3TZB59PjwejiBXhjp8BNYAW/v9S1+Pg2EP3
	 OMxM1MufwWag/Y6mek27z9XL3clJrsgjWRMGpH2qRb/Ev/0rm++6LQX0Qdng4iVRIn
	 PFwDyveytjyfmB4mePk80INfW6ygDlWY11gb6m3iZFqdnvXDI6m/0JXM7QcWfzJVvI
	 XiAR47AsnPnWwOMnu+TExpr0aJ0vscA3w+oUoNgPHN3m/jhfBcKICoIXtkRwegiBPA
	 z82zZMAolNAAg==
Received: by pali.im (Postfix)
	id 2D481B49; Sun,  6 Oct 2024 12:01:02 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] cifs: Add mount option -o reparse=native
Date: Sun,  6 Oct 2024 12:00:40 +0200
Message-Id: <20241006100046.30772-2-pali@kernel.org>
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

Currently the default option is -o reparse=default which is same as
-o reparse=nfs. Currently mount option -o reparse=nfs does not create
symlink in NFS reparse point style, which is misleading.

Add new -o reparse= options "native", "native+nfs" and "native+wsl" to make
it more clear and allow to choose the expected reparse point types.

"native" would mean to create new special files only with reparse point
tags which are natively supported by SMB or Windows. Types which are not
natively supported cannot be created.

"native+nfs" would mean same as native, but fallback to "nfs" for
unsupported types.

"native+wsl" would mean to fallback to "wsl".

Change also meaning of "nfs" and "wsl" to always create special types with
nfs / wsl style.

And change also the default option to "native+nfs", so the default behavior
stay same as without this change. Without this change were all symlinks
created in native Windows/SMB form and this stay same with this change too.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   | 15 ++++++++--
 fs/smb/client/fs_context.c | 12 ++++++++
 fs/smb/client/fs_context.h |  3 ++
 fs/smb/client/reparse.c    | 58 +++++++++++++++++++++++++++++++-------
 fs/smb/client/reparse.h    |  2 ++
 5 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 260b553283ef..367f0ac6400d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -154,14 +154,23 @@ enum securityEnum {
 };
 
 enum cifs_reparse_type {
-	CIFS_REPARSE_TYPE_NFS,
-	CIFS_REPARSE_TYPE_WSL,
-	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NFS,
+	CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
+	CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for others */
+	CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for others */
+	CIFS_REPARSE_TYPE_NFS, /* nfs for everything */
+	CIFS_REPARSE_TYPE_WSL, /* wsl for everything */
+	CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NATIVE_NFS,
 };
 
 static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
 {
 	switch (type) {
+	case CIFS_REPARSE_TYPE_NATIVE:
+		return "native";
+	case CIFS_REPARSE_TYPE_NATIVE_NFS:
+		return "native+nfs";
+	case CIFS_REPARSE_TYPE_NATIVE_WSL:
+		return "native+wsl";
 	case CIFS_REPARSE_TYPE_NFS:
 		return "nfs";
 	case CIFS_REPARSE_TYPE_WSL:
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 22b550860cc8..e5de84912e3d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -303,6 +303,9 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
 
 static const match_table_t reparse_flavor_tokens = {
 	{ Opt_reparse_default,	"default" },
+	{ Opt_reparse_native,	"native" },
+	{ Opt_reparse_native_nfs, "native+nfs" },
+	{ Opt_reparse_native_wsl, "native+wsl" },
 	{ Opt_reparse_nfs,	"nfs" },
 	{ Opt_reparse_wsl,	"wsl" },
 	{ Opt_reparse_err,	NULL },
@@ -317,6 +320,15 @@ static int parse_reparse_flavor(struct fs_context *fc, char *value,
 	case Opt_reparse_default:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 		break;
+	case Opt_reparse_native:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE;
+		break;
+	case Opt_reparse_native_nfs:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE_NFS;
+		break;
+	case Opt_reparse_native_wsl:
+		ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE_WSL;
+		break;
 	case Opt_reparse_nfs:
 		ctx->reparse_type = CIFS_REPARSE_TYPE_NFS;
 		break;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 8dd12498ffd8..1011176ba3b7 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -43,6 +43,9 @@ enum {
 
 enum cifs_reparse_parm {
 	Opt_reparse_default,
+	Opt_reparse_native,
+	Opt_reparse_native_nfs,
+	Opt_reparse_native_wsl,
 	Opt_reparse_nfs,
 	Opt_reparse_wsl,
 	Opt_reparse_err
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 6e9d914bac41..38fe0a710c65 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -14,6 +14,20 @@
 #include "fs_context.h"
 #include "reparse.h"
 
+static int mknod_nfs(unsigned int xid, struct inode *inode,
+		     struct dentry *dentry, struct cifs_tcon *tcon,
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname);
+
+static int mknod_wsl(unsigned int xid, struct inode *inode,
+		     struct dentry *dentry, struct cifs_tcon *tcon,
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname);
+
+static int create_native_symlink(const unsigned int xid, struct inode *inode,
+				 struct dentry *dentry, struct cifs_tcon *tcon,
+				 const char *full_path, const char *symname);
+
 static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 					   const unsigned int xid,
 					   const char *full_path,
@@ -23,6 +37,26 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
+{
+	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
+
+	switch (ctx->reparse_type) {
+	case CIFS_REPARSE_TYPE_NATIVE:
+	case CIFS_REPARSE_TYPE_NATIVE_NFS:
+	case CIFS_REPARSE_TYPE_NATIVE_WSL:
+		return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
+	case CIFS_REPARSE_TYPE_NFS:
+		return mknod_nfs(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
+	case CIFS_REPARSE_TYPE_WSL:
+		return mknod_wsl(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int create_native_symlink(const unsigned int xid, struct inode *inode,
+				 struct dentry *dentry, struct cifs_tcon *tcon,
+				 const char *full_path, const char *symname)
 {
 	struct reparse_symlink_data_buffer *buf = NULL;
 	struct cifs_open_info_data data = {};
@@ -363,6 +397,7 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	case NFS_SPECFILE_SOCK:
 		dlen = 0;
 		break;
+	case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -381,7 +416,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 
 static int mknod_nfs(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
-		     const char *full_path, umode_t mode, dev_t dev)
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname)
 {
 	struct cifs_open_info_data data;
 	struct reparse_posix_data *p;
@@ -421,6 +457,7 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_AF_UNIX:
 		break;
+	case IO_REPARSE_TAG_LX_SYMLINK: /* TODO: add support for WSL symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -518,7 +555,8 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
 
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
-		     const char *full_path, umode_t mode, dev_t dev)
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname)
 {
 	struct cifs_open_info_data data;
 	struct reparse_data_buffer buf;
@@ -563,17 +601,17 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 		       const char *full_path, umode_t mode, dev_t dev)
 {
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
-	int rc = -EOPNOTSUPP;
 
 	switch (ctx->reparse_type) {
+	case CIFS_REPARSE_TYPE_NATIVE_NFS:
 	case CIFS_REPARSE_TYPE_NFS:
-		rc = mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev);
-		break;
+		return mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
+	case CIFS_REPARSE_TYPE_NATIVE_WSL:
 	case CIFS_REPARSE_TYPE_WSL:
-		rc = mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev);
-		break;
+		return mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
+	default:
+		return -EOPNOTSUPP;
 	}
-	return rc;
 }
 
 /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
@@ -848,7 +886,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	return rc;
 }
 
-static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
+static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
 				 u32 plen, bool unicode,
 				 struct cifs_sb_info *cifs_sb,
 				 const char *full_path,
@@ -936,7 +974,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 		return parse_reparse_posix((struct reparse_posix_data *)buf,
 					   cifs_sb, data);
 	case IO_REPARSE_TAG_SYMLINK:
-		return parse_reparse_symlink(
+		return parse_reparse_native_symlink(
 			(struct reparse_symlink_data_buffer *)buf,
 			plen, unicode, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_LX_SYMLINK:
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index eb6854e65e08..a6bdf20ce1b0 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -61,6 +61,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 static inline u64 reparse_mode_nfs_type(mode_t mode)
 {
 	switch (mode & S_IFMT) {
+	case S_IFLNK: return NFS_SPECFILE_LNK;
 	case S_IFBLK: return NFS_SPECFILE_BLK;
 	case S_IFCHR: return NFS_SPECFILE_CHR;
 	case S_IFIFO: return NFS_SPECFILE_FIFO;
@@ -72,6 +73,7 @@ static inline u64 reparse_mode_nfs_type(mode_t mode)
 static inline u32 reparse_mode_wsl_tag(mode_t mode)
 {
 	switch (mode & S_IFMT) {
+	case S_IFLNK: return IO_REPARSE_TAG_LX_SYMLINK;
 	case S_IFBLK: return IO_REPARSE_TAG_LX_BLK;
 	case S_IFCHR: return IO_REPARSE_TAG_LX_CHR;
 	case S_IFIFO: return IO_REPARSE_TAG_LX_FIFO;
-- 
2.20.1

