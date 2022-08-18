Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36FCC00140
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Aug 2022 12:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiHRMvp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 08:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244699AbiHRMvo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 08:51:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BA77C52D
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 05:51:42 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M7l6p2B2fz1N7LP;
        Thu, 18 Aug 2022 20:48:18 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 20:51:32 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>
Subject: [PATCH] cifs: Fix memory leak on the deferred close
Date:   Thu, 18 Aug 2022 21:50:44 +0800
Message-ID: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

xfstests on smb21 report kmemleak as below:

  unreferenced object 0xffff8881767d6200 (size 64):
    comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
    hex dump (first 32 bytes):
      80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c....
      00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v............
    backtrace:
      [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
      [<0000000028b93c82>] __fput+0xff/0x3f0
      [<00000000d8116851>] task_work_run+0x85/0xc0
      [<0000000027e14f9e>] do_exit+0x5e5/0x1240
      [<00000000fb492b95>] do_group_exit+0x58/0xe0
      [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
      [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
      [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

When cancel the deferred close work, we should also cleanup the struct
cifs_deferred_close.

Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/rename/lease break.")
Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/misc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1f2628ffe9d7..87f60f736731 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -737,6 +737,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -766,6 +768,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				cifs_del_deferred_close(cfile);
+
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
 					break;
@@ -799,6 +803,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
 				if (cancel_delayed_work(&cfile->deferred)) {
+					cifs_del_deferred_close(cfile);
+
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 					if (tmp_list == NULL)
 						break;
-- 
2.31.1

