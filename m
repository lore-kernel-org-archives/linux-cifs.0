Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84423C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 00:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiDUAIz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 20:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376861AbiDUAIx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 20:08:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE62F14015
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 17:06:04 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4BC3B7FC9E;
        Thu, 21 Apr 2022 00:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1650499561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oMuqpZBMNR6OGZj24NsBu0gqrdUPpp6dE9LjNd/DE4E=;
        b=KYTn2WKLA/8O9Ntffus/Pyy8GwJQJgEXmXsqyjLdvVySNTiKkbldvWoxyGtQ4o13HdF/pT
        oMzwsaOjqay0NsfslsfEgRYZvfdaqmfbnWwDLJGXFy38zfQ6fRWdfpH+hklsBmPPo7Gfyg
        45IghFxGyBuL3YKYahLz8yuwJxmD3XmJT/6hs/sDDqhs/578LbQHdn9I+9oGu8EJTvVuyV
        mDTM8AG+dfNkHLQJP6Iqkya2ZwE6jhcjINbJdJa4U8D2LwC/fgm5DuMqKvVBY+TSEwsunD
        gktgENGBZ9AEfXkVoKThSClfz49gsvmINdnW0TP0l1uJqT+Be887RyRkxkdSdQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: fix NULL ptr dereference in refresh_mounts()
Date:   Wed, 20 Apr 2022 21:05:45 -0300
Message-Id: <20220421000546.5129-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Either mount(2) or automount might not have server->origin_fullpath
set yet while refresh_cache_worker() is attempting to refresh DFS
referrals.  Add missing NULL check and locking around it.

This fixes bellow crash:

[ 1070.276835] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
[ 1070.277676] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[ 1070.278219] CPU: 1 PID: 8506 Comm: kworker/u8:1 Not tainted 5.18.0-rc3 #10
[ 1070.278701] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
[ 1070.279495] Workqueue: cifs-dfscache refresh_cache_worker [cifs]
[ 1070.280044] RIP: 0010:strcasecmp+0x34/0x150
[ 1070.280359] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
[ 1070.281729] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
[ 1070.282114] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
[ 1070.282691] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1070.283273] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
[ 1070.283857] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
[ 1070.284436] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
[ 1070.284990] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
[ 1070.285625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.286100] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
[ 1070.286683] Call Trace:
[ 1070.286890]  <TASK>
[ 1070.287070]  refresh_cache_worker+0x895/0xd20 [cifs]
[ 1070.287475]  ? __refresh_tcon.isra.0+0xfb0/0xfb0 [cifs]
[ 1070.287905]  ? __lock_acquire+0xcd1/0x6960
[ 1070.288247]  ? is_dynamic_key+0x1a0/0x1a0
[ 1070.288591]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[ 1070.289012]  ? lock_downgrade+0x6f0/0x6f0
[ 1070.289318]  process_one_work+0x7bd/0x12d0
[ 1070.289637]  ? worker_thread+0x160/0xec0
[ 1070.289970]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 1070.290318]  ? _raw_spin_lock_irq+0x5e/0x90
[ 1070.290619]  worker_thread+0x5ac/0xec0
[ 1070.290891]  ? process_one_work+0x12d0/0x12d0
[ 1070.291199]  kthread+0x2a5/0x350
[ 1070.291430]  ? kthread_complete_and_exit+0x20/0x20
[ 1070.291770]  ret_from_fork+0x22/0x30
[ 1070.292050]  </TASK>
[ 1070.292223] Modules linked in: bpfilter cifs cifs_arc4 cifs_md4
[ 1070.292765] ---[ end trace 0000000000000000 ]---
[ 1070.293108] RIP: 0010:strcasecmp+0x34/0x150
[ 1070.293471] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
[ 1070.297718] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
[ 1070.298622] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
[ 1070.299428] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1070.300296] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
[ 1070.301204] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
[ 1070.301932] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
[ 1070.302645] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
[ 1070.303462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.304131] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
[ 1070.305004] Kernel panic - not syncing: Fatal exception
[ 1070.305711] Kernel Offset: disabled
[ 1070.305971] ---[ end Kernel panic - not syncing: Fatal exception ]---

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c   |  2 ++
 fs/cifs/dfs_cache.c | 19 ++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 902e8c6c0f9c..2c24d433061a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3675,9 +3675,11 @@ static void setup_server_referral_paths(struct mount_ctx *mnt_ctx)
 {
 	struct TCP_Server_Info *server = mnt_ctx->server;
 
+	mutex_lock(&server->refpath_lock);
 	server->origin_fullpath = mnt_ctx->origin_fullpath;
 	server->leaf_fullpath = mnt_ctx->leaf_fullpath;
 	server->current_fullpath = mnt_ctx->leaf_fullpath;
+	mutex_unlock(&server->refpath_lock);
 	mnt_ctx->origin_fullpath = mnt_ctx->leaf_fullpath = NULL;
 }
 
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 30e040da4f09..956f8e5cf3e7 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1422,12 +1422,14 @@ static int refresh_tcon(struct cifs_ses **sessions, struct cifs_tcon *tcon, bool
 	struct TCP_Server_Info *server = tcon->ses->server;
 
 	mutex_lock(&server->refpath_lock);
-	if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
-		__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
+	if (server->origin_fullpath) {
+		if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
+							server->origin_fullpath))
+			__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
+		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
+	}
 	mutex_unlock(&server->refpath_lock);
 
-	__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
-
 	return 0;
 }
 
@@ -1530,11 +1532,14 @@ static void refresh_mounts(struct cifs_ses **sessions)
 		list_del_init(&tcon->ulist);
 
 		mutex_lock(&server->refpath_lock);
-		if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
-			__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
+		if (server->origin_fullpath) {
+			if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
+								server->origin_fullpath))
+				__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
+			__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
+		}
 		mutex_unlock(&server->refpath_lock);
 
-		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
 		cifs_put_tcon(tcon);
 	}
 }
-- 
2.35.3

