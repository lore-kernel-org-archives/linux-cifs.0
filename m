Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962198;
	b=F12zw7Uo/x3cKTToyz5Fe+oOJB/L1K/gHvG2/KAO//Ry415r/V8LWZXuzDoqgnkNpFGX
	 PnhFo7DX7KSSOELOGnc9Rnc2QLE/f+e/Mdo1zsHRl0xooPtxRiH9WFkEx8QvLIYKUJ2b4
	 fSQXuPQWyPz+csSQJjHzGAjPwSOSfAAQtgjARL7xmcIUvLKvZt6pke4VyLzgEGw0srGAQ
	 pnSgSm6E2Y1zEkx4rBlDb6ueOWtnOwLyQkxkue9awh7CTTMSunw2w9ksvvgsIiMi/Eu2t
	 /uCD7T4VHOAewZk8hso/IYtvrWtmK8W8fRta5AzBuulW5uCy7VtgBCDuV7z+8dJA9Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vozgox7VuTujIqMpvfXqXiEr1XVbfBQ1Yg/sCJ3vgMc=;
	b=hyr+wZSYo8gyLtftURMbyU96Y9FeoizPXmXQj4N88LUIFODabMx1yBfIA6T+eB0Kykl+
	 nSGSiWe4dXWRQ3IX8kMg6UvB+R9/l9lZD2Q0pTaBwxTUASjZ8eOubqSH68RMiTs/xALem
	 ja5C5hxDERs5IDQVcLLFv/1s42/GhnW8nztdAdsau2/MTlksWsyy4GvIGyFRae3lnA/11
	 rfwfMBYwJQ9dQg2OLw7rDDmJijqP/r0p5mPHrEvc25h5rQ2UWAUc2kAFrTGrsLBP2RkGe
	 /Den/SBT9NQrGs+zcTJW0WdrVDDR49nHS6tuYmQRMKjYhkUx0Dzg2ujnqBPS+UgzFQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MbpXc3Ig;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124CF606D828
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 10:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 124CF606D828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MbpXc3Ig
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso175320a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 02:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793962196; x=1794566996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vozgox7VuTujIqMpvfXqXiEr1XVbfBQ1Yg/sCJ3vgMc=;
        b=MbpXc3IguyIuW7Vj/867woyPgK8qvhQ9rCY38XYd27/69KkdXHqw2FGysml1MyCceJ
         wPsaD+TvxJj2ZWdlbDNqsu2lsZle5Y3QzpNnoleTepCJpoIb03x2K1yzICHBJE+quMu7
         WVltu7ap+qTPieyEoUl3xnwcsgw4DskmD6WuMtI6KptiWnE4bHhS+xKObVboBdn++KV2
         w3/ITF/GR/IS3UDqBrj65xrNkeICZA7PrbRxOMy1Vbbkjcb63r06aAcXpI3mzy5UfYbf
         xA4LfR/tNEMmHRal98sThlnebuetPbDALb7GGL/veP5btH9NxKUM8hc2OKx+BKBoMjYg
         pKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793962196; x=1794566996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vozgox7VuTujIqMpvfXqXiEr1XVbfBQ1Yg/sCJ3vgMc=;
        b=kRpqfhNcM8Off1TZk4w3FGo3zB05rmzorhEjRffD8UWp8RrtQEC39gyZzqm9GWBcxY
         B+Y8jA76gwBBgWO+lok/ypzigwHsr413wVjOdtEoalT/Au0LKSMOr6qhdiblheuHsbaU
         Qt1apb0ZxUO2Yx9MTo7XfOVdf3YrRfNOwLmQQhTdqiiXTuwL1MBvGXZJx6v0tubiKBib
         xuCSSBSwv1oNS56J+qhhWQ4UEQ18zidog8jS9BdOEpHZn7zaC55BvJbwTjuEl9l0VWe1
         SZS7OZcW+H1ZIZpIPG4M/VV9VVVq6Kgl7HilBMXnr2YtrzI+PDDc07IXsB1V5/fnpVXH
         OnwQ==
