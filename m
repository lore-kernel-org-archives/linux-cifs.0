Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFD53BE652
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 11:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162771; cv=none; b=TT2EoQLpzZuelHvI0YPIhu9BfeEYyvd9ll0Xqc7ifIUMW1u7my9Zo2o2La1pn5xX2R79coMNFctRZnVFUEcI6RyNQ1mQv2iBe6aMXDd7gScpdJBoY0WxkcBtTTyoHeWBOeK1fUPOlcnAtXFUbipHc1B5OHP1T8gWUvfVaGQk+Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162771; c=relaxed/simple;
	bh=wn3to4HmecO3f7kNncaC3ZRIh6JTjLNcqPlqTcqTWxg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Um8LamHJRU8KRvJohRcihN29wmyQ0UjfEPq6IOH2de9IPAdk3kTW+++Vs5eF4mOl+fkbI0GqvY8kSeYtKbjhiGdylq6anaMpHbR04/Z+eUyHnCq6q6G42DldoLqiD+9/hWprlkmAv+yEXkAPQQ8Qt+0aEn5YWurA6YYisMp6tWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNrPu3cj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNrPu3cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C27B1F00893;
	Wed, 23 Sep 2026 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790162763;
	bh=MsqxLLMJOFtJoVPVJE5tkHJOL9G9gD3vWwTXVCZlLFU=;
	h=From:To:Cc:Subject:Date;
	b=KNrPu3cjHxfNX21KDrXsBSAfpnlg6j+q1eFNfNs1t0pV3shw8F7iZ1jMbWaLvDc55
	 kVOWV0XRtOaKAcEjCJE4K4XvzhEV7iDA3BOlMf40yLQHk3PNrxv6urZp4Lpry5HDke
	 nWir2oYAH16w9AIG5ApxCG1XpJJrqNI4nDbBWuDuP2SiQl8qZK1qlcrGkh/PknkIHc
	 oUtdqYN+vD++cSlizpm62lUbym/vkUP1OoS+yDviSUpQKa/Vys4MEV6iwSmkVqmuyd
	 82/Z/FIHEvfP9Ve3VrVEBH25nA8YsFBKx5k6lo1hp9nQCrsqfK+LkP9Tg1x3Bm7ENJ
	 oYeU0E5ntZFMA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: pc@manguebit.org,
	linux-cifs@vger.kernel.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	tom@talpey.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] cifs: use finish_no_open() for non-regular inodes
Date: Wed, 23 Sep 2026 20:25:49 +0900
Message-Id: <20260923112549.21294-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An O_CREAT open can find an existing symlink or another non-regular
inode. cifs_atomic_open() calls finish_open() on it and attaches a
cifsFileInfo. Symlink inodes have no CIFS release operation, so the
dentry reference held by cifsFileInfo is leaked. FMODE_OPENED also
prevents the VFS from following the symlink.

Track whether cifs_do_create() returned an open server handle. For
non-regular inodes, close the handle if present, remove the pending
open, and call finish_no_open() so the VFS can continue the lookup.
Do not set FMODE_CREATED unless a regular file was opened. For
O_NOFOLLOW with __O_REGULAR, return -ELOOP before the VFS's
-EFTYPE check.

Defer closing a legacy POSIX handle on a non-regular inode until
after inode lookup. This avoids closing it again if lookup fails.

Fixes: d2c127197dfc ("cifs: implement i_op->atomic_open()")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/dir.c | 52 +++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6fa6d48fdfd3..1a56fa4d0e89 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -199,7 +199,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 			    struct tcon_link *tlink, unsigned int oflags,
 			    umode_t mode, __u32 *oplock, struct cifs_fid *fid,
 			    struct cifs_open_info_data *buf,
-			    struct inode **inode)
+			    struct inode **inode, bool *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -216,6 +216,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	__le32 lease_flags = 0;
 
 	*inode = NULL;
+	*opened = false;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -232,6 +233,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
+			*opened = true;
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -253,11 +255,9 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 				/*
 				 * The server may allow us to open things like
 				 * FIFOs, but the client isn't set up to deal
-				 * with that. If it's not a regular file, just
-				 * close it and proceed as if it were a normal
-				 * lookup.
+				 * with that. Keep the handle until the caller
+				 * can finish the lookup.
 				 */
