Return-Path: <SRS0=O+hx=3M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0838FC2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 20:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C3322522
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 20:20:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2SpqKzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAWUUf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jan 2020 15:20:35 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45580 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWUUf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jan 2020 15:20:35 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so3031456iln.12
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2020 12:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1+QB8+SLbpwmidiljGwpc6OtFRLxGqTygkV+uROWRCo=;
        b=d2SpqKzXkLlBrEMowPn/HVaN/mQRuMPbatbX44yMVoX8+vVnktLaJ42vKca7IgWLjc
         7DhVrucZoKBGyZ7+s2Oaalv/HUd2Zo3UHG3kihzmEkGLWGTcES1D6nL+u79qFQW8gxdJ
         uzwZ/eB56kUBmecgw+ZndTNGELM5OCCgS4lN52oM3OWwWvOKwZHS+ZkUs4uspJNXf/wL
         a/HG3Mwh2Nx90XlVE1BZpibMvEphRXyfAH/Y84aBup1suqVF86aP9ysrKP5i1vufNUYB
         zAfS4OS3sdvjXz8ClgZ9koS1APxt97ujmihCr96g2L9rpwVWW2NMnZWcKDFzeN3uXHXw
         VD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1+QB8+SLbpwmidiljGwpc6OtFRLxGqTygkV+uROWRCo=;
        b=iItVyxmByaC1vB7HP9FzNTESmFGV+77mc+JaXqNLRMtISueP/301Wox4E6ZrPQ0a9/
         O1Jw3IBrBbL4myxiB6LIhQT/pRBjORWx/ifcvsP6Dx4bb6pXmqD1COa5zvc/TtqSJKF9
         uqwbFEBQ217zxapSpPVIz/vUSQMxc2aVLxP6HOinRTNz3M4iA772xPqoHNgXIcRIdHAZ
         8KwGfRQqTz6cin7WHV+fTaXfDytxxp60k40lxWeLHW+Kshjsd98bsgKvaYBklJpVyRHC
         ZuE+ylzerGeqWN5u1hXwoBXTsKVjnEujOLLb1vUjaarI4nJQ2iSUmYbZ8PYZJBEiu/Qk
         PL+A==
X-Gm-Message-State: APjAAAW11RBqZCHjhPCOYamwIvLX/kaFRGLdO3wMiPLbcWlcr4XioUg9
        r1TzyyxLExv0sooi+PIeuggUoeTGhA4lTwZyu0/cBBw5
X-Google-Smtp-Source: APXvYqzHrnibVb1bPeJxvXuWqKrU9thTGigBm3U9ZTMTiPl+ra1o2oREE/m8Go7nEdE3omvJXjr+m+DAequGWdIDjGs=
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr14435550ili.173.1579810834332;
 Thu, 23 Jan 2020 12:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20200123160906.28498-1-vincent.whitchurch@axis.com>
In-Reply-To: <20200123160906.28498-1-vincent.whitchurch@axis.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Jan 2020 14:20:23 -0600
Message-ID: <CAH2r5muenAhXP-T2es_+NyaSJ2=C6v07Bu3HR_6_woXRDqP9ww@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix task struct use-after-free on reconnect
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, kernel@axis.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next (and added cc:stable)

On Thu, Jan 23, 2020 at 10:17 AM Vincent Whitchurch
<vincent.whitchurch@axis.com> wrote:
>
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
>         spin_unlock(&GlobalMid_Lock);
>         mutex_unlock(&server->srv_mutex);
>
>  +      msleep(10000);
>  +
>         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>         list_for_each_safe(tmp, tmp2, &retry_list) {
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
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
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 40705e862451..239338d57086 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1588,6 +1588,7 @@ struct mid_q_entry {
>         mid_callback_t *callback; /* call completion callback */
>         mid_handle_t *handle; /* call handle mid callback */
>         void *callback_data;      /* general purpose pointer for callback */
> +       struct task_struct *creator;
>         void *resp_buf;         /* pointer to received SMB header */
>         unsigned int resp_buf_size;
>         int mid_state;  /* wish this were enum but can not pass to wait_event */
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 387c88704c52..fe6acfce3390 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -685,6 +685,8 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
>          * The default is for the mid to be synchronous, so the
>          * default callback just wakes up the current task.
>          */
> +       get_task_struct(current);
> +       temp->creator = current;
>         temp->callback = cifs_wake_up_task;
>         temp->callback_data = current;
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 3d2e11f85cba..cb3ee916f527 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -76,6 +76,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
>          * The default is for the mid to be synchronous, so the
>          * default callback just wakes up the current task.
>          */
> +       get_task_struct(current);
> +       temp->creator = current;
>         temp->callback = cifs_wake_up_task;
>         temp->callback_data = current;
>
> @@ -158,6 +160,7 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
>                 }
>         }
>  #endif
> +       put_task_struct(midEntry->creator);
>
>         mempool_free(midEntry, cifs_mid_poolp);
>  }
> --
> 2.20.0
>


-- 
Thanks,

Steve
