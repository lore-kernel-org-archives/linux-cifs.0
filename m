Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9999544BCB6
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392512; cv=none; b=RvxZFe0vtS94WL+qcWpv2tPdzFb2SkW9eSNen5/vb0a11yBijwKD76OEjvVVBEQ4469WYpBLipBOOLJDTGFqAaO6V+ZO2Ffnr3TnAmSR5eFZyAZ8WFG3TQH2Oni99RHR6YtTgJXc5QixqgDLLmGfwsUbUWIpbIAMqbaGwIjWKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392512; c=relaxed/simple;
	bh=laxYPRxQNROn/mCB1U8uJ/z9GQXx1ybMlhRi45bFu9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhS6OXluhS+0Lw1pSks9dpqmtkVnBMi91Hn7UEfaYJhjDPrscJhAMDkMGJA/AoEanD1RgJd+bAGqSjWWo5J9RUG3ZeXAewcuSwH5dkMg0dzpif8oLr8xn2FB1xWk/Vym4HClIaLmWqKze9bdWYy0zJBFjgMkjigpc2BNdEkWF28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ln/BoTA4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ln/BoTA4"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b23fcf90b2so110901735ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392509; x=1777997309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhpjoDjQGZevd2W9AU4bA1KVcZ73s6bijGKBV20qyws=;
        b=Ln/BoTA4OpepPSTCn0hS7FAe1CcWBSWBiO+jGTTq0AtdvGv/3v2/hcXGsxCS+skhdD
         WNsJKLDtbPXFQVbkT/hqrB1sRv5oGcx0rrQjRuTpeKwiYEE2claiWqKYU3WTRAmd3H1u
         G2hxAXalE2Re2+xBqE+JbVZMZX4I+He8KghiwbGUqA0RLCN2tA+2lloh+cpHi7+QVO2n
         8BleHQc8RDoXQRsQHEJfJ1rywQKPsV8ofR3QOX0biL+NUA1QnBdTQA1eTNLS6+qJCdO7
         OnpZtsPfe6LjTxLvKHFnVw2N2i9OatwlL7CKwUClME4UPq6zcFvu1jLfhgt7QgoxwIgD
         3eDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392509; x=1777997309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UhpjoDjQGZevd2W9AU4bA1KVcZ73s6bijGKBV20qyws=;
        b=Fhsr/DsLjxU21bllLwFbWMQ5OEIm8c1vercAeH9gcqTZJqLc4lTcw92hcJRbHWr8qx
         3UtmEmqBOoWLrZ2PdxgkbLRSKeo/khSfDG8kfnGhe3KSseBt7OI+fIUAjMW5Z7f5dWP7
         wboWsDdvNll3dBPwBHGeuMOHOcctxoWZkQO5qBG8Y6+1xBpcex+sQ5prxaWCvKtgCHGm
         FYBy/5LE45aLnDR6yv8d3w1QDQvzwLhJnUOrlbUVMyJFAmiNiH2uL1JB9bG1rifcQHZh
         bNPMSZuBqg/f2tQ95jTax1/LvMU9/9ZTpU+HFiou3Ox/7+ASFpiSoDZG1gZ23dSn5WMI
         XQgw==
X-Gm-Message-State: AOJu0YyHiqoDIQ9UR3ygU4SZzWe5nuMS8Kn6XjIRWrK2wp+XiwTlwO4u
	PAbaPerrZjT1HY23nIDYmJp2Y3nzdVd/jll7xo0+FcmRNF/00gnzSemZOAqWPMDB5GE=
X-Gm-Gg: AeBDiesWbrUtdCs6mSeYJLJcDvQJkc31Wnw61ZEUuq5OXbDO8QZT+DMTVqgCvpaD/uL
	JEY9sfYzTlm1LOeWxZ+lIEFpiLBCJM34kYc2N8T+teCWOUDgT05kpOs3DUr16hkRfODp+66d5ro
	0mEjD/CgmI/Y/ocqHFZ49KQMYfU8JHflM2x22jy26iKVgw5P9+w5m6VlyV39AlqaNl9gbw+OeYp
	aazfLLGC2T9N6okDfVh3VEft3ZEOfvasRGqy0WRWhq+VEO1A/lmvtSTfFzY7jcXEY2qbSH0TSMd
	cNsD3pDePWVUgWxBcs13Q4yLrbAKW5bnirWjqIr3gwr5tH5nRkPgjO57K/ykwiYcUAqTdIKcEbg
	bCuzTFzguju/Y2nHuzYZMgwbIVE8E4jJaHo2Mw+L7v8RwJCNcaG98YpcULCvc2Lw+ndXZDVlnpZ
	jab5wnpODx/XzL/wCIYdeCaFiMEO3u2xklqKD19f8ZOLXENFlfr+GpS6qz2eqY2n7lDiteAxDFr
	0w=
