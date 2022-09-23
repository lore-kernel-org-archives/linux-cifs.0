Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70B7C54EE9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 00:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiIWA4x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 20:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiIWA4w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 20:56:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDFEB440D
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 17:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663894611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+q90XWXPJ/Wv/dFY4yPfcZ/qRVFa++BezvoUFkV6Vc=;
        b=NwXZGCLNqBWjfvDXV9Qmh9tAjkHCwlEPq8FIzDASIusf0FgRrpf5AkyJ8ijaZO9fGNWO6Q
        nP7l6Cn/rfb5/SArtOeLmI4BwOgj+iEt8QobBeLhPmrWcUgWdAPli7vhwo6eZuY1Kflmmo
        F1rG397o1KeRXrepurcirJYH11m8cpw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-ABxOogVXP7KycfvpAdGmsQ-1; Thu, 22 Sep 2022 20:56:49 -0400
X-MC-Unique: ABxOogVXP7KycfvpAdGmsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36AF43C02189;
        Fri, 23 Sep 2022 00:56:49 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 022B253AA;
        Fri, 23 Sep 2022 00:56:47 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/2] cifs: Add a laundromat thread that will timeout any directory leases we have
Date:   Fri, 23 Sep 2022 10:56:36 +1000
Message-Id: <20220923005636.626014-3-lsahlber@redhat.com>
In-Reply-To: <20220923005636.626014-1-lsahlber@redhat.com>
References: <20220923005636.626014-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

after a timeout of 5 seconds. Later we will add instrumentation to tweak this value.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cached_dir.h |  1 +
 2 files changed, 71 insertions(+)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index e2f2052dbabf..ffe0dea08b17 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -95,6 +95,7 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 		dput(dentry);
 		dentry = child;
 	} while (!IS_ERR(dentry));
+
 	return dentry;
 }
 
@@ -498,6 +499,55 @@ static void free_cached_dir(struct cached_fid *cfid)
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
+			if (time_after(jiffies, cfid->time + HZ * 5)) {
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
@@ -507,6 +557,20 @@ struct cached_fids *init_cached_dirs(void)
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
 
@@ -519,6 +583,12 @@ void free_cached_dirs(struct cached_fids *cfids)
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

