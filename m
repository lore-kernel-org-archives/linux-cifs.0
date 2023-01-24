Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9265C25B4E
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Jan 2023 17:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbjAXRuv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Jan 2023 12:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjAXRuu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Jan 2023 12:50:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642944C6FD
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 09:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674582542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TXWHZz/pFmVyykOp2InAKZu8Zo1EO1lRr/Zu22EyGhc=;
        b=eA5ax9tgvpLPefXY0jI67mYFa5lu6mVkfqjsrP2ZXNRCLTJh43vHJ6eWSTBqgpcDqnuyZu
        IjVb/VlFEvIEwFGmdaFvPgZ1X24RYNBIVRGfqXhDtqEWg7eBnAqpbsYjYinLpYeAOJyelm
        uTIAURZOiKLz7Yqper+qx9b4rgtQyJA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124--Gm-7mbKN6qaL5eP2kNHow-1; Tue, 24 Jan 2023 12:49:00 -0500
X-MC-Unique: -Gm-7mbKN6qaL5eP2kNHow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBF23814941;
        Tue, 24 Jan 2023 17:49:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C670BC15BA0;
        Tue, 24 Jan 2023 17:48:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Steve French <sfrench@samba.org>
cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: cifs-rdma: KASAN-detected UAF when using rxe driver
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1130898.1674582538.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 24 Jan 2023 17:48:58 +0000
Message-ID: <1130899.1674582538@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

