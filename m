Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F344BC9F
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392508; cv=none; b=lqTPlcDhK/t0FKxiu1Fq76Sq690qgZl9acs4fTEnjZHscSmlwGKfnZDMSs0Vph9UHjzaGF0HucInbbJGrtVbzmLtzn+89jIeaEy0lZ4+Ssel/4XbN1xTZNV0xapUvvb9NvgCA+WTZ1VDRdPaa+O/q1JauivlVjkhFY0W+c/mQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392508; c=relaxed/simple;
	bh=yQDGUugMgmyKUZ0z5Lq2sQESbHDF2/K5IdaSCxIi0YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHTCdNvdbnQwKAXkNl2L0Mg4iJC/mEzbD21a/YuwAjTuMkfnIoaSUL8OZUMaivJpnuwtmE7jXMBbYj5/csTqzsGJev/Kvak5fd4KJiNqNA1qqT4twIvQJaNxRGRAloQIdwDKwPt6unlsAg2C0DpL9Ayemr3P5JpspH4+EmDiBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlRbwtIl; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlRbwtIl"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso10323844a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392506; x=1777997306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXcR03k3xJhfx1FDqTSaR+BYNjaTbVzhTjZ49oxLsl0=;
        b=AlRbwtIlgrtILp+H+58nXRLKNoRozj1/H5v5NgAT9WhNGTtTlQUmTL3AjzMmWj8X1x
         dnCysvTgEIT0/ay1fYnnoE9RwPT+/lXqxrs+QK/q8D76pUhBbDz59Trr11g2LRj33za5
         URXOz2T8ko3ZLGIWeuFV/57xZcxmVPfb8vNLJgWo5Er7e4EYO6KDWF0w1sggLioFPnSz
         LI+bbZaAoyqe5yw0bbiT42Z0lfHug8nabnIp/G98a7qn7pY5I/Rad3e0K0UxqKjNGMEI
         iNo61pMiCqsZFOx5Dl41iOJneS391QESsh7R2zSflMj6Ll4HWfNG4863DCtlplDovHry
         UmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392506; x=1777997306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IXcR03k3xJhfx1FDqTSaR+BYNjaTbVzhTjZ49oxLsl0=;
        b=lCeTQVkbdArLzH/WzcKlm63HEuhyGQgYyfI8GsegPbxD7zlBsA2Ux4deL92QYdFuro
         nDKpS77D3Fr+BJC71hM7gcIvv64BPXeUwEnozcm0WxSB4k1xZHfrigwNA++vV7bE/llQ
         4s3iCos0KE6ptJ5Vbs3pxlI4y48al/6FdTtNi+Gv2DXWTrhsgOo51xpoYPGp6vi28nS1
         31MFR4R8d1wvXjaWsfSOhCAsfDYaVufYhQ5Ib40q+R1By7Cu5wqamptgNTdHEAHENknz
         jLYaGiFLWDXI6cCtfkCWob4StkYY2vc4FpxfPdlsMKNm95OinlWMBql/kefdrkpKROYr
         ibzg==
X-Gm-Message-State: AOJu0YwBLPWj+4bFIhLNfGyUMZhYlXCYMZcKozZtYzKzHlCd1L08kfJY
	CZq2Ns7nesNoMuAzcGvMRVqLYC1EW3SnNN2h53qgfuCHm2i97sS3xW7k0btymCmT4Fw=
