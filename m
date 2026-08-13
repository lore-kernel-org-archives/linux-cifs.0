Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD03747988A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627967; cv=pass; b=Qm032byd3Fb3blmWG4S0MUQHEZ4W35KkvEQ6/93cy3+WEkWvetvL3SWIB062UZwa0rFDooAtb3AfFQC/P2bO762jlr4+acjk1kfvcnsR+9F/zTlSBt+27ZQXVpR13B/gnwbm3r5/S25451jhn6InmyiFhbd/f/MX0+e2pM+eXVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627967; c=relaxed/simple;
	bh=iHdAw1YFg37VODHYo5heIo0UqntIr7iem9emFDlGAbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=td6Orln3CtNKCdcHC0ReX1/h+l3MVz6YmRRyA2AoRBAKzCmAOdWGL3rhuhHeTQA72TCHjMKTr0SyCi3sl9SUHUPeiSHQExryedp7i88tDdZyXrZI81HtkzthT0bLv5j9dJ2DVfwCcCFEn7ixh4NjrfeklnpiCTMZcHjjWCzOjW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvXBL4dt; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvXBL4dt"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8f0e5e36912so13568766d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 06:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786627965; cv=none;
        d=google.com; s=arc-20260327;
        b=Gr0/ZeBm33KxydAlKyZO8qbIuEPc/yNV20VKdRbB3lpKog5oAIpsLeXB2t0BJftXBd
         eh4KmxxHnXqA5mTgViixjoaprX0x+ZBFSfilzwQN2Vjy8d7lVimEVZHoo1tQHawZlWVB
         UIcfJoZ5KaTvkMywdZ2TZN8zxi720+Fmcw7QxVg5DjE6DW2nSEe5Dr6LGy1FxyQClfS6
         dWi1agKZAtHZR764XYl+mJqIG12wRIMJucoEelVUv3gS6kj+lMYUUyBpnPBR/aGYwQGe
         bkixXxnG0I3Jp3tX5sHnmexLCImWR8txR8dSP5OwKkr+E5KDQlBtlq+nR0LJ3rlnOeWK
         gCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ngtufuqB30xEw3RZ9ubRWeLqvVy9kYPC7hGOLdQrKEY=;
        fh=VuTpoUhN8RkQlhEGYBT1GXpvVKRcYdqYAuoTokPdvVA=;
        b=p8ClR9f5moVX9hXOFdR+bKHNtqa4E7VTQAPjW0qSR4o97rAt/FqonwHlt3mIEDW98M
         5x6nRAJ4Arqq2Q83Mpex545/x37FT+kHDFaI5w3jHfcjEB3XqmC8pGlxkEZ1KsSxbAk2
         51Je/AxYZBmG+yQXCVpJezKmTRURFAA1rHA/Et6jC7LKWtHtlXOPg7YBh2HAk2oPBG66
         BJdloZIAy3o8LfhvS+d9fPx8A9v3YaJSAHFMPxpRxxBzPew8fvwav5TfODaDsuISGpm1
         5STwI7ySK9H4eZtdYkSjrRl7M+QtNXjXwL5u6dALZjNinj2UZ0QZDqRUo5rn4ZyElXg8
         /1lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786627965; x=1787232765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ngtufuqB30xEw3RZ9ubRWeLqvVy9kYPC7hGOLdQrKEY=;
        b=NvXBL4dtYXs3HQemPqehCaGDFNELs34+9v43fDHLsyA4a/+NfpPpwV0TunAb73iukP
         ADGDD9E0UyoR5kuSudLE6Ih1sONOBqJ1hJokbNW+XstpsCJZuaGndpc+LbJV0BnujANf
         fHD1A9pbHijIVNn1Gd5wbeXzNob2gxvA+8EsbrVyrhW6yP96WAfda7tUjsVOhFsDH2b9
         5GqrgsoSRm2FQU6E5UfNR1CNXXFTHE/0elwhTkb95cgPMLyRjIojCqDcIS0CCPs5yUV9
         dI2kQjIt5xGj5AYNQMEdUVPEaZYc3MxEsQ7SWiexVjoyjf8sxpYLIz8IxVpBMSRMOGm1
         oukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786627965; x=1787232765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngtufuqB30xEw3RZ9ubRWeLqvVy9kYPC7hGOLdQrKEY=;
        b=VbNWGSmg9oV7TzZ14oiR1zGSCw+LleN8XA9EFY43e8Cvqx/HXjGEJMyQ1Mn1sIlvj6
         FAiy41sRBSphxS2kSG5CHUrtXoOF7tt3TsIqz9RRvOgn6x9B9Vx3xSbc5zUp3sxQNI9B
         JZatwzfkC8YQeTx8/y9AU58NQJ8kt4rcUCj4rl6NioHtOSP3deHLDOvYiQOfdxmrFQzw
         u1IB0clkBRAy5g26HGetSJ6avC/KPKZwYUP3/RQhTitRFHoMBLlFLTx22A79iYAcLzwb
         2I5cWaSaSiy6qhtKGaycj7K5iNH7sEtT01+rgOJHwR5zk91yw+03a9tf8PJJZI12j0mD
         +0gQ==
