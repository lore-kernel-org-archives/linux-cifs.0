Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B67A1D432A
	for <linux-cifs@vger.kernel.org>; Thu, 10 Oct 2024 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571267; cv=none; b=SeRExKl2LZ+rPwh9LrO1hz6/JSy30FoU3cwyEXRCBw5rC/izxy+RuSltM9bOjI6agoGpGNBAgB9V4bC6qWM5BY4X0eL1zuI14246ujx+cmQmEmkMB5r3erZGO0oqq0dEyeqLHpnxNnz8riBgn1MvLwKfbFSFUm5xdhiRZRReVSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571267; c=relaxed/simple;
	bh=22MwZV7t7lInvZ7qTHTrcSlF1VPnfM8zuvZ16fzDPRk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bJ1zqhAz8Hzqqy3r8UawRoQUCqZQrPbe5hgU3dsyTR+o0s2QWGmkmN388+o2L+ItT6i8M5kvQKoZKrF7i4jiEs8UO6J8WdmsgMyiQ1XlQbzk/VFbTvggC56uqmAUfQGgsPHXoS/w5DmZrjlBt8PGbpekol5JvN1t3RpBDOjdx/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMBDgdKA; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMBDgdKA"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5369f1c7cb8so1405045e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 10 Oct 2024 07:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728571264; x=1729176064; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZvIvDQoMUIUjMYfbW4IhN9mXx5tcjd8NxRU7STpp7rI=;
        b=KMBDgdKA1GkCvfX5VHoG7Z8TV7walIbKWIdW/tgvwp1Zr0x/ZFQfMaxUOSXhl3YZZD
         PTK4i0q61ZN24Kkr66/DhzQ1zvtcPmnCSUtqoFenwEQVT9Uw0+Wy1S/hUSwPob2UVwRd
         BfVFEvQeNjidaszx/vezVRG1CJVd6PwtDx9Us1wk/c+gUuTt7u4w1f5Jdu6AKfSS3342
         vaFU07J+ze6S5F5iAWGv9us2Wr+DrTetp97mcL6JyXuAEGEkC/ykWOP87LfmZJpQHfnP
         jtQrPNcu90CGmEHrDaOUrUN5k4n5fw8IBZnPv4LEO0psd6H2gR7YK8LmGxa52Cg40soe
         9pFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728571264; x=1729176064;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZvIvDQoMUIUjMYfbW4IhN9mXx5tcjd8NxRU7STpp7rI=;
        b=U4dTaY9fRzHYq0bSF8yJGR1JHTKcvYiQu24h/bqgPSILsnW2kdKLxb4s5ZSOeCRxqJ
         O8b4WyTYlkOM48aGLuOLmNIcEwTarf7UUkU0zzdK0GXUoDDGeMqpqZ+RExz+Y4n1VZUV
         ignV+mc+rB1jqUJ8dggvb3y1ITuj5Wx0ozQcftgx0Fi7w1T3ztBBBmsduqKyjGfnrcPe
         wUZtF9DwpCjvkEZjv3ex+efKQ3BDrIfIHT0f513qYS73dpmoYM9C0AsfSnJkTeSd7ffM
         3QS7fqjESddZehOEyfzaTvZwu9QCEGGKp7IfIdZJR4jayh5Drr/8pjGRN8fin+SyPvnt
         v9ng==
X-Gm-Message-State: AOJu0Yw4KfaBTCv/oyTymNwDDULyxyTWNUkrE0tYhpro896BMEcXrFUA
	GAQPAw54lhWtPjRo0E0kLTNUOVE6FY6fmQdV1qqQNk/T+z0mtEF7xOTUz6dS9OuE5sukhm+pMph
	egl9u/gr4TOMGeqFQi5H7RSSMPFlkQLbd
X-Google-Smtp-Source: AGHT+IGSin8rwge78kv3xeeI/Ljs2GcZKwBcrgddbS+qjc8VPsQVluCisARSJfrYF2E9vWSNboZm3pDSTQT9EWd05vw=
X-Received: by 2002:a05:6512:10c4:b0:538:9efb:dbe4 with SMTP id
 2adb3069b0e04-539c495b9ecmr4466690e87.46.1728571263554; Thu, 10 Oct 2024
 07:41:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steven Malis <smmalis37@gmail.com>
Date: Thu, 10 Oct 2024 10:40:27 -0400
Message-ID: <CAHFp+BejrfrTJOERpkCgWnMe+2+0bxL9pRk8_qPuRu3HHhb1cQ@mail.gmail.com>
Subject: Kernel panic during copy of large file
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all. I just experienced a kernel panic while copying a ~22GB file
from my local drive to my NAS mounted via CIFS/SMB. Unfortunately this
panic seems to have resulted in some sort of corruption, and my system
is no longer booting. Please let me know what other information I can
provide to help out here, and I'll provide it as soon as I can get my
system working again.

