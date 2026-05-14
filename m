Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E30325704
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782119; cv=none; b=nUO/KcM74LaLDeDhaZlGXZx+KES+ir9DntXj+wjGXpKymCJ/JTcFgWbPorX6c9FghxcE+FSItLAK9KU3Fy5tFB0jZxh2tUX5T9wa1MV/QeOIdyURmN5MUq3GeA577qCpdyb6Nal/X52Ie2Ys4X8j041RfWBHjo6sS1S8bXyG54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782119; c=relaxed/simple;
	bh=ZnT0grLm8W5f9rEAJIzYcRXqnBGQFbUV/XY9LWxt6eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odGhC5BvkSX3MAnMv3bSLEa1Xdw1cND8y152eDqLqnPGbKHfbGno8D4bk7T7PUggG2olV9qRh7GSjK+8jGfsF3r01HALO4xJJyDinjEatHV1WgKVRgTAuNS36ajyZiN/rtsiEOvYjJHxRaxlU3Opr4H5Aufro4raPlSOGbKKShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YivJlidx; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YivJlidx"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c798fc1a28cso3985344a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782117; x=1779386917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fI7E0lRwIilc5XQ2SPS6mbq1msNJU8wQcyK1ivrlKX4=;
        b=YivJlidxbZDjlsekeCCWnMTF532Wvi/80X19f1HA3EIq8bycOZTRdnrl1qD6KTttMN
         LCFlO0j/bVgo7WvtmvajW4IiIaVnACwDZHl0W09VwOCI+WxZa1ActOdhFnPGoJ2zFeKY
         /8DODZ2l82f3TmdfTYNbDQjE+JK+8MKTKUn35NSQJnpr9yzIDiQbzMP9vds37570l7R1
         czVXxaJYFgekaYG5CCbDlZ6NbNyUNq1rPv8ahwvOT9EUmt+z2m4lxkIwIf1Om4lIelAX
         BXudH1RB8ynP4iwOq1md2rfOUtW0IUiedyMTrqRhYwrSj6oBC/t2sFZBMZZ2ay7bfSgO
         xhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782117; x=1779386917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fI7E0lRwIilc5XQ2SPS6mbq1msNJU8wQcyK1ivrlKX4=;
        b=OHDfxqXEstxFmrE44t6jAKv5OaMajTmqG+J6cySNEBGQJcrLTpKcYW8cZE1BG1+WVM
         9ie4ZVx9/s5h7mouu2LiuGT8OCK+1igC4tk0dABuyh7dO5ceousPqVKKO5M2nnJBNrE4
         0lNF3rZL0HnUKa6ND/gdSBHj/CtC5b3hGOAWgMYMx7sXVXsJWpR2kmXl4iUxwFo99La9
         FOeYkIzxcKLQrNc1gkfEUcywRCH73A6e5GlLyWpjguLK0vrQGTDwhikwBg67R0PapdKV
         eZJkpPAQbcrbkj1NLvv5YqqSkAlvR7v2E3rQVsUMBH0U6KPteXkNcDg/vgSzbTUucxYC
         4wdA==
X-Gm-Message-State: AOJu0YxVDKgDWKT1SMLfxmhujsFUJosN3UcNW9vpzxdkj6afmiW4dN5C
	2X5ycaVsP5QENCRMbT6rYLvICuoMJVgebVDsLw6ZuvDj/PVrx9SVaKB7qAETaDoQRQ8=
X-Gm-Gg: Acq92OEwsDMxM3xvpOk69y/AG6VOCnUUMvKCG9qB+HOe/sEC9QPYzfmjSHCHl6AGSgR
	2Hub7qhwj7YQ5/4jo9Nnlq73v5p0Wi0+CF4lgrF8aZe6BElobZQ//FLswtL1dzwy1HlOR4YfXWh
	6wtiUQyLlttw3gXPj6NgeW+cqwiJ7qcOvpemd+c9pcD/oGfBUCsLafhaPVhu6nn+qj9ChcPMFcZ
	jvFmuvyI9mcXfTjFvu/UKbT/GhoyHUuGZDZb1m/BxGGmYalBoTjz1BHxUlP4q7kiyWjthkwwfKn
	OMuZNUnsQfF+2+lJ6uztLC7O751MbEgPlRpR5N/2mtvCpYx7Vn4GtlAeYhpGXvyll/hwrR8CafX
	guw5kX+OhpjQ3SLueTrEdS45VeCVvTosz6J0+A9Sz7e+hYH9zpHbz4XbzjiUY1YMumHrwLVY8IM
	5xNvgiEBelY9RgcKUcOc4qBJdtAhqNLoefTKKaO4+0Siivwqrri+hV0g==
X-Received: by 2002:a05:6a21:9982:b0:3b1:a9ce:5088 with SMTP id adf61e73a8af0-3b22ecac1f9mr308001637.31.1778782117044;
        Thu, 14 May 2026 11:08:37 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:36 -0700 (PDT)
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
Subject: [PATCH v5 05/17] cifs: reorganize cached dir helpers
Date: Thu, 14 May 2026 23:38:11 +0530
Message-ID: <20260514180823.497293-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
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
index 88d5e9a32f28b..13a197f1c35ce 100644
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
index fc756836da95a..724d57a8a5bc6 100644
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

