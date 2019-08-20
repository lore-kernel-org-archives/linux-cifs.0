Return-Path: <SRS0=G0ZP=WQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155DDC3A589
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Aug 2019 13:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5FB22CF7
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Aug 2019 13:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfHTNya (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:54:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4735 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729203AbfHTNya (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Aug 2019 09:54:30 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6A6FED3B6313764722A5;
        Tue, 20 Aug 2019 21:54:22 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 20 Aug 2019
 21:54:15 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] cifs: remove unused variable
Date:   Tue, 20 Aug 2019 22:00:47 +0800
Message-ID: <1566309647-67393-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In smb3_punch_hole, variable cifsi set but not used, remove it.
In cifs_lock, variable netfid set but not used, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/cifs/file.c    | 2 --
 fs/cifs/smb2ops.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9709069..ab07ae8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1695,7 +1695,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
-	__u16 netfid;
 	__u32 type;

 	rc = -EACCES;
@@ -1711,7 +1710,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
 	cifs_sb = CIFS_FILE_SB(file);
-	netfid = cfile->fid.netfid;
 	cinode = CIFS_I(file_inode(file));

 	if (cap_unix(tcon->ses) &&
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 64a5864..f5bbd1d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2939,7 +2939,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
 	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -2949,7 +2948,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	xid = get_xid();

 	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);

 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
--
2.7.4

