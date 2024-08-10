Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868516A925
	for <linux-cifs@vger.kernel.org>; Sat, 10 Aug 2024 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723308240; cv=none; b=himl+saX2gNYRzqgN+BDMPyPpczB/3p04S5GVSalArhb81+wKivXQ1AXc1Hr/nbpQ5PejhjXH27k0hmtmR531l5LAkFhb+TnJD3Qx+vs9RAJCFkf9r+bAzWm1ysXL1SqjILpdXcSWUHTYPCtle3ZOpJVbvdMqq0oEmNKZf1GOzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723308240; c=relaxed/simple;
	bh=aBo6FbM9o31ghCDzoIPo/m16Flz2rIFyzNGdESbF7+U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=T1aSZvCmhmb0nXf9c8yiTCvMMs/PwlYFb3qsqmfgQhecXLXuFLyQKw3UHyY/eTFF6XoWeRTGqR0Z6J//fWQKCqOYxvthwH8W3QPubSOLepurzb3V5jfNrJkX52VmlTrIcG88GZ/3d5B+Q08kHYhEX5J56rmIcrE2O9aT+UuWmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZgPuPM1; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZgPuPM1"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efdf02d13so5439150e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 Aug 2024 09:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723308236; x=1723913036; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=guCY42ZDo3Nw1O9ALMQ7KpxJDwL9/luyKWPVd6tZhy8=;
        b=NZgPuPM1RZDEbVkdeKSBlWesWTd6kNc8l2nftOmKpDk7vCaKT4n6+F7lIIDdn20fIO
         tVuiMuu2W7rIk9+BvTcYM/5eADpXt6+14QYT13zamupJ4jAnYgRm3zYTn+bQdhhCJlTx
         StfW3pdvK9OiY91cCp8H9OHYrvHAfW22AxZpyepUBGppAawVPu4pawDID/kr1W1T2TP/
         f5/vWiSxyNzQPfvy40GHYrbSasUENUhZ0Tya+E2fbMJIUSJPVfydBGmn8Iph62rqZQzq
         ealqsEhalZPIzhfVVPSRqJKSndyq6kcudwfNwxAQNXGiR11NkhUytSCQxacRMq/41wAm
         g2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723308236; x=1723913036;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=guCY42ZDo3Nw1O9ALMQ7KpxJDwL9/luyKWPVd6tZhy8=;
        b=FBO1ZVQolvm54+laWiLbrJCh2wmPU9sWzuq1x8zvMYl1Drj6+LYLr+3xPOJbJ2+IQi
         wZVpHukyT2wxHgD15ek1c7yspiV7m1uUt3S7pbxTk4JRDfiKjvXUxjI2ID0VimlWkOOc
         8b1Hm9L0JNVTB2tVRn/YJuoFMvpNIEzZK5Bs5xutH/v1tE1D1Dri4SdpRMJubiEmpbwX
         KTBbQmAiWfKy5VuD6ByRwXwj2JzLfTMGR4nOaC4xoxNfhfy9YhfBU0sxTwNVNIPL2K3X
         GDh85B2B07KYkr6uruBnNDeGiki7leQOx1464Yna1s8AhcMzuOtvM1f1g0hBr8shCgG/
         mtIw==
X-Forwarded-Encrypted: i=1; AJvYcCVa1jIgVkwxuAwLS8FC3FCGOuJh9NhbzOTCE8tQopIGNG95SOLo3ksLU9A8zxfBv/EJRdrpDo4gFpy0Wp7DmweWTJ9BY98AnkSggA==
X-Gm-Message-State: AOJu0YyW75arPx4z3ald0Etb+te7z0eje600vm0mAm2pF/+66W5PN1Yj
	JXkh4qcc0IgKb5miP29voNjJOTH+OXI9gT7oYX5SZpRW9ll2j3RPhlnTdcCJRUydNdhzyCL1ELm
	xGomugyXleNiXMMj+bhhlCqrB3pjBU45O