X-Received: by 2002:a17:903:1103:b0:2b2:4029:d781 with SMTP id d9443c01a7336-2b97c46201bmr40245435ad.20.1777392509493;
        Tue, 28 Apr 2026 09:08:29 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:29 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 11/19] cifs: in place changes to cached_dirents when dir lease is held
Date: Tue, 28 Apr 2026 21:37:56 +0530
Message-ID: <20260428160804.281745-11-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When a directory lease is held, we do not need to invalidate the
dirent cache on the cfid when new dentries are added.

This change allows local adds to directory contents to be made
in the cached_dirents so that we don't need to fetch again from server.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/dir.c   |  95 ++++++++++---------
 fs/smb/client/inode.c | 207 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 234 insertions(+), 68 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 4e5c580e4de0a..092fff1ad02a2 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -194,7 +194,6 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
-	bool found_parent_cfid;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -320,33 +319,14 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 
 retry_open:
 	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
-		found_parent_cfid = false;
 		parent_cfid = NULL;
-		spin_lock(&tcon->cfids->cfid_list_lock);
-		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
-			spin_lock(&parent_cfid->cfid_lock);
-			if (parent_cfid->dentry == direntry->d_parent) {
-				kref_get(&parent_cfid->refcount);
-				spin_unlock(&parent_cfid->cfid_lock);
-				spin_unlock(&tcon->cfids->cfid_list_lock);
-				found_parent_cfid = true;
-				cifs_dbg(FYI, "found a parent cached file handle\n");
-				if (cached_dir_copy_lease_key(parent_cfid,
-						      fid->parent_lease_key)) {
-					lease_flags
-						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-					mutex_lock(&parent_cfid->dirents.de_mutex);
-					parent_cfid->dirents.is_valid = false;
-					parent_cfid->dirents.is_failed = true;
-					mutex_unlock(&parent_cfid->dirents.de_mutex);
-				}
-				close_cached_dir(parent_cfid);
-				break;
-			}
-			spin_unlock(&parent_cfid->cfid_lock);
+		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent,
+					      &parent_cfid)) {
+			cifs_dbg(FYI, "found a parent cached file handle\n");
+			if (cached_dir_copy_lease_key(parent_cfid,
+					      fid->parent_lease_key))
+				lease_flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
 		}
-		if (!found_parent_cfid)
-			spin_unlock(&tcon->cfids->cfid_list_lock);
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -364,6 +344,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
 		if (rc == -EACCES && rdwr_for_fscache == 1) {
+			if (parent_cfid) {
+				close_cached_dir(parent_cfid);
+				parent_cfid = NULL;
+			}
 			desired_access &= ~GENERIC_READ;
 			rdwr_for_fscache = 2;
 			goto retry_open;
@@ -452,10 +436,25 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 			goto out_err;
 		}
 
+	if (newinode && parent_cfid) {
+		struct cifs_fattr fattr;
+		bool cache_updated;
+
+		cifs_inode_to_fattr(newinode, &fattr);
+		cache_updated = update_dirent_in_cached_dir(parent_cfid,
+						    direntry->d_name.name,
+						    direntry->d_name.len,
+						    &fattr);
+		if (!cache_updated)
+			invalidate_cached_dir_contents(parent_cfid);
+	}
+
 	d_drop(direntry);
 	d_add(direntry, newinode);
 
 out:
+	if (parent_cfid)
+		close_cached_dir(parent_cfid);
 	free_dentry_path(page);
 	return rc;
 
@@ -732,27 +731,35 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 		cifs_dbg(FYI, "NULL inode in lookup\n");
 
