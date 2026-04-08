Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B3B3815DF
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647781; cv=pass; b=CbarsU1T9CoAQuq8xLtVI+7YnCOFEcBTIc0rP+ilTO3o3Xq+m3Qn8HTC4w8FZfvYsj4XRcyfIBHT1x+AbY0Fl0Cfy3QKYUndELDgCK6fUxvw3VUQurpypWnz0njL3de0txgkMC4332+rNkUrqI+OuFwav1hTgPyM1yu8GaZLdBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647781; c=relaxed/simple;
	bh=u88/aNKm6cCsmocJ8ciVIgp+3eroE8CYTmBTMb8daow=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=odTAyZffJhP/v+NBfLsJSaN0blw14LMVhnnvvJOxVMUkLXmI5cnXkAznjA1/ym8ZG9dFoE4K2yl3MSgb6izJBNQh2MgbV6Hw1i5ars6kTsL80uEFwriYJbTjthdGj1YQXzvH/SqGR5DFh1ODE7UWoicRBaDGejx8GxFB7MQZHyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pwno.io; spf=pass smtp.mailfrom=pwno.io; dkim=pass (2048-bit key) header.d=pwno-io.20251104.gappssmtp.com header.i=@pwno-io.20251104.gappssmtp.com header.b=uponOBjs; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pwno.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwno.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pwno-io.20251104.gappssmtp.com header.i=@pwno-io.20251104.gappssmtp.com header.b="uponOBjs"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2d323567f11so237951eec.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Apr 2026 04:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775647778; cv=none;
        d=google.com; s=arc-20240605;
        b=UhOsmd+towDuxv46OcRbW/0MiLvSe1Jcs7fQ0nezEnUb7mhxPRkMTfw4o+yXSv3IkW
         8k+iRCYbaN3MGwdrDq3LAYj7JA4GmmdhUkpq1mdnZr20hPLnEur5od1uFH8XBSyBfoa+
         w7pXczszvuxgorr9dVWj3M7V8AzVm1c6gQSoqWZTAttFJUBfSpKFv1QLQ6tARiT82s43
         wh6mUdepFVyyrfqLgCVpVvQBpfJAriKZs5TJhCHyLT1PfhL9uqICpgwuGAmYDEnvZ/b5
         oFqMtrNMBDtbw56ldqfvxnubE15L3up3J/4uhb6A6EK7RgbCFartmyu/tV/hnm0kN+sa
         wMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=epukYx8jBt/8xiheyPplCLvOzPZBhamJoHaHp38LDiU=;
        fh=ivZ9q7hDDUKR5VZ3Kv9XtT3eBLowoczdn0Ru4dV+oQI=;
        b=YC52iol4gvE8kIEI7t4LwrQTKnNPOQxDbfqEEZqc+gGQcH0igUSSgmoEurgkLLSHTB
         4LZUyj13UwAKnqtA7fWi605AhBVcr+hvwjR/IbVAckKrm/hKYvFZD/VGFDpfsfyRyrCi
         mS+Z8Cvggq/IbG2TG24YZvYS0lKAi9tUPzSKgdZ3PO240hci937+5LP0AbAnt06AaXKE
         ir85pSy47a+r1bWj0kK4Y0Ht1r1NnSZMes3ANPiRv6Yxx8P9DqD158P3peQkQmIWIo0v
         7HCVvsqqga3Pb9+DCitduFngcmJbMgstSFtxdoG6gmteU4KRsdBAsqgYLQBuRWZTzxlm
         gH1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pwno-io.20251104.gappssmtp.com; s=20251104; t=1775647778; x=1776252578; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=epukYx8jBt/8xiheyPplCLvOzPZBhamJoHaHp38LDiU=;
        b=uponOBjshbldY3p01AOQfN31tqzya3E6rKNnNOlT+8rTS9Ce8wHEguBUioIhkh1AkT
         YWAyWz68haf09HAfmRyZJkxZPtMAkiSVT84woTzqeEe4lAISi5Ts1TsuIJ+99JlGQUG8
         dCSu+dHE9F+CUoREYltVbXRjHTE+G/e0GGks1wIRD4NBzACWzkogoL8Pib6c/T1TLAE4
         n8fOpAqCOHYbW3Qg2qH5kk1hWs2/6N0Qra0cmJUXHF/JIbcPKNVcdYFiTL5kYo+cx8Iw
         URaBWh83P2VMQ+3ygwbdU19S3Kgv0Ko1XKtNKpDhkBqr4+1RyrWTEX7ia2kZ5BCZMJTl
         uTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775647778; x=1776252578;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epukYx8jBt/8xiheyPplCLvOzPZBhamJoHaHp38LDiU=;
        b=pWgKtJcynONqYChipx6F0CyKBn02KeuCpZo+CicaDoSdkIo9hPBiWLtB0t7SZ8r7Hk
         lQfGN/5DHPygntdy8jV7z3+MnEAmqLrs9mcS7DqtxelYnu16CHvyK+4dP6q6kyJtrHkf
         sSUCk37+cR7IjmDrjIuqPp2x3HcVD3/8bizY8BWPWTHkwwTZQ2U5yPezYzgINMgji9GJ
         woOOYUm2MfSGu0o094bS9nh5/HyEB+2fmPmmEDh6XQUBqaxezjNUCh8vhk2h50kYHfJZ
         NdM8Lett57euTgBpqalKuCQBupmjdjIvce1o0CaCAXhHYKaXhyWUt4Sad1/LDJJAbIU2
         Uv+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6c3MkK26W0d7OQmbz9l61xRfwiJnwRDiVzzLFRCyvI/CPqV1YxHHc5lgx26xVewnd2GtwMcwy35tI@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk0V8zm5RqCmgKytYrvled/dH6mEabLUCsykk0ujaGu38Dnz/F
	JDTLmptqXl1HxjEitFKpfc/+Dgz5oje2xdovU3KxFdjaI8SONQmsjrKU4e96k2miLs9TcR9ZubZ
	gJ9P4efkGVbkbBUPTPfKc9knzo50cmJXH8GUo2ytlb6coqSzIRwIeeMYQSz55puzJ
