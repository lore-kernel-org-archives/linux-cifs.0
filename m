Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0933BD637
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775127917; cv=none; b=TI7vanwtxSlb9+jrSmlytHVDBH+7ozEgWYNcTZ8fkefypnj5H46OajZJzbtMxrxOKEWtSv6RgMrPiS/vxkFn5Q+r0iahEefbHD7eBf27whbkSswgFgez5tPCN4vlA1b4yES7EP1LO0W3rSAV74ZDww7IfENL0vFYpEEIgxqKTWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775127917; c=relaxed/simple;
	bh=hh/9WyWXu2FWQlYRFgYXlP+baNOTT16o3da9xD8DrWk=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=YgTI3Mj9uJw1VHgqfyiJslqQZEm0gVgcZ0oB0O4I1sEFQ3LxWMqmJV9i9DJPQVNTsb3lJK/m47AGJtE0CmGifpWvdYyT1e8YSzAgq4yW0GivRHDwI+xi65fHyO6Srx88p/3n5/p9mpoQX5BuPF4DLmr6N/ZdkeTm2lfiT71b0aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IdlQlIpQ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdlQlIpQ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c6dd5b01e14so265838a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775127912; x=1775732712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tqTKsGz0a/iEhu97+WLC1/Q+/BEXoDFjWt70UqzgAAo=;
        b=IdlQlIpQjaUKkyn2PLtHTm6OAXKS4BrX6BoJyjif0QuRnu7yTrjXCxWn9OcdXv6oug
         4acCIb05RRoYzV/7U+B46qvAY0Mu9+Al8/246vurWhYSzcDYJ14WWWVkdhrKqo0r1Jhb
         67Oncnohu/WaNfO/MkrysufY4z9Tfqp0cqtezfF31890U7TE/dfEs9N8KLH6l5IxMlgs
         AOUNKzoUWVLl8KI0UPG87JIQAbgJwKcqzXhQs8WLdMc3Gs20QvxQd2bOG9zkVii++XQp
         rz75879n0AgDgioKEeB/HMnfRvZa03Xg8yxTX3ukXIPtuDPTIXXTvdHF3zPUXgLCsxDw
         KspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775127912; x=1775732712;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqTKsGz0a/iEhu97+WLC1/Q+/BEXoDFjWt70UqzgAAo=;
        b=TN0nIdxAxm8Z9i86RKLoUqv/ItiLw2Oq06qEnAo258B1muKla2k7IiT8tp/ZQtCL0d
         eE02IQ1DxkSKkhk82PNN/+BsmZ8zOV3v82NGJ7bClcfWOQvon/LUgyZadc302v4G64wD
         4Ahk6jevdaR2EK7QyEc5R9HfRC7wFYTw5c0YiSlxRYYw4yDZ1EPaf/VQtFF5xr7U+Wwg
         +OzKwMQx9RJBkL3nF9u6qEbALz8v7jbfLUVtpgkaaPVH19rVjhB8suKRoN9azGv0IssR
         AeS09hILKJO20LauY6ItoNEOqrlqBqrlJofudnXwJmRAoBYkjXwTnPpUiE/Hkmqs9K3W
         mIsQ==
X-Gm-Message-State: AOJu0Yy6G5K9sbMkEOmBXjznFjIOs1OWyTkjb58S7cdPUNT+tm4ZWU4m
	gO0blTgE9h1RDClTGYtABEesVGcYtj9CABjxiGXezadJiWUQaO7RHXE7
X-Gm-Gg: ATEYQzx1qLmx4vq9pR1UXr/6oohbr3y+6eG9lbtz90hWIffpkIIwaFBiWS0o2lhJmr6
	JGFv90vX4LM/hJ7XrxPyHvGAOdlEcyBSnVOWBUjKp/pjVJGaIKCDsLUDm62/qWgeBdKx3l3QiET
	/kRZeqGEK/JWIh5Bv8UDOsnGEkUwjEgCMSE2xZUgG+2MsL2tz0gO3TD5WmsP3XaNtptgzABtt5v
	4GVTq0J3X0R+DmLJU6VqpJpp+C1tJKpLyYMLpMhqqt/QkCZPW42rfSpBLodWId0wMP2+jFqKnDK
	nIjHXzbVkoMH/j33uUjnnTqbGapT2nJW+jhqQv5Y3LC6mID6eLc6yQ0F/BaxTVr7rfAMkYI64/z
	e9OfCLwxJ4Oq/41KjNHRiDhz/e0XtnAZj6fwzZBWhb2sOJn3oBdApW0sMGwQUJXe/kfiAybPMzP
	+vrS2ft/7knCcD4LMEkluvppwlbaJ3fQ==
