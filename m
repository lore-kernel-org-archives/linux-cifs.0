Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419843D4EE
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 08:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609442; cv=pass; b=NLY36N8tfFcpBdlc583/TThv/2xFhFfJ+ulFsbGRBe/82PraVP8C7Kbe/53s3LVrU2Je6igSIztEWOSZTES141Tn3z1BM7++NBTB9HUjoMidQYJ/vipAHeqOenz0ebnJDJhyfcG4SuG/K4UNbzGsrY4Y8H+qGRcJI3Qr6taxjVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609442; c=relaxed/simple;
	bh=ibtwg+CQ7s+XtNhxiTTJ3u8q/OIARg68JosaSwyu5uU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vy/CUfpcXPyjEqY/RmKWwP+XATSHhnq0rCsffYvke7qNWKa4D6Y6ljTCViB9qKHapN3LMTDXjDJtOdkxbSEKTntjSSDR80jPuF1SNXYGJVJAq3iG/kpjB2cIwmWgJrF1jHir56b/o8dIL9U5+E6z9JfYIod+yTBshI15Vjvtc/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rceLh3TC; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rceLh3TC"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso6117366d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 01:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786609440; cv=none;
        d=google.com; s=arc-20260327;
        b=G5lMyOFdOPPW8aWcVc4CeqqspINwiUTdFhl0a/5R8zoJOfwNVA9t7OLBGvMUM2mhcu
         0LpK31EQoLwuBfC9wfBK9s+Xeuh32nOmjg8Rur57SzoZHTEKBqGwwbqyfIAll7kEe6lP
         2kWa0y7+gNudwLc2kLA+kQdTHuozpr/INDtqzYWIw7HRzu4rNzxfXgUWqJvxXj2cta8Z
         DoZSu/+QgvUwPex9XzcbiQCKFe8OOpiXUqMSyExsAk5ywvmpYoxVGMK29qGwK4UnNxm4
         nPC1MOmcs/E1p3MeKrGC/cdd/NgYzDazAeSH1YwdoMnIyd1TBouaMxrIHzPPwe+FR8Nt
         hkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TbblNQ6nDYvoOGRI+/VgL6ihxQJ/bq/rBZwZDZEG538=;
        fh=vFef+iUpnCWA6pu20DEX7WKnc+vAhZBTMMncqRis26g=;
        b=CQQ7V98kL6e6F28Ksz24fMwop7Tnb3g6vah9AU4IK/Mx9DLrX8xORpsWJUVQP15H01
         YdHnbKNN95/eymwr8ujBXLOMOkPXgOYdRWKmTK6K6JPXEalBnzAgr3Yr0ZrX3bTXdUmK
         PlTEhmhEdaYd8x9/ZzP7omYne1LnYu08XzMuQa6ZGFoQ9XoLjNfD81ZIhAxEjt690f91
         CsfdhM0unJvfxlzUay0MR96Itc09Kvc0/moqlYkbj0kfPAWMZPosr3G92/cQa/acbYUk
         28X+Y3msqYb+Zl5wIAePc7q5bSlBj7ljLUb84o1vqyC0ou0038AzgSkYq714hyTjTbl0
         cvyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786609440; x=1787214240; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TbblNQ6nDYvoOGRI+/VgL6ihxQJ/bq/rBZwZDZEG538=;
        b=rceLh3TCjeT1skJAeZPqZd6TyF/FKdpQ3QFRcPv2C+UkGCV8m3b6efpj1B4yI+j37X
         6dtru4jSZVEWUfEzD72+zgvLvVGPMP1XiA4O0khdWAhkC3s4iI9C/VrdwBvZNl8lP8Ov
         2cZrsyCZ9OtwE3rIqE5P5BNAtIFht9s5Z3Oqm7U+TgBoKVDdhe93EUWEoys/bzksqb/A
         7XXv7psNXuaVYejmJtsh4f/nOYSUKrHcX6oew5eQXEXJcTy36LmuJFIq1ZSYfOvLiabt
         BEcKh2iCntO8LZiFjG/MS9CPHELgGOYVDoWtvxLWQsM6ev21gHKuYHGgOaqlx4y6zH27
         m2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609440; x=1787214240;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TbblNQ6nDYvoOGRI+/VgL6ihxQJ/bq/rBZwZDZEG538=;
        b=naENu+mnVRoD1PnYNcDUde80KPVvf3RrINcCfW2e19KgG0DpFdZw4r6Rw00tCgSEDD
         5nmWM/woXQFgAHSSDXQaR9u+iLphq5YruDVnqT6t2ygzCNpHRWUWVco74sIvQJ07nJwR
         Mg444KumeNN5bEc9FlHH6jzTgy4ZDH2Ex+okQOzCm9LJ0a0YCOlFcwoyIIRRFQUI61xK
         +6dJSlw9Zmq1LbiBxUOTPxn07psTe1TkwOVbl9Mm0OZHk4lvMZISXWwdCrA+8jpM2GdX
         bs4/JTSiNQR0C+fpjCBTc5v/XlrWjPE+1e3+NHnSyrhtgk+RNo4F4C4TPkxjm/+DuVVq
         IV5w==
