Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5BA4CDDF7;
	Thu, 17 Sep 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670382; cv=none; b=RAZbN6NOsNaqDhXMOdIPViOD2kGOe9GybGTew0K1zbYkk/S4cjwYbs0NsTA3/AmSEGAzgGHgSWThowP/XjBzz+TMtHF8m3AuYh7wQkOWjUEy0qtyPvuucdjj0Gz5eWCZ6/zdG4icFEsxdCy2ZmM53Wlvw2RZ8z0RlVwUfkO2PE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670382; c=relaxed/simple;
	bh=ES+wrlflL0dYmlhZPXmo2KquWpWv5jg0ZSGQoVa6Tb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixEpE+Afqzlai+iqbWe9/A5r0p6RTX6all2astys/hDEQnlcfOAlFw9x5nfo1gZYW4hCBLbAT1P0NvWAjonCdjf+hnrIcs+eookEEazttaf2K7dxyicm/GfJyNBwvxoEQo9ZSuJHjhiR8SGQxgo1KpwZtgqUtYWqk6HDo7oPENE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJd/dPwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJd/dPwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18051F00898;
	Thu, 17 Sep 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789670377;
	bh=PvM5aVeMLPtH56o0j8DKVj0vl6tA6FtVT3OY9lopMHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJd/dPwe9GBeZIF26dlM9neNshKz6olX8jG4a4Z8d22e9rq32VgOjMpsN7xKxpQkX
	 Ijh8QN0uxgW+XOAr0vOABoKyhPvzd7n09SEGC3Dn80QQDTuYwfDtyKHFE4waclidi8
	 WDNvp6BDlHk7EbApxbQD+1SOBkl5ip1KKDOcyQbfPw/xy3BYrwECDarL1lLJM1gIGr
	 iAVn2Q7aytY05VjvS2cy9ljGXzj+4w/7GAinoUHr1Cy8ileVoPWqiw4boQrQyk85If
	 guYDxWAUo1CVp93sewaJTiiRSz1DG7kmy4kvRbJqAzVL+mMGsGcrfi6bj6Tvm52na6
	 Rtsvb0ff6Gnyw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 1/2] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 14:39:34 -0400
Message-ID: <20260917183935.1200920-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091635-untwist-absently-462b@gregkh>
References: <2026091635-untwist-absently-462b@gregkh>
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

Backport to 5.15 as a dependency of
cf4d35896621b7298eef51b7a465e5c0cb22f670.

Adapt the conversion to fs/cifs and its existing mount/reconnect, legacy
I/O, DFS and fscache paths. Drop hunks for newer cached-dir and reparse
code that is absent here. Retain the existing CIFS_SB/CIFS_FILE_SB,
cifs_remap and cifs_forced_shutdown functions in place; do not introduce
the upstream generic-pointer helpers or any new functions.

