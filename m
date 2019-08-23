Return-Path: <SRS0=Weua=WT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C49CC3A5A2
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Aug 2019 12:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A5322CEC
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Aug 2019 12:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391627AbfHWMQT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:16:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45608 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389773AbfHWMQS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 23 Aug 2019 08:16:18 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 78ABB5F6FD15DD49C872;
        Fri, 23 Aug 2019 20:16:08 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 20:15:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cifs: remove set but not used variables
Date:   Fri, 23 Aug 2019 20:15:35 +0800
Message-ID: <20190823121535.76296-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

fs/cifs/file.c: In function cifs_lock:
fs/cifs/file.c:1696:24: warning: variable cinode set but not used [-Wunused-but-set-variable]
fs/cifs/file.c: In function cifs_write:
fs/cifs/file.c:1765:23: warning: variable cifs_sb set but not used [-Wunused-but-set-variable]
fs/cifs/file.c: In function collect_uncached_read_data:
fs/cifs/file.c:3578:20: warning: variable tcon set but not used [-Wunused-but-set-variable]

'cinode' is never used since introduced by
commit 03776f4516bc ("CIFS: Simplify byte range locking code")
'cifs_sb' is not used since commit cb7e9eabb2b5 ("CIFS: Use
multicredits for SMB 2.1/3 writes").
'tcon' is not used since commit d26e2903fc10 ("smb3: fix bytes_read statistics")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/cifs/file.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ab07ae8..f16f6d2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1693,7 +1693,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	bool posix_lck = false;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
@@ -1710,7 +1709,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
 	cifs_sb = CIFS_FILE_SB(file);
-	cinode = CIFS_I(file_inode(file));
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
@@ -1762,7 +1760,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
-	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	unsigned int xid;
@@ -1770,8 +1767,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 	struct cifsInodeInfo *cifsi = CIFS_I(d_inode(dentry));
 	struct cifs_io_parms io_parms;
 
-	cifs_sb = CIFS_SB(dentry->d_sb);
-
 	cifs_dbg(FYI, "write %zd bytes to offset %lld of %pd\n",
 		 write_size, *offset, dentry);
 
@@ -3575,10 +3570,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 	struct cifs_readdata *rdata, *tmp;
 	struct iov_iter *to = &ctx->iter;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	int rc;
 
-	tcon = tlink_tcon(ctx->cfile->tlink);
 	cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);
 
 	mutex_lock(&ctx->aio_mutex);
-- 
2.7.4


