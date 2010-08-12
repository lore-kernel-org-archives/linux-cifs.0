From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 12 Aug 2010 17:46:21 +1000
Message-ID: <20100812174621.b1dbc20f.sfr@canb.auug.org.au>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
	<AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Aug_2010_17_46_21_+1000_yjLM=8lGx_xPYx0p"
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
	Bryan Schumaker <bjschuma@netapp.com>,
	David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Thu__12_Aug_2010_17_46_21_+1000_yjLM=8lGx_xPYx0p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 11 Aug 2010 23:04:36 -0500 Steve French <smfrench@gmail.com> wrote:
>
> Are you sure that this is a valid config file?  CONFIG_KEYS should be
> set if CONFIG_DNS_RESOLVER is set?

It is a ppc64_defconfig.  It has:

# CONFIG_KEYS is not set
CONFIG_DNS_RESOLVER=3Dy

CONFIG_NFS_USE_KERNEL_DNS just selects CONFIG_DNS_RESOLVER but there is
no dependency on CONFIG_KEYS (select does not care about the
dependencies of the selected config option).

> key.h looks like it is included in all arch in this path
>=20
> net/dns_resolver/dns_key.c includes
> include/keys/dns_resolver-type.h which includes
> include/linux/key-type.h which includes
> include/linux/key.h
>=20
> the line 258 "key_instantiate_and_link" error could occur if
> "CONFIG_KEYS" is not set in .config

Which t isn't.

> net/dns_resolver/Kconfig config DNS_RESOLVER "depends on NET && KEYS"
> so ... CONFIG_KEYS should be set ....

See above.  You need CONFIG_NFS_USE_KERNEL_DNS to also depend on
CONFIG_KEYS ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Aug_2010_17_46_21_+1000_yjLM=8lGx_xPYx0p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMY6bNAAoJEDMEi1NhKgbsTqsH/0RUu72CT13xLIua6gpSidpS
sC2do6Jb4ISLMVMEDlQbOUniz2Q+GhXylnxoFIHfWPYJywO5K6vS4Y3HPfi4kREs
SIhNu687LNUGzdCZA47Aqn1BpSjqO6fWWjYGombtN5SG5UcYdsQaGMqypr+vVSJn
N6Is9sq6/ZjIRdFXk+m6JNnbQGRPBgn/7y2k8BWnbtW520HmKDRqakdqHg71sRLm
fuQ4L1N8OUUfnFPqdBKRPA+0H9v75Q4zPhKa5GpgR/Yzdi5vD/2U+OlIXaFuxMgG
qztqdq7Hl40fnVTim0fHalgfKzUx4J2d/zUMSNPLKM6z9Ht6/S+ZR5Ylu3VpyBQ=
=xbsW
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Aug_2010_17_46_21_+1000_yjLM=8lGx_xPYx0p--
