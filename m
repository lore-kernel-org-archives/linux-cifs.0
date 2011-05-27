From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: sparse warning in cifsacl.c
Date: Fri, 27 May 2011 16:34:20 -0400
Message-ID: <20110527163420.29ef4b26@tlielax.poochiereds.net>
References: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng@mail.gmail.com>
	<20110527154459.1da9c523@tlielax.poochiereds.net>
	<BANLkTin-iQ7mrPifK-wM1BfM1HO6GsbjcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin-iQ7mrPifK-wM1BfM1HO6GsbjcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 May 2011 15:32:11 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> OK - after you and shirish take a look will send this trivial delta u=
p
> as a 2nd patch (the other is already merged).  I wish compiler were
> smart enough to figure this out ... but Jeff's point makes sense.
>=20

The compiler does figure this out, but cpu_to_le32 is necessarily
arch-specific code, so it can't figure it out on a LE arch.

> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 5f02b4e..8f17006 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone =3D {
>  	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>  /* security id for Authenticated Users system group */
>  static const struct cifs_sid sid_authusers =3D {
> -	1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> +	1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11)} };
>  /* group users */
>  static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0, 5}=
, {} };
>=20

That looks better...

>=20
> On Fri, May 27, 2011 at 2:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Thu, 26 May 2011 23:48:45 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Shirish - below is a patch to fix a sparse warning in the cifsacl
> >> code. =C2=A0The change around line 458 is cosmetic (doesn't look l=
ike the
> >> original code caused a problem but at least this quiets sparse) bu=
t
> >> doesn't sid_authusers have an endian error. =C2=A0 How far back do=
es this
> >> bug go - does it affect much?
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index 076b69c..5f02b4e 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone =3D {
> >> =C2=A0 =C2=A0 =C2=A0 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> >> =C2=A0/* security id for Authenticated Users system group */
> >> =C2=A0static const struct cifs_sid sid_authusers =3D {
> >> - =C2=A0 =C2=A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };
> >> + =C2=A0 =C2=A0 1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^=
^^^^^^^^
> > This will break on big-endian arches. You need to use
> > __constant_cpu_to_le32() instead.
> >
> >> =C2=A0/* group users */
> >> =C2=A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, =
0, 0, 5}, {} };
> >>
> >> @@ -458,7 +458,8 @@ int compare_sids(const struct cifs_sid *ctsid,
> >> const struct cifs_sid *cwsid)
> >> =C2=A0 =C2=A0 =C2=A0 if (num_subauth) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i <=
 num_subauth; ++i) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (ctsid->sub_auth[i] !=3D cwsid->sub_auth[i]) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ctsid->sub_auth[i] > cwsid->sub_aut=
h[i])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (le32_to_cpu(ctsid->sub_auth[i]) >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu=
(cwsid->sub_auth[i]))
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retu=
rn 1;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retu=
rn -1;
> >>
> >>
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
