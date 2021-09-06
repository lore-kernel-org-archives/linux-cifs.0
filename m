Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B318C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 05:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 812EF60EBA
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Sep 2021 05:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhIFFoN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 01:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhIFFoM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 01:44:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C36CC061575
        for <linux-cifs@vger.kernel.org>; Sun,  5 Sep 2021 22:43:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so3608511pjb.0
        for <linux-cifs@vger.kernel.org>; Sun, 05 Sep 2021 22:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=stD+27V/yXOLtXxW7DmjjZCLgsBCy8q6e93PaiYYG4E=;
        b=O0Ys6OAFNYL0DRGpmvxaPErl/r4VAs+SjsGkbs7/c/2J8BRSg0v01S69tskz4VYuNt
         xr7+K5YR2hE+sl8bMefcN5VMzh0Ts9mPx3L9E5GdEi6ZojNFezmYvh9vB6FiXT5QmXoL
         VietiLAcBxjcqDrbbL77d/v/muFF3N43GKrkriDuOAp6okSclldMFnCfHXMvwu5deVJL
         4i4KDbtceuaw4NcdsQziqWzS6euVcHFDxsUxoNdR17+cOeqiWtMW1THX0iMkmL6IAern
         9C8hCiRwTyoVheTQNrwX1Wsql7DAQUgszPSpKt20pGz5APl+3tBiAcNgkLqn3UWlPUYF
         rczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=stD+27V/yXOLtXxW7DmjjZCLgsBCy8q6e93PaiYYG4E=;
        b=fAKkAIF1342SyvO/nhhtfzCHTnHKok+dCAcPdwIN2ViEMB3iihWxHOqquNWmPEI/e+
         9n9OYF+DkTqWP/tfaGD6fdE9cOlYEpfhclgQis8F7vMdeVilTX7AEqNAMb0eEM1tAnjA
         HlbRG9zc147XQZwr+BmwTNAxcpx+RJtcf8gnNCV6gI6N4aU8t1bkJI9LtLWzWAH8qiYI
         HbVOhWWhtOToTUSK6WBiz7YEO6gpURFAbiMzdmo9C7aSeEM0tUpK2GDrDSIUWpkX/tGz
         S3+5S1tsnLjFa6WQhNAoIFgPCKJY7FPiyAc0vAC/ehsTG++DCsNNiuJYs+zZjzCg0ClB
         oXnw==
X-Gm-Message-State: AOAM532geomS9iVBa0tVrnBWkPflu3k6au66UCGBGmKTbaQI/N9Mavgp
        CzMrRzHAaVzxLYmxvyqyAN9eIpu3fjc=
X-Google-Smtp-Source: ABdhPJwsk9J78FBgHpKpcNhO0Od7CErHvKYRmwdvA3fGlPv2Yn49vBzEIeioFa93W7XpAH1R1JBbhA==
X-Received: by 2002:a17:90b:3742:: with SMTP id ne2mr12292321pjb.218.1630906987333;
        Sun, 05 Sep 2021 22:43:07 -0700 (PDT)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q20sm7638041pgu.31.2021.09.05.22.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:43:06 -0700 (PDT)
Date:   Mon, 6 Sep 2021 13:42:58 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Rohith Surabattula <rohiths@microsoft.com>, bgoncalv@redhat.com
Subject: [regression] fsstress hung since 5.14-rc5-smb3-fixes
Message-ID: <20210906054258.si3itgafckvfpsdc@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Since this commit:

commit 9e992755be8f2d458a0bcbefd19e493483c1dba2
Author: Rohith Surabattula <rohiths@microsoft.com>
Date:   Mon Aug 9 09:32:46 2021 +0000

    cifs: Call close synchronously during unlink/rename/lease break.


CIFS can't finish a basic fsstress testcase. The kernel is soft locked up and
never returns. You can't stop these IO process but restarting the server.
For example, xfstests generic/051. The server is samba-4.14 and it's always
reproducible. See call traces in the end of this email.

Reverting this commit can fix this.

Other xfstest fsstress testcase like generic/461 can also hit this issue.


Thanks,
Murphy


