Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9852C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 10:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiE0KdT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 06:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiE0KdS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 06:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 647B71053F1
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 03:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653647595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=41kFAoQe/9fnamyT2xaCKIfijdeuW47SigpyhvuXmd4=;
        b=NmKUcMN6xxt/DowFQ0fnZ5s9EvwXGTWkNqnGckNqesQN41vQK3OxiQY40dOihuXSg9ibKw
        TlkIwj8SLYHuqqmfyl1WGe3vi+DQ6yOKfjq5hE1mvT9qsOLc4XTMFK5lcor1HOITcSilaO
        cttDZKhMPayDFV5Fpg1Omxhn0XyaS1U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-CBM9q_eUP-ieTjSqMqtZmg-1; Fri, 27 May 2022 06:33:10 -0400
X-MC-Unique: CBM9q_eUP-ieTjSqMqtZmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96FF6101A54E;
        Fri, 27 May 2022 10:33:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89826112131B;
        Fri, 27 May 2022 10:33:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Namjae Jeon <linkinjeon@kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Long Li <longli@microsoft.com>, Tom Talpey <tom@talpey.com>
Subject: UAF in smbd_reconnect() when using softIWarp
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3333123.1653647587.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 27 May 2022 11:33:07 +0100
Message-ID: <3333124.1653647587@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

I switch to using the softIWarp driver as there's a deadlock in the softRo=
CE
driver.  However, this comes up with a repeatable UAF detected by KASAN.

The RDMA link was brought up with:

	rdma link add siw0 type siw netdev enp6s0

and then I started running xfstests with -g quick.

MOUNT_OPTIONS -- -ordma,username=3Dshares,password=3D...,mfsymlinks -o con=
text=3Dsystem_u:object_r:root_t:s0 //carina/scratch /xfstest.scratch

The kernel was v5.18 + iwarp SGE patch.

