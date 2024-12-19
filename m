Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602D1FC7E6
	for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2024 09:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600843; cv=none; b=rfZ4WuFAwX2fFLZ485KgVs3piVC8QLv/Tyl2Ynm8hDFt2/+uJod21JAAVWIiDKf/9Z7uLUyZrx34bhkXEZ7R8Xp+1e4gRP+ysEgJNeG4Si9V44PrRMLrE9T/g35lTKuZ6svLPoJGt04yOMdz0M/trg2JC8iILy3Vn8u6vRBDynw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600843; c=relaxed/simple;
	bh=NkXQHbVIPaKjJTl0Twv7M83oGAqzgTM0lTIF/LX+sK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBlthsC35pkxyol6HUntAif2hm79GHgb/rZ5pjkEKkJ2SKFqMvjgUWu/WeR/AA1zU5ljXjc9ULAbQEyF/fte7Nsaul/Z0vRZdnuTeUO2hgOWKwg4tkhea29LXQTfjOD3mzXuQCwwnUt9uuwuGh5oOA2T7+WHL/wurXk/FGbucRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1ckTtGK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1ckTtGK"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aab9e281bc0so99852266b.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2024 01:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734600840; x=1735205640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kaNQKda2PXVepE2farMFA3zqinyf8gPcsbLcw+9OmY=;
        b=k1ckTtGKpfIwwxY5haQgICwkuFtK/gTutXv8GUN8B3HMdCmDTmHUB8nGIQ0qkBXJmr
         PmYY6SE2n3HZSrG8HMFUxJ0n3/x2ojT4AhZFuUvkh8zY/879dmABWwsMLVfM3JdEmqie
         2n8EehtX6m4dd0Jf+cOyWffRACTH6BNZ/HoMeK9oVz/B+R6gvC0UgVqetvxlHMp4RBkW
         oc5X1tY8xVCArZ1pWw/Uozxxn769mFwT3Ubcg3wp+5UriYELg87EQMEmJnntkZZi9ezO
         pjOACF0glupen2joWjLEQEHubCd5UGlr+BQoUsWOCHZIGnKfBzyudL/lsu7TitLUvrEc
         P/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734600840; x=1735205640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kaNQKda2PXVepE2farMFA3zqinyf8gPcsbLcw+9OmY=;
        b=H/UrcSb+FzJ0MZgtZTsFBYGLoEdSLnfAS4QMQfRqyK4f6Ef5Dk7HpeHNcM9OUS0L9C
         oBvd0ex0jjbzoiBajnM9vbipQ6jgGKd0nj450g9YZ9W4jnOjBNGJPVO3J+jMadqV3WT0
         OFCOUr88GzdGMpfuHe3NdDTRhI3Z9kGxU+SXGNctFvcjrD9F6zkPpb4alT4iOOKOp5Al
         BnKBDM2vYFE/w9jIWpPiUPi7SBlxzOzD7QB4pUhHhXwfFZsvXB0705ZEAMtD0+jsq8EG
         Ru5D0RkMc/RU7bpQ/Di96u1YXLfkSB4VZQ/Oni5Tsunx6ULWR3l3kOZiAxbuGfGtXong
         5dmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO8HspMof6vkVi2fqwQKYFZjLHdDx9nEaAjPvTpxn7Q0z/YWHTJyiVMIrdRdc83TDV3hQWpuySwU0D@vger.kernel.org
X-Gm-Message-State: AOJu0YxAdN6zjtrpa0Diyi0JwX+6nzH99F0gLSXrb2HwZHiiL7u0//i8
	5g9F3ZmqTfrqCTanCSL1ekumos5WRUXWq40gZMCjF8e6s2ldA+ockN32nwAmRbeC0IfmVtFhcPD
	alzzUuZQ26lkAkd1Qd9w7GSP25C+DIDpq
X-Gm-Gg: ASbGncs93Fh9niDqYN7myyCEqHCgA2V2yL16/xF1tgEjx5RUwqzb9fq2O5NJCtQamZp
	sprPOl+5Ew//CdO4Do+/aNNkTVkYT7SwVlNKNl19XJOxI9UQx+9q3gXUIiT0vsYl0gIop
X-Google-Smtp-Source: AGHT+IFq5n9ahI9pZzZwpAOQU1tPkwL7ms9hxAtfyjEvZfRW6Rqr9OpIqP/iSMpJs8xV381aLq3ToaLa7F1eRK33gi0=
X-Received: by 2002:a17:907:1c9e:b0:aa6:7785:5485 with SMTP id
 a640c23a62f3a-aac07b0a1admr234588166b.38.1734600839550; Thu, 19 Dec 2024
 01:33:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241216183148.4291-1-bharathsm@microsoft.com> <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
In-Reply-To: <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 19 Dec 2024 15:03:48 +0530
Message-ID: <CANT5p=rYjgbteSBRuZFfXYwC-g6QLMG20250RzO9Es8GZPeL2g@mail.gmail.com>
Subject: Re: [PATCH] smb: enable reuse of deferred file handles for write operations
To: Steve French <smfrench@gmail.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	pc@manguebit.com, sprasad@microsoft.com, tom@talpey.com, 
	ronniesahlberg@gmail.com, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 2:22=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> merged into cifs-2.6.git for-next pending review and more testing
>
> On Mon, Dec 16, 2024 at 12:36=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > Previously, deferred file handles were reused only for read
> > operations, this commit extends to reusing deferred handles
> > for write operations.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/file.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > index a58a3333ecc3..98deff1de74c 100644
> > --- a/fs/smb/client/file.c
> > +++ b/fs/smb/client/file.c
> > @@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct file *fi=
le)
> >         }
> >
> >         /* Get the cached handle as SMB2 close is deferred */
> > -       rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> > +       if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
> > +               rc =3D cifs_get_writable_path(tcon, full_path, FIND_WR_=
ANY, &cfile);

Wondering if FIND_WR_ANY is okay for all use cases?
Specifically, I'm checking where FIND_WR_FSUID_ONLY is relevant.
@Steve French Is this for multiuser mounts? I don't think so, since
multiuser mounts come with their own tcon, and we search writable
files in our tcon's open list.

> > +       } else {
> > +               rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> > +       }
> >         if (rc =3D=3D 0) {
> >                 if (file->f_flags =3D=3D cfile->f_flags) {
> >                         file->private_data =3D cfile;
> > --
> > 2.43.0
> >
> >
>
>
> --
> Thanks,
>
> Steve
>
Other than that one thing to look at, the changes look good to me.

--=20
Regards,
Shyam
