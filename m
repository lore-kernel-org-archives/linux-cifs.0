Return-Path: <SRS0=zgNb=YW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFA8CA9EAE
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 14:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1DF20717
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 14:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="U7Lb79z+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbfJ2OtU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Oct 2019 10:49:20 -0400
Received: from mx.cjr.nz ([51.158.111.142]:47474 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389398AbfJ2OtU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 29 Oct 2019 10:49:20 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D7FAD80C12;
        Tue, 29 Oct 2019 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1572360556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k07hK8uevKJ+ds39pgXe4XqxbgGcv5Mds/KQPbYbEqk=;
        b=U7Lb79z+LO61kEf41I4ljw6g3MnaThDS0E6NWYlHO5aW1L8jVz8ePp8hOv7/pcV1owUBH1
        d0xAHCpu/83Q4aN3CP3j4xcsmZkiNvICqu9J3Lf1EKqxv2pDX1rEf1CGWZx7CSnR8E/Atl
        3HWwAw9po7km73rRzKCAGmwmy//0i8cv+noNmp33USg5mckUyyGFfaiOekX3Os1YO87qvY
        +OMg2cArUVMbOJnNEwJeL6Rup7eE5ERx3RVfv5jadbquxpa2jK4v3UzmUtR74vM06cMXUK
        3dLnnOTNYoz5yTJKhl9thpzXfGF4/O7mE7YPMektVbBTDJi/m4mrSBJl2doNkA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel hangs in cifs_reconnect
In-Reply-To: <9c5eeb76-7895-5938-355f-f5d43c5affe5@prodrive-technologies.com>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
 <871rveaurv.fsf@suse.com> <87a7a2ynxg.fsf@cjr.nz>
 <68a58b8e-3cab-093b-3098-6ee4a6dd3117@prodrive-technologies.com>
 <9c5eeb76-7895-5938-355f-f5d43c5affe5@prodrive-technologies.com>
Date:   Tue, 29 Oct 2019 11:49:10 -0300
Message-ID: <87pnif4nfd.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Martijn,

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:

> Anybody any idea on what goes wrong here?

Looks like an use-after-free bug in cifs_reconnect(). cifs superblock
gets freed due to automount expiration and then we dereference it in
dfs_cache_noreq_find().

> Is any of the recently posted patches related to my issue, because I'm 
> more that willing to test out patches if needed.

Could you please test it again with below patch?

cheers,
Paulo


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-cifs-Fix-use-after-free-bug-in-cifs_reconnect.patch

From 6143e4f4af194ebd1ec58d51510e0caf5917786d Mon Sep 17 00:00:00 2001
From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Date: Wed, 23 Oct 2019 18:00:37 -0300
Subject: [PATCH] cifs: Fix use-after-free bug in cifs_reconnect()

Ensure we grab an active reference in cifs superblock while doing
failover to prevent automounts (DFS links) of expiring and then
destroying the superblock pointer.

This patch fixes the following KASAN report:

[  464.301462] BUG: KASAN: use-after-free in
cifs_reconnect+0x6ab/0x1350
[  464.303052] Read of size 8 at addr ffff888155e580d0 by task
cifsd/1107

[  464.304682] CPU: 3 PID: 1107 Comm: cifsd Not tainted 5.4.0-rc4+ #13
[  464.305552] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.12.1-0-ga5cab58-rebuilt.opensuse.org 04/01/2014
[  464.307146] Call Trace:
[  464.307875]  dump_stack+0x5b/0x90
[  464.308631]  print_address_description.constprop.0+0x16/0x200
[  464.309478]  ? cifs_reconnect+0x6ab/0x1350
[  464.310253]  ? cifs_reconnect+0x6ab/0x1350
[  464.311040]  __kasan_report.cold+0x1a/0x41
[  464.311811]  ? cifs_reconnect+0x6ab/0x1350
[  464.312563]  kasan_report+0xe/0x20
[  464.313300]  cifs_reconnect+0x6ab/0x1350
[  464.314062]  ? extract_hostname.part.0+0x90/0x90
[  464.314829]  ? printk+0xad/0xde
[  464.315525]  ? _raw_spin_lock+0x7c/0xd0
[  464.316252]  ? _raw_read_lock_irq+0x40/0x40
[  464.316961]  ? ___ratelimit+0xed/0x182
[  464.317655]  cifs_readv_from_socket+0x289/0x3b0
[  464.318386]  cifs_read_from_socket+0x98/0xd0
[  464.319078]  ? cifs_readv_from_socket+0x3b0/0x3b0
[  464.319782]  ? try_to_wake_up+0x43c/0xa90
[  464.320463]  ? cifs_small_buf_get+0x4b/0x60
[  464.321173]  ? allocate_buffers+0x98/0x1a0
[  464.321856]  cifs_demultiplex_thread+0x218/0x14a0
[  464.322558]  ? cifs_handle_standard+0x270/0x270
[  464.323237]  ? __switch_to_asm+0x40/0x70
[  464.323893]  ? __switch_to_asm+0x34/0x70
[  464.324554]  ? __switch_to_asm+0x40/0x70
[  464.325226]  ? __switch_to_asm+0x40/0x70
[  464.325863]  ? __switch_to_asm+0x34/0x70
[  464.326505]  ? __switch_to_asm+0x40/0x70
[  464.327161]  ? __switch_to_asm+0x34/0x70
[  464.327784]  ? finish_task_switch+0xa1/0x330
[  464.328414]  ? __switch_to+0x363/0x640
[  464.329044]  ? __schedule+0x575/0xaf0
[  464.329655]  ? _raw_spin_lock_irqsave+0x82/0xe0
[  464.330301]  kthread+0x1a3/0x1f0
[  464.330884]  ? cifs_handle_standard+0x270/0x270
[  464.331624]  ? kthread_create_on_node+0xd0/0xd0
[  464.332347]  ret_from_fork+0x35/0x40

[  464.333577] Allocated by task 1110:
[  464.334381]  save_stack+0x1b/0x80
[  464.335123]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[  464.335848]  cifs_smb3_do_mount+0xd4/0xb00
[  464.336619]  legacy_get_tree+0x6b/0xa0
[  464.337235]  vfs_get_tree+0x41/0x110
[  464.337975]  fc_mount+0xa/0x40
[  464.338557]  vfs_kern_mount.part.0+0x6c/0x80
[  464.339227]  cifs_dfs_d_automount+0x336/0xd29
[  464.339846]  follow_managed+0x1b1/0x450
[  464.340449]  lookup_fast+0x231/0x4a0
[  464.341039]  path_openat+0x240/0x1fd0
[  464.341634]  do_filp_open+0x126/0x1c0
[  464.342277]  do_sys_open+0x1eb/0x2c0
[  464.342957]  do_syscall_64+0x5e/0x190
[  464.343555]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  464.344772] Freed by task 0:
[  464.345347]  save_stack+0x1b/0x80
[  464.345966]  __kasan_slab_free+0x12c/0x170
[  464.346576]  kfree+0xa6/0x270
[  464.347211]  rcu_core+0x39c/0xc80
[  464.347800]  __do_softirq+0x10d/0x3da

