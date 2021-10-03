Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81877C433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5352C611EE
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhJCAON (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 20:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhJCAOM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 20:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CAE7611EE
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633219946;
        bh=/3fTwR7mWRtBlHK8BGqh7fP7kcmu2Sz6lrtWEb5bXcg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=H1pHK6IOWSlU6NYYtpm+akwTL7aGhzZuINO9tYuM6tLXsJrvZv5CZ3rJwKvMD0uqY
         2ske1YMfkm0PYWhBzLW0e6YcG+gRqFPePDkM4Ia8N+h7cvdY5kSzNwSx9ktyv1/ts+
         h3QzcT0rr+tAQwl9SQ2EoQ8te6S1w7lnPNyeEIJvdYzRLkgL1DBwBl7YY1680vhV6+
         Hjt+syqZlyls8Rk/imSItv90XaxX5r3NIY436ZnakxQN9mGQB64ac+vmSjiPfJBv7H
         2TFI0bJMzY7WODVoSsx7/cu4+C9bQvx55hKLiPuzAZMY0nUlamtNaHGXtlS0x/Uicc
         yHPxVjcU93w1Q==
Received: by mail-oi1-f181.google.com with SMTP id u22so16636713oie.5
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 17:12:26 -0700 (PDT)
X-Gm-Message-State: AOAM533TsCWhcni94WBeJRFj0X4aFA7ROdIDmAzq/eftwMqwDrtUkIf+
        PVaazcceB6WhV8DnjVv0mxkgksH3968NsstSImQ=
X-Google-Smtp-Source: ABdhPJwH7CL+Em2YhQmR42dOyk9+k1/LGUSMWQDUj+yncGF/36PPZqmoIUjQ/xSDEzJKAvZJzJqUaaB8LUgfcBE3ga4=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr9004379oib.167.1633219945862;
 Sat, 02 Oct 2021 17:12:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 17:12:25 -0700 (PDT)
In-Reply-To: <CAF6XXKV-WOYqRnhXj4qZePES+_nTSpXChw_aD9hSvwRQHs-qkA@mail.gmail.com>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org> <20210823151357.471691-11-brauner@kernel.org>
 <7ca65b4ef1806c914ffb3a199bccf5fe80cb4969.camel@freebox.fr>
 <CAKYAXd_dDyu2Q7Vf90vw2HHYNQpXOkKJZn8GD9Qz8PmG5ScQRA@mail.gmail.com> <CAF6XXKV-WOYqRnhXj4qZePES+_nTSpXChw_aD9hSvwRQHs-qkA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 09:12:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_rcfbyz+Q46H88mRouVJz_3W2F7j_4iXY7t+4Zc4_GWg@mail.gmail.com>
Message-ID: <CAKYAXd_rcfbyz+Q46H88mRouVJz_3W2F7j_4iXY7t+4Zc4_GWg@mail.gmail.com>
Subject: Re: [PATCH 10/11] ksmbd: remove setattr preparations in set_file_basic_info()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     Christian Brauner <brauner@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-03 4:29 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> On Sat, Oct 2, 2021 at 2:41 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> 2021-10-02 3:51 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
>> > On Mon, 2021-08-23 at 17:13 +0200, Christian Brauner wrote:
>> >> From: Christian Brauner <christian.brauner@ubuntu.com>
>> >>
>> >> Permission checking and copying over ownership information is the
>> >> task
>> >> of the underlying filesystem not ksmbd. The order is also wrong here.
>> >> This modifies the inode before notify_change(). If notify_change()
>> >> fails
>> >> this will have changed ownership nonetheless. All of this is
>> >> unnecessary
>> >> though since the underlying filesystem's ->setattr handler will do
>> >> all
>> >> this (if required) by itself.
>> >> Cc: Steve French <stfrench@microsoft.com>
>> >> Cc: Christoph Hellwig <hch@infradead.org>
>> >> Cc: Namjae Jeon <namjae.jeon@samsung.com>
>> >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> >> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>> >> Cc: linux-cifs@vger.kernel.org
>> >> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
>> >> ---
>> >>  fs/ksmbd/smb2pdu.c | 5 -----
>> >>  1 file changed, 5 deletions(-)
>> >>
>> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> index 1148e52a4037..059764753aaa 100644
>> >> --- a/fs/ksmbd/smb2pdu.c
>> >> +++ b/fs/ksmbd/smb2pdu.c
>> >> @@ -5521,12 +5521,7 @@ static int set_file_basic_info(struct
>> >> ksmbd_file *fp, char *buf,
>> >>              if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>> >>                      return -EACCES;
>> >>
>> >> -            rc = setattr_prepare(user_ns, dentry, &attrs);
>> >> -            if (rc)
>> >> -                    return -EINVAL;
>> >> -
>> >>              inode_lock(inode);
>> >> -            setattr_copy(user_ns, inode, &attrs);
>> >>              attrs.ia_valid &= ~ATTR_CTIME;
>> >>              rc = notify_change(user_ns, dentry, &attrs, NULL);
>> >>              inode_unlock(inode);
>> >
>> > Hello,
>> Hi Marios,
>> >
>> > With this change, rsync'ing a large directory (kernel repo checkout for
>> > example) to a FUSE-backed share crashes the kernel:
>> >
>> >  BUG: unable to handle page fault for address: fffffffffffffff8
>> >  #PF: supervisor write access in kernel mode
>> >  #PF: error_code(0x0002) - not-present page
>> >  PGD 3229067 P4D 3229067 PUD 322b067 PMD 0
>> >  Oops: 0002 [#1] SMP KASAN NOPTI
>> >  CPU: 0 PID: 55 Comm: kworker/u2:1 Not tainted 5.15.0-rc3+ #186
>> >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-
>> > 1ubuntu1.1 04/01/2014
>> >  Workqueue: writeback wb_workfn (flush-8:17-fuseblk)
>> >  RIP: 0010:fuse_file_get+0x26/0x50
>> >  Code: 00 0f 1f 00 0f 1f 44 00 00 41 56 53 48 89 fb 4c 8d 77 28 4c 89
>> > f7 be 04 00 00 00 e8 54 ad c1 ff be 01 00 00 00 b8 01 00 e
>> >  RSP: 0018:ffffc900001af660 EFLAGS: 00010256
>> >  RAX: 0000000000000001 RBX: ffffffffffffffd0 RCX: ffffffff818314cc
>> >  RDX: 0000000000000001 RSI: 0000000000000001 RDI: fffffffffffffff8
>> >  RBP: ffff8880108b0680 R08: dffffc0000000000 R09: fffffc0000000000
>> >  R10: fffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
>> >  R13: 0000000000020087 R14: fffffffffffffff8 R15: ffff8880108b0680
>> >  FS:  0000000000000000(0000) GS:ffff888036200000(0000)
>> > knlGS:0000000000000000
>> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >  CR2: fffffffffffffff8 CR3: 00000000101a4000 CR4: 00000000000006f0
>> >  Call Trace:
>> >   __fuse_write_file_get+0x4e/0x70
>> >   fuse_write_inode+0xf/0x40
>> >   __writeback_single_inode+0x206/0x250
>> >   writeback_sb_inodes+0x3fb/0x760
>> >   ? queue_io+0xd0/0xd0
>> >   ? trylock_super+0x17/0x60
>> >   ? __init_rwsem+0xf0/0xf0
>> >   ? rcu_read_lock_sched_held+0xa5/0x130
>> >   ? __bpf_trace_rcu_barrier+0x10/0x10
>> >   ? do_raw_spin_lock+0x14f/0x250
>> >   ? __bpf_trace_rcu_barrier+0x10/0x10
>> >   __writeback_inodes_wb+0xbf/0x130
>> >   wb_writeback+0x25b/0x360
>> >   ? print_irqtrace_events+0x110/0x110
>> >   ? trace_writeback_exec+0x150/0x150
>> >   ? _local_bh_enable+0x70/0x70
>> >   ? cpumask_next+0x20/0x50
>> >   ? cpumask_next+0x20/0x50
>> >   wb_workfn+0x608/0x860
>> >   ? __inode_wait_for_writeback+0x1c0/0x1c0
>> >   ? check_chain_key+0x1cf/0x2a0
>> >   ? __lock_acquire+0x9f4/0xdf0
>> >   ? lock_acquire+0x14d/0x370
>> >   ? process_one_work+0x2c5/0x550
>> >   ? lock_acquire+0x176/0x370
>> >   ? rcu_read_lock_sched_held+0xa5/0x130
>> >   ? __bpf_trace_rcu_barrier+0x10/0x10
>> >   ? lock_acquire+0x14d/0x370
>> >   ? worker_thread+0xf8/0x4a0
>> >   ? lock_acquire+0x176/0x370
>> >   process_one_work+0x304/0x550
>> >   ? worker_detach_from_pool+0x100/0x100
>> >   ? _raw_spin_lock_irq+0xaf/0xe0
>> >   ? _raw_spin_lock_irqsave+0xf0/0xf0
>> >   ? __list_add_valid+0x2a/0xa0
>> >   worker_thread+0x373/0x4a0
>> >   kthread+0x1d9/0x1f0
>> >   ? pr_cont_work+0xa0/0xa0
>> >   ? __list_add+0x50/0x50
>> >   ret_from_fork+0x1f/0x30
>> >  Modules linked in:
>> >  CR2: fffffffffffffff8
>> >  ---[ end trace fa4a96caf17482dd ]---
>> >
>> > $ ./scripts/faddr2line vmlinux.o fuse_file_get+0x26/0x50
>> > fuse_file_get+0x26/0x50:
>> > arch_atomic_fetch_add at arch/x86/include/asm/atomic.h:184
>> > (inlined by) atomic_fetch_add_relaxed at include/asm-generic/atomic-
>> > instrumented.h:143
>> > (inlined by) __refcount_add at include/linux/refcount.h:193
>> > (inlined by) __refcount_inc at include/linux/refcount.h:250
>> > (inlined by) refcount_inc at include/linux/refcount.h:267
>> > (inlined by) fuse_file_get at fs/fuse/file.c:93
>> >
>> > $ ./scripts/faddr2line vmlinux.o __fuse_write_file_get+0x4e/0x70
>> > __fuse_write_file_get+0x4e/0x70:
>> > __fuse_write_file_get at fs/fuse/file.c:1827
>> >
>> > I had already encountered this before [0]. Back then, changing ksmbd to
>> > use notify_change rather than mark_inode_dirty fixed the issue [1].
>> >
>> > Using ext4/xfs does not trigger the bug.
>> Thanks for your report and detailed check.
>> >
>> > rsync'ing the same folder over SMB (with samba4), or over NFS does not
>> > trigger the bug either. The only combination where I'm seeing this so
>> > far is ksmbd+FUSE, although I can't tell if it's a bug in ksmbd side or
>> > FUSE.
>>
>> Could you please check your issue is fixed with the following change ?
>
> Thanks for the quick reply. I did a few tests today and I can't reproduce
> the crash after applying the patch. Is mark_inode_dirty() not needed here ?
mark_inode_dirty() will be called in notify_change().
Thanks for your test! Will add your tested-by tag:)
>
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 4d1be224dd8e..e58a5a99d6ed 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -5483,7 +5483,6 @@ static int set_file_basic_info(struct ksmbd_file
>> *fp,
>>                                struct ksmbd_share_config *share)
>>  {
>>         struct iattr attrs;
>> -       struct timespec64 ctime;
>>         struct file *filp;
>>         struct inode *inode;
>>         struct user_namespace *user_ns;
>> @@ -5505,13 +5504,11 @@ static int set_file_basic_info(struct ksmbd_file
>> *fp,
>>                 attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
>>         }
>>
>> +       attrs.ia_valid |= ATTR_CTIME;
>>         if (file_info->ChangeTime) {
>>                 attrs.ia_ctime =
>> ksmbd_NTtimeToUnix(file_info->ChangeTime);
>> -               ctime = attrs.ia_ctime;
>> -               attrs.ia_valid |= ATTR_CTIME;
>> -       } else {
>> -               ctime = inode->i_ctime;
>> -       }
>> +       } else
>> +               attrs.ia_ctime = inode->i_ctime;
>>
>>         if (file_info->LastWriteTime) {
>>                 attrs.ia_mtime =
>> ksmbd_NTtimeToUnix(file_info->LastWriteTime);
>> @@ -5557,11 +5554,9 @@ static int set_file_basic_info(struct ksmbd_file
>> *fp,
>>                         return -EACCES;
>>
>>                 inode_lock(inode);
>> +               inode->i_ctime = attrs.ia_ctime;
>> +               attrs.ia_valid &= ~ATTR_CTIME;
>>                 rc = notify_change(user_ns, dentry, &attrs, NULL);
>> -               if (!rc) {
>> -                       inode->i_ctime = ctime;
>> -                       mark_inode_dirty(inode);
>> -               }
>>                 inode_unlock(inode);
>>         }
>>         return rc;
>> --
>> 2.25.1
>>
>> >
>> > Marios
>> >
>> > [0]
>> > https://lore.kernel.org/linux-fsdevel/CAF6XXKWCwqSa72p+iQjg4QSBmAkX4Y5DxGrRR1tW1ar2uthd=w@mail.gmail.com/T/#u
>> > [1]
>> > https://github.com/cifsd-team/ksmbd/commit/5e929125e519acaf48abc4c42f8389caa26c4d5a#diff-9f95c7d87d27c50e4e1d0afb24772b60bfa1449d619c118f23d7a2493d3ea9b0
>> >
>> >
>
