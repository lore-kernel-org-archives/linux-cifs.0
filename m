Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AA1186294;
	Tue, 18 Mar 2025 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742309619; cv=none; b=QHAyfobsPvKhVJ+9HUrRxzOKhsSRGdcmoEtpEkb5t+9oUAabJsUXWMv/ywSLcImYI7MAqKv88skh3qXRqhdF09ESQXbO8ojx/989DBQ4j7Dw0Ayg4CUd06O0fAVEHCT82aYwarVzF0j0CqRlbN7XhRe+8y2J2JsqhV9VegAecbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742309619; c=relaxed/simple;
	bh=sTH0UabtxaxZkCum+XDITHsWu7+/yRCwNZdRydvDwfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kKM/r0wuSuUjd+5QlnxPvo6Veyq9jlNWJEbWLe4LSRdlriB8HSdUhHwh/97UydmYY/fMubVtKYv3QtSkQ0DAJqTMOr30EKYIJcFqob113M1dI4G22xCbhWkjm98p9FlhpRhIIGAo64O4CVXT47GAnzeilnRz0uQWax2/NEISJ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HpCKwIum; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HpCKwIum"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-30613802a04so65102481fa.2;
        Tue, 18 Mar 2025 07:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742309615; x=1742914415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCX1OeueJixUkz6vpARB1ZP0NyY4RPNqrKaN8sBVG1c=;
        b=HpCKwIumX+jhMGmKLlKjtXahnlRL0WoxTwQ827/oDmaTtUtxVTiXIRRrzYTIqrdjEQ
         2O0BitDkUgT6lrrFuUKlOVb+Bx4K7Z3eFUVg4hVBkdcgc8zJLzjSjlyo2/5qrlJOigSP
         ID9xq0vGbBZhiSMEpoLYvH+I1EOdg1iTPUuWbO3yjHejXD6L47ha9TgRPbAkHk3Sv1S3
         vLnsXqgBswcygN7fgqq8pExh2upLDOo+V1xUBBaWsXSOF2rWfcuT0n34qL1Sri1MzdyO
         eLEbwFm+aU0MwK+r6YJmX6VLzAX9Heq6KphZRiHcG52BLKUXBwnEaAYerHDKxHQAN9u1
         Q24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742309615; x=1742914415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCX1OeueJixUkz6vpARB1ZP0NyY4RPNqrKaN8sBVG1c=;
        b=A430oCKeJnQPDK5cK4GCVpEtWtOyRX78tWChazJPoAUgK2+jNHAjSguXYdw16l4+l0
         BLID/wPIexVSwXa5hjlO2hXLRvutelfireOErjelmiZV+iZF341F32pUzEvd6ZvsFMit
         y/a4f6UbJio/a7bENUmiqh2LUfE8m9G+1gg96PNvbBpmTSLWTNx1EZc7GdazgrCeRHCI
         BRnK3KS73+SsY5TWlXvWrLyqWGTTnSZ3IBlb5f8FSvOx+/JO5I+yCMXd9zyQK5S8kuo2
         n4o2fS4iTgrNUESOSYsPzHaR8b54i98jffZJ6mEq0WOkxVVbs7WzbzNmPVFS7JX8CrN9
         YMLg==
X-Forwarded-Encrypted: i=1; AJvYcCUH1UXUCT95fsCha5IDp+b8VP5NkD/RESqXh5VErKmU7pWSo9cQOuxzxhjjLgQ4HcPxbF7viAQozmXLrTI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd2GCfO1XZX0e/xykjUw5YG0Pt5O6UtKZTfnq9wbZ+bMNKONG0
	e+6xIrNivWdeWXpLjmKPYo79kvrWiVCyxX8rwdlxhVda0q+E6+NV2QvvaeNx3ByzzSyXaw37MqA
	TvmPGK3SdJr/rceG4Ns7plzu9KlA=
