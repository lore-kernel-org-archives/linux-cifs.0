Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69C4D517;
	Sat, 12 Oct 2024 08:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723329; cv=none; b=jEeXYubOuZBC1aZCG3JsZNHM5lAIPFBsAMN0soozCAD0j9CNHswf6yX9BrQ2GiHcQsyizPMdfqGsJ6vYtPqjfqIvFwXlJUrU5LBUbjiDax8ek+qttvL7O+gvnLqbSLAygjxJ8hI3fldsKiipkz6eE4NuN33idQ/v/AiOG2vESGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723329; c=relaxed/simple;
	bh=BEzzMn9tuq91tn/CyMsXH0kda1QwYiNB5hUQY0xol2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m67r2pGUQEBL1A4KA9TQFK4QobT8peixjSMPZxZtjZC0s6+1rRl0V1N13W0RgJo5ecIH/SP2QCLOGBRu8dtb8Rkew+Owf1hngu6+lGhFnEDZXt4j9jSyLJGGfqvOAw5vBmnYLKOZIxdcqCuKhGgKxIVNHIaUVLqiVl4E2PFiXTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtHJ+kvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtHJ+kvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7D9C4CEC6;
	Sat, 12 Oct 2024 08:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723327;
	bh=BEzzMn9tuq91tn/CyMsXH0kda1QwYiNB5hUQY0xol2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtHJ+kvE6bgvDdl9swGA9e7fgyy3rJg1gS1RXXVru+KgGpgRRmMCsBml6z6B6g3c9
	 /bhql2AmiaIDmcjr/3hKRC1ZKpmvsgVDRaABzthR3Ep0QPh7K/sHOFPG01mWbQC/9w
	 wdF28j/SVveAEpCxeAILugc9MPAOfIvKqljU7d+b1Qo7LBvpzHGmtFEw3UA1GuhpFz
	 3SP1vlawY7ZNJcaRw8XAtF5ej0NOdum6qeVoXtTZ0MdbQRD/+4SiTNL5dfr8P7Cuze
	 fhveKtAQAZPvPAq+uyrIBppkGx2O4igsxccXJpndPoNmGA8cujxKSzh71YrDr6A1u9
	 H8sISKXoVx0BQ==
Received: by pali.im (Postfix)
	id 79BAA7BD; Sat, 12 Oct 2024 10:55:21 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] cifs: Add mount option -o symlink= for choosing symlink create type
Date: Sat, 12 Oct 2024 10:55:07 +0200
Message-Id: <20241012085507.633-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
References: <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently Linux CIFS client creates a new symlink of the first flavor which
is allowed by mount options, parsed in this order: -o (no)mfsymlinks,
-o (no)sfu, -o (no)unix (+ its aliases) and -o reparse=[type].

Introduce a new mount option -o symlink= for explicitly choosing a symlink
flavor. Possible options are:

  -o symlink=default    - The default behavior, like before this change.
  -o symlink=none       - Disallow creating a new symlinks
  -o symlink=native     - Create as native SMB symlink reparse point
  -o symlink=unix       - Create via SMB1 unix extension command
  -o symlink=mfsymlinks - Create as regular file of mfsymlinks format
  -o symlink=sfu        - Create as regular system file of SFU format
  -o symlink=nfs        - Create as NFS reparse point
  -o symlink=wsl        - Create as WSL reparse point

So for example specifying -o sfu,mfsymlinks,symlink=native will allow to
parse symlinks also of SFU and mfsymlinks types (which are disabled by
default unless mount option is explicitly specified), but new symlinks will
be created under native SMB type (which parsing is always enabled).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsfs.c     |  2 ++
 fs/smb/client/cifsglob.h   | 33 ++++++++++++++++++
 fs/smb/client/connect.c    |  2 ++
 fs/smb/client/fs_context.c | 71 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/fs_context.h | 16 +++++++++
 fs/smb/client/link.c       | 60 ++++++++++++++++++++++++--------
 fs/smb/client/reparse.c    | 52 ++++++++++++++++++++++------
 fs/smb/client/reparse.h    |  2 ++
 8 files changed, 214 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 000e1ef3beea..39ec67d9808e 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -689,6 +689,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 					    cifs_sb->ctx->backupgid));
 	seq_show_option(s, "reparse",
 			cifs_reparse_type_str(cifs_sb->ctx->reparse_type));
