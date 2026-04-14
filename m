Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958793115AF;
	Tue, 14 Apr 2026 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776177452; cv=none; b=Eyi8F678HsolDQBDr43UcbVHDd8Oi1V6r7pv73PDFjJzDkJBszVjb0gCKvVpRUKC9bgORrhpdQ1X/nk3H5Kyi3QaXDVBzJs6yIOu7LmcC+FiccK4NxVRy/9VSdgBpXQfjkwk8HpSeWXTYLrLVuQm6K8xaof8mk5kN4kcbQiAVd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776177452; c=relaxed/simple;
	bh=5RQ2BoHKBBLKbxf6m8wqphbNLkkIJ8MXTz6bhV2aqyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H7DFUGhDNTTmKpdHT3BHrg5BnoswFpTqjodnntQRy7ufiBVjTQReundt7VpkOicXtG4FGtRTJQDJnM2zYezaCna0u6XSZYcK4noMa4h4QPF5oKPEzEp32thp+LIVBy2ODLtGFYoyaMhuq2y+FK0k11f6Ay5wSagBAENLsnegAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=52TnticL; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="52TnticL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=J8x1aq6PSopvf/hXZfxwRUdDZpC5EfUzTLL7KcXdPyU=; b=52TnticLchLpV1ImUTXVktw8Wp
	hHA4XTC5Bii4qtvF9XEELd9NE/c4Uo5Bb0rsKpQpU4BVd0fek4KtAKronBws70ScpgYHMmtR/N+du
	of8wjXZakhvkUB/ZgDQ8ODZtzdqMDO05QDY0QVNYv01+yZ/rVQ9O5/Z4FmZ7dsU5dx7rlicRpbQRZ
	9YeH9C4+E+NcWHCqS/h01zuRIR9JIkvTY6imhjk9EGBuJMoO41/mRHxgFybD2eqMHJcHUYbVasge+
	toBd/HjiSX1i5OUzneBXKLQqY67dGLUuCwDuo5WFILIRA2xdtmcA8Zbe/ab5Nu7Yz2gq/v0VEy51T
	6QIhydXA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wCetH-000000009sy-1t1a;
	Tue, 14 Apr 2026 11:37:23 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Steve French <smfrench@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH] vfs: get rid of BUG_ON() in d_mark_tmpfile_name()
Date: Tue, 14 Apr 2026 11:37:21 -0300
Message-ID: <20260414143721.858743-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do proper error handling in d_mark_tmpfile_name() by returning errors
rather than using BUG_ON()'s.

Adjust caller to check for errors from d_mark_tmpfile_name() as well
as clean it up for using return value from scnprintf() in QSTR_LEN()
to make it more obvious where the tmpfile name's length is coming
from.

Link: https://lore.kernel.org/r/CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
CC: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
 fs/dcache.c            | 14 +++++++++-----
 fs/smb/client/cifsfs.h | 15 +++++----------
 fs/smb/client/dir.c    | 25 +++++++++++++++----------
 include/linux/dcache.h |  2 +-
 4 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index df11bbba0342..dbcbd0affb26 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3196,15 +3196,18 @@ void d_mark_tmpfile(struct file *file, struct inode *inode)
 }
 EXPORT_SYMBOL(d_mark_tmpfile);
 
-void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
+int d_mark_tmpfile_name(struct file *file, const struct qstr *name)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	char *dname = dentry->d_shortname.string;
 
-	BUG_ON(dname_external(dentry));
-	BUG_ON(d_really_is_positive(dentry));
-	BUG_ON(!d_unlinked(dentry));
-	BUG_ON(name->len > DNAME_INLINE_LEN - 1);
+	if (unlikely(dname_external(dentry) ||
+		     d_really_is_positive(dentry) ||
+		     !d_unlinked(dentry)))
+		return -EINVAL;
+	if (unlikely(name->len > DNAME_INLINE_LEN - 1))
+		return -ENAMETOOLONG;
+
 	spin_lock(&dentry->d_parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	dentry->__d_name.len = name->len;
@@ -3212,6 +3215,7 @@ void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
 	dname[name->len] = '\0';
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dentry->d_parent->d_lock);
+	return 0;
 }
 EXPORT_SYMBOL(d_mark_tmpfile_name);
 
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 18f9f93a01b4..7370b38da938 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -10,6 +10,7 @@
 #define _CIFSFS_H
 
 #include <linux/hash.h>
+#include <linux/dcache.h>
 
 #define ROOT_I 2
 
@@ -149,17 +150,11 @@ struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type, int flags,
 
 char *cifs_silly_fullpath(struct dentry *dentry);
 