X-Gm-Gg: AeBDiet/mfsSkXg1Jsy+UyKuwaxG6sWhsNX6yGS4vnvpb4/YQhjm3qLb3trab0aPPiL
	gkF0PnMliMi5eecXSPU9z4PmNWQ6Flb0BOH4u8KetJ2CMvDqFQY+yiP2GkPFej5UwXAYXmV8a6l
	yoiG/MjSrJ8wVe4j3eERrXDrZ/GVHe83IBaRoBR7ixdTrqD1TZIDQQWHeghclNioDHlwVbqjQGp
	FsVvQbIx+XyyMdARSmMea7VEC6O/eD/qxGcstd+wDBEnddv+Y8vLfsM3jOM2It5sAkKzzF2WohI
	+xHFMWgkTTETlR2uH0YQR1VGnLQpxMxS4W+J/sNXLb6LwxclFlMoSgBT0M95XOcKgw/n9xGsiDX
	2FXFrtxUXORISMg8iy5ETQW8=
X-Received: by 2002:a05:7300:a287:b0:2c7:6218:9830 with SMTP id
 5a478bee46e88-2cbfb4acafamr9255933eec.11.1775647778127; Wed, 08 Apr 2026
 04:29:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ruikai Peng <ruikai@pwno.io>
Date: Wed, 8 Apr 2026 07:29:26 -0400
X-Gm-Features: AQROBzBiS4q0TEjpdbnzycPNLon-oL1wDyq_hVDiO_7YwhfhX_jbuMGHSJOR9bY
Message-ID: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
Subject: [SECURITY] SMB Direct: double-free of send_io on ib_post_send failure
 in batch flush path
To: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com
Cc: security@kernel.org, metze@samba.org, pc@manguebit.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