X-Gm-Gg: AeBDiesSyNwZvNT1GJ6t8dVMW7hsewnJ4XInaEaw/KMhEnjYUNciJhuNt+viQcqhZlu
	1b6xGTMPf6mok7FK9ZHJxVXi3ovz0Bo8anV4JLAVBjxvjofxwVJmI+2wf3Qqo7h3/o0qnH5vLSn
	tdReOPX4ZG2epQjMx7O0GtHwQlFmkk5J7QZZULrvBTJH7aadA4tNKz02IBg6YuCruBpALKniAFM
	S1MM8uNKZ9jZe16JgTJMuFHCUTZ0uHramtA7c8WDzaWCpYp3j1n3XFnQUeZ3WucM0aI7sTAzf4f
	Hu5ydjD+aeH6rYCEGBEAiTNIDYkogDLGlMOzFzQcXFIvps2bJp8CFB/FfQ4v1N/vT7yx6/VHpwk
	B5TVPivUgP5wavHJuKa3JTxwi4nOFpUI0umyc7IThyZ6JTipMX8dCuEs1IgnpXRKyOdYFQ/ahlw
	B9Ywhkc4A5wobpQ3aLyE0MaNGU82xpyzgBkvQ0p/1Ig6+4rsjHVP26q9ZCrx3C1yWr
X-Received: by 2002:a17:90a:e18c:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-364921bf8famr4240779a91.23.1777392505648;
        Tue, 28 Apr 2026 09:08:25 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:25 -0700 (PDT)
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
Subject: [PATCH v3 07/19] cifs: reorganize cached dir helpers
Date: Tue, 28 Apr 2026 21:37:52 +0530
Message-ID: <20260428160804.281745-7-sprasad@microsoft.com>
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

Currently, we have helper functions for cfid and dirent caching spread
across cached_dir.c and readdir.c, with de_mutex locking done inside
the calling functions. This change neatly wraps them in helper functions
and keeps all such functions in cached_dir.c.

This code also splits the logic of dirent emit into cache and to VFS into
different functions.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 207 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/cached_dir.h |  18 +++-
 fs/smb/client/readdir.c    | 167 ++----------------------------
 3 files changed, 231 insertions(+), 161 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 64e22c064fa0a..a9bc0c81868c8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -23,6 +23,213 @@ struct cached_dir_dentry {
 	struct dentry *dentry;
 };
 
