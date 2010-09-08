From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] do not assume kerberos as default auth mech
Date: Tue, 7 Sep 2010 20:35:33 -0400
Message-ID: <20100907203533.6a5418e8@corrin.poochiereds.net>
References: <1283830375-25015-1-git-send-email-shirishpargaonkar@gmail.com>
	<AANLkTi=x_m5nz2if4Wbd_gb+6-XaLgS1qBB26ZypE5VW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=x_m5nz2if4Wbd_gb+6-XaLgS1qBB26ZypE5VW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Sep 2010 19:13:31 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This looks independent of the others - does this have dependencies on
> the rest of the series?
>=20
> On Mon, Sep 6, 2010 at 10:32 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > =A0fs/cifs/cifssmb.c | =A0 15 +++++++++------
> > =A01 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index c65c341..1f1b097 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -604,12 +604,15 @@ CIFSSMBNegotiate(unsigned int xid, struct cif=
sSesInfo *ses)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EINVAL;
> >
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_kerbe=
ros || server->sec_mskerberos)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 serve=
r->secType =3D Kerberos;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->sec_=
ntlmssp)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 serve=
r->secType =3D RawNTLMSSP;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 -EOPNOTSUPP;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=
=3D Kerberos) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!=
server->sec_kerberos &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 !server->sec_mskerberos)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -EOPNOTSUPP;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->se=
cType =3D=3D RawNTLMSSP) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!=
server->sec_ntlmssp)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -EOPNOTSUPP;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -EOPNOTSUPP;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0} else
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->capabilities &=3D ~CAP_EXTEN=
DED_SECURITY;
> > --
> > 1.6.0.2
> >
> >
>=20
>=20
>=20

Agreed. The patch to remove CalcNTLMv2_partial_mac_key is also
independent of the others too (at least, once it's fixed to remove the
declaration from the header too).

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
