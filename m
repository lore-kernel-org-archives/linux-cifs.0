Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D965C83F1E
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Aug 2023 18:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbjH3Sx1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244043AbjH3MUg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Aug 2023 08:20:36 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E924CC2
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 05:20:32 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-d72cf9156easo4926620276.0
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 05:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693398031; x=1694002831; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IB7GdhP2U/taz0sSfXrtyk6ebrvewemFx6/BdToafPM=;
        b=m+A/keOQ/2xeqNMlupfJKhV3J7e8lPfm2OZREZuMKJMpJIWlf5MQN4L3TFxzT57LUr
         hTu4cqFud1Nrc6jaSVzoP+5BsjisrJ6D29oAvxu0deqPeHZpgRWC/Ntcjnx6t/ulHPz1
         od9JNGRFO9gNKtwrSwzpdE0J/iBoFc0Mai3VgoGOhQ3zXAjJp2NemOQgCzfDhUQDrQJq
         /jDp/bJJROGZb7iG3dKHOkiuiH1YUNYx0Ww+RprAup3HhQ0UQQRA3L0RKKwk7roBzFcT
         DGjLZrncaUuDPDLzImMsASZbACi26xGJTkA/B0omrBAlqjJ75X/Fg5CfLKbxh991kDpO
         eYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693398031; x=1694002831;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IB7GdhP2U/taz0sSfXrtyk6ebrvewemFx6/BdToafPM=;
        b=i7cKwZ+yg7/a8YDm6iVfQKiNOWlVra44jYE9SupU0h7/NUNEG876Fio3r4qWs5LS73
         iHkshsAV4FN529JahLV1piZrEWNX54fjBiEWDIBjglMjT9I1/Pf55/+Kk00JZNXPBgPw
         Bv6/BM0WMj+OxN7TysfmCWXEQwvAJJIZ/icRTNYBROR1FpStG6ss5qUVwScRcUZMyxxn
         lfhfs/TW3d5CEbEROVrRCuq6SEV+a08CY49HwjddrPldXwlLWqIt+jn5qYyWEJmnYJ1C
         qC/YTBJtgHY3dahlPPSF93gwteZcoqyo9CIFKBneFNbw7uHkNAheo1pv0t0QUc+j+IN/
         Zdyw==
X-Gm-Message-State: AOJu0YxxOEwqhB+zCIhNwj3H/4+yvPlbsPbalhwuddLVY/GuCESeKsRp
        NjiFAhIlB7nV3blncA5yiNFdzA3BZwbh3RHjFmKLo95AtH8=
X-Google-Smtp-Source: AGHT+IG1tqDJAqHMwqwycaayaI5djw03Bs4gfTWV049ie02UoEJCWJ+H9PTleHmhrGG+eMtKlvrX3Eq6RRM5NuAmdxU=
X-Received: by 2002:a25:257:0:b0:d7b:8acc:beb0 with SMTP id
 84-20020a250257000000b00d7b8accbeb0mr1989408ybc.42.1693398031242; Wed, 30 Aug
 2023 05:20:31 -0700 (PDT)
MIME-Version: 1.0
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 30 Aug 2023 20:20:20 +0800
Message-ID: <CADJHv_tztxLsa4GGEWXG4FxWp8cFh__5zF5qU5kTB45h9cO_VA@mail.gmail.com>
Subject: WARNING: CPU: 5 PID: 60057 at fs/smb/client/connect.c:2417 cifs_put_tcon.part.0+0x281/0x290
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Looping fstests generic/412 can trigger this warning resulting a panic.

I'm using the samba server in Fedora Rawhide:

 samba                           x86_64  2:4.19.0-0.4.rc3.fc40
 samba-client                  x86_64  2:4.19.0-0.4.rc3.fc40

------ testparm info ------

samba shares:
Load smb config files from /etc/samba/smb.conf
Loaded services file OK.
Weak crypto is allowed by GnuTLS (e.g. NTLM as a compatibility fallback)

