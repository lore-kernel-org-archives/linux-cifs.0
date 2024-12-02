Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A265F9E6
	for <linux-cifs@vger.kernel.org>; Mon,  2 Dec 2024 08:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733126610; cv=none; b=P5DueSEW5lKDkuzJPudjUkDvcBWOJfDvdAC6mcLgivl+wHIi6Q3GjExlwNoL+QCsAAJHJD5PWPSq8SMlQl4jB3hSj4gwtsLTUqeza/+5prB6DLH4w76lDIYOLCw4ZuMSbRcKpY57RKC86XBOaWzGaLhKtmzi7DZEpCqgnNEp9hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733126610; c=relaxed/simple;
	bh=KvdgboTLUf3AIsHKnp8Kidq/Vdgy1Oby0HqtzajMzdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=cOB0xXAdoOquL/R697aBqBDVXBxOiY35mch62Vx5skIIFHTYOgZVGlqdvvCOhs0GXDEqrtgWTBF8QAUQFmHGu09lgV2OrBqmZ5KDEBsb6N9oj1nHCISFm6+/Aj0asXBBNJRi0lvgv+406Z/raMFfJkus9b6oUdZExK1051xopYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuKIJMOZ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuKIJMOZ"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso664107266b.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Dec 2024 00:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733126606; x=1733731406; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EcNvz+WaNq+ZAvmtIkrk7IlvcV0TllS/5Cxe+2Yh34M=;
        b=kuKIJMOZjq6JE++cYmg7Be879aQ7hON2pJLUgcSv8yErF042uSpO4S/JLMRajQDKIX
         5tU+nVLHwaMuHU/ATccsNzW8et54c0DJFnRpn0ayja1wrT5qLXsZMi6Myw+0ANchCNG7
         bOEFRlQCsde4bQpw5WO4zAWlnyDZcK23b3abqTQmy/q7yVM3I2KDg30pfFLpJU8pkzKc
         hqxQ2OqS6U9aZMiyOW7H3qI46hy+31A7NIHczQpxpvgy4sUPmKHggZQUeon5GddhuAaW
         1/FXdXC8sAbX4550mvW1Y78jee3B89aSfIxVAQ0Mc/QK758FoI3jIRHjFuHT4kpH1b0z
         fY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733126606; x=1733731406;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EcNvz+WaNq+ZAvmtIkrk7IlvcV0TllS/5Cxe+2Yh34M=;
        b=XWs1MfJxV0pxnaY22JBnknCy2wtLXaI6C12W2gkEK0wOj65NItBSHLf6njFJDz2R/v
         ugPcC8N2fYimjrVZHh3kZbONCel5briBxVyV5gQBDQsoLBrdWpbKJmo1aoEat3HUormE
         M8nNn0nC0c6AA7mOk9zf+UKLuiWofrQja75gXAEHeoPIakF4rXyQIW67AbuseGQdnYrJ
         KqNJC78J3QTIALcXpTNH67vWTaaXvu/3aiVfVuWgzWauC/raF/xAy4pPHN4Z4vqhqp8/
         3sfNY114Bd6Xx6hSZ1vqIycw/6by/8I3huRqdO7Jpfb+iOks80cr+Ts5nqVe62CCCZbw
         FI3w==
X-Forwarded-Encrypted: i=1; AJvYcCVG40GexlR9NMMld86A8JgjkAANkhrFJXoxFh110cziVCaxOVRSx8CUx5rtdSSdvtauvdyRNOtp8AoF@vger.kernel.org
X-Gm-Message-State: AOJu0YyxLKkGtVyX8gmzE7/3ooU9Nn1XqJaSknHOvMfuD/UJUJmWFiP3
	oH8GcWPCgqKgHGhBaCl0eBNzcreGlcFjv9pb8FFBvvdUsW00ExpCtFwAwP0yvSsMHpHo0eTBuf+
	yxHdJ9l3v50PH8VHgWVEIWOfifOxBmQ==
