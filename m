Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7BEB64C
	for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 03:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723607673; cv=none; b=b2qMhYeVWieaUuipdA1ihBSw81LQTLI0QCRUn73gdvYK/SDzsAqff9Ea7c5hqgQB9T4YmMYFurj2bENPwLQgLAE80SL3lijg0nrGYGMG0XEffxeYMjiaJETGorZXsFicDLa7EvbkteXh/o3U1E13prnFJE+VGSiLuOTyD+FlUS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723607673; c=relaxed/simple;
	bh=/R3QoQzRs4aMcCHornKYO82tO1VmhgsE/4wClcEXf6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=B458YXb66TG+g0YO0JD72fudqdZIamSEsuKWiLizTHE3fOq9VqOpl9crz5rOJRcIcCyRR/2gFQoJIeo4mmFeqwEjEr7OlVfATjz6MUfF7m2iE8tORPmiZdQ9ue1wXPuQjQC8n3nwlcY9Siy8IwybJOXROu+DNB1Td6Dds6++l4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1X7ul4H; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1X7ul4H"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52efd08e6d9so7849846e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 13 Aug 2024 20:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723607668; x=1724212468; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eE9omwZhxClzXKxzVZBC0R546kBKkDF7/L7XpXqAM4w=;
        b=E1X7ul4HhPBlENpL+86F4fZENbUSFfpJUoCOrby9m53s8yPCuoYjPN7IYxApwjaEax
         i8vdqaqYT4ek3cNpTsqStOqreOLO/Cs9LEwd3HRFwTzM4BEuyF/GSHX/7p4LTWL0eZcV
         FI6pvueMGUF8r9rUZdnsVO0m4ChmZ4uBz3gapTxIscaHCQDnMldggROHGBCWq/2tKF6C
         VFicAh/Fyjc9ytmjXt55imCJJrmyYSpf6KdXWVX9sSLo5vQW1TAlRqGjXoH8ED+BTGDp
         iw1MHVtxiAsD3v2W6MFWhKPewjoibVPFkA+/DPvAym9oxnbqXqeOpox8DqCynPyXIKIW
         VOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723607668; x=1724212468;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eE9omwZhxClzXKxzVZBC0R546kBKkDF7/L7XpXqAM4w=;
        b=fd9wSNNstTEfahawFk2LcaCPUUF6xl+ZESU6TNdRlb2lB+/rpRWkFYPAZTmx3/6Fgt
         Towf4Z0t8tDcsgL66IATcb5EIPTzgQX2wGMByyk02GvbXd35DR5JPoWOHUNqEf9IoYFp
         6JUYgdpxu9dGFjip7933p0VLO8X5CgyuiKnvUM96lmqAC3K4fej/n80bK53dSDLX/pyq
         u8IdXNF0snbpBhM3xSge5CIGbuUc5vx7CFpBJxbmFN5ZmVjtgLCwLNg+uOKEX5jdseXr
         U5aPP5j2kikKpsVmqL3kFNzk2aWhFrFoX/zx2gzpGuMhbnD+hIrZ0Bp0uZrGNS7NJfix
         Q95A==
X-Gm-Message-State: AOJu0YykjFI/M2I+cXJzUuT8oiJfvZ+VaIJS9e1DfIVnnglOPNuobQwQ
	19L/G0Rc5//3Ynl1FwRgnUjr2dPBDXa0ZGDtRvywTkQ68hqGinatNF5584TcimUClGYgUOsp2DB
	OcSOvqh4yu3vlIicnK1iqZi6iH3/zsw==
X-Google-Smtp-Source: AGHT+IEap11h0mvre+hsL94KtJt7yYuxC9akHaoB7iMeGZTdFoqHJaT+B3mwBuM2PNHmqJokOy77uIKHZCANBp5sX3g=
X-Received: by 2002:a05:6512:131b:b0:52c:d5b3:1a6a with SMTP id
 2adb3069b0e04-532eda81a3fmr682477e87.28.1723607667831; Tue, 13 Aug 2024
 20:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQ+Q6T97AmMP1nDF-m3eWTwUvrk2oFeEXzCW0PjkH4JA@mail.gmail.com>
