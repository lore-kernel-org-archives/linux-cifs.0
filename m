Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3315EC64ED6
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 05:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjB1FJo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 00:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1FJn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 00:09:43 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3047B761
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 21:09:41 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-536bf92b55cso238896677b3.12
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 21:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=awmPXwncwz2B7GEJWNKPJWqMOSSgJY6bSWPIdgznnis=;
        b=FEAPT4PbK0B9zBLzG8X8JOVxa9zO3du2r045HAnLhJ5/Ij9pI+NwJJ2nK2wjmEHGom
         HBDubo5nitcBtnHY7NRGPFGREVKtmW6b/tSq8RYgq/JkxGCVx+aM0Ye9Q1jEFShE5mRU
         uLvoFk8G86+wIIJ45kvr8BYcDJqXilcaSrQ0XyRPN0QOfw7Vm64XMzmNSOwHmhy+wQr5
         fbj6Q8fMKs5obKJGzIDHwJrhXb0bmAZXSB0/2WRoawb0SD8pMMM7loJsKfZZ37Je+5tG
         IsBt8IQnABj1GKwkv4HgDw20GGpfqF+iy0EWFlu/OHjwZRF+mWwjBlFU9TAIVg0e3xo9
         m3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=awmPXwncwz2B7GEJWNKPJWqMOSSgJY6bSWPIdgznnis=;
        b=aKSfJHgyyvyBYcxJv7GeSDbX5kQpoPL/YvX/DCIUOsNKn2kOSKbwwBi10WItP3YzdI
         1A+6cTZjDqxDRqUL+FsrypGw19ZjO4pRKt5H68cWk8YNULjH/zJoOz+mEYxkDHqwZklG
         LqflbppqumbeKzzvyTBAjNP/ocpeG17l8T24DOz9Jev/gUso0P+dKmmmOqw4OaocgoaG
         ZdTVU64SvtIGoZbqotO2LZxgRpHpBrZUxLTb+YKH05DTR84L3O7CU53uS5sP2aA671o8
         15BDoGtL6yAjUbh/U6dkET1oitPSIYU/Yux/TtURLLgtCNG/q2H2dfqtCZEaJn4HMvaX
         7HOw==
X-Gm-Message-State: AO0yUKXtIYnwp2ioKdZvlBpevWg+BpMoYOXPpfaAjHCkbQM/hZPwnYfe
        liSsojQAjiw/ENa0kNlllsVPZUDlhHJPBVyn2QeZEffOL6727A==
X-Google-Smtp-Source: AK7set/bqdlXMwT/0Lwwb9L0/XEr6+leVBWi9zIfidoqb1l57lzKOZBh57iCW59o6N5908JizirbvN3hgdy0Ow/Pk8I=
X-Received: by 2002:a5b:94c:0:b0:a2c:77db:d3aa with SMTP id
 x12-20020a5b094c000000b00a2c77dbd3aamr507965ybq.6.1677560980839; Mon, 27 Feb
 2023 21:09:40 -0800 (PST)
MIME-Version: 1.0
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Tue, 28 Feb 2023 13:09:29 +0800
Message-ID: <CADJHv_s5s=Di_buo_1ENgJQjO_qR_tcKf+UySfdCR0k0+g2Dxw@mail.gmail.com>
Subject: cifs xfstests aio-dio-invalidate-failure test fail after 6.3 merge
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

It is xfstests generic/208. It passed with the v6.2 release.

The similar WARNING can be triggered with the v6.2 release without the
"cache=none" mount option.


Thanks,
Murphy

Test log with kernel built on the top of commit f3a2439f20d9:

# FS QA Test No. 208
#
# Run aio-dio-invalidate-failure - test race in read cache invalidation
#

FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 xzhouw2 6.2.0+ #3 SMP PREEMPT_DYNAMIC
Mon Feb 27 12:18:03 CST 2023
MKFS_OPTIONS  -- //localhost/scratch
MOUNT_OPTIONS -- -o vers=3.11,username=root,
password=redhat,mfsymlinks,cache=none -o
context=system_u:object_r:nfs_t:s0 //localhost/scratch /cifssch

