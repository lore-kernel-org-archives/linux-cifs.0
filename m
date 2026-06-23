Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D713790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246034; cv=none; b=X8hDqh46gQVGxPY9oU1AFv/wltspmN84Y7PDEonNFKBZij29Okx6fQO8FPIay4/d5ZQo+iufDgBfu8r5hXRPMsew6OQgI4QisD8ahA1pfevCXofwXJPblQrw7SFPluRND9hBH8GFTJRC/Mv+OfBbEiEx5fRJnodXnH0A2WndVlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246034; c=relaxed/simple;
	bh=6w5MpISGcf8YvC9+UDfFwqN5nN0JSEpDpB8FsVleia8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ula094/lCxNvPvFQosSEHeiAjKklgPjt5+0JQKiX1bne1J109X2vAjm1NRrwTLCSwqxdiD9/V+flcb8M148al/+ZnRATvMIP/rZal58r5c/U+xt5cTbHkRlRZb4ZM2VTouHWlfSpLOf5DK7Ofr2atRhHe/Sw3m3SIGUhxOFN6jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCItw0rH; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCItw0rH"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69eb8b6bea8so147165eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246031; x=1782850831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPowKD9C8kSUeR1yN7IBAFHNLSc7nAt6HRJh+sKqLUk=;
        b=fCItw0rHxF2Vhow0Xc5jfQ+GEfdXcwPlSLjQu2wr2RH9EulgjA/xcMN2Ua3WRZU7VS
         xMTlKA8kE/fr5/L4pK+IWyPcRdduDAoyPxE9xAANnL7BNhG+ZA6Kp7lXok9sh5oXPXWm
         WPddRd0aD//T+Solx2tehgpZFxCibW2EDxqHGWiOCn8kEWESynCgm84FfZ5YmkqhP/fi
         RpAKMyKelEdzosXasRQ4eVXnVz3Z8/P6sr5eHVJIp/dZqsTqO5ZKg+gLq/4HI1m5BxnO
         1pp5Gvtny/gMQwpbxJRwrBYpVZGXDSZ9dz2dLBWESmbmsfjddPFGl0s3mbYPwfVkkmeR
         32Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246031; x=1782850831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xPowKD9C8kSUeR1yN7IBAFHNLSc7nAt6HRJh+sKqLUk=;
        b=hwkgm+3Lx75OujX2TuRT3fWnFCTYT2sALTu8ZMxX0hS5duxr4a/AmvUKLhXJHK9k1q
         538aRe+C8TewfPVFwSh4gCQ3v6NjPTrglzx1psPPcisAFLAMwgsSInnDcaqIMxlgTRKt
         J5c0SFEHu+IAUgnNZmcC/VS+8RiG2lW6AmaIOYtbZykjTGNP6dwY2GcQSCOTChr793Ss
         iyfINBjUUUI9Z5g9OONap7+LceoQ2XCicfZkSJPiRy8gnza029yl5kRONd4gXbtoQmI0
         cnUnEMkTr2Hmp33xoyzbqI4qeIf65USbDMfRYX8EG2uvd8fxJ6uMCF85R1cMfSwq8tjj
         KNEw==
X-Gm-Message-State: AOJu0YyNpBmtl2j64VM4PQSnkggHNsz5EXyLGy6efSyJiclaGRTdXK9N
	Ad2qkzvCuXTnbWVEIYpyHtZLiDjt/9I2ttGd0N3nC+FwR5Cms0DGZOmeKukcWFfr
X-Gm-Gg: AfdE7cmaKch1zsWI1CSQCoD7wllBbVlOXLJy8wS348hmF+kA1DJBPp/A0KEltvx89jx
	IidctImVkXhhtxvNjMNNuSz5aHvTJW7i+21fkCye8hqgEYCWw7w9WtmIqI/WgQkYCOUFlfV2fEv
	woJnUSYYgJmdee2w90PrmG1H+LyQC2r6va3lE+eKocUoPd90EuNVqGXC21NHZYwVJBT4xxqlqhi
	uRWpKexiOKtrE+eDwXPOSkDCEw/mZNqx5tKPEjW3g0Lcx6KN3N+GUPMjXUdLgfkgMi7jpMhmrLc
	1lZ4Ub+Wl/thWRaTM/ESdCqlMczDJUUuQcWL76oXSuEEmcaU2FV9kTeLmEhsNU74hSqgxn6/h7G
	xXR6k2uD5nLTAvCYHkMNR9jOA/EjWrPjQB+j9cDmzp3iyjP/+WAI3OJZQ665SP1yNO1usreMn73
	LXb5BTDHeehKttA/ZIbhRQAjf+Apdr+IH5BJ8I7PyM3QGE3x+L6/3ZzTZKdEbOQOvWYmg8wRnrP
	szYqiZyolfqWAIKJjZcss7RR8HxkjyQWwdCYpDxCz+eRwYu3nBK97fVbc9GR19KTARXZtMV1EAF
	eA+3Ej9LjCEvz4cRvNxWokqQ/Yk=
X-Received: by 2002:a05:6820:6acf:b0:69e:3563:4424 with SMTP id 006d021491bc7-6a122f47d29mr196954eaf.24.1782246031471;
        Tue, 23 Jun 2026 13:20:31 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:31 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 04/16] cifs: reorganize cached dir helpers
Date: Tue, 23 Jun 2026 15:13:31 -0500
Message-ID: <20260623201344.2043841-4-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
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
index 88d5e9a32f28..13a197f1c35c 100644
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
index fc756836da95..724d57a8a5bc 100644
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
index 71cf9379703c..d463dc057f80 100644
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
2.53.0

