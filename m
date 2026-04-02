Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADA93BED5C
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775128024; cv=none; b=SYGiZOgRJkLYw2AKfZZ12+rNREfSVxCFACsWXJrn3elQwMpz0U5i/5PKN+eqy893l6dBi0h20OYGziC6cbIYC0tiBbUfQOPx8/48tmeWz+rVLZHjmT2B6yqQbH+rqEUNNi/87Vmcu4wEY0+IlUePGfKKup2vFfbul+QP42Jv3+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775128024; c=relaxed/simple;
	bh=3RRxKFIktcDCw568ZsPXt3vVTDC9PEFREaT4G8posPU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=Xh4FTXoODMFcj2RLVCe124Tz9T2fLsmn4D6FwaUZILc7O7ZKnQ1V0x7Z44S3c6gZXEz1TbK0pz2TGB0oCxhLaT+w8LjzAhOZRY/Dqod0TjzHp0WL15vJ9Wr9t7givDk7rGFWRV3EmyQQfpcqI/6swFMDOYihRLhQceC9OnRJJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQV4SxHT; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQV4SxHT"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso368841a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 04:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775128018; x=1775732818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tmCtaWGrJzPHLTJbmGTfU/PViFD3usZzQK2tZkfcZnk=;
        b=fQV4SxHTqEsNQM4o0N5lZcVSCDV76dystMJopw/2o++1lLj6pHlNRrrhfS1yeQ5hz+
         9i8J5S+/V//ow7rCM+9ZyOEMxIgIvI3Xx3QaNm2r4y7yC1u2ywYR0E8gIoQ6+Mu7hNPB
         rv8dvlMiHb9yya6HZxdDuw1zTnXv+FmEt2tetF8Jx72OypJ7UNTSrPP2F3saZBB30CYE
         uu2ZCN1U7afn1paRwkhiWb+hRH76tOiAW+ajnO9e2x/nUO0Hwe7xQ7UxGCtiQ0IGgeWQ
         tTcpzDF3hQ0hSQapQ1k8u2lcu4udBokMLaXI34UIH8mEmtGhFtwNEZnWkDLeAfSc6Tsb
         BaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775128018; x=1775732818;
        h=content-transfer-encoding:mime-version:date:subject:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmCtaWGrJzPHLTJbmGTfU/PViFD3usZzQK2tZkfcZnk=;
        b=KVd5+M+LSugFw+JMDqrzXylkna9kzIwkDzwu2ID3YaKHOmfUGJWgEcGn0nuu8Ps+rp
         X+X4luUIDgHqqQet/N8zYgMajxLm7O+4KVUlY4nqL8xN06wM3md8oLTDijPFn8v1usHH
         x57t8Ls/uQRz0YXrenmg9tsn96XRpxIRQmZhHST1NzbhQwyyTE3gVSQVBY+74qllboyv
         Rei6ynJQDaDDcwzjsk29wuFVox8er8prMxqX1q9o2O7FW9/EP4/7m4Br8Wmu4rtZClsB
         1iTy9DFnF1XsWsSl1CZkcYQuIppwKHBLNaWrerYxogrAxUijT5H0RdozXiimxvCHCbM9
         +pug==
X-Gm-Message-State: AOJu0YyIqZGTEf+iyxJly4BNeO5/tx/0bom195FZgGc4XLGlpuejnIt5
	Ytsqb5KmolmMESfNpb0PQMACv6c1I28hReyvr25x2nVDp918Zrd1wOlkXOJfrNLYmyWXhQ==
