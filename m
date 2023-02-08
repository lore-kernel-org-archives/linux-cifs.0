Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022FBC636CD
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Feb 2023 02:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBHCH3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Feb 2023 21:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBHCH3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Feb 2023 21:07:29 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0634530EB2
        for <linux-cifs@vger.kernel.org>; Tue,  7 Feb 2023 18:07:17 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6D9C77FE0A;
        Wed,  8 Feb 2023 02:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675822035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QJfZ7xZqQVsHVSCGzuOv0Y6Ph5SmIkrZuldywreSPcw=;
        b=v7xDHiIw4SPwD/B2zg5phcwkj2ahtK3tt2M1iK8ABCNyhjV9zHVYuexGg5dV7tdZPnQJEJ
        gGS2QYZRv28sN5iSMbLU95dD/V2bZKu5NdPSw+NeXoYww94i8+wfIdWxu57Rloeh9I41aA
        U/Pxvo0a6Z7+OZXaihhFEpdVU2BuY8A+jBnS2sr/tSbjGrSRjZmxsdyC9fry5INk0ghY42
        RrvB5caSDRa7E0xj1LkcVGViANSOvNs1CjvDAMIMp3/DsUCoplFdmu6Gmwmse1oS4II+RU
        CwWYYl6KQTA6qlx6FSYGU1qKnVwtoDir3WNfIXVdjzMnuUw0mC2jPE59wnkV2w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: fix UAF in refresh_cache_worker()
Date:   Tue,  7 Feb 2023 23:06:47 -0300
Message-Id: <20230208020648.30073-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The lifetime of DFS root sessions are managed by DFS cache in a
per-mount basis, therefore ensure that the refresh cache worker is
done before putting the DFS root sessions of specific superblock in
cifs_umount().

This fixes below UAF catched by KASAN

[ 379.946955] BUG: KASAN: use-after-free in __refresh_tcon.isra.0+0x10b/0xc10 [cifs]
[ 379.947642] Read of size 8 at addr ffff888018f57030 by task kworker/u4:3/56
[ 379.948096]
[ 379.948208] CPU: 0 PID: 56 Comm: kworker/u4:3 Not tainted 6.2.0-rc7-lku #23
[ 379.948661] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.16.0-0-gd239552-rebuilt.opensuse.org 04/01/2014
[ 379.949368] Workqueue: cifs-dfscache refresh_cache_worker [cifs]
[ 379.949942] Call Trace:
[ 379.950113] <TASK>
[ 379.950260] dump_stack_lvl+0x50/0x67
[ 379.950510] print_report+0x16a/0x48e
[ 379.950759] ? __virt_addr_valid+0xd8/0x160
[ 379.951040] ? __phys_addr+0x41/0x80
[ 379.951285] kasan_report+0xdb/0x110
[ 379.951533] ? __refresh_tcon.isra.0+0x10b/0xc10 [cifs]
[ 379.952056] ? __refresh_tcon.isra.0+0x10b/0xc10 [cifs]
[ 379.952585] __refresh_tcon.isra.0+0x10b/0xc10 [cifs]
[ 379.953096] ? __pfx___refresh_tcon.isra.0+0x10/0x10 [cifs]
[ 379.953637] ? __pfx___mutex_lock+0x10/0x10
[ 379.953915] ? lock_release+0xb6/0x720
[ 379.954167] ? __pfx_lock_acquire+0x10/0x10
[ 379.954443] ? refresh_cache_worker+0x34e/0x6d0 [cifs]
[ 379.954960] ? __pfx_wb_workfn+0x10/0x10
[ 379.955239] refresh_cache_worker+0x4ad/0x6d0 [cifs]
[ 379.955755] ? __pfx_refresh_cache_worker+0x10/0x10 [cifs]
[ 379.956323] ? __pfx_lock_acquired+0x10/0x10
[ 379.956615] ? read_word_at_a_time+0xe/0x20
[ 379.956898] ? lockdep_hardirqs_on_prepare+0x12/0x220
[ 379.957235] process_one_work+0x535/0x990
[ 379.957509] ? __pfx_process_one_work+0x10/0x10
[ 379.957812] ? lock_acquired+0xb7/0x5f0
[ 379.958069] ? __list_add_valid+0x37/0xd0
[ 379.958341] ? __list_add_valid+0x37/0xd0
[ 379.958611] worker_thread+0x8e/0x630
[ 379.958861] ? __pfx_worker_thread+0x10/0x10
[ 379.959148] kthread+0x17d/0x1b0
[ 379.959369] ? __pfx_kthread+0x10/0x10
[ 379.959630] ret_from_fork+0x2c/0x50
[ 379.959879] </TASK>

Fixes: 6916881f443f ("cifs: fix refresh of cached referrals")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index ac86bd0ebd63..498e71f6114b 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1149,14 +1149,21 @@ void dfs_cache_put_refsrv_sessions(const uuid_t *mount_id)
 	if (!mount_id || uuid_is_null(mount_id))
 		return;
 
+	cancel_delayed_work_sync(&refresh_task);
+
 	mutex_lock(&mount_group_list_lock);
 	mg = find_mount_group_locked(mount_id);
 	if (IS_ERR(mg)) {
 		mutex_unlock(&mount_group_list_lock);
-		return;
+		goto out_requeue;
 	}
 	mutex_unlock(&mount_group_list_lock);
 	kref_put(&mg->refcount, mount_group_release);
+
+out_requeue:
+	spin_lock(&cache_ttl_lock);
+	queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
+	spin_unlock(&cache_ttl_lock);
 }
 
 /* Extract share from DFS target and return a pointer to prefix path or NULL */
-- 
2.39.1

