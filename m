Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A78D502;
	Fri, 13 Sep 2024 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726266818; cv=none; b=O6/gSp7Jr1XhFbFqyC0ok9Yh2L+PLFHgI7wgScZT+s3K+USW2wMgjAtf7e3qnaaTLe/qjAsBVX/Oymjiq/Wiqa81L33F0eRPvO3FqjFy1p7NZfP5QV8/pqEjVBP7EEBZO1amz1CnARd4NLrFjg41cMMfgSdmtyc4TfbvpSlLQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726266818; c=relaxed/simple;
	bh=EdFGuxoFM7GGXxeP3wdVcdb75w5FP1HDHQLPeMjebGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tb119WjaaE62NUqillLmkpUfCpmAwAfbfhP7j/e9DfZawACWf/QOJoSv6i/JtE0NheTKKcRqfknWbArH/Rmfj0qz8Lg0lF0pMj4t+hGJCoOOko/eYx2Ts1N5k//k2aZuJQVUk5r/CuuvcuQctVxH76cyin79jXtL6WzSayZHcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUF1QpXN; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUF1QpXN"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a8a706236bfso74231366b.0;
        Fri, 13 Sep 2024 15:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726266815; x=1726871615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8U9RJozTknlutL+hhyt4CUdPuPWCF8nPwSWbYIEsTxc=;
        b=TUF1QpXNopukTz47CQkB5dgKnLRVsUL5NMLaDo1xgMnOiCTwr3O4oW1oaRTfNWZ0PP
         wUlJL45ov8A8dPI9N/1hdTk8SpmFwK37uaJM51jqGvY1WWkwVkUjN21OX6z2l0J1HyDP
         Xu5ZV4qmo9iOCZlKwLt3p5S96Luk/3hv/0MzeU63nIjJmooHdoumQQ/uxdpCwiMd7ED5
         fyI4Rp8pdg4Jn2WiH9aa8Q5EVQULxVlpVwcz5/mvvHSy03nrZ5sysvkRiaFJdoLY1eZE
         4yDJsUKs+fFGGV/jv4kpqeYVXGzwaHcXvqUXcmh2h/Sg5scYK7dBjJBV5ndk+BqqmSyI
         kCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726266815; x=1726871615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8U9RJozTknlutL+hhyt4CUdPuPWCF8nPwSWbYIEsTxc=;
        b=mTkgFMtXv9tqhmYe5YWbT68dm/LOiBPmwMP18FoAB3Ho6+e7Gj/ZaI5qTXUsFXxilS
         IQL1AcoTtDHu2oD6SNdr7JzVnhypSG2rSeMQmSEZvBIwKpgdDVNKyNeeD194hdDv4CEi
         kV+4LLjkfGmzOK2tlm9sWKj8X6uJZK6u/LaqKJZ6wovpCSBZvRyGja1o+/usAnNmOC/y
         x+VpNbPzHV0zWpyoS/JPJQrPx3WA+CXmJXVvt8KFdh2q69eDkOmAuPMOJOI8KkutjQTY
         xs95FkmbnSWnnmGLJkrbOys6kaBhSc5N5ZoSB4PhVV5wKtx9NZ5GkQCJGKMUYaS3KZ7Q
         CpDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8rCBoTCoXcTdKmA61O58TahpNnZM2XZT8hOVhfdoHhoR6PEoDaXgLk9Q9JJodGY7GSpyh2NO+UtKn@vger.kernel.org, AJvYcCVk/wLI5EXkRCdo+gKKswr3Mf/y95cw1RQP0xTEyC+M2FBxSkzINroMHVqHlQmrUj/+k4WlrqbOIlkPN+e/@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxf5zGdUEW3NvJ2ETHgxI42fLD5CccnB0CZDqGsQpielJfAedY
	EAXMHAvYyJqsF1ZFv7eVvLev16mCOpQ511FTD0NjH9hotRapwXIvXUpcjA3DQhkrOYlVleJJW73
	K0gHPt5Y72wkLncLmwefAzTlHjDU=
X-Google-Smtp-Source: AGHT+IG6OoqjYvygWloG0kVfFXJKeW8FDDKrKGnU2viTb/U/Gf3PEJF9JpettkHJZDIBDptC5aoY7BAm7iUEfQ8L+fk=
X-Received: by 2002:a05:6402:2108:b0:5c4:2366:2bd2 with SMTP id
 4fb4d7f45d1cf-5c423662c51mr2844730a12.21.1726266814353; Fri, 13 Sep 2024
 15:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-1-pali@kernel.org> <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali> <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
