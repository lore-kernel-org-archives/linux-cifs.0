Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5010FC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 18:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F0F660F6D
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 18:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhJASxa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 14:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJASxa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 14:53:30 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE34EC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 11:51:45 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so12041795wmc.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 11:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gRhqt7QPM/bSHD0dPz5FH9MmcNTorv4tNJnpb6SVd4w=;
        b=SGbEg2OlNTWmjcutC1ox3V7U0DL54CfYKPoE5lyLyE68pYFyEhwwCxhZY9O03BDN4j
         OU0kU2xEHbugp25Ti0/x9G4XFABQ6v8g1mm4h3lTHKN7xsKque7Od7sBZXhIK6q9klai
         Ft/9O+nyl+9WWMeLO2UcHqXn7oih7lFAoEd0vbfPr4LVo9+TiE2ELRT383xGIia1L+Zc
         IzeXpLUHgSeftSnTEE5JDrdcsdhqSOw42YE0PXSi9LiToHH7ZBSGz3nB28YsAiYQdoS8
         Z8wxl38Vx9zLn83mpImKrqczrMzkiz538C482mryPSGNRTcID60CUjUAHZzp6TUGzfPK
         DvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gRhqt7QPM/bSHD0dPz5FH9MmcNTorv4tNJnpb6SVd4w=;
        b=BvvHrO/gEK/qGSPGj8CTvscq524RSuYMUzqX1vmJg7zJssDcoe4DALOgA4piIRTW4C
         dPonDsbktPqU0CZ2Umb4IkYD6a38qqLBl22obRu+S70BjFRKVZw2nqMLxfo2p1uM3UpQ
         7wuqXn+59lc4zIHSVnWHNYGDBIFAl3+Y5E8MsqLJcXVBaMA8l+90DgchU0zaECq+nteC
         +uMNRs54Y6nyx/UgLgZsXjWfyS3NxhqeKTTtSbjAGF3jJK1pTXJ1ZKuigyQgTus687z8
         wUFF5qqgI6Y5A7Yd9xZ+f9KlpGMlyqEQk1maWLh3fKSMCuFipe7Y6p7Iwe+DDaDFb8V3
         Cuag==
X-Gm-Message-State: AOAM533dYUhTciiufd4qaok9gOi1Mo4XZpQWkmSkkGlIkA0H6vXxTD2H
        xwtz0Nl/cajOx6uJYjT4lFQG3A==
X-Google-Smtp-Source: ABdhPJwxBEo+qpsNxeWKfXXtO7u0zF482GFa4Q0cfxJOgsBh8b0YUUGmhI3A12DH2XJdcaDsC/OMrg==
X-Received: by 2002:a7b:cc0d:: with SMTP id f13mr5880737wmh.85.1633114304088;
        Fri, 01 Oct 2021 11:51:44 -0700 (PDT)
