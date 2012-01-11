From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Wed, 11 Jan 2012 15:41:32 +0300
Message-ID: <20120111124132.GO3644@mwanda>
References: <20120111074627.GA4519@elgon.mountain>
 <20120111072029.672dfdca@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vy1A5eXR7jld12ZH"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120111072029.672dfdca-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--Vy1A5eXR7jld12ZH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2012 at 07:20:29AM -0500, Jeff Layton wrote:
> On Wed, 11 Jan 2012 10:46:27 +0300
> Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > On 32 bit systems num_aces * sizeof(struct cifs_ace *) could overflow
> > leading to a smaller ppace buffer than we expected.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >=20
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 72ddf23..c1b2544 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -909,6 +909,8 @@ static void parse_dacl(struct cifs_acl *pdacl, char=
 *end_of_acl,
> >  		umode_t group_mask =3D S_IRWXG;
> >  		umode_t other_mask =3D S_IRWXU | S_IRWXG | S_IRWXO;
> > =20
> > +		if (num_aces > ULONG_MAX / sizeof(struct cifs_ace *))
> > +			return;
> >  		ppace =3D kmalloc(num_aces * sizeof(struct cifs_ace *),
> >  				GFP_KERNEL);
> >  		if (!ppace) {
>=20
>=20
> Looks plausible. This function could use some work. I'm not sure why
> num_aces is signed here too...
>=20
> The first arg to kmalloc is a size_t. Does that boil down to an unsigned
> long on all arches?

People have been submitting a lot of patches recently based on that
assumption.  It matches the check in kcalloc() as well.  According
to include/asm-generic/posix_types.h:

/*
 * Most 32 bit architectures use "unsigned int" size_t,
 * and all 64 bit architectures use "unsigned long" size_t.
 */

It would be better to user a lower limit, but I don't know the code
well enough to say if which one is good that won't break things...
A high number can trigger a kmalloc() failure and that puts annoying
spam in the dmesg.

regards,
dan carpenter

--Vy1A5eXR7jld12ZH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDYN7AAoJEOnZkXI/YHqR5fkP/2QObEnGeg0v2YTnPXQskyF7
DCGKs2WwpBvMHmJRJzCUK9knZaCTYqwL2a0Q6j/ZGXsH8AhhSMXN0EUGGGblfkRF
BLD6a+7OiGh6E//UDPbTnei+WQNYoszbJdohvbseI+lNDLLXMTeavRJdqtXonBNf
PAO20xfbIs6C3hlhDWBGR6pAb/J3Id1NlsAPTVasVhG+VbpIjmX2mb1VTvtCO6/Z
A2rUVd2GLpmrrdPaBZ+xBUVCt7thoBi6W9IMfwZeYJeULU1VlL759YkWSHL0hd0u
AkGAE8rmMx3VlHLHFoqKc9K+mgBUqrkupJZtYfwq0ZaaBdqeon6ul+v+/qwGrj7Y
rarbE1TqFj9DNse6Y3Vd+v3QVZBnOQ1gmnM3+VGPvDQDr9mvpPmi+Msi8YoFJ77m
9LxKWwt9vcVGHFJFBD3POtL9VeKymiqoJqp7033VA3zq3+2ja06iPtkGyNlSPaMB
zHsUDsCwenjwd8TS645VLLk1EY8nViq3NDC9awUW0FATnqe3FkN4a5gKmKNXN42K
zi/+5ZEG4jGT8fvyOp1/Ufz9qmfB2xP+yzvZNPSo8eJCtnj39HddNxu2/Eih2vYC
vKW2cdEl0R21wumPmJLvmxtMY0B/rp0iCQ67LQlROXeZgqLBvN3o3DdGnbTdbyI6
gBX9nMucW59YW83+TyFl
=Enrf
-----END PGP SIGNATURE-----

--Vy1A5eXR7jld12ZH--
