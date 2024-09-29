Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3071386B4
	for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727625947; cv=none; b=AwY0SoF9aD+C1L6pBjvp2WWd07P50p/WUIiH0Ge+OTkvKQ/Vnm9K3iYxZPyTGIhnMh3nhwWVe/Qe/EuWE/NsVJRdMj4UtdGqxvRSwvGJp2pJFaXOu2jVWd1aHS/1HNlNhhfXucPF+CXDLnZ2f4m38vgA/mF5sMz2iBAwxC+2ECg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727625947; c=relaxed/simple;
	bh=DRc9vjEfCutCgjyPmtF0x+agNGNeWQ921majW1ua+kQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=uXa5UJfurGcOtvSwO+5uRl88f0Wsxen7gU3zSuG0B7ahphCzhCRtnjh3NrpX2Lq8H0BwOYcozUp3cIGNjeDsdKyIClqQrLpLKTKoaSxFknYVindIcCK8DTIKaS9K9CNEND8zzlo8EzagnGDxQ2ies9nPsTw1Mo4oy8gYZTQbg8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HC3JcDmT; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HC3JcDmT"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-537a399e06dso4169034e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 09:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727625944; x=1728230744; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+H94FGEb5ohUWunQcg63aPts6x6SoYIXVLkpRT9Ejo=;
        b=HC3JcDmTOKsz2RJHcgTQB8L6l6FLWhe0DQp6SqsOdLjxrTKLABndavF06APoKGF1TC
         Y5sV/sE8WcB5MqemZmUWV90NS2sS0dswAyV/Eph8wwtU/nKAxNOi++3cTEk38i+WuA/n
         3kFc8hVBamqBauRhnmSt6C/DaM+YwcDpkiEpKh1OYTXXeo51KNqZtSJjriiikcugkcof
         iB3UorIyvQJmfZDchibal0A2fkm426DOxXDd6fH3z+pRI70nw29228F3lE1/47NNwV1a
         AKRoc4CQKBPjdhrooDdAh7mY/R2SZuXbRhqqDRhK9HnA40riw7Rjgiu1WRYQG20bi+y7
         hC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727625944; x=1728230744;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+H94FGEb5ohUWunQcg63aPts6x6SoYIXVLkpRT9Ejo=;
        b=hUs0FRbKs8pVY1BbKaR+wk3qhpGtQ4v1Sc+4Gqw6TOLq5IT41PRhdrfPRJE5ho8tUx
         uvuc/SdunwE5bGycGQawFaC1qt3/VC9aHcWE9+JvjjSACBz/jsuVexo/XBcNHCgvhUZH
         ADNL3/32rVfFTILoGXWzyoF1a6WMRuwA3h+aJ68vP0sWOZ+HoW26KLi6FhdlDQfeBrJG
         CAX98rMiyaMUxca4AY4f5TMSYgEYQPCcr6dzN0n8EnpHzO8QHArrXOyLnyA9G+hzrLoB
         xlTTRw8KOLZCPWgRa54qu+3SCPj1YTs6jonAh/Vw/yKlmGSAvyTFL3zfFK888G1mu2Sm
         G86w==
X-Gm-Message-State: AOJu0YwQiXxl24HysfMJV3luqOtzwbbEmZJuSID23EIuhEPVCh8pJo1O
	khM7/AqTt1Gw2LLEcL9YmhkkTf7m0bWXCie06cg2reU+h3pc7bYLDxcmjoyTm5YzGOfVBzoGA1a
	zujF43zIaKLy+2M3DJZ8GT0VFj7gfqsfB
X-Google-Smtp-Source: AGHT+IEWs+gUb6laGjWqVFpV1oyd95xfLV31oSABu/DkT4qnEY1WlmDMz01wjylQlYvO/9OVvepXGD3sLdotz0pgHi4=
X-Received: by 2002:a05:6512:3c8f:b0:536:53b2:1d0d with SMTP id
 2adb3069b0e04-5389fc30f11mr4440145e87.9.1727625943432; Sun, 29 Sep 2024
 09:05:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 11:05:32 -0500
Message-ID: <CAH2r5mszmtcJi7yd6xREje5rPy=WEvL3RQ=7qSQC3K+PGOzatg@mail.gmail.com>
Subject: Re: xfstests generic/089
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

After killing the test and doing rmmod I saw this error logged
(although module removed ok).  Anyone else seen this?