Server role: ROLE_STANDALONE

# Global parameters
[global]
idmap config * : backend = tdb


[test]
path = /export/test
read only = No


[scratch]
path = /export/scratch
read only = No

------ testparm info  end------

Mount options is " -o vers=3.11,mfsymlinks"

Kernel version is the latest upstream 6.5.0.

Thanks,
Murphy


[  841.449048] ./checking generic/412
[  841.683690] CIFS: Attempting to mount //127.0.0.1/test
[  841.686211] ------------[ cut here ]------------
[  841.686863] WARNING: CPU: 5 PID: 60057 at
fs/smb/client/connect.c:2417 cifs_put_tcon.part.0+0x281/0x290 [cifs]
[  841.688364] Modules linked in: nls_utf8 cifs cifs_arc4 cifs_md4
dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common
sunrpc sb_edac x86_pkg_temp_thermal intel_powerclamp ipmi_ssif
coretemp kvm_intel kvm irqbypass iTCO_wdt acpi_ipmi ipmi_si rapl
intel_pmc_bxt i2c_i801 iTCO_vendor_support intel_cstate ipmi_devintf
intel_uncore hpilo lpc_ich ioatdma i2c_smbus ipmi_msghandler igb
pcspkr acpi_power_meter acpi_tad dca fuse loop zram xfs
crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni
polyval_generic ghash_clmulni_intel sha512_ssse3 serio_raw mgag200
hpwdt i2c_algo_bit wmi
[  841.690949] CPU: 5 PID: 60057 Comm: mount.cifs Not tainted 6.5.0 #1
[  841.691682] Hardware name: HP ProLiant DL80 Gen9/ProLiant DL80
Gen9, BIOS U15 10/21/2019
[  841.692086] RIP: 0010:cifs_put_tcon.part.0+0x281/0x290 [cifs]
[  841.693113] Code: e8 48 c7 c1 b0 3d d9 c0 48 c7 c2 e0 a5 e2 c0 41
89 c1 48 c7 c6 08 5b df c0 48 c7 c7 70 7e cd c0 e8 14 d7 c6 d9 e9 45
fe ff ff <0f> 0b e9 c5 fd ff ff 0f 1f 84 00 00 00 00 00 90 90 90 90 90
90 90
[  841.694452] RSP: 0018:ffffb7bf40f73c68 EFLAGS: 00010286
[  841.694731] RAX: 00000000ffffffff RBX: ffff9da3c5889800 RCX: 0000000000000000
[  841.695470] RDX: 0000000000000001 RSI: ffff9da42f092c00 RDI: ffff9da3c5889828
[  841.696221] RBP: ffff9da3c5889828 R08: 000000000000000a R09: 0000000000000000
[  841.696988] R10: ffff9da42da78c40 R11: 0000000000000100 R12: ffff9da3d863a800
[  841.697804] R13: ffff9da3c5889800 R14: ffff9da42486ee40 R15: ffff9da42f092c00
[  841.698692] FS:  00007f91e9a06780(0000) GS:ffff9da537940000(0000)
knlGS:0000000000000000
[  841.699098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  841.699807] CR2: 00007f9435193540 CR3: 0000000101024002 CR4: 00000000001706e0
[  841.700589] Call Trace:
[  841.700738]  <TASK>
[  841.701227]  ? cifs_put_tcon.part.0+0x281/0x290 [cifs]
[  841.701718]  ? __warn+0x81/0x130
[  841.702376]  ? cifs_put_tcon.part.0+0x281/0x290 [cifs]
[  841.702864]  ? report_bug+0x171/0x1a0
[  841.703069]  ? handle_bug+0x3c/0x80
[  841.703706]  ? exc_invalid_op+0x17/0x70
[  841.703923]  ? asm_exc_invalid_op+0x1a/0x20
[  841.704122]  ? cifs_put_tcon.part.0+0x281/0x290 [cifs]
[  841.704626]  ? cifs_put_tcon.part.0+0x36/0x290 [cifs]
[  841.705112]  cifs_put_tlink+0x49/0x70 [cifs]
[  841.706092]  cifs_match_super+0x10f/0x3d0 [cifs]
[  841.707020]  ? __pfx_cifs_match_super+0x10/0x10 [cifs]
[  841.707504]  sget+0x1c1/0x2b0
[  841.708065]  ? __pfx_cifs_set_super+0x10/0x10 [cifs]
[  841.708554]  cifs_smb3_do_mount+0x217/0x760 [cifs]
[  841.709679]  smb3_get_tree+0xce/0x280 [cifs]
[  841.710598]  vfs_get_tree+0x29/0xf0
[  841.711201]  path_mount+0x4a3/0xae0
[  841.711968]  __x64_sys_mount+0x11a/0x150
[  841.712217]  do_syscall_64+0x60/0x90
[  841.712412]  ? count_memcg_events.constprop.0+0x1a/0x30
[  841.712673]  ? handle_mm_fault+0x9e/0x350
[  841.712878]  ? do_user_addr_fault+0x179/0x640
[  841.713501]  ? exc_page_fault+e fa 49 89 ca b8 a5 00 00 00 0f 05
<48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b2 12 12 00 f7 d8 64 89 01 48
[  842.214890] RSP: 002b:00007ffe6c404078 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[  842.215693] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f91e9716b4e
[  842.216624] RDX: 0000559bb88a1476 RSI: 0000559bb88a14dc RDI: 00007ffe6c405152
[  842.217396] RBP: 00007ffe6c404130 R08: 0000559bb9a20eb0 R09: 0000000000000000
[  842.218180] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559bb88a103f
[  842.218944] R13: 0000559bb9a21f10 R14: 00007ffe6c405152 R15: 00007f91e9a17000
[  842.220193]  </TASK>
[  842.220429] ---[ end trace 0000000000000000 ]---
[  842.221077] BUG: scheduling while atomic: mount.cifs/60057/0x00000002
[  842.221455] Modules linked in: nls_utf8 cifs cifs_arc4 cifs_md4
dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common
sunrpc sb_edac x86_pkg_temp_thermal intel_powerclamp ipmi_ssif
coretemp kvm_intel kvm irqbypass iTCO_wdt acpi_ipmi ipmi_si rapl
intel_pmc_bxt i2c_i801 iTCO_vendor_support intel_cstate ipmi_devintf
intel_uncore hpilo lpc_ich ioatdma i2c_smbus ipmi_msghandler s
Tainted: G        W          6.5.0 #1
[  842.723585] Hardware name: HP ProLiant DL80 Gen9/ProLiant DL80
Gen9, BIOS U15 10/21/2019
[  842.723995] Call Trace:
[  842.724128]  <TASK>
[  842.724679]  dump_stack_lvl+0x47/0x60
[  842.724901]  __schedule_bug+0x56/0x70
[  842.725092]  __schedule+0x106a/0x14c0
[  842.725313]  schedule+0x5e/0xd0
[  842.725970]  wait_for_response+0x96/0xe0 [cifs]
[  842.726771]  ? __pfx_autoremove_wake_function+0x10/0x10
[  842.727054]  compound_send_recv+0x461/0xa90 [cifs]
[  842.727941]  ? mempool_alloc+0x89/0x1b0
[  842.728181]  cifs_send_recv+0x23/0x30 [cifs]
[  842.729037]  SMB2_tdis+0x2b9/0x3c0 [cifs]
[  842.729460]  ? cifs_put_tcon.part.0+0xe7/0x290 [cifs]
[  842.729966]  cifs_put_tcon.part.0+0xe7/0x290 [cifs]
[  842.730750]  cifs_put_tlink+0x49/0x70 [cifs]
[  842.731547]  cifs_match_super+0x10f/0x3d0 [cifs]
[  842.732541]  ? __pfx_cifs_match_super+0x10/0x10 [cifs]
[  842.733097]  sget+0x1c1/0x2b0
[  842.733678]  ? __pfx_cifs_set_super+0x10/0x10 [cifs]
[  842.734213]  cifs_smb3_do_mount+0x217/0x760 [cifs]
[  842.735003]  smb3_get_tree+0xce/0x280 [cifs]
[  842.735778]  vfs_get_tree+0x29/0xf0
[  842.736355]  path_mount+0x4a3/0xae0
[  842.736993]  __ault+0x179/0x640
[  843.237833]  ? exc_page_fault+0x7f/0x180
[  843.238050]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  843.238334] RIP: 0033:0x7f91e9716b4e
[  843.238527] Code: 48 8b 0d e5 12 12 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b2 12 12 00 f7 d8 64 89
01 48
[  843.239814] RSP: 002b:00007ffe6c404078 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[  843.240749] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f91e9716b4e
[  843.241566] RDX: 0000559bb88a1476 RSI: 0000559bb88a14dc RDI: 00007ffe6c405152
[  843.242321] RBP: 00007ffe6c404130 R08: 0000559bb9a20eb0 R09: 0000000000000000
[  843.243103] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559bb88a103f
[  843.244140] R13: 0000559bb9a21f10 R14: 00007ffe6c405152 R15: 00007f91e9a17000
[  843.245109]  </TASK>
[  843.245363] ------------[ cut here ]------------
[  843.246039] kernel BUG at mm/slub.c:440!
[  843.246277] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  843.246533] CPU: 11 PID: 60057 Comm: mount.cifs Tainted: G        W
         6.5.0 #1
