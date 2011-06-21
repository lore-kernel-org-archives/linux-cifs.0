From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: advertise the right receive buffer size to the
 server
Date: Tue, 21 Jun 2011 11:31:55 -0400
Message-ID: <20110621113155.199b8f37@tlielax.poochiereds.net>
References: <1308658004-14725-1-git-send-email-jlayton@redhat.com>
	<BANLkTim+LC=6GD2+0k1Fem9b1KLaNzof=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim+LC=6GD2+0k1Fem9b1KLaNzof=A@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Jun 2011 09:03:05 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> makes sense although I think some servers ignore this.
>=20

I'm sure some do. One question though...

> On Tue, Jun 21, 2011 at 7:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Currently, we mirror the same size back to the server that it sends=
 us.
> > That makes little sense. Instead we should be sending the server th=
e
> > maximum buffer size that we can handle.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/sess.c | =C2=A0 =C2=A03 ++-
> > =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index 3892ab8..855c777 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -124,7 +124,8 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *s=
es, SESSION_SETUP_ANDX *pSMB)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* =C2=A0 =C2=A0 =C2=A0that we use in ne=
xt few lines =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Note that header is initialized to ze=
ro in header_assemble */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req.AndXCommand =3D 0xFF;
> > - =C2=A0 =C2=A0 =C2=A0 pSMB->req.MaxBufferSize =3D cpu_to_le16(ses-=
>server->maxBuf);
> > + =C2=A0 =C2=A0 =C2=A0 pSMB->req.MaxBufferSize =3D cpu_to_le16(min_=
t(u32, CIFSMaxBufSize,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 USHRT_MAX));

Should we be using CIFSMaxBufSize - 4 here (to account for the RFC1001 =
header) ?

> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req.MaxMpxCount =3D cpu_to_le16(se=
s->server->maxReq);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMB->req.VcNumber =3D get_next_vcnum(se=
s);
> >
> > --
> > 1.7.5.4
> >
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