X-Gm-Gg: AeBDietfzocDwnKuwoPjoXoYqW69zdP3mlJrhX8nmOGRA0lnXx+UgV5ufQq61z5nKFH
	Q0l+siwkiaeyprgWAe5YXlgTvfn95ulsGTRtItIJ8Q202t39kx4Uylt8N4rXG9yeANdLsyQh8yP
	mtt07WckSdTA+s1Q2RNP1tvEmKDyKnXM5/PU9ECVzeEPw/Oxr1HN3pcebsI8eOGOuDDe8gF5RmT
	QAlB4/ZzFWg8ls31mwf2FQ/AXu3ujBm+0wu2ffYgxNMxk4rRKQ5sx+ONsZaK3B3DQtPxqv49utB
	2bc4GqT/sZAklLY3olJwai0kbsZoJSgHNBCZhWV1DhbJWZ9YmlwIuD42tUeBj2g8piqBrFMcnlA
	N5va0LzptF+7N03RK5mJkeg2k+/CJ9azPfe2dYpUkFWuEzazGmLm3T5lcCsTn0dv8OcSrTsvMMS
	Jl2kOWW3coGxzwWDTQCzs=
X-Received: by 2002:a17:90b:1d0b:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-35dc6ea6d23mr6219862a91.1.1775128018296;
        Thu, 02 Apr 2026 04:06:58 -0700 (PDT)
