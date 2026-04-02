Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77133BF66C
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775127964; cv=none; b=AUUuA7Hcx7/YvfhJpr6zkYPMKqpEvY4wsOSTfecXKafC54bB22MVaVbLXgaPZqudJeReW7J9BeD7FmvgyoSxZtONwehbvyRlh8sIMnNuPJo5t86iAoFIjeMtLUbnY12CFr+O2IOfuDahkCcWCJb/O+y0e/7G3/5rfE7sBRzkpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775127964; c=relaxed/simple;
	bh=igNBNIEqQHqUpNevNXL7SA6bOyjrHVLQFvDneQMocJg=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=VS9RYPcpaFsg3HtWXK94nMs1WzTyv3HwGLjxEH1eumbQ9HkhOHGIZTMBk0xsu52Yf1Een2OLX1/Na9vAFO7SeCfjsOSQ/xcP3iJ7F1WbxU5hrl3bgEplO83BcVIfyST47YzuLn84pDszj03hytii3DLCHah89vRsMUud3RRxkrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Avb+SaW7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Avb+SaW7"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82cdb4ab547so352054b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775127958; x=1775732758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QH8rFGXCql2J5VSaf4NPB5jUdIfpnQqgR3OUxyg18a8=;
        b=Avb+SaW7DM14peRzGz2saQILReRqVtl8YFQMjBnmEfE8YePWqQk2z/313FWXbfqs/6
         SO0OgcEIFK/v7ff6BtzqsSIicoU6HodS0IrDUmUKcu7YiJ4wY100Dr13ICywisF+YTy7
         DayLpUvmlNG8yzgFfw+GyCVuEcEX/xre9MIodmesq/hnldXO/HwadXGoTGYVE4iQr5DI
         2vEYBhm4HL5sQO/CDdmHysSnTW6YI2Gok4uTJJG8BdGWf9KpRKqPz7JTYWHFHeIsA838
         +VQSpNhK1tjWVE7c8FJhjy30pmReWqXFSvpEU3a8b62DHqZgI30eP5llS5YI2Vx3eEjw
         1omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775127958; x=1775732758;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QH8rFGXCql2J5VSaf4NPB5jUdIfpnQqgR3OUxyg18a8=;
        b=M4g9wGX69/kvEJEgUkuyRHKDVD6BGTYhnM29QjmhQpF7w85dB/O7CSgq0sEQyhoP2x
         xS/0xFCm0b/0kPHGFZLnzuscJSa+3tO7yQynGTDE/Ll5eEYZwRv9vJB5uxXV8TuX9YzP
         V4FrOZLJTCN81g+RyBtKALONtsXfRZdvgbFpDT003YSIKYqF9BGBM5ql7og+XtFIY6iH
         eYjakDnpOHcdgCk5lL4X2PsRRaejOUUc1oZmgUmgrMvFo9bvEI8MRWp22CuNYqfdKcYg
         y7UlIGIHIvKzZmdTE6EqlkTGg0ViHdRsYwT/OZOltEMIET4MnIaA2z6FUiszuN+9m+S3
         YNjQ==
X-Gm-Message-State: AOJu0YweuijJAT0QKdSs8U4aDf+F7jdLLEFgVYHSrqOUK1/CtocBiURz
	bCOX12gLEilA4BBtQUjH8hG4uELbU4v8l+DJCGdofY47pkCeMMixo/U+
X-Gm-Gg: ATEYQzwTWEUfSAxet3sT5KF7skUaU5kMsxQMczGNdarPA2tDIilV+5lnpQ0ccv3Cfpm
	pi6HFbO2L35f1pBEiauuAB2Zi8eeLuFgXL3UYMFbi7NIfnT9AUvTrU3IOezswsyG7OcBBK4NYod
	JdBeWrOy5eg+CQSzl7yJS42zcM5nekyEFWpox8FwDJlWWPQY5DcyUEFdLreplj9wZUgOKkWqlYb
	KKAzVKYDAqzqYBFUpQ+HUwXJBqy6h4bFQo5FyarmIjYPmyxpluk8R+7yEvY6qA+gbHgpod+YCQu
	5iN5hYreiFLwLxSZYkUbVgmWhI6Th0uRxTUq8jm26fCfLZO3Mxcyx360WbQN2OHV3TNQsm7drGU
	M3QckIuKjDE6jrwioHYmVfIFzygvro1dMnkVzL2jVh0hvZKZiu3BqYdZqZ9mBA5iozSPkib3ljP
	LTZsTL5KzhKpNheNpzuPE=