Provide cifs_sb_flags as an atomic-read macro. Convert existing reads
and bit updates to atomic accesses, and publish mount-option updates
with atomic_set while retaining the existing void updater interface.
Use a single sbflags snapshot in cifs_getattr so the target's ownership
condition patch applies unchanged after the fs/smb/client -> fs/cifs
path mapping. Leave the POSIX ownership fix for the target commit.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 23. Not backported here:
  fs/smb/client/cached_dir.c
  fs/smb/client/cifsacl.c
  fs/smb/client/cifsfs.c
  fs/smb/client/cifs_fs_sb.h
  fs/smb/client/cifsglob.h
  fs/smb/client/cifs_ioctl.h
  fs/smb/client/cifs_unicode.c
  fs/smb/client/cifs_unicode.h
  ... and 19 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: cf4d35896621 ("smb: client: fix uid/gid override in getattr with posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_dfs_ref.c |   2 +-
 fs/cifs/cifs_fs_sb.h   |   8 ++-
 fs/cifs/cifs_ioctl.h   |   2 +-
 fs/cifs/cifs_unicode.c |   4 +-
 fs/cifs/cifsacl.c      |   6 +--
 fs/cifs/cifsfs.c       |  66 ++++++++++++-------------
 fs/cifs/cifsglob.h     |   8 +--
 fs/cifs/connect.c      |  43 ++++++++--------
 fs/cifs/dfs_cache.c    |   2 +-
 fs/cifs/dir.c          |  16 +++---
 fs/cifs/file.c         |  38 +++++++-------
 fs/cifs/fs_context.c   | 109 +++++++++++++++++++++--------------------
 fs/cifs/fscache.c      |   2 +-
 fs/cifs/inode.c        |  90 +++++++++++++++++-----------------
 fs/cifs/ioctl.c        |   2 +-
 fs/cifs/link.c         |   4 +-
 fs/cifs/misc.c         |  10 ++--
 fs/cifs/readdir.c      |  18 +++----
 fs/cifs/smb1ops.c      |   4 +-
 fs/cifs/smb2misc.c     |   4 +-
 fs/cifs/smb2ops.c      |   2 +-
 fs/cifs/smb2pdu.c      |   4 +-
 fs/cifs/xattr.c        |   6 +--
 23 files changed, 231 insertions(+), 219 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 2c6dee3f097b8..501ca9d8bf266 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -298,7 +298,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
 	 * gives us the latter, so we must adjust the result.
 	 */
 	cifs_sb = CIFS_SB(mntpt->d_sb);
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS)
 		return ERR_PTR(-EREMOTE);
 
 	cur_ctx = cifs_sb->ctx;
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 013a4bd65280c..7117fcc32e54b 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -10,6 +10,7 @@
 #ifndef _CIFS_FS_SB_H
 #define _CIFS_FS_SB_H
 
+#include <linux/atomic.h>
 #include <linux/backing-dev.h>
 
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
@@ -54,7 +55,7 @@ struct cifs_sb_info {
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
-	unsigned int mnt_cifs_flags;
+	atomic_t mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
@@ -73,4 +74,9 @@ struct cifs_sb_info {
 	 */
 	struct dentry *root;
 };
+
+/* Mount flags may change concurrently during mount/remount and reconnect. */
+#define cifs_sb_flags(cifs_sb) \
+	((unsigned int)atomic_read(&(cifs_sb)->mnt_cifs_flags))
+
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index b87cbbe6d2d4b..bd10906bcb201 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -111,7 +111,7 @@ struct smb3_notify {
 
 static inline bool cifs_forced_shutdown(struct cifs_sb_info *sbi)
 {
-	if (CIFS_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb_flags(sbi))
 		return true;
 	else
 		return false;
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index e7582dd791794..921d55f7d0da2 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -17,9 +17,9 @@ int cifs_remap(struct cifs_sb_info *cifs_sb)
 {
 	int map_type;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SFM_CHR)
 		map_type = SFM_MAP_UNI_RSVD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		map_type = SFU_MAP_UNI_RSVD;
 	else
 		map_type = NO_MAP_UNI_RSVD;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1b52e0c88877a..b4413bd043c5b 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -351,7 +351,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		return -EIO;
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL) ||
 	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
 		bool is_group;
@@ -1694,12 +1694,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
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
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7bdeaecc6c508..0d582348931a7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -162,7 +162,7 @@ cifs_read_super(struct super_block *sb)
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
 	if (tcon->snapshot_time)
@@ -238,7 +238,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
@@ -339,7 +339,7 @@ static int cifs_permission(struct user_namespace *mnt_userns,
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM) {
 		if ((mask & MAY_EXEC) && !execute_ok(inode))
 			return -EACCES;
 		else
@@ -474,13 +474,13 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
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
@@ -551,14 +551,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
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
@@ -595,53 +595,53 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
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
@@ -760,7 +760,7 @@ static int cifs_drop_inode(struct inode *inode)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+	return !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) ||
 		generic_drop_inode(inode);
 }
 
@@ -797,7 +797,7 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		return dget(sb->s_root);
 
 	full_path = cifs_build_path_to_root(ctx, cifs_sb,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9b08020634f19..7167a14a29fc5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1393,9 +1393,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || \
+	(cifs_sb_flags(CIFS_SB(cinode->vfs_inode.i_sb)) & CIFS_MOUNT_RO_CACHE))
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || \
+	(cifs_sb_flags(CIFS_SB(cinode->vfs_inode.i_sb)) & CIFS_MOUNT_RW_CACHE))
 
 /*
  * One of these for each file inode
@@ -1461,7 +1463,7 @@ CIFS_FILE_SB(struct file *file)
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		return '/';
 	else
 		return '\\';
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d35474b836007..73f290574b826 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2418,8 +2418,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
-	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int oldflags = cifs_sb_flags(old) & CIFS_MOUNT_MASK;
+	unsigned int newflags = cifs_sb_flags(new) & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
@@ -2466,9 +2466,9 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	bool old_set = (cifs_sb_flags(old) & CIFS_MOUNT_USE_PREFIX_PATH) &&
 		old->prepath;
-	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	bool new_set = (cifs_sb_flags(new) & CIFS_MOUNT_USE_PREFIX_PATH) &&
 		new->prepath;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
@@ -2495,7 +2495,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	cifs_sb = CIFS_SB(sb);
 
 	/* We do not want to use a superblock that has been shutdown */