The send batching logic introduced in the v7.0 merge window has a
double-free of mempool-backed send message objects when ib_post_send()
fails during a batch flush. The bug affects both the client
(fs/smb/client/smbdirect.c) and server (fs/smb/server/transport_rdma.c)
SMB Direct implementations. It is present on current upstream HEAD
(v7.0-rc7+).

The batch flush helpers (smbd_send_batch_flush and
smb_direct_flush_send_list) take ownership of the batched send
messages and free them on ib_post_send() failure:

  fs/smb/server/transport_rdma.c, smb_direct_flush_send_list():

    ret = smb_direct_post_send(sc, &first->wr);
    if (ret) {
        list_for_each_entry_safe(sibling, ...) {
            smb_direct_free_sendmsg(sc, sibling);
        }
        smb_direct_free_sendmsg(sc, last);
    }

However, the callers (smb_direct_post_send_data and
smbd_post_send_iter) have a generic error path that frees the same
message unconditionally:

  fs/smb/server/transport_rdma.c, smb_direct_post_send_data():

    ret = smb_direct_flush_send_list(sc, send_ctx, true);
    if (ret)
        goto err;
    ...
  err:
    smb_direct_free_sendmsg(sc, msg);

This double-free occurs specifically when using the stack-allocated
local batch for single-message sends, since in that case the caller
immediately flushes and then falls through to the same err label.

The same pattern exists on the client side:

  fs/smb/client/smbdirect.c, smbd_post_send_iter():

    rc = smbd_send_batch_flush(sc, batch, true);
    if (!rc)
        return 0;
    ...
  err_dma:
    smbd_free_send_io(request);

A remote peer can trigger ib_post_send() failures by tearing down the
RDMA connection or forcing the QP into an error state during active
sending. This results in:

  - Kernel heap double-free of mempool-backed send_io objects
  - Use-after-free from subsequent RDMA completion processing
  - Potential memory corruption

This requires an SMB Direct (RDMA) configuration and an attacker
capable of disrupting the RDMA connection.

I reproduced this deterministically using paired QEMU guests with
RXE soft-RDMA, a ksmbd share mounted over SMB Direct, and a
kretprobe-based fault injection module that forces
smb_direct_post_send() to return -EIO. KASAN reports a double-free
in mempool_free_slab and follow-on slab-use-after-free splats.

The first splat is a use-after-free when the caller's error path
touches the object that the flush helper already freed:

  [   14.352449] BUG: KASAN: slab-use-after-free in