X-Forwarded-Encrypted: i=1; AHgh+Rort3TqP8qUEhVqUOfVZ5aYP2PDHDlfyGjPGQ6ksTLwm+m3q9zhKS7kHtZUixUDEMe04G2vwXu1/Ubu@vger.kernel.org
X-Gm-Message-State: AOJu0YxwR5Ag6g8ex2yGrj1uAiHrWI3+5TgCdQjvyEhs5y4W9doaNUPP
	4qOGV+w2U3N3UQlVzPE8vCivJQvajNRJ5hsJpYgdvOXnxZuEZZlxSqLa5UqhIUtI2hEiooYiKne
	hL7IbK8HLraMRje8eGcSncMaZCHVEwlA=
X-Gm-Gg: AR+sD134K2dgD6Qsv35rJO0v9MXx+vpdgPsve40WsZOwtePX06bOoqgKLb0blvGxLNa
	SlQ67j3w5oyPkCemhjPR50EFSPRJi1jLTSJfng8ZcJ/mbPjY6ORNCaeDYKlwXOLotFhghVZ/RjC
	8XrSjy1GQ2IqGQCFDKsYwDBEF9nQ42UurDe/Am5QS2rE8oMjiS3n8AJTZzlmQ5qKmzsLEMDJV0s
	dEVQEZv1NqABr/F92ve6mEZ77YDb1dYzio7vq76RNObgiISwilZR2l2WAnl9rndZIULDJyxdbgV
	gp+7ME8nQyaZZfCye8xyJbMCExL8cbTSic45J09PuKN3dfekXBqxMChX1oEkHm/iAfhFKp8FjL5
	BoOc+HeKg1cCrYb0q63acDi60GqRNJVQ/PWKIxM8=
X-Received: by 2002:a05:6214:21c2:b0:8f0:f35c:23ae with SMTP id
 6a1803df08f44-90a80c11aecmr58127926d6.29.1786627964485; Thu, 13 Aug 2026
 06:32:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com> <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
In-Reply-To: <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 22:32:33 +0900
X-Gm-Features: AUfX_mwR5ZZU1tS-7LsiIsnPLON1G3PIFG5zx-MCkndBG1g0uwxEhpzfKhnmFHA
Message-ID: <CALT=-858DTXUWV=CQX7Bqpf+HyVpC_JzFuWyq6GKRM87nGbs8g@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix use-after-free in ksmbd_conn_transport_destroy()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, tom@talpey.com, 
	senozhatsky@chromium.org, Bahubali B Gumaji <bahubali.bg@samsung.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Yes, they are different issues. We still need to continue analyzing the
> BUG_ON issue.

Agreed. I dug into it further on ksmbd-for-next-next and I think there are =
two
sites that need the same treatment. Data below, and a patch that survives t=
he
reproducer at the end -- though please read the caveat before taking it.

All runs: branch smb3/ksmbd-for-next-next at e7317f3e41, fs/smb/ built agai=
nst
the 7.2.0-rc7 it is based on, freshly booted guest each time, kernel otherw=
ise
clean (Tainted: [O]=3DOOT_MODULE only), same lockfuzz2.py.