-				CIFSSMBClose(xid, tcon, fid->netfid);
 				goto cifs_create_get_file_info;
 			}
 			/* success, no need to query */
@@ -384,6 +384,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 		}
 		return rc;
 	}
+	*opened = true;
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(dir, FSCACHE_INVAL_DIO_WRITE);
 
@@ -475,7 +476,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	return rc;
 
 out_err:
-	if (server->ops->close)
+	if (*opened && server->ops->close)
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
@@ -487,7 +488,7 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 			  unsigned int oflags, umode_t mode,
 			  __u32 *oplock, struct cifs_fid *fid,
 			  struct cifs_open_info_data *buf,
-			  struct inode **inode)
+			  struct inode **inode, bool *opened)
 {
 	void *page = alloc_dentry_path();
 	const char *full_path;
@@ -496,10 +497,11 @@ static int cifs_do_create(struct inode *dir, struct dentry *direntry,
 	full_path = build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
 		rc = PTR_ERR(full_path);
+		*opened = false;
 	} else {
 		rc = __cifs_do_create(dir, direntry, full_path, xid,
 				      tlink, oflags, mode, oplock,
-				      fid, buf, inode);
+				      fid, buf, inode, opened);
 	}
 	free_dentry_path(page);
 	return rc;
@@ -529,6 +531,8 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
+	bool is_regular;
+	bool opened;
 	int rc;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
@@ -581,12 +585,26 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 	cifs_add_pending_open(&fid, tlink, &open);
 
 	rc = cifs_do_create(dir, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &buf, &inode);
+			    &oplock, &fid, &buf, &inode, &opened);
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
+	is_regular = S_ISREG(inode->i_mode);
+	if (!is_regular || !opened) {
+		if (opened && server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+		if (S_ISLNK(inode->i_mode) &&
+		    (oflags & (O_NOFOLLOW | __O_REGULAR)) ==
+		    (O_NOFOLLOW | __O_REGULAR) && !(oflags & O_EXCL)) {
+			iput(inode);
+			rc = -ELOOP;
+			goto out;
+		}
+	}
+
 	if (d_in_lookup(direntry)) {
 		alias = d_splice_alias(inode, direntry);
 		if (!IS_ERR_OR_NULL(alias))
@@ -595,9 +613,15 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 		d_instantiate(direntry, inode);
 	}
 
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	if (is_regular && opened &&
+	    (oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		file->f_mode |= FMODE_CREATED;
 
+	if (!is_regular || !opened) {
+		rc = finish_no_open(file, NULL);
+		goto out;
+	}
+
 	rc = finish_open(file, direntry, generic_file_open);
 	if (rc) {
 		if (server->ops->close)
@@ -660,6 +684,7 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	struct cifs_fid fid;
 	__u32 oplock;
+	bool opened;
 	struct cifs_open_info_data buf = {};
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
@@ -682,10 +707,10 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
 		server->ops->new_lease_key(&fid);
 
 	rc = cifs_do_create(dir, direntry, xid, tlink, oflags,
-			    mode, &oplock, &fid, &buf, &inode);
+			    mode, &oplock, &fid, &buf, &inode, &opened);
 	if (!rc) {
 		d_instantiate(direntry, inode);
-		if (server->ops->close)
+		if (opened && server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 	}
 
@@ -1078,6 +1103,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	unsigned int xid;
 	__u32 oplock;
+	bool opened;
 	int namelen;
 	int rc;
 
@@ -1116,7 +1142,7 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 		namelen = scnprintf(name, namesize, CIFS_TMPNAME_PREFIX "%x",
 				    atomic_inc_return(&cifs_tmpcounter));
 		rc = __cifs_do_create(dir, dentry, path, xid, tlink, oflags,
-				      mode, &oplock, &fid, NULL, &inode);
+				      mode, &oplock, &fid, NULL, &inode, &opened);
 		if (!rc) {
 			rc = d_mark_tmpfile_name(file, &QSTR_LEN(name, namelen));
 			if (rc) {
-- 
2.25.1