-		/*
-		 * We can only rely on negative dentries having the same
-		 * spelling as the cached dirent if case insensitivity is
-		 * forced on mount.
-		 *
-		 * XXX: if servers correctly announce Case Sensitivity Search
-		 * on GetInfo of FileFSAttributeInformation, then we can take
-		 * correct action even if case insensitive is not forced on
-		 * mount.
-		 */
-		if (pTcon->nocase && !open_cached_dir_by_dentry(pTcon, direntry->d_parent, &cfid)) {
+		if (!open_cached_dir_by_dentry(pTcon, direntry->d_parent, &cfid)) {
+			struct qstr qname = QSTR_INIT(direntry->d_name.name, direntry->d_name.len);
+			struct cached_dirent_lookup_result lookup = {};
+			int rc_lookup;
+			int rc_wait;
+
+			rc_wait = cifs_wait_for_pending_dcache(cfid, qname.name, qname.len);
+			if (rc_wait == -ETIMEDOUT)
+				cifs_dbg(FYI, "Wait for pending dcache entry timed out\n");
+
+			rc_lookup = lookup_cached_dir(cfid, qname.name,
+							       qname.len, &lookup);
+			if (!rc_lookup && lookup.found && lookup.under_active_lease) {
+				newInode = cifs_iget(parent_dir_inode->i_sb, &lookup.fattr);
+				close_cached_dir(cfid);
+				if (!newInode) {
+					de = ERR_PTR(-ENOMEM);
+					goto free_dentry_path;
+				}
+				rc = 0;
+				renew_parental_timestamps(direntry);
+				goto out;
+			}
+
 			/*
 			 * dentry is negative and parent is fully cached:
-			 * we can assume file does not exist
+			 * we can assume file does not exist if case sensitive
 			 */
-			bool dirents_valid;
-
-			mutex_lock(&cfid->dirents.de_mutex);
-			dirents_valid = cfid->dirents.is_valid;
-			mutex_unlock(&cfid->dirents.de_mutex);
-			if (dirents_valid) {
+			if (pTcon->nocase && cfid->dirents.is_valid) {
 				close_cached_dir(cfid);
 				goto out;
 			}
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index e077df844c819..f03371abcfef9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -28,19 +28,18 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
-static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
-				       struct dentry *parent)
+static void cifs_invalidate_cached_dirent(struct cifs_tcon *tcon,
+						 struct dentry *parent,
+						 const char *name,
+						 unsigned int namelen)
 {
 	struct cached_fid *parent_cfid = NULL;
 
-	if (!tcon || !parent)
+	if (!tcon || !parent || !name || !namelen)
 		return;
 
 	if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
-		mutex_lock(&parent_cfid->dirents.de_mutex);
-		parent_cfid->dirents.is_valid = false;
-		parent_cfid->dirents.is_failed = true;
-		mutex_unlock(&parent_cfid->dirents.de_mutex);
+		invalidate_dirent_in_cached_dir(parent_cfid, name, namelen);
 		close_cached_dir(parent_cfid);
 	}
 }
@@ -177,6 +176,28 @@ cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	set_nlink(inode, fattr->cf_nlink);
 }
 
+void cifs_inode_to_fattr(struct inode *inode, struct cifs_fattr *fattr)
+{
+	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
+
+	memset(fattr, 0, sizeof(*fattr));
+	fattr->cf_cifsattrs = cifs_i->cifsAttrs;
+	fattr->cf_uniqueid = cifs_i->uniqueid;
+	fattr->cf_eof = cifs_i->netfs.remote_i_size;
+	fattr->cf_bytes = (u64)inode->i_blocks << 9;
+	fattr->cf_createtime = cifs_i->createtime;
+	fattr->cf_uid = inode->i_uid;
+	fattr->cf_gid = inode->i_gid;
+	fattr->cf_mode = inode->i_mode;
+	fattr->cf_rdev = inode->i_rdev;
+	fattr->cf_nlink = inode->i_nlink;
+	fattr->cf_dtype = S_DT(inode->i_mode);
+	fattr->cf_atime = inode_get_atime(inode);
+	fattr->cf_mtime = inode_get_mtime(inode);
+	fattr->cf_ctime = inode_get_ctime(inode);
+	fattr->cf_cifstag = cifs_i->reparse_tag;
+}
+
 /* populate an inode with info from a cifs_fattr struct */
 int
 cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
@@ -1169,6 +1190,24 @@ static inline bool is_inode_cache_good(struct inode *ino)
 	return ino && CIFS_CACHE_READ(CIFS_I(ino)) && CIFS_I(ino)->time != 0;
 }
 
