From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs unable to access shares with read restricted at root level
 (bso#8950)
Date: Tue, 27 Oct 2015 10:59:05 +0100
Message-ID: <20151027105905.0644daf2@aaptelpc>
References: <20151026131817.3a8a3ded@aaptelpc>
	<CADT32eJgrjigh_ezCAJK-ivO-t_yygPEhgwoHKsE-8EdVxKP+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/h7EGnSa_o2fzgBH/aOATwcG"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJgrjigh_ezCAJK-ivO-t_yygPEhgwoHKsE-8EdVxKP+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/h7EGnSa_o2fzgBH/aOATwcG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Shirish,

On Mon, 26 Oct 2015 22:04:28 -0500 Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> They are stored in a linked list of struct cifs_rdelem off of
> superblock where each element of this linked list points to a
> disconnected dentry.

This list is only used use when we mount with noserverino. It doesn't
work in both case anyway.
=20
> > * How do you allocate a new dentry?
> > * What do d_obtain_alias() and d_splice_dentry() actually do? I've
> > read the doc strings several times but I still have a hard time
> > wrapping my head around it.
>=20
> I think the simplistic answer is d_obtain_alias creates a dentry
> without a parent and d_splice_dentry connects a disconnected dentry
> to a parent. So let us say you have a a filesystem like /a/b/c/d/e/f
> where c is not accessible, we would create a disconnected for d (and
> for all the entries starting d such as e and f)
> Then when c is accessible and we are trying to reach f, while
> traversing, for each dentry we would look whether it is disconnected
> or not and if found (by any of three search routines), splice dentry
> with c.
>=20
> What kind of setup do you have where the patchset is not working?

Everything is explained on the link I provided. It's the same setup you
used I think.

  http://diobla.info/doc/suse-todo#bnc799133

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/h7EGnSa_o2fzgBH/aOATwcG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWL0rqAAoJEDIGO5Hchq/8JQkP/i+CHORJXw7GsDpXmrZgZlxE
4BRaPpS5LMVCDP3VDqMMcLzSgU2QetMM8yBiV5haAKTg6Utp0z0vwTS3Pi1r9m4e
LAQ5PujN4C1fQyymHAsO5MtupzoZXCs2SQ/ylWy3fgk3ziNBJK106gHHgd7EF6ts
Egzz6BRQgFpROjZias9f2/TnCoyyDdu52w+Y9/nAgzll3XHOv/qN45ZlzonlEE1N
gpimVbtsWdhaK5m7HcnDAzOw6DWegRd2FRZuGTiVLxGSpgowVLaFZ38c/VJg5EH7
QVxUHlyBM/ZVT6SP4o8cPzQ+cyGetYS6knCGieGfYdV0HA/HvwBopuMjwjr4qzYQ
Kp6LLUU5vTlO7LX1hwwDhPPzO8Q8wd/hyhFEC2EyfkXTjcWwgfXXV7uwh6HpvrFv
bFdDQPBJo7ill+fC9tnc/SvbmrIlxACDh8BzBVimgsbOVYDhEdi82J0AQaTG0pd6
HWaJF4lh9O17ew/nMPC8s+jXEzHYwcd13o0ONcRfxsWVpMaNZcE8nLOmTNyU0cpw
IGiq/KpgyPhAHfzjUSsn3lfyryvBZc2FegRgf4MarELOkIiFVs8+CG1Xl/iAltaO
2lhHIVYgDIJ1T1H7LJ/jz+zUWEfqZeOQKm6iHgFl0dADnVBXRF0UXLxmzYQWr5BN
+0Y52PyDjIqxMW0crLF6
=BttG
-----END PGP SIGNATURE-----

--Sig_/h7EGnSa_o2fzgBH/aOATwcG--