I was trying to test cifs rdma and KASAN detected a UAF when using the
softRoCE RDMA driver (rxe):

	BUG: KASAN: use-after-free in smbd_reconnect (fs/cifs/smbdirect.c:1427
	if (server->smbd_conn->transport_status =3D=3D SMBD_CONNECTED) {

I've attached the oops log below.  This is with v6.2-rc5 with no additiona=
l
patches.  One thing I'm wondering is if smbd_destroy() should clear
server->smbd_conn before returning since it kfrees the smbd_connection str=
uct
that that was pointing to.

The commands I was using:

	rdma link add rxe0 type rxe netdev enp6s0 # andromeda, softRoCE
	cd ~/xfstests-dev; ./check generic/001

The xfstests config:

	FSTYP=3Dcifs
	TEST_DEV=3D//carina/test
	TEST_DIR=3D/xfstest.test
	TEST_FS_MOUNT_OPTS=3D'-ousername=3Dshares,password=3Dfoobar,vers=3D3.1.1,=
rdma'
	export MOUNT_OPTIONS=3D'-ousername=3Dshares,password=3Dfoobar,vers=3D3.1.=
1,rdma'
	export SCRATCH_DEV=3D//carina/scratch
	export SCRATCH_MNT=3D/xfstest.scratch

The mounted filesystem:

	//carina/test /xfstest.test cifs rw,context=3Dsystem_u:object_r:root_t:s0=
,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dshares,uid=3D0,noforceuid=
,gid=3D0,noforcegid,addr=3D192.168.6.1,rdma,file_mode=3D0755,dir_mode=3D07=
55,soft,nounix,serverino,mapposix,rsize=3D524224,wsize=3D524224,bsize=3D10=
48576,echo_interval=3D60,actimeo=3D1,closetimeo=3D5 0 0

It's talking to ksmbd on carina.

David
---
infiniband rxe0: set active
infiniband rxe0: added enp6s0
RDS/IB: rxe0: added
CIFS: Attempting to mount \\carina\test
CIFS: VFS: RDMA transport established
CIFS: Attempting to mount \\carina\scratch
CIFS: Attempting to mount \\carina\scratch
run fstests generic/001 at 2023-01-24 17:31:24
CIFS: VFS: smbd_recv_buf:1887 disconnected
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in smbd_reconnect+0xba/0x1a9
Read of size 4 at addr ffff888119014000 by task cifsd/4963

CPU: 0 PID: 4963 Comm: cifsd Not tainted 6.2.0-rc5-build2 #729
Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4c/0x5f
 print_address_description.constprop.0+0x80/0x2b2
 print_report+0x10f/0x1f2
 ? __virt_addr_valid+0xcd/0x113
 ? smbd_reconnect+0xba/0x1a9
  ? smbd_reconnect+0xba/0x1a9
 kasan_report+0x88/0xa7
 ? smbd_reconnect+0xba/0x1a9
 smbd_reconnect+0xba/0x1a9
 __cifs_reconnect+0x4ca/0x637
 ? cifs_mark_tcp_ses_conns_for_reconnect+0x20a/0x20a
 ? __raw_spin_lock_init+0x83/0x83
 ? cifs_readv_from_socket+0x28f/0x2e6
 ? cifs_readv_from_socket+0x28f/0x2e6
 cifs_readv_from_socket+0x1e7/0x2e6
 cifs_read_from_socket+0xb5/0xef
 ? cifs_readv_from_socket+0x2e6/0x2e6
 ? mempool_kmalloc+0x11/0x11
 ? reacquire_held_locks+0x1bb/0x1bb
 ? memset+0x21/0x3f
 cifs_demultiplex_thread+0x19f/0xbae
 ? cifs_handle_standard+0x277/0x277
 ? reacquire_held_locks+0x1bb/0x1bb
 ? __kthread_parkme+0x65/0xe8
 ? rcu_read_lock_bh_held+0xb1/0xb1
 ? preempt_count_sub+0x18/0xba
 ? _raw_spin_unlock_irqrestore+0x39/0x4c
 ? cifs_handle_standard+0x277/0x277
 kthread+0x164/0x173
 ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 4959:
 stack_trace_save+0x8d/0xba
 kasan_save_stack+0x1c/0x38
 kasan_set_track+0x21/0x26
 ____kasan_kmalloc+0x69/0x73
 _smbd_get_connection+0xcf/0x124c
 smbd_get_connection+0x21/0x3e
 cifs_get_tcp_session.part.0+0x7f6/0xb87
 cifs_mount_get_session+0x53/0x164
 cifs_mount+0x8d/0x227
 cifs_smb3_do_mount+0x168/0x465
 smb3_get_tree+0x55/0x8a
 vfs_get_tree+0x43/0x14d
 do_new_mount+0x197/0x2b4
 path_mount+0x6c7/0x705
 do_mount+0x9c/0xdb
 __do_sys_mount+0x141/0x16e
 do_syscall_64+0x39/0x46
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 4963:
 stack_trace_save+0x8d/0xba
 kasan_save_stack+0x1c/0x38
 kasan_set_track+0x21/0x26
 kasan_save_free_info+0x27/0x37
 ____kasan_slab_free+0xb6/0xd2
 __kmem_cache_free+0x93/0xd2
 smbd_destroy+0x8da/0x91c
 __cifs_reconnect+0x48d/0x637
 cifs_readv_from_socket+0x1e7/0x2e6
 cifs_read_from_socket+0xb5/0xef
 cifs_demultiplex_thread+0x19f/0xbae
 kthread+0x164/0x173
 ret_from_fork+0x1f/0x30

Last potentially related work creation:
 stack_trace_save+0x8d/0xba
 kasan_save_stack+0x1c/0x38
 __kasan_record_aux_stack+0x5f/0x65
 insert_work+0x30/0xaf
 __queue_work+0x3cc/0x3ef
 queue_work_on+0x4e/0x68
 __ib_process_cq+0x228/0x276
 ib_poll_handler+0x41/0x14f
 irq_poll_softirq+0xd9/0x1ad
 __do_softirq+0x201/0x470

Second to last potentially related work creation:
 stack_trace_save+0x8d/0xba
 kasan_save_stack+0x1c/0x38
 __kasan_record_aux_stack+0x5f/0x65
 insert_work+0x30/0xaf
 __queue_work+0x3cc/0x3ef
 queue_work_on+0x4e/0x68
 recv_done+0x171/0x714
 __ib_process_cq+0x228/0x276
 ib_poll_handler+0x41/0x14f
 irq_poll_softirq+0xd9/0x1ad
 __do_softirq+0x201/0x470

The buggy address belongs to the object at ffff888119014000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes inside of
 4096-byte region [ffff888119014000, ffff888119015000)

The buggy address belongs to the physical page:
page:00000000a28ee5c4 refcount:1 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x119014
head:00000000a28ee5c4 order:1 compound_mapcount:0 subpages_mapcount:0 comp=
ound_pincount:0
flags: 0x200000000010200(slab|head|node=3D0|zone=3D2)
raw: 0200000000010200 ffff888100040900 ffffea0004513490 ffffea0004581e10
raw: 0000000000000000 ffff888119014000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888119013f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888119013f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888119014000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888119014080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888119014100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