---
Soft lock up call trace from fsstress test:

[  130.698396] watchdog: BUG: soft lockup - CPU#6 stuck for 26s! [xfs_fsr:6618]
[  130.705489] Modules linked in: nls_utf8 cifs cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common sunrpc isst_if_common nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif mgag200 i2c_algo_bit drm_kms_helper irqbypass acpi_ipmi syscopyarea sysfillrect ipmi_si rapl ses sysimgblt intel_cstate fb_sys_fops enclosure intel_uncore cec ipmi_devintf mei_me mei acpi_tad ipmi_msghandler pcspkr lpc_ich ioatdma hpilo acpi_power_meter dca drm fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul uas crc32_pclmul crc32c_intel smartpqi serio_raw usb_storage tg3 ghash_clmulni_intel scsi_transport_sas hpwdt wmi
[  130.765809] CPU: 6 PID: 6618 Comm: xfs_fsr Kdump: loaded Tainted: G          I       5.14.0-master-27151f177827+ #32
[  130.776391] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  130.784960] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x44/0x190
[  130.791706] Code: 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 8b 02 <84> c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00 81 fe
[  130.795394] watchdog: BUG: soft lockup - CPU#22 stuck for 26s! [cifsd:6084]
[  130.810583] RSP: 0018:ffffaedb4abcbb88 EFLAGS: 00000202
[  130.817582] Modules linked in:
[  130.817582]
[  130.817583] RAX: 0000000000000101 RBX: ffffa016a569fec0 RCX: 0000000000000000
[  130.822833]  nls_utf8
[  130.825902] RDX: ffffffffc0deb2b4 RSI: 0000000000000000 RDI: ffffffffc0deb2b4
[  130.827396]  cifs
[  130.834569] RBP: ffffa01dc2a8c000 R08: 0000000000000001 R09: 0000000000000064
[  130.836851]  cifs_arc4
[  130.844023] R10: ffffa016a569fec0 R11: 0000000074736574 R12: ffffa016a569fec0
[  130.845956]  rdma_cm
[  130.853129] R13: ffffaedb4abcbcf0 R14: ffffaedb4abcbc6c R15: 0000000000000000
[  130.855497]  iw_cm
[  130.862669] FS:  00007fa1ece9d740(0000) GS:ffffa01d9fd80000(0000) knlGS:0000000000000000
[  130.864861]  ib_cm
[  130.872034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  130.874053]  ib_core
[  130.882186] CR2: 00007ffc4ea8bf40 CR3: 000000015448c002 CR4: 00000000007706e0
[  130.884205]  cifs_md4
[  130.889980] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  130.892172]  dns_resolver
[  130.899346] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  130.901628]  fscache
[  130.908801] PKRU: 55555554
[  130.911432]  netfs
[  130.918604] Call Trace:
[  130.920796]  rfkill
[  130.923515]  _raw_spin_lock+0x1a/0x20
[  130.925533]  intel_rapl_msr
[  130.927989]  _get_xid+0x11/0xa0 [cifs]
[  130.930093]  intel_rapl_common
[  130.933773]  cifs_revalidate_dentry_attr+0x70/0x360 [cifs]
[  130.936577]  sunrpc
[  130.940344]  cifs_revalidate_dentry+0xf/0x20 [cifs]
[  130.943408]  isst_if_common
[  130.948922]  cifs_d_revalidate+0x51/0x150 [cifs]
[  130.951028]  nfit
[  130.955931]  lookup_fast+0xd2/0x160
[  130.958735]  x86_pkg_temp_thermal
[  130.963376]  walk_component+0x41/0x1d0
[  130.965308]  intel_powerclamp
[  130.968813]  path_lookupat+0x6e/0x1b0
[  130.972141]  coretemp kvm_intel
[  130.975908]  __filename_lookup+0xcf/0x1d0
[  130.978887]  kvm
[  130.982566]  ? path_openat+0x21d/0x2b0
[  130.985721]  ipmi_ssif
[  130.989749]  ? __virt_addr_valid+0x45/0x70
[  130.991593]  mgag200
[  130.995360]  ? __check_object_size.part.0+0x11f/0x140
[  130.997729]  i2c_algo_bit
[  131.001843]  user_path_at_empty+0x3a/0x60
[  131.004036]  drm_kms_helper
[  13[  158.698098] watchdog: BUG: soft lockup - CPU#6 stuck for 52s! [xfs_fsr:6618]
[  158.705188] Modules linked in: nls_utf8 cifs cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common sunrpc isst_if_common nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif mgag200 i2c_algo_bit drm_kms_helper irqbypass acpi_ipmi syscopyarea sysfillrect ipmi_si rapl ses sysimgblt intel_cstate fb_sys_fops enclosure intel_uncore cec ipmi_devintf mei_me mei acpi_tad ipmi_msghandler pcspkr lpc_ich ioatdma hpilo acpi_power_meter dca drm fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul uas crc32_pclmul crc32c_intel smartpqi serio_raw usb_storage tg3 ghash_clmulni_intel scsi_transport_sas hpwdt wmi
[  158.765499] CPU: 6 PID: 6618 Comm: xfs_fsr Kdump: loaded Tainted: G          I  L    5.14.0-master-27151f177827+ #32
[  158.776079] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  158.784648] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x42/0x190
[  158.791390] Code: 0f ba 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[  158.795096] watchdog: BUG: soft lockup - CPU#22 stuck for 52s! [cifsd:6084]
[  158.810268] RSP: 0018:ffffaedb4abcbb88 EFLAGS: 00000202
[  158.817266] Modules linked in: nls_utf8
[  158.822517]
[  158.822518] RAX: 0000000000000101 RBX: ffffa016a569fec0 RCX: 0000000000000000
[  158.826369]  cifs
[  158.827864] RDX: ffffffffc0deb2b4 RSI: 0000000000000000 RDI: ffffffffc0deb2b4
[  158.835036]  cifs_arc4
[  158.836969] RBP: ffffa01dc2a8c000 R08: 0000000000000001 R09: 0000000000000064
[  158.844140]  rdma_cm
[  158.846508] R10: ffffa016a569fec0 R11: 0000000074736574 R12: ffffa016a569fec0
[  158.853680]  iw_cm
[  158.855873] R13: ffffaedb4abcbcf0 R14: ffffaedb4abcbc6c R15: 0000000000000000
[  158.863046]  ib_cm
[  158.865064] FS:  00007fa1ece9d740(0000) GS:ffffa01d9fd80000(0000) knlGS:0000000000000000
[  158.872237]  ib_core
[  158.874255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.882388]  cifs_md4
[  158.884581] CR2: 00007ffc4ea8bf40 CR3: 000000015448c002 CR4: 00000000007706e0
[  158.890357]  dns_resolver
[  158.892639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.899812]  fscache
[  158.902443] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  158.909615]  netfs
[  158.911808] PKRU: 55555554
[  158.918982]  rfkill
[  158.921000] Call Trace:
[  158.923718]  intel_rapl_msr
[  158.925824]  _raw_spin_lock+0x1a/0x20
[  158.928279]  intel_rapl_common
[  158.931084]  _get_xid+0x11/0xa0 [cifs]
[  158.934763]  sunrpc isst_if_common
[  158.937831]  cifs_revalidate_dentry_attr+0x70/0x360 [cifs]
[  158.941597]  nfit
[  158.945015]  cifs_revalidate_dentry+0xf/0x20 [cifs]
[  158.950527]  x86_pkg_temp_thermal
[  158.952460]  cifs_d_revalidate+0x51/0x150 [cifs]
[  158.957361]  intel_powerclamp
[  158.960691]  lookup_fast+0xd2/0x160
[  158.965329]  coretemp
[  158.968310]  walk_component+0x41/0x1d0
[  158.971813]  kvm_intel
[  158.974096]  path_lookupat+0x6e/0x1b0
[  158.977861]  kvm
[  158.980231]  __filename_lookup+0xcf/0x1d0
[  158.983908]  ipmi_ssif
[  158.985754]  ? path_openat+0x21d/0x2b0
[  158.989780]  mgag200
[  158.992149]  ? __virt_addr_valid+0x45/0x70
[  158.995914]  i2c_algo_bit
[  158.998109]  ? __check_object_size.part.0+0x11f/0x140
[  159.002223]  drm_kms_helper
[  159.004855]  user_path_at_empty+0x3a/0x60
[  159.009930]  irqbypass
[  159.012736]  vfs_statx+0x74/0x130
[  159.016762]  acpi_ipmi
[  159.019131]  ? rcu_nocb_try_bypass+0x4a/0x3f0
[  159.022461]  syscopyarea
[  159.024831]  __do_sys_newfstatat+0x31/0x70
[  159.029209]  sysfillrect
[  159.031752]  ? syscall_trace_enter.constprop.0+0x13d/0x1b0
[  159.035867]  ipmi_si
[  159.038412]  do_syscall_64+0x38/0x90
[  159.043925]  rapl
[  159.046120]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  159.049711]  ses
[  159.051644] RIP: 0033:0x7fa1ecfa0dee
[  159.056719]  sysimgblt
[  159.058565] Code: 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 07 00 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 41 89 ca b8 06 01 00 00 0f 05 <3d> 00 f0 ff ff 77 0b 31 c0 c3 0f 1f 84 00 00 00 00 00 48 8b 15 01
[  159.062157]  intel_cstate
[  159.064527] RSP: 002b:00007ffc4ea8dfc8 EFLAGS: 00000202
[  159.083404]  fb_sys_fops
[  159.086036]  ORIG_RAX: 0000000000000106
[  159.091286]  enclosure
[  159.093828] RAX: ffffffffffffffda RBX: 00007ffc4ea8e728 RCX: 00007fa1ecfa0dee
[  159.097682]  intel_uncore
[  159.100051] RDX: 00007ffc4ea8e070 RSI: 00007ffc4ea903e9 RDI: 00000000ffffff9c
[  159.107224]  cec
[  159.109854] RBP: 0000000000000003 R08: 00000000018f12f0 R09: 0000000000000001
[  159.117026]  ipmi_devintf
[  159.118871] R10: 0000000000000100 R11: 0000000000000202 R12: 00007ffc4ea903e9
[  159.126043]  mei_me
[  159.128675] R13: 00007ffc4ea8e070 R14: 00007fa1ed11cc00 R15: 000000000040ce08
[  159.135847]  mei acpi_tad ipmi_msghandler pcspkr lpc_ich ioatdma hpilo acpi_power_meter dca drm fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul uas crc32_pclmul crc32c_intel smartpqi serio_raw usb_storage tg3 ghash_clmulni_intel scsi_transport_sas hpwdt wmi
[  159.168470] CPU: 22 PID: 6084 Comm: cifsd Kdump: loaded Tainted: G          I  L    5.14.0-master-27151f177827+ #32
[  159.178963] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  159.187532] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x42/0x190
[  159.194272] Code: 0f ba 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[  159.213149] RSP: 0018:ffffaedb47e5fd48 EFLAGS: 00000202
[  159.218401] RAX: 0000000000000101 RBX: ffffffffc0deb2c4 RCX: 0000000000000000
[  159.225573] RDX: ffffffffc0deb2c4 RSI: 0000000000000000 RDI: ffffffffc0deb2c4
[  159.232746] RBP: ffffa01732f27800 R08: ffffa01732f27800 R09: ffffaedb47e5fd08
[  159.239919] R10: ffffa016888a0000 R11: ffffffffa0c060e0 R12: ffffa01dcaca0000
[  159.247092] R13: ffffaedb47e5feb0 R14: ffffa016b8c4cf00 R15: ffffa01dcaca0000
[  159.254264] FS:  0000000000000000(0000) GS:ffffa01d9ff00000(0000) knlGS:0000000000000000
[  159.262399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  159.268175] CR2: 0000560f1678c958 CR3: 0000000ae1e10003 CR4: 00000000007706e0
[  159.275348] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  159.282520] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  159.289693] PKRU: 55555554
[  159.292412] Call Trace:
[  159.294867]  _raw_spin_lock+0x1a/0x20
[  159.298548]  cifs_put_smb_ses+0x37/0x3b0 [cifs]
[  159.303130]  smb2_find_smb_tcon+0x8a/0xd0 [cifs]
[  159.307803]  smb2_handle_cancelled_mid+0x3e/0x90 [cifs]
[  159.313087]  _cifs_mid_q_entry_release+0x83/0xb0 [cifs]
[  159.318367]  cifs_mid_q_entry_release+0x41/0x50 [cifs]
[  159.323560]  cifs_demultiplex_thread+0x2f5/0x7a0 [cifs]
[  159.328838]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  159.334027]  kthread+0x10c/0x130
[  159.337271]  ? set_kthread_struct+0x40/0x40
[  159.341475]  ret_from_fork+0x1f/0x30
[  163.490051] rcu: INFO: rcu_sched self-detected stall on CPU
[  163.495654] rcu: 	22-....: (58901 ticks this GP) idle=335/1/0x4000000000000000 softirq=2462/2462 fqs=15001
[  163.505451] 	(t=60016 jiffies g=19949 q=792)
[  163.509744] NMI backtrace for cpu 22
[  163.513336] CPU: 22 PID: 6084 Comm: cifsd Kdump: loaded Tainted: G          I  L    5.14.0-master-27151f177827+ #32
[  163.523829] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  163.532399] Call Trace:
[  163.534857]  <IRQ>
[  163.536877]  dump_stack_lvl+0x34/0x44
[  163.540562]  nmi_cpu_backtrace.cold+0x30/0x6f
[  163.544941]  ? lapic_can_unplug_cpu+0x80/0x80
[  163.549321]  nmi_trigger_cpumask_backtrace+0xd2/0xe0
[  163.554316]  trigger_single_cpu_backtrace+0x2a/0x2d
[  163.559224]  rcu_dump_cpu_stacks+0xaa/0xe3
[  163.563341]  print_cpu_stall.cold+0x2f/0xd2
[  163.567546]  check_cpu_stall+0xe9/0x240
[  163.571403]  rcu_pending+0x26/0x130
[  163.574909]  rcu_sched_clock_irq+0x43/0x100
[  163.579114]  update_process_times+0x8c/0xc0
[  163.583319]  tick_sched_handle+0x22/0x60
[  163.587265]  tick_sched_timer+0x61/0x70
[  163.591122]  ? tick_sched_do_timer+0x50/0x50
[  163.595415]  __hrtimer_run_queues+0x127/0x270
[  163.599796]  hrtimer_interrupt+0xfc/0x210
[  163.603825]  __sysvec_apic_timer_interrupt+0x59/0xd0
[  163.608820]  sysvec_apic_timer_interrupt+0x6d/0x90
[  163.613637]  </IRQ>
[  163.615742]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  163.620907] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x42/0x190
[  163.627646] Code: 0f ba 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[  163.646525] RSP: 0018:ffffaedb47e5fd48 EFLAGS: 00000202
[  163.651779] RAX: 0000000000000101 RBX: ffffffffc0deb2c4 RCX: 0000000000000000
[  163.658952] RDX: ffffffffc0deb2c4 RSI: 0000000000000000 RDI: ffffffffc0deb2c4
[  163.666125] RBP: ffffa01732f27800 R08: ffffa01732f27800 R09: ffffaedb47e5fd08
[  163.673299] R10: ffffa016888a0000 R11: ffffffffa0c060e0 R12: ffffa01dcaca0000
[  163.680471] R13: ffffaedb47e5feb0 R14: ffffa016b8c4cf00 R15: ffffa01dcaca0000
[  163.687646]  _raw_spin_lock+0x1a/0x20
[  163.691328]  cifs_put_smb_ses+0x37/0x3b0 [cifs]
[  163.695906]  smb2_find_smb_tcon+0x8a/0xd0 [cifs]
[  163.700580]  smb2_handle_cancelled_mid+0x3e/0x90 [cifs]
[  163.705865]  _cifs_mid_q_entry_release+0x83/0xb0 [cifs]
[  163.711146]  cifs_mid_q_entry_release+0x41/0x50 [cifs]
[  163.716339]  cifs_demultiplex_thread+0x2f5/0x7a0 [cifs]
[  163.721616]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  163.726806]  kthread+0x10c/0x130
[  163.730051]  ? set_kthread_struct+0x40/0x40
[  163.734256]  ret_from_fork+0x1f/0x30
[  186.697897] watchdog: BUG: soft lockup - CPU#6 stuck for 78s! [xfs_fsr:6618]
[  186.704986] Modules linked in: nls_utf8 cifs cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common sunrpc isst_if_common nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif mgag200 i2c_algo_bit drm_kms_helper irqbypass acpi_ipmi syscopyarea sysfillrect ipmi_si rapl ses sysimgblt intel_cstate fb_sys_fops enclosure intel_uncore cec ipmi_devintf mei_me mei acpi_tad ipmi_msghandler pcspkr lpc_ich ioatdma hpilo acpi_power_meter dca drm fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul uas crc32_pclmul crc32c_intel smartpqi serio_raw usb_storage tg3 ghash_clmulni_intel scsi_transport_sas hpwdt wmi
[  186.765293] CPU: 6 PID: 6618 Comm: xfs_fsr Kdump: loaded Tainted: G          I  L    5.14.0-master-27151f177827+ #32
[  186.775874] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  186.784446] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x42/0x190
[  186.791186] Code: 0f ba 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[  186.810063] RSP: 0018:ffffaedb4abcbb88 EFLAGS: 00000202
[  186.815314] RAX: 0000000000000101 RBX: ffffa016a569fec0 RCX: 0000000000000000
[  186.822488] RDX: ffffffffc0deb2b4 RSI: 0000000000000000 RDI: ffffffffc0deb2b4
[  186.829662] RBP: ffffa01dc2a8c000 R08: 0000000000000001 R09: 0000000000000064
[  186.836836] R10: ffffa016a569fec0 R11: 0000000074736574 R12: ffffa016a569fec0
[  186.844009] R13: ffffaedb4abcbcf0 R14: ffffaedb4abcbc6c R15: 0000000000000000
[  186.851183] FS:  00007fa1ece9d740(0000) GS:ffffa01d9fd80000(0000) knlGS:0000000000000000
[  186.859319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  186.865096] CR2: 00007ffc4ea8bf40 CR3: 000000015448c002 CR4: 00000000007706e0
[  186.872268] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  186.879442] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  186.886615] PKRU: 55555554
[  186.889332] Call Trace:
[  186.891789]  _raw_spin_lock+0x1a/0x20
[  186.895471]  _get_xid+0x11/0xa0 [cifs]
[  186.899270]  cifs_revalidate_dentry_attr+0x70/0x360 [cifs]
[  186.904811]  cifs_revalidate_dentry+0xf/0x20 [cifs]
[  186.909740]  cifs_d_revalidate+0x51/0x150 [cifs]
[  186.914406]  lookup_fast+0xd2/0x160
[  186.917913]  walk_component+0x41/0x1d0
[  186.921683]  path_lookupat+0x6e/0x1b0
[  186.925364]  __filename_lookup+0xcf/0x1d0
[  186.929392]  ? path_openat+0x21d/0x2b0
[  186.933160]  ? __virt_addr_valid+0x45/0x70
[  186.937279]  ? __check_object_size.part.0+0x11f/0x140
[  186.942357]  user_path_at_empty+0x3a/0x60
[  186.946386]  vfs_statx+0x74/0x130
[  186.949717]  ? rcu_nocb_try_bypass+0x4a/0x3f0
[  186.954096]  __do_sys_newfstatat+0x31/0x70
[  186.958213]  ? syscall_trace_enter.constprop.0+0x13d/0x1b0
[  186.963729]  do_syscall_64+0x38/0x90
[  186.967323]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  186.972401] RIP: 0033:0x7fa1ecfa0dee
[  186.975994] Code: 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 07 00 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 41 89 ca b8 06 01 00 00 0f 05 <3d> 00 f0 ff ff 77 0b 31 c0 c3 0f 1f 84 00 00 00 00 00 48 8b 15 01
[  186.994872] RSP: 002b:00007ffc4ea8dfc8 EFLAGS: 00000202 ORIG_RAX: 0000000000000106
[  187.002483] RAX: ffffffffffffffda RBX: 00007ffc4ea8e728 RCX: 00007fa1ecfa0dee
[  187.009655] RDX: 00007ffc4ea8e070 RSI: 00007ffc4ea903e9 RDI: 00000000ffffff9c
[  187.016829] RBP: 0000000000000003 R08: 00000000018f12f0 R09: 0000000000000001
[  187.024003] R10: 0000000000000100 R11: 0000000000000202 R12: 00007ffc4ea903e9
[  187.031175] R13: 00007ffc4ea8e070 R14: 00007fa1ed11cc00 R15: 000000000040ce08
[  190.794869] watchdog: BUG: soft lockup - CPU#22 stuck for 82s! [cifsd:6084]
[  190.801872] Modules linked in: nls_utf8 cifs cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 dns_resolver fscache netfs rfkill intel_rapl_msr intel_rapl_common sunrpc isst_if_common nfit x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif mgag200 i2c_algo_bit drm_kms_helper irqbypass acpi_ipmi syscopyarea sysfillrect ipmi_si rapl ses sysimgblt intel_cstate fb_sys_fops enclosure intel_uncore cec ipmi_devintf mei_me mei acpi_tad ipmi_msghandler pcspkr lpc_ich ioatdma hpilo acpi_power_meter dca drm fuse xfs libcrc32c sd_mod t10_pi sg crct10dif_pclmul uas crc32_pclmul crc32c_intel smartpqi serio_raw usb_storage tg3 ghash_clmulni_intel scsi_transport_sas hpwdt wmi
[  190.862180] CPU: 22 PID: 6084 Comm: cifsd Kdump: loaded Tainted: G          I  L    5.14.0-master-27151f177827+ #32
[  190.872674] Hardware name: HPE ProLiant DL388 Gen10/ProLiant DL388 Gen10, BIOS U30 04/18/2019
[  190.881243] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x42/0x190
[  190.887983] Code: 0f ba 2a 08 0f 92 c1 8b 02 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ed 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[  190.906861] RSP: 0018:ffffaedb47e5fd48 EFLAGS: 00000202
[  190.912113] RAX: 0000000000000101 RBX: ffffffffc0deb2c4 RCX: 0000000000000000
[  190.919287] RDX: ffffffffc0deb2c4 RSI: 0000000000000000 RDI: ffffffffc0deb2c4
[  190.926460] RBP: ffffa01732f27800 R08: ffffa01732f27800 R09: ffffaedb47e5fd08
[  190.933631] R10: ffffa016888a0000 R11: ffffffffa0c060e0 R12: ffffa01dcaca0000
[  190.940804] R13: ffffaedb47e5feb0 R14: ffffa016b8c4cf00 R15: ffffa01dcaca0000
[  190.947976] FS:  0000000000000000(0000) GS:ffffa01d9ff00000(0000) knlGS:0000000000000000
[  190.956110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  190.961887] CR2: 0000560f1678c958 CR3: 0000000ae1e10003 CR4: 00000000007706e0
[  190.969062] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  190.976236] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  190.983409] PKRU: 55555554
[  190.986127] Call Trace:
[  190.988584]  _raw_spin_lock+0x1a/0x20
[  190.992267]  cifs_put_smb_ses+0x37/0x3b0 [cifs]
[  190.996848]  smb2_find_smb_tcon+0x8a/0xd0 [cifs]
[  191.001524]  smb2_handle_cancelled_mid+0x3e/0x90 [cifs]
[  191.006809]  _cifs_mid_q_entry_release+0x83/0xb0 [cifs]
[  191.012090]  cifs_mid_q_entry_release+0x41/0x50 [cifs]
[  191.017286]  cifs_demultiplex_thread+0x2f5/0x7a0 [cifs]
[  191.022562]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  191.027752]  kthread+0x10c/0x130
[  191.030995]  ? set_kthread_struct+0x40/0x40
[  191.035199]  ret_from_fork+0x1f/0x30


