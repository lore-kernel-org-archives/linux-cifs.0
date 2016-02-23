From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 23 Feb 2016 14:05:35 +0100
Message-ID: <56CC591F.30205@samba.org>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="X79lAgGlRq68QUkIvJetI5SPUHV3n07uS"
Cc: sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>,
	Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X79lAgGlRq68QUkIvJetI5SPUHV3n07uS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ira,

> If the server sends an interim response, then the real response, the re=
al
> response, is handled by standard_receive3() in the kernel, instead of t=
he
> proper function, and this causes a disconnect.  If there isn't a
> disconnect, I believe the reply will just be discarded if I understand =
the
> code correctly.  (That is a big if here ;) )
>=20
> I've written a patch for Samba to stop sending interim replies on SMB2_=
READ
> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  =
We
> may want to add SMB2_CREATE to the list of ops we don't send async repl=
ies
> for non-compounded, but I'm not sold either way, I know we CAN go async=

> there!  I want some opinions here.
>=20
> This is not hidden behind a flag because compatibility issues that don'=
t
> impact protocol correctness usually aren't.
>=20
> Setting req->async_te =3D talloc_new(NULL); is just ugly, though it wor=
ks.
> If you have a cleaner approach, I welcome it.

Fix the broken kernel client!

I think this is nothing we should work around in the server.
The situation might be different if Windows clients would be unhappy,
but the linux client is more or less under our control and can be fixed.

People hitting this can just use SMB1 until it's fixed.

metze


--X79lAgGlRq68QUkIvJetI5SPUHV3n07uS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJWzFkjAAoJEA219WEoab1W4I8P/Rn//IRWurFlxQK8mhbQINaK
YP9fo1TK2xKtHpgawaJHo8NzE7fpM/MhWze79BA3GUE42wrk61BgJsXmgtYiE+LP
Skoouz13ObHq2Ag/6JnKN8Mu/e+Cl0SyYQa1e/UUdVPN3z5LVSTEYB2jKubDCNMi
bppUbbCQeMEcSzMO1r6cxrOwWE5OnwAge9Uipe1ozktlH+eWB5PD6D6yZysX3548
NkE5ZWEgjFn8u7HucF0UASba8sSPQQcN3Q0HCf9wSQv7SDCZN81RnusHFTLq2whZ
Sgxqc97DKzUADkuLeRhwUTOPvwvHOd0edKo/0QmMEHmqPYMdiMez/iAhkwMSaWiL
J0mMpttJEJ+YV/BlLWYE5bhr034RsS2+lpB9ytzLh0lzSHTmhiPPljNR7SGDgdx9
4/gwZJIUbbrEluD2kyQUG2HFoJRdhrdrzgu2mjSSm7E2tZpLmUOXm39uGDTWSHP6
EfFyIQh+QepbxBq5yWxrUnUmtPDwqeyHO0Unkt0F4Ch8g5USuHq4+266Dof3NKva
N2nm0GymQg3H6LISmB7E5pIApEHt8QkGXv0bNWcOW5/oFMebIxcsJdh0bZh8qcze
XAeYF+BjzRHO0K/vgYIIgmCbntxqPzAdelsqqSj2zxlYNfWTH21aHVC3BncYE0CQ
jQFQIsksrg3x3VorRNZZ
=OsDC
-----END PGP SIGNATURE-----

--X79lAgGlRq68QUkIvJetI5SPUHV3n07uS--
