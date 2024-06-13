Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD1514431F
	for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2024 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284421; cv=none; b=KRYhf0bmeMwqMhwPQSu5riCtRZC9y7cgBtpl3cdFVJl9ZiRB00WSQ7S07Tj0/n1yZCFmbVw2r0YQx5p2KZFYoHco2kMBaQpa0fAih9xv4neIZ+f+OtfGXMqIIZLVSAIZOus9axORAO+eLZRB8kUYVKtRqrd5g4z7Fw3U0QK+Voc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284421; c=relaxed/simple;
	bh=VD67ZpN2s9KZt5l2gjS1CK2z4EJC2TGzZjZaATKTPxE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r+WwCOMC5YNnjOP921ZN7f69mlBxMQfru2kYZzU7nRljEVUSX0cNiuH4AnGjKIj3sUInMs5u9ceibUNgozre8UrRX0HRQSFWCwdc5oBDX6cbqVXCL51GE2YrfScnVU8K/daZl3TDx12Bfa9F7hNNW7hJXgsGSRFD/yPwbIZqX00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=SJ0mo4x7; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="SJ0mo4x7"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-35f1bc63981so1333212f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2024 06:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1718284416; x=1718889216; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tkLRx0qzK3Vjkr/PvXo5VQr2FzWv6mPfUIolCh71VTk=;
        b=SJ0mo4x7ikxucYSeQugOqYKB/rERrEPVDEPrkfSdNCtt+6KSeZONUdJofCGD8cco8B
         Oa1ujOmclBmtsgoO0p0GkQE9+LX03qROoC9v5zGayuXpoP1Qu97VFdEaqXVAHyWtNoQI
         kyJXZD+e05Czl6SBj2G6PGt7uqk7sf3hmy8WmnXoN7/g9rp5ynIWDQorP935tnGjqE6P
         zqtvGp00srGAB1nUDxTpr7GuQKcWA1LxAQWlOv687E9ynt0k03FcPlNUX8zftQu8DTIH
         DxbO7DfYBAfRcMZRJyDkqFZrVYBEnHLjDoDsW/h3S1mLF0HEMWBXTctr3UAsA71IrOIY
         PzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284416; x=1718889216;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkLRx0qzK3Vjkr/PvXo5VQr2FzWv6mPfUIolCh71VTk=;
        b=f41eMjjiuGAM4hmLrgbQV/72MSroJH6wa8u2U3in++p8n1zbMSry7J9vxkeizwMAAo
         qrg7J8Y00FV9a3UUAEZ87OgIXnXQR51UXtIABwXZ+uol8eXd3799FJKLFlb9PR2RKhur
         33sSnS9NJPk9b+cA1oV0Yq6oWFrZNZ5xqpRXUaHJRaYRLkSXpgPCBoWbzWWkJFwGck1A
         E7I6AYro595xZScFWhk8zJZSnA5xkarYC/trk1W/H4bA8laI+cFRAYC783cd9OCCHAAn
         5hw7dzdm5leJ+cFWgJokHULiSUA0tgqxZcWeyqQ2kcH64kF2NroH4uh68Pjt+1fvZpup
         Dbhw==
X-Forwarded-Encrypted: i=1; AJvYcCWZuZT4Myqcn3+ceBpe7hBuvgIu/gE3YCLBG9EPVtCMC+HpqXOuG40yS+aQV0pdJaK+0Ddjd+T7i3r9cT83eivPjt7B4L18FQ5x2w==
X-Gm-Message-State: AOJu0YxZzc5zOeW2zBj8aqx1ub+cgQf9h8UHtjdKhQtCYMfnFDse4/n8
	Q7hE86TLK0x7MaMAJYh8igG54sf2sPwPvpJ5Nz6SR9UxvU0DfmEGY8XXQ7ojTe4=
X-Google-Smtp-Source: AGHT+IGhnRIu/Ebo0W6EIB8A+1NHvRB0prmoyqiq2+FeQgxat9LItLaql2YJ1UJKSHnw9Sm2zirxEQ==
X-Received: by 2002:adf:e501:0:b0:35f:32af:d7a with SMTP id ffacd0b85a97d-360718ec18amr2470282f8f.34.1718284415872;
        Thu, 13 Jun 2024 06:13:35 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d3:3500:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-360750f224esm1691409f8f.66.2024.06.13.06.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 06:13:35 -0700 (PDT)
