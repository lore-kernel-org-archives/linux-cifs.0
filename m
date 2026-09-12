Received: from mail-oo2-f5.google.com (mail-oo2-f5.google.com [74.125.231.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842282D9484
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 00:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789174066; cv=none; b=QWJzAtQ5WWZleaO0juEGoqYe+izPkw0oyBvz+UVhKHwk2Qen3sGxiuo7m82QR9k+UrBiaA5438/2aDPr57olVfA5laCiVXmR0AOKCgr5hUtc9PAaDRr/YzQkDd7sKlVBgSNk4dPB8popmgElFNQvoGoKfUIAxIM+12PwmlEyPaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789174066; c=relaxed/simple;
	bh=gMuliW5QjP2cRZymyy5ef4oU1RFUpLf2LDkUinKWE8Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Lwhj+mN+EPrGe2kTTmdIcmC3+gGpOS15tHNaoXec2s9BGgiGuxGbCczK4E6Fe0Pp6OJjmq46n8RKqM0u5VknwHR4SVzNXfAn3FcpL9xbW2YFhPwCNtMUZy6h5zu+9RhjP8norNY3DlErZCCcKD3a+WIFsbmS4zxeCvOorN5cNFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f5.google.com with SMTP id 46e09a7af769-7f4e6693089so504058a34.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 17:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789174061; x=1789778861;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=seRlCS++4FDyl1r7S13VogHo/qZgqTrgoFbcFWoWHnI=;
        b=XRg7K58HGGXyqo7FpVqqlc6R93EdCWTPGJmhlYDxOWs+LdRnzMisZWdMJ+Dg1D4S0R
         SCfKLQFIcDWBLzuXOu0P+V3pT8yebMoRkooHZCTgtQbmZIZKc+U/egEpi0BV+sCAMwfw
         raJDbbwfrf0X/NcYJdePNjMfT9PP3IrT90qQHM0BWPxthb7aoLosaaqI8W8l6JGYMhGc
         wAwjjiv4Br0VzL1SfqLDIIduyzjl3HbKKxCplQQMhwGfyuiyBv0bDWGVBVU48uGWcUGz
         O1xMWwlzT3LOAEjo3FY3nuxfD3Voz83ncHiHPgoqFuATf/n/PZbo9xfVCvVkKmSwWEgv
         XszQ==
X-Forwarded-Encrypted: i=1; AKwUvBz14VG5U83Md2s2+dt64dlHU1UM+JuH53b89lUZo/XWdjFl8fD9+imf3Mk5vjo+/SGQNwqPltPVpWhQ@vger.kernel.org
X-Gm-Message-State: AFuF++njT36PZRhfJV/8ru5CT3QDNRnY20h2Pq2tjBnmgRZZN1XxFCPP
	l/a2W3RLcw9HabfFpw4vTdzmiMfIXdKthfglWzDFOnjid8k9SZ1XKSRuhn5LD5O02rZf5cK1Yi0
	34CVTdq4yrx5oykUKcea51Y81E5xQ4jZbHAr1sHIdm7TNYdJpo6hr7X1/fTE=
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:5605:b0:6b1:b33a:db69 with SMTP id
 006d021491bc7-6c0bb3f863cmr6673662eaf.15.1789174061360; Fri, 11 Sep 2026
 17:47:41 -0700 (PDT)
Date: Fri, 11 Sep 2026 17:47:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa4a12d.f81106d8.2ab401.0023.GAE@google.com>
Subject: [syzbot] [cifs?] KASAN: slab-use-after-free Read in smb2_reconnect_server
From: syzbot <syzbot+5003556314abc915a71f@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    df2908090cda Linux 7.3-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=172f6af9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19560cab9a915237
dashboard link: https://syzkaller.appspot.com/bug?extid=5003556314abc915a71f
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/16e15edbf5cd/disk-df290809.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ccece7686f7/vmlinux-df290809.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d0faf024d724/bzImage-df290809.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in smb2_reconnect_server+0x1a9a/0x1b80 fs/smb/client/smb2pdu.c:4257
Read of size 4 at addr ffff888021aca078 by task kworker/1:1/30

CPU: 1 UID: 0 PID: 30 Comm: kworker/1:1 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Workqueue: cifsiod smb2_reconnect_server
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 smb2_reconnect_server+0x1a9a/0x1b80 fs/smb/client/smb2pdu.c:4257
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 9709:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f20 fs/smb/client/connect.c:1758
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3570
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3860
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1947
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount fs/namespace.c:3848 [inline]
 path_mount+0x7d0/0x24c0 fs/namespace.c:4168
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount fs/namespace.c:4374 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 9713:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6499 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6792
 clean_demultiplex_info+0x98a/0xe90 fs/smb/client/connect.c:1146
 cifs_demultiplex_thread+0x5b5/0x2ea0 fs/smb/client/connect.c:1439
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
 insert_work+0x36/0x230 kernel/workqueue.c:2272
 __queue_work+0xa60/0x1370 kernel/workqueue.c:2448
 __queue_delayed_work+0x357/0x450 kernel/workqueue.c:2617
 mod_delayed_work_on+0x195/0x1c0 kernel/workqueue.c:2705
 mod_delayed_work include/linux/workqueue.h:730 [inline]
 cifs_queue_server_reconn fs/smb/client/cifsglob.h:2340 [inline]
 cifs_queue_server_reconn fs/smb/client/cifsglob.h:2336 [inline]
 __cifs_reconnect+0x51d/0xa80 fs/smb/client/connect.c:431
 _cifs_reconnect fs/smb/client/connect.c:590 [inline]
 cifs_reconnect fs/smb/client/connect.c:604 [inline]
 cifs_readv_from_socket+0x7c1/0xa30 fs/smb/client/connect.c:743
 cifs_read_from_socket+0xb8/0x100 fs/smb/client/connect.c:798
 cifs_demultiplex_thread+0x2db/0x2ea0 fs/smb/client/connect.c:1288
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888021aca000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 120 bytes inside of
 freed 4096-byte region [ffff888021aca000, ffff888021acb000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21ac8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801c02e140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801c02e140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4981, tgid 4981 (udevadm), ts 33953960392
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7410
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x67c/0x840 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 tomoyo_realpath_from_path+0xb6/0x690 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x2af/0x3c0 security/tomoyo/file.c:776
 tomoyo_file_open+0x6b/0x90 security/tomoyo/tomoyo.c:334
 security_file_open+0xb5/0x1e0 security/security.c:2739
 do_dentry_open+0x588/0x14d0 fs/open.c:973
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5000
 do_file_open+0x20e/0x430 fs/namei.c:5029
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
page last free pid 4981 tgid 4981 ts 33942031212 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __kmalloc_cache_noprof+0x278/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 kernfs_get_open_node fs/kernfs/file.c:536 [inline]
 kernfs_fop_open+0x9fa/0xd50 fs/kernfs/file.c:711
 do_dentry_open+0x6ab/0x14d0 fs/open.c:996
 vfs_open+0x82/0x3f0 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x19fa/0x2440 fs/namei.c:5000
 do_file_open+0x20e/0x430 fs/namei.c:5029
 do_sys_openat2+0x10f/0x1e0 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x12d/0x210 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888021ac9f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888021ac9f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888021aca000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff888021aca080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021aca100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
