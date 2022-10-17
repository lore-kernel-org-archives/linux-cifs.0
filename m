Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5A3C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 08:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJQIzv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 04:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiJQIzt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 04:55:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C29120A5
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 01:55:48 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrW6j3NzHzHv2P;
        Mon, 17 Oct 2022 16:55:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 16:55:43 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 16:55:42 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-cifs@vger.kernel.org>
CC:     <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH -next] cifs: use LIST_HEAD() and list_move() to simplify code
Date:   Mon, 17 Oct 2022 16:55:08 +0800
Message-ID: <20221017085508.3582763-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD().

Using list_move() instead of list_del() and list_add().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/cifs/cached_dir.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index fe88b67c863f..8cad528a8722 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -378,13 +378,11 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
-	struct list_head entry;
+	LIST_HEAD(entry);
 
-	INIT_LIST_HEAD(&entry);
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		list_del(&cfid->entry);
-		list_add(&cfid->entry, &entry);
+		list_move(&cfid->entry, &entry);
 		cfids->num_entries--;
 		cfid->is_open = false;
 		/* To prevent race with smb2_cached_lease_break() */
@@ -518,15 +516,13 @@ struct cached_fids *init_cached_dirs(void)
 void free_cached_dirs(struct cached_fids *cfids)
 {
 	struct cached_fid *cfid, *q;
-	struct list_head entry;
+	LIST_HEAD(entry);
 
-	INIT_LIST_HEAD(&entry);
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		cfid->on_list = false;
 		cfid->is_open = false;
-		list_del(&cfid->entry);
-		list_add(&cfid->entry, &entry);
+		list_move(&cfid->entry, &entry);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
-- 
2.25.1

