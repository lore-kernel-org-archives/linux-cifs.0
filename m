Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60893148C9
	for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864488; cv=none; b=hZ2pMFrxwQfXOQHXNhqvzAJ35RFSxFAB2dKd4DZkr4m1bIm8qPvTzYE8l73hl/o5F9gprPvlhFrtvb8knRTQkilRHIC69xXRdNg69kBJNK8KjhaAju1iPf6l65HK0sBGbzR2CW4+INydbqmWiIoFWOO7gy1b8AfrKIT90Q45rqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864488; c=relaxed/simple;
	bh=JKWkjZwb78iBnKugTKQT7pPpC/RvE2a5chOrXZ1t1RI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hlMu+Ecz3amfD/ywq3Nn+U829sCJAlMaRKXRgMNstc6turEH6yakvzDfXGueU5e/9eEQ2pEXYHm12+Cm8uVFUgC7Pm9iuZt8505dWUoH4M6ei89ifgnGUhANASW0plEQS8G+PPmtdQH/LDRIDN6/+eNojIG9sP4LcGV1QE39blw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hkOqnF1e; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hkOqnF1e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=6YVhDKFgdRe2ekX44270JVP43AjIwSh3ly3MpsOSS1Q=; b=hkOqnF1eQLzrvbRQF4fVwQDbsb
	X/bXNa/vPbt7KAyVnRpQ2xmD3QupgMwiMp6mBG0W9TKEXwqCZYh5gaZOv4H2+QCJGP5Qnx93XUxzS
	nf8keM8dbad2kzaJyO/QUMRc4F5UhGvly/tuaRZypJiZ1izHc4EHL2iymyZQuqh77uiY4IE2Bh10p
	ueuQ3lQqs1KaLwCETDiER+xxM3Tr2hXz1Ntdqm+Rg72el6lsIhdbeofksO6exfasW18RSqfXXgYyH
	8ziIgmX10FkVzylYme292MPcYORgmaFOQ9QXQkF6sXeBjrh4OGDdK9wYpFqpbiPLhfWrmt0ephKf0
	Kj0l+tqg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vuYtH-00000000dFV-0oRO;
	Mon, 23 Feb 2026 13:34:35 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: use atomic_t for mnt_cifs_flags