The KASAN splat is attached.  Some decoded bits:

 smbd_reconnect+0xba/0x1a6
 smbd_reconnect (fs/cifs/smbdirect.c:1427):
	if (server->smbd_conn->transport_status =3D=3D SMBD_CONNECTED) {

 _smbd_get_connection+0xce/0x1367
 _smbd_get_connection (fs/cifs/smbdirect.c:1530):
	info =3D kzalloc(sizeof(struct smbd_connection), GFP_KERNEL);

 smbd_destroy+0x852/0x899
 smbd_destroy (fs/cifs/smbdirect.c:1323):
	(probably the kfree at the end on line 1407)

 __cifs_reconnect+0x315/0x4b3
 __cifs_reconnect (fs/cifs/connect.c:311 fs/cifs/connect.c:358) =

		smbd_destroy(server);

David
---
run fstests generic/005 at 2022-05-27 11:18:41
run fstests generic/006 at 2022-05-27 11:18:51
CIFS: VFS: smbd_recv_buf:1889 disconnected
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in smbd_reconnect+0xba/0x1a6
Read of size 4 at addr ffff88813029e000 by task cifsd/4509

CPU: 2 PID: 4509 Comm: cifsd Not tainted 5.18.0-build2+ #467
Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x45/0x59
 print_address_description.constprop.0+0x1f/0x2ce
 ? smbd_reconnect+0xba/0x1a6
 print_report+0xf0/0x1d6
 ? smbd_reconnect+0xba/0x1a6
 ? do_raw_spin_lock+0x13a/0x17b
 ? smbd_reconnect+0xba/0x1a6
 kasan_report+0x81/0xa1
 ? smbd_reconnect+0xba/0x1a6
 smbd_reconnect+0xba/0x1a6
 __cifs_reconnect+0x351/0x4b3
 ? cifs_mark_tcp_ses_conns_for_reconnect+0x1b3/0x1b3
 ? __raw_spin_lock_init+0x85/0x85
 cifs_readv_from_socket+0x29a/0x2f4
 cifs_read_from_socket+0x95/0xc5
 ? cifs_readv_from_socket+0x2f4/0x2f4
 ? cifs_small_buf_get+0x50/0x5d
 ? allocate_buffers+0xfb/0x186
 cifs_demultiplex_thread+0x19b/0xb64
 ? cifs_handle_standard+0x27e/0x27e
 ? lock_downgrade+0xad/0xad
 ? rcu_read_lock_bh_held+0xab/0xab
 ? pci_mmcfg_check_reserved+0xbd/0xbd
 ? preempt_count_sub+0x18/0xba
 ? _raw_spin_unlock_irqrestore+0x39/0x4c
 ? cifs_handle_standard+0x27e/0x27e
 kthread+0x164/0x173
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 4505:
 stack_trace_save+0x8f/0xbe
 kasan_save_stack+0x1e/0x39
 kasan_set_track+0x21/0x26
 ____kasan_kmalloc+0x68/0x72
 kmem_cache_alloc_trace+0x121/0x162
 _smbd_get_connection+0xce/0x1367
 smbd_get_connection+0x21/0x3e
 cifs_get_tcp_session.part.0+0x853/0xbda
 mount_get_conns+0x51/0x594
 cifs_mount+0x8d/0x279
 cifs_smb3_do_mount+0x186/0x471
 smb3_get_tree+0x58/0x91
 vfs_get_tree+0x46/0x150
 do_new_mount+0x19f/0x2c9
 path_mount+0x6a5/0x6e3
 do_mount+0x9e/0xe1
 __do_sys_mount+0x150/0x17c
 do_syscall_64+0x39/0x46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4509:
 stack_trace_save+0x8f/0xbe
 kasan_save_stack+0x1e/0x39
 kasan_set_track+0x21/0x26
 kasan_set_free_info+0x20/0x2f
 ____kasan_slab_free+0xad/0xc9
 kfree+0x125/0x14b
 smbd_destroy+0x852/0x899
 __cifs_reconnect+0x315/0x4b3
 cifs_readv_from_socket+0x29a/0x2f4
 cifs_read_from_socket+0x95/0xc5
 cifs_demultiplex_thread+0x19b/0xb64
 kthread+0x164/0x173
 ret_from_fork+0x1f/0x30

Last potentially related work creation:
 stack_trace_save+0x8f/0xbe
 kasan_save_stack+0x1e/0x39
 __kasan_record_aux_stack+0x62/0x68
 insert_work+0x30/0xaf
 __queue_work+0x4b9/0x4dc
 queue_work_on+0x4d/0x67
 __ib_process_cq+0x219/0x268
 ib_poll_handler+0x3f/0x14c
 irq_poll_softirq+0xd8/0x1ab
 __do_softirq+0x202/0x489

Second to last potentially related work creation:
 stack_trace_save+0x8f/0xbe
 kasan_save_stack+0x1e/0x39
 __kasan_record_aux_stack+0x62/0x68
 insert_work+0x30/0xaf
 __queue_work+0x4b9/0x4dc
 queue_work_on+0x4d/0x67
 recv_done+0x16f/0x727
 __ib_process_cq+0x219/0x268
 ib_poll_handler+0x3f/0x14c
 irq_poll_softirq+0xd8/0x1ab
 __do_softirq+0x202/0x489

The buggy address belongs to the object at ffff88813029e000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes inside of
 4096-byte region [ffff88813029e000, ffff88813029f000)
The buggy address belongs to the physical page:
page:0000000001f91160 refcount:1 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x13029e
head:0000000001f91160 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010200(slab|head|node=3D0|zone=3D2)
raw: 0200000000010200 ffffea0004c06d08 ffffea0004c0a288 ffff888100040900
raw: 0000000000000000 ffff88813029e000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88813029df00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88813029df80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88813029e000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88813029e080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88813029e100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Disabling lock debugging due to kernel taint
CIFS: VFS: RDMA transport re-established
CIFS: VFS: smbd_recv_buf:1889 disconnected

