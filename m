From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Linux CIFS NTLMSSP mount failing against win2k8
Date: Wed, 30 Jun 2010 07:55:30 -0400
Message-ID: <20100630075530.4d5263c1@corrin.poochiereds.net>
References: <20100410181730.7fa0af32@tlielax.poochiereds.net>
	<j2n4a4634331004102109k49cfb3f0gdaafcd712a972c01@mail.gmail.com>
	<1277853910.2423.5.camel@ruth>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Zc.3B4Dg/ulPfGfWxeT9oT"; protocol="application/pgp-signature"
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277853910.2423.5.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/=Zc.3B4Dg/ulPfGfWxeT9oT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jun 2010 09:25:10 +1000
Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Sat, 2010-04-10 at 23:09 -0500, Shirish Pargaonkar wrote:
> > On Sat, Apr 10, 2010 at 5:17 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > > I've been playing with NTLMSSP today in CIFS, and have run across a
> > > problem. The Session Setup using Raw NTLMSSP succeeds, but then after=
ward
> > > the tree connect fails with STATUS_ACCESS_DENIED. The odd thing is th=
at
> > > if authenticate as the same user using krb5, then it works fine.
> > > smbclient does SPNEGO encapsulated NTLMSSP and the tree connect it do=
es
> > > works fine as well.
> > >
> > > Attached is a capture that shows two "mount attempts". The first one
> > > fails (that the Linux CIFS one). The second succeeds -- that's the
> > > Linux CIFS one.
> > >
> > > The code I'm using is slightly modified so that the tree connect is
> > > closer to identical to what smbclient does. That doesn't get around t=
he
> > > problem though. I assume that there must be something wrong with the
> > > session setup, but since it succeeds it seems like it ought to work...
> > >
> > > Does anyone have any clue as to what the problem is? Or does anyone
> > > know how to make win2k8 tell me why it's refusing the tree connect? T=
he
> > > event viewer seems to be pretty useless for this, but maybe I'm just
> > > not looking in the right place?
> > >
> > > --
> > > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > >
> >=20
> > Jeff,
> >=20
> > You can see if this code change,
> >   cifs_MD5_update(&context, (char *)&key->data, 16);
> > insetead of
> >  cifs_MD5_update(&context, (char *)&key->data, key->len);
> > in function cifs_calculate_signature() works.
>=20
> If I had some context, I would be able to advise if this is correct.  If
> this is the application of the 'session key' to the SMB singing (the MD5
> with the actual packet), then this is important, but only for Kerberos,
> not NTLMSSP, which for all versions returns a 16 byte key.=20
>=20

(dropping old linux-cifs-client list and adding new one to cc list)

Unfortunately, I haven't had time to spend on this in a while so I
haven't really given it the time it deserves.  My gut feeling is that
there are enough questionable portions of this code in CIFS that it
really needs an overhaul from "first principles" -- starting by making
the encryption algorithms use the standard kernel crypto libs and a
review of what NTLMSSP flags are being set in the negotation. Some of
that may just be my lack of familiarity with the code, but a lot of the
unicode conversion in smbencrypt.c looks questionable.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--Sig_/=Zc.3B4Dg/ulPfGfWxeT9oT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkwrMLcACgkQyP0gxQMdzICQ/wCdEU2qtTJI4vfH4gck1gfHqTAt
9gwAn3lkOKwSzdrvZZECsw58SGmxavI7
=MMwv
-----END PGP SIGNATURE-----

--Sig_/=Zc.3B4Dg/ulPfGfWxeT9oT--