X-Gm-Gg: ASbGncsBytqM7vPtwJHpBztTNdUU94EeWeLAfwgm356MnZDqcrpMHkqlF0XU0Jf4iuC
	oii2BPLoj8mHxWcnXuF+s3okJV6oxBuULLCgbG6bb2nHtO5d9GLYJQJ097S1Z5sC/sIhorks92I
	sy7lFJvHAr/Q9hDjcaLARfLFL3M2UBIyYp+Kw=
X-Google-Smtp-Source: AGHT+IEffRJcHBxfC84c0MY+7SqV/ayZZE4qWUDDWPAmJpHHYOTB3EnXbM/CwiNecCzYwD0ZPiPKnH340g79qGFMNp8=
X-Received: by 2002:a05:651c:2228:b0:30b:9813:afff with SMTP id
 38308e7fff4ca-30c9ff1deaamr33113881fa.31.1742309615305; Tue, 18 Mar 2025
 07:53:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt4ej2EtMHAc9Vro325XoMA++iktxcx28k1OGte_sxhVg@mail.gmail.com>
 <20250318041821.24433-1-chunjie.zhu@cloud.com>
In-Reply-To: <20250318041821.24433-1-chunjie.zhu@cloud.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Mar 2025 09:53:23 -0500
X-Gm-Features: AQ5f1JpDrX6GZyeuHJBJpx7VHoQbSFC1uafX0BXtOfPZg30P5iV2D3cvq1le95g
Message-ID: <CAH2r5mv27yTcE3wjSOj1vQ8S1Lgbw3LdAevNtB5UiAF24yWoaw@mail.gmail.com>
Subject: Re: Re: [PATCH] open hardlink on deferred close file return EINVAL
To: Chunjie Zhu <chunjie.zhu@cloud.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lsahlber@redhat.com, pc@manguebit.com, ross.lagerwall@cloud.com, 
	samba-technical@lists.samba.org, sfrench@samba.org, sprasad@microsoft.com, 
	tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Wouldn't a simpler fix be to either not include the lease key when
opening the hardlink of the file which already has a lease on the
other filename? or alternatively don't request a lease at all on the
second open? or if we get the error invalid parameter then check if
the problem was the other open of the hardlink and either immediately
close it and reopen (if deferred close) or retry the open without
requesting leases?

Failing intentionally seems wrong

On Mon, Mar 17, 2025 at 11:19=E2=80=AFPM Chunjie Zhu <chunjie.zhu@cloud.com=
> wrote:
>
> If we run 2 applications on a CIFS client machine, one application opens =
file A,
> the other application opens file B which is hard link of file A, this iss=
ue would
> happen, as well.
>
> The purpose of this patch is to reduce the CIFS protocol network communic=
ation as
> we can decide how to responsd to application at client side.
>
> > It is fixed by running with leases disable (via mount parm), but
> > wouldn't it be better to fix the error so apps don't break.  Ideas?
> >
>
> Ideas,
>
> Extend SMB SMB_COM_OPEN_ANDX and SMB_COM_NT_CREATE_ANDX messages, add fil=
e alias
> into open or create request messages, an alias means a hard link of the o=
riginal
> file.
>
> > On Mon, Mar 17, 2025 at 3:41=3DE2=3D80=3DAFAM Chunjie Zhu <chunjie.zhu@=
cloud.com>=3D
> >  wrote:
> > >
> > > The following Python script results in unexpected behaviour when run =
on
> > > a CIFS filesystem against a Windows Server:
> > >
> > >     # Create file
> > >     fd =3D3D os.open('test', os.O_WRONLY|os.O_CREAT)
> > >     os.write(fd, b'foo')
> > >     os.close(fd)
> > >
> > >     # Open and close the file to leave a pending deferred close
> > >     fd =3D3D os.open('test', os.O_RDONLY|os.O_DIRECT)
> > >     os.close(fd)
> > >
> > >     # Try to open the file via a hard link
> > >     os.link('test', 'new')
> > >     newfd =3D3D os.open('new', os.O_RDONLY|os.O_DIRECT)
> > >
> > > The final open returns EINVAL due to the server returning
> > > STATUS_INVALID_PARAMETER. The root cause of this is that the client
> > > caches lease keys per inode, but the spec requires them to be related=
 to