[57667.830388] ------------[ cut here ]------------
[57667.830392] kmem_cache_destroy cifs_small_rq: Slab cache still has
objects when called from exit_cifs+0x65/0x7a0 [cifs]
[57667.830543] WARNING: CPU: 3 PID: 858022 at mm/slab_common.c:511
kmem_cache_destroy+0x129/0x190
[57667.830557] Modules linked in: nfnetlink_queue nfnetlink_log
ib_core cifs(OE-) rfcomm snd_seq_dummy snd_hrtimer snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables br_netfilter bridge stp llc nls_utf8 cachefiles
cifs_arc4 nls_ucs2_utils cifs_md4 netfs ccm overlay cmac algif_hash
algif_skcipher af_alg qrtr bnep sch_fq_codel elan_i2c
intel_uncore_frequency intel_uncore_frequency_common intel_tcc_cooling
iwlmvm snd_sof_pci_intel_cnl snd_sof_intel_hda_generic
x86_pkg_temp_thermal intel_powerclamp soundwire_intel coretemp
kvm_intel soundwire_cadence crct10dif_pclmul polyval_clmulni btusb
snd_sof_intel_hda_common polyval_generic ghash_clmulni_intel
sha256_ssse3 btrtl sha1_ssse3 btintel aesni_intel btbcm crypto_simd
cryptd btmtk snd_soc_hdac_hda kvm binfmt_misc mac80211
snd_sof_intel_hda_mlink snd_sof_intel_hda nls_iso8859_1 snd_sof_pci
nouveau
[57667.830746]  snd_sof_xtensa_dsp snd_sof snd_sof_utils
snd_soc_acpi_intel_match soundwire_generic_allocation snd_soc_acpi
soundwire_bus cmdlinepart spi_nor snd_soc_avs mtd ee1004 mei_pxp
mei_hdcp snd_soc_hda_codec snd_hda_ext_core snd_hda_codec_realtek
snd_soc_core snd_hda_codec_generic snd_hda_scodec_component
intel_rapl_msr snd_hda_codec_hdmi snd_compress ac97_bus
snd_pcm_dmaengine uvcvideo libarc4 snd_hda_intel videobuf2_vmalloc uvc
snd_intel_dspcfg videobuf2_memops videobuf2_v4l2 snd_intel_sdw_acpi
iwlwifi snd_hda_codec rapl videobuf2_common snd_hda_core videodev
intel_cstate think_lmi bluetooth snd_hwdep firmware_attributes_class
processor_thermal_device_pci_legacy intel_wmi_thunderbolt wmi_bmof
snd_pcm mc cfg80211 processor_thermal_device processor_thermal_wt_hint
i2c_i801 processor_thermal_rfim spi_intel_pci nvidiafb spi_intel
i2c_mux processor_thermal_rapl vgastate mei_me snd_timer i2c_smbus
intel_rapl_common snd_ctl_led fb_ddc processor_thermal_wt_req
processor_thermal_power_floor mei processor_thermal_mbox
[57667.830913]  intel_soc_dts_iosf intel_pch_thermal thinkpad_acpi
nvram int3403_thermal int340x_thermal_zone intel_pmc_core intel_vsec
int3400_thermal pmt_telemetry acpi_thermal_rel acpi_pad pmt_class
joydev input_leds nfsd mac_hid serio_raw auth_rpcgss mxm_wmi drm_gpuvm
drm_exec gpu_sched drm_ttm_helper nfs_acl ttm lockd drm_display_helper
cec grace rc_core i2c_algo_bit sunrpc msr parport_pc ppdev lp parport
nvme_fabrics nvme_keyring efi_pstore nfnetlink dmi_sysfs ip_tables
x_tables autofs4 xfs btrfs blake2b_generic raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 wacom hid_generic usbhid hid 8250_dw
nvme rtsx_pci_sdmmc e1000e nvme_core ucsi_acpi snd typec_ucsi
intel_lpss_pci psmouse crc32_pclmul intel_lpss rtsx_pci typec
nvme_auth idma64 soundcore video sparse_keymap platform_profile wmi
pinctrl_cannonlake [last unloaded: cifs]
[57667.831115] CPU: 3 UID: 0 PID: 858022 Comm: rmmod Tainted: G    B
   OE      6.11.0+ #22
