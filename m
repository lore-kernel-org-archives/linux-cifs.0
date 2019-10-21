Return-Path: <SRS0=SN/X=YO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C501ACA9EAF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 17:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A1492077C
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 17:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1FT+Ijo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfJURXL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Oct 2019 13:23:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbfJURXL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Oct 2019 13:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571678588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=voBNVYxMip0Cua5n2Obu6rb0dGhN8+OrH1il0+qp+/0=;
        b=b1FT+IjoeQj4lOW11ZFP8FlMf2j6iYNgwqClerR6CdNYTpB25KfRLwN8qcy/0c499RK0UB
        rKvF58HMuR4PvP4mqsWwa6bj+FhOzzbGR9qebL8TzhZt3jK0KbgTE/TE1ACnHyMnjcnSm3
        y5YLgZBzBpFBeWToIsoTwbiiC34v63U=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-4oECyb1QMLuk-58XzX0APA-1; Mon, 21 Oct 2019 13:23:06 -0400
Received: by mail-qk1-f200.google.com with SMTP id k67so14237891qkc.3
        for <linux-cifs@vger.kernel.org>; Mon, 21 Oct 2019 10:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=f+wVXTfFuBDn7o/7l2n2lclpIkAILwyErCpXEOFxdmw=;
        b=gkjRk9KYc4Qp00Nhw72ZOePcOLepRS8/YoirgOtqSMbK1mdC9m0EibPgnePVuzNtmW
         o69NA+ZgExmOl96GlvT3X1pw0zSqW+3MvAsH00GX1xUejnf9QXDG0sPe6NoGsfR+iecH
         KWkeF9xtwnHnT5xcvF5n/CQ9VzlN7xVh7JgCbhd4yidmbXhvEQ1aVq3Qk4xSSY2klrJ/
         K+F4AxOs1FufiE7XDVcyOOtaPMeStma1Rrf2jZ2L1mH2ih4I8hwpHGH00anB4DM/lOqX
         Wl0JytyoLj/eKM7wHacVonAL2jIkJt3oZbYhLjg7kYIfrHWNZqjBOfrGFiO1e2gzRXFN
         xhwA==
X-Gm-Message-State: APjAAAWttlnlb1Yka/Z0VrDzJSBc/hbuog6DziX+z869ZbkjHoOK4U3H
        3Ow47tigkgnJPzkW33ZuX9ou/2zcHSwFVqgP5PoqwnM/frWxr6HuCdQvtAm4stM4GZXXH0RC1Hq
        Km+htq3CdyaKAQOj0IB1faxXwbmnq2uJu5+amSw==
X-Received: by 2002:ae9:f404:: with SMTP id y4mr23012810qkl.225.1571678585295;
        Mon, 21 Oct 2019 10:23:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxBWtbCGKrsRAeUJBC9B3hUSmHZqqgE0l4RJvm033YowJdodazbAsXdBJZ6dao15F0s/tjusK+szQAz1Obn92w=
X-Received: by 2002:ae9:f404:: with SMTP id y4mr23012770qkl.225.1571678584708;
 Mon, 21 Oct 2019 10:23:04 -0700 (PDT)
MIME-Version: 1.0
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 21 Oct 2019 13:22:27 -0400
Message-ID: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
Subject: Easily reproducible deadlock on 5.4-rc4 with cifsInodeInfo.lock_sem
 semaphore after network disruption or smb restart
To:     linux-cifs <linux-cifs@vger.kernel.org>
X-MC-Unique: 4oECyb1QMLuk-58XzX0APA-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; boundary="000000000000be94d005956eeff8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000be94d005956eeff8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

HI all,

We recently found another problem when running a simple test case
where multiple processes open/read/close a single file, and a network
disruption or smb restart occurs.

After just a few minutes of restarts, a few of the processes error
out, but a few remain.  If you stop the disruption, the share is
accessible again, but the original processes are blocked indefinitely
waiting on lock_sem

Once this occurs, you'll see two threads deadlocked like the below.  Basica=
lly:
thread1: down_read(lock_sem) inside cifs_strict_readv(); does not
block, but blocks on network temporarily
thread2: down_write(lock_sem) inside _cifsFileInfo_put; blocks due to threa=
d 1
thread1: down_read(lock_sem) inside cifs_reopen_file (after
reconnect); unblocks to reconnect, but then blocks due to thread 2

At this point there is a deadlock, both threads are waiting for each
other to release lock_sem

The root of the problem seems to be having to hold the read sem over a
network disruption, and no check when it comes back before down_read a
second time.
Inside cifs_strict_readv there's a comment that explains why we need
hold the sem over the read, and it's so no one modifies the lock list
with a brlock that prevents writing.
However, in this case at least, we're only opening files for reading,
and inside _cifsFileInfo_put it needs to down_write to delete the
outstanding lock records.
So we're not really hitting that case, but are modifying the list.

One approach to avoid the deadlock is for the reading process to drop
the lock_sem before re-aquiring it again inside cifs_reopen_file.
We would drop the lock just before calling, and then inside we'd need
to check for the condition of the conflicting brlock, and then
possibly error out somehow.
But that is probably not preferred.

Instead, can the reader only down_read one time?  cifs_relock_file is
only called from one place (cifs_reopen_file) and it's when we're
reconnecting, but
cifs_reopen_file is called from many places. I'm not sure if we there
is something in existence we can use that says we don't need to
re-aquire it, or if we need to add a flag or something?





Here is the live crash session