Site 1: __ksmbd_close_fd()
-------------------------

  branch as-is:  fault after ~1.6 s, 142 lock requests

  kernel BUG at fs/locks.c:312!
  Call trace:
   locks_release_private+0x214/0x2c8 (P)
   locks_free_lock+0x20/0x40
   __ksmbd_close_fd+0x4d8/0xd28          [ksmbd]
   ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
   ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
   ksmbd_sessions_deregister+0x450/0x540 [ksmbd]
   ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]

The comment above that loop is the thing that misleads:

/* because the reference count of fp is 0, it is guaranteed that
* there are not accesses to fp->lock_list.
*/

fp's refcount reaching zero rules out further *ksmbd* references. It says
nothing about the VFS blocked-request graph, which fs/locks.c owns and whic=
h can
still have another client's pending request chained onto this file_lock.


Site 2: the cross-request unlock path in smb2_lock()
----------------------------------------------------

With only the vfs_cache.c hunk applied, the teardown path is genuinely clos=
ed --
the trace no longer goes through __ksmbd_close_fd() -- but the same BUG_ON
reappears:

  branch + vfs_cache.c hunk:  fault after ~118 s, 247 lock requests

  Call trace:
   locks_release_private+0x214/0x2c8 (P)
   locks_free_lock+0x20/0x40
   smb2_lock+0x264c/0x4404               [ksmbd]
   handle_ksmbd_work+0x4dc/0x17dc        [ksmbd]

smb2_lock+0x264c is fs/smb/server/smb2pdu.c:9366 on this branch -- the
locks_free_lock(cmp_lock->fl) in the cross-request unlock path, whose only =
guard
is

static inline bool lock_defer_pending(struct file_lock *fl)
{
/* check pending lock waiters */
return waitqueue_active(&fl->c.flc_wait);
}

That asks "am I waiting?", not "is anyone waiting on me?".
locks_release_private() asserts five separate conditions and this guard cov=
ers
one of them (flc_wait); the one that actually trips is flc_blocked_requests=
.

c120970353 reworked when granted locks get published, which is what fixed t=
he
use-after-free, but it does not change this guard, so this site is still
reachable.


Both hunks together
-------------------

  branch + both hunks:  11185 lock requests over 181 s, no fault,
                        kernel still Tainted: [O] only

For scale, the unpatched branch faults after 142 requests, so that is rough=
ly
79x the request volume with nothing. I also watched locks_sent climb the wh=
ole
way (9592 -> 11185 in the last 25 s) rather than plateauing, because a stal=
led
harness reporting zero faults is exactly how I fooled myself earlier in thi=
s
thread.

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -645,6 +645,14 @@ static void __ksmbd_close_fd(struct
ksmbd_file_table *ft, struct ksmbd_file *fp)
  }

  list_del(&smb_lock->flist);
+ /*
+ * Waiters may still be chained onto this lock through the VFS
+ * blocked-request graph. fp's refcount says nothing about that
+ * graph, so detach and wake them before destroying the lock;
+ * otherwise locks_release_private() trips
+ * BUG_ON(!list_empty(&flc->flc_blocked_requests)).
+ */
+ ksmbd_vfs_posix_lock_unblock(smb_lock->fl);
  locks_free_lock(smb_lock->fl);
  kfree(smb_lock);
  }

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9362,6 +9362,13 @@ int smb2_lock(struct ksmbd_work *work)
  up_read(&conn_list_lock);

  ksmbd_conn_put(conn);
+ /*
+ * Other clients may still be chained onto this
+ * lock in the VFS blocked-request graph;
+ * lock_defer_pending() only covers flc_wait.
+ * Detach and wake them before destroying it.
+ */
+ ksmbd_vfs_posix_lock_unblock(cmp_lock->fl);
  locks_free_lock(cmp_lock->fl);
  kfree(cmp_lock);
  goto out_check_cl;

