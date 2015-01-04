From: Giel van Schijndel <me@mortis.eu>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Mon, 5 Jan 2015 00:05:28 +0100
Message-ID: <20150104230527.GJ4806@salidar.dom.custoft.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve French <sfrench@samba.org>,
	Rahul Bedarkar <rahulbedarkar89@gmail.com>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"open list:CERTIFIED WIRELES..." <linux-usb@vger.kernel.org>,
	"open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET F..."
	<samba-technical@lists.samba.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420394744-20268-1-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:05:40 +0100, Giel van Schijndel wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear locally allocated/owned buffers. memset(0) may be optimized away.
>=20
> All of the affected buffers contain sensitive data, key material or
> derivatives of one of those two.
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Question: what do you call your programming methodology?
 Answer: Faith based development. You code and then pray that it works."
  -- John Spelner

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpxzcACgkQZBYm/87l50JXdwCghdjEOFoNthiW/f473N2RIPXH
tfAAoIiPfYASW9F/CSGBPBSqKE4tGCwd
=iRgY
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--
