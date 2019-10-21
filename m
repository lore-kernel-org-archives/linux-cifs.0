Return-Path: <SRS0=SN/X=YO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69535CA9EAF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 22:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EF622086D
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 22:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yg1PC0wI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfJUWTY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Oct 2019 18:19:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36542 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJUWTY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Oct 2019 18:19:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id u16so11400058lfq.3
        for <linux-cifs@vger.kernel.org>; Mon, 21 Oct 2019 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GxTS14rknA/wNbiUEQVCVIuqL/3vJMQlrdT1dInDiy4=;
        b=Yg1PC0wIxn8LFuXyt17+v6fp4TR47mMGHMfw+9Bgevs7U/dnFbegyoEj+KPAEdktMV
         Hhz78LJ5Dv3PpkbxTZSBJohHWK3DvwLz+jh1rJlBvSFCl+m0Btiu373sUiy4KRSkmzdu
         AieDxG3bxDQJs6BCeJfsvwwdhLaMo5OTTq6vdi/L4ZNvj1AEssArvjCaLRO45WY2/wJe
         OdcQqy/4fHWYq+55YZuWIW7xITHXoy5k7LO7etXOK/RGx8n+Z9QDFilv4TdN6xMzSOw/
         IUF2Byl3uA1AfynyXAQksWcvBtiNL9Jg4SD5WFCg/9wsMZarQJXYFa6gUbbNijN9mPd1
         TNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GxTS14rknA/wNbiUEQVCVIuqL/3vJMQlrdT1dInDiy4=;
        b=daQW8Ky2vvJa6qXpjQLA24OCICRtLFKftTJ+bPkWodlItPwEojbW/pCfYo3JnxHFCp
         QrsFpjJNqAh7ejsY/FMY1D276RwaOOiF1BP89HuVFiUpaCPFTnTjGls27UjLL92n0IM6
         roi+uJ0in265JNO6peqZfB0VKGUVLvYFb85sX3K+UKnMHaO+tBOxjzr6Q4FR85K0DaWs
         KeF7H8HpTRrA1rpT2MP4/cTphGEXJ6VVJ1vNqHqDuOuREvwpXelDWsai6BcV7q3Sz6AV
         p4OPUh4TMXLE0jBOfRCkP6AZRwmisFmmIn04KmOgsw7QDyBuM94UpbwRNhy2rXs3p/eu
         ghNQ==
X-Gm-Message-State: APjAAAXOgR8oNLBXUYmmVIB2OlXNmv5XKbUZK7WDoMim6/GvVaM9t6YW
        /Fp5hUogjRfaLFPY5DYussmeWRHWg45ppoqbTg==
X-Google-Smtp-Source: APXvYqyLZXPrct4YqStALlIUgXyQ+pHZ2H9UnZCl7zEuNd7oU4LB4lVEQnDLI6FxmqjAC9fS90XrebsQG7St2T5vrcU=
X-Received: by 2002:ac2:5de1:: with SMTP id z1mr12869448lfq.36.1571696361548;
 Mon, 21 Oct 2019 15:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
In-Reply-To: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 21 Oct 2019 15:19:10 -0700
Message-ID: <CAKywueQRnmAuXJq+5ZER3ir6BhUgNFaaFCG6aZE7ep=qe=qbmQ@mail.gmail.com>
Subject: Re: Easily reproducible deadlock on 5.4-rc4 with cifsInodeInfo.lock_sem
 semaphore after network disruption or smb restart
