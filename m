Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5B478E5A
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786628266; cv=pass; b=W29nWH3L7laeMtkfGlH6A+nVHDRll/2/SBBXKQMQePSoyVlpcLLrdjFPy91K2Gx6j0JoC1OWMb1C2e2UGNR26CIDgjHS/yeC9OovKsQPxuFs993gvi/MWdY1cwShiEJF+Fpv/cJ/LpkP2dYarMHxI2o82YXYMS4b3y+7Qi6EVeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786628266; c=relaxed/simple;
	bh=OOc5Id/VbgxayJrgghmmTiTfbtM3DkWQaC+kotatnlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CjVqu6nXCTq+mHJS2daNItflB4wh5Sw5AZq7C0AXbb2znWpj7yTUvjbXUpEpp8PBUsRNjofDh5TMTBL3TJRF0laZb0fAdS4j4YJeVStPqz7nOvow+HFEvQ/We3so9RU6c5il4EkfEKN1EoRK1j9RDMYG5yJTF/G2XpjUn0/n39s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icU6FrVY; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icU6FrVY"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-90898faf46dso12913276d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 06:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786628264; cv=none;
        d=google.com; s=arc-20260327;
        b=dD8st2V8kqjynBFkxnrp+3SI2NL232CIssHYJ8u70e7XjxDXNQN6BrKVVZIfq3gKqS
         Q1aDtuDTq4U0ofWIM8DJSYvP12y8auXkehBw4TYiCTV0g2lK/MCGzaIZNehJZts8T9Zt
         Otb/nWPTZkcsBXHNabAvwzwNbd+CO4Wat7W6j+DLPE82vIMC6e2/b23+t05dSQpqsPG2
         7ZiTx5t3kPlEFfrpAOfmzzQiKKEtrVj2Dp0qxhlD9O+w1+yzH5oWn9AHWtUNMut4o4dn
         p7NXNa9H10aRTrGMCM69cgTWi/Po/f3Rg6brIAsV6uYxFqc79OF9iKrhAIvmlLWFEDL9
         4ANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/qW4KgrOb5NUp9nlnU+3RdeGVmpBeNL627iXAEsflKY=;
        fh=jX1Bfm2AxuLoVYJzgdHQPl4cnQWCRTHoZWjmdvpVQho=;
        b=WlqKj8ahHo6AYw9cbFhJeKOAFRITEx7NSQUXy/dhK6HPBlH1OSDwaNo5kLpWEILzTX
         PxyVi83CfG9RiiQGrB4qkpP67eod2DvaNWvrtkIeQ+/T5I7h/mS5zcx27pPBmBbhJuvE
         cviVtcEtr1fEArtwfNGWmpvwx6kWH2LTQpyIcmxQs75fEIREXHsN+RJde2Of8m8XjRZZ
         Pyhdk8W3g+cDvYp79Nofc708jX6cLIbFxzY9rcSrO2ihzwvPzpCyxyyAJiIVrgtZ4NbJ
         DbMuIAd4V+Xg1Cxkussa5fWuzuzPDXYHnXJqwKBEaE79kMRMzxvmnMeNl0O+2VMxywa1
         D+iA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786628264; x=1787233064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/qW4KgrOb5NUp9nlnU+3RdeGVmpBeNL627iXAEsflKY=;
        b=icU6FrVYZ7rxVxFuTufFcmArmowZPV97Dxzgy2+LUllwmG3UIDimS0XcEvw9zj4PwK
         u7YZI/Y2VLW2/EvIaD9mBYOuaiH0fNFlwTpcJI50jUajtNoeb1AheGcmcXQ60Hbwc1bv
         omrgzIBpqD+Jd2OU62DJdzPZkp+jNBVxW+O2VGce+XiCUZvZzMU3EYDypijfb5vz5Wi4
         da594Fs8PYcS7zJQj5w1uMPdpIvikCZ2Dc8B6nEk/yCIP9HHQT5oi774S2g/WYM79BgI
         cY1xevh6f0heAS+z3bu4NM77O3QuHjldq6JZDqNTD5YXvPOxPjoUnmeVNzKwiGu6bdw9
         6fDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786628264; x=1787233064;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/qW4KgrOb5NUp9nlnU+3RdeGVmpBeNL627iXAEsflKY=;
        b=iJJw3WKs+VTU2DJaRqAQ0PZTIjnXTty2i0GgfsYvTEfD25aMlb13g8pYiRmiUaa560
         KX80VS8ozpHebt/nnpNJADXoxBG2DgfwTXKQknh0c/AH7YpRB3+PF0VenVtDwPsRyKcc
         oscQwxWJLnVh0FgGmIs5RWd19xmhFEomH/701gZ0H6ld4PIb3wV5pK8uCeoy8algnkGP
         L5l6h5YRhiTiBc5aTt5mPWOkK+JDZUXc4UpDBHar1/RbgeW/A5OKB1bxa7zo/qQBHV4M
         0HPYYKWrgYPwXg9WmX/2n2CEX3XPgy1Smh71GVPrKtqYUOH+VghpJnAOcyPCDdfNBrYI
         Az3A==
X-Forwarded-Encrypted: i=1; AHgh+RoD3f+piT1v+zZN0Krb5xWgJpaXB6OIHyJ6RGNuCP98L0UonMAbysKFswKaq5d+rc8HndkkR4a4VYHg@vger.kernel.org
X-Gm-Message-State: AOJu0YzgfURNmtz7U8YVFia1WP9TU05XdbubSFVimxTbmKu4oMiZQ0Bb
	6a0nQAV/M+ehb55nAtz5p6MQ1aNerwfjl5Eb2YjG0XZtoLb/qfDVCRzpZPXPkNr+C7MaRmZRgNq
	mYQdGv/FtZPqmtuM1GlbsRLkCWFCYvGY=
X-Gm-Gg: AR+sD12VYBi7ET8AbiDChTz0S6EppTk5QkfPVAuRAUHjc5pugazAT1pzuAKXDnzBCu3
	5SjBdGxKMl8aomwSvUJthRVyvFkevHs93lgT2hVHXX1GajZkUy02NtdnIOMggluNBoyNx30RB7Y
	nsC43FIKf3noKB2nVhZ4wtY63yWP/ZGRvK0RF3OUzRf+29+ECzrUAeNXBVHXFYRNL3cqIhF9R/Q
	B/I0u24MBfz0sjeHgchQB+9KAtI2KP6XAO7C4nYcgCj0Vj1GdHGaaMw1S7WDVfrXLVhFh6mxUcq
	HVzTSW9wsEYLOCCCfsSUn1mGpCUNKq1/+1wiu20mxkCLspwgB8Z5ozh+ZDOoV7gO3M8u+Gy+i9D
	pq/zzTcO5DHmucXTMOv3hQJuc9UO5
X-Received: by 2002:a05:6214:242f:b0:904:4275:e165 with SMTP id
 6a1803df08f44-90a80b74b7dmr52771566d6.19.1786628263702; Thu, 13 Aug 2026
 06:37:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com> <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
In-Reply-To: <fc4bcb05-866d-471e-b07f-61575d46bb13@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 22:37:31 +0900
X-Gm-Features: AUfX_myXOuhTbyuta9PPi_fhb9_8cGk_1ccjhjbZH9phPBAGs8c6YKbwsos8Z1o
Message-ID: <CALT=-86GYBvQd_L89fddL-0bwcezo9NQgGf+bme0JppqKSWpVQ@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix use-after-free in ksmbd_conn_transport_destroy()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, tom@talpey.com, 
	senozhatsky@chromium.org, Bahubali B Gumaji <bahubali.bg@samsung.com>, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
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
