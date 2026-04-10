Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A9578F4F;
	Fri, 10 Apr 2026 23:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775863261; cv=none; b=gum/5uhSv7EXfVSUnMh6mjPfu4YQJr5irUaMO2CHDel4gjHHcLeJoh1SH/lTust6AMKNcPLqFbdp3LF8wnNY0BbZwukA78GeU936Z0LJT8hGceBIWm0Q4930i0AqZG0jGwh+Mr7Gty9t43Y+buKE6XeaYP2sn8xsK/cJfwNM/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775863261; c=relaxed/simple;
	bh=xLYMJsZb9IzyVX8l8/n9T3eevmN2NNElKg+5QWW6LjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ScNahaThFuZ+kkU+0JXm02VML8GM8o8GVDGjEZuhzGAc9cDsVWG1QCJ4H9irHi2kftR88d+CTD+VeAx1zk8VU+EvJUb6gggEy3vad3vpcTCVfcO8o9xfKtKcXQzG/Qhd3KPAEc3Ny0MHHPZOX8Lr5l/m0fyviWJZaO+40Y9dpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=IDFZeIu8; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="IDFZeIu8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pxwfcnC1ooZ01QHTltFOb/7v1rFhrgwsQWkVgNQtSxM=; b=IDFZeIu8u1O5uINakARi2UE7Lw
	XhtIsWqEKqnTOCWCMk7t9YNLPV8t9tkYWyPvajtQYhFXhjC0G13NAbYo5LGeUHG+OZq4tcylv4n23
	2Omolsb3rX/EXLusypZ+BQNdcxfpXWZkAo8rbUdFbaJp+2xaN0UuD0fcrnKCPwOoWSedOc2oVy8NT
	i0cVvlK6wS0gwJnXAhlUJ5bRUxZIjWSYRd3bqcb9Iy/wjws8hs1TfLJ/rbUPX+dFzotSmeivmjbb/
	2hY8Tk25GPFzBwitETQo0Tl9jeRZRYpgieI9TSMWG+vQJBR88CaD4e/33iT+I7H6KDSI5tcpQVasm
	bHcsKa6Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wBL9k-00000002aTc-0MMA;
	Fri, 10 Apr 2026 20:20:56 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	NeilBrown <neilb@ownmail.net>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: get rid of d_drop()+d_add()
Date: Fri, 10 Apr 2026 20:20:55 -0300
Message-ID: <20260410232055.1582463-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace d_drop()+d_add() in cifs_tmpfile() and cifs_create() with
d_instantiate(), and in cifs_atomic_open() with d_splice_alias() if
in-lookup, otherwise d_instantiate().

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/r/20260408065719.GF3836593@ZenIV
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: NeilBrown <neilb@ownmail.net>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsfs.h |  4 +--
 fs/smb/client/dir.c    | 62 ++++++++++++++++++++++++++----------------
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 64c7a4c6ac83..18f9f93a01b4 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -52,9 +52,9 @@ void cifs_sb_deactive(struct super_block *sb);
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 struct inode *cifs_root_iget(struct super_block *sb);
-int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
+int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *direntry, umode_t mode, bool excl);
-int cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 		     struct file *file, unsigned int oflags, umode_t mode);
 int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 		 struct file *file, umode_t mode);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index bfc887d506b6..6ea1ae7f7a46 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -219,6 +219,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
 
+	*inode = NULL;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -462,7 +463,6 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 		goto out_err;
 	}
 
-	d_drop(direntry);
 	*inode = newinode;
 	return rc;
 
@@ -478,11 +478,11 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 			  unsigned int xid, struct tcon_link *tlink,
 			  unsigned int oflags, umode_t mode,
 			  __u32 *oplock, struct cifs_fid *fid,
