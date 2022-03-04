Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C73C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 00:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiCDAcu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Mar 2022 19:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiCDAct (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Mar 2022 19:32:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 134CF15D38C
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 16:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646353921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IZtIPkwixXGjdp5pi+BZPeRrnNZj3A77qFTd9Yi0jbE=;
        b=ZyKklJAwZzQaPxPqKvQrIWylFYNaGcmfA1a0qbNiI6x1SyFaj935/m9SUteiYvj+bisZou
        b8QkBZUCygWxMh40VXzxpHn0DMlp63jksyrWa6YxOGE5qlL8NEmaiu6zuqd1+TVphPXiA+
        a+ZiygRFr6/9s7jE6lVnPZuEpQAxlF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-glBz7NSaPFOjip2FCzCV-w-1; Thu, 03 Mar 2022 19:31:58 -0500
X-MC-Unique: glBz7NSaPFOjip2FCzCV-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F0B88070F0;
        Fri,  4 Mar 2022 00:31:57 +0000 (UTC)
Received: from thinkpad (vpn2-54-54.bne.redhat.com [10.64.54.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EFD5795B0;
        Fri,  4 Mar 2022 00:31:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix handlecache and multiuser
Date:   Fri,  4 Mar 2022 10:31:49 +1000
Message-Id: <20220304003149.299182-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In multiuser each individual user has their own tcon structure for the
share and thus their own handle for a cached directory.
When we umount such a share we much make sure to release the pinned down dentry
for each such tcon and not just the master tcon.

Otherwise we will get nasty warnings on umount that dentries are still in use:
[ 3459.590047] BUG: Dentry 00000000115c6f41{i=12000000019d95,n=/}  still in use\
 (2) [unmount of cifs cifs]
...
[ 3459.590492] Call Trace:
[ 3459.590500]  d_walk+0x61/0x2a0
[ 3459.590518]  ? shrink_lock_dentry.part.0+0xe0/0xe0
[ 3459.590526]  shrink_dcache_for_umount+0x49/0x110
[ 3459.590535]  generic_shutdown_super+0x1a/0x110
[ 3459.590542]  kill_anon_super+0x14/0x30
[ 3459.590549]  cifs_kill_sb+0xf5/0x104 [cifs]
[ 3459.590773]  deactivate_locked_super+0x36/0xa0
[ 3459.590782]  cleanup_mnt+0x131/0x190
[ 3459.590789]  task_work_run+0x5c/0x90
[ 3459.590798]  exit_to_user_mode_loop+0x151/0x160
[ 3459.590809]  exit_to_user_mode_prepare+0x83/0xd0
[ 3459.590818]  syscall_exit_to_user_mode+0x12/0x30
[ 3459.590828]  do_syscall_64+0x48/0x90
[ 3459.590833]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dca42aa87d30..da6478b39eba 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -253,6 +253,9 @@ static void cifs_kill_sb(struct super_block *sb)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct cached_fid *cfid;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct tcon_link *tlink;
 
 	/*
 	 * We ned to release all dentries for the cached directories
@@ -262,17 +265,21 @@ static void cifs_kill_sb(struct super_block *sb)
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (tcon) {
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	node = rb_first(root);
+	while (node != NULL) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
 		cfid = &tcon->crfid;
 		mutex_lock(&cfid->fid_mutex);
 		if (cfid->dentry) {
-
 			dput(cfid->dentry);
 			cfid->dentry = NULL;
 		}
 		mutex_unlock(&cfid->fid_mutex);
+		node = rb_next(node);
 	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
-- 
2.30.2

