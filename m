Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072F35293FE;
	Thu, 17 Sep 2026 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653736; cv=none; b=XXiebtugxbleQutG08Uj+LP7OIvtmyIQGYxhU44IUeShB8maMbiPa0yLkgn4ZTdL9Rq4qdDJJcChLFxfXDTqPu9ySokZY3LoSOLrU+fngUihPBrunrPjMoN1FsCo3ohVG1BaxlgyXflWjHpf3Tn0/ywqN6vvQtwAehTdQBkvnQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653736; c=relaxed/simple;
	bh=KrVTFqjvqocoDmbGfOXXX7ObLYpof+u93wR1pZB4hOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjJE1RcRwDM2rbNvWCUt+kgqEzW/qeJXcfREbXDNlSEwSv9n5AWlaChypEv4kl8h0TFvdJGbonPPwTVnBTOUMdliG41s2yC1AJ0FOuojdrHh0OsXvN5s8lEZP63PGhIA6CKFjtNF+r96FLAyOq4Ia/ugECmp+aVUYe8T8GizIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWxIxmni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWxIxmni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665021F000FF;
	Thu, 17 Sep 2026 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653732;
	bh=CW6SrAKDdwgWraHhgv/cn6S+Cchsnz3QYC1d2o0Ngws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWxIxmnirD63VYKdE7o7CwxFz2hpGU+SM3y/zsnWX6MoLBBosdwHa6gBBHgpPCp/e
	 xIaUQ9TX7bnitb9KB/ETcMJ0vuPUmR3cGTLpRTthBZN7I+MqpY51JpvAAwBONIvHRV
	 iAmarB6C0Uer1pK7TjqdoSOx9wGP3D7EbIwbAcTsyi0i0+WKcJp9lPzVXrVAojTZNV
	 hhPscRje+GPrZ7xCI61XciKnvUJ1rzV+lARmek2fKVhXAsRjPWCgoxx9TTU93YSZsn
	 v8s5BKx3wzf1tflPdAqGMYTs3co3A8WTZxEZGDH6fgqBWL62H1OYrNOrsC7ovtXm68
	 Ab7F+ykXDUCAg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 2/3] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 10:02:07 -0400
Message-ID: <20260917140208.505903-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917140208.505903-1-sashal@kernel.org>
References: <2026091634-finch-unglazed-c530@gregkh>
 <20260917140208.505903-1-sashal@kernel.org>
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

Adapt the atomic conversion to the 6.6 SMB client. Keep the existing
CIFS_SB/CIFS_FILE_SB interfaces, cifs_remap implementation, shutdown
helper, and smb3_update_mnt_flags signature. Omit the unrelated generic
superblock accessors and changes to newer symlink and I/O code.

Provide cifs_sb_flags as a single-evaluation macro, with the same unsigned
atomic read as upstream, without adding functions. Convert every existing
flag reader and use atomic_or/atomic_andnot for flag updates, including
the legacy reset_cifs_unix_caps path. Keeping bitwise updates in the
mount/remount paths also preserves concurrent changes to other flag bits.

