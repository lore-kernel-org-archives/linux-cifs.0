From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: lockdep spew with Pavel's for-next branch
Date: Mon, 10 Sep 2012 15:55:15 +0400
Message-ID: <CAKywueShjat=5NH9D-ughbV22W1i8QEHnsE7Xf3L_bBpJ7oX8A@mail.gmail.com>
References: <20120905100514.175aa792@tlielax.poochiereds.net>
	<CAKywueSO2rSpHsRsSwq1A2MPAsM4rSBYC69ZtqEMAUfM-FdBiQ@mail.gmail.com>
	<20120907090534.65c0827c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120907090534.65c0827c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/9/7 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 6 Sep 2012 18:34:45 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2012/9/5 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > I got the following lockdep pop when testing a few patches on top of
>> > Pavel's for-next branch. The relevant mount options were:
>> >
>> >     vers=1.0,cache=strict,nounix
>> >
>> > The test that caused it to pop was connectathon test5 (the read/write
>> > test).
>> >
>> > I haven't yet done any investigation but it looks like a plausible
>> > deadlock possibility. Also, fwiw -- the test7 regression that I
>> > reported earlier seems to have gone away for now. No idea why.
>> >
>> > Anyway, here's the lockdep spew:
>> >
>> > [ 1732.096609] ======================================================
>> > [ 1732.096609] [ INFO: possible circular locking dependency detected ]
>> > [ 1732.096609] 3.6.0-0.rc4.git0.1.fc18.x86_64.debug #1 Tainted: G           O
>> > [ 1732.096609] -------------------------------------------------------
>> > [ 1732.096609] test5/7374 is trying to acquire lock:
>> > [ 1732.096609]  (sb_writers#13){.+.+.+}, at: [<ffffffff8115edd3>] generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]
>> > [ 1732.096609] but task is already holding lock:
>> > [ 1732.096609]  (&cifsi->lock_sem){+++++.}, at: [<ffffffffa02b61fc>] cifs_strict_writev+0xcc/0x1b0 [cifs]
>> > [ 1732.096609]
>> > [ 1732.096609] which lock already depends on the new lock.
>> > [ 1732.096609]
>> > [ 1732.096609]
>> > [ 1732.096609] the existing dependency chain (in reverse order) is:
>> > [ 1732.096609]
>> > [ 1732.096609] -> #1 (&cifsi->lock_sem){+++++.}:
>> > [ 1732.096609]        [<ffffffff810d5d91>] lock_acquire+0xa1/0x1f0
>> > [ 1732.096609]        [<ffffffff816d8721>] down_write+0x61/0xb0
>> > [ 1732.096609]        [<ffffffffa02b1c8d>] cifs_new_fileinfo+0xbd/0x2e0 [cifs]
>> > [ 1732.096609]        [<ffffffffa02b2217>] cifs_open+0x327/0x760 [cifs]
>> > [ 1732.096609]        [<ffffffff811cb923>] do_dentry_open+0x263/0x310
>> > [ 1732.096609]        [<ffffffff811cba1b>] finish_open+0x4b/0x70
>> > [ 1732.096609]        [<ffffffff811deace>] do_last+0x6de/0xe00
>> > [ 1732.096609]        [<ffffffff811df2ad>] path_openat+0xbd/0x500
>> > [ 1732.096609]        [<ffffffff811dfcc1>] do_filp_open+0x41/0xa0
>> > [ 1732.096609]        [<ffffffff811ccdc6>] do_sys_open+0xf6/0x1e0
>> > [ 1732.096609]        [<ffffffff811cced1>] sys_open+0x21/0x30
>> > [ 1732.096609]        [<ffffffff816e42a9>] system_call_fastpath+0x16/0x1b
>> > [ 1732.096609]
>> > [ 1732.096609] -> #0 (sb_writers#13){.+.+.+}:
>> > [ 1732.096609]        [<ffffffff810d4f52>] __lock_acquire+0x1372/0x1ad0
>> > [ 1732.096609]        [<ffffffff810d5d91>] lock_acquire+0xa1/0x1f0
>> > [ 1732.096609]        [<ffffffff811d0b87>] __sb_start_write+0xd7/0x1d0
>> > [ 1732.096609]        [<ffffffff8115edd3>] generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]        [<ffffffffa02b6299>] cifs_strict_writev+0x169/0x1b0 [cifs]
>> > [ 1732.096609]        [<ffffffff811cd137>] do_sync_write+0xa7/0xe0
>> > [ 1732.096609]        [<ffffffff811cda2f>] vfs_write+0xaf/0x190
>> > [ 1732.096609]        [<ffffffff811cdd6d>] sys_write+0x4d/0x90
>> > [ 1732.096609]        [<ffffffff816e42a9>] system_call_fastpath+0x16/0x1b
>> > [ 1732.096609]
>> > [ 1732.096609] other info that might help us debug this:
>> > [ 1732.096609]
>> > [ 1732.096609]  Possible unsafe locking scenario:
>> > [ 1732.096609]
>> > [ 1732.096609]        CPU0                    CPU1
>> > [ 1732.096609]        ----                    ----
>> > [ 1732.096609]   lock(&cifsi->lock_sem);
>> > [ 1732.096609]                                lock(sb_writers#13);
>> > [ 1732.096609]                                lock(&cifsi->lock_sem);
>> > [ 1732.096609]   lock(sb_writers#13);
>> > [ 1732.096609]
>> > [ 1732.096609]  *** DEADLOCK ***
>> > [ 1732.096609]
>> > [ 1732.096609] 1 lock held by test5/7374:
>> > [ 1732.096609]  #0:  (&cifsi->lock_sem){+++++.}, at: [<ffffffffa02b61fc>] cifs_strict_writev+0xcc/0x1b0 [cifs]
>> > [ 1732.096609]
>> > [ 1732.096609] stack backtrace:
>> > [ 1732.096609] Pid: 7374, comm: test5 Tainted: G           O 3.6.0-0.rc4.git0.1.fc18.x86_64.debug #1
>> > [ 1732.096609] Call Trace:
>> > [ 1732.096609]  [<ffffffff816cf0b4>] print_circular_bug+0x1fb/0x20c
>> > [ 1732.096609]  [<ffffffff810d4f52>] __lock_acquire+0x1372/0x1ad0
>> > [ 1732.096609]  [<ffffffff8104aee2>] ? kvm_clock_read+0x32/0x40
>> > [ 1732.096609]  [<ffffffff81021e39>] ? sched_clock+0x9/0x10
>> > [ 1732.096609]  [<ffffffff810ac295>] ? sched_clock_local+0x25/0xa0
>> > [ 1732.096609]  [<ffffffff810d5d91>] lock_acquire+0xa1/0x1f0
>> > [ 1732.096609]  [<ffffffff8115edd3>] ? generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]  [<ffffffff811d0b87>] __sb_start_write+0xd7/0x1d0
>> > [ 1732.096609]  [<ffffffff8115edd3>] ? generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]  [<ffffffff8115edd3>] ? generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]  [<ffffffff8115edd3>] generic_file_aio_write+0x63/0x100
>> > [ 1732.096609]  [<ffffffffa02b6299>] cifs_strict_writev+0x169/0x1b0 [cifs]
>> > [ 1732.096609]  [<ffffffff811cd137>] do_sync_write+0xa7/0xe0
>> > [ 1732.096609]  [<ffffffff811cda2f>] vfs_write+0xaf/0x190
>> > [ 1732.096609]  [<ffffffff811cdd6d>] sys_write+0x4d/0x90
>> > [ 1732.096609]  [<ffffffff816e42a9>] system_call_fastpath+0x16/0x1b
>> >
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> I think we can replace generic_file_aio_write call here with something
>> like cifs_generic_aio_write that is almost the same as
>> generic_file_aio_write but with up_read(&cinode->lock_sem) after
>> sb_start_write and down_read(&cinode->lock_sem) before sb_end_write -
>> to make locking in the same order:
>>
>> 1) sb_writers
>> 2) lock_sem
>>
>> thoughts?
>>
>
> I don't know. I don't have a good feeling about this whole lock_sem
> idea at all. It seems like a huge swath of this code is now running
> under it.
>
> That's not good from a performance standpoint for one thing. It may
> also lead to subtle bugs later when we make changes to this code. Parts
> of it are now being serialized that may not need to be. If that
> serialization is later removed, it could have "interesting" effects.
>
> I'm not sure what would work better however...
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Fixed the problem (by reordering lock obtaining) and updated my for-next branch.

-- 
Best regards,
Pavel Shilovsky.