In-Reply-To: <CAH2r5muQ+Q6T97AmMP1nDF-m3eWTwUvrk2oFeEXzCW0PjkH4JA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 13 Aug 2024 22:54:16 -0500
Message-ID: <CAH2r5msbX0_O+Y1sqmhaCfoYRpuyhukwYp-Z=u=RJjmeuvafbQ@mail.gmail.com>
Subject: Fwd: ksmbd field spanning write
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Tue, Aug 13, 2024 at 10:52=E2=80=AFPM
Subject: ksmbd field spanning write
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>


I can see this error logged by simply starting ksmbd, and doing
"smbclient -L //localhost".   Ideas ...?

[18540.444483] ------------[ cut here ]------------
[18540.444486] memcpy: detected field-spanning write (size 219) of
single field "(char *)&rsp->hdr.ProtocolId + sz" at
fs/smb/server/smb2pdu.c:1373 (size 0)
[18540.444500] WARNING: CPU: 6 PID: 8319 at
fs/smb/server/smb2pdu.c:1373 ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[18540.444519] Modules linked in: ksmbd crc32_generic rdma_cm iw_cm
ib_cm ib_core rfcomm snd_seq_dummy snd_hrtimer snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables br_netfilter bridge stp llc nls_utf8 cifs_arc4
nls_ucs2_utils cifs_md4 cachefiles netfs ccm overlay cmac algif_hash
algif_skcipher af_alg elan_i2c qrtr bnep binfmt_misc nls_iso8859_1
snd_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel
soundwire_cadence snd_sof_intel_hda_common snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp
intel_uncore_frequency intel_uncore_frequency_common snd_sof
snd_sof_utils snd_soc_hdac_hda snd_soc_acpi_intel_match
soundwire_generic_allocation snd_soc_acpi soundwire_bus
intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp snd_soc_avs
coretemp snd_soc_hda_codec snd_hda_ext_core snd_ctl_led cmdlinepart
iwlmvm
[18540.444563]  snd_soc_core kvm_intel snd_hda_codec_realtek spi_nor
snd_hda_codec_generic snd_compress ac97_bus ee1004 mtd mei_hdcp
mei_pxp intel_rapl_msr snd_hda_scodec_component snd_pcm_dmaengine
snd_hda_codec_hdmi kvm mac80211 crct10dif_pclmul polyval_clmulni
polyval_generic snd_hda_intel ghash_clmulni_intel libarc4
snd_intel_dspcfg sha256_ssse3 snd_intel_sdw_acpi
processor_thermal_device_pci_legacy snd_hda_codec sha1_ssse3 uvcvideo
processor_thermal_device aesni_intel btusb videobuf2_vmalloc
crypto_simd snd_hda_core uvc cryptd btrtl videobuf2_memops
processor_thermal_wt_hint iwlwifi snd_hwdep processor_thermal_rfim
btintel videobuf2_v4l2 rapl i2c_i801 processor_thermal_rapl btbcm
think_lmi spi_intel_pci i2c_mux btmtk intel_rapl_common intel_cstate
videodev nvidiafb firmware_attributes_class wmi_bmof
intel_wmi_thunderbolt spi_intel i2c_smbus snd_pcm cfg80211 mei_me
processor_thermal_wt_req bluetooth videobuf2_common vgastate
processor_thermal_power_floor processor_thermal_mbox fb_ddc mei mc
intel_soc_dts_iosf
[18540.444607]  snd_timer intel_pch_thermal int3403_thermal
int340x_thermal_zone joydev input_leds intel_pmc_core intel_vsec
pmt_telemetry int3400_thermal acpi_thermal_rel acpi_pad pmt_class
mac_hid serio_raw nouveau mxm_wmi drm_gpuvm drm_exec gpu_sched
drm_ttm_helper ttm drm_display_helper cec rc_core i2c_algo_bit nfsd
msr parport_pc auth_rpcgss nfs_acl ppdev lockd grace lp parport
nvme_fabrics efi_pstore sunrpc nfnetlink dmi_sysfs ip_tables x_tables
autofs4 wacom hid_microsoft ff_memless hid_generic usbhid hid xfs
btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 8250_dw
rtsx_pci_sdmmc nvme crc32_pclmul thinkpad_acpi intel_lpss_pci nvram
ucsi_acpi nvme_core psmouse e1000e intel_lpss snd typec_ucsi rtsx_pci
xhci_pci nvme_auth idma64 xhci_pci_renesas typec soundcore video
sparse_keymap platform_profile wmi pinctrl_cannonlake [last unloaded:
ksmbd(OE)]
[18540.444663] CPU: 6 UID: 0 PID: 8319 Comm: kworker/6:0 Tainted: G
    W  OE      6.11.0-061100rc2-generic #202408042216