X-Gm-Message-State: APuU4Z8eVQ8lbTsaLCT4XxvTFBd0CP25mv7Jm5/UeYGE9/zpkMnTlmPs
	AQLArIAVXQljEVUzNn7pE36inSN7vEFF/v1mNpyvsw8KEegtY/8uTAye
X-Gm-Gg: AYBFou3aqYBzxJ/nsBjLPnqcrVZ4ooNhT6Pemqm2XnXzAbA+bZwdIZXXEVXlUyS+uf3
	raLyovulfht/DC8wNfZTamDDaGqj0UIaGJqy8JMNPIr3qvCHJ9dXvJmcvaTh79X2q60GOfKDuUI
	j3n7t2kZc+8TtTCvBlIe4uPchU1BjDt9ovF0Ybf6mEeSGcqIPDaIz+nL1iHsH41In59qOLqlcr3
	gzg/OnUwEPKtzyca4Oylg5yoYUMPUXOknAWW/mfaprBtTnX7NU992ZRATsuldAognx+CIkTlDCl
	AiBPNTCN58AAtmtp0rIl3RZTYDJIbkf6ChCMspazi28VYmlbXyDx7AuJnOrmcEK3Sxc1FVGhUmS
	CasmAVEA0Asi1Lv4vD9BARTmCCH/y2Giveo5q6OKWzzdEn5slSRg5bXefKohsyKxPMVlAYoYtvQ
	/rR+s6ocR56nh25dRbZnTClIVQqEoSHkQenJXB2k2TGmLETAJkQfH/c1GGAzj2uDZLrNf9MptyM
	rC7JMUHrfd+00MmPprJ8wKa5sJKztpqaw/+ZWatNYk0ygqyW9iVadrZRr54G896zq/JTAXB6hnT
	/ld/av6xtruiEUaNh5QZp7EhRNdiXGgzZg+t72oyDw==
X-Received: by 2002:a17:90b:2682:b0:3b0:a7e7:68f5 with SMTP id 98e67ed59e1d1-3b0db60a8f0mr1780534a91.7.1793962196375;
        Fri, 06 Nov 2026 02:49:56 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0d7c8a3d9sm3747364a91.10.2026.11.06.02.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 02:49:55 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 0/2] smb: client: validate ACL lengths and compare encoded SIDs
Date: Fri,  6 Nov 2026 18:48:34 +0800
Message-ID: <20261106104842.441067-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This series fixes two memory-safety issues in the CIFS/SMB3 client,
reproduced on mainline commit f66469d9905b39d2c260a15d7d6db450f4db67c1:

1. A zero-length security-query response can bypass the caller's minimum
   and return ZERO_SIZE_PTR, causing an Oops during an ownership change.
2. populate_new_aces() compares variable-length SIDs over the maximum
   structure size, causing a KASAN out-of-bounds read during chmod.

The first patch validates the response before dynamic allocation and
uses the descriptor header as the minimum for ACL queries. This also
preserves short DACL/SACL-only xattr responses. The second patch requires
equal subauthority counts and compares only the validated encoded bytes.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

A server reproducer is available to maintainers privately on request;
it is not included in this public series.

Testing:
- x86_64 KASAN/WERROR build (bzImage and modules) and QEMU boot.
- Post-fix reproducer checks: neither original Oops/KASAN report recurred.

A malicious SMB server can trigger these failures by returning crafted
security descriptors during client-side chown/chmod on a cifsacl mount.

Crash reports, from the above mainline commit with KASAN:

1. Zero-length security descriptor during chown:

