From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] fs/cifs: suppress a string overflow warning
Date: Tue, 4 Sep 2018 11:22:18 +1000
Message-ID: <20180904112218.3f7e3337@canb.auug.org.au>
References: <20180903131558.21cdeb35@canb.auug.org.au>
        <CAH2r5mu99E39iwx=70w6F5MxvNh1MrzbVwTRb2e8dmz9WU52sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kbqeILRHxWRI.P51Ik0MYhj"; protocol="application/pgp-signature"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mu99E39iwx=70w6F5MxvNh1MrzbVwTRb2e8dmz9WU52sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/kbqeILRHxWRI.P51Ik0MYhj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 3 Sep 2018 09:44:17 -0500 Steve French <smfrench@gmail.com> wrote:
>
> Merged into cifs-2.6.git for-next
>=20
> Is the message annoying enough on powerpc to merit going into
> 4.19-rc3, presumably should wait for 4.20?

Up to you, but 4.20 is probably fine.

--=20
Cheers,
Stephen Rothwell

--Sig_/kbqeILRHxWRI.P51Ik0MYhj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAluN3koACgkQAVBC80lX
0GzrmQf/Ve8hQUTM1f4nkGK+HsgLYxG/iO95r5ffvMH3cpIXD4bCJBAyd/+w6dn+
mH+uRsqTkAOwOFHIzByacUbgQJn9wHzNWfF/v+PyRplJC8AbfBj8607ktJulS+pU
c5c9yWLvE9T4fETrrpRGas8YNDIzY7RyOKrA0d4T0XUyUsDTSW72kWrX+njUh+n2
HIszle/iIsSyz6YL9EO2/V/ZbfOglZYQ8PGegyRQo5l2vVivDhMglIh1xGoAJM7r
dvdbFGv/3grCCV0MsYMgvkE6D963rVrqH7mmpJTzjAB6oHdlSle3MTK26Xd5GS7O
Rq9AlaRBOOvOJQRv3tQN6YrAwDRwPA==
=3x/f
-----END PGP SIGNATURE-----

--Sig_/kbqeILRHxWRI.P51Ik0MYhj--