X-Forwarded-Encrypted: i=1; AHgh+Rogk/clJAHKM+s8CB6xbP4C0Wfz5K19VZdSZKk4MeBBQfsQI6MOJdVablxmJ971EeQSlaSdAXA/4n4M@vger.kernel.org
X-Gm-Message-State: AOJu0YwS6beMTZ0E75QARMFvapeOYnpZlwrx3Wg14bXZECUceHWvCpkk
	kecKG7KVwCP15IS45UMSKtuq3SG+hbCy6MbKJDy6jnEvvjyXD1gvSGZhUezXoGwiNJrhszmSi2v
	uh5A8mBtsXsdyxDMu5P1nXikrJc3ODKw=
X-Gm-Gg: AR+sD131IPk2IePiiz+OfZAMRLVl5qCk3tS8aMIP/4xzmL7DB9vXFMVMCIUIWxTIr72
	Jm6GAJf/RtUqlA5COdJaKR1JQcDKrTret/T3SK1lEgD29GYC+G9Hm0iPObk84TwECQbj07w/jFu
	TaX+hD7TH969ftAZqLkvDawqHApmj4YAw8u8TMm9QRi0kZHXyJ9WLGMoJnzqGS97k3dHud6+GOi
	0uAnCj/mSrcL83HKHFSX+Ryz8YHzDyMnmmS3RnkVFW/tORGzRDqxP01jATojw+xaRO7MQ+gPBs1
	eIQ+D2M7/bHlsMBSwR6BV+lSpDsxOhEQZNjKmuXKReKxFSevPIx2OoHzGhnl4XsgScaYIF8emjp
	63ixcfuO1sC4Hw+cncXFS6enWx6Pf
X-Received: by 2002:a05:6214:da5:b0:908:488b:14f with SMTP id
 6a1803df08f44-90a809cfdb6mr33036656d6.5.1786609439494; Thu, 13 Aug 2026
 01:23:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
In-Reply-To: <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 17:23:48 +0900
X-Gm-Features: AUfX_mywOq09YL8qT0uYhkt6JjUIaOTCBeFHyBztZeTnl5QMXbU-aAi4Q2M-HVE
Message-ID: <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for confirming it on mainline.

One thing about the for-next-next run: the output shows locks_sent=3D0,
which means the harness never managed to send a single lock request, so
that run did not exercise the path at all. It is not evidence that the
branch is unaffected. The harness silently retries on connection errors,
which makes a failed setup look like a clean run -- sorry about that.

kfuzz2.py defaults to:

    KFUZZ_HOST=3D127.0.0.1  KFUZZ_USER=3Dfuzzuser
    KFUZZ_PASS=3Dfuzzpass   KFUZZ_SHARE=3Dfuzz

so it needs a share named "fuzz" and that user to exist. Please set those
to match your setup and check that locks_sent climbs before drawing a
conclusion.

On the UAF you hit: I think it may be the same one I have now root-caused.
Captured on a clean untainted mainline boot with continuous logging
(ksmbd's own log spam overflows the ring buffer and hides the earlier
faults, which is why I missed the ordering at first):

  [284.826] BUG: KASAN: slab-use-after-free in smb2_lock+0x33b4
            Write of size 8 by task 1984
            Allocated by task 1984: smb2_lock+0xa90
            Freed by task 2119:     smb2_lock+0x23b4
  [285.088] same task -> _raw_spin_lock on garbage -> Oops
  [287.598] kernel BUG at fs/locks.c:312

Symbolized:
  alloc +0xa90  -> smb2pdu.c:8156  smb2_lock_init()
  free  +0x23b4 -> smb2pdu.c:8213  the cross-request unlock kfree(cmp_lock)
  write +0x33b4 -> smb2pdu.c:8323  list_del(&smb_lock->llist),
                   inlined list.h:260 =3D=3D next->prev =3D prev

