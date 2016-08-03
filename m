From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/3] bug fixes and code cleanups for inaccessible root
 patch
Date: Wed, 3 Aug 2016 15:25:55 +0200
Message-ID: <20160803152555.35db9a78@aaptelpc>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yJIM5824q_XHVk6ixbPZGFJ"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469828301-9937-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/yJIM5824q_XHVk6ixbPZGFJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jul 2016 22:38:18 +0100 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
wrote:
> The fix for unaccessible root with summary
> "fs/cifs: make share unaccessible at root level mountable"
> introduces a few bugs. This series of patches cleans up some parts of
> the code and also fixes a couple of bugs seen in the patch.
>=20
> Sachin Prabhu (3):
>   Fix memory leaks in cifs_do_mount()
>   Compare prepaths when comparing superblocks
>   Move check for prefix path to within cifs_get_root()
>=20
>  fs/cifs/cifsfs.c    | 29 ++++++++++++-----------------
>  fs/cifs/cifsproto.h |  2 +-
>  fs/cifs/connect.c   | 31 +++++++++++++++++++++++++++++--
>  3 files changed, 42 insertions(+), 20 deletions(-)
>=20

I've tested it, I can confirm it works as the original patch intended.

Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/yJIM5824q_XHVk6ixbPZGFJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXofDtAAoJEDIGO5Hchq/8EhUP/0rL8TyjB31gP6OXZ5My430N
x/3DYyL9Y3txtbpYh6OJljQSMSZosANXRA4mw3yDaXspvYcn7o8y8uoJx2xR+yAF
mvf6f3m9wB7K/4CMXAUrPg400k1WyScSIHBj4gp6V1JiU9jqE1xNIxLI3YQIhOIb
cQuWd7CEsPIH1po2ehAPTUn7OWVy4DzJISIx9bLSCQLqHb7bwxOX+IJ9Ag2zrUdL
HT5WkAkwyyLoO3CUwVQUlakWhJ0orA8O8B6/uatq5bEtZRJWLcSPAPCSHocuJ868
fhMczQHd1P1lfNiE918o5dj0RSr1SRJTbyIhW03jNszf+dBGUyopmXBtt6f7X/e1
lbxcoSBIm6dgPXII2TxLHVOq33m7Ut6C8hWIn+3lXwwJ5p49vyg3/an83089j7fs
kmu2nvVwz35sI3pm7R6fG8Y+jsOAcsQjTmJx+D5CT5w9GlJMetzN7wT8u4Izo7ZJ
DrZq4xtXj50u+UewvEeilnVIacGWFc8EJOUn+Dmksop2BFjtkO/gw1ks+1SSfIA6
jVMymVch2fLmfR7/lsWYjkeOKNNFgemTcs+PCkvqDZNcxggVYEi+e6y07YrzUiz8
f7+6kXnmn+tlJcu3H6WWeC9rLZOE43eUr/dgoM3x5args0A5MHvC3bMlT6N/YGBm
U6907VN+GOtnQgei7yl+
=MgyK
-----END PGP SIGNATURE-----

--Sig_/yJIM5824q_XHVk6ixbPZGFJ--
