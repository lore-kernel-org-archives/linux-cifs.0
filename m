Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCE48F830;
	Mon,  7 Sep 2026 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781672; cv=none; b=LctlqrV/4tZZakIhoLmSds1t6QW3p0zFjGWqsYKkaNl4XHrG0JXaC2Lx+J96ttLArbyKEW9HC4ZJNKEenlYkAYxDsxpX4UcLVGV/ti5ejd+wjhYsysuJGktS+Pblm44g5UF1fAivzkuj+w+o6/Qarfhlo7bi8+QMpKHrBbZH34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781672; c=relaxed/simple;
	bh=b63Ihb3Mlxh/gbL4pU19SqkB27CodHMgdfSNLswHhgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkUVVybRGznMHMidOIjR1WfMdWDQPkPxw98hgmnTpkdyZRWjpALyk8sftRoGjIVBRRnHolqE8/LSYtyAuwEgjIGs9rxx9jU1TVvTNqa9GhwKbjaNJ55BTj9D2uqVysJIbWFHhJm09rB3FnrQ/vKZGXXXD7dpn2AfnqEoRBvgZxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i30779ZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i30779ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1D91F00A3A;
	Mon,  7 Sep 2026 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781668;
	bh=NibyEvJpUyqjHFkAfH8hC6i8IH72uWdMPM+hIpcco1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i30779ZMUDTrxjXSkh6ygsDnv0WLresoMSIUJf47A+lMjUCPUOAGHoLnV66dwB1EX
	 wUsZSI8pWGOPS8zBEZmFHQU6C6MTyKAJr5GmB3ThwSRWJkH0rVDwnCwbMDEpXoSqrG
	 FkR0gfhDEm6VPAdS8pfSiUxuMVXpDFiAHOR2ORXxQd1v+WCXwYaFxylGSs/h5ezW78
	 8uD14GaS9F9yvGJPHfiW3PpNpiZezs4k1pLJJlMb2uCY8wsWWk75sMQf41cRhdXtL8
	 gp+0TSCZD5dlLJDlRfNrX25/9i/MCVs4AI+ParwDdWKRbF2dNNeW8CPey5wWDYH6Op
	 7Lkh6evBKXrGQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 4/5] smb: client: use atomic_t for mnt_cifs_flags
Date: Mon,  7 Sep 2026 07:47:41 -0400
Message-ID: <20260907114742.2872537-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907114742.2872537-1-sashal@kernel.org>
References: <2026090351-popper-penpal-d0a0@gregkh>
 <20260907114742.2872537-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4fc3a433c13944ee5766ec5b9bf6f1eb4d29b880 ]

Use atomic_t for cifs_sb_info::mnt_cifs_flags as it's currently
accessed locklessly and may be changed concurrently in mount/remount
and reconnect paths.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 24. Not backported here:
  fs/smb/client/cifs_unicode.h
  fs/smb/client/reparse.c
  fs/smb/client/smb2file.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c   |   2 +-
 fs/smb/client/cifs_fs_sb.h   |   2 +-
 fs/smb/client/cifs_ioctl.h   |   2 +-
 fs/smb/client/cifs_unicode.c |   5 +-
 fs/smb/client/cifsacl.c      |   6 +-
 fs/smb/client/cifsfs.c       |  66 ++++++++++-----------
 fs/smb/client/cifsglob.h     |   9 ++-
 fs/smb/client/connect.c      |  53 +++++++++--------
 fs/smb/client/dfs_cache.c    |   2 +-
 fs/smb/client/dir.c          |  16 ++---
 fs/smb/client/file.c         |  32 +++++-----
 fs/smb/client/fs_context.c   | 112 ++++++++++++++++++-----------------
 fs/smb/client/fs_context.h   |   2 +-
 fs/smb/client/inode.c        |  64 ++++++++++----------
 fs/smb/client/ioctl.c        |   2 +-
 fs/smb/client/link.c         |   4 +-
 fs/smb/client/misc.c         |  12 ++--
 fs/smb/client/readdir.c      |  16 ++---
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |   4 +-
 fs/smb/client/smb2misc.c     |   4 +-
 fs/smb/client/smb2ops.c      |   4 +-
 fs/smb/client/smb2pdu.c      |   4 +-
 fs/smb/client/xattr.c        |   6 +-
 24 files changed, 222 insertions(+), 211 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fbc746813a6f2..ee045e6125809 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -118,7 +118,7 @@ static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
 	if (!*path)
 		return path;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH) &&
 	    cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath) + 1;
 		if (unlikely(len > strlen(path)))
diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 6517591922801..1a58b5b051122 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -54,7 +54,7 @@ struct cifs_sb_info {
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
-	unsigned int mnt_cifs_flags;
+	atomic_t mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index 26327442e383b..d72032d942a6d 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -125,7 +125,7 @@ struct smb3_notify_info {
 
 static inline bool cifs_forced_shutdown(struct cifs_sb_info *sbi)
 {
-	if (CIFS_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
+	if (CIFS_MOUNT_SHUTDOWN & atomic_read(&sbi->mnt_cifs_flags))
 		return true;
 	else
 		return false;
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index f8659d36793f1..9efba1c883aff 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -15,10 +15,11 @@
 int cifs_remap(struct cifs_sb_info *cifs_sb)
 {
 	int map_type;
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+	if (sbflags & CIFS_MOUNT_MAP_SFM_CHR)
 		map_type = SFM_MAP_UNI_RSVD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+	else if (sbflags & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		map_type = SFU_MAP_UNI_RSVD;
 	else
 		map_type = NO_MAP_UNI_RSVD;
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 230b98b3a272c..4f33b20d479a6 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -356,7 +356,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 		return -EIO;
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL) ||
 	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
 		bool is_group;
@@ -1715,12 +1715,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		return rc;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)
 		mode_from_sid = true;
 	else
 		mode_from_sid = false;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 		id_from_sid = true;
 	else
 		id_from_sid = false;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 08e7931cdda2b..7ea288a7a11e6 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -196,7 +196,7 @@ cifs_read_super(struct super_block *sb)
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
 	if (tcon->snapshot_time)
@@ -272,7 +272,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
@@ -389,7 +389,7 @@ static int cifs_permission(struct mnt_idmap *idmap,
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM) {
 		if ((mask & MAY_EXEC) && !execute_ok(inode))
 			return -EACCES;
 		else
@@ -537,13 +537,13 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 {
 	seq_puts(s, ",cache=");
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 		seq_puts(s, "strict");
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO)
 		seq_puts(s, "none");
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 		seq_puts(s, "singleclient"); /* assume only one client access */
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RO_CACHE)
 		seq_puts(s, "ro"); /* read only caching assumed */
 	else
 		seq_puts(s, "loose");
@@ -639,14 +639,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	seq_printf(s, ",uid=%u",
 		   from_kuid_munged(&init_user_ns, cifs_sb->ctx->linux_uid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		seq_puts(s, ",forceuid");
 	else
 		seq_puts(s, ",noforceuid");
 
 	seq_printf(s, ",gid=%u",
 		   from_kgid_munged(&init_user_ns, cifs_sb->ctx->linux_gid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		seq_puts(s, ",forcegid");
 	else
 		seq_puts(s, ",noforcegid");
@@ -685,53 +685,53 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",unix");
 	else
 		seq_puts(s, ",nounix");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS)
 		seq_puts(s, ",nodfs");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		seq_puts(s, ",posixpaths");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID)
 		seq_puts(s, ",setuids");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 		seq_puts(s, ",idsfromsid");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		seq_puts(s, ",serverino");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		seq_puts(s, ",rwpidforward");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL)
 		seq_puts(s, ",forcemand");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 		seq_puts(s, ",nouser_xattr");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		seq_puts(s, ",mapchars");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SFM_CHR)
 		seq_puts(s, ",mapposix");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL)
 		seq_puts(s, ",sfu");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 		seq_puts(s, ",nobrl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_HANDLE_CACHE)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_HANDLE_CACHE)
 		seq_puts(s, ",nohandlecache");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)
 		seq_puts(s, ",modefromsid");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL)
 		seq_puts(s, ",cifsacl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)
 		seq_puts(s, ",dynperm");
 	if (root->d_sb->s_flags & SB_POSIXACL)
 		seq_puts(s, ",acl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS)
 		seq_puts(s, ",mfsymlinks");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_FSCACHE)
 		seq_puts(s, ",fsc");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)
 		seq_puts(s, ",nostrictsync");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		seq_puts(s, ",noperm");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPUID)
 		seq_printf(s, ",backupuid=%u",
 			   from_kuid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupuid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPGID)
 		seq_printf(s, ",backupgid=%u",
 			   from_kgid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupgid));
