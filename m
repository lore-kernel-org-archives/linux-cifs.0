Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68177C4167B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJQNmS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJQNmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:42:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9529B4E42B
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:42:14 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrdMv2djvzmV82;
        Mon, 17 Oct 2022 21:37:31 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 21:42:12 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <aaptel@suse.com>
Subject: [PATCH 3/5] cifs: Fix xid leak in cifs_flock()
Date:   Mon, 17 Oct 2022 22:45:23 +0800
Message-ID: <20221017144525.414313-4-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
References: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If not flock, before return -ENOLCK, should free the xid,
otherwise, the xid will be leaked.

Fixes: d0677992d2af ("cifs: add support for flock")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/file.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f6ffee514c34..5b3b308e115c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1885,11 +1885,13 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
-	rc = -EACCES;
 	xid = get_xid();
 
-	if (!(fl->fl_flags & FL_FLOCK))
-		return -ENOLCK;
+	if (!(fl->fl_flags & FL_FLOCK)) {
+		rc = -ENOLCK;
+		free_xid(xid);
+		return rc;
+	}
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);
@@ -1908,8 +1910,9 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 		 * if no lock or unlock then nothing to do since we do not
 		 * know what it is
 		 */
+		rc = -EOPNOTSUPP;
 		free_xid(xid);
-		return -EOPNOTSUPP;
+		return rc;
 	}
 
 	rc = cifs_setlk(file, fl, type, wait_flag, posix_lck, lock, unlock,
-- 
2.31.1

