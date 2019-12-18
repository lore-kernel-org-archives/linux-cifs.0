Return-Path: <SRS0=WFxL=2I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB15C43603
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 03:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18ED206D8
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 03:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQNnLXWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLRDE5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Dec 2019 22:04:57 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43354 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLRDE5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Dec 2019 22:04:57 -0500
Received: by mail-oi1-f193.google.com with SMTP id x14so339691oic.10;
        Tue, 17 Dec 2019 19:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qgb6QFyGnQWAwY76V6AQltArKs3hiGbYMFOAjHQ7Svs=;
        b=ZQNnLXWAG1gpFjoRgTPx/Lp6gRQVY27mORHYOTWxiC8xTE4RjEEBVPDF0KB32KW22w
         xcgLD4/459ZHEqr9BrQ5QePTt1K9dbWX+bmGSAzSZi23J1LkbSC4gvrRqyVYtcpAbFvo
         5EhHWbnbTjG9ttjLFqk9/+MAudT8Tt6gS9pwblazzFUuLfyspSF9DU0oPEqKTL7ipUnQ
         /Xo0rzR8fWrzEm1mvlfn3w9oQ728jAubGHsQYXNFnDmtOohNfXxZAoYhFTl6dr6TqTwj
         c8yJEtTUQtMhykwLjel/Ihz8BXyoiHlIN/YtIKwX0ajtWRZdDKXrv+/mi8oCYatqgDIb
         lgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qgb6QFyGnQWAwY76V6AQltArKs3hiGbYMFOAjHQ7Svs=;
        b=CTGUfOOBBUINZdq8SffYPVrr1p4CoIsDs//mnvP3+kXTdJhdvjM01t+3kE/nYsguei
         iGiaK5IZM37ZsvMTz2e0BohvaZ31oh1zT82+CNFej52W5tD/oDqkXdoVrKmNY77hsJhh
         FqVHt3L1UvvgnPtcW4NNOTdyMGAQTgM6K7kSCJ1XfKOHMv5ggtpKbnwSiygiijKtr+qj
         kInXDgTzFT72zl0j/bkjVIAt6I1d8GKc0Gkzeom0M/aIzII1LQIONd9qQaDlMJI9B6KQ
         jLI2S1CG4HMKrnRBvdGd5ObWRR9AODS/dLoQmg5c0DZVB14zrU8p4LVAkf+I9LOLjfJk
         ZPWg==
X-Gm-Message-State: APjAAAW1WbviodndieB9b/iz2QOPg29xV2wWNIHCfw34EC48MWjk2eBn
        ZIWO+7XaEqHHMDYL/sm4MLw=
X-Google-Smtp-Source: APXvYqzYAZy5xUcpNc1N6ZvGZzgwns7EmdgVYLJjjBie4UYpv5fE5SQtY8nULmMb4W7wvw1v+hOV4g==
X-Received: by 2002:aca:2808:: with SMTP id 8mr175315oix.27.1576638296013;
        Tue, 17 Dec 2019 19:04:56 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n20sm341000oie.4.2019.12.17.19.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:04:55 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] cifs: Adjust indentation in smb2_open_file
Date:   Tue, 17 Dec 2019 20:04:51 -0700
Message-Id: <20191218030451.40994-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns:

../fs/cifs/smb2file.c:70:3: warning: misleading indentation; statement
is not part of the previous 'if' [-Wmisleading-indentation]
         if (oparms->tcon->use_resilient) {
         ^
../fs/cifs/smb2file.c:66:2: note: previous statement is here
        if (rc)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 592fafe644bf ("Add resilienthandles mount parm")
Link: https://github.com/ClangBuiltLinux/linux/issues/826
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 8b0b512c5792..afe1f03aabe3 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -67,7 +67,7 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		goto out;
 
 
-	 if (oparms->tcon->use_resilient) {
+	if (oparms->tcon->use_resilient) {
 		/* default timeout is 0, servers pick default (120 seconds) */
 		nr_ioctl_req.Timeout =
 			cpu_to_le32(oparms->tcon->handle_timeout);
-- 
2.24.1