Date: Mon, 23 Feb 2026 13:34:35 -0300
Message-ID: <20260223163435.333561-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use atomic_t for cifs_sb_info::mnt_cifs_flags as it's currently
accessed locklessly and may be changed concurrently in mount/remount
and reconnect paths.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cached_dir.c   |   2 +-
 fs/smb/client/cifs_fs_sb.h   |   2 +-
 fs/smb/client/cifs_ioctl.h   |   8 --
 fs/smb/client/cifs_unicode.c |  14 ----
 fs/smb/client/cifs_unicode.h |  14 +++-
 fs/smb/client/cifsacl.c      |  17 ++--
 fs/smb/client/cifsfs.c       |  84 ++++++++++----------
 fs/smb/client/cifsglob.h     |  61 +++++++++++---
 fs/smb/client/connect.c      |  65 ++++++++-------
 fs/smb/client/dfs_cache.c    |   2 +-
 fs/smb/client/dir.c          |  55 +++++++------
 fs/smb/client/file.c         |  96 +++++++++++-----------
 fs/smb/client/fs_context.c   | 149 +++++++++++++++++------------------
 fs/smb/client/fs_context.h   |   2 +-
 fs/smb/client/inode.c        | 146 ++++++++++++++++++----------------
 fs/smb/client/ioctl.c        |   2 +-
 fs/smb/client/link.c         |  14 ++--
 fs/smb/client/misc.c         |  16 ++--
 fs/smb/client/readdir.c      |  39 ++++-----
 fs/smb/client/reparse.c      |  29 +++----
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |  22 ++++--
 fs/smb/client/smb2file.c     |   2 +-
 fs/smb/client/smb2misc.c     |  18 +----
 fs/smb/client/smb2ops.c      |   8 +-
 fs/smb/client/smb2pdu.c      |  13 ++-
 fs/smb/client/xattr.c        |   6 +-
 27 files changed, 469 insertions(+), 421 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 2a6b8ce80be2..5ebf8b9a3e61 100644
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
index 5e8d163cb5f8..84e7e366b0ff 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -55,7 +55,7 @@ struct cifs_sb_info {
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
-	unsigned int mnt_cifs_flags;
+	atomic_t mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index b51ce64fcccf..147496ac9f9f 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -122,11 +122,3 @@ struct smb3_notify_info {
 #define CIFS_GOING_FLAGS_DEFAULT                0x0     /* going down */
 #define CIFS_GOING_FLAGS_LOGFLUSH               0x1     /* flush log but not data */
 #define CIFS_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't flush log nor data */
-
-static inline bool cifs_forced_shutdown(struct cifs_sb_info *sbi)
-{
-	if (CIFS_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
-		return true;
-	else
-		return false;
-}
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index e7891b4406f2..e2edc207cef2 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -11,20 +11,6 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 
-int cifs_remap(struct cifs_sb_info *cifs_sb)
-{
-	int map_type;
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
-		map_type = SFM_MAP_UNI_RSVD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
-		map_type = SFU_MAP_UNI_RSVD;
-	else
-		map_type = NO_MAP_UNI_RSVD;
-
-	return map_type;
-}
-
 /* Convert character using the SFU - "Services for Unix" remapping range */
 static bool
 convert_sfu_char(const __u16 src_char, char *target)
diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
index 9249db3b78c3..3e9cd9acf0a9 100644
--- a/fs/smb/client/cifs_unicode.h
+++ b/fs/smb/client/cifs_unicode.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/nls.h>
 #include "../../nls/nls_ucs2_utils.h"
+#include "cifsglob.h"
 
 /*
  * Macs use an older "SFM" mapping of the symbols above. Fortunately it does
@@ -65,10 +66,21 @@ char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const struct nls_table *codepage);
 int cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		       const struct nls_table *cp, int map_chars);
-int cifs_remap(struct cifs_sb_info *cifs_sb);
 __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
 			      int *utf16_len, const struct nls_table *cp,
 			      int remap);
 wchar_t cifs_toupper(wchar_t in);
 
+static inline int cifs_remap(const struct cifs_sb_info *cifs_sb)
+{
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
+
+	if (sbflags & CIFS_MOUNT_MAP_SFM_CHR)
+		return SFM_MAP_UNI_RSVD;
+	if (sbflags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+		return SFU_MAP_UNI_RSVD;
+
+	return NO_MAP_UNI_RSVD;
+}
+
 #endif /* _CIFS_UNICODE_H */
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f03eda46f452..6b9eae703a29 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -356,7 +356,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 				psid->num_subauth, SID_MAX_SUB_AUTHORITIES);
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_UID_FROM_ACL) ||
 	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
 		bool is_group;
@@ -1615,7 +1615,8 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	struct smb_acl *dacl_ptr = NULL;
 	struct smb_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct smb_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	unsigned int sbflags;
 	struct tcon_link *tlink;
 	struct smb_version_operations *ops;
 	bool mode_from_sid, id_from_sid;
@@ -1646,15 +1647,9 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		return rc;
 	}
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)
-		mode_from_sid = true;
-	else
-		mode_from_sid = false;
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
-		id_from_sid = true;
-	else
-		id_from_sid = false;
+	sbflags = cifs_sb_flags(cifs_sb);
+	mode_from_sid = sbflags & CIFS_MOUNT_MODE_FROM_SID;
+	id_from_sid = sbflags & CIFS_MOUNT_UID_FROM_ACL;
 
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index afda1d7c1ee1..911ea0289212 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -226,16 +226,18 @@ cifs_sb_deactive(struct super_block *sb)
 static int
 cifs_read_super(struct super_block *sb)
 {
-	struct inode *inode;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
+	unsigned int sbflags;
 	struct timespec64 ts;
+	struct inode *inode;
 	int rc = 0;
 
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
+	sbflags = cifs_sb_flags(cifs_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
+	if (sbflags & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
 	if (tcon->snapshot_time)
@@ -311,7 +313,7 @@ cifs_read_super(struct super_block *sb)
 	}
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	if (sbflags & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
@@ -389,8 +391,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(CIFS_SB(file));
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct inode *inode = file_inode(file);
 	int rc;
@@ -418,11 +419,9 @@ static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
 static int cifs_permission(struct mnt_idmap *idmap,
 			   struct inode *inode, int mask)
 {
-	struct cifs_sb_info *cifs_sb;
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(inode));
 
-	cifs_sb = CIFS_SB(inode->i_sb);
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+	if (sbflags & CIFS_MOUNT_NO_PERM) {
 		if ((mask & MAY_EXEC) && !execute_ok(inode))
 			return -EACCES;
 		else
@@ -568,15 +567,17 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 static void
 cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
+
 	seq_puts(s, ",cache=");
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+	if (sbflags & CIFS_MOUNT_STRICT_IO)
 		seq_puts(s, "strict");
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
+	else if (sbflags & CIFS_MOUNT_DIRECT_IO)
 		seq_puts(s, "none");
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+	else if (sbflags & CIFS_MOUNT_RW_CACHE)
 		seq_puts(s, "singleclient"); /* assume only one client access */
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE)
+	else if (sbflags & CIFS_MOUNT_RO_CACHE)
 		seq_puts(s, "ro"); /* read only caching assumed */
 	else
 		seq_puts(s, "loose");
@@ -637,6 +638,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct sockaddr *srcaddr;
+	unsigned int sbflags;
+
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
 	seq_show_option(s, "vers", tcon->ses->server->vals->version_string);
@@ -670,16 +673,17 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 				   (int)(srcaddr->sa_family));
 	}
 
+	sbflags = cifs_sb_flags(cifs_sb);
 	seq_printf(s, ",uid=%u",
 		   from_kuid_munged(&init_user_ns, cifs_sb->ctx->linux_uid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (sbflags & CIFS_MOUNT_OVERR_UID)
 		seq_puts(s, ",forceuid");
 	else
 		seq_puts(s, ",noforceuid");
 
 	seq_printf(s, ",gid=%u",
 		   from_kgid_munged(&init_user_ns, cifs_sb->ctx->linux_gid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (sbflags & CIFS_MOUNT_OVERR_GID)
 		seq_puts(s, ",forcegid");
 	else
 		seq_puts(s, ",noforcegid");
@@ -722,53 +726,53 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",unix");
 	else
 		seq_puts(s, ",nounix");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
+	if (sbflags & CIFS_MOUNT_NO_DFS)
 		seq_puts(s, ",nodfs");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (sbflags & CIFS_MOUNT_POSIX_PATHS)
 		seq_puts(s, ",posixpaths");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
+	if (sbflags & CIFS_MOUNT_SET_UID)
 		seq_puts(s, ",setuids");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
+	if (sbflags & CIFS_MOUNT_UID_FROM_ACL)
 		seq_puts(s, ",idsfromsid");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	if (sbflags & CIFS_MOUNT_SERVER_INUM)
 		seq_puts(s, ",serverino");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+	if (sbflags & CIFS_MOUNT_RWPIDFORWARD)
 		seq_puts(s, ",rwpidforward");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
+	if (sbflags & CIFS_MOUNT_NOPOSIXBRL)
 		seq_puts(s, ",forcemand");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (sbflags & CIFS_MOUNT_NO_XATTR)
 		seq_puts(s, ",nouser_xattr");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
+	if (sbflags & CIFS_MOUNT_MAP_SPECIAL_CHR)
 		seq_puts(s, ",mapchars");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
+	if (sbflags & CIFS_MOUNT_MAP_SFM_CHR)
 		seq_puts(s, ",mapposix");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	if (sbflags & CIFS_MOUNT_UNX_EMUL)
 		seq_puts(s, ",sfu");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	if (sbflags & CIFS_MOUNT_NO_BRL)
 		seq_puts(s, ",nobrl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_HANDLE_CACHE)
+	if (sbflags & CIFS_MOUNT_NO_HANDLE_CACHE)
 		seq_puts(s, ",nohandlecache");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)
+	if (sbflags & CIFS_MOUNT_MODE_FROM_SID)
 		seq_puts(s, ",modefromsid");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
+	if (sbflags & CIFS_MOUNT_CIFS_ACL)
 		seq_puts(s, ",cifsacl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+	if (sbflags & CIFS_MOUNT_DYNPERM)
 		seq_puts(s, ",dynperm");
 	if (root->d_sb->s_flags & SB_POSIXACL)
 		seq_puts(s, ",acl");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	if (sbflags & CIFS_MOUNT_MF_SYMLINKS)
 		seq_puts(s, ",mfsymlinks");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+	if (sbflags & CIFS_MOUNT_FSCACHE)
 		seq_puts(s, ",fsc");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
+	if (sbflags & CIFS_MOUNT_NOSSYNC)
 		seq_puts(s, ",nostrictsync");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		seq_puts(s, ",noperm");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
+	if (sbflags & CIFS_MOUNT_CIFS_BACKUPUID)
 		seq_printf(s, ",backupuid=%u",
 			   from_kuid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupuid));
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
+	if (sbflags & CIFS_MOUNT_CIFS_BACKUPGID)
 		seq_printf(s, ",backupgid=%u",
 			   from_kgid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupgid));
@@ -909,10 +913,10 @@ static int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 static int cifs_drop_inode(struct inode *inode)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(inode));
 
 	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+	return !(sbflags & CIFS_MOUNT_SERVER_INUM) ||
 		inode_generic_drop(inode);
 }
 
@@ -950,7 +954,7 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 	char *s, *p;
 	char sep;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 		return dget(sb->s_root);
 
 	full_path = cifs_build_path_to_root(ctx, cifs_sb,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 080ea601c209..6f9b6c72962b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1580,24 +1580,59 @@ CIFS_I(struct inode *inode)
 	return container_of(inode, struct cifsInodeInfo, netfs.inode);
 }
 
-static inline struct cifs_sb_info *
-CIFS_SB(struct super_block *sb)
+static inline void *cinode_to_fsinfo(struct cifsInodeInfo *cinode)
+{
+	return cinode->netfs.inode.i_sb->s_fs_info;
+}
+
+static inline void *super_to_fsinfo(struct super_block *sb)
 {
 	return sb->s_fs_info;
 }
 
-static inline struct cifs_sb_info *
-CIFS_FILE_SB(struct file *file)
+static inline void *inode_to_fsinfo(struct inode *inode)
 {
-	return CIFS_SB(file_inode(file)->i_sb);
+	return inode->i_sb->s_fs_info;
+}
+
+static inline void *file_to_fsinfo(struct file *file)
+{
+	return file_inode(file)->i_sb->s_fs_info;
+}
+
+static inline void *dentry_to_fsinfo(struct dentry *dentry)
+{
+	return dentry->d_sb->s_fs_info;
+}
+
+static inline void *const_dentry_to_fsinfo(const struct dentry *dentry)
+{
+	return dentry->d_sb->s_fs_info;
+}
+
+#define CIFS_SB(_ptr) \
+	((struct cifs_sb_info *) \
+	 _Generic((_ptr), \
+		  struct cifsInodeInfo * : cinode_to_fsinfo, \
+		  const struct dentry * : const_dentry_to_fsinfo, \
+		  struct super_block * : super_to_fsinfo, \
+		  struct dentry * : dentry_to_fsinfo, \
+		  struct inode * : inode_to_fsinfo, \
+		  struct file * : file_to_fsinfo)(_ptr))
+
+/*
+ * Use atomic_t for @cifs_sb->mnt_cifs_flags as it is currently accessed
+ * locklessly and may be changed concurrently by mount/remount and reconnect
+ * paths.
+ */
+static inline unsigned int cifs_sb_flags(const struct cifs_sb_info *cifs_sb)
+{
+	return atomic_read(&cifs_sb->mnt_cifs_flags);
 }
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
-		return '/';
-	else
-		return '\\';
+	return (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS) ? '/' : '\\';
 }
 
 static inline void
