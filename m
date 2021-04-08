Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F97AC433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 07:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F0E61155
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhDHH5b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:57:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16042 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHH53 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 03:57:29 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGD7B57QwzPp7Q;
        Thu,  8 Apr 2021 15:54:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 15:57:11 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <namjae.jeon@samsung.com>, <sergey.senozhatsky@gmail.com>,
        <sfrench@samba.org>, <hyc.lee@gmail.com>
CC:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        Tian Tao <tiantao6@hisilicon.com>,
        Zhiqi Song <songzhiqi1@huawei.com>
Subject: [PATCH] cifsd: remove unused including <linux/version.h>
Date:   Thu, 8 Apr 2021 15:57:36 +0800
Message-ID: <1617868656-34872-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
---
 fs/cifsd/crypto_ctx.c | 1 -
 fs/cifsd/glob.h       | 1 -
 fs/cifsd/misc.c       | 1 -
 fs/cifsd/vfs.c        | 1 -
 fs/cifsd/vfs_cache.h  | 1 -
 5 files changed, 5 deletions(-)

diff --git a/fs/cifsd/crypto_ctx.c b/fs/cifsd/crypto_ctx.c
index 2c31e8b..8322b0f 100644
--- a/fs/cifsd/crypto_ctx.c
+++ b/fs/cifsd/crypto_ctx.c
@@ -9,7 +9,6 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/version.h>
 
 #include "glob.h"
 #include "crypto_ctx.h"
diff --git a/fs/cifsd/glob.h b/fs/cifsd/glob.h
index d0bc6ed..9d70093 100644
--- a/fs/cifsd/glob.h
+++ b/fs/cifsd/glob.h
@@ -8,7 +8,6 @@
 #define __KSMBD_GLOB_H
 
 #include <linux/ctype.h>
-#include <linux/version.h>
 
 #include "unicode.h"
 #include "vfs_cache.h"
diff --git a/fs/cifsd/misc.c b/fs/cifsd/misc.c
index b6f3f08..cbaaecf 100644
--- a/fs/cifsd/misc.c
+++ b/fs/cifsd/misc.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/fs.h>
 
diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
index d388220..5985d2d 100644
--- a/fs/cifsd/vfs.c
+++ b/fs/cifsd/vfs.c
@@ -9,7 +9,6 @@
 #include <linux/uaccess.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
-#include <linux/version.h>
 #include <linux/xattr.h>
 #include <linux/falloc.h>
 #include <linux/genhd.h>
diff --git a/fs/cifsd/vfs_cache.h b/fs/cifsd/vfs_cache.h
index 318dcb1..8226fdf 100644
--- a/fs/cifsd/vfs_cache.h
+++ b/fs/cifsd/vfs_cache.h
@@ -6,7 +6,6 @@
 #ifndef __VFS_CACHE_H__
 #define __VFS_CACHE_H__
 
-#include <linux/version.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/rwsem.h>
-- 
2.7.4