-	if (CIFS_MOUNT_SHUTDOWN & cifs_sb->mnt_cifs_flags) {
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb_flags(cifs_sb)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
@@ -2860,8 +2860,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
+				atomic_or(CIFS_MOUNT_POSIXACL,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		if (ctx && ctx->posix_paths == 0)
@@ -2869,8 +2869,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
+				atomic_or(CIFS_MOUNT_POSIX_PATHS,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
@@ -2936,11 +2936,11 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
 	if (ctx->cache_ro) {
 		cifs_dbg(VFS, "mounting share with read only caching. Ensure that the share will not be modified while in use.\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RO_CACHE;
+		atomic_or(CIFS_MOUNT_RO_CACHE, &cifs_sb->mnt_cifs_flags);
 	} else if (ctx->cache_rw) {
 		cifs_dbg(VFS, "mounting share in single client RW caching mode. Ensure that no other systems will be accessing the share.\n");
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_RO_CACHE |
-					    CIFS_MOUNT_RW_CACHE);
+		atomic_or(CIFS_MOUNT_RO_CACHE | CIFS_MOUNT_RW_CACHE,
+			  &cifs_sb->mnt_cifs_flags);
 	}
 
 	if ((ctx->cifs_acl) && (ctx->dynperm))
@@ -2950,7 +2950,7 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 		cifs_sb->prepath = kstrdup(ctx->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+		atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	}
 
 	return 0;
@@ -2967,7 +2967,7 @@ static inline void mount_put_conns(struct mount_ctx *mnt_ctx)
 		cifs_put_smb_ses(mnt_ctx->ses);
 	else if (mnt_ctx->server)
 		cifs_put_tcp_session(mnt_ctx->server, 0);
-	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	atomic_andnot(CIFS_MOUNT_POSIX_PATHS, &mnt_ctx->cifs_sb->mnt_cifs_flags);
 	free_xid(mnt_ctx->xid);
 }
 
@@ -3017,7 +3017,7 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
+		atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 
 	/* tell server which Unix caps we support */
 	if (cap_unix(tcon->ses)) {
@@ -3038,11 +3038,11 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(xid, tcon, cifs_sb);
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
@@ -3322,7 +3322,8 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_server_dbg(VFS, "cannot query dirs between root and final path, enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			atomic_or(CIFS_MOUNT_USE_PREFIX_PATH,
+				  &cifs_sb->mnt_cifs_flags);
 			rc = 0;
 		}
 	}
@@ -3359,7 +3360,7 @@ static int is_dfs_mount(struct mount_ctx *mnt_ctx, bool *isdfs, struct dfs_cache
 	 * Skip prefix path to provide support for DFS referrals from w2k8 servers which don't seem
 	 * to respond with PATH_NOT_COVERED to requests that include the prefix.
 	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS) ||
 	    dfs_cache_find(mnt_ctx->xid, mnt_ctx->ses, cifs_sb->local_nls, cifs_remap(cifs_sb),
 			   ctx->UNC + 1, NULL, root_tl)) {
 		if (rc)
@@ -3575,7 +3576,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
@@ -4004,7 +4005,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	kuid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index c78accc623ec9..2d7ee74c936c0 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1497,7 +1497,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	rc = refresh_tcon(sessions, tcon, true);
 
 	kref_put(&mg->refcount, mount_group_release);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 83c929dd6ed59..cfeebdf0400eb 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -96,7 +96,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	else
 		dfsplen = 0;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
 	s = dentry_path_raw(direntry, page, PATH_MAX);
@@ -123,7 +123,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	if (dfsplen) {
 		s -= dfsplen;
 		memcpy(s, tcon->treeName, dfsplen);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
 				if (s[i] == '\\')
@@ -150,7 +150,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)) {
 		for (i = 0; i < direntry->d_name.len; i++) {
 			if (direntry->d_name.name[i] == '\\') {
 				cifs_dbg(FYI, "Invalid file name\n");
@@ -328,7 +328,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				.device	= 0,
 		};
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				args.gid = inode->i_gid;
@@ -363,9 +363,9 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
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
@@ -494,8 +494,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	}
 
 	if (file->f_flags & O_DIRECT &&
-	    CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(CIFS_SB(inode->i_sb)) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(CIFS_SB(inode->i_sb)) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 71f585a41d456..c79cc70c89326 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -477,7 +477,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		 * close  because it may cause a error when we open this file
 		 * again and get at least level II oplock.
 		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
@@ -555,8 +555,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		 inode, file->f_flags, full_path);
 
 	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
@@ -682,7 +682,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
@@ -1443,7 +1443,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
@@ -1823,7 +1823,7 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 
 	if (!lock && !unlock) {
@@ -1872,7 +1872,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 	/*
 	 * BB add code here to normalize offset and length to account for
@@ -2004,7 +2004,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2060,7 +2060,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2607,7 +2607,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
 	__u32 pid;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = cfile->pid;
 	else
 		pid = current->tgid;
@@ -2693,7 +2693,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2738,7 +2738,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		 file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2985,7 +2985,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	size_t start;
 	unsigned int xid;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -3386,7 +3386,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
-		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+		  && ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = generic_file_write_iter(iocb, from);
 			goto out;
 		}
@@ -3723,7 +3723,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4102,7 +4102,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to);
 
 	/*
@@ -4156,7 +4156,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 		return -ENOSYS;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4494,7 +4494,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		return rc;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4731,7 +4731,7 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		struct cifs_sb_info *cifs_sb;
 
 		cifs_sb = CIFS_SB(cifsInode->vfs_inode.i_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0336580062067..409e87c5dd2be 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1606,139 +1606,139 @@ smb3_cleanup_fs_context(struct smb3_fs_context *ctx)
 
 void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
 
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
-					    CIFS_MOUNT_NO_PERM);
+		sbflags |= CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_NO_PERM;
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
@@ -1755,7 +1755,8 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
 		}
 	}
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SHUTDOWN;
+	sbflags &= ~CIFS_MOUNT_SHUTDOWN;
 
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	return;
 }
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 8eedd20c44abd..edb06d8093404 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -153,7 +153,7 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
 	if (cifsi->fscache)
 		return;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_FSCACHE))
 		return;
 
 	cifs_fscache_acquire_inode_cookie(cifsi, tcon);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index bb0b172c5a74d..537e5baf4ca24 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -33,17 +33,17 @@ static void cifs_set_ops(struct inode *inode)
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &cifs_file_inode_ops;
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
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
@@ -175,7 +175,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	/* if dynperm is set, don't clobber existing mode */
 	if (inode->i_state & I_NEW ||
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
@@ -219,7 +219,7 @@ cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		return;
 
 	fattr->cf_uniqueid = iunique(sb, ROOT_I);
@@ -289,7 +289,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
 			kuid_t uid = make_kuid(&init_user_ns, id);
@@ -299,7 +299,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 	
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
 			kgid_t gid = make_kgid(&init_user_ns, id);
@@ -397,7 +397,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	}
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		int tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
 					     full_path);
 		if (tmprc)
@@ -414,7 +414,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -825,7 +825,7 @@ cifs_backup_query_path_info(int xid,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0)
 		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	else /* no srvino useful for fallback to some netapp */
 		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -857,7 +857,7 @@ cifs_set_fattr_ino(int xid,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		if (*inode)
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else
@@ -1031,14 +1031,14 @@ cifs_get_inode_info(struct inode **inode,
 handle_mnt_opt:
 	/* query for SFU type info if supported and needed */
 	if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	    cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL) {
 		tmprc = cifs_sfu_type(&fattr, full_path, cifs_sb, xid);
 		if (tmprc)
 			cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
 	}
 
 	/* fill in 0777 bits from ACL */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
 				       full_path, fid);
 		if (rc == -EREMOTE)
@@ -1048,7 +1048,7 @@ cifs_get_inode_info(struct inode **inode,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
 				       full_path, fid);
 		if (rc == -EREMOTE)
@@ -1061,11 +1061,11 @@ cifs_get_inode_info(struct inode **inode,
 	}
 
 	/* fill in remaining high mode bits e.g. SUID, VTX */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL)
 		cifs_sfu_mode(&fattr, full_path, cifs_sb, xid);
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
 					 full_path);
 		if (tmprc)
