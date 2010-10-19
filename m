From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Tue, 19 Oct 2010 16:21:20 +1100
Message-ID: <20101019162120.76e03b4b.sfr@canb.auug.org.au>
References: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_16_21_20_+1100_Iha3b_u2=2EIQviC"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100924135531.96e5ac72.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Tue__19_Oct_2010_16_21_20_+1100_Iha3b_u2=2EIQviC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Fri, 24 Sep 2010 13:55:31 +1000 Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> =
wrote:
>
> After merging the irqflags tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> fs/cifs/sess.c: In function 'CIFS_SessSetup':
> fs/cifs/sess.c:595: warning: unused variable 'blob_len'
>=20
> Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
> NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
> CONFIG_CIFS_UPCALL is not set in this build.

I am still getting this ...

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_16_21_20_+1100_Iha3b_u2=2EIQviC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvSrQAAoJEDMEi1NhKgbstscH/1ge2UoyXCskX3ZfNwndQg9m
fp6oM9LZueFo7n+Ew876WlCMDEVuvEFcjI2vwir2orCUpighnWImuMNDHX8nINkA
cp1UF6PfvoBSQ86+Z/F0HtAOyGqovzQtzs2qkd+av+C8OkvNuhzUE1L2t+RiJ0pi
C7+LlyTzpGFzr7NU9c4suPnZP98W7X8SOp0Sz2/QZsuc0HJ2HJUp3Q9bz5sjdtEj
NsuExebqQ+n1dzKjj+uPo6oPLIuiFviavys9hAGO7mXPzaJi1dw9ucYr92+7hLWq
2L9M7EyHibA9BC/4YTnHpvc/eSxPTzFKzIlHRl0AtonB2sWryJa91wgmxSp0cyE=
=CBWz
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_16_21_20_+1100_Iha3b_u2=2EIQviC--
