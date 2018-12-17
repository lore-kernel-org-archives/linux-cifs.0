From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: Re: [PATCH] CIFS: use the correct length when pinning memory for
 direct I/O for write
Date: Sun, 16 Dec 2018 15:10:35 -1000
Message-ID: <20181217011035.ykal46ixowdqyl7h@gmail.com>
References: <20181216231704.16761-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="idxsf4dcv7fappfg"
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org,
        Joey Pabalinas <joeypabalinas@gmail.com>
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181216231704.16761-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--idxsf4dcv7fappfg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 16, 2018 at 11:17:04PM +0000, Long Li wrote:
> From: Long Li <longli@microsoft.com>
>=20
> The current code attempts to pin memory using the largest possible wsize
> based on the currect SMB credits. This doesn't cause kernel oops but this=
 is
> not optimal as we may pin more pages then actually needed.
>=20
> Fix this by only pinning what are needed for doing this write I/O.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org

Looks sane to me.

Reviewed-by: Joey Pabalinas <joeypabalinas@gmail.com>

> ---
>  fs/cifs/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 3467351..c23bf9d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2617,11 +2617,13 @@ cifs_write_from_iter(loff_t offset, size_t len, s=
truct iov_iter *from,
>  		if (rc)
>  			break;
> =20
> +		cur_len =3D min_t(const size_t, len, wsize);
> +
>  		if (ctx->direct_io) {
>  			ssize_t result;
> =20
>  			result =3D iov_iter_get_pages_alloc(
> -				from, &pagevec, wsize, &start);
> +				from, &pagevec, cur_len, &start);
>  			if (result < 0) {
>  				cifs_dbg(VFS,
>  					"direct_writev couldn't get user pages "
> --=20
> 2.7.4
>=20

--=20
Cheers,
Joey Pabalinas

--idxsf4dcv7fappfg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlwW94oACgkQ2rGdfm9D
tVJDVw//YlX/0LsP6eZyP08m4OT21ajO8bNIkFqd+jLFVEcIlm/Nk0f+gxxcIwiJ
y+Xt6rSwl3tyypQKvIh2ba6XdgFM+Ti3O7jb/6oiE0guwLhh1WUA4iQhPgDjBPrJ
rzvsVaEB2LQpXOzPQd7zFcpvx5wJO8S13ZUpeaSUvA8LpbKQTf0Oh2u6WUOf2guo
gfMJixovSgbl2kpTiUSd8gqh5Bw51zsyLTFsnE8GFx30liXzZ5zxguMXKPu41rQa
uWfyK0A1LFzniBL9x0aDciYiL2qZZbyCY1BdKJTwqxFqX6VmHGGNlODguLdYAY6V
mp3wt2EyXbGwt1yYhhkXEwFgYuNsdYYvZOGLhElIrvMBH27QtX52sPW3pIv2+vS2
8BZpHyOTuCJ/zC9EsOkK3dyHrCdh9wSk6VDycSKrBfNCDSyNSq1FZJaujzOk6TP+
uFBO0PDpi222KzBf1LuGVlLOZlHGMbrrZZTpIyFZwLnLP4kh/c0qdJCrdXgyMMYd
biu/SBjt84+zvGIfLyXuq/5uJYUyesWaTpYWatpg1ohJ5QxIfCJb2B2YdniZ6fad
m5tB2+E4Hy2xM4NeNiMqYm0dP2KgR8fFzoOe86Aqe/A+ufGAEaMYCh/XWieozVXO
duE7ft8m5IQk/SgbvpCnhW1lYV3zm0K527wSaumYgxCYxcROs0Q=
=bRcp
-----END PGP SIGNATURE-----

--idxsf4dcv7fappfg--
