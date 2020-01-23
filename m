Return-Path: <SRS0=O+hx=3M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D84C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 17:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF04214AF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 17:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="DZZmx/kh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAWRHh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jan 2020 12:07:37 -0500
Received: from mx.cjr.nz ([51.158.111.142]:20888 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgAWRHh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Jan 2020 12:07:37 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9E1C8808AB;
        Thu, 23 Jan 2020 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1579799254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FdVKPe1ze00BBbcvbfyG5WKDkK7bMCGNVh8nJMtWX/Y=;
        b=DZZmx/khxl0bQS+2WnY6R2aelZhbJ9KpgCOv0Hp60TOY5gZUBblnJH/0F44AvLS9UGw3dh
        gDilb5NvCTd4zrxPtDDRsTx8AmkUC3BDA74R2vQvgjgE7aInMDqlvIIz+Aw5YXlhx7DC1b
        NL3T4+KfvneU/DADXS6sAxkjtXP6O0js+rAf9AoxF+P8pJO2J4bm22akqMebBJpXgN6Yz8
        6qmluN6nSm20bNqRXG91ZVsyBmfzepXIJBuvJWTsISmWr8SzzCB10JYRy1D//g7+DAy0lU
        P74a2dldEkbEamius5N2jepU4TJdqDuoeNZYsgwgVkoCIhS/KuqkeDdLdo9a0w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, kernel@axis.com,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH] CIFS: Fix task struct use-after-free on reconnect
In-Reply-To: <20200123160906.28498-1-vincent.whitchurch@axis.com>
References: <20200123160906.28498-1-vincent.whitchurch@axis.com>
Date:   Thu, 23 Jan 2020 14:07:28 -0300
Message-ID: <87lfpyyucv.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Vincent Whitchurch <vincent.whitchurch@axis.com> writes:

> The task which created the MID may be gone by the time cifsd attempts to
> call the callbacks on MIDs from cifs_reconnect().
>
> This leads to a use-after-free of the task struct in cifs_wake_up_task:
>
>  ==================================================================
>  BUG: KASAN: use-after-free in __lock_acquire+0x31a0/0x3270
>  Read of size 8 at addr ffff8880103e3a68 by task cifsd/630
>
>  CPU: 0 PID: 630 Comm: cifsd Not tainted 5.5.0-rc6+ #119
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
>  Call Trace:
>   dump_stack+0x8e/0xcb
>   print_address_description.constprop.5+0x1d3/0x3c0
>   ? __lock_acquire+0x31a0/0x3270
>   __kasan_report+0x152/0x1aa
>   ? __lock_acquire+0x31a0/0x3270
>   ? __lock_acquire+0x31a0/0x3270
>   kasan_report+0xe/0x20
>   __lock_acquire+0x31a0/0x3270
>   ? __wake_up_common+0x1dc/0x630
>   ? _raw_spin_unlock_irqrestore+0x4c/0x60
>   ? mark_held_locks+0xf0/0xf0
>   ? _raw_spin_unlock_irqrestore+0x39/0x60
>   ? __wake_up_common_lock+0xd5/0x130
>   ? __wake_up_common+0x630/0x630
>   lock_acquire+0x13f/0x330
>   ? try_to_wake_up+0xa3/0x19e0
>   _raw_spin_lock_irqsave+0x38/0x50
>   ? try_to_wake_up+0xa3/0x19e0
>   try_to_wake_up+0xa3/0x19e0
>   ? cifs_compound_callback+0x178/0x210
>   ? set_cpus_allowed_ptr+0x10/0x10
>   cifs_reconnect+0xa1c/0x15d0
>   ? generic_ip_connect+0x1860/0x1860
>   ? rwlock_bug.part.0+0x90/0x90
>   cifs_readv_from_socket+0x479/0x690
>   cifs_read_from_socket+0x9d/0xe0
>   ? cifs_readv_from_socket+0x690/0x690
>   ? mempool_resize+0x690/0x690
>   ? rwlock_bug.part.0+0x90/0x90
>   ? memset+0x1f/0x40
>   ? allocate_buffers+0xff/0x340
>   cifs_demultiplex_thread+0x388/0x2a50
>   ? cifs_handle_standard+0x610/0x610
>   ? rcu_read_lock_held_common+0x120/0x120
>   ? mark_lock+0x11b/0xc00
>   ? __lock_acquire+0x14ed/0x3270
>   ? __kthread_parkme+0x78/0x100
>   ? lockdep_hardirqs_on+0x3e8/0x560
>   ? lock_downgrade+0x6a0/0x6a0
>   ? lockdep_hardirqs_on+0x3e8/0x560
>   ? _raw_spin_unlock_irqrestore+0x39/0x60
>   ? cifs_handle_standard+0x610/0x610
>   kthread+0x2bb/0x3a0
>   ? kthread_create_worker_on_cpu+0xc0/0xc0
>   ret_from_fork+0x3a/0x50
>
>  Allocated by task 649:
>   save_stack+0x19/0x70
>   __kasan_kmalloc.constprop.5+0xa6/0xf0
>   kmem_cache_alloc+0x107/0x320
>   copy_process+0x17bc/0x5370
>   _do_fork+0x103/0xbf0
>   __x64_sys_clone+0x168/0x1e0
>   do_syscall_64+0x9b/0xec0
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
>  Freed by task 0:
>   save_stack+0x19/0x70
>   __kasan_slab_free+0x11d/0x160
>   kmem_cache_free+0xb5/0x3d0
>   rcu_core+0x52f/0x1230
>   __do_softirq+0x24d/0x962
>
>  The buggy address belongs to the object at ffff8880103e32c0
>   which belongs to the cache task_struct of size 6016
>  The buggy address is located 1960 bytes inside of
>   6016-byte region [ffff8880103e32c0, ffff8880103e4a40)
>  The buggy address belongs to the page:
>  page:ffffea000040f800 refcount:1 mapcount:0 mapping:ffff8880108da5c0
>  index:0xffff8880103e4c00 compound_mapcount: 0
>  raw: 4000000000010200 ffffea00001f2208 ffffea00001e3408 ffff8880108da5c0
>  raw: ffff8880103e4c00 0000000000050003 00000001ffffffff 0000000000000000
>  page dumped because: kasan: bad access detected
>
>  Memory state around the buggy address:
>   ffff8880103e3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880103e3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  >ffff8880103e3a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                            ^
>   ffff8880103e3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880103e3b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ==================================================================
>
> This can be reliably reproduced by adding the below delay to
> cifs_reconnect(), running find(1) on the mount, restarting the samba
> server while find is running, and killing find during the delay:
>
>   	spin_unlock(&GlobalMid_Lock);
>   	mutex_unlock(&server->srv_mutex);
>
>  +	msleep(10000);
>  +
>   	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>   	list_for_each_safe(tmp, tmp2, &retry_list) {
>   		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>
> Fix this by holding a reference to the task struct until the MID is
> freed.
>
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
>  fs/cifs/cifsglob.h      | 1 +
>  fs/cifs/smb2transport.c | 2 ++
>  fs/cifs/transport.c     | 3 +++
>  3 files changed, 6 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Thanks,
Paulo
