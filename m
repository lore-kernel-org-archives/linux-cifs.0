Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232F7C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Apr 2022 23:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiDLXWC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiDLXVz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 19:21:55 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C223BAC
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 15:57:57 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id n18so347557plg.5
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 15:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6fpi9+6i2JTacQ7rMNVJ9Obj/8AzF4nmEWWPzoLmxKk=;
        b=PjeQbfiQhKGOIw0Dspk8kzqyJNjOWx/BAFR3VFGsWYATCc0LGMPzTSxy6rNxehYu0d
         c9eF/JoSOn1msDFcGSeihwXuI/27iiQcQt9jFOLcRY802/rpAxB5w3ex2U1L7jIuwFFN
         efsK5RsZ8llVc1gOW0uDVKWaiIm48kNK/1sESmlih0Rb7x98TkZnHed+bHLhZTOpBH/Y
         najhBbG8kC4cn1Fsnc7FZUc/teeGjtHG2iZ6kJl8iLPVukZLGPeUWjdm1lqrgi4ytwfY
         AmW0axlnQjcv1NG4McjYQxSsRo5Slc4xkOmuy+ec9PNRfNJaxaz0DcXGJM5kwCI/AF6a
         9MSg==
X-Gm-Message-State: AOAM531m1B2ClFT/klnN80Z0StJyXi5DuP370m3hjrrYCqHmmlTQkZPG
        hIP18M0C+Q16pwOYowEZ1hfOYh02oxKgcg==
X-Google-Smtp-Source: ABdhPJxwg/O38XteeYp6rzZLQBf5dQkehcge1LubKB2iqQ/HhUAi4tqEXMa5IMl7zn7CE8fbaxDkfA==
X-Received: by 2002:a17:90b:1d04:b0:1c7:b10f:e33d with SMTP id on4-20020a17090b1d0400b001c7b10fe33dmr7591940pjb.165.1649804276966;
        Tue, 12 Apr 2022 15:57:56 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m6-20020aa79006000000b00505bf6f2b36sm8522337pfo.205.2022.04.12.15.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:57:56 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH RESEND] ksmbd: increment reference count of parent fp
Date:   Wed, 13 Apr 2022 07:57:43 +0900
Message-Id: <20220412225743.5590-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add missing increment reference count of parent fp in
ksmbd_lookup_fd_inode().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c   | 2 ++
 fs/ksmbd/vfs_cache.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e38fb68ded21..62cc0f95ab87 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5758,8 +5758,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
 			pr_err("parent dir is opened with delete access\n");
+			ksmbd_fd_put(work, parent_fp);
 			return -ESHARE;
 		}
+		ksmbd_fd_put(work, parent_fp);
 	}
 next:
 	return smb2_rename(work, fp, user_ns, rename_info,
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 0974d2e972b9..c4d59d2735f0 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -496,6 +496,7 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
+			lfp = ksmbd_fp_get(lfp);
 			read_unlock(&ci->m_lock);
 			return lfp;
 		}
-- 
2.25.1

