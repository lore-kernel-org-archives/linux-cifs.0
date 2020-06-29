Return-Path: <SRS0=t+Ft=AK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365E4C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1144D2053B
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgF2BF1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Jun 2020 21:05:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6847 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgF2BF1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 28 Jun 2020 21:05:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 666C64504AA81878707F;
        Mon, 29 Jun 2020 09:05:25 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 29 Jun 2020 09:05:16 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <zhangxiaoxu5@huawei.com>, <sfrench@samba.org>,
        <piastryyy@gmail.com>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH] cifs: Fix the target file was deleted when rename failed.
Date:   Sun, 28 Jun 2020 21:06:38 -0400
Message-ID: <20200629010638.3418176-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When xfstest generic/035, we found the target file was deleted
if the rename return -EACESS.

In cifs_rename2, we unlink the positive target dentry if rename
failed with EACESS or EEXIST, even if the target dentry is positived
before rename. Then the existing file was deleted.

We should just delete the target file which created during the
rename.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ce95801e9b66..49c3ea8aa845 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2044,6 +2044,7 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	unsigned int xid;
 	int rc, tmprc;
+	bool new_target = d_really_is_negative(target_dentry);
 
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
@@ -2120,8 +2121,13 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 	 */
 
 unlink_target:
-	/* Try unlinking the target dentry if it's not negative */
-	if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
+	/*
+	 * If the target dentry was created during the rename, try
+	 * unlinking it if it's not negative
+	 */
+	if (new_target &&
+	    d_really_is_positive(target_dentry) &&
+	    (rc == -EACCES || rc == -EEXIST)) {
 		if (d_is_dir(target_dentry))
 			tmprc = cifs_rmdir(target_dir, target_dentry);
 		else
-- 
2.25.4

