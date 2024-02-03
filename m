Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE757168B1
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999794; cv=none; b=qwE1uO6mtJscVQRr1ctzWMg9YG/WpiKRK90ygVGKjhln/9PdHCyPIZ2HMJ4gcN3Sfmes/0TgZvh0l6eLLD5jJwoGO5v+7ldlZFhCHp5KD7jm9ij25CkGqU1INHUrk4eUipjTOXnJ9YfdnmmJJyU7BOxWG56lTVQYBniE+IaHA3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999794; c=relaxed/simple;
	bh=G69x7vUCKgeOMyU8VMKB1d0CXQL1AnpL8Z5aGsMsSCc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=JcOle7WaR4/+F+NW4Wf+YM4brfOpcsVLamEXymPU68BWsu64sVI66OPcXmPGsal6dyAoMbYWNVs3erznf4O3VopeEthTXbYCj/occRkytfeeepc3xaBlZ5a9nTPbobQ51Pw5nYjIQrguXE8jhZYMTmty6nFFU978gEnEryjP6Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/hjXgrZ; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/hjXgrZ"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5112a04c7acso5392761e87.3
        for <linux-cifs@vger.kernel.org>; Sat, 03 Feb 2024 14:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706999791; x=1707604591; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WL4j+BSWXoM+Rp0x8AwXPchew7ypo59hJXLsh5EppNw=;
        b=m/hjXgrZ7gCq6pxIl/fVFSeBzRp1s0CwHO71ZHy1Ub5Le5bAaHJxMR64AWAIX/U0jR
         /em5CuDBhkNOOPrqAcT0sV3e+niUJj2gfu/ijbdJfWEcVFzVWHjUpoug03FSe18qPobi
         VLSYO6OQ1HRxRwQgKZ9ydJIXj9H1wfG1EIoUz7GKDQiPxlSc/robbVdzU/dJaidy2w1K
         wqvgc7Rz/ei/6Fx3wpnTjaPkpGgiYFvWmXVeIzM2mX8HtfPEPx09D9o17QdNQJvWEFIt
         Z91VL0Tb1JfZIjING6zLkLlqSu4ngPUg2cfavJu5Tj1R1KuRPgaXcGGi62K/0nCnaDkV
         ac/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999791; x=1707604591;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WL4j+BSWXoM+Rp0x8AwXPchew7ypo59hJXLsh5EppNw=;
        b=F3H4Ig33hBVg24NN3hc1bqAIJhqx4HjCt049Ic65MjoIri2En/Sg+phHZ95cpSAkII
         ObAty9XcUfYKS9wjum0K0Z0NpEmNYpRiCVhu6EzdUQ6VrqNZCPRyAkC2W/3ktMMqWWp0
         BmPR9l0V2jY258fc7larP+fZQzyhzJBwe3TZs4iGljwW47ZFuy3fnzG25FB3S3UkTBds
         bkDCFWwgD0LsX7tvG77c4VlWczEJerngpjOzdSgBl9gNpqhcQWnGYreY7K5vCVNDdI//
         tWdVoxa5m4WVPn02csEBCBzPli34Q2EAuF9KgAwIO92cqoE5uIZGG91czfYX3aosOvlM
         DbGA==
X-Gm-Message-State: AOJu0Yx1cg9FWV8b/TVz1r+fjPTONHr1+D2FdkRWSigqOpcl506OhenJ
	WBuOXjI88DzbsJF+VxhkiZX/WIutUiiXl+byQ7DXb/dt/gWpVllVy52vaZOl3cGx7UyjmAa6ofK
	EH3unPSa+cCzYBC1CytgJGPZwzn8KY0DvkyU=
X-Google-Smtp-Source: AGHT+IHP6kHyAwGT639YDgWK7zkg2eF3V1/DKyqE4TZfvROxxMRcwL8+U5jnrzZQDgTt0elc7cl26mgEfNF54r+czPs=
X-Received: by 2002:ac2:5633:0:b0:511:490e:b8fd with SMTP id
 b19-20020ac25633000000b00511490eb8fdmr945366lff.45.1706999790375; Sat, 03 Feb
 2024 14:36:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 3 Feb 2024 16:36:19 -0600
Message-ID: <CAH2r5mtXzfzNG3QbN8Uk8TfMu=g=mWVKC3bwTysTnkaARBw=2g@mail.gmail.com>
Subject: ksmbd oops in xfstest generic/298 with multichannel
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Any thoughts on this oops I see in ksmbd running xfstest generic/298
to current mainline