crash> ps -m | grep UN
[0 01:54:10.166] [UN]  PID: 13271  TASK: ffff93b8a7349e40  CPU: 2
COMMAND: "python3-openloo"
[0 01:54:10.167] [UN]  PID: 13273  TASK: ffff93b8b3310000  CPU: 2
COMMAND: "python3-openloo"
[0 01:54:10.169] [UN]  PID: 13269  TASK: ffff93b8a734dac0  CPU: 0
COMMAND: "python3-openloo"
[0 01:54:10.208] [UN]  PID: 13272  TASK: ffff93b8a7348000  CPU: 7
COMMAND: "python3-openloo"
[0 01:54:10.216] [UN]  PID: 13265  TASK: ffff93b8a7358000  CPU: 6
COMMAND: "python3-openloo"
[0 01:54:10.172] [UN]  PID: 13263  TASK: ffff93b8b3313c80  CPU: 2
COMMAND: "python3-openloo"
[0 01:54:10.229] [UN]  PID: 13267  TASK: ffff93b8a7359e40  CPU: 5
COMMAND: "python3-openloo"
[0 01:54:10.234] [UN]  PID: 13277  TASK: ffff93b8a7dddac0  CPU: 3
COMMAND: "python3-openloo"
[0 01:54:10.235] [UN]  PID: 13270  TASK: ffff93b8a734bc80  CPU: 1
COMMAND: "python3-openloo"
[0 01:54:10.244] [UN]  PID: 13276  TASK: ffff93b8a7dd8000  CPU: 6
COMMAND: "python3-openloo"
[0 01:54:10.260] [UN]  PID: 13264  TASK: ffff93b8b3315ac0  CPU: 6
COMMAND: "python3-openloo"
[0 01:54:10.257] [UN]  PID: 13274  TASK: ffff93b8a7ddbc80  CPU: 1
COMMAND: "python3-openloo"
[0 01:54:31.262] [UN]  PID: 13279  TASK: ffff93b8a7d90000  CPU: 1
COMMAND: "python3-openloo" <--- block same instant
[0 01:54:31.265] [UN]  PID: 13275  TASK: ffff93b8a7dd9e40  CPU: 4
COMMAND: "python3-openloo" <--- block same instant
crash> bt 13279
PID: 13279  TASK: ffff93b8a7d90000  CPU: 1   COMMAND: "python3-openloo"
 #0 [ffffaae1c0a77c20] __schedule at ffffffffa19d4239
 #1 [ffffaae1c0a77cb0] schedule at ffffffffa19d46b9
 #2 [ffffaae1c0a77cc8] rwsem_down_write_slowpath at ffffffffa1131ada
<------------- T+1: pid 13279 down_write(... lock_sem); blocks due to
pid 13275
 #3 [ffffaae1c0a77d98] _cifsFileInfo_put at ffffffffc0759818 [cifs]
 #4 [ffffaae1c0a77e78] cifs_close at ffffffffc0759b4f [cifs]
 #5 [ffffaae1c0a77e88] __fput at ffffffffa12f6e51
 #6 [ffffaae1c0a77ed0] task_work_run at ffffffffa10fc827
 #7 [ffffaae1c0a77f08] exit_to_usermode_loop at ffffffffa1003f83
 #8 [ffffaae1c0a77f38] do_syscall_64 at ffffffffa10043c2
 #9 [ffffaae1c0a77f50] entry_SYSCALL_64_after_hwframe at ffffffffa1a0008c
    RIP: 00007fc6caca1778  RSP: 00007ffed0c43de8  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: 00007fc6bd5a5f30  RCX: 00007fc6caca1778
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000003
    RBP: 0000558ebb9ca0d0   R8: 00007fc6cab941a8   R9: 0000000000000000
    R10: 0000558ebb9ca0d0  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 00007fc6cab4df0c  R15: 00007ffed0c43f10
    ORIG_RAX: 0000000000000003  CS: 0033  SS: 002b
crash> bt 13275
PID: 13275  TASK: ffff93b8a7dd9e40  CPU: 4   COMMAND: "python3-openloo"
 #0 [ffffaae1c0a57a00] __schedule at ffffffffa19d4239
 #1 [ffffaae1c0a57a90] schedule at ffffffffa19d46b9
 #2 [ffffaae1c0a57aa8] rwsem_down_read_slowpath at ffffffffa19d72b4
 #3 [ffffaae1c0a57b60] cifs_reopen_file at ffffffffc0755352 [cifs]
<------------- T+2: pid 13275 down_read(... lock_sem); blocks due to
pid 13279
 #4 [ffffaae1c0a57c08] cifs_readpage_worker at ffffffffc07575f0 [cifs]
 #5 [ffffaae1c0a57cd0] cifs_readpage at ffffffffc0758096 [cifs]
 #6 [ffffaae1c0a57d08] generic_file_read_iter at ffffffffa123acd2
 #7 [ffffaae1c0a57e10] cifs_strict_readv at ffffffffc07606a5 [cifs]
<------------- T+0: pid 13275 down_read(... lock_sem); does not block
 #8 [ffffaae1c0a57e40] new_sync_read at ffffffffa12f336a
 #9 [ffffaae1c0a57ec8] vfs_read at ffffffffa12f5fad
#10 [ffffaae1c0a57f00] ksys_read at ffffffffa12f62df
#11 [ffffaae1c0a57f38] do_syscall_64 at ffffffffa10042bb
#12 [ffffaae1c0a57f50] entry_SYSCALL_64_after_hwframe at ffffffffa1a0008c
    RIP: 00007f6ed0b7c055  RSP: 00007ffeea637e68  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 00007f6ed05cd600  RCX: 00007f6ed0b7c055
    RDX: 000000000000001e  RSI: 00007f6ec3404c10  RDI: 0000000000000003
    RBP: 000000000000001e   R8: 00007f6ed0a6f1a8   R9: 0000000000000000
    R10: 00007f6ed090faf0  R11: 0000000000000246  R12: 00007f6ec3480f40
    R13: 0000000000000003  R14: 00007f6ec3404c10  R15: 000055c449ea60d0
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b


