Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4730CC4167B
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Nov 2023 07:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjKDHpF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Nov 2023 03:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjKDHpE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Nov 2023 03:45:04 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822041BD
        for <linux-cifs@vger.kernel.org>; Sat,  4 Nov 2023 00:45:00 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507a29c7eefso3529784e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 Nov 2023 00:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699083899; x=1699688699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b34jgQRMknfTynWWyyPpSqMh1K/fjYLFMThGT0Sb764=;
        b=cLpUgFGzxuOpHs4qAi/QWaBNe0NbTd7Qs4vpakyUGQ4XRrGjT/H1GmyDoLNxj5tLz8
         8U7ogBmhsdpg/UPK4vOGuFLhjmVQ0s7kOoTrSdldkydIbjbkQJnK2VBuX4FUI9ooCukA
         hCVETIah8oJACjGvteUIDVODQ4phpI35U6dsRJWW//yYwUKeMiWvxi+Pg81zLCsGb0yL
         zee1p+aPm6A1EGPxEQ4ZwOxLTAfBFSgUEXsPXp7cYEICVH5zBQGTIJe8Z+NJ99kyN5WM
         zN2XxU4ODFEO8Haz+NeDni4glg915eemjJm7ug6FOYlOAXyFCC9OMtorOFIq6SFzDKDH
         aTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699083899; x=1699688699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b34jgQRMknfTynWWyyPpSqMh1K/fjYLFMThGT0Sb764=;
        b=vzzjq796SzHG8qS3uTAbB24IJ7ztbKxCfi7W7v7j+CRrJUahDkwbt2aQlU5hnevTCG
         K5TlAX1mZMh0UHgomSDsHngFenhdrjs0vogu21gVMRFWgQAMmUa3ZuL0OF9PAxg81Dih
         GpRMTtni2MBBnJSjEm97gtDXTl92Wwb5aIQnhChk/FSS+P0gunzeeijLxarUASRI5SSR
         ANGSYJl/kh/NJIN3yuHxcXLllvCUYx1iV5o3EPY/O6SNpRsSZfSxeVvNTbX4Et0jzIVM
         bpsYnHKOuzqaSZ5BUMQkrR1M3boyMGXX9048H0IYRtPL4CFdYrRofaVRRpbe1YdZ9AYa
         e+MA==
X-Gm-Message-State: AOJu0YwDVG2qUcxujm61EPVzPDYf1r/lgOCXoxwht8Y7XXxmjErFuLpR
        ZxAAocoPN8WeUFTAkrDYqGs/UIhkaiQIGKlCLWU=
X-Google-Smtp-Source: AGHT+IENTI4ZYAPvjLYPmCRc2tSfEtIBw0gt6ipfYUKqTmloHHVFXUrdJ1y5PB3me/+dgwDNtIRRg62FRMaMwcDIg84=
X-Received: by 2002:a05:6512:695:b0:509:297d:b7a2 with SMTP id
 t21-20020a056512069500b00509297db7a2mr13920888lfe.65.1699083898317; Sat, 04
 Nov 2023 00:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-13-sprasad@microsoft.com>
 <d1c99946663662e7160bf1ed0a6b2dc6.pc@manguebit.com>