Date: Thu, 13 Jun 2024 15:13:33 +0200
From: Corentin LABBE <clabbe@baylibre.com>
To: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: cifs: BUG: kernel NULL pointer dereference
Message-ID: <ZmrwfZvkueiV2GnD@Red>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

Since 6.6.30 and up to 6.8.12 ( will try more recent kernel soon), I get the following crash very often when using some CIFS share.

Jun 12 11:07:11 upsquare kernel: BUG: kernel NULL pointer dereference, address: 0000000000000000
Jun 12 11:07:11 upsquare kernel: #PF: supervisor read access in kernel mode
Jun 12 11:07:11 upsquare kernel: #PF: error_code(0x0000) - not-present page
Jun 12 11:07:11 upsquare kernel: PGD 0 P4D 0 
Jun 12 11:07:11 upsquare kernel: Oops: 0000 [#1] SMP NOPTI
Jun 12 11:07:11 upsquare kernel: CPU: 1 PID: 16741 Comm: rsync Not tainted 6.6.30-gentoo #1
Jun 12 11:07:11 upsquare kernel: Hardware name: AAEON UP-APL01/UP-APL01, BIOS UPA1AM52 08/04/2020
Jun 12 11:07:11 upsquare kernel: RIP: 0010:strcmp+0x10/0x30
Jun 12 11:07:11 upsquare kernel: Code: 84 00 00 00 00 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 31 c0 eb 08 48 83 c0 01 84 d2 74 13 <0f> b6 14 07 3a 14 06 74
 ef 19 c0 83 c8 01 c3 cc cc cc cc 31 c0 c3
Jun 12 11:07:11 upsquare kernel: RSP: 0018:ffffc9000092fbb8 EFLAGS: 00010246
Jun 12 11:07:11 upsquare kernel: RAX: 0000000000000000 RBX: ffff88810a0fefaa RCX: 000000000097362e
Jun 12 11:07:11 upsquare kernel: RDX: 0000000000000001 RSI: ffff88810a0fefaa RDI: 0000000000000000
Jun 12 11:07:11 upsquare kernel: RBP: ffffc9000092fdf0 R08: 0000000000000000 R09: 0000000000027470
Jun 12 11:07:11 upsquare kernel: R10: 0000000000000074 R11: 0000000000000001 R12: 0000000000000010
Jun 12 11:07:11 upsquare kernel: R13: ffff88813cd3a288 R14: ffff88813cd3a280 R15: ffff8881bb112200
Jun 12 11:07:11 upsquare kernel: FS:  00007feb05d14740(0000) GS:ffff888277c80000(0000) knlGS:0000000000000000
Jun 12 11:07:11 upsquare kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 12 11:07:11 upsquare kernel: CR2: 0000000000000000 CR3: 00000001678a6000 CR4: 00000000003506e0
Jun 12 11:07:11 upsquare kernel: Call Trace:
Jun 12 11:07:11 upsquare kernel:  <TASK>
Jun 12 11:07:11 upsquare kernel:  ? __die+0x1e/0x60
Jun 12 11:07:11 upsquare kernel:  ? page_fault_oops+0x158/0x440
Jun 12 11:07:11 upsquare kernel:  ? __kmem_cache_free+0x81/0x270
Jun 12 11:07:11 upsquare kernel:  ? exc_page_fault+0x325/0x600
Jun 12 11:07:11 upsquare kernel:  ? cifsConvertToUTF16.part.0+0x1d0/0x3b0 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? asm_exc_page_fault+0x26/0x30
Jun 12 11:07:11 upsquare kernel:  ? strcmp+0x10/0x30
Jun 12 11:07:11 upsquare kernel:  open_cached_dir+0x15a/0xaa0 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? cifs_small_buf_get+0x15/0x30 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? __smb2_plain_req_init+0xd2/0x220 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? free_rsp_buf+0x2e/0x60 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? SMB2_query_directory+0x146/0x230 [cifs]
Jun 12 11:07:11 upsquare kernel:  ? cifs_readdir+0xa3a/0xb50 [cifs]
Jun 12 11:07:11 upsquare kernel:  cifs_readdir+0xa3a/0xb50 [cifs]
Jun 12 11:07:11 upsquare kernel:  iterate_dir+0x83/0x140
Jun 12 11:07:11 upsquare kernel:  __x64_sys_getdents64+0x83/0x120
Jun 12 11:07:11 upsquare kernel:  ? __pfx_filldir64+0x10/0x10
Jun 12 11:07:11 upsquare kernel:  do_syscall_64+0x39/0x90
Jun 12 11:07:11 upsquare kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 12 11:07:11 upsquare kernel: RIP: 0033:0x7feb05de7213
Jun 12 11:07:11 upsquare kernel: Code: 89 df e8 80 50 fb ff 48 83 c4 08 48 89 e8 5b 5d c3 66 0f 1f 44 00 00 b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05
 c3 0f 1f 40 00 48 8b 15 d1 fb 0f 00 f7 d8
Jun 12 11:07:11 upsquare kernel: RSP: 002b:00007fff832b06b8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
Jun 12 11:07:11 upsquare kernel: RAX: ffffffffffffffda RBX: 000055a08c788170 RCX: 00007feb05de7213
Jun 12 11:07:11 upsquare kernel: RDX: 0000000000100000 RSI: 000055a08c7881a0 RDI: 0000000000000003
Jun 12 11:07:11 upsquare kernel: RBP: 000055a08c788174 R08: 000000000000000a R09: 0000000000000000
Jun 12 11:07:11 upsquare kernel: R10: 0000000000000000 R11: 0000000000000293 R12: 000055a08c7881a0
Jun 12 11:07:11 upsquare kernel: R13: ffffffffffffff88 R14: 0000000000000000 R15: 000055a08c7882b8
Jun 12 11:07:11 upsquare kernel:  </TASK>
Jun 12 11:07:11 upsquare kernel: Modules linked in: veth xt_nat xt_tcpudp xt_conntrack xt_MASQUERADE nfnetlink iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_addrtype br_ne
tfilter bridge stp llc overlay md5 cmac cifs cifs_arc4 netfs nls_ucs2_utils cifs_md4 xts ecb dm_crypt iptable_filter ip_tables x_tables ipv6 iwlmvm mac80211 libarc4 iwlwifi sha256_generic li
bsha256 i915 cfg80211 x86_pkg_temp_thermal rfkill i2c_algo_bit drm_buddy intel_gtt drm_display_helper ttm efivarfs
Jun 12 11:07:11 upsquare kernel: CR2: 0000000000000000
Jun 12 11:07:11 upsquare kernel: ---[ end trace 0000000000000000 ]---


The other trace I got:
Jun  7 21:15:21 upsquare kernel: BUG: kernel NULL pointer dereference, address: 0000000000000000
Jun  7 21:15:21 upsquare kernel: #PF: supervisor read access in kernel mode
Jun  7 21:15:21 upsquare kernel: #PF: error_code(0x0000) - not-present page
Jun  7 21:15:21 upsquare kernel: PGD 0 P4D 0 
Jun  7 21:15:21 upsquare kernel: Oops: 0000 [#1] SMP NOPTI
Jun  7 21:15:21 upsquare kernel: CPU: 1 PID: 26962 Comm: rsync Not tainted 6.6.30-gentoo #1
Jun  7 21:15:21 upsquare kernel: Hardware name: AAEON UP-APL01/UP-APL01, BIOS UPA1AM52 08/04/2020
Jun  7 21:15:21 upsquare kernel: RIP: 0010:strcmp+0x10/0x30
Jun  7 21:15:21 upsquare kernel: Code: 84 00 00 00 00 00 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 31 c0 eb 08 48 83 c0 01 84 d2 74 13 <0f> b6 14 07 3a 14 06 74
 ef 19 c0 83 c8 01 c3 cc cc cc cc 31 c0 c3
Jun  7 21:15:21 upsquare kernel: RSP: 0018:ffffc90000c3fbb8 EFLAGS: 00010246
Jun  7 21:15:21 upsquare kernel: RAX: 0000000000000000 RBX: ffff88810e2ebfcb RCX: 00000000004279db
Jun  7 21:15:21 upsquare kernel: RDX: 0000000000000001 RSI: ffff88810e2ebfcb RDI: 0000000000000000
Jun  7 21:15:21 upsquare kernel: RBP: ffffc90000c3fdf0 R08: 0000000000000000 R09: 0000000000027470
Jun  7 21:15:21 upsquare kernel: R10: 0000000000000065 R11: 0000000000000001 R12: 0000000000000010
Jun  7 21:15:21 upsquare kernel: R13: ffff888107dcdd08 R14: ffff888107dcdd00 R15: ffff88818318fa00
Jun  7 21:15:21 upsquare kernel: FS:  00007fac604fe740(0000) GS:ffff888277c80000(0000) knlGS:0000000000000000
Jun  7 21:15:21 upsquare kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun  7 21:15:21 upsquare kernel: CR2: 0000000000000000 CR3: 0000000145dae000 CR4: 00000000003506e0
Jun  7 21:15:21 upsquare kernel: Call Trace:
Jun  7 21:15:21 upsquare kernel:  <TASK>
Jun  7 21:15:21 upsquare kernel:  ? __die+0x1e/0x60
Jun  7 21:15:21 upsquare kernel:  ? page_fault_oops+0x158/0x440
Jun  7 21:15:21 upsquare kernel:  ? __cond_resched+0x15/0x50
Jun  7 21:15:21 upsquare kernel:  ? __kmem_cache_alloc_node+0x273/0x3f0
Jun  7 21:15:21 upsquare kernel:  ? cifsConvertToUTF16.part.0+0x48/0x3b0 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? exc_page_fault+0x325/0x600
Jun  7 21:15:21 upsquare kernel:  ? cifsConvertToUTF16.part.0+0x1d0/0x3b0 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? asm_exc_page_fault+0x26/0x30
Jun  7 21:15:21 upsquare kernel:  ? strcmp+0x10/0x30
Jun  7 21:15:21 upsquare kernel:  open_cached_dir+0x15a/0xaa0 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? finish_wait+0x33/0x70
Jun  7 21:15:21 upsquare kernel:  ? smb2_reconnect+0x11c/0x4d0 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? SMB2_query_directory_init+0x43/0x160 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? SMB2_query_directory+0x11b/0x230 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? SMB2_query_directory+0x146/0x230 [cifs]
Jun  7 21:15:21 upsquare kernel:  ? cifs_readdir+0xa0d/0xb50 [cifs]
Jun  7 21:15:21 upsquare kernel:  cifs_readdir+0xa0d/0xb50 [cifs]
Jun  7 21:15:21 upsquare kernel:  iterate_dir+0x83/0x140
Jun  7 21:15:21 upsquare kernel:  __x64_sys_getdents64+0x83/0x120
Jun  7 21:15:21 upsquare kernel:  ? __pfx_filldir64+0x10/0x10
Jun  7 21:15:21 upsquare kernel:  do_syscall_64+0x39/0x90
Jun  7 21:15:21 upsquare kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun  7 21:15:21 upsquare kernel: RIP: 0033:0x7fac605d1213
Jun  7 21:15:21 upsquare kernel: Code: 89 df e8 80 50 fb ff 48 83 c4 08 48 89 e8 5b 5d c3 66 0f 1f 44 00 00 b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05
 c3 0f 1f 40 00 48 8b 15 d1 fb 0f 00 f7 d8
Jun  7 21:15:21 upsquare kernel: RSP: 002b:00007ffe27344878 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
Jun  7 21:15:21 upsquare kernel: RAX: ffffffffffffffda RBX: 00005562dcde33d0 RCX: 00007fac605d1213
Jun  7 21:15:21 upsquare kernel: RDX: 0000000000100000 RSI: 00005562dcde3400 RDI: 0000000000000003
Jun  7 21:15:21 upsquare kernel: RBP: 00005562dcde33d4 R08: 000000000000006f R09: 0000000000000000
Jun  7 21:15:21 upsquare kernel: R10: 0000000000000000 R11: 0000000000000293 R12: 00005562dcde3400
Jun  7 21:15:21 upsquare kernel: R13: ffffffffffffff88 R14: 0000000000000000 R15: 00005562dcde38d0
Jun  7 21:15:21 upsquare kernel:  </TASK>
Jun  7 21:15:21 upsquare kernel: Modules linked in: xt_nat xt_tcpudp veth xt_conntrack xt_MASQUERADE nfnetlink iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_addrtype br_ne
tfilter bridge stp llc overlay md5 cmac cifs cifs_arc4 netfs nls_ucs2_utils cifs_md4 xts ecb dm_crypt iptable_filter ip_tables x_tables ipv6 iwlmvm mac80211 libarc4 iwlwifi sha256_generic li
bsha256 cfg80211 i915 x86_pkg_temp_thermal rfkill i2c_algo_bit drm_buddy intel_gtt drm_display_helper ttm efivarfs
Jun  7 21:15:21 upsquare kernel: CR2: 0000000000000000
Jun  7 21:15:21 upsquare kernel: ---[ end trace 0000000000000000 ]---


Jun 12 17:55:26 upsquare kernel: BUG: kernel NULL pointer dereference, address: 0000000000000098
Jun 12 17:55:26 upsquare kernel: #PF: supervisor read access in kernel mode
Jun 12 17:55:26 upsquare kernel: #PF: error_code(0x0000) - not-present page
Jun 12 17:55:26 upsquare kernel: PGD 0 P4D 0 
Jun 12 17:55:26 upsquare kernel: Oops: 0000 [#1] SMP NOPTI
Jun 12 17:55:26 upsquare kernel: CPU: 3 PID: 14166 Comm: rsync Not tainted 6.8.12-gentoo #1
Jun 12 17:55:26 upsquare kernel: Hardware name: AAEON UP-APL01/UP-APL01, BIOS UPA1AM52 08/04/2020
Jun 12 17:55:26 upsquare kernel: RIP: 0010:open_cached_dir_by_dentry+0x5d/0xb0 [cifs]
Jun 12 17:55:26 upsquare kernel: Code: 48 85 ed 75 25 48 8b 1b 48 39 c3 75 f8 41 c6 04 24 00 5b b8 fe ff ff ff 5d 41 5c 41 5d c3 cc cc cc cc 48 8b 1b 48 39 d8 74 e3 <48> 39 ab 98 00 00 00 75
 ef 48 8d 7b 30 b8 01 00 00 00 f0 0f c1 43
Jun 12 17:55:26 upsquare kernel: RSP: 0018:ffffb604006ffb30 EFLAGS: 00010286
Jun 12 17:55:26 upsquare kernel: RAX: ffff9c2ac01ed788 RBX: 0000000000000000 RCX: 0000003100000000
Jun 12 17:55:26 upsquare kernel: RDX: 0000000000000001 RSI: ffff9c2acc7b2480 RDI: ffff9c2ac01ed780
Jun 12 17:55:26 upsquare kernel: RBP: ffff9c2acc7b2480 R08: 0000000000000064 R09: 616720796d2f7374
Jun 12 17:55:26 upsquare kernel: R10: 0000000000000002 R11: 0000000000000002 R12: ffff9c2ac01ed780
Jun 12 17:55:26 upsquare kernel: R13: ffffb604006ffb58 R14: d0d0d0d0d0d0d0d0 R15: 2f2f2f2f2f2f2f2f
Jun 12 17:55:26 upsquare kernel: FS:  00007fe8fe06b740(0000) GS:ffff9c2c37d80000(0000) knlGS:0000000000000000
Jun 12 17:55:26 upsquare kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 12 17:55:26 upsquare kernel: CR2: 0000000000000098 CR3: 0000000120f9c000 CR4: 00000000003506f0
Jun 12 17:55:26 upsquare kernel: Call Trace:
Jun 12 17:55:26 upsquare kernel:  <TASK>
Jun 12 17:55:26 upsquare kernel:  ? __die+0x1e/0x60
Jun 12 17:55:26 upsquare kernel:  ? page_fault_oops+0x158/0x440
Jun 12 17:55:26 upsquare kernel:  ? schedule_timeout+0x8a/0xf0
Jun 12 17:55:26 upsquare kernel:  ? finish_wait+0x33/0x70
Jun 12 17:55:26 upsquare kernel:  ? exc_page_fault+0x316/0x5c0
Jun 12 17:55:26 upsquare kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
Jun 12 17:55:26 upsquare kernel:  ? asm_exc_page_fault+0x26/0x30
Jun 12 17:55:26 upsquare kernel:  ? open_cached_dir_by_dentry+0x5d/0xb0 [cifs]
Jun 12 17:55:26 upsquare kernel:  cifs_dentry_needs_reval+0xa4/0x1a0 [cifs]
Jun 12 17:55:26 upsquare kernel:  cifs_revalidate_dentry_attr+0x3f/0x160 [cifs]
Jun 12 17:55:26 upsquare kernel:  cifs_revalidate_dentry+0xe/0x30 [cifs]
Jun 12 17:55:26 upsquare kernel:  cifs_d_revalidate+0x4e/0xd0 [cifs]
Jun 12 17:55:26 upsquare kernel:  lookup_fast+0x73/0xf0
Jun 12 17:55:26 upsquare kernel:  walk_component+0x1a/0x150
Jun 12 17:55:26 upsquare kernel:  link_path_walk.part.0.constprop.0+0x261/0x360
Jun 12 17:55:26 upsquare kernel:  path_lookupat+0x39/0x1a0
Jun 12 17:55:26 upsquare kernel:  ? flat_send_IPI_mask+0x15/0x30
Jun 12 17:55:26 upsquare kernel:  filename_lookup+0xcf/0x1d0
Jun 12 17:55:26 upsquare kernel:  ? inode_update_timestamps+0x69/0x160
Jun 12 17:55:26 upsquare kernel:  ? file_update_time+0x62/0x80
Jun 12 17:55:26 upsquare kernel:  vfs_statx+0x7b/0x170
Jun 12 17:55:26 upsquare kernel:  vfs_fstatat+0xbf/0x100
Jun 12 17:55:26 upsquare kernel:  __do_sys_newfstatat+0x26/0x60
Jun 12 17:55:26 upsquare kernel:  ? __memcg_slab_free_hook+0xad/0x100
Jun 12 17:55:26 upsquare kernel:  ? __x64_sys_close+0x38/0x80
Jun 12 17:55:26 upsquare kernel:  ? kmem_cache_free+0x27d/0x2f0
Jun 12 17:55:26 upsquare kernel:  ? syscall_exit_to_user_mode+0x54/0x120
Jun 12 17:55:26 upsquare kernel:  do_syscall_64+0x4d/0x110
Jun 12 17:55:26 upsquare kernel:  entry_SYSCALL_64_after_hwframe+0x78/0x80
Jun 12 17:55:26 upsquare kernel: RIP: 0033:0x7fe8fe16020a
Jun 12 17:55:26 upsquare kernel: Code: 48 8b 15 11 dc 0d 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 41 89 ca b8 06 01 00 00 0f 05 <3d> 00 f0 ff ff 77 07 31
 c0 c3 0f 1f 40 00 48 8b 15 d9 db 0d 00 f7
Jun 12 17:55:26 upsquare kernel: RSP: 002b:00007fffeafa3308 EFLAGS: 00000202 ORIG_RAX: 0000000000000106
Jun 12 17:55:26 upsquare kernel: RAX: ffffffffffffffda RBX: 00007fffeafa3440 RCX: 00007fe8fe16020a
Jun 12 17:55:26 upsquare kernel: RDX: 00007fffeafa3440 RSI: 00007fffeafa34d0 RDI: 00000000ffffff9c
Jun 12 17:55:26 upsquare kernel: RBP: 0000000000000000 R08: 00005582c1429c9f R09: 0000000000000008
Jun 12 17:55:26 upsquare kernel: R10: 0000000000000100 R11: 0000000000000202 R12: 00007fffeafa34d0
Jun 12 17:55:26 upsquare kernel: R13: 00007fffeafa3440 R14: 00007fffeafa34d0 R15: 000000000000002e
Jun 12 17:55:26 upsquare kernel:  </TASK>
Jun 12 17:55:26 upsquare kernel: Modules linked in: md5 cmac cifs cifs_arc4 nls_ucs2_utils netfs cifs_md4 xts dm_crypt iptable_filter ip_tables x_tables ipv6 iwlmvm mac80211 libarc4 iwlwifi 
i915 sha256_generic libsha256 x86_pkg_temp_thermal cfg80211 rfkill i2c_algo_bit drm_buddy intel_gtt drm_display_helper ttm efivarfs
Jun 12 17:55:26 upsquare kernel: CR2: 0000000000000098
Jun 12 17:55:26 upsquare kernel: ---[ end trace 0000000000000000 ]---

Regards