@@ -2314,9 +2349,8 @@ static inline bool __cifs_cache_state_check(struct cifsInodeInfo *cinode,
 					    unsigned int oplock_flags,
 					    unsigned int sb_flags)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cinode->netfs.inode.i_sb);
+	unsigned int sflags = cifs_sb_flags(CIFS_SB(cinode));
 	unsigned int oplock = READ_ONCE(cinode->oplock);
-	unsigned int sflags = cifs_sb->mnt_cifs_flags;
 
 	return (oplock & oplock_flags) || (sflags & sb_flags);
 }
@@ -2336,4 +2370,9 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
+{
+	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 1b479561cbf9..ddf65b000f58 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2915,8 +2915,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	unsigned int oldflags = old->mnt_cifs_flags & CIFS_MOUNT_MASK;
-	unsigned int newflags = new->mnt_cifs_flags & CIFS_MOUNT_MASK;
+	unsigned int oldflags = cifs_sb_flags(old) & CIFS_MOUNT_MASK;
+	unsigned int newflags = cifs_sb_flags(new) & CIFS_MOUNT_MASK;
 
 	if ((sb->s_flags & CIFS_MS_MASK) != (mnt_data->flags & CIFS_MS_MASK))
 		return 0;
@@ -2971,9 +2971,9 @@ static int match_prepath(struct super_block *sb,
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
@@ -3004,7 +3004,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	cifs_sb = CIFS_SB(sb);
 
 	/* We do not want to use a superblock that has been shutdown */
-	if (CIFS_MOUNT_SHUTDOWN & cifs_sb->mnt_cifs_flags) {
+	if (cifs_forced_shutdown(cifs_sb)) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return 0;
 	}
@@ -3469,6 +3469,8 @@ ip_connect(struct TCP_Server_Info *server)
 int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 {
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
+	unsigned int sbflags;
+	int rc = 0;
 
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 	INIT_LIST_HEAD(&cifs_sb->tcon_sb_link);
@@ -3493,17 +3495,16 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
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
@@ -3512,16 +3513,19 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
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
 void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx)
 {
+	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	int rc = 0;
 
 	if (mnt_ctx->tcon)
@@ -3533,7 +3537,7 @@ void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx)
 	mnt_ctx->ses = NULL;
 	mnt_ctx->tcon = NULL;
 	mnt_ctx->server = NULL;
-	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
+	atomic_andnot(CIFS_MOUNT_POSIX_PATHS, &cifs_sb->mnt_cifs_flags);
 	free_xid(mnt_ctx->xid);
 }
 
@@ -3587,19 +3591,23 @@ int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx)
 int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct TCP_Server_Info *server;
+	struct cifs_tcon *tcon = NULL;
 	struct cifs_sb_info *cifs_sb;
 	struct smb3_fs_context *ctx;
-	struct cifs_tcon *tcon = NULL;
+	unsigned int sbflags;
 	int rc = 0;
 
-	if (WARN_ON_ONCE(!mnt_ctx || !mnt_ctx->server || !mnt_ctx->ses || !mnt_ctx->fs_ctx ||
-			 !mnt_ctx->cifs_sb)) {
-		rc = -EINVAL;
-		goto out;
+	if (WARN_ON_ONCE(!mnt_ctx))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!mnt_ctx->server || !mnt_ctx->ses ||
+			 !mnt_ctx->fs_ctx || !mnt_ctx->cifs_sb)) {
+		mnt_ctx->tcon = NULL;
+		return -EINVAL;
 	}
 	server = mnt_ctx->server;
 	ctx = mnt_ctx->fs_ctx;
 	cifs_sb = mnt_ctx->cifs_sb;
+	sbflags = cifs_sb_flags(cifs_sb);
 
 	/* search for existing tcon to this server share */
 	tcon = cifs_get_tcon(mnt_ctx->ses, ctx);
@@ -3614,9 +3622,9 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	 * path (i.e., do not remap / and \ and do not map any special characters)
 	 */
 	if (tcon->posix_extensions) {
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
-		cifs_sb->mnt_cifs_flags &= ~(CIFS_MOUNT_MAP_SFM_CHR |
-					     CIFS_MOUNT_MAP_SPECIAL_CHR);
+		sbflags |= CIFS_MOUNT_POSIX_PATHS;
+		sbflags &= ~(CIFS_MOUNT_MAP_SFM_CHR |
+			     CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
@@ -3643,12 +3651,11 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	/* do not care if a following call succeed - informational */
 	if (!tcon->pipe && server->ops->qfs_tcon) {
 		server->ops->qfs_tcon(mnt_ctx->xid, tcon, cifs_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE) {
+		if (sbflags & CIFS_MOUNT_RO_CACHE) {
 			if (tcon->fsDevInfo.DeviceCharacteristics &
 			    cpu_to_le32(FILE_READ_ONLY_DEVICE))
 				cifs_dbg(VFS, "mounted to read only share\n");
-			else if ((cifs_sb->mnt_cifs_flags &
-				  CIFS_MOUNT_RW_CACHE) == 0)
+			else if (!(sbflags & CIFS_MOUNT_RW_CACHE))
 				cifs_dbg(VFS, "read only mount of RW share\n");
 			/* no need to log a RW mount of a typical RW share */
 		}
@@ -3660,11 +3667,12 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 	 * Inside cifs_fscache_get_super_cookie it checks
 	 * that we do not get super cookie twice.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+	if (sbflags & CIFS_MOUNT_FSCACHE)
 		cifs_fscache_get_super_cookie(tcon);
 
 out:
 	mnt_ctx->tcon = tcon;
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
 	return rc;
 }
 
@@ -3783,7 +3791,8 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_server_dbg(VFS, "cannot query dirs between root and final path, enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+			atomic_or(CIFS_MOUNT_USE_PREFIX_PATH,
+				  &cifs_sb->mnt_cifs_flags);
 			rc = 0;
 		}
 	}
@@ -3863,7 +3872,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = ctx->prepath;
 	ctx->prepath = NULL;
@@ -4357,7 +4366,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	kuid_t fsuid = current_fsuid();
 	int err;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index f2ad0ccd08a7..0daa98992938 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1333,7 +1333,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
 	 */
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 
 	refresh_tcon_referral(tcon, true);
 	return 0;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index cb10088197d2..953f1fee8cb8 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -82,10 +82,11 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 					       const char *tree, int tree_len,
 					       bool prefix)
 {
-	int dfsplen;
-	int pplen = 0;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry);
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	char dirsep = CIFS_DIR_SEP(cifs_sb);
+	int pplen = 0;
+	int dfsplen;
 	char *s;
 
 	if (unlikely(!page))
