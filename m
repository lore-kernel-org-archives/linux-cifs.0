Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC5F3BE637
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775128018; cv=none; b=N6ddtMg3wTm5ayRxy8NWlSnAOszyvFnIiZAy1dBbmgRM2H8G1MODuq6r2Oqbkm6qBzl9AXA0kjnylV4cbuK8aRmZX/ySYKuXF2y5UyXP6vNUY7h2LdwyFaqO9BOn7Oe7L2bXAtNRM5R+Rhex0jH/Wv+C40QOOOu3DLiFjwlKtmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775128018; c=relaxed/simple;
	bh=gvc+ylVEiBZLeUBzLsKpxBQFxkn+XFGKUGaW4uUFjmg=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=ONaVl4csa3e57at20CtwdagpHcyE0hPJFXfjTc6DH+PCVpOwl9Mal/qZ6u/r8dTi6qP5rbetzo8gWFjQrmUuxoNgA130RY33pImYxKQ7yLOgCPTx2J0pSfprxOT9BJ50ZISgX+5K4NnnkRy2oH0k1m5vcLP4msHdmKyFQnf9VAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cSEFpbgG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cSEFpbgG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82418b0178cso363707b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775128012; x=1775732812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yBvzEO/eu6cmBuDOTFyAOHFu+vBa0cU2540l+m5WNPg=;
        b=cSEFpbgGttbPIsi7jjZp/WeTQVfIqdzKjIccDnPkGYVGv0iyRDEJCuncSUXpM4+qhD
         QBgUsFyVx7881dgJEEYjQQC82T35cdLQey41zrZpOs9je6Etxyina/sRVuyrfFRI//P4
         ZFpPmz/bT0R8PTVrWbUD3WJumeUDrd/6D9Z6SKwl7KSUJUDD2wE1EFtlMg8L6/aLWC4t
         Bq6O9gAcZZ59PjPYY/PHk1KBF0cu4KqiNG5+XX77T+YaV8z2i/54ujTdCArH9kuWNpb2
         RtJPCRxfz8CAnOM++BpHdNKSHthCk6N/U1iPqftBaC6szYHqFumxeXp++wXeKrj/cFPm
         XW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775128012; x=1775732812;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBvzEO/eu6cmBuDOTFyAOHFu+vBa0cU2540l+m5WNPg=;
        b=DDBPi6o4WGX6zEVQ9bKfYu9FLskJfWmRAT+abcmUi0bbap5fkwuB3nnR3BW+JEce9e
         smbISd42U0OMgy5wuE3B3rKFmq9MSg+KtB0TnXifGY79NhB91ik6i6WVpxu07toGROsn
         XUIl/NMO/iFE/VAo2nzZCub4040c2hhOl9ZvR44AI14LppvF4p82IShFoxaVANeBlb9n
         8meOl30gvhzIidp7GENqRfyKUZ9AvT8B3RBTJTtk1epiOxBLhyWHWH+V1pQhYD2fh6MP
         ski+1Wz4o2CKTMNDQzzu3YRJQox+m0mv5u1iHJUSdUeL7spOT3Mvwtbj8uM32Lr8Zg3a
         vHMQ==
X-Gm-Message-State: AOJu0YwB+KZd8GzGCIUqgxPXFm5eLbX4lXHxOFaMWJE2lPk8182rCYYM
	RFma/JzilEjJOyneYc0hTo8yzD3H3NfH5fYrXjdZSeyT4YGvKqAMBMdR
X-Gm-Gg: ATEYQzw6qZagKZAo+wQHmvqtl8UgUEzNb26lBfGemJo7mBAwkdfHoBp4w9pAffa2xxU
	JKnV9uiZlQGWPuxXoKXnaKG2JDnNybHvCs5mOAtw/Hx7SsCBfXll2GZIZ9OiiY+H6+kFG4DPeFs
	kt+epv9eyIRdD7BE6cpPIeGTFBLauOYoXxSw0C87X+HS2rxgmZBJC7jaBDfXqxo4w9xka8lflA/
	25Ff5bYBs+yl7TKABm64CbhkvO+b2jPAYKAhTY8XAqLPkNGj343H5NmQs8C3U+DkZqMxCU1uv1g
	9M73nH5XssbMvjoD1NBulFTkNcZFXhKHSU1VzdZ/mh2ZtTO++yZmfbo5VC3hFVi9hcKvj1lSRN5
	saODFMTe2kjk6afVrsLRz6Mw57s7Cbo+t0QiZBdf1UzNm2+LWCm6LxN86clOevLRpaNOcaDN/mA
	SECLxWjQqds19fQXbpPMo=