[18540.444666] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[18540.444667] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[18540.444668] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[18540.444681] RIP: 0010:ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[18540.444693] Code: 00 3c 01 0f 87 9e 48 01 00 a8 01 75 b8 48 c7 c2
88 c5 31 c2 4c 89 fe 48 c7 c7 d8 c5 31 c2 c6 05 aa cd 01 00 01 e8 e1
31 fa ee <0f> 0b eb 97 41 bd f4 ff ff ff e9 df fe ff ff e8 7d cc 13 f0
66 66
[18540.444694] RSP: 0018:ffffaa31cceabcf0 EFLAGS: 00010246
[18540.444696] RAX: 0000000000000000 RBX: ffff9b1c8e0d1204 RCX: 00000000000=
00000
[18540.444698] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[18540.444699] RBP: ffffaa31cceabd40 R08: 0000000000000000 R09: 00000000000=
00000
[18540.444700] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b1c8e0=
d124c
[18540.444701] R13: 0000000000000000 R14: ffff9b1e07912d00 R15: 00000000000=
000db
[18540.444702] FS:  0000000000000000(0000) GS:ffff9b23fbb00000(0000)
knlGS:0000000000000000
[18540.444710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18540.444712] CR2: 00005fa01c7a8000 CR3: 000000013f43e004 CR4: 00000000003=
706f0
[18540.444714] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[18540.444715] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[18540.444717] Call Trace:
[18540.444718]  <TASK>
[18540.444720]  ? show_trace_log_lvl+0x1be/0x310
[18540.444746]  ? show_trace_log_lvl+0x1be/0x310
[18540.444751]  ? smb2_sess_setup+0x936/0xa00 [ksmbd]
[18540.444768]  ? show_regs.part.0+0x22/0x30
[18540.444771]  ? show_regs.cold+0x8/0x10
[18540.444773]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[18540.444787]  ? __warn.cold+0xa7/0x101
[18540.444789]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[18540.444806]  ? report_bug+0x114/0x160
[18540.444809]  ? handle_bug+0x51/0xa0
[18540.444812]  ? exc_invalid_op+0x18/0x80
[18540.444815]  ? asm_exc_invalid_op+0x1b/0x20
[18540.444820]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[18540.444848]  ? ksmbd_release_crypto_ctx+0xa4/0xd0 [ksmbd]
[18540.444869]  smb2_sess_setup+0x936/0xa00 [ksmbd]
[18540.444908]  __process_request+0xa5/0x1c0 [ksmbd]
[18540.444926]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
[18540.444955]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
[18540.444971]  process_one_work+0x174/0x350
[18540.444975]  worker_thread+0x31a/0x450
[18540.444978]  ? _raw_spin_lock_irqsave+0xe/0x20
[18540.444981]  ? __pfx_worker_thread+0x10/0x10
[18540.444983]  kthread+0xe1/0x110
[18540.444986]  ? __pfx_kthread+0x10/0x10
[18540.444989]  ret_from_fork+0x44/0x70
[18540.444992]  ? __pfx_kthread+0x10/0x10
[18540.444994]  ret_from_fork_asm+0x1a/0x30
[18540.444998]  </TASK>
[18540.445000] ---[ end trace 0000000000000000 ]---
[18540.445179] ------------[ cut here ]------------
[18540.445180] memcpy: detected field-spanning write (size 9) of
single field "(char *)&rsp->hdr.ProtocolId + sz" at
fs/smb/server/smb2pdu.c:1456 (size 0)
[18540.445193] WARNING: CPU: 6 PID: 8319 at
fs/smb/server/smb2pdu.c:1456 ntlm_authenticate.isra.0+0x4cd/0x540
[ksmbd]
[18540.445214] Modules linked in: ksmbd crc32_generic rdma_cm iw_cm
ib_cm ib_core rfcomm snd_seq_dummy snd_hrtimer snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables br_netfilter bridge stp llc nls_utf8 cifs_arc4
nls_ucs2_utils cifs_md4 cachefiles netfs ccm overlay cmac algif_hash
algif_skcipher af_alg elan_i2c qrtr bnep binfmt_misc nls_iso8859_1
snd_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel
soundwire_cadence snd_sof_intel_hda_common snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp
intel_uncore_frequency intel_uncore_frequency_common snd_sof
snd_sof_utils snd_soc_hdac_hda snd_soc_acpi_intel_match
soundwire_generic_allocation snd_soc_acpi soundwire_bus
intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp snd_soc_avs
coretemp snd_soc_hda_codec snd_hda_ext_core snd_ctl_led cmdlinepart
iwlmvm
[18540.445291]  snd_soc_core kvm_intel snd_hda_codec_realtek spi_nor
snd_hda_codec_generic snd_compress ac97_bus ee1004 mtd mei_hdcp
mei_pxp intel_rapl_msr snd_hda_scodec_component snd_pcm_dmaengine
snd_hda_codec_hdmi kvm mac80211 crct10dif_pclmul polyval_clmulni
polyval_generic snd_hda_intel ghash_clmulni_intel libarc4
snd_intel_dspcfg sha256_ssse3 snd_intel_sdw_acpi
processor_thermal_device_pci_legacy snd_hda_codec sha1_ssse3 uvcvideo
processor_thermal_device aesni_intel btusb videobuf2_vmalloc
crypto_simd snd_hda_core uvc cryptd btrtl videobuf2_memops
processor_thermal_wt_hint iwlwifi snd_hwdep processor_thermal_rfim
btintel videobuf2_v4l2 rapl i2c_i801 processor_thermal_rapl btbcm
think_lmi spi_intel_pci i2c_mux btmtk intel_rapl_common intel_cstate
videodev nvidiafb firmware_attributes_class wmi_bmof
intel_wmi_thunderbolt spi_intel i2c_smbus snd_pcm cfg80211 mei_me
processor_thermal_wt_req bluetooth videobuf2_common vgastate
processor_thermal_power_floor processor_thermal_mbox fb_ddc mei mc
intel_soc_dts_iosf
[18540.445358]  snd_timer intel_pch_thermal int3403_thermal
int340x_thermal_zone joydev input_leds intel_pmc_core intel_vsec
pmt_telemetry int3400_thermal acpi_thermal_rel acpi_pad pmt_class
mac_hid serio_raw nouveau mxm_wmi drm_gpuvm drm_exec gpu_sched
drm_ttm_helper ttm drm_display_helper cec rc_core i2c_algo_bit nfsd
msr parport_pc auth_rpcgss nfs_acl ppdev lockd grace lp parport
nvme_fabrics efi_pstore sunrpc nfnetlink dmi_sysfs ip_tables x_tables
autofs4 wacom hid_microsoft ff_memless hid_generic usbhid hid xfs
btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 8250_dw
rtsx_pci_sdmmc nvme crc32_pclmul thinkpad_acpi intel_lpss_pci nvram
ucsi_acpi nvme_core psmouse e1000e intel_lpss snd typec_ucsi rtsx_pci
xhci_pci nvme_auth idma64 xhci_pci_renesas typec soundcore video
sparse_keymap platform_profile wmi pinctrl_cannonlake [last unloaded:
ksmbd(OE)]
[18540.445443] CPU: 6 UID: 0 PID: 8319 Comm: kworker/6:0 Tainted: G
    W  OE      6.11.0-061100rc2-generic #202408042216