[  464.348919] The buggy address belongs to the object at
ffff888155e58000
                which belongs to the cache kmalloc-256 of size 256
[  464.350222] The buggy address is located 208 bytes inside of
                256-byte region [ffff888155e58000, ffff888155e58100)
[  464.351575] The buggy address belongs to the page:
[  464.352333] page:ffffea0005579600 refcount:1 mapcount:0
mapping:ffff88815a803400 index:0x0 compound_mapcount: 0
[  464.353583] flags: 0x200000000010200(slab|head)
[  464.354209] raw: 0200000000010200 ffffea0005576200 0000000400000004
ffff88815a803400
[  464.355353] raw: 0000000000000000 0000000080100010 00000001ffffffff
0000000000000000
[  464.356458] page dumped because: kasan: bad access detected

[  464.367005] Memory state around the buggy address:
[  464.367787]  ffff888155e57f80: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  464.368877]  ffff888155e58000: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  464.369967] >ffff888155e58080: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[  464.371111]                                                  ^
[  464.371775]  ffff888155e58100: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  464.372893]  ffff888155e58180: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[  464.373983] ==================================================================

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccaa8bad336f..a4ae4d944a3a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -387,7 +387,7 @@ static inline int reconn_set_ipaddr(struct TCP_Server_Info *server)
 #ifdef CONFIG_CIFS_DFS_UPCALL
 struct super_cb_data {
 	struct TCP_Server_Info *server;
-	struct cifs_sb_info *cifs_sb;
+	struct super_block *sb;
 };
 
 /* These functions must be called with server->srv_mutex held */
