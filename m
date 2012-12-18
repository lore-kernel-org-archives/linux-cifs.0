From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 0/5] cifs-utils: plugin interface for SID to UID/GID
 mapping
Date: Tue, 18 Dec 2012 10:04:57 -0500
Message-ID: <20121218100457.54e89049@tlielax.poochiereds.net>
References: <1355839848-24118-1-git-send-email-jlayton@samba.org>
	<50D0817D.5040508@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GuVt8oCxvPNQiUbIhfmhNbN"; protocol="application/pgp-signature"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50D0817D.5040508-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/GuVt8oCxvPNQiUbIhfmhNbN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Dec 2012 15:45:17 +0100
"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Hi Jeff,
>=20
> I didn't look at the whole patchset in detail, but I think
> such a new API should support IDMAP_BOTH, which means that
> a sid can resolve into a uid and a gid at the same time.
>=20
> This is very important as it allows groups to own files
> e.g. BUILTIN\Administrators is likely to be the owner of a lot
> of files. And it's the only way to support the 'sIDHistory' for users.
>=20
> metze
>=20

I'm not sure I understand how that would work. The situation is often
going to be something like this:

"The kernel has an ACL that it has fetched from the server. That ACL
has a SIDs in it that are designated as the user and group owner. The
goal is to turn those into the st_uid and st_gid values as presented by
stat()."

So...how does IDMAP_BOTH come into play here?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--Sig_/GuVt8oCxvPNQiUbIhfmhNbN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0IYZAAoJEAAOaEEZVoIVMjsP/AxaRmxGHtQAXi6h/G58yzk0
SBM70F6tuSTERYpZnvfY0kkyZWxTG/YVAWED17dUAkPyWBMGlyypndQaf8csrF7a
isyAFC2QqKoytOg6v/3lY3oD6gQNvTFqn/gufGVK52B7yHrXAB6nri2GhoplqdNu
fMrFhW9ZzpHHV8EuFYbjpdetqh/P740Pm1phiOlmcfLPzZWRh/o4xVw1xzss3Q1d
RED1HPe57VwqBxkz77v+o4T7TLPtVMxjlZZbH7KkMD1UBVTuCL3HDgfxAJxG3ejn
XUp3hxC8krZRKCRhwcCdaJN6d/aR+K0vzoxW9yE1Bc2hVuUTHYC7VU7TbqHmpzxt
BrJzt36ofDggfh+bwvOxoTwZv9SY35krxCU0l19oz/udXHcZXcyyZgtSH29JEHgQ
nUjvxvJR07p/Yf00SzdcAFV0mim4aHgn0EPkDuOS+rSiE7/86zc7zaQtU6KR6Iq/
KquXCpjww/besxc8QJedy6pH8iygTG0fqoFd/TxfRcpnnwpz+3Y7I/0tDaftzy33
ZO9im1PNUe+/xuwcuNLzp395gQziUiuBDz4x3tTi0JP6jami6RzS2RzMyMfZwIuE
OZYpvBRq3O30vBF3/36Tajlc+n5CN+ovx/QbLx6GpY/qeEpkb09A+n399AWqvJtb
dlE273B1V0RGhrdX15CL
=wVmY
-----END PGP SIGNATURE-----

--Sig_/GuVt8oCxvPNQiUbIhfmhNbN--