X-Received: by 2002:a05:6a00:2e94:b0:827:37ef:7322 with SMTP id d2e1a72fcca58-82ce88ea7e7mr7178665b3a.2.1775128011889;
        Thu, 02 Apr 2026 04:06:51 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6c2b4sm2744512b3a.46.2026.04.02.04.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:06:51 -0700 (PDT)
Message-ID: <69ce4dcb.050a0220.2c5230.ef9c@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] Linux Kernel ksmbd srv_mutex Circular Deadlock — Additional Trigger Paths
Date: Thu, 02 Apr 2026 19:06:49 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel ksmbd srv_mutex Circular Deadlock — Additional Trigger Paths

  1. Vulnerability Title

Linux Kernel ksmbd Server srv_mutex / session_lock / m_lock Circular Deadlock — Systemic Oplock Break Issue (3 New Trigger Paths)

  2. High-Level Overview

The same circular locking dependency reported in crash_002 (`srv_mutex → session_lock → m_lock`) has been independently triggered through three additional ksmbd handler paths beyond the original `smb2_set_info` trigger. This confirms the deadlock is not handler-specific but a systemic issue in ksmbd's oplock break notification mechanism. Any ksmbd SMB2 handler that calls `smb_break_all_oplock()` or `smb_break_all_levII_oplock()` while the inode's `m_lock` is held can trigger the deadlock. The newly discovered trigger paths are `smb2_write` (via `ksmbd_vfs_write`), `smb2_lock`, and `smb2_open`, substantially widening the attack surface for this denial-of-service vulnerability.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/server/oplock.c` — `smb_break_all_levII_oplock()`, `smb_break_all_oplock()`, `oplock_break()`
Supporting Components:
- `fs/smb/server/smb2pdu.c` — `smb2_write()`, `smb2_lock()`, `smb2_open()`, `smb2_set_info()`
- `fs/smb/server/vfs.c` — `ksmbd_vfs_write()` (calls oplock break)
- `fs/smb/server/connection.c` — `ksmbd_conn_write()` (acquires `srv_mutex`)
- `fs/smb/server/mgmt/user_session.c` — `ksmbd_session_destroy()`, `destroy_previous_session()`

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

The fundamental lock ordering violation is identical to crash_002: oplock break notification (`ksmbd_conn_write()`) acquires `srv_mutex` while `m_lock` is held, conflicting with the session teardown path that acquires locks in the opposite order (`srv_mutex → session_lock → m_lock`).

What crash_009 reveals is that this is not limited to `smb2_set_info`. Every ksmbd handler that breaks oplocks is affected:

1. smb2_write (NEW): `smb2_write → ksmbd_vfs_write → smb_break_all_levII_oplock → oplock_break → ksmbd_conn_write`
2. smb2_lock (NEW): `smb2_lock → smb_break_all_oplock → smb_break_all_levII_oplock → oplock_break → ksmbd_conn_write`
3. smb2_open (NEW): `smb2_open → smb_break_all_oplock → smb_break_all_levII_oplock → oplock_break → ksmbd_conn_write`
4. smb2_set_info (original, crash_002): `smb2_set_info → smb_break_all_levII_oplock → oplock_break → ksmbd_conn_write`

Additionally, the `#2` link in the chain (`session_lock → m_lock`) can be established through either connection termination (`ksmbd_server_terminate_conn → ksmbd_sessions_deregister`) or session re-establishment (`destroy_previous_session → ksmbd_session_destroy`), widening the attack surface further.

  4.b. Code Flow

---
Lock chain (unchanged from crash_002):
  &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock

ALL affected handler paths (common suffix):
  → smb_break_all_oplock() or smb_break_all_levII_oplock()
    → [holds ci->m_lock]
      → oplock_break()
        → __smb2_oplock_break_noti()
          → ksmbd_conn_write()    [wants srv_mutex] ← DEADLOCK

Trigger 1 (smb2_write):
  smb2_write → ksmbd_vfs_write → smb_break_all_levII_oplock

Trigger 2 (smb2_lock):
  smb2_lock → smb_break_all_oplock → smb_break_all_levII_oplock

Trigger 3 (smb2_open):
  smb2_open → smb_break_all_oplock → smb_break_all_levII_oplock

Trigger 4 (smb2_set_info, original crash_002):
  smb2_set_info → smb_break_all_levII_oplock

Session teardown path (counterpart):
  Variant A: ksmbd_conn_handler_loop → ksmbd_sessions_deregister
             → ksmbd_session_destroy → __close_file_table_ids [wants m_lock]
  Variant B: destroy_previous_session → ksmbd_session_destroy
             → __close_file_table_ids [wants m_lock]
---

  4.c. Crash Trace

This vulnerability was discovered by ven0mfuzzer. The lock chain is identical to crash_002 but triggered through different handlers. Representative LOCKDEP outputs from three independent trigger paths:

