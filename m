Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9254CC293;
	Thu, 15 Oct 2026 19:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092713; cv=none; b=jn8zjX1TCwnBRjgSWTDsJaZMzOKeDgaejQ6hSB/nPO24FXFhOhC9OozMIL7Qmmb48h1SNqP6Wg77j25XPZIU+Lt1/OqSL8IlNV5gZ92Wh0VSI1XRploVM8UyVm3KMCPrGX0plk/nLuV4IDIQ82+ZMFlHise1F59HOxjPAHj44Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092713; c=relaxed/simple;
	bh=WNMoi9mDFgdoJSmRCHgesEN8GvYYbKrfHmR6RcQgl9o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RKMaZT5VhoLMGIFMXdhBsSuhBquXV578hXQGFeMeQ4ORNGtlVV4OuvsqqvSX2fkV+NCXrFqOiGYHkEC5zNqs1YYPGdWcGCHWbRQQrI26yCiEqy0VQW0CHwM3SQxSaYHWJ2xf3S8DOofZebzBp7wrhzS8bYpT1YMMyyuaesKmruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=0jhCZy+O; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=sjqI52a7; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="0jhCZy+O";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="sjqI52a7"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1792092150; h=date : from : to : cc : subject : message-id :
 mime-version : content-type : from;
 bh=J7KLABIsCCqHYLpgTjwfxqpIaMfPVRz5i8J+X9Sp+Og=;
 b=0jhCZy+OsjmKKGSz1xj+wSkuBPQBqQXmx6KhmuOuh8/U0CfUYEiIJrBSzu43qePia/xl4
 SL/XkjP/Nqm5sZhAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1792092150; h=date :
 from : to : cc : subject : message-id : mime-version : content-type :
 from; bh=J7KLABIsCCqHYLpgTjwfxqpIaMfPVRz5i8J+X9Sp+Og=;
 b=sjqI52a7dXJBQKCprNEDu2gRhxppYokiwDegBK3nyt9tE21lzr6NZjeWEQ1j/luVNtPx8
 /CqK0ZkV7ocnsUmA04zCD3mXHT2S+enuIKXAdvzI+jYUaeRRbuxHnIhpGFMrRtK62piVaLy
 6Nw1XgHcbf+T8tNzLkf7Dwu+hoTGXspqgeLMgyxtq8G77x34RiZez9EQXpq8r6lzFLoS/7t
 gyYwknH5ADtwvP9L22Y1NDLlk505KraUaBoFW03c0I7yGtEEy/G+OYgzesJJMk+GELf0nk6
 uVrbUnfkBTRZJyVUeUZ34//zsLU74pv9Lg/4klqCqXChEsS1T9z6FT6YhfjQ==
Received: by o-chul.darkrain42.org (Postfix) id BDB9183F6;
	Thu, 15 Oct 2026 12:22:30 -0700 (PDT)
Received: by redcloak.home.arpa (Postfix, from userid 1000)
	id C9C764804FB; Thu, 15 Oct 2026 12:22:29 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:22:29 -0700
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org, stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Subject: [REGRESSION] smb: client: batch SRV_COPYCHUNK entries to cut round
 trips - 6.12.y EIO above 12 MiB with SMB3 encryption
Message-ID: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
Mail-Followup-To: linux-cifs@vger.kernel.org, stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi,

In stable 6.12.y releases, a copy_file_range request exceeding 12 MiB on an
encrypted SMB3 mount fails with EIO and a WARN_ON_ONCE() splat in
SMB2_ioctl_init:

     # cp /mnt/otters/13mib.bin /mnt/otters/output.bin
     cp: error copying '/mnt/otters/13mib.bin' to '/mnt/otters/output.bin':
     Input/output error

