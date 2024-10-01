Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2141A3BDA
	for <linux-cifs@vger.kernel.org>; Tue,  1 Oct 2024 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727754211; cv=none; b=lU0Z7N4yNOsvuivCG0ikdWhbMKnU/luBuC/eeWZoFJpC1sqUTXcZI7cSsf3IXqOarzwmh+4Pl8xwik94ol40/ZP1NHR2r8R0wwboYdqBBQHY9aI72yVCNhK4X1OoWticclpm5p+mEzQz6xL1/LLdjDZBOKCx050IXkUofMz4Gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727754211; c=relaxed/simple;
	bh=7o0mfh4ot5lrgy2uKJW1e9uwPiH8GsWq4rVGJVKxWMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iEphbJH/x0jNhNtfFIyW1kcbj29wLHJZfTGcG/ppvEBv1v0UCc1Px/qumz1j4hIpFrtZ9xsWdjEC38VxdrEOfzD/f1hFP4IzB1MUbl8pp71cUETs+Zfb1wxk4pp/OKnXjJxEUZ8EzhlvrDnhaDTEV988V5M8xC+uAJ5j+x7na4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KwtDnjfW; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KwtDnjfW"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5398e33155fso2871684e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2024 20:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727754207; x=1728359007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hn56LApwT1oHU2v/dqCqXFicAA2bPisoYU1JmoIGrkM=;
        b=KwtDnjfWNvJA74/BkkiW56hAjuVqn5KkLQsWk03NQOeCHQmeWA7+1XXpAwNnSRr1pZ
         15+uTPxIc8M0EV1opOVjQ+HZ6Y730Nj8Yz2vziFYc6EjbsbjnDkdGp0bcdfiOCEvHASZ
         +ETQoN02+48lORE4gFyBiOllsR/aeyNcGlUfGL5jMR7jOO9E9dK/mFf2I8ADH5qFrH21
         TelnKietB/ce7Gx6OdkIpEJforWpD7Z26ti5CYczOb5mYc88uVTXRJQc6egWmowuhEya
         0g7AQhkG4uqUCa66TfEwiGffje63xwOthgIInpKSBn68JmrIvOvkJD8i+vyfg0WkoUyr
         yRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727754207; x=1728359007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hn56LApwT1oHU2v/dqCqXFicAA2bPisoYU1JmoIGrkM=;
        b=vOq2ug54ezN20L9vAU8H4C336M4uamPS9jbvCWVPozmHRW5xZ87MeeqnzktM8bHB7a
         76tWxK0r879bFm8C7W17TKfzQqwbY2pTYb0GTpLU6oxjAoOo2w3OJ5EvP5/3mkIupok2
         giNaHXsok5iCDgNtqCEMc0cVKShwMgWp2zJSf1LufABs4S4v66oUKyaL9jbkQ/3lxqJU
         3jOgY2IUEvaJJutAWYeF1QOAB+5qXkCfT7FDf9gorBVzEw6UltpuDK1e87+NfnSXmeP7
         WQLP4cEqw3849DfMUX4PYBIy9CPVzgMYIMkEjpiKlZ3ibJ+4q36fdo3LnwOMap9/BjOj
         Ucvg==
X-Forwarded-Encrypted: i=1; AJvYcCWDA5D3iMW5aPVlK3PvbKkJC7+zR1RwLRAL0KrBYAU7LCCwbl0QHK2oSK/ApNQjsLIsqKYEb0MVCQqf@vger.kernel.org
X-Gm-Message-State: AOJu0YzBp+qdiPfAL+zMnKhBm4jnA4HEOdpv6w8l3D9fpD8B2qwZEBLH
	cSPARRgtZFiBvnbP+hz6SeD0/O83wqjw/NUv+tnypv8s1O90ThMicq3yJiM21ZYIdfHzf9yWQT/
	PpzmCGV1x7kRSBIuLmcCRbXHwePIf5w==
