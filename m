Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05EA2F2908
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 20:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757536107; cv=none; b=CqRtElmQEK9myogrGaCVNn1M1yUi9mNe6sJukZ4Zq2vmPXP2PQ38TxUvmtuloR0OI5ZSCZW6IO6ynH6ZRGkYzd3vJ+/byGeMCVQBPeOoJ85Ej0mDEJWOCHed1LYwJcI9krv4CqB9ED3Qj4aaxIlVxEW2gmzmK6URAAMesL+Vobw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757536107; c=relaxed/simple;
	bh=Xko8QyVLkghzk+iRlobeMXjKo0UBP1Sgk5r5q5Wu0Z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m76QtqQYEMOKl8xcxiLXuB36WkJ/lALMa+7ITlFXhNqhHM509svupxJbTxP2R6zpH3PmogEc+69msHN2Aeve8yehYsYfW+1Fbca4aPImAFGcDKWvfegNhksuDT/5/Ef6hD/DujjhSaP99D8jHqNnGNtWrOxC8A2ip6L+Gs2ggc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d1N2xpEO; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1N2xpEO"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70df92872ceso156626d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 13:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757536105; x=1758140905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoD+jf8a6jOSihiLhiZa52QhcqKVRTwi8Wfw11HdQ9A=;
        b=d1N2xpEOYA8D2RFFXnf6CDGpZmf0hXiteqZb+17zPt5v68nKfzXCZ8mSoMQnmgW4dn
         XyMjIB4mA6QOn0oNPvFI+DjKsrcmSppsKJswr0ghDkOnT9VQ3Ek2Nbt72Yx/SIMLLakE
         8uxzZOE3ZULf0kH4SepKD4iAxYkEJyn7I9ArIO137Ls/FNt6ROBEDJvhB7E959f8Q6+y
         J5JGUUgoOuSoqjqFHxDZWU4XYfgQct1gj6eTb+n3aRxFPnhU8Dh8v+nm2W6Zud7Jc8gr
         2Tr6dFuKN1vHJt4Sp9W0MSwygd6X0+FvSG4CbFtwiz0i/Mj1cIU2NTc++TPRARa1osLl
         vXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757536105; x=1758140905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EoD+jf8a6jOSihiLhiZa52QhcqKVRTwi8Wfw11HdQ9A=;
        b=eNefn0yXcZtp0+UhsdT8ixup926jv+/q4OaXYwSHKZNXuNY4pEjzyaF5f4NsnAWRZW
         W7kMIhbA3sUYL0gmshEPLj6U68doPlRArGl5AePKVbfuAGzfFFHF+3Lkc95fgoDuP8M+
         FbJAhUFi9hIKQNiDSTGdO0YCXIFzHVtg93L6XKzcqhuCLgtTVs/g2oIDGNu6kIx0ZcXo
         Kf3q5fypQA15WQGbAxsVaUPOBjkPDFlnH8hu/ke70m5L97IjP4qphLZYbGUVXow5gkkE
         m7rFJIzHr2eFyodov6bRnV1eEOEmXn0aEdE+3tJb2LXRyXlg4l0FE0ig3qu9LRgoonkD
         Yatg==
X-Forwarded-Encrypted: i=1; AJvYcCXIZqkqTmJ1KrmEL2iZf8B6x2r+wzVsou2443/nIr4Z1xgcRQ50jiSjL1e8G2CX8QHvxymmgnB3OyuR@vger.kernel.org
X-Gm-Message-State: AOJu0YxtBZwgGiTyn78Ssab5XPQdF/ZgZQTXK0Ey0OsXG7M7I9QUj3Ys
	kZCMasIn1FZk2G6yC/Os3k+no4FUuprU9NVWtpsVqSDxCRr41Yz4t8+BCJpqEEfyQz+ZAUwBmev
	qCKOaMfpm+tyzf4DQrGkTey5jJaHF11U=