Received: from localhost ([137.132.22.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe93661fsm8008060a91.11.2026.04.02.04.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:06:58 -0700 (PDT)
Message-ID: <69ce4dd2.170a0220.23bcc5.dd88@mx.google.com>
From: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Steve French <sfrench@samba.org>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [BUG] Linux Kernel CIFS Client SMB2_open_free KFENCE Double-Free
Date: Thu, 02 Apr 2026 19:06:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: KernelStackFuzz send_email.sh

Linux Kernel CIFS Client SMB2_open_free KFENCE Double-Free

  1. Vulnerability Title

Linux Kernel CIFS Client SMB2 Compound Request KFENCE-Confirmed Double-Free Vulnerability (ksmbd)

  2. High-Level Overview

This report describes the same double-free vulnerability in the Linux kernel CIFS client as crash_001 (KASAN detection), now independently confirmed by KFENCE (Kernel Electric-Fence). When the CIFS client sends a compound `CREATE + CLOSE` request (e.g., via `smb2_unlink()`), a malicious server or MITM can return `STATUS_IO_TIMEOUT` in the CREATE response, causing a retry loop. On the error-path of the retry, `SMB2_open_free()` is called a second time on an already-freed `cifs_small_rq` mempool object (448 bytes), producing a double-free.

The KFENCE detection provides additional forensic detail over the KASAN report in crash_001: precise timestamps, exact object lifetime (27.5 seconds), exact slab cache name (`cifs_small_rq`), and confirmation that both frees are issued by the same task — ruling out any race condition. This is a deterministic, single-threaded double-free.

This vulnerability was discovered using ven0mfuzzer, our custom-designed MITM-based network filesystem fuzzer developed by our team. Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact.

  3. Affected Product and Version Information

Product: Linux Kernel (upstream mainline)
Affected Component: `fs/smb/client/smb2inode.c` — `smb2_unlink()` (line 1186)
Supporting Components:
- `fs/smb/client/smb2pdu.c` — `SMB2_open_free()` does not null freed pointer (line 3244)

  Tested Versions (confirmed vulnerable)
- Linux kernel 6.19.0 (mainline, commit `44331bd6a610`, gcc 11.4.0, built 2026-02-13)
- Linux kernel 6.12.74 (LTS, used in Google kernelCTF COS target)

  Affected Version Range
All kernels from approximately 6.0 through 6.19 (current mainline at time of report) with SMB2 compound replay support are believed affected.

  Affected Distributions and Products

 |  Vendor / Product  |  Notes  | 
 | --- | --- | 
 |  Red Hat Enterprise Linux (RHEL 9.x)  |  Ships kernels >= 5.14 with backported SMB2 compound replay  | 
 |  Ubuntu (22.04 LTS, 24.04 LTS)  |  HWE kernels 6.x include vulnerable code  | 
 |  SUSE Linux Enterprise Server (SLES 15 SP5+)  |  Kernel 6.x based  | 
 |  Debian (Bookworm, Trixie)  |  Kernels 6.1+  | 
 |  Fedora (39+)  |  Kernels 6.5+  | 
 |  Amazon Linux 2023  |  Kernel 6.1 LTS based  | 
 |  Google ChromeOS / COS  |  kernelCTF target, confirmed vulnerable on 6.12.74  | 

  4. Root Cause Analysis

  4.a. Detailed Description

This is the same root cause as crash_001: `smb2_unlink()` calls `SMB2_open_free()` twice on the same stack-local `open_iov` array pointer. The first free occurs during normal cleanup after `compound_send_recv()` returns `-EAGAIN` (due to `STATUS_IO_TIMEOUT`). The retry loop (`goto again`) reuses the same `open_iov` array without clearing it. If `SMB2_open_init()` fails on the second iteration (due to reconnect state), the `err_free` label calls `SMB2_open_free()` again on the stale pointer.

The KFENCE report captures all three critical events:

1. Allocation at `smb2_unlink+0x470` — `SMB2_open_init` allocates the CREATE request buffer
2. First free at `smb2_unlink+0x5db` — normal cleanup after `compound_send_recv` (line 1263)
3. Invalid second free at `smb2_unlink+0x81c` — `err_free` label (line 1289)

  4.b. Code Flow

---
smb2_unlink()                    [fs/smb/client/smb2inode.c:1186]
  again:
    SMB2_open_init()             ← allocates cifs_small_rq object (448B)
    compound_send_recv()         ← server returns STATUS_IO_TIMEOUT → -EAGAIN
    SMB2_open_free(&rqst[0])    ← FIRST FREE (line 1263), does NOT null open_iov[0]
    goto again
  again:
    memset(rqst, 0, ...)         ← clears rqst[] but NOT open_iov[] (stale pointer!)
    SMB2_open_init()             ← fails (connection being reconnected) → rc != 0
    goto err_free
  err_free:
    SMB2_open_free(&rqst[0])    ← SECOND FREE of already-freed buffer!
---

  4.c. KFENCE Crash Trace

This vulnerability was discovered by ven0mfuzzer. The following kernel trace is submitted following syzkaller's common practice of providing the raw crash trace as the primary reproduction evidence:

---
: VFS: Signing Key   d8 d6 c0 c2 b7 56 41 83 e9 d7 b5 fd 2c df 47 62
[ 1087.254230] CIFS: VFS: ServerIn Key  5b 78 90 2a f0 90 67 84 da 43 e8 f1 a8 43 eb 91
[ 1087.254673] CIFS: VFS: ServerOut Key 93 3a 5d ae db 4a 4b fb 24 4b c5 b8 f9 e3 47 29
[ 1087.258673] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -22
[ 1087.259195] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1087.259715] ==================================================================
[ 1087.260125] BUG: KFENCE: invalid free in mempool_free+0xde/0x130
[ 1087.260125] 
[ 1087.260556] Invalid free of 0xffff8881f5cc4e40 (in kfence-#97):
[ 1087.260893]  mempool_free+0xde/0x130
[ 1087.261124]  cifs_small_buf_release+0x41/0x70
[ 1087.261392]  SMB2_open_free+0x78/0x1b0
[ 1087.261631]  smb2_unlink+0x81c/0x8d0
[ 1087.261870]  __cifs_unlink+0x830/0x1890
[ 1087.262134]  vfs_unlink+0x2f0/0xbd0
[ 1087.262369]  filename_unlinkat+0x345/0x6d0
[ 1087.262628]  __x64_sys_unlinkat+0xc4/0x130
[ 1087.262886]  do_syscall_64+0x111/0x690
[ 1087.263125]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1087.263427] 
[ 1087.263531] kfence-#97: 0xffff8881f5cc4e40-0xffff8881f5cc4fff, size=448, cache=cifs_small_rq
[ 1087.263531] 
[ 1087.264219] allocated by task 1881 on cpu 0 at 1059.756104s (27.508113s ago):
[ 1087.264648]  mempool_alloc_noprof+0x18a/0x2c0
[ 1087.264919]  cifs_small_buf_get+0x36/0x80
[ 1087.265210]  __smb2_plain_req_init+0x4b/0x1140
[ 1087.265487]  SMB2_open_init+0x1ae/0x37f0
[ 1087.265735]  smb2_unlink+0x470/0x8d0
[ 1087.265974]  __cifs_unlink+0x830/0x1890
[ 1087.266226]  vfs_unlink+0x2f0/0xbd0
[ 1087.266460]  filename_unlinkat+0x345/0x6d0
[ 1087.266717]  __x64_sys_unlinkat+0xc4/0x130
[ 1087.266975]  do_syscall_64+0x111/0x690
[ 1087.267214]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1087.267514] 
[ 1087.267618] freed by task 1881 on cpu 0 at 1087.241106s (0.026511s ago):
[ 1087.268109]  mempool_free+0xde/0x130
[ 1087.268352]  cifs_small_buf_release+0x41/0x70
[ 1087.268620]  SMB2_open_free+0x78/0x1b0
[ 1087.268858]  smb2_unlink+0x5db/0x8d0
[ 1087.269091]  __cifs_unlink+0x830/0x1890
[ 1087.269293]  vfs_unlink+0x2f0/0xbd0
[ 1087.269481]  filename_unlinkat+0x345/0x6d0
[ 1087.269687]  __x64_sys_unlinkat+0xc4/0x130
[ 1087.269895]  do_syscall_64+0x111/0x690
[ 1087.270086]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1087.270327] 
[ 1087.270417] CPU: 0 UID: 0 PID: 1881 Comm: rm Tainted: G    B               6.19.0-g44331bd6a610-dirty #5 PREEMPT(lazy) 
[ 1087.270900] Tainted: [B]=BAD_PAGE
[ 1087.271061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[ 1087.271561] ==================================================================
[ 1087.723901] CIFS: VFS: \\10.0.0.2 RFC 1002 unknown response type 0x8
[ 1087.739764] CIFS: VFS: \\10.0.0.2\IPC$ validate protocol negotiate failed: -11
[ 1087.740391] CIFS: VFS: \\10.0.0.2\IPC$ reconnect tcon failed rc = -5
[ 1087.746271] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[ 1087.746842] CIFS: VFS: Session Id    02 00 00 00 00 00 00 00
[ 1087.747238] CIFS: VFS: Cipher type   1
[ 1087.747464] CIFS: VFS: Session Key   71 85 72 ad 7c b4 da e7 cf dc c0 ae 3a 07 98 19
[ 1087.747888] CIFS: VFS: Signing Key   88 3f d1 03 8b 13 17 97 88 be 52 23 9b 8d a9 ed
[ 1087.748463] CIFS: VFS: ServerIn Key  0e 28 bd af 95 9d 5d e4 34 0a d5 de a6 9a 74 0d
[ 1087.749077] CIFS: VFS: ServerOut Key ba a1 76 7c c0 b9 32 db 27 09 85 1a e7 7d cf 65
[ 1087.754602] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -13
[ 1087.755289] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1087.758970] CIFS: VFS: smb2_get_data_area_len: invalid data area (off=10608 len=24)
[ 1087.759770] CIFS: VFS: \\10.0.0.2\fuzzshare Malformed ioctl resp: len 24 offset 10608
[ 1087.760271] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -5
[ 1087.760742] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1087.764494] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -22
[ 1087.765178] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1088.197368] CIFS: VFS: Bad protocol string signature header 420053fe
[ 1088.198145] CIFS: VFS: Bad SMB detected. The Mid=16
[ 1088.198652] 00000000: 420053fe 00010040 00000000 000a0005  .S.B@...........
[ 1088.199364] 00000010: 00000001 00000000 00000010 00000000  ................
[ 1088.200070] 00000020: 00000776 00000004 00000002 00000002  v...............
[ 1088.459625] CIFS: VFS: \\10.0.0.2 RFC 1002 unknown response type 0x42
[ 1089.503269] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[ 1089.503705] CIFS: VFS: Session Id    02 00 00 00 00 00 00 00
[ 1089.504013] CIFS: VFS: Cipher type   1
[ 1089.504229] CIFS: VFS: Session Key   d6 56 c8 0b 7a 8f 2c 81 4a 9a 16 b8 ef a6 df 50
[ 1089.504575] CIFS: VFS: Signing Key   b6 36 17 ad 2f 1d d5 d6 21 0a 98 37 50 9a 31 08
[ 1089.504914] CIFS: VFS: ServerIn Key  b6 c4 17 a9 16 ed 60 72 14 1b 64 6b d5 20 5f f2
[ 1089.505485] CIFS: VFS: ServerOut Key e1 8c 7f af 9e 04 ed 2c 67 47 63 68 e4 eb 9e 2b
[ 1089.718373] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -22
[ 1089.719252] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1090.142104] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -5
[ 1090.142986] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1090.353639] CIFS: VFS: \\10.0.0.2\fuzzshare validate protocol negotiate failed: -22
[ 1090.354254] CIFS: VFS: \\10.0.0.2\fuzzshare reconnect tcon failed rc = -5
[ 1091.057267] CIFS: VFS: \\10.0.0.2\IPC$ validate protocol negotiate failed: -22
[ 1091.058141] CIFS: VFS: \\10.0.0.2\IPC$ reconnect tcon failed rc = -5