-#define CIFS_TMPNAME_PREFIX        ".__smbfile_tmp"
-#define CIFS_TMPNAME_PREFIX_LEN    ((int)sizeof(CIFS_TMPNAME_PREFIX) - 1)
-#define CIFS_TMPNAME_COUNTER_LEN   ((int)sizeof(cifs_tmpcounter) * 2)
-#define CIFS_TMPNAME_LEN \
-	(CIFS_TMPNAME_PREFIX_LEN + CIFS_TMPNAME_COUNTER_LEN)
+#define CIFS_TMPNAME_PREFIX	".__smbfile_tmp"
+#define CIFS_TMPNAME_LEN	(DNAME_INLINE_LEN - 1)
 
-#define CIFS_SILLYNAME_PREFIX	    ".__smbfile_silly"
-#define CIFS_SILLYNAME_PREFIX_LEN  ((int)sizeof(CIFS_SILLYNAME_PREFIX) - 1)
-#define CIFS_SILLYNAME_COUNTER_LEN ((int)sizeof(cifs_sillycounter) * 2)
-#define CIFS_SILLYNAME_LEN \
-	(CIFS_SILLYNAME_PREFIX_LEN + CIFS_SILLYNAME_COUNTER_LEN)
+#define CIFS_SILLYNAME_PREFIX	".__smbfile_silly"
+#define CIFS_SILLYNAME_LEN	(DNAME_INLINE_LEN - 1)
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6ea1ae7f7a46..e4295a5b55b3 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1056,9 +1056,9 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
+	size_t namesize = CIFS_TMPNAME_LEN + 1;
 	char *path __free(kfree) = NULL, *name;
 	unsigned int oflags = file->f_flags;
-	size_t size = CIFS_TMPNAME_LEN + 1;
 	int retries = 0, max_retries = 16;
 	struct TCP_Server_Info *server;
 	struct cifs_pending_open open;
@@ -1070,6 +1070,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
+	int namelen;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
@@ -1093,7 +1094,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 		server->ops->new_lease_key(&fid);
 	cifs_add_pending_open(&fid, tlink, &open);
 
-	path = alloc_parent_path(dentry, size - 1);
+	path = alloc_parent_path(dentry, namesize - 1);
 	if (IS_ERR(path)) {
 		cifs_del_pending_open(&open);
 		rc = PTR_ERR(path);
@@ -1103,16 +1104,22 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 
 	name = path + strlen(path);
 	do {
-		scnprintf(name, size,
-			  CIFS_TMPNAME_PREFIX "%0*x",
-			  CIFS_TMPNAME_COUNTER_LEN,
-			  atomic_inc_return(&cifs_tmpcounter));
+		/* Append tmpfile name to @path */
+		namelen = scnprintf(name, namesize, CIFS_TMPNAME_PREFIX "%x",
+				    atomic_inc_return(&cifs_tmpcounter));
 		rc = __cifs_do_create(dir, dentry, path, xid, tlink, oflags,
 				      mode, &oplock, &fid, NULL, &inode);
 		if (!rc) {
+			rc = d_mark_tmpfile_name(file, &QSTR_LEN(name, namelen));
+			if (rc) {
+				cifs_dbg(VFS | ONCE, "%s: failed to set filename in dentry: %d\n",
+					 __func__, rc);
+				rc = -EISDIR;
+				iput(inode);
+				goto err_open;
+			}
 			set_nlink(inode, 0);
 			mark_inode_dirty(inode);
-			d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
 			d_instantiate(dentry, inode);
 			break;
 		}
@@ -1168,9 +1175,7 @@ char *cifs_silly_fullpath(struct dentry *dentry)
 
 	do {
 		dput(sdentry);
-		scnprintf(name, namesize,
-			  CIFS_SILLYNAME_PREFIX "%0*x",
-			  CIFS_SILLYNAME_COUNTER_LEN,
+		scnprintf(name, namesize, CIFS_SILLYNAME_PREFIX "%x",
 			  atomic_inc_return(&cifs_sillycounter));
 		sdentry = lookup_noperm(&QSTR(name), dentry->d_parent);
 		if (IS_ERR(sdentry))
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f60819dcfebd..c5bd5a74baba 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -264,7 +264,7 @@ extern void d_invalidate(struct dentry *);
 extern struct dentry * d_make_root(struct inode *);
 
 extern void d_mark_tmpfile(struct file *, struct inode *);
-void d_mark_tmpfile_name(struct file *file, const struct qstr *name);
+int d_mark_tmpfile_name(struct file *file, const struct qstr *name);
 extern void d_tmpfile(struct file *, struct inode *);
 
 extern struct dentry *d_find_alias(struct inode *);
-- 
2.53.0