[18540.445448] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[18540.445449] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[18540.445451] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[18540.445472] RIP: 0010:ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[18540.445492] Code: e9 44 fc ff ff 48 c7 c2 c8 c9 31 c2 4c 89 c6 48
c7 c7 d8 c5 31 c2 48 89 45 b0 4c 89 45 b8 c6 05 4b a8 01 00 01 e8 83
0c fa ee <0f> 0b 44 0f b7 7d c6 48 8b 45 b0 4c 8b 45 b8 e9 b5 fb ff ff
49 8b
[18540.445494] RSP: 0018:ffffaa31cceabce8 EFLAGS: 00010246
[18540.445497] RAX: 0000000000000000 RBX: ffff9b1c8a847c00 RCX: 00000000000=
00000
[18540.445499] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[18540.445501] RBP: ffffaa31cceabd40 R08: 0000000000000000 R09: 00000000000=
00000
[18540.445502] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b1c827=
42600
[18540.445504] R13: ffff9b1ca0381404 R14: ffff9b1c8e0d1204 R15: 00000000000=
00000
[18540.445506] FS:  0000000000000000(0000) GS:ffff9b23fbb00000(0000)
knlGS:0000000000000000
[18540.445508] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18540.445510] CR2: 00005fa01c7a8000 CR3: 000000013f43e004 CR4: 00000000003=
706f0
[18540.445512] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[18540.445514] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[18540.445516] Call Trace:
[18540.445517]  <TASK>
[18540.445519]  ? show_trace_log_lvl+0x1be/0x310
[18540.445523]  ? show_trace_log_lvl+0x1be/0x310
[18540.445529]  ? smb2_sess_setup+0x88c/0xa00 [ksmbd]
[18540.445549]  ? show_regs.part.0+0x22/0x30
[18540.445553]  ? show_regs.cold+0x8/0x10
[18540.445555]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[18540.445573]  ? __warn.cold+0xa7/0x101
[18540.445576]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[18540.445593]  ? report_bug+0x114/0x160
[18540.445597]  ? handle_bug+0x51/0xa0
[18540.445600]  ? exc_invalid_op+0x18/0x80
[18540.445604]  ? asm_exc_invalid_op+0x1b/0x20
[18540.445608]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[18540.445626]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[18540.445644]  smb2_sess_setup+0x88c/0xa00 [ksmbd]
[18540.445663]  __process_request+0xa5/0x1c0 [ksmbd]
[18540.445684]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
[18540.445707]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
[18540.445724]  process_one_work+0x174/0x350
[18540.445728]  worker_thread+0x31a/0x450
[18540.445730]  ? _raw_spin_lock_irqsave+0xe/0x20
[18540.445734]  ? __pfx_worker_thread+0x10/0x10
[18540.445736]  kthread+0xe1/0x110
[18540.445740]  ? __pfx_kthread+0x10/0x10
[18540.445743]  ret_from_fork+0x44/0x70
[18540.445745]  ? __pfx_kthread+0x10/0x10
[18540.445748]  ret_from_fork_asm+0x1a/0x30
[18540.445754]  </TASK>
[18540.445755] ---[ end trace 0000000000000000 ]---