Retain the cifs_getattr sbflags snapshot so cf4d35896621 applies unchanged.
The POSIX ownership condition itself remains for that target commit.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 23. Not backported here:
  fs/smb/client/cifs_unicode.h
  fs/smb/client/fs_context.h
  fs/smb/client/reparse.c
  fs/smb/client/smb2file.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: cf4d35896621 ("smb: client: fix uid/gid override in getattr with posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c   |   2 +-
 fs/smb/client/cifs_fs_sb.h   |   8 ++-
 fs/smb/client/cifs_ioctl.h   |   2 +-
 fs/smb/client/cifs_unicode.c |   4 +-
 fs/smb/client/cifsacl.c      |   6 +-
 fs/smb/client/cifsfs.c       |  66 ++++++++++-----------
 fs/smb/client/cifsglob.h     |  10 +++-
 fs/smb/client/connect.c      |  39 ++++++-------
 fs/smb/client/dfs_cache.c    |   2 +-
 fs/smb/client/dir.c          |  16 +++---
 fs/smb/client/file.c         |  38 ++++++-------
 fs/smb/client/fs_context.c   | 107 +++++++++++++++++------------------
 fs/smb/client/inode.c        |  88 ++++++++++++++--------------
 fs/smb/client/ioctl.c        |   2 +-
 fs/smb/client/link.c         |   2 +-
 fs/smb/client/misc.c         |  12 ++--
 fs/smb/client/readdir.c      |  16 +++---
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |   4 +-
 fs/smb/client/smb2misc.c     |   4 +-
 fs/smb/client/smb2ops.c      |   4 +-
 fs/smb/client/smb2pdu.c      |   4 +-
 fs/smb/client/xattr.c        |   6 +-
 23 files changed, 227 insertions(+), 219 deletions(-)

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
index 6517591922801..c6d6b297c6a5f 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
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
 
@@ -71,4 +72,9 @@ struct cifs_sb_info {
 	 */
 	struct dentry *root;
 };
+
+/* Mount flags are shared by mount/remount and reconnect paths. */
+#define cifs_sb_flags(cifs_sb) \
+	((unsigned int)atomic_read(&(cifs_sb)->mnt_cifs_flags))
+
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index 26327442e383b..5d22b7d43033f 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -125,7 +125,7 @@ struct smb3_notify_info {
 
 static inline bool cifs_forced_shutdown(struct cifs_sb_info *sbi)
 {
-	if (CIFS_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb_flags(sbi))
 		return true;
 	else
 		return false;
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index f8659d36793f1..b6100ae68e618 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -16,9 +16,9 @@ int cifs_remap(struct cifs_sb_info *cifs_sb)
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
index a1c5ef3b2f1eb..de34ab6828650 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -195,7 +195,7 @@ cifs_read_super(struct super_block *sb)
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
 	if (tcon->snapshot_time)
@@ -271,7 +271,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
@@ -372,7 +372,7 @@ static int cifs_permission(struct mnt_idmap *idmap,
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM) {
 		if ((mask & MAY_EXEC) && !execute_ok(inode))
 			return -EACCES;
 		else
@@ -515,13 +515,13 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
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
@@ -592,14 +592,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
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
@@ -638,53 +638,53 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
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
@@ -822,7 +822,7 @@ static int cifs_drop_inode(struct inode *inode)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+	return !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) ||
 		generic_drop_inode(inode);
 }
 
@@ -860,7 +860,7 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		return dget(sb->s_root);
 
 	full_path = cifs_build_path_to_root(ctx, cifs_sb,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a4e0618c58efc..6f5eb01391734 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1538,9 +1538,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_READ(cinode) \
+	((cinode->oplock & CIFS_CACHE_READ_FLG) || \
+	 (cifs_sb_flags(CIFS_SB(cinode->netfs.inode.i_sb)) & CIFS_MOUNT_RO_CACHE))
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+#define CIFS_CACHE_WRITE(cinode) \
+	((cinode->oplock & CIFS_CACHE_WRITE_FLG) || \
+	 (cifs_sb_flags(CIFS_SB(cinode->netfs.inode.i_sb)) & CIFS_MOUNT_RW_CACHE))
 
 /*
  * One of these for each file inode
@@ -1605,7 +1609,7 @@ CIFS_FILE_SB(struct file *file)
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		return '/';
 	else
 		return '\\';
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 68a000956d957..add375797f6a8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2860,8 +2860,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
-	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int oldflags = cifs_sb_flags(old) & CIFS_MOUNT_MASK;
+	unsigned int newflags = cifs_sb_flags(new) & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
@@ -2912,9 +2912,9 @@ static int match_prepath(struct super_block *sb,
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
@@ -2945,7 +2945,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	cifs_sb = CIFS_SB(sb);
 
 	/* We do not want to use a superblock that has been shutdown */
-	if (CIFS_MOUNT_SHUTDOWN & cifs_sb->mnt_cifs_flags) {
+	if (CIFS_MOUNT_SHUTDOWN & cifs_sb_flags(cifs_sb)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
@@ -3329,8 +3329,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
+				atomic_or(CIFS_MOUNT_POSIXACL, &cifs_sb->mnt_cifs_flags);
 		}
 
 		if (ctx && ctx->posix_paths == 0)
@@ -3338,8 +3337,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
+				atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 		}
 
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
@@ -3406,11 +3404,10 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
 	if (ctx->cache_ro) {
 		cifs_dbg(VFS, "mounting share with read only caching. Ensure that the share will not be modified while in use.\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RO_CACHE;
+		atomic_or(CIFS_MOUNT_RO_CACHE, &cifs_sb->mnt_cifs_flags);
 	} else if (ctx->cache_rw) {
 		cifs_dbg(VFS, "mounting share in single client RW caching mode. Ensure that no other systems will be accessing the share.\n");
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_RO_CACHE |
-					    CIFS_MOUNT_RW_CACHE);
+		atomic_or(CIFS_MOUNT_RO_CACHE | CIFS_MOUNT_RW_CACHE, &cifs_sb->mnt_cifs_flags);
 	}
 
 	if ((ctx->cifs_acl) && (ctx->dynperm))
@@ -3420,7 +3417,7 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 		cifs_sb->prepath = kstrdup(ctx->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+		atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	}
 
 	return 0;
@@ -3440,7 +3437,7 @@ void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx)
 	mnt_ctx->ses = NULL;
 	mnt_ctx->tcon = NULL;
 	mnt_ctx->server = NULL;
-	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	atomic_andnot(CIFS_MOUNT_POSIX_PATHS, &mnt_ctx->cifs_sb->mnt_cifs_flags);
 	free_xid(mnt_ctx->xid);
 }
 
@@ -3518,7 +3515,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
+		atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	/* tell server which Unix caps we support */
@@ -3544,11 +3541,11 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
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
@@ -3582,7 +3579,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	 * Inside cifs_fscache_get_super_cookie it checks
 	 * that we do not get super cookie twice.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_FSCACHE)
 		cifs_fscache_get_super_cookie(tcon);
 
 out:
