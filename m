Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C65AC4363A
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 21:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B052C20756
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 21:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QE4mv9j/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgJEVQg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgJEVQg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Oct 2020 17:16:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601932593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=6IfSmwLfVeVxVeFEwJ2jWhip16nUIYi39Y5KmPyvTr0=;
        b=QE4mv9j/aIC0f3kS7zcJeQa2o1QQArpUeUMQ/7tGf9Gn5tOcLfMcnymfvZSkohBGb9pDmw
        xupKN0JSMjBCd96dV6du8m3PiXROmb0wF5tcRYsoUS+ZjvHEuDqehlcgcdW/COJapUn+5r
        fyJU0A6ztNLsmoomc/tP96bei4Ehouw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-ipKFwOtoO-epN--Ub-X6FA-1; Mon, 05 Oct 2020 17:16:30 -0400
X-MC-Unique: ipKFwOtoO-epN--Ub-X6FA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B929C1005E5E;
        Mon,  5 Oct 2020 21:16:29 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC8A78816;
        Mon,  5 Oct 2020 21:16:28 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 3/3] cifs: cache the directory content for shroot
Date:   Tue,  6 Oct 2020 07:16:22 +1000
Message-Id: <20201005211622.18097-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add caching of the directory content for the shroot.
Populate the cache during the initial scan in readdir()
and then try to serve out of the cache for subsequent scans.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h |  22 +++++++
 fs/cifs/misc.c     |   2 +
 fs/cifs/readdir.c  | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2ops.c  |  14 +++++
 4 files changed, 207 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b565d83ba89e..487e6de80e47 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1073,6 +1073,27 @@ cap_unix(struct cifs_ses *ses)
 	return ses->server->vals->cap_unix & ses->capabilities;
 }
 
+struct cached_dirent {
+	struct list_head entry;
+	char *name;
+	int namelen;
+	loff_t pos;
+	u64 ino;
+	unsigned type;
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
@@ -1083,6 +1104,7 @@ struct cached_fid {
 	struct cifs_tcon *tcon;
 	struct work_struct lease_break;
 	struct smb2_file_all_info file_all_info;
+	struct cached_dirents dirents;
 };
 
 /*
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1c14cf01dbef..a106bd3cc20b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -124,6 +124,8 @@ tconInfoAlloc(void)
 		kfree(ret_buf);
 		return NULL;
 	}
+	INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
+	mutex_init(&ret_buf->crfid.dirents.de_mutex);
 
 	atomic_inc(&tconInfoAllocCount);
 	ret_buf->tidStatus = CifsNew;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 31a18aae5e64..4779ae15307f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -811,9 +811,110 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 	return rc;
 }
 
+static bool emit_cached_dirents(struct cached_dirents *cde,
+				struct dir_context *ctx)
+{
+	struct list_head *tmp;
+	struct cached_dirent *dirent;
+	int rc;
+
+	list_for_each(tmp, &cde->entries) {
+		dirent = list_entry(tmp, struct cached_dirent, entry);
+		if (ctx->pos >= dirent->pos)
+			continue;
+		ctx->pos = dirent->pos;
+		rc = dir_emit(ctx, dirent->name, dirent->namelen,
+			      dirent->ino, dirent->type);
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
+			      u64 ino, unsigned type)
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
+	de->name = kzalloc(namelen, GFP_ATOMIC);
+	if (de->name == NULL) {
+		kfree(de);
+		cde->is_failed = 1;
+		return;
+	}
+	memcpy(de->name, name, namelen);
+	de->namelen = namelen;
+	de->pos = ctx->pos;
+	de->ino = ino;
+	de->type = type;
+
+	list_add_tail(&de->entry, &cde->entries);
+}
+
+static bool cifs_dir_emit(struct dir_context *ctx,
+			  const char *name, int namelen,
+			  u64 ino, unsigned type,
+			  struct cached_fid *cfid)
+{
+	bool rc;
+
+	rc = dir_emit(ctx, name, namelen, ino, type);
+	if (!rc)
+		return rc;
+
+	if (cfid) {
+		mutex_lock(&cfid->dirents.de_mutex);
+		add_cached_dirent(&cfid->dirents, ctx, name, namelen, ino,
+				  type);
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
@@ -903,16 +1004,16 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
 	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
-	return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
+	return !cifs_dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype,
+			      cfid);
 }
 
-
 int cifs_readdir(struct file *file, struct dir_context *ctx)
 {
 	int rc = 0;
 	unsigned int xid;
 	int i;
-	struct cifs_tcon *tcon;
+	struct cifs_tcon *tcon, *mtcon;
 	struct cifsFileInfo *cifsFile = NULL;
 	char *current_entry;
 	int num_to_fill = 0;
@@ -920,15 +1021,59 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	char *end_of_smb;
 	unsigned int max_len;
 	char *full_path = NULL;
+	struct cached_fid *cfid = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 
 	xid = get_xid();
-
 	full_path = build_path_from_dentry(file_dentry(file));
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 		goto rddir2_exit;
 	}
 
+	mtcon = cifs_sb_master_tcon(cifs_sb);
+	if (!is_smb1_server(mtcon->ses->server) && !strcmp(full_path, "")) {
+		rc = open_shroot(xid, mtcon, cifs_sb, &cfid);
+		if (rc)
+			goto cache_not_found;
+
+		mutex_lock(&cfid->dirents.de_mutex);
+		/*
+		 * If this was reading from the start of the directory
+		 * we need to initialize scanning and storing the
+		 * directory content.
+		 */
+		if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
+			cfid->dirents.ctx = ctx;
+			cfid->dirents.pos = 2;
+		}
+		/*
+		 * If we already have the entire directory cached then
+		 * we can just serve the cache.
+		 */
+		if (cfid->dirents.is_valid) {
+			if (!dir_emit_dots(file, ctx)){
+				mutex_unlock(&cfid->dirents.de_mutex);
+				goto rddir2_exit;
+			}
+			emit_cached_dirents(&cfid->dirents, ctx);
+			mutex_unlock(&cfid->dirents.de_mutex);
+			goto rddir2_exit;
+		}
+		mutex_unlock(&cfid->dirents.de_mutex);
+	}
+ cache_not_found:
+
+	/* Drop the cache while calling initiate_cifs_search and
+	 * find_cifs_entry in case there will be reconnects during
+	 * query_directory.
+	 */
+	if (cfid) {
+		close_shroot(cfid);
+		cfid = NULL;
+	}
+
+
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
@@ -949,6 +1094,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		if after then keep searching till find it */
 
 	cifsFile = file->private_data;