The experiment to change ntlm_negotiate doesn't fix it but does seem
to change the error logged:

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2df1354288e6..10c10c8436a7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1326,7 +1326,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
        struct challenge_message *chgblob;
        unsigned char *spnego_blob =3D NULL;
        u16 spnego_blob_len;
-       char *neg_blob;
+       char *neg_blob, *spnego_off;
        int sz, rc;

        ksmbd_debug(SMB, "negotiate phase\n");
@@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work,
        }

        sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
-       memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_=
len);
+       spnego_off =3D (char *)&rsp->hdr.ProtocolId + sz;
+       memcpy(spnego_off, spnego_blob, spnego_blob_len);
        rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len);

 out:

[18328.301593] ------------[ cut here ]------------
[18328.301602] memcpy: detected field-spanning write (size 219) of
single field "spnego_off" at
/home/smfrench/smb3-kernel/fs/smb/server/smb2pdu.c:1374 (size 0)
[18328.301647] WARNING: CPU: 2 PID: 9880 at
/home/smfrench/smb3-kernel/fs/smb/server/smb2pdu.c:1374
smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.301726] Modules linked in: ksmbd(OE) crc32_generic rdma_cm
iw_cm ib_cm ib_core rfcomm snd_seq_dummy snd_hrtimer snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables br_netfilter bridge stp llc nls_utf8 cifs_arc4
nls_ucs2_utils cifs_md4 cachefiles netfs ccm overlay cmac algif_hash
algif_skcipher af_alg elan_i2c qrtr bnep binfmt_misc nls_iso8859_1
snd_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel
soundwire_cadence snd_sof_intel_hda_common snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp
intel_uncore_frequency intel_uncore_frequency_common snd_sof
snd_sof_utils snd_soc_hdac_hda snd_soc_acpi_intel_match
soundwire_generic_allocation snd_soc_acpi soundwire_bus
intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp snd_soc_avs
coretemp snd_soc_hda_codec snd_hda_ext_core snd_ctl_led cmdlinepart
iwlmvm
[18328.301964]  snd_soc_core kvm_intel snd_hda_codec_realtek spi_nor
snd_hda_codec_generic snd_compress ac97_bus ee1004 mtd mei_hdcp
mei_pxp intel_rapl_msr snd_hda_scodec_component snd_pcm_dmaengine
snd_hda_codec_hdmi kvm mac80211 crct10dif_pclmul polyval_clmulni
polyval_generic snd_hda_intel ghash_clmulni_intel libarc4
snd_intel_dspcfg sha256_ssse3 snd_intel_sdw_acpi
processor_thermal_device_pci_legacy snd_hda_codec sha1_ssse3 uvcvideo
processor_thermal_device aesni_intel btusb videobuf2_vmalloc
crypto_simd snd_hda_core uvc cryptd btrtl videobuf2_memops
processor_thermal_wt_hint iwlwifi snd_hwdep processor_thermal_rfim
btintel videobuf2_v4l2 rapl i2c_i801 processor_thermal_rapl btbcm
think_lmi spi_intel_pci i2c_mux btmtk intel_rapl_common intel_cstate
videodev nvidiafb firmware_attributes_class wmi_bmof
intel_wmi_thunderbolt spi_intel i2c_smbus snd_pcm cfg80211 mei_me
processor_thermal_wt_req bluetooth videobuf2_common vgastate
processor_thermal_power_floor processor_thermal_mbox fb_ddc mei mc
intel_soc_dts_iosf
[18328.302170]  snd_timer intel_pch_thermal int3403_thermal
int340x_thermal_zone joydev input_leds intel_pmc_core intel_vsec
pmt_telemetry int3400_thermal acpi_thermal_rel acpi_pad pmt_class
mac_hid serio_raw nouveau mxm_wmi drm_gpuvm drm_exec gpu_sched
drm_ttm_helper ttm drm_display_helper cec rc_core i2c_algo_bit nfsd
msr parport_pc auth_rpcgss nfs_acl ppdev lockd grace lp parport
nvme_fabrics efi_pstore sunrpc nfnetlink dmi_sysfs ip_tables x_tables
autofs4 wacom hid_microsoft ff_memless hid_generic usbhid hid xfs
btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 8250_dw
rtsx_pci_sdmmc nvme crc32_pclmul thinkpad_acpi intel_lpss_pci nvram
ucsi_acpi nvme_core psmouse e1000e intel_lpss snd typec_ucsi rtsx_pci
xhci_pci nvme_auth idma64 xhci_pci_renesas typec soundcore video
sparse_keymap platform_profile wmi pinctrl_cannonlake [last unloaded:
ksmbd]
[18328.302423] CPU: 2 UID: 0 PID: 9880 Comm: kworker/2:3 Tainted: G
       OE      6.11.0-061100rc2-generic #202408042216
