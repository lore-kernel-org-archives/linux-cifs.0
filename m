From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: add cifs_async_writev
Date: Fri, 15 Apr 2011 06:45:49 -0400
Message-ID: <20110415064549.14868488@tlielax.poochiereds.net>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
	<1301747039-31411-5-git-send-email-jlayton@redhat.com>
	<BANLkTimHi_w55+bqFstXZZdjaMzw1mw_yA@mail.gmail.com>
	<20110412071120.75e45b38@corrin.poochiereds.net>
	<BANLkTi=G1U591vh4cc6XxT=FRe0puir2Ew@mail.gmail.com>
	<BANLkTimhDSgsq=Obq-TRSpxQrJZpT6+5iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimhDSgsq=Obq-TRSpxQrJZpT6+5iA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 15 Apr 2011 11:52:49 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


> >>> > +static void
> >>> > +cifs_writev_complete(struct work_struct *work)
> >>> > +{
> >>> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata *wdata =3D contain=
er_of(work,
> >>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_writedata, work);
> >>> > + =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon =3D tlink_tcon(wd=
ata->cfile->tlink);
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^ this variable is unused.
> >>>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Not exactly.
> >>
> >>> > + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D wdata->cfile->de=
ntry->d_inode;
> >>> > + =C2=A0 =C2=A0 =C2=A0 struct page *page;
> >>> > + =C2=A0 =C2=A0 =C2=A0 int i =3D 0;
> >>> > +
> >>> > + =C2=A0 =C2=A0 =C2=A0 if (wdata->result =3D=3D 0) {
> >>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_update_=
eof(CIFS_I(inode), wdata->offset, wdata->bytes);
> >>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_stats_b=
ytes_written(tcon, wdata->bytes);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ^^^^^
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
The tcon is used here
> >
> > Strange, the compiler (gcc-4.4.4-1ubuntu2) reports it:
> > /home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: In function
> > =E2=80=98cifs_writev_complete=E2=80=99:
> > /home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c:1633: warning: unused
> > variable =E2=80=98tcon=E2=80=99
> >
> > but you are right - it is used.
>=20
> figured it out: I compiled module without CONFIG_CIFS_STATS.
>=20

Ahh yeah, that function gets compiled out to nothing when
CONFIG_CIFS_STATS isn't set. I guess I can get rid of the separate tcon
stack var and just inline the tlink_tcon call there. I'll fix it in my
next set.

Thanks.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