+	tcon = tlink_tcon(cifsFile->tlink);
 	if (cifsFile->srch_inf.endOfSearch) {
 		if (cifsFile->srch_inf.emptyDir) {
 			cifs_dbg(FYI, "End of search, empty dir\n");
@@ -960,15 +1106,22 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		tcon->ses->server->close(xid, tcon, &cifsFile->fid);
 	} */
 
-	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
 			     &current_entry, &num_to_fill);
+	if (!is_smb1_server(tcon->ses->server) && !strcmp(full_path, "")) {
+		open_shroot(xid, mtcon, cifs_sb, &cfid);
+	}
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
@@ -998,7 +1151,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		 */
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
-				  tmp_buf, max_len);
+				  tmp_buf, max_len, cfid);
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
@@ -1006,6 +1159,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
@@ -1020,6 +1179,8 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	kfree(tmp_buf);
 
 rddir2_exit:
+	if (cfid)
+		close_shroot(cfid);
 	kfree(full_path);
 	free_xid(xid);
 	return rc;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index fd6c136066df..280464e21a5f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -605,6 +605,8 @@ smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
+	struct list_head *pos, *q;
+	struct cached_dirent *dirent;
 
 	if (cfid->is_valid) {
 		cifs_dbg(FYI, "clear cached root file handle\n");
@@ -613,6 +615,18 @@ smb2_close_cached_fid(struct kref *ref)
 		cfid->is_valid = false;
 		cfid->file_all_info_is_valid = false;
 		cfid->has_lease = false;
+		mutex_lock(&cfid->dirents.de_mutex);
+		list_for_each_safe(pos, q, &cfid->dirents.entries) {
+			dirent = list_entry(pos, struct cached_dirent, entry);
+			list_del(pos);
+			kfree(dirent->name);
+			kfree(dirent);
+		}
+		cfid->dirents.is_valid = 0;
+		cfid->dirents.is_failed = 0;
+		cfid->dirents.ctx = NULL;
+		cfid->dirents.pos = 0;
+		mutex_unlock(&cfid->dirents.de_mutex);
 	}
 }
 
-- 
2.13.6

