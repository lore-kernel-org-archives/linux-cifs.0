Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FF5219A7D
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762617616; cv=none; b=r/OE4rkhvlZEXQxn27/ifg6lfM0GCYa88s8utcu1DcUj2N+FwEELlo+U6Y6P9Pu1MOd4L/fn14NoOMOEPoEYUdDJawoi32T0Uiw8FSyY2keVX03NrRJL6HGDw5EMeRZS6l5asOquShJQ6W/XQ2xF90mOWrMUTBqZj8ERtnWmQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762617616; c=relaxed/simple;
	bh=bFsXLkOC7htAcCK4FnqqlbRFpr/P4o9KOYs3YriLlAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bW9YAu9pxFizklbe7dhMcMxCDulIntB9+KrM0iu09g0JlLcE2q30wUgz/KWLBXBol30KLTQwg5UWCHdJ291sWRq9CMxHq1KUyNd5+M5cYU4VCgM+a/Dv5ftC6n70896g9SYhUvKpi9mti6sQ5fgQXllT/pCNIwIFP+JTewG75GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Is+gnpXv; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Is+gnpXv"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b70b40e0321so32114066b.1
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 08:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762617613; x=1763222413; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5gIjwY0VIkQOLBhqDqw7K5il1qhHJd5j+7PMJ2a3+Q=;
        b=Is+gnpXvIL2ogHXDKkF/jx3CednBJYPcv22ZtpKCpu0J6ktH08cYqOTIDJlImVwAR7
         dyadKr9LlZTSsCgGBjtMsgIKKq9aBsGeW8+r5IzXjSAjWBYZ3OVTgo6uYrq9icO6IlOF
         IVkGhwAyMxV7ikbVVNRnmjC8mDX8vCy/GKp46scZ16Ci2LnVjKSnHNFvDEX9zuMxH2+Z
         YVkYRdQKFphGrNMbRY2Oy4qk2av87Up9LwptxDxLnmJjZsF8Xe6/aUsnO15QPNvZ1Pkq
         2lqsTfK94VflzWP5umoJw2LHLCqXN+zFDwGMXILfP1TShNrwOVjV7rzZcievbF7ENZ5V
         S8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762617613; x=1763222413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5gIjwY0VIkQOLBhqDqw7K5il1qhHJd5j+7PMJ2a3+Q=;
        b=T5oQ8FBoajuAXv0tZUjVjHc/de+BVU7asRlxgsIPO/F12PZUa/C4EQdZ8/tZgiMQ6y
         fH+f7fjUFDsxcjMbH3Ik05bzysHupvaAp3xOhEs0ckPgJm/rjhqH2IwVdcquJcZE7iQX
         fXV4xjm4MSYbEhhxgg8A7iPp8/a/XT1DGNledW6NyGtgCmF+/vgvU3Qb4AS+pKQXP6r8
         enEGynndHVwqO/hy7q1UGmq960cPvpjyHkgK17o5SCBaKGpcApQN5uwLtCWdSXU889zO
         QGn6FVRLObvEQlM/BFTVJfkl7NN0CTIKhlAdTyJzFV2eMLdZ+KVTpwVvaqYn2bHrMtS7
         8GOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK4YN07JRcyFst4zcK35bFn1LGKTm65oftQ+amxwYZBbRSP0Shvhnu3UzqWXpyjqS+pTZ7nNsPlw5r@vger.kernel.org
X-Gm-Message-State: AOJu0Yy64hdE1GyR8YdAKngvfkTmcoatjQEPqAm7pFdz8ru/rc+ovDGd
	icnO74chkD5wdYR9e3zWz8PwZotAqFVNieedfUFEFMPjk/C60gV6nJ+7nupml0VeQ67nPWRP8aV
	F9bSaqw1IoIuduFpb0KPuB+uYnha6Pys=
X-Gm-Gg: ASbGncst/bqdJPN1i0XsH/Goy5L9GmI8x/GrYxHL3VY8SAg1mUl/CnMqqvUwTB1k+c1
	pLtWfWY5Imm5k6mmMm8oiAkbK7a2mRI/p/3g91OeviVVJCRshLNvgQymDuZDII7pubkOqvXFfd3
	ZZlo8PP2SK8Z88x3m9hWCforwc0z06hfXRKbwoNWjkkXlosMLOFM6BNxw686zEfo1ml7CBaQjwC
	kPuOVKSDFjETkoZ/BxLxgPw4Spw2pbjpi4B4xrV7zRlT10ZlLVuKY/LUI85D9O5vT0VTNiy