+static bool cifs_inode_has_writable_handle(struct inode *inode)
+{
+	struct cifsInodeInfo *cifs_inode = CIFS_I(inode);
+	struct cifsFileInfo *open_file;
+	bool writable = false;
+
+	spin_lock(&cifs_inode->open_file_lock);
+	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
+		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
+			writable = true;
+			break;
+		}
+	}
+	spin_unlock(&cifs_inode->open_file_lock);
+
+	return writable;
+}
+
 static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 				 struct super_block *sb,
 				 const unsigned int xid,
@@ -2085,7 +2124,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 
 out_reval:
 	if (!rc && dentry->d_parent)
-		cifs_invalidate_cached_dir(tcon, dentry->d_parent);
+		cifs_invalidate_cached_dirent(tcon, dentry->d_parent,
+							    dentry->d_name.name,
+							    dentry->d_name.len);
 
 	if (inode) {
 		cifs_inode = CIFS_I(inode);
@@ -2276,6 +2317,7 @@ struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 	int rc = 0;
 	unsigned int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct cached_fid *parent_cfid = NULL;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
@@ -2337,12 +2379,26 @@ struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 	/* TODO: skip this for smb2/smb3 */
 	rc = cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb, tcon,
 			      xid);
+	if (!rc && d_inode(direntry) && direntry->d_parent &&
+	    server->dialect >= SMB30_PROT_ID &&
+	    !open_cached_dir_by_dentry(tcon, direntry->d_parent, &parent_cfid)) {
+		struct cifs_fattr fattr;
+
+		cifs_inode_to_fattr(d_inode(direntry), &fattr);
+		if (!update_dirent_in_cached_dir(parent_cfid,
+						  direntry->d_name.name,
+						  direntry->d_name.len,
+						  &fattr))
+			invalidate_cached_dir_contents(parent_cfid);
+	}
 mkdir_out:
 	/*
 	 * Force revalidate to get parent dir info when needed since cached
 	 * attributes are invalid now.
 	 */
 	CIFS_I(inode)->time = 0;
+	if (parent_cfid)
+		close_cached_dir(parent_cfid);
 	free_dentry_path(page);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
@@ -2408,7 +2464,9 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 		clear_nlink(d_inode(direntry));
 		spin_unlock(&d_inode(direntry)->i_lock);
 		if (direntry->d_parent)
-			cifs_invalidate_cached_dir(tcon, direntry->d_parent);
+			cifs_invalidate_cached_dirent(tcon, direntry->d_parent,
+							    direntry->d_name.name,
+							    direntry->d_name.len);
 	}
 
 	/* force revalidate to go get info when needed */
@@ -2518,6 +2576,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	     struct dentry *target_dentry, unsigned int flags)
 {
 	const char *from_name, *to_name;
+	const char *source_name, *target_name;
 	struct TCP_Server_Info *server;
 	void *page1, *page2;
 	struct cifs_sb_info *cifs_sb;
@@ -2525,10 +2584,12 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_tcon *tcon;
 	struct dentry *source_parent;
 	struct dentry *target_parent;
+	struct inode *source_inode;
 	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
+	unsigned int source_namelen, target_namelen;
 	FILE_UNIX_BASIC_INFO *info_buf_source = NULL;
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	FILE_UNIX_BASIC_INFO *info_buf_target;
@@ -2556,6 +2617,11 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	source_inode = d_inode(source_dentry);
+	source_name = source_dentry->d_name.name;
+	source_namelen = source_dentry->d_name.len;
+	target_name = target_dentry->d_name.name;
+	target_namelen = target_dentry->d_name.len;
 	source_parent = source_dentry->d_parent ? dget(source_dentry->d_parent) : NULL;
 	target_parent = target_dentry->d_parent ? dget(target_dentry->d_parent) : NULL;
 	server = tcon->ses->server;
@@ -2598,6 +2664,31 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 
 	if (!rc)
 		rehash = false;
+
+	/* Update cached dirents after successful rename (before exit checks) */
+	if (!rc) {
+		struct cifs_fattr fattr;
+		struct cached_fid *target_cfid = NULL;
+
+		/* Invalidate source entry (no longer exists at old name) */
+		cifs_invalidate_cached_dirent(tcon, source_parent,
+					      source_name,
+					      source_namelen);
+
+		/* Upsert target entry with the renamed inode's attributes */
+		if (source_inode && target_parent) {
+			cifs_inode_to_fattr(source_inode, &fattr);
+			if (!open_cached_dir_by_dentry(tcon, target_parent, &target_cfid)) {
+				if (!update_dirent_in_cached_dir(target_cfid,
+								  target_name,
+								  target_namelen,
+								  &fattr))
+					invalidate_cached_dir_contents(target_cfid);
+				close_cached_dir(target_cfid);
+			}
+		}
+	}
+
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2693,13 +2784,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	/* force revalidate to go get info when needed */
-	if (!rc) {
-		cifs_invalidate_cached_dir(tcon, source_parent);
-		if (target_parent != source_parent)
-			cifs_invalidate_cached_dir(tcon, target_parent);
-	}
-
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
@@ -2723,13 +2807,14 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
 	struct cached_fid *cfid = NULL;
+	bool retried_pending = false;
+	bool force_reval = cifs_i->time == 0;
 
 	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags))
 		return false;