[33936.494831] CIFS: VFS: \\192.168.0.4 Error -32 sending data on
socket to server
[33936.499033] CIFS: VFS: \\192.168.0.4 Error -32 sending data on
socket to server
[33936.506298] ------------[ cut here ]------------
[33936.506307] kernel BUG at lib/iov_iter.c:563!
[33936.519703] Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[33936.524934] CPU: 3 UID: 0 PID: 581 Comm: cifsd Not tainted
6.11.2-arch1-1 #1 6667b52d0e7397e7c0c02157894d188bad0541b5
[33936.530110] Hardware name: Intel(R) Client Systems
NUC8i3BEH/NUC8BEB, BIOS BECFL357.86A.0072.2019.0524.1801 05/24/2019
[33936.535257] RIP: 0010:iov_iter_revert+0x10e/0x110
[33936.540205] Code: 48 29 fe 8b 79 08 48 89 50 20 48 83 c2 01 48 39
f7 72 e9 48 29 f7 48 89 48 10 48 89 78 08 c3 cc cc cc cc 0f 0b c3 cc
cc cc cc <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 56
45 89
[33936.545554] RSP: 0000:ffffa3e6c1307dc8 EFLAGS: 00010246
[33936.550928] RAX: ffff89025f0743f8 RBX: ffff890007b0c000 RCX: ffffffff98b283a0
[33936.556304] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 0000000000000004
[33936.561689] RBP: ffff89025f0743c0 R08: ffff89075ecb6980 R09: ffff890014030090
[33936.567069] R10: ffff89075ecb69d0 R11: 0000000000000000 R12: 0000000000400000
[33936.572157] R13: ffff8903f5aaf240 R14: 0000000000400050 R15: 00000000ffffff99
[33936.577219] FS:  0000000000000000(0000) GS:ffff89075ed80000(0000)
knlGS:0000000000000000
[33936.582382] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[33936.586410] CR2: 00007465eb3e1480 CR3: 000000011348c006 CR4: 00000000003706f0
[33936.590439] Call Trace:
[33936.594069]  <TASK>
[33936.597260]  ? __die_body.cold+0x19/0x27
[33936.600460]  ? die+0x2e/0x50
[33936.603227]  ? do_trap+0xca/0x110
[33936.605875]  ? do_error_trap+0x6a/0x90
[33936.608513]  ? iov_iter_revert+0x10e/0x110
[33936.611032]  ? exc_invalid_op+0x50/0x70
[33936.613275]  ? iov_iter_revert+0x10e/0x110
[33936.615537]  ? asm_exc_invalid_op+0x1a/0x20
[33936.617768]  ? iov_iter_revert+0x10e/0x110
[33936.619912]  cifs_readv_receive+0x5f8/0x660 [cifs
2fc02a466fc4887c8669edb79b6d58b6265db8f9]
[33936.622052]  cifs_demultiplex_thread+0x456/0xa90 [cifs
2fc02a466fc4887c8669edb79b6d58b6265db8f9]
[33936.624206]  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs
2fc02a466fc4887c8669edb79b6d58b6265db8f9]
[33936.626373]  kthread+0xcf/0x100
[33936.628363]  ? __pfx_kthread+0x10/0x10
[33936.630162]  ret_from_fork+0x31/0x50
[33936.631955]  ? __pfx_kthread+0x10/0x10
[33936.633724]  ret_from_fork_asm+0x1a/0x30
[33936.635499]  </TASK>
[33936.637252] Modules linked in: cmac nls_utf8 cifs cifs_arc4
nls_ucs2_utils rdma_cm iw_cm ib_cm ib_core cifs_md4 dns_resolver netfs
nls_iso8859_1 vfat fat intel_rapl_msr intel_rapl_common
intel_uncore_frequency intel_uncore_frequency_common intel_tcc_cooling
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic
ghash_clmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3 jc42
aesni_intel iwlmvm gf128mul btusb iTCO_wdt crypto_simd btrtl
intel_pmc_bxt cryptd btintel iTCO_vendor_support btbcm ee1004 mei_hdcp
rapl mei_pxp mac80211 btmtk intel_cstate e1000e libarc4 spi_nor
intel_uncore ptp pcspkr i2c_i801 bluetooth wmi_bmof intel_pmc_core
iwlwifi intel_wmi_thunderbolt mei_me pps_core mtd i2c_smbus mei cp210x
i2c_mux intel_pch_thermal pinctrl_cannonlake intel_vsec pmt_telemetry
cfg80211 pmt_class acpi_pad acpi_tad rfkill mac_hid loop dm_mod
nfnetlink ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
i915 rtsx_pci_sdmmc mmc_core i2c_algo_bit drm_buddy
[33936.637326]  crc32c_intel ttm xhci_pci intel_gtt spi_intel_pci
xhci_pci_renesas drm_display_helper rtsx_pci spi_intel video cec wmi
[33936.650655] ---[ end trace 0000000000000000 ]---
[33936.653431] RIP: 0010:iov_iter_revert+0x10e/0x110
[33936.655726] Code: 48 29 fe 8b 79 08 48 89 50 20 48 83 c2 01 48 39
f7 72 e9 48 29 f7 48 89 48 10 48 89 78 08 c3 cc cc cc cc 0f 0b c3 cc
cc cc cc <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 56
45 89
[33936.658211] RSP: 0000:ffffa3e6c1307dc8 EFLAGS: 00010246
[33936.660789] RAX: ffff89025f0743f8 RBX: ffff890007b0c000 RCX: ffffffff98b283a0
[33936.663294] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 0000000000000004
[33936.666273] RBP: ffff89025f0743c0 R08: ffff89075ecb6980 R09: ffff890014030090
[33936.668804] R10: ffff89075ecb69d0 R11: 0000000000000000 R12: 0000000000400000
[33936.671298] R13: ffff8903f5aaf240 R14: 0000000000400050 R15: 00000000ffffff99
[33936.673315] FS:  0000000000000000(0000) GS:ffff89075ed00000(0000)
knlGS:0000000000000000
[33936.675570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[33936.677320] CR2: 0000726ae3132000 CR3: 0000000120240004 CR4: 00000000003706f0
[34084.769849] CIFS: VFS: cifs_setlk failed rc=-22

Steven Malis