X-Google-Smtp-Source: AGHT+IE36q81ytbzipjRNhSYqb9l6GAh21i2Japqe13b7xIwmws0+g4DATqa0W/viEjZnbKMLzVT0GmZGyYO3yq7+qg=
X-Received: by 2002:a17:907:d29:b0:b46:6718:3f1f with SMTP id
 a640c23a62f3a-b72e0572c96mr159995566b.7.1762617612482; Sat, 08 Nov 2025
 08:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025110803-retrace-unnatural-127f@gregkh> <20251108123609.382365-1-pioooooooooip@gmail.com>
 <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
In-Reply-To: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
From: =?UTF-8?B?44GP44GV44GC44GV?= <pioooooooooip@gmail.com>
Date: Sun, 9 Nov 2025 01:00:01 +0900
X-Gm-Features: AWmQ_blPS5r1nNyxxhsinZ2QngiwVO-KEXZe6F6Hp_3GEfSqaWpGWONKMCdT6F4
Message-ID: <CAFgAp7hG8k7Qrtor0O_CKb8tH3yNso-m2AjWDmvOtbRE4056JA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: vfs: fix truncate lock-range check for shrink/grow
 and avoid size==0 underflow
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhitong Liu <liuzhitong1993@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the guidance =E2=80=94 I=E2=80=99ve sent v2 patch.
Best regards,
Qianchang

On Sat, Nov 8, 2025 at 11:46=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sat, Nov 8, 2025 at 9:36=E2=80=AFPM Qianchang Zhao <pioooooooooip@gmai=
l.com> wrote:
> >
> > ksmbd_vfs_truncate() uses check_lock_range() with arguments that are
> > incorrect for shrink, and can underflow when size=3D=3D0:
> >
> > - For shrink, the code passed [inode->i_size, size-1], which is reverse=
d.
> > - When size=3D=3D0, "size-1" underflows to -1, so the range becomes
> >   [old_size, -1], effectively skipping the intended [0, old_size-1].
> >
> > Fix by:
> > - Rejecting negative size with -EINVAL.
> > - For shrink (size < old): check [size, old-1].
> > - For grow   (size > old): check [old, size-1].
> > - Skip lock check when size =3D=3D old.
> > - Keep the return value on conflict as -EAGAIN (no noisy pr_err()).
> >
> > This avoids the size=3D=3D0 underflow and uses the correct range order,
> > preserving byte-range lock semantics.
> >
> > Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> > Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
> > ---
> >  fs/smb/server/vfs.c | 28 +++++++++++++++++++---------
> >  1 file changed, 19 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> > index 891ed2dc2..e7843ec9b 100644
> > --- a/fs/smb/server/vfs.c
> > +++ b/fs/smb/server/vfs.c
> > @@ -825,17 +825,27 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
> >         if (!work->tcon->posix_extensions) {
> >                 struct inode *inode =3D file_inode(filp);
> >
> > -               if (size < inode->i_size) {
> > -                       err =3D check_lock_range(filp, size,
> > -                                              inode->i_size - 1, WRITE=
);
> > -               } else {
> > -                       err =3D check_lock_range(filp, inode->i_size,
> > -                                              size - 1, WRITE);
> > +               loff_t old =3D i_size_read(inode);
> > +               loff_t start =3D 0, end =3D -1;
> > +               bool need_check =3D false;
> > +
> > +               if (size < 0)
> > +                       return -EINVAL;
> There is no case where size variable is negative.
>
> > +
> > +               if (size < old) {
> > +                       start =3D size;
> > +                       end   =3D old - 1;
> > +                       need_check =3D true;
> > +               } else if (size > old) {
> > +                       start =3D old;
> > +                       end   =3D size - 1;
> > +                       need_check =3D true;
> >                 }
> >
> > -               if (err) {
> > -                       pr_err("failed due to lock\n");
> > -                       return -EAGAIN;
> > +               if (need_check) {
> > +                       err =3D check_lock_range(filp, start, end, WRIT=
E);
> > +                       if (err)
> > +                               return -EAGAIN;
> >                 }
> >         }
> Can't you just change it like this?
>
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 891ed2dc2b73..f96f27c60301 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -828,7 +828,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
>                 if (size < inode->i_size) {
>                         err =3D check_lock_range(filp, size,
>                                                inode->i_size - 1, WRITE);
> -               } else {
> +               } else if (size > inode->i_size) {
>                         err =3D check_lock_range(filp, inode->i_size,
>                                                size - 1, WRITE);
>                 }
>
> Thanks.
> > --
> > 2.34.1
> >