generic/208 200s ...  [13:01:11][failed, exit status 1] [13:01:53]-
output mismatch (see
/root/upstream/xfstests/results//generic/208.out.bad)
    --- tests/generic/208.out    2022-09-13 10:27:36.077029036 +0800
    +++ /root/upstream/xfstests/results//generic/208.out.bad
2023-02-27 13:01:53.189534533 +0800
    @@ -1,2 +1,2 @@
     QA output created by 208
    -ran for 200 seconds without error, passing
    +buffered write returned -1_check_dmesg: something found in dmesg
(see /root/upstream/xfstests/results//generic/208.dmesg)
Ran: generic/208
Failures: generic/208
Failed 1 of 1 tests

[   30.762541] run fstests generic/208 at 2023-02-27 13:01:11
[   72.029275] ------------[ cut here ]------------
[   72.029279] WARNING: CPU: 0 PID: 3064 at mm/gup.c:218
try_grab_page+0x65/0x100
[   72.029288] Modules linked in: cifs rdma_cm iw_cm ib_cm ib_core
dns_resolver fscache netfs loop xt_CHECKSUM xt_MASQUERADE xt_conntrack
ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc
rfkill sunrpc snd_hda_codec_generic ledtrig_audio snd_hda_intel
snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core
intel_rapl_msr snd_hwdep intel_rapl_common snd_seq
intel_uncore_frequency_common isst_if_common snd_seq_device snd_pcm
nfit snd_timer crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd
rapl iTCO_wdt i2c_i801 iTCO_vendor_support soundcore pcspkr i2c_smbus
lpc_ich joydev virtio_balloon xfs libcrc32c qxl drm_ttm_helper ttm
drm_kms_helper sr_mod cdrom sg syscopyarea sysfillrect sysimgblt drm
ahci libahci libata virtio_net crc32c_intel net_failover serio_raw
virtio_blk virtio_scsi virtio_console failover dm_mirror
dm_region_hash dm_log dm_mod fuse
[   72.029345] CPU: 0 PID: 3064 Comm: aio-dio-invalid Not tainted 6.2.0+ #3
[   72.029347] Hardware name: Red Hat RHEL/RHEL-AV, BIOS
1.15.0-2.module+el8.6.0+14757+c25ee005 04/01/2014
[   72.029349] RIP: 0010:try_grab_page+0x65/0x100
[   72.029351] Code: 48 89 fa f7 c7 ff 0f 00 00 75 d1 48 8b 07 a9 00
00 01 00 74 c7 48 8b 47 48 48 8d 50 ff a8 01 48 0f 44 d7 8b 42 34 85
c0 7f b9 <0f> 0b b8 f4 ff ff ff c3 cc cc cc cc 31 c0 81 e6 00 00 08 00
74 32
[   72.029353] RSP: 0018:ffffb14582f8fa80 EFLAGS: 00010282
[   72.029354] RAX: 0000000080000001 RBX: ffffd79904a08568 RCX: 8000000000000225
[   72.029356] RDX: ffffd7990042fd80 RSI: 0000000000290000 RDI: ffffd7990042fd80
[   72.029357] RBP: ffffa00be8215020 R08: 0000000000000000 R09: 0000000000000043
[   72.029358] R10: ffffa00be9c50a00 R11: 0000000000000000 R12: 0000000000290000
[   72.029358] R13: 8000000010bf6225 R14: ffffd7990042fd80 R15: 0000000000080000
[   72.029362] FS:  00007fb185af2740(0000) GS:ffffa01aff600000(0000)
knlGS:0000000000000000
[   72.029363] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.029364] CR2: 000055725030d000 CR3: 000000010ff24002 CR4: 00000000007706f0
[   72.029365] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   72.029366] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   72.029367] PKRU: 55555554
[   72.029368] Call Trace:
[   72.029369]  <TASK>
[   72.029370]  follow_page_pte+0x1a7/0x570
[   72.029374]  __get_user_pages+0x1a2/0x650
[   72.029376]  __gup_longterm_locked+0xdc/0xb50
[   72.029379]  internal_get_user_pages_fast+0x17f/0x310
[   72.029382]  pin_user_pages_fast+0x46/0x60
[   72.029384]  iov_iter_extract_pages+0xc9/0x510
[   72.029388]  ? __kmalloc_large_node+0xb1/0x120
[   72.029392]  ? __kmalloc_node+0xbe/0x130
[   72.029394]  netfs_extract_user_iter+0xbf/0x200 [netfs]
[   72.029404]  __cifs_writev+0x150/0x330 [cifs]
[   72.029561]  vfs_write+0x2a8/0x3c0
[   72.029570]  ksys_pwrite64+0x65/0xa0
[   72.029573]  ? syscall_trace_enter.isra.17+0x126/0x1a0
[   72.029578]  do_syscall_64+0x58/0x80
[   72.029583]  ? exit_to_user_mode_prepare+0x176/0x190
[   72.029585]  ? syscall_exit_to_user_mode+0x12/0x30
[   72.029589]  ? do_syscall_64+0x67/0x80
[   72.029590]  ? syscall_exit_to_user_mode+0x12/0x30
[   72.029591]  ? do_syscall_64+0x67/0x80
[   72.029592]  ? do_syscall_64+0x67/0x80
[   72.029593]  ? do_syscall_64+0x67/0x80
[   72.029595]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   72.029598] RIP: 0033:0x7fb185012448
[   72.029601] Code: 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00
00 00 f3 0f 1e fa 8b 05 06 d0 20 00 49 89 ca 85 c0 75 17 b8 12 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 41 55 49 89
cd 41
[   72.029602] RSP: 002b:00007ffd8f67ae48 EFLAGS: 00000246 ORIG_RAX:
0000000000000012
[   72.029604] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fb185012448
[   72.029605] RDX: 0000000002000000 RSI: 0000000000604000 RDI: 0000000000000004
[   72.029606] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fb18521b2f0
[   72.029606] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
[   72.029607] R13: 00007ffd8f67aff0 R14: 0000000000000000 R15: 0000000000000000
[   72.029609]  </TASK>
[   72.029610] ---[ end trace 0000000000000000 ]---
[   72.029612] netfs: Couldn't get user pages (rc=-12)
