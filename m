Return-Path: <SRS0=aXsT=UC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F83C04AB6
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 07:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 545BB27D04
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 07:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfFCH7e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jun 2019 03:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfFCH7d (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 3 Jun 2019 03:59:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74FE93082B55;
        Mon,  3 Jun 2019 07:59:33 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6323648B3;
        Mon,  3 Jun 2019 07:59:32 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add global spinlock for the openFileList
Date:   Mon,  3 Jun 2019 17:59:22 +1000
Message-Id: <20190603075922.27266-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 03 Jun 2019 07:59:33 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can not depend on the tcon->open_file_lock here since in multiuser mode
we may have the same file/inode open via multiple different tcons.

The current code is race prone and will crash if one user deletes a file
at the same time a different user opens/create the file.

RHBZ:  1580165

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c   |  1 +
 fs/cifs/cifsglob.h |  5 +++++
 fs/cifs/file.c     | 12 ++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f5fcd6360056..20cc4eaa7a49 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1459,6 +1459,7 @@ init_cifs(void)
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
 	spin_lock_init(&cifs_tcp_ses_lock);
+	spin_lock_init(&cifs_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
 	cifs_lock_secret = get_random_u32();
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 334ff5f9c3f3..807b7cd7d48d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1817,6 +1817,11 @@ GLOBAL_EXTERN struct list_head		cifs_tcp_ses_list;
  * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
  */
 GLOBAL_EXTERN spinlock_t		cifs_tcp_ses_lock;
+/*
+ * This lock protects the cifsInodeInfo->openFileList as well as
+ * cifsFileInfo->flist|tlist.
+ */
+GLOBAL_EXTERN spinlock_t		cifs_list_lock;
 
 #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
 /* Outstanding dir notify requests */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 06e27ac6d82c..8e96a5ae83bf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	atomic_inc(&tcon->num_local_opens);
 
 	/* if readable file instance put first in list*/
+	spin_lock(&cifs_list_lock);
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
 		list_add_tail(&cfile->flist, &cinode->openFileList);
+	spin_unlock(&cifs_list_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	if (fid->purge_cache)
@@ -413,8 +415,10 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
+	spin_lock(&cifs_list_lock);
 	list_del(&cifs_file->flist);
 	list_del(&cifs_file->tlist);
+	spin_unlock(&cifs_list_lock);
 	atomic_dec(&tcon->num_local_opens);
 
 	if (list_empty(&cifsi->openFileList)) {
@@ -1459,8 +1463,10 @@ void
 cifs_move_llist(struct list_head *source, struct list_head *dest)
 {
 	struct list_head *li, *tmp;
+	spin_lock(&cifs_list_lock);
 	list_for_each_safe(li, tmp, source)
 		list_move(li, dest);
+	spin_unlock(&cifs_list_lock);
 }
 
 void
@@ -1469,7 +1475,9 @@ cifs_free_llist(struct list_head *llist)
 	struct cifsLockInfo *li, *tmp;
 	list_for_each_entry_safe(li, tmp, llist, llist) {
 		cifs_del_lock_waiters(li);
+		spin_lock(&cifs_list_lock);
 		list_del(&li->llist);
+		spin_unlock(&cifs_list_lock);
 		kfree(li);
 	}
 }
@@ -1950,9 +1958,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 			return 0;
 		}
 
-		spin_lock(&tcon->open_file_lock);
+		spin_lock(&cifs_list_lock);
 		list_move_tail(&inv_file->flist, &cifs_inode->openFileList);
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_list_lock);
 		cifsFileInfo_put(inv_file);
 		++refind;
 		inv_file = NULL;
-- 
2.13.6

