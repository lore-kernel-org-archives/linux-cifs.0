Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C52E2D5A10;
	Tue, 12 Aug 2025 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026810; cv=none; b=lf9fGqpDvTjdAcqi7wP3WCh+VttQuc8/DS59Xo4Z8qG5J04Lg+H/DSgeoqSbBj7bB5tVI0ewZmGjerR3Ma/LtxFrSLlwM7V6pXbnWG0KZWXkKxGmqUMa/MceTycMY9z2U/FQhk48E7KCrJOKQBIN9TjJrK4olfdjcUPfg7DVEFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026810; c=relaxed/simple;
	bh=VjzVHJegA4XagbOBzyPc58o6xCaappX9pPu3vCneRpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iy5eBtt6PD1Zmx4WoHGZUxA6M8fF4S+lM6Nanp8+0xNDTX3v9PkspknikFGFuDj/3uE3SxkrF6w5+Sv314UkzWPx1bZu7hlwUrKA4+3u1bqqboO+sONu0GLjL7SJwGZ/Th0iQrM2pptl9NzR1cOThz+BKra6Ay4AM06aCLSHw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDFSLkcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDFSLkcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80D6C4CEF0;
	Tue, 12 Aug 2025 19:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026810;
	bh=VjzVHJegA4XagbOBzyPc58o6xCaappX9pPu3vCneRpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDFSLkclXwXbcuOEh/iHNkkhOwtgo+2xA7BWcKyLZ2NZbbsE2D0r9gY8DQikrpPy5
	 NbRGPVIX0n5kQ1Lma73wkXSxeluuxwXiVUDA/TWPcqd+i7tK09p91qLUFdfuobXl6K
	 PEII9f78Zf/VJBgVu/RfARRYAy/RushXb+heSFK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Ralph Boehme <slow@samba.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Richardson <m.richardson@ed.ac.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 448/480] smb: client: set symlink type as native for POSIX mounts
Date: Tue, 12 Aug 2025 19:50:56 +0200
Message-ID: <20250812174415.879700349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit a967e758f8e9d8ce5ef096743393df5e6e51644b upstream.

SMB3.1.1 POSIX mounts require symlinks to be created natively with
IO_REPARSE_TAG_SYMLINK reparse point.

Cc: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
Closes: https://marc.info/?i=1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c     |    2 +-
 fs/smb/client/fs_context.c |   18 ------------------
 fs/smb/client/fs_context.h |   18 +++++++++++++++++-
 fs/smb/client/link.c       |   11 +++--------
 fs/smb/client/reparse.c    |    2 +-
 5 files changed, 22 insertions(+), 29 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -724,7 +724,7 @@ cifs_show_options(struct seq_file *s, st
 	else
 		seq_puts(s, ",nativesocket");
 	seq_show_option(s, "symlink",
-			cifs_symlink_type_str(get_cifs_symlink_type(cifs_sb)));
+			cifs_symlink_type_str(cifs_symlink_type(cifs_sb)));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1851,24 +1851,6 @@ static int smb3_fs_context_parse_param(s
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
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -606,14 +606,7 @@ cifs_symlink(struct mnt_idmap *idmap, st
 
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
@@ -653,6 +646,8 @@ cifs_symlink(struct mnt_idmap *idmap, st
 			goto symlink_exit;
 		}
 		break;
+	default:
+		break;
 	}
 
 	if (rc == 0) {
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -38,7 +38,7 @@ int smb2_create_reparse_symlink(const un
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, const char *symname)
 {
-	switch (get_cifs_symlink_type(CIFS_SB(inode->i_sb))) {
+	switch (cifs_symlink_type(CIFS_SB(inode->i_sb))) {
 	case CIFS_SYMLINK_TYPE_NATIVE:
 		return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
 	case CIFS_SYMLINK_TYPE_NFS:


