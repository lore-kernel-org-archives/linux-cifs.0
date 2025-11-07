Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B3424DD1F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Nov 2025 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762500631; cv=none; b=fVFlt0BCpXwCmPQmy17YbfroxAziJN7gXuBTc9PXDQTG9Nm6j0ZYGHQAx8K+sZMK+1eyQX4bis8ON5Oxc+9n8bMgwStS6wXZ7qZxjMwB0nGWWViCvmyeIuUVOgNRdNvjRv/zDbonySNLu7HByWeEMNY5kVP6r0sNTmpIT23dZq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762500631; c=relaxed/simple;
	bh=PmuoT3c8H1nbh0QIg54m2H7tK1X89lomLu0DJ4gC6vk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BsFvsaAZk88CTS7ErJXeyvlfcwi3nJHZsFB85asJA2qmFffj/d3VJcpNHKUR9+/TWFEHlblLqYOJUxVZ+s+nHxu7+tFOx7A45vhtsFH2xSAPKBn0rUirbhYkuJbMqg66X6uCArzJ/7LzxwIICpEhNPiut9J7oqPirIEFx8oX+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-433296252f8so11979745ab.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 23:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762500628; x=1763105428;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wvhS3yJ5RI+iBD3kWFB7/BHHupDd3V14Ik9agSFoCEU=;
        b=Bi12yTU8fT/2pTcjPEcOeWaqpSxTJoYJCj9wKgdMC7nyqL+yTVEluDEHauJVd4Q9p5
         ei4+KdGnn555iS4e9KwKBh2KrTOc/7/PESIGCIXxEUWAMHDYkYWC8Hqvya1OHj3H9Oad
         LamH2b5B5Hny/Yp/MmPKt2QlVJ6zJ9DDRpTFlUUDb8ZJyOF/edUjbPfLInK8Sj6Ts5W9
         b0YQeIR5Zj3Cnr/jc73VHcz0GwIXRRYDX8BpfoKHeadoAyUiIyiTQhZyYfkGwOVV0bmi
         qxPF++BiNxDJI4vMEiY4ycoqi3/RaIu67HRpJVzTN5aoFulsS/JHMfdbiRBqQXxjfJZn
         adYg==
X-Forwarded-Encrypted: i=1; AJvYcCX81fEGeLkwdlCNVS9B8XwIwvAkoLNS9Gz0gg2ID0pqFdz7hWLxfRLB5d138T5FX7oxiO5lEElfx+hP@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr7kH8hw+XGtLbXXqHvON/HugFHMY1KnFx29TQ4OVoF3i2kDlH
	Gb3Yr+mGpbFNMe0fN2mK1SVBvOxxRBR0wAYFjaunFP7UExgWd2OiBhZx8IZBnPCGIRBX141aFGT
	xJr9aVGlgJPi+W/pJi6P0LdB3m26RbjkuW43/SjiuCKsTgcyz9s7VnOeR/kU=
X-Google-Smtp-Source: AGHT+IFJk0Ewu+jeYb+KnQD2z6NrRThAVFqW/pLK+NL0wuCeR3kb4YjsvP6XIDWgVBnDoviUPxi+rly+NBHelhzxQuqwhXQ+GFhj
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2283:b0:433:4f00:5d0c with SMTP id
 e9e14a558f8ab-4335f441229mr27971185ab.20.1762500628341; Thu, 06 Nov 2025
 23:30:28 -0800 (PST)
Date: Thu, 06 Nov 2025 23:30:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690da014.a70a0220.22f260.0026.GAE@google.com>
Subject: [syzbot] [cifs?] memory leak in smb3_fs_context_parse_param
From: syzbot <syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2c2ccfd4ba7 Merge tag 'net-6.18-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127d2a58580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
dashboard link: https://syzkaller.appspot.com/bug?extid=72afd4c236e6bc3f4bac
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104c7012580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1206e17c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b0451ba3fe41/disk-c2c2ccfd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d3e8c67119ab/vmlinux-c2c2ccfd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d8e176e5054/bzImage-c2c2ccfd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com

2025/11/07 05:48:37 executed programs: 5
BUG: memory leak
unreferenced object 0xffff888108910420 (size 96):
  comm "syz.0.17", pid 6085, jiffies 4294942570
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5751
    __kmemdup_nul mm/util.c:64 [inline]
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888128afa060 (size 96):
  comm "syz.0.18", pid 6087, jiffies 4294942571
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5751
    __kmemdup_nul mm/util.c:64 [inline]
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888128afa300 (size 96):
  comm "syz.0.19", pid 6090, jiffies 4294942572
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888128afa360 (size 96):
  comm "syz.0.19", pid 6090, jiffies 4294942572
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5751
    __kmemdup_nul mm/util.c:64 [inline]
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888112c7d900 (size 96):
  comm "syz.0.21", pid 6128, jiffies 4294943114
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888112c7d420 (size 96):
  comm "syz.0.21", pid 6128, jiffies 4294943114
  hex dump (first 32 bytes):
    2f 2f f2 62 06 08 ba df 58 6f dc ea 95 9a 9b 2f  //.b....Xo...../
    51 39 f9 0d 6d 44 94 29 55 db 15 58 2e 49 0a 7d  Q9..mD.)U..X.I.}
  backtrace (crc 79c9c7ba):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5751
    __kmemdup_nul mm/util.c:64 [inline]
    kstrdup+0x3c/0x80 mm/util.c:84
    smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_context.c:1444
    vfs_parse_fs_param+0xf4/0x190 fs/fs_context.c:146
    vfs_fsconfig_locked fs/fsopen.c:303 [inline]
    __do_sys_fsconfig+0x7d3/0x900 fs/fsopen.c:473
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