@@ -398,25 +398,39 @@ static void super_cb(struct super_block *sb, void *arg)
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 
-	if (d->cifs_sb)
+	if (d->sb)
 		return;
 
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 	if (tcon->ses->server == d->server)
-		d->cifs_sb = cifs_sb;
+		d->sb = sb;
 }
 
-static inline struct cifs_sb_info *
-find_super_by_tcp(struct TCP_Server_Info *server)
+static struct super_block *get_tcp_super(struct TCP_Server_Info *server)
 {
 	struct super_cb_data d = {
 		.server = server,
-		.cifs_sb = NULL,
+		.sb = NULL,
 	};
 
 	iterate_supers_type(&cifs_fs_type, super_cb, &d);
-	return d.cifs_sb ? d.cifs_sb : ERR_PTR(-ENOENT);
+
+	if (unlikely(!d.sb))
+		return ERR_PTR(-ENOENT);
+	/*
+	 * Grab an active reference in order to prevent automounts (DFS links)
+	 * of expiring and then freeing up our cifs superblock pointer while
+	 * we're doing failover.
+	 */
+	cifs_sb_active(d.sb);
+	return d.sb;
+}
+
+static inline void put_tcp_super(struct super_block *sb)
+{
+	if (!IS_ERR_OR_NULL(sb))
+		cifs_sb_deactive(sb);
 }
 
 static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
@@ -480,6 +494,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	struct mid_q_entry *mid_entry;
 	struct list_head retry_list;
 #ifdef CONFIG_CIFS_DFS_UPCALL
+	struct super_block *sb = NULL;
 	struct cifs_sb_info *cifs_sb = NULL;
 	struct dfs_cache_tgt_list tgt_list = {0};
 	struct dfs_cache_tgt_iterator *tgt_it = NULL;
@@ -489,13 +504,15 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	server->nr_targets = 1;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	spin_unlock(&GlobalMid_Lock);
-	cifs_sb = find_super_by_tcp(server);
-	if (IS_ERR(cifs_sb)) {
-		rc = PTR_ERR(cifs_sb);
+	sb = get_tcp_super(server);
+	if (IS_ERR(sb)) {
+		rc = PTR_ERR(sb);
 		cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
 			 __func__, rc);
-		cifs_sb = NULL;
+		sb = NULL;
 	} else {
+		cifs_sb = CIFS_SB(sb);
+
 		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list, &tgt_it);
 		if (rc && (rc != -EOPNOTSUPP)) {
 			cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
@@ -512,6 +529,10 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		/* the demux thread will exit normally
 		next time through the loop */
 		spin_unlock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		dfs_cache_free_tgts(&tgt_list);
+		put_tcp_super(sb);
+#endif
 		return rc;
 	} else
 		server->tcpStatus = CifsNeedReconnect;
@@ -638,7 +659,10 @@ cifs_reconnect(struct TCP_Server_Info *server)
 				 __func__, rc);
 		}
 		dfs_cache_free_tgts(&tgt_list);
+
 	}
+
+	put_tcp_super(sb);
 #endif
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
-- 
2.23.0


--=-=-=--