+	seq_show_option(s, "symlink",
+			cifs_symlink_type_str(get_cifs_symlink_type(cifs_sb)));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d5446d652755..f419d20f6c38 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -171,6 +171,39 @@ static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
 	}
 }
 
+enum cifs_symlink_type {
+	CIFS_SYMLINK_TYPE_DEFAULT,
+	CIFS_SYMLINK_TYPE_NONE,
+	CIFS_SYMLINK_TYPE_NATIVE,
+	CIFS_SYMLINK_TYPE_UNIX,
+	CIFS_SYMLINK_TYPE_MFSYMLINKS,
+	CIFS_SYMLINK_TYPE_SFU,
+	CIFS_SYMLINK_TYPE_NFS,
+	CIFS_SYMLINK_TYPE_WSL,
+};
+
+static inline const char *cifs_symlink_type_str(enum cifs_symlink_type type)
+{
+	switch (type) {
+	case CIFS_SYMLINK_TYPE_NONE:
+		return "none";
+	case CIFS_SYMLINK_TYPE_NATIVE:
+		return "native";
+	case CIFS_SYMLINK_TYPE_UNIX:
+		return "unix";
+	case CIFS_SYMLINK_TYPE_MFSYMLINKS:
+		return "mfsymlinks";
+	case CIFS_SYMLINK_TYPE_SFU:
+		return "sfu";
+	case CIFS_SYMLINK_TYPE_NFS:
+		return "nfs";
+	case CIFS_SYMLINK_TYPE_WSL:
+		return "wsl";
+	default:
+		return "unknown";
+	}
+}
+
 struct session_key {
 	unsigned int len;
 	char *response;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index adf8758847f6..bc5b5100ac09 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2831,6 +2831,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 		return 0;
 	if (old->ctx->reparse_type != new->ctx->reparse_type)
 		return 0;
+	if (old->ctx->symlink_type != new->ctx->symlink_type)
+		return 0;
 
 	return 1;
 }
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b2a8581c21f7..6bd4a5e61342 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -178,6 +178,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("sec", Opt_sec),
 	fsparam_string("cache", Opt_cache),
 	fsparam_string("reparse", Opt_reparse),
+	fsparam_string("symlink", Opt_symlink),
 	fsparam_string("symlinkroot", Opt_symlinkroot),
 
 	/* Arguments that should be ignored */
@@ -330,6 +331,55 @@ static int parse_reparse_flavor(struct fs_context *fc, char *value,
 	return 0;
 }
 
