Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8228C433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 15:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC12611AD
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 15:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhEDPkC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 May 2021 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhEDPkB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 May 2021 11:40:01 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9690BC061574;
        Tue,  4 May 2021 08:39:06 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id s82so5735238wmf.3;
        Tue, 04 May 2021 08:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WAbDT06lmoDzuztzXgk+cC20Azgq28Piv4t2hW78+jw=;
        b=PLlDcuYBuk89gfluBkMBlgk6z09eLazYQ2YcFLzjVIBujBBLWJIfdmZkezrtRgXPM+
         NDC+gpyZYoP+4BV71tPHcB8/dTA6q1qSINm+zJhL41r1WFSANpZlBeJ5TIu66wCHQafn
         bruQ7V/LBj/5Y5XCjVEsEZEwdkRmjCXJTQx2sQ5W9aPzfxPX4hPyM/wxG9mKTSqMB2aC
         Gqwmg33WF3yti4OajFjrZnt1kYDN5H+/4fFYAYo38QNF80f7ngNUBTRucf8BVGTq56Nv
         wBuCGnRvugXR+yjJqV+0EotoEGW5rLJt75SpZZgfpRPiHY/7kQCyTwO06wQ2H2XcFwS4
         DNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WAbDT06lmoDzuztzXgk+cC20Azgq28Piv4t2hW78+jw=;
        b=bwG0rZVe5JMcEfhCzXh/wNp7FtSfm9cCMlJfmbrAtERkVOqyr6aIquPfEhsCc/cX0f
         OQGMk+B4e7VPvcQ7OLMa2EUiO/aNKnwSyZm4SBJve/dgzUNq9T+DbvJWtiBGlFQ2trdp
         Y+rGeGeoeE3kBONkzGv22ldOJ/fVvE0/Ski2rJCsTbs80bf742RjysLZpu2yypniTrY2
         S8BlzoVs3oGWMzgHH+9UT/y/PTL5NQfRs6678il/06t7bUefeV98S+c0zRbrW3GaKE0Z
         w353DHSBNKh18/wa+vsnOrNKksxOY0XZtc9bxOEfJ49SwJEa85zl5t9bwElx84xUBIlg
         Lrvw==
X-Gm-Message-State: AOAM532g/3MaXbkua+8Px8izWDNWjUVSAlO9xwSbo+bD9Rx5gI+7WI9R
        1G1m7r0+slYhx0cPHELsw8jnaHnNl7IzJO+v
X-Google-Smtp-Source: ABdhPJwV0LzPwoFrsjZGliyjfU3QOeIlZ/d5ErsojeSwGZjVvaEYVNfS3teJDoXg/Z40yCl5moYgXg==
X-Received: by 2002:a1c:1bca:: with SMTP id b193mr28730877wmb.28.1620142745344;
        Tue, 04 May 2021 08:39:05 -0700 (PDT)
Received: from localhost.localdomain ([197.2.237.199])
        by smtp.gmail.com with ESMTPSA id d5sm17166845wrv.43.2021.05.04.08.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 08:39:04 -0700 (PDT)
From:   Khaled ROMDHANI <khaledromdhani216@gmail.com>
To:     sfrench@samba.org
Cc:     Khaled ROMDHANI <khaledromdhani216@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH-V2] fs/cifs: Fix resource leak
Date:   Tue,  4 May 2021 16:38:55 +0100
Message-Id: <20210504153855.26227-1-khaledromdhani216@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The -EIO error return path is leaking memory allocated
to page. Fix this by moving the allocation block after
the check of cifs_forced_shutdown.

Addresses-Coverity: ("Resource leak")
Fixes: 087f757b0129 ("cifs: add shutdown support")
Signed-off-by: Khaled ROMDHANI <khaledromdhani216@gmail.com>
---
V2: Add a fix tag and move the allocation to avoid its failure
in the declaration block as suggested by Dan Carpenter.
V1: Invoke the free_dentry_path before the return.
---
 fs/cifs/link.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 1cbe7ec73728..970fcf2adb08 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -683,12 +683,16 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
 	struct tcon_link *tlink;
 	struct cifs_tcon *pTcon;
 	const char *full_path;
-	void *page = alloc_dentry_path();
+	void *page;
 	struct inode *newinode = NULL;
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
+	page = alloc_dentry_path();
+	if (!page)
+		return -ENOMEM;
+
 	xid = get_xid();
 
 	tlink = cifs_sb_tlink(cifs_sb);
-- 
2.17.1