X-Gm-Gg: ASbGncuJfugEykaffz35DfAkk3YxnhveMUqcw50p22JrA6syGZt7VNe837bJ6dlfuw8
	X73IAs+iteKQD/L3+bmgaB6iZQkker+QVc7VKBkY66yBftrKRbvVaHyEGLQ55wQ==
X-Google-Smtp-Source: AGHT+IHu1z7Sd+Sq4COosYUHni7IZkgCw0+rfj/66MG1AS4ejUD7iLSiG+6H2hlB7FBMhx6RghUdj2bfoJKfSgOfq+k=
X-Received: by 2002:a17:906:3145:b0:aa5:1d68:1ec8 with SMTP id
 a640c23a62f3a-aa580eddd16mr1891347766b.7.1733126606153; Mon, 02 Dec 2024
 00:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
In-Reply-To: <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 2 Dec 2024 13:33:14 +0530
Message-ID: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 2, 2024 at 7:46=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> Found this null-ptr dereference in netfs code with 6.13-rc1.
>
> Is it a known issue?
>
> [Mon Dec  2 01:57:27 2024] ------------[ cut here ]------------
> [Mon Dec  2 01:57:27 2024] WARNING: CPU: 1 PID: 152 at
> fs/netfs/read_collect.c:110 netfs_consume_read_data.isra.0+0x715/0xbb0
> [netfs]
> [Mon Dec  2 01:57:27 2024] Modules linked in: cmac nls_utf8 cifs
> cifs_arc4 nls_ucs2_utils cifs_md4 netfs qrtr cfg80211 8021q garp mrp
> stp llc xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> xt_owner xt_tcpudp nft_compat nf_tables mlx5_ib ib_uverbs macsec
> binfmt_misc ib_core intel_rapl_msr intel_rapl_common
> intel_uncore_frequency_common isst_if_common nls_iso8859_1 mlx5_core
> btrfs mlxfw blake2b_generic psample xor tls skx_edac_common
> crct10dif_pclmul crc32_pclmul raid6_pq polyval_clmulni polyval_generic
> libcrc32c joydev ghash_clmulni_intel mac_hid sha256_ssse3 sha1_ssse3
> serio_raw hid_generic aesni_intel crypto_simd cryptd hyperv_drm
> hid_hyperv rapl hyperv_fb vmgenid hid hv_netvsc hyperv_keyboard
> sch_fq_codel dm_multipath msr nvme_fabrics efi_pstore nfnetlink
> ip_tables x_tables autofs4
> [Mon Dec  2 01:57:27 2024] CPU: 1 UID: 0 PID: 152 Comm: kworker/1:1
> Not tainted 6.13.0-rc1-mainline #9
> [Mon Dec  2 01:57:27 2024] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> 08/23/2024
> [Mon Dec  2 01:57:27 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
> [Mon Dec  2 01:57:27 2024] RIP:
> 0010:netfs_consume_read_data.isra.0+0x715/0xbb0 [netfs]
> [Mon Dec  2 01:57:27 2024] Code: 8b 78 08 ba 1e 00 00 00 4c 89 e6 e8
> 75 a8 ff ff e9 d7 fc ff ff 48 8b 45 90 4c 89 80 48 02 00 00 0f 1f 44
> 00 00 e9 c2 fb ff ff <0f> 0b 48 8b 43 70 48 8b 75 90 8b 7d 9c 0f b7 93
> 96 00 00 00 8b b6
> [Mon Dec  2 01:57:27 2024] RSP: 0018:ffffb2f6805dfda0 EFLAGS: 00010246
> [Mon Dec  2 01:57:27 2024] RAX: ffff969a23360c00 RBX: ffff969a18da72c0
> RCX: 0000000012800000
> [Mon Dec  2 01:57:27 2024] RDX: 0000000012a00000 RSI: ffff969a23360c00
> RDI: ffffffff9b609a30
> [Mon Dec  2 01:57:27 2024] RBP: ffffb2f6805dfe10 R08: 0000000000000020
> R09: 0000000000200000
> [Mon Dec  2 01:57:27 2024] R10: 0000000000000001 R11: 0000000000000005
> R12: 0000000000000000
> [Mon Dec  2 01:57:27 2024] R13: ffff969a232b97e8 R14: 0000000000200000
> R15: 0000000000000002
> [Mon Dec  2 01:57:27 2024] FS:  0000000000000000(0000)
> GS:ffff96bc53480000(0000) knlGS:0000000000000000
> [Mon Dec  2 01:57:27 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Mon Dec  2 01:57:27 2024] CR2: 000079a46e3fe000 CR3: 000000012cfda002
> CR4: 00000000003706f0
> [Mon Dec  2 01:57:27 2024] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> [Mon Dec  2 01:57:27 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> DR7: 0000000000000400
> [Mon Dec  2 01:57:27 2024] Call Trace:
> [Mon Dec  2 01:57:27 2024]  <TASK>
> [Mon Dec  2 01:57:27 2024]  ? show_regs+0x64/0x70
> [Mon Dec  2 01:57:27 2024]  ? __warn+0x89/0x120
> [Mon Dec  2 01:57:27 2024]  ? netfs_consume_read_data.isra.0+0x715/0xbb0 =
[netfs]
> [Mon Dec  2 01:57:27 2024]  ? report_bug+0x15d/0x180
> [Mon Dec  2 01:57:27 2024]  ? handle_bug+0x5b/0x90
> [Mon Dec  2 01:57:27 2024]  ? exc_invalid_op+0x18/0x70
> [Mon Dec  2 01:57:27 2024]  ? asm_exc_invalid_op+0x1b/0x20
> [Mon Dec  2 01:57:27 2024]  ? netfs_consume_read_data.isra.0+0x715/0xbb0 =
[netfs]
> [Mon Dec  2 01:57:27 2024]  ? __schedule+0x401/0x16e0
> [Mon Dec  2 01:57:27 2024]  netfs_read_subreq_terminated+0x2b2/0x390 [net=
fs]
> [Mon Dec  2 01:57:27 2024]  smb2_readv_worker+0x1a/0x20 [cifs]
> [Mon Dec  2 01:57:27 2024]  process_one_work+0x170/0x330
> [Mon Dec  2 01:57:27 2024]  worker_thread+0x2ce/0x400
> [Mon Dec  2 01:57:27 2024]  ? _raw_spin_unlock_irqrestore+0xe/0x20
> [Mon Dec  2 01:57:27 2024]  ? __pfx_worker_thread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  kthread+0xd4/0x100
> [Mon Dec  2 01:57:27 2024]  ? __pfx_kthread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  ret_from_fork+0x3d/0x60
> [Mon Dec  2 01:57:27 2024]  ? __pfx_kthread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  ret_from_fork_asm+0x1a/0x30
> [Mon Dec  2 01:57:27 2024]  </TASK>
> [Mon Dec  2 01:57:27 2024] ---[ end trace 0000000000000000 ]---
> [Mon Dec  2 01:57:27 2024] netfs: R=3D00002827[3] s=3D12800000-12bfffff
> ctl=3D200000/400000/400000 sl=3D2
> [Mon Dec  2 01:57:27 2024] netfs: folioq: orders=3D09090909
> [Mon Dec  2 01:57:27 2024] BUG: kernel NULL pointer dereference,
> address: 0000000000000000
> [Mon Dec  2 01:57:27 2024] #PF: supervisor write access in kernel mode
> [Mon Dec  2 01:57:27 2024] #PF: error_code(0x0002) - not-present page
> [Mon Dec  2 01:57:27 2024] PGD 0 P4D 0
> [Mon Dec  2 01:57:27 2024] Oops: Oops: 0002 [#1] SMP PTI
> [Mon Dec  2 01:57:27 2024] CPU: 1 UID: 0 PID: 152 Comm: kworker/1:1
> Tainted: G        W          6.13.0-rc1-mainline #9
> [Mon Dec  2 01:57:27 2024] Tainted: [W]=3DWARN
> [Mon Dec  2 01:57:27 2024] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> 08/23/2024
> [Mon Dec  2 01:57:27 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
> [Mon Dec  2 01:57:27 2024] RIP:
> 0010:netfs_consume_read_data.isra.0+0x35d/0xbb0 [netfs]
> [Mon Dec  2 01:57:27 2024] Code: 41 5f 5d c3 cc cc cc cc 44 8b 7d 9c
> 48 89 f0 48 2b 43 60 48 89 43 78 41 83 ff 1e 0f 87 16 08 00 00 48 8b
> 45 a0 4e 8b 64 f8 08 <f0> 41 80 0c 24 08 48 8b 45 90 48 8b 80 58 02 00
> 00 a9 00 00 00 80
> [Mon Dec  2 01:57:27 2024] RSP: 0018:ffffb2f6805dfda0 EFLAGS: 00010297
> [Mon Dec  2 01:57:27 2024] RAX: ffff969a23360c00 RBX: ffff969a18da72c0
> RCX: 0000000000200000
> [Mon Dec  2 01:57:27 2024] RDX: 0000000000000000 RSI: 0000000012c00000
> RDI: ffff96bc534a0a40
> [Mon Dec  2 01:57:27 2024] RBP: ffffb2f6805dfe10 R08: 0000000000000000
> R09: 0000000000000001
> [Mon Dec  2 01:57:27 2024] R10: ffffb2f681b42000 R11: 0000000012a00000
> R12: 0000000000000000
> [Mon Dec  2 01:57:27 2024] R13: ffff969a232b97e8 R14: 0000000000200000
> R15: 0000000000000002
> [Mon Dec  2 01:57:27 2024] FS:  0000000000000000(0000)
> GS:ffff96bc53480000(0000) knlGS:0000000000000000
> [Mon Dec  2 01:57:27 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Mon Dec  2 01:57:27 2024] CR2: 0000000000000000 CR3: 000000012cfda002
> CR4: 00000000003706f0
> [Mon Dec  2 01:57:27 2024] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> [Mon Dec  2 01:57:27 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> DR7: 0000000000000400
> [Mon Dec  2 01:57:27 2024] Call Trace:
> [Mon Dec  2 01:57:27 2024]  <TASK>
> [Mon Dec  2 01:57:27 2024]  ? show_regs+0x64/0x70
> [Mon Dec  2 01:57:27 2024]  ? __die+0x24/0x70
> [Mon Dec  2 01:57:27 2024]  ? page_fault_oops+0x290/0x5b0
> [Mon Dec  2 01:57:27 2024]  ? do_user_addr_fault+0x448/0x800
> [Mon Dec  2 01:57:27 2024]  ? irq_work_queue+0x28/0x50
> [Mon Dec  2 01:57:27 2024]  ? exc_page_fault+0x7a/0x160
> [Mon Dec  2 01:57:27 2024]  ? asm_exc_page_fault+0x27/0x30
> [Mon Dec  2 01:57:27 2024]  ? netfs_consume_read_data.isra.0+0x35d/0xbb0 =
[netfs]
> [Mon Dec  2 01:57:27 2024]  ? __schedule+0x401/0x16e0
> [Mon Dec  2 01:57:27 2024]  netfs_read_subreq_terminated+0x2b2/0x390 [net=
fs]
> [Mon Dec  2 01:57:27 2024]  smb2_readv_worker+0x1a/0x20 [cifs]
> [Mon Dec  2 01:57:27 2024]  process_one_work+0x170/0x330
> [Mon Dec  2 01:57:27 2024]  worker_thread+0x2ce/0x400
> [Mon Dec  2 01:57:27 2024]  ? _raw_spin_unlock_irqrestore+0xe/0x20
> [Mon Dec  2 01:57:27 2024]  ? __pfx_worker_thread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  kthread+0xd4/0x100
> [Mon Dec  2 01:57:27 2024]  ? __pfx_kthread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  ret_from_fork+0x3d/0x60
> [Mon Dec  2 01:57:27 2024]  ? __pfx_kthread+0x10/0x10
> [Mon Dec  2 01:57:27 2024]  ret_from_fork_asm+0x1a/0x30
> [Mon Dec  2 01:57:27 2024]  </TASK>
> [Mon Dec  2 01:57:27 2024] Modules linked in: cmac nls_utf8 cifs
> cifs_arc4 nls_ucs2_utils cifs_md4 netfs qrtr cfg80211 8021q garp mrp
> stp llc xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> xt_owner xt_tcpudp nft_compat nf_tables mlx5_ib ib_uverbs macsec
> binfmt_misc ib_core intel_rapl_msr intel_rapl_common
> intel_uncore_frequency_common isst_if_common nls_iso8859_1 mlx5_core
> btrfs mlxfw blake2b_generic psample xor tls skx_edac_common
> crct10dif_pclmul crc32_pclmul raid6_pq polyval_clmulni polyval_generic
> libcrc32c joydev ghash_clmulni_intel mac_hid sha256_ssse3 sha1_ssse3
> serio_raw hid_generic aesni_intel crypto_simd cryptd hyperv_drm
> hid_hyperv rapl hyperv_fb vmgenid hid hv_netvsc hyperv_keyboard
> sch_fq_codel dm_multipath msr nvme_fabrics efi_pstore nfnetlink
> ip_tables x_tables autofs4
> [Mon Dec  2 01:57:27 2024] CR2: 0000000000000000
> [Mon Dec  2 01:57:27 2024] ---[ end trace 0000000000000000 ]---
> [Mon Dec  2 01:57:27 2024] RIP:
> 0010:netfs_consume_read_data.isra.0+0x35d/0xbb0 [netfs]
> [Mon Dec  2 01:57:27 2024] Code: 41 5f 5d c3 cc cc cc cc 44 8b 7d 9c
> 48 89 f0 48 2b 43 60 48 89 43 78 41 83 ff 1e 0f 87 16 08 00 00 48 8b
> 45 a0 4e 8b 64 f8 08 <f0> 41 80 0c 24 08 48 8b 45 90 48 8b 80 58 02 00
> 00 a9 00 00 00 80
> [Mon Dec  2 01:57:27 2024] RSP: 0018:ffffb2f6805dfda0 EFLAGS: 00010297
> [Mon Dec  2 01:57:27 2024] RAX: ffff969a23360c00 RBX: ffff969a18da72c0
> RCX: 0000000000200000
> [Mon Dec  2 01:57:27 2024] RDX: 0000000000000000 RSI: 0000000012c00000
> RDI: ffff96bc534a0a40
> [Mon Dec  2 01:57:27 2024] RBP: ffffb2f6805dfe10 R08: 0000000000000000
> R09: 0000000000000001
> [Mon Dec  2 01:57:27 2024] R10: ffffb2f681b42000 R11: 0000000012a00000
> R12: 0000000000000000
> [Mon Dec  2 01:57:27 2024] R13: ffff969a232b97e8 R14: 0000000000200000
> R15: 0000000000000002
> [Mon Dec  2 01:57:27 2024] FS:  0000000000000000(0000)
> GS:ffff96bc53480000(0000) knlGS:0000000000000000
> [Mon Dec  2 01:57:27 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Mon Dec  2 01:57:27 2024] CR2: 0000000000000000 CR3: 000000012cfda002
> CR4: 00000000003706f0
> [Mon Dec  2 01:57:27 2024] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> [Mon Dec  2 01:57:27 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> DR7: 0000000000000400
>
>
> --
> Regards,
> Shyam

This issue is consistently reproducible for me from at least 6.12.
It shows up when several reads are in flight in parallel.

--=20
Regards,
Shyam
