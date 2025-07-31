Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED2428AB03
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 23:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005617; cv=none; b=c2u5+yXuD/Yj7/xeJbLY3fIZDrdVOyl8FG9HAVYLBRjTMV+FrVw2yQjCKQy4KhK3XTvPxPTRSpE2FpgstMEMKq8eP9cxPsG64p1+jXrFGPwb9dtc2CJxBpd44f6tWlde0qOsqnenkVs8beULmoleBa/4+71jiQEEVVSfXC/jo1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005617; c=relaxed/simple;
	bh=y6AjtRwDHsIt7ykHAqN9+5T6ti+L0U11pcHVlys1LSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NmI99RfSECOgxefdM9YddXjNx0j6EfQmrHOkP9+L1A8YQHc+GC6l6SOoPXJdfC3UO66SSK0Jchd9k7YedkhFib5aiM1TqsqjR2JLqHjm2o0/XRIuZU0oG2yQRKfYnPOXxDTgtCfaBe4MR3xfeHMfSNmZXaeVgvjGFeLZ2KfgpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=C0LKPSZ1; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="C0LKPSZ1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=5FzEJ0uod47QJhWNwEh4RWWvIiQC5TcI8/nUS4BrRys=; b=C0LKPSZ1YSYVziJ+WrI6owb7T+
	FDI0ZEoH9hSVsTh6tU76CTgsDzn/iuXYkn1eDtiRZOtsWb1PXyFpPdsRAhoTBLgv2nbbJ8wOSLKnd
	YKD1IEoxn0KUHe6CdsUyrsbBGwelwUmYnXukkRs0cmAvICcdSHuFoberfqm+BXhWbrAmZbRwKqkAZ
	aS8MenIZXfreCH387K+68QVBov9i4wIbwPf4ivRocyTxh48WsiIpNvlvhvWGU8oLaGMdDiYASYw9b
	PpexOdDIS9Mbca4vl+Lv2iLWhhudXQTForZhQgMxJb7b3xMar9TsM8+i5pzEYBiJq6WseI8SLxoPR
	21mFAR/g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhcz5-00000000Abc-3FZY;
	Thu, 31 Jul 2025 20:46:51 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Ralph Boehme <slow@samba.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Richardson <m.richardson@ed.ac.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 1/3] smb: client: set symlink type as native for POSIX mounts
Date: Thu, 31 Jul 2025 20:46:41 -0300
Message-ID: <20250731234643.787785-1-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB3.1.1 POSIX mounts require symlinks to be created natively with
IO_REPARSE_TAG_SYMLINK reparse point.

Cc: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Cc: David Howells <dhowells@redhat.com>
Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
Closes: https://marc.info/?i=1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/cifsfs.c     |  2 +-
 fs/smb/client/fs_context.c | 18 ------------------
 fs/smb/client/fs_context.h | 18 +++++++++++++++++-
 fs/smb/client/link.c       | 11 +++--------
 fs/smb/client/reparse.c    |  2 +-
 5 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 0a5266ecfd15..697badd0445a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -723,7 +723,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	else
 		seq_puts(s, ",nativesocket");
 	seq_show_option(s, "symlink",
-			cifs_symlink_type_str(get_cifs_symlink_type(cifs_sb)));
+			cifs_symlink_type_str(cifs_symlink_type(cifs_sb)));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3f34bb07997b..cc8bd79ebca9 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1829,24 +1829,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	return -EINVAL;
 }
 
-enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_sb)
-{
-	if (cifs_sb->ctx->symlink_type == CIFS_SYMLINK_TYPE_DEFAULT) {
-		if (cifs_sb->ctx->mfsymlinks)
-			return CIFS_SYMLINK_TYPE_MFSYMLINKS;
-		else if (cifs_sb->ctx->sfu_emul)
-			return CIFS_SYMLINK_TYPE_SFU;
-		else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_linux_ext)
-			return CIFS_SYMLINK_TYPE_UNIX;
-		else if (cifs_sb->ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
-			return CIFS_SYMLINK_TYPE_NATIVE;
-		else
-			return CIFS_SYMLINK_TYPE_NONE;
-	} else {
-		return cifs_sb->ctx->symlink_type;
-	}
-}
-
 int smb3_init_fs_context(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 9e83302ce4b8..b0fec6b9a23b 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -341,7 +341,23 @@ struct smb3_fs_context {
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
 
-extern enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_sb);
+static inline enum cifs_symlink_type cifs_symlink_type(struct cifs_sb_info *cifs_sb)
+{
+	bool posix = cifs_sb_master_tcon(cifs_sb)->posix_extensions;
+
+	if (cifs_sb->ctx->symlink_type != CIFS_SYMLINK_TYPE_DEFAULT)
+		return cifs_sb->ctx->symlink_type;
+
+	if (cifs_sb->ctx->mfsymlinks)
+		return CIFS_SYMLINK_TYPE_MFSYMLINKS;
+	else if (cifs_sb->ctx->sfu_emul)
+		return CIFS_SYMLINK_TYPE_SFU;
+	else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_linux_ext)
+		return posix ? CIFS_SYMLINK_TYPE_NATIVE : CIFS_SYMLINK_TYPE_UNIX;
+	else if (cifs_sb->ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
+		return CIFS_SYMLINK_TYPE_NATIVE;
+	return CIFS_SYMLINK_TYPE_NONE;
+}
 
 extern int smb3_init_fs_context(struct fs_context *fc);
 extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 2ecd705e9e8c..afe76367d2c8 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -605,14 +605,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 
 	/* BB what if DFS and this volume is on different share? BB */
 	rc = -EOPNOTSUPP;
-	switch (get_cifs_symlink_type(cifs_sb)) {
-	case CIFS_SYMLINK_TYPE_DEFAULT:
-		/* should not happen, get_cifs_symlink_type() resolves the default */
-		break;
-
-	case CIFS_SYMLINK_TYPE_NONE:
-		break;
-
+	switch (cifs_symlink_type(cifs_sb)) {
 	case CIFS_SYMLINK_TYPE_UNIX:
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 		if (pTcon->unix_ext) {
@@ -648,6 +641,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 			goto symlink_exit;
 		}
 		break;
+	default:
+		break;
 	}
 
 	if (rc == 0) {
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 33c1d970747c..7869cec58f52 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -38,7 +38,7 @@ int create_reparse_symlink(const unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
 {
-	switch (get_cifs_symlink_type(CIFS_SB(inode->i_sb))) {
+	switch (cifs_symlink_type(CIFS_SB(inode->i_sb))) {
 	case CIFS_SYMLINK_TYPE_NATIVE:
 		return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
 	case CIFS_SYMLINK_TYPE_NFS:
-- 
2.50.1