@@ -96,7 +97,7 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 	else
 		dfsplen = 0;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if (sbflags & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
 	s = dentry_path_raw(direntry, page, PATH_MAX);
@@ -123,7 +124,7 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 	if (dfsplen) {
 		s -= dfsplen;
 		memcpy(s, tree, dfsplen);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
+		if (sbflags & CIFS_MOUNT_POSIX_PATHS) {
 			int i;
 			for (i = 0; i < dfsplen; i++) {
 				if (s[i] == '\\')
@@ -152,7 +153,7 @@ char *build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page
 static int
 check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry);
 	int i;
 
 	if (unlikely(tcon->fsAttrInfo.MaxPathNameComponentLength &&
@@ -160,7 +161,7 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)) {
 		for (i = 0; i < direntry->d_name.len; i++) {
 			if (direntry->d_name.name[i] == '\\') {
 				cifs_dbg(FYI, "Invalid file name\n");
@@ -181,11 +182,12 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
 	int desired_access;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifs_tcon *tcon = tlink_tcon(tlink);
 	const char *full_path;
 	void *page = alloc_dentry_path();
 	struct inode *newinode = NULL;
+	unsigned int sbflags;
 	int disposition;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
@@ -365,6 +367,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	 * If Open reported that we actually created a file then we now have to
 	 * set the mode if possible.
 	 */
+	sbflags = cifs_sb_flags(cifs_sb);
 	if ((tcon->unix_ext) && (*oplock & CIFS_CREATE_ACTION)) {
 		struct cifs_unix_set_info_args args = {
 				.mode	= mode,
@@ -374,7 +377,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 				.device	= 0,
 		};
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (sbflags & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				args.gid = inode->i_gid;
@@ -411,9 +414,9 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			if (server->ops->set_lease_key)
 				server->ops->set_lease_key(newinode, fid);
 			if ((*oplock & CIFS_CREATE_ACTION) && S_ISREG(newinode->i_mode)) {
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+				if (sbflags & CIFS_MOUNT_DYNPERM)
 					newinode->i_mode = mode;
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+				if (sbflags & CIFS_MOUNT_SET_UID) {
 					newinode->i_uid = current_fsuid();
 					if (inode->i_mode & S_ISGID)
 						newinode->i_gid = inode->i_gid;
@@ -458,18 +461,20 @@ int
 cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		 struct file *file, unsigned int oflags, umode_t mode)
 {
-	int rc;
-	unsigned int xid;
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	struct cifs_open_info_data buf = {};
 	struct TCP_Server_Info *server;
-	struct cifs_fid fid = {};
-	struct cifs_pending_open open;
-	__u32 oplock;
 	struct cifsFileInfo *file_info;
-	struct cifs_open_info_data buf = {};
+	struct cifs_pending_open open;
+	struct cifs_fid fid = {};
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	unsigned int sbflags;
+	unsigned int xid;
+	__u32 oplock;
+	int rc;
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
+	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
 	/*
@@ -499,7 +504,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
 
-	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
 		rc = PTR_ERR(tlink);
 		goto out_free_xid;
@@ -536,13 +541,13 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		goto out;
 	}
 
-	if (file->f_flags & O_DIRECT &&
-	    CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	sbflags = cifs_sb_flags(cifs_sb);
+	if ((file->f_flags & O_DIRECT) && (sbflags & CIFS_MOUNT_STRICT_IO)) {
+		if (sbflags & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
-		}
+	}
 
 	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock, buf.symlink_target);
 	if (file_info == NULL) {
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 88273f82812b..5d16cae312bc 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -270,7 +270,7 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
 static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
 	struct cifs_io_request *req = container_of(rreq, struct cifs_io_request, rreq);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode);
 	struct cifsFileInfo *open_file = NULL;
 
 	rreq->rsize = cifs_sb->ctx->rsize;
@@ -281,7 +281,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		open_file = file->private_data;
 		rreq->netfs_priv = file->private_data;
 		req->cfile = cifsFileInfo_get(open_file);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RWPIDFORWARD)
 			req->pid = req->cfile->pid;
 	} else if (rreq->origin != NETFS_WRITEBACK) {
 		WARN_ON_ONCE(1);
@@ -906,7 +906,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		 * close  because it may cause a error when we open this file
 		 * again and get at least level II oplock.
 		 */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_STRICT_IO)
 			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
@@ -955,11 +955,11 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 int cifs_file_flush(const unsigned int xid, struct inode *inode,
 		    struct cifsFileInfo *cfile)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifs_tcon *tcon;
 	int rc;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)
 		return 0;
 
 	if (cfile && (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)) {
@@ -1015,24 +1015,24 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 int cifs_open(struct inode *inode, struct file *file)
 
 {
-	int rc = -EACCES;
-	unsigned int xid;
-	__u32 oplock;
-	struct cifs_sb_info *cifs_sb;
-	struct TCP_Server_Info *server;
-	struct cifs_tcon *tcon;
-	struct tcon_link *tlink;
-	struct cifsFileInfo *cfile = NULL;
-	void *page;
-	const char *full_path;
-	bool posix_open_ok = false;
-	struct cifs_fid fid = {};
-	struct cifs_pending_open open;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifs_open_info_data data = {};
+	struct cifsFileInfo *cfile = NULL;
+	struct TCP_Server_Info *server;
+	struct cifs_pending_open open;
+	bool posix_open_ok = false;
+	struct cifs_fid fid = {};
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	const char *full_path;
+	unsigned int sbflags;
+	int rc = -EACCES;
+	unsigned int xid;
+	__u32 oplock;
+	void *page;
 
 	xid = get_xid();
 
-	cifs_sb = CIFS_SB(inode->i_sb);
 	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
 		free_xid(xid);
 		return smb_EIO(smb_eio_trace_forced_shutdown);
@@ -1056,9 +1056,9 @@ int cifs_open(struct inode *inode, struct file *file)
 	cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
 		 inode, file->f_flags, full_path);
 
-	if (file->f_flags & O_DIRECT &&
-	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+	sbflags = cifs_sb_flags(cifs_sb);
+	if ((file->f_flags & O_DIRECT) && (sbflags & CIFS_MOUNT_STRICT_IO)) {
+		if (sbflags & CIFS_MOUNT_NO_BRL)
 			file->f_op = &cifs_file_direct_nobrl_ops;
 		else
 			file->f_op = &cifs_file_direct_ops;
@@ -1209,7 +1209,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cinode);
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 	down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
@@ -1222,7 +1222,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -2011,7 +2011,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cinode);
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 	/* we are going to update can_cache_brlcks here - need a write access */
@@ -2024,7 +2024,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		rc = cifs_push_posix_locks(cfile);
 	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -2428,11 +2428,11 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	cifs_read_flock(fl, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
-	cifs_sb = CIFS_FILE_SB(file);
+	cifs_sb = CIFS_SB(file);
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 
 	if (!lock && !unlock) {
@@ -2455,14 +2455,14 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 
 int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 {
-	int rc, xid;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
+	struct cifsFileInfo *cfile;
 	int lock = 0, unlock = 0;
 	bool wait_flag = false;
 	bool posix_lck = false;
-	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cfile;
 	__u32 type;
+	int rc, xid;
 
 	rc = -EACCES;
 	xid = get_xid();
@@ -2477,12 +2477,11 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 
 	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
-	cifs_sb = CIFS_FILE_SB(file);
 	set_bit(CIFS_INO_CLOSE_ON_LOCK, &CIFS_I(d_inode(cfile->dentry))->flags);
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
+	    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		posix_lck = true;
 	/*
 	 * BB add code here to normalize offset and length to account for
@@ -2532,11 +2531,11 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode);
 	struct cifsFileInfo *open_file = NULL;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2589,10 +2588,10 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 		return rc;
 	}
 
-	cifs_sb = CIFS_SB(cifs_inode->netfs.inode.i_sb);
+	cifs_sb = CIFS_SB(cifs_inode);
 
 	/* only filter by fsuid on multiuser mounts */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
 	spin_lock(&cifs_inode->open_file_lock);
@@ -2787,7 +2786,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file_inode(file);
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
 	rc = file_write_and_wait_range(file, start, end);
 	if (rc) {
@@ -2801,7 +2800,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		 file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOSSYNC)) {
 		server = tcon->ses->server;
 		if (server->ops->flush == NULL) {
 			rc = -ENOSYS;
@@ -2853,7 +2852,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file->f_mapping->host;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	ssize_t rc;
 
 	rc = netfs_start_io_write(inode);
@@ -2870,7 +2869,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (rc <= 0)
 		goto out;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) &&
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) &&
 	    (cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
 				     server->vals->exclusive_lock_type, 0,
 				     NULL, CIFS_WRITE_OP))) {
@@ -2893,7 +2892,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
 						iocb->ki_filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
@@ -2906,7 +2905,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (CIFS_CACHE_WRITE(cinode)) {
 		if (cap_unix(tcon->ses) &&
 		    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
-		    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
+		    ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
 			written = netfs_file_write_iter(iocb, from);
 			goto out;
 		}
@@ -2994,7 +2993,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
 						iocb->ki_filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
@@ -3011,7 +3010,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (!CIFS_CACHE_READ(cinode))
 		return netfs_unbuffered_read_iter(iocb, to);
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) {
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NOPOSIXBRL) == 0) {
 		if (iocb->ki_flags & IOCB_DIRECT)
 			return netfs_unbuffered_read_iter(iocb, to);
 		return netfs_buffered_read_iter(iocb, to);
@@ -3130,10 +3129,9 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 	if (is_inode_writable(cifsInode) ||
 		((cifsInode->oplock & CIFS_CACHE_RW_FLG) != 0 && from_readdir)) {
 		/* This inode is open for write at least once */
-		struct cifs_sb_info *cifs_sb;
+		struct cifs_sb_info *cifs_sb = CIFS_SB(cifsInode);
 
-		cifs_sb = CIFS_SB(cifsInode->netfs.inode.i_sb);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
 			we can change size safely */
 			return true;
@@ -3181,7 +3179,7 @@ void cifs_oplock_break(struct work_struct *work)
 	server = tcon->ses->server;
 
 	scoped_guard(spinlock, &cinode->open_file_lock) {
-		unsigned int sbflags = cifs_sb->mnt_cifs_flags;
+		unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
 		server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
 					      cfile->oplock_epoch, &purge_cache);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 412c5b534791..0af050ab02e3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -2062,161 +2062,160 @@ smb3_cleanup_fs_context(struct smb3_fs_context *ctx)
 	kfree(ctx);
 }
 
-void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
+unsigned int smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
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
-	if (ctx->mfsymlinks) {
-		if (ctx->sfu_emul) {
-			/*
-			 * Our SFU ("Services for Unix") emulation allows now
-			 * creating new and reading existing SFU symlinks.
-			 * Older Linux kernel versions were not able to neither
-			 * read existing nor create new SFU symlinks. But
-			 * creating and reading SFU style mknod and FIFOs was
-			 * supported for long time. When "mfsymlinks" and
-			 * "sfu" are both enabled at the same time, it allows
-			 * reading both types of symlinks, but will only create
-			 * them with mfsymlinks format. This allows better
-			 * Apple compatibility, compatibility with older Linux
-			 * kernel clients (probably better for Samba too)
-			 * while still recognizing old Windows style symlinks.
-			 */
-			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
-		}
-	}
-	cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SHUTDOWN;
+		sbflags &= ~CIFS_MOUNT_MF_SYMLINKS;
 
-	return;
+	if (ctx->mfsymlinks && ctx->sfu_emul) {
+		/*
+		 * Our SFU ("Services for Unix") emulation allows now
+		 * creating new and reading existing SFU symlinks.
+		 * Older Linux kernel versions were not able to neither
+		 * read existing nor create new SFU symlinks. But
+		 * creating and reading SFU style mknod and FIFOs was
+		 * supported for long time. When "mfsymlinks" and
+		 * "sfu" are both enabled at the same time, it allows
+		 * reading both types of symlinks, but will only create
+		 * them with mfsymlinks format. This allows better
+		 * Apple compatibility, compatibility with older Linux
+		 * kernel clients (probably better for Samba too)
+		 * while still recognizing old Windows style symlinks.
+		 */
+		cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
+	}
+	sbflags &= ~CIFS_MOUNT_SHUTDOWN;
+	atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
+	return sbflags;
 }
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 49b2a6f09ca2..0b64fcb5d302 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -374,7 +374,7 @@ int smb3_fs_context_dup(struct smb3_fs_context *new_ctx,
 			struct smb3_fs_context *ctx);
 int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb,
 				    struct cifs_ses *ses);
-void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
+unsigned int smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 /*
  * max deferred close timeout (jiffies) - 2^30
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c23c057162e6..c2a71d5bfbe6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -40,32 +40,33 @@ static void cifs_set_netfs_context(struct inode *inode)
 
 static void cifs_set_ops(struct inode *inode)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct netfs_inode *ictx = netfs_inode(inode);
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &cifs_file_inode_ops;
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (sbflags & CIFS_MOUNT_DIRECT_IO) {
 			set_bit(NETFS_ICTX_UNBUFFERED, &ictx->flags);
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+			if (sbflags & CIFS_MOUNT_NO_BRL)
 				inode->i_fop = &cifs_file_direct_nobrl_ops;
 			else
 				inode->i_fop = &cifs_file_direct_ops;
-		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+		} else if (sbflags & CIFS_MOUNT_STRICT_IO) {
+			if (sbflags & CIFS_MOUNT_NO_BRL)
 				inode->i_fop = &cifs_file_strict_nobrl_ops;
 			else
 				inode->i_fop = &cifs_file_strict_ops;
-		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+		} else if (sbflags & CIFS_MOUNT_NO_BRL)
 			inode->i_fop = &cifs_file_nobrl_ops;
 		else { /* not direct, send byte range locks */
 			inode->i_fop = &cifs_file_ops;
 		}
 
 		/* check if server can support readahead */
-		if (cifs_sb_master_tcon(cifs_sb)->ses->server->max_read <
-				PAGE_SIZE + MAX_CIFS_HDR_SIZE)
+		if (tcon->ses->server->max_read < PAGE_SIZE + MAX_CIFS_HDR_SIZE)
 			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
@@ -194,8 +195,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	inode->i_gid = fattr->cf_gid;
 
 	/* if dynperm is set, don't clobber existing mode */
-	if (inode_state_read(inode) & I_NEW ||
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
+	if ((inode_state_read(inode) & I_NEW) ||
+	    !(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
@@ -248,10 +249,8 @@ cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
-		return;
-
-	fattr->cf_uniqueid = iunique(sb, ROOT_I);
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM))
+		fattr->cf_uniqueid = iunique(sb, ROOT_I);
 }
 
 /* Fill a cifs_fattr struct with info from FILE_UNIX_BASIC_INFO. */
@@ -259,6 +258,8 @@ void
 cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 			 struct cifs_sb_info *cifs_sb)
 {
+	unsigned int sbflags;
+
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_uniqueid = le64_to_cpu(info->UniqueId);
 	fattr->cf_bytes = le64_to_cpu(info->NumOfBytes);
@@ -317,8 +318,9 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		break;
 	}
 
+	sbflags = cifs_sb_flags(cifs_sb);
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
+	if (!(sbflags & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
 			kuid_t uid = make_kuid(&init_user_ns, id);
@@ -328,7 +330,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 	}
 	
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
+	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
 			kgid_t gid = make_kgid(&init_user_ns, id);
@@ -382,7 +384,7 @@ static int update_inode_info(struct super_block *sb,
 	 *
 	 * If file type or uniqueid is different, return error.
 	 */
-	if (unlikely((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (unlikely((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 		     CIFS_I(*inode)->uniqueid != fattr->cf_uniqueid)) {
 		CIFS_I(*inode)->time = 0; /* force reval */
 		return -ESTALE;
@@ -468,7 +470,7 @@ static int cifs_get_unix_fattr(const unsigned char *full_path,
 		cifs_fill_uniqueid(sb, fattr);
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1081,7 +1083,7 @@ cifs_backup_query_path_info(int xid,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0)
 		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
 		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	else /* no srvino useful for fallback to some netapp */
 		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
@@ -1109,7 +1111,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc;
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)) {
 		if (*inode)
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else
@@ -1263,14 +1265,15 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 			  struct inode **inode,
 			  const char *full_path)
 {
-	struct cifs_open_info_data tmp_data = {};
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_open_info_data tmp_data = {};
 	void *smb1_backup_rsp_buf = NULL;
-	int rc = 0;
+	struct TCP_Server_Info *server;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	unsigned int sbflags;
 	int tmprc = 0;
+	int rc = 0;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -1370,16 +1373,17 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 handle_mnt_opt:
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	sbflags = cifs_sb_flags(cifs_sb);
 	/* query for SFU type info if supported and needed */
 	if ((fattr->cf_cifsattrs & ATTR_SYSTEM) &&
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)) {
+	    (sbflags & CIFS_MOUNT_UNX_EMUL)) {
 		tmprc = cifs_sfu_type(fattr, full_path, cifs_sb, xid);
 		if (tmprc)
 			cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
 	}
 
 	/* fill in 0777 bits from ACL */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
+	if (sbflags & CIFS_MOUNT_MODE_FROM_SID) {
 		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
 				       true, full_path, fid);
 		if (rc == -EREMOTE)
@@ -1389,7 +1393,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+	} else if (sbflags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
 				       false, full_path, fid);
 		if (rc == -EREMOTE)
@@ -1399,7 +1403,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 				 __func__, rc);
 			goto out;
 		}
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
+	} else if (sbflags & CIFS_MOUNT_UNX_EMUL)
 		/* fill in remaining high mode bits e.g. SUID, VTX */
 		cifs_sfu_mode(fattr, full_path, cifs_sb, xid);
 	else if (!(tcon->posix_extensions))
@@ -1409,7 +1413,7 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 
 
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (sbflags & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1509,7 +1513,7 @@ static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
 	 * 3. Tweak fattr based on mount options
 	 */
 	/* check for Minshall+French symlinks */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
 		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
 	}
@@ -1660,7 +1664,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	int len;
 	int rc;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_USE_PREFIX_PATH)
 	    && cifs_sb->prepath) {
 		len = strlen(cifs_sb->prepath);
 		path = kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
@@ -2098,8 +2102,9 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 		 const char *full_path, struct cifs_sb_info *cifs_sb,
 		 struct cifs_tcon *tcon, const unsigned int xid)
 {
-	int rc = 0;
 	struct inode *inode = NULL;
+	unsigned int sbflags;
+	int rc = 0;
 
 	if (tcon->posix_extensions) {
 		rc = smb311_posix_get_inode_info(&inode, full_path,
@@ -2139,6 +2144,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 	if (parent->i_mode & S_ISGID)
 		mode |= S_ISGID;
 
+	sbflags = cifs_sb_flags(cifs_sb);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (tcon->unix_ext) {
 		struct cifs_unix_set_info_args args = {
@@ -2148,7 +2154,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 			.mtime	= NO_CHANGE_64,
 			.device	= 0,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (sbflags & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			if (parent->i_mode & S_ISGID)
 				args.gid = parent->i_gid;
@@ -2166,14 +2172,14 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 	{
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 		struct TCP_Server_Info *server = tcon->ses->server;
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
+		if (!(sbflags & CIFS_MOUNT_CIFS_ACL) &&
 		    (mode & S_IWUGO) == 0 && server->ops->mkdir_setinfo)
 			server->ops->mkdir_setinfo(inode, full_path, cifs_sb,
 						   tcon, xid);
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+		if (sbflags & CIFS_MOUNT_DYNPERM)
 			inode->i_mode = (mode | S_IFDIR);
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (sbflags & CIFS_MOUNT_SET_UID) {
 			inode->i_uid = current_fsuid();
 			if (inode->i_mode & S_ISGID)
 				inode->i_gid = parent->i_gid;
@@ -2687,7 +2693,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct cached_fid *cfid = NULL;
 
@@ -2728,7 +2734,7 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	}
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
@@ -2753,10 +2759,10 @@ cifs_wait_bit_killable(struct wait_bit_key *key, int mode)
 int
 cifs_revalidate_mapping(struct inode *inode)
 {
-	int rc;
 	struct cifsInodeInfo *cifs_inode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	unsigned long *flags = &cifs_inode->flags;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	int rc;
 
 	/* swapfiles are not supposed to be shared */
 	if (IS_SWAPFILE(inode))
@@ -2769,7 +2775,7 @@ cifs_revalidate_mapping(struct inode *inode)
 
 	if (test_and_clear_bit(CIFS_INO_INVALID_MAPPING, flags)) {
 		/* for cache=singleclient, do not invalidate */
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_RW_CACHE)
 			goto skip_invalidate;
 
 		cifs_inode->netfs.zero_point = cifs_inode->netfs.remote_i_size;
@@ -2893,10 +2899,11 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		 struct kstat *stat, u32 request_mask, unsigned int flags)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(path->dentry);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct dentry *dentry = path->dentry;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct inode *inode = d_inode(dentry);
+	unsigned int sbflags;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
@@ -2953,12 +2960,13 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
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
@@ -3103,7 +3111,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	void *page = alloc_dentry_path();
 	struct inode *inode = d_inode(direntry);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	struct cifs_unix_set_info_args *args = NULL;
@@ -3114,7 +3122,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3267,26 +3275,26 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 static int
 cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 {
-	unsigned int xid;
+	struct inode *inode = d_inode(direntry);
+	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
+	struct cifsFileInfo *cfile = NULL;
+	void *page = alloc_dentry_path();
+	__u64 mode = NO_CHANGE_64;
 	kuid_t uid = INVALID_UID;
 	kgid_t gid = INVALID_GID;
-	struct inode *inode = d_inode(direntry);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
-	struct cifsFileInfo *cfile = NULL;
 	const char *full_path;
-	void *page = alloc_dentry_path();
-	int rc = -EACCES;
 	__u32 dosattr = 0;
-	__u64 mode = NO_CHANGE_64;
-	bool posix = cifs_sb_master_tcon(cifs_sb)->posix_extensions;
+	int rc = -EACCES;
+	unsigned int xid;
 
 	xid = get_xid();
 
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3347,8 +3355,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	if (sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
@@ -3359,9 +3366,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				goto cifs_setattr_exit;
 			}
 		}
-	} else
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
+	} else if (!(sbflags & CIFS_MOUNT_SET_UID)) {
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
+	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
@@ -3370,9 +3377,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		mode = attrs->ia_mode;
 		rc = 0;
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) ||
-		    posix) {
+		if ((sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) ||
+		    cifs_sb_master_tcon(cifs_sb)->posix_extensions) {
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
 						INVALID_UID, INVALID_GID);
 			if (rc) {
@@ -3394,7 +3400,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
 
 			/* fix up mode if we're not using dynperm */
-			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
+			if ((sbflags & CIFS_MOUNT_DYNPERM) == 0)
 				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
 		} else if ((mode & S_IWUGO) &&
 			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
@@ -3405,7 +3411,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				dosattr |= ATTR_NORMAL;
 
 			/* reset local inode permissions to normal */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+			if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
@@ -3414,7 +3420,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 					attrs->ia_mode |=
 						cifs_sb->ctx->file_mode;
 			}
-		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+		} else if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
 			attrs->ia_valid &= ~ATTR_MODE;
 		}
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index a4aa063cf5ea..233d90316747 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -216,7 +216,7 @@ static int cifs_shutdown(struct super_block *sb, unsigned long arg)
 	 */
 	case CIFS_GOING_FLAGS_LOGFLUSH:
 	case CIFS_GOING_FLAGS_NOLOGFLUSH:
-		sbi->mnt_cifs_flags |= CIFS_MOUNT_SHUTDOWN;
+		atomic_or(CIFS_MOUNT_SHUTDOWN, &sbi->mnt_cifs_flags);
 		goto shutdown_good;
 	default:
 		rc = -EINVAL;
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index a2f7bfa8ad1e..434e8fe74080 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -544,14 +544,15 @@ int
 cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	     struct dentry *direntry, const char *symname)
 {
-	int rc = -EOPNOTSUPP;
-	unsigned int xid;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	struct inode *newinode = NULL;
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	const char *full_path;
+	int rc = -EOPNOTSUPP;
+	unsigned int sbflags;
+	unsigned int xid;
 	void *page;
-	struct inode *newinode = NULL;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
@@ -580,6 +581,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
+	sbflags = cifs_sb_flags(cifs_sb);
 	rc = -EOPNOTSUPP;
 	switch (cifs_symlink_type(cifs_sb)) {
 	case CIFS_SYMLINK_TYPE_UNIX:
@@ -594,14 +596,14 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 		break;
 
 	case CIFS_SYMLINK_TYPE_MFSYMLINKS:
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+		if (sbflags & CIFS_MOUNT_MF_SYMLINKS) {
 			rc = create_mf_symlink(xid, pTcon, cifs_sb,
 					       full_path, symname);
 		}
 		break;
 
 	case CIFS_SYMLINK_TYPE_SFU:
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+		if (sbflags & CIFS_MOUNT_UNX_EMUL) {
 			rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
 						  full_path, S_IFLNK,
 						  0, symname);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 1773e3b471aa..389e45c10132 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -275,13 +275,15 @@ dump_smb(void *buf, int smb_buf_length)
 void
 cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
+
+	if (sbflags & CIFS_MOUNT_SERVER_INUM) {
 		struct cifs_tcon *tcon = NULL;
 
 		if (cifs_sb->master_tlink)
 			tcon = cifs_sb_master_tcon(cifs_sb);
 
-		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+		atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 		cifs_sb->mnt_cifs_serverino_autodisabled = true;
 		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s\n",
 			 tcon ? tcon->tree_name : "new server");
@@ -382,11 +384,13 @@ void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 bool
 backup_cred(struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
+
+	if (sbflags & CIFS_MOUNT_CIFS_BACKUPUID) {
 		if (uid_eq(cifs_sb->ctx->backupuid, current_fsuid()))
 			return true;
 	}
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
+	if (sbflags & CIFS_MOUNT_CIFS_BACKUPGID) {
 		if (in_group_p(cifs_sb->ctx->backupgid))
 			return true;
 	}
@@ -954,7 +958,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 			convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
 	}
 
-	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
+	atomic_or(CIFS_MOUNT_USE_PREFIX_PATH, &cifs_sb->mnt_cifs_flags);
 	return 0;
 }
 
@@ -983,7 +987,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	 * look up or tcon is not DFS.
 	 */
 	if (strlen(full_path) < 2 || !cifs_sb ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS) ||
 	    !is_tcon_dfs(tcon))
 		return 0;
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 67a8555efa1e..a0a6f0dde75a 100644
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
@@ -177,6 +177,7 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	struct cifs_open_info_data data = {
 		.reparse = { .tag = fattr->cf_cifstag, },
 	};
+	unsigned int sbflags;
 
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
@@ -215,12 +216,12 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * may look wrong since the inodes may not have timed out by the time
 	 * "ls" does a stat() call on them.
 	 */
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
+	sbflags = cifs_sb_flags(cifs_sb);
+	if (sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
-	    fattr->cf_cifsattrs & ATTR_SYSTEM) {
+	if ((sbflags & CIFS_MOUNT_UNX_EMUL) &&
+	    (fattr->cf_cifsattrs & ATTR_SYSTEM)) {
 		if (fattr->cf_eof == 0)  {
 			fattr->cf_mode &= ~S_IFMT;
 			fattr->cf_mode |= S_IFIFO;
@@ -345,13 +346,14 @@ static int
 _initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
 {
-	__u16 search_flags;
-	int rc = 0;
-	struct cifsFileInfo *cifsFile;
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 	struct tcon_link *tlink = NULL;
-	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
+	struct cifsFileInfo *cifsFile;
+	struct cifs_tcon *tcon;
+	unsigned int sbflags;
+	__u16 search_flags;
+	int rc = 0;
 
 	if (file->private_data == NULL) {
 		tlink = cifs_sb_tlink(cifs_sb);
@@ -385,6 +387,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
 ffirst_retry:
+	sbflags = cifs_sb_flags(cifs_sb);
 	/* test for Unix extensions */
 	/* but now check for them on the share/mount not on the SMB session */
 	/* if (cap_unix(tcon->ses) { */
@@ -395,7 +398,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	else if ((tcon->ses->capabilities &
 		  tcon->ses->server->vals->cap_nt_find) == 0) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+	} else if (sbflags & CIFS_MOUNT_SERVER_INUM) {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
 	} else /* not srvinos - BB fixme add check for backlevel? */ {
 		cifsFile->srch_inf.info_level = SMB_FIND_FILE_FULL_DIRECTORY_INFO;
@@ -411,8 +414,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 
 	if (rc == 0) {
 		cifsFile->invalidHandle = false;
-	} else if ((rc == -EOPNOTSUPP) &&
-		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	} else if (rc == -EOPNOTSUPP && (sbflags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_autodisable_serverino(cifs_sb);
 		goto ffirst_retry;
 	}
@@ -690,7 +692,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 	loff_t first_entry_in_buffer;
 	loff_t index_to_find = pos;
 	struct cifsFileInfo *cfile = file->private_data;
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	/* check if index in the buffer */
 
@@ -955,6 +957,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_dirent de = { NULL, };
 	struct cifs_fattr fattr;
+	unsigned int sbflags;
 	struct qstr name;
 	int rc = 0;
 
@@ -1019,15 +1022,15 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		break;
 	}
 
-	if (de.ino && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	sbflags = cifs_sb_flags(cifs_sb);
+	if (de.ino && (sbflags & CIFS_MOUNT_SERVER_INUM)) {
 		fattr.cf_uniqueid = de.ino;
 	} else {
 		fattr.cf_uniqueid = iunique(sb, ROOT_I);
 		cifs_autodisable_serverino(cifs_sb);
 	}
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) &&
-	    couldbe_mf_symlink(&fattr))
+	if ((sbflags & CIFS_MOUNT_MF_SYMLINKS) && couldbe_mf_symlink(&fattr))
 		/*
 		 * trying to get the type and mode can be slow,
 		 * so just call those regular files for now, and mark
@@ -1058,7 +1061,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	const char *full_path;
 	void *page = alloc_dentry_path();
 	struct cached_fid *cfid = NULL;
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(file);
 
 	xid = get_xid();
 
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ce9b923498b5..cd1e1eaee67a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -55,17 +55,18 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 				 const char *full_path, const char *symname)
 {
 	struct reparse_symlink_data_buffer *buf = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	const char *symroot = cifs_sb->ctx->symlinkroot;
 	struct cifs_open_info_data data = {};
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	const char *symroot = cifs_sb->ctx->symlinkroot;
-	struct inode *new;
-	struct kvec iov;
-	__le16 *path = NULL;
-	bool directory;
+	char sep = CIFS_DIR_SEP(cifs_sb);
 	char *symlink_target = NULL;
-	char *sym = NULL;
-	char sep = CIFS_DIR_SEP(cifs_sb);
 	u16 len, plen, poff, slen;
+	unsigned int sbflags;
+	__le16 *path = NULL;
+	struct inode *new;
+	char *sym = NULL;
+	struct kvec iov;
+	bool directory;
 	int rc = 0;
 
 	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
@@ -83,8 +84,8 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		.symlink_target = symlink_target,
 	};
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
-	    symroot && symname[0] == '/') {
+	sbflags = cifs_sb_flags(cifs_sb);
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symroot && symname[0] == '/') {
 		/*
 		 * This is a request to create an absolute symlink on the server
 		 * which does not support POSIX paths, and expects symlink in
@@ -164,7 +165,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	 * mask these characters in NT object prefix by '_' and then change
 	 * them back.
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
 		sym[0] = sym[1] = sym[2] = sym[5] = '_';
 
 	path = cifs_convert_path_to_utf16(sym, cifs_sb);
@@ -173,7 +174,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		goto out;
 	}
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
 		sym[0] = '\\';
 		sym[1] = sym[2] = '?';
 		sym[5] = ':';
@@ -197,7 +198,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	slen = 2 * UniStrnlen((wchar_t *)path, REPARSE_SYM_PATH_MAX);
 	poff = 0;
 	plen = slen;
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
 		/*
 		 * For absolute NT symlinks skip leading "\\??\\" in PrintName as
 		 * PrintName is user visible location in DOS/Win32 format (not in NT format).
@@ -824,7 +825,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 		goto out;
 	}
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS) &&
 	    symroot && !relative) {
 		/*
 		 * This is an absolute symlink from the server which does not
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 570b0d25aeba..0164dc47bdfd 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -33,7 +33,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 {
 	u32 uid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
 	return make_kuid(current_user_ns(), uid);
 }
@@ -43,7 +43,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 {
 	u32 gid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
 	return make_kgid(current_user_ns(), gid);
 }
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 970aeffe936e..a117ec2dbba5 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -49,6 +49,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+		unsigned int sbflags;
 
 		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/*
@@ -75,14 +76,16 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
 			cifs_dbg(VFS, "per-share encryption not supported yet\n");
 
+		if (cifs_sb)
+			sbflags = cifs_sb_flags(cifs_sb);
+
 		cap &= CIFS_UNIX_CAP_MASK;
 		if (ctx && ctx->no_psx_acl)
 			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
 			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
+				sbflags |= CIFS_MOUNT_POSIXACL;
 		}
 
 		if (ctx && ctx->posix_paths == 0)
@@ -90,10 +93,12 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
 			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
+				sbflags |= CIFS_MOUNT_POSIX_PATHS;
 		}
 
+		if (cifs_sb)
+			atomic_set(&cifs_sb->mnt_cifs_flags, sbflags);
+
 		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
 #ifdef CONFIG_CIFS_DEBUG2
 		if (cap & CIFS_UNIX_FCNTL_CAP)
@@ -1147,7 +1152,7 @@ static int cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
 				__u64 volatile_fid, __u16 net_fid,
 				struct cifsInodeInfo *cinode, unsigned int oplock)
 {
-	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(cinode));
 	__u8 op;
 
 	op = !!((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT_RO_CACHE));
@@ -1282,7 +1287,8 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	       struct dentry *dentry, struct cifs_tcon *tcon,
 	       const char *full_path, umode_t mode, dev_t dev)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct inode *newinode = NULL;
 	int rc;
 
@@ -1298,7 +1304,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			.mtime	= NO_CHANGE_64,
 			.device	= dev,
 		};
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+		if (sbflags & CIFS_MOUNT_SET_UID) {
 			args.uid = current_fsuid();
 			args.gid = current_fsgid();
 		} else {
@@ -1317,7 +1323,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		if (rc == 0)
 			d_instantiate(dentry, newinode);
 		return rc;
-	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	} else if (sbflags & CIFS_MOUNT_UNX_EMUL) {
 		/*
 		 * Check if mounted with mount parm 'sfu' mount parm.
 		 * SFU emulation should work with all servers
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 476c53b3711f..7f93bbc79bb1 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -72,7 +72,7 @@ int smb2_fix_symlink_target_type(char **target, bool directory, struct cifs_sb_i
 	 * POSIX server does not distinguish between symlinks to file and
 	 * symlink directory. So nothing is needed to fix on the client side.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_POSIX_PATHS)
 		return 0;
 
 	if (!*target)
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index d1ae839e4863..26dba7c93db4 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -455,17 +455,8 @@ smb2_calc_size(void *buf)
 __le16 *
 cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 {
-	int len;
 	const char *start_of_path;
-	__le16 *to;
-	int map_type;
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR)
-		map_type = SFM_MAP_UNI_RSVD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
-		map_type = SFU_MAP_UNI_RSVD;
-	else
-		map_type = NO_MAP_UNI_RSVD;
+	int len;
 
 	/* Windows doesn't allow paths beginning with \ */
 	if (from[0] == '\\')
@@ -479,14 +470,13 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 	} else
 		start_of_path = from;
 
-	to = cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len,
-				   cifs_sb->local_nls, map_type);
-	return to;
+	return cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len,
+				     cifs_sb->local_nls, cifs_remap(cifs_sb));
 }
 
 __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock)
 {
-	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(cinode));
 	__le32 lease = 0;
 
 	if ((oplock & CIFS_CACHE_WRITE_FLG) || (sbflags & CIFS_MOUNT_RW_CACHE))
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7370d7a18cd0..171fcb8dc0f0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -987,7 +987,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 				rc = -EREMOTE;
 		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+		    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2692,7 +2692,7 @@ static int smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
 				__u64 volatile_fid, __u16 net_fid,
 				struct cifsInodeInfo *cinode, unsigned int oplock)
 {
-	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(cinode));
 	__u8 op;
 
 	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
@@ -5333,7 +5333,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  struct dentry *dentry, struct cifs_tcon *tcon,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int sbflags = cifs_sb_flags(CIFS_SB(inode));
 	int rc = -EOPNOTSUPP;
 
 	/*
@@ -5342,7 +5342,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+	if (sbflags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	} else if (CIFS_REPARSE_SUPPORT(tcon)) {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7f3edf42b9c3..31ebdb60d90e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3184,22 +3184,19 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 
 	if ((oparms->disposition != FILE_OPEN) && (oparms->cifs_sb)) {
+		unsigned int sbflags = cifs_sb_flags(oparms->cifs_sb);
 		bool set_mode;
 		bool set_owner;
 
-		if ((oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) &&
-		    (oparms->mode != ACL_NO_MODE))
+		if ((sbflags & CIFS_MOUNT_MODE_FROM_SID) &&
+		    oparms->mode != ACL_NO_MODE) {
 			set_mode = true;
-		else {
+		} else {
 			set_mode = false;
 			oparms->mode = ACL_NO_MODE;
 		}
 
-		if (oparms->cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL)
-			set_owner = true;
-		else
-			set_owner = false;
-
+		set_owner = sbflags & CIFS_MOUNT_UID_FROM_ACL;
 		if (set_owner | set_mode) {
 			cifs_dbg(FYI, "add sd with mode 0x%x\n", oparms->mode);
 			rc = add_sd_context(iov, &n_iov, oparms->mode, set_owner);
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index e1a7d9a10a53..23227f2f9428 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -149,7 +149,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->set_EA) {
@@ -309,7 +309,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 			break;
 		}
 
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
 		if (pTcon->ses->server->ops->query_all_EAs)
@@ -398,7 +398,7 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_NO_XATTR)
 		return -EOPNOTSUPP;
 
 	tlink = cifs_sb_tlink(cifs_sb);
-- 
2.53.0

