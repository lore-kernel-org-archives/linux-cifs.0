Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55D1C32793
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 00:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiHXA2m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 20:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiHXA2m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 20:28:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51156B8CD
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 17:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661300920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r8X+nPTibvuEHRFengs11r7iUtFJ/COKbBDJYXL5rnY=;
        b=gXW+26uCDR4VLXkE/9Z8Ok9bGBFEjxqUKzBXrr0xPbg0plFup13JEn6GG0c0JCjtzamtNY
        luF6KUlI2DThACWsN7Y5hzzB+LukxyCxW8YN6QZnqawSSqSleAQ6aO3nlOR9Fc9IEUKxLc
        YhNcKS7M2w7x/SUUQ4Y1p6zK8uT/Al4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-pJn3eiDaOLWcMphBngh8Cg-1; Tue, 23 Aug 2022 20:28:39 -0400
X-MC-Unique: pJn3eiDaOLWcMphBngh8Cg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F90A811E76;
        Wed, 24 Aug 2022 00:28:39 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1011D2026D4C;
        Wed, 24 Aug 2022 00:28:37 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 6/6] cifs: do not cache leased directories for longer than 30 seconds
Date:   Wed, 24 Aug 2022 10:27:56 +1000
Message-Id: <20220824002756.3659568-7-lsahlber@redhat.com>
In-Reply-To: <20220824002756.3659568-1-lsahlber@redhat.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 32 ++++++++++++++++++++++++++++++--
 fs/cifs/cached_dir.h |  2 ++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index f4d7700827b3..1c4a409bcb67 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -14,6 +14,7 @@
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
+static void smb2_cached_lease_timeout(struct work_struct *work);
 
 /*
  * Locking and reference count for cached directory handles:
@@ -321,6 +322,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->tcon = tcon;
 	cfid->time = jiffies;
 	cfid->is_open = true;
+	queue_delayed_work(cifsiod_wq, &cfid->lease_timeout, HZ * 30);
+	cfid->has_timeout = true;
 	cfid->has_lease = true;
 
 oshr_free:
@@ -447,6 +450,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		list_add(&cfid->entry, &entry);
 		cfids->num_entries--;
 		cfid->is_open = false;
+		cfid->has_timeout = false;
 		/* To prevent race with smb2_cached_lease_break() */
 		kref_get(&cfid->refcount);
 	}
@@ -455,6 +459,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		cfid->on_list = false;
 		list_del(&cfid->entry);
+		cancel_delayed_work_sync(&cfid->lease_timeout);
 		cancel_work_sync(&cfid->lease_break);
 		if (cfid->has_lease) {
 			/*
@@ -477,12 +482,34 @@ smb2_cached_lease_break(struct work_struct *work)
 	struct cached_fid *cfid = container_of(work,
 				struct cached_fid, lease_break);
 
+	cancel_delayed_work_sync(&cfid->lease_timeout);
 	spin_lock(&cfid->cfids->cfid_list_lock);
+	if (!cfid->has_lease) {
+		spin_unlock(&cfid->cfids->cfid_list_lock);
+		return;
+	}
 	cfid->has_lease = false;
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
+static void
+smb2_cached_lease_timeout(struct work_struct *work)
+{
+	struct cached_fid *cfid = container_of(work,
+				struct cached_fid, lease_timeout.work);
+
+	spin_lock(&cfid->cfids->cfid_list_lock);
+	if (!cfid->has_timeout || !cfid->on_list) {
+		spin_unlock(&cfid->cfids->cfid_list_lock);
+		return;
+	}
+	cfid->has_timeout = false;
+	spin_unlock(&cfid->cfids->cfid_list_lock);
+
+	queue_work(cifsiod_wq, &cfid->lease_break);
+}
+
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
 	struct cached_fids *cfids = tcon->cfids;
@@ -506,9 +533,9 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			queue_work(cifsiod_wq,
-				   &cfid->lease_break);
+			cfid->has_timeout = false;
 			spin_unlock(&cfids->cfid_list_lock);
+			queue_work(cifsiod_wq, &cfid->lease_break);
 			return true;
 		}
 	}
@@ -530,6 +557,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	}
 
 	INIT_WORK(&cfid->lease_break, smb2_cached_lease_break);
+	INIT_DELAYED_WORK(&cfid->lease_timeout, smb2_cached_lease_timeout);
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index e536304ca2ce..813cd30f7ca3 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -35,6 +35,7 @@ struct cached_fid {
 	struct cached_fids *cfids;
 	const char *path;
 	bool has_lease:1;
+	bool has_timeout:1;
 	bool is_open:1;
 	bool on_list:1;
 	bool file_all_info_is_valid:1;
@@ -45,6 +46,7 @@ struct cached_fid {
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct lease_break;
+	struct delayed_work lease_timeout;
 	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
 };
-- 
2.35.3