@@ -1084,7 +1084,7 @@ cifs_get_inode_info(struct inode **inode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -1170,7 +1170,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 	 */
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
 					 full_path);
 		if (tmprc)
@@ -1189,7 +1189,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -1320,7 +1320,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	char *path = NULL;
 	int len;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 	    && cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath);
 		path = kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
@@ -1752,7 +1752,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
 				args.gid = parent->i_gid;
@@ -1767,14 +1767,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 				       cifs_remap(cifs_sb));
 	} else {
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
@@ -1819,7 +1819,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 		/* no return info, go query for it */
 		goto posix_mkdir_get_info;
 	/*
-	 * BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if
+	 * BB check (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID ) to see if
 	 * need to set uid/gid.
 	 */
 
@@ -2252,7 +2252,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	}
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
@@ -2311,7 +2311,7 @@ cifs_revalidate_mapping(struct inode *inode)
 
 	if (test_and_clear_bit(CIFS_INO_INVALID_MAPPING, flags)) {
 		/* for cache=singleclient, do not invalidate */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 			goto skip_invalidate;
 
 		rc = cifs_invalidate_mapping(inode);
@@ -2429,6 +2429,7 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct inode *inode = d_inode(dentry);
+	unsigned int sbflags;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
@@ -2485,12 +2486,13 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	 * enabled, and the admin hasn't overridden them, set the ownership
 	 * to the fsuid/fsgid of the current process.
 	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+	sbflags = cifs_sb_flags(cifs_sb);
+	if ((sbflags & CIFS_MOUNT_MULTIUSER) &&
+	    !(sbflags & CIFS_MOUNT_CIFS_ACL) &&
 	    !tcon->unix_ext) {
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
+		if (!(sbflags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
+		if (!(sbflags & CIFS_MOUNT_OVERR_GID))
 			stat->gid = current_fsgid();
 	}
 	return 0;
@@ -2674,7 +2676,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&init_user_ns, direntry, attrs);
@@ -2822,7 +2824,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&init_user_ns, direntry, attrs);
@@ -2856,7 +2858,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if ((attrs->ia_valid & ATTR_MTIME) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);
@@ -2882,8 +2884,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
@@ -2895,7 +2897,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			}
 		}
 	} else
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID))
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
 
 	/* skip mode change if it's just for clearing setuid/setgid */
