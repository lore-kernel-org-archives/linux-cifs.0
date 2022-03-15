Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FBAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 04:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiCOETI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Mar 2022 00:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344746AbiCOETH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Mar 2022 00:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C0AEE081
        for <linux-cifs@vger.kernel.org>; Mon, 14 Mar 2022 21:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647317875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WAdBRsecU14/qYYiPxPWyIHiCYmLHaJWJ7UJkQgTWXU=;
        b=d11ueWqRR7eIzvTlIkuKSOIdXQc/RoxLRdQUB2KBAWvKy2GHxpAzSquq8HV4knyGUa0M3n
        DQlMGhMGPRMz2Pm6nncyTbYJL3Trd0KEvBspYzBwsYzbX5YuDYP8lmaebSwtA8KYNYc2k6
        oAM75xm/FwwKZdNxI9vbF8aGp1GrMBc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-xbpT5tymP4y3xcUwxZ8hCQ-1; Tue, 15 Mar 2022 00:17:53 -0400
X-MC-Unique: xbpT5tymP4y3xcUwxZ8hCQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EC82185A7BA;
        Tue, 15 Mar 2022 04:17:53 +0000 (UTC)
Received: from thinkpad (vpn2-54-164.bne.redhat.com [10.64.54.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 601CA4B8D59;
        Tue, 15 Mar 2022 04:17:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix KASAN warning in parse_server_interfaces() during mount
Date:   Tue, 15 Mar 2022 14:17:45 +1000
Message-Id: <20220315041745.625517-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In parse_server_interfaces() we hold a spinlock across a parsing look that
calls kmalloc(). Use GFP_ATOMIC for this kmalloc since we can not sleep
while holding a spinlock.

KASAN warning for this bug looks as:
[ 2638.506227] BUG: sleeping function called from invalid context at include/li\
nux/sched/mm.h:256
[ 2638.506360] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3633, nam\
e: mount.cifs
[ 2638.506446] preempt_count: 1, expected: 0
[ 2638.506486] CPU: 0 PID: 3633 Comm: mount.cifs Tainted: G        W  OE     5.\
17.0-rc7-00006-g4eb628dd74df #135
[ 2638.506490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-\
1.fc33 04/01/2014
[ 2638.506493] Call Trace:
[ 2638.506495]  <TASK>
[ 2638.506497]  dump_stack_lvl+0x34/0x44
[ 2638.506505]  __might_resched.cold+0x13f/0x172
[ 2638.506509]  ? _raw_spin_lock+0x81/0xe0
[ 2638.506514]  ? parse_server_interfaces+0x3fe/0xc17 [cifs]
[ 2638.506610]  kmem_cache_alloc_trace+0x261/0x2f0
[ 2638.506616]  parse_server_interfaces+0x3fe/0xc17 [cifs]
[ 2638.506685]  ? kref_put.isra.0+0x42/0x42 [cifs]
[ 2638.506754]  smb3_qfs_tcon.cold+0x28/0x2d [cifs]
[ 2638.506821]  ? open_cached_dir+0x1080/0x1080 [cifs]
[ 2638.506884]  ? io_schedule_timeout+0x1a0/0x1a0
[ 2638.506888]  ? _raw_spin_lock+0x81/0xe0
[ 2638.506892]  ? _raw_write_lock_irq+0xd0/0xd0
[ 2638.506896]  ? __raw_callee_save___native_queued_spin_unlock+0x11/0x1e
[ 2638.506901]  ? _raw_spin_lock+0x81/0xe0
[ 2638.506904]  ? cifs_get_tcon+0xea3/0x1bc0 [cifs]
[ 2638.506959]  mount_get_conns+0x366/0xf60 [cifs]
[ 2638.507012]  cifs_mount+0xcc/0xe90 [cifs]
[ 2638.507068]  ? __irq_work_queue_local+0x67/0xa0
[ 2638.507073]  ? follow_dfs_link+0x810/0x810 [cifs]
[ 2638.507125]  ? _raw_spin_lock+0x81/0xe0
[ 2638.507130]  cifs_smb3_do_mount+0x259/0x5f0 [cifs]
[ 2638.507180]  ? cifs_sb_deactive+0x60/0x60 [cifs]
[ 2638.507231]  ? mutex_lock+0x9f/0xf0
[ 2638.507234]  ? __mutex_lock_slowpath+0x10/0x10
[ 2638.507238]  ? smb3_fs_context_parse_monolithic+0x10b/0x2e0 [cifs]
[ 2638.507309]  ? smb3_init_fs_context+0x1b6/0x8f0 [cifs]
[ 2638.507388]  smb3_get_tree+0x77/0xf0 [cifs]
[ 2638.507450]  vfs_get_tree+0x84/0x2b0
[ 2638.507455]  do_new_mount+0x21e/0x480
[ 2638.507460]  ? do_add_mount+0x370/0x370
[ 2638.507464]  ? security_capable+0x56/0x90
[ 2638.507469]  path_mount+0x2ad/0x1660

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e04c3045c4d6..0ecd6e1832a1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -569,7 +569,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 
 		/* no match. insert the entry in the list */
 		info = kmalloc(sizeof(struct cifs_server_iface),
-			       GFP_KERNEL);
+			       GFP_ATOMIC);
 		if (!info) {
 			rc = -ENOMEM;
 			spin_unlock(&ses->iface_lock);
-- 
2.30.2