smb_direct_free_sendmsg+0x31f/0x380
  [   14.352449] Read of size 8 at addr ffff888009dc72f8 by task kworker/1:0H/25
  [   14.352449]
  [   14.352449] CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Tainted: G
        O        7.0.0-rc7-00059-g3036cd0d3328 #10 PREEMPT(lazy)
  [   14.352449] Workqueue: ksmbd-smb_direct-wq smb_direct_send_immediate_work
  [   14.352449] Call Trace:
  [   14.352449]  <TASK>
  [   14.352449]  dump_stack_lvl+0x5f/0x80
  [   14.352449]  print_report+0xd1/0x640
  [   14.352449]  kasan_report+0xe5/0x120
  [   14.352449]  smb_direct_free_sendmsg+0x31f/0x380
  [   14.352449]  smb_direct_post_send_data+0xf77/0x2cf0
  [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
  [   14.352449]  process_one_work+0x635/0x10a0
  [   14.352449]  worker_thread+0x45b/0xc90
  [   14.352449]  kthread+0x2d7/0x3c0
  [   14.352449]  ret_from_fork+0x39f/0x5d0
  [   14.352449]  </TASK>
  [   14.352449]
  [   14.352449] Allocated by task 25:
  [   14.352449]  kmem_cache_alloc_noprof+0x109/0x380
  [   14.352449]  mempool_alloc_slab+0x14/0x20
  [   14.352449]  mempool_alloc_noprof+0x127/0x210
  [   14.352449]  smb_direct_post_send_data+0x308/0x2cf0
  [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
  [   14.352449]
  [   14.352449] Freed by task 25:
  [   14.352449]  kmem_cache_free+0xb5/0x3b0
  [   14.352449]  mempool_free_slab+0x16/0x20
  [   14.352449]  mempool_free+0xbe/0x110
  [   14.352449]  smb_direct_free_sendmsg+0xa0/0x380
  [   14.352449]  smb_direct_flush_send_list+0x411/0x660      <--
first free here
  [   14.352449]  smb_direct_post_send_data+0x1abb/0x2cf0
  [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
  [   14.352449]
  [   14.352449] The buggy address belongs to the object at ffff888009dc7280
  [   14.352449]  which belongs to the cache
smbdirect_send_io_pool_(____ptrval____) of size 208

This is immediately followed by the explicit double-free when the
caller attempts to return the same object to the mempool:

  [   14.382870] BUG: KASAN: double-free in mempool_free_slab+0x16/0x20
  [   14.382949] Free of addr ffff888009dc7280 by task kworker/1:0H/25
  [   14.383097]
  [   14.383097] CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Tainted: G
 B      O        7.0.0-rc7-00059-g3036cd0d3328 #10 PREEMPT(lazy)
  [   14.383143] Workqueue: ksmbd-smb_direct-wq smb_direct_send_immediate_work
  [   14.383171] Call Trace:
  [   14.383181]  <TASK>
  [   14.383192]  dump_stack_lvl+0x5f/0x80
  [   14.383211]  print_report+0xd1/0x640
  [   14.383278]  kasan_report_invalid_free+0xa4/0xd0
  [   14.383387]  check_slab_allocation+0xe2/0x110
  [   14.383387]  __kasan_slab_pre_free+0xd/0x20
  [   14.383387]  kmem_cache_free+0x90/0x3b0
  [   14.383387]  mempool_free_slab+0x16/0x20
  [   14.383387]  mempool_free+0xbe/0x110
  [   14.383387]  smb_direct_free_sendmsg+0xa0/0x380           <--
second free here
  [   14.383387]  smb_direct_post_send_data+0xf77/0x2cf0       <--
caller err path
  [   14.383387]  smb_direct_send_immediate_work+0x55/0x70
  [   14.383387]  process_one_work+0x635/0x10a0
  [   14.383387]  worker_thread+0x45b/0xc90
  [   14.383387]  kthread+0x2d7/0x3c0
  [   14.383387]  ret_from_fork+0x39f/0x5d0
  [   14.383387]  </TASK>
  [   14.383387]
  [   14.383387] Allocated by task 25:
  [   14.383387]  kmem_cache_alloc_noprof+0x109/0x380
  [   14.383387]  mempool_alloc_slab+0x14/0x20
  [   14.383387]  mempool_alloc_noprof+0x127/0x210
  [   14.383387]  smb_direct_post_send_data+0x308/0x2cf0
  [   14.383387]  smb_direct_send_immediate_work+0x55/0x70
  [   14.383387]
  [   14.383387] Freed by task 25:
  [   14.383387]  kmem_cache_free+0xb5/0x3b0
  [   14.383387]  mempool_free_slab+0x16/0x20
  [   14.383387]  mempool_free+0xbe/0x110
  [   14.383387]  smb_direct_free_sendmsg+0xa0/0x380
  [   14.383387]  smb_direct_flush_send_list+0x411/0x660       <--
flush freed it
  [   14.383387]  smb_direct_post_send_data+0x1abb/0x2cf0
  [   14.383387]  smb_direct_send_immediate_work+0x55/0x70

The "Freed by" stacks confirm the first free comes from
smb_direct_flush_send_list() and the second from the caller
smb_direct_post_send_data() at a different offset (+0xf77 vs +0x1abb),
matching the two distinct free sites described above.

Best,
- Ruikai Peng
