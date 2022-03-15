Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 03:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244993AbiCODpa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Mar 2022 23:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239264AbiCODp3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Mar 2022 23:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D17939153
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 20:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647315856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J6iSnVlXBt4SYBdOmk1bVU3pew3A2k1tmb9UVwBT7Dc=;
        b=anmtr7jzgwPtnEM4ZYiU3Jqe2eUwWv96mVmy/ljkfaf1tRvRCujrcErcFaFrlh/jGEsxtR
        8MlySQwqd3UvbZ+1Y26ghJQlNr3b2yfj2cUEnCab6EvNRRFOM4zsagbLUgVAxsVYQ96BtJ
        pZNqmkAgreIsNRu60YzzFsHkZmv6jts=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-ZSE92j4RP4O-DOMuLJeSnQ-1; Mon, 14 Mar 2022 23:44:13 -0400
X-MC-Unique: ZSE92j4RP4O-DOMuLJeSnQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86375802A6A;
        Tue, 15 Mar 2022 03:44:12 +0000 (UTC)
Received: from thinkpad (vpn2-54-164.bne.redhat.com [10.64.54.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 954084B8D42;
        Tue, 15 Mar 2022 03:44:11 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: we do not need a spinlock around the tree access during umount
Date:   Tue, 15 Mar 2022 13:44:04 +1000
Message-Id: <20220315034404.623539-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove the spinlock around the tree traversal as we are calling possibly
sleeping functions.
We do not need a spinlock here as there will be no modifications to this
tree at this point.

This prevents warnings like this to occur in dmesg:
[  653.774996] BUG: sleeping function called from invalid context at kernel/loc\
king/mutex.c:280
[  653.775088] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1827, nam\
e: umount
[  653.775152] preempt_count: 1, expected: 0
[  653.775191] CPU: 0 PID: 1827 Comm: umount Tainted: G        W  OE     5.17.0\
-rc7-00006-g4eb628dd74df #135
[  653.775195] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-\
1.fc33 04/01/2014
[  653.775197] Call Trace:
[  653.775199]  <TASK>
[  653.775202]  dump_stack_lvl+0x34/0x44
[  653.775209]  __might_resched.cold+0x13f/0x172
[  653.775213]  mutex_lock+0x75/0xf0
[  653.775217]  ? __mutex_lock_slowpath+0x10/0x10
[  653.775220]  ? _raw_write_lock_irq+0xd0/0xd0
[  653.775224]  ? dput+0x6b/0x360
[  653.775228]  cifs_kill_sb+0xff/0x1d0 [cifs]
[  653.775285]  deactivate_locked_super+0x85/0x130
[  653.775289]  cleanup_mnt+0x32c/0x4d0
[  653.775292]  ? path_umount+0x228/0x380
[  653.775296]  task_work_run+0xd8/0x180
[  653.775301]  exit_to_user_mode_loop+0x152/0x160
[  653.775306]  exit_to_user_mode_prepare+0x89/0xd0
[  653.775315]  syscall_exit_to_user_mode+0x12/0x30
[  653.775322]  do_syscall_64+0x48/0x90
[  653.775326]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 187af6e98b44e5d8f25e1d41a92db138eb54416f ("cifs: fix handlecache and multiuser")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 677c02aa8731..6e5246122ee2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -269,7 +269,6 @@ static void cifs_kill_sb(struct super_block *sb)
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	spin_lock(&cifs_sb->tlink_tree_lock);
 	node = rb_first(root);
 	while (node != NULL) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
@@ -283,7 +282,6 @@ static void cifs_kill_sb(struct super_block *sb)
 		mutex_unlock(&cfid->fid_mutex);
 		node = rb_next(node);
 	}
-	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
-- 
2.30.2