-	if (cifs_i->time == 0)
-		return true;
 
 	if (CIFS_CACHE_READ(cifs_i))
 		return false;
@@ -2737,36 +2822,110 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return true;
+	tcon = tlink_tcon(tlink);
+
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
 		if (cifs_i->time > cfid->time) {
 			close_cached_dir(cfid);
+			cifs_put_tlink(tlink);
 			return false;
 		}
 		close_cached_dir(cfid);
 	}
+
+	if (dentry->d_parent) {
+		struct cached_dirent_lookup_result lookup = {};
+		int rc;
+		int rc_wait;
+
+	retry_lookup:
+		cfid = NULL;
+		if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
+			rc = lookup_cached_dir(cfid, dentry->d_name.name,
+							  dentry->d_name.len,
+							  &lookup);
+			if (rc == -ENOENT && !retried_pending) {
+				rc_wait = cifs_wait_for_pending_dcache(cfid,
+							     dentry->d_name.name,
+							     dentry->d_name.len);
+				if (rc_wait == -ETIMEDOUT)
+					cifs_dbg(FYI,
+						 "Timed out waiting for async dcache population of %pd\n",
+						 dentry);
+				else if (!rc_wait) {
+					close_cached_dir(cfid);
+					retried_pending = true;
+					goto retry_lookup;
+				}
+			}
+			close_cached_dir(cfid);
+			if (!rc && lookup.found && lookup.under_active_lease) {
+				if (cifs_inode_has_writable_handle(inode)) {
+					cifs_set_time(dentry, jiffies);
+					cifs_put_tlink(tlink);
+					return false;
+				}
+				rc = cifs_fattr_to_inode(inode, &lookup.fattr, false);
+				if (!rc) {
+					cifs_set_time(dentry, jiffies);
+					cifs_put_tlink(tlink);
+					return false;
+				}
+				if (rc != -ESTALE) {
+					cifs_put_tlink(tlink);
+					return true;
+				}
+			}
+		}
+	}
+
+	/*
+	 * Even when metadata is marked stale (time == 0), attempt the
+	 * cached-dir fast path above first; only force wire revalidation if
+	 * cache lookup/update did not satisfy this dentry.
+	 */
+	if (force_reval) {
+		cifs_put_tlink(tlink);
+		return true;
+	}
+
 	/*
 	 * depending on inode type, check if attribute caching disabled for
 	 * files or directories
 	 */
 	if (S_ISDIR(inode->i_mode)) {
-		if (!cifs_sb->ctx->acdirmax)
+		if (!cifs_sb->ctx->acdirmax) {
+			cifs_put_tlink(tlink);
 			return true;
+		}
 		if (!time_in_range(jiffies, cifs_i->time,
-				   cifs_i->time + cifs_sb->ctx->acdirmax))
+				   cifs_i->time + cifs_sb->ctx->acdirmax)) {
+			cifs_put_tlink(tlink);
 			return true;
+		}
 	} else { /* file */
-		if (!cifs_sb->ctx->acregmax)
+		if (!cifs_sb->ctx->acregmax) {
+			cifs_put_tlink(tlink);
 			return true;
+		}
 		if (!time_in_range(jiffies, cifs_i->time,
-				   cifs_i->time + cifs_sb->ctx->acregmax))
+				   cifs_i->time + cifs_sb->ctx->acregmax)) {
+			cifs_put_tlink(tlink);
 			return true;
+		}
 	}
 
 	/* hardlinked files w/ noserverino get "special" treatment */
 	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) &&
-	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
+	    S_ISREG(inode->i_mode) && inode->i_nlink != 1) {
+		cifs_put_tlink(tlink);
 		return true;
+	}
 
+	cifs_put_tlink(tlink);
 	return false;
 }
 
-- 
2.43.0

