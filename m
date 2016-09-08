From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs_get_root shouldn't use path with tree name
Date: Thu, 08 Sep 2016 12:49:46 +0200
Message-ID: <mpsmvjir7hx.fsf@suse.com>
References: <1473260003-5271-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473260003-5271-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Sachin,

As you said, patch is similar to what I proposed few month ago. There's
only one thing that bothers me. cifs_build_path_to_root() has this bit
before the DFS test:

	/* if no prefix path, simply set path to the root of share to "" */
	if (pplen =3D=3D 0) {
		full_path =3D kzalloc(1, GFP_KERNEL);
		return full_path;
	}


I think it should be dropped. It was already inconsistent because if the
share was in a DFS without a prepath it would have returned an empty
string instead of a path with the tree name prefix.

I can send a patch after yours to correct that you think it should be in
a separate commit.

Cheers,

=2D-=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJX0UJLAAoJEDIGO5Hchq/8uh4P/RJrweMa35R0/LAY40gPCab3
1uqR2yZOTXKGaibFIN273ihEPPyzSE4eIjYpKeoDqkI/vDJxb/b+UvKxObrXZwTk
zGi4LNl1na7fiOk+ByJVV6rEQmeYzeRdO5wsIXVcCgKNvxeDxpt2DwKiAhUDfWt3
GlnmkJrDf6Bzy9jGFz+77f3q3FGOxLs47lMIUghg0J4LV1e/p8zwNi7efavFw/V8
P7B6SSyiHfFnFEaUQ3KmZUQk6YnKzbnICqqgi1K1vb4mIZBksrx+FHAwAx95v2gw
fcueDvSnGIeZ8pBFHAfpWRqSv5Wl2iDnkZfU2hsywOJta8Qgv58J7/Qo+8bkoZeg
/jUnj8w/8vPS5hKVYbJmXi4oekAb4fkIChMWn6k6uJgmp5nVf1qb4LsJFOZe+YWj
Orp3X7ZDObF2D6w5rLp/Dqhi0PmE6zEHcPL8GjzDcWSzR5dt7aRGsLY05Pxa5uHY
nTUINXLg/tSdHg5uzjR/dXaQGnhZ26zCmypSVqZQY8xSBXo7atFyXGEN5pkvseLu
46EJf+Uxi4uXrvapuwef5clbfpGaztGVpZ3x2Z8y5MFe/qVpooeDZlp7VUDTVP0Q
HZm4vPUypLYET2U2m28X0mKILwjA6L0iz82TYx/8aAnL44P2mOQTOLuSR8wBa8or
jl4xqhlJq6vEyUiyD7lj
=kG4U
-----END PGP SIGNATURE-----
--=-=-=--
