Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD361CAA7D
	for <linux-cifs@vger.kernel.org>; Sun,  1 Feb 2026 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769967857; cv=pass; b=OjSFAAt79qdDRzqKSHo8qq1bIIdUzXXYt8xAm2IFpv5ifIt9XrdIhGTNtO+1rn7X1/MB+xCPIjooWwouRvBoeXRbUP8ky+nhixDMYVmbJ8cNOxA1P4HnxV9jgIzNU0vnkBIrR3k6/HKpISJWmrilYhfwQzUwhbjpDB1uZKEcAUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769967857; c=relaxed/simple;
	bh=xNYfFQ7RWY/L+qH6Y0zB78KuQm4LIx2ced3NmSs5S0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJBrigzdmiRgmLaHqs4X0ufsmuM5EjvthnQDAayh+xVg9nDupSUY4yM/IS+p5Y/YnddGfAxFG2xd0J91eUGaF+veJJzBt6OxtxoZzz6F0Wia5d8HMBj3hZ8NxL7WXg9h5LrB80bsZ2BK0+/v6rPj1078XMTJ7aBVnAqAYxPWYFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bE3uOYlZ; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bE3uOYlZ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a367a1dbbso58859376d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Feb 2026 09:44:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769967855; cv=none;
        d=google.com; s=arc-20240605;
        b=HwiQo5P5TJ59o98U2XtJm9G7nU+jIJYBKuO1gt75O22D5He5xgNe5Siu9lWouAc7tZ
         cISje+w1EzDLnTxexwHiaDn8ceqkzmf6xz8YSIM/niGTvXO1yQygPgP5YrHLVCiHhH4B
         nN7vTe8NxaIb7cfdOg7NaXlpjIP/xyO6exGle0tz1Iue6l7+am81t/Y+6ZsAMYzM6b96
         3JzXsfFsKI+SQiDIVR2CheA69Ik4EIlYi4Khp7A4oqpJW1zmJadByI1/O5pMKXxRD4d0
         F3m/fRss+HZ5+uDV5vy+3QGbaiVkHvWypoRcSuiKjCFI+jMS9ic0SJLRxZJkw/FSzhcR
         3I3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9P5p4wbnD1ABbvKL0Fjyaj0R3K+dBuE8K9zunaIY2VM=;
        fh=F1JPRo7e7qPt/rE2b3tC6EtUshhFsWAXaw82Bl/lSgE=;
        b=kO0PLxcHhhylEwIKvTlUP7yEohJXszT0M5vx0Zzx0AhNOKzsuGYIqWVNKw2FCZaZcq
         8ol1uv1xLNTtE6Q/KSgUvors2eAA6ompU0F3o6mOaVSVBo+bDZ9lnqHmQRJ2claFXXjb
         x31lMSjRxK28WU4fSTfbvgqcnRhDBaVZfTvwWqdXn8ChOvEwtYk2uFaeAmbAt88G4n+X
         1OJmONMiM2tEO/4XUkzuluUIZPK37MibmdCjMphdAHbpshkRpexczZP7csnC4hJO8WCE
         MXJSc+HHNCSCSeY1Te8nuQGQNS9lRBKY2UaQGW145iELQ2Ntf+notAmZy+NybF1dRLzU
         P+1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769967855; x=1770572655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9P5p4wbnD1ABbvKL0Fjyaj0R3K+dBuE8K9zunaIY2VM=;
        b=bE3uOYlZIrPlQI0nNbggxJTEUr3JtfuciD7CxOiQNMLHM8TDf7r8co5IXVK6Xdh0Qh
         3YS2T2WDdTW2SoPxMrUbYEIPlkS7AGgzw6PZTso4awd4FirOF16Dek04/K/HhZ0LDpYr
         JuhHgQHG0NKEK2pV6KJWSjgdWSLgiK9qyEjTOnXnDJICRl3dFT010lBquq/s1D3Ec3T9
         zZwWFs/V4RkHHxTWaziDJkwViZ/HJ+GSxTNC/1D/A4OBR2+jJGjHmOzM0V/+nZ2fjxw1
         9wUp9xKCV3IAa6Ubf2O9noqPklbMcMMFf4KLl4IjLGYKgPsC/Xg30X8LyX+QPFLsE/EC
         JgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769967855; x=1770572655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9P5p4wbnD1ABbvKL0Fjyaj0R3K+dBuE8K9zunaIY2VM=;
        b=r8Gyg0A5Ac8Xb+suxzWZw7tvdLqMAMA8layVRJ2nDeXwNhrfVSirz30+G/h+A9dSLu
         agqnzP14xIFipeXcPUMdmKboDqiQpo7dIwkWbdH64LPF6+Pqs3ZUgW9x0DslSUwM8eCI
         jdeUaEIHS7JJnWkoyUX73GLXJPzeyQWiZIKhZLlL8QIMfm5+PUhI9lCQOQVEYK9ClxhC
         Ft0hNWlaiMLrMYTPDaEHBZ8fWw9FdXRLGCm1j6V1BTis45L9KC08sdeeD2bZm40nY0yQ
         3X8vHwX4s2hayGZUBXw73PndD5OY4tCUaxhwPxQxD67L9v9AhlmORatyxcFgN4ZieiRT
         ryBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIdNGh9c+roZ0aSdZsur5mhu0zxO5tIS+vw+MbmkqBEkdofZJMN8TNXB4dHOCgZ0muR4KN5pNs7tEa@vger.kernel.org