Trigger Path 1: smb2_open (crash-0-1773307879)
---
[  485.999550] ksmbd: session id(32769) is different with the first operation(1)
[  486.010267] ksmbd: cli req too short, len 192 not 105. cmd:16 mid:42
[  488.425383] 
[  488.425605] ======================================================
[  488.426005] WARNING: possible circular locking dependency detected
[  488.426402] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[  488.426721] ------------------------------------------------------
[  488.427097] kworker/1:1/483 is trying to acquire lock:
[  488.427417] ffff88810dcce888 (&conn->srv_mutex){+.+.}-{4:4}, at: ksmbd_conn_write+0x100/0x400
[  488.428080] 
[  488.428080] but task is already holding lock:
[  488.428436] ffff88810a11fd70 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  488.429035] 
[  488.429035] which lock already depends on the new lock.
[  488.429035] 
[  488.429521] 
[  488.429521] the existing dependency chain (in reverse order) is:
[  488.429996] 
[  488.429996] -> #2 (&ci->m_lock){++++}-{4:4}:
[  488.430386]        lock_acquire+0x150/0x2c0
[  488.430685]        down_write+0x92/0x1f0
[  488.430978]        __close_file_table_ids+0x1ad/0x430
[  488.431323]        ksmbd_destroy_file_table+0x4a/0xe0
[  488.431743]        ksmbd_session_destroy+0x105/0x3e0
[  488.432071]        ksmbd_sessions_deregister+0x41d/0x750
[  488.432349]        ksmbd_server_terminate_conn+0x15/0x30
[  488.432622]        ksmbd_conn_handler_loop+0xaf1/0xfd0
[  488.432900]        kthread+0x378/0x490
[  488.433123]        ret_from_fork+0x676/0xac0
[  488.433369]        ret_from_fork_asm+0x1a/0x30
[  488.433628] 
[  488.433628] -> #1 (&conn->session_lock){++++}-{4:4}:
[  488.433971]        lock_acquire+0x150/0x2c0
[  488.434195]        down_read+0x9b/0x450
[  488.434406]        ksmbd_session_lookup+0x22/0xd0
[  488.434654]        smb2_sess_setup+0x5aa/0x5fb0
[  488.434900]        handle_ksmbd_work+0x4f5/0x1330
[  488.435147]        process_one_work+0x962/0x1a40
[  488.435411]        worker_thread+0x6ce/0xf10
[  488.435656]        kthread+0x378/0x490
[  488.435871]        ret_from_fork+0x676/0xac0
[  488.436104]        ret_from_fork_asm+0x1a/0x30
[  488.436350] 
[  488.436350] -> #0 (&conn->srv_mutex){+.+.}-{4:4}:
[  488.436683]        check_prev_add+0xeb/0xd00
[  488.436913]        __lock_acquire+0x1641/0x2260
[  488.437154]        lock_acquire+0x150/0x2c0
[  488.437378]        __mutex_lock+0x19f/0x2330
[  488.437606]        ksmbd_conn_write+0x100/0x400
[  488.437854]        __smb2_oplock_break_noti+0x8ac/0xba0
[  488.438127]        oplock_break+0xda9/0x15d0
[  488.438358]        smb_break_all_levII_oplock+0x6a7/0x940
[  488.438644]        smb_break_all_oplock+0x1b4/0x200
[  488.438905]        smb2_open+0x9ef2/0xa220
[  488.439125]        handle_ksmbd_work+0x4f5/0x1330
[  488.439370]        process_one_work+0x962/0x1a40
[  488.439636]        worker_thread+0x6ce/0xf10
[  488.439863]        kthread+0x378/0x490
[  488.440074]        ret_from_fork+0x676/0xac0
[  488.440360]        ret_from_fork_asm+0x1a/0x30
[  488.440666] 
[  488.440666] other info that might help us debug this:
[  488.440666] 
[  488.441143] Chain exists of:
[  488.441143]   &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock
[  488.441143] 
[  488.441830]  Possible unsafe locking scenario:
[  488.441830] 
[  488.442190]        CPU0                    CPU1
[  488.442480]        ----                    ----
[  488.442765]   rlock(&ci->m_lock);
[  488.442996]                                lock(&conn->session_lock);
[  488.443402]                                lock(&ci->m_lock);
[  488.443797]   lock(&conn->srv_mutex);
[  488.444048] 
[  488.444048]   DEADLOCK 
[  488.444048] 
[  488.444340] 3 locks held by kworker/1:1/483:
[  488.444561]  #0: ffff888103769548 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x11d8/0x1a40
[  488.445089]  #1: ffffc90000f5fd00 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x8d8/0x1a40
[  488.445638]  #2: ffff88810a11fd70 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  488.446140] 
[  488.446140] stack backtrace:
[  488.446376] CPU: 1 UID: 0 PID: 483 Comm: kworker/1:1 Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[  488.446400] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  488.446420] Workqueue: ksmbd-io handle_ksmbd_work
[  488.446444] Call Trace:
[  488.446463]  <TASK>
[  488.446472]  dump_stack_lvl+0xc6/0x120
[  488.446497]  print_circular_bug+0x2d1/0x400
[  488.446520]  check_noncircular+0x146/0x160
[  488.446546]  check_prev_add+0xeb/0xd00
[  488.446569]  __lock_acquire+0x1641/0x2260
[  488.446594]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.446624]  ? stack_depot_save_flags+0x424/0x990
[  488.446676]  lock_acquire+0x150/0x2c0
[  488.446697]  ? ksmbd_conn_write+0x100/0x400
[  488.446726]  ? __pfx___might_resched+0x10/0x10
[  488.446750]  ? smb_break_all_levII_oplock+0x6a7/0x940
[  488.446777]  ? smb_break_all_oplock+0x1b4/0x200
[  488.446802]  ? smb2_open+0x9ef2/0xa220
[  488.446825]  __mutex_lock+0x19f/0x2330
[  488.446845]  ? ksmbd_conn_write+0x100/0x400
[  488.446875]  ? ksmbd_conn_write+0x100/0x400
[  488.446905]  ? __pfx___mutex_lock+0x10/0x10
[  488.446935]  ? ksmbd_conn_write+0x100/0x400
[  488.446963]  ksmbd_conn_write+0x100/0x400
[  488.446994]  __smb2_oplock_break_noti+0x8ac/0xba0
[  488.447019]  ? kasan_set_track+0x10/0x20
[  488.447065]  oplock_break+0xda9/0x15d0
[  488.447090]  ? __pfx_oplock_break+0x10/0x10
[  488.447113]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447137]  ? down_read+0x1b1/0x450
[  488.447159]  ? __pfx_down_read+0x10/0x10
[  488.447181]  ? lock_release+0xc7/0x270
[  488.447201]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447229]  smb_break_all_levII_oplock+0x6a7/0x940
[  488.447260]  smb_break_all_oplock+0x1b4/0x200
[  488.447287]  smb2_open+0x9ef2/0xa220
[  488.447318]  ? handle_ksmbd_work+0x227/0x1330
[  488.447337]  ? __pfx_smb2_open+0x10/0x10
[  488.447359]  ? __lock_acquire+0x466/0x2260
[  488.447381]  ? __lock_acquire+0x466/0x2260
[  488.447405]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447429]  ? __lock_acquire+0x466/0x2260
[  488.447464]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447488]  ? lock_is_held_type+0x8f/0x100
[  488.447508]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447533]  ? find_held_lock+0x2b/0x80
[  488.447567]  ? xa_load+0x149/0x300
[  488.447593]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447626]  ? ksmbd_smb2_check_message+0x460/0x25c0
[  488.447657]  ? __pfx_smb2_open+0x10/0x10
[  488.447678]  handle_ksmbd_work+0x4f5/0x1330
[  488.447702]  process_one_work+0x962/0x1a40
[  488.447740]  ? __pfx_process_one_work+0x10/0x10
[  488.447772]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447800]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447825]  worker_thread+0x6ce/0xf10
[  488.447846]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447870]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447894]  ? __kthread_parkme+0x191/0x240
[  488.447919]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.447943]  ? __pfx_worker_thread+0x10/0x10
[  488.447976]  kthread+0x378/0x490
[  488.448005]  ? lockdep_hardirqs_on_prepare+0xea/0x1a0
[  488.448027]  ? __pfx_kthread+0x10/0x10
[  488.448057]  ret_from_fork+0x676/0xac0
[  488.448083]  ? __pfx_ret_from_fork+0x10/0x10
[  488.448110]  ? srso_alias_return_thunk+0x5/0xfbef5
[  488.448134]  ? __switch_to+0x7a0/0x10c0
[  488.448158]  ? __pfx_kthread+0x10/0x10
[  488.448191]  ret_from_fork_asm+0x1a/0x30
[  488.448232]  </TASK>
[  489.191073] ksmbd: Failed to send message: -32
[  489.251306] ksmbd: bad smb2 signature
[  489.301208] ksmbd: session id(4294967295) is different with the first operation(1)