Received: from [192.168.108.49] (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id g21sm6344145wmk.10.2021.10.01.11.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:51:43 -0700 (PDT)
Message-ID: <7ca65b4ef1806c914ffb3a199bccf5fe80cb4969.camel@freebox.fr>
Subject: Re: [PATCH 10/11] ksmbd: remove setattr preparations in
 set_file_basic_info()
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     Christian Brauner <brauner@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Date:   Fri, 01 Oct 2021 20:51:42 +0200
In-Reply-To: <20210823151357.471691-11-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
         <20210823151357.471691-1-brauner@kernel.org>
         <20210823151357.471691-11-brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 2021-08-23 at 17:13 +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Permission checking and copying over ownership information is the
> task
> of the underlying filesystem not ksmbd. The order is also wrong here.
> This modifies the inode before notify_change(). If notify_change()
> fails
> this will have changed ownership nonetheless. All of this is
> unnecessary
> though since the underlying filesystem's ->setattr handler will do
> all
> this (if required) by itself.
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ksmbd/smb2pdu.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 1148e52a4037..059764753aaa 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -5521,12 +5521,7 @@ static int set_file_basic_info(struct
> ksmbd_file *fp, char *buf,
>  		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  			return -EACCES;
>  
> -		rc = setattr_prepare(user_ns, dentry, &attrs);
> -		if (rc)
> -			return -EINVAL;
> -
>  		inode_lock(inode);
> -		setattr_copy(user_ns, inode, &attrs);
>  		attrs.ia_valid &= ~ATTR_CTIME;
>  		rc = notify_change(user_ns, dentry, &attrs, NULL);
>  		inode_unlock(inode);

Hello,

With this change, rsync'ing a large directory (kernel repo checkout for
example) to a FUSE-backed share crashes the kernel:

 BUG: unable to handle page fault for address: fffffffffffffff8
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 3229067 P4D 3229067 PUD 322b067 PMD 0
 Oops: 0002 [#1] SMP KASAN NOPTI
 CPU: 0 PID: 55 Comm: kworker/u2:1 Not tainted 5.15.0-rc3+ #186
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-
1ubuntu1.1 04/01/2014
 Workqueue: writeback wb_workfn (flush-8:17-fuseblk)
 RIP: 0010:fuse_file_get+0x26/0x50
 Code: 00 0f 1f 00 0f 1f 44 00 00 41 56 53 48 89 fb 4c 8d 77 28 4c 89
f7 be 04 00 00 00 e8 54 ad c1 ff be 01 00 00 00 b8 01 00 e
 RSP: 0018:ffffc900001af660 EFLAGS: 00010256
 RAX: 0000000000000001 RBX: ffffffffffffffd0 RCX: ffffffff818314cc
 RDX: 0000000000000001 RSI: 0000000000000001 RDI: fffffffffffffff8
 RBP: ffff8880108b0680 R08: dffffc0000000000 R09: fffffc0000000000
 R10: fffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000020087 R14: fffffffffffffff8 R15: ffff8880108b0680
 FS:  0000000000000000(0000) GS:ffff888036200000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: fffffffffffffff8 CR3: 00000000101a4000 CR4: 00000000000006f0
 Call Trace:
  __fuse_write_file_get+0x4e/0x70
  fuse_write_inode+0xf/0x40
  __writeback_single_inode+0x206/0x250
  writeback_sb_inodes+0x3fb/0x760
  ? queue_io+0xd0/0xd0
  ? trylock_super+0x17/0x60
  ? __init_rwsem+0xf0/0xf0
  ? rcu_read_lock_sched_held+0xa5/0x130
  ? __bpf_trace_rcu_barrier+0x10/0x10
  ? do_raw_spin_lock+0x14f/0x250
  ? __bpf_trace_rcu_barrier+0x10/0x10
  __writeback_inodes_wb+0xbf/0x130
  wb_writeback+0x25b/0x360
  ? print_irqtrace_events+0x110/0x110
  ? trace_writeback_exec+0x150/0x150
  ? _local_bh_enable+0x70/0x70
  ? cpumask_next+0x20/0x50
  ? cpumask_next+0x20/0x50
  wb_workfn+0x608/0x860
  ? __inode_wait_for_writeback+0x1c0/0x1c0
  ? check_chain_key+0x1cf/0x2a0
  ? __lock_acquire+0x9f4/0xdf0
  ? lock_acquire+0x14d/0x370
  ? process_one_work+0x2c5/0x550
  ? lock_acquire+0x176/0x370
  ? rcu_read_lock_sched_held+0xa5/0x130
  ? __bpf_trace_rcu_barrier+0x10/0x10
  ? lock_acquire+0x14d/0x370
  ? worker_thread+0xf8/0x4a0
  ? lock_acquire+0x176/0x370
  process_one_work+0x304/0x550
  ? worker_detach_from_pool+0x100/0x100
  ? _raw_spin_lock_irq+0xaf/0xe0
  ? _raw_spin_lock_irqsave+0xf0/0xf0
  ? __list_add_valid+0x2a/0xa0
  worker_thread+0x373/0x4a0
  kthread+0x1d9/0x1f0
  ? pr_cont_work+0xa0/0xa0
  ? __list_add+0x50/0x50
  ret_from_fork+0x1f/0x30
 Modules linked in:
 CR2: fffffffffffffff8
 ---[ end trace fa4a96caf17482dd ]---

$ ./scripts/faddr2line vmlinux.o fuse_file_get+0x26/0x50
fuse_file_get+0x26/0x50:
arch_atomic_fetch_add at arch/x86/include/asm/atomic.h:184
(inlined by) atomic_fetch_add_relaxed at include/asm-generic/atomic-
instrumented.h:143
(inlined by) __refcount_add at include/linux/refcount.h:193
(inlined by) __refcount_inc at include/linux/refcount.h:250
(inlined by) refcount_inc at include/linux/refcount.h:267
(inlined by) fuse_file_get at fs/fuse/file.c:93

$ ./scripts/faddr2line vmlinux.o __fuse_write_file_get+0x4e/0x70
__fuse_write_file_get+0x4e/0x70:
__fuse_write_file_get at fs/fuse/file.c:1827

I had already encountered this before [0]. Back then, changing ksmbd to
use notify_change rather than mark_inode_dirty fixed the issue [1].

Using ext4/xfs does not trigger the bug.

rsync'ing the same folder over SMB (with samba4), or over NFS does not
trigger the bug either. The only combination where I'm seeing this so
far is ksmbd+FUSE, although I can't tell if it's a bug in ksmbd side or
FUSE.

Marios

[0] 
https://lore.kernel.org/linux-fsdevel/CAF6XXKWCwqSa72p+iQjg4QSBmAkX4Y5DxGrRR1tW1ar2uthd=w@mail.gmail.com/T/#u
[1] 
https://github.com/cifsd-team/ksmbd/commit/5e929125e519acaf48abc4c42f8389caa26c4d5a#diff-9f95c7d87d27c50e4e1d0afb24772b60bfa1449d619c118f23d7a2493d3ea9b0

