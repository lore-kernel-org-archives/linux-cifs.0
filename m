Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2C72561A7;
	Fri, 18 Sep 2026 00:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789691322; cv=none; b=jFgQpd05qJQmja/95refUM801hxCRqueEMi8XVXZqEIKDKr6uzwv5E3iF5pMOF9SDZ3YOpJezh8izKkcVTBlFKV0CvF3dsA+5xpULGfqdbCfqgmAaoQEyoWDyrpzmKzw9+7ZAixktp2WFKn6nOtnvEbziWnD+cKM8tOEUczWcmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789691322; c=relaxed/simple;
	bh=Rcf352jo6Iuq/Hqu93TmjV5ot3O+P52PRCmCM+fKIJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhVYbCmc2O6fEt2Hcc0nSZh5v6G7fvKwNFtN7plRNNUGDtolKv6u/bvq6ByR/WU/IX9u2IZevGsFE45c7bgHXLdthX/MsK7s/uxS/KCbumqCKaosb0/CNDh+YyRLtwUJ7jGHqpdj4By9Pvmn6AK3b7FDAQdUkbmTgWQAUWkBrRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwnG/81F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwnG/81F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DD61F000FF;
	Fri, 18 Sep 2026 00:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789691314;
	bh=gTTzWtAuyAmAlkQmRYK182MjSpE5c6BOa0uq9RnZc64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwnG/81FXMnFQaHxJ1vjm+ZCmJVduSRXNhPn2BnTTwrfpLYKq+FSU4/5Yt0TUIY3e
	 CjKJroA7MhrRkwOiyZfzZZ1riyuvvWjV8DcuGWwkePBAhsuGNCe2l8Ee56YftE8JU8
	 6amnsNO4YihIK3krSs4DLjgNcfDkzVvEa73Bgh5WR3TYbXAC7q9p70lzqgl6SeFgIi
	 ZqCVPOuFeN9M1wytFzmDhTGcK4eqfJy216CNYWTb7tI+FzeUEf+Z1m7HH/oIiP7mIy
	 iHPNs2FPFsrX0D18ch7iUvqO99kO/BVdAmVBRrL71yRZGhQR12efsyk+3A9bhwIlcu
	 ZQ89Ud0iG/aFg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y 1/2] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 20:28:30 -0400
Message-ID: <20260918002831.1323627-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091636-plot-cobalt-bbd3@gregkh>
References: <2026091636-plot-cobalt-bbd3@gregkh>
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

Adapt the dependency to the 5.10 client under fs/cifs. Keep its existing
smb_vol mount setup, CIFS_SB interface and cifs_remap implementation;
omit upstream-only cached directory, reparse and shutdown changes.
Convert all mount flag readers, including the older DFS and fscache
paths, and use atomic bit operations for updates after mount setup.
Initialize the flags once from the existing mount options.

Provide cifs_sb_flags as a single-evaluation macro so this backport adds
no functions. Retain the cifs_getattr flag snapshot needed for
cf4d35896621b7298eef51b7a465e5c0cb22f670 to cherry-pick cleanly, while
leaving its POSIX ownership fix to that target commit.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 19. Not backported here:
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
 fs/cifs/cifs_dfs_ref.c |  2 +-
 fs/cifs/cifs_fs_sb.h   |  6 ++-
 fs/cifs/cifs_unicode.c |  4 +-
 fs/cifs/cifsacl.c      |  6 +--
 fs/cifs/cifsfs.c       | 68 ++++++++++++++---------------
 fs/cifs/cifsglob.h     | 10 +++--
 fs/cifs/connect.c      | 97 +++++++++++++++++++++---------------------
 fs/cifs/dir.c          | 16 +++----
 fs/cifs/file.c         | 38 ++++++++---------
 fs/cifs/fscache.c      |  2 +-
 fs/cifs/inode.c        | 90 ++++++++++++++++++++-------------------
 fs/cifs/link.c         |  4 +-
 fs/cifs/misc.c         | 10 ++---
 fs/cifs/readdir.c      | 18 ++++----
 fs/cifs/smb1ops.c      |  4 +-
 fs/cifs/smb2misc.c     |  4 +-
 fs/cifs/smb2ops.c      |  2 +-
 fs/cifs/smb2pdu.c      |  4 +-
 fs/cifs/xattr.c        |  6 +--
 19 files changed, 201 insertions(+), 190 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 42125601ebb10..b2bbf54551094 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -317,7 +317,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	mnt = ERR_PTR(-ENOMEM);
 
 	cifs_sb = CIFS_SB(mntpt->d_sb);
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS) {
 		mnt = ERR_PTR(-EREMOTE);
 		goto cdda_exit;
 	}
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 6e7c4427369d8..f1fe2d5a7589b 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -20,6 +20,7 @@
 #ifndef _CIFS_FS_SB_H
 #define _CIFS_FS_SB_H
 