X-Google-Smtp-Source: AGHT+IErf/hvVzAAZzlL2FX+bDvyvKylX4mPC3Chkafi6XRSvAFNak8vXlXvMniZaR12qE30U0Q218+f7uJqa5nmsnI=
X-Received: by 2002:a05:6512:1250:b0:539:96a1:e4cf with SMTP id
 2adb3069b0e04-53996a1e652mr2658018e87.32.1727754206806; Mon, 30 Sep 2024
 20:43:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926174616.229666-1-ematsumiya@suse.de> <20240926174616.229666-5-ematsumiya@suse.de>
 <6ab25571881f3d17aec3382fe80190fe@manguebit.com> <CAH2r5mtx70aZQgaojDeKDWdrCsJX=VnziKm0JBCJZzOHeKGMzQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtx70aZQgaojDeKDWdrCsJX=VnziKm0JBCJZzOHeKGMzQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Sep 2024 22:43:15 -0500
Message-ID: <CAH2r5msJiWRhWO=gkf1sMmmAtRrinr-R-OHLN3ddbOrdfajDtw@mail.gmail.com>
Subject: Re: [PATCH 4/4] smb: client: make SHA-512 TFM ephemeral
To: Paulo Alcantara <pc@manguebit.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have also added a few tests to the 'buildbot' that will do signed
SMB2.1 mounts so this won't be missed in the future.