X-Gm-Gg: ASbGncsbTbq47H21hse+/3xGmMSeYRilxOLfAcXWWMLKnJ5GjDLEq7urdO0sgnHDeDY
	/gbovDBtoExvGxd2jTlnPNen+IHWVjM7it3cp7J9Qcd/PuYLqZ72RQ/mqpuqOmwCAqYhZxsY/sI
	QFRRXCccirn8hA7cfdi44Mlrht6J1kdXb3OZ6zvQZsa2XLoqEhou9oqJT2qgk5AVQJQI/hiSYq4
	RMjzAVHRLw6VtSPTCj+g1Pr3QixTACLA4Oe4Na6QuCBYP9BQ3DX85LNpvwVKzY6v24JHjVf1qqJ
	CS/EPSjWZwrHjtj6Y5XkHqerLld7NGJrGSP9UDRbJtV0Wd91z2KUq7FFVpjvl4I2ljMBhjRy8MT
	UhKce4Y86lEg=
X-Google-Smtp-Source: AGHT+IFKakBwYP74rJ88DzfdJVV1aGp5+fkJMCp7pOJ0vCm7iGGmkE/jHeOrycAsem3ie7ZJP2Vxn+zv+pDvJdQO0/8=
X-Received: by 2002:ad4:5aad:0:b0:758:2117:821d with SMTP id
 6a1803df08f44-762262da023mr13048626d6.24.1757536104692; Wed, 10 Sep 2025
 13:28:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250909202749.2443617-1-henrique.carvalho@suse.com> <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 10 Sep 2025 15:28:13 -0500
X-Gm-Features: AS18NWCNmYnjg4A1foJeFwN28A6zzIlDiu7n1TIAkJn4QwuFykRpCngiuKkNZvM
Message-ID: <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Henrique, I can repro the failure in generic/005 with your patches,
but am fascinated that one of your patches may have worked around the
generic/637 problem at least in some cases, but am having difficulty
bisecting this.

On Wed, Sep 10, 2025 at 12:50=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Interesting that running with three of your patches, I no longer see
> the failure in generic/637 (dir lease related file contents bug) but I
> do see two unexpected failures in generic/005 and generic/586:
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
5/builds/116
>
> e.g.
>
> generic/005 5s ... - output mismatch (see
> /data/xfstests-dev/results//smb21/generic/005.out.bad)
>     --- tests/generic/005.out 2024-05-15 02:56:10.033955659 -0500
>     +++ /data/xfstests-dev/results//smb21/generic/005.out.bad
> 2025-09-10 08:33:45.271123450 -0500
>     @@ -1,8 +1,51 @@
>      QA output created by 005
>     +ln: failed to create symbolic link 'symlink_00': No such file or dir=
ectory
>     +ln: failed to create symbolic link 'symlink_01': No such file or dir=
ectory
>     +ln: failed to create symbolic link 'symlink_02': No such file or dir=
ectory
>     +ln: failed to create symbolic link 'symlink_03': No such file or dir=
ectory
>     +ln: failed to create symbolic link 'symlink_04': No such file or dir=
ectory
>     +ln: failed to create symbolic link 'symlink_05': No such file or dir=
ectory
>
> Do you also see these test failures?
>
> On Tue, Sep 9, 2025 at 3:30=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > For mkdir the final component is looked up with LOOKUP_CREATE |
> > LOOKUP_EXCL.
> >
> > We don't need an existence check in mkdir; return NULL and let mkdir
> > create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/dir.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > index 5223edf6d11a..d26a14ba6d9b 100644
> > --- a/fs/smb/client/dir.c
> > +++ b/fs/smb/client/dir.c
> > @@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct=
 dentry *direntry,
> >         void *page;
> >         int retry_count =3D 0;
> >
> > +       /* if in mkdir, let create path handle it */
> > +       if (flags =3D=3D (LOOKUP_CREATE | LOOKUP_EXCL))
> > +               return NULL;
> > +
> >         xid =3D get_xid();
> >
> >         cifs_dbg(FYI, "parent inode =3D 0x%p name is: %pd and dentry =
=3D 0x%p\n",
> > --
> > 2.50.1
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
