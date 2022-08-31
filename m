Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924DFECAAD5
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 02:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiHaCuN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 22:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiHaCuM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 22:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A454D4C6
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 19:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661914210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVY2WMjgGK08eQlqeVLw/a2bBJHT8CTVNDR1qNLLd8E=;
        b=fRY6ylVoCFelj0izi+3K33Q6QtlTPQMIVgHAwvFPK40PZG9yAKXUenZ75JXZzCuArGetF6
        0O/fgFQDd3p0viEPhapgcew+FsbRIYaCwOjK5qW8YppO5KJzjKcKyRUTfD3B7REVjhwmPd
        bBj5GnVa4FuerSGYKxGM4li8xDjbKpo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-cTCq6suPNiSoXs2ylFXhiA-1; Tue, 30 Aug 2022 22:50:07 -0400
X-MC-Unique: cTCq6suPNiSoXs2ylFXhiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECDA51C04B42;
        Wed, 31 Aug 2022 02:50:06 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29A534010D43;
        Wed, 31 Aug 2022 02:50:05 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 6/6] cifs: Add a laundromat thread that will timeout any directory leases we have
Date:   Wed, 31 Aug 2022 12:49:47 +1000
Message-Id: <20220831024947.3917507-7-lsahlber@redhat.com>
In-Reply-To: <20220831024947.3917507-1-lsahlber@redhat.com>
References: <20220831024947.3917507-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

after a timeout of 5 seconds. Later we will add instrumentation to tweak this value.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 87 ++++++++++++++++++++++++++++++++++++++------
 fs/cifs/cached_dir.h |  1 +
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 20aba23d8d88..16ab0cb9c53c 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -61,17 +61,12 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 }
 
 static struct dentry *
-path_to_dentry(struct cifs_sb_info *cifs_sb, const char *full_path)
+path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 {
 	struct dentry *dentry;
-	char *path = NULL;
-	char *s, *p;
+	const char *s, *p;
 	char sep;
 
-	path = kstrdup(full_path, GFP_ATOMIC);
-	if (path == NULL)
-		return ERR_PTR(-ENOMEM);
-
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(cifs_sb->root);
 	s = path;
@@ -100,7 +95,7 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *full_path)
 		dput(dentry);
 		dentry = child;
 	} while (!IS_ERR(dentry));
-	kfree(path);
+
 	return dentry;
 }
 
@@ -255,15 +250,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!strlen(path)) {
+	if (!path[0])
 		dentry = dget(cifs_sb->root);
-		cfid->dentry = dentry;
-	} else{
+	else {
 		dentry = path_to_dentry(cifs_sb, path);
 		if (IS_ERR(dentry))
 			goto oshr_free;
-		cfid->dentry = dentry;
 	}
+	cfid->dentry = dentry;
 	cfid->tcon = tcon;
 	cfid->time = jiffies;
 	cfid->is_open = true;
@@ -505,6 +499,55 @@ static void free_cached_dir(struct cached_fid *cfid)
 	kfree(cfid);
 }
 
+
+
+static int
+cifs_cfids_laundromat_thread(void *p)
+{
+	struct cached_fids *cfids = p;
+	struct cached_fid *cfid, *q;
+	struct list_head entry;
+
+	while (!kthread_should_stop()) {
+		ssleep(1);
+		INIT_LIST_HEAD(&entry);
+		if (kthread_should_stop())
+			return 0;
+		spin_lock(&cfids->cfid_list_lock);
+		list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+			if (jiffies > cfid->time + HZ * 5) {
+				list_del(&cfid->entry);
+				list_add(&cfid->entry, &entry);
+				cfids->num_entries--;
+			}
+		}
+		spin_unlock(&cfids->cfid_list_lock);
+
+		list_for_each_entry_safe(cfid, q, &entry, entry) {
+			cfid->on_list = false;
+			list_del(&cfid->entry);
+			/*
+			 * Cancel, and wait for the work to finish in
+			 * case we are racing with it.
+			 */
+			cancel_work_sync(&cfid->lease_break);
+			if (cfid->has_lease) {
+				/*
+				 * We lease has not yet been cancelled from
+				 * the server so we need to drop the reference.
+				 */
+				spin_lock(&cfids->cfid_list_lock);
+				cfid->has_lease = false;
+				spin_unlock(&cfids->cfid_list_lock);
+				kref_put(&cfid->refcount, smb2_close_cached_fid);
+			}
+		}
+	}
+
+	return 0;
+}
+
+
 struct cached_fids *init_cached_dirs(void)
 {
 	struct cached_fids *cfids;
@@ -514,6 +557,20 @@ struct cached_fids *init_cached_dirs(void)
 		return NULL;
 	spin_lock_init(&cfids->cfid_list_lock);
 	INIT_LIST_HEAD(&cfids->entries);
+
+	/*
+	 * since we're in a cifs function already, we know that
+	 * this will succeed. No need for try_module_get().
+	 */
+	__module_get(THIS_MODULE);
+	cfids->laundromat = kthread_run(cifs_cfids_laundromat_thread,
+				  cfids, "cifsd-cfid-laundromat");
+	if (IS_ERR(cfids->laundromat)) {
+		cifs_dbg(VFS, "Failed to start cfids laundromat thread.\n");
+		kfree(cfids);
+		module_put(THIS_MODULE);
+		return NULL;
+	}
 	return cfids;
 }
 
@@ -526,6 +583,12 @@ void free_cached_dirs(struct cached_fids *cfids)
 	struct cached_fid *cfid, *q;
 	struct list_head entry;
 
+	if (cfids->laundromat) {
+		kthread_stop(cfids->laundromat);
+		cfids->laundromat = NULL;
+		module_put(THIS_MODULE);
+	}
+	
        	INIT_LIST_HEAD(&entry);
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index e536304ca2ce..4ab9b10cd098 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -57,6 +57,7 @@ struct cached_fids {
 	spinlock_t cfid_list_lock;
 	int num_entries;
 	struct list_head entries;
+	struct task_struct *laundromat;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
-- 
2.35.3