+static const match_table_t symlink_flavor_tokens = {
+	{ Opt_symlink_default,		"default" },
+	{ Opt_symlink_none,		"none" },
+	{ Opt_symlink_native,		"native" },
+	{ Opt_symlink_unix,		"unix" },
+	{ Opt_symlink_mfsymlinks,	"mfsymlinks" },
+	{ Opt_symlink_sfu,		"sfu" },
+	{ Opt_symlink_nfs,		"nfs" },
+	{ Opt_symlink_wsl,		"wsl" },
+	{ Opt_symlink_err,		NULL },
+};
+
+static int parse_symlink_flavor(struct fs_context *fc, char *value,
+				struct smb3_fs_context *ctx)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	switch (match_token(value, symlink_flavor_tokens, args)) {
+	case Opt_symlink_default:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
+		break;
+	case Opt_symlink_none:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_NONE;
+		break;
+	case Opt_symlink_native:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_NATIVE;
+		break;
+	case Opt_symlink_unix:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_UNIX;
+		break;
+	case Opt_symlink_mfsymlinks:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_MFSYMLINKS;
+		break;
+	case Opt_symlink_sfu:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_SFU;
+		break;
+	case Opt_symlink_nfs:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_NFS;
+		break;
+	case Opt_symlink_wsl:
+		ctx->symlink_type = CIFS_SYMLINK_TYPE_WSL;
+		break;
+	default:
+		cifs_errorf(fc, "bad symlink= option: %s\n", value);
+		return 1;
+	}
+	return 0;
+}
+
 #define DUP_CTX_STR(field)						\
 do {									\
 	if (ctx->field) {						\
@@ -1620,6 +1670,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (parse_reparse_flavor(fc, param->string, ctx))
 			goto cifs_parse_mount_err;
 		break;
+	case Opt_symlink:
+		if (parse_symlink_flavor(fc, param->string, ctx))
+			goto cifs_parse_mount_err;
+		break;
 	case Opt_symlinkroot:
 		if (param->string[0] != '/') {
 			cifs_errorf(fc, "symlinkroot mount options must be absolute path\n");
@@ -1650,6 +1704,22 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	return -EINVAL;
 }
 
+enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_sb)
+{
+	if (cifs_sb->ctx->symlink_type == CIFS_SYMLINK_TYPE_DEFAULT) {
+		if (cifs_sb->ctx->mfsymlinks)
+			return CIFS_SYMLINK_TYPE_MFSYMLINKS;
+		else if (cifs_sb->ctx->sfu_emul)
+			return CIFS_SYMLINK_TYPE_SFU;
+		else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_linux_ext)
+			return CIFS_SYMLINK_TYPE_UNIX;
+		else
+			return CIFS_SYMLINK_TYPE_NATIVE;
+	} else {
+		return cifs_sb->ctx->symlink_type;
+	}
+}
+
 int smb3_init_fs_context(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx;
@@ -1726,6 +1796,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 
 	ctx->retrans = 1;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
+	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
 
 /*
  *	short int override_uid = -1;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 94db5fdce621..3bcf20495fea 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -48,6 +48,18 @@ enum cifs_reparse_parm {
 	Opt_reparse_err
 };
 
+enum cifs_symlink_parm {
+	Opt_symlink_default,
+	Opt_symlink_none,
+	Opt_symlink_native,
+	Opt_symlink_unix,
+	Opt_symlink_mfsymlinks,
+	Opt_symlink_sfu,
+	Opt_symlink_nfs,
+	Opt_symlink_wsl,
+	Opt_symlink_err
+};
+
 enum cifs_sec_param {
 	Opt_sec_krb5,
 	Opt_sec_krb5i,
@@ -157,6 +169,7 @@ enum cifs_param {
 	Opt_sec,
 	Opt_cache,
 	Opt_reparse,
+	Opt_symlink,
 	Opt_symlinkroot,
 
 	/* Mount options to be ignored */
@@ -285,12 +298,15 @@ struct smb3_fs_context {
 	struct cifs_ses *dfs_root_ses;
 	bool dfs_automount:1; /* set for dfs automount only */
 	enum cifs_reparse_type reparse_type;
+	enum cifs_symlink_type symlink_type;
 	bool dfs_conn:1; /* set for dfs mounts */
 	char *symlinkroot; /* top level directory for native SMB symlinks in absolute format */
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
 
+extern enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_sb);
+
 extern int smb3_init_fs_context(struct fs_context *fc);
 extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
 extern void smb3_cleanup_fs_context(struct smb3_fs_context *ctx);
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 47ddeb7fa111..6e6c09cc5ce7 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -18,6 +18,7 @@
 #include "cifs_unicode.h"
 #include "smb2proto.h"
 #include "cifs_ioctl.h"
+#include "fs_context.h"
 
 /*
  * M-F Symlink Functions - Begin
@@ -604,22 +605,53 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
-		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
-		rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
-					  full_path, S_IFLNK, 0, symname);
+	rc = -EOPNOTSUPP;
+	switch (get_cifs_symlink_type(cifs_sb)) {
+	case CIFS_SYMLINK_TYPE_DEFAULT:
+		/* should not happen, get_cifs_symlink_type() resolves the default */
+		break;
+
+	case CIFS_SYMLINK_TYPE_NONE:
+		break;
+
+	case CIFS_SYMLINK_TYPE_UNIX:
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	} else if (pTcon->unix_ext) {
-		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
-					   cifs_sb->local_nls,
-					   cifs_remap(cifs_sb));
+		if (pTcon->unix_ext) {
+			rc = CIFSUnixCreateSymLink(xid, pTcon, full_path,
+						   symname,
+						   cifs_sb->local_nls,
+						   cifs_remap(cifs_sb));
+		}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	} else if (server->ops->create_reparse_symlink) {
-		rc =  server->ops->create_reparse_symlink(xid, inode, direntry,
-							  pTcon, full_path,
-							  symname);
-		goto symlink_exit;
+		break;
+
+	case CIFS_SYMLINK_TYPE_MFSYMLINKS:
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+			rc = create_mf_symlink(xid, pTcon, cifs_sb,
+					       full_path, symname);
+		}
+		break;
+
+	case CIFS_SYMLINK_TYPE_SFU:
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+			rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
+						  full_path, S_IFLNK,
+						  0, symname);
+		}
+		break;
+
+	case CIFS_SYMLINK_TYPE_NATIVE:
+	case CIFS_SYMLINK_TYPE_NFS:
+	case CIFS_SYMLINK_TYPE_WSL:
+		if (server->ops->create_reparse_symlink) {
+			rc = server->ops->create_reparse_symlink(xid, inode,
+								 direntry,
+								 pTcon,
+								 full_path,
+								 symname);
+			goto symlink_exit;
+		}
+		break;
 	}
 
 	if (rc == 0) {
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 99ef9bc88afc..d950c60323e8 100644
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
@@ -23,6 +37,22 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
+{
+	switch (get_cifs_symlink_type(CIFS_SB(inode->i_sb))) {
+	case CIFS_SYMLINK_TYPE_NATIVE:
+		return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
+	case CIFS_SYMLINK_TYPE_NFS:
+		return mknod_nfs(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
+	case CIFS_SYMLINK_TYPE_WSL:
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
@@ -363,6 +393,7 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	case NFS_SPECFILE_SOCK:
 		dlen = 0;
 		break;
+	case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -381,7 +412,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 
 static int mknod_nfs(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
-		     const char *full_path, umode_t mode, dev_t dev)
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname)
 {
 	struct cifs_open_info_data data;
 	struct reparse_posix_data *p;
@@ -421,6 +453,7 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_AF_UNIX:
 		break;
+	case IO_REPARSE_TAG_LX_SYMLINK: /* TODO: add support for WSL symlinks */
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -518,7 +551,8 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
 
 static int mknod_wsl(unsigned int xid, struct inode *inode,
 		     struct dentry *dentry, struct cifs_tcon *tcon,
-		     const char *full_path, umode_t mode, dev_t dev)
+		     const char *full_path, umode_t mode, dev_t dev,
+		     const char *symname)
 {
 	struct cifs_open_info_data data;
 	struct reparse_data_buffer buf;
@@ -563,17 +597,15 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 		       const char *full_path, umode_t mode, dev_t dev)
 {
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
-	int rc = -EOPNOTSUPP;
 
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
-		rc = mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev);
-		break;
+		return mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
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
@@ -848,7 +880,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	return rc;
 }
 
-static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
+static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
 				 u32 plen, bool unicode,
 				 struct cifs_sb_info *cifs_sb,
 				 const char *full_path,
@@ -936,7 +968,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 		return parse_reparse_posix((struct reparse_posix_data *)buf,
 					   cifs_sb, data);
 	case IO_REPARSE_TAG_SYMLINK:
-		return parse_reparse_symlink(
+		return parse_reparse_native_symlink(
 			(struct reparse_symlink_data_buffer *)buf,
 			plen, unicode, cifs_sb, full_path, data);
 	case IO_REPARSE_TAG_LX_SYMLINK:
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 81b6979bb40b..08579af9b9d7 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -48,6 +48,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 static inline u64 reparse_mode_nfs_type(mode_t mode)
 {
 	switch (mode & S_IFMT) {
+	case S_IFLNK: return NFS_SPECFILE_LNK;
 	case S_IFBLK: return NFS_SPECFILE_BLK;
 	case S_IFCHR: return NFS_SPECFILE_CHR;
 	case S_IFIFO: return NFS_SPECFILE_FIFO;
@@ -59,6 +60,7 @@ static inline u64 reparse_mode_nfs_type(mode_t mode)
 static inline u32 reparse_mode_wsl_tag(mode_t mode)
 {
 	switch (mode & S_IFMT) {
+	case S_IFLNK: return IO_REPARSE_TAG_LX_SYMLINK;
 	case S_IFBLK: return IO_REPARSE_TAG_LX_BLK;
 	case S_IFCHR: return IO_REPARSE_TAG_LX_CHR;
 	case S_IFIFO: return IO_REPARSE_TAG_LX_FIFO;
-- 
2.20.1