---

Key forensic facts from KFENCE:
- Object size: 448 bytes, cache `cifs_small_rq`
- Object lifetime: 27.5 seconds (alloc at 1059.756s, first free at 1087.241s)
- Time between frees: 0.027 seconds (deterministic, single-threaded)
- Both frees from same task (PID 1881, `rm`) — no race condition involved

  4.d. Relationship to crash_001

crash_001 detected the same double-free via KASAN. This KFENCE detection (crash_008) is an independent confirmation of the same root cause with additional forensic data. Together they provide overwhelming evidence that the bug is real, deterministic, and affecting both KASAN and KFENCE instrumentation paths.

  4.e. Suggested Fix

Null out the pointer in `SMB2_open_free()` after releasing the buffer:

---
void SMB2_open_free(struct smb_rqst *rqst)
{
    int i;
    if (rqst && rqst->rq_iov) {
        cifs_small_buf_release(rqst->rq_iov[0].iov_base);
+       rqst->rq_iov[0].iov_base = NULL;
        for (i = 1; i < rqst->rq_nvec; i++)
            if (rqst->rq_iov[i].iov_base != smb2_padding)
                kfree(rqst->rq_iov[i].iov_base);
+       rqst->rq_nvec = 0;
    }
}
---

Alternatively, add `memset(open_iov, 0, sizeof(open_iov))` at the `again` label in `smb2_unlink()`.

  5. Discovery Method and Reproduction

  5.a. Discovery

This vulnerability was discovered using ven0mfuzzer, a custom-designed MITM-based network filesystem fuzzer developed by our team. The fuzzer operates by positioning an AF_PACKET/TCP transparent proxy between a Linux kernel filesystem client (VM-A) and its server (VM-B), then mutating network protocol messages in-flight. We designed ven0mfuzzer specifically for this class of network filesystem vulnerabilities.

Following the common syzkaller practice, we submit the kernel crash trace as the primary reproduction artifact. The trace above was captured with KFENCE enabled on kernel 6.19.0.

  5.b. Reproduction Setup

---
VM-A (CIFS client) ──SMB2──► Host:44446 (MITM proxy) ──TCP──► Host:44445 ──hostfwd──► VM-B:445 (ksmbd)
---

Trigger condition: Any `unlink` operation on a CIFS mount while the MITM injects `STATUS_IO_TIMEOUT` (`0xC00000B5`) in CREATE responses followed by a forced reconnect.

---
Reported-by: ven0mfuzzer <ven0mkernelfuzzer@gmail.com>
Link: https://github.com/KernelStackFuzz/KernelStackFuzz
