Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6110519B3CB
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749749291; cv=none; b=WDAmyByOIRHjrdzLh9pRZlszlvarhmx1pAJba5Nxuh/0YApdp6MmB9OJbQg3hyxXf7168AGAx+a3kEop2QBDIWKMdQz5MVKV6H40LKPQlQKbCvD4ArpjjdlVpHdhUxnxUYrvaLo1MAVHuqv5G9WMbTrtVgc7Y7UGeggJZM/xoiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749749291; c=relaxed/simple;
	bh=WZhop1YERcX997E+c3qVwBRYLGpfGoRCq9o/Qh0dYwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfsgww7/4OEgf2NScmtC58uDfh6iw3LFcUsIkw2Bug9dXgLPXKaHPKs3ZF4WQgPEnAvl+WtvnSsdywx94Zes/TBc5NhprZNihE0r2fW6JpUrltFrAChXXS53UAIxtCxHoGjnBFonjsdOzNbRSNnflT4OyCq6h/xtnMPS07fh5yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXVcZUzT; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXVcZUzT"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so2832316a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 10:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749749288; x=1750354088; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxyarbdSY2J5PiefhCbtRfuR9hDa8cQW32zW7iXDPtk=;
        b=WXVcZUzTF6HMpbE7Y568lH1+dk9U6r6tmnd3/BcqGC+Crf+DGAOWATSfGNOrEOYnC6
         o/2Bk4tvIKFD92AtuaTAyqBhZ7jVE/VslwzLFwO7F37qbvCdk5sNjCyrGaeRu/7nvRnA
         AtDtScE3LSRJYaq27rk5r30nMAuYMeNMeZotXHL9EzMz1HjjBJ8YNqavDUcyeTc2+Y4F
         Wkofhd6j8pA56wGTl2SYRiosqU+a9H75fSN0LF0n5RZLHRpVlbdaoR6BoCh/Lk2TNoGs
         96CY/LKvE22xxNrfjVUrl3GsNSU3mYnfRDP7vOTDk0TR5KqoL1QjLh1ktPkjTiroiiuV
         obDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749749288; x=1750354088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxyarbdSY2J5PiefhCbtRfuR9hDa8cQW32zW7iXDPtk=;
        b=DekE4cG4w0vNh+jU/L3BAzsxVtZPWM/Kz8aowTKTSvCre8ZvPAep6MNcJLHIYwzubZ
         BZQTiB1+sJZCMa6ANT0IszYumkQPV9vcOZTzsEP1BI3PiUywlHS0HBEvh7dD9omglC/G
         SdkzoMUiwNBdtx/KbMhYUcmifvQQenz/e8sqSPaAg1zSYn6ZDUeF4F1HDqbviXV7wu1P
         AzPJolqIvREf8tYGN4QwTxueEjs7srsazF16n2rZ+4i3y3ghcc+ROfCqaHHqLSVcOenH
         BtjHo/dgMv6AxF33t2A7NODLnW3uEX34vnVl2LBd+iEtjsbKdtdi+GEn34Hz8Q0R+H+K
         hNEA==
X-Forwarded-Encrypted: i=1; AJvYcCVKJ5kBQ+j0w8eFqq5vxKzoLZDY7ScnqDzZTrAvd4Pe3BvVySvnr6w8QDxrXujfOTrSIk6lGkG/gLth@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8gWJbnzAKP4skGLgf2e6cajMsR4p5Wpx9wWDnFwg8xKm+k7sZ
	rDm5oS5TUtZ99EN4rTsDY5G2Zhssv2IdQw1vWIV34U6UyyzvBm3yqHF+Xj1KQLEQzQyo/3BVqpX
	h/q8BsT/nau+6n9SjYgKMSKNUP/LsGFAbHHGJ
X-Gm-Gg: ASbGnctPL7H40E7TbcXcYedYSC+6epIqBG9FnPjUgtcpsYMCIzm/PaALDbFBfl/7AV8
	Vw+9F3c+nN2cezKvIl/hWpQPIfQeNtM8lMylxQMsXpJEMdgLu1uc3GXWZAg9nWUiezUWjRd5VGy
	u6Y796/mmKtc2+389mstqrDxQwn1hGjpMUr1xn3FNVRw==
X-Google-Smtp-Source: AGHT+IEjXcozh2Rb0LebaVnLpFlJnKCv3JcSTNiMe/z0WvTzIm4/wb52Li5F6mYFcDlS7gElsIt3uyndAe3dhspA66o=
X-Received: by 2002:a05:6402:2694:b0:607:783e:5970 with SMTP id
 4fb4d7f45d1cf-608af556ec6mr633466a12.8.1749749287577; Thu, 12 Jun 2025
 10:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612154504.246390-1-pc@manguebit.org> <CAH2r5mvh7VC_fVp0QQ2ACJohuEvWriJp+zc8HSW6Z6GQTeH2-w@mail.gmail.com>
