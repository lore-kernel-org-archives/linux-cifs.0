Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3603C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB07461037
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhHWPQY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhHWPQS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF62661371;
        Mon, 23 Aug 2021 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731735;
        bh=CzDaPb+vJk8+rzF06lBfdJ4RPo5P4NA8wQLcjFHNHvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8wjLcUiaaXTs0kVV854GQY4IEgpg2V0rih1BfuB9pGbdMoHBGnOvIUWOkllWhw8+
         knW+SuJjvFDiJY6DWNh9qqE4n4XZs9Ht8z3vPoKM5UaAVOlb0Yre1VvLdeHQ3Y5Emz
         nOdoEUoDI52+ns+ApYoM0pa91Uq4QJInEG/uYim3PpJrI/bqRd7HtoH26Yd4VmHUyD
         PvdRUQy/dovuIncJPh6enVNKqPtDv6N0a9mcWoWtnxufVGSaOeEiTYzj5qJVYacZJv
         9pLiVlsAxl6IBxYBtraZ8s8p0bCZ8W6Vo2XEFFg1JtnU5TJuVaA6MUjSvKkHNqY3j6
         cRtKv90mSIbCA==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 10/11] ksmbd: remove setattr preparations in set_file_basic_info()
Date:   Mon, 23 Aug 2021 17:13:56 +0200
Message-Id: <20210823151357.471691-11-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1371; h=from:subject; bh=Di6RlFMWadp2RZjTWlhtophyNmU3z/OR4K0oggKUg6Q=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zZuK2W0eeG7snTeXn3WKLMt9z/fXXziqYOdm/jJtawP EuaWdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEN5KR4dMqD4ln03s+/eh58048vU So7r+8PLMGT6HJpFVLFx2Y2sfwv6zfIOghx78NJZkhxl1SOq3r/k/y7jFSzPP8xNX294IkAwA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Permission checking and copying over ownership information is the task
of the underlying filesystem not ksmbd. The order is also wrong here.
This modifies the inode before notify_change(). If notify_change() fails
this will have changed ownership nonetheless. All of this is unnecessary
though since the underlying filesystem's ->setattr handler will do all
this (if required) by itself.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smb2pdu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1148e52a4037..059764753aaa 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5521,12 +5521,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EACCES;
 
-		rc = setattr_prepare(user_ns, dentry, &attrs);
-		if (rc)
-			return -EINVAL;
-
 		inode_lock(inode);
-		setattr_copy(user_ns, inode, &attrs);
 		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(user_ns, dentry, &attrs, NULL);
 		inode_unlock(inode);
-- 
2.30.2

