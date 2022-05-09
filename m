Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76C7C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiEIXs3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiEIXro (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A250D26BC9B
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652139751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwYbIfcABg2xIQfbCNrXeZI70aSfhM0z6TEW/9khnzQ=;
        b=bNvbAmMM+WkjanV++aTmU6gMuzISNvxBJMQRUWB/25KQNt/Ifgb3dKjSOby0zBKgmLrTKP
        nXT4p9iw1XTLEjlOl6OgaooPTXldZEtNMxC8i/FgN6c/3HulPGYHnga489iTEFIoUohzon
        XyrBtnVX0KxYoGk/n9EgqvFZ+bDnT0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-rMOLnUYJNiW1CtqdqaPeog-1; Mon, 09 May 2022 19:42:28 -0400
X-MC-Unique: rMOLnUYJNiW1CtqdqaPeog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0964D811E76;
        Mon,  9 May 2022 23:42:28 +0000 (UTC)
Received: from thinkpad (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E8102166B2F;
        Mon,  9 May 2022 23:42:26 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 4/4] cifs: cache the dirents for entries in a cached directory
Date:   Tue, 10 May 2022 09:42:07 +1000
Message-Id: <20220509234207.2469586-5-lsahlber@redhat.com>
In-Reply-To: <20220509234207.2469586-1-lsahlber@redhat.com>
References: <20220509234207.2469586-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This adds caching of the directory entries for a cached directory while we keep
a lease on the directory.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h |  22 ++++++
 fs/cifs/misc.c     |   2 +
 fs/cifs/readdir.c  | 181 +++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2ops.c  |  16 ++++
 4 files changed, 213 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f2eeabb189a2..4ec6a3df17fa 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1040,6 +1040,27 @@ struct cifs_fattr {
 	u32             cf_cifstag;
 };
 
+struct cached_dirent {
+	struct list_head entry;
+	char *name;
+	int namelen;
+	loff_t pos;
+
+	struct cifs_fattr fattr;
+};
+
+struct cached_dirents {
+	bool is_valid:1;
+	bool is_failed:1;
+	struct dir_context *ctx; /*
+				  * Only used to make sure we only take entries
+				  * from a single context. Never dereferenced.
+				  */
+	struct mutex de_mutex;
+	int pos;		 /* Expected ctx->pos */
+	struct list_head entries;
+};
+
 struct cached_fid {
 	bool is_valid:1;	/* Do we have a useable root fid */
 	bool file_all_info_is_valid:1;
@@ -1052,6 +1073,7 @@ struct cached_fid {
 	struct dentry *dentry;
 	struct work_struct lease_break;
 	struct smb2_file_all_info file_all_info;
+	struct cached_dirents dirents;
 };
 
 /*
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index afaf59c22193..7fef08add3bc 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -114,6 +114,8 @@ tconInfoAlloc(void)
 		kfree(ret_buf);
 		return NULL;
 	}
+	INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
+	mutex_init(&ret_buf->crfid.dirents.de_mutex);
 
 	atomic_inc(&tconInfoAllocCount);
 	ret_buf->status = TID_NEW;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 1929e80c09ee..e71c7b3941b4 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -840,9 +840,109 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 	return rc;
 }
 
+static bool emit_cached_dirents(struct cached_dirents *cde,
+				struct dir_context *ctx)
+{
+	struct cached_dirent *dirent;
+	int rc;
+
+	list_for_each_entry(dirent, &cde->entries, entry) {
+		if (ctx->pos >= dirent->pos)
+			continue;
+		ctx->pos = dirent->pos;
+		rc = dir_emit(ctx, dirent->name, dirent->namelen,
+			      dirent->fattr.cf_uniqueid,
+			      dirent->fattr.cf_dtype);
+		if (!rc)
+			return rc;
+	}
+	return true;
+}
+
+static void update_cached_dirents_count(struct cached_dirents *cde,
+					struct dir_context *ctx)
+{
+	if (cde->ctx != ctx)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+
+	cde->pos++;
+}
+
+static void finished_cached_dirents_count(struct cached_dirents *cde,
+					struct dir_context *ctx)
+{
+	if (cde->ctx != ctx)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+	if (ctx->pos != cde->pos)
+		return;
+
+	cde->is_valid = 1;
+}
+
+static void add_cached_dirent(struct cached_dirents *cde,
+			      struct dir_context *ctx,
+			      const char *name, int namelen,
+			      struct cifs_fattr *fattr)
+{
+	struct cached_dirent *de;
+
+	if (cde->ctx != ctx)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+	if (ctx->pos != cde->pos) {
+		cde->is_failed = 1;
+		return;
+	}
+	de = kzalloc(sizeof(*de), GFP_ATOMIC);
+	if (de == NULL) {
+		cde->is_failed = 1;
+		return;
+	}
+	de->namelen = namelen;
+	de->name = kstrndup(name, namelen, GFP_ATOMIC);
+	if (de->name == NULL) {
+		kfree(de);
+		cde->is_failed = 1;
+		return;
+	}
+	de->pos = ctx->pos;
+
+	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
+
+	list_add_tail(&de->entry, &cde->entries);
+}
+
+static bool cifs_dir_emit(struct dir_context *ctx,
+			  const char *name, int namelen,
+			  struct cifs_fattr *fattr,
+			  struct cached_fid *cfid)
+{
+	bool rc;
+	ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
+
+	rc = dir_emit(ctx, name, namelen, ino, fattr->cf_dtype);
+	if (!rc)
+		return rc;
+
+	if (cfid) {
+		mutex_lock(&cfid->dirents.de_mutex);
+		add_cached_dirent(&cfid->dirents, ctx, name, namelen,
+				  fattr);
+		mutex_unlock(&cfid->dirents.de_mutex);
+	}
+
+	return rc;
+}
+
 static int cifs_filldir(char *find_entry, struct file *file,
-		struct dir_context *ctx,
-		char *scratch_buf, unsigned int max_len)
+			struct dir_context *ctx,
+			char *scratch_buf, unsigned int max_len,
+			struct cached_fid *cfid)
 {
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -851,7 +951,6 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	struct cifs_fattr fattr;
 	struct qstr name;
 	int rc = 0;
-	ino_t ino;
 
 	rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
 			      file_info->srch_inf.unicode);
@@ -931,8 +1030,8 @@ static int cifs_filldir(char *find_entry, struct file *file,
 
 	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
-	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
-	return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
+	return !cifs_dir_emit(ctx, name.name, name.len,
+			      &fattr, cfid);
 }
 
 
@@ -941,8 +1040,9 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	int rc = 0;
 	unsigned int xid;
 	int i;
+	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
-	struct cifsFileInfo *cifsFile = NULL;
+	struct cifsFileInfo *cifsFile;
 	char *current_entry;
 	int num_to_fill = 0;
 	char *tmp_buf = NULL;
@@ -950,6 +1050,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned int max_len;
 	const char *full_path;
 	void *page = alloc_dentry_path();
+	struct cached_fid *cfid = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 
 	xid = get_xid();
 
@@ -959,6 +1061,56 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		goto rddir2_exit;
 	}
 
+	if (file->private_data == NULL) {
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink))
+			goto cache_not_found;
+		tcon = tlink_tcon(tlink);
+	} else {
+		cifsFile = file->private_data;
+		tcon = tlink_tcon(cifsFile->tlink);
+	}
+	
+	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+	cifs_put_tlink(tlink);
+	if (rc)
+		goto cache_not_found;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	/*
+	 * If this was reading from the start of the directory
+	 * we need to initialize scanning and storing the
+	 * directory content.
+	 */
+	if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
+		cfid->dirents.ctx = ctx;
+		cfid->dirents.pos = 2;
+	}
+	/*
+	 * If we already have the entire directory cached then
+	 * we can just serve the cache.
+	 */
+	if (cfid->dirents.is_valid) {
+		if (!dir_emit_dots(file, ctx)){
+			mutex_unlock(&cfid->dirents.de_mutex);
+			goto rddir2_exit;
+		}
+		emit_cached_dirents(&cfid->dirents, ctx);
+		mutex_unlock(&cfid->dirents.de_mutex);
+		goto rddir2_exit;
+	}
+	mutex_unlock(&cfid->dirents.de_mutex);
+
+	/* Drop the cache while calling initiate_cifs_search and
+	 * find_cifs_entry in case there will be reconnects during
+	 * query_directory.
+	 */
+	if (cfid) {
+		close_cached_dir(cfid);
+		cfid = NULL;
+	}
+
+ cache_not_found:	
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
@@ -977,7 +1129,6 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		is in current search buffer?
 		if it before then restart search
 		if after then keep searching till find it */
-
 	cifsFile = file->private_data;
 	if (cifsFile->srch_inf.endOfSearch) {
 		if (cifsFile->srch_inf.emptyDir) {
@@ -993,12 +1144,18 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
 			     &current_entry, &num_to_fill);
+	open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
 	} else if (current_entry != NULL) {
 		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
 	} else {
+		if (cfid) {
+			mutex_lock(&cfid->dirents.de_mutex);
+			finished_cached_dirents_count(&cfid->dirents, ctx);
+			mutex_unlock(&cfid->dirents.de_mutex);
+		}
 		cifs_dbg(FYI, "Could not find entry\n");
 		goto rddir2_exit;
 	}
@@ -1028,7 +1185,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		 */
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
-				  tmp_buf, max_len);
+				  tmp_buf, max_len, cfid);
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
@@ -1036,6 +1193,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		ctx->pos++;
+		if (cfid) {
+			mutex_lock(&cfid->dirents.de_mutex);
+			update_cached_dirents_count(&cfid->dirents, ctx);
+			mutex_unlock(&cfid->dirents.de_mutex);
+		}
+
 		if (ctx->pos ==
 			cifsFile->srch_inf.index_of_last_entry) {
 			cifs_dbg(FYI, "last entry in buf at pos %lld %s\n",
@@ -1050,6 +1213,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	kfree(tmp_buf);
 
 rddir2_exit:
+	if (cfid)
+		close_cached_dir(cfid);
 	free_dentry_path(page);
 	free_xid(xid);
 	return rc;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index cbe56ed35694..e59503733a27 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -699,6 +699,7 @@ smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
+	struct cached_dirent *dirent, *q;
 
 	if (cfid->is_valid) {
 		cifs_dbg(FYI, "clear cached root file handle\n");
@@ -718,6 +719,21 @@ smb2_close_cached_fid(struct kref *ref)
 		dput(cfid->dentry);
 		cfid->dentry = NULL;
 	}
+	/*
+	 * Delete all cached dirent names
+	 */
+	mutex_lock(&cfid->dirents.de_mutex);
+	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
+		list_del(&dirent->entry);
+		kfree(dirent->name);
+		kfree(dirent);
+	}
+	cfid->dirents.is_valid = 0;
+	cfid->dirents.is_failed = 0;
+	cfid->dirents.ctx = NULL;
+	cfid->dirents.pos = 0;
+	mutex_unlock(&cfid->dirents.de_mutex);
+	
 }
 
 void close_cached_dir(struct cached_fid *cfid)
-- 
2.30.2