[18328.302438] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[18328.302443] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[18328.302449] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[18328.302510] RIP: 0010:smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.302567] Code: 87 13 0a 01 00 a8 01 0f 85 7b fe ff ff 48 c7 c2
70 c6 31 c2 4c 89 f6 48 c7 c7 c0 c6 31 c2 c6 05 45 94 01 00 01 e8 fc
f9 f9 ee <0f> 0b e9 57 fe ff ff f6 05 36 9b 01 00 01 0f 84 87 ee ff ff
e9 e6
[18328.302575] RSP: 0018:ffffaa31cbb4bd88 EFLAGS: 00010246
[18328.302585] RAX: 0000000000000000 RBX: ffff9b1cf243d400 RCX: 00000000000=
00000
[18328.302592] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[18328.302597] RBP: ffffaa31cbb4bdf8 R08: 0000000000000000 R09: 00000000000=
00000
[18328.302603] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b1da44=
3f804
[18328.302609] R13: ffff9b1cdc992200 R14: 00000000000000db R15: ffff9b1df30=
b37c0
[18328.302616] FS:  0000000000000000(0000) GS:ffff9b23fb900000(0000)
knlGS:0000000000000000
[18328.302623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18328.302630] CR2: 00007a6b31a2ff50 CR3: 000000013f43e002 CR4: 00000000003=
706f0
[18328.302637] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[18328.302642] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[18328.302649] Call Trace:
[18328.302654]  <TASK>
[18328.302661]  ? show_trace_log_lvl+0x1be/0x310
[18328.302678]  ? show_trace_log_lvl+0x1be/0x310
[18328.302697]  ? handle_ksmbd_work+0x16f/0x490 [ksmbd]
[18328.302754]  ? show_regs.part.0+0x22/0x30
[18328.302767]  ? show_regs.cold+0x8/0x10
[18328.302774]  ? smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.302824]  ? __warn.cold+0xa7/0x101
[18328.302832]  ? smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.302879]  ? report_bug+0x114/0x160
[18328.302889]  ? handle_bug+0x51/0xa0
[18328.302901]  ? exc_invalid_op+0x18/0x80
[18328.302936]  ? asm_exc_invalid_op+0x1b/0x20
[18328.302956]  ? smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.302999]  ? smb2_sess_setup+0x1244/0x12d0 [ksmbd]
[18328.303047]  handle_ksmbd_work+0x16f/0x490 [ksmbd]
[18328.303101]  process_one_work+0x174/0x350
[18328.303114]  worker_thread+0x31a/0x450
[18328.303123]  ? _raw_spin_lock_irqsave+0xe/0x20
[18328.303135]  ? __pfx_worker_thread+0x10/0x10
[18328.303144]  kthread+0xe1/0x110
[18328.303155]  ? __pfx_kthread+0x10/0x10
[18328.303166]  ret_from_fork+0x44/0x70
[18328.303174]  ? __pfx_kthread+0x10/0x10
[18328.303184]  ret_from_fork_asm+0x1a/0x30
[18328.303204]  </TASK>
[18328.303209] ---[ end trace 0000000000000000 ]---
[18328.303945] ------------[ cut here ]------------
[18328.303953] memcpy: detected field-spanning write (size 9) of
single field "(char *)&rsp->hdr.ProtocolId + sz" at
/home/smfrench/smb3-kernel/fs/smb/server/smb2pdu.c:1457 (size 0)
[18328.303992] WARNING: CPU: 2 PID: 9880 at
/home/smfrench/smb3-kernel/fs/smb/server/smb2pdu.c:1457
smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.304065] Modules linked in: ksmbd(OE) crc32_generic rdma_cm
iw_cm ib_cm ib_core rfcomm snd_seq_dummy snd_hrtimer snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables br_netfilter bridge stp llc nls_utf8 cifs_arc4
nls_ucs2_utils cifs_md4 cachefiles netfs ccm overlay cmac algif_hash
algif_skcipher af_alg elan_i2c qrtr bnep binfmt_misc nls_iso8859_1
snd_sof_pci_intel_cnl snd_sof_intel_hda_generic soundwire_intel
soundwire_cadence snd_sof_intel_hda_common snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp
intel_uncore_frequency intel_uncore_frequency_common snd_sof
snd_sof_utils snd_soc_hdac_hda snd_soc_acpi_intel_match
soundwire_generic_allocation snd_soc_acpi soundwire_bus
intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp snd_soc_avs
coretemp snd_soc_hda_codec snd_hda_ext_core snd_ctl_led cmdlinepart
iwlmvm
[18328.304267]  snd_soc_core kvm_intel snd_hda_codec_realtek spi_nor
snd_hda_codec_generic snd_compress ac97_bus ee1004 mtd mei_hdcp
mei_pxp intel_rapl_msr snd_hda_scodec_component snd_pcm_dmaengine
snd_hda_codec_hdmi kvm mac80211 crct10dif_pclmul polyval_clmulni
polyval_generic snd_hda_intel ghash_clmulni_intel libarc4
snd_intel_dspcfg sha256_ssse3 snd_intel_sdw_acpi
processor_thermal_device_pci_legacy snd_hda_codec sha1_ssse3 uvcvideo
processor_thermal_device aesni_intel btusb videobuf2_vmalloc
crypto_simd snd_hda_core uvc cryptd btrtl videobuf2_memops
processor_thermal_wt_hint iwlwifi snd_hwdep processor_thermal_rfim
btintel videobuf2_v4l2 rapl i2c_i801 processor_thermal_rapl btbcm
think_lmi spi_intel_pci i2c_mux btmtk intel_rapl_common intel_cstate
videodev nvidiafb firmware_attributes_class wmi_bmof
intel_wmi_thunderbolt spi_intel i2c_smbus snd_pcm cfg80211 mei_me
processor_thermal_wt_req bluetooth videobuf2_common vgastate
processor_thermal_power_floor processor_thermal_mbox fb_ddc mei mc
intel_soc_dts_iosf
[18328.304466]  snd_timer intel_pch_thermal int3403_thermal
int340x_thermal_zone joydev input_leds intel_pmc_core intel_vsec
pmt_telemetry int3400_thermal acpi_thermal_rel acpi_pad pmt_class
mac_hid serio_raw nouveau mxm_wmi drm_gpuvm drm_exec gpu_sched
drm_ttm_helper ttm drm_display_helper cec rc_core i2c_algo_bit nfsd
msr parport_pc auth_rpcgss nfs_acl ppdev lockd grace lp parport
nvme_fabrics efi_pstore sunrpc nfnetlink dmi_sysfs ip_tables x_tables
autofs4 wacom hid_microsoft ff_memless hid_generic usbhid hid xfs
btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 8250_dw
rtsx_pci_sdmmc nvme crc32_pclmul thinkpad_acpi intel_lpss_pci nvram
ucsi_acpi nvme_core psmouse e1000e intel_lpss snd typec_ucsi rtsx_pci
xhci_pci nvme_auth idma64 xhci_pci_renesas typec soundcore video
sparse_keymap platform_profile wmi pinctrl_cannonlake [last unloaded:
ksmbd]
[18328.304710] CPU: 2 UID: 0 PID: 9880 Comm: kworker/2:3 Tainted: G
    W  OE      6.11.0-061100rc2-generic #202408042216