In-Reply-To: <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Sep 2024 17:33:22 -0500
Message-ID: <CAH2r5mskDvz2-iAYY8mknuBVtPq_C5sQyggYEwDivtGPc83B1g@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special files
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One other thing which worried me a bit is that I confirmed that an
empty file with the system attribute set was matched as a FIFO file
type (when you mount with "sfu") - this seems risky.

On Fri, Sep 13, 2024 at 5:14=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> How did you find the format of the FIFO and SOCK file types?  I
> couldn't find any references to those so added two new types to allow
> current Linux to be able to create these (especially since they are
> opaque to the server and thus low risk).
>
> > +     case S_IFSOCK:
> > -             strscpy(pdev.type, "LnxSOCK");
> > +             /* SFU socket is system file with one zero byte */
> > +             pdev_len =3D 1;
> > +             pdev.type[0] =3D '\0';
> >               break;
> >       case S_IFIFO:
> > -             strscpy(pdev.type, "LnxFIFO");
> > +             /* SFU fifo is system file which is empty */
> > +             pdev_len =3D 0;
>
> My worry about the suggested change above is that it is possible that
> we could accidentally match to an empty file. We intentionally added
> the two new dev.type fields for these to avoid collisions with other
> things (and since they are Linux specific).  It seems risky to have an
> empty file with the system attribute marked as a FIFO, and similarly a
> file with one byte null as Socket.   Since this is for only the Linux
> client to recognize, I wanted to do something safe for those file
> types less likely to be confusing (ie strings for Socket and FIFO that
> were similar in length and format to the other special files seemed
> intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
> file to reduce confusion ie the tags for those two start with "Lnx" -
> ie "something used for Linux client" not related to the original
> Interix (those begin with "Intx").
>
> Note that in the long run we hope to use reparse points by default in
> more servers to store special files like this but there are a few
> cases for unusual workloads that need special file support that would
> have to use sfu still.  The newer reparse tags that Windows uses "WSL"
> have the advantage that they require fewer roundtrips to query (since
> the file type is in the reparse tag).
>
> Also noticed an interesting problem when mounted with "sfu" -
> "smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
> that expected for a FIFO?
>
> On Fri, Sep 13, 2024 at 3:07=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org>=
 wrote:
> >
> > On Thursday 12 September 2024 14:05:47 Pali Roh=C3=A1r wrote:
> > > SFU-style fifo is empty file with system attribute set. This format i=
s used
> > > by old Microsoft POSIX subsystem and later also by OpenNT/Interix sub=
system
> > > (which replaced Microsoft POSIX subsystem and is part of Microsoft SF=
U).
> > >
> > > SFU-style socket is file which has system attribute set and file cont=
ent is
> > > one zero byte. This format was introduced in Interix 3.0 subsystem, a=
s part
> > > of the Microsoft SFU 3.0 and is used also by all later versions. Prev=
ious
> > > versions had no UNIX domain socket support.
> > >
> > > Currently when sfu mount option is specified then CIFS creates fifo a=
nd
> > > socket special files with some strange LnxSOCK or LnxFIFO content whi=
ch is
> > > not compatible with Microsoft SFU and neither recognized by other SMB
> > > implementations which have some SFU support, including older Linux ci=
fs
> > > implementations.
> > >
> > > So when sfu mount option is specified, create all fifo and socket spe=
cial
> > > files compatible with SFU format to achieve SFU interop, as it is exp=
ected
> > > by sfu mount option.
> > >
> > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> >
> > Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu"=
 mount option")
> > Fixes: 518549c120e6 ("cifs: fix creating sockets when using sfu mount o=
ptions")
> >
> > I located commits which introduced those strange LnxSOCK or LnxFIFO
> > types which are not compatible with SFU. I would suggest to add those
> > two Fixes: tags into commit message for reference.
> >
> > > ---
> > >  fs/smb/client/cifssmb.c |  8 ++++----
> > >  fs/smb/client/smb1ops.c |  2 +-
> > >  fs/smb/client/smb2ops.c | 29 +++++++++++++++++++----------
> > >  3 files changed, 24 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > > index cfae2e918209..0ffc45aa5e2c 100644
> > > --- a/fs/smb/client/cifssmb.c
> > > +++ b/fs/smb/client/cifssmb.c
> > > @@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct ci=
fs_tcon *tcon,
> > >       pSMB->OpenFlags |=3D cpu_to_le16(REQ_MORE_INFO);
> > >       pSMB->Mode =3D cpu_to_le16(access_flags_to_smbopen_mode(access_=
flags));
> > >       pSMB->Mode |=3D cpu_to_le16(0x40); /* deny none */
> > > -     /* set file as system file if special file such
> > > -        as fifo and server expecting SFU style and
> > > +     /* set file as system file if special file such as fifo,
> > > +      * socket, char or block and server expecting SFU style and
> > >          no Unix extensions */
> > >
> > >       if (create_options & CREATE_OPTION_SPECIAL)
> > > @@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_o=
pen_parms *oparms, int *oplock,
> > >       req->AllocationSize =3D 0;
> > >
> > >       /*
> > > -      * Set file as system file if special file such as fifo and ser=
ver
> > > -      * expecting SFU style and no Unix extensions.
> > > +      * Set file as system file if special file such as fifo, socket=
, char
> > > +      * or block and server expecting SFU style and no Unix extensio=
ns.
> > >        */
> > >       if (create_options & CREATE_OPTION_SPECIAL)
> > >               req->FileAttributes =3D cpu_to_le32(ATTR_SYSTEM);
> > > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > > index e1f2feb56f45..e03c91a49650 100644
> > > --- a/fs/smb/client/smb1ops.c
> > > +++ b/fs/smb/client/smb1ops.c
> > > @@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *=
inode,
> > >       /*
> > >        * Check if mounted with mount parm 'sfu' mount parm.
> > >        * SFU emulation should work with all servers, but only
> > > -      * supports block and char device (no socket & fifo),
> > > +      * supports block and char device, socket & fifo,
> > >        * and was used by default in earlier versions of Windows
> > >        */
> > >       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index 9c2d065d3cc4..9e90672caf60 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -5066,26 +5066,32 @@ static int __cifs_sfu_make_node(unsigned int =
xid, struct inode *inode,
> > >       struct cifs_fid fid;
> > >       unsigned int bytes_written;
> > >       struct win_dev pdev =3D {};
> > > +     size_t pdev_len =3D 0;
> > >       struct kvec iov[2];
> > >       __u32 oplock =3D server->oplocks ? REQ_OPLOCK : 0;
> > >       int rc;
> > >
> > >       switch (mode & S_IFMT) {
> > >       case S_IFCHR:
> > > +             pdev_len =3D sizeof(pdev);
> > >               memcpy(pdev.type, "IntxCHR\0", 8);
> > >               pdev.major =3D cpu_to_le64(MAJOR(dev));
> > >               pdev.minor =3D cpu_to_le64(MINOR(dev));
> > >               break;
> > >       case S_IFBLK:
> > > +             pdev_len =3D sizeof(pdev);
> > >               memcpy(pdev.type, "IntxBLK\0", 8);
> > >               pdev.major =3D cpu_to_le64(MAJOR(dev));
> > >               pdev.minor =3D cpu_to_le64(MINOR(dev));
> > >               break;
> > >       case S_IFSOCK:
> > > -             strscpy(pdev.type, "LnxSOCK");
> > > +             /* SFU socket is system file with one zero byte */
> > > +             pdev_len =3D 1;
> > > +             pdev.type[0] =3D '\0';
> > >               break;
> > >       case S_IFIFO:
> > > -             strscpy(pdev.type, "LnxFIFO");
> > > +             /* SFU fifo is system file which is empty */
> > > +             pdev_len =3D 0;
> > >               break;
> > >       default:
> > >               return -EPERM;
> > > @@ -5100,14 +5106,17 @@ static int __cifs_sfu_make_node(unsigned int =
xid, struct inode *inode,
> > >       if (rc)
> > >               return rc;
> > >
> > > -     io_parms.pid =3D current->tgid;
> > > -     io_parms.tcon =3D tcon;
> > > -     io_parms.length =3D sizeof(pdev);
> > > -     iov[1].iov_base =3D &pdev;
> > > -     iov[1].iov_len =3D sizeof(pdev);
> > > +     if (pdev_len > 0) {
> > > +             io_parms.pid =3D current->tgid;
> > > +             io_parms.tcon =3D tcon;
> > > +             io_parms.length =3D pdev_len;
> > > +             iov[1].iov_base =3D &pdev;
> > > +             iov[1].iov_len =3D pdev_len;
> > > +
> > > +             rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> > > +                                          &bytes_written, iov, 1);
> > > +     }
> > >
> > > -     rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> > > -                                  &bytes_written, iov, 1);
> > >       server->ops->close(xid, tcon, &fid);
> > >       return rc;
> > >  }
> > > @@ -5149,7 +5158,7 @@ static int smb2_make_node(unsigned int xid, str=
uct inode *inode,
> > >       /*
> > >        * Check if mounted with mount parm 'sfu' mount parm.
> > >        * SFU emulation should work with all servers, but only
> > > -      * supports block and char device (no socket & fifo),
> > > +      * supports block and char device, socket & fifo,
> > >        * and was used by default in earlier versions of Windows
> > >        */
> > >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> > > --
> > > 2.20.1
> > >
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
