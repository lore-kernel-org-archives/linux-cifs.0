Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE86C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Feb 2022 16:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbiBJQ7f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:59:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiBJQ7e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Feb 2022 11:59:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15A98B8A
        for <linux-cifs@vger.kernel.org>; Thu, 10 Feb 2022 08:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644512374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pCqZxJlMoyLaeOL5jd+79hg80efgkkIPY44VtblTnHI=;
        b=BSnn2xzCY9UaJgxkbGyWEeLly3XSIRStzfyoGwYaMV5W+yk+0BjZI6lf/pe7VNnOKwl9vb
        +/XefEM9yDrqX4ccgaI4GXMYPNrrv6PuScK9rG10Bkumn7nPNlj/Xfe+Qi5Yszalna1Jqa
        dbtz7NRJZ1QGZrs2HzjOhF6YgToXK0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-uMkVpxE2PUG2gsDuvRx3-w-1; Thu, 10 Feb 2022 11:59:32 -0500
X-MC-Unique: uMkVpxE2PUG2gsDuvRx3-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8801B1937FF2;
        Thu, 10 Feb 2022 16:59:31 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-22.bne.redhat.com [10.64.54.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B376C77456;
        Thu, 10 Feb 2022 16:59:29 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: fix double free race when mount fails in cifs_get_root()
Date:   Fri, 11 Feb 2022 02:59:15 +1000
Message-Id: <20220210165915.3253555-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When cifs_get_root() fails during cifs_smb3_do_mount() we call
deactivate_locked_super() which eventually will call delayed_free() which
will free the context.
In this situation we should not proceed to enter the out: section in
cifs_smb3_do_mount() and free the same resources a second time.

[Thu Feb 10 12:59:06 2022] BUG: KASAN: use-after-free in rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022] Read of size 8 at addr ffff888364f4d110 by task swapper/1/0

[Thu Feb 10 12:59:06 2022] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           OE     5.17.0-rc3+ #4
[Thu Feb 10 12:59:06 2022] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 12/17/2019
[Thu Feb 10 12:59:06 2022] Call Trace:
[Thu Feb 10 12:59:06 2022]  <IRQ>
[Thu Feb 10 12:59:06 2022]  dump_stack_lvl+0x5d/0x78
[Thu Feb 10 12:59:06 2022]  print_address_description.constprop.0+0x24/0x150
[Thu Feb 10 12:59:06 2022]  ? rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  kasan_report.cold+0x7d/0x117
[Thu Feb 10 12:59:06 2022]  ? rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  __asan_load8+0x86/0xa0
[Thu Feb 10 12:59:06 2022]  rcu_cblist_dequeue+0x32/0x60
[Thu Feb 10 12:59:06 2022]  rcu_core+0x547/0xca0
[Thu Feb 10 12:59:06 2022]  ? call_rcu+0x3c0/0x3c0
[Thu Feb 10 12:59:06 2022]  ? __this_cpu_preempt_check+0x13/0x20
[Thu Feb 10 12:59:06 2022]  ? lock_is_held_type+0xea/0x140
[Thu Feb 10 12:59:06 2022]  rcu_core_si+0xe/0x10
[Thu Feb 10 12:59:06 2022]  __do_softirq+0x1d4/0x67b
[Thu Feb 10 12:59:06 2022]  __irq_exit_rcu+0x100/0x150
[Thu Feb 10 12:59:06 2022]  irq_exit_rcu+0xe/0x30
[Thu Feb 10 12:59:06 2022]  sysvec_hyperv_stimer0+0x9d/0xc0
...
[Thu Feb 10 12:59:07 2022] Freed by task 58179:
[Thu Feb 10 12:59:07 2022]  kasan_save_stack+0x26/0x50
[Thu Feb 10 12:59:07 2022]  kasan_set_track+0x25/0x30
[Thu Feb 10 12:59:07 2022]  kasan_set_free_info+0x24/0x40
[Thu Feb 10 12:59:07 2022]  ____kasan_slab_free+0x137/0x170
[Thu Feb 10 12:59:07 2022]  __kasan_slab_free+0x12/0x20
[Thu Feb 10 12:59:07 2022]  slab_free_freelist_hook+0xb3/0x1d0
[Thu Feb 10 12:59:07 2022]  kfree+0xcd/0x520
[Thu Feb 10 12:59:07 2022]  cifs_smb3_do_mount+0x149/0xbe0 [cifs]
[Thu Feb 10 12:59:07 2022]  smb3_get_tree+0x1a0/0x2e0 [cifs]
[Thu Feb 10 12:59:07 2022]  vfs_get_tree+0x52/0x140
[Thu Feb 10 12:59:07 2022]  path_mount+0x635/0x10c0
[Thu Feb 10 12:59:07 2022]  __x64_sys_mount+0x1bf/0x210
[Thu Feb 10 12:59:07 2022]  do_syscall_64+0x5c/0xc0
[Thu Feb 10 12:59:07 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[Thu Feb 10 12:59:07 2022] Last potentially related work creation:
[Thu Feb 10 12:59:07 2022]  kasan_save_stack+0x26/0x50
[Thu Feb 10 12:59:07 2022]  __kasan_record_aux_stack+0xb6/0xc0
[Thu Feb 10 12:59:07 2022]  kasan_record_aux_stack_noalloc+0xb/0x10
[Thu Feb 10 12:59:07 2022]  call_rcu+0x76/0x3c0
[Thu Feb 10 12:59:07 2022]  cifs_umount+0xce/0xe0 [cifs]
[Thu Feb 10 12:59:07 2022]  cifs_kill_sb+0xc8/0xe0 [cifs]
[Thu Feb 10 12:59:07 2022]  deactivate_locked_super+0x5d/0xd0
[Thu Feb 10 12:59:07 2022]  cifs_smb3_do_mount+0xab9/0xbe0 [cifs]
[Thu Feb 10 12:59:07 2022]  smb3_get_tree+0x1a0/0x2e0 [cifs]
[Thu Feb 10 12:59:07 2022]  vfs_get_tree+0x52/0x140
[Thu Feb 10 12:59:07 2022]  path_mount+0x635/0x10c0
[Thu Feb 10 12:59:07 2022]  __x64_sys_mount+0x1bf/0x210
[Thu Feb 10 12:59:07 2022]  do_syscall_64+0x5c/0xc0
[Thu Feb 10 12:59:07 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 199edac0cb59..082c21478686 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -919,6 +919,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
+	return root;
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
-- 
2.30.2

