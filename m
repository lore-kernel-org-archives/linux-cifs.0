Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766DB2BE629
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 04:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763007991; cv=none; b=n3YsBf7FNwZdfjo4hR5EA5xp5FVivO2hBPNLJt8qmSL9fiXxDebOqdNDAOmq7yFM9aszHobXf+E1zEX0V+NXdacp781XCTVRmdPoS63zm9cuALpLu/jg/50mKO+6reDbSAj/RGG6vckIjZAvhvJSX/ctuByGJYuPfoyI53hyDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763007991; c=relaxed/simple;
	bh=h0INBf89Mp9+J6NVNbApuTqiFkExLITyHns+5BnmXKk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XhAA7DHbNvE7iCak9LBLbioM9op91OauNyRkTSGVX2RBkASeLA/mJScaEaoLwNNSFeIjBGT4fO7bbXNnqjBdOBHdrOG/1c6Mrjdl5sbSQGdAzibuFLJ5AbfDj5IYjfnIBHfQje5mTuqe9C2uUiOUONB8kJ/Xp7yl333m/9+WUDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-433692f7479so18115755ab.3
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 20:26:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763007988; x=1763612788;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ydHVQNe2srJLJGp2D/A0QPLHXTjGyY6A2XrZzcrWi1Q=;
        b=qzbseFm0YskG8ncM/h2TD2N2WmUME7jrQYPxsNm/09ICE7SRRlMJIlBkXzJ0491lut
         /Tw0WyRUxzfk6TRDD38h1nr5oHln5xVeXUSkXbYwOPfzca4V3BA3q1rN8uCyFZQnfSxk
         PH6dGGnY/4har8FYwjC0Luw1bdpdBidPASxV3JxPk2sM3KO3MYGGi/TOUzz03HGQQ670
         h0JuxIaE5ThD5uWM1ug60aXuJWf7XFbjgx9DiNKUAfvXN9vP0IOyxJM7rbvonYX9dKEh
         fiNR6sSPQgkRMwwO7o49LfOfiMEP24U6SJIM5io8XH8sybjhSPA8nke7VMQwQOnAjF1l
         Bh8w==
X-Forwarded-Encrypted: i=1; AJvYcCXdmZsxmRskiA+dHMgd4c8A2dZn/P98TZzKslql3fvmtQsEeEXMPIsfCHYFox8U6PfJljVcN/b2NdaU@vger.kernel.org
X-Gm-Message-State: AOJu0YxgXGYONszYrH7wKspuGXUdVphM2fSrVsJcUknRwfJc4ezkXq93
	7ZiY5CS7JdsyRJgk/Ki0v6Dy+JDT+KBoQgJsxQjZRvfyaNfLlcl6zJVhED1fk0iteiknv/zn3Lp
	TZBDLzt/vKLIK17/FqD0BtHhSXgTeL+MRzy+H704cdkuEdzVs6v7ccYu7Oj4=
X-Google-Smtp-Source: AGHT+IHXrfGrzI9sEMMFVaBVE7dJZIIx6+86VFCDEXXhBEvo6fy/89IuSzROtjYJoDB0IT8eOAHfShX8nYEaKj6G82SPNeKbhssH
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e04:b0:433:7d37:38ea with SMTP id
 e9e14a558f8ab-43473dae01emr61075365ab.24.1763007988701; Wed, 12 Nov 2025
 20:26:28 -0800 (PST)
Date: Wed, 12 Nov 2025 20:26:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Subject: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
From: syzbot <syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4ea7c1717f3f Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b75c12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
dashboard link: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15350658580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160d960a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1f8cf51c9042/disk-4ea7c171.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6f227246b5b7/vmlinux-4ea7c171.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f935766a00b3/bzImage-4ea7c171.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com

2025/11/11 03:33:01 executed programs: 5
BUG: memory leak
unreferenced object 0xffff888110616300 (size 192):
  comm "syz.0.17", pid 6091, jiffies 4294942682
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5658
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
unreferenced object 0xffff888110616180 (size 192):
  comm "syz.0.17", pid 6091, jiffies 4294942682
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5755
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
unreferenced object 0xffff888128172cc0 (size 192):
  comm "syz.0.18", pid 6093, jiffies 4294942683
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5658
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
unreferenced object 0xffff888128172180 (size 192):
  comm "syz.0.18", pid 6093, jiffies 4294942683
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5755
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
unreferenced object 0xffff888128172000 (size 192):
  comm "syz.0.19", pid 6098, jiffies 4294942685
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5658
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
unreferenced object 0xffff8881281723c0 (size 192):
  comm "syz.0.19", pid 6098, jiffies 4294942685
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_node_track_caller_noprof+0x3aa/0x6b0 mm/slub.c:5755
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
unreferenced object 0xffff888128172c00 (size 192):
  comm "syz.0.20", pid 6128, jiffies 4294943222
  hex dump (first 32 bytes):
    2f 2f f2 2f 06 08 2f df 2f 6f dc ea 95 9a 82 10  //./.././o......
    97 57 8f 37 98 9b 2f f9 0d 6d 44 94 29 55 db 15  .W.7../..mD.)U..
  backtrace (crc 93bb458c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5658
    kmalloc_noprof include/linux/slab.h:961 [inline]
    smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:629
    smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_context.c:1438
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