X-Gm-Message-State: AOJu0YwgW4hU2PUwkP+4i01+T3LpMt8/kESVr3l9r6Q9lrkkXKTLQa2h
	6YnldWwJyH0LovbkaDyimqq+E0Iozvt7s+RNz4YXFWQdTMuIZENwgE7Km0aXvyhG1v/PhKmLaOg
	ls+JklJLsSGPwOOhmokYkd9NKCxUTp5g=
X-Gm-Gg: AZuq6aKFYqLnk6444H+fYzUYFjn+AWs79WCn1cJmKiE4W7p0MFO4IQVCoboMxasYacV
	biCr4iWEeH+mXFq8sTp1DoPNMOzlED3kNoQSOt8A7GzUZiC5nAEbd5twPZWAknDzNToLrefFtSf
	dLlsI2QK0uIG/AvwHFHTCv92EZP40KyHP8kjhX/zHiJsZ6MMa0KbXjXpbA8VVw075dZFygzR3S6
	7FYA3b9O6wihHp5v06UcZp3+ElNXZs/j9QpoUEUB11L3HONXQvPKfVTF2TUxdZfkFSNqWB0Mevw
	0cjrPr/7/B1N6oxJMvKxpm7bU02y1k43n/sJ2Njt+mxOg6gxX/mdBYql2k2lVhd/xIvCS36cfJi
	BaMdc21aYQGhni6bSf3N8OgjcV77Wr8NRvXrs44MDW0n2PXvADI3i6RWnH/HAeLZLrvpq/gk0mE
	j8sllW4CdyUw==
X-Received: by 2002:ad4:5dcc:0:b0:895:829:4884 with SMTP id
 6a1803df08f44-8950829589fmr30883526d6.71.1769967855340; Sun, 01 Feb 2026
 09:44:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev> <CAH2r5msbLmvEpaDt4HK+jdRQw1kkh13iNtigNZ_-KxyozDoa-Q@mail.gmail.com>
In-Reply-To: <CAH2r5msbLmvEpaDt4HK+jdRQw1kkh13iNtigNZ_-KxyozDoa-Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Feb 2026 11:44:04 -0600
X-Gm-Features: AZwV_Qj_widacLXTwVYrQDtQ0MdXRWPuP6p0j14p14oQqEpCuFKxegHFttZ_jGk
Message-ID: <CAH2r5ms3o2Miv0V0_RD0nd-txUYMF_yUbwXDaMo_Fz0xbW=uUA@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix memory leak in smb2_open_file()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, nspmangalore@gmail.com, 
	henrique.carvalho@suse.com, meetakshisetiyaoss@gmail.com, ematsumiya@suse.de, 
	pali@kernel.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't see the smb1 rmmod failure in 6.18 kernel but do see it in 6.19-rc5=
.

On Sun, Feb 1, 2026 at 11:29=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Good catch.
>
> Added to cifs-2.6.git for-next
>
> This fixes the problem for smb2 and later (next will be to fix it for smb=
1).
>
> On Sun, Feb 1, 2026 at 2:11=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
> >
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > Reproducer:
> >
> >   1. On server, set the permissions of the shared directory to read-onl=
y
> >   2. mount -t cifs //${server_ip}/export /mnt
> >   4. dd if=3D/dev/zero of=3D/mnt/file bs=3D512 count=3D1000 oflag=3Ddir=
ect
> >   5. umount /mnt
> >   6. sleep 1
> >   7. modprobe -r cifs
> >
> > The error message is as follows:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >   BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_sh=
utdown()
> >   ---------------------------------------------------------------------=
--------
> >
> >   Object 0x00000000d47521be @offset=3D14336
> >   ...
> >   WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: =
modprobe/1577
> >   ...
> >   Call Trace:
> >    <TASK>
> >    kmem_cache_destroy+0x94/0x190
> >    cifs_destroy_request_bufs+0x3e/0x50 [cifs]
> >    cleanup_module+0x4e/0x540 [cifs]
> >    __se_sys_delete_module+0x278/0x400
> >    __x64_sys_delete_module+0x5f/0x70
> >    x64_sys_call+0x2299/0x2ff0
> >    do_syscall_64+0x89/0x350
> >    entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >   ...
> >   kmem_cache_destroy cifs_small_rq: Slab cache still has objects when c=
alled from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
> >   WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#=
0: modprobe/1577
> >
> > Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761=
b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
> > Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_R=
EAD_ATTRIBUTES")
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > ---
> >  fs/smb/client/smb2file.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> > index 0f0514be29cd..9ab0df01b774 100644
> > --- a/fs/smb/client/smb2file.c
> > +++ b/fs/smb/client/smb2file.c
> > @@ -178,6 +178,7 @@ int smb2_open_file(const unsigned int xid, struct c=
ifs_open_parms *oparms,
> >         rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_dat=
a, NULL, &err_iov,
> >                        &err_buftype);
> >         if (rc =3D=3D -EACCES && retry_without_read_attributes) {
> > +               free_rsp_buf(err_buftype, err_iov.iov_base);
> >                 oparms->desired_access &=3D ~FILE_READ_ATTRIBUTES;
> >                 rc =3D SMB2_open(xid, oparms, smb2_path, &smb2_oplock, =
smb2_data, NULL, &err_iov,
> >                                &err_buftype);
> > --
> > 2.52.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
