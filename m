Return-Path: <SRS0=/HTR=UK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AD3C43218
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 13:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9D8206BB
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 13:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391559AbfFKN5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:57:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387835AbfFKN5d (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 Jun 2019 09:57:33 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EE158C4322C7E5AD3117;
        Tue, 11 Jun 2019 21:57:30 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 11 Jun 2019
 21:57:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <sfrench@samba.org>, <lsahlber@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-cifs@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cifs: remove set but not used variable 'ioctl_buf' and 'cifsi'
Date:   Tue, 11 Jun 2019 21:53:15 +0800
Message-ID: <20190611135315.20012-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warnings:

fs/cifs/smb2ops.c: In function smb2_query_symlink:
fs/cifs/smb2ops.c:2417:8: warning: variable ioctl_buf set but not used [-Wunused-but-set-variable]
fs/cifs/smb2ops.c: In function smb3_punch_hole:
fs/cifs/smb2ops.c:2799:24: warning: variable cifsi set but not used [-Wunused-but-set-variable]

'ioctl_buf' is never used since introduction in commit ebaf546a5584 ("SMB3:
Clean up query symlink when reparse point")

'cifsi' is never used since introduction in commit 31742c5a3317 ("enable
fallocate punch hole ("fallocate -p") for SMB3")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/cifs/smb2ops.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e921e65..e8dfa34 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2414,7 +2414,6 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec close_iov[1];
 	struct smb2_create_rsp *create_rsp;
 	struct smb2_ioctl_rsp *ioctl_rsp;
-	char *ioctl_buf;
 	u32 plen;
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
@@ -2496,7 +2495,6 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == 0) && (is_reparse_point)) {
 		/* See MS-FSCC 2.3.23 */
 
-		ioctl_buf = (char *)ioctl_rsp + le32_to_cpu(ioctl_rsp->OutputOffset);
 		plen = le32_to_cpu(ioctl_rsp->OutputCount);
 
 		if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
@@ -2796,7 +2794,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
 	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -2806,7 +2803,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);
 
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
-- 
2.7.4


