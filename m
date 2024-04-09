Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF461773A
	for <linux-cifs@vger.kernel.org>; Tue,  9 Apr 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712644286; cv=none; b=GfIeicFzi12U4dTSzs9GG6UcICcyjJz1vVZvvXyAgu/rQKPYSc2t/uY+zheNbiIt9Xy9/c99+6S9sSkNqmGgB19tUJiNxAL9S/ZJ/Alq4/RTXev3W1veVzMwZ/m94ZYHsq7vG49W5DwUjKBlCFiNwinn2pKw2vG3XKb3ISjQ8NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712644286; c=relaxed/simple;
	bh=u0eO/An/k5xG7Hl8P2IAWT5Q46YAZeIHVm+lyUdVzko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UOXtPbvRIEJdr1RosoCW8533Ac7SSDgPL6Dep4M7MnyFBbNS2Bxyi/iVHNhgMPQFYcCXBkYMad1n27Xo94D6lbExW+BvGdF0mb5hzhwBcRXexfy6v1ditryO7DTHbvTmunPZkx21HY38G/0gr4QdUyP1WAl6niaNkrVNCr1JjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APvJMcko; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APvJMcko"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a51d0dda061so267078066b.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2024 23:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712644283; x=1713249083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grF/9vcaqd7sXSI10pSv52oh+Ck8WrZyOyKcGgYLZ08=;
        b=APvJMcko2yA1SeIY2yM7pbU2/ZkmlYiy7KJbeX3YIIwgsLZg5GydJpKJ1HTraVVoza
         mdPvSN4EqjFeXGjtSGsZ8E8lHIo0SsrOmVLrxlQJMHCvM2Yms5zy6mRpaB2kkG3PpqTU
         dgf/kXl4/yRyhEyFwio8TNBMOZZ87+tXLeY7OK5KT5gcgf0Qq35/n9lZXC9pW4LEFgkW
         Wlx0MOpMgmeuAkVV02m6ByPMLvqGIz1X0r4g92EvwFgszCyBliQMhn5iwqGr4zn/OCzR
         UkGRJNXuX9IPcliv6mT0njKE0+TF2Wm4aZzfMZCi1dg5qnBDzFI1atXox8YxFezUTjBS
         /LqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712644283; x=1713249083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grF/9vcaqd7sXSI10pSv52oh+Ck8WrZyOyKcGgYLZ08=;
        b=hIOMszOzkP1N34Z9jqiRcC2TTu6cvhnEEDMINpkufdEC2xtXWrTso/a0BcccL1qAjQ
         SGmgm6Pm52MP76hy3Gxcscluuch5N0I0wUlqUTuiK8qcpUqZR/sQ8cBZwJ4m/cK5AxbI
         v/4rxCkbztzPgnNaLXh/YrJXZfGqg8rQGUfQ+KpuSgxLMXz5LC3DWfQ1lOA3iaMdN/4t
         C1JRSKB7UIs1pxxeMH61i6qxvTtkPkBAODAstloOtuji+UccNW7vLNBGozrj+Kgjc0a4
         La/w3F3sxLGLY9LAKQQLTxI34y+cukbb6fuLqE4y6UxoAez+uPUufwYfAd24q0uCfTzc
         AWVA==
X-Forwarded-Encrypted: i=1; AJvYcCWmJbfAsOXf57VXVrvEWAmPFWleioX3fz8L2HSXr7pvsP6Cr2IT7pqy3n6cz7RDt2baVSGC6NQl6lTJvYAwwgWIa+Mca1fhHJR6ug==
X-Gm-Message-State: AOJu0Yx41kUNjRM/eb4wTd/wV8/gq9onlEc2YtS/KbpwzPLBYA4XdrJD
	aW7Lor88RBO80YlLhmTyFirrshsC2d7ut4KdqCWRW4jxzcp3KrtZT1NYUo0niORViRCv7K1RpQf
	Kh2nn4qBlfR8lqXInidP4YXjqFks=
X-Google-Smtp-Source: AGHT+IHcDd3euzZ/lP4ybVo4gX0gxSMpDI4VAhXVJKPXXimH44DVuINDLGVtLimXEfMlcg+xPjolniPaEDP51SFX1JA=
X-Received: by 2002:a17:907:9343:b0:a51:f46a:b000 with SMTP id
 bv3-20020a170907934300b00a51f46ab000mr1152348ejc.20.1712644283357; Mon, 08
 Apr 2024 23:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240408213217.241887-1-pc@manguebit.com> <CAH2r5msiCzzP-cHcnzqHuAM23N5a_55TLMg3crt=Z0F=bS=xcA@mail.gmail.com>
