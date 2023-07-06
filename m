Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076AFEB64DA
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jul 2023 02:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjGFCdY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 22:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjGFCdX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 22:33:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4616C1B6
        for <linux-cifs@vger.kernel.org>; Wed,  5 Jul 2023 19:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688610755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GvJiOR8iOybZy78iuNJKs3psIy7vdA6AABfNkW9Q/HQ=;
        b=XTEPoNIRWBqWeUMvmrsA0CVooRiC5J+KF8UEmqAaTWxc9g5N08vlNdHnj0+gbaWKSZPP/N
        rzBy8gCJTUb5L3mfvXY85nU1YH231OMF9Adec6LW2sQ3Ex/sTa/S3phQIaNml8pilVLELC
        ICO22lUxSWkiYUhQl76pba1yOpHQPp8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-em6kCyyaORGwdWZzy4NXNQ-1; Wed, 05 Jul 2023 22:32:32 -0400
X-MC-Unique: em6kCyyaORGwdWZzy4NXNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82D71C06913;
        Thu,  6 Jul 2023 02:32:31 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-17.bne.redhat.com [10.64.52.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAF18207B2DD;
        Thu,  6 Jul 2023 02:32:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: Add a laundromat thread for cached directories
Date:   Thu,  6 Jul 2023 12:32:24 +1000
Message-Id: <20230706023224.609324-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and drop cached directories after 30 seconds

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/smb/client/cached_dir.c | 67 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 2 files changed, 68 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index bfc964b36c72..f567eea0a456 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -568,6 +568,53 @@ static void free_cached_dir(struct cached_fid *cfid)
 	kfree(cfid);
 }
 
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
+			if (jiffies > cfid->time + HZ * 30) {
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
@@ -577,6 +624,20 @@ struct cached_fids *init_cached_dirs(void)
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
 
@@ -589,6 +650,12 @@ void free_cached_dirs(struct cached_fids *cfids)
 	struct cached_fid *cfid, *q;
 	LIST_HEAD(entry);
 
+	if (cfids->laundromat) {
+		kthread_stop(cfids->laundromat);
+		cfids->laundromat = NULL;
+		module_put(THIS_MODULE);
+	}
+	
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		cfid->on_list = false;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 2f4e764c9ca9..facc9b154d00 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -57,6 +57,7 @@ struct cached_fids {
 	spinlock_t cfid_list_lock;
 	int num_entries;
 	struct list_head entries;
+	struct task_struct *laundromat;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
-- 
2.35.3

