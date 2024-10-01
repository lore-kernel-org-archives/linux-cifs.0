Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1515F29AF
	for <linux-cifs@vger.kernel.org>; Tue,  1 Oct 2024 01:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727744753; cv=none; b=nwEBbSoSdz+evGJdw8aPiILsw/SDFOh7aixqgPQQwxOYu0Sb/xhofphTRQgFaZ197dTFCOU8UBsSsC/cQOAi2XIAD4d1iXyBd8mgt2oxv7p8gE+upoVwNpN7GTJwhm5XYgvjpnrxiFy7plUySM+gSZy5P8rIKeyjmeoDse1AlYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727744753; c=relaxed/simple;
	bh=Wyd18MSXyHtnA6vu2uyDwppuPTmx5pJI7RxG74Q4FCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lP43BryzZgXzXrn5X5kJcmGMsEgRZHRxpOx7HjF0GkWOanrIqu4yCB2DL4yMoEjgjLPQ2y0uGvjTKou7YX13imnu/rwYZ0KLDBdpaAiRLACQBntzKMkwwgQDDkx9YNbdkdKymXvCEKIUdAk7OQnRjbbNFsw7I1NOMxy7elinXuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iv3hY86X; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iv3hY86X"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5369f1c7cb8so6053311e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 18:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727744750; x=1728349550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLKcS9UQMbURSF346UwPmWhvrT436nIsKQgqwjd7g3k=;
        b=Iv3hY86XSjwpFFKjxlMVASoFmbtgKNtY/TB18NS1RITYFZnDAGC0FMp7hVU7fLMP09
         OA5wbdw3Pjc/+uykLBU/uwRyRPVTFLYsZrUu+VqQGNLUTawGtt2znl0TYGfV5z9VUFuh
         6IxR4dXZb0Foy+u47w41OwPJAd4JWSZeI696D45UQByzzhOH59YfK7F8l51hPOR02PRO
         Bf8KOoS4GlHwIpPGj5Kr7O0fabg16+AGPymIV5cdkcSjXOsWSZSXcU4/XRRbv0nNn11Y
         wBt9lp7rYa/BA21HnQWcTy5wAcOuxmvCSGkzEAPYBBh77JW+xm4atCg865OnOGicPkvf
         SdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727744750; x=1728349550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLKcS9UQMbURSF346UwPmWhvrT436nIsKQgqwjd7g3k=;
        b=XbMpg5ScU22wN5IJ7pKJLuPzm450O/bOfOLF/sYzLObCs85wTioqFKN3CH/rYxnd/w
         Chl+qJcD7UFpn+t1LMeu0VzkDxQXdT022VQEF7raPmJsx05aDHIQIpMTwVdPXKDJWiFd
         ApyEYPjLXvEYi1q2tpENp+dL49ZUkF7ifduipS7viQSmizz6+G8MwvjfFBdFogljR/3Q
         A91dvvN/aXuXlqJ3EQpK/Y5Kpt73xSr9NLPwmaVn6Kae4bIkIyxJCCABT0rpEONoFdjn
         55ukFb6hMROWmsCmHWIBLY9Fo8uEef3BIGsridMxCCO65PSYAWbqa5kRI8lZhMb3Ntys
         HIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUporQfmCyXXxbUP4YF3HBrxoeGxdHeYf9sPX5yZ637ciWWYQDSP7/dDF61BUs3CSsxbXvqHp16EFwT@vger.kernel.org
X-Gm-Message-State: AOJu0YzLkGWolI2LLcsPy9+vUgdWyAGXZwC8RdPTW26y2DghFltaxkr2
	3rjykV7IyfUth+msc+cArm7E0ZeqkNgfFG+STvLCwu1+SSg31pQik/JQcrRjausCfM0PH5Fnu+N
	skTo0niHMdB2SeTh1xsZTtQCl0ZQzGg==
X-Google-Smtp-Source: AGHT+IGeSCHXdQXpNkWEFRtvL5wcuT1QJ2aQnEGk7yxQbBr3bKC9Z9e3KT5Q82DNLKUDYIR9Atqx9y5L3rZ9v/PaXnw=
X-Received: by 2002:a05:6512:2254:b0:539:9645:97ab with SMTP id
 2adb3069b0e04-53996459870mr2774731e87.33.1727744749917; Mon, 30 Sep 2024
 18:05:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926174616.229666-1-ematsumiya@suse.de> <20240926174616.229666-5-ematsumiya@suse.de>
 <6ab25571881f3d17aec3382fe80190fe@manguebit.com>
In-Reply-To: <6ab25571881f3d17aec3382fe80190fe@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Sep 2024 20:05:38 -0500
Message-ID: <CAH2r5mtx70aZQgaojDeKDWdrCsJX=VnziKm0JBCJZzOHeKGMzQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] smb: client: make SHA-512 TFM ephemeral
To: Paulo Alcantara <pc@manguebit.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also see a problem with smb2.1 signed mounts (will need to make sure
our buildbot is testing with this config) so have reverted this patch
in for-next

