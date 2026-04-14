Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B303E6DF4
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175178; cv=none; b=Gr3+SYE6hFFXvv/Mt4sN09V0bjerzyjctI9HKt1NZhMSi4jGxUOqrt4nHcYdPgk555jmJdDHY9z9q2Z8TlTPBJwi0aYDqiWNnOhssK4xCxK1v+pgfasFFVLJH+NDFvr6FkdZ8hlDq//aDt8wUJWFlfDFgFRsK2Iqe1G/aduYGx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175178; c=relaxed/simple;
	bh=YZ4iElVEnXDZYySVO3VBpfGCVaSUyJl4g2ffVrW1WgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnzd2yBgr4oz3hSEA6t0bImtAGQIUwuP8Ctb7fitANIaaT4CxdqLHjckUCrhoHx/pehS06xSZWY48N61dSb/jGPO1l1pYCE7+vi/1GsjwsJh7H3FXubUY90kAywfiVvnQntNWTw92kDBKozZXFLCoAdOet3lH47EP6+y/XXKFo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeXuIgd+; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeXuIgd+"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad9f316d68so24907925ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175176; x=1776779976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENAAh/1O3MhaZu/Z65n/crtkMvLMA8Mtex6JNce8d08=;
        b=aeXuIgd+IzPKMm4yGkNqg3z0ujg0cpjdWHQQqoPnFV3zfJXNjuPu7kraww01E5/bwQ
         GvKfwzh6yRW0XqDuQWKUkLWnEpcTt9T1vR6XugNr2kIMtEm3OHyyodojqGNJLChRwSXe
         CDhlq2rvPk5iMGjGPkqsYsWvfhGbpHp+H5VhI0uUp8vy5eEz565N1JpSepYt2kE8X6UM
         auJ2UZH1fF91HFJY9cIUFZNGv1Hlzt8gARgDsi4sjsU4QuNsJoE0aVNzj+oIYPZP8qlI
         RE3vzXiimC7dHtIth+NHmDIpC6Zu8BCWqelkIs7dz0Yua3FMIuaK3NALb1LJoOvGugK5
         XQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175176; x=1776779976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ENAAh/1O3MhaZu/Z65n/crtkMvLMA8Mtex6JNce8d08=;
        b=QkSzij4OtTNHW5PzM+B4ccVgKZju+l//42FRmW/v6nbnbK/osbuTJtqIxNwET4xfLo
         0BPbzJ7HdWAsWhJiVl0TehXvwPFcJz/l98lwztCL5zZEfncktTOqFmyUI9NsMaFatWAK
         wpZAqgg4XeBiRF/gwAG3Orom6BrtvefYQNemFUrliFN/ponzwFGSNCTofgE+qXtF+HGQ
         LukbBZ00XJ8yWcObXLmGd2U+EWJiq1bKphgPLYZX72OyHjykGUVbY/tk4PfA3e/Ec7oS
         /2/mdEdr6S/qV44kFDx4NdCXYHRoXMMUbznYzl0qwlBFq8SPwFwer3tWfT1UyR9crIOa
         6q2Q==
X-Gm-Message-State: AOJu0Ywwyr1WSAndym1T/8yQoImAu1/r5J+lsv3Xsf3Ghj1Xq1UHA+Lt
	BvIwe1IUO3bltuZK8TKVkKVoZPvgfYDdfFu9281yPjmDrbnFwVauuUEIVzo+RpyJQcA=
X-Gm-Gg: AeBDietPaQuZEVicv+gfxB8NeRfEW3SQlDeeB+IjaHz92mFxDx+IAwD4mDxKVi3QD6S
	Y1QaySPphSuinqBbtuxbpvHcImNQtpH6wNT4kuTU3g21zJyAX8M09xDBsrDsu+BvaAWfjQ8sTuU
	+L0E3779EVtxovDCI5uAwnPeJkPfIBQNF3BsK/eVacp8M/oal3fK9BN+ShoEyvEcPnsMrsiWWJk
	/VtbC9IRN0/oHRMrdJWvyvYVQw10x9cKaljLj1apc5Agcdl/z6MdwBLyTZEqa9OW62k+BB1/iCc
	GImqpv5KG4DXJCB635pjG/3INRaeBGyQhRZPUdCKD8rHvqe9AGe23722DcJWcoS0OB8WOsLhPOd
	EHeENfzq1OkG7wP62dLdOCiZy2PM4redYTce/UQPavNPKfWGBE27nOpHAZuO8A0sfIQxjmvQsU3
	ibCeK4EZ/AMPQPRQ4Q3jP+lYvfrlF9yRWhRa7xpBfzXqzWJA1wOcBwPQXlHZQlq94=
X-Received: by 2002:a17:903:1a43:b0:2b0:ccad:de1a with SMTP id d9443c01a7336-2b2d5a2c035mr174646825ad.30.1776175175961;
        Tue, 14 Apr 2026 06:59:35 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:35 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 7/7] cifs: reorganize cached dir helpers
Date: Tue, 14 Apr 2026 19:29:18 +0530
Message-ID: <20260414135918.279802-7-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414135918.279802-1-sprasad@microsoft.com>
References: <20260414135918.279802-1-sprasad@microsoft.com>
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
index e9917e5204b00..10fe703d353d1 100644
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