+#include <linux/atomic.h>
 #include <linux/backing-dev.h>
 
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
@@ -56,6 +57,9 @@
 #define CIFS_MOUNT_RO_CACHE	0x20000000  /* assumes share will not change */
 #define CIFS_MOUNT_RW_CACHE	0x40000000  /* assumes only client accessing */
 
+/* Mount and reconnect paths may update these flags concurrently. */
+#define cifs_sb_flags(cifs_sb) ((unsigned int)atomic_read(&(cifs_sb)->mnt_cifs_flags))
+
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
 	spinlock_t tlink_tree_lock;
@@ -72,7 +76,7 @@ struct cifs_sb_info {
 	kgid_t	mnt_backupgid;
 	umode_t	mnt_file_mode;
 	umode_t	mnt_dir_mode;
-	unsigned int mnt_cifs_flags;
+	atomic_t mnt_cifs_flags;
 	char   *mountdata; /* options received at mount time or via DFS refs */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 171ad8b42107e..91f84bd6299a6 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -18,9 +18,9 @@ int cifs_remap(struct cifs_sb_info *cifs_sb)
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
index c8a0a2edc6500..6f5c4b51dd265 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -359,7 +359,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		return -EIO;
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL) ||
 	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
 		bool is_group;
@@ -1332,12 +1332,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 		return -ENOMEM;
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
index 900ac4d04d901..7f150250d35de 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -166,7 +166,7 @@ cifs_read_super(struct super_block *sb)
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
 	if (tcon->snapshot_time)
@@ -236,7 +236,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
@@ -306,7 +306,7 @@ static int cifs_permission(struct inode *inode, int mask)
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM) {
 		if ((mask & MAY_EXEC) && !execute_ok(inode))
 			return -EACCES;
 		else
@@ -445,13 +445,13 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
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
@@ -488,7 +488,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	if (tcon->no_lease)
 		seq_puts(s, ",nolease");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER)
 		seq_puts(s, ",multiuser");
 	else if (tcon->ses->user_name)
 		seq_show_option(s, "username", tcon->ses->user_name);
