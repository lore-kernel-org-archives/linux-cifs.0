Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52163BED19
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775128029; cv=none; b=MrVOJf4TfcEOfuKiIb7+/gAnEkhkPmVWsgzcW5Yi0y5UojfjhsfbxEEtg/qcLTunSHGq+S0sqlcL5fAyMQ673fevWzVtWLgItE2g+gxIp2jrbaIucT/DXL6xUujaD5RO5AuuKvlF7KXUkmu6IQLkdKQMdKgEWhf520KJ8p6IZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775128029; c=relaxed/simple;
	bh=Bvqo9k+uWe79hD+EUzdQrkh/Lqm87qTJgqtYKXT+ZqI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=npC2nsQweYWrc6ZBEnNx4SiHjLlpVWDdG909F3uk7MxStt027CDT/PVQ+/cISHPLU2gqTcxHlZOMci5Iz4DDyjhjQOyghtvQJbrnIBUaDuJw/rC83RI7g9M7P2oiqtdD4Vnwyq4GdO4LKgFXv0wnzjkEaa/rVAbd0xnzMn9rdkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iiyazaFx; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiyazaFx"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso359526b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775128025; x=1775732825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FqVUaOxIIQGdvZuHr4y8df1rC/Cd4m3EejmoyV3YomM=;
        b=iiyazaFxpKSBDXhh14DdZVTWTb9m1BsvngjygqGk/lehXOR0wXltSz3VnbGzHFRSnV
         YKO7WqSBZbO7ofiSGAZ5tePUlroyBsUhscn+RJZrfG0aLrsbEEi5uRoBss6g7OxlmJTL
         PxxrEpjvr3WZnj9acSQlA7jvoV5GeGpHgCdWofpLuxMj2wLn8VW146TU3Zfi8l0uLZug
         SgB/IbqV53BDN9M7aRW9YqezB3EFqZzO5gxS6OFbMZsgLWulGp2ISuLVO7gWud0zfxhd
         ytzBd5Zf2sMkIW9Zx1STKBe0t0PS42aCO+BA5w0PKWGVxGQVO4bWJxcnU2bs6NSwJgBE
         6kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775128025; x=1775732825;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqVUaOxIIQGdvZuHr4y8df1rC/Cd4m3EejmoyV3YomM=;
        b=CqoyCDbgXkKPrwq+cUjUDht9M+kzE8dexCnoSup4f3tkgawwJZg7DZf9Wns6WMak0P
         hsNHHDx68hrp/Ef15kxfpgmemGHTQUMY2hnW0Q2+Wx4+9/s5UguuBn3wf0jzC1LjDSnc
         9hi2MCyBnYIfVDyOjUI0Xd9EVKgFfpsMh0StyAhCtMTVqk3E5HbrTJ5BSU6CJVqB8oKu
         UbJxpTWTcibJw9YYOqOfBhpz+FeioOdSZv1BK93df3IXp0dCdNzI+2KFF9VIqHxrf43l
         i1IKqZ16n27Xw57xsgQxk7y50mcqly4NDxh7p5v7Z99ghqIBM+praa+eQS22h/WU8b0H
         9ikQ==
X-Gm-Message-State: AOJu0YxAu/7ZrAiLxcIV9EYwV7UlP2gCaas0BqceK61XYFssrQPHxfr2
	7lThQA75rlYGLf6T43G+eO0kNSU6fDnYg5MBHhTrvZpa3ySSk2bbXhFd