In-Reply-To: <CAH2r5msiCzzP-cHcnzqHuAM23N5a_55TLMg3crt=Z0F=bS=xcA@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Tue, 9 Apr 2024 12:01:11 +0530
Message-ID: <CAFTVevUm5_FsMWq5n30zVbApbf5CtHV4Y3tZzr3bBLFV4dmvoQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix NULL ptr deref in cifs_mark_open_handles_for_deleted_file()
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, looks good.

Meetakshi

On Tue, Apr 9, 2024 at 3:39=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> merged into cifs-2.6.git for-next
>
> Good catch
>
>
> On Mon, Apr 8, 2024 at 4:32=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > cifs_get_fattr() may be called with a NULL inode, so check for a
> > non-NULL inode before calling
> > cifs_mark_open_handles_for_deleted_file().
> >
> > This fixes the following oops:
> >
> >   mount.cifs //srv/share /mnt -o ...,vers=3D3.1.1
> >   cd /mnt
> >   touch foo; tail -f foo &
> >   rm foo
> >   cat foo
> >
> >   BUG: kernel NULL pointer dereference, address: 00000000000005c0
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   PGD 0 P4D 0
> >   Oops: 0000 [#1] PREEMPT SMP NOPTI
> >   CPU: 2 PID: 696 Comm: cat Not tainted 6.9.0-rc2 #1
> >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> >   1.16.3-1.fc39 04/01/2014
> >   RIP: 0010:__lock_acquire+0x5d/0x1c70
> >   Code: 00 00 44 8b a4 24 a0 00 00 00 45 85 f6 0f 84 bb 06 00 00 8b 2d
> >   48 e2 95 01 45 89 c3 41 89 d2 45 89 c8 85 ed 0 0 <48> 81 3f 40 7a 76
> >   83 44 0f 44 d8 83 fe 01 0f 86 1b 03 00 00 31 d2
> >   RSP: 0018:ffffc90000b37490 EFLAGS: 00010002
> >   RAX: 0000000000000000 RBX: ffff888110021ec0 RCX: 0000000000000000
> >   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000005c0
> >   RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> >   R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> >   R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000200
> >   FS: 00007f2a1fa08740(0000) GS:ffff888157a00000(0000)
> >   knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
> >   0000000080050033
> >   CR2: 00000000000005c0 CR3: 000000011ac7c000 CR4: 0000000000750ef0
> >   PKRU: 55555554
> >   Call Trace:
> >    <TASK>
> >    ? __die+0x23/0x70
> >    ? page_fault_oops+0x180/0x490
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    ? exc_page_fault+0x70/0x230
> >    ? asm_exc_page_fault+0x26/0x30
> >    ? __lock_acquire+0x5d/0x1c70
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    lock_acquire+0xc0/0x2d0
> >    ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    ? kmem_cache_alloc+0x2d9/0x370
> >    _raw_spin_lock+0x34/0x80
> >    ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
> >    cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
> >    cifs_get_fattr+0x24c/0x940 [cifs]
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    cifs_get_inode_info+0x96/0x120 [cifs]
> >    cifs_lookup+0x16e/0x800 [cifs]
> >    cifs_atomic_open+0xc7/0x5d0 [cifs]
> >    ? lookup_open.isra.0+0x3ce/0x5f0
> >    ? __pfx_cifs_atomic_open+0x10/0x10 [cifs]
> >    lookup_open.isra.0+0x3ce/0x5f0
> >    path_openat+0x42b/0xc30
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    ? srso_alias_return_thunk+0x5/0xfbef5
> >    do_filp_open+0xc4/0x170
> >    do_sys_openat2+0xab/0xe0
> >    __x64_sys_openat+0x57/0xa0
> >    do_syscall_64+0xc1/0x1e0
> >    entry_SYSCALL_64_after_hwframe+0x72/0x7a
> >
> > Fixes: ffceb7640cbf ("smb: client: do not defer close open handles to d=
eleted files")
> > Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> > ---
> >  fs/smb/client/inode.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index 91b07ef9e25c..60afab5c83d4 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -1105,7 +1105,8 @@ static int cifs_get_fattr(struct cifs_open_info_d=
ata *data,
> >                 } else {
> >                         cifs_open_info_to_fattr(fattr, data, sb);
> >                 }
> > -               if (!rc && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
> > +               if (!rc && *inode &&
> > +                   (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING))
> >                         cifs_mark_open_handles_for_deleted_file(*inode,=
 full_path);
> >                 break;
> >         case -EREMOTE:
> > --
> > 2.44.0
> >
>
>
> --
> Thanks,
>
> Steve
>