[57667.831126] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MO=
DULE
[57667.831130] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[57667.831134] RIP: 0010:kmem_cache_destroy+0x129/0x190
[57667.831144] Code: 31 c0 31 d2 31 c9 31 f6 31 ff c3 cc cc cc cc 48
8b 53 60 48 8b 4d 08 48 c7 c6 c0 58 04 8c 48 c7 c7 d8 48 67 8c e8 b7
10 ce ff <0f> 0b 48 8b 53 68 48 8b 43 70 48 c7 c7 60 d6 03 8d 48 89 42
08 48
[57667.831150] RSP: 0018:ffffaab348107bc8 EFLAGS: 00010246
[57667.831157] RAX: 0000000000000000 RBX: ffff9f7f002d0e00 RCX: 00000000000=
00000
[57667.831162] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[57667.831167] RBP: ffffaab348107bd0 R08: 0000000000000000 R09: 00000000000=
00000
[57667.831172] R10: 0000000000000000 R11: 0000000000000000 R12: 0000637ffdc=
96778
[57667.831176] R13: 00000000000000b0 R14: 0000000000000000 R15: 00000000000=
00000
[57667.831181] FS:  0000775517d25080(0000) GS:ffff9f867b980000(0000)
knlGS:0000000000000000
[57667.831188] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[57667.831193] CR2: 0000595d4602f540 CR3: 000000011f08a002 CR4: 00000000003=
706f0
[57667.831199] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[57667.831203] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[57667.831209] Call Trace:
[57667.831212]  <TASK>
[57667.831216]  ? show_regs+0x6c/0x80
[57667.831226]  ? __warn+0x8d/0x150
[57667.831233]  ? kmem_cache_destroy+0x129/0x190
[57667.831244]  ? report_bug+0x182/0x1b0
[57667.831251]  ? irq_work_queue+0x2f/0x70
[57667.831263]  ? handle_bug+0x6e/0xb0
[57667.831270]  ? exc_invalid_op+0x18/0x80
[57667.831277]  ? asm_exc_invalid_op+0x1b/0x20
[57667.831289]  ? kmem_cache_destroy+0x129/0x190
[57667.831298]  ? kmem_cache_destroy+0x129/0x190
[57667.831308]  exit_cifs+0x65/0x7a0 [cifs]
[57667.831446]  __do_sys_delete_module.isra.0+0x19f/0x310
[57667.831459]  __x64_sys_delete_module+0x12/0x20
[57667.831467]  x64_sys_call+0x13cc/0x25f0
[57667.831475]  do_syscall_64+0x7e/0x170
[57667.831485]  ? kernfs_seq_start+0x65/0xc0
[57667.831497]  ? do_fault+0x292/0x4e0
[57667.831505]  ? __handle_mm_fault+0x824/0x10a0
[57667.831512]  ? vfs_read+0x297/0x380
[57667.831534]  ? __count_memcg_events+0x85/0x160
[57667.831544]  ? count_memcg_events.constprop.0+0x2a/0x50
[57667.831554]  ? handle_mm_fault+0xaf/0x2e0
[57667.831564]  ? do_user_addr_fault+0x5d5/0x870
[57667.831572]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[57667.831581]  ? irqentry_exit_to_user_mode+0x2d/0x1d0
[57667.831591]  ? irqentry_exit+0x43/0x50
[57667.831600]  ? exc_page_fault+0x96/0x1c0
[57667.831609]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[57667.831619] RIP: 0033:0x77551752ac9b
[57667.831625] Code: 73 01 c3 48 8b 0d 7d 81 0d 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4d 81 0d 00 f7 d8 64 89
01 48
[57667.831631] RSP: 002b:00007ffdbb11e888 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[57667.831639] RAX: ffffffffffffffda RBX: 0000637ffdc96710 RCX: 00007755175=
2ac9b
[57667.831644] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000637ffdc=
96778
[57667.831649] RBP: 00007ffdbb11e8b0 R08: 1999999999999999 R09: 00000000000=
00000
[57667.831654] R10: 00007755175b1fc0 R11: 0000000000000206 R12: 00000000000=
00000
[57667.831659] R13: 00007ffdbb11eb00 R14: 0000637ffdc96710 R15: 00000000000=
00000
[57667.831671]  </TASK>
[57667.831674] ---[ end trace 0000000000000000 ]---

On Sun, Sep 29, 2024 at 10:32=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Has anyone seen xfstest generic/089 going forever (sending compounded
> open/close then open then close forever)?  This was with current
> for-next, running to current Samba master (localhost) with "linux"
> mount option
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
