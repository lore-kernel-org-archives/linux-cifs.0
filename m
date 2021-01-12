Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D99C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jan 2021 09:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCA92076A
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jan 2021 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbhALJOc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729821AbhALJOc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jan 2021 04:14:32 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC63C061786;
        Tue, 12 Jan 2021 01:13:52 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id s15so1062710plr.9;
        Tue, 12 Jan 2021 01:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lyXow/3PC7QTBK6uhoVlenZ4U54g3gv/53mAMDOeC9U=;
        b=h7JG850Vtnv/nQBRiK4B/cIsS1GNe5+A41CC4vmBOFdypDjFjtF6SNbarNmEVSQZAw
         f/Bo1DsX/chTWznMw4Nu5gaarXkbSA2EPvTUAW77oP2y1iTIRwBxAU3dyRfWMxORfAwF
         QGVtr0Fa92UUGu8tKjINM907vEVcf08RHki3G7cMMNbKlRfeZ5iuhQiermbidVq2LSKy
         us1Bp1D0+pgZ3Vdl+xnVUOUuXZOSp/vUWM9zYZx38iAi6crKd8SiSaK/y+2lHYpHP2sp
         owszV2lbrTKTnTDR1LuZ3gIghKLdEKtQLRGcISaYXUjSvPgolDegYj0pJPk4BTvsFiEQ
         JOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lyXow/3PC7QTBK6uhoVlenZ4U54g3gv/53mAMDOeC9U=;
        b=g+YgnpHfdkrCpBR+kCqGKQVsjvjfYomZmZuXLcjzWrHQalWOdefQNap/hvzvrIzh6X
         HZnP+tclSK6cd2LDbt4hhbiXnVD0IefVm39EmFa45CqppLskPW5WdHceLCl4vmhgIri9
         qzXa6jYZ3aCQyXzv30j8hkmY73tq7nrV3KhAFbkBoUMZaVIFNy/wCQpwUHwQcc4mSEwn
         afLAU89qdb95P3tsaVtNbx7YnZvpyiAImg4AFq2Qx3j5X5JDQXeO7vtR+HGlT7ZQFZSW
         5oToZbBz5uZL1MAM0x481s6B4SMxt0hzozryB0z+yHY3etHfoqHTZhyC4WoKXYnh0gt3
         jSrA==
X-Gm-Message-State: AOAM533nZM3e1grJQXhzKhKUqi4EloIpvvRWuLqyFa2gOc33qaHimGU/
        kyDBHldLnXtYXGiHEqTnCKA=
X-Google-Smtp-Source: ABdhPJw5P9XSSSVDXoCDLeXI7bKGWp6EU0dOa5n/b76hxexr1KLz3hAO+2vjD90uRqX65Sg3Ci+b8w==
X-Received: by 2002:a17:902:8c8f:b029:dc:425c:e274 with SMTP id t15-20020a1709028c8fb02900dc425ce274mr3786720plo.17.1610442831768;
        Tue, 12 Jan 2021 01:13:51 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id g5sm2296013pfr.87.2021.01.12.01.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:13:51 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] fs: cifs: remove unneeded variable in smb3_fs_context_dup
Date:   Tue, 12 Jan 2021 01:13:40 -0800
Message-Id: <20210112091340.7500-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

'rc' in smb3_fs_context_dup is not used and can be removed.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 fs/cifs/fs_context.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0afccbbed2e6..076bcadc756a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -303,8 +303,6 @@ do {									\
 int
 smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx)
 {
-	int rc = 0;
-
 	memcpy(new_ctx, ctx, sizeof(*ctx));
 	new_ctx->prepath = NULL;
 	new_ctx->mount_options = NULL;
@@ -327,7 +325,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	DUP_CTX_STR(nodename);
 	DUP_CTX_STR(iocharset);
 
-	return rc;
+	return 0;
 }
 
 static int
-- 
2.17.1

