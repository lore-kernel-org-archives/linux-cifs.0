From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs unable to access shares with read restricted at root level
 (bso#8950)
Date: Mon, 26 Oct 2015 13:54:30 +0100
Message-ID: <20151026135430.255deac3@aaptelpc>
References: <20151026131817.3a8a3ded@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k0mN+9GiDvocEBKZB+s3_Q="; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151026131817.3a8a3ded@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/k0mN+9GiDvocEBKZB+s3_Q=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I wanted to add a few things....

On Mon, 26 Oct 2015 13:18:17 +0100 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
wrote:
> * How do you allocate a new dentry? =20

That's too broad, forget this one. There are many functions to do that
depending on what you want.

> * What do d_obtain_alias() and d_splice_dentry() actually do? I've
> read the doc strings several times but I still have a hard time
> wrapping my head around it. =20

To be more specific, where does d_obtain_alias() look for a dentry
associated with the provided inode? I would guess in all the connected
dentries for the inode superblock. If it's not there, what is the path
of the newly allocated dentry?

d_splice_alias() looks for an existing dentry associated with the
provided inode and if it founds one, replaces it with the one provided.
Correct?

Really, I think my biggest misunderstanding is, what does it mean for a
dentry to be disconnected?

> The result I'm getting seems to indicate that when an intermediary
> path element is inaccessible an alternate root dentry directly
> pointing to the requested path is created. The problem is that the
> prefixpath of that is not stored anywhere so when we ask for a
> pattern to list the content of that share, we use the path of the
> dentry from the root (which is, well /) instead of the share
> prefixpath. =20

To illustrate this:

* User bill can only access HOST/share/sub/path and none of the
  intermediary path.

* When we mount this path to /mnt we realize we cannot access
  intermediary path.

* We create an alternative root which directly sores
  HOST/share/sub/path as / (but /sub/path/ is not stored anywhere!).

* When we ls /mnt, we use this alternate root path. The function that
  builds the share path from a dentry (build_path_from_dentry) simply
  walk the d_parent dentry until it reach /. In that case it immediatly
  stops because the disconnected root is.. a root. It should
  use /sub/path instead.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/k0mN+9GiDvocEBKZB+s3_Q=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWLiKGAAoJEDIGO5Hchq/8u6IP/iEBoxTF+bMzVDG13h853Apz
Lw8gkUiM6Kar80FNAuRp0yieWlCAG9CsN8gvSu3LkaCNq4hHkMGcF2UNS1ai+wUI
doCE0LpAPBtgASPQautnBwPuQQHZBep5zJ1OCVA1KeHouR4b1Xh0/F7OqpZa6VWi
yaHpHM9lcy9oABWdIUjd6DAfSmXWAYU0Q7tPRrxbj/dwKIARUc/f8FSrU0xwuLeu
mLfaXGw2wBRigQkJvESYxjIOub4qwkrUTcLo4tYFD4TkBWWuTi1yn8Opp5LKFF0F
wVTwykszV1hLLfyeXyx+1VLgLg5zZB/Kif66NtHwzxB2QfhuIdqYVxjaSUgVGcS4
qSbzB2MIWakC/R3YqHV9np2ygkb43bSz04qq4o0ra85h0XjXYppmnmymRnq7O19o
hwl5iquK3VT35fB3hCWCeUsHaTLN8IzGdzcRdsqmXU5BYxKhjoM85AuDbL9dQScZ
r8Btg6jSjvnz5UwtSI0rtOGbsxK8xZjXG2clpTbybMW4Q0GZe1ocNlY9tHS1LWKz
y6igLnXiyOAwRvxNApmtPmI+fudIU+zgGdpkqGXtki2+13fdex3jzH07meA59c2v
3DTdLKUsgXTiqTKDkfH4Yb3uCahqk4Gqjf7cTBLJZeq1Ntl26iEf26YAbSoe13Hc
rASw/BI7Qpb/ctRwfPJl
=y9In
-----END PGP SIGNATURE-----

--Sig_/k0mN+9GiDvocEBKZB+s3_Q=--
