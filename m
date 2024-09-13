Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7551465BD;
	Fri, 13 Sep 2024 22:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726265678; cv=none; b=IW5l0d55GRNN3BM0+2bJKSS9+taH2kYbLtezn/WwAqE28gp8CaXlrHPhJdsK2UHSKb4j0BpKrG/H4zffLIZfMWpZUGjKzspTy6Kj2Ti+HbEUctz57GhkYH6dwpr50hQzr3pv1x3y/jCgVrCmSgO7KMDmoVTPee99UUiW3lHQivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726265678; c=relaxed/simple;
	bh=xkinW/eCmyJWqJ4WR3CmqiNkQ7IK2lH3jx3/p8DxE6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JO1/2/MA1HApt59O/K22iXhbxwvzu2pFGGGLWPsJRAwY9LMmyRLzHqJqVldwXQoKVbkQ6yXYav+ACuFZ533b7u5JCh+TKvZ9T+ACOiDeYfmx3D0VkHGjyiCEMQ5d8Cv2M+XLn1JfxFZ9YbCQLn/eWGiAQvka5pZD4s44kHXy0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1qwiS1o; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1qwiS1o"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c42bcf35fbso48658a12.1;
        Fri, 13 Sep 2024 15:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726265675; x=1726870475; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRL9LDz2rsK0FN1KAz224XQhSxH7vVi+ad7F6G+Anp8=;
        b=N1qwiS1o2twPntyNaNuvbEXduwlse/glumqxp+ZqURMQU4U9EOiVw6nLNCuP3UkyF2
         L9GZDBNmAfD5dOE3FdQ6pn9rWNrZ/r+OsXSA0rItqU3ZWPAf+WtQtPS6NqcnH8vlWt+h
         6ssnJ5ZdDlUfhV52k47bHHMrF95Jp0gvL3MarAMCGMU4TFn1sWluszxKvyh/FZo8KQvu
         OKuMooRxjgqTc7aFifo/eqszLEnqo4AReXy3XPShj0FpkDR/xa6kSPHtre3/rSFde2Pa
         Pgb+wgUBXGfntVgrQnmyHat7jAFZHO56MZLfy6lTGElPdMpJHHlIcJFxhM5sJYZjtWST
         6uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726265675; x=1726870475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CRL9LDz2rsK0FN1KAz224XQhSxH7vVi+ad7F6G+Anp8=;
        b=KprQ6sLpQpt7LeGcDNhqzK0g1O/CXH9qKLTKXF2VVZkzJLC+bMrsJSO7StFecLoeEC
         m4zVLvC7GVzNpwOKuTWpMFKdPk7dxdFYoSflPkea17vbVlgDgh2fKAa65j9awQjJ1hJF
         Y0rZikpmGO1FzsxpCRULa3eO8VG+xiVW5jYIaeeFch5KH6GN1GTkTerfe0/6Wl+aQRFg
         TGZdGfxhzAU9wQ/FE0+quoBEP6HIPBfbs1STy3//9DLv3EZ5QZ0rtl1TTE7R/682xYnh
         Lo8gLE1odv+ihO4edX5c/ASeKEj58lt2FS5aqvYobcEWwD6En+zrJUweANeNqDe9ZsZh
         +XFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjxVBDmbhNpAbsQHyzHbJAe8+ReuCGkur2hPbiLVnEcBC17JVXfUnXyVltotCLPDdXImeGb9Ae4RTeLADq@vger.kernel.org, AJvYcCWYGebXMnZ/fqMbC9JkrLPj0EknpYRyAIhmdxIO5bWsN+dLxl4vsXNn3NPiYyq4BqNqCT6NUx/uzFhx@vger.kernel.org
X-Gm-Message-State: AOJu0YwS14R3bZSRoBL0wZ6pWWOWNiJuORpRTKiX9g8HZcX8154hlTru
	Zbl/N998/4AcdkUkEY/gVg8Slqpzv37FwxK4orC67dJ2HxAywcZ5SR6d+cOG7ITuDjiHvNQ5Jtq
	4qXCAGi4LBMfAmaNkzNE/BddGCazYUGD4pVU=
X-Google-Smtp-Source: AGHT+IEkhkw8cLLjFutnTVvHHBmunYY+GWZdhnv2SFLwuCPdXWIMMKeIBOcbToIb2N4pqBOR/RkLKhVs5b2D32Bd8cI=
X-Received: by 2002:a05:6402:234f:b0:5c4:95d:da49 with SMTP id
 4fb4d7f45d1cf-5c41e195187mr3679917a12.15.1726265674128; Fri, 13 Sep 2024
 15:14:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-1-pali@kernel.org> <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