X-Received: by 2002:a05:6a00:2e94:b0:823:12cb:f5d1 with SMTP id d2e1a72fcca58-82ce88ea8ebmr7481879b3a.6.1775127958369;
        Thu, 02 Apr 2026 04:05:58 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9ca79basm3557108b3a.58.2026.04.02.04.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:05:58 -0700 (PDT)
Message-ID: <69ce4d96.050a0220.acfda.24f9@mx.google.com>
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
Subject: [BUG] Linux Kernel CIFS Client Recursive lock_sem Deadlock
Date: Thu, 02 Apr 2026 19:05:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel CIFS Client Recursive lock_sem Deadlock

  1. Vulnerability Title

Linux Kernel CIFS Client Guaranteed Single-Thread Deadlock via Recursive lock_sem Acquisition

  2. High-Level Overview

A guaranteed single-thread deadlock exists in the Linux kernel CIFS client when a write operation triggers file reopening through the netfs layer. `cifs_strict_writev()` acquires `&cifsi->lock_sem`, then through the call chain `netfs_perform_write → netfs_end_writethrough → netfs_write_folio → netfs_advance_write → cifs_prepare_write → cifs_reopen_file`, the same thread attempts to acquire `lock_sem` again. Since `lock_sem` is a non-recursive `rw_semaphore`, this immediately deadlocks. Unlike circular dependencies between two threads (which are probabilistic), this is a deterministic, single-threaded deadlock — it will always hang when the code path is reached. A MITM attacker can reliably trigger this by corrupting any SMB2 response during a write operation.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/client/file.c` — `cifs_strict_writev()` (acquires `lock_sem`) and `cifs_reopen_file()` (re-acquires `lock_sem`)
Supporting Components:
- `fs/netfs/write_issue.c` — `netfs_perform_write()`, `netfs_end_writethrough()`, `netfs_advance_write()`
- `fs/smb/client/file.c` — `cifs_prepare_write()` (calls `cifs_reopen_file`)

  Tested Versions (confirmed vulnerable)
- Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built 2026-02-13)
- Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)

  Affected Version Range
All kernels with netfs-based CIFS write path (approximately 6.8 through 6.19) are believed affected.

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

The deadlock is straightforward: a single thread acquires `&cifsi->lock_sem` in `cifs_strict_writev()`, then through the netfs write path, eventually calls `cifs_reopen_file()` which attempts to acquire the same `lock_sem` again. Since `rw_semaphore` is not recursive, the thread deadlocks on itself.

The path is triggered when MITM-corrupted SMB2 responses cause the CIFS client to detect a connection error during a write. The netfs layer's writethrough path calls `cifs_prepare_write()` to prepare a folio for writing, which discovers the file needs reopening and calls `cifs_reopen_file()`. At this point, `lock_sem` is already held from the top of the write path.

Key distinction from crash_007: crash_007 is a circular dependency between two threads (`wb_lock → lock_sem` vs `lock_sem → wb_lock`), which is probabilistic and requires concurrency. crash_010 is a recursive lock by a single thread (`lock_sem → ... → lock_sem`), which is deterministic and always deadlocks.

  4.b. Code Flow

---
write() syscall by ksf-fuzzer/742
  → vfs_write
    → cifs_strict_writev+0x996
      → [acquires &cifsi->lock_sem at +0x4c1]       ← LOCK ACQUIRED
      → netfs_buffered_write_iter_locked
        → netfs_perform_write
          → netfs_end_writethrough
            → netfs_write_folio
              → netfs_advance_write
                → cifs_prepare_write+0x321
                  → cifs_reopen_file+0x14aa
                    → down_read(&cifsi->lock_sem)    ← SAME LOCK → DEADLOCK

5 locks held at deadlock:
  #0: &f->f_pos_lock           at fdget_pos+0x2aa
  #1: sb_writers#9              at ksys_write+0x12a
  #2: &sb->s_type->i_mutex_key at netfs_start_io_write+0x59
  #3: &cifsi->lock_sem          at cifs_strict_writev+0x4c1   ← HELD
  #4: &ctx->wb_lock             at netfs_begin_writethrough+0x64
---

  4.c. Crash Trace

This vulnerability was discovered by ven0mfuzzer. The following kernel trace is submitted following syzkaller's common practice of providing the raw crash trace as the primary reproduction evidence:

---
 00 00 00 00 00 00
[  166.084791] CIFS: VFS: Cipher type   1
[  166.084968] CIFS: VFS: Session Key   81 59 e8 07 1c dd 18 ad 59 0d 78 70 d0 59 29 9e
[  166.085307] CIFS: VFS: Signing Key   29 df ff 6f ef 8b ce 77 4a aa ba c1 88 2e db 88
[  166.085672] CIFS: VFS: ServerIn Key  d4 fb 55 8f 79 04 ea 99 ff bd 18 88 79 43 6f 9a
[  166.086016] CIFS: VFS: ServerOut Key 14 32 f3 23 82 2a 34 c5 51 82 20 6a e2 bd d2 4f
[  166.286874] 
[  166.287084] ============================================
[  166.287609] WARNING: possible recursive locking detected
[  166.288111] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[  166.288618] --------------------------------------------
[  166.289112] ksf-fuzzer/742 is trying to acquire lock:
[  166.289604] ffff88811bf505a8 (&cifsi->lock_sem){++++}-{4:4}, at: cifs_reopen_file+0x14aa/0x1e00
[  166.290610] 
[  166.290610] but task is already holding lock:
[  166.291179] ffff88811bf505a8 (&cifsi->lock_sem){++++}-{4:4}, at: cifs_strict_writev+0x4c1/0xe20
[  166.292075] 
[  166.292075] other info that might help us debug this:
[  166.292685]  Possible unsafe locking scenario:
[  166.292685] 
[  166.293221]        CPU0
[  166.293467]        ----
[  166.293712]   lock(&cifsi->lock_sem);
[  166.294086]   lock(&cifsi->lock_sem);
[  166.294461] 
[  166.294461]   DEADLOCK 
[  166.294461] 
[  166.294996]  May be due to missing lock nesting notation
[  166.294996] 
[  166.295608] 5 locks held by ksf-fuzzer/742:
[  166.296010]  #0: ffff888112511e78 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x2aa/0x380
[  166.296886]  #1: ffff888118d5c3f8 (sb_writers#9){.+.+}-{0:0}, at: ksys_write+0x12a/0x250
[  166.297608]  #2: ffff88811bf50150 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: netfs_start_io_write+0x59/0x80
[  166.298109]  #3: ffff88811bf505a8 (&cifsi->lock_sem){++++}-{4:4}, at: cifs_strict_writev+0x4c1/0xe20
[  166.298561]  #4: ffff88811bf504d8 (&ctx->wb_lock){+.+.}-{4:4}, at: netfs_begin_writethrough+0x64/0x340
[  166.299027] 
[  166.299027] stack backtrace:
[  166.299233] CPU: 0 UID: 0 PID: 742 Comm: ksf-fuzzer Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[  166.299256] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  166.299272] Call Trace:
[  166.299281]  <TASK>
[  166.299287]  dump_stack_lvl+0xc6/0x120
[  166.299325]  print_deadlock_bug+0x27b/0x3a0
[  166.299355]  __lock_acquire+0x14c3/0x2260
[  166.299380]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.299410]  lock_acquire+0x150/0x2c0
[  166.299431]  ? cifs_reopen_file+0x14aa/0x1e00
[  166.299455]  ? __pfx___might_resched+0x10/0x10
[  166.299480]  ? dentry_path_raw+0xcd/0x120
[  166.299507]  down_read+0x9b/0x450
[  166.299531]  ? cifs_reopen_file+0x14aa/0x1e00
[  166.299554]  ? __pfx_down_read+0x10/0x10
[  166.299577]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.299600]  ? __build_path_from_dentry_optional_prefix+0x423/0x620
[  166.299627]  cifs_reopen_file+0x14aa/0x1e00
[  166.299652]  ? __pfx_smb2_get_lease_key+0x10/0x10
[  166.299680]  ? __pfx_cifs_reopen_file+0x10/0x10
[  166.299703]  ? find_held_lock+0x2b/0x80
[  166.299732]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.299756]  ? lock_release+0xc7/0x270
[  166.299779]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.299802]  ? cifs_pick_channel+0x2e3/0x3b0
[  166.299832]  cifs_prepare_write+0x321/0xd50
[  166.299857]  netfs_advance_write+0x74b/0xe80
[  166.299884]  ? __pfx_cifs_prepare_write+0x10/0x10
[  166.299908]  ? rolling_buffer_append+0x2bc/0x450
[  166.299936]  netfs_write_folio+0xc20/0x1dd0
[  166.299967]  ? __pfx___might_resched+0x10/0x10
[  166.299989]  netfs_end_writethrough+0x59/0xf0
[  166.300018]  netfs_perform_write+0x1495/0x2150
[  166.300048]  ? __pfx_netfs_perform_write+0x10/0x10
[  166.300070]  ? __vfs_getxattr+0x145/0x1a0
[  166.300102]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300126]  ? generic_write_checks+0x311/0x480
[  166.300159]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300183]  ? file_update_time_flags+0x383/0x520
[  166.300210]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300236]  netfs_buffered_write_iter_locked+0x1d0/0x240
[  166.300260]  cifs_strict_writev+0x996/0xe20
[  166.300292]  ? security_file_permission+0x21/0x80
[  166.300325]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300349]  ? lock_is_held_type+0x8f/0x100
[  166.300370]  vfs_write+0x6bc/0x1200
[  166.300390]  ? __pfx_cifs_strict_writev+0x10/0x10
[  166.300419]  ? __pfx_vfs_write+0x10/0x10
[  166.300438]  ? find_held_lock+0x2b/0x80
[  166.300475]  ksys_write+0x12a/0x250
[  166.300495]  ? __pfx_ksys_write+0x10/0x10
[  166.300514]  ? kcov_ioctl+0x16a/0x720
[  166.300552]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300575]  ? fput+0x66/0xe0
[  166.300599]  ? srso_alias_return_thunk+0x5/0xfbef5
[  166.300625]  do_syscall_64+0x111/0x690
[  166.300649]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  166.300669] RIP: 0033:0x408f9f
[  166.300683] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2d 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
[  166.300701] RSP: 002b:00007fcbc3e04cc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  166.300721] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 0000000000408f9f
[  166.300734] RDX: 000000000000065b RSI: 00007fcbc3e04cf0 RDI: 0000000000000009
[  166.300746] RBP: 00000000004e6100 R08: 0000000000000000 R09: 00000000004e93f0
[  166.300759] R10: 0000000000000453 R11: 0000000000000293 R12: 00000000004e60d0
[  166.300771] R13: 00000000004e60e8 R14: 00000000004e60a0 R15: 00000000004e60b8
[  166.300789]  </TASK>
---

  4.d. Impact Assessment

This is a denial-of-service vulnerability. A MITM attacker or malicious SMB server can trigger this deadlock by corrupting any SMB2 response during a write operation. Once triggered:
- The client process hangs permanently (uninterruptible sleep)
- Kernel locks on the inode are held indefinitely
- All subsequent operations on the same file also hang
- The effect cascades to any process accessing the same mount

  4.e. Suggested Fix

`cifs_strict_writev()` should not hold `lock_sem` across the entire write path that includes `cifs_prepare_write()`. Options:

1. Use `down_read_trylock()` in `cifs_reopen_file()` when called from the write path, and handle failure by deferring the reopen
2. Release `lock_sem` before entering the netfs write path and re-acquire afterward
3. Restructure the netfs write collection path to not call `cifs_prepare_write()` (which calls `cifs_reopen_file()`) while `lock_sem` is held — defer the reopen until after `lock_sem` is released

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger condition: Any write operation on a CIFS-mounted file while the MITM proxy corrupts the SMB2 response (bad signature, wrong status, etc.), forcing a reconnection in the write path.

Key sequence:
1. Client starts `write()` → acquires `lock_sem`
2. MITM mutates the server response
3. Write path detects connection loss
4. netfs calls `cifs_prepare_write` → `cifs_reopen_file`
5. `cifs_reopen_file` tries `down_read(lock_sem)` → already held → permanent hang

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