To:     David Wysochanski <dwysocha@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 21 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 10:23, David Wysoc=
hanski <dwysocha@redhat.com>:
>
> HI all,
>
> We recently found another problem when running a simple test case
> where multiple processes open/read/close a single file, and a network
> disruption or smb restart occurs.
>
> After just a few minutes of restarts, a few of the processes error
> out, but a few remain.  If you stop the disruption, the share is
> accessible again, but the original processes are blocked indefinitely
> waiting on lock_sem
>
> Once this occurs, you'll see two threads deadlocked like the below.  Basi=
cally:
> thread1: down_read(lock_sem) inside cifs_strict_readv(); does not
> block, but blocks on network temporarily
> thread2: down_write(lock_sem) inside _cifsFileInfo_put; blocks due to thr=
ead 1
> thread1: down_read(lock_sem) inside cifs_reopen_file (after
> reconnect); unblocks to reconnect, but then blocks due to thread 2
>
> At this point there is a deadlock, both threads are waiting for each
> other to release lock_sem
>
> The root of the problem seems to be having to hold the read sem over a
> network disruption, and no check when it comes back before down_read a
> second time.
> Inside cifs_strict_readv there's a comment that explains why we need
> hold the sem over the read, and it's so no one modifies the lock list
> with a brlock that prevents writing.
> However, in this case at least, we're only opening files for reading,
> and inside _cifsFileInfo_put it needs to down_write to delete the
> outstanding lock records.
> So we're not really hitting that case, but are modifying the list.
>
> One approach to avoid the deadlock is for the reading process to drop
> the lock_sem before re-aquiring it again inside cifs_reopen_file.
> We would drop the lock just before calling, and then inside we'd need
> to check for the condition of the conflicting brlock, and then
> possibly error out somehow.
> But that is probably not preferred.
>
> Instead, can the reader only down_read one time?  cifs_relock_file is
> only called from one place (cifs_reopen_file) and it's when we're
> reconnecting, but
> cifs_reopen_file is called from many places. I'm not sure if we there
> is something in existence we can use that says we don't need to
> re-aquire it, or if we need to add a flag or something?
>
>
>
>
>
> Here is the live crash session
>
> crash> ps -m | grep UN
> [0 01:54:10.166] [UN]  PID: 13271  TASK: ffff93b8a7349e40  CPU: 2
> COMMAND: "python3-openloo"
> [0 01:54:10.167] [UN]  PID: 13273  TASK: ffff93b8b3310000  CPU: 2
> COMMAND: "python3-openloo"
> [0 01:54:10.169] [UN]  PID: 13269  TASK: ffff93b8a734dac0  CPU: 0
> COMMAND: "python3-openloo"
> [0 01:54:10.208] [UN]  PID: 13272  TASK: ffff93b8a7348000  CPU: 7
> COMMAND: "python3-openloo"
> [0 01:54:10.216] [UN]  PID: 13265  TASK: ffff93b8a7358000  CPU: 6
> COMMAND: "python3-openloo"
> [0 01:54:10.172] [UN]  PID: 13263  TASK: ffff93b8b3313c80  CPU: 2
> COMMAND: "python3-openloo"
> [0 01:54:10.229] [UN]  PID: 13267  TASK: ffff93b8a7359e40  CPU: 5
> COMMAND: "python3-openloo"
> [0 01:54:10.234] [UN]  PID: 13277  TASK: ffff93b8a7dddac0  CPU: 3
> COMMAND: "python3-openloo"
> [0 01:54:10.235] [UN]  PID: 13270  TASK: ffff93b8a734bc80  CPU: 1
> COMMAND: "python3-openloo"
> [0 01:54:10.244] [UN]  PID: 13276  TASK: ffff93b8a7dd8000  CPU: 6
> COMMAND: "python3-openloo"
> [0 01:54:10.260] [UN]  PID: 13264  TASK: ffff93b8b3315ac0  CPU: 6
> COMMAND: "python3-openloo"
> [0 01:54:10.257] [UN]  PID: 13274  TASK: ffff93b8a7ddbc80  CPU: 1
> COMMAND: "python3-openloo"
> [0 01:54:31.262] [UN]  PID: 13279  TASK: ffff93b8a7d90000  CPU: 1
> COMMAND: "python3-openloo" <--- block same instant
> [0 01:54:31.265] [UN]  PID: 13275  TASK: ffff93b8a7dd9e40  CPU: 4
> COMMAND: "python3-openloo" <--- block same instant
> crash> bt 13279
> PID: 13279  TASK: ffff93b8a7d90000  CPU: 1   COMMAND: "python3-openloo"
>  #0 [ffffaae1c0a77c20] __schedule at ffffffffa19d4239
>  #1 [ffffaae1c0a77cb0] schedule at ffffffffa19d46b9
>  #2 [ffffaae1c0a77cc8] rwsem_down_write_slowpath at ffffffffa1131ada
> <------------- T+1: pid 13279 down_write(... lock_sem); blocks due to
> pid 13275
>  #3 [ffffaae1c0a77d98] _cifsFileInfo_put at ffffffffc0759818 [cifs]
>  #4 [ffffaae1c0a77e78] cifs_close at ffffffffc0759b4f [cifs]
>  #5 [ffffaae1c0a77e88] __fput at ffffffffa12f6e51
>  #6 [ffffaae1c0a77ed0] task_work_run at ffffffffa10fc827
>  #7 [ffffaae1c0a77f08] exit_to_usermode_loop at ffffffffa1003f83
>  #8 [ffffaae1c0a77f38] do_syscall_64 at ffffffffa10043c2
>  #9 [ffffaae1c0a77f50] entry_SYSCALL_64_after_hwframe at ffffffffa1a0008c
>     RIP: 00007fc6caca1778  RSP: 00007ffed0c43de8  RFLAGS: 00000246
>     RAX: 0000000000000000  RBX: 00007fc6bd5a5f30  RCX: 00007fc6caca1778
>     RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000003
>     RBP: 0000558ebb9ca0d0   R8: 00007fc6cab941a8   R9: 0000000000000000
>     R10: 0000558ebb9ca0d0  R11: 0000000000000246  R12: 0000000000000000
>     R13: 0000000000000000  R14: 00007fc6cab4df0c  R15: 00007ffed0c43f10
>     ORIG_RAX: 0000000000000003  CS: 0033  SS: 002b
> crash> bt 13275
> PID: 13275  TASK: ffff93b8a7dd9e40  CPU: 4   COMMAND: "python3-openloo"
>  #0 [ffffaae1c0a57a00] __schedule at ffffffffa19d4239
>  #1 [ffffaae1c0a57a90] schedule at ffffffffa19d46b9
>  #2 [ffffaae1c0a57aa8] rwsem_down_read_slowpath at ffffffffa19d72b4
>  #3 [ffffaae1c0a57b60] cifs_reopen_file at ffffffffc0755352 [cifs]
> <------------- T+2: pid 13275 down_read(... lock_sem); blocks due to
> pid 13279
>  #4 [ffffaae1c0a57c08] cifs_readpage_worker at ffffffffc07575f0 [cifs]
>  #5 [ffffaae1c0a57cd0] cifs_readpage at ffffffffc0758096 [cifs]
>  #6 [ffffaae1c0a57d08] generic_file_read_iter at ffffffffa123acd2
>  #7 [ffffaae1c0a57e10] cifs_strict_readv at ffffffffc07606a5 [cifs]
> <------------- T+0: pid 13275 down_read(... lock_sem); does not block
>  #8 [ffffaae1c0a57e40] new_sync_read at ffffffffa12f336a
>  #9 [ffffaae1c0a57ec8] vfs_read at ffffffffa12f5fad
> #10 [ffffaae1c0a57f00] ksys_read at ffffffffa12f62df
> #11 [ffffaae1c0a57f38] do_syscall_64 at ffffffffa10042bb
> #12 [ffffaae1c0a57f50] entry_SYSCALL_64_after_hwframe at ffffffffa1a0008c
>     RIP: 00007f6ed0b7c055  RSP: 00007ffeea637e68  RFLAGS: 00000246
>     RAX: ffffffffffffffda  RBX: 00007f6ed05cd600  RCX: 00007f6ed0b7c055
>     RDX: 000000000000001e  RSI: 00007f6ec3404c10  RDI: 0000000000000003
>     RBP: 000000000000001e   R8: 00007f6ed0a6f1a8   R9: 0000000000000000
>     R10: 00007f6ed090faf0  R11: 0000000000000246  R12: 00007f6ec3480f40
>     R13: 0000000000000003  R14: 00007f6ec3404c10  R15: 000055c449ea60d0
>     ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b
>
>
> Here is my tracing from the attached debug patch which shows the
> conditions, and points at the bugzilla we have open:
> [  233.588248] CIFS VFS: file=3Dfs/cifs/file.c line=3D480 pid=3D13279
> cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
> [  233.589462] CIFS VFS: file=3Dfs/cifs/file.c line=3D311 pid=3D13279
> cifs_sem_op op=3Ddown_write sem=3Dffff93b8a7424bd8
> [  233.592333] CIFS VFS: file=3Dfs/cifs/file.c line=3D314 pid=3D13275
> cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
> [  233.612324] CIFS VFS: file=3Dfs/cifs/file.c line=3D314 pid=3D13279
> cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
> [  233.612510] CIFS VFS: file=3Dfs/cifs/file.c line=3D3920 pid=3D13275
> cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8
> [  233.616487] CIFS VFS: file=3Dfs/cifs/file.c line=3D3920 pid=3D13279
> cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8  T0:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9
> [  254.389458] CIFS VFS: Send error in read =3D -9
> [  254.391943] CIFS VFS: file=3Dfs/cifs/file.c line=3D3926 pid=3D13279
> cifs_sem_op op=3Dup_read sem=3Dffff93b8a7424bd8
> [  254.397453] CIFS VFS: file=3Dfs/cifs/file.c line=3D471 pid=3D13279
> cifs_sem_op op=3Ddown_write sem=3Dffff93b8a7424bd8  T1:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9
> [  254.399798] CIFS VFS: file=3Dfs/cifs/file.c line=3D630 pid=3D13275
> cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8   T2:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9
>
>
>
> There was a patch that removed a lockdep warning, but it looks like
> this removed a semi-valid warning, because clearly we can deadlock
> here:
>
> commit 560d388950ceda5e7c7cdef7f3d9a8ff297bbf9d
> Author: Rabin Vincent <rabinv@axis.com>
> Date:   Wed May 3 17:17:21 2017 +0200
>
>     CIFS: silence lockdep splat in cifs_relock_file()
>
>     cifs_relock_file() can perform a down_write() on the inode's lock_sem=
 even
