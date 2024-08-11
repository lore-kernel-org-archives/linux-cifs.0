Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A051E57D
	for <linux-cifs@vger.kernel.org>; Sun, 11 Aug 2024 02:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723343494; cv=none; b=CSpUm1bMpvntvTJ94RNiNvMfE8s1qwhT5q6srOejv20eFi30YZ2EJFS/EfrqUhEQQHE05ZGcHU7vOTaPoLrw4a1LqmPTPeKbNT21Fv7v7nZmOnlcrjMKhTJ8a1Di4axjqX8J4yP+jPKJbelt6Fk8kONnHmeL8VcecPCTgZNcUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723343494; c=relaxed/simple;
	bh=6sYDmnXB4sr4KGghBaIuR85hEvZNd23YFqdlkY5sXkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qGyURIQji71EjVig3HG3JUtJrxRV8bOls9M/pyWo6TuJBhfBYfdviTEx9U8nkJI87yXm3fhS0EjV6f/He0tT9xSk9z2K+Ib3vHTnI27qoUHzOeVxtVnuXjaZ/oxaD1bcjvRtuRjEnnGgtBCGuO9oK6EU55aUwAw4wnJdM0w1jmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZPAZ4/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZPAZ4/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D05DC32781
	for <linux-cifs@vger.kernel.org>; Sun, 11 Aug 2024 02:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723343493;
	bh=6sYDmnXB4sr4KGghBaIuR85hEvZNd23YFqdlkY5sXkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hZPAZ4/zTmjCIJEUIkPKmo7X7zZAhzwLxfgElNaAeyt8K3uE3ekMdJ2wKPPBV3mvV
	 FYGowR8qmpRZ9oH6xvIDWWnz2V8D4fi9naNiddKoXerkK1dqlPsya+tA/FW+k5y/i+
	 G3Q9/6izSx6vYZj1M/h4GjW3GfSVHvyYF9TJvlwd+63HET+PQgvG2Cb1voFCoWJlsX
	 nkuXn7sLxn4zJqCuzSglIbSpdqlGqz4JJnHqJsRerx2K7/jk8QDqCJ/ttHMhsbYnWb
	 V5Yi2fxY9bdzI4jIlpjKPTjo/5Aja7YcOQ5AyvrOraVWJigQAcwukHKJfGRPb8XSZf
	 tWvSKI8ZN5biw==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-25e3bc751daso2151353fac.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 Aug 2024 19:31:33 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw8Bw9FyhcBMK4rvPOXhnKbVX45kSQsIA/+FiXb/Wgv9qka8aqU
	Kfr/XqURNj0LpHYTSpLKuep17FZ500Fl3zbOLeYl9abRwFKupZ6fpSKCFtLDVGU2JcPMuoQ2Ant
	Z9RfIVbLycnbz/BXSgDIxfE3VQm0=
X-Google-Smtp-Source: AGHT+IHuOcdX1RQS923Dg2jYwSL6t3qht86tQtdmMDzhjdplFY9fo2K4IlHjpVFI0tHn9lT5Edr3trhLLNsZloQHWyk=
X-Received: by 2002:a05:6871:3a08:b0:260:e3fa:ab8d with SMTP id
 586e51a60fabf-26c62f51cf7mr7738394fac.37.1723343492853; Sat, 10 Aug 2024
 19:31:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvAVoUxDgfvbH2ywHd9+ivgRrQNMu0dRNqkJm40jyxoEg@mail.gmail.com>
 <CAKYAXd-ec8QEE+Z_k5iSMSRf8C9p0v2ENj3178yFHmJrKmhQHA@mail.gmail.com>
In-Reply-To: <CAKYAXd-ec8QEE+Z_k5iSMSRf8C9p0v2ENj3178yFHmJrKmhQHA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 11 Aug 2024 11:31:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wvY9Ha+tdgwrhD4rv8j7YoN1GbMPiB5JgvyVjdf55pg@mail.gmail.com>
Message-ID: <CAKYAXd_wvY9Ha+tdgwrhD4rv8j7YoN1GbMPiB5JgvyVjdf55pg@mail.gmail.com>
Subject: Re: field-spanning write warning
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Can you share local.config of xfstests ?

