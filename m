Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8130AC47092
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 03:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F26B6052B
	for <linux-cifs@archiver.kernel.org>; Mon, 31 May 2021 03:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEaDD2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 May 2021 23:03:28 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3297 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhEaDD1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 May 2021 23:03:27 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Ftg165dg2z1BGjj;
        Mon, 31 May 2021 10:56:42 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 11:01:22 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 31 May
 2021 11:01:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>
CC:     <namjae.jeon@samsung.com>, <sergey.senozhatsky@gmail.com>,
        <sfrench@samba.org>, <hyc.lee@gmail.com>
Subject: [PATCH -next v2] cifsd: check return value of ksmbd_vfs_getcasexattr() correctly
Date:   Mon, 31 May 2021 11:05:50 +0800
Message-ID: <20210531030550.1708816-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ksmbd_vfs_getcasexattr() returns -ENOMEM, stream_buf is NULL,
it will cause null-ptr-deref when using it to copy memory. So we
need check the return value of ksmbd_vfs_getcasexattr() by comparing
with 0.

Fixes: f44158485826 ("cifsd: add file operations")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  Handle the case ksmbd_vfs_getcasexattr() returns 0.
---
 fs/cifsd/vfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
index 97d5584ec870..2a9cc0bc7726 100644
--- a/fs/cifsd/vfs.c
+++ b/fs/cifsd/vfs.c
@@ -274,7 +274,6 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 {
 	ssize_t v_len;
 	char *stream_buf = NULL;
-	int err;
 
 	ksmbd_debug(VFS, "read stream data pos : %llu, count : %zd\n",
 		    *pos, count);
@@ -283,10 +282,9 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
-	if (v_len == -ENOENT) {
+	if ((int)v_len <= 0) {
 		ksmbd_err("not found stream in xattr : %zd\n", v_len);
-		err = -ENOENT;
-		return err;
+		return v_len == 0 ? -ENOENT : (int)v_len;
 	}
 
 	memcpy(buf, &stream_buf[*pos], count);
@@ -415,9 +413,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
-	if (v_len == -ENOENT) {
+	if ((int)v_len <= 0) {
 		ksmbd_err("not found stream in xattr : %zd\n", v_len);
-		err = -ENOENT;
+		err = v_len == 0 ? -ENOENT : (int)v_len;
 		goto out;
 	}
 
-- 
2.25.1

