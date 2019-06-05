Return-Path: <SRS0=m+wU=UE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6EBC282CE
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 00:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3FF206DF
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 00:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFEAir (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Jun 2019 20:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFEAir (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 4 Jun 2019 20:38:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 431EA5F72C;
        Wed,  5 Jun 2019 00:38:47 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1E981001DFD;
        Wed,  5 Jun 2019 00:38:46 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add spinlock for the openFileList to cifsInodeInfo
Date:   Wed,  5 Jun 2019 10:38:38 +1000
Message-Id: <20190605003838.13101-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 05 Jun 2019 00:38:47 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can not depend on the tcon->open_file_lock here since in multiuser mode
we may have the same file/inode open via multiple different tcons.

The current code is race prone and will crash if one user deletes a file
at the same time a different user opens/create the file.

To avoid this we need to have a spinlock attached to the inode and not the tcon.

RHBZ:  1580165

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c   | 1 +
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/file.c     | 8 ++++++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f5fcd6360056..65d9771e49f9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -303,6 +303,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
 	cifs_inode->epoch = 0;
+	spin_lock_init(&cifs_inode->open_file_lock);
 	generate_random_uuid(cifs_inode->lease_key);
 
 	/*
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 334ff5f9c3f3..733ddd5fd480 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1377,6 +1377,7 @@ struct cifsInodeInfo {
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
+	spinlock_t	open_file_lock;	/* protects openFileList */
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 06e27ac6d82c..97090693d182 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	atomic_inc(&tcon->num_local_opens);
 
 	/* if readable file instance put first in list*/
+	spin_lock(&cinode->open_file_lock);
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
 		list_add_tail(&cfile->flist, &cinode->openFileList);
+	spin_unlock(&cinode->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	if (fid->purge_cache)
@@ -413,7 +415,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
+	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
+	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 	atomic_dec(&tcon->num_local_opens);
 
@@ -1950,9 +1954,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 			return 0;
 		}
 
-		spin_lock(&tcon->open_file_lock);
+		spin_lock(&cifs_inode->open_file_lock);
 		list_move_tail(&inv_file->flist, &cifs_inode->openFileList);
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_inode->open_file_lock);
 		cifsFileInfo_put(inv_file);
 		++refind;
 		inv_file = NULL;
-- 
2.13.6