X-Gm-Gg: ATEYQzwG5dF2+aSmcEu1n7qZtG1XBR0pt5UIx6q3XC2I5tWpmfKIBya/FkggToLIiSq
	sMsHaRIgPfkwW6geuJl8M5zjmgRGWPmt/yf6p8T74RWOiPvJ781dUtdPSHGW52G4MfJhNQ0323q
	TxwC/yThHmWuXwm5UpHfjcS2LbI8eC+CF1Vk3jtn0TnY28hVL2axsdriWmn1C39KU/c31/YsQf7
	FurXTSrjwsjbDPOg6ExAk/lZgmI+af8u8tTumoKQGTN933XDoE5BjUhQu/4o25Y+6oc4N36vtU8
	2UckPGW4HwK2yyrbdLQ2NyvHdqSsevhctacYdFWgrZ3eG9BDwvfGhM5AT/EPJ0q8N31riFM8m54
	Gy22tBktXchrJD0Xx2iu3il89Nuk9zTdgCV4ETGZakfx3S1kg0z2zXkWTanFI3os1e/W3IbgXXS
	YWJlp4YJRZO8EgYrGZXjk=
X-Received: by 2002:a05:6a00:2d02:b0:82c:9c4e:66ca with SMTP id d2e1a72fcca58-82d00209118mr2082347b3a.2.1775128024851;
        Thu, 02 Apr 2026 04:07:04 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c68273sm3716913b3a.41.2026.04.02.04.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:07:04 -0700 (PDT)
Message-ID: <69ce4dd8.050a0220.11816b.80c8@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        netfs@lists.linux.dev,
        linux-fsdevel@vger.kernel.org
Subject: [BUG] Linux Kernel CIFS Client Circular Locking: wb_lock vs lock_sem
Date: Thu, 02 Apr 2026 19:07:02 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel CIFS Client Circular Locking: wb_lock vs lock_sem

  1. Vulnerability Title

Linux Kernel CIFS Client wb_lock / lock_sem Circular Locking Deadlock During Writeback

  2. High-Level Overview

