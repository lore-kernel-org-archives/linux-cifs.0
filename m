Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E62DEA75
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649532; cv=none; b=TABfcGLdERqOdKUHTjtdcowGnGgboJj54r+HoJ5rJ/VLqM77mGSdzMzWqmOQ4UFh41T0tkNW5NyERLnYAHiMrkOubQKXFHoFdxVrDpFEOcKUhBBwtMEWRHBurRKiz5VUpDyS7ffMN+erBH2kWVfuNEOYYGG5cF6xqb5ybWyk0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649532; c=relaxed/simple;
	bh=aAn0Os1N590Ftuam2ZAHDH6gc3gnX/ziCaudC7L0Htg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZ7jg3S2d1O384Uu2DdESfRUP+pHGgVydR/fLIZbKxkK/gBwjFyhai02sPZP52W/TbclZKEF1qosra9hK/5aOryn5lVNEFLrajthszgThFEJSV/gN0ivyjZhWrWYDtly/GEPJvb3Mn7I5Sabn0DEfGrEYQPb+t4KHhJXz5XySoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2n2s2jgp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2n2s2jgp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=+NMDacEd7QGB4H33ox7SaCdPpnu9a1iUT/u7dXT9CIU=; b=2n2s2jgp8QehULpZCPj+lSP8pZ
	57uz2hKoiGWDbKDK0GHXRg3E0cxQyz//ZkHgP4Pbc1rOWHlHOShlOx6DRxFB98lyjDMWb25wDd6NJ
	52GpkZu+lyRieJBfV2D0ZLF1qr3BUFodM+p26JoZE5Y8Xey06fP8ReH0j526jJ9l1g7F7EoWUmvo1
	2gJ0uVzhjyBmOjhKVqevIBZISTMYhZZPIZ9WRwN8jD9ehFPTwHlJ0th6Hq5bny30DpKKaM2UjY4fU
	T0kRyjQQSLMVNVmvBdd691pweEY8m/Nim+vqslbF8h3WWg9NladdpQkMi9rCAuCzx8KVoKq7g3TO4
	gUJdfIsJU8YJ/PU4oPObEILdZVyQOHnCjv+49MHbqj3FK4b25pWBy2iaxRDkgcGRoWpK8ckDO48+M
	beBiAOvBwHOu0rCRDeCug9BvZDxlvK7pija27mOlp/KSD8FdShPLACqgmMzPYE2czeWpwskn9qjmK
	F4Qt4NIv+P8hFyaNYv+ibS5C;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wARYW-00000007qGH-0QM6;
	Wed, 08 Apr 2026 11:58:48 +0000
Message-ID: <38cfe7f7-f2a1-4544-a61e-2f3efd0d71c6@samba.org>
Date: Wed, 8 Apr 2026 13:58:47 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Ruikai Peng <ruikai@pwno.io>, linkinjeon@kernel.org, sfrench@samba.org,
 senozhatsky@chromium.org, tom@talpey.com
Cc: security@kernel.org, pc@manguebit.org, linux-cifs@vger.kernel.org
References: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0DivhxQ_pcc7immVVOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ruikai,

thanks for the report I'll have a deeper look.

metze