@@ -514,14 +514,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	seq_printf(s, ",uid=%u",
 		   from_kuid_munged(&init_user_ns, cifs_sb->mnt_uid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		seq_puts(s, ",forceuid");
 	else
 		seq_puts(s, ",noforceuid");
 
 	seq_printf(s, ",gid=%u",
 		   from_kgid_munged(&init_user_ns, cifs_sb->mnt_gid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		seq_puts(s, ",forcegid");
 	else
 		seq_puts(s, ",noforcegid");
@@ -559,53 +559,53 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
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
 					    cifs_sb->mnt_backupuid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPGID)
 		seq_printf(s, ",backupgid=%u",
 			   from_kgid_munged(&init_user_ns,
 					    cifs_sb->mnt_backupgid));
@@ -698,7 +698,7 @@ static int cifs_drop_inode(struct inode *inode)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+	return !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) ||
 		generic_drop_inode(inode);
 }
 
@@ -733,7 +733,7 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		return dget(sb->s_root);
 
 	full_path = cifs_build_path_to_root(vol, cifs_sb,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d0905aa0b04cd..79335daa86efc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1452,9 +1452,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_READ(cinode) \
+	(((cinode)->oplock & CIFS_CACHE_READ_FLG) || \
+	 (cifs_sb_flags(CIFS_SB((cinode)->vfs_inode.i_sb)) & CIFS_MOUNT_RO_CACHE))
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+#define CIFS_CACHE_WRITE(cinode) \
+	(((cinode)->oplock & CIFS_CACHE_WRITE_FLG) || \
+	 (cifs_sb_flags(CIFS_SB((cinode)->vfs_inode.i_sb)) & CIFS_MOUNT_RW_CACHE))
 
 /*
  * One of these for each file inode
@@ -1515,7 +1519,7 @@ CIFS_FILE_SB(struct file *file)
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		return '/';
 	else
 		return '\\';
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a95b9d2318fa2..c64063bb9afdf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3450,8 +3450,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
-	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int oldflags = cifs_sb_flags(old) & CIFS_MOUNT_MASK;
+	unsigned int newflags = cifs_sb_flags(new) & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
@@ -3493,9 +3493,9 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
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
@@ -3874,8 +3874,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
+				atomic_or(CIFS_MOUNT_POSIXACL,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		if (vol_info && vol_info->posix_paths == 0)
@@ -3883,8 +3883,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
+				atomic_or(CIFS_MOUNT_POSIX_PATHS,
+					  &cifs_sb->mnt_cifs_flags);
 		}
 
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
@@ -3921,6 +3921,8 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = 0;
+
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
@@ -3945,69 +3947,67 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->local_nls = pvolume_info->local_nls;
 
 	if (pvolume_info->nodfs)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
+		sbflags |= CIFS_MOUNT_NO_DFS;
 	if (pvolume_info->noperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
+		sbflags |= CIFS_MOUNT_NO_PERM;
 	if (pvolume_info->setuids)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
+		sbflags |= CIFS_MOUNT_SET_UID;
 	if (pvolume_info->setuidfromacl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
+		sbflags |= CIFS_MOUNT_UID_FROM_ACL;
 	if (pvolume_info->server_ino)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
+		sbflags |= CIFS_MOUNT_SERVER_INUM;
 	if (pvolume_info->remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SFM_CHR;
+		sbflags |= CIFS_MOUNT_MAP_SFM_CHR;
 	if (pvolume_info->sfu_remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
+		sbflags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
 	if (pvolume_info->no_xattr)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_XATTR;
+		sbflags |= CIFS_MOUNT_NO_XATTR;
 	if (pvolume_info->sfu_emul)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
+		sbflags |= CIFS_MOUNT_UNX_EMUL;
 	if (pvolume_info->nobrl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
+		sbflags |= CIFS_MOUNT_NO_BRL;
 	if (pvolume_info->nohandlecache)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_HANDLE_CACHE;
+		sbflags |= CIFS_MOUNT_NO_HANDLE_CACHE;
 	if (pvolume_info->nostrictsync)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
+		sbflags |= CIFS_MOUNT_NOSSYNC;
 	if (pvolume_info->mand_lock)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+		sbflags |= CIFS_MOUNT_NOPOSIXBRL;
 	if (pvolume_info->rwpidforward)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
+		sbflags |= CIFS_MOUNT_RWPIDFORWARD;
 	if (pvolume_info->mode_ace)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MODE_FROM_SID;
+		sbflags |= CIFS_MOUNT_MODE_FROM_SID;
 	if (pvolume_info->cifs_acl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
+		sbflags |= CIFS_MOUNT_CIFS_ACL;
 	if (pvolume_info->backupuid_specified) {
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
+		sbflags |= CIFS_MOUNT_CIFS_BACKUPUID;
 		cifs_sb->mnt_backupuid = pvolume_info->backupuid;
 	}
 	if (pvolume_info->backupgid_specified) {
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
+		sbflags |= CIFS_MOUNT_CIFS_BACKUPGID;
 		cifs_sb->mnt_backupgid = pvolume_info->backupgid;
 	}
 	if (pvolume_info->override_uid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
+		sbflags |= CIFS_MOUNT_OVERR_UID;
 	if (pvolume_info->override_gid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
+		sbflags |= CIFS_MOUNT_OVERR_GID;
 	if (pvolume_info->dynperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
+		sbflags |= CIFS_MOUNT_DYNPERM;
 	if (pvolume_info->fsc)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
+		sbflags |= CIFS_MOUNT_FSCACHE;
 	if (pvolume_info->multiuser)
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
-					    CIFS_MOUNT_NO_PERM);
+		sbflags |= CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_NO_PERM;
 	if (pvolume_info->strict_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
+		sbflags |= CIFS_MOUNT_STRICT_IO;
 	if (pvolume_info->direct_io) {
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
+		sbflags |= CIFS_MOUNT_DIRECT_IO;
 	}
 	if (pvolume_info->cache_ro) {
 		cifs_dbg(VFS, "mounting share with read only caching. Ensure that the share will not be modified while in use.\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RO_CACHE;
+		sbflags |= CIFS_MOUNT_RO_CACHE;
 	} else if (pvolume_info->cache_rw) {
 		cifs_dbg(VFS, "mounting share in single client RW caching mode. Ensure that no other systems will be accessing the share.\n");
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_RO_CACHE |
-					    CIFS_MOUNT_RW_CACHE);
+		sbflags |= CIFS_MOUNT_RO_CACHE | CIFS_MOUNT_RW_CACHE;
 	}
 	if (pvolume_info->mfsymlinks) {
 		if (pvolume_info->sfu_emul) {
@@ -4024,7 +4024,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			 */
 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
 		}
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
+		sbflags |= CIFS_MOUNT_MF_SYMLINKS;
 	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
@@ -4034,9 +4034,10 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+		sbflags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	return 0;
 }
 