---

Trigger Path 2: smb2_write (crash-0-1773506639)
---
[  402.180292] 
[  402.180541] ======================================================
[  402.181117] WARNING: possible circular locking dependency detected
[  402.181716] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[  402.182196] ------------------------------------------------------
[  402.182794] kworker/1:2/74 is trying to acquire lock:
[  402.183298] ffff888110fd2088 (&conn->srv_mutex){+.+.}-{4:4}, at: ksmbd_conn_write+0x100/0x400
[  402.184133] 
[  402.184133] but task is already holding lock:
[  402.184440] ffff88810ca3b770 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  402.184975] 
[  402.184975] which lock already depends on the new lock.
[  402.184975] 
[  402.185395] 
[  402.185395] the existing dependency chain (in reverse order) is:
[  402.185804] 
[  402.185804] -> #2 (&ci->m_lock){++++}-{4:4}:
[  402.186146]        lock_acquire+0x150/0x2c0
[  402.186402]        down_write+0x92/0x1f0
[  402.186672]        __close_file_table_ids+0x1ad/0x430
[  402.186971]        ksmbd_destroy_file_table+0x4a/0xe0
[  402.187279]        ksmbd_session_destroy+0x105/0x3e0
[  402.187577]        ksmbd_sessions_deregister+0x41d/0x750
[  402.187879]        ksmbd_server_terminate_conn+0x15/0x30
[  402.188177]        ksmbd_conn_handler_loop+0xaf1/0xfd0
[  402.188479]        kthread+0x378/0x490
[  402.188728]        ret_from_fork+0x676/0xac0
[  402.188992]        ret_from_fork_asm+0x1a/0x30
[  402.189267] 
[  402.189267] -> #1 (&conn->session_lock){++++}-{4:4}:
[  402.189659]        lock_acquire+0x150/0x2c0
[  402.189906]        down_read+0x9b/0x450
[  402.190135]        ksmbd_session_lookup+0x22/0xd0
[  402.190405]        smb2_sess_setup+0x5aa/0x5fb0
[  402.190691]        handle_ksmbd_work+0x4f5/0x1330
[  402.190962]        process_one_work+0x962/0x1a40
[  402.191257]        worker_thread+0x6ce/0xf10
[  402.191521]        kthread+0x378/0x490
[  402.191758]        ret_from_fork+0x676/0xac0
[  402.192014]        ret_from_fork_asm+0x1a/0x30
[  402.192284] 
[  402.192284] -> #0 (&conn->srv_mutex){+.+.}-{4:4}:
[  402.192660]        check_prev_add+0xeb/0xd00
[  402.192914]        __lock_acquire+0x1641/0x2260
[  402.193178]        lock_acquire+0x150/0x2c0
[  402.193424]        __mutex_lock+0x19f/0x2330
[  402.193690]        ksmbd_conn_write+0x100/0x400
[  402.193966]        __smb2_oplock_break_noti+0x8ac/0xba0
[  402.194267]        oplock_break+0xda9/0x15d0
[  402.194542]        smb_break_all_levII_oplock+0x6a7/0x940
[  402.194856]        ksmbd_vfs_write+0x347/0xc00
[  402.195132]        smb2_write+0x8b1/0xff0
[  402.195371]        handle_ksmbd_work+0x4f5/0x1330
[  402.195653]        process_one_work+0x962/0x1a40
[  402.195935]        worker_thread+0x6ce/0xf10
[  402.196182]        kthread+0x378/0x490
[  402.196416]        ret_from_fork+0x676/0xac0
[  402.196679]        ret_from_fork_asm+0x1a/0x30
[  402.196897] 
[  402.196897] other info that might help us debug this:
[  402.196897] 
[  402.197229] Chain exists of:
[  402.197229]   &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock
[  402.197229] 
[  402.197728]  Possible unsafe locking scenario:
[  402.197728] 
[  402.197984]        CPU0                    CPU1
[  402.198186]        ----                    ----
[  402.198384]   rlock(&ci->m_lock);
[  402.198563]                                lock(&conn->session_lock);
[  402.198849]                                lock(&ci->m_lock);
[  402.199113]   lock(&conn->srv_mutex);
[  402.199288] 
[  402.199288]   DEADLOCK 
[  402.199288] 
[  402.199553] 3 locks held by kworker/1:2/74:
[  402.199742]  #0: ffff888102dc7548 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x11d8/0x1a40
[  402.200214]  #1: ffffc90001727d00 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x8d8/0x1a40
[  402.200707]  #2: ffff88810ca3b770 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[  402.201157] 
[  402.201157] stack backtrace:
[  402.201356] CPU: 1 UID: 0 PID: 74 Comm: kworker/1:2 Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[  402.201378] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  402.201392] Workqueue: ksmbd-io handle_ksmbd_work
[  402.201412] Call Trace:
[  402.201422]  <TASK>
[  402.201428]  dump_stack_lvl+0xc6/0x120
[  402.201450]  print_circular_bug+0x2d1/0x400
[  402.201470]  check_noncircular+0x146/0x160
[  402.201494]  ? __unwind_start+0x496/0x800
[  402.201525]  check_prev_add+0xeb/0xd00
[  402.201546]  __lock_acquire+0x1641/0x2260
[  402.201569]  ? _raw_spin_unlock_irqrestore+0x3f/0x50
[  402.201601]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.201628]  lock_acquire+0x150/0x2c0
[  402.201648]  ? ksmbd_conn_write+0x100/0x400
[  402.201675]  ? __pfx___might_resched+0x10/0x10
[  402.201696]  ? oplock_break+0xda9/0x15d0
[  402.201717]  ? smb_break_all_levII_oplock+0x6a7/0x940
[  402.201741]  ? ksmbd_vfs_write+0x347/0xc00
[  402.201765]  __mutex_lock+0x19f/0x2330
[  402.201784]  ? ksmbd_conn_write+0x100/0x400
[  402.201811]  ? ksmbd_conn_write+0x100/0x400
[  402.201839]  ? __pfx___mutex_lock+0x10/0x10
[  402.201867]  ? ksmbd_conn_write+0x100/0x400
[  402.201892]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.201914]  ksmbd_conn_write+0x100/0x400
[  402.201942]  __smb2_oplock_break_noti+0x8ac/0xba0
[  402.201964]  ? kasan_set_track+0x10/0x20
[  402.202000]  oplock_break+0xda9/0x15d0
[  402.202022]  ? __pfx_oplock_break+0x10/0x10
[  402.202044]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202066]  ? down_read+0x1b1/0x450
[  402.202087]  ? __pfx_down_read+0x10/0x10
[  402.202107]  ? lock_release+0xc7/0x270
[  402.202126]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202151]  smb_break_all_levII_oplock+0x6a7/0x940
[  402.202180]  ksmbd_vfs_write+0x347/0xc00
[  402.202204]  ? __pfx_ksmbd_vfs_write+0x10/0x10
[  402.202227]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202249]  ? _raw_read_unlock+0x1e/0x40
[  402.202277]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202299]  ? __ksmbd_lookup_fd+0x17d/0x1b0
[  402.202329]  smb2_write+0x8b1/0xff0
[  402.202350]  ? __pfx_smb2_write+0x10/0x10
[  402.202370]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202396]  ? __pfx_smb2_write+0x10/0x10
[  402.202417]  handle_ksmbd_work+0x4f5/0x1330
[  402.202439]  process_one_work+0x962/0x1a40
[  402.202473]  ? __pfx_process_one_work+0x10/0x10
[  402.202516]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202542]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202566]  worker_thread+0x6ce/0xf10
[  402.202587]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202609]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202631]  ? __kthread_parkme+0x191/0x240
[  402.202654]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202677]  ? __pfx_worker_thread+0x10/0x10
[  402.202708]  kthread+0x378/0x490
[  402.202734]  ? lockdep_hardirqs_on_prepare+0xea/0x1a0
[  402.202755]  ? __pfx_kthread+0x10/0x10
[  402.202783]  ret_from_fork+0x676/0xac0
[  402.202807]  ? __pfx_ret_from_fork+0x10/0x10
[  402.202832]  ? srso_alias_return_thunk+0x5/0xfbef5
[  402.202854]  ? __switch_to+0x7a0/0x10c0
[  402.202874]  ? __pfx_kthread+0x10/0x10
[  402.202902]  ret_from_fork_asm+0x1a/0x30
[  402.202935]  </TASK>