+static bool emit_cached_dirents(struct cached_dirents *cde,
+				struct dir_context *ctx)
+{
+	struct cached_dirent *dirent;
+	bool rc;
+
+	lockdep_assert_held(&cde->de_mutex);
+
+	list_for_each_entry(dirent, &cde->entries, entry) {
+		/*
+		 * Skip all early entries prior to the current lseek()
+		 * position.
+		 */
+		if (ctx->pos > dirent->pos)
+			continue;
+		/*
+		 * We recorded the current ->pos value for the dirent
+		 * when we stored it in the cache.
+		 * However, this sequence of ->pos values may have holes
+		 * in it, for example dot-dirs returned from the server
+		 * are suppressed.
+		 * Handle this by forcing ctx->pos to be the same as the
+		 * ->pos of the current dirent we emit from the cache.
+		 * This means that when we emit these entries from the cache
+		 * we now emit them with the same ->pos value as in the
+		 * initial scan.
+		 */
+		ctx->pos = dirent->pos;
+		rc = dir_emit(ctx, dirent->name, dirent->namelen,
+			      dirent->fattr.cf_uniqueid,
+			      dirent->fattr.cf_dtype);
+		if (!rc)
+			return rc;
+		ctx->pos++;
+	}
+	return true;
+}
+
+static bool add_cached_dirent(struct cached_dirents *cde,
+			      struct dir_context *ctx, const char *name,
+			      int namelen, struct cifs_fattr *fattr,
+			      struct file *file)
+{
+	struct cached_dirent *de;
+
+	lockdep_assert_held(&cde->de_mutex);
+
+	if (cde->file != file)
+		return false;
+	if (cde->is_valid || cde->is_failed)
+		return false;
+	if (ctx->pos != cde->pos) {
+		cde->is_failed = 1;
+		return false;
+	}
+	de = kzalloc_obj(*de, GFP_KERNEL);
+	if (de == NULL) {
+		cde->is_failed = 1;
+		return false;
+	}
+	de->namelen = namelen;
+	de->name = kstrndup(name, namelen, GFP_KERNEL);
+	if (de->name == NULL) {
+		kfree(de);
+		cde->is_failed = 1;
+		return false;
+	}
+	de->pos = ctx->pos;
+
+	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
+
+	list_add_tail(&de->entry, &cde->entries);
+	/* update accounting */
+	cde->entries_count++;
+	cde->bytes_used += sizeof(*de) + (size_t)namelen + 1;
+	return true;
+}
+
+bool emit_cached_dir_if_valid(struct cached_fid *cfid,
+			      struct file *file,
+			      struct dir_context *ctx)
+{
+	if (!cfid)
+		return false;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	/*
+	 * If this was reading from the start of the directory
+	 * we need to initialize scanning and storing the
+	 * directory content.
+	 */
+	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
+		cfid->dirents.file = file;
+		cfid->dirents.pos = 2;
+	}
+
+	if (!cfid->dirents.is_valid) {
+		mutex_unlock(&cfid->dirents.de_mutex);
+		return false;
+	}
+
+	if (dir_emit_dots(file, ctx))
+		emit_cached_dirents(&cfid->dirents, ctx);
+
+	mutex_unlock(&cfid->dirents.de_mutex);
+	return true;
+}
+
+bool add_to_cached_dir(struct cached_fid *cfid,
+		       struct dir_context *ctx,
+		       const char *name,
+		       int namelen,
+		       struct cifs_fattr *fattr,
+		       struct file *file)
+{
+	size_t delta_bytes;
+	bool added = false;
+
+	if (!cfid)
+		return false;
+
+	/* Cost of this entry */
+	delta_bytes = sizeof(struct cached_dirent) + (size_t)namelen + 1;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	added = add_cached_dirent(&cfid->dirents, ctx, name, namelen,
+				  fattr, file);
+	mutex_unlock(&cfid->dirents.de_mutex);
+
+	if (added) {
+		/* per-tcon then global for consistency with free path */
+		atomic64_add((long long)delta_bytes, &cfid->cfids->total_dirents_bytes);
+		atomic_long_inc(&cfid->cfids->total_dirents_entries);
+		atomic64_add((long long)delta_bytes, &cifs_dircache_bytes_used);
+	}
+
+	return added;
+}
+
+static void update_cached_dirents_count(struct cached_dirents *cde,
+					struct file *file)
+{
+	if (cde->file != file)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+
+	cde->pos++;
+}
+
+static void finished_cached_dirents_count(struct cached_dirents *cde,
+					  struct dir_context *ctx,
+					  struct file *file)
+{
+	if (cde->file != file)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+	if (ctx->pos != cde->pos)
+		return;
+
+	cde->is_valid = 1;
+}
+
+void update_pos_cached_dir(struct cached_fid *cfid,
+				      struct file *file)
+{
+	if (!cfid)
+		return;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	update_cached_dirents_count(&cfid->dirents, file);
+	mutex_unlock(&cfid->dirents.de_mutex);
+}
+
+void complete_cached_dir(struct cached_fid *cfid,
+					struct dir_context *ctx,
+					struct file *file)
+{
+	if (!cfid)
+		return;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	finished_cached_dirents_count(&cfid->dirents, ctx, file);
+	mutex_unlock(&cfid->dirents.de_mutex);
+}
+
+struct cached_dirent *lookup_cached_dirent(struct cached_dirents *cde,
+				   const char *name,
+				   unsigned int namelen)
+{
+	struct cached_dirent *entry;
+
+	if (!cde)
+		return NULL;
+
+	lockdep_assert_held(&cde->de_mutex);
+
+	list_for_each_entry(entry, &cde->entries, entry) {
+		if (entry->namelen == namelen &&
+		    memcmp(entry->name, name, namelen) == 0)
+			return entry;
+	}
+
+	return NULL;
+}
+
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
 						    bool lookup_only,
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 19d5592512e4b..09f1f488059c9 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,7 +8,6 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
-
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
@@ -87,6 +86,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
 int open_cached_dir_by_dentry(struct cifs_tcon *tcon, struct dentry *dentry,
 			      struct cached_fid **ret_cfid);
 void close_cached_dir(struct cached_fid *cfid);