In-Reply-To: <CAH2r5mvh7VC_fVp0QQ2ACJohuEvWriJp+zc8HSW6Z6GQTeH2-w@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Jun 2025 22:57:56 +0530
X-Gm-Features: AX0GCFvEKuhi5RjO_rhPhVqVNlYeDEl6JbhuZF23YKa5VGsBdqkOjB3hXsiMFU0
Message-ID: <CANT5p=rGbHfXiHYyQE6bXxka0o299ZhgZ8oajrwYw7f147k_Zg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix perf regression with deferred closes
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Jay Shin <jaeshin@redhat.com>, 
	Pierguido Lambri <plambri@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 9:56=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> tentatively merged into cifs-2.6.git for-next pending testing and any
> additional review
>
> On Thu, Jun 12, 2025 at 10:45=E2=80=AFAM Paulo Alcantara <pc@manguebit.or=
g> wrote:
> >
> > Customer reported that one of their applications started failing to
> > open files with STATUS_INSUFFICIENT_RESOURCES due to NetApp server
> > hitting the maximum number of opens to same file that it would allow
> > for a single client connection.
> >
> > It turned out the client was failing to reuse open handles with
> > deferred closes because matching ->f_flags directly without masking
> > off O_CREAT|O_EXCL|O_TRUNC bits first broke the comparision and then
> > client ended up with thousands of deferred closes to same file.  Those
> > bits are already satisfied on the original open, so no need to check
> > them against existing open handles.
> >
> > Reproducer:
> >
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> >  #include <unistd.h>
> >  #include <fcntl.h>
> >  #include <pthread.h>
> >
> >  #define NR_THREADS      4
> >  #define NR_ITERATIONS   2500
> >  #define TEST_FILE       "/mnt/1/test/dir/foo"
> >
> >  static char buf[64];
> >
> >  static void *worker(void *arg)
> >  {
> >          int i, j;
> >          int fd;
> >
> >          for (i =3D 0; i < NR_ITERATIONS; i++) {
> >                  fd =3D open(TEST_FILE, O_WRONLY|O_CREAT|O_APPEND, 0666=
);
> >                  for (j =3D 0; j < 16; j++)
> >                          write(fd, buf, sizeof(buf));
> >                  close(fd);
> >          }
> >  }
> >
> >  int main(int argc, char *argv[])
> >  {
> >          pthread_t t[NR_THREADS];
> >          int fd;
> >          int i;
> >
> >          fd =3D open(TEST_FILE, O_WRONLY|O_CREAT|O_TRUNC, 0666);
> >          close(fd);
> >          memset(buf, 'a', sizeof(buf));
> >          for (i =3D 0; i < NR_THREADS; i++)
> >                  pthread_create(&t[i], NULL, worker, NULL);
> >          for (i =3D 0; i < NR_THREADS; i++)
> >                  pthread_join(t[i], NULL);
> >          return 0;
> >  }
> >
> > Before patch:
> >
> > $ mount.cifs //srv/share /mnt/1 -o ...
> > $ mkdir -p /mnt/1/test/dir
> > $ gcc repro.c && ./a.out
> > ...
> > number of opens: 1391
> >
> > After patch:
> >
> > $ mount.cifs //srv/share /mnt/1 -o ...
> > $ mkdir -p /mnt/1/test/dir
> > $ gcc repro.c && ./a.out
> > ...
> > number of opens: 1
> >
> > Cc: linux-cifs@vger.kernel.org
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Jay Shin <jaeshin@redhat.com>
> > Cc: Pierguido Lambri <plambri@redhat.com>
> > Fixes: b8ea3b1ff544 ("smb: enable reuse of deferred file handles for wr=
ite operations")
> > Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> > ---
> >  fs/smb/client/file.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index d2df10b8e6fd..9835672267d2 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -999,15 +999,18 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> >                 rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> >         }
> >         if (rc =3D=3D 0) {
> > -               if (file->f_flags =3D=3D cfile->f_flags) {
> > +               unsigned int oflags =3D file->f_flags & ~(O_CREAT|O_EXC=
L|O_TRUNC);
> > +               unsigned int cflags =3D cfile->f_flags & ~(O_CREAT|O_EX=
CL|O_TRUNC);
> > +
> > +               if (cifs_convert_flags(oflags, 0) =3D=3D cifs_convert_f=
lags(cflags, 0) &&
> > +                   (oflags & (O_SYNC|O_DIRECT)) =3D=3D (cflags & (O_SY=
NC|O_DIRECT))) {
> >                         file->private_data =3D cfile;
> >                         spin_lock(&CIFS_I(inode)->deferred_lock);
> >                         cifs_del_deferred_close(cfile);
> >                         spin_unlock(&CIFS_I(inode)->deferred_lock);
> >                         goto use_cache;
> > -               } else {
> > -                       _cifsFileInfo_put(cfile, true, false);
> >                 }
> > +               _cifsFileInfo_put(cfile, true, false);
> >         } else {
> >                 /* hard link on the defeered close file */
> >                 rc =3D cifs_get_hardlink_path(tcon, inode, file);
> > --
> > 2.49.0
> >
>
>
> --
> Thanks,
>
> Steve
>

Looks okay to me.

--=20
Regards,
Shyam
