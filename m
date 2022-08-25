Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F21BC04AA5
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiHYElZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiHYElX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B371BE
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661402481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5eAGpedc53fq+szSrlzLLzrJyC7UV2N4pAN+4VsjY8=;
        b=jAQibA/gIIs9mbDTGQDJtxvMQsqRfDcQDeALRj/5G4OyMnHnbud+NDUAjsKeNCTHyfx8xk
        848ttSa+AsB8MY9QtDcuVEVZZh4tRa3pmyBxj+A/9EPrY6mdxqkYN3TAiMdntI2luS3t5a
        YPmQn3szc4XP7tlqp+XTo1zdiCUUmG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-Ti-RtuLIOiai_XCZ5UlMVA-1; Thu, 25 Aug 2022 00:41:20 -0400
X-MC-Unique: Ti-RtuLIOiai_XCZ5UlMVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8355811E76;
        Thu, 25 Aug 2022 04:41:19 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC324C819;
        Thu, 25 Aug 2022 04:41:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/5] cifs: Make tcon contain a wrapper structure cached_fids instead of cached_fid
Date:   Thu, 25 Aug 2022 14:41:03 +1000
Message-Id: <20220825044107.3703811-2-lsahlber@redhat.com>
In-Reply-To: <20220825044107.3703811-1-lsahlber@redhat.com>
References: <20220825044107.3703811-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This wrapper structure will later be expanded to contain a list of
fids that are cached and not just the root fid.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 50 ++++++++++++++++++++++++--------------------
 fs/cifs/cached_dir.h |  8 +++++--
 fs/cifs/cifsglob.h   |  2 +-
 fs/cifs/misc.c       |  6 +++---
 4 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index b401339f6e73..c2f5b71a3c9f 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -52,7 +52,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	dentry = cifs_sb->root;
 
-	cfid = tcon->cfid;
+	cfid = &tcon->cfids->cfid;
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
@@ -226,7 +226,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 {
 	struct cached_fid *cfid;
 
-	cfid = tcon->cfid;
+	cfid = &tcon->cfids->cfid;
 
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->dentry == dentry) {
@@ -320,7 +320,7 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
-		cfid = tcon->cfid;
+		cfid = &tcon->cfids->cfid;
 		mutex_lock(&cfid->fid_mutex);
 		if (cfid->dentry) {
 			dput(cfid->dentry);
@@ -336,12 +336,14 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
  */
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
-	mutex_lock(&tcon->cfid->fid_mutex);
-	tcon->cfid->is_valid = false;
+	struct cached_fid *cfid = &tcon->cfids->cfid;
+
+	mutex_lock(&cfid->fid_mutex);
+	cfid->is_valid = false;
 	/* cached handle is not valid, so SMB2_CLOSE won't be sent below */
-	close_cached_dir_lease_locked(tcon->cfid);
-	memset(&tcon->cfid->fid, 0, sizeof(struct cifs_fid));
-	mutex_unlock(&tcon->cfid->fid_mutex);
+	close_cached_dir_lease_locked(cfid);
+	memset(&cfid->fid, 0, sizeof(struct cifs_fid));
+	mutex_unlock(&cfid->fid_mutex);
 }
 
 static void
@@ -355,34 +357,36 @@ smb2_cached_lease_break(struct work_struct *work)
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
-	if (tcon->cfid->is_valid &&
+	struct cached_fid *cfid = &tcon->cfids->cfid;
+
+	if (cfid->is_valid &&
 	    !memcmp(lease_key,
-		    tcon->cfid->fid.lease_key,
+		    cfid->fid.lease_key,
 		    SMB2_LEASE_KEY_SIZE)) {
-		tcon->cfid->time = 0;
-		INIT_WORK(&tcon->cfid->lease_break,
+		cfid->time = 0;
+		INIT_WORK(&cfid->lease_break,
 			  smb2_cached_lease_break);
 		queue_work(cifsiod_wq,
-			   &tcon->cfid->lease_break);
+			   &cfid->lease_break);
 		return true;
 	}
 	return false;
 }
 
-struct cached_fid *init_cached_dir(void)
+struct cached_fids *init_cached_dirs(void)
 {
-	struct cached_fid *cfid;
+	struct cached_fids *cfids;
 
-	cfid = kzalloc(sizeof(*cfid), GFP_KERNEL);
-	if (!cfid)
+	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
+	if (!cfids)
 		return NULL;
-	INIT_LIST_HEAD(&cfid->dirents.entries);
-	mutex_init(&cfid->dirents.de_mutex);
-	mutex_init(&cfid->fid_mutex);
-	return cfid;
+	INIT_LIST_HEAD(&cfids->cfid.dirents.entries);
+	mutex_init(&cfids->cfid.dirents.de_mutex);
+	mutex_init(&cfids->cfid.fid_mutex);
+	return cfids;
 }
 
-void free_cached_dir(struct cifs_tcon *tcon)
+void free_cached_dirs(struct cached_fids *cfids)
 {
-	kfree(tcon->cfid);
+	kfree(cfids);
 }
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index bd262dc8b179..e430e1102296 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -45,8 +45,12 @@ struct cached_fid {
 	struct cached_dirents dirents;
 };
 
-extern struct cached_fid *init_cached_dir(void);
-extern void free_cached_dir(struct cifs_tcon *tcon);
+struct cached_fids {
+	struct cached_fid cfid;
+};
+
+extern struct cached_fids *init_cached_dirs(void);
+extern void free_cached_dirs(struct cached_fids *cfids);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			   const char *path,
 			   struct cifs_sb_info *cifs_sb,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f15d7b0c123d..768003e52cc9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1221,7 +1221,7 @@ struct cifs_tcon {
 	struct fscache_volume *fscache;	/* cookie for share */
 #endif
 	struct list_head pending_opens;	/* list of incomplete opens */
-	struct cached_fid *cfid; /* Cached root fid */
+	struct cached_fids *cfids;
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct list_head ulist; /* cache update list */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 87f60f736731..5cb7e1ae00a4 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -117,8 +117,8 @@ tconInfoAlloc(void)
 	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
 	if (!ret_buf)
 		return NULL;
-	ret_buf->cfid = init_cached_dir();
-	if (!ret_buf->cfid) {
+	ret_buf->cfids = init_cached_dirs();
+	if (!ret_buf->cfids) {
 		kfree(ret_buf);
 		return NULL;
 	}
@@ -144,7 +144,7 @@ tconInfoFree(struct cifs_tcon *tcon)
 		cifs_dbg(FYI, "Null buffer passed to tconInfoFree\n");
 		return;
 	}
-	free_cached_dir(tcon);
+	free_cached_dirs(tcon->cfids);
 	atomic_dec(&tconInfoAllocCount);
 	kfree(tcon->nativeFileSystem);
 	kfree_sensitive(tcon->password);
-- 
2.35.3

