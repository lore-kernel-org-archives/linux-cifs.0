Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792458341;
	b=gt3SLKmBfhEPZWKZ/asYMLf0LvI3MvnF6flWS9BLx5aBVzppuTat67QVx53EtXPN5Ugw
	 EIU2SUqiednb1mhILnNzRyEUOliBdqKEUhcppTlOvJzPzexPhp/gTAuQWEbpBC2VQmuTK
	 OUoADEwomuYUzKr583Dvx7h5un9i6qmqPPlB4TzBoo1kCedTIxUV1rQEnH6IYIo0Y4KME
	 87HbQvwWp4g5TEv+nlL7GtI1sqHwf73ke7dDKYT5BffrHTlp3yYkqmAr07wbGtKgVTrvk
	 iAkeGG9LoT9LekB/abBWeNvpNZLzXJL0znDEB74If1v8+xPB5hHr+Hk9azJXTqITrew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792458341;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=71xlRhy0KQqFKDLpjD4JcOfEoZi763hKFB0PEaFGPMA=;
	b=gny2Nw62txNZpflElPcDCE//qPb7aiHY+CnJHW/zzUJJKM3wDjMxU195/9q1MKA3/bgz
	 zc+OXmb6EWLVY2XzfVGBlUItGGj9tisxkFthZB8o3pFxmPflWA3PFme0UxqDFRTy8piEr
	 8uAdAvquVzaGEHmH+vvAyzLSSfgrt1wObQzHRHkoXSU01RGf1lwA6Dh8w/bm3+i72LV7M
	 OpD5OYYzfDxL0aPBHbajFdYfZ7qvxSljPY7Sn3XqXQiMVM/LTUWYW4YDABRBSi6NDrStm
	 V8HF0X5KlX4agsL/2sjNCH4I7D0kTd0rsAk4jxy2MZ7GiQVZ/fINrwJcXw66YG/G42w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27DA606A31A
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 01:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A27DA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-54213290993so1091457b6e.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 18:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792458339; x=1793063139;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=71xlRhy0KQqFKDLpjD4JcOfEoZi763hKFB0PEaFGPMA=;
        b=sv7P++hYO3zMEbugI/hgEWx5EMheD3YbIBtkFHKZ5IVtrYC/mwgclY5/eYoDvNQGIm
         lenzEGNbiqPHGkfZLfgH23xk8jMuJUsTeKZkG6YG2TRXroCgtEV583jRNpMBcyXcWxyu
         y7m+yHnHj4PNTQH2HNvIq+2gTDF5+PYmtab1fGUZHtZVEDWz27k1qyvYb/U9qbKfMzBZ
         NgE9yv9pz+U7Flvm8QC3jbjEMNpaS0PHgsIm9hsxQLHjul4BEbJtwGy/Yle93zXzoDmf
         LVSe+M2Pef/UCcazz45uDNmzhmjo9v9O93IcJFbDVRRc65HqdPl9Zpl5kGXYEtewfY4o
         gSNA==
X-Forwarded-Encrypted: i=1; AKwUvBx+KdmVtWMF73b5T2Cfh0tEO0dKMCOgKrLLuqSAsAylsJIZGubzZDPcRBMQmBCJvU5hcsqeEMqizOyN@vger.kernel.org
X-Gm-Message-State: AFq9FYKaFePblYUv66UaMzvWLZ89wQMFfMelRdv8iKXLhk0iFH+Tw6ed
	CWS+P+1KP9ZEalfIQ0SIpAnQmSjz8AzlfLCkycFJBd7/3e+jZrgu2Pmax11yYbWGx4GFlXBGGwh
	zSzoiXeg/DC5MYWDuZvlMRiHXDHwAANJR8X0cpwX4LBLavgEPKHn91qMfTtU=
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1914:b0:4cb:26a3:a0dc with SMTP id
 5614622812f47-53ccd9ba7e5mr7738248b6e.20.1792458339574; Mon, 19 Oct 2026
 18:05:39 -0700 (PDT)
Date: Mon, 19 Oct 2026 18:05:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad6be63.a20cb897.960b0.0079.GAE@google.com>
Subject: [syzbot] [cifs?] KASAN: slab-use-after-free Read in cifs_crypto_secmech_release
From: syzbot <syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com>
To: bharathsm@microsoft.com, linkinjeon@kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	samba-technical@lists.samba.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    045958acaa75 Merge tag 'net-7.3-rc8' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ac9f01580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e4baf48b1a52e1
dashboard link: https://syzkaller.appspot.com/bug?extid=c2ec61adfbcb24e5ec20
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/02297297c905/disk-045958ac.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7722daeec07b/vmlinux-045958ac.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c601e2d8abc7/bzImage-045958ac.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com

CIFS: VFS: \\172.20.20.170 Error -512 sending data on socket to server
==================================================================
BUG: KASAN: slab-use-after-free in cifs_crypto_secmech_release+0xed/0x120 fs/smb/client/cifsencrypt.c:512
Read of size 8 at addr ffff8880526ec490 by task syz.3.92/6393

