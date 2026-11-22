Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795356096;
	b=zskRHewHHEvKHe5KBEqLCEMbvCl/dhIT9I0kQgLAsn1bllW/AwaF6vYMqOwFT1Lk/S8d
	 CMkP+XJMKdyLE+1Wie1KXQ7qWUk0UUNtlmujAhSj/JT6+NITEnqE8OgmfRjuy4MGDl19h
	 cN90AQhDhJm/2e63V+GgxTPoQ8Tu3bkvOBNWe7FTiH4ocd2LV+IHel4rWa4ai7gbLjwnr
	 43GOzqFYAnpU5CZUL0tRegipUYV7QMsCTkWzT4i7seuxCLjn/A/9EJNvGSsjA5kBt/NQ+
	 FNDMzE2K/r62nPxUamv3Yz6/C4buznQQ8M5ucnCDkEaah7W39dZQtFEbeQIR8JVeOrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795356096;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=Ac5T75nKhAOEN8GsTBdgzFdlr60mex3YgfV6IsITSSw=;
	b=nz0oJInQuz6jl0w0a7M1wpH1VqDG8GgCeTR/biJyXUG87Z+KhIa1vFpyzZXN2UMQ+O9N
	 q3GT4seaKxsF8cCjOiO+i8gfXB/Yjz5cbQx2u8n/9Ws1wVqlDdLOmxdXG81ZIrToV0oLF
	 B2pB9F+S50xLcmyj071+7cWx6jhw4kmdWotBxqV9laqjvNBf/H015AJMn98J3llVFg/Eg
	 UkGH8bEVlIdh8AF2c9Wa1uCyZbEZ1vk42qpHUVawgkhnMFV0RiYEqKkRjygolei908ZYF
	 pkRzXnMQ6gkUl0ZTss4iK4HyoIvt2ZOT7DGfdbTbmctxrlDv4B5Nb53FShODw/EPiEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F249606A332
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 14:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F249606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-57489477aabso2935364b6e.1
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 06:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795356095; x=1795960895;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ac5T75nKhAOEN8GsTBdgzFdlr60mex3YgfV6IsITSSw=;
        b=1kMNPgXEBd/ags1dRO0BnecXQS3J1P0dCiUWpHHgcgQ28BXA9+4/zp56IKvncStRwz
         qWhMzb0D4w+AneM1nK+OcfcG1t0aQMfjqoFpeB65mUPqgRG+SnzuSMw0TBojWTHODoJy
         AXCq3qG6CPbg67HwwNyr/33RUZA88LZ5T7CtZLS0OlcGF8cypH5j0+IG4ZZNQXyO5BgB
         I1WuIS6j0wgICSvRMVeOEbAOQJ1BKegKXoV9Z14NImte581IsWpTTLKkvuCWcR2JLH9M
         VP8LYl0mbuYmMlZKprKHubKDUUm8GH71Uyx5Kl9/t44cZfaUanactBbDeMNaC759zjwu
         +GJg==
X-Forwarded-Encrypted: i=1; AL+hErExRDNiYjXgRJg+4VIYSRYwAZk4Lq9R2573UDk8HaBLDk/QqGCwZQZbKpkt9s6YthdZSlu+da6lz/il@vger.kernel.org
X-Gm-Message-State: APuU4Z/M+FGIf7kURG+vApeGhGIf4RFU4MWHqmPn5lqpjYTSVPKikQri
	724P9L7oEXbxbUrm3Lmca3PVUn8d6bSHlupofHPZ0mqw7I2ZRH51MXtjew1Lrr9nHn43CpxoWFD
	J2ryaO4+s0UoCwRywUYb35lzBYIsFHwN/h+sakOFQ0Ngwx7tTQnZwNJIhFwk=
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1483:b0:579:f664:6619 with SMTP id
 5614622812f47-57a056c8503mr8925121b6e.1.1795356094997; Sun, 22 Nov 2026
 06:01:34 -0800 (PST)
Date: Sun, 22 Nov 2026 06:01:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b02f5be.71deaa98.2984e6.0004.GAE@google.com>
Subject: [syzbot] [cifs?] WARNING in smbdirect_connect_rdma_event_handler
From: syzbot <syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com>
To: linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, metze@samba.org, pc@manguebit.org, 
	samba-technical@lists.samba.org, stfrench@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d0f871bfb831 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107cbabd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d16c0eae9c338e3c
dashboard link: https://syzkaller.appspot.com/bug?extid=a989758ffc6f93223eb6
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/14c5ba415020/disk-d0f871bf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/90aa1edd6ee8/vmlinux-d0f871bf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/45d67d635102/bzImage-d0f871bf.xz

The issue was bisected by AI to:

commit d1f187656797fc7434388c1795e05f8abe370d46
Author: Stefan Metzmacher <metze@samba.org>
Date:   Mon Sep 1 14:10:49 2025 +0000

    smb: smbdirect: introduce smbdirect_connect[_sync]()

AI reasoning:   https://syzkaller.appspot.com/ai_job?id=d29fe03c-f946-4e73-8c7d-eddda90b1783

AI-generated root cause summary:
smbdirect_connect_rdma_event_handler() accesses sc->first_error and sc->status
without synchronization or READ_ONCE/barriers against concurrent teardown in
smbdirect_connection_wait_for_connected(),
__smbdirect_socket_schedule_cleanup(), and smbdirect_socket_destroy_sync(),
which modify sc->first_error and sc->status (to SMBDIRECT_SOCKET_DISCONNECTED)
before acquiring rdma_lock_handler(sc->rdma.cm_id). When the waiter is
interrupted by a signal (-ERESTARTSYS), the cleanup/destroy path can advance
sc->status to SMBDIRECT_SOCKET_DISCONNECTED and set sc->first_error =
-ERESTARTSYS between the handler's sc->first_error check and its sc->status
check in SMBDIRECT_CHECK_STATUS_DISCONNECT(), triggering the WARN_ONCE at
fs/smb/smbdirect/connect.c:307. Moreover, because smbdirect_socket_destroy()
disables work items before taking rdma_lock_handler(), the same race allows
smbdirect_connect_rdma_connect() to re-initialize and schedule
sc->idle.timer_work after it was disabled, risking a use-after-free after sc is
freed.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=a989758ffc6f93223eb6

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com

The cause commit was identified by AI and may be wrong.
If you agree with it, please also add:
Fixes: d1f187656797 ("smb: smbdirect: introduce smbdirect_connect[_sync]()")

------------[ cut here ]------------
expected[RESOLVE_ADDR_RUNNING] != DISCONNECTED first_error=-ERESTARTSYS local=127.0.0.1:51036 remote=127.0.0.1:445
WARNING: fs/smb/smbdirect/connect.c:307 at smbdirect_connect_rdma_event_handler+0x1e02/0x2820 fs/smb/smbdirect/connect.c:307, CPU#1: kworker/u8:7/198
Modules linked in:
CPU: 1 UID: 0 PID: 198 Comm: kworker/u8:7 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Workqueue: rdma_cm cma_work_handler
RIP: 0010:smbdirect_connect_rdma_event_handler+0x2086/0x2820 fs/smb/smbdirect/connect.c:307
Code: df 41 0f b6 04 06 84 c0 0f 85 67 06 00 00 49 63 8f 98 00 00 00 48 89 df 48 c7 c6 20 a8 be 8b 4c 89 ea 4d 89 e0 4c 8b 4c 24 08 <67> 48 0f b9 3a 4c 89 ff 48 c7 c6 60 97 be 8b 31 d2 48 c7 c1 6f 55
RSP: 0018:ffffc90004257a08 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff90dcd1d0 RCX: fffffffffffffe00
RDX: ffffffff8bbeab40 RSI: ffffffff8bbea820 RDI: ffffffff90dcd1d0
RBP: ffff8880295a2098 R08: ffff888062fdc020 R09: ffff888062fdc0a0
R10: 0000000000000100 R11: 0000000000000012 R12: ffff888062fdc020
R13: ffffffff8bbeab40 R14: 1ffff110052b4413 R15: ffff8880295a2000
FS:  0000000000000000(0000) GS:ffff888124804000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a41662068 CR3: 00000000352ee000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 cma_cm_event_handler+0xac/0x2c0 drivers/infiniband/core/cma.c:2181
 cma_work_handler+0x265/0x520 drivers/infiniband/core/cma.c:3040
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	41 0f b6 04 06       	movzbl (%r14,%rax,1),%eax
   5:	84 c0                	test   %al,%al
   7:	0f 85 67 06 00 00    	jne    0x674
   d:	49 63 8f 98 00 00 00 	movslq 0x98(%r15),%rcx
  14:	48 89 df             	mov    %rbx,%rdi
  17:	48 c7 c6 20 a8 be 8b 	mov    $0xffffffff8bbea820,%rsi
  1e:	4c 89 ea             	mov    %r13,%rdx
  21:	4d 89 e0             	mov    %r12,%r8
  24:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
* 29:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2e:	4c 89 ff             	mov    %r15,%rdi
  31:	48 c7 c6 60 97 be 8b 	mov    $0xffffffff8bbe9760,%rsi
  38:	31 d2                	xor    %edx,%edx
  3a:	48                   	rex.W
  3b:	c7                   	.byte 0xc7
  3c:	c1                   	.byte 0xc1
  3d:	6f                   	outsl  %ds:(%rsi),(%dx)
  3e:	55                   	push   %rbp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about AI bisection see: https://goo.gl/tpsmEJ#ai-bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