> > > the filename which causes problems when hard links are involved:
> > >
> > > From MS-SMB2 section 3.3.5.9.11:
> > >
> > > "The server MUST attempt to locate a Lease by performing a lookup in =
the
> > > LeaseTable.LeaseList using the LeaseKey in the
> > > SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
> > > Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match t=
he
> > > file name for the incoming request, the request MUST be failed with
> > > STATUS_INVALID_PARAMETER"
> > >
> > > The client side can return EINVAL directly without invoking server
> > > operations. This reduces client server network communication overhead=
.
> > >
> > > Signed-off-by: Chunjie Zhu <chunjie.zhu@cloud.com>
> > > ---
> > >  fs/smb/client/cifsproto.h |  2 ++
> > >  fs/smb/client/file.c      | 29 +++++++++++++++++++++++++++++
> > >  2 files changed, 31 insertions(+)
> > >
> > > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > > index 260a6299bddb..b563c227792e 100644
> > > --- a/fs/smb/client/cifsproto.h
> > > +++ b/fs/smb/client/cifsproto.h
> > > @@ -157,6 +157,8 @@ extern int cifs_get_writable_path(struct cifs_tco=
n *t=3D
> > con, const char *name,
> > >  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo =
*, b=3D
> > ool);
> > >  extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char=
 *na=3D
> > me,
> > >                                   struct cifsFileInfo **ret_file);
> > > +extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct ino=
de *=3D
> > inode,
> > > +                                 struct file *file);
> > >  extern unsigned int smbCalcSize(void *buf);
> > >  extern int decode_negTokenInit(unsigned char *security_blob, int len=
gth,
> > >                         struct TCP_Server_Info *server);
> > > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > > index 4cbb5487bd8d..0a66cce6e0ff 100644
> > > --- a/fs/smb/client/file.c
> > > +++ b/fs/smb/client/file.c
> > > @@ -751,6 +751,12 @@ int cifs_open(struct inode *inode, struct file *=
file=3D
> > )
> > >                 } else {
> > >                         _cifsFileInfo_put(cfile, true, false);
> > >                 }
> > > +       } else {
> > > +               /* hard link on the defeered close file */
> > > +               rc =3D3D cifs_get_hardlink_path(tcon, inode, file);
> > > +               if (rc) {
> > > +                       goto out;
> > > +               }
> > >         }
> > >
> > >         if (server->oplocks)
> > > @@ -2413,6 +2419,29 @@ cifs_get_readable_path(struct cifs_tcon *tcon,=
 con=3D
> > st char *name,
> > >         return -ENOENT;
> > >  }
> > >
> > > +int
> > > +cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
> > > +                               struct file *file)
> > > +{
> > > +       struct cifsFileInfo *open_file =3D3D NULL;
> > > +       struct cifsInodeInfo *cinode =3D3D CIFS_I(inode);
> > > +       int rc =3D3D 0;
> > > +
> > > +       spin_lock(&tcon->open_file_lock);
> > > +       spin_lock(&cinode->open_file_lock);
> > > +
> > > +       list_for_each_entry(open_file, &cinode->openFileList, flist) =
{
> > > +               if (file->f_flags =3D3D=3D3D open_file->f_flags) {
> > > +                       rc =3D3D -EINVAL;
> > > +                       break;
> > > +               }
> > > +       }
> > > +
> > > +       spin_unlock(&cinode->open_file_lock);
> > > +       spin_unlock(&tcon->open_file_lock);
> > > +       return rc;
> > > +}
> > > +
> > >  void
> > >  cifs_writedata_release(struct kref *refcount)
> > >  {
> > > --
> > > 2.34.1
> > >
> > >
> >
> >
> > --=3D20
> > Thanks,
> >
> > Steve
> >



--=20
Thanks,

Steve
