From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a
 gid
Date: Sun, 12 Dec 2010 14:48:04 +1100
Message-ID: <1292125684.7313.4.camel@ruth>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	 <20101211111716.1e21be41@corrin.poochiereds.net>
	 <AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	 <20101211193003.4a11fc7f@corrin.poochiereds.net>
	 <AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
	 <20101211221159.36e6c814@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yhKBYH/wQiBWcN0D6zYl"
Cc: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101211221159.36e6c814-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-yhKBYH/wQiBWcN0D6zYl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-12-11 at 22:11 -0500, Jeff Layton wrote:
> On Sat, 11 Dec 2010 19:57:11 -0500
> Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On Sat, Dec 11, 2010 at 7:30 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > >>
> > >> Will look into this.  One thing that concerns me is if a cached etnr=
y
> > >> for a SID with its name and an id (either an uid or a gid), if that =
SID
> > >> now represents a different object and has differernt name, would
> > >> not cached info be incorrect?  Not sure if this can ever happen
> > >> or how would it happen and if it does, what would be a trigger
> > >> for a cache revalidation and purges!
> > >>
> > >
> > > Sure, mappings can change. But, you still have the same problem with
> > > what you're proposing in these patches. The userspace program isn't
> > > setting a timeout on the key. Once a mapping is put in the keyring,
> > > it's there until it's revoked. You probably want to set a max TTL for
> > > the entries in the cache regardless of what scheme is used.
> >=20
> > I was under the impression that SIDs are never reused. Perhaps I am mis=
taken.
> >=20
>=20
> That may be, but the mapping of a SID is dependent upon settings in
> config files that could change. It seems reasonable to me to only cache
> these mappings for a period of time in the event that they do. That
> period of time could default to being rather long and be tunable.

I think that instead some explicit signal should be made to indicate
that a mapping has changed, so you don't have to worry about cache
times.  It should change *very* rarely and only on specific
administrator intervention.  We do a lot of things to avoid this
happening in the normal course of events.=20

Andrew Bartlett

--=20
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
Samba Developer, Cisco Inc.

--=-yhKBYH/wQiBWcN0D6zYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBNBEX0z4A8Wyi0NrsRAvMxAKCbfRMdbnBDNwBdgvAEpxjhI9XRmwCgoSm6
WXAsHIgHCEKZJ38pbuVwcX0=
=pfJn
-----END PGP SIGNATURE-----

--=-yhKBYH/wQiBWcN0D6zYl--
