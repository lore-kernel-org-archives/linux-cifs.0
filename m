Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65A7C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiHICMl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiHICMk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 576551BE93
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+h50wU5RQ6/zzwJy17RkrmDX+z5AvHJoEch7yXgB3U4=;
        b=QQraWZWOcTXYYhUTSA5KBLn9QdAzpKgpzajwKFdG1jcqUozLblDQQIz87o2uUUX2KA4cxR
        UK+Y53ULbWuFBIxuTP9IHEARM8mrHKfbkBhunEupppKEFUwSC0l4aAO4PzIh1rASiVYHQ/
        A3ndg7mZDSMHbH3ySxJMUi1O9w6kTAM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Gz_3IJSvP7-S6wD8NcnOlA-1; Mon, 08 Aug 2022 22:12:37 -0400
X-MC-Unique: Gz_3IJSvP7-S6wD8NcnOlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9B9A1019E1D;
        Tue,  9 Aug 2022 02:12:36 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE49DC15BA1;
        Tue,  9 Aug 2022 02:12:35 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from is_path_accessible
Date:   Tue,  9 Aug 2022 12:11:52 +1000
Message-Id: <20220809021156.3086869-6-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cfids will soon keep a list of cached fids so we should not access this
directly from outside of cached_dir.c

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 10 ++++++----
 fs/cifs/cached_dir.h |  2 +-
 fs/cifs/readdir.c    |  4 ++--
 fs/cifs/smb2inode.c  |  2 +-
 fs/cifs/smb2ops.c    | 18 ++++++++++++++----
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 604ac444ad25..1fb80b23bbeb 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -16,9 +16,9 @@
  * If error then *cfid is not initialized.
  */
 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
-		const char *path,
-		struct cifs_sb_info *cifs_sb,
-		struct cached_fid **ret_cfid)
+		    const char *path,
+		    struct cifs_sb_info *cifs_sb,
+		    bool lookup_only, struct cached_fid **ret_cfid)
 {
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
@@ -68,9 +68,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 * cifs_mark_open_files_invalid() which takes the lock again
 	 * thus causing a deadlock
 	 */
-
 	mutex_unlock(&cfid->fid_mutex);
 
+	if (lookup_only)
+		return -ENOENT;
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index 4ea30a5ba4e7..5a384fad2432 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -54,7 +54,7 @@ extern void free_cached_dirs(struct cached_fids *cfids);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			   const char *path,
 			   struct cifs_sb_info *cifs_sb,
-			   struct cached_fid **cfid);
+			   bool lookup_only, struct cached_fid **cfid);
 extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 				     struct dentry *dentry,
 				     struct cached_fid **cfid);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index a06072ae6c7e..2eece8a07c11 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1072,7 +1072,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		tcon = tlink_tcon(cifsFile->tlink);
 	}
 
-	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
 	cifs_put_tlink(tlink);
 	if (rc)
 		goto cache_not_found;
@@ -1143,7 +1143,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	tcon = tlink_tcon(cifsFile->tlink);
 	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
 			     &current_entry, &num_to_fill);
-	open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+	open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
 	if (rc) {
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 9696184a09e3..b83f59051b26 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -516,7 +516,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (strcmp(full_path, ""))
 		rc = -ENOENT;
 	else
-		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
+		rc = open_cached_dir(xid, tcon, full_path, cifs_sb, false, &cfid);
 	/* If it is a root and its handle is cached then use it */
 	if (!rc) {
 		if (cfid->file_all_info_is_valid) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 780ada4d8f6e..4727ee537f11 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -720,7 +720,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
+	rc = open_cached_dir(xid, tcon, "", cifs_sb, false, &cfid);
 	if (rc == 0)
 		memcpy(&fid, &cfid->fid, sizeof(struct cifs_fid));
 	else
@@ -783,9 +783,16 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
+	struct cached_fid *cfid;
 
-	if ((*full_path == 0) && tcon->cfids->cfid.is_valid)
-		return 0;
+	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
+	if (!rc) {
+		if (cfid->is_valid) {
+			close_cached_dir(cfid);
+			return 0;
+		}
+		close_cached_dir(cfid);
+	}
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
 	if (!utf16_path)
@@ -2431,8 +2438,11 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
+	/*
+	 * We can only call this for things we know are directories.
+	 */
 	if (!strcmp(path, ""))
-		open_cached_dir(xid, tcon, path, cifs_sb, &cfid); /* cfid null if open dir failed */
+		open_cached_dir(xid, tcon, path, cifs_sb, false, &cfid); /* cfid null if open dir failed */
 
 	memset(&open_iov, 0, sizeof(open_iov));
 	rqst[0].rq_iov = open_iov;
-- 
2.35.3

