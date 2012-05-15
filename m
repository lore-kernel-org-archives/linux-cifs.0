From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] Support non-BMP characters on UTF-16 filesystems
Date: Wed, 16 May 2012 00:55:48 +0200
Message-ID: <4FB2DEF4.7030701@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigEFAD0476C980FF20EDC98AF3"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>,
	Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>,
	Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEFAD0476C980FF20EDC98AF3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, when conducting some automated filesystem tests, I've discovered
that some filesystems are unable to cope with non-BMP characters. While
most usual characters are in BMP, I still think that supporting then is
important. Perhaps, the single most important reason to support them is
that they come up in some personal names. The series has 2 patches to
prepare the ground by changing NLS functions uni2char and char2uni to
work on full unicode_t and another patch for UTF-16 conversion functions.=

Remaining 6 patches are for specific filesystems.The filesystems I haven'=
t
fixed are ncpfs and cifs since I don't have the relevant test environment=

but it should be easy for someone with one to extend it for them as well.=

I've used mainly 2 following characters for test:
=F0=AF=A6=99 Some rare CJK symbol, no idea what it means, picked it up at=
 random.
=F0=9F=98=81 An emoticon.

I send this explanation and first 2 patches to all concerned parties. Res=
t
is sent to LKML, linux-fsdevel and relevant filesystem maintaintainer/lis=
t only
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigEFAD0476C980FF20EDC98AF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y3vUACgkQNak7dOguQgkzTAD/VPVRlFLsYJ71/tJxUpEzREtd
+mrxUsU81NRp4WdoVy0A/38nbsTU5m3sGosxnC8vwyEEAx2jmG/wCEiiKB4z1zQU
=h+9z
-----END PGP SIGNATURE-----

--------------enigEFAD0476C980FF20EDC98AF3--
