Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C71E95A95
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 15:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346469AbjJIPMP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346602AbjJIPMO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Oct 2023 11:12:14 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3FAC5
        for <linux-cifs@vger.kernel.org>; Mon,  9 Oct 2023 08:12:11 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-694f3444f94so3769285b3a.2
        for <linux-cifs@vger.kernel.org>; Mon, 09 Oct 2023 08:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864330; x=1697469130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXqQj5ZdFP/STQ5l2a76yrfh8IP312G+9wICnwyUgMM=;
        b=s1dmrxwwNOpkE+7O/sfsutnNOIAsbVwF446qiFHfb7nuiOZ0cuYpDXyxGv8k+NeBZe
         GgVUap+FU9QxPySg+N4Q94KfK/ioodTfoo4Un+4MhAzukLJdWm0Nih9zCk/d/NHU1PJw
         b3ka5tT45Od/oU0mmmrU1cvpbWgkUB6NyfrnFjzFehjP+bX8qdC6dyrTCv8k9aD0GTtM
         ZVHTc301v9L81RazdzwdDFlSUGoOZ6I9iQm4zUiQE/xfNR8e1+sNy2zwI315DdGjdax1
         e3B9QtWSEw0hLmGInWAIiVbtmOJ4Xqk6tYx2FcrZm3F8Wu15yY57meJ5Tj79TJvZNXSF
         tWOg==
X-Gm-Message-State: AOJu0Yz/Xw0ElZ/Jx7co2aQSW7izjM4GxuQue1RPBqpiHrLCijuijS8K
        F/qNiE8G/gbP6oLbxRfTtiMZsLTB2tA=
X-Google-Smtp-Source: AGHT+IG4SsQFIPeKnabQ4uG9xsi4zDrYogdGch1PQQ6iRg46QXIfrPv+G8iHs16xiDa8BSJ8NTJAFg==
X-Received: by 2002:a17:90b:1d81:b0:274:84e4:4ef8 with SMTP id pf1-20020a17090b1d8100b0027484e44ef8mr15262084pjb.32.1696864330195;
        Mon, 09 Oct 2023 08:12:10 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id mp3-20020a17090b190300b00267d9f4d340sm10529284pjb.44.2023.10.09.08.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:12:09 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [v2 PATCH] ksmbd: not allow to open file if delelete on close bit is set
Date:   Tue, 10 Oct 2023 00:11:50 +0900
Message-Id: <20231009151153.7360-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cthon test fail with the following error.

check for proper open/unlink operation
nfsjunk files before unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
./nfs2y8Jm9 open; unlink ret = 0
nfsjunk files after unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
data compare ok
nfsjunk files after close:
  ls: cannot access './nfs2y8Jm9': No such file or directory
special tests failed

Cthon expect to second unlink failure when file is already unlinked.
ksmbd can not allow to open file if flags of ksmbd inode is set with
S_DEL_ON_CLS flags.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   return STATUS_DELETE_PENDING error response instead of STATUS_OBJECT_NAME_INVALID. 
 fs/smb/server/vfs_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c4b80ab7df74..1c5c39733652 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -106,7 +106,7 @@ int ksmbd_query_inode_status(struct inode *inode)
 	ci = __ksmbd_inode_lookup(inode);
 	if (ci) {
 		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & S_DEL_PENDING)
+		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
 			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
 		atomic_dec(&ci->m_count);
 	}
@@ -116,7 +116,7 @@ int ksmbd_query_inode_status(struct inode *inode)
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & S_DEL_PENDING);
+	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
-- 
2.25.1

