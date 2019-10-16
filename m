Return-Path: <SRS0=fkjb=YJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCCBECE599
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 19:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95ED92053B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 19:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfJPT1l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Oct 2019 15:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732467AbfJPT1l (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 16 Oct 2019 15:27:41 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCD4C87638
        for <linux-cifs@vger.kernel.org>; Wed, 16 Oct 2019 19:27:40 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id o133so24838347qke.4
        for <linux-cifs@vger.kernel.org>; Wed, 16 Oct 2019 12:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bAIu28/VPGJtUM/8ihj4Z+kR5k8VB70haXXCyCxkntA=;
        b=M9PrR3k9PxWsZ5VPKv7OmRqfDuJ29/nwaDBfbv+YAAIsXV0ZpfogA3mCgjO68KhPND
         sLM/GvZ+qCJW4n5KvbOSqFuw5NQWsPpJJYPXIq1XUjLmX8kDPUsEBnTcN+awoqLtg/60
         D0tEF/QKxgKpRuelMtCj1qaGuhaWJA8Np2jeOXj73qcUe1Mns8NACSKmr08qGZs3YmTL
         b56D72/5F3Av+lnXKr7jlNsjiT+xmNVfY76no6Ap9kg2kJoVWU+oi0L8Q6/+m7l+IsYO
         MePjKR0/VMpDMDM4dF+2T4mveOhjEugbNxNPASb4vi5fwTVRTKiY+ONl+T+NrPi9i2pW
         RpuQ==
X-Gm-Message-State: APjAAAXyCFsDbSfbetRtLVOHgF/HIxw4vMPmMO1gvGm0I+Ub7bKVesao
        0coUUG3uEpklPp0q4hMpp0XjPHUeMWtfnxWlaTMYyfX3LG1oBJG/vIDPBUjszT0atQVn9fGLWNQ
        NkMcsG/mnLeXun3jHlghfK85lk+cVvMT3xNBtyQ==
X-Received: by 2002:a37:a704:: with SMTP id q4mr40462552qke.385.1571254059711;
        Wed, 16 Oct 2019 12:27:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyq16vPtl/Vx1MFO8eLMqdgcPzETpdhFNCtTnb1AoQQDlAAsbkqg/9XndCG2LaaP3h7+BFidxlCze5TDI+Ld9o=
X-Received: by 2002:ac8:3f64:: with SMTP id w33mr45801738qtk.191.1571254058658;
 Wed, 16 Oct 2019 12:27:38 -0700 (PDT)
MIME-Version: 1.0
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Wed, 16 Oct 2019 15:27:02 -0400
Message-ID: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
Subject: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     "Sorenson, Frank" <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think this has been there for a long time, since we first saw this
on a 4.18.0 based kernel but I just noticed the bug recently.
I just retested on 5.4-rc3 and it's still there.  Easy to repro with a
fairly simple but invasive server restart test - takes only maybe a
couple minutes on my VM.


From Frank Sorenson:

mount off a samba server:

    # mount //vm1/share /mnt/vm1
-overs=2.1,hard,sec=ntlmssp,credentials=/root/.smb_creds


on the client, start 10 'find' loops:

    # export test_path=/mnt/vm1
    # do_find() { while true ; do find $test_path >/dev/null 2>&1 ; done }

    # for i in {1..10} ; do do_find & done


optional:  also start something to monitor for when the hang occurs:

    # while true ; do count=$(grep smb2_reconnect /proc/*/stack -A3 |
grep -c open_shroot) ; [[ $count -gt 0 ]] && { echo "$(date):
reproduced bug" ; break ; } ; echo "$(date): stayin' alive" ; sleep 2
; done



On the samba server:  restart smb.service (loop it in case it requires
more than one restart):

    # while true ; do echo "$(date): restarting" ; systemctl restart
smb.service ; sleep 5 ; done | tee /var/tmp/smb_restart_log.out




[  430.454897] list_del corruption. prev->next should be
ffff98d3a8f316c0, but was 2e885cb266355469
[  430.464668] ------------[ cut here ]------------
[  430.466569] kernel BUG at lib/list_debug.c:51!
[  430.468476] invalid opcode: 0000 [#1] SMP PTI
[  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted
5.4.0-rc3+ #19
[  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
[  430.478129] Code: 5e 15 8e e8 54 a3 c5 ff 0f 0b 48 c7 c7 78 5f 15
8e e8 46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 38 5f 15 8e e8 32
a3 c5 ff <0f> 0b 48 89 fe 4c 89 c2 48 c7 c7 00 5f 15 8e e8 1e a3 c5 ff
0f 0b
[  430.485563] RSP: 0018:ffffb4db0042fd38 EFLAGS: 00010246
[  430.487665] RAX: 0000000000000054 RBX: ffff98d3aabb8800 RCX: 0000000000000000
[  430.490513] RDX: 0000000000000000 RSI: ffff98d3b7a17908 RDI: ffff98d3b7a17908
[  430.493383] RBP: ffff98d3a8f316c0 R08: ffff98d3b7a17908 R09: 0000000000000285
[  430.496258] R10: ffffb4db0042fbf0 R11: ffffb4db0042fbf5 R12: ffff98d3aabb89c0
[  430.499113] R13: ffffb4db0042fd48 R14: 2e885cb266355469 R15: ffff98d3b24c4480
[  430.501981] FS:  0000000000000000(0000) GS:ffff98d3b7a00000(0000)
knlGS:0000000000000000
[  430.505232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  430.507546] CR2: 00007f08cd17b9c0 CR3: 000000023484a000 CR4: 00000000000406f0
[  430.510426] Call Trace:
[  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
[  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
[  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
[  430.517452]  ? try_to_wake_up+0x212/0x650
[  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
[  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
[  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
[  430.525116]  kthread+0xfb/0x130
[  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  430.528514]  ? kthread_park+0x90/0x90
[  430.530019]  ret_from_fork+0x35/0x40
[  430.531487] Modules linked in: cifs libdes libarc4 ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
iptable_mangle iptable_raw iptable_security nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul joydev
virtio_balloon ghash_clmulni_intel i2c_piix4 nfsd nfs_acl lockd
auth_rpcgss grace sunrpc xfs libcrc32c virtio_net net_failover
crc32c_intel virtio_console serio_raw virtio_blk ata_generic failover
pata_acpi qemu_fw_cfg
[  430.552782] ---[ end trace c91d4468f8689482 ]---
[  430.554948] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
[  430.557251] Code: 5e 15 8e e8 54 a3 c5 ff 0f 0b 48 c7 c7 78 5f 15
8e e8 46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 38 5f 15 8e e8 32
a3 c5 ff <0f> 0b 48 89 fe 4c 89 c2 48 c7 c7 00 5f 15 8e e8 1e a3 c5 ff
0f 0b
[  430.565019] RSP: 0018:ffffb4db0042fd38 EFLAGS: 00010246
[  430.567181] RAX: 0000000000000054 RBX: ffff98d3aabb8800 RCX: 0000000000000000
[  430.570073] RDX: 0000000000000000 RSI: ffff98d3b7a17908 RDI: ffff98d3b7a17908
[  430.572955] RBP: ffff98d3a8f316c0 R08: ffff98d3b7a17908 R09: 0000000000000285
[  430.575854] R10: ffffb4db0042fbf0 R11: ffffb4db0042fbf5 R12: ffff98d3aabb89c0
[  430.578745] R13: ffffb4db0042fd48 R14: 2e885cb266355469 R15: ffff98d3b24c4480
[  430.581624] FS:  0000000000000000(0000) GS:ffff98d3b7a00000(0000)
knlGS:0000000000000000
[  430.584881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  430.587230] CR2: 00007f08cd17b9c0 CR3: 000000023484a000 CR4: 00000000000406f0


crash> dis -lr cifs_reconnect+0x25e | tail --lines=20
0xffffffffc062dc26 <cifs_reconnect+0x226>:      movb
$0x0,0xbb36b(%rip)        # 0xffffffffc06e8f98 <GlobalMid_Lock>
/mnt/build/kernel/fs/cifs/connect.c: 572
0xffffffffc062dc2d <cifs_reconnect+0x22d>:      mov    %r12,%rdi
0xffffffffc062dc30 <cifs_reconnect+0x230>:      callq
0xffffffff8d9d5a20 <mutex_unlock>
/mnt/build/kernel/fs/cifs/connect.c: 574
0xffffffffc062dc35 <cifs_reconnect+0x235>:      testb
$0x1,0xbb300(%rip)        # 0xffffffffc06e8f3c <cifsFYI>
0xffffffffc062dc3c <cifs_reconnect+0x23c>:      je
0xffffffffc062dc43 <cifs_reconnect+0x243>
/mnt/build/kernel/./arch/x86/include/asm/jump_label.h: 25
0xffffffffc062dc3e <cifs_reconnect+0x23e>:      data32 data32 data32
xchg %ax,%ax
/mnt/build/kernel/fs/cifs/connect.c: 575
0xffffffffc062dc43 <cifs_reconnect+0x243>:      mov    0x8(%rsp),%rbp
0xffffffffc062dc48 <cifs_reconnect+0x248>:      mov    0x0(%rbp),%r14
0xffffffffc062dc4c <cifs_reconnect+0x24c>:      cmp    %r13,%rbp
0xffffffffc062dc4f <cifs_reconnect+0x24f>:      jne
0xffffffffc062dc56 <cifs_reconnect+0x256>
0xffffffffc062dc51 <cifs_reconnect+0x251>:      jmp
0xffffffffc062dc90 <cifs_reconnect+0x290>
0xffffffffc062dc53 <cifs_reconnect+0x253>:      mov    %rax,%r14
/mnt/build/kernel/./include/linux/list.h: 190
0xffffffffc062dc56 <cifs_reconnect+0x256>:      mov    %rbp,%rdi
0xffffffffc062dc59 <cifs_reconnect+0x259>:      callq
0xffffffff8d4e6b00 <__list_del_entry_valid>
0xffffffffc062dc5e <cifs_reconnect+0x25e>:      test   %al,%al


fs/cifs/connect.c
566         mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
567         if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
568             mid_entry->mid_state = MID_RETRY_NEEDED;
569         list_move(&mid_entry->qhead, &retry_list);
570     }
571     spin_unlock(&GlobalMid_Lock);
572     mutex_unlock(&server->srv_mutex);
573
574     cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
575-->    list_for_each_safe(tmp, tmp2, &retry_list) {
576         mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
577         list_del_init(&mid_entry->qhead);
578         mid_entry->callback(mid_entry);
579     }
580
581     if (cifs_rdma_enabled(server)) {
582         mutex_lock(&server->srv_mutex);
583         smbd_destroy(server);
584         mutex_unlock(&server->srv_mutex);