>     though it was already performed in cifs_strict_readv().  Lockdep comp=
lains
>     about this.  AFAICS, there is no problem here, and lockdep just needs=
 to be
>     told that this nesting is OK.
>
>      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>      [ INFO: possible recursive locking detected ]
>      4.11.0+ #20 Not tainted
>      ---------------------------------------------
>      cat/701 is trying to acquire lock:
>       (&cifsi->lock_sem){++++.+}, at: cifs_reopen_file+0x7a7/0xc00
>
>      but task is already holding lock:
>       (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310
>
>      other info that might help us debug this:
>       Possible unsafe locking scenario:
>
>             CPU0
>             ----
>        lock(&cifsi->lock_sem);
>        lock(&cifsi->lock_sem);
>
>       *** DEADLOCK ***
>
>       May be due to missing lock nesting notation
>
>      1 lock held by cat/701:
>       #0:  (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310
>
>      stack backtrace:
>      CPU: 0 PID: 701 Comm: cat Not tainted 4.11.0+ #20
>      Call Trace:
>       dump_stack+0x85/0xc2
>       __lock_acquire+0x17dd/0x2260
>       ? trace_hardirqs_on_thunk+0x1a/0x1c
>       ? preempt_schedule_irq+0x6b/0x80
>       lock_acquire+0xcc/0x260
>       ? lock_acquire+0xcc/0x260
>       ? cifs_reopen_file+0x7a7/0xc00
>       down_read+0x2d/0x70
>       ? cifs_reopen_file+0x7a7/0xc00
>       cifs_reopen_file+0x7a7/0xc00
>       ? printk+0x43/0x4b
>       cifs_readpage_worker+0x327/0x8a0
>       cifs_readpage+0x8c/0x2a0
>       generic_file_read_iter+0x692/0xd00
>       cifs_strict_readv+0x29f/0x310
>       generic_file_splice_read+0x11c/0x1c0
>       do_splice_to+0xa5/0xc0
>       splice_direct_to_actor+0xfa/0x350
>       ? generic_pipe_buf_nosteal+0x10/0x10
>       do_splice_direct+0xb5/0xe0
>       do_sendfile+0x278/0x3a0
>       SyS_sendfile64+0xc4/0xe0
>       entry_SYSCALL_64_fastpath+0x1f/0xbe
>
>     Signed-off-by: Rabin Vincent <rabinv@axis.com>
>     Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
>     Signed-off-by: Steve French <smfrench@gmail.com>

So, even after we already grabbed the semaphore it doesn't allow us to
acquire it one more time because of the conflicting waiting down_write
? If yes, then we can create another work queue that will be
re-locking files that have been re-opened. In this case
cifs_reopen_file will simply submit the "re-lock" request to the queue
without the need to grab the lock one more time.

Thoughts?

--
Best regards,
Pavel Shilovsky