@@ -4074,7 +4075,7 @@ static inline void mount_put_conns(struct cifs_sb_info *cifs_sb,
 		cifs_put_smb_ses(ses);
 	else if (server)
 		cifs_put_tcp_session(server, 0);
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	atomic_andnot(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 	free_xid(xid);
 }
 
@@ -4130,7 +4131,7 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
+		atomic_or(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 
 	/* tell server which Unix caps we support */
 	if (cap_unix(tcon->ses)) {
@@ -4149,11 +4150,11 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(*xid, tcon, cifs_sb);
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
@@ -4248,7 +4249,7 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 	struct dfs_info3_param referral = {0};
 	char *full_path = NULL, *mdata = NULL;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS)
 		return -EREMOTE;
 
 	full_path = build_unc_path_to_root(volume_info, cifs_sb, true);
@@ -4378,7 +4379,7 @@ static int do_dfs_failover(const char *path, const char *full_path, struct cifs_
 	struct dfs_cache_tgt_list tgt_list;
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS)
 		return -EOPNOTSUPP;
 
 	rc = dfs_cache_noreq_find(path, NULL, &tgt_list);
@@ -4553,7 +4554,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_server_dbg(VFS, "cannot query dirs between root and final path, enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 			rc = 0;
 		}
 	}
@@ -4781,7 +4782,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	 * Force the use of prefix path to support failover on DFS paths that
 	 * resolve to targets that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = vol->prepath;
 	vol->prepath = NULL;
@@ -5246,7 +5247,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	kuid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 73d43d8911aa5..e1493768d2f2d 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -107,7 +107,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, bool prefix)
 	else
 		dfsplen = 0;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
 cifs_bp_rename_retry:
@@ -181,7 +181,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, bool prefix)
 
 	if (dfsplen) {
 		strncpy(full_path, tcon->treeName, dfsplen);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
 				if (full_path[i] == '\\')
@@ -208,7 +208,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)) {
 		for (i = 0; i < direntry->d_name.len; i++) {
 			if (direntry->d_name.name[i] == '\\') {
 				cifs_dbg(FYI, "Invalid file name\n");
@@ -384,7 +384,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				.device	= 0,
 		};
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				args.gid = inode->i_gid;
@@ -418,10 +418,10 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		if (newinode) {
 			if (server->ops->set_lease_key)
 				server->ops->set_lease_key(newinode, fid);
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+			if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)
 				newinode->i_mode = mode;
 			if ((*oplock & CIFS_CREATE_ACTION) &&
-			    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)) {
+			    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID)) {
 				newinode->i_uid = current_fsuid();
 				if (inode->i_mode & S_ISGID)
 					newinode->i_gid = inode->i_gid;
@@ -545,8 +545,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
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
index 0da9c11cae278..0ec0cf7edf7b3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -473,7 +473,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		 * close  because it may cause a error when we open this file
 		 * again and get at least level II oplock.
 		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
@@ -544,8 +544,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		 inode, file->f_flags, full_path);
 
 	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	    cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
