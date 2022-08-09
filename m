Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DEBC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiHICMq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiHICMp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE04A1BE98
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TriPXjo/igwExy9roXWGRmwBhIx1FeSyqgk96SMukI=;
        b=NaA/xWwsU5y66mKm4S3AXvzaUUTpImP7wkpF6ESYELlX39i/2KLGHwtJO9Mnvnc+bOyh4D
        Jry7L38L9Rd7RhlYgEWNek8lIwRU1aYVuYFEMPcxi3+X6BDa8PfXL87dSeAVCKvlNuFN+3
        nivUVOvhT6DKoE4m1RNN57gq+xWG0q8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-LVXHBgFkM9GW6xjETse9vw-1; Mon, 08 Aug 2022 22:12:39 -0400
X-MC-Unique: LVXHBgFkM9GW6xjETse9vw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 804488041B5;
        Tue,  9 Aug 2022 02:12:39 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92B27492C3B;
        Tue,  9 Aug 2022 02:12:38 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 7/9] cifs: store a pointer to a fid in the cfid structure instead of the struct
Date:   Tue,  9 Aug 2022 12:11:54 +1000
Message-Id: <20220809021156.3086869-8-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

also create a constructor that takes a path name and stores it in the fid.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 63 ++++++++++++++++++++++++++++++++++++++------
 fs/cifs/cached_dir.h |  4 ++-
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 9423fee378f4..5f2d01833f1e 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -11,6 +11,8 @@
 #include "smb2proto.h"
 #include "cached_dir.h"
 
+struct cached_fid *init_cached_dir(const char *path);
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
@@ -53,7 +55,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (strlen(path))
 		return -ENOENT;
 
-	cfid = &tcon->cfids->cfid;
+	cfid = tcon->cfids->cfid;
+	if (cfid == NULL) {
+		cfid = init_cached_dir(path);
+		tcon->cfids->cfid = cfid;
+	}
+	if (cfid == NULL)
+		return -ENOMEM;
+
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
@@ -228,7 +237,9 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 {
 	struct cached_fid *cfid;
 
-	cfid = &tcon->cfids->cfid;
+	cfid = tcon->cfids->cfid;
+	if (cfid == NULL)
+		return -ENOENT;
 
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->dentry == dentry) {
@@ -322,7 +333,9 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
-		cfid = &tcon->cfids->cfid;
+		cfid = tcon->cfids->cfid;
+		if (cfid == NULL)
+			continue;
 		mutex_lock(&cfid->fid_mutex);
 		if (cfid->dentry) {
 			dput(cfid->dentry);
@@ -338,7 +351,10 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
  */
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
-	struct cached_fid *cfid = &tcon->cfids->cfid;
+	struct cached_fid *cfid = tcon->cfids->cfid;
+
+	if (cfid == NULL)
+		return;
 
 	mutex_lock(&cfid->fid_mutex);
 	cfid->is_valid = false;
@@ -359,7 +375,10 @@ smb2_cached_lease_break(struct work_struct *work)
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
-	struct cached_fid *cfid = &tcon->cfids->cfid;
+	struct cached_fid *cfid = tcon->cfids->cfid;
+
+	if (cfid == NULL)
+		return false;
 
 	if (cfid->is_valid &&
 	    !memcmp(lease_key,
@@ -376,6 +395,32 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 	return false;
 }
 
+struct cached_fid *init_cached_dir(const char *path)
+{
+	struct cached_fid *cfid;
+
+	cfid = kzalloc(sizeof(*cfid), GFP_KERNEL);
+	if (!cfid)
+		return NULL;
+	cfid->path = kstrdup(path, GFP_KERNEL);
+	if (!cfid->path) {
+		kfree(cfid);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&cfid->dirents.entries);
+	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->fid_mutex);
+	return cfid;
+}
+
+void free_cached_dir(struct cached_fid *cfid)
+{
+	kfree(cfid->path);
+	cfid->path = NULL;
+	kfree(cfid);
+}
+
 struct cached_fids *init_cached_dirs(void)
 {
 	struct cached_fids *cfids;
@@ -383,13 +428,15 @@ struct cached_fids *init_cached_dirs(void)
 	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
 	if (!cfids)
 		return NULL;
-	INIT_LIST_HEAD(&cfids->cfid.dirents.entries);
-	mutex_init(&cfids->cfid.dirents.de_mutex);
-	mutex_init(&cfids->cfid.fid_mutex);
+	mutex_init(&cfids->cfid_list_mutex);
 	return cfids;
 }
 
 void free_cached_dirs(struct cached_fids *cfids)
 {
+	if (cfids->cfid) {
+		free_cached_dir(cfids->cfid);
+		cfids->cfid = NULL;
+	}
 	kfree(cfids);
 }
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index 5a384fad2432..d34ff3e31488 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -31,6 +31,7 @@ struct cached_dirents {
 };
 
 struct cached_fid {
+	const char *path;
 	bool is_valid:1;	/* Do we have a useable root fid */
 	bool file_all_info_is_valid:1;
 	bool has_lease:1;
@@ -46,7 +47,8 @@ struct cached_fid {
 };
 
 struct cached_fids {
-	struct cached_fid cfid;
+	struct mutex cfid_list_mutex;
+	struct cached_fid *cfid;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
-- 
2.35.3