Here is my tracing from the attached debug patch which shows the
conditions, and points at the bugzilla we have open:
[  233.588248] CIFS VFS: file=3Dfs/cifs/file.c line=3D480 pid=3D13279
cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
[  233.589462] CIFS VFS: file=3Dfs/cifs/file.c line=3D311 pid=3D13279
cifs_sem_op op=3Ddown_write sem=3Dffff93b8a7424bd8
[  233.592333] CIFS VFS: file=3Dfs/cifs/file.c line=3D314 pid=3D13275
cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
[  233.612324] CIFS VFS: file=3Dfs/cifs/file.c line=3D314 pid=3D13279
cifs_sem_op op=3Dup_write sem=3Dffff93b8a7424bd8
[  233.612510] CIFS VFS: file=3Dfs/cifs/file.c line=3D3920 pid=3D13275
cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8
[  233.616487] CIFS VFS: file=3Dfs/cifs/file.c line=3D3920 pid=3D13279
cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8  T0:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9
[  254.389458] CIFS VFS: Send error in read =3D -9
[  254.391943] CIFS VFS: file=3Dfs/cifs/file.c line=3D3926 pid=3D13279
cifs_sem_op op=3Dup_read sem=3Dffff93b8a7424bd8
[  254.397453] CIFS VFS: file=3Dfs/cifs/file.c line=3D471 pid=3D13279
cifs_sem_op op=3Ddown_write sem=3Dffff93b8a7424bd8  T1:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9
[  254.399798] CIFS VFS: file=3Dfs/cifs/file.c line=3D630 pid=3D13275
cifs_sem_op op=3Ddown_read sem=3Dffff93b8a7424bd8   T2:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1760835#c9



There was a patch that removed a lockdep warning, but it looks like
this removed a semi-valid warning, because clearly we can deadlock
here:

commit 560d388950ceda5e7c7cdef7f3d9a8ff297bbf9d
Author: Rabin Vincent <rabinv@axis.com>
Date:   Wed May 3 17:17:21 2017 +0200

    CIFS: silence lockdep splat in cifs_relock_file()

    cifs_relock_file() can perform a down_write() on the inode's lock_sem e=
ven
    though it was already performed in cifs_strict_readv().  Lockdep compla=
ins
    about this.  AFAICS, there is no problem here, and lockdep just needs t=