struct ksmbd_lock is on three lists: clist (conn->lock_list), flist
(fp->lock_list) and llist (the *on-stack* lock_list / rollback_list of the
request that created it). The cross-request unlock path removes flist and
clist but not llist, so one worker frees an object that another worker
still has threaded onto its stack-resident list; that worker then wakes
from ksmbd_vfs_posix_lock_wait() and list_del() writes through the freed
neighbour.

Note this UAF is the *first* fault, on an untainted kernel -- it precedes
the BUG_ON rather than being fallout from it, and it is a write, not a read=
.

Also, please do not treat my earlier vfs_cache.c hunk as a fix. With it
applied the BUG_ON still reproduces in ~5 s; the trace just moves from
__ksmbd_close_fd() to smb2_lock+0x23ac, i.e. smb2pdu.c:8213 -- the same
cross-request unlock path above, which that patch does not touch.

2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:59, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On 8/13/26 00:09, Blue bird wrote:
> >
> > Call trace
> > ----------
> >
> >    kernel BUG at fs/locks.c:312!
> >    Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> >    CPU: 4 UID: 0 PID: 1509 Comm: ksmbd:::ffff:12 Not tainted 7.2.0-rc7-
> > gf5bbbfec59b4
> >    pc : locks_release_private+0x214/0x2c8
> >    Call trace:
> >     locks_release_private+0x214/0x2c8 (P)
> >     locks_free_lock+0x20/0x40
> >     __ksmbd_close_fd+0x67c/0xc28          [ksmbd]
> >     __close_file_table_ids+0x430/0x780    [ksmbd]
> >     ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
> >     ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
> >     ksmbd_sessions_deregister+0x3fc/0x5c8 [ksmbd]
> >     ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
> >     ksmbd_conn_handler_loop+0x4b4/0xd10   [ksmbd]
> >
> > fs/locks.c:312 is BUG_ON(!list_empty(&flc->flc_blocked_requests));
>
> Hi Blue,
>
> Thank you for reporting this issue and providing the poc.
>
> I reproduced the same BUG_ON on mainline. However, it could not be
> reproduced on the ksmbd-for-next-next branch, but another UAF issue was
> found, I will continue debugging it.
>
> ```
> LF_SECONDS=3D10 python3 -u lockfuzz2.py
> t=3D5s locks_sent=3D0 faults=3D0
> t=3D10s locks_sent=3D0 faults=3D0
>
> lsmod | grep ksmbd
> ksmbd                1236992  0
>
> modprobe -r ksmbd # slab-use-after-free
> ```
>
> [  170.722187]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  170.724724] BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
> [  170.726934] Read of size 8 at addr ffff8881044eff98 by task modprobe/1=
019
>
> [  170.729907] CPU: 5 UID: 0 PID: 1019 Comm: modprobe Not tainted
> 7.2.0-rc7+ #5 PREEMPT(full)
> [  170.729917] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.17.0-9.fc43 06/10/2025
> [  170.729922] Call Trace:
> [  170.729926]  <TASK>
> [  170.729930]  __dump_stack+0x19/0x30
> [  170.729939]  dump_stack_lvl+0x49/0x60
> [  170.729945]  print_address_description+0x7b/0x200
> [  170.729952]  ? proc_remove+0x3e/0x80
> [  170.729958]  print_report+0x5b/0x70
> [  170.729980]  kasan_report+0xed/0x130
> [  170.729987]  ? proc_remove+0x3e/0x80
> [  170.729996]  __asan_report_load8_noabort+0x18/0x20
> [  170.730001]  proc_remove+0x3e/0x80
> [  170.730006]  ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
> [  170.730073]  cleanup_module+0x33/0xe00 [ksmbd]
> [  170.730126]  __se_sys_delete_module+0x276/0x400
> [  170.730133]  ? fput_close_sync+0x9a/0x110
> [  170.730138]  __x64_sys_delete_module+0x5f/0x70
> [  170.730143]  x64_sys_call+0x2675/0x3030
> [  170.730147]  do_syscall_64+0xf0/0x3b0
> [  170.730153]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  170.730157] RIP: 0033:0x7f81a592b02b
> [  170.730162] Code: 73 01 c3 48 8b 0d ed ad 0c 00 f7 d8 64 89 01 48 83
> c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f
> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd ad 0c 00 f7 d8 64 89 01 48
> [  170.730166] RSP: 002b:00007fff84d9cdb8 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000b0
> [  170.730172] RAX: ffffffffffffffda RBX: 000055993a2f5ca0 RCX:
> 00007f81a592b02b
> [  170.730176] RDX: 0000000000000000 RSI: 0000000000000800 RDI:
> 000055993a2f5d08
> [  170.730178] RBP: 00007fff84d9cde0 R08: 1999999999999999 R09:
> 0000000000000000
> [  170.730181] R10: 00007f81a59a5fe0 R11: 0000000000000206 R12:
> 0000000000000000
> [  170.730184] R13: 00007fff84d9ce10 R14: 0000000000000000 R15:
> 0000000000000000
> [  170.730188]  </TASK>
>
> [  170.778338] Allocated by task 141:
> [  170.779443]  kasan_save_track+0x2f/0x70
> [  170.780675]  kasan_save_alloc_info+0x40/0x50
> [  170.782044]  __kasan_slab_alloc+0x52/0x70
> [  170.783312]  kmem_cache_alloc_noprof+0x168/0x3e0
> [  170.784715]  __proc_create+0x20b/0x710
> [  170.785846]  proc_create_single_data+0x78/0x150
> [  170.786703]  ksmbd_proc_create+0x24/0x30 [ksmbd]
> [  170.787525]  ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
> [  170.788525]  server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
> [  170.789471]  process_scheduled_works+0x788/0xec0
> [  170.790295]  worker_thread+0x894/0xc10
> [  170.790986]  kthread+0x2e5/0x3c0
> [  170.791548]  ret_from_fork+0x168/0x4f0
> [  170.792256]  ret_from_fork_asm+0x1a/0x30
>
> [  170.793241] Freed by task 1019:
> [  170.793802]  kasan_save_track+0x2f/0x70
> [  170.794411]  kasan_save_free_info+0x4a/0x60
> [  170.795155]  __kasan_slab_free+0x47/0x70
> [  170.795878]  kmem_cache_free+0x122/0x410
> [  170.796556]  pde_put+0xfd/0x160
> [  170.797156]  remove_proc_subtree+0x365/0x540
> [  170.797910]  proc_remove+0x6a/0x80
> [  170.798500]  ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
> [  170.799389]  cleanup_module+0x18/0xe00 [ksmbd]
> [  170.800243]  __se_sys_delete_module+0x276/0x400
> [  170.801046]  __x64_sys_delete_module+0x5f/0x70
> [  170.801827]  x64_sys_call+0x2675/0x3030
> [  170.802498]  do_syscall_64+0xf0/0x3b0
> [  170.803155]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> [  170.804362] The buggy address belongs to the object at ffff8881044eff0=
0
>                  which belongs to the cache proc_dir_entry of size 192
> [  170.806657] The buggy address is located 152 bytes inside of
>                  freed 192-byte region [ffff8881044eff00, ffff8881044effc=
0)
>
> [  170.809083] The buggy address belongs to the physical page:
> [  170.810057] page: refcount:0 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x1044ee
> [  170.811450] head: order:1 mapcount:0 entire_mapcount:0
> nr_pages_mapped:0 pincount:0
> [  170.812749] flags:
> 0x17ffffc0000040(head|node=3D0|zone=3D2|lastcpupid=3D0x1fffff)
> [  170.813918] page_type: f5(slab)
> [  170.814464] raw: 0017ffffc0000040 ffff888100a252c0 dead000000000100
> dead000000000122
> [  170.815773] raw: 0000000000000000 0000000800200020 00000000f5000000
> 0000000000000000
> [  170.817065] head: 0017ffffc0000040 ffff888100a252c0 dead000000000100
> dead000000000122
> [  170.818361] head: 0000000000000000 0000000800200020 00000000f5000000
> 0000000000000000
> [  170.819656] head: 0017ffffc0000001 ffffffffffffff81 00000000ffffffff
> 00000000ffffffff
> [  170.820991] head: ffffffffffffffff 0000000000000000 00000000ffffffff
> 0000000000000002
> [  170.822282] page dumped because: kasan: bad access detected
>
> [  170.823477] Memory state around the buggy address:
> [  170.824297]  ffff8881044efe80: 00 00 00 00 00 00 00 00 fc fc fc fc fc
> fc fc fc
> [  170.825501]  ffff8881044eff00: fa fb fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb
> [  170.826698] >ffff8881044eff80: fb fb fb fb fb fb fb fb fc fc fc fc fc
> fc fc fc
> [  170.827971]                             ^
> [  170.828634]  ffff8881044f0000: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00
> [  170.829862]  ffff8881044f0080: 00 fc fc fc fc fc fc fc fc 00 00 00 00
> 00 00 00
> [  170.831072]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