@@ -657,7 +657,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
@@ -1361,7 +1361,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
@@ -1741,7 +1741,7 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 
 	if (!lock && !unlock) {
@@ -1789,7 +1789,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 	/*
 	 * BB add code here to normalize offset and length to account for
@@ -1919,7 +1919,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -1975,7 +1975,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 	cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2526,7 +2526,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
 	__u32 pid;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = cfile->pid;
 	else
 		pid = current->tgid;
@@ -2608,7 +2608,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2653,7 +2653,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		 file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2900,7 +2900,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	size_t start;
 	unsigned int xid;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -3301,7 +3301,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
-		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+		  && ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = generic_file_write_iter(iocb, from);
 			goto out;
 		}
@@ -3638,7 +3638,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4012,7 +4012,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to);
 
 	/*
@@ -4066,7 +4066,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 		return -ENOSYS;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4397,7 +4397,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		return rc;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
 		pid = current->tgid;
@@ -4629,7 +4629,7 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		struct cifs_sb_info *cifs_sb;
 
 		cifs_sb = CIFS_SB(cifsInode->vfs_inode.i_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index da688185403c3..79074a104890c 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -164,7 +164,7 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
 	if (cifsi->fscache)
 		return;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_FSCACHE))
 		return;
 
 	cifs_fscache_acquire_inode_cookie(cifsi, tcon);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b11a919b9cab0..6f44f54ea60e2 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -46,17 +46,17 @@ static void cifs_set_ops(struct inode *inode)
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
@@ -182,7 +182,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	/* if dynperm is set, don't clobber existing mode */
 	if (inode->i_state & I_NEW ||
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
@@ -225,7 +225,7 @@ cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		return;
 
 	fattr->cf_uniqueid = iunique(sb, ROOT_I);
@@ -295,7 +295,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
 			kuid_t uid = make_kuid(&init_user_ns, id);
@@ -305,7 +305,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 	
 	fattr->cf_gid = cifs_sb->mnt_gid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
 			kgid_t gid = make_kgid(&init_user_ns, id);
@@ -400,7 +400,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	}
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		int tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
 					     full_path);
 		if (tmprc)
@@ -417,7 +417,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*pinode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -828,7 +828,7 @@ cifs_backup_query_path_info(int xid,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0)
 		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	else /* no srvino useful for fallback to some netapp */
 		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -860,7 +860,7 @@ cifs_set_fattr_ino(int xid,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		if (*inode)
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else
@@ -1034,14 +1034,14 @@ cifs_get_inode_info(struct inode **inode,
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
@@ -1051,7 +1051,7 @@ cifs_get_inode_info(struct inode **inode,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
 				       full_path, fid);
 		if (rc == -EREMOTE)
@@ -1064,11 +1064,11 @@ cifs_get_inode_info(struct inode **inode,
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
@@ -1087,7 +1087,7 @@ cifs_get_inode_info(struct inode **inode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -1181,7 +1181,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 	 */
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, &fattr,
 					 full_path);
 		if (tmprc)
@@ -1200,7 +1200,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 		/* we already have inode, update it */
 
 		/* if uniqueid is different, return error */
-		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		if (unlikely(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM &&
 		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
 			CIFS_I(*inode)->time = 0; /* force reval */
 			rc = -ESTALE;
@@ -1337,7 +1337,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	char *path = NULL;
 	int len;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 	    && cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath);
 		path = kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
@@ -1753,7 +1753,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
 				args.gid = parent->i_gid;
@@ -1768,14 +1768,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
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
@@ -1820,7 +1820,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 		/* no return info, go query for it */
 		goto posix_mkdir_get_info;
 	/*
-	 * BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if
+	 * BB check (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID ) to see if
 	 * need to set uid/gid.
 	 */
 
@@ -2199,7 +2199,7 @@ cifs_inode_needs_reval(struct inode *inode)
 		return true;
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
@@ -2368,6 +2368,7 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct inode *inode = d_inode(dentry);
+	unsigned int sbflags;
 	int rc;
 
 	/*
@@ -2421,12 +2422,13 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
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
@@ -2606,7 +2608,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(direntry, attrs);
@@ -2753,7 +2755,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(direntry, attrs);
@@ -2790,7 +2792,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if ((attrs->ia_valid & ATTR_MTIME) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);
@@ -2816,8 +2818,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			rc = id_mode_to_cifs_acl(inode, full_path, NO_CHANGE_64,
 							uid, gid);
@@ -2827,9 +2829,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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
@@ -2838,8 +2840,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		mode = attrs->ia_mode;
 		rc = 0;
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+		if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
 			rc = id_mode_to_cifs_acl(inode, full_path, mode,
 						INVALID_UID, INVALID_GID);
 			if (rc) {
@@ -2854,7 +2856,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
 
 			/* fix up mode if we're not using dynperm */
-			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
+			if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM) == 0)
 				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
 		} else if ((mode & S_IWUGO) &&
 			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
@@ -2865,7 +2867,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				dosattr |= ATTR_NORMAL;
 
 			/* reset local inode permissions to normal */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
@@ -2874,7 +2876,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 					attrs->ia_mode |=
 						cifs_sb->mnt_file_mode;
 			}
-		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+		} else if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
 			attrs->ia_valid &= ~ATTR_MODE;
 		}
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 4fc6eb8e786d4..84545eea2d181 100644
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
 
