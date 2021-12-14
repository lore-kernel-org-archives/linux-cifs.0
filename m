Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5571C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Dec 2021 21:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhLNVGK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Dec 2021 16:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbhLNVGJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Dec 2021 16:06:09 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0792C061574
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 13:06:09 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id n15so19813544qta.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 13:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=EUIW1WBl6OqGDvO4fIDINUlRK/gpKS4f3FX5baY53dw=;
        b=PJRrxjgdiqPdM8RK9IFTBfoCB+WnxNbbPsghERO9KlUksSvmCUvJB+/KhRJSzv/XfM
         9M98n1Nf8HL04I3CQHXM2g9wg8ZjnZVFUdJZQZZPegwfc/aLwIU1x4AXQ2HPk02cu3n+
         rgTzndm19NQ8SvINgYtdpxQ1DnUJqq0iTrCOh5DtVP4pir3cTEygJI0aJvY8S1yAJHQ1
         4fYEEo2qj3igrThx8plfq6TLQBzR6w686xUTb1WicRJR3Cnxg0U1rHwO+2g3G8He8H1A
         zsHEGCFp/5GrhnHAbNd/7O0XjElWqddtAWOq/+WCME+B1h6lf9EC8Rxv+JZ/hhmqRtkH
         wOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EUIW1WBl6OqGDvO4fIDINUlRK/gpKS4f3FX5baY53dw=;
        b=j6SM8cgmAc5pQ4xoGWSvwxCuxA3iqAtKED3vvCKNq/bXWD8rp6CJZNJc9vLHHoTOLK
         L1L4ogoHA/+nS9ZFVskMd+qofXjr8Tm4lbpMTvU2hZ5BKxtm/2sVhG5zjEMUuySJi71F
         Vgf6OpPLw5z/4n85eNXuin89uNhclOO3ewjoyQ0eiXLhgrzpvYmJnxPwW2q31ERotBGg
         6L1gnp4upmFL1q3V09zR9KrE5oiEhJPN0P4xQ/wS/1JS6y80VwAG6eLK6zOij0yNBxev
         PImcNeIXpoCfZsjx6JMBsyyzS38Fct92fhH+o5K5Nkh77Kc0YPMybb0SmjIbkkQBuBYj
         AL7g==
X-Gm-Message-State: AOAM5326cx0tbM4n1tmxLyNaRPl6KvBRHt7MWVEy4lxsYEryXUoiwzcS
        /EL7S/Myc+MzcFWImTXbIvwns7R6doUVcvK0Bxj5fMILRzs=
X-Google-Smtp-Source: ABdhPJwx6yGXfWbBVCOCeFFx5hbWhV0NMv/gGNqLzG8kc7VVcpyklkiw+6hPjwu6qtg0nCF1EykC60YST0IkWg8eAxk=
X-Received: by 2002:ac8:7fc5:: with SMTP id b5mr8660501qtk.351.1639515968542;
 Tue, 14 Dec 2021 13:06:08 -0800 (PST)
MIME-Version: 1.0
From:   Ryan Bair <ryandbair@gmail.com>
Date:   Tue, 14 Dec 2021 16:05:58 -0500
Message-ID: <CAAWC1ohFHN85PcqXrZiH+4WPjHx+z1bqNfJ4rE2gdhSE9+WBHw@mail.gmail.com>
Subject: NULL pointer deref on 4.16.0-rc5 with multiuser mounts
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Listing the directory as root works as expected, but when attempting
as a user with credentials stored this happens:

