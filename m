Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C919C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 00:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C146109D
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 00:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhIGAIB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 20:08:01 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:55966 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhIGAIB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 20:08:01 -0400
Received: by mail-pj1-f42.google.com with SMTP id i13so5148674pjv.5
        for <linux-cifs@vger.kernel.org>; Mon, 06 Sep 2021 17:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ucOG/xB0xoB4J/wP5D+elrrblfPP9rByEVn07YtPYmU=;
        b=EFLsFs2QNv4N8QFB/vLuZNu6tZ1TsJnhXjjlcVYXH5lVtWa0R1lprRZvQjMeG9GbFK
         xwXotV43dFBhnZdag6NpOq+bVaeW4GKG4c9c65JdSFl5fyHL0oEPAJnkXCFLM+p8aW3y
         FxBgGu0IYdkuBK129pjDmzFoWOlJdpZ4v+znvNIM0xEzGaYvVbmikTjxO7BCa/5lmOXN
         1jxln3A6t5e7Jef/dBwXYT0QQ3+bL6BKMtowz46mUbM+u0NjQMpevGY5fCxISiaoFWTK
         lIUz/FxVWeNkinYqEv3/q6JnyVzAQKX56uL/glRs8/9B3WJPMIIKTfjs5ylE983ATp4F
         vHMA==
X-Gm-Message-State: AOAM530XI+xk+dA36TDPx2NJ6HosvzW88WZnk3yg7RkyzH73R3Gz1i6l
        Kz/kmairBS5xvrX6gO0ucZbeQIhvv+sAtg==
X-Google-Smtp-Source: ABdhPJxv+JFVZ1VwTTaCUpMgjYGYyd4ckSEPmpfTFKJMpwSqU6zy0f6dZZ8+H1M0pRcgNm0CLXLJbA==
X-Received: by 2002:a17:90a:420c:: with SMTP id o12mr1548547pjg.101.1630973215671;
        Mon, 06 Sep 2021 17:06:55 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id cq8sm438029pjb.31.2021.09.06.17.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 17:06:55 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: fix read of uninitialized variable ret in set_file_basic_info
Date:   Tue,  7 Sep 2021 09:06:25 +0900
Message-Id: <20210907000626.14385-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Addresses-Coverity reported Uninitialized variables warninig :

/fs/ksmbd/smb2pdu.c: 5525 in set_file_basic_info()
5519                    if (!rc) {
5520                            inode->i_ctime = ctime;
5521                            mark_inode_dirty(inode);
5522                    }
5523                    inode_unlock(inode);
5524            }
>>>     CID 1506805:  Uninitialized variables  (UNINIT)
>>>     Using uninitialized value "rc".
5525            return rc;
5526     }
5527
5528     static int set_file_allocation_info(struct ksmbd_work *work,
5529                                 struct ksmbd_file *fp, char *buf)
5530     {

Addresses-Coverity: ("Uninitialized variable")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 745d3f5eac09..56ebd3d7dc35 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5449,7 +5449,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	struct file *filp;
 	struct inode *inode;
 	struct user_namespace *user_ns;
-	int rc;
+	int rc = 0;
 
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
-- 
2.25.1