@@ -868,7 +868,7 @@ static int cifs_drop_inode(struct inode *inode)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+	return !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) ||
 		generic_drop_inode(inode);
 }
 
@@ -906,7 +906,7 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		return dget(sb->s_root);
 
 	full_path = cifs_build_path_to_root(ctx, cifs_sb,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4f30059c08ddc..1603381ee6871 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1500,9 +1500,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (cifs_sb_flags(CIFS_SB(cinode->netfs.inode.i_sb)) & CIFS_MOUNT_RO_CACHE))
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (cifs_sb_flags(CIFS_SB(cinode->netfs.inode.i_sb)) & CIFS_MOUNT_RW_CACHE))
 
 /*
  * One of these for each file inode
@@ -1563,9 +1563,12 @@ CIFS_FILE_SB(struct file *file)
 	return CIFS_SB(file_inode(file)->i_sb);
 }
 
+#define cifs_sb_flags(cifs_sb) \
+	((unsigned int)atomic_read(&(cifs_sb)->mnt_cifs_flags))
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		return '/';
 	else
 		return '\\';
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 52ac9b096a402..b794ef34823d5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2863,8 +2863,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
-	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int oldflags = cifs_sb_flags(old) & CIFS_MOUNT_MASK;
+	unsigned int newflags = cifs_sb_flags(new) & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
@@ -2915,9 +2915,9 @@ static int match_prepath(struct super_block *sb,
 	struct smb3_fs_context *ctx = mnt_data->ctx;
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	bool old_set = (cifs_sb_flags(old) & CIFS_MOUNT_USE_PREFIX_PATH) &&
 		old->prepath;
-	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	bool new_set = (cifs_sb_flags(new) & CIFS_MOUNT_USE_PREFIX_PATH) &&
 		new->prepath;
 
 	if (tcon->origin_fullpath &&
@@ -2948,7 +2948,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	cifs_sb = CIFS_SB(sb);
 
 	/* We do not want to use a superblock that has been shutdown */