[ 1645.700809] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 1645.700817] #PF: supervisor read access in kernel mode
[ 1645.700821] #PF: error_code(0x0000) - not-present page
[ 1645.700824] PGD 0 P4D 0
[ 1645.700829] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 1645.700834] CPU: 10 PID: 8304 Comm: bash Not tainted
5.16.0-0.rc5.35.fc36.x86_64 #1
[ 1645.700839] Hardware name: ASUS System Product Name/PRIME Z690-P
D4, BIOS 0605 11/12/2021
[ 1645.700842] RIP: 0010:strnlen+0x17/0x30
[ 1645.700852] Code: 38 00 75 f7 48 29 f8 c3 31 c0 c3 0f 1f 84 00 00
00 00 00 48 8d 14 37 48 89 f8 48 85 f6 75 0b eb 19 48 83 c0 01 48 39
c2 74 09 <80> 38 00 75 f2 48 29 f8 c3 48 89 d0 48 29 f8 c3 31 c0 c3 66
0f 1f
[ 1645.700856] RSP: 0018:ffffb672802cbaa0 EFLAGS: 00010206
[ 1645.700861] RAX: 0000000000000000 RBX: 000000000000002e RCX: ffffffffc0272000
[ 1645.700864] RDX: 0000000000000041 RSI: 0000000000000041 RDI: 0000000000000000
[ 1645.700866] RBP: ffff8b11411bac00 R08: 00000000000001c0 R09: ffff8b116bc99600
[ 1645.700869] R10: 0000000000000001 R11: 0000000000000049 R12: ffffb672802cbaee
[ 1645.700871] R13: ffff8b1150f03000 R14: ffff8b1150f03000 R15: 0000000000000002
[ 1645.700874] FS:  00007ff6095ca740(0000) GS:ffff8b189f480000(0000)
knlGS:0000000000000000
[ 1645.700878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1645.700880] CR2: 0000000000000000 CR3: 000000031e188004 CR4: 0000000000770ee0
[ 1645.700884] PKRU: 55555554
[ 1645.700885] Call Trace:
[ 1645.700889]  <TASK>
[ 1645.700894]  size_of_ntlmssp_blob+0x6a/0x90 [cifs]
[ 1645.700986]  build_ntlmssp_negotiate_blob+0x38/0x120 [cifs]
[ 1645.701049]  SMB2_sess_auth_rawntlmssp_negotiate+0xa1/0x1e0 [cifs]
[ 1645.701127]  SMB2_sess_setup+0x1cf/0x2c0 [cifs]
[ 1645.701192]  cifs_setup_session+0xb7/0x1c0 [cifs]
[ 1645.701251]  cifs_get_smb_ses+0x674/0xdd0 [cifs]
[ 1645.701306]  ? cifs_sb_tlink+0x64c/0xd40 [cifs]
[ 1645.701360]  ? kfree+0xaa/0x3e0
[ 1645.701366]  cifs_sb_tlink+0x41d/0xd40 [cifs]
[ 1645.701420]  cifs_get_inode_info+0x62/0xa40 [cifs]
[ 1645.701480]  ? irq_work_queue+0x35/0x50
[ 1645.701486]  ? trace_buffer_unlock_commit_regs+0x47/0x240
[ 1645.701496]  cifs_revalidate_dentry_attr+0x158/0x370 [cifs]
[ 1645.701552]  cifs_getattr+0xb8/0x250 [cifs]
[ 1645.701604]  vfs_statx+0x90/0x100
[ 1645.701611]  __do_sys_newfstatat+0x1e/0x40
[ 1645.701618]  do_syscall_64+0x38/0x90
[ 1645.701626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1645.701634] RIP: 0033:0x7ff6096cdcbe
[ 1645.701638] Code: 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff
e9 07 00 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 41 89 ca b8 06 01 00
00 0f 05 <3d> 00 f0 ff ff 77 0b 31 c0 c3 0f 1f 84 00 00 00 00 00 48 8b
15 31
[ 1645.701642] RSP: 002b:00007ffe30bfd0c8 EFLAGS: 00000246 ORIG_RAX:
0000000000000106
[ 1645.701647] RAX: ffffffffffffffda RBX: 00005560a3f32c5f RCX: 00007ff6096cdcbe
[ 1645.701649] RDX: 00007ffe30bfd0f0 RSI: 00005560a3f32c50 RDI: 00000000ffffff9c
[ 1645.701652] RBP: 0000000000000000 R08: 00005560a3f32c51 R09: 0000000000000001
[ 1645.701654] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
[ 1645.701657] R13: 00005560a3f32c51 R14: 00005560a3f32c5f R15: 00005560a3f32c50
[ 1645.701663]  </TASK>
[ 1645.701665] Modules linked in: uinput snd_seq_dummy snd_hrtimer
nls_utf8 cifs cifs_arc4 cifs_md4 dns_resolver fscache netfs nft_objref
nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject tun nft_ct nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink qrtr
intel_rapl_msr sunrpc iTCO_wdt intel_pmc_bxt pmt_telemetry ee1004
mei_hdcp iTCO_vendor_support pmt_class intel_rapl_common
intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass rapl intel_cstate intel_uncore eeepc_wmi
asus_wmi sparse_keymap platform_profile rfkill pcspkr wmi_bmof
snd_sof_pci_intel_tgl vfat fat snd_sof_intel_hda_common
soundwire_intel soundwire_generic_allocation soundwire_cadence
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof
snd_soc_hdac_hda snd_hda_ext_core snd_soc_acpi_intel_match
snd_soc_acpi soundwire_bus snd_soc_core
[ 1645.701750]  snd_hda_codec_realtek snd_hda_codec_generic
snd_compress ac97_bus ledtrig_audio snd_hda_codec_hdmi
snd_pcm_dmaengine i2c_i801 i2c_smbus snd_hda_intel snd_intel_dspcfg
snd_intel_sdw_acpi snd_hda_codec mei_me snd_hda_core mei snd_hwdep
snd_seq idma64 snd_seq_device snd_pcm joydev xpad snd_timer snd
intel_pmt soundcore acpi_tad acpi_pad zram ip_tables hid_microsoft
ff_memless amdgpu iommu_v2 gpu_sched hid_logitech_hidpp
hid_logitech_dj i915 radeon crct10dif_pclmul crc32_pclmul crc32c_intel
nvme r8169 ghash_clmulni_intel nvme_core drm_ttm_helper ttm vmd wmi
video pinctrl_alderlake ipmi_devintf ipmi_msghandler fuse
[ 1645.701813] CR2: 0000000000000000
[ 1645.701817] ---[ end trace 9bfea57ad4ec1112 ]---
[ 1645.701820] RIP: 0010:strnlen+0x17/0x30
[ 1645.701826] Code: 38 00 75 f7 48 29 f8 c3 31 c0 c3 0f 1f 84 00 00
00 00 00 48 8d 14 37 48 89 f8 48 85 f6 75 0b eb 19 48 83 c0 01 48 39
c2 74 09 <80> 38 00 75 f2 48 29 f8 c3 48 89 d0 48 29 f8 c3 31 c0 c3 66
0f 1f
[ 1645.701829] RSP: 0018:ffffb672802cbaa0 EFLAGS: 00010206
[ 1645.701833] RAX: 0000000000000000 RBX: 000000000000002e RCX: ffffffffc0272000
[ 1645.701836] RDX: 0000000000000041 RSI: 0000000000000041 RDI: 0000000000000000
[ 1645.701838] RBP: ffff8b11411bac00 R08: 00000000000001c0 R09: ffff8b116bc99600
[ 1645.701841] R10: 0000000000000001 R11: 0000000000000049 R12: ffffb672802cbaee
[ 1645.701843] R13: ffff8b1150f03000 R14: ffff8b1150f03000 R15: 0000000000000002
[ 1645.701846] FS:  00007ff6095ca740(0000) GS:ffff8b189f480000(0000)
knlGS:0000000000000000
[ 1645.701849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1645.701852] CR2: 0000000000000000 CR3: 000000031e188004 CR4: 0000000000770ee0
[ 1645.701855] PKRU: 55555554

fstab entry:
//192.168.1.51/media    /smb/rexx/media         smb3
multiuser,sec=ntlmssp,credentials=/etc/rexx.creds   0 0