[   35.944052] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
[   35.945987] KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
[   35.947229] CPU: 1 UID: 0 PID: 269 Comm: chown Not tainted 7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   35.948739] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   35.950560] RIP: 0010:id_mode_to_cifs_acl+0x4a5/0x2c90
[   35.951444] Code: 5f c3 cc cc cc cc 48 ba 00 00 00 00 00 fc ff df 48 8b 1c 24 c7 84 24 00 01 00 00 9c 00 00 00 48 8d 7b 10 48 89 f8 48 c1 e8 03 <0f> b6 0c 10 48 8d 43 13 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 fe
[   35.954900] RSP: 0018:ffff88810a1cf968 EFLAGS: 00010212
[   35.955777] RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffffffff82232148
[   35.956959] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000020
[   35.958118] RBP: 0000000000840204 R08: 0000000000000000 R09: ffffed1021281ec7
[   35.959276] R10: ffff88810940f63f R11: 00000000f36cce94 R12: 0000000000000000
[   35.960451] R13: ffff88810940f63c R14: ffff88810a1cfd90 R15: 0000000000000000
[   35.961618] FS:  00007fb6b8ced580(0000) GS:ffff888193e1c000(0000) knlGS:0000000000000000
[   35.962960] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.963918] CR2: 0000562460238398 CR3: 000000010a9db000 CR4: 00000000000006f0
[   35.965113] Call Trace:
[   35.965530]  <TASK>
[   35.970619]  cifs_setattr+0x4a2/0x2d00
[   35.971859]  notify_change+0x438/0xf30
[   35.973758]  chown_common+0x26b/0x530
[   35.975096]  do_fchownat+0x137/0x170
[   35.976339]  __x64_sys_fchownat+0xbd/0x160
[   35.977490]  do_syscall_64+0xdd/0x4a0
[   35.977954]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   35.978552] RIP: 0033:0x7fb6b8c0487a
[   35.979070] Code: 48 8b 0d 19 16 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 04 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e6 15 0e 00 f7 d8 64 89 01 48
[   35.981256] RSP: 002b:00007fff704367f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000104
[   35.982156] RAX: ffffffffffffffda RBX: 0000000070436b01 RCX: 00007fb6b8c0487a
[   35.983007] RDX: 00000000000003e9 RSI: 0000562460237390 RDI: 00000000ffffff9c
[   35.983925] RBP: 0000562460236ad0 R08: 0000000000000000 R09: 0000562460237390
[   35.984850] R10: 00000000000003e9 R11: 0000000000000202 R12: 0000562460236b48
[   35.985701] R13: 0000562460236920 R14: 00000000ffffff9c R15: 00007fff704369f0
[   35.986534]  </TASK>
[   35.986840] Modules linked in:
[   35.987275] ---[ end trace 0000000000000000 ]---
[   35.987893] RIP: 0010:id_mode_to_cifs_acl+0x4a5/0x2c90
[   35.987898] Code: 5f c3 cc cc cc cc 48 ba 00 00 00 00 00 fc ff df 48 8b 1c 24 c7 84 24 00 01 00 00 9c 00 00 00 48 8d 7b 10 48 89 f8 48 c1 e8 03 <0f> b6 0c 10 48 8d 43 13 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 fe
[   35.987906] RSP: 0018:ffff88810a1cf968 EFLAGS: 00010212
[   35.987908] RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffffffff82232148
[   35.987910] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000020
[   35.987911] RBP: 0000000000840204 R08: 0000000000000000 R09: ffffed1021281ec7
[   35.987912] R10: ffff88810940f63f R11: 00000000f36cce94 R12: 0000000000000000
[   35.987913] R13: ffff88810940f63c R14: ffff88810a1cfd90 R15: 0000000000000000
[   35.987920] FS:  00007fb6b8ced580(0000) GS:ffff888193e1c000(0000) knlGS:0000000000000000
[   35.987931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.987933] CR2: 0000562460238398 CR3: 000000010a9db000 CR4: 00000000000006f0

2. SID comparison over a 44-byte descriptor during chmod:

[   11.393405] ==================================================================
[   11.393412] BUG: KASAN: slab-out-of-bounds in memcmp+0x1bd/0x1d0
[   11.393457] Read of size 8 at addr ffff8881067a9128 by task chmod/252

