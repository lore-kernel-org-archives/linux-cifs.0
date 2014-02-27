From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: connect: added option krb5mi which may allow
 package signing
Date: Thu, 27 Feb 2014 07:03:24 -0800
Message-ID: <20140227070324.0861fb3a@corrin.poochiereds.net>
References: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
	<20140226122634.1190167e@corrin.poochiereds.net>
	<trinity-0877060f-29cb-4f1f-885e-f0d1c09a0a31-1393492393926@3capp-gmx-bs47>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <trinity-0877060f-29cb-4f1f-885e-f0d1c09a0a31-1393492393926@3capp-gmx-bs47>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Feb 2014 10:13:14 +0100
"Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org> wrote:

>=20
> =C2=A0
> =C2=A0
>=20
> Gesendet:=C2=A0Mittwoch, 26. Februar 2014 um 21:26 Uhr
> Von:=C2=A0"Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> An:=C2=A0"Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org>
> Cc:=C2=A0sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technic=
al-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Betreff:=C2=A0Re: [PATCH] cifs: connect: added option krb5mi which ma=
y allow package signing
> On Wed, 26 Feb 2014 14:46:47 +0100
> "Lorenz Bucher" <Lorenz.Bucher-Mmb7MZpHnFY@public.gmane.org> wrote:
>=20
> > Solves an issue with dfs where servers using package signing are
> > mixed with servers which don't use package signing.
> >
> > Signed-off-by: Lorenz Bucher <lorenz.bucher-Mmb7MZpHnFY@public.gmane.org>
> > ---
> > fs/cifs/connect.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 56c152d..9d06dd8 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdat=
a, const char *devname,
> > if (!value || !*value) {
> > cERROR(1, "no security value specified");
> > continue;
> > + } else if (strnicmp(value, "krb5mi", 6) =3D=3D 0) {
> > + vol->secFlg |=3D CIFSSEC_MAY_KRB5 |
> > + CIFSSEC_MAY_SIGN;
> > } else if (strnicmp(value, "krb5i", 5) =3D=3D 0) {
> > vol->secFlg |=3D CIFSSEC_MAY_KRB5 |
> > CIFSSEC_MUST_SIGN;
>=20
> This looks like it applies to a really old kernel. I think that probl=
em
> was what commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 was intended
> to fix.
>=20
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>=20
> Its the current kernel from LTS Ubuntu 12.04
> 3.2.0-59-generic #90-Ubuntu SMP Tue Jan 7 22:43:51 UTC 2014
>=20

Yep, that kernel is pretty old.

You're probably best off asking the ubuntu kernel maintainers to take
that patch (or asking them to backport 0b7bc84000d). It should
be reasonably safe but they'll have to make that call.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
