Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5448BC433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Apr 2021 22:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26572611AE
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Apr 2021 22:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhDVWOv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Apr 2021 18:14:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:48364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVWOv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Apr 2021 18:14:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F032AFEA
        for <linux-cifs@vger.kernel.org>; Thu, 22 Apr 2021 22:14:15 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>
Subject: [PATCH] cifs: fix leak in cifs_smb3_do_mount() ctx
Date:   Fri, 23 Apr 2021 00:14:03 +0200
Message-Id: <20210422221403.13617-1-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs_smb3_do_mount() calls smb3_fs_context_dup() and then
cifs_setup_volume_info(). The latter's subsequent smb3_parse_devname()
call overwrites the cifs_sb->ctx->UNC string already dup'ed by
smb3_fs_context_dup(), resulting in a leak. E.g.

unreferenced object 0xffff888002980420 (size 32):
  comm "mount", pid 160, jiffies 4294892541 (age 30.416s)
  hex dump (first 32 bytes):
    5c 5c 31 39 32 2e 31 36 38 2e 31 37 34 2e 31 30  \\192.168.174.10
    34 5c 72 61 70 69 64 6f 2d 73 68 61 72 65 00 00  4\rapido-share..
  backtrace:
    [<00000000069e12f6>] kstrdup+0x28/0x50
    [<00000000b61f4032>] smb3_fs_context_dup+0x127/0x1d0 [cifs]
    [<00000000c6e3e3bf>] cifs_smb3_do_mount+0x77/0x660 [cifs]
    [<0000000063467a6b>] smb3_get_tree+0xdf/0x220 [cifs]
    [<00000000716f731e>] vfs_get_tree+0x1b/0x90
    [<00000000491d3892>] path_mount+0x62a/0x910
    [<0000000046b2e774>] do_mount+0x50/0x70
    [<00000000ca7b64dd>] __x64_sys_mount+0x81/0xd0
    [<00000000b5122496>] do_syscall_64+0x33/0x40
    [<000000002dd397af>] entry_SYSCALL_64_after_hwframe+0x44/0xae

This change is a bandaid until the cifs_setup_volume_info() TODO and
error handling issues are resolved.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 fs/cifs/cifsfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5ddd20b62484..34c125798ad3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -834,6 +834,12 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
+	/* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
+	kfree(cifs_sb->ctx->UNC);
+	cifs_sb->ctx->UNC = NULL;
+	kfree(cifs_sb->ctx->prepath);
+	cifs_sb->ctx->prepath = NULL;
+
 	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
 	if (rc) {
 		root = ERR_PTR(rc);
-- 
2.26.2