+bool emit_cached_dir_if_valid(struct cached_fid *cfid,
+			      struct file *file,
+			      struct dir_context *ctx);
+bool add_to_cached_dir(struct cached_fid *cfid,
+		       struct dir_context *ctx,
+		       const char *name,
+		       int namelen,
+		       struct cifs_fattr *fattr,
+		       struct file *file);
+void update_pos_cached_dir(struct cached_fid *cfid,
+				      struct file *file);
+void complete_cached_dir(struct cached_fid *cfid,
+					struct dir_context *ctx,
+					struct file *file);
+struct cached_dirent *lookup_cached_dirent(struct cached_dirents *cde,
+				   const char *name,
+				   unsigned int namelen);
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 8a444f97e0ae9..907e235ad1b8f 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -817,136 +817,13 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 	return rc;
 }
 
-static bool emit_cached_dirents(struct cached_dirents *cde,
-				struct dir_context *ctx)
-{
-	struct cached_dirent *dirent;
-	bool rc;
-
-	list_for_each_entry(dirent, &cde->entries, entry) {
-		/*
-		 * Skip all early entries prior to the current lseek()
-		 * position.
-		 */
-		if (ctx->pos > dirent->pos)
-			continue;
-		/*
-		 * We recorded the current ->pos value for the dirent
-		 * when we stored it in the cache.
-		 * However, this sequence of ->pos values may have holes
-		 * in it, for example dot-dirs returned from the server
-		 * are suppressed.
-		 * Handle this by forcing ctx->pos to be the same as the
-		 * ->pos of the current dirent we emit from the cache.
-		 * This means that when we emit these entries from the cache
-		 * we now emit them with the same ->pos value as in the
-		 * initial scan.
-		 */
-		ctx->pos = dirent->pos;
-		rc = dir_emit(ctx, dirent->name, dirent->namelen,
-			      dirent->fattr.cf_uniqueid,
-			      dirent->fattr.cf_dtype);
-		if (!rc)
-			return rc;
-		ctx->pos++;
-	}
-	return true;
-}
-
-static void update_cached_dirents_count(struct cached_dirents *cde,
-					struct file *file)
-{
-	if (cde->file != file)
-		return;
-	if (cde->is_valid || cde->is_failed)
-		return;
-
-	cde->pos++;
-}
-
-static void finished_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx, struct file *file)
-{
-	if (cde->file != file)
-		return;
-	if (cde->is_valid || cde->is_failed)
-		return;
-	if (ctx->pos != cde->pos)
-		return;
-
-	cde->is_valid = 1;
-}
-
-static bool add_cached_dirent(struct cached_dirents *cde,
-			      struct dir_context *ctx, const char *name,
-			      int namelen, struct cifs_fattr *fattr,
-			      struct file *file)
-{
-	struct cached_dirent *de;
-
-	if (cde->file != file)
-		return false;
-	if (cde->is_valid || cde->is_failed)
-		return false;
-	if (ctx->pos != cde->pos) {
-		cde->is_failed = 1;
-		return false;
-	}
-	de = kzalloc_obj(*de, GFP_ATOMIC);
-	if (de == NULL) {
-		cde->is_failed = 1;
-		return false;
-	}
-	de->namelen = namelen;
-	de->name = kstrndup(name, namelen, GFP_ATOMIC);
-	if (de->name == NULL) {
-		kfree(de);
-		cde->is_failed = 1;
-		return false;
-	}
-	de->pos = ctx->pos;
-
-	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
-
-	list_add_tail(&de->entry, &cde->entries);
-	/* update accounting */
-	cde->entries_count++;
-	cde->bytes_used += sizeof(*de) + (size_t)namelen + 1;
-	return true;
-}
-
 static bool cifs_dir_emit(struct dir_context *ctx,
 			  const char *name, int namelen,
-			  struct cifs_fattr *fattr,
-			  struct cached_fid *cfid,
-			  struct file *file)
+			  struct cifs_fattr *fattr)
 {
-	size_t delta_bytes = 0;
-	bool rc, added = false;
 	ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
 
-	rc = dir_emit(ctx, name, namelen, ino, fattr->cf_dtype);
-	if (!rc)
-		return rc;
-
-	if (cfid) {
-		/* Cost of this entry */
-		delta_bytes = sizeof(struct cached_dirent) + (size_t)namelen + 1;
-
-		mutex_lock(&cfid->dirents.de_mutex);
-		added = add_cached_dirent(&cfid->dirents, ctx, name, namelen,
-					  fattr, file);
-		mutex_unlock(&cfid->dirents.de_mutex);
-
-		if (added) {
-			/* per-tcon then global for consistency with free path */
-			atomic64_add((long long)delta_bytes, &cfid->cfids->total_dirents_bytes);
-			atomic_long_inc(&cfid->cfids->total_dirents_entries);
-			atomic64_add((long long)delta_bytes, &cifs_dircache_bytes_used);
-		}
-	}
-
-	return rc;
+	return dir_emit(ctx, name, namelen, ino, fattr->cf_dtype);
 }
 
 static int cifs_filldir(char *find_entry, struct file *file,
@@ -1040,10 +917,10 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		 */
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
+	add_to_cached_dir(cfid, ctx, name.name, name.len, &fattr, file);
 	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
-	return !cifs_dir_emit(ctx, name.name, name.len,
-			      &fattr, cfid, file);
+	return !cifs_dir_emit(ctx, name.name, name.len, &fattr);
 }
 
 
