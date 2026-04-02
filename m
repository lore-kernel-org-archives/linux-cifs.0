Received: from mail-vs1-f65.google.com (mail-vs1-f65.google.com [209.85.217.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B93A4F27
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135184; cv=none; b=CQ3Qi637oEddtj6SvXbBOczv2d++KpQ6S406tthDyaN/B+sxBa/6z84wd0cj7Odh8zll+AvoDsu7k4U8oFWLShyqYr6ASdY0xJs4GdXfnViZaCGKmuaQSle+ce/eSMR9dIqtvknBEyenUOXvTI0i7S50FcnPkTydgjcBon3FDmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135184; c=relaxed/simple;
	bh=ik7uUTib9+LCz0UAAdU8wVthAJCsJQ9Tt8iu7WwCWkA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=ANU7H1IySFMoHZ6dFBAVXLokgQrZd6fMw8zi+HizZnoa/LgzkWbegfWdMaVYMREzcLzn62A70TsSDiyxqzh2UKKGR0eCPotqxp4ElFfbKH2IxgGceOuOE9x0HTxs36MRJDYHjvHfj9TVcfX/APrwxWC8XhWP14KjxwtT5ShGIe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfUOkdby; arc=none smtp.client-ip=209.85.217.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfUOkdby"
Received: by mail-vs1-f65.google.com with SMTP id ada2fe7eead31-5ffdd9a6155so1844137137.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 06:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775135177; x=1775739977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=f10hXx8Ya/o2nsVJSMU9jz32XKIcCmbLZ6lBcgyEWlM=;
        b=bfUOkdbym1vG20v5T1ObL72no8Cp1A9rP6pG/4c8bkIXUVJAZfGgzbv0pchaExI68v
         epxMwJZt1o301ehqj1oj4Nr2KicS7a6r+dg23jy0d849qhsUU0OcfM/AevqSqvKMNHbh
         8CMV5QWty2n7RtiB1y6k76ZmvjdCHj74nvF/2/H2w+lMkgtHubw9SWyq2tol6E8WQC0B
         Cup5/mZg+RMi926Q9RprEMcJws1Gq652s08V5kjAutBmBkL2QrccJZt6JizkKg1gZMAe
         rNLEBuD+jEG4WEWV3ctwoEC+09T//qwjN16R6z8R3bf6OOrDUm7QXC+XwDMc1ZP9UYoo
         FYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775135177; x=1775739977;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f10hXx8Ya/o2nsVJSMU9jz32XKIcCmbLZ6lBcgyEWlM=;
        b=pOySg2l3NhOI3KTLe5cZRI4h/CK81aGNJixKjypUCnsSGNJzr5ACC2uoNpK9cUVa0F
         wVJ+O7HPT2n0zwygCxpE3mAIBTfte8Dgb5/RRPA0smnzdag/KJt2o36ID1zxBkev6Oab
         PLz069F+RbCeYnej42Ki9+b8FT8K2XvFsoOIN1B7Fn7ES26Ki7Fit+XqxY8qG2Wq/ZT2
         a1d5A5/mWy7jebXlH00ct7E53s7jyVyejSWTRelHsia2Jf8hXiTZuXyXBPEq3/nP6uwv
         smOZPjBgmxUt//rBCqF0bj0dzQw0oBemQofPpw1FKDpk07P+XEtKAhSpTEULsmTKbS23
         Sfsw==
X-Gm-Message-State: AOJu0YwFUzPy1z/TZ4WuDwWzx7Bmm2eN205O/HnduxMWntpAmHinj72B
	naIu0KEaPIoqiNKSrL2HU0bQrVw2lY+1novbD73b2CgZ6MIKLQl+4W+KmbZORYWcC9ZmbHFP
X-Gm-Gg: ATEYQzzVCMXIGJh0m8bm1Eg3U51HS59a7M3Ed1N+ndNurcvPmJDe+KtISqSWGn9i1WI
	f0KLOHoYzCgM+e8XcsbQqYZU6V9A4ddP/JwXCB/fWA/ohiY9ZlnHytCFetsOnx6i47Y4slutqPV
	hGKldh/zOE2NKcbIa/ad3Cyu81XhsX0MbWfg68DtIxzfVZ9pMptxUuf07yVfSSsY1VQTBXswwWe
	Mgki7Kd+ujjyn3q21UvAiXlwP7hf2IqIMThnBEcmnYJbsugdjEpZehVJTPikQMwExpJeWHzH5A/
	IP3uJkgeiLqhuvlq8jqeA7ekmdzAp0bl3bEr04W3YcSL7NDgLuIJXg5baO0jAJ8vw1HU2z0EpE4
	6PTUKK7+O1+dhfZgktqmeGFRHnu1yxdaQLXrzXf+BX2qX6CYZZntjBr3HhEmLH0EfSoP1FLoZSU
	ha4Hgu5mORP5K+woNqxHs=
X-Received: by 2002:a17:90b:1f85:b0:359:8957:7285 with SMTP id 98e67ed59e1d1-35dd67257bbmr1602746a91.3.1775128030888;
        Thu, 02 Apr 2026 04:07:10 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35364edsm2447388a91.0.2026.04.02.04.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:07:10 -0700 (PDT)
Message-ID: <69ce4dde.170a0220.39732d.82c2@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Simon Horman <horms@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        David Ahern <dsahern@kernel.org>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [BUG] Linux Kernel ksmbd Multiple Memory Leaks in Session Handling
Date: Thu, 02 Apr 2026 19:07:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel ksmbd Multiple Memory Leaks in Session Handling

  1. Vulnerability Title

Linux Kernel ksmbd Server Multiple Kernel Memory Leak Vulnerability in Session Setup/Teardown

  2. High-Level Overview

Seven distinct kernel memory leaks exist in the ksmbd (in-kernel SMB server) session handling paths. During SMB session setup and teardown, multiple kernel objects — including socket inodes (1344 bytes), LSM security blobs (120 and 32 bytes), TCP connection structures (3264 bytes), ksmbd connection contexts (64 and 16 bytes), and network skb buffers (240 bytes) — are allocated but never freed. These leaks accumulate over time with repeated session establishment, allowing a remote attacker to exhaust kernel memory by repeatedly connecting and disconnecting SMB sessions. This constitutes a denial-of-service vulnerability.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/server/` — ksmbd session setup/teardown, connection handling
Supporting Components:
- `fs/smb/server/transport_tcp.c` — `ksmbd_kthread_fn()`, `ksmbd_tcp_readv()`
- `fs/smb/server/connection.c` — connection context allocation
- `net/socket.c` — `sock_alloc_inode()`, `kernel_accept()`
- `net/ipv4/tcp_minisocks.c` — `tcp_create_openreq_child()`

  Tested Versions (confirmed vulnerable)
- Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built 2026-02-13)
- Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)

  Affected Version Range
All kernels with ksmbd support (approximately 5.15 through 6.19) are believed affected.

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

The kmemleak detector identified 7 unreferenced kernel objects allocated during ksmbd session handling that are never freed. These leaks occur across multiple subsystems involved in SMB connection management:

1. Socket inode (1344 bytes): Allocated by `sock_alloc_inode()` during `kernel_accept()` in `ksmbd_kthread_fn()`. The accepted socket's inode is not properly released when the connection is torn down.

2. LSM security blob (120 bytes): Allocated by `security_inode_alloc()` during inode initialization for the socket. Leaked because the parent inode is leaked.

3. TCP connection structure (3264 bytes): Allocated by `sk_prot_alloc()` during `tcp_create_openreq_child()` when accepting a new TCP connection. The TCP socket is not properly closed on session teardown.

4. LSM security blob for socket (32 bytes): Allocated by `security_sk_alloc()` for the cloned TCP socket. Leaked with the parent TCP structure.

5. ksmbd connection context (64 bytes): Allocated by `ksmbd_kthread_fn()` for per-connection state. Not freed when the connection handler exits abnormally.

6. ksmbd TCP read buffer (16 bytes): Allocated by `ksmbd_tcp_readv()` for receiving SMB messages. Not freed when read is interrupted.

7. SKB buffer (240 bytes): Allocated by `build_skb()` in the virtio-net receive path for incoming SMB packets. Orphaned when the associated socket is leaked.

  4.b. Code Flow

---
ksmbd_kthread_fn()                    [fs/smb/server/transport_tcp.c]
  → kernel_accept()                   ← allocates socket inode (1344B) + security blob (120B)
    → sock_alloc() → alloc_inode()
    → security_inode_alloc()

TCP SYN_RECV → ESTABLISHED:
  → tcp_create_openreq_child()        ← allocates TCP sock (3264B) + security blob (32B)
    → sk_prot_alloc() → sk_clone()
    → security_sk_alloc()

ksmbd_kthread_fn() continued:
  → kmalloc (64B)                     ← ksmbd connection context

ksmbd_conn_handler_loop():
  → ksmbd_tcp_readv()
    → kmalloc (16B)                   ← TCP read buffer

[on session teardown — objects NOT freed due to missing cleanup]
---

  4.c. Crash Trace

This vulnerability was discovered by ven0mfuzzer. The following kmemleak output is submitted following syzkaller's common practice of providing the raw kernel trace as the primary reproduction evidence:

---
unreferenced object 0xffff88810af3d180 (size 1344):
  comm "ksmbd-eth0", pid 328, jiffies 4294901355
  backtrace (crc 1a26ccb4):
    kmem_cache_alloc_lru_noprof+0x3ed/0x5f0
    sock_alloc_inode+0x25/0x1c0
    alloc_inode+0x64/0x240
    sock_alloc+0x40/0x280
    sock_create_lite+0x82/0x120
    kernel_accept+0x16b/0x380
    ksmbd_kthread_fn+0xee/0xf30

unreferenced object 0xffff888107243bd0 (size 120):
  comm "ksmbd-eth0", pid 328, jiffies 4294901355
  backtrace (crc 6bd3e180):
    kmem_cache_alloc_noprof+0x3ed/0x5f0
    security_inode_alloc+0x3b/0x140
    inode_init_always_gfp+0xbf9/0xf20
    alloc_inode+0x86/0x240
    sock_alloc+0x40/0x280
    sock_create_lite+0x82/0x120
    kernel_accept+0x16b/0x380
    ksmbd_kthread_fn+0xee/0xf30

unreferenced object 0xffff88810fbfa980 (size 3264):
  comm "softirq", pid 0, jiffies 4294902189
  backtrace (crc c2de1a0c):
    kmem_cache_alloc_noprof+0x3ed/0x5f0
    sk_prot_alloc+0x60/0x2a0
    sk_clone+0x79/0x14f0
    inet_csk_clone_lock+0x2f/0x760
    tcp_create_openreq_child+0x34/0x26a0
    tcp_v4_syn_recv_sock+0x115/0x10e0

unreferenced object 0xffff888108c514a0 (size 32):
  comm "softirq", pid 0, jiffies 4294902189
  backtrace (crc ea16adaf):
    __kmalloc_noprof+0x4eb/0x760
    lsm_blob_alloc+0x68/0x90
    security_sk_alloc+0x2f/0xd0
    sk_prot_alloc+0xfb/0x2a0
    sk_clone+0x79/0x14f0

unreferenced object 0xffff88810fd0b540 (size 64):
  comm "ksmbd-eth0", pid 328, jiffies 4294902189
  backtrace (crc f2da5eae):
    __kmalloc_cache_noprof+0x411/0x610
    ksmbd_kthread_fn+0x288/0xf30

unreferenced object 0xffff8881063426f0 (size 16):
  comm "ksmbd:::ffff:10", pid 434, jiffies 4294902190
  backtrace (crc 9e6ee6c8):
    __kmalloc_cache_noprof+0x411/0x610
    ksmbd_tcp_readv.constprop.0+0x16d/0x700
    ksmbd_tcp_read+0x88/0xc0
    ksmbd_conn_handler_loop+0x5dd/0xfd0

unreferenced object 0xffff88810fa94200 (size 240):
  comm "softirq", pid 0, jiffies 4294902419
  backtrace (crc 4367e44b):
    kmem_cache_alloc_noprof+0x3ed/0x5f0
    build_skb+0x46/0x370
    page_to_skb+0x5df/0xb30
    receive_buf+0xa3e/0x4940
    virtnet_poll+0xfb6/0x1750
---

Total leaked per session: approximately 5,080 bytes (1344 + 120 + 3264 + 32 + 64 + 16 + 240). An attacker establishing and tearing down sessions repeatedly can exhaust kernel memory.

  4.d. Suggested Fix

The ksmbd session teardown path (`ksmbd_sessions_deregister` / `ksmbd_conn_handler_loop` exit) must properly release all allocated resources:
1. Close the accepted socket via `sock_release()` to free the socket inode and associated LSM blobs
2. Properly tear down the cloned TCP socket
3. Free the ksmbd connection context and read buffers on all exit paths, including error/abort paths

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight.

Following the common syzkaller practice, we submit the kernel kmemleak output as the primary reproduction artifact. The output above was captured with CONFIG_DEBUG_KMEMLEAK enabled on kernel 6.19.0.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger condition: Repeated SMB session establishment and teardown, especially when the MITM proxy disrupts the session setup handshake, forcing abnormal teardown paths.

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