In-Reply-To: <20240913200721.7egunkwp76qo5yy7@pali>
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Sep 2024 17:14:22 -0500
Message-ID: <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special files
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

How did you find the format of the FIFO and SOCK file types?  I
couldn't find any references to those so added two new types to allow
current Linux to be able to create these (especially since they are
opaque to the server and thus low risk).

> +     case S_IFSOCK:
> -             strscpy(pdev.type, "LnxSOCK");
> +             /* SFU socket is system file with one zero byte */
> +             pdev_len =3D 1;
> +             pdev.type[0] =3D '\0';
>               break;
>       case S_IFIFO:
> -             strscpy(pdev.type, "LnxFIFO");
> +             /* SFU fifo is system file which is empty */
> +             pdev_len =3D 0;

My worry about the suggested change above is that it is possible that
we could accidentally match to an empty file. We intentionally added
the two new dev.type fields for these to avoid collisions with other
things (and since they are Linux specific).  It seems risky to have an
empty file with the system attribute marked as a FIFO, and similarly a
file with one byte null as Socket.   Since this is for only the Linux
client to recognize, I wanted to do something safe for those file
types less likely to be confusing (ie strings for Socket and FIFO that
were similar in length and format to the other special files seemed
intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
file to reduce confusion ie the tags for those two start with "Lnx" -
ie "something used for Linux client" not related to the original
Interix (those begin with "Intx").

Note that in the long run we hope to use reparse points by default in
more servers to store special files like this but there are a few
cases for unusual workloads that need special file support that would
have to use sfu still.  The newer reparse tags that Windows uses "WSL"
have the advantage that they require fewer roundtrips to query (since
the file type is in the reparse tag).

Also noticed an interesting problem when mounted with "sfu" -
"smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
that expected for a FIFO?

On Fri, Sep 13, 2024 at 3:07=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Thursday 12 September 2024 14:05:47 Pali Roh=C3=A1r wrote:
> > SFU-style fifo is empty file with system attribute set. This format is =
used
> > by old Microsoft POSIX subsystem and later also by OpenNT/Interix subsy=
stem
> > (which replaced Microsoft POSIX subsystem and is part of Microsoft SFU)=
.
> >
> > SFU-style socket is file which has system attribute set and file conten=
t is
> > one zero byte. This format was introduced in Interix 3.0 subsystem, as =
part
> > of the Microsoft SFU 3.0 and is used also by all later versions. Previo=
us
> > versions had no UNIX domain socket support.
> >
> > Currently when sfu mount option is specified then CIFS creates fifo and
> > socket special files with some strange LnxSOCK or LnxFIFO content which=
 is
> > not compatible with Microsoft SFU and neither recognized by other SMB
> > implementations which have some SFU support, including older Linux cifs
> > implementations.
> >
> > So when sfu mount option is specified, create all fifo and socket speci=
al
> > files compatible with SFU format to achieve SFU interop, as it is expec=
ted
> > by sfu mount option.
> >
> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>
> Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" m=
ount option")
> Fixes: 518549c120e6 ("cifs: fix creating sockets when using sfu mount opt=
ions")
>
> I located commits which introduced those strange LnxSOCK or LnxFIFO
> types which are not compatible with SFU. I would suggest to add those
> two Fixes: tags into commit message for reference.
>
> > ---
> >  fs/smb/client/cifssmb.c |  8 ++++----
> >  fs/smb/client/smb1ops.c |  2 +-
> >  fs/smb/client/smb2ops.c | 29 +++++++++++++++++++----------
> >  3 files changed, 24 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > index cfae2e918209..0ffc45aa5e2c 100644
> > --- a/fs/smb/client/cifssmb.c
> > +++ b/fs/smb/client/cifssmb.c
> > @@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs=
_tcon *tcon,
> >       pSMB->OpenFlags |=3D cpu_to_le16(REQ_MORE_INFO);
> >       pSMB->Mode =3D cpu_to_le16(access_flags_to_smbopen_mode(access_fl=
ags));
> >       pSMB->Mode |=3D cpu_to_le16(0x40); /* deny none */
> > -     /* set file as system file if special file such
> > -        as fifo and server expecting SFU style and
> > +     /* set file as system file if special file such as fifo,
> > +      * socket, char or block and server expecting SFU style and
> >          no Unix extensions */
> >
> >       if (create_options & CREATE_OPTION_SPECIAL)
> > @@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_ope=
n_parms *oparms, int *oplock,
> >       req->AllocationSize =3D 0;
> >
> >       /*
> > -      * Set file as system file if special file such as fifo and serve=
r
> > -      * expecting SFU style and no Unix extensions.
> > +      * Set file as system file if special file such as fifo, socket, =
char
> > +      * or block and server expecting SFU style and no Unix extensions=
.
> >        */
> >       if (create_options & CREATE_OPTION_SPECIAL)
> >               req->FileAttributes =3D cpu_to_le32(ATTR_SYSTEM);
> > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > index e1f2feb56f45..e03c91a49650 100644
> > --- a/fs/smb/client/smb1ops.c
> > +++ b/fs/smb/client/smb1ops.c
> > @@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *in=
ode,
> >       /*
> >        * Check if mounted with mount parm 'sfu' mount parm.
> >        * SFU emulation should work with all servers, but only
> > -      * supports block and char device (no socket & fifo),
> > +      * supports block and char device, socket & fifo,
> >        * and was used by default in earlier versions of Windows
> >        */
> >       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 9c2d065d3cc4..9e90672caf60 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -5066,26 +5066,32 @@ static int __cifs_sfu_make_node(unsigned int xi=
d, struct inode *inode,
> >       struct cifs_fid fid;
> >       unsigned int bytes_written;
> >       struct win_dev pdev =3D {};
> > +     size_t pdev_len =3D 0;
> >       struct kvec iov[2];
> >       __u32 oplock =3D server->oplocks ? REQ_OPLOCK : 0;
> >       int rc;
> >
> >       switch (mode & S_IFMT) {
> >       case S_IFCHR:
> > +             pdev_len =3D sizeof(pdev);
> >               memcpy(pdev.type, "IntxCHR\0", 8);
> >               pdev.major =3D cpu_to_le64(MAJOR(dev));
> >               pdev.minor =3D cpu_to_le64(MINOR(dev));
> >               break;
> >       case S_IFBLK:
> > +             pdev_len =3D sizeof(pdev);
> >               memcpy(pdev.type, "IntxBLK\0", 8);
> >               pdev.major =3D cpu_to_le64(MAJOR(dev));
> >               pdev.minor =3D cpu_to_le64(MINOR(dev));
> >               break;
> >       case S_IFSOCK:
> > -             strscpy(pdev.type, "LnxSOCK");
> > +             /* SFU socket is system file with one zero byte */
> > +             pdev_len =3D 1;
> > +             pdev.type[0] =3D '\0';
> >               break;
> >       case S_IFIFO:
> > -             strscpy(pdev.type, "LnxFIFO");
> > +             /* SFU fifo is system file which is empty */
> > +             pdev_len =3D 0;
> >               break;
> >       default:
> >               return -EPERM;
> > @@ -5100,14 +5106,17 @@ static int __cifs_sfu_make_node(unsigned int xi=
d, struct inode *inode,
> >       if (rc)
> >               return rc;
> >
> > -     io_parms.pid =3D current->tgid;
> > -     io_parms.tcon =3D tcon;
> > -     io_parms.length =3D sizeof(pdev);
> > -     iov[1].iov_base =3D &pdev;
> > -     iov[1].iov_len =3D sizeof(pdev);
> > +     if (pdev_len > 0) {
> > +             io_parms.pid =3D current->tgid;
> > +             io_parms.tcon =3D tcon;
> > +             io_parms.length =3D pdev_len;
> > +             iov[1].iov_base =3D &pdev;
> > +             iov[1].iov_len =3D pdev_len;
> > +
> > +             rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> > +                                          &bytes_written, iov, 1);
> > +     }
> >
> > -     rc =3D server->ops->sync_write(xid, &fid, &io_parms,
> > -                                  &bytes_written, iov, 1);
> >       server->ops->close(xid, tcon, &fid);
> >       return rc;
> >  }
> > @@ -5149,7 +5158,7 @@ static int smb2_make_node(unsigned int xid, struc=
t inode *inode,
> >       /*
> >        * Check if mounted with mount parm 'sfu' mount parm.
> >        * SFU emulation should work with all servers, but only
> > -      * supports block and char device (no socket & fifo),
> > +      * supports block and char device, socket & fifo,
> >        * and was used by default in earlier versions of Windows
> >        */
> >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> > --
> > 2.20.1
> >
>


--=20
Thanks,

Steve