X-Google-Smtp-Source: AGHT+IHYEWqx3lsa6a/S0D+LZlWsKPN505Fdf43/C/fZwgnAIaxisvXIRslKtobAYpITy50chDoBsH0fPdXWVL0+0zk=
X-Received: by 2002:a05:6512:3d90:b0:52c:d628:c77c with SMTP id
 2adb3069b0e04-530ee9f4360mr4265297e87.43.1723308235645; Sat, 10 Aug 2024
 09:43:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 10 Aug 2024 11:43:44 -0500
Message-ID: <CAH2r5mvAVoUxDgfvbH2ywHd9+ivgRrQNMu0dRNqkJm40jyxoEg@mail.gmail.com>
Subject: field-spanning write warning
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Running xfstests against ksmbd on kernel 6.11-rc2, I noticed the
following errors logged in the server's dmesg log. It was likely
fairly early in the test run (before the client got to test
generic/100 e.g.) Any ideas on the bug?

[Sat Aug 10 15:15:24 2024] ------------[ cut here ]------------
[Sat Aug 10 15:15:24 2024] memcpy: detected field-spanning write (size
137) of single field "(char *)&rsp->hdr.ProtocolId + sz" at
fs/smb/server/smb2pdu.c:1373 (size 0)
[Sat Aug 10 15:15:24 2024] WARNING: CPU: 3 PID: 82 at
fs/smb/server/smb2pdu.c:1373 ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[Sat Aug 10 15:15:24 2024] Modules linked in: nls_utf8 ksmbd
crc32_generic rdma_cm iw_cm ib_cm cifs_arc4 nls_ucs2_utils cfg80211
binfmt_misc xfs nls_iso8859_1 intel_rapl_msr intel_rapl_common
intel_uncore_frequency_common isst_if_common xt_conntrack nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
skx_edac_common nfit nfnetlink rapl i2c_piix4 i2c_smbus hv_balloon
vmgenid input_leds joydev mac_hid serio_raw dm_multipath msr
efi_pstore dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macsec
ib_core mlx5_core mlxfw psample tls pci_hyperv pci_hyperv_intf
hid_generic crct10dif_pclmul hv_storvsc hyperv_drm crc32_pclmul
hid_hyperv hv_netvsc hid scsi_transport_fc hv_utils hyperv_keyboard
polyval_clmulni polyval_generic hyperv_fb ghash_clmulni_intel
sha256_ssse3 sha1_ssse3 pata_acpi psmouse hv_vmbus floppy aesni_intel
crypto_simd cryptd
[Sat Aug 10 15:15:24 2024] CPU: 3 UID: 0 PID: 82 Comm: kworker/3:1 Not
tainted 6.11.0-061100rc2-generic #202408042216
[Sat Aug 10 15:15:24 2024] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
[Sat Aug 10 15:15:24 2024] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[Sat Aug 10 15:15:24 2024] RIP: 0010:ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[Sat Aug 10 15:15:24 2024] Code: 00 3c 01 0f 87 9e 48 01 00 a8 01 75
b8 48 c7 c2 88 05 45 c1 4c 89 fe 48 c7 c7 d8 05 45 c1 c6 05 aa cd 01
00 01 e8 e1 d1 ee f8 <0f> 0b eb 97 41 bd f4 ff ff ff e9 df fe ff ff e8
7d 6c 08 fa 66 66
[Sat Aug 10 15:15:24 2024] RSP: 0018:ffff9b80802f7cf0 EFLAGS: 00010246
[Sat Aug 10 15:15:24 2024] RAX: 0000000000000000 RBX: ffff8ae7ce4a8004
RCX: 0000000000000000
[Sat Aug 10 15:15:24 2024] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[Sat Aug 10 15:15:24 2024] RBP: ffff9b80802f7d40 R08: 0000000000000000
R09: 0000000000000000
[Sat Aug 10 15:15:24 2024] R10: 0000000000000000 R11: 0000000000000000
R12: ffff8ae7ce4a804c
[Sat Aug 10 15:15:24 2024] R13: 0000000000000000 R14: ffff8ae7cc2eb380
R15: 0000000000000089
[Sat Aug 10 15:15:24 2024] FS:  0000000000000000(0000)
GS:ffff8aee63b80000(0000) knlGS:0000000000000000
[Sat Aug 10 15:15:24 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Aug 10 15:15:24 2024] CR2: 000070d3373f7a78 CR3: 00000001070cc004
CR4: 00000000003706f0
[Sat Aug 10 15:15:24 2024] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[Sat Aug 10 15:15:24 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[Sat Aug 10 15:15:24 2024] Call Trace:
[Sat Aug 10 15:15:24 2024]  <TASK>
[Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
[Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
[Sat Aug 10 15:15:24 2024]  ? smb2_sess_setup+0x936/0xa00 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? show_regs.part.0+0x22/0x30
[Sat Aug 10 15:15:24 2024]  ? show_regs.cold+0x8/0x10
[Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? __warn.cold+0xa7/0x101
[Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? report_bug+0x114/0x160
[Sat Aug 10 15:15:24 2024]  ? handle_bug+0x51/0xa0
[Sat Aug 10 15:15:24 2024]  ? exc_invalid_op+0x18/0x80
[Sat Aug 10 15:15:24 2024]  ? asm_exc_invalid_op+0x1b/0x20
[Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? ksmbd_release_crypto_ctx+0xa4/0xd0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  smb2_sess_setup+0x936/0xa00 [ksmbd]
[Sat Aug 10 15:15:24 2024]  __process_request+0xa8/0x1c0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  process_one_work+0x177/0x350
[Sat Aug 10 15:15:24 2024]  worker_thread+0x31a/0x450
[Sat Aug 10 15:15:24 2024]  ? _raw_spin_unlock_irqrestore+0x11/0x60
[Sat Aug 10 15:15:24 2024]  ? __pfx_worker_thread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  kthread+0xe4/0x110
[Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  ret_from_fork+0x47/0x70
[Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  ret_from_fork_asm+0x1a/0x30
[Sat Aug 10 15:15:24 2024]  </TASK>
[Sat Aug 10 15:15:24 2024] ---[ end trace 0000000000000000 ]---
[Sat Aug 10 15:15:24 2024] ------------[ cut here ]------------
[Sat Aug 10 15:15:24 2024] memcpy: detected field-spanning write (size
9) of single field "(char *)&rsp->hdr.ProtocolId + sz" at
fs/smb/server/smb2pdu.c:1456 (size 0)
[Sat Aug 10 15:15:24 2024] WARNING: CPU: 3 PID: 82 at
fs/smb/server/smb2pdu.c:1456 ntlm_authenticate.isra.0+0x4cd/0x540
[ksmbd]
[Sat Aug 10 15:15:24 2024] Modules linked in: nls_utf8 ksmbd
crc32_generic rdma_cm iw_cm ib_cm cifs_arc4 nls_ucs2_utils cfg80211
binfmt_misc xfs nls_iso8859_1 intel_rapl_msr intel_rapl_common
intel_uncore_frequency_common isst_if_common xt_conntrack nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
skx_edac_common nfit nfnetlink rapl i2c_piix4 i2c_smbus hv_balloon
vmgenid input_leds joydev mac_hid serio_raw dm_multipath msr
efi_pstore dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macsec
ib_core mlx5_core mlxfw psample tls pci_hyperv pci_hyperv_intf
hid_generic crct10dif_pclmul hv_storvsc hyperv_drm crc32_pclmul
hid_hyperv hv_netvsc hid scsi_transport_fc hv_utils hyperv_keyboard
polyval_clmulni polyval_generic hyperv_fb ghash_clmulni_intel
sha256_ssse3 sha1_ssse3 pata_acpi psmouse hv_vmbus floppy aesni_intel
crypto_simd cryptd
[Sat Aug 10 15:15:24 2024] CPU: 3 UID: 0 PID: 82 Comm: kworker/3:1
Tainted: G        W          6.11.0-061100rc2-generic #202408042216
[Sat Aug 10 15:15:24 2024] Tainted: [W]=WARN
[Sat Aug 10 15:15:24 2024] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
[Sat Aug 10 15:15:24 2024] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[Sat Aug 10 15:15:24 2024] RIP:
0010:ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[Sat Aug 10 15:15:24 2024] Code: e9 44 fc ff ff 48 c7 c2 c8 09 45 c1
4c 89 c6 48 c7 c7 d8 05 45 c1 48 89 45 b0 4c 89 45 b8 c6 05 4b a8 01
00 01 e8 83 ac ee f8 <0f> 0b 44 0f b7 7d c6 48 8b 45 b0 4c 8b 45 b8 e9
b5 fb ff ff 49 8b
[Sat Aug 10 15:15:24 2024] RSP: 0018:ffff9b80802f7ce8 EFLAGS: 00010246
[Sat Aug 10 15:15:24 2024] RAX: 0000000000000000 RBX: ffff8ae7cc4bbc00
RCX: 0000000000000000
[Sat Aug 10 15:15:24 2024] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[Sat Aug 10 15:15:24 2024] RBP: ffff9b80802f7d40 R08: 0000000000000000
R09: 0000000000000000
[Sat Aug 10 15:15:24 2024] R10: 0000000000000000 R11: 0000000000000000
R12: ffff8ae7ce49b800
[Sat Aug 10 15:15:24 2024] R13: ffff8ae7ce4a8004 R14: ffff8ae7ce4abc04
R15: 0000000000000000
[Sat Aug 10 15:15:24 2024] FS:  0000000000000000(0000)
GS:ffff8aee63b80000(0000) knlGS:0000000000000000
[Sat Aug 10 15:15:24 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Sat Aug 10 15:15:24 2024] CR2: 000070d3373f7a78 CR3: 00000001070cc004
CR4: 00000000003706f0
[Sat Aug 10 15:15:24 2024] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[Sat Aug 10 15:15:24 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[Sat Aug 10 15:15:24 2024] Call Trace:
[Sat Aug 10 15:15:24 2024]  <TASK>
[Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
[Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
[Sat Aug 10 15:15:24 2024]  ? smb2_sess_setup+0x88c/0xa00 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? show_regs.part.0+0x22/0x30
[Sat Aug 10 15:15:24 2024]  ? show_regs.cold+0x8/0x10
[Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? __warn.cold+0xa7/0x101
[Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? report_bug+0x114/0x160
[Sat Aug 10 15:15:24 2024]  ? handle_bug+0x51/0xa0
[Sat Aug 10 15:15:24 2024]  ? exc_invalid_op+0x18/0x80
[Sat Aug 10 15:15:24 2024]  ? asm_exc_invalid_op+0x1b/0x20
[Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
[Sat Aug 10 15:15:24 2024]  smb2_sess_setup+0x88c/0xa00 [ksmbd]
[Sat Aug 10 15:15:24 2024]  __process_request+0xa8/0x1c0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
[Sat Aug 10 15:15:24 2024]  process_one_work+0x177/0x350
[Sat Aug 10 15:15:24 2024]  worker_thread+0x31a/0x450
[Sat Aug 10 15:15:24 2024]  ? _raw_spin_unlock_irqrestore+0x11/0x60
[Sat Aug 10 15:15:24 2024]  ? __pfx_worker_thread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  kthread+0xe4/0x110
[Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  ret_from_fork+0x47/0x70
[Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
[Sat Aug 10 15:15:24 2024]  ret_from_fork_asm+0x1a/0x30
[Sat Aug 10 15:15:24 2024]  </TASK>
[Sat Aug 10 15:15:24 2024] ---[ end trace 0000000000000000 ]---
[Sat Aug 10 16:39:21 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[Sat Aug 10 16:39:21 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
CPU for >10000us 5 times, consider switching to WQ_UNBOUND
[Sat Aug 10 16:39:22 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
CPU for >10000us 7 times, consider switching to WQ_UNBOUND
[Sat Aug 10 16:39:41 2024] workqueue: xfs_inodegc_worker [xfs] hogged
CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[Sat Aug 10 16:39:47 2024] workqueue: xfs_inodegc_worker [xfs] hogged
CPU for >10000us 5 times, consider switching to WQ_UNBOUN

-- 
Thanks,

Steve