o be
    told that this nesting is OK.

     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
     [ INFO: possible recursive locking detected ]
     4.11.0+ #20 Not tainted
     ---------------------------------------------
     cat/701 is trying to acquire lock:
      (&cifsi->lock_sem){++++.+}, at: cifs_reopen_file+0x7a7/0xc00

     but task is already holding lock:
      (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310

     other info that might help us debug this:
      Possible unsafe locking scenario:

            CPU0
            ----
       lock(&cifsi->lock_sem);
       lock(&cifsi->lock_sem);

      *** DEADLOCK ***

      May be due to missing lock nesting notation

     1 lock held by cat/701:
      #0:  (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310

     stack backtrace:
     CPU: 0 PID: 701 Comm: cat Not tainted 4.11.0+ #20
     Call Trace:
      dump_stack+0x85/0xc2
      __lock_acquire+0x17dd/0x2260
      ? trace_hardirqs_on_thunk+0x1a/0x1c
      ? preempt_schedule_irq+0x6b/0x80
      lock_acquire+0xcc/0x260
      ? lock_acquire+0xcc/0x260
      ? cifs_reopen_file+0x7a7/0xc00
      down_read+0x2d/0x70
      ? cifs_reopen_file+0x7a7/0xc00
      cifs_reopen_file+0x7a7/0xc00
      ? printk+0x43/0x4b
      cifs_readpage_worker+0x327/0x8a0
      cifs_readpage+0x8c/0x2a0
      generic_file_read_iter+0x692/0xd00
      cifs_strict_readv+0x29f/0x310
      generic_file_splice_read+0x11c/0x1c0
      do_splice_to+0xa5/0xc0
      splice_direct_to_actor+0xfa/0x350
      ? generic_pipe_buf_nosteal+0x10/0x10
      do_splice_direct+0xb5/0xe0
      do_sendfile+0x278/0x3a0
      SyS_sendfile64+0xc4/0xe0
      entry_SYSCALL_64_fastpath+0x1f/0xbe

    Signed-off-by: Rabin Vincent <rabinv@axis.com>
    Acked-by: Pavel Shilovsky <pshilov@microsoft.com>
    Signed-off-by: Steve French <smfrench@gmail.com>

--000000000000be94d005956eeff8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-debug-cifs-lock_sem-deadlock-redhat-bug-1760835.patch"
Content-Disposition: attachment; 
	filename="0001-debug-cifs-lock_sem-deadlock-redhat-bug-1760835.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k20nr7cu0>
X-Attachment-Id: f_k20nr7cu0

RnJvbSA2OGZlODAwNDQ1NjI5ODA3MDI0N2ZkMjNjM2FmOTFiMzMyZDk4ZDM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIFd5c29jaGFuc2tpIDxkd3lzb2NoYUByZWRoYXQuY29t
PgpEYXRlOiBNb24sIDIxIE9jdCAyMDE5IDA3OjI4OjA0IC0wNDAwClN1YmplY3Q6IFtQQVRDSF0g
ZGVidWcgY2lmcyBsb2NrX3NlbSBkZWFkbG9jayAtIHJlZGhhdCBidWcgMTc2MDgzNQoKZGVidWcg
b2YgaHR0cHM6Ly9idWd6aWxsYS5yZWRoYXQuY29tL3Nob3dfYnVnLmNnaT9pZD0xNzYwODM1Cgpj
aWZzX2RiZyB0cmFjZSBvZiBsb2NrX3NlbQp0dXJuIG9mZiByYXRlbGltaXRpbmcKLS0tCiBNYWtl
ZmlsZSAgICAgICAgICAgIHwgIDIgKy0KIGZzL2NpZnMvY2lmc2ZzLmMgICAgfCAgMSArCiBmcy9j
aWZzL2NpZnNwcm90by5oIHwgMzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwog
ZnMvY2lmcy9maWxlLmMgICAgICB8IDMyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiBmcy9jaWZzL3NtYjJmaWxlLmMgIHwgIDIgKysKIGxpYi9yYXRlbGltaXQuYyAgICAgfCAgMyAr
LS0KIDYgZmlsZXMgY2hhbmdlZCwgNzEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IDU0NzVjZGI2ZDU3ZC4uNDdiMGQ0
MmYwNDE4IDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtMiw3ICsyLDcg
QEAKIFZFUlNJT04gPSA1CiBQQVRDSExFVkVMID0gNAogU1VCTEVWRUwgPSAwCi1FWFRSQVZFUlNJ
T04gPSAtcmM0CitFWFRSQVZFUlNJT04gPSAtcmM0LWRiZzMKIE5BTUUgPSBOZXN0aW5nIE9wb3Nz
dW0KIAogIyAqRE9DVU1FTlRBVElPTioKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9m
cy9jaWZzL2NpZnNmcy5jCmluZGV4IGMwNDljN2IzYWE4Ny4uNDMxYTlkNDZiNDA5IDEwMDY0NAot
LS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTEzMzUsNiAr
MTMzNSw3IEBAIHN0YXRpYyBzc2l6ZV90IGNpZnNfY29weV9maWxlX3JhbmdlKHN0cnVjdCBmaWxl
ICpzcmNfZmlsZSwgbG9mZl90IG9mZiwKIAlzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lmc2kgPSBp
bm9kZTsKIAogCWlub2RlX2luaXRfb25jZSgmY2lmc2ktPnZmc19pbm9kZSk7CisJY2lmc19zZW1f
b3BfdHJhY2VfaW5pdF9yd3NlbSgmY2lmc2ktPmxvY2tfc2VtKTsKIAlpbml0X3J3c2VtKCZjaWZz
aS0+bG9ja19zZW0pOwogfQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5oIGIvZnMv
Y2lmcy9jaWZzcHJvdG8uaAppbmRleCBlNTNlOWY2MmI4N2IuLjU0ODhlNWUxMWU0MCAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZzL2NpZnNwcm90by5oCkBAIC02
NSw2ICs2NSw0MCBAQCBleHRlcm4gaW50IHNtYl9zZW5kKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
Kiwgc3RydWN0IHNtYl9oZHIgKiwKIAllbHNlCQkJCQkJCVwKIAkJdHJhY2Vfc21iM19leGl0X2Rv
bmUoY3Vycl94aWQsIF9fZnVuY19fKTsJXAogfSB3aGlsZSAoMCkKKworCisvKiBEZWJ1ZyBsb2Nr
X3NlbSAqLworI2RlZmluZSBjaWZzX3NlbV9vcF90cmFjZShTRU0sIE9QKSBcCitkbyB7IFwKKwlj
aWZzX2RiZyhWRlMsICJmaWxlPSVzIGxpbmU9JWQgcGlkPSVkIGNpZnNfc2VtX29wIG9wPSVzIHNl
bT0lcHhcbiIsIFwKKwkJIF9fRklMRV9fLCBfX0xJTkVfXywgY3VycmVudC0+cGlkLCAjT1AsIFNF
TSk7IFwKK30gd2hpbGUoMCkKKworI2RlZmluZSBjaWZzX3NlbV9vcF90cmFjZV9pbml0X3J3c2Vt
KFgpIFwKK2RvIHsgXAorCWNpZnNfc2VtX29wX3RyYWNlKFgsIGluaXRfcndzZW0pOyBcCit9IHdo
aWxlICgwKQorCisjZGVmaW5lIGNpZnNfc2VtX29wX3RyYWNlX2Rvd25fcmVhZChYKSBcCitkbyB7
IFwKKwljaWZzX3NlbV9vcF90cmFjZShYLCBkb3duX3JlYWQpOyBcCit9IHdoaWxlICgwKQorCisj
ZGVmaW5lIGNpZnNfc2VtX29wX3RyYWNlX3VwX3JlYWQoWCkgXAorZG8geyBcCisJY2lmc19zZW1f
b3BfdHJhY2UoWCwgdXBfcmVhZCk7IFwKK30gd2hpbGUgKDApCisKKyNkZWZpbmUgY2lmc19zZW1f
b3BfdHJhY2VfZG93bl93cml0ZShYKSBcCitkbyB7IFwKKwljaWZzX3NlbV9vcF90cmFjZShYLCBk
b3duX3dyaXRlKTsgXAorfSB3aGlsZSAoMCkKKworI2RlZmluZSBjaWZzX3NlbV9vcF90cmFjZV91
cF93cml0ZShYKSBcCitkbyB7IFwKKwljaWZzX3NlbV9vcF90cmFjZShYLCB1cF93cml0ZSk7IFwK
K30gd2hpbGUgKDApCisKIGV4dGVybiBpbnQgaW5pdF9jaWZzX2lkbWFwKHZvaWQpOwogZXh0ZXJu
IHZvaWQgZXhpdF9jaWZzX2lkbWFwKHZvaWQpOwogZXh0ZXJuIGludCBpbml0X2NpZnNfc3BuZWdv
KHZvaWQpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRl
eCA1YWQxNWRlMmJiNGYuLjU4ZTU1NGNjMzk3YSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMK
KysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTI3MCw2ICsyNzAsNyBAQCBpbnQgY2lmc19wb3NpeF9v
cGVuKGNoYXIgKmZ1bGxfcGF0aCwgc3RydWN0IGlub2RlICoqcGlub2RlLAogCXN0cnVjdCBjaWZz
X2ZpZF9sb2NrcyAqY3VyOwogCWJvb2wgaGFzX2xvY2tzID0gZmFsc2U7CiAKKwljaWZzX3NlbV9v
cF90cmFjZV9kb3duX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fcmVhZCgmY2lub2Rl
LT5sb2NrX3NlbSk7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjdXIsICZjaW5vZGUtPmxsaXN0LCBs
bGlzdCkgewogCQlpZiAoIWxpc3RfZW1wdHkoJmN1ci0+bG9ja3MpKSB7CkBAIC0yNzcsNiArMjc4
LDcgQEAgaW50IGNpZnNfcG9zaXhfb3BlbihjaGFyICpmdWxsX3BhdGgsIHN0cnVjdCBpbm9kZSAq
KnBpbm9kZSwKIAkJCWJyZWFrOwogCQl9CiAJfQorCWNpZnNfc2VtX29wX3RyYWNlX3VwX3JlYWQo
JmNpbm9kZS0+bG9ja19zZW0pOwogCXVwX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCXJldHVy
biBoYXNfbG9ja3M7CiB9CkBAIC0zMDYsOCArMzA4LDEwIEBAIHN0cnVjdCBjaWZzRmlsZUluZm8g
KgogCUlOSVRfTElTVF9IRUFEKCZmZGxvY2tzLT5sb2Nrcyk7CiAJZmRsb2Nrcy0+Y2ZpbGUgPSBj
ZmlsZTsKIAljZmlsZS0+bGxpc3QgPSBmZGxvY2tzOworCWNpZnNfc2VtX29wX3RyYWNlX2Rvd25f
d3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0p
OwogCWxpc3RfYWRkKCZmZGxvY2tzLT5sbGlzdCwgJmNpbm9kZS0+bGxpc3QpOworCWNpZnNfc2Vt
X29wX3RyYWNlX3VwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAl1cF93cml0ZSgmY2lub2Rl
LT5sb2NrX3NlbSk7CiAKIAljZmlsZS0+Y291bnQgPSAxOwpAQCAtNDY0LDYgKzQ2OCw3IEBAIHZv
aWQgX2NpZnNGaWxlSW5mb19wdXQoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2lmc19maWxlLCBib29s
IHdhaXRfb3Bsb2NrX2hhbmRsZXIpCiAJICogRGVsZXRlIGFueSBvdXRzdGFuZGluZyBsb2NrIHJl
Y29yZHMuIFdlJ2xsIGxvc2UgdGhlbSB3aGVuIHRoZSBmaWxlCiAJICogaXMgY2xvc2VkIGFueXdh
eS4KIAkgKi8KKwljaWZzX3NlbV9vcF90cmFjZV9kb3duX3dyaXRlKCZjaWZzaS0+bG9ja19zZW0p
OwogCWRvd25fd3JpdGUoJmNpZnNpLT5sb2NrX3NlbSk7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9z
YWZlKGxpLCB0bXAsICZjaWZzX2ZpbGUtPmxsaXN0LT5sb2NrcywgbGxpc3QpIHsKIAkJbGlzdF9k
ZWwoJmxpLT5sbGlzdCk7CkBAIC00NzIsNiArNDc3LDcgQEAgdm9pZCBfY2lmc0ZpbGVJbmZvX3B1
dChzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjaWZzX2ZpbGUsIGJvb2wgd2FpdF9vcGxvY2tfaGFuZGxl
cikKIAl9CiAJbGlzdF9kZWwoJmNpZnNfZmlsZS0+bGxpc3QtPmxsaXN0KTsKIAlrZnJlZShjaWZz
X2ZpbGUtPmxsaXN0KTsKKwljaWZzX3NlbV9vcF90cmFjZV91cF93cml0ZSgmY2lmc2ktPmxvY2tf
c2VtKTsKIAl1cF93cml0ZSgmY2lmc2ktPmxvY2tfc2VtKTsKIAogCWNpZnNfcHV0X3RsaW5rKGNp
ZnNfZmlsZS0+dGxpbmspOwpAQCAtNjIxLDkgKzYyNywxMSBAQCBpbnQgY2lmc19vcGVuKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCXN0cnVjdCBjaWZzX3Rjb24gKnRj
b24gPSB0bGlua190Y29uKGNmaWxlLT50bGluayk7CiAJaW50IHJjID0gMDsKIAorCWNpZnNfc2Vt
X29wX3RyYWNlX2Rvd25fcmVhZCgmY2lub2RlLT5sb2NrX3NlbSk7CiAJZG93bl9yZWFkX25lc3Rl
ZCgmY2lub2RlLT5sb2NrX3NlbSwgU0lOR0xFX0RFUFRIX05FU1RJTkcpOwogCWlmIChjaW5vZGUt
PmNhbl9jYWNoZV9icmxja3MpIHsKIAkJLyogY2FuIGNhY2hlIGxvY2tzIC0gbm8gbmVlZCB0byBy
ZWxvY2sgKi8KKwkJY2lmc19zZW1fb3BfdHJhY2VfdXBfcmVhZCgmY2lub2RlLT5sb2NrX3NlbSk7
CiAJCXVwX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCQlyZXR1cm4gcmM7CiAJfQpAQCAtNjM1
LDYgKzY0Myw3IEBAIGludCBjaWZzX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZpbGUpCiAJZWxzZQogCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnB1c2hfbWFu
ZF9sb2NrcyhjZmlsZSk7CiAKKwljaWZzX3NlbV9vcF90cmFjZV91cF9yZWFkKCZjaW5vZGUtPmxv
Y2tfc2VtKTsKIAl1cF9yZWFkKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlyZXR1cm4gcmM7CiB9CkBA
IC0xMDAxLDYgKzEwMTAsNyBAQCBpbnQgY2lmc19jbG9zZWRpcihzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0
bGlua190Y29uKGNmaWxlLT50bGluayktPnNlcy0+c2VydmVyOwogCWJvb2wgZXhpc3Q7CiAKKwlj
aWZzX3NlbV9vcF90cmFjZV9kb3duX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fcmVh
ZCgmY2lub2RlLT5sb2NrX3NlbSk7CiAKIAlleGlzdCA9IGNpZnNfZmluZF9sb2NrX2NvbmZsaWN0
KGNmaWxlLCBvZmZzZXQsIGxlbmd0aCwgdHlwZSwKQEAgLTEwMTksNiArMTAyOSw3IEBAIGludCBj
aWZzX2Nsb3NlZGlyKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCWVs
c2UKIAkJZmxvY2stPmZsX3R5cGUgPSBGX1VOTENLOwogCisJY2lmc19zZW1fb3BfdHJhY2VfdXBf
cmVhZCgmY2lub2RlLT5sb2NrX3NlbSk7CiAJdXBfcmVhZCgmY2lub2RlLT5sb2NrX3NlbSk7CiAJ
cmV0dXJuIHJjOwogfQpAQCAtMTAyNyw4ICsxMDM4LDEwIEBAIGludCBjaWZzX2Nsb3NlZGlyKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogY2lmc19sb2NrX2FkZChzdHJ1
Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNMb2NrSW5mbyAqbG9jaykKIHsKIAlz
dHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lub2RlID0gQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRy
eSkpOworCWNpZnNfc2VtX29wX3RyYWNlX2Rvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwog
CWRvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCWxpc3RfYWRkX3RhaWwoJmxvY2stPmxs
aXN0LCAmY2ZpbGUtPmxsaXN0LT5sb2Nrcyk7CisJY2lmc19zZW1fb3BfdHJhY2VfdXBfd3JpdGUo
JmNpbm9kZS0+bG9ja19zZW0pOwogCXVwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIH0KIApA
QCAtMTA0OSw2ICsxMDYyLDcgQEAgaW50IGNpZnNfY2xvc2VkaXIoc3RydWN0IGlub2RlICppbm9k
ZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAKIHRyeV9hZ2FpbjoKIAlleGlzdCA9IGZhbHNlOworCWNp
ZnNfc2VtX29wX3RyYWNlX2Rvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fd3Jp
dGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCiAJZXhpc3QgPSBjaWZzX2ZpbmRfbG9ja19jb25mbGlj
dChjZmlsZSwgbG9jay0+b2Zmc2V0LCBsb2NrLT5sZW5ndGgsCkBAIC0xMDU2LDYgKzEwNzAsNyBA
QCBpbnQgY2lmc19jbG9zZWRpcihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmls
ZSkKIAkJCQkJQ0lGU19MT0NLX09QKTsKIAlpZiAoIWV4aXN0ICYmIGNpbm9kZS0+Y2FuX2NhY2hl
X2JybGNrcykgewogCQlsaXN0X2FkZF90YWlsKCZsb2NrLT5sbGlzdCwgJmNmaWxlLT5sbGlzdC0+
bG9ja3MpOworCQljaWZzX3NlbV9vcF90cmFjZV91cF93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7
CiAJCXVwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAkJcmV0dXJuIHJjOwogCX0KQEAgLTEw
NjYsMTYgKzEwODEsMTkgQEAgaW50IGNpZnNfY2xvc2VkaXIoc3RydWN0IGlub2RlICppbm9kZSwg
c3RydWN0IGZpbGUgKmZpbGUpCiAJCXJjID0gLUVBQ0NFUzsKIAllbHNlIHsKIAkJbGlzdF9hZGRf
dGFpbCgmbG9jay0+Ymxpc3QsICZjb25mX2xvY2stPmJsaXN0KTsKKwkJY2lmc19zZW1fb3BfdHJh
Y2VfdXBfd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCQl1cF93cml0ZSgmY2lub2RlLT5sb2Nr
X3NlbSk7CiAJCXJjID0gd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlKGxvY2stPmJsb2NrX3EsCiAJ
CQkJCShsb2NrLT5ibGlzdC5wcmV2ID09ICZsb2NrLT5ibGlzdCkgJiYKIAkJCQkJKGxvY2stPmJs
aXN0Lm5leHQgPT0gJmxvY2stPmJsaXN0KSk7CiAJCWlmICghcmMpCiAJCQlnb3RvIHRyeV9hZ2Fp
bjsKKwkJY2lmc19zZW1fb3BfdHJhY2VfZG93bl93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJ
CWRvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCQlsaXN0X2RlbF9pbml0KCZsb2NrLT5i
bGlzdCk7CiAJfQogCisJY2lmc19zZW1fb3BfdHJhY2VfdXBfd3JpdGUoJmNpbm9kZS0+bG9ja19z
ZW0pOwogCXVwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlyZXR1cm4gcmM7CiB9CkBAIC0x
MDk3LDYgKzExMTUsNyBAQCBpbnQgY2lmc19jbG9zZWRpcihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
dHJ1Y3QgZmlsZSAqZmlsZSkKIAlpZiAoKGZsb2NrLT5mbF9mbGFncyAmIEZMX1BPU0lYKSA9PSAw
KQogCQlyZXR1cm4gMTsKIAorCWNpZnNfc2VtX29wX3RyYWNlX2Rvd25fcmVhZCgmY2lub2RlLT5s
b2NrX3NlbSk7CiAJZG93bl9yZWFkKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlwb3NpeF90ZXN0X2xv
Y2soZmlsZSwgZmxvY2spOwogCkBAIC0xMTA1LDYgKzExMjQsNyBAQCBpbnQgY2lmc19jbG9zZWRp
cihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAkJcmMgPSAxOwogCX0K
IAorCWNpZnNfc2VtX29wX3RyYWNlX3VwX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCXVwX3Jl
YWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCXJldHVybiByYzsKIH0KQEAgLTExMjUsMTMgKzExNDUs
MTYgQEAgaW50IGNpZnNfY2xvc2VkaXIoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUg
KmZpbGUpCiAJCXJldHVybiByYzsKIAogdHJ5X2FnYWluOgorCWNpZnNfc2VtX29wX3RyYWNlX2Rv
d25fd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fd3JpdGUoJmNpbm9kZS0+bG9ja19z
ZW0pOwogCWlmICghY2lub2RlLT5jYW5fY2FjaGVfYnJsY2tzKSB7CisJCWNpZnNfc2VtX29wX3Ry
YWNlX3VwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAkJdXBfd3JpdGUoJmNpbm9kZS0+bG9j
a19zZW0pOwogCQlyZXR1cm4gcmM7CiAJfQogCiAJcmMgPSBwb3NpeF9sb2NrX2ZpbGUoZmlsZSwg
ZmxvY2ssIE5VTEwpOworCWNpZnNfc2VtX29wX3RyYWNlX3VwX3dyaXRlKCZjaW5vZGUtPmxvY2tf
c2VtKTsKIAl1cF93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJaWYgKHJjID09IEZJTEVfTE9D
S19ERUZFUlJFRCkgewogCQlyYyA9IHdhaXRfZXZlbnRfaW50ZXJydXB0aWJsZShmbG9jay0+Zmxf
d2FpdCwgIWZsb2NrLT5mbF9ibG9ja2VyKTsKQEAgLTEzMzEsOCArMTM1NCwxMCBAQCBzdHJ1Y3Qg
bG9ja190b19wdXNoIHsKIAlpbnQgcmMgPSAwOwogCiAJLyogd2UgYXJlIGdvaW5nIHRvIHVwZGF0
ZSBjYW5fY2FjaGVfYnJsY2tzIGhlcmUgLSBuZWVkIGEgd3JpdGUgYWNjZXNzICovCisJY2lmc19z
ZW1fb3BfdHJhY2VfZG93bl93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJZG93bl93cml0ZSgm
Y2lub2RlLT5sb2NrX3NlbSk7CiAJaWYgKCFjaW5vZGUtPmNhbl9jYWNoZV9icmxja3MpIHsKKwkJ
Y2lmc19zZW1fb3BfdHJhY2VfdXBfd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwogCQl1cF93cml0
ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJCXJldHVybiByYzsKIAl9CkBAIC0xMzQ1LDYgKzEzNzAs
NyBAQCBzdHJ1Y3QgbG9ja190b19wdXNoIHsKIAkJcmMgPSB0Y29uLT5zZXMtPnNlcnZlci0+b3Bz
LT5wdXNoX21hbmRfbG9ja3MoY2ZpbGUpOwogCiAJY2lub2RlLT5jYW5fY2FjaGVfYnJsY2tzID0g
ZmFsc2U7CisJY2lmc19zZW1fb3BfdHJhY2VfdXBfd3JpdGUoJmNpbm9kZS0+bG9ja19zZW0pOwog
CXVwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlyZXR1cm4gcmM7CiB9CkBAIC0xNTIyLDYg
KzE1NDgsNyBAQCBzdHJ1Y3QgbG9ja190b19wdXNoIHsKIAlpZiAoIWJ1ZikKIAkJcmV0dXJuIC1F
Tk9NRU07CiAKKwljaWZzX3NlbV9vcF90cmFjZV9kb3duX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2Vt
KTsKIAlkb3duX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlmb3IgKGkgPSAwOyBpIDwgMjsg
aSsrKSB7CiAJCWN1ciA9IGJ1ZjsKQEAgLTE1OTIsNiArMTYxOSw3IEBAIHN0cnVjdCBsb2NrX3Rv
X3B1c2ggewogCQl9CiAJfQogCisJY2lmc19zZW1fb3BfdHJhY2VfdXBfd3JpdGUoJmNpbm9kZS0+
bG9ja19zZW0pOwogCXVwX3dyaXRlKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlrZnJlZShidWYpOwog
CXJldHVybiByYzsKQEAgLTMxNDgsNiArMzE3Niw3IEBAIHNzaXplX3QgY2lmc191c2VyX3dyaXRl
dihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkKIAkgKiBXZSBuZWVk
IHRvIGhvbGQgdGhlIHNlbSB0byBiZSBzdXJlIG5vYm9keSBtb2RpZmllcyBsb2NrIGxpc3QKIAkg
KiB3aXRoIGEgYnJsb2NrIHRoYXQgcHJldmVudHMgd3JpdGluZy4KIAkgKi8KKwljaWZzX3NlbV9v
cF90cmFjZV9kb3duX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCWRvd25fcmVhZCgmY2lub2Rl
LT5sb2NrX3NlbSk7CiAKIAlyYyA9IGdlbmVyaWNfd3JpdGVfY2hlY2tzKGlvY2IsIGZyb20pOwpA
QCAtMzE2MSw2ICszMTkwLDcgQEAgc3NpemVfdCBjaWZzX3VzZXJfd3JpdGV2KHN0cnVjdCBraW9j
YiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICpmcm9tKQogCWVsc2UKIAkJcmMgPSAtRUFDQ0VTOwog
b3V0OgorCWNpZnNfc2VtX29wX3RyYWNlX3VwX3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCXVw
X3JlYWQoJmNpbm9kZS0+bG9ja19zZW0pOwogCWlub2RlX3VubG9jayhpbm9kZSk7CiAKQEAgLTM4
ODcsMTEgKzM5MTcsMTMgQEAgc3NpemVfdCBjaWZzX3VzZXJfcmVhZHYoc3RydWN0IGtpb2NiICpp
b2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKnRvKQogCSAqIFdlIG5lZWQgdG8gaG9sZCB0aGUgc2VtIHRv
IGJlIHN1cmUgbm9ib2R5IG1vZGlmaWVzIGxvY2sgbGlzdAogCSAqIHdpdGggYSBicmxvY2sgdGhh
dCBwcmV2ZW50cyByZWFkaW5nLgogCSAqLworCWNpZnNfc2VtX29wX3RyYWNlX2Rvd25fcmVhZCgm
Y2lub2RlLT5sb2NrX3NlbSk7CiAJZG93bl9yZWFkKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlpZiAo
IWNpZnNfZmluZF9sb2NrX2NvbmZsaWN0KGNmaWxlLCBpb2NiLT5raV9wb3MsIGlvdl9pdGVyX2Nv
dW50KHRvKSwKIAkJCQkgICAgIHRjb24tPnNlcy0+c2VydmVyLT52YWxzLT5zaGFyZWRfbG9ja190
eXBlLAogCQkJCSAgICAgMCwgTlVMTCwgQ0lGU19SRUFEX09QKSkKIAkJcmMgPSBnZW5lcmljX2Zp
bGVfcmVhZF9pdGVyKGlvY2IsIHRvKTsKKwljaWZzX3NlbV9vcF90cmFjZV91cF9yZWFkKCZjaW5v
ZGUtPmxvY2tfc2VtKTsKIAl1cF9yZWFkKCZjaW5vZGUtPmxvY2tfc2VtKTsKIAlyZXR1cm4gcmM7
CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJmaWxlLmMgYi9mcy9jaWZzL3NtYjJmaWxlLmMK
aW5kZXggZTZhMWZjNzIwMThmLi45Zjg5YTc2NWQ5NzcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21i
MmZpbGUuYworKysgYi9mcy9jaWZzL3NtYjJmaWxlLmMKQEAgLTE0NSw2ICsxNDUsNyBAQAogCiAJ
Y3VyID0gYnVmOwogCisJY2lmc19zZW1fb3BfdHJhY2VfZG93bl93cml0ZSgmY2lub2RlLT5sb2Nr
X3NlbSk7CiAJZG93bl93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJbGlzdF9mb3JfZWFjaF9l
bnRyeV9zYWZlKGxpLCB0bXAsICZjZmlsZS0+bGxpc3QtPmxvY2tzLCBsbGlzdCkgewogCQlpZiAo
ZmxvY2stPmZsX3N0YXJ0ID4gbGktPm9mZnNldCB8fApAQCAtMjA2LDYgKzIwNyw3IEBACiAJCX0g
ZWxzZQogCQkJY2lmc19mcmVlX2xsaXN0KCZ0bXBfbGxpc3QpOwogCX0KKwljaWZzX3NlbV9vcF90
cmFjZV91cF93cml0ZSgmY2lub2RlLT5sb2NrX3NlbSk7CiAJdXBfd3JpdGUoJmNpbm9kZS0+bG9j
a19zZW0pOwogCiAJa2ZyZWUoYnVmKTsKZGlmZiAtLWdpdCBhL2xpYi9yYXRlbGltaXQuYyBiL2xp
Yi9yYXRlbGltaXQuYwppbmRleCBlMDFhOTNmNDZmODMuLmJjODdmNzkwMzA0YyAxMDA2NDQKLS0t
IGEvbGliL3JhdGVsaW1pdC5jCisrKyBiL2xpYi9yYXRlbGltaXQuYwpAQCAtMjksOCArMjksNyBA
QCBpbnQgX19fcmF0ZWxpbWl0KHN0cnVjdCByYXRlbGltaXRfc3RhdGUgKnJzLCBjb25zdCBjaGFy
ICpmdW5jKQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJaW50IHJldDsKIAotCWlmICghcnMtPmlu
dGVydmFsKQotCQlyZXR1cm4gMTsKKwlyZXR1cm4gMTsKIAogCS8qCiAJICogSWYgd2UgY29udGVu
ZCBvbiB0aGlzIHN0YXRlJ3MgbG9jayB0aGVuIGFsbW9zdAotLSAKMS44LjMuMQoK
--000000000000be94d005956eeff8--