On Mon, Sep 30, 2024 at 8:05=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> I also see a problem with smb2.1 signed mounts (will need to make sure
> our buildbot is testing with this config) so have reverted this patch
> in for-next
>
> On Mon, Sep 30, 2024 at 6:35=E2=80=AFPM Paulo Alcantara <pc@manguebit.com=
> wrote:
> >
> > Enzo Matsumiya <ematsumiya@suse.de> writes:
> >
> > > The SHA-512 shash TFM is used only briefly during Session Setup stage=
,
> > > when computing SMB 3.1.1 preauth hash.
> > >
> > > There's no need to keep it allocated in servers' secmech the whole ti=
me,
> > > so keep its lifetime inside smb311_update_preauth_hash().
> > >
> > > This also makes smb311_crypto_shash_allocate() redundant, so expose
> > > smb3_crypto_shash_allocate() and use that.
> > >
> > > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > > ---
> > >  fs/smb/client/cifsencrypt.c   |  1 -
> > >  fs/smb/client/cifsglob.h      |  1 -
> > >  fs/smb/client/sess.c          |  2 +-
> > >  fs/smb/client/smb2misc.c      | 28 ++++++++++++++--------------
> > >  fs/smb/client/smb2proto.h     |  2 +-
> > >  fs/smb/client/smb2transport.c | 30 +-----------------------------
> > >  6 files changed, 17 insertions(+), 47 deletions(-)
> >
> > This commit leads to the following NULL ptr deref when mounting a share
> > with 'vers=3D2.1'.  Reproduced it against Windows Server 2022 and samba
> > 4.21.
> >
> >   $ mount.cifs //srv/share /mnt -o ...,vers=3D2.1
> >
> >   BUG: KASAN: null-ptr-deref in smb2_calc_signature+0x195/0x4f0 [cifs]
> >   Read of size 8 at addr 0000000000000000 by task mount.cifs/693
> >
> >   CPU: 2 UID: 0 PID: 693 Comm: mount.cifs Not tainted 6.11.0 #3
> >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc4=
0
> >   04/01/2014
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x5d/0x80
> >    ? smb2_calc_signature+0x195/0x4f0 [cifs]
> >    kasan_report+0xda/0x110
> >    ? smb2_calc_signature+0x195/0x4f0 [cifs]
> >    smb2_calc_signature+0x195/0x4f0 [cifs]
> >    ? __pfx_smb2_calc_signature+0x10/0x10 [cifs]
> >    ? do_raw_spin_trylock+0xc6/0x120
> >    ? do_raw_spin_unlock+0x9a/0xf0
> >    ? _raw_spin_unlock+0x23/0x40
> >    ? smb2_sign_rqst+0x10c/0x160 [cifs]
> >    smb2_setup_request+0x225/0x3a0 [cifs]
> >    compound_send_recv+0x417/0x1140 [cifs]
> >    ? __pfx_compound_send_recv+0x10/0x10 [cifs]
> >    ? __create_object+0x5e/0x90
> >    ? hlock_class+0x32/0xb0
> >    ? do_raw_spin_unlock+0x9a/0xf0
> >    cifs_send_recv+0x23/0x30 [cifs]
> >    SMB2_tcon+0x3ec/0xb30 [cifs]
> >    ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
> >    ? ___ratelimit+0x133/0x1f0
> >    ? __pfx____ratelimit+0x10/0x10
> >    ? __pfx_SMB2_tcon+0x10/0x10 [cifs]
> >    ? cifs_get_smb_ses+0xcaf/0x1070 [cifs]
> >    cifs_get_smb_ses+0xcaf/0x1070 [cifs]
> >    ? __pfx_cifs_get_smb_ses+0x10/0x10 [cifs]
> >    ? cifs_get_tcp_session+0xaa0/0xca0 [cifs]
> >    cifs_mount_get_session+0x8a/0x210 [cifs]
> >    dfs_mount_share+0x1b0/0x11d0 [cifs]
> >    ? __pfx___lock_acquire+0x10/0x10
> >    ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
> >    ? lock_acquire+0x14b/0x3e0
> >    ? find_held_lock+0x8a/0xa0
> >    ? hlock_class+0x32/0xb0
> >    ? lock_release+0x203/0x5d0
> >    cifs_mount+0xb3/0x3d0 [cifs]
> >    ? do_raw_spin_trylock+0xc6/0x120
> >    ? __pfx_cifs_mount+0x10/0x10 [cifs]
> >    ? ___ratelimit+0x133/0x1f0
> >    ? smb3_update_mnt_flags+0x372/0x3b0 [cifs]
> >    cifs_smb3_do_mount+0x1e2/0xc80 [cifs]
> >    ? __pfx___mutex_lock+0x10/0x10
> >    ? __pfx_cifs_smb3_do_mount+0x10/0x10 [cifs]
> >    smb3_get_tree+0x1bf/0x330 [cifs]
> >    vfs_get_tree+0x4a/0x160
> >    path_mount+0x3c1/0xfb0
> >    ? kasan_quarantine_put+0xc7/0x1d0
> >    ? __pfx_path_mount+0x10/0x10
> >    ? kmem_cache_free+0x118/0x3e0
> >    ? user_path_at+0x74/0xa0
> >    __x64_sys_mount+0x1a6/0x1e0
> >    ? __pfx___x64_sys_mount+0x10/0x10
> >    ? mark_held_locks+0x1a/0x90
> >    do_syscall_64+0xbb/0x1d0
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >   RIP: 0033:0x7fd23a9a88fe
> >   Code: 48 8b 0d 1d a5 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f =
84
> >   00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 0=
1
> >   f0 ff ff 73 01 c3 48 8b 0d ea a4 0c 00 f7 d8 64 89 01 48
> >   RSP: 002b:00007ffdeef79388 EFLAGS: 00000246 ORIG_RAX: 00000000000000a=
5
> >   RAX: ffffffffffffffda RBX: 0000562a96057eb0 RCX: 00007fd23a9a88fe
> >   RDX: 0000562a6d33347e RSI: 0000562a6d3334e4 RDI: 00007ffdeef7a4a2
> >   RBP: 00007ffdeef79440 R08: 0000562a96057eb0 R09: 0000000000000000
> >   R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
> >   R13: 00007ffdeef7a4a2 R14: 0000562a96058f00 R15: 00007fd23aa96000
> >    </TASK>
> >
> >   $ ./scripts/faddr2line --list fs/smb/client/cifs.o smb2_calc_signatur=
e+0x195
> >   smb2_calc_signature+0x195/0x4f0:
> >
> >   smb2_calc_signature at /home/pc/g/linux/fs/smb/client/smb2transport.c=
:235
> >    230                  }
> >    231          } else {
> >    232                  shash =3D server->secmech.hmacsha256;
> >    233          }
> >    234
> >   >235<         rc =3D crypto_shash_setkey(shash->tfm, ses->auth_key.re=
sponse,
> >    236                          SMB2_NTLMV2_SESSKEY_SIZE);
> >    237          if (rc) {
> >    238                  cifs_server_dbg(VFS,
> >    239                                  "%s: Could not update with resp=
onse\n",
> >    240                                  __func__);
> >
> > What's the problem with having it allocated the whole time?  Reconnect
> > path will need it to re-establish SMB sessions, so this means we'll now
> > have to allocate it every time we attempt to reconnect a session?  This
> > could be worse when smb2_reconnect_server() is periodically attemping t=
o
> > reconnect a session.
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
