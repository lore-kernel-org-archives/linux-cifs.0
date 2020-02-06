Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98087C33CAC
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 17:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7756A21775
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 17:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBFRRC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 12:17:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:59640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbgBFRRC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 6 Feb 2020 12:17:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9754AAA6;
        Thu,  6 Feb 2020 17:17:00 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: fix mode bits from dir listing when mounted with modefromsid
Date:   Thu,  6 Feb 2020 18:16:55 +0100
Message-Id: <20200206171655.23659-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When mounting with -o modefromsid, the mode bits are stored in an
ACE. Directory enumeration (e.g. ls -l /mnt) triggers an SMB Query Dir
which does not include ACEs in its response. The mode bits in this
case are silently set to a default value of 755 instead.

This patch marks the dentry created during the directory enumeration
as needing re-evaluation (i.e. additional Query Info with ACEs) so
that the mode bits can be properly extracted.

Quick repro:

$ mount.cifs //win19.test/data /mnt -o ...,modefromsid
$ touch /mnt/foo && chmod 751 /mnt/foo
$ stat /mnt/foo
  # reports 751 (OK)
$ sleep 2
  # dentry older than 1s by default get invalidated
$ ls -l /mnt
  # since dentry invalid, ls does a Query Dir
  # and reports foo as 755 (WRONG)

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/readdir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index d17587c2c4ab..ba9dadf3be24 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -196,7 +196,8 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * may look wrong since the inodes may not have timed out by the time
 	 * "ls" does a stat() call on them.
 	 */
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
-- 
2.16.4

