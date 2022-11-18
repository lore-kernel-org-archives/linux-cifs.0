Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A570FC43219
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 02:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbiKRCHu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Nov 2022 21:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240836AbiKRCHs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Nov 2022 21:07:48 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAE18A155
        for <linux-cifs@vger.kernel.org>; Thu, 17 Nov 2022 18:07:44 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ND0TW75l8zJnp1;
        Fri, 18 Nov 2022 10:04:31 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 10:07:42 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2] cifs: Fix OOB read in parse_server_interfaces()
Date:   Fri, 18 Nov 2022 11:12:22 +0800
Message-ID: <20221118031222.3072694-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
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

There is a OOB read in when decode the server interfaces response:

  BUG: KASAN: slab-out-of-bounds in parse_server_interfaces+0x9ca/0xb80
  Read of size 4 at addr ffff8881711f2f98 by task mount.cifs/1402

  CPU: 6 PID: 1402 Comm: mount.cifs Not tainted 6.1.0-rc5+ #69
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_report+0x171/0x472
   kasan_report+0xad/0x130
   kasan_check_range+0x145/0x1a0
   parse_server_interfaces+0x9ca/0xb80
   SMB3_request_interfaces+0x174/0x1e0
   smb3_qfs_tcon+0x150/0x2a0
   mount_get_conns+0x218/0x750
   cifs_mount+0x103/0xd00
   cifs_smb3_do_mount+0x1dd/0xcb0
   smb3_get_tree+0x1d5/0x300
   vfs_get_tree+0x41/0xf0
   path_mount+0x9b3/0xdd0
   __x64_sys_mount+0x190/0x1d0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

  Allocated by task 1402:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   __kasan_kmalloc+0x7a/0x90
   __kmalloc_node_track_caller+0x60/0x140
   kmemdup+0x22/0x50
   SMB2_ioctl+0x58d/0x5d0
   SMB3_request_interfaces+0xcd/0x1e0
   smb3_qfs_tcon+0x150/0x2a0
   mount_get_conns+0x218/0x750
   cifs_mount+0x103/0xd00
   cifs_smb3_do_mount+0x1dd/0xcb0
   smb3_get_tree+0x1d5/0x300
   vfs_get_tree+0x41/0xf0
   path_mount+0x9b3/0xdd0
   __x64_sys_mount+0x190/0x1d0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

It can be reproduce with mount.cifs over rdma.

When decode ioctl(FSCTL_QUERY_NETWORK_INTERFACE_INFO) response complete,
still try to decode the 'p->Next' check whether has interface not decode.
Since no more data in the response, then OOB read occurred.

Let's just check the bytes still not decode to determine whether has
uncomplete interface in the response.

Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
v2: Update commit message and fixes tag.

 fs/cifs/smb2ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 880cd494afea..39c7bee87556 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -673,8 +673,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		goto out;
 	}
 
-	/* Azure rounds the buffer size up 8, to a 16 byte boundary */
-	if ((bytes_left > 8) || p->Next)
+	if (bytes_left > 0)
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
 
-- 
2.31.1

