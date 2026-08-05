Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B1353A8A
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 00:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888037; cv=none; b=FdSSzHXBOVJj1mSimSwD3JcveAHVvrT8VGC5MNY80wiMek+RKxaC9X6yk2nnRKLyhFlXoRrgTCvimjwcVve0jEWnKNQoaxvtoTG3czqg5vuImVzCjQPag3bVL6arz/pgdZccbEzFY7nOONE3Z15t5zoI+jViN7xNoonXGTyHD1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888037; c=relaxed/simple;
	bh=tqCXa5RpdTiH8CMXe4RrLbA0dS1waBXFcrnXXqj2jKM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ty5wsS4j5Azdd1rBAVClTSLVGJAGGNzVgmNJvtcOIg+mBVgPhOVd+wcz5a59Yoi8eYBjCaA+a0PKerq9KTN9/RSLySBv4I2NvfyQt6Gt1CWAWVLkO7Qhmf93JtURuoey+oabCGcqm/Na9MtQCuNqAkolBcgCe9K4BB2VYTBcvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6ae8bc06f00so391001eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 17:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785888035; x=1786492835;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hHUeae2DjQEe7Wyd++T/vRBkiuFzCW3smhqZbf77/qs=;
        b=kuip47jkwOGqy44xoPeK2Yf1cKvtNAJahOzG8vg/XWOIYXLpPRQk8aT0UI2qAqKRR3
         cnaueYb4pyrk9X6lnst+Fc2ZXzqLnAglSSBqMh/zB0Ga5Vmodroao0fxYW9MRmd9YLpH
         SYNQYKSFaDv0sX53AXvCuNGmM1SytvKrQW51BvoJZ9BVhHbXMdOU9QUi1fRoO0/yyflK
         yLLlPDMZ8OPCfTHxpJzcHpiWVeNz5qiz/seSq7gzTz2NHSLEXzNkC0XXUDWLwpNZctpM
         TKpmknKjvq0jXA6ckgsHXuHDG/oA7+Zi2eU3dXVTTT0yWBVuvu4TuJn89jsNo+fnVgMH
         7Bgw==
X-Forwarded-Encrypted: i=1; AHgh+RotQuBMIOfjeYjMlum59y6bzYBEd0uJWFUcpHF5vmcYpvRH02dP3+n/oBI3cNjCIEIYyMuIlEoptkOa@vger.kernel.org
X-Gm-Message-State: AOJu0YxSKaAzRhudlSip51OsrflkEkfHkXd/E82EbY5FUfBpjYyIROc6
	059xVn3zddBHkKH3QESYFVjJd3DYmulE5vz2gb2HutcqoM/z6ROGjUkkzG7p09wiSgcxfaZHGLw
	T5QdzPde95b7R+dPRZ8+Q+v0O3v5Y2bui/cY6MqouBJ6HYJ+8mCMkzNnSZfg=
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b8b:b0:6ac:b07c:b34b with SMTP id
 006d021491bc7-6ae96c126femr1689557eaf.4.1785888034739; Tue, 04 Aug 2026
 17:00:34 -0700 (PDT)
Date: Tue, 04 Aug 2026 17:00:34 -0700
In-Reply-To: <6a6d3f57.6ce73036.24301b.000f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a727d22.40259c87.584f4.04ce.GAE@google.com>
Subject: Re: [syzbot] [cifs?] WARNING in smb2_add_credits
From: syzbot <syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	syzbot@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13947e32580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=eeb58d2197d88720a228
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174b13b9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f47649580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/32c9dc084aaa/disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b7604244b0a9/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4cd321f6fe47/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com

CIFS: VFS: \\127.0.0.1 Error -32 sending data on socket to server
------------[ cut here ]------------
server->in_flight == 0
WARNING: fs/smb/client/smb2ops.c:104 at smb2_add_credits+0x1213/0x1790 fs/smb/client/smb2ops.c:104, CPU#0: syz-executor203/8920
Modules linked in:
CPU: 0 UID: 0 PID: 8920 Comm: syz-executor203 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:smb2_add_credits+0x1213/0x1790 fs/smb/client/smb2ops.c:104
Code: c6 e8 d1 e9 b5 fe 84 db 0f 85 0a fb ff ff e8 b4 ef b5 fe 48 8d 3d 9d ad d5 0d 67 48 0f b9 3a e9 f4 fa ff ff e8 9e ef b5 fe 90 <0f> 0b 90 0f b6 05 9c e3 b5 0d 31 ff 89 c6 88 44 24 28 e8 96 e9 b5
RSP: 0018:ffffc90008187208 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888032dce300 RCX: ffffffff835465cb
RDX: ffff88802c5d8000 RSI: ffffffff83547542 RDI: ffff88802c5d8000
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90008187448
R13: 0000000000000200 R14: 0000000000000001 R15: ffff888032dce000
FS:  00007f73289316c0(0000) GS:ffff888123dd8000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f73289d463c CR3: 0000000071a37000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 add_credits fs/smb/client/cifsglob.h:894 [inline]
 compound_send_recv+0x1030/0x2a10 fs/smb/client/transport.c:979
 cifs_send_recv+0x43/0x60 fs/smb/client/transport.c:1106
 SMB2_negotiate+0x15c4/0x5380 fs/smb/client/smb2pdu.c:1188
 cifs_negotiate_protocol fs/smb/client/connect.c:4043 [inline]
 cifs_negotiate_protocol+0x268/0x4c0 fs/smb/client/connect.c:4014
 cifs_get_smb_ses+0xfc9/0x2170 fs/smb/client/connect.c:2492
 cifs_mount_get_session+0xf8/0x460 fs/smb/client/connect.c:3578
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3860
 cifs_smb3_do_mount+0x2c0/0x1b20 fs/smb/client/cifsfs.c:1024
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1700
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount fs/namespace.c:3841 [inline]
 path_mount+0x7d0/0x23d0 fs/namespace.c:4161
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount fs/namespace.c:4367 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7328959099
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f73289311d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f7328a09b48 RCX: 00007f7328959099
RDX: 0000200000000400 RSI: 0000200000000300 RDI: 0000200000000200
RBP: 00007f7328a09b40 R08: 0000200000000500 R09: 38203a6b63617473
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f73289db378
R13: 0000200000000200 R14: 0000200000000400 R15: 0000200000000300
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