[18328.304726] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[18328.304731] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[18328.304737] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[18328.304798] RIP: 0010:smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.304855] Code: d1 4c 89 c6 48 c7 c2 10 c7 31 c2 48 89 45 a0 48
c7 c7 c0 c6 31 c2 4c 89 55 a8 4c 89 45 b0 c6 05 ca 94 01 00 01 e8 82
fa f9 ee <0f> 0b 48 8b 45 a0 4c 8b 55 a8 4c 8b 45 b0 e9 43 f8 ff ff 48
8b 7d
[18328.304863] RSP: 0018:ffffaa31cbb4bd88 EFLAGS: 00010246
[18328.304872] RAX: 0000000000000000 RBX: ffff9b1cf243d400 RCX: 00000000000=
00000
[18328.304879] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[18328.304885] RBP: ffffaa31cbb4bdf8 R08: 0000000000000000 R09: 00000000000=
00000
[18328.304891] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9b1da44=
3f804
[18328.304897] R13: ffff9b1da480b004 R14: ffff9b1cf243d400 R15: ffff9b1df30=
b37c0
[18328.304904] FS:  0000000000000000(0000) GS:ffff9b23fb900000(0000)
knlGS:0000000000000000
[18328.304930] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18328.304940] CR2: 00007a6b31a2ff50 CR3: 000000013f43e002 CR4: 00000000003=
706f0
[18328.304947] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[18328.304952] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[18328.304959] Call Trace:
[18328.304963]  <TASK>
[18328.304970]  ? show_trace_log_lvl+0x1be/0x310
[18328.304986]  ? show_trace_log_lvl+0x1be/0x310
[18328.305006]  ? handle_ksmbd_work+0x16f/0x490 [ksmbd]
[18328.305063]  ? show_regs.part.0+0x22/0x30
[18328.305076]  ? show_regs.cold+0x8/0x10
[18328.305084]  ? smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.305134]  ? __warn.cold+0xa7/0x101
[18328.305142]  ? smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.305188]  ? report_bug+0x114/0x160
[18328.305198]  ? handle_bug+0x51/0xa0
[18328.305211]  ? exc_invalid_op+0x18/0x80
[18328.305223]  ? asm_exc_invalid_op+0x1b/0x20
[18328.305237]  ? smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.305281]  ? smb2_sess_setup+0x11be/0x12d0 [ksmbd]
[18328.305328]  handle_ksmbd_work+0x16f/0x490 [ksmbd]
[18328.305381]  process_one_work+0x174/0x350
[18328.305396]  worker_thread+0x31a/0x450
[18328.305409]  ? _raw_spin_lock_irqsave+0xe/0x20
[18328.305424]  ? __pfx_worker_thread+0x10/0x10
[18328.305437]  kthread+0xe1/0x110
[18328.305451]  ? __pfx_kthread+0x10/0x10
[18328.305467]  ret_from_fork+0x44/0x70
[18328.305478]  ? __pfx_kthread+0x10/0x10
[18328.305491]  ret_from_fork_asm+0x1a/0x30
[18328.305517]  </TASK>
[18328.305523] ---[ end trace 0000000000000000 ]---



--=20
Thanks,

Steve


--=20
Thanks,

Steve