-	if (CIFS_MOUNT_SHUTDOWN & cifs_sb->mnt_cifs_flags) {
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb_flags(cifs_sb)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
@@ -3332,8 +3332,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
+				atomic_or(CIFS_MOUNT_POSIXACL,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		if (ctx && ctx->posix_paths == 0)
@@ -3341,8 +3341,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
+				atomic_or(CIFS_MOUNT_POSIX_PATHS,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
@@ -3380,6 +3380,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 {
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
+	unsigned int sbflags;
+	int rc = 0;
 
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 
@@ -3403,17 +3405,16 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 	}
 	ctx->local_nls = cifs_sb->local_nls;
 
-	smb3_update_mnt_flags(cifs_sb);
+	sbflags = smb3_update_mnt_flags(cifs_sb);
 
 	if (ctx->direct_io)
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
 	if (ctx->cache_ro) {
 		cifs_dbg(VFS, "mounting share with read only caching. Ensure that the share will not be modified while in use.\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RO_CACHE;
+		sbflags |= CIFS_MOUNT_RO_CACHE;
 	} else if (ctx->cache_rw) {
 		cifs_dbg(VFS, "mounting share in single client RW caching mode. Ensure that no other systems will be accessing the share.\n");
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_RO_CACHE |
-					    CIFS_MOUNT_RW_CACHE);
+		sbflags |= CIFS_MOUNT_RO_CACHE | CIFS_MOUNT_RW_CACHE;
 	}
 
 	if ((ctx->cifs_acl) && (ctx->dynperm))
@@ -3422,11 +3423,13 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 	if (ctx->prepath) {
 		cifs_sb->prepath = kstrdup(ctx->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
-			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			rc = -ENOMEM;
+		else
+			sbflags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
-	return 0;
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
+	return rc;
 }
 
 /* Release all succeed connections */
@@ -3443,7 +3446,8 @@ void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx)
 	mnt_ctx->ses = NULL;
 	mnt_ctx->tcon = NULL;
 	mnt_ctx->server = NULL;
-	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	atomic_andnot(CIFS_MOUNT_POSIX_PATHS,
+		      &mnt_ctx->cifs_sb->mnt_cifs_flags);
 	free_xid(mnt_ctx->xid);
 }
 
@@ -3521,7 +3525,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
+		atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	/* tell server which Unix caps we support */
@@ -3547,11 +3551,11 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(mnt_ctx->xid, tcon, cifs_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RO_CACHE) {
 			if (tcon->fsDevInfo.DeviceCharacteristics &
 			    cpu_to_le32(FILE_READ_ONLY_DEVICE))
 				cifs_dbg(VFS, "mounted to read only share\n");
-			else if ((cifs_sb->mnt_cifs_flags &
+			else if ((cifs_sb_flags(cifs_sb) &
 				  CIFS_MOUNT_RW_CACHE) == 0)
 				cifs_dbg(VFS, "read only mount of RW share\n");
 			/* no need to log a RW mount of a typical RW share */
@@ -3585,7 +3589,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	 * Inside cifs_fscache_get_super_cookie it checks
 	 * that we do not get super cookie twice.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_FSCACHE)
 		cifs_fscache_get_super_cookie(tcon);
 
 out:
@@ -3704,7 +3708,8 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_server_dbg(VFS, "cannot query dirs between root and final path, enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			atomic_or(CIFS_MOUNT_USE_PREFIX_PATH,
+				  &cifs_sb->mnt_cifs_flags);
 			rc = 0;
 		}
 	}
@@ -3735,7 +3740,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
@@ -4316,7 +4321,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	kuid_t fsuid = current_fsuid();
 	int err;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 110f03df012a0..d3b2498d08f0e 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1321,7 +1321,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 
 	refresh_tcon_referral(tcon, true);
 	return 0;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6bb0e98462a98..cdf2de0931cec 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -96,7 +96,7 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 	else
 		dfsplen = 0;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
 	s = dentry_path_raw(direntry, page, PATH_MAX);
@@ -123,7 +123,7 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 	if (dfsplen) {
 		s -= dfsplen;
 		memcpy(s, tree, dfsplen);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
 				if (s[i] == '\\')
@@ -160,7 +160,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)) {
 		for (i = 0; i < direntry->d_name.len; i++) {
 			if (direntry->d_name.name[i] == '\\') {
 				cifs_dbg(FYI, "Invalid file name\n");
@@ -350,7 +350,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 				.device	= 0,
 		};
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				args.gid = inode->i_gid;
@@ -387,9 +387,9 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			if (server->ops->set_lease_key)
 				server->ops->set_lease_key(newinode, fid);
 			if ((*oplock & CIFS_CREATE_ACTION) && S_ISREG(newinode->i_mode)) {
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+				if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)
 					newinode->i_mode = mode;
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+				if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 					newinode->i_uid = current_fsuid();
 					if (inode->i_mode & S_ISGID)
 						newinode->i_gid = inode->i_gid;
@@ -519,8 +519,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	}
 
 	if (file->f_flags & O_DIRECT &&
-	    CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(CIFS_SB(inode->i_sb)) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(CIFS_SB(inode->i_sb)) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 70b64df9fb2eb..291f0695c4895 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -269,7 +269,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		open_file = file->private_data;
 		rreq->netfs_priv = file->private_data;
 		req->cfile = cifsFileInfo_get(open_file);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 			req->pid = req->cfile->pid;
 	} else if (rreq->origin != NETFS_WRITEBACK) {
 		WARN_ON_ONCE(1);
@@ -883,7 +883,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		 * close  because it may cause a error when we open this file
 		 * again and get at least level II oplock.
 		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
@@ -974,8 +974,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		 inode, file->f_flags, full_path);
 
 	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
@@ -1123,7 +1123,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -1919,7 +1919,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -2327,7 +2327,7 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 
 	if (!lock && !unlock) {
@@ -2377,7 +2377,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 	/*
 	 * BB add code here to normalize offset and length to account for
@@ -2432,7 +2432,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2488,7 +2488,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 	cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2663,7 +2663,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2711,7 +2711,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		 file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2780,7 +2780,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (rc <= 0)
 		goto out;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) &&
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) &&
 	    (cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
 				     server->vals->exclusive_lock_type, 0,
 				     NULL, CIFS_WRITE_OP))) {
@@ -2816,7 +2816,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-		    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+		    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = netfs_file_write_iter(iocb, from);
 			goto out;
 		}
@@ -2921,7 +2921,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (!CIFS_CACHE_READ(cinode))
 		return netfs_unbuffered_read_iter(iocb, to);
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) {
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0) {
 		if (iocb->ki_flags & IOCB_DIRECT)
 			return netfs_unbuffered_read_iter(iocb, to);
 		return netfs_buffered_read_iter(iocb, to);
@@ -3043,7 +3043,7 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 		struct cifs_sb_info *cifs_sb;
 
 		cifs_sb = CIFS_SB(cifsInode->netfs.inode.i_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 769380020d41a..c9e5d8a69377e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1908,141 +1908,142 @@ smb3_cleanup_fs_context(struct smb3_fs_context *ctx)
 	kfree(ctx);
 }
 
-void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
+unsigned int smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 {
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
 	if (ctx->nodfs)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
+		sbflags |= CIFS_MOUNT_NO_DFS;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_DFS;
+		sbflags &= ~CIFS_MOUNT_NO_DFS;
 
 	if (ctx->noperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
+		sbflags |= CIFS_MOUNT_NO_PERM;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_PERM;
+		sbflags &= ~CIFS_MOUNT_NO_PERM;
 
 	if (ctx->setuids)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
+		sbflags |= CIFS_MOUNT_SET_UID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SET_UID;
+		sbflags &= ~CIFS_MOUNT_SET_UID;
 
 	if (ctx->setuidfromacl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
+		sbflags |= CIFS_MOUNT_UID_FROM_ACL;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UID_FROM_ACL;
+		sbflags &= ~CIFS_MOUNT_UID_FROM_ACL;
 
 	if (ctx->server_ino)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
+		sbflags |= CIFS_MOUNT_SERVER_INUM;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		sbflags &= ~CIFS_MOUNT_SERVER_INUM;
 
 	if (ctx->remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SFM_CHR;
+		sbflags |= CIFS_MOUNT_MAP_SFM_CHR;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SFM_CHR;
+		sbflags &= ~CIFS_MOUNT_MAP_SFM_CHR;
 
 	if (ctx->sfu_remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
+		sbflags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SPECIAL_CHR;
+		sbflags &= ~CIFS_MOUNT_MAP_SPECIAL_CHR;
 
 	if (ctx->no_xattr)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_XATTR;
+		sbflags |= CIFS_MOUNT_NO_XATTR;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_XATTR;
+		sbflags &= ~CIFS_MOUNT_NO_XATTR;
 
 	if (ctx->sfu_emul)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
+		sbflags |= CIFS_MOUNT_UNX_EMUL;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UNX_EMUL;
+		sbflags &= ~CIFS_MOUNT_UNX_EMUL;
 
 	if (ctx->nobrl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
+		sbflags |= CIFS_MOUNT_NO_BRL;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_BRL;
+		sbflags &= ~CIFS_MOUNT_NO_BRL;
 
 	if (ctx->nohandlecache)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_HANDLE_CACHE;
+		sbflags |= CIFS_MOUNT_NO_HANDLE_CACHE;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_HANDLE_CACHE;
+		sbflags &= ~CIFS_MOUNT_NO_HANDLE_CACHE;
 
 	if (ctx->nostrictsync)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
+		sbflags |= CIFS_MOUNT_NOSSYNC;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOSSYNC;
+		sbflags &= ~CIFS_MOUNT_NOSSYNC;
 
 	if (ctx->mand_lock)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+		sbflags |= CIFS_MOUNT_NOPOSIXBRL;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOPOSIXBRL;
+		sbflags &= ~CIFS_MOUNT_NOPOSIXBRL;
 
 	if (ctx->rwpidforward)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
+		sbflags |= CIFS_MOUNT_RWPIDFORWARD;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_RWPIDFORWARD;
+		sbflags &= ~CIFS_MOUNT_RWPIDFORWARD;
 
 	if (ctx->mode_ace)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MODE_FROM_SID;
+		sbflags |= CIFS_MOUNT_MODE_FROM_SID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MODE_FROM_SID;
+		sbflags &= ~CIFS_MOUNT_MODE_FROM_SID;
 
 	if (ctx->cifs_acl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
+		sbflags |= CIFS_MOUNT_CIFS_ACL;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_ACL;
+		sbflags &= ~CIFS_MOUNT_CIFS_ACL;
 
 	if (ctx->backupuid_specified)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
+		sbflags |= CIFS_MOUNT_CIFS_BACKUPUID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPUID;
+		sbflags &= ~CIFS_MOUNT_CIFS_BACKUPUID;
 
 	if (ctx->backupgid_specified)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
+		sbflags |= CIFS_MOUNT_CIFS_BACKUPGID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPGID;
+		sbflags &= ~CIFS_MOUNT_CIFS_BACKUPGID;
 
 	if (ctx->override_uid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
+		sbflags |= CIFS_MOUNT_OVERR_UID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_UID;
+		sbflags &= ~CIFS_MOUNT_OVERR_UID;
 
 	if (ctx->override_gid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
+		sbflags |= CIFS_MOUNT_OVERR_GID;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_GID;
+		sbflags &= ~CIFS_MOUNT_OVERR_GID;
 
 	if (ctx->dynperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
+		sbflags |= CIFS_MOUNT_DYNPERM;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DYNPERM;
+		sbflags &= ~CIFS_MOUNT_DYNPERM;
 
 	if (ctx->fsc)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
+		sbflags |= CIFS_MOUNT_FSCACHE;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_FSCACHE;
+		sbflags &= ~CIFS_MOUNT_FSCACHE;
 
 	if (ctx->multiuser)
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
+		sbflags |= (CIFS_MOUNT_MULTIUSER |
 					    CIFS_MOUNT_NO_PERM);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MULTIUSER;
+		sbflags &= ~CIFS_MOUNT_MULTIUSER;
 
 
 	if (ctx->strict_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
+		sbflags |= CIFS_MOUNT_STRICT_IO;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_STRICT_IO;
+		sbflags &= ~CIFS_MOUNT_STRICT_IO;
 
 	if (ctx->direct_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
+		sbflags |= CIFS_MOUNT_DIRECT_IO;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DIRECT_IO;
+		sbflags &= ~CIFS_MOUNT_DIRECT_IO;
 
 	if (ctx->mfsymlinks)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
+		sbflags |= CIFS_MOUNT_MF_SYMLINKS;
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MF_SYMLINKS;
+		sbflags &= ~CIFS_MOUNT_MF_SYMLINKS;
 	if (ctx->mfsymlinks) {
 		if (ctx->sfu_emul) {
 			/*
@@ -2062,7 +2063,8 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
 		}
 	}
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SHUTDOWN;
+	sbflags &= ~CIFS_MOUNT_SHUTDOWN;
 
-	return;
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
+	return sbflags;
 }
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index c7e00025518f7..c7d1d0aba0b00 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -313,7 +313,7 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
 extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
-extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
+extern unsigned int smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 /*
  * max deferred close timeout (jiffies) - 2^30
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8c422b3c73662..26590df944f04 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -63,18 +63,18 @@ static void cifs_set_ops(struct inode *inode)
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &cifs_file_inode_ops;
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			set_bit(NETFS_ICTX_UNBUFFERED, &ictx->flags);
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+			if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 				inode->i_fop = &cifs_file_direct_nobrl_ops;
 			else
 				inode->i_fop = &cifs_file_direct_ops;
-		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+		} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO) {
+			if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 				inode->i_fop = &cifs_file_strict_nobrl_ops;
 			else
 				inode->i_fop = &cifs_file_strict_ops;
-		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+		} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 			inode->i_fop = &cifs_file_nobrl_ops;
 		else { /* not direct, send byte range locks */
 			inode->i_fop = &cifs_file_ops;
@@ -212,7 +212,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 
 	/* if dynperm is set, don't clobber existing mode */
 	if (inode->i_state & I_NEW ||
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
@@ -265,7 +265,7 @@ cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		return;
 
 	fattr->cf_uniqueid = iunique(sb, ROOT_I);
@@ -335,7 +335,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
 			kuid_t uid = make_kuid(&init_user_ns, id);
@@ -345,7 +345,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 	
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
 			kgid_t gid = make_kgid(&init_user_ns, id);
@@ -399,7 +399,7 @@ static int update_inode_info(struct super_block *sb,
 	 *
 	 * If file type or uniqueid is different, return error.
 	 */
-	if (unlikely((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (unlikely((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 		     CIFS_I(*inode)->uniqueid != fattr->cf_uniqueid)) {
 		CIFS_I(*inode)->time = 0; /* force reval */
 		return -ESTALE;
@@ -485,7 +485,7 @@ static int cifs_get_unix_fattr(const unsigned char *full_path,
 		cifs_fill_uniqueid(sb, fattr);
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1076,7 +1076,7 @@ cifs_backup_query_path_info(int xid,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0)
 		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	else /* no srvino useful for fallback to some netapp */
 		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -1104,7 +1104,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		if (*inode)
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else
@@ -1363,14 +1363,14 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 	/* query for SFU type info if supported and needed */
 	if ((fattr->cf_cifsattrs & ATTR_SYSTEM) &&
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)) {
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL)) {
 		tmprc = cifs_sfu_type(fattr, full_path, cifs_sb, xid);
 		if (tmprc)
 			cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
 	}
 
 	/* fill in 0777 bits from ACL */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
 				       true, full_path, fid);
 		if (rc == -EREMOTE)
@@ -1380,7 +1380,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
 				       false, full_path, fid);
 		if (rc == -EREMOTE)
@@ -1390,7 +1390,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL)
 		/* fill in remaining high mode bits e.g. SUID, VTX */
 		cifs_sfu_mode(fattr, full_path, cifs_sb, xid);
 	else if (!(tcon->posix_extensions))
@@ -1400,7 +1400,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1500,7 +1500,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	 * 3. Tweak fattr based on mount options
 	 */
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1651,7 +1651,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	int len;
 	int rc;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 	    && cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath);
 		path = kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
@@ -2120,7 +2120,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
 				args.gid = parent->i_gid;
@@ -2138,14 +2138,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 	{
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 		struct TCP_Server_Info *server = tcon->ses->server;
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+		if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) &&
 		    (mode & S_IWUGO) == 0 && server->ops->mkdir_setinfo)
 			server->ops->mkdir_setinfo(inode, full_path, cifs_sb,
 						   tcon, xid);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)
 			inode->i_mode = (mode | S_IFDIR);
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			inode->i_uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				inode->i_gid = parent->i_gid;
@@ -2661,7 +2661,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	}
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
@@ -2702,7 +2702,7 @@ cifs_revalidate_mapping(struct inode *inode)
 
 	if (test_and_clear_bit(CIFS_INO_INVALID_MAPPING, flags)) {
 		/* for cache=singleclient, do not invalidate */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 			goto skip_invalidate;
 
 		cifs_inode->netfs.zero_point = cifs_inode->netfs.remote_i_size;
@@ -2886,12 +2886,12 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	 * enabled, and the admin hasn't overridden them, set the ownership
 	 * to the fsuid/fsgid of the current process.
 	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER) &&
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) &&
 	    !tcon->unix_ext) {
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
+		if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
+		if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID))
 			stat->gid = current_fsgid();
 	}
 	return 0;
