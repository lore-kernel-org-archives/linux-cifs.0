Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC66FC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 02:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJRCqG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 22:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJRCqC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 22:46:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC67E17894
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 19:45:58 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mrym94SFdz1P72d;
        Tue, 18 Oct 2022 10:41:13 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 10:45:55 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH] cifs: Fix memory leak when build ntlmssp negotiate blob failed
Date:   Tue, 18 Oct 2022 11:49:16 +0800
Message-ID: <20221018034916.821280-1-zhangxiaoxu5@huawei.com>
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

There is a memory leak when mount cifs:
  unreferenced object 0xffff888166059600 (size 448):
    comm "mount.cifs", pid 51391, jiffies 4295596373 (age 330.596s)
    hex dump (first 32 bytes):
      fe 53 4d 42 40 00 00 00 00 00 00 00 01 00 82 00  .SMB@...........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<0000000060609a61>] mempool_alloc+0xe1/0x260
      [<00000000adfa6c63>] cifs_small_buf_get+0x24/0x60
      [<00000000ebb404c7>] __smb2_plain_req_init+0x32/0x460
      [<00000000bcf875b4>] SMB2_sess_alloc_buffer+0xa4/0x3f0
      [<00000000753a2987>] SMB2_sess_auth_rawntlmssp_negotiate+0xf5/0x480
      [<00000000f0c1f4f9>] SMB2_sess_setup+0x253/0x410
      [<00000000a8b83303>] cifs_setup_session+0x18f/0x4c0
      [<00000000854bd16d>] cifs_get_smb_ses+0xae7/0x13c0
      [<000000006cbc43d9>] mount_get_conns+0x7a/0x730
      [<000000005922d816>] cifs_mount+0x103/0xd10
      [<00000000e33def3b>] cifs_smb3_do_mount+0x1dd/0xc90
      [<0000000078034979>] smb3_get_tree+0x1d5/0x300
      [<000000004371f980>] vfs_get_tree+0x41/0xf0
      [<00000000b670d8a7>] path_mount+0x9b3/0xdd0
      [<000000005e839a7d>] __x64_sys_mount+0x190/0x1d0
      [<000000009404c3b9>] do_syscall_64+0x35/0x80

When build ntlmssp negotiate blob failed, the session setup request
should be freed.

Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a2384509ea84..c930b63bc422 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1531,7 +1531,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 					  &blob_length, ses, server,
 					  sess_data->nls_cp);
 	if (rc)
-		goto out_err;
+		goto out;
 
 	if (use_spnego) {
 		/* BB eventually need to add this */
-- 
2.31.1

