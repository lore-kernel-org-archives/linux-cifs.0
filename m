Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705963112DA
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232175; cv=none; b=DkZDXeMf5+k6YxVH6eozZn5Z5xJ2UJScCk3HgDs6YLAgJnAGWlnJItAlCdkRVOewOKUQusXl8gYaXkTXJ12lJbTIMvETqaUqf7q0GmymMwvcMksaTPwCNhkUKPPck5fMYdHYHx/r9FacAHQbpaRtNYxPC+/y5kmWwtvO87NqSno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232175; c=relaxed/simple;
	bh=92zOcPSmL7cfJ+fBNAv2Fli6PKboYOamBJBcyUqCQXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbmrmmjM6RwrqL+eVRcENVmvR9Ayvvn7PuXzWGSyD/QctCN5vyKWibIX/konZ+5cEzY5Ljv2FRX24eUDVMTqon9V9cdhnXu6X0o4K2N0ROzPd1PIDws68Yokm6SNyY6J3aGqSvSwRmNeoFkhlDST14NRZgN8jl1qM18b0aRMeQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a4dgrO6a; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4dgrO6a"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c6c57c5c07so209265ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232173; x=1782836973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khSwSzWPJab5HMfpSdGK5ebxijmljVSJVgC/ryOMShs=;
        b=a4dgrO6asQCTW8pjTGxkRaEYTqbv02a8GCCs2uYLtgtCLBK+G/NZcPxnrJfzki268+
         CdYIbd82LM1Tnam3D3Jm1iLr9gczhMYAMrk9g05WXDqzczMeXaGxrvFMtskGd8tPXnc4
         lWN5+I0DxZrok6NZzpPrg3l8B05PbRuVmDZL/2H0N9SU/li1TDq/fCnaxCnvRESmQ4Fz
         1Xly86+7p2NRfyqUhMQbaJ28hQ6rJy5Mgl0egiF8+Pqji1zOKEioMqmCG9JaUzw5SW1U
         OmP8IpX5I3GFQZ1VcdcoW89+YisGfba6Fdui1MRSyNyOiPUHhp3dw6qcOmxyW3HjkA62
         knQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232173; x=1782836973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=khSwSzWPJab5HMfpSdGK5ebxijmljVSJVgC/ryOMShs=;
        b=Nb4yJAX05Ww2whPd4OjLE1GaY6Ihe+BAM97qRI9g54OWqkIQvXqYB4gJJ7QzX7uf5k
         MteplUY52pLVmpyQmL9J9/Mb9JouDloxaJ5tQBoSnj0cYxVtHEOM0KCNsLowrL3zeyMN
         djcu9sSYFYwIXiQNlIpKk/6sgOX4YZ8RCurkYnxvyxDeZ6r7pIQvBHk793nH6QCr1keS
         nhP+JUwTxWljEbr6QNsL+HQ/UiSaiugRyUiYDWy3oAG0UgxSO89MSlaSphhW6NZiTmP2
         ZpeKAkvblpFUdlO5YHdEybGOWig43KS+9myPnUHduK/9gA4/cPziJGY9gjVQLsA9kupE
         G9tw==
X-Gm-Message-State: AOJu0YwFELRedVXhjyaqpSkk0sTZ3MG0u4qLmSl4lfJQNX4Tlc4k4BXY
	PNkJ6qxfi2FRmdP3HdkkjnPz24jQT21gnTQpCjhZOB/s0Jpbk+0BnIctFZckYMu1saU=
X-Gm-Gg: AfdE7ckieu6BjZxQ3+aZel/ypRhNu+crLazj1/HYBtzKAIss1dKCrS8NhPrOiHFAXV9
	gvXgd7/2wEBpHkefxLmklmRN3OoNFJNiR5C268pjPqKWmv6K6+GyFbnPtvzCfMXwMmCLzaAbbos
	/kF1JMDGcM09otvWiKvaxVZfW0boXMzwWBwApOxb9R5coxQIA/pkUUdXX1BGJjWZP8FhqnPUqW0
	qJhikSR8WgMhigo1nt3DzbyslVP3rzXBQF3EJcwDHniMzcV+WZTR8HoLKw+9a0eF1lTpUB3IW3n
	Gz4W3ADGHA1F/hROhLUtYYXtVQ8teK7TsRseue45WDzZkz76oP3rcbSGvOiDFErJ+fA61E+AsNa
	ppz8PKvXsbyV5edJfOn+cG0dS2v6590RwY+2X14tAMih3+1Os8r1IS6ZGtiHufoFypd7QZPZ4t1
	d5k2TJM92M3d2Fid1jGLm2M+neTyL8Kw5j6EibXT+JQhg=