@@ -694,7 +694,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS)
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
 	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b4199b4085db3..10b054f05f390 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -537,13 +537,13 @@ dump_smb(void *buf, int smb_buf_length)
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
@@ -643,11 +643,11 @@ void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 bool
 backup_cred(struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPUID) {
 		if (uid_eq(cifs_sb->mnt_backupuid, current_fsuid()))
 			return true;
 	}
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_BACKUPGID) {
 		if (in_group_p(cifs_sb->mnt_backupgid))
 			return true;
 	}
@@ -1206,7 +1206,7 @@ int update_super_prepath(struct cifs_tcon *tcon, char *prefix)
 	} else
 		cifs_sb->prepath = NULL;
 
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 
 out:
 	cifs_put_tcon_super(sb);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 9a7315aa24e0d..dab5d1b4bc1f0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -112,7 +112,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			 * want to clobber the existing one with the one that
 			 * the readdir code created.
 			 */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+			if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
 			/* update inode in place
@@ -220,11 +220,11 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
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
@@ -435,7 +435,7 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	} else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	} else /* not srvinos - BB fixme add check for backlevel? */ {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -455,8 +455,8 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
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
@@ -908,14 +908,14 @@ static int cifs_filldir(char *find_entry, struct file *file,
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
index 80287c26cfac0..5d22ded1f68f2 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1052,7 +1052,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			.mtime	= NO_CHANGE_64,
 			.device	= dev,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			args.gid = current_fsgid();
 		} else {
@@ -1077,7 +1077,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	 * SMB1 SFU emulation: should work with all servers, but only
 	 * support block and char device (no socket & fifo)
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		goto out;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode))
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 2013489431ac1..179c264469c0d 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -477,9 +477,9 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
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
index 51f8ea0c89065..da6a8f43b72ef 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5108,7 +5108,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UNX_EMUL))
 		goto out;
 
 	/*
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 19b4f426e9afa..a17e33a0ee7eb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2805,7 +2805,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		bool set_mode;
 		bool set_owner;
 
-		if ((oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) &&
+		if ((cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) &&
 		    (oparms->mode != ACL_NO_MODE))
 			set_mode = true;
 		else {
@@ -2813,7 +2813,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			oparms->mode = ACL_NO_MODE;
 		}
 
-		if (oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+		if (cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_UID_FROM_ACL)
 			set_owner = true;
 		else
 			set_owner = false;
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index c6931eab3f97e..01cf57b64341c 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -154,7 +154,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
@@ -321,7 +321,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
@@ -402,7 +402,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 	struct cifs_tcon *pTcon;
 	char *full_path;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
 	tlink = cifs_sb_tlink(cifs_sb);
-- 
2.53.0