@@ -2905,8 +2907,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		mode = attrs->ia_mode;
 		rc = 0;
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+		if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
 						INVALID_UID, INVALID_GID);
 			if (rc) {
@@ -2928,7 +2930,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
 
 			/* fix up mode if we're not using dynperm */
-			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
+			if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM) == 0)
 				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
 		} else if ((mode & S_IWUGO) &&
 			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
@@ -2939,7 +2941,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				dosattr |= ATTR_NORMAL;
 
 			/* reset local inode permissions to normal */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
@@ -2948,7 +2950,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 					attrs->ia_mode |=
 						cifs_sb->ctx->file_mode;
 			}
-		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+		} else if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
 			attrs->ia_valid &= ~ATTR_MODE;
 		}
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 566e04fd01581..a159c1f0384de 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -194,7 +194,7 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 	 */
 	case CIFS_GOING_FLAGS_LOGFLUSH:
 	case CIFS_GOING_FLAGS_NOLOGFLUSH:
-		sbi->mnt_cifs_flags |= CIFS_MOUNT_SHUTDOWN;
+		atomic_or(CIFS_MOUNT_SHUTDOWN, &sbi->mnt_cifs_flags);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 4308b27ba3464..0729af14ca7e2 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -638,7 +638,7 @@ cifs_get_link(struct dentry *direntry, struct inode *inode,
 	 * First try Minshall+French Symlinks, if configured
 	 * and fallback to UNIX Extensions Symlinks.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS)
 		rc = query_mf_symlink(xid, tcon, cifs_sb, full_path,
 				      &target_path);
 
