Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7A9C4320A
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B8660F56
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhIAAq4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:46:56 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:34734 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241505AbhIAAqz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 20:46:55 -0400
Received: by mail-pg1-f176.google.com with SMTP id x4so1050816pgh.1
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 17:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZJucjIXNMkSXo11UYB7gpFsoKqdvQdeqSLHQsJ2D7+o=;
        b=QV9XuHW6v51jSYr8j+vRSi/p1BcLCdacxlbGAg6NJJA0GgDSEq2hx1bJJf4wBIQtZJ
         wVpErmRBlvBXjRVEKer3aQqynUDHrxB0M19m0Y4/ewuiuhhWOJL6RuwtpBN2aFpxECVA
         AQNBrMgdrpzin/EzPYdsqQpqW4fW8Tu3hBfJlN4NTXvo4XxHNQtlTZNXpJOrZ5f0V0x0
         S+ndT6dI4cvkmT2zoJo2JdDo+vS0s+uQuNln8lXGrb2ELohebBFg1XJpXpReQ+T6hq5V
         9D5B7nZ/GZ0bM+U1+js/sjDNNllnYswnc3WGrgMhfkARuN2gqs+8QnmKgsTpBLNJhPqW
         +wUg==
X-Gm-Message-State: AOAM532EvoczyhbgZ3HfV3fLNBBDQA3k78zb2swJ8uzeH62hkHF0Ge2+
        z+zuy67+1+C5Mo0kvLtLB1dyeCpOUU9u/Q==
X-Google-Smtp-Source: ABdhPJzqERQxqsJS8qCugobqwq5YRFj8zd6rpqPp7wfiF2vp20frNaSkzv+HgBXyo2Cg549b4qkK8g==
X-Received: by 2002:a63:5a64:: with SMTP id k36mr28728668pgm.378.1630457159538;
        Tue, 31 Aug 2021 17:45:59 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id gg22sm3849024pjb.19.2021.08.31.17.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:45:59 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/4] ksmbd: remove unused ksmbd_file_table_flush function
Date:   Wed,  1 Sep 2021 09:45:37 +0900
Message-Id: <20210901004537.45511-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901004537.45511-1-linkinjeon@kernel.org>
References: <20210901004537.45511-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd_file_table_flush is a leftover from SMB1. This function is no longer
needed as SMB1 has been removed from ksmbd.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/vfs_cache.c | 16 ----------------
 fs/ksmbd/vfs_cache.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 92d8c61ffd2a..29c1db66bd0f 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -666,22 +666,6 @@ void ksmbd_free_global_file_table(void)
 	ksmbd_destroy_file_table(&global_ft);
 }
 
-int ksmbd_file_table_flush(struct ksmbd_work *work)
-{
-	struct ksmbd_file	*fp = NULL;
-	unsigned int		id;
-	int			ret;
-
-	read_lock(&work->sess->file_table.lock);
-	idr_for_each_entry(work->sess->file_table.idr, fp, id) {
-		ret = ksmbd_vfs_fsync(work, fp->volatile_id, KSMBD_NO_FID);
-		if (ret)
-			break;
-	}
-	read_unlock(&work->sess->file_table.lock);
-	return ret;
-}
-
 int ksmbd_init_file_table(struct ksmbd_file_table *ft)
 {
 	ft->idr = kzalloc(sizeof(struct idr), GFP_KERNEL);
diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
index 70dfe6a99f13..448576fbe4b7 100644
--- a/fs/ksmbd/vfs_cache.h
+++ b/fs/ksmbd/vfs_cache.h
@@ -152,7 +152,6 @@ void ksmbd_close_session_fds(struct ksmbd_work *work);
 int ksmbd_close_inode_fds(struct ksmbd_work *work, struct inode *inode);
 int ksmbd_init_global_file_table(void);
 void ksmbd_free_global_file_table(void);
-int ksmbd_file_table_flush(struct ksmbd_work *work);
 void ksmbd_set_fd_limit(unsigned long limit);
 
 /*
-- 
2.25.1