Works in 6.12.110.  Fails in 6.12.111 through 6.12.113 (latest).  Via
bisection, introduced by 8d103b285359 ("smb: client: batch SRV_COPYCHUNK
entries to cut round trips").

#regzbot introduced: 8d103b285359

The same reproducer succeeds on 6.18, the first release to have the upstream
SRV_COPYCHUNK batching commit.  That was introduced after these
encryption-path changes:

- bc925c1216f0 ("smb: client: improve compound padding in encryption")
- 9f544d26b15b ("smb: client: get rid of bounds check in SMB2_ioctl_init()")

There was also a subsequent follow-up correction:

- 90f7c100d2dd ("smb: client: fix compound alignment with encryption"), marked
   as "Fixes: bc925c1216f0".

To reproduce:

     mount -o seal,username=... -t smb3 '\\127.0.0.1\data' /mnt
     mkdir /mnt/otters && dd if=/dev/zero bs=1024k count=13 of=/mnt/otters/13mib.bin
     python3 -c 'import os; src=os.open("/mnt/otters/13mib.bin", os.O_RDONLY); dst=os.open("/mnt/otters/output.bin", os.O_WRONLY | os.O_TRUNC | os.O_CREAT); print(os.copy_file_range(src, dst, 12*1024*1024+1))'

At 12 MiB, it works.  At 12 MiB + 1 (or any longer length), it fails with
OSError: [Errno 5] Input/output error


root@ubuntu-server-vm:~# cat /proc/version
Linux version 6.12.113 (user@host) (gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44) #10 SMP PREEMPT_DYNAMIC Thu Oct 15 08:14:40 PDT 2026

[  646.792249] ------------[ cut here ]------------
[  646.792272] WARNING: CPU: 1 PID: 745 at fs/smb/client/smb2pdu.c:3362 SMB2_ioctl_init+0x949/0xcf0
[  646.792290] Modules linked in:
[  646.792306] CPU: 1 UID: 0 PID: 745 Comm: cp Not tainted 6.12.113 #10
[  646.792318] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[  646.792327] RIP: 0010:SMB2_ioctl_init+0x949/0xcf0
[  646.792338] Code: 00 48 b8 00 00 00 00 00 fc ff df 8b 6c 24 58 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 36 01 00 00 49 89 6d 08 e9 d5 fb ff ff 90 <0f> 0b 90 48 89 cf e8 3c 65 f8 ff 41 b8 fb ff ff ff e9 f0 f7 ff ff
[  646.792348] RSP: 0018:ffa00000019f76b8 EFLAGS: 00010202
[  646.792363] RAX: 00000000000001d0 RBX: 1ff400000033eedc RCX: ff1100010d0465c0
[  646.792372] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000158
[  646.792380] RBP: ffa00000019f78b0 R08: 0000000000000000 R09: ffe21c002042e8bd
[  646.792389] R10: ff110001021745ef R11: 0000000000000001 R12: 00000000001480f2
[  646.792397] R13: ffa00000019f7910 R14: 0000000071eb8c42 R15: ff11000102174000
[  646.792408] FS:  00007fbe61b48840(0000) GS:ff11000181680000(0000) knlGS:0000000000000000
[  646.792420] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  646.792429] CR2: 000055b3cd8a1fb0 CR3: 0000000112f1a001 CR4: 0000000000771ef0
[  646.792437] PKRU: 55555554
[  646.792445] Call Trace:
[  646.792453]  <TASK>
[  646.792468]  ? __pfx_SMB2_ioctl_init+0x10/0x10
[  646.792484]  ? do_raw_spin_unlock+0x53/0x210
[  646.792496]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792508]  ? _raw_spin_unlock+0x1e/0x40
[  646.792519]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792534]  SMB2_ioctl+0x2f9/0xa70
[  646.792562]  ? __pfx_SMB2_ioctl+0x10/0x10
[  646.792590]  ? mark_held_locks+0x94/0xe0
[  646.792608]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792618]  ? kasan_quarantine_put+0xc7/0x1d0
[  646.792638]  ? __smb2_copychunk_range+0xae8/0x1890
[  646.792649]  __smb2_copychunk_range+0xae8/0x1890
[  646.792684]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792695]  ? ktime_get_coarse_real_ts64+0x110/0x140
[  646.792705]  ? inode_needs_update_time+0x7e/0x2c0
[  646.792722]  ? __pfx___smb2_copychunk_range+0x10/0x10
[  646.792733]  ? inode_needs_update_time+0x90/0x2c0
[  646.792745]  ? __pfx_inode_needs_update_time+0x10/0x10
[  646.792759]  ? down_write_nested+0x11c/0x1f0
[  646.792772]  ? __pfx_down_write_nested+0x10/0x10
[  646.792783]  ? lock_release+0x203/0x6e0
[  646.792802]  smb2_copychunk_range+0xd/0x20
[  646.792813]  cifs_file_copychunk_range+0x476/0x830
[  646.792837]  cifs_copy_file_range+0x10f/0x220
[  646.792856]  ? __pfx_cifs_copy_file_range+0x10/0x10
[  646.792869]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792881]  ? __pfx___might_resched+0x10/0x10
[  646.792892]  ? srso_alias_return_thunk+0x5/0xfbef5
[  646.792902]  ? lock_is_held_type+0x85/0xf0
[  646.792916]  ? __pfx_cifs_copy_file_range+0x10/0x10
[  646.792928]  vfs_copy_file_range+0x477/0x1540
[  646.792947]  ? __pfx_vfs_copy_file_range+0x10/0x10
[  646.792976]  __do_sys_copy_file_range+0x13e/0x340
[  646.792990]  ? __pfx___do_sys_copy_file_range+0x10/0x10
[  646.793004]  ? ksys_fadvise64_64+0xbe/0xf0
[  646.793025]  do_syscall_64+0xbb/0x1f0
[  646.793040]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  646.793050] RIP: 0033:0x7fbe61c993e6
[  646.793060] Code: 47 ba 04 00 00 00 48 8b 05 1f 1a 17 00 64 89 10 48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45 10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e 0f 1f 84 00
[  646.793069] RSP: 002b:00007ffd5290a7b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000146
[  646.793084] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbe61c993e6
[  646.793093] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
[  646.793101] RBP: 00007ffd5290a7c0 R08: 7fffffffc0000000 R09: 0000000000000000
[  646.793109] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000006442202
[  646.793118] R13: 00007ffd5290b65e R14: 00007ffd5290a9b8 R15: ffffffffffffffff
[  646.793144]  </TASK>
[  646.793152] irq event stamp: 33537
[  646.793160] hardirqs last  enabled at (33543): [<ffffffff8b2cac4d>] __up_console_sem+0x4d/0x60
[  646.793294] hardirqs last disabled at (33578): [<ffffffff8b2cac32>] __up_console_sem+0x32/0x60
[  646.793306] softirqs last  enabled at (33574): [<ffffffff8b16ea4c>] irq_exit_rcu+0x8c/0xc0
[  646.793318] softirqs last disabled at (33547): [<ffffffff8b16ea4c>] irq_exit_rcu+0x8c/0xc0
[  646.793329] ---[ end trace 0000000000000000 ]---

First observed on Debian 13 (stable / trixie) with
linux-image-6.12.111+deb13-amd64.

All the testing results are from vanilla kernels, reproduced with a minimal
.config that matched across tests ('make olddefconfig' after changing the
checkout).  I don't think the .config is relevant, but I can provide the whole
thing if needed.

% grep -e SMBFS -e CIFS .config
CONFIG_CIFS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DEBUG_DUMP_KEYS=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_ROOT is not set
# CONFIG_CIFS_COMPRESSION is not set
CONFIG_SMBFS=y
%

-- 
~Paul