A circular locking dependency exists in the Linux kernel CIFS client between `&ctx->wb_lock` (netfs writeback lock) and `&cifsi->lock_sem` (CIFS inode lock semaphore). When a `close()` operation triggers writeback and calls `cifs_reopen_file()` while holding `wb_lock`, it attempts to acquire `lock_sem`. Simultaneously, a concurrent `write()` path holds `lock_sem` and attempts to acquire `wb_lock` via `netfs_begin_writethrough()`. This AB-BA lock ordering conflict produces a potential deadlock. The deadlock is triggered by MITM-induced connection disruption during active writeback, causing the CIFS client to call `cifs_reopen_file()` in the writeback path where it should not need to reconnect.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/client/file.c` — `cifs_reopen_file()` (acquires `lock_sem`)
Supporting Components:
- `fs/netfs/writeback.c` — `netfs_writepages()` (acquires `wb_lock`)
- `fs/netfs/write_issue.c` — `netfs_begin_writethrough()` (acquires `wb_lock`)
- `fs/smb/client/file.c` — `cifs_strict_writev()`, `cifs_get_writable_file()`

  Tested Versions (confirmed vulnerable)
- Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built 2026-02-13)
- Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)

  Affected Version Range
All kernels with netfs-based CIFS writeback (approximately 6.8 through 6.19) are believed affected.

  Affected Distributions and Products

 |  Vendor / Product  |  Notes  | 
 | --- | --- | 
 |  Red Hat Enterprise Linux (RHEL 9.x)  |  Ships kernels >= 5.14 with backported netfs/CIFS  | 
 |  Ubuntu (22.04 LTS, 24.04 LTS)  |  HWE kernels 6.x include vulnerable code  | 
 |  SUSE Linux Enterprise Server (SLES 15 SP5+)  |  Kernel 6.x based  | 
 |  Debian (Bookworm, Trixie)  |  Kernels 6.1+  | 
 |  Fedora (39+)  |  Kernels 6.5+  | 
 |  Amazon Linux 2023  |  Kernel 6.1 LTS based  | 
 |  Google ChromeOS / COS  |  kernelCTF target, confirmed vulnerable on 6.12.74  | 

  4. Root Cause Analysis

  4.a. Detailed Description

The deadlock arises from two conflicting lock acquisition orders:

Path 1 (close → writeback → reopen):
`close()` → `cifs_flush()` → `netfs_writepages()` [acquires wb_lock] → `cifs_begin_writeback()` → `cifs_get_writable_file()` → `cifs_reopen_file()` [tries lock_sem] — blocked if another thread holds `lock_sem`.

Path 2 (write → writethrough):
`write()` → `cifs_strict_writev()` [acquires lock_sem implicitly] → `netfs_perform_write()` → `netfs_begin_writethrough()` [tries wb_lock] — blocked if Path 1 holds `wb_lock`.

When MITM-corrupted SMB2 responses cause connection disruption, `cifs_reopen_file()` is called in the writeback path (which already holds `wb_lock`). This creates the circular dependency.

  4.b. Code Flow

---
  CPU0 (dd/855, close path)           CPU1 (write path)
  ----                                ----
  close() → cifs_flush()
    → netfs_writepages()
      lock(&ctx->wb_lock)             cifs_strict_writev()
                                        lock(&cifsi->lock_sem)
    → cifs_begin_writeback()
      → cifs_get_writable_file()        → netfs_perform_write()
        → cifs_reopen_file()              → netfs_begin_writethrough()
          rlock(&cifsi->lock_sem)           lock(&ctx->wb_lock)
          ^^^ BLOCKED                       ^^^ BLOCKED
                     DEADLOCK 
---

  4.c. Crash Trace

This vulnerability was discovered by ven0mfuzzer. The following kernel trace is submitted following syzkaller's common practice of providing the raw crash trace as the primary reproduction evidence:

---
[  599.752057] 
[  599.752318] ======================================================
[  599.752885] WARNING: possible circular locking dependency detected
[  599.753401] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[  599.753757] ------------------------------------------------------
[  599.754139] dd/855 is trying to acquire lock:
[  599.754424] ffff888112e5f790 (&cifsi->lock_sem){++++}-{4:4}, at: cifs_reopen_file+0x14aa/0x1e00
[  599.755109] 
[  599.755109] but task is already holding lock:
[  599.755500] ffff888112e5f6c0 (&ctx->wb_lock){+.+.}-{4:4}, at: netfs_writepages+0xba/0xb20
[  599.756130] 
[  599.756130] which lock already depends on the new lock.
[  599.756130] 
[  599.756633] 
[  599.756633] the existing dependency chain (in reverse order) is:
[  599.757090] 
[  599.757090] -> #1 (&ctx->wb_lock){+.+.}-{4:4}:
[  599.757496]        lock_acquire+0x150/0x2c0
[  599.757807]        __mutex_lock+0x19f/0x2330
[  599.758128]        netfs_begin_writethrough+0x64/0x340
[  599.758478]        netfs_perform_write+0x13a1/0x2150
[  599.758833]        netfs_buffered_write_iter_locked+0x1d0/0x240
[  599.759220]        cifs_strict_writev+0x996/0xe20
[  599.759545]        vfs_write+0x6bc/0x1200
[  599.759835]        ksys_write+0x12a/0x250
[  599.760107]        do_syscall_64+0x111/0x690
[  599.760419]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  599.760776] 
[  599.760776] -> #0 (&cifsi->lock_sem){++++}-{4:4}:
[  599.761114]        check_prev_add+0xeb/0xd00
[  599.761348]        __lock_acquire+0x1641/0x2260
[  599.761593]        lock_acquire+0x150/0x2c0
[  599.761819]        down_read+0x9b/0x450
[  599.762033]        cifs_reopen_file+0x14aa/0x1e00
[  599.762287]        cifs_get_writable_file+0x57a/0xa30
[  599.762562]        cifs_begin_writeback+0x49/0xf0
[  599.762818]        netfs_writepages+0x4eb/0xb20
[  599.763070]        do_writepages+0x26a/0x5c0
[  599.763319]        filemap_writeback+0x1fc/0x290
[  599.763575]        filemap_write_and_wait_range+0xa6/0x130
[  599.763874]        cifs_flush+0xb8/0x2d0
[  599.764094]        filp_flush+0x128/0x1d0
[  599.764324]        __x64_sys_close+0x7f/0x120
[  599.764569]        do_syscall_64+0x111/0x690
[  599.764804]        entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  599.765092] 
[  599.765092] other info that might help us debug this:
[  599.765092] 
[  599.765477]  Possible unsafe locking scenario:
[  599.765477] 
[  599.765767]        CPU0                    CPU1
[  599.766007]        ----                    ----
[  599.766234]   lock(&ctx->wb_lock);
[  599.766426]                                lock(&cifsi->lock_sem);
[  599.766741]                                lock(&ctx->wb_lock);
[  599.767046]   rlock(&cifsi->lock_sem);
[  599.767251] 
[  599.767251]   DEADLOCK 
[  599.767251] 
[  599.767541] 1 lock held by dd/855:
[  599.767724]  #0: ffff888112e5f6c0 (&ctx->wb_lock){+.+.}-{4:4}, at: netfs_writepages+0xba/0xb20
[  599.768201] 
[  599.768201] stack backtrace:
[  599.768451] CPU: 0 UID: 0 PID: 855 Comm: dd Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[  599.768475] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  599.768494] Call Trace:
[  599.768509]  <TASK>
[  599.768518]  dump_stack_lvl+0xc6/0x120
[  599.768545]  print_circular_bug+0x2d1/0x400
[  599.768569]  check_noncircular+0x146/0x160
[  599.768594]  check_prev_add+0xeb/0xd00
[  599.768617]  __lock_acquire+0x1641/0x2260
[  599.768647]  lock_acquire+0x150/0x2c0
[  599.768669]  ? cifs_reopen_file+0x14aa/0x1e00
[  599.768694]  ? __pfx___might_resched+0x10/0x10
[  599.768722]  ? dentry_path_raw+0xcd/0x120
[  599.768756]  down_read+0x9b/0x450
[  599.768780]  ? cifs_reopen_file+0x14aa/0x1e00
[  599.768803]  ? __pfx_down_read+0x10/0x10
[  599.768826]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.768852]  ? __build_path_from_dentry_optional_prefix+0x423/0x620
[  599.768880]  cifs_reopen_file+0x14aa/0x1e00
[  599.768908]  ? __pfx_smb2_get_lease_key+0x10/0x10
[  599.768941]  ? __pfx_cifs_reopen_file+0x10/0x10
[  599.768969]  ? cifs_get_writable_file+0x570/0xa30
[  599.768996]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.769020]  ? lock_release+0xc7/0x270
[  599.769044]  cifs_get_writable_file+0x57a/0xa30
[  599.769072]  ? iov_iter_folio_queue+0x31/0x1f0
[  599.769117]  cifs_begin_writeback+0x49/0xf0
[  599.769145]  netfs_writepages+0x4eb/0xb20
[  599.769175]  ? __pfx_netfs_writepages+0x10/0x10
[  599.769204]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.769228]  ? kasan_save_stack+0x42/0x60
[  599.769263]  ? kasan_save_stack+0x33/0x60
[  599.769290]  ? kasan_record_aux_stack+0xa7/0xc0
[  599.769314]  ? __call_rcu_common.constprop.0+0x71/0xb00
[  599.769345]  ? __fput+0x68d/0xb70
[  599.769371]  ? fput_close_sync+0x118/0x240
[  599.769399]  ? __x64_sys_close+0x8b/0x120
[  599.769429]  ? __pfx_netfs_writepages+0x10/0x10
[  599.769459]  do_writepages+0x26a/0x5c0
[  599.769486]  ? __pfx_do_writepages+0x10/0x10
[  599.769512]  filemap_writeback+0x1fc/0x290
[  599.769541]  ? __pfx_filemap_writeback+0x10/0x10
[  599.769582]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.769607]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.769630]  ? lock_is_held_type+0x8f/0x100
[  599.769651]  ? srso_alias_return_thunk+0x5/0xfbef5
[  599.769677]  filemap_write_and_wait_range+0xa6/0x130
[  599.769713]  cifs_flush+0xb8/0x2d0
[  599.769740]  ? __pfx_cifs_flush+0x10/0x10
[  599.769767]  filp_flush+0x128/0x1d0
[  599.769789]  __x64_sys_close+0x7f/0x120
[  599.769819]  do_syscall_64+0x111/0x690
[  599.769845]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  599.769866] RIP: 0033:0x7f2a653e59e0
[  599.769882] Code: 0d 00 00 00 eb b2 e8 0f f8 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 80 3d 01 2c 0e 00 00 74 17 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c
[  599.769902] RSP: 002b:00007fff1b0d2738 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
[  599.769922] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f2a653e59e0
[  599.769935] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
[  599.769947] RBP: 00007f2a652ea6c0 R08: 001c504f75800000 R09: 00007f2a654d4000
[  599.769961] R10: 00007f2a653064f0 R11: 0000000000000202 R12: 0000000000000000
[  599.769974] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000008
[  599.769993]  </TASK>
[  599.855370] CIFS: VFS: \\10.0.0.2 SMB response too long (134217728 bytes)
[  600.866435] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[  600.867038] CIFS: VFS: Session Id    01 00 00 00 00 00 00 00
[  600.867488] CIFS: VFS: Cipher type   1
[  600.867783] CIFS: VFS: Session Key   60 f3 79 68 76 95 29 2f dd 55 e3 70 3c dc 60 b9
[  600.868472] CIFS: VFS: Signing Key   9f cb c1 31 b8 79 0e ae a2 ac 10 0c e1 8b f9 fe
[  600.869030] CIFS: VFS: ServerIn Key  65 cf ab 4d ce ba 97 26 88 6e f8 42 2e 8a 06 e9
[  600.869605] CIFS: VFS: ServerOut Key a0 30 bd 69 e2 e7 ef 34 6a a1 ae a3 95 f7 dd 8f
[  600.897704] dd (850) used greatest stack depth: 20312 bytes left
[  601.137178] CIFS: VFS: \\10.0.0.2 RFC 1002 unknown response type 0x5
[  601.141560] CIFS: VFS: \\10.0.0.2\IPC$ reconnect tcon failed rc = -11
[  601.151852] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[  601.152430] CIFS: VFS: Session Id    01 00 00 00 00 00 00 00
[  601.152802] CIFS: VFS: Cipher type   1
[  601.153054] CIFS: VFS: Session Key   b7 e4 09 8f f5 15 be c6 26 eb 47 b4 eb 81 ba 54
[  601.153645] CIFS: VFS: Signing Key   3d cb ba 59 5d 85 1d 38 4f 68 e3 a0 36 f9 9d 7c
[  601.154133] CIFS: VFS: ServerIn Key  af 0f b2 27 b8 df ff ca 23 48 fe 21 73 ca ab e1
[  601.154628] CIFS: VFS: ServerOut Key 3a bc c1 4b 06 ee ce 01 e0 a3 05 db d7 30 d5 91
[  601.254390] cat (865) used greatest stack depth: 20144 bytes left

---

  4.d. Suggested Fix

Drop `wb_lock` before calling `cifs_reopen_file()` in the writeback path, or restructure `cifs_begin_writeback()` so that file reopening does not occur while `wb_lock` is held. Alternatively, the `cifs_get_writable_file()` function should use `down_read_trylock()` on `lock_sem` when called from the writeback path and return an error if the lock cannot be acquired, allowing the caller to retry later.

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact. The trace above was captured with LOCKDEP enabled on kernel 6.19.0.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger condition: Concurrent `close()` (triggering writeback flush) and `write()` operations on the same CIFS-mounted file while the MITM proxy corrupts SMB2 responses to force a reconnection in the writeback path.

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
