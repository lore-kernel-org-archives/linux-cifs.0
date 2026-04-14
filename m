Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8B42BEC2E;
	Tue, 14 Apr 2026 04:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776141595; cv=none; b=ppyKJ2+qfdhFRP0F32l62gko72NrUw5+xIIbafFq5bE02i++TdGth2k847LL83E9rWhaqK6Dq4Dmq+wQ247cn31QLpTscF/50v6ohuXXJygNjVvCVty7xdd6M2YPXjs5kMharcKQ0fodk6yYbwjto2olBAkXYMjzxDWn+yLBc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776141595; c=relaxed/simple;
	bh=3I11mppRQVAtR9NKpJkZml88D6trLMBNwHinDFvW0A4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=OFJFV8dagT0OmMXBMZ5WrYiB3DmcKjwHFZdjYsRL6hGE6LlFlTih1h24GFomSW52iv8+mrliDnKIlXwQVykpl9OnD8CX54M6hmjnDfjThIgRwL/X0bHD2yUmSaYskdoUtE/ICOk5Wph5SnXQFqcDamRVZ8Npu6ZQLc18OijlC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=WGK79bBI; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="WGK79bBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZD1lVsqAnuFJQwRVQZ03zmrBbHsS6i9f43BJZMGscqA=; b=WGK79bBIHmt7iCM8bHpDVloWCr
	q+TSkf5zvB7zG3FOh7mgIjZ9eZ28/QiJa0eErjXIxnJJbTQYf2QJW+sYVHci0Szl86SPl0NKycL+E
	nkosoyK3kwzualSDH2HJSIA7djWBZitGExuZq9W31/X4NfZnhcz4V2lhNSMphKbzgXHnaO3yDd6n9
	q7Fab9XfeysA+Th9YOrdIc3YDaGijyAipex25bPe2nEsAT5l1tQfrJTlsJqlMFaO7zmjMHL/BsrX9
	0s6obDADYCzgpRGhqx9o1JtyUiy7DJx6UicA15i0zRBi0Nggti/CiHXUK8+gtgjpCGw0onsRcA/1N
	X5eYP2bw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wCVZ0-000000007wF-2jRj;
	Tue, 14 Apr 2026 01:39:50 -0300
Message-ID: <44bed253083c84d4dafa9ad1c069f3a9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [GIT PULL] smb3 client fixes
In-Reply-To: <CAHk-=wjTfaTPf+Vp=XGmW1z9YPZcx8dhPjaGfhfYett9=-jHMA@mail.gmail.com>
References: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
 <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com>
 <ab9457074b5852e73e84f0209bb58279@manguebit.org>
 <CAHk-=wjTfaTPf+Vp=XGmW1z9YPZcx8dhPjaGfhfYett9=-jHMA@mail.gmail.com>
Date: Tue, 14 Apr 2026 01:39:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Thanks for the review, Linus.

What about below changes now?

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
index 6ea1ae7f7a46..07b9d2369787 100644
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
@@ -1103,16 +1104,24 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 
 	name = path + strlen(path);
 	do {
-		scnprintf(name, size,
-			  CIFS_TMPNAME_PREFIX "%0*x",
-			  CIFS_TMPNAME_COUNTER_LEN,
-			  atomic_inc_return(&cifs_tmpcounter));
+		/* Append tmpfile name to @path */
+		namelen = scnprintf(name, namesize,
+				    CIFS_TMPNAME_PREFIX "%0*x",
+				    (int)sizeof(cifs_tmpcounter) * 2,
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
@@ -1170,7 +1179,7 @@ char *cifs_silly_fullpath(struct dentry *dentry)
 		dput(sdentry);
 		scnprintf(name, namesize,
 			  CIFS_SILLYNAME_PREFIX "%0*x",
-			  CIFS_SILLYNAME_COUNTER_LEN,
+			  (int)sizeof(cifs_sillycounter) * 2,
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