@@ -3078,7 +3078,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3218,7 +3218,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
-	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct cifsFileInfo *wfile;
 	struct cifs_tcon *tcon;
 	const char *full_path;
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 2aef6d7617b7b..e4d4b07d40357 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -220,7 +220,7 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 	 */
 	case CIFS_GOING_FLAGS_LOGFLUSH:
 	case CIFS_GOING_FLAGS_NOLOGFLUSH:
-		sbi->mnt_cifs_flags |= CIFS_MOUNT_SHUTDOWN;
+		atomic_or(CIFS_MOUNT_SHUTDOWN, &sbi->mnt_cifs_flags);
 		goto shutdown_good;
 	default:
 		rc = -EINVAL;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index aa45ef6ae99a6..1ba000741a2b9 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -604,9 +604,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL) {
 		rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
 					  full_path, S_IFLNK, 0, symname);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ce8f3fdffc3bd..ccf1adde0c5ec 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -562,13 +562,13 @@ dump_smb(void *buf, int smb_buf_length)
 void
 cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		struct cifs_tcon *tcon = NULL;
 
 		if (cifs_sb->master_tlink)
 			tcon = cifs_sb_master_tcon(cifs_sb);
 
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 		cifs_sb->mnt_cifs_serverino_autodisabled = true;
 		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s\n",
 			 tcon ? tcon->tree_name : "new server");