---

Trigger Path 3: smb2_lock via destroy_previous_session (crash-9-1773486531)
---
[ 5770.186438] ksmbd: failed to get filp for fid 15
[ 5775.405322] 
[ 5775.405445] ======================================================
[ 5775.405727] WARNING: possible circular locking dependency detected
[ 5775.406005] 6.19.0-g44331bd6a610-dirty #5 Not tainted
[ 5775.406237] ------------------------------------------------------
[ 5775.406510] kworker/1:3/9011 is trying to acquire lock:
[ 5775.406749] ffff8881096e5088 (&conn->srv_mutex){+.+.}-{4:4}, at: ksmbd_conn_write+0x100/0x400
[ 5775.407208] 
[ 5775.407208] but task is already holding lock:
[ 5775.407466] ffff88810a7c9070 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[ 5775.407913] 
[ 5775.407913] which lock already depends on the new lock.
[ 5775.407913] 
[ 5775.408290] 
[ 5775.408290] the existing dependency chain (in reverse order) is:
[ 5775.408626] 
[ 5775.408626] -> #2 (&ci->m_lock){++++}-{4:4}:
[ 5775.408911]        lock_acquire+0x150/0x2c0
[ 5775.409130]        down_write+0x92/0x1f0
[ 5775.409342]        __close_file_table_ids+0x1ad/0x430
[ 5775.409591]        ksmbd_destroy_file_table+0x4a/0xe0
[ 5775.409843]        destroy_previous_session+0x254/0x370
[ 5775.410092]        smb2_sess_setup+0x35d2/0x5fb0
[ 5775.410319]        handle_ksmbd_work+0x4f5/0x1330
[ 5775.410543]        process_one_work+0x962/0x1a40
[ 5775.410784]        worker_thread+0x6ce/0xf10
[ 5775.410990]        kthread+0x378/0x490
[ 5775.411189]        ret_from_fork+0x676/0xac0
[ 5775.411412]        ret_from_fork_asm+0x1a/0x30
[ 5775.411642] 
[ 5775.411642] -> #1 (&conn->session_lock){++++}-{4:4}:
[ 5775.411972]        lock_acquire+0x150/0x2c0
[ 5775.412178]        down_read+0x9b/0x450
[ 5775.412370]        ksmbd_session_lookup+0x22/0xd0
[ 5775.412597]        smb2_sess_setup+0x5aa/0x5fb0
[ 5775.412818]        handle_ksmbd_work+0x4f5/0x1330
[ 5775.413043]        process_one_work+0x962/0x1a40
[ 5775.413278]        worker_thread+0x6ce/0xf10
[ 5775.413486]        kthread+0x378/0x490
[ 5775.413681]        ret_from_fork+0x676/0xac0
[ 5775.413896]        ret_from_fork_asm+0x1a/0x30
[ 5775.414121] 
[ 5775.414121] -> #0 (&conn->srv_mutex){+.+.}-{4:4}:
[ 5775.414424]        check_prev_add+0xeb/0xd00
[ 5775.414633]        __lock_acquire+0x1641/0x2260
[ 5775.414855]        lock_acquire+0x150/0x2c0
[ 5775.415060]        __mutex_lock+0x19f/0x2330
[ 5775.415270]        ksmbd_conn_write+0x100/0x400
[ 5775.415496]        __smb2_oplock_break_noti+0x8ac/0xba0
[ 5775.415753]        oplock_break+0xda9/0x15d0
[ 5775.415965]        smb_break_all_levII_oplock+0x6a7/0x940
[ 5775.416224]        smb_break_all_oplock+0x1b4/0x200
[ 5775.416463]        smb2_lock+0x480b/0x4d90
[ 5775.416678]        handle_ksmbd_work+0x4f5/0x1330
[ 5775.416903]        process_one_work+0x962/0x1a40
[ 5775.417137]        worker_thread+0x6ce/0xf10
[ 5775.417342]        kthread+0x378/0x490
[ 5775.417537]        ret_from_fork+0x676/0xac0
[ 5775.417751]        ret_from_fork_asm+0x1a/0x30
[ 5775.417975] 
[ 5775.417975] other info that might help us debug this:
[ 5775.417975] 
[ 5775.418322] Chain exists of:
[ 5775.418322]   &conn->srv_mutex --> &conn->session_lock --> &ci->m_lock
[ 5775.418322] 
[ 5775.418842]  Possible unsafe locking scenario:
[ 5775.418842] 
[ 5775.419105]        CPU0                    CPU1
[ 5775.419316]        ----                    ----
[ 5775.419522]   rlock(&ci->m_lock);
[ 5775.419703]                                lock(&conn->session_lock);
[ 5775.420001]                                lock(&ci->m_lock);
[ 5775.420269]   lock(&conn->srv_mutex);
[ 5775.420452] 
[ 5775.420452]   DEADLOCK 
[ 5775.420452] 
[ 5775.420714] 3 locks held by kworker/1:3/9011:
[ 5775.420917]  #0: ffff8881043d2748 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x11d8/0x1a40
[ 5775.421398]  #1: ffffc900019efd00 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x8d8/0x1a40
[ 5775.421901]  #2: ffff88810a7c9070 (&ci->m_lock){++++}-{4:4}, at: smb_break_all_levII_oplock+0x12a/0x940
[ 5775.422362] 
[ 5775.422362] stack backtrace:
[ 5775.422568] CPU: 1 UID: 0 PID: 9011 Comm: kworker/1:3 Not tainted 6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[ 5775.422591] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[ 5775.422606] Workqueue: ksmbd-io handle_ksmbd_work
[ 5775.422626] Call Trace:
[ 5775.422635]  <TASK>
[ 5775.422643]  dump_stack_lvl+0xc6/0x120
[ 5775.422665]  print_circular_bug+0x2d1/0x400
[ 5775.422686]  check_noncircular+0x146/0x160
[ 5775.422710]  check_prev_add+0xeb/0xd00
[ 5775.422732]  __lock_acquire+0x1641/0x2260
[ 5775.422755]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.422781]  ? stack_depot_save_flags+0x424/0x990
[ 5775.422822]  lock_acquire+0x150/0x2c0
[ 5775.422843]  ? ksmbd_conn_write+0x100/0x400
[ 5775.422871]  ? __pfx___might_resched+0x10/0x10
[ 5775.422894]  ? smb_break_all_levII_oplock+0x6a7/0x940
[ 5775.422920]  ? smb_break_all_oplock+0x1b4/0x200
[ 5775.422945]  ? smb2_lock+0x480b/0x4d90
[ 5775.422968]  __mutex_lock+0x19f/0x2330
[ 5775.422987]  ? ksmbd_conn_write+0x100/0x400
[ 5775.423016]  ? ksmbd_conn_write+0x100/0x400
[ 5775.423045]  ? __pfx___mutex_lock+0x10/0x10
[ 5775.423075]  ? ksmbd_conn_write+0x100/0x400
[ 5775.423101]  ksmbd_conn_write+0x100/0x400
[ 5775.423131]  __smb2_oplock_break_noti+0x8ac/0xba0
[ 5775.423155]  ? kasan_set_track+0x10/0x20
[ 5775.423192]  oplock_break+0xda9/0x15d0
[ 5775.423216]  ? __pfx_oplock_break+0x10/0x10
[ 5775.423239]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423263]  ? down_read+0x1b1/0x450
[ 5775.423284]  ? __pfx_down_read+0x10/0x10
[ 5775.423305]  ? lock_release+0xc7/0x270
[ 5775.423325]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423352]  smb_break_all_levII_oplock+0x6a7/0x940
[ 5775.423382]  smb_break_all_oplock+0x1b4/0x200
[ 5775.423408]  smb2_lock+0x480b/0x4d90
[ 5775.423431]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423457]  ? do_raw_spin_lock+0xd7/0x270
[ 5775.423483]  ? ksmbd_smb2_check_message+0x158f/0x25c0
[ 5775.423511]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423535]  ? do_raw_spin_unlock+0x53/0x220
[ 5775.423562]  ? __pfx_smb2_lock+0x10/0x10
[ 5775.423583]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423610]  ? __pfx_smb2_lock+0x10/0x10
[ 5775.423633]  handle_ksmbd_work+0x4f5/0x1330
[ 5775.423656]  process_one_work+0x962/0x1a40
[ 5775.423697]  ? __pfx_process_one_work+0x10/0x10
[ 5775.423729]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423756]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423783]  worker_thread+0x6ce/0xf10
[ 5775.423802]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423826]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423849]  ? __kthread_parkme+0x191/0x240
[ 5775.423873]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.423897]  ? __pfx_worker_thread+0x10/0x10
[ 5775.423929]  kthread+0x378/0x490
[ 5775.423956]  ? lockdep_hardirqs_on_prepare+0xea/0x1a0
[ 5775.423979]  ? __pfx_kthread+0x10/0x10
[ 5775.424008]  ret_from_fork+0x676/0xac0
[ 5775.424033]  ? __pfx_ret_from_fork+0x10/0x10
[ 5775.424060]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 5775.424083]  ? __switch_to+0x7a0/0x10c0
[ 5775.424104]  ? __pfx_kthread+0x10/0x10
[ 5775.424133]  ret_from_fork_asm+0x1a/0x30
[ 5775.424168]  </TASK>
[ 5775.460958] ksmbd: Try to unlock nolocked range
[ 5775.736021] ksmbd: Try to unlock nolocked range
[ 5777.717197] ksmbd: not allow rw access by exclusive lock from other opens
[ 5777.717586] ksmbd: unable to write due to lock

---

  4.d. Suggested Fix

Since the deadlock is systemic (affecting all oplock-breaking handlers), the fix must be architectural:

1. Preferred: Asynchronous oplock break notification — Queue oplock break writes to a dedicated workqueue instead of calling `ksmbd_conn_write()` directly within the oplock break path. This decouples the lock ordering entirely.
2. Alternative: Drop `m_lock` before notification — Release `ci->m_lock` before calling `ksmbd_conn_write()` in `oplock_break()`, re-acquire afterward if needed.
3. Alternative: Separate write mutex — Use a dedicated mutex for oplock break writes that does not conflict with the `srv_mutex → session_lock → m_lock` ordering.

Option 1 is the cleanest and most maintainable.

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger conditions:
- Multiple concurrent SMB sessions with open files on overlapping inodes
- WRITE, LOCK, or CREATE operations that conflict with existing oplocks
- Concurrent session setup/teardown (MITM-induced or natural)

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
