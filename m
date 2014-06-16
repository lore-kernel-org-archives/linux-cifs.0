From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
Date: Mon, 16 Jun 2014 15:49:49 +0200
Message-ID: <539EF5FD.5000307@samba.org>
References: <1402394606-7910-1-git-send-email-bb@sernet.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?B?QmrDtnJuIEJhdW1iYWNo?= <bb-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402394606-7910-1-git-send-email-bb-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Steve,

any comments on this? How can we get this fixed upstream?

Thanks!
metze

Am 10.06.2014 12:03, schrieb Bj=C3=B6rn Baumbach:
> commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
> ("CIFS: Cleanup cifs open codepath")
> changed disposition to FILE_OPEN.
>=20
> Signed-off-by: Bj=C3=B6rn Baumbach <bb-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Reviewed-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.14+
> Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/link.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 264ece7..68559fd 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cif=
s_tcon *tcon,
>  	oparms.cifs_sb =3D cifs_sb;
>  	oparms.desired_access =3D GENERIC_WRITE;
>  	oparms.create_options =3D create_options;
> -	oparms.disposition =3D FILE_OPEN;
> +	oparms.disposition =3D FILE_CREATE;
>  	oparms.path =3D path;
>  	oparms.fid =3D &fid;
>  	oparms.reconnect =3D false;
>=20


--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOe9gYACgkQm70gjA5TCD89XQCfR05JcjbtnGAs3mpQXQXS1CGx
cLYAnjWQBwzYg7zJROjwbKmvp2gXjZcK
=686d
-----END PGP SIGNATURE-----

--QbxoLR5KvvS2XQrJOoAOfRa5p7cjHO6jH--
