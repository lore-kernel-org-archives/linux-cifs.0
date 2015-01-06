From: Giel van Schijndel <me@mortis.eu>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Tue, 6 Jan 2015 20:42:26 +0100
Message-ID: <20150106194226.GM4806@salidar.dom.custoft.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <20150104213538.GA19906@gondor.apana.org.au>
 <20150104224909.GB4806@salidar.dom.custoft.eu>
 <20150104233637.GA20757@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c8JyeaiReRNoiMDS"
Cc: linux-kernel@vger.kernel.org,
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
	<samba-technical@lists.samba.org>,
	Daniel Borkmann <dborkman@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150104233637.GA20757@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--c8JyeaiReRNoiMDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2015 at 10:36:37 +1100, Herbert Xu wrote:
> On Sun, Jan 04, 2015 at 11:49:09PM +0100, Giel van Schijndel wrote:
>>
>>> sctx does not point to stack memory so this is bogus.
>>>=20
>>> Only stack memory cleared just before it goes out of scope needs
>>> memzero_explicit.
>>=20
>> Is that because the compiler can't safely optimize memset(0) away for a
>> variable with greater-than-local scope?
>=20
> Exactly.  memzero_explicit is not a marker for sensitive data.
> Its only purpose is to prevent the compiler from optimising away
> zeroing that occurs at the end of a scope.

Question: are you sure the compiler won't optimize the call to memset(0)
way if it's immediately followed by kfree()?

Because one of my changes concerns that situation.

Another actually does change a stack-allocated buffer, I'll split that
one off right away.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"When all you have is a hammer, everything starts to look like a nail."
  -- Abraham Maslow

--c8JyeaiReRNoiMDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSsOqAACgkQZBYm/87l50L6PwCfbRC+ZfKuH+/OgfI/jHZ5AJjv
68MAn38Cc4ILwBfpaOu+tSVaN3OGhHX5
=TXqV
-----END PGP SIGNATURE-----

--c8JyeaiReRNoiMDS--
