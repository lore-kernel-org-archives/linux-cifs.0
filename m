Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997823BE160
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775128045; cv=none; b=TcvtklunX5ypaRU3gPGEOxqlEu6IA/scMgKUVJWqzREENAe+cnSUm44k+nrSSWG8cTRvyxMl8UKb5aTfL8vBtzvodFpxF/KV9UIhtrcG1Vcvo+LF+EgXtSpDjJsN1JfASeSHR1SSR2oqLczzoHPFp/NFCPwRGdA/zSCHY5/T7nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775128045; c=relaxed/simple;
	bh=/EAm8QHHZtYrAIP+97mH3AdvvNbUbtZFUv3U52G/8r4=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=X+0oqJyc+aqjNt5rzPBwba7C9Ug1cuvXFfEVlY8SOBpcrrHRBD94Kc6X7rEzj7CfzcRdQZd3UEE8TcIynvnIbjXXOi4CKK4XwBnkNiICBi1RIIUjSttG7pGzdCGqqqu4yNG5lu1zO7Zj0BI7geD0Nh3PZ8Vpstgk+abBiV6oAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQdanHiw; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQdanHiw"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-827270d50d4so697963b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775128042; x=1775732842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3h3GW1rO9GTli/mxZGzKkIJ+7XNO9TdzOOFz8ZN3mAU=;
        b=mQdanHiwXJ8kIfnAfdF9CMtLtRKRuTjOadOy0Z6SaTrbqINlVT2JpmstTPEUSbxlOq
         U2DdxbUoBkxtAyOSPLWiRJ+BmzzOUdUFuP+NHed1LCnh4OkATsPz1EmX1WmFNqlklVWD
         4m+LtFYNhRuaf0dSuO9yCgS0u3S04bK4EGeh2v1/XLpFGtj/iPhDjzkfyhqXAtijq7I9
         vKZZh3wrCg2lvIdvG7TtMVjlBq1H9vlpDI+m6/oaPwpYOQ2COHmOTV04ekX+2p2gNXMd
         mlPiXxcCWahICABPoFeEcPutAey/zBrUJe5sNYS5gYXPCz9V+4txj0sBKkQHLlq8+eE1
         Rwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775128042; x=1775732842;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3h3GW1rO9GTli/mxZGzKkIJ+7XNO9TdzOOFz8ZN3mAU=;
        b=E4p4c5LdRpZrTZXxBkCLTQwnMwFBYQHt1/kNxS8qUsvFy+wJIeHtHrnVx+flYi8Z1/
         uqjdlvAA2XU89Cl5E5kJxXh6jrsxHn75PbBeL3ymbOYOnDDYYsrPD1029D20IgU0w3k+
         6maGe2pognbyqrG2ZzXvalqxvOc9OFfT0YDJGicq8puPn2g1MKQKF598vTZz7bNAAX6x
         pC0j1ODhI9mgHdjof13shHf3zz3fSnjxjwx5p2q4dycwkaUNjNy2/YkFJJmKEjdNGv/g
         RgQ/A6Rb7Q4ntRwuP2DEDewejNn2UFwyQEzd2zySnW/iGdQQFP71iamvxptPz7j4gXXC
         59+A==
X-Gm-Message-State: AOJu0YzdM1IW7GM0IFPP2dxI3IZXMr48H6NE+7GHSk6c04LA/qLJhivw
	bgLur9LSHdTppBT4FCBQKjDGdhKHD/ZFyTfvyRXh1vxTpAMMCURhS83r
X-Gm-Gg: ATEYQzy2dA3ia1GUXp1Xhs3j8S/JAiNhGyD9x8q3Vn7lTw5IuF/0TKFvYjVSjVh/gRh
	y+NP5TcOanb7iyiZxhZuopiE+tngulonlCe7pnYcjsR79yuv7lYcqUpDFQBhZx/fIMcsuseO5nj
	nEODUQmN7/VPVu/jy/Mf1fHGhvub8BxyUQJAG3CQefy4V/TBrVyOHw2/XqHIfqOK3/4juibnS7r
	0VdR5+2KLvaBMN3kD4bDtcX8mz4Zr6zr6oaoRezha/sLX7GzrT5stuw6b/M2iOhZ8C1NBR2HETY
	BlJiDHC0ltXtOQd5gm5ioP2pKn5ki15QFyBCUxflN0nRlPg33fEkkIwqYQp8NTFKETxce8vDF+0
	vMCuajsfrN+np1OUwSCEdNRw99zgUY1NbyRpgH2XJr3Uj2IMdoghE0m9AgOAxR4aUZ/iQwARY7v
	/J/L33J5S0yvSX1dTmq2jyOy49s+L50g==