2024=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EC=9D=BC) =EC=98=A4=EC=A0=84 9:12, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Thanks for your report:)
> I will check it.
>
> 2024=EB=85=84 8=EC=9B=94 11=EC=9D=BC (=EC=9D=BC) =EC=98=A4=EC=A0=84 1:44,=
 Steve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > Running xfstests against ksmbd on kernel 6.11-rc2, I noticed the
> > following errors logged in the server's dmesg log. It was likely
> > fairly early in the test run (before the client got to test
> > generic/100 e.g.) Any ideas on the bug?
> >
> > [Sat Aug 10 15:15:24 2024] ------------[ cut here ]------------
> > [Sat Aug 10 15:15:24 2024] memcpy: detected field-spanning write (size
> > 137) of single field "(char *)&rsp->hdr.ProtocolId + sz" at
> > fs/smb/server/smb2pdu.c:1373 (size 0)
> > [Sat Aug 10 15:15:24 2024] WARNING: CPU: 3 PID: 82 at
> > fs/smb/server/smb2pdu.c:1373 ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024] Modules linked in: nls_utf8 ksmbd
> > crc32_generic rdma_cm iw_cm ib_cm cifs_arc4 nls_ucs2_utils cfg80211
> > binfmt_misc xfs nls_iso8859_1 intel_rapl_msr intel_rapl_common
> > intel_uncore_frequency_common isst_if_common xt_conntrack nf_conntrack
> > nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
> > skx_edac_common nfit nfnetlink rapl i2c_piix4 i2c_smbus hv_balloon
> > vmgenid input_leds joydev mac_hid serio_raw dm_multipath msr
> > efi_pstore dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
> > raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> > async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macsec
> > ib_core mlx5_core mlxfw psample tls pci_hyperv pci_hyperv_intf
> > hid_generic crct10dif_pclmul hv_storvsc hyperv_drm crc32_pclmul
> > hid_hyperv hv_netvsc hid scsi_transport_fc hv_utils hyperv_keyboard
> > polyval_clmulni polyval_generic hyperv_fb ghash_clmulni_intel
> > sha256_ssse3 sha1_ssse3 pata_acpi psmouse hv_vmbus floppy aesni_intel
> > crypto_simd cryptd
> > [Sat Aug 10 15:15:24 2024] CPU: 3 UID: 0 PID: 82 Comm: kworker/3:1 Not
> > tainted 6.11.0-061100rc2-generic #202408042216
> > [Sat Aug 10 15:15:24 2024] Hardware name: Microsoft Corporation
> > Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
> > [Sat Aug 10 15:15:24 2024] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd=
]
> > [Sat Aug 10 15:15:24 2024] RIP: 0010:ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024] Code: 00 3c 01 0f 87 9e 48 01 00 a8 01 75
> > b8 48 c7 c2 88 05 45 c1 4c 89 fe 48 c7 c7 d8 05 45 c1 c6 05 aa cd 01
> > 00 01 e8 e1 d1 ee f8 <0f> 0b eb 97 41 bd f4 ff ff ff e9 df fe ff ff e8
> > 7d 6c 08 fa 66 66
> > [Sat Aug 10 15:15:24 2024] RSP: 0018:ffff9b80802f7cf0 EFLAGS: 00010246
> > [Sat Aug 10 15:15:24 2024] RAX: 0000000000000000 RBX: ffff8ae7ce4a8004
> > RCX: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] RDX: 0000000000000000 RSI: 0000000000000000
> > RDI: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] RBP: ffff9b80802f7d40 R08: 0000000000000000
> > R09: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] R10: 0000000000000000 R11: 0000000000000000
> > R12: ffff8ae7ce4a804c
> > [Sat Aug 10 15:15:24 2024] R13: 0000000000000000 R14: ffff8ae7cc2eb380
> > R15: 0000000000000089
> > [Sat Aug 10 15:15:24 2024] FS:  0000000000000000(0000)
> > GS:ffff8aee63b80000(0000) knlGS:0000000000000000
> > [Sat Aug 10 15:15:24 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> > [Sat Aug 10 15:15:24 2024] CR2: 000070d3373f7a78 CR3: 00000001070cc004
> > CR4: 00000000003706f0
> > [Sat Aug 10 15:15:24 2024] DR0: 0000000000000000 DR1: 0000000000000000
> > DR2: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> > DR7: 0000000000000400
> > [Sat Aug 10 15:15:24 2024] Call Trace:
> > [Sat Aug 10 15:15:24 2024]  <TASK>
> > [Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
> > [Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
> > [Sat Aug 10 15:15:24 2024]  ? smb2_sess_setup+0x936/0xa00 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  ? show_regs.part.0+0x22/0x30
> > [Sat Aug 10 15:15:24 2024]  ? show_regs.cold+0x8/0x10
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  ? __warn.cold+0xa7/0x101
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  ? report_bug+0x114/0x160
> > [Sat Aug 10 15:15:24 2024]  ? handle_bug+0x51/0xa0
> > [Sat Aug 10 15:15:24 2024]  ? exc_invalid_op+0x18/0x80
> > [Sat Aug 10 15:15:24 2024]  ? asm_exc_invalid_op+0x1b/0x20
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_negotiate+0x1bf/0x1e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  ? ksmbd_release_crypto_ctx+0xa4/0xd0 [ksmbd=
]
> > [Sat Aug 10 15:15:24 2024]  smb2_sess_setup+0x936/0xa00 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  __process_request+0xa8/0x1c0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  process_one_work+0x177/0x350
> > [Sat Aug 10 15:15:24 2024]  worker_thread+0x31a/0x450
> > [Sat Aug 10 15:15:24 2024]  ? _raw_spin_unlock_irqrestore+0x11/0x60
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_worker_thread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  kthread+0xe4/0x110
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  ret_from_fork+0x47/0x70
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  ret_from_fork_asm+0x1a/0x30
> > [Sat Aug 10 15:15:24 2024]  </TASK>
> > [Sat Aug 10 15:15:24 2024] ---[ end trace 0000000000000000 ]---
> > [Sat Aug 10 15:15:24 2024] ------------[ cut here ]------------
> > [Sat Aug 10 15:15:24 2024] memcpy: detected field-spanning write (size
> > 9) of single field "(char *)&rsp->hdr.ProtocolId + sz" at
> > fs/smb/server/smb2pdu.c:1456 (size 0)
> > [Sat Aug 10 15:15:24 2024] WARNING: CPU: 3 PID: 82 at
> > fs/smb/server/smb2pdu.c:1456 ntlm_authenticate.isra.0+0x4cd/0x540
> > [ksmbd]
> > [Sat Aug 10 15:15:24 2024] Modules linked in: nls_utf8 ksmbd
> > crc32_generic rdma_cm iw_cm ib_cm cifs_arc4 nls_ucs2_utils cfg80211
> > binfmt_misc xfs nls_iso8859_1 intel_rapl_msr intel_rapl_common
> > intel_uncore_frequency_common isst_if_common xt_conntrack nf_conntrack
> > nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
> > skx_edac_common nfit nfnetlink rapl i2c_piix4 i2c_smbus hv_balloon
> > vmgenid input_leds joydev mac_hid serio_raw dm_multipath msr
> > efi_pstore dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
> > raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> > async_tx xor raid6_pq libcrc32c raid1 raid0 mlx5_ib ib_uverbs macsec
> > ib_core mlx5_core mlxfw psample tls pci_hyperv pci_hyperv_intf
> > hid_generic crct10dif_pclmul hv_storvsc hyperv_drm crc32_pclmul
> > hid_hyperv hv_netvsc hid scsi_transport_fc hv_utils hyperv_keyboard
> > polyval_clmulni polyval_generic hyperv_fb ghash_clmulni_intel
> > sha256_ssse3 sha1_ssse3 pata_acpi psmouse hv_vmbus floppy aesni_intel
> > crypto_simd cryptd
> > [Sat Aug 10 15:15:24 2024] CPU: 3 UID: 0 PID: 82 Comm: kworker/3:1
> > Tainted: G        W          6.11.0-061100rc2-generic #202408042216
> > [Sat Aug 10 15:15:24 2024] Tainted: [W]=3DWARN
> > [Sat Aug 10 15:15:24 2024] Hardware name: Microsoft Corporation
> > Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
> > [Sat Aug 10 15:15:24 2024] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd=
]
> > [Sat Aug 10 15:15:24 2024] RIP:
> > 0010:ntlm_authenticate.isra.0+0x4cd/0x540 [ksmbd]
> > [Sat Aug 10 15:15:24 2024] Code: e9 44 fc ff ff 48 c7 c2 c8 09 45 c1
> > 4c 89 c6 48 c7 c7 d8 05 45 c1 48 89 45 b0 4c 89 45 b8 c6 05 4b a8 01
> > 00 01 e8 83 ac ee f8 <0f> 0b 44 0f b7 7d c6 48 8b 45 b0 4c 8b 45 b8 e9
> > b5 fb ff ff 49 8b
> > [Sat Aug 10 15:15:24 2024] RSP: 0018:ffff9b80802f7ce8 EFLAGS: 00010246
> > [Sat Aug 10 15:15:24 2024] RAX: 0000000000000000 RBX: ffff8ae7cc4bbc00
> > RCX: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] RDX: 0000000000000000 RSI: 0000000000000000
> > RDI: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] RBP: ffff9b80802f7d40 R08: 0000000000000000
> > R09: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] R10: 0000000000000000 R11: 0000000000000000
> > R12: ffff8ae7ce49b800
> > [Sat Aug 10 15:15:24 2024] R13: ffff8ae7ce4a8004 R14: ffff8ae7ce4abc04
> > R15: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] FS:  0000000000000000(0000)
> > GS:ffff8aee63b80000(0000) knlGS:0000000000000000
> > [Sat Aug 10 15:15:24 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> > [Sat Aug 10 15:15:24 2024] CR2: 000070d3373f7a78 CR3: 00000001070cc004
> > CR4: 00000000003706f0
> > [Sat Aug 10 15:15:24 2024] DR0: 0000000000000000 DR1: 0000000000000000
> > DR2: 0000000000000000
> > [Sat Aug 10 15:15:24 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> > DR7: 0000000000000400
> > [Sat Aug 10 15:15:24 2024] Call Trace:
> > [Sat Aug 10 15:15:24 2024]  <TASK>
> > [Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
> > [Sat Aug 10 15:15:24 2024]  ? show_trace_log_lvl+0x1be/0x310
> > [Sat Aug 10 15:15:24 2024]  ? smb2_sess_setup+0x88c/0xa00 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  ? show_regs.part.0+0x22/0x30
> > [Sat Aug 10 15:15:24 2024]  ? show_regs.cold+0x8/0x10
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksm=
bd]
> > [Sat Aug 10 15:15:24 2024]  ? __warn.cold+0xa7/0x101
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksm=
bd]
> > [Sat Aug 10 15:15:24 2024]  ? report_bug+0x114/0x160
> > [Sat Aug 10 15:15:24 2024]  ? handle_bug+0x51/0xa0
> > [Sat Aug 10 15:15:24 2024]  ? exc_invalid_op+0x18/0x80
> > [Sat Aug 10 15:15:24 2024]  ? asm_exc_invalid_op+0x1b/0x20
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksm=
bd]
> > [Sat Aug 10 15:15:24 2024]  ? ntlm_authenticate.isra.0+0x4cd/0x540 [ksm=
bd]
> > [Sat Aug 10 15:15:24 2024]  smb2_sess_setup+0x88c/0xa00 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  __process_request+0xa8/0x1c0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  __handle_ksmbd_work+0x1ce/0x2e0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  handle_ksmbd_work+0x2d/0xa0 [ksmbd]
> > [Sat Aug 10 15:15:24 2024]  process_one_work+0x177/0x350
> > [Sat Aug 10 15:15:24 2024]  worker_thread+0x31a/0x450
> > [Sat Aug 10 15:15:24 2024]  ? _raw_spin_unlock_irqrestore+0x11/0x60
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_worker_thread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  kthread+0xe4/0x110
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  ret_from_fork+0x47/0x70
> > [Sat Aug 10 15:15:24 2024]  ? __pfx_kthread+0x10/0x10
> > [Sat Aug 10 15:15:24 2024]  ret_from_fork_asm+0x1a/0x30
> > [Sat Aug 10 15:15:24 2024]  </TASK>
> > [Sat Aug 10 15:15:24 2024] ---[ end trace 0000000000000000 ]---
> > [Sat Aug 10 16:39:21 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
> > CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > [Sat Aug 10 16:39:21 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
> > CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > [Sat Aug 10 16:39:22 2024] workqueue: handle_ksmbd_work [ksmbd] hogged
> > CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> > [Sat Aug 10 16:39:41 2024] workqueue: xfs_inodegc_worker [xfs] hogged
> > CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > [Sat Aug 10 16:39:47 2024] workqueue: xfs_inodegc_worker [xfs] hogged
> > CPU for >10000us 5 times, consider switching to WQ_UNBOUN
> >
> > --
> > Thanks,
> >
> > Steve
