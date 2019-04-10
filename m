Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D42C10F0E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 01:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DEA52084F
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 01:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfDJBmD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 21:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfDJBmD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Apr 2019 21:42:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90848307E055;
        Wed, 10 Apr 2019 01:42:03 +0000 (UTC)
Received: from dhcp-12-126.nay.redhat.com (dhcp-12-126.nay.redhat.com [10.66.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6581061995;
        Wed, 10 Apr 2019 01:42:02 +0000 (UTC)
From:   XiaoLi Feng <xifeng@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Subject: [PATCH v2] CIFS: display noacl in the mount options
Date:   Wed, 10 Apr 2019 09:41:58 +0800
Message-Id: <20190410014158.27517-1-xifeng@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 10 Apr 2019 01:42:03 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>

The mount option noacl aren't shown in /proc/mounts
even if they are mounted successfully. And smb2.0+
don't support ACL. Display noacl acquiescently if ACL
is unsupported.

Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f9b71c12cc9f..80ee4fbcd25b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -535,6 +535,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
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