X-Received: by 2002:a17:903:178e:b0:2c6:a185:be8b with SMTP id d9443c01a7336-2c718ccaad3mr232337525ad.10.1782232172740;
        Tue, 23 Jun 2026 09:29:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:32 -0700 (PDT)
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
Subject: [PATCH v6 09/17] cifs: in place changes to cached_dirents when dir lease is held
Date: Tue, 23 Jun 2026 21:59:02 +0530
Message-ID: <20260623162910.343930-9-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
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
 fs/smb/client/dir.c   |  97 +++++++++++---------
 fs/smb/client/inode.c | 209 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 238 insertions(+), 68 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 4eb4d7731887b..e8d5d0aa19504 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -218,7 +218,6 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
-	bool found_parent_cfid;
 
 	*inode = NULL;
 	*oplock = 0;
@@ -348,33 +347,14 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 
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
@@ -392,6 +372,10 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
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
@@ -486,6 +470,21 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	}
 
 	*inode = newinode;
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
+	if (parent_cfid)
+		close_cached_dir(parent_cfid);
 	return rc;
 
 out_err:
@@ -493,6 +492,8 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
+	if (parent_cfid)
+		close_cached_dir(parent_cfid);
 	return rc;
 }
 
@@ -813,27 +814,35 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
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
index 51fb7c418d52a..631f5fae813b7 100644
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
+	fattr->cf_eof = netfs_read_remote_i_size(inode);
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
@@ -2518,15 +2576,18 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	     struct dentry *target_dentry, unsigned int flags)
 {
 	const char *from_name, *to_name;
+	const char *source_name, *target_name;
 	struct TCP_Server_Info *server;
 	void *page1, *page2;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	struct inode *source_inode;
 	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
+	unsigned int source_namelen, target_namelen;
 	FILE_UNIX_BASIC_INFO *info_buf_source = NULL;
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	FILE_UNIX_BASIC_INFO *info_buf_target;
@@ -2554,6 +2615,11 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
+	source_inode = d_inode(source_dentry);
+	source_name = source_dentry->d_name.name;
+	source_namelen = source_dentry->d_name.len;
+	target_name = target_dentry->d_name.name;
+	target_namelen = target_dentry->d_name.len;
 	server = tcon->ses->server;
 
 	page1 = alloc_dentry_path();
@@ -2594,6 +2660,33 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 
 	if (!rc)
 		rehash = false;
+
+	/* Update cached dirents after successful rename (before exit checks) */
+	if (!rc) {
+		struct cifs_fattr fattr;
+		struct cached_fid *target_cfid = NULL;
+
+		/* Invalidate source entry (no longer exists at old name) */
+		cifs_invalidate_cached_dirent(tcon, source_dentry->d_parent,
+					      source_name,
+					      source_namelen);
+
+		/* Upsert target entry with the renamed inode's attributes */
+		if (source_inode) {
+			cifs_inode_to_fattr(source_inode, &fattr);
+			if (!open_cached_dir_by_dentry(tcon,
+						       target_dentry->d_parent,
+						       &target_cfid)) {
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
@@ -2689,13 +2782,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	/* force revalidate to go get info when needed */
-	if (!rc) {
-		cifs_invalidate_cached_dir(tcon, source_dentry->d_parent);
-		if (target_dentry->d_parent != source_dentry->d_parent)
-			cifs_invalidate_cached_dir(tcon, target_dentry->d_parent);
-	}
-
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
@@ -2715,14 +2801,15 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
 	struct cached_fid *cfid = NULL;
+	bool retried_pending = false;
+	bool force_reval = cifs_i->time == 0;
 
 	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags) ||
 	    test_bit(CIFS_INO_TMPFILE, &cifs_i->flags))
 		return false;
-	if (cifs_i->time == 0)
-		return true;
 
 	if (CIFS_CACHE_READ(cifs_i))
 		return false;
@@ -2730,36 +2817,110 @@ cifs_dentry_needs_reval(struct dentry *dentry)
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