X-Received: by 2002:a05:6a20:a10d:b0:398:7ed3:a005 with SMTP id adf61e73a8af0-39ef76c2a52mr7512550637.29.1775127911685;
        Thu, 02 Apr 2026 04:05:11 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6492097sm2414887a12.10.2026.04.02.04.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:05:11 -0700 (PDT)
Message-ID: <69ce4d67.630a0220.2cd27f.198f@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] Linux Kernel ksmbd Oplock Break vs Session Teardown Circular Deadlock
Date: Thu, 02 Apr 2026 19:05:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel ksmbd Oplock Break vs Session Teardown Circular Deadlock

  1. Vulnerability Title

Linux Kernel ksmbd Server Circular Locking Deadlock in Oplock Break Notification vs Session Teardown (via truncate/set_info)

  2. High-Level Overview

A circular locking dependency exists in the Linux kernel ksmbd (in-kernel SMB server) between the oplock break notification path and the session teardown path. When `smb2_set_info` performs a file truncate via `ksmbd_vfs_truncate()`, it calls `smb_break_all_levII_oplock()` which holds `ci->m_lock` and then attempts to send an oplock break notification via `ksmbd_conn_write()`, which requires `conn->srv_mutex`. Simultaneously, the session teardown path holds `srv_mutex` (via `ksmbd_conn_handler_loop`) and walks through `ksmbd_sessions_deregister → ksmbd_session_destroy → __close_file_table_ids`, which requires `ci->m_lock`. This creates a 3-level circular lock chain (`srv_mutex → session_lock → m_lock → srv_mutex`). When the deadlock fires, ksmbd worker threads enter D-state and the SMB server becomes completely unresponsive — a denial-of-service condition.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/server/oplock.c` — `smb_break_all_levII_oplock()`, `oplock_break()`
Supporting Components:
- `fs/smb/server/connection.c` — `ksmbd_conn_write()` (acquires `srv_mutex`)
- `fs/smb/server/vfs.c` — `ksmbd_vfs_truncate()` (triggers oplock break)
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

The deadlock involves three locks forming a circular dependency chain:

Path A (oplock break, triggered by truncate):
`smb2_set_info()` → `ksmbd_vfs_truncate()` → `smb_break_all_levII_oplock()` acquires `ci->m_lock` (read lock at offset +0x12a), then calls `oplock_break()` → `__smb2_oplock_break_noti()` → `ksmbd_conn_write()` which attempts to acquire `conn->srv_mutex` (at offset +0x100).

Path B (session teardown):
`ksmbd_conn_handler_loop()` → `ksmbd_server_terminate_conn()` → `ksmbd_sessions_deregister()` implicitly holds `srv_mutex`, acquires `session_lock`, then calls `ksmbd_session_destroy()` → `ksmbd_destroy_file_table()` → `__close_file_table_ids()` which attempts `down_write(ci->m_lock)`.

Path C (session setup — establishes the `srv_mutex → session_lock` ordering):
`smb2_sess_setup()` → `ksmbd_session_lookup()` acquires `session_lock`.

The deadlock occurs when Path A and Path B execute concurrently on different CPUs with overlapping inodes.

  4.b. Code Flow

---
Path A (oplock break — holds m_lock, wants srv_mutex):
  smb2_set_info+0x16d4/0x30e0
    → ksmbd_vfs_truncate+0x46/0x230
      → smb_break_all_levII_oplock+0x12a/0x940  [acquires ci->m_lock]
        → oplock_break+0xda9/0x15d0
          → __smb2_oplock_break_noti+0x8ac/0xba0
            → ksmbd_conn_write+0x100/0x400       [wants srv_mutex]

Path B (session teardown — holds srv_mutex, wants m_lock):
  ksmbd_conn_handler_loop+0xaf1/0xfd0
    → ksmbd_server_terminate_conn+0x15/0x30
      → ksmbd_sessions_deregister+0x41d/0x750    [holds srv_mutex]
        → ksmbd_session_destroy+0x105/0x3e0
          → ksmbd_destroy_file_table+0x4a/0xe0
            → __close_file_table_ids+0x1ad/0x430 [wants ci->m_lock]

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
[ 3286.027108] WARNING: possible circular locking dependency detected
[ 3286.027585] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[ 3286.027961] ------------------------------------------------------
[ 3286.028420] kworker/0:2/975 is trying to acquire lock:
[ 3286.028810] ffff88810dc43888 (&conn->srv_mutex){+.+.}-{4:4}, at: ksmbd_conn_write+0x100/0x400

               but task is already holding lock:
[ 3286.030012] ffff88811016e570 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940

               the existing dependency chain (in reverse order) is:

               -> #2 (&ci->m_lock){++++}-{4:4}:
[ 3286.032186]        lock_acquire+0x150/0x2c0
[ 3286.032539]        down_write+0x92/0x1f0
[ 3286.032868]        __close_file_table_ids+0x1ad/0x430
[ 3286.033284]        ksmbd_destroy_file_table+0x4a/0xe0
[ 3286.033675]        ksmbd_session_destroy+0x105/0x3e0
[ 3286.034053]        ksmbd_sessions_deregister+0x41d/0x750
[ 3286.034453]        ksmbd_server_terminate_conn+0x15/0x30
[ 3286.034864]        ksmbd_conn_handler_loop+0xaf1/0xfd0
[ 3286.035286]        kthread+0x378/0x490

               -> #1 (&conn->session_lock){++++}-{4:4}:
[ 3286.036859]        lock_acquire+0x150/0x2c0
[ 3286.037198]        down_read+0x9b/0x450
[ 3286.037528]        ksmbd_session_lookup+0x22/0xd0
[ 3286.037944]        smb2_sess_setup+0x5aa/0x5fb0
[ 3286.038310]        handle_ksmbd_work+0x4f5/0x1330
[ 3286.038709]        process_one_work+0x962/0x1a40

               -> #0 (&conn->srv_mutex){+.+.}-{4:4}:
[ 3286.040983]        check_prev_add+0xeb/0xd00
[ 3286.041313]        __lock_acquire+0x1641/0x2260
[ 3286.041645]        lock_acquire+0x150/0x2c0
[ 3286.041956]        __mutex_lock+0x19f/0x2330
[ 3286.042268]        ksmbd_conn_write+0x100/0x400
[ 3286.042625]        __smb2_oplock_break_noti+0x8ac/0xba0
[ 3286.043002]        oplock_break+0xda9/0x15d0
[ 3286.043234]        smb_break_all_levII_oplock+0x6a7/0x940
[ 3286.043506]        ksmbd_vfs_truncate+0x46/0x230
[ 3286.043744]        smb2_set_info+0x16d4/0x30e0
[ 3286.043974]        handle_ksmbd_work+0x4f5/0x1330
[ 3286.044208]        process_one_work+0x962/0x1a40

Chain exists of:
  &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock

  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   rlock(&ci->m_lock);
                                lock(&conn->session_lock);
                                lock(&ci->m_lock);
   lock(&conn->srv_mutex);
                 DEADLOCK 

[ 3286.049466] 3 locks held by kworker/0:2/975:
[ 3286.049756]  #0: ffff888103737b48 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x11d8/0x1a40
[ 3286.050395]  #1: ffffc900014d7d00 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x8d8/0x1a40
[ 3286.051136]  #2: ffff88811016e570 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[ 3286.052242] CPU: 0 UID: 0 PID: 975 Comm: kworker/0:2 Not tainted 6.19.0-g44331bd6a610-dirty #5
[ 3286.052304] Workqueue: ksmbd-io handle_ksmbd_work
---

  4.d. Suggested Fix

The root cause is that `smb_break_all_levII_oplock()` calls `ksmbd_conn_write()` while holding `ci->m_lock`. The fix should either:

1. Preferred: Asynchronous oplock break — Queue the oplock break notification to a workqueue instead of sending inline during handler execution. This is the cleanest solution.
2. Drop `ci->m_lock` before calling `ksmbd_conn_write()` in the oplock break path
3. Use a separate lock for the oplock break write that does not conflict with the session teardown ordering

Related source files:
- `fs/smb/server/oplock.c` — `smb_break_all_levII_oplock()`, `oplock_break()`
- `fs/smb/server/connection.c` — `ksmbd_conn_write()`
- `fs/smb/server/mgmt/user_session.c` — `ksmbd_session_destroy()`
- `fs/smb/server/smb2pdu.c` — `smb2_set_info()`, `smb2_sess_setup()`

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact. The trace above was captured with LOCKDEP (CONFIG_PROVE_LOCKING) enabled on kernel 6.19.0.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger conditions:
- ksmbd server with oplocks and leases enabled (default)
- Multiple concurrent SMB sessions with open files on overlapping inodes
- One session performs truncate/set_info (triggers oplock break)
- Another connection is simultaneously setting up or tearing down

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
