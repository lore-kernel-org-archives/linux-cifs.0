From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a
 gid
Date: Wed, 15 Dec 2010 09:42:23 +1100
Message-ID: <1292366543.22252.313.camel@obed>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	 <20101211111716.1e21be41@corrin.poochiereds.net>
	 <AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	 <20101211193003.4a11fc7f@corrin.poochiereds.net>
	 <AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
	 <20101211221159.36e6c814@corrin.poochiereds.net>
	 <1292125684.7313.4.camel@ruth>
	 <20101212063929.77a619e4@tlielax.poochiereds.net>
	 <1292210529.15637.10.camel@obed>
	 <20101213061622.7e78e475@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H5gAeXM+vaVXFw0btP2q"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101213061622.7e78e475-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-H5gAeXM+vaVXFw0btP2q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-12-13 at 06:16 -0500, Jeff Layton wrote:

>=20
> The other option is just to have a manual knob that flushes the cache,
> and add something like this to the cifs.upcall manpage: "If you change
> your idmapping configuration, then you'll probably also want to flush
> the idmap cache." Maybe it's a rare enough thing that we shouldn't
> sweat trying to make it too automatic.

I think that's a reasonable approach.=20

--=20
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
Samba Developer, Cisco Inc.

--=-H5gAeXM+vaVXFw0btP2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBNB/LPz4A8Wyi0NrsRAiZpAJ4+p7gs400akXoCKGFTNLuIZL63MQCfZA6H
tmSILB38njGgPsjmYXlGCcQ=
=Pa7L
-----END PGP SIGNATURE-----

--=-H5gAeXM+vaVXFw0btP2q--