On Mon, Sep 30, 2024 at 6:35=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > The SHA-512 shash TFM is used only briefly during Session Setup stage,
> > when computing SMB 3.1.1 preauth hash.
> >
> > There's no need to keep it allocated in servers' secmech the whole time=
,
> > so keep its lifetime inside smb311_update_preauth_hash().
> >
> > This also makes smb311_crypto_shash_allocate() redundant, so expose
> > smb3_crypto_shash_allocate() and use that.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/smb/client/cifsencrypt.c   |  1 -
> >  fs/smb/client/cifsglob.h      |  1 -
> >  fs/smb/client/sess.c          |  2 +-
> >  fs/smb/client/smb2misc.c      | 28 ++++++++++++++--------------
> >  fs/smb/client/smb2proto.h     |  2 +-
> >  fs/smb/client/smb2transport.c | 30 +-----------------------------
> >  6 files changed, 17 insertions(+), 47 deletions(-)
>
> This commit leads to the following NULL ptr deref when mounting a share
> with 'vers=3D2.1'.  Reproduced it against Windows Server 2022 and samba
> 4.21.
>
>   $ mount.cifs //srv/share /mnt -o ...,vers=3D2.1
>
>   BUG: KASAN: null-ptr-deref in smb2_calc_signature+0x195/0x4f0 [cifs]
>   Read of size 8 at addr 0000000000000000 by task mount.cifs/693
>
>   CPU: 2 UID: 0 PID: 693 Comm: mount.cifs Not tainted 6.11.0 #3
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40
>   04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x5d/0x80
>    ? smb2_calc_signature+0x195/0x4f0 [cifs]
>    kasan_report+0xda/0x110
>    ? smb2_calc_signature+0x195/0x4f0 [cifs]
>    smb2_calc_signature+0x195/0x4f0 [cifs]
>    ? __pfx_smb2_calc_signature+0x10/0x10 [cifs]
>    ? do_raw_spin_trylock+0xc6/0x120
>    ? do_raw_spin_unlock+0x9a/0xf0
>    ? _raw_spin_unlock+0x23/0x40
>    ? smb2_sign_rqst+0x10c/0x160 [cifs]
>    smb2_setup_request+0x225/0x3a0 [cifs]
>    compound_send_recv+0x417/0x1140 [cifs]
>    ? __pfx_compound_send_recv+0x10/0x10 [cifs]
>    ? __create_object+0x5e/0x90
>    ? hlock_class+0x32/0xb0
>    ? do_raw_spin_unlock+0x9a/0xf0
>    cifs_send_recv+0x23/0x30 [cifs]
>    SMB2_tcon+0x3ec/0xb30 [cifs]
>    ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
>    ? ___ratelimit+0x133/0x1f0
>    ? __pfx____ratelimit+0x10/0x10
>    ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
>    ? cifs_get_smb_ses+0xcaf/0x1070 [cifs]
>    cifs_get_smb_ses+0xcaf/0x1070 [cifs]
>    ? __pfx_cifs_get_smb_ses+0x10/0x10 [cifs]
>    ? cifs_get_tcp_session+0xaa0/0xca0 [cifs]
>    cifs_mount_get_session+0x8a/0x210 [cifs]
>    dfs_mount_share+0x1b0/0x11d0 [cifs]
>    ? __pfx___lock_acquire+0x10/0x10
>    ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
>    ? lock_acquire+0x14b/0x3e0
>    ? find_held_lock+0x8a/0xa0
>    ? hlock_class+0x32/0xb0
>    ? lock_release+0x203/0x5d0
>    cifs_mount+0xb3/0x3d0 [cifs]
>    ? do_raw_spin_trylock+0xc6/0x120
>    ? __pfx_cifs_mount+0x10/0x10 [cifs]
>    ? ___ratelimit+0x133/0x1f0
>    ? smb3_update_mnt_flags+0x372/0x3b0 [cifs]
>    cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
>    ? __pfx___mutex_lock+0x10/0x10
>    ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
>    smb3_get_tree+0x1bf/0x330 [cifs]
>    vfs_get_tree+0x4a/0x160
>    path_mount+0x3c1/0xfb0
>    ? kasan_quarantine_put+0xc7/0x1d0
>    ? __pfx_path_mount+0x10/0x10
>    ? kmem_cache_free+0x118/0x3e0
>    ? user_path_at+0x74/0xa0
>    __x64_sys_mount+0x1a6/0x1e0
>    ? __pfx___x64_sys_mount+0x10/0x10
>    ? mark_held_locks+0x1a/0x90
>    do_syscall_64+0xbb/0x1d0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   RIP: 0033:0x7fd23a9a88fe
>   Code: 48 8b 0d 1d a5 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84
>   00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
>   f0 ff ff 73 01 c3 48 8b 0d ea a4 0c 00 f7 d8 64 89 01 48
>   RSP: 002b:00007ffdeef79388 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>   RAX: ffffffffffffffda RBX: 0000562a96057eb0 RCX: 00007fd23a9a88fe
>   RDX: 0000562a6d33347e RSI: 0000562a6d3334e4 RDI: 00007ffdeef7a4a2
>   RBP: 00007ffdeef79440 R08: 0000562a96057eb0 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
>   R13: 00007ffdeef7a4a2 R14: 0000562a96058f00 R15: 00007fd23aa96000
>    </TASK>
>
>   $ ./scripts/faddr2line --list fs/smb/client/cifs.o smb2_calc_signature+=
0x195
>   smb2_calc_signature+0x195/0x4f0:
>
>   smb2_calc_signature at /home/pc/g/linux/fs/smb/client/smb2transport.c:2=
35
>    230                  }
>    231          } else {
>    232                  shash =3D server->secmech.hmacsha256;
>    233          }
>    234
>   >235<         rc =3D crypto_shash_setkey(shash->tfm, ses->auth_key.resp=
onse,
>    236                          SMB2_NTLMV2_SESSKEY_SIZE);
>    237          if (rc) {
>    238                  cifs_server_dbg(VFS,
>    239                                  "%s: Could not update with respon=
se\n",
>    240                                  __func__);
>
> What's the problem with having it allocated the whole time?  Reconnect
> path will need it to re-establish SMB sessions, so this means we'll now
> have to allocate it every time we attempt to reconnect a session?  This
> could be worse when smb2_reconnect_server() is periodically attemping to
> reconnect a session.



--=20
Thanks,

Steve