@@ -703,7 +703,7 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS)
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index cb7fb2c4ea71f..2f8f3aef57fb6 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -528,13 +528,13 @@ dump_smb(void *buf, int smb_buf_length)
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
 			 tcon ? tcon->treeName : "new server");
@@ -635,11 +635,11 @@ void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
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
@@ -1331,7 +1331,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	} else
 		cifs_sb->prepath = NULL;
 
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	return 0;
 }
 #endif
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 7c47a03afbcc3..47a29359db6ec 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -100,7 +100,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			 * want to clobber the existing one with the one that
 			 * the readdir code created.
 			 */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
 			/* update inode in place
@@ -206,11 +206,11 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
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
@@ -421,7 +421,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	} else /* not srvinos - BB fixme add check for backlevel? */ {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -441,8 +441,8 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	else if STATUS_STOPPED_ON_SYMLINK
 		call get_symlink_reparse_path and retry with new path */
 	else if ((rc == -EOPNOTSUPP) &&
-		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
+		atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 		goto ffirst_retry;
 	}
 error_exit:
@@ -915,14 +915,14 @@ static int cifs_filldir(char *find_entry, struct file *file,
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
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 41e468d06b5b0..dd892a37440e7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1050,7 +1050,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			.mtime	= NO_CHANGE_64,
 			.device	= dev,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			args.gid = current_fsgid();
 		} else {
@@ -1075,7 +1075,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	 * SMB1 SFU emulation: should work with all servers, but only
 	 * support block and char device (no socket & fifo)
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		goto out;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode))
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index c8171dc04bf43..bd1db0b1ca434 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -473,9 +473,9 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
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
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3aaa45375d8ba..7e6428f8d2877 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5363,7 +5363,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		goto out;
 
 	/*
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e93dd51a88557..bc1286afe99e0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2869,7 +2869,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		bool set_mode;
 		bool set_owner;
 
-		if ((oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) &&
+		if ((cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) &&
 		    (oparms->mode != ACL_NO_MODE))
 			set_mode = true;
 		else {
@@ -2877,7 +2877,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			oparms->mode = ACL_NO_MODE;
 		}
 
-		if (oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+		if (cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 			set_owner = true;
 		else
 			set_owner = false;
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 6f719b9cf9e9e..e252e83c9dc23 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -147,7 +147,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
@@ -323,7 +323,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
@@ -417,7 +417,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
 	tlink = cifs_sb_tlink(cifs_sb);
-- 
2.53.0

