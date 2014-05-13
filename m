From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: manual merge of the vfs tree with the cifs tree
Date: Tue, 13 May 2014 13:16:16 +1000
Message-ID: <20140513131616.59f41b7a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7jgW=iFLg/NxUdPohlpKI0m"; protocol="application/pgp-signature"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/7jgW=iFLg/NxUdPohlpKI0m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/cifs/cifsfs.c between commit 485c4e72d0f1 ("cifs: revalidate mapping
prior to satisfying aio_read request") from the cifs tree and commits
aad4f8bb42af ("switch simple generic_file_aio_read() users to
->read_iter()") and 3dae8750c368 ("cifs: switch to ->write_iter()")
from the vfs tree.

I fixed it up (I dropped the cifs commit, so this will need a better
fix ...) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/7jgW=iFLg/NxUdPohlpKI0m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcY6FAAoJEMDTa8Ir7ZwVInoP+wSZYnMqydKFp8qkDgQBml5m
oOvDeIkPJF/adf2dsDEt2YM1oBh7l5rLNQrFg2mWWXvAO2TW9RkyP0LC3hRR8c+0
gl7DVCpf+ZYj0dkjbXROxGqd+b7QUyxe/bZfWsN8kshEeqnFzx3uasUUEDC8KoSy
xGTXbWk7A/y4vH6UQo1IZnzl0Ki8WyYcf4QgkGHpmy4tbVPFmDBu4QDfhfdrOGRG
h7aglb5SPwwCgFVDmZMR0D4sSwbFprt6WsrrgjrxlVxbs8Mz6ImL95dertOC+f5o
MB0LyQHygELz8WWKWbdUdPZ1U3nzC0pWEVIN09HqKZV24x+HowCRZaEDyLBevMu+
FzalKvJMnoIBoBP1jJTcNWEHoRkVN+m7PkzB6IyS2wzsDgXrXpG8QXg7wjTTlvm8
WhtKlqSxvqQ8ZONHlHqjtoB0qq7zyMPbDwf5886nyoS3zdxN+xgIBDEMQMKiAxrn
+m/wHZDSaksPdFrbYgpx5a61ksZEh5f3jEnUh4GaNMn8ODTfRACY52r0695bV2lM
4Zftu+c9MV/0iP/xpoTz8iFWiG6ZoePif3j0GN/BTuJoyp2zD2NTIWtdqUhAUaU9
EUa6qbu5Noucu3KBH20/cQpx8EWNy/NzAhgkFG+lAe4YbIlUM7BIljjpM9iojlzm
CoRiCd7CLb54ZWUNup99
=jrm1
-----END PGP SIGNATURE-----

--Sig_/7jgW=iFLg/NxUdPohlpKI0m--
