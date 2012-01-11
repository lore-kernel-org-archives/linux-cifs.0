From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Wed, 11 Jan 2012 08:33:12 -0500
Message-ID: <20120111083312.692be486@tlielax.poochiereds.net>
References: <20120111074627.GA4519@elgon.mountain>
	<20120111072029.672dfdca@tlielax.poochiereds.net>
	<20120111124132.GO3644@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z41yH79_d=n5pHOMyAmXvSC"; protocol="application/pgp-signature"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120111124132.GO3644@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/z41yH79_d=n5pHOMyAmXvSC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jan 2012 15:41:32 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, Jan 11, 2012 at 07:20:29AM -0500, Jeff Layton wrote:
> > On Wed, 11 Jan 2012 10:46:27 +0300
> > Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >=20
> > > On 32 bit systems num_aces * sizeof(struct cifs_ace *) could overflow
> > > leading to a smaller ppace buffer than we expected.
> > >=20
> > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >=20
> > > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > > index 72ddf23..c1b2544 100644
> > > --- a/fs/cifs/cifsacl.c
> > > +++ b/fs/cifs/cifsacl.c
> > > @@ -909,6 +909,8 @@ static void parse_dacl(struct cifs_acl *pdacl, ch=
ar *end_of_acl,
> > >  		umode_t group_mask =3D S_IRWXG;
> > >  		umode_t other_mask =3D S_IRWXU | S_IRWXG | S_IRWXO;
> > > =20
> > > +		if (num_aces > ULONG_MAX / sizeof(struct cifs_ace *))
> > > +			return;
> > >  		ppace =3D kmalloc(num_aces * sizeof(struct cifs_ace *),
> > >  				GFP_KERNEL);
> > >  		if (!ppace) {
> >=20
> >=20
> > Looks plausible. This function could use some work. I'm not sure why
> > num_aces is signed here too...
> >=20
> > The first arg to kmalloc is a size_t. Does that boil down to an unsigned
> > long on all arches?
>=20
> People have been submitting a lot of patches recently based on that
> assumption.  It matches the check in kcalloc() as well.  According
> to include/asm-generic/posix_types.h:
>=20
> /*
>  * Most 32 bit architectures use "unsigned int" size_t,
>  * and all 64 bit architectures use "unsigned long" size_t.
>  */
>=20
> It would be better to user a lower limit, but I don't know the code
> well enough to say if which one is good that won't break things...
> A high number can trigger a kmalloc() failure and that puts annoying
> spam in the dmesg.
>=20
> regards,
> dan carpenter

Ok, thanks. In that case...

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--Sig_/z41yH79_d=n5pHOMyAmXvSC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPDY+YAAoJEAAOaEEZVoIVhI4P/2kLl7iQceBfHAUewrqEHcni
yvYyIAD3+rG67QRg2ma4rWJJcGJfL0SgnHoSKSUXf/aYWCCBs1YaUK0hXn49NGO9
BMHDcBb8gcJ27a/ocakXLTdp4nij9xWFA13r7QwtPQ7ALDX4T//ZqaiCaArmr3DB
B/J0M7Mnf2aZfdOPwbgTlnM7NaDaYS5cPIw6YfH88zY32vtpI4bGKkuB94nOBUAo
h0CZJjUD6y8rd1xI6VKi/e+OsW3OXiMwU44IrK7wBXZdrCLW6NeVEUQIZZnnlHU/
WSWNo2AQc1/75r3O8tHdCe4jjokiJ9p4CyDWEJXVMJpH1g6Nu88Q2oRNx90fE8CE
P9Xe/p8jeKY/KzZgfHT3SIQETdL+k1m7NH+t9e6FWYKlXFyYjSMpdV+oSeenBAHW
aCnBNfRMh/1aOslQp0nsjUKj+b8aNU5Rk+tcBxq985EXWh1c7mQ5KOD0i1tb3Drb
+5v/+U3bVb1D1Qj7kIB7rZB1SXHS2BroHDlV5YBSy5guujXSHseq72i7QLCcJUNH
T0zAHRHzKofh7TTDot1JhWGxLlijzLTHGq9VWEcCxT829kIyWyUs0ujaOaQr6YEz
4pq5OpfzrnReb0cUHM3DaQksSXjxcCfjKft02gfV76y7ma+o2RBDJQACkzaHbq/R
oHBzZQwe3nnnsffh2lED
=V7+C
-----END PGP SIGNATURE-----

--Sig_/z41yH79_d=n5pHOMyAmXvSC--