@@ -1088,30 +965,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	if (rc)
 		goto cache_not_found;
 
-	mutex_lock(&cfid->dirents.de_mutex);
-	/*
-	 * If this was reading from the start of the directory
-	 * we need to initialize scanning and storing the
-	 * directory content.
-	 */
-	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
-		cfid->dirents.file = file;
-		cfid->dirents.pos = 2;
-	}
-	/*
-	 * If we already have the entire directory cached then
-	 * we can just serve the cache.
-	 */
-	if (cfid->dirents.is_valid) {
-		if (!dir_emit_dots(file, ctx)) {
-			mutex_unlock(&cfid->dirents.de_mutex);
-			goto rddir2_exit;
-		}
-		emit_cached_dirents(&cfid->dirents, ctx);
-		mutex_unlock(&cfid->dirents.de_mutex);
+	if (emit_cached_dir_if_valid(cfid, file, ctx))
 		goto rddir2_exit;
-	}
-	mutex_unlock(&cfid->dirents.de_mutex);
 
 	/* Drop the cache while calling initiate_cifs_search and
 	 * find_cifs_entry in case there will be reconnects during
@@ -1161,11 +1016,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	} else if (current_entry != NULL) {
 		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
 	} else {
-		if (cfid) {
-			mutex_lock(&cfid->dirents.de_mutex);
-			finished_cached_dirents_count(&cfid->dirents, ctx, file);
-			mutex_unlock(&cfid->dirents.de_mutex);
-		}
+		complete_cached_dir(cfid, ctx, file);
 		cifs_dbg(FYI, "Could not find entry\n");
 		goto rddir2_exit;
 	}
@@ -1202,11 +1053,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		ctx->pos++;
-		if (cfid) {
-			mutex_lock(&cfid->dirents.de_mutex);
-			update_cached_dirents_count(&cfid->dirents, file);
-			mutex_unlock(&cfid->dirents.de_mutex);
-		}
+		update_pos_cached_dir(cfid, file);
 
 		if (ctx->pos ==
 			cifsFile->srch_inf.index_of_last_entry) {
-- 
2.43.0