CPU: 1 UID: 0 PID: 6393 Comm: syz.3.92 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 cifs_crypto_secmech_release+0xed/0x120 fs/smb/client/cifsencrypt.c:512
 cifs_put_tcp_session+0x240/0x3e0 fs/smb/client/connect.c:1740
 cifs_mount_put_conns+0x2b3/0x340 fs/smb/client/connect.c:3554
 cifs_mount+0x4ac/0xdb0 fs/smb/client/connect.c:3912
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35d7b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f35d5de0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f35d7e26180 RCX: 00007f35d7b9e559
RDX: 0000200000000300 RSI: 0000200000000100 RDI: 0000200000000200
RBP: 00007f35d7c358b0 R08: 0000200000000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f35d7e26218 R14: 00007f35d7e26180 R15: 00007ffce1bc0ac8
 </TASK>

Allocated by task 6393:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6394:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6802
 clean_demultiplex_info+0x997/0xe90 fs/smb/client/connect.c:1153
 cifs_demultiplex_thread+0x5b5/0x2ea0 fs/smb/client/connect.c:1446
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880526ec000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1168 bytes inside of
 freed 4096-byte region [ffff8880526ec000, ffff8880526ed000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x526e8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6393, tgid 6385 (syz.3.92), ts 190011878541
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
page last free pid 6391 tgid 6385 ts 189990448004 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 kmem_cache_alloc_bulk_noprof+0x352/0x890 mm/slub.c:7543
 __io_alloc_req_refill+0x9e/0x330 io_uring/io_uring.c:981
 io_alloc_req io_uring/io_uring.h:537 [inline]
 io_submit_sqes.cold+0xf6/0x301 io_uring/io_uring.c:2039
 __do_sys_io_uring_enter+0xa88/0x1b10 io_uring/io_uring.c:2640
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880526ec380: fb fb fb fb fb fb fb f
 ffff8880526ec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880526ec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880526ec500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
==================================================================
BUG: KASAN: slab-use-after-free in cifs_crypto_secmech_release+0xfa/0x120 fs/smb/client/cifsencrypt.c:516
Read of size 8 at addr ffff8880526ec498 by task syz.3.92/6393

CPU: 1 UID: 0 PID: 6393 Comm: syz.3.92 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 cifs_crypto_secmech_release+0xfa/0x120 fs/smb/client/cifsencrypt.c:516
 cifs_put_tcp_session+0x240/0x3e0 fs/smb/client/connect.c:1740
 cifs_mount_put_conns+0x2b3/0x340 fs/smb/client/connect.c:3554
 cifs_mount+0x4ac/0xdb0 fs/smb/client/connect.c:3912
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35d7b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f35d5de0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f35d7e26180 RCX: 00007f35d7b9e559
RDX: 0000200000000300 RSI: 0000200000000100 RDI: 0000200000000200
RBP: 00007f35d7c358b0 R08: 0000200000000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f35d7e26218 R14: 00007f35d7e26180 R15: 00007ffce1bc0ac8
 </TASK>

Allocated by task 6393:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6394:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6802
 clean_demultiplex_info+0x997/0xe90 fs/smb/client/connect.c:1153
 cifs_demultiplex_thread+0x5b5/0x2ea0 fs/smb/client/connect.c:1446
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880526ec000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1176 bytes inside of
 freed 4096-byte region [ffff8880526ec000, ffff8880526ed000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x526e8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6393, tgid 6385 (syz.3.92), ts 190011878541
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
page last free pid 6391 tgid 6385 ts 189990448004 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 kmem_cache_alloc_bulk_noprof+0x352/0x890 mm/slub.c:7543
 __io_alloc_req_refill+0x9e/0x330 io_uring/io_uring.c:981
 io_alloc_req io_uring/io_uring.h:537 [inline]
 io_submit_sqes.cold+0xf6/0x301 io_uring/io_uring.c:2039
 __do_sys_io_uring_enter+0xa88/0x1b10 io_uring/io_uring.c:2640
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880526ec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880526ec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880526ec500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
==================================================================
BUG: KASAN: slab-use-after-free in cifs_put_tcp_session+0x374/0x3e0 fs/smb/client/connect.c:1742
Read of size 8 at addr ffff8880526ec470 by task syz.3.92/6393

CPU: 1 UID: 0 PID: 6393 Comm: syz.3.92 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 cifs_put_tcp_session+0x374/0x3e0 fs/smb/client/connect.c:1742
 cifs_mount_put_conns+0x2b3/0x340 fs/smb/client/connect.c:3554
 cifs_mount+0x4ac/0xdb0 fs/smb/client/connect.c:3912
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35d7b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f35d5de0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f35d7e26180 RCX: 00007f35d7b9e559
RDX: 0000200000000300 RSI: 0000200000000100 RDI: 0000200000000200
RBP: 00007f35d7c358b0 R08: 0000200000000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f35d7e26218 R14: 00007f35d7e26180 R15: 00007ffce1bc0ac8
 </TASK>

Allocated by task 6393:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6394:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6802
 clean_demultiplex_info+0x997/0xe90 fs/smb/client/connect.c:1153
 cifs_demultiplex_thread+0x5b5/0x2ea0 fs/smb/client/connect.c:1446
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880526ec000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1136 bytes inside of
 freed 4096-byte region [ffff8880526ec000, ffff8880526ed000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x526e8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6393, tgid 6385 (syz.3.92), ts 190011878541
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
page last free pid 6391 tgid 6385 ts 189990448004 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 kmem_cache_alloc_bulk_noprof+0x352/0x890 mm/slub.c:7543
 __io_alloc_req_refill+0x9e/0x330 io_uring/io_uring.c:981
 io_alloc_req io_uring/io_uring.h:537 [inline]
 io_submit_sqes.cold+0xf6/0x301 io_uring/io_uring.c:2039
 __do_sys_io_uring_enter+0xa88/0x1b10 io_uring/io_uring.c:2640
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880526ec300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880526ec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff8880526ec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
==================================================================
BUG: KASAN: slab-use-after-free in cifs_put_tcp_session+0x381/0x3e0 fs/smb/client/connect.c:1743
Write of size 8 at addr ffff8880526ec470 by task syz.3.92/6393

CPU: 1 UID: 0 PID: 6393 Comm: syz.3.92 Tainted: G    B               syzkaller #0 PREEMPT(full) 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 cifs_put_tcp_session+0x381/0x3e0 fs/smb/client/connect.c:1743
 cifs_mount_put_conns+0x2b3/0x340 fs/smb/client/connect.c:3554
 cifs_mount+0x4ac/0xdb0 fs/smb/client/connect.c:3912
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35d7b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f35d5de0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f35d7e26180 RCX: 00007f35d7b9e559
RDX: 0000200000000300 RSI: 0000200000000100 RDI: 0000200000000200
RBP: 00007f35d7c358b0 R08: 0000200000000400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f35d7e26218 R14: 00007f35d7e26180 R15: 00007ffce1bc0ac8
 </TASK>

Allocated by task 6393:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2f8/0x6d0 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6394:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x22b/0x6d0 mm/slub.c:6802
 clean_demultiplex_info+0x997/0xe90 fs/smb/client/connect.c:1153
 cifs_demultiplex_thread+0x5b5/0x2ea0 fs/smb/client/connect.c:1446
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880526ec000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1136 bytes inside of
 freed 4096-byte region [ffff8880526ec000, ffff8880526ed000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x526e8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801d035140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6393, tgid 6385 (syz.3.92), ts 190011878541
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x110d/0x35d0 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2eb/0x3300 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab mm/slub.c:3462 [inline]
 new_slab+0xa9/0x6e0 mm/slub.c:3513
 refill_objects+0xe3/0x410 mm/slub.c:7418
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x35e/0x650 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __kmalloc_cache_noprof+0x4f4/0x6d0 mm/slub.c:5559
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 cifs_get_tcp_session+0x144/0x1f80 fs/smb/client/connect.c:1765
 cifs_mount_get_session+0xc9/0x460 fs/smb/client/connect.c:3579
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x200/0x1e20 fs/smb/client/dfs.c:275
 cifs_mount+0xc4/0xdb0 fs/smb/client/connect.c:3869
 cifs_smb3_do_mount+0x2c0/0x1b10 fs/smb/client/cifsfs.c:1026
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree fs/smb/client/fs_context.c:917 [inline]
 smb3_get_tree+0x1fd/0x440 fs/smb/client/fs_context.c:909
 vfs_get_tree+0x92/0x320 fs/super.c:1932
 fc_mount fs/namespace.c:1278 [inline]
 do_new_mount_fc fs/namespace.c:3885 [inline]
 do_new_mount fs/namespace.c:3961 [inline]
 path_mount+0x7d0/0x2850 fs/namespace.c:4312
 do_mount fs/namespace.c:4325 [inline]
 __do_sys_mount fs/namespace.c:4543 [inline]
 __se_sys_mount fs/namespace.c:4520 [inline]
 __x64_sys_mount+0x293/0x310 fs/namespace.c:4520
page last free pid 6391 tgid 6385 ts 189990448004 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0x79f/0x10f0 mm/page_alloc.c:2962
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x1a0/0x1f0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 kmem_cache_alloc_bulk_noprof+0x352/0x890 mm/slub.c:7543
 __io_alloc_req_refill+0x9e/0x330 io_uring/io_uring.c:981
 io_alloc_req io_uring/io_uring.h:537 [inline]
 io_submit_sqes.cold+0xf6/0x301 io_uring/io_uring.c:2039
 __do_sys_io_uring_enter+0xa88/0x1b10 io_uring/io_uring.c:2640
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880526ec300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880526ec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff8880526ec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880526ec500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