-			  struct cifs_open_info_data *buf)
+			  struct cifs_open_info_data *buf,
+			  struct inode **inode)
 {
 	void *page = alloc_dentry_path();
 	const char *full_path;
-	struct inode *inode;
 	int rc;
 
 	full_path = build_path_from_dentry(direntry, page);
@@ -491,9 +491,7 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 	} else {
 		rc = __cifs_do_create(dir, direntry, full_path, xid,
 				      tlink, oflags, mode, oplock,
-				      fid, buf, &inode);
-		if (!rc)
-			d_add(direntry, inode);
+				      fid, buf, inode);
 	}
 	free_dentry_path(page);
 	return rc;
@@ -504,13 +502,13 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
  * Look up, create and open a CIFS file.
  *
  * The initial dentry state is in-lookup or hashed-negative.  On success, dentry
- * will become hashed-positive by calling d_drop() & d_add(), respectively.
+ * will become hashed-positive by calling d_splice_alias() if in-lookup,
+ * otherwise d_instantiate().
  */
-int
-cifs_atomic_open(struct inode *inode, struct dentry *direntry,
-		 struct file *file, unsigned int oflags, umode_t mode)
+int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
+		     struct file *file, unsigned int oflags, umode_t mode)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
 	struct cifs_open_info_data buf = {};
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *file_info;
@@ -519,6 +517,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	unsigned int sbflags;
+	struct dentry *alias;
+	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
 	int rc;
@@ -545,13 +545,13 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		if (!d_in_lookup(direntry))
 			return -ENOENT;
 
-		return finish_no_open(file, cifs_lookup(inode, direntry, 0));
+		return finish_no_open(file, cifs_lookup(dir, direntry, 0));
 	}
 
 	xid = get_xid();
 
 	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-		 inode, direntry, direntry);
+		 dir, direntry, direntry);
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
@@ -572,13 +572,21 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	cifs_add_pending_open(&fid, tlink, &open);
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &buf);
+	rc = cifs_do_create(dir, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fid, &buf, &inode);
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
+	if (d_in_lookup(direntry)) {
+		alias = d_splice_alias(inode, direntry);
+		if (!IS_ERR_OR_NULL(alias))
+			direntry = alias;
+	} else {
+		d_instantiate(direntry, inode);
+	}
+
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		file->f_mode |= FMODE_CREATED;
 
@@ -622,11 +630,12 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
  * Create a CIFS file.
  *
  * The initial dentry state is hashed-negative.  On success, dentry will become
- * hashed-positive by calling d_drop() & d_add(), respectively.
+ * hashed-positive by calling d_instantiate().
  */
-int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
+int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *direntry, umode_t mode, bool excl)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
 	int rc;
 	unsigned int xid = get_xid();
 	/*
@@ -640,19 +649,20 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
+	struct inode *inode;
 	struct cifs_fid fid;
 	__u32 oplock;
 	struct cifs_open_info_data buf = {};
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-		 inode, direntry, direntry);
+		 dir, direntry, direntry);
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
+	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
 		rc = smb_EIO(smb_eio_trace_forced_shutdown);
 		goto out_free_xid;
 	}
 
-	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	tlink = cifs_sb_tlink(cifs_sb);
 	rc = PTR_ERR(tlink);
 	if (IS_ERR(tlink))
 		goto out_free_xid;
@@ -663,9 +673,13 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
 	if (server->ops->new_lease_key)
 		server->ops->new_lease_key(&fid);
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode, &oplock, &fid, &buf);
-	if (!rc && server->ops->close)
-		server->ops->close(xid, tcon, &fid);
+	rc = cifs_do_create(dir, direntry, xid, tlink, oflags,
+			    mode, &oplock, &fid, &buf, &inode);
+	if (!rc) {
+		d_instantiate(direntry, inode);
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+	}
 
 	cifs_free_open_info(&buf);
 	cifs_put_tlink(tlink);
@@ -1035,7 +1049,7 @@ static int set_tmpfile_attr(const unsigned int xid, unsigned int oflags,
  * Create a hidden temporary CIFS file with delete-on-close bit set.
  *
  * The initial dentry state is unhashed-negative.  On success, dentry will
- * become unhashed-positive by calling d_drop() & d_instantiate(), respectively.
+ * become unhashed-positive by calling d_instantiate().
  */
 int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 		 struct file *file, umode_t mode)
-- 
2.53.0