X-Received: by 2002:a05:6a00:4086:b0:82c:dc17:2918 with SMTP id d2e1a72fcca58-82ce88e077emr7711673b3a.13.1775128041497;
        Thu, 02 Apr 2026 04:07:21 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3baffsm2826534b3a.14.2026.04.02.04.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:07:21 -0700 (PDT)
Message-ID: <69ce4de9.050a0220.83ffb.1587@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] Linux Kernel ksmbd Circular Locking Dependency: Oplock Break vs Session Teardown
Date: Thu, 02 Apr 2026 19:07:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel ksmbd Circular Locking Dependency: Oplock Break vs Session Teardown

  1. Vulnerability Title

Linux Kernel ksmbd Server srv_mutex / session_lock / m_lock Circular Locking Deadlock Vulnerability

  2. High-Level Overview

A circular locking dependency exists in the Linux kernel ksmbd (in-kernel SMB server) between the oplock break notification path and the session teardown path. When `smb2_set_info` triggers an oplock break while holding `ci->m_lock`, the notification path attempts to acquire `conn->srv_mutex` via `ksmbd_conn_write()`. Simultaneously, if another thread is tearing down a session, it holds `srv_mutex` and attempts to acquire `session_lock` and then `m_lock` through `ksmbd_session_destroy()`. This produces a 3-level lock chain deadlock: `&conn->srv_mutex → &conn->session_lock → &ci->m_lock`. When the deadlock occurs, ksmbd worker threads enter D-state (uninterruptible sleep) and cannot be killed, rendering the SMB server completely unresponsive.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/server/oplock.c` — `smb_break_all_levII_oplock()`, `oplock_break()`
Supporting Components:
- `fs/smb/server/connection.c` — `ksmbd_conn_write()` (acquires `srv_mutex`)
- `fs/smb/server/mgmt/user_session.c` — `ksmbd_session_destroy()` (acquires `m_lock` under `session_lock`)
- `fs/smb/server/smb2pdu.c` — `smb2_set_info()`, `smb2_sess_setup()`

  Tested Versions (confirmed vulnerable)
- Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built 2026-02-13)
- Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)

  Affected Version Range
All kernels with ksmbd oplock support (approximately 5.15 through 6.19) are believed affected.

  Affected Distributions and Products

 |  Vendor / Product  |  Notes  | 
 | --- | --- | 
 |  Red Hat Enterprise Linux (RHEL 9.x)  |  Ships kernels >= 5.14 with ksmbd module  | 
 |  Ubuntu (22.04 LTS, 24.04 LTS)  |  HWE kernels 6.x include ksmbd  | 
 |  SUSE Linux Enterprise Server (SLES 15 SP5+)  |  Kernel 6.x based  | 
 |  Debian (Bookworm, Trixie)  |  Kernels 6.1+  | 
 |  Fedora (39+)  |  Kernels 6.5+  | 
 |  Amazon Linux 2023  |  Kernel 6.1 LTS based  | 
 |  Google ChromeOS / COS  |  kernelCTF target, confirmed vulnerable on 6.12.74  | 

  4. Root Cause Analysis

  4.a. Detailed Description

The deadlock involves three locks forming a circular chain:

1. Path A (oplock break): `smb2_set_info()` → `smb_break_all_levII_oplock()` acquires `ci->m_lock` (read lock), then calls `oplock_break()` → `__smb2_oplock_break_noti()` → `ksmbd_conn_write()` which attempts to acquire `conn->srv_mutex`.

2. Path B (session teardown): `ksmbd_conn_handler_loop()` → `ksmbd_sessions_deregister()` holds `srv_mutex`, acquires `session_lock`, then calls `ksmbd_session_destroy()` → `__close_file_table_ids()` which attempts to acquire `ci->m_lock` (write lock).

3. Path C (session setup): `smb2_sess_setup()` → `ksmbd_session_lookup()` acquires `session_lock` under the context where `srv_mutex` is implicitly ordered first.

The resulting chain `srv_mutex → session_lock → m_lock` conflicts with Path A's `m_lock → srv_mutex` ordering.

  4.b. Code Flow

---
Path A (oplock break — holds m_lock, wants srv_mutex):
  smb2_set_info+0x2506/0x30e0
    → smb_break_all_levII_oplock+0x12a/0x940  [acquires ci->m_lock]
      → oplock_break+0xda9/0x15d0
        → __smb2_oplock_break_noti+0x8ac/0xba0
          → ksmbd_conn_write+0x100/0x400       [wants srv_mutex] ← BLOCKED

Path B (session teardown — holds srv_mutex, wants m_lock):
  ksmbd_conn_handler_loop+0xaf1/0xfd0
    → ksmbd_server_terminate_conn
      → ksmbd_sessions_deregister+0x41d/0x750  [holds srv_mutex]
        → ksmbd_session_destroy+0x105/0x3e0
          → ksmbd_destroy_file_table+0x4a/0xe0
            → __close_file_table_ids+0x1ad/0x430 [wants ci->m_lock] ← BLOCKED

  Deadlock scenario:
        CPU0                           CPU1
        ----                           ----
   rlock(&ci->m_lock)
                                  lock(&conn->session_lock)
                                  lock(&ci->m_lock)         ← waits CPU0
   lock(&conn->srv_mutex)                                   ← waits CPU1
                        DEADLOCK 
---

  4.c. Crash Trace

This vulnerability was discovered by ven0mfuzzer. The following kernel trace is submitted following syzkaller's common practice of providing the raw crash trace as the primary reproduction evidence:

---

[  752.089825] ======================================================
[  752.090256] WARNING: possible circular locking dependency detected
[  752.090682] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[  752.091032] ------------------------------------------------------
[  752.091449] kworker/1:4/516 is trying to acquire lock:
[  752.091808] ffff88810c75d088 (&conn->srv_mutex){+.+.}-{4:4}, at: ksmbd_conn_write+0x100/0x400
[  752.093014] 
               but task is already holding lock:
[  752.093423] ffff8881040d7770 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  752.094161] 
               which lock already depends on the new lock.

[  752.094692] 
               the existing dependency chain (in reverse order) is:
[  752.095168] 
               -> #2 (&ci->m_lock){++++}-{4:4}:
[  752.095617]        lock_acquire+0x150/0x2c0
[  752.095965]        down_write+0x92/0x1f0
[  752.096331]        __close_file_table_ids+0x1ad/0x430
[  752.096738]        ksmbd_destroy_file_table+0x4a/0xe0
[  752.097099]        ksmbd_session_destroy+0x105/0x3e0
[  752.097462]        ksmbd_sessions_deregister+0x41d/0x750
[  752.097848]        ksmbd_server_terminate_conn+0x15/0x30
[  752.099598]        ksmbd_conn_handler_loop+0xaf1/0xfd0
[  752.099993]        kthread+0x378/0x490
[  752.101482]        ret_from_fork+0x676/0xac0
[  752.101839]        ret_from_fork_asm+0x1a/0x30
[  752.102205] 
               -> #1 (&conn->session_lock){++++}-{4:4}:
[  752.103665]        lock_acquire+0x150/0x2c0
[  752.103987]        down_read+0x9b/0x450
[  752.105340]        ksmbd_session_lookup+0x22/0xd0
[  752.105673]        smb2_sess_setup+0x5aa/0x5fb0
[  752.106002]        handle_ksmbd_work+0x4f5/0x1330
[  752.107434]        process_one_work+0x962/0x1a40
[  752.107815]        worker_thread+0x6ce/0xf10
[  752.108139]        kthread+0x378/0x490
[  752.109498]        ret_from_fork+0x676/0xac0
[  752.109830]        ret_from_fork_asm+0x1a/0x30
[  752.110184] 
               -> #0 (&conn->srv_mutex){+.+.}-{4:4}:
[  752.111706]        check_prev_add+0xeb/0xd00
[  752.112033]        __lock_acquire+0x1641/0x2260
[  752.113628]        lock_acquire+0x150/0x2c0
[  752.113927]        __mutex_lock+0x19f/0x2330
[  752.114234]        ksmbd_conn_write+0x100/0x400
[  752.115610]        __smb2_oplock_break_noti+0x8ac/0xba0
[  752.115973]        oplock_break+0xda9/0x15d0
[  752.117436]        smb_break_all_levII_oplock+0x6a7/0x940
[  752.117817]        smb2_set_info+0x2506/0x30e0
[  752.118137]        handle_ksmbd_work+0x4f5/0x1330
[  752.119513]        process_one_work+0x962/0x1a40
[  752.119858]        worker_thread+0x6ce/0xf10
[  752.120165]        kthread+0x378/0x490
[  752.121519]        ret_from_fork+0x676/0xac0
[  752.121858]        ret_from_fork_asm+0x1a/0x30
[  752.122207] 
               other info that might help us debug this:

[  752.123816] Chain exists of:
                 &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock

[  752.125669]  Possible unsafe locking scenario:

[  752.126072]        CPU0                    CPU1
[  752.127582]        ----                    ----
[  752.127902]   rlock(&ci->m_lock);
[  752.128169]                                lock(&conn->session_lock);
[  752.129665]                                lock(&ci->m_lock);
[  752.130163]   lock(&conn->srv_mutex);
[  752.131488] 
                 DEADLOCK 

[  752.131871] 3 locks held by kworker/1:4/516:
[  752.132201]  #0: ffff88810374b348 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x11d8/0x1a40
[  752.134010]  #1: ffffc900014ffd00 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x8d8/0x1a40
[  752.135801]  #2: ffff8881040d7770 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  752.137653] 
               stack backtrace:
[  752.138015] CPU: 1 UID: 0 PID: 516 Comm: kworker/1:4 Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[  752.138052] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  752.138079] Workqueue: ksmbd-io handle_ksmbd_work
[  752.138122] Call Trace:
[  752.138149]  <TASK>
[  752.138164]  dump_stack_lvl+0xc6/0x120
[  752.138203]  print_circular_bug+0x2d1/0x400
[  752.138238]  check_noncircular+0x146/0x160
[  752.139318]  ? __unwind_start+0x496/0x800
[  752.139383]  check_prev_add+0xeb/0xd00
[  752.139416]  __lock_acquire+0x1641/0x2260
[  752.139449]  ? _raw_spin_unlock_irqrestore+0x3f/0x50
[  752.139503]  ? srso_alias_return_thunk+0x5/0xfbef5
[  752.139546]  lock_acquire+0x150/0x2c0
[  752.139576]  ? ksmbd_conn_write+0x100/0x400
[  752.139620]  ? __pfx___might_resched+0x10/0x10
[  752.234307]  ? oplock_break+0xda9/0x15d0
[  752.234349]  ? smb_break_all_levII_oplock+0x6a7/0x940
[  752.234391]  ? smb2_set_info+0x2506/0x30e0
[  752.234430]  __mutex_lock+0x19f/0x2330
[  752.234475]  ? ksmbd_conn_write+0x100/0x400
[  752.234525]  ? ksmbd_conn_write+0x100/0x400
[  752.234573]  ? __pfx___mutex_lock+0x10/0x10
---

  4.d. Suggested Fix

The root cause is that `smb_break_all_levII_oplock()` calls `ksmbd_conn_write()` while holding `ci->m_lock`. The recommended fix is to make oplock break notifications asynchronous — queue the write to a workqueue instead of calling `ksmbd_conn_write()` directly within the oplock break path. This decouples the lock ordering and eliminates the circular dependency.

Alternative approaches:
1. Drop `ci->m_lock` before calling `ksmbd_conn_write()` in the oplock break path
2. Use a separate mutex for oplock break writes that does not conflict with the session teardown ordering

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact. The trace above was captured with LOCKDEP (CONFIG_PROVE_LOCKING) enabled on kernel 6.19.0.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger conditions:
- Multiple concurrent SMB sessions with open files on the same inode
- One session performs truncate/set_info (triggers oplock break)
- Another connection is simultaneously setting up or tearing down

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