[   11.393466] CPU: 0 UID: 0 PID: 252 Comm: chmod Not tainted 7.4.0-rc1-gf66469d9905b #1 PREEMPT(lazy) 
[   11.393470] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   11.393474] Call Trace:
[   11.393478]  <TASK>
[   11.393479]  dump_stack_lvl+0x53/0x70
[   11.393489]  print_report+0xd0/0x630
[   11.393516]  kasan_report+0xce/0x100
[   11.393522]  memcmp+0x1bd/0x1d0
[   11.393524]  populate_new_aces+0xfd/0xc30
[   11.393545]  id_mode_to_cifs_acl+0x1990/0x2c90
[   11.393571]  cifs_setattr+0x817/0x2d00
[   11.393580]  notify_change+0x438/0xf30
[   11.393597]  chmod_common+0x1f2/0x4b0
[   11.393604]  do_fchmodat+0xc2/0x130
[   11.393610]  __x64_sys_fchmodat+0x77/0xc0
[   11.393623]  do_syscall_64+0xdd/0x4a0
[   11.393627]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   11.393631] RIP: 0033:0x7f12340a2084
[   11.393636] Code: 26 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f7 c1 ff fe ff ff 75 30 80 e5 01 75 43 b8 0c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 04 c3 0f 1f 00 48 8b 15 d9 2d 0e 00 f7 d8 64
[   11.393640] RSP: 002b:00007ffd114a5168 EFLAGS: 00000246 ORIG_RAX: 000000000000010c
[   11.393647] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f12340a2084
[   11.393649] RDX: 00000000000001a4 RSI: 000055db8d0eaa10 RDI: 00000000ffffff9c
[   11.393650] RBP: 000055db8d0ea980 R08: 0000000000000000 R09: 0000000000004000
[   11.393652] R10: 000055db6d763b9c R11: 0000000000000246 R12: 000055db8d0eaa10
[   11.393653] R13: 000055db8d0ebc40 R14: 000055db8d0eaa10 R15: 00000000000041ed
[   11.393656]  </TASK>

[   11.393657] Allocated by task 252:
[   11.393659]  kasan_save_stack+0x33/0x60
[   11.393665]  kasan_save_track+0x14/0x30
[   11.393667]  __kasan_kmalloc+0x8f/0xa0
[   11.393669]  __kmalloc_noprof+0x198/0x450
[   11.393673]  query_info+0xd38/0x12a0
[   11.393675]  SMB2_query_acl+0x5f/0xb0
[   11.393677]  get_smb2_acl_by_path+0x352/0x610
[   11.393681]  id_mode_to_cifs_acl+0x257/0x2c90
[   11.393684]  cifs_setattr+0x817/0x2d00
[   11.393686]  notify_change+0x438/0xf30
[   11.393688]  chmod_common+0x1f2/0x4b0
[   11.393691]  do_fchmodat+0xc2/0x130
[   11.393693]  __x64_sys_fchmodat+0x77/0xc0
[   11.393696]  do_syscall_64+0xdd/0x4a0
[   11.393698]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

[   11.393702] The buggy address belongs to the object at ffff8881067a9100
                which belongs to the cache kmalloc-64 of size 64
[   11.393704] The buggy address is located 40 bytes inside of
                allocated 44-byte region [ffff8881067a9100, ffff8881067a912c)

[   11.393707] The buggy address belongs to the physical page:
[   11.393710] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1067a9
[   11.393714] flags: 0x200000000000000(node=0|zone=2)
[   11.393718] page_type: f5(slab)
[   11.393722] raw: 0200000000000000 ffff8881000428c0 dead000000000122 0000000000000000
[   11.393725] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
[   11.393726] page dumped because: kasan: bad access detected

[   11.393728] Memory state around the buggy address:
[   11.393729]  ffff8881067a9000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   11.393731]  ffff8881067a9080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   11.393732] >ffff8881067a9100: 00 00 00 00 00 04 fc fc fc fc fc fc fc fc fc fc
[   11.393734]                                   ^
[   11.393735]  ffff8881067a9180: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
[   11.393736]  ffff8881067a9200: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[   11.393737] ==================================================================
[   11.393738] Disabling lock debugging due to kernel taint
[   11.396664] 00000000: 424d53fe 00000040 00000000 00400011  .SMB@.........@.
[   11.396668] 00000010: 00000001 00000000 0000001a 00000000  ................
[   11.396670] 00000020: 00000000 00000000 00001001 00000000  ................

Regards,
liuyong from 360 Vulnerability Research Institute

liuyong (2):
  smb: client: validate descriptor headers before query result
    allocation
  smb: client: compare owner and group SIDs using their encoded lengths

 fs/smb/client/cifsacl.c |  5 ++++-
 fs/smb/client/smb2pdu.c | 10 +++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)


base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
