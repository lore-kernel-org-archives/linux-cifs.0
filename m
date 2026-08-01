Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2936308A
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 00:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785544542; cv=none; b=COzxPPTcYmvnlN4omXEgcQcCeyvypeZw0ZRAIV+XuHfsh2WFzrbMFLOOE7lbTrNx3N+2BoUIp41E9aVwXf1qAie/SuAU/f44ST9RF/Csh/DjWulRYkDI0mpWowWL/68CCNbuk4E3kYBSVIGt0Qmfr+Ulug+xn25LpfmCJC2pKog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785544542; c=relaxed/simple;
	bh=EhUyWK4U45j4xnYzFM9BHzD1uQML/96WylaD2Tyn9c0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pJzYPky+lIv18GQ6befvfpjX8gTOxwFNWqnBYunt5E6OHrKGODjKDWZmlwPdzsHsg48NvTGMDcCQNFQfYyhBk6OzaJCJnchLv0rnT4g/d7qaMRPl6RkPPtuidNb2rAdMp+h0VQiUef6XjJdFlK8C8HICLBFkaBLAWtruOFNIVA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4a485034d01so2338393b6e.3
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785544535; x=1786149335;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJfQBso+K6JNjiOS6Td46OwHlphadW08iCnYeD1GfvA=;
        b=B+W/ZEvIlkBUWzCNPiCahvujji8hrgdoGCPs8t4dL0iLSZIxVedeA1PorQs/iOuaXV
         y7HuGXX471Df0Qlf8jWixg3VHCRwvwgZDKNNFDKKB3UyhyLCgpnkyv9IT1dz8gZ3R0Fd
         u6ikljk+bk1l3HYvohjLGXr8Bk6f2waMP/hF39cGZKJEpZikYnrybUVbs3jRlIkE4+qu
         aye14+BBngxbd81p6bbAxzWDpHk/MKOwKVdSnSw5ANnKs41j1va2GR9XbNZ0DwZcQzaU
         2JfEapaaZfaTY7alvxqhJt0xMVcf0WSSvkY7DiV/lFS11XSyz+bs2pV23h1W7cLQx7ei
         D0qg==
X-Forwarded-Encrypted: i=1; AHgh+RpTme7feyRfj/9HBWaRHz9EohWJXD4FOZx7wwOnz0ZtlzDjZnvdpvPbSxI8SD+lmfHLXEP/We7mDkpZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyxIbt5OFf4YbKTNjEuYQeyzwLXhLZcmhBQbCmyf0DJxrQ8r0iV
	fm9fH7NAXrOTOtx6I1T0RBUqFBv86Z+F8Iu1mZnsjXkNIN7CVJg5lPAx9fyUs7XoP0o0oxD7wiF
	s7pozJNIfvxU1BjV0LxLyDytGXsBIMlznE0X9qW2LuQzxfXbVVElkVAp9XyA=
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5242:b0:4ae:f5be:fe30 with SMTP id
 5614622812f47-4af5e2eacc9mr3827298b6e.18.1785544535088; Fri, 31 Jul 2026
 17:35:35 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:35:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d3f57.6ce73036.24301b.000f.GAE@google.com>
Subject: [syzbot] [cifs?] WARNING in smb2_add_credits
From: syzbot <syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f5098b6bae76 Linux 7.2-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d5d1b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=eeb58d2197d88720a228
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12299632580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2113dcf433f6/disk-f5098b6b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/413e673b7de4/vmlinux-f5098b6b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc40c1b83e80/bzImage-f5098b6b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com

CIFS: VFS: \\127.0.0.1 Error -104 sending data on socket to server
------------[ cut here ]------------
server->in_flight == 0
WARNING: fs/smb/client/smb2ops.c:104 at smb2_add_credits+0x1213/0x1790 fs/smb/client/smb2ops.c:104, CPU#0: syz.2.443/8120
Modules linked in:
CPU: 0 UID: 0 PID: 8120 Comm: syz.2.443 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:smb2_add_credits+0x1213/0x1790 fs/smb/client/smb2ops.c:104
Code: c6 e8 21 ea b5 fe 84 db 0f 85 0a fb ff ff e8 04 f0 b5 fe 48 8d 3d ad 9f d5 0d 67 48 0f b9 3a e9 f4 fa ff ff e8 ee ef b5 fe 90 <0f> 0b 90 0f b6 05 87 d6 b5 0d 31 ff 89 c6 88 44 24 28 e8 e6 e9 b5
RSP: 0018:ffffc90005cbf2d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88805d5ee300 RCX: ffffffff835460db
RDX: ffff88801c79ca80 RSI: ffffffff83547052 RDI: ffff88801c79ca80
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90005cbf518
R13: 0000000000000200 R14: 0000000000000002 R15: ffff88805d5ee000
FS:  00007f783f8496c0(0000) GS:ffff888123ddc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000077f4543a020 CR3: 000000002b566000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 add_credits fs/smb/client/cifsglob.h:894 [inline]
 compound_send_recv+0x1030/0x2a10 fs/smb/client/transport.c:979


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