@@ -3701,7 +3698,7 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_server_dbg(VFS, "cannot query dirs between root and final path, enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 			rc = 0;
 		}
 	}
@@ -3732,7 +3729,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
@@ -4310,7 +4307,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	kuid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 70ed4d7e4f37c..44d22765d7d6f 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1342,7 +1342,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
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
index 94c8b173a8d63..4ee37365d169e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -770,7 +770,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		 * close  because it may cause a error when we open this file
 		 * again and get at least level II oplock.
 		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
@@ -861,8 +861,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		 inode, file->f_flags, full_path);
 
 	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
@@ -1010,7 +1010,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -1805,7 +1805,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -2214,7 +2214,7 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 
 	if (!lock && !unlock) {
@@ -2263,7 +2263,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 	/*
 	 * BB add code here to normalize offset and length to account for
@@ -2395,7 +2395,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2451,7 +2451,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 	cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -3283,7 +3283,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	struct folio *folio = page_folio(page);
 	__u32 pid;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = cfile->pid;
 	else
 		pid = current->tgid;
@@ -3376,7 +3376,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -3421,7 +3421,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		 file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -3621,7 +3621,7 @@ cifs_write_from_iter(loff_t fpos, size_t len, struct iov_iter *from,
 	struct TCP_Server_Info *server;
 	unsigned int xid, max_segs = INT_MAX;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -3994,7 +3994,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
-		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+		  && ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = generic_file_write_iter(iocb, from);
 			goto out;
 		}
@@ -4168,7 +4168,7 @@ cifs_send_async_read(loff_t fpos, size_t len, struct cifsFileInfo *open_file,
 		max_segs = server->smbd_conn->max_frmr_depth;
 #endif
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4511,7 +4511,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to);
 
 	/*
@@ -4565,7 +4565,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 		return -ENOSYS;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4755,7 +4755,7 @@ static void cifs_readahead(struct readahead_control *ractl)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -5003,7 +5003,7 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 		struct cifs_sb_info *cifs_sb;
 
 		cifs_sb = CIFS_SB(cifsInode->netfs.inode.i_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0812af0014173..21b9adf72315e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1875,136 +1875,135 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
 
 	if (ctx->nodfs)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
+		atomic_or(CIFS_MOUNT_NO_DFS, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_DFS;
+		atomic_andnot(CIFS_MOUNT_NO_DFS, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->noperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
+		atomic_or(CIFS_MOUNT_NO_PERM, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_PERM;
+		atomic_andnot(CIFS_MOUNT_NO_PERM, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->setuids)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
+		atomic_or(CIFS_MOUNT_SET_UID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SET_UID;
+		atomic_andnot(CIFS_MOUNT_SET_UID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->setuidfromacl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
+		atomic_or(CIFS_MOUNT_UID_FROM_ACL, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UID_FROM_ACL;
+		atomic_andnot(CIFS_MOUNT_UID_FROM_ACL, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->server_ino)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
+		atomic_or(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SFM_CHR;
+		atomic_or(CIFS_MOUNT_MAP_SFM_CHR, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SFM_CHR;
+		atomic_andnot(CIFS_MOUNT_MAP_SFM_CHR, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->sfu_remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
+		atomic_or(CIFS_MOUNT_MAP_SPECIAL_CHR, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SPECIAL_CHR;
+		atomic_andnot(CIFS_MOUNT_MAP_SPECIAL_CHR, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->no_xattr)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_XATTR;
+		atomic_or(CIFS_MOUNT_NO_XATTR, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_XATTR;
+		atomic_andnot(CIFS_MOUNT_NO_XATTR, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->sfu_emul)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
+		atomic_or(CIFS_MOUNT_UNX_EMUL, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UNX_EMUL;
+		atomic_andnot(CIFS_MOUNT_UNX_EMUL, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->nobrl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
+		atomic_or(CIFS_MOUNT_NO_BRL, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_BRL;
+		atomic_andnot(CIFS_MOUNT_NO_BRL, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->nohandlecache)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_HANDLE_CACHE;
+		atomic_or(CIFS_MOUNT_NO_HANDLE_CACHE, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_HANDLE_CACHE;
+		atomic_andnot(CIFS_MOUNT_NO_HANDLE_CACHE, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->nostrictsync)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
+		atomic_or(CIFS_MOUNT_NOSSYNC, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOSSYNC;
+		atomic_andnot(CIFS_MOUNT_NOSSYNC, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->mand_lock)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+		atomic_or(CIFS_MOUNT_NOPOSIXBRL, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOPOSIXBRL;
+		atomic_andnot(CIFS_MOUNT_NOPOSIXBRL, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->rwpidforward)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
+		atomic_or(CIFS_MOUNT_RWPIDFORWARD, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_RWPIDFORWARD;
+		atomic_andnot(CIFS_MOUNT_RWPIDFORWARD, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->mode_ace)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MODE_FROM_SID;
+		atomic_or(CIFS_MOUNT_MODE_FROM_SID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MODE_FROM_SID;
+		atomic_andnot(CIFS_MOUNT_MODE_FROM_SID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->cifs_acl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
+		atomic_or(CIFS_MOUNT_CIFS_ACL, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_ACL;
+		atomic_andnot(CIFS_MOUNT_CIFS_ACL, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->backupuid_specified)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
+		atomic_or(CIFS_MOUNT_CIFS_BACKUPUID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPUID;
+		atomic_andnot(CIFS_MOUNT_CIFS_BACKUPUID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->backupgid_specified)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
+		atomic_or(CIFS_MOUNT_CIFS_BACKUPGID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPGID;
+		atomic_andnot(CIFS_MOUNT_CIFS_BACKUPGID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->override_uid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
+		atomic_or(CIFS_MOUNT_OVERR_UID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_UID;
+		atomic_andnot(CIFS_MOUNT_OVERR_UID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->override_gid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
+		atomic_or(CIFS_MOUNT_OVERR_GID, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_GID;
+		atomic_andnot(CIFS_MOUNT_OVERR_GID, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->dynperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
+		atomic_or(CIFS_MOUNT_DYNPERM, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DYNPERM;
+		atomic_andnot(CIFS_MOUNT_DYNPERM, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->fsc)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
+		atomic_or(CIFS_MOUNT_FSCACHE, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_FSCACHE;
+		atomic_andnot(CIFS_MOUNT_FSCACHE, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->multiuser)
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
-					    CIFS_MOUNT_NO_PERM);
+		atomic_or(CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_NO_PERM, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MULTIUSER;
+		atomic_andnot(CIFS_MOUNT_MULTIUSER, &cifs_sb->mnt_cifs_flags);
 
 
 	if (ctx->strict_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
+		atomic_or(CIFS_MOUNT_STRICT_IO, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_STRICT_IO;
+		atomic_andnot(CIFS_MOUNT_STRICT_IO, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->direct_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
+		atomic_or(CIFS_MOUNT_DIRECT_IO, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DIRECT_IO;
+		atomic_andnot(CIFS_MOUNT_DIRECT_IO, &cifs_sb->mnt_cifs_flags);
 
 	if (ctx->mfsymlinks)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
+		atomic_or(CIFS_MOUNT_MF_SYMLINKS, &cifs_sb->mnt_cifs_flags);
 	else
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MF_SYMLINKS;
+		atomic_andnot(CIFS_MOUNT_MF_SYMLINKS, &cifs_sb->mnt_cifs_flags);
 	if (ctx->mfsymlinks) {
 		if (ctx->sfu_emul) {
 			/*
@@ -2021,7 +2020,7 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
 		}
 	}
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SHUTDOWN;
+	atomic_andnot(CIFS_MOUNT_SHUTDOWN, &cifs_sb->mnt_cifs_flags);
 
 	return;
 }
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cca480ab7e64b..af4a99ccafc20 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -35,17 +35,17 @@ static void cifs_set_ops(struct inode *inode)
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
@@ -197,7 +197,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 
 	/* if dynperm is set, don't clobber existing mode */
 	if (inode->i_state & I_NEW ||
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
@@ -248,7 +248,7 @@ cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		return;
 
 	fattr->cf_uniqueid = iunique(sb, ROOT_I);
@@ -318,7 +318,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
 			kuid_t uid = make_kuid(&init_user_ns, id);
@@ -328,7 +328,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 	
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
 			kgid_t gid = make_kgid(&init_user_ns, id);
@@ -382,7 +382,7 @@ static int update_inode_info(struct super_block *sb,
 	 *
 	 * If file type or uniqueid is different, return error.
 	 */
-	if (unlikely((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (unlikely((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 		     CIFS_I(*inode)->uniqueid != fattr->cf_uniqueid)) {
 		CIFS_I(*inode)->time = 0; /* force reval */
 		return -ESTALE;
@@ -468,7 +468,7 @@ static int cifs_get_unix_fattr(const unsigned char *full_path,
 		cifs_fill_uniqueid(sb, fattr);
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1015,7 +1015,7 @@ cifs_backup_query_path_info(int xid,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0)
 		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	else /* no srvino useful for fallback to some netapp */
 		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -1043,7 +1043,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		if (*inode)
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else
@@ -1302,14 +1302,14 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
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
@@ -1319,7 +1319,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
 				       false, full_path, fid);
 		if (rc == -EREMOTE)
@@ -1329,7 +1329,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL)
 		/* fill in remaining high mode bits e.g. SUID, VTX */
 		cifs_sfu_mode(fattr, full_path, cifs_sb, xid);
 	else if (!(tcon->posix_extensions))
@@ -1339,7 +1339,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1439,7 +1439,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	 * 3. Tweak fattr based on mount options
 	 */
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1590,7 +1590,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	int len;
 	int rc;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 	    && cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath);
 		path = kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
@@ -2058,7 +2058,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
 				args.gid = parent->i_gid;
@@ -2076,14 +2076,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
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
@@ -2129,7 +2129,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 		/* no return info, go query for it */
 		goto posix_mkdir_get_info;
 	/*
-	 * BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if
+	 * BB check (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID ) to see if
 	 * need to set uid/gid.
 	 */
 
@@ -2597,7 +2597,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	}
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
@@ -2655,7 +2655,7 @@ cifs_revalidate_mapping(struct inode *inode)
 
 	if (test_and_clear_bit(CIFS_INO_INVALID_MAPPING, flags)) {
 		/* for cache=singleclient, do not invalidate */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 			goto skip_invalidate;
 
 		rc = cifs_invalidate_mapping(inode);
@@ -2779,6 +2779,7 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct inode *inode = d_inode(dentry);
+	unsigned int sbflags;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
@@ -2835,12 +2836,13 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
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
@@ -3025,7 +3027,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3177,7 +3179,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3211,7 +3213,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if ((attrs->ia_valid & ATTR_MTIME) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);
@@ -3237,8 +3239,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
@@ -3249,9 +3251,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				goto cifs_setattr_exit;
 			}
 		}
-	} else
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
+	} else if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID)) {
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
+	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
@@ -3260,8 +3262,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		mode = attrs->ia_mode;
 		rc = 0;
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) ||
+		if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) ||
 		    posix) {
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
 						INVALID_UID, INVALID_GID);
