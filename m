Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2F8C432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA0F61371
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhHWPQP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhHWPQP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B7361037;
        Mon, 23 Aug 2021 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731732;
        bh=sU30vqZh3+xM5Kte/0k8LzoMWtxcTotcBTRlHcfhbjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkSgj+GfJDhPPSbZr9WppLjDwe+qezRBUUhxucUJfM/XhViDocCHIiDoIOt+xONm7
         XrYmreTF5p8EkdK+xqtydX1ShNUM+A+HZgKdW5xA9grogthtiygdBjwDMaXDfhGRUx
         xgctHoGutfXQghzcbYx7gnPu4Y3roW+V8DseaSHsZN/TbTK4NFHFW44M2bSNfNBjaJ
         47JhijRQqFlwwl4T44O83LxfmZbRyeoadzTg4/fH0zVNckZXC7M8mfpD63i2LgTeQZ
         GvTJwhVIgexA88sEQ8Hw4B2seSclk0K4Fdx0WdanyUAf8c5u2naI7GM9vw0zT23PEr
         RmQQ0QN5PBAEw==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 09/11] ksmbd: ensure error is surfaced in set_file_basic_info()
Date:   Mon, 23 Aug 2021 17:13:55 +0200
Message-Id: <20210823151357.471691-10-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=911; h=from:subject; bh=qsihtA5JTjrExsCdSCnrzzZsdg4m1aCSqjKOhGG4gXo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zaadkbs06ppITcr1rkWZSzdNvnZTXkjT4arfBcTmtWj eCY1d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkIZ7hn51l1dmMgkUyRybcX/C6mK 3jcq3W0mc3wh3+7X2gLPZF+jMjQ9+C+9dWZ7dMM9vqmCrnYvXV6aaA5l+ehOspHg9+7uZnYwIA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

It seems the error was accidently ignored until now. Make sure it is
surfaced.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1b0a9242be88..1148e52a4037 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5531,7 +5531,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 		rc = notify_change(user_ns, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}
-	return 0;
+	return rc;
 }
 
 static int set_file_allocation_info(struct ksmbd_work *work,
-- 
2.30.2