2026=EB=85=84 8=EC=9B=94 13=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 9:38, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring
> and statistics")
>
> =E5=9C=A8 2026/8/13 18:40, ChenXiaoSong =E5=86=99=E9=81=93:
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > Reproducer (Link[1]):
> >
> >    1. Build kernel with CONFIG_KASAN=3Dy
> >    2. server: systemctl start ksmbd
> >    3. client: mount -t cifs //localhost/export /mnt
> >    4. client: umount /mnt
> >    5. server: modprobe -r ksmbd
> >
> > The error message is as follows:
> >
> >    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
> >    Read of size 8 at addr ffff88810654e098 by task modprobe/785
> >    ...
> >    Call Trace:
> >     <TASK>
> >     __dump_stack+0x19/0x30
> >     dump_stack_lvl+0x49/0x60
> >     print_address_description+0x7b/0x200
> >     print_report+0x5b/0x70
> >     kasan_report+0xed/0x130
> >     __asan_report_load8_noabort+0x18/0x20
> >     proc_remove+0x3e/0x80
> >     ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
> >     cleanup_module+0x33/0xe00 [ksmbd]
> >     __se_sys_delete_module+0x276/0x400
> >     __x64_sys_delete_module+0x5f/0x70
> >     x64_sys_call+0x2675/0x3030
> >     do_syscall_64+0xf0/0x3b0
> >     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >    RIP: 0033:0x7f5b56d2b02b
> >    ...
> >     </TASK>
> >
> >    Allocated by task 159:
> >     kasan_save_track+0x2f/0x70
> >     kasan_save_alloc_info+0x40/0x50
> >     __kasan_slab_alloc+0x52/0x70
> >     kmem_cache_alloc_noprof+0x168/0x3e0
> >     __proc_create+0x20b/0x710
> >     proc_create_single_data+0x78/0x150
> >     ksmbd_proc_create+0x24/0x30 [ksmbd]
> >     ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
> >     server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
> >     process_scheduled_works+0x788/0xec0
> >     worker_thread+0x894/0xc10
> >     kthread+0x2e5/0x3c0
> >     ret_from_fork+0x168/0x4f0
> >     ret_from_fork_asm+0x1a/0x30
> >
> >    Freed by task 785:
> >     kasan_save_track+0x2f/0x70
> >     kasan_save_free_info+0x4a/0x60
> >     __kasan_slab_free+0x47/0x70
> >     kmem_cache_free+0x122/0x410
> >     pde_put+0xfd/0x160
> >     remove_proc_subtree+0x365/0x540
> >     proc_remove+0x6a/0x80
> >     ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
> >     cleanup_module+0x18/0xe00 [ksmbd]
> >     __se_sys_delete_module+0x276/0x400
> >     __x64_sys_delete_module+0x5f/0x70
> >     x64_sys_call+0x2675/0x3030
> >     do_syscall_64+0xf0/0x3b0
> >     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Reported-by: Kyenghwan Hwang <obnred@gmail.com>
> > Link[1]: https://lore.kernel.org/linux-cifs/8ea028f5-90f4-4d21-b1ac-a34=
3f0f04d88@chenxiaosong.com/
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > ---
> >   fs/smb/server/server.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> > index 0ccd123ba418..d619d1f22601 100644
> > --- a/fs/smb/server/server.c
> > +++ b/fs/smb/server/server.c
> > @@ -596,11 +596,16 @@ static int ksmbd_server_shutdown(void)
> >   {
> >       WRITE_ONCE(server_conf.state, SERVER_STATE_SHUTTING_DOWN);
> >
> > -     ksmbd_proc_cleanup();
> >       class_unregister(&ksmbd_control_class);
> >       ksmbd_workqueue_destroy();
> >       ksmbd_ipc_release();
> >       ksmbd_conn_transport_destroy();
> > +     /*
> > +      * ksmbd_conn_transport_destroy() calls delete_proc_clients() and=
 destroys
> > +      * sessions. ksmbd_session_destroy() removes each session's proc =
entry.
> > +      * Keep the procfs tree alive until these entries have been remov=
ed.
> > +      */
> > +     ksmbd_proc_cleanup();
> >       ksmbd_crypto_destroy();
> >       ksmbd_free_global_file_table();
> >       destroy_lease_table(NULL);
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
