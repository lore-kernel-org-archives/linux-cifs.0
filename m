From: Giel van Schijndel <me@mortis.eu>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Date: Sun, 4 Jan 2015 23:49:09 +0100
Message-ID: <20150104224909.GB4806@salidar.dom.custoft.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <20150104213538.GA19906@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
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
	<samba-technical@lists.samba.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150104213538.GA19906@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2015 at 08:35:38 +1100, Herbert Xu wrote:
> On Sun, Jan 04, 2015 at 07:05:40PM +0100, Giel van Schijndel wrote:
>> When leaving a function use memzero_explicit instead of memset(0) to
>> clear locally allocated/owned buffers. memset(0) may be optimized away.
>>=20
>> All of the affected buffers contain sensitive data, key material or
>> derivatives of one of those two.
>=20
> Nack.

Do you mean that the sample below doesn't contain sensitive data?
Or is there another buffer(s) in my patch that you believe doesn't
contain that?

(I contain a hash derived from secret material to be a "derivative of one of
those two", leaking of which could lead to a confirmation-attack).

>> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha25=
6_ssse3_glue.c
>> index 8fad72f..b616e63 100644
>> --- a/arch/x86/crypto/sha256_ssse3_glue.c
>> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
>> @@ -164,7 +164,7 @@ static int sha256_ssse3_final(struct shash_desc *des=
c, u8 *out)
>>  		dst[i] =3D cpu_to_be32(sctx->state[i]);
>> =20
>>  	/* Wipe context */
>> -	memset(sctx, 0, sizeof(*sctx));
>> +	memzero_explicit(sctx, sizeof(*sctx));
>=20
> sctx does not point to stack memory so this is bogus.
>=20
> Only stack memory cleared just before it goes out of scope needs
> memzero_explicit.

Is that because the compiler can't safely optimize memset(0) away for a
variable with greater-than-local scope?

Because I think using memzero_explicit() as an indicator that said
buffer contains data that really *needs* to be destroyed is enough of a
reason already. I believe any overhead is negligable because there's
only a single extra call involved and that's cheap for the extra clarity
it buys (i.e. "this piece of memory *really* needs to be destroyed
beyond this statement"). (Though this approach is only valid for memory
that can contain security-sensitive data IMO.)

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Always code as if the guy who ends up maintaining your code will be a
 violent psychopath who knows where you live."
  -- Rick Osborne

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpw2MACgkQZBYm/87l50I3dACfXrmRUd+wT79FclBrimamPV6t
zYIAoMLxf3hCCeD4zJU6SrSIEyb2p+/b
=nL3b
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