[  843.246914] Hardware name: HP ProLiant DL80 Gen9/ProLiant DL80
Gen9, BIOS U15 10/21/2019
[  843.247319] RIP: 0010:__slab_free+0x152/0x330
[  843.248097] Code: 8b 06 48 89 0c 24 48 c1 e8 36 48 8b 84 c3 d8 00
00 00 48 89 c7 48 89 44 24 20 e8 29 97 bc 00 48 8b 0c 24 48 89 44 24
08 eb 87 <0f> 0b f7 43 08 00 0d 21 00 75 ca eb c3 f7 43 08 00 0d 21 00
0f 84
[  843.249649] RSP: 0018:ffffb7bf40f73b30 EFLAGS: 00010246
[  843.249935] RAX: ffff9da3c5903390 RBX: ffff9da3c0042400 R[
843.730400] R10: ffffb7bf40f73c68 R11: 0000000000000100 R12:
ffff9da3c5903380
[  843.751313] R13: ffff9da3c5903380 R14: fffff4aa441640c0 R15: dead000000000100
[  843.752078] FS:  00007f91e9a06780(0000) GS:ffff9da537ac0000(0000)
knlGS:0000000000000000
[  843.752526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  843.753228] CR2: 000055bad95f8290 CR3: 0000000101024003 CR4: 00000000001706e0
[  843.754224] Call Trace:
[  843.754417]  <TASK>
[  843.754909]  ? die+0x36/0x90
[  843.755472]  ? do_trap+0xda/0x100
[  843.756140]  ? __slab_free+0x152/0x330
[  843.756354]  ? do_error_trap+0x6a/0x90
[  843.756548]  ? __slab_free+0x152/0x330
[  843.756738]  ? exc_invalid_op+0x50/0x70
[  843.756929]  ? __slab_free+0x152/0x330
[  843.757117]  ? asm_exc_invalid_op+0x1a/0x20
[  843.757332]  ? free_cached_dirs+0x14d/0x180 [cifs]
[  843.758125]  ? __slab_free+0x152/0x330
[  843.758347]  free_cached_dirs+0x14d/0x180 [cifs]
[  843.759105]  tconInfoFree+0x29/0x130 [cifs]
[  843.759468]  cifs_put_tcon.part.0+0xfe/0x290 [cifs]
[  843.760219]  cifs_put_tlink+0x49/0x70 [cifs]
[  843.760956]  cifs_match_super+0x10f/0x3d0 [cifs]
[  843.761722]  ? __pfx_cifs_match_super+0x10/0x10 [cifs]
[  843.762133]  sget+0x1c1/0x2b0
[  843.762674]  ? __pfx_cifs_set_super+0x10/0x10 [cifs]
[  843.763081]  cifs_smb3_do_m__x64_sys_mount+0x11a/0x150
[  844.263687]  do_syscall_64+0x60/0x90
[  844.263878]  ? count_memcg_events.constprop.0+0x1a/0x30
[  844.264122]  ? handle_mm_fault+0x9e/0x350
[  844.264375]  ? do_user_addr_fault+0x179/0x640
[  844.264965]  ? exc_page_fault+0x7f/0x180
[  844.265185]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  844.265441] RIP: 0033:0x7f91e9716b4e
[  844.265644] Code: 48 8b 0d e5 12 12 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b2 12 12 00 f7 d8 64 89
01 48
[  844.266922] RSP: 002b:00007ffe6c404078 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[  844.267666] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f91e9716b4e
[  844.268380] RDX: 0000559bb88a1476 RSI: 0000559bb88a14dc RDI: 00007ffe6c405152
[  844.269096] RBP: 00007ffe6c404130 R08: 0000559bb9a20eb0 R09: 0000000000000000
[  844.269844] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559bb88a103f
[  844.270587] R13: 0000559bb9a21f10 R14: 00007ffe6c405152 R15: 00007f91e9a17000
[  844.271299]  </TASK>
[  844.271434] Modules linked in: nls_utf8 cifs cifs_arc4 cifs_md4
dns_resolver fscache nec_smbus ipmi_msghandler igb pcspkr
acpi_power_meter acpi_tad dca fuse loop zram xfs crct10dif_pclmul
crc32_pclmul crc32c_intel polyval_clmulni polyval_generic
ghash_clmulni_intel sha512_ssse3 serio_raw mgag200 hpwdt i2c_algo_bit
wmi
[  844.773065] ---[ end trace 0000000000000000 ]---
[  844.775279] pstore: backend (erst) writing error (-28)
[  844.775585] RIP: 0010:__slab_free+0x152/0x330
[  844.776201] Code: 8b 06 48 89 0c 24 48 c1 e8 36 48 8b 84 c3 d8 00
00 00 48 89 c7 48 89 44 24 20 e8 29 97 bc 00 48 8b 0c 24 48 89 44 24
08 eb 87 <0f> 0b f7 43 08 00 0d 21 00 75 ca eb c3 f7 43 08 00 0d 21 00
0f 84
[  844.777437] RSP: 0018:ffffb7bf40f73b30 EFLAGS: 00010246
[  844.777726] RAX: ffff9da3c5903390 RBX: ffff9da3c0042400 RCX: 0000000080800072
[  844.778433] RDX: fffffffe8ef03380 RSI: ffff9da3c5903380 RDI: ffffb7bf40f73ba0
[  844.779152] RBP: ffffb7bf40f73bd0 R08: 0000000000000001 R09: ffffffffc0c5d96d
[  844.779900] R10: ffffb7bf40f73c68 R11: 0000000000000100 R12: ffff9da3c5903380
[  844.780671] R13: ffff9da3c5903380 R14: fffff4aa441640c0 R15: dead000000000100
[  844.0101024003 CR4: 00000000001706e0
[  845.282046] Kernel panic - not syncing: Fatal exception
[  845.282427] Kernel Offset: 0x19000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  845.284558] ---[ end Kernel panic - not syncing: Fatal exception ]---
