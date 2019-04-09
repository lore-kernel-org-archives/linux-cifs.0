Return-Path: <SRS0=suyG=SL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B9FC10F0E
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 13:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76AF2084C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 13:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfDINRX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfDINRX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Apr 2019 09:17:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04260C066462;
        Tue,  9 Apr 2019 13:17:23 +0000 (UTC)
Received: from dhcp-12-126.nay.redhat.com (dhcp-12-126.nay.redhat.com [10.66.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89DFB619C8;
        Tue,  9 Apr 2019 13:17:21 +0000 (UTC)
From:   XiaoLi Feng <xifeng@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Subject: [PATCH v1] CIFS: display noacl and locallease in the mount options
Date:   Tue,  9 Apr 2019 21:17:16 +0800
Message-Id: <20190409131716.15212-1-xifeng@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 09 Apr 2019 13:17:23 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>

The mount option noacl and locallease aren't shown in /proc/mounts
even if they are mounted successfully. Now display them.

Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
---
 fs/cifs/cifsfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f9b71c12cc9f..44dbace210d2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -503,6 +503,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",unix");
 	else
 		seq_puts(s, ",nounix");
+	if (tcon->local_lease)
+		seq_puts(s, ",locallease");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
 		seq_puts(s, ",nodfs");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
@@ -535,6 +537,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",dynperm");
 	if (root->d_sb->s_flags & SB_POSIXACL)
 		seq_puts(s, ",acl");
+	else
+		seq_puts(s, ",noacl");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
 		seq_puts(s, ",mfsymlinks");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
-- 
2.18.1

