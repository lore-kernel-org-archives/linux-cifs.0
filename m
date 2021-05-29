Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDE2C4708F
	for <linux-cifs@archiver.kernel.org>; Sat, 29 May 2021 08:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D25E61090
	for <linux-cifs@archiver.kernel.org>; Sat, 29 May 2021 08:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhE2ISL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 May 2021 04:18:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2089 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhE2ISK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 May 2021 04:18:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsZ5k291ZzWnjh;
        Sat, 29 May 2021 16:11:54 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 16:16:31 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 29 May
 2021 16:16:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>
CC:     <namjae.jeon@samsung.com>, <sergey.senozhatsky@gmail.com>,
        <sfrench@samba.org>, <hyc.lee@gmail.com>
Subject: [PATCH -next 2/3] cifsd: fix memleak in ksmbd_vfs_stream_read()
Date:   Sat, 29 May 2021 16:20:57 +0800
Message-ID: <20210529082058.3012233-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210529082058.3012233-1-yangyingliang@huawei.com>
References: <20210529082058.3012233-1-yangyingliang@huawei.com>
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

Before ksmbd_vfs_stream_read() return, memory allocate in
ksmbd_vfs_getcasexattr() need be freed.

Fixes: f44158485826 ("cifsd: add file operations")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/cifsd/vfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifsd/vfs.c b/fs/cifsd/vfs.c
index 9057b30278b9..97d5584ec870 100644
--- a/fs/cifsd/vfs.c
+++ b/fs/cifsd/vfs.c
@@ -290,6 +290,7 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	}
 
 	memcpy(buf, &stream_buf[*pos], count);
+	kfree(stream_buf);
 	return v_len > count ? count : v_len;
 }
 
-- 
2.25.1