[16402.020739] run fstests generic/298 at 2024-02-03 15:41:35
[16402.317292] CIFS: Attempting to mount //localhost/test
[16407.583660] CIFS: VFS: Error connecting to socket. Aborting operation.
[16407.583668] CIFS: VFS: failed to open extra channel on
iface:10.99.0.17 rc=-115
[16407.583681] CIFS: VFS: Error connecting to socket. Aborting operation.
[16407.583682] CIFS: VFS: failed to open extra channel on
iface:fe80:0000:0000:0000:128f:1148:6fa0:b79d rc=-22
[16407.669458] CIFS: VFS: successfully opened new channel on iface:10.20.14.177
[16407.713103] CIFS: Attempting to mount //localhost/scratch
[16407.725766] CIFS: Attempting to mount //localhost/scratch
[16407.746126] CIFS: Attempting to mount //localhost/scratch
[16407.756800] CIFS: Attempting to mount //localhost/scratch
[16407.899399] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for
>10000us 64 times, consider switching to WQ_UNBOUND
[16432.466494] warning: `ThreadPoolForeg' uses wireless extensions
which will stop working for Wi-Fi 7 hardware; use nl80211
[16471.493869] BUG: kernel NULL pointer dereference, address: 0000000000000028
[16471.493873] #PF: supervisor read access in kernel mode
[16471.493876] #PF: error_code(0x0000) - not-present page
[16471.493877] PGD 0 P4D 0
[16471.493880] Oops: 0000 [#1] PREEMPT SMP PTI
[16471.493882] CPU: 8 PID: 901381 Comm: kworker/8:6 Tainted: G
W  OE      6.8.0-060800rc2daily20240202-generic #202402012102
[16471.493884] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET69W (1.52 ) 11/27/2023
[16471.493886] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[16471.493902] RIP: 0010:do_clone_file_range+0xe2/0x200
[16471.493906] Code: 41 5c 41 5d 41 5e 41 5f 5d 31 d2 31 c9 31 f6 31
ff 45 31 c0 45 31 c9 45 31 d2 c3 cc cc cc cc 49 8b bd a0 00 00 00 4c
8b 4f 30 <49> 8b 41 28 48 8b 80 38 04 00 00 48 85 c0 74 be 41 0f b7 01
49 8d
[16471.493908] RSP: 0018:ffffa22581e6bc90 EFLAGS: 00010246
[16471.493910] RAX: 0000000000000000 RBX: 0000000400000000 RCX: 0000000000000000
[16471.493911] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9542438afcc0
[16471.493913] RBP: ffffa22581e6bcc8 R08: 0000000000000000 R09: 0000000000000000
[16471.493914] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9543772a0400
[16471.493915] R13: ffff954322844d00 R14: 0000000000000000 R15: 0000000400000000
[16471.493916] FS:  0000000000000000(0000) GS:ffff9549bbc00000(0000)
knlGS:0000000000000000
[16471.493918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16471.493919] CR2: 0000000000000028 CR3: 00000004c343c001 CR4: 00000000003706f0
[16471.493921] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16471.493922] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[16471.493923] Call Trace:
[16471.493924]  <TASK>
[16471.493927]  ? show_regs+0x6d/0x80
[16471.493929]  ? __die+0x24/0x80
[16471.493931]  ? page_fault_oops+0x99/0x1b0
[16471.493934]  ? do_user_addr_fault+0x2ee/0x6b0
[16471.493937]  ? exc_page_fault+0x83/0x1b0
[16471.493940]  ? asm_exc_page_fault+0x27/0x30
[16471.493944]  ? do_clone_file_range+0xe2/0x200
[16471.493947]  vfs_clone_file_range+0xa6/0x180
[16471.493950]  smb2_ioctl+0x729/0xac0 [ksmbd]
[16471.493962]  ? ksmbd_smb2_check_message+0x25b/0x3c0 [ksmbd]
[16471.493973]  __process_request+0xa3/0x1d0 [ksmbd]
[16471.493985]  __handle_ksmbd_work+0x1c4/0x2f0 [ksmbd]
[16471.493995]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
[16471.494005]  process_one_work+0x16c/0x350
[16471.494008]  worker_thread+0x306/0x440
[16471.494011]  ? __pfx_worker_thread+0x10/0x10
[16471.494013]  kthread+0xef/0x120
[16471.494016]  ? __pfx_kthread+0x10/0x10
[16471.494018]  ret_from_fork+0x44/0x70
[16471.494020]  ? __pfx_kthread+0x10/0x10
[16471.494022]  ret_from_fork_asm+0x1b/0x30
[16471.494025]  </TASK>
[16471.494026] Modules linked in: ksmbd crc32_generic rdma_cm iw_cm
ib_cm ib_core cifs(OE) rfcomm snd_seq_dummy snd_hrtimer xt_conntrack
nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype
nft_compat nf_tables nfnetlink br_netfilter bridge stp llc nls_utf8
cifs_arc4 nls_ucs2_utils cifs_md4 cachefiles netfs nvme_fabrics
overlay cmac algif_hash algif_skcipher af_alg bnep binfmt_misc
nls_iso8859_1 elan_i2c snd_sof_pci_intel_cnl snd_sof_intel_hda_common
soundwire_intel intel_uncore_frequency snd_sof_intel_hda_mlink
intel_uncore_frequency_common soundwire_cadence snd_sof_intel_hda
snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_ctl_led snd_sof_utils
snd_soc_hdac_hda snd_hda_ext_core snd_soc_acpi_intel_match
snd_hda_codec_realtek snd_soc_acpi soundwire_generic_allocation
snd_hda_codec_generic intel_tcc_cooling soundwire_bus
x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi snd_soc_core
coretemp snd_compress ac97_bus snd_pcm_dmaengine kvm_intel
[16471.494071]  snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi
snd_hda_codec kvm snd_hda_core snd_hwdep irqbypass crct10dif_pclmul
polyval_clmulni polyval_generic snd_pcm cmdlinepart
ghash_clmulni_intel iwlmvm intel_rapl_msr sha256_ssse3 spi_nor
sha1_ssse3 snd_seq_midi mei_hdcp mei_pxp ee1004 mtd snd_seq_midi_event
aesni_intel mac80211 crypto_simd cryptd snd_rawmidi uvcvideo
processor_thermal_device_pci_legacy libarc4 rapl btusb
processor_thermal_device videobuf2_vmalloc snd_seq btrtl
processor_thermal_wt_hint uvc processor_thermal_rfim videobuf2_memops
thinkpad_acpi btintel processor_thermal_rapl videobuf2_v4l2 think_lmi
btbcm intel_rapl_common nvram snd_seq_device btmtk ledtrig_audio
processor_thermal_wt_req firmware_attributes_class intel_cstate
snd_timer videodev intel_wmi_thunderbolt processor_thermal_power_floor
wmi_bmof platform_profile bluetooth iwlwifi input_leds snd
videobuf2_common intel_pmc_core spi_intel_pci nvidiafb mei_me
processor_thermal_mbox i2c_i801 intel_vsec vgastate int3403_thermal
ecdh_generic
[16471.494117]  joydev int3400_thermal pmt_telemetry cfg80211
spi_intel i2c_smbus mei mc ecc fb_ddc intel_soc_dts_iosf
intel_pch_thermal soundcore int340x_thermal_zone acpi_thermal_rel
pmt_class acpi_pad serio_raw mac_hid nouveau mxm_wmi drm_gpuvm
drm_exec gpu_sched drm_ttm_helper ttm drm_display_helper cec rc_core
i2c_algo_bit nfsd msr parport_pc auth_rpcgss nfs_acl ppdev lockd grace
lp parport efi_pstore sunrpc dmi_sysfs ip_tables x_tables autofs4
wacom hid_generic usbhid hid xfs btrfs blake2b_generic xor raid6_pq
libcrc32c 8250_dw nvme rtsx_pci_sdmmc crc32_pclmul ucsi_acpi nvme_core
psmouse e1000e intel_lpss_pci typec_ucsi intel_lpss rtsx_pci nvme_auth
xhci_pci idma64 xhci_pci_renesas typec video wmi pinctrl_cannonlake
[last unloaded: scsi_debug]
[16471.494162] CR2: 0000000000000028
[16471.494164] ---[ end trace 0000000000000000 ]---
[16471.729867] RIP: 0010:do_clone_file_range+0xe2/0x200
[16471.729881] Code: 41 5c 41 5d 41 5e 41 5f 5d 31 d2 31 c9 31 f6 31
ff 45 31 c0 45 31 c9 45 31 d2 c3 cc cc cc cc 49 8b bd a0 00 00 00 4c
8b 4f 30 <49> 8b 41 28 48 8b 80 38 04 00 00 48 85 c0 74 be 41 0f b7 01
49 8d
[16471.729884] RSP: 0018:ffffa22581e6bc90 EFLAGS: 00010246
[16471.729887] RAX: 0000000000000000 RBX: 0000000400000000 RCX: 0000000000000000
[16471.729888] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9542438afcc0
[16471.729890] RBP: ffffa22581e6bcc8 R08: 0000000000000000 R09: 0000000000000000
[16471.729908] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9543772a0400
[16471.729909] R13: ffff954322844d00 R14: 0000000000000000 R15: 0000000400000000
[16471.729911] FS:  0000000000000000(0000) GS:ffff9549bbc00000(0000)
knlGS:0000000000000000
[16471.729912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16471.729914] CR2: 0000000000000028 CR3: 000000014b314005 CR4: 00000000003706f0
[16471.729915] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16471.729916] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[16471.729918] note: kworker/8:6[901381] exited with irqs disabled


-- 
Thanks,

Steve