@@ -669,11 +669,11 @@ void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 bool
 backup_cred(struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPUID) {
 		if (uid_eq(cifs_sb->ctx->backupuid, current_fsuid()))
 			return true;
 	}
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPGID) {
 		if (in_group_p(cifs_sb->ctx->backupgid))
 			return true;
 	}
@@ -1310,7 +1310,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 			convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
 	}
 
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	return 0;
 }
 
@@ -1339,7 +1339,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	 * look up or tcon is not DFS.
 	 */
 	if (strlen(full_path) < 2 || !cifs_sb ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS) ||
 	    !is_tcon_dfs(tcon))
 		return 0;
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 7bf3214117a91..267738553b4fc 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -121,7 +121,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			 * want to clobber the existing one with the one that
 			 * the readdir code created.
 			 */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
 			/*
@@ -215,11 +215,11 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * may look wrong since the inodes may not have timed out by the time
 	 * "ls" does a stat() call on them.
 	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL &&
 	    fattr->cf_cifsattrs & ATTR_SYSTEM) {
 		if (fattr->cf_eof == 0)  {
 			fattr->cf_mode &= ~S_IFMT;
@@ -395,7 +395,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	} else /* not srvinos - BB fixme add check for backlevel? */ {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_FULL_DIRECTORY_INFO;
@@ -412,7 +412,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	if (rc == 0) {
 		cifsFile->invalidHandle = false;
 	} else if ((rc == -EOPNOTSUPP) &&
-		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+		   (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_autodisable_serverino(cifs_sb);
 		goto ffirst_retry;
 	}
@@ -1005,14 +1005,14 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		break;
 	}
 
-	if (de.ino && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (de.ino && (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		fattr.cf_uniqueid = de.ino;
 	} else {
 		fattr.cf_uniqueid = iunique(sb, ROOT_I);
 		cifs_autodisable_serverino(cifs_sb);
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) &&
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) &&
 	    couldbe_mf_symlink(&fattr))
 		/*
 		 * trying to get the type and mode can be slow,
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index f080f92cb1e74..d72a8c1eafcb3 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -32,7 +32,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 {
 	u32 uid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
 	return make_kuid(current_user_ns(), uid);
 }
@@ -42,7 +42,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 {
 	u32 gid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
 	return make_kgid(current_user_ns(), gid);
 }
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 4670c3e451a75..a3263f9afcc3a 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1323,7 +1323,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			.mtime	= NO_CHANGE_64,
 			.device	= dev,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			args.gid = current_fsgid();
 		} else {
@@ -1349,7 +1349,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		return -EPERM;
 	return cifs_sfu_make_node(xid, inode, dentry, tcon,
 				  full_path, mode, dev);
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index f4a38b0ce8402..1a6a8fab1939e 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -495,9 +495,9 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 	__le16 *to;
 	int map_type;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SFM_CHR)
 		map_type = SFM_MAP_UNI_RSVD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		map_type = SFU_MAP_UNI_RSVD;
 	else
 		map_type = NO_MAP_UNI_RSVD;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e99b8e1f66d4f..3aea3be797e8b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1011,7 +1011,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 				rc = -EREMOTE;
 		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;
 		goto out;
 	}
@@ -5321,7 +5321,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	} else {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5a8a9e4ba36db..6b583159beb64 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3127,7 +3127,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		bool set_mode;
 		bool set_owner;
 
-		if ((oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) &&
+		if ((cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) &&
 		    (oparms->mode != ACL_NO_MODE))
 			set_mode = true;
 		else {
@@ -3135,7 +3135,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			oparms->mode = ACL_NO_MODE;
 		}
 
-		if (oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+		if (cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 			set_owner = true;
 		else
 			set_owner = false;
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 58a584f0b27e9..100e43ca39596 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -147,7 +147,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
@@ -299,7 +299,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
@@ -373,7 +373,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
 	tlink = cifs_sb_tlink(cifs_sb);
-- 
2.53.0