> The send batching logic introduced in the v7.0 merge window has a
> double-free of mempool-backed send message objects when ib_post_send()
> fails during a batch flush. The bug affects both the client
> (fs/smb/client/smbdirect.c) and server (fs/smb/server/transport_rdma.c)
> SMB Direct implementations. It is present on current upstream HEAD
> (v7.0-rc7+).
> 
> The batch flush helpers (smbd_send_batch_flush and
> smb_direct_flush_send_list) take ownership of the batched send
> messages and free them on ib_post_send() failure:
> 
>    fs/smb/server/transport_rdma.c, smb_direct_flush_send_list():
> 
>      ret = smb_direct_post_send(sc, &first->wr);
>      if (ret) {
>          list_for_each_entry_safe(sibling, ...) {
>              smb_direct_free_sendmsg(sc, sibling);
>          }
>          smb_direct_free_sendmsg(sc, last);
>      }
> 
> However, the callers (smb_direct_post_send_data and
> smbd_post_send_iter) have a generic error path that frees the same
> message unconditionally:
> 
>    fs/smb/server/transport_rdma.c, smb_direct_post_send_data():
> 
>      ret = smb_direct_flush_send_list(sc, send_ctx, true);
>      if (ret)
>          goto err;
>      ...
>    err:
>      smb_direct_free_sendmsg(sc, msg);
> 
> This double-free occurs specifically when using the stack-allocated
> local batch for single-message sends, since in that case the caller
> immediately flushes and then falls through to the same err label.
> 
> The same pattern exists on the client side:
> 
>    fs/smb/client/smbdirect.c, smbd_post_send_iter():
> 
>      rc = smbd_send_batch_flush(sc, batch, true);
>      if (!rc)
>          return 0;
>      ...
>    err_dma:
>      smbd_free_send_io(request);
> 
> A remote peer can trigger ib_post_send() failures by tearing down the
> RDMA connection or forcing the QP into an error state during active
> sending. This results in:
> 
>    - Kernel heap double-free of mempool-backed send_io objects
>    - Use-after-free from subsequent RDMA completion processing
>    - Potential memory corruption
> 
> This requires an SMB Direct (RDMA) configuration and an attacker
> capable of disrupting the RDMA connection.
> 
> I reproduced this deterministically using paired QEMU guests with
> RXE soft-RDMA, a ksmbd share mounted over SMB Direct, and a
> kretprobe-based fault injection module that forces
> smb_direct_post_send() to return -EIO. KASAN reports a double-free
> in mempool_free_slab and follow-on slab-use-after-free splats.
> 
> The first splat is a use-after-free when the caller's error path
> touches the object that the flush helper already freed:
> 
>    [   14.352449] BUG: KASAN: slab-use-after-free in
> smb_direct_free_sendmsg+0x31f/0x380
>    [   14.352449] Read of size 8 at addr ffff888009dc72f8 by task kworker/1:0H/25
>    [   14.352449]
>    [   14.352449] CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Tainted: G
>          O        7.0.0-rc7-00059-g3036cd0d3328 #10 PREEMPT(lazy)
>    [   14.352449] Workqueue: ksmbd-smb_direct-wq smb_direct_send_immediate_work
>    [   14.352449] Call Trace:
>    [   14.352449]  <TASK>
>    [   14.352449]  dump_stack_lvl+0x5f/0x80
>    [   14.352449]  print_report+0xd1/0x640
>    [   14.352449]  kasan_report+0xe5/0x120
>    [   14.352449]  smb_direct_free_sendmsg+0x31f/0x380
>    [   14.352449]  smb_direct_post_send_data+0xf77/0x2cf0
>    [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
>    [   14.352449]  process_one_work+0x635/0x10a0
>    [   14.352449]  worker_thread+0x45b/0xc90
>    [   14.352449]  kthread+0x2d7/0x3c0
>    [   14.352449]  ret_from_fork+0x39f/0x5d0
>    [   14.352449]  </TASK>
>    [   14.352449]
>    [   14.352449] Allocated by task 25:
>    [   14.352449]  kmem_cache_alloc_noprof+0x109/0x380
>    [   14.352449]  mempool_alloc_slab+0x14/0x20
>    [   14.352449]  mempool_alloc_noprof+0x127/0x210
>    [   14.352449]  smb_direct_post_send_data+0x308/0x2cf0
>    [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
>    [   14.352449]
>    [   14.352449] Freed by task 25:
>    [   14.352449]  kmem_cache_free+0xb5/0x3b0
>    [   14.352449]  mempool_free_slab+0x16/0x20
>    [   14.352449]  mempool_free+0xbe/0x110
>    [   14.352449]  smb_direct_free_sendmsg+0xa0/0x380
>    [   14.352449]  smb_direct_flush_send_list+0x411/0x660      <--
> first free here
>    [   14.352449]  smb_direct_post_send_data+0x1abb/0x2cf0
>    [   14.352449]  smb_direct_send_immediate_work+0x55/0x70
>    [   14.352449]
>    [   14.352449] The buggy address belongs to the object at ffff888009dc7280
>    [   14.352449]  which belongs to the cache
> smbdirect_send_io_pool_(____ptrval____) of size 208
> 
> This is immediately followed by the explicit double-free when the
> caller attempts to return the same object to the mempool:
> 
>    [   14.382870] BUG: KASAN: double-free in mempool_free_slab+0x16/0x20
>    [   14.382949] Free of addr ffff888009dc7280 by task kworker/1:0H/25
>    [   14.383097]
>    [   14.383097] CPU: 1 UID: 0 PID: 25 Comm: kworker/1:0H Tainted: G
>   B      O        7.0.0-rc7-00059-g3036cd0d3328 #10 PREEMPT(lazy)
>    [   14.383143] Workqueue: ksmbd-smb_direct-wq smb_direct_send_immediate_work
>    [   14.383171] Call Trace:
>    [   14.383181]  <TASK>
>    [   14.383192]  dump_stack_lvl+0x5f/0x80
>    [   14.383211]  print_report+0xd1/0x640
>    [   14.383278]  kasan_report_invalid_free+0xa4/0xd0
>    [   14.383387]  check_slab_allocation+0xe2/0x110
>    [   14.383387]  __kasan_slab_pre_free+0xd/0x20
>    [   14.383387]  kmem_cache_free+0x90/0x3b0
>    [   14.383387]  mempool_free_slab+0x16/0x20
>    [   14.383387]  mempool_free+0xbe/0x110
>    [   14.383387]  smb_direct_free_sendmsg+0xa0/0x380           <--
> second free here
>    [   14.383387]  smb_direct_post_send_data+0xf77/0x2cf0       <--
> caller err path
>    [   14.383387]  smb_direct_send_immediate_work+0x55/0x70
>    [   14.383387]  process_one_work+0x635/0x10a0
>    [   14.383387]  worker_thread+0x45b/0xc90
>    [   14.383387]  kthread+0x2d7/0x3c0
>    [   14.383387]  ret_from_fork+0x39f/0x5d0
>    [   14.383387]  </TASK>
>    [   14.383387]
>    [   14.383387] Allocated by task 25:
>    [   14.383387]  kmem_cache_alloc_noprof+0x109/0x380
>    [   14.383387]  mempool_alloc_slab+0x14/0x20
>    [   14.383387]  mempool_alloc_noprof+0x127/0x210
>    [   14.383387]  smb_direct_post_send_data+0x308/0x2cf0
>    [   14.383387]  smb_direct_send_immediate_work+0x55/0x70
>    [   14.383387]
>    [   14.383387] Freed by task 25:
>    [   14.383387]  kmem_cache_free+0xb5/0x3b0
>    [   14.383387]  mempool_free_slab+0x16/0x20
>    [   14.383387]  mempool_free+0xbe/0x110
>    [   14.383387]  smb_direct_free_sendmsg+0xa0/0x380
>    [   14.383387]  smb_direct_flush_send_list+0x411/0x660       <--
> flush freed it
>    [   14.383387]  smb_direct_post_send_data+0x1abb/0x2cf0
>    [   14.383387]  smb_direct_send_immediate_work+0x55/0x70
> 
> The "Freed by" stacks confirm the first free comes from
> smb_direct_flush_send_list() and the second from the caller
> smb_direct_post_send_data() at a different offset (+0xf77 vs +0x1abb),
> matching the two distinct free sites described above.
> 
> Best,
> - Ruikai Peng