In-Reply-To: <d1c99946663662e7160bf1ed0a6b2dc6.pc@manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 4 Nov 2023 13:14:46 +0530
Message-ID: <CANT5p=pna6WxpSy5fXwsDGRJFRVpRaVCzp8uLFV4keOXcdvv5A@mail.gmail.com>
Subject: Re: [PATCH 13/14] cifs: display the endpoint IP details in DebugData
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 1, 2023 at 7:42=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Paulo Alcantara <pc@manguebit.com> writes:
>
> >> @@ -515,7 +573,18 @@ static int cifs_debug_data_proc_show(struct seq_f=
ile *m, void *v)
> >>                              seq_printf(m, "\n\n\tExtra Channels: %zu =
",
> >>                                         ses->chan_count-1);
> >>                              for (j =3D 1; j < ses->chan_count; j++) {
> >> +                                    /*
> >> +                                     * kernel_getsockname can block i=
nside
> >> +                                     * cifs_dump_channel. so drop the=
 lock first
> >> +                                     */
> >> +                                    server->srv_count++;
> >> +                                    spin_unlock(&cifs_tcp_ses_lock);
> >> +
> >>                                      cifs_dump_channel(m, j, &ses->cha=
ns[j]);
> >> +
> >> +                                    cifs_put_tcp_session(server, 0);
> >> +                                    spin_lock(&cifs_tcp_ses_lock);
> >
> > Here you are re-acquiring @cifs_tcp_ses_lock spinlock under
> > @ses->chan_lock, which will introduce deadlocks in threads calling
> > cifs_match_super(), cifs_signal_cifsd_for_reconnect(),
> > cifs_mark_tcp_ses_conns_for_reconnect(), cifs_find_smb_ses(), ...
>

Good points.
I'm just wondering why I'm unable to repro the same though.
I have lockdep enabled on my kernel too. But the same steps do not
throw this warning.

> A simple reproducer
>
>   $ mount.cifs //srv/share /mnt -o ...,multichannel
>   $ cat /proc/fs/cifs/DebugData
>
>   [ 1293.512572] BUG: sleeping function called from invalid context at ne=
t/core/sock.c:3507
>   [ 1293.513915] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1=
068, name: cat
>   [ 1293.515381] preempt_count: 1, expected: 0
>   [ 1293.516321] RCU nest depth: 0, expected: 0
>   [ 1293.517294] 3 locks held by cat/1068:
>   [ 1293.518165]  #0: ffff88800818fc48 (&p->lock){+.+.}-{3:3}, at: seq_re=
ad_iter+0x59/0x470
>   [ 1293.519383]  #1: ffff88800aed2b28 (&ret_buf->chan_lock){+.+.}-{2:2},=
 at: cifs_debug_data_proc_show+0x555/0xee0 [cifs]
>   [ 1293.520865]  #2: ffff888011c9a540 (sk_lock-AF_INET-CIFS){+.+.}-{0:0}=
, at: inet_getname+0x29/0xa0
>   [ 1293.522098] CPU: 3 PID: 1068 Comm: cat Not tainted 6.6.0-rc7 #2
>   [ 1293.522901] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
>   [ 1293.524368] Call Trace:
>   [ 1293.524711]  <TASK>
>   [ 1293.525015]  dump_stack_lvl+0x64/0x80
>   [ 1293.525519]  __might_resched+0x173/0x280
>   [ 1293.526059]  lock_sock_nested+0x43/0x80
>   [ 1293.526578]  ? inet_getname+0x29/0xa0
>   [ 1293.527097]  inet_getname+0x29/0xa0
>   [ 1293.527584]  cifs_debug_data_proc_show+0xcf9/0xee0 [cifs]
>   [ 1293.528360]  seq_read_iter+0x118/0x470
>   [ 1293.528877]  proc_reg_read_iter+0x53/0x90
>   [ 1293.529419]  ? srso_alias_return_thunk+0x5/0x7f
>   [ 1293.530037]  vfs_read+0x201/0x350
>   [ 1293.530507]  ksys_read+0x75/0x100
>   [ 1293.530968]  do_syscall_64+0x3f/0x90
>   [ 1293.531461]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>   [ 1293.532138] RIP: 0033:0x7f71d767e381
>   [ 1293.532630] Code: ff ff eb c3 e8 0e ea 01 00 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 90 90 80 3d a5 f6 0e 00 00 74 13 31 c0 0f 05=
 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 48 83 ec 28 48 89 54
>   [ 1293.535095] RSP: 002b:00007ffc312d65a8 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000000
>   [ 1293.536106] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f7=
1d767e381
>   [ 1293.537056] RDX: 0000000000020000 RSI: 00007f71d74f8000 RDI: 0000000=
000000003
>   [ 1293.538003] RBP: 0000000000020000 R08: 00000000ffffffff R09: 0000000=
000000000
>   [ 1293.538957] R10: 0000000000000022 R11: 0000000000000246 R12: 00007f7=
1d74f8000
>   [ 1293.539908] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000=
000020000
>   [ 1293.540877]  </TASK>
>   [ 1293.541233]
>   [ 1293.541449] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   [ 1293.542270] WARNING: possible circular locking dependency detected
>   [ 1293.543098] 6.6.0-rc7 #2 Tainted: G        W
>   [ 1293.543782] ------------------------------------------------------
>   [ 1293.544606] cat/1068 is trying to acquire lock:
>   [ 1293.545214] ffffffffc015b5f8 (&cifs_tcp_ses_lock){+.+.}-{2:2}, at: c=
ifs_put_tcp_session+0x1c/0x180 [cifs]
>   [ 1293.546516]
>   [ 1293.546516] but task is already holding lock:
>   [ 1293.547292] ffff88800aed2b28 (&ret_buf->chan_lock){+.+.}-{2:2}, at: =
cifs_debug_data_proc_show+0x555/0xee0 [cifs]
>   [ 1293.548454]
>   [ 1293.548454] which lock already depends on the new lock.
>   [ 1293.548454]
>   [ 1293.549350]
>   [ 1293.549350] the existing dependency chain (in reverse order) is:
>   [ 1293.550183]
>   [ 1293.550183] -> #1 (&ret_buf->chan_lock){+.+.}-{2:2}:
>   [ 1293.550899]        _raw_spin_lock+0x34/0x80
>   [ 1293.551401]        cifs_debug_data_proc_show+0x555/0xee0 [cifs]
>   [ 1293.552082]        seq_read_iter+0x118/0x470
>   [ 1293.552556]        proc_reg_read_iter+0x53/0x90
>   [ 1293.553054]        vfs_read+0x201/0x350
>   [ 1293.553490]        ksys_read+0x75/0x100
>   [ 1293.553925]        do_syscall_64+0x3f/0x90
>   [ 1293.554389]        entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>   [ 1293.555004]
>   [ 1293.555004] -> #0 (&cifs_tcp_ses_lock){+.+.}-{2:2}:
>   [ 1293.555709]        __lock_acquire+0x1521/0x2660
>   [ 1293.556218]        lock_acquire+0xbf/0x2b0
>   [ 1293.556680]        _raw_spin_lock+0x34/0x80
>   [ 1293.557148]        cifs_put_tcp_session+0x1c/0x180 [cifs]
>   [ 1293.557773]        cifs_debug_data_proc_show+0xd15/0xee0 [cifs]
>   [ 1293.558463]        seq_read_iter+0x118/0x470
>   [ 1293.558945]        proc_reg_read_iter+0x53/0x90
>   [ 1293.559450]        vfs_read+0x201/0x350
>   [ 1293.559882]        ksys_read+0x75/0x100
>   [ 1293.560317]        do_syscall_64+0x3f/0x90
>   [ 1293.560773]        entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>   [ 1293.561390]
>   [ 1293.561390] other info that might help us debug this:
>   [ 1293.561390]
>   [ 1293.562267]  Possible unsafe locking scenario:
>   [ 1293.562267]
>   [ 1293.562927]        CPU0                    CPU1
>   [ 1293.563394]        ----                    ----
>   [ 1293.563754]   lock(&ret_buf->chan_lock);
>   [ 1293.564068]                                lock(&cifs_tcp_ses_lock);
>   [ 1293.564573]                                lock(&ret_buf->chan_lock)=
;
>   [ 1293.565077]   lock(&cifs_tcp_ses_lock);
>   [ 1293.565387]
>   [ 1293.565387]  *** DEADLOCK ***
>   [ 1293.565387]
>   [ 1293.565852] 2 locks held by cat/1068:
>   [ 1293.566147]  #0: ffff88800818fc48 (&p->lock){+.+.}-{3:3}, at: seq_re=
ad_iter+0x59/0x470
>   [ 1293.566767]  #1: ffff88800aed2b28 (&ret_buf->chan_lock){+.+.}-{2:2},=
 at: cifs_debug_data_proc_show+0x555/0xee0 [cifs]
>   [ 1293.567611]
>   [ 1293.567611] stack backtrace:
>   [ 1293.567954] CPU: 3 PID: 1068 Comm: cat Tainted: G        W          =
6.6.0-rc7 #2
>   [ 1293.568536] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
>   [ 1293.569387] Call Trace:
>   [ 1293.569585]  <TASK>
>   [ 1293.569755]  dump_stack_lvl+0x4a/0x80
>   [ 1293.570047]  check_noncircular+0x14e/0x170
>   [ 1293.570373]  ? save_trace+0x3e/0x390
>   [ 1293.570659]  __lock_acquire+0x1521/0x2660
>   [ 1293.570982]  lock_acquire+0xbf/0x2b0
>   [ 1293.571268]  ? cifs_put_tcp_session+0x1c/0x180 [cifs]
>   [ 1293.571687]  _raw_spin_lock+0x34/0x80
>   [ 1293.571977]  ? cifs_put_tcp_session+0x1c/0x180 [cifs]
>   [ 1293.572394]  cifs_put_tcp_session+0x1c/0x180 [cifs]
>   [ 1293.572795]  cifs_debug_data_proc_show+0xd15/0xee0 [cifs]
>   [ 1293.573241]  seq_read_iter+0x118/0x470
>   [ 1293.573546]  proc_reg_read_iter+0x53/0x90
>   [ 1293.573861]  ? srso_alias_return_thunk+0x5/0x7f
>   [ 1293.574218]  vfs_read+0x201/0x350
>   [ 1293.574489]  ksys_read+0x75/0x100
>   [ 1293.574752]  do_syscall_64+0x3f/0x90
>   [ 1293.575030]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>   [ 1293.575428] RIP: 0033:0x7f71d767e381
>   [ 1293.575716] Code: ff ff eb c3 e8 0e ea 01 00 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 90 90 80 3d a5 f6 0e 00 00 74 13 31 c0 0f 05=
 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 48 83 ec 28 48 89 54
>   [ 1293.577151] RSP: 002b:00007ffc312d65a8 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000000
>   [ 1293.577736] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f7=
1d767e381
>   [ 1293.578286] RDX: 0000000000020000 RSI: 00007f71d74f8000 RDI: 0000000=
000000003
>   [ 1293.578839] RBP: 0000000000020000 R08: 00000000ffffffff R09: 0000000=
000000000
>   [ 1293.579391] R10: 0000000000000022 R11: 0000000000000246 R12: 00007f7=
1d74f8000
>   [ 1293.579951] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000=
000020000
>   [ 1293.580511]  </TASK>



--=20
Regards,
Shyam