@@ -3284,7 +3286,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
 
 			/* fix up mode if we're not using dynperm */
-			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
+			if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM) == 0)
 				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
 		} else if ((mode & S_IWUGO) &&
 			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
@@ -3295,7 +3297,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				dosattr |= ATTR_NORMAL;
 
 			/* reset local inode permissions to normal */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
@@ -3304,7 +3306,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 					attrs->ia_mode |=
 						cifs_sb->ctx->file_mode;
 			}
-		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+		} else if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
 			attrs->ia_valid &= ~ATTR_MODE;
 		}
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 8a668b827570a..00199176ad82e 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -209,7 +209,7 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 	 */
 	case CIFS_GOING_FLAGS_LOGFLUSH:
 	case CIFS_GOING_FLAGS_NOLOGFLUSH:
-		sbi->mnt_cifs_flags |= CIFS_MOUNT_SHUTDOWN;
+		atomic_or(CIFS_MOUNT_SHUTDOWN, &sbi->mnt_cifs_flags);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 007da0a699cb0..d235ad37fceb6 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -603,7 +603,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	} else if (pTcon->unix_ext) {
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 29a390a497aef..2200ff92221fe 100644
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
@@ -1373,7 +1373,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 			convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
 	}
 
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	return 0;
 }
 
@@ -1402,7 +1402,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	 * look up or tcon is not DFS.
 	 */
 	if (strlen(full_path) < 2 || !cifs_sb ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS) ||
 	    !is_tcon_dfs(tcon))
 		return 0;
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 5febf8afaab04..6faa73d096c78 100644
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
index ff05b0e75c928..c15e4541cca06 100644
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
index 6acadfcbadc8e..4654577c54ddd 100644
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
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		return -EPERM;
 	return cifs_sfu_make_node(xid, inode, dentry, tcon,
 				  full_path, mode, dev);
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 6fa23cf7a529e..c0e263b0bd71f 100644
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
index 8a15694c1bbb5..6156d863dc824 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -969,7 +969,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 				rc = -EREMOTE;
 		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;
 		goto out;
 	}
@@ -5166,7 +5166,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	} else {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8bb739d150c05..ee2d1994467ed 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3121,7 +3121,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		bool set_mode;
 		bool set_owner;
 
-		if ((oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) &&
+		if ((cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) &&
 		    (oparms->mode != ACL_NO_MODE))
 			set_mode = true;
 		else {
@@ -3129,7 +3129,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			oparms->mode = ACL_NO_MODE;
 		}
 
-		if (oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+		if (cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 			set_owner = true;
 		else
 			set_owner = false;
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index e8696ad4da994..a0f6eeb0c86ca 100644
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

