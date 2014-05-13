From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: linux-next: manual merge of the vfs tree with the cifs tree
Date: Tue, 13 May 2014 06:49:37 -0400
Message-ID: <20140513064937.641b45ed@tlielax.poochiereds.net>
References: <20140513131616.59f41b7a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/P7RrZww8mVxhq6zAEMUh5zD"; protocol="application/pgp-signature"
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Steve French <smfrench@gmail.com>,
	<linux-cifs@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20140513131616.59f41b7a@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/P7RrZww8mVxhq6zAEMUh5zD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 May 2014 13:16:16 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Al,
>=20
> Today's linux-next merge of the vfs tree got a conflict in
> fs/cifs/cifsfs.c between commit 485c4e72d0f1 ("cifs: revalidate mapping
> prior to satisfying aio_read request") from the cifs tree and commits
> aad4f8bb42af ("switch simple generic_file_aio_read() users to
> ->read_iter()") and 3dae8750c368 ("cifs: switch to ->write_iter()")
> from the vfs tree.
>=20
> I fixed it up (I dropped the cifs commit, so this will need a better
> fix ...) and can carry the fix as necessary.
>=20

Thanks Stephen,

Steve, what we probably need to do is replace 485c4e72d0f1 with this
patch. Only tested for compilation so far, but it should do the right
thing. I'll resend to the list once I've had a chance to test it.

--------------------------[snip]-------------------------

[PATCH] cifs: revalidate mapping prior to satisfying read_iter request

Before satisfying a read with cache=3Dloose, we should always check
that the pagecache is valid.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 fs/cifs/cifsfs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 078c171c4f1b..149b09ce148d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -729,6 +729,19 @@ out_nls:
 	goto out;
 }
=20
+static ssize_t
+cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	ssize_t rc;
+	struct inode *inode =3D file_inode(iocb->ki_filp);
+
+	rc =3D cifs_revalidate_mapping(inode);
+	if (rc)
+		return rc;
+
+	return generic_file_read_iter(iocb, to);
+}
+
 static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *f=
rom)
 {
 	struct inode *inode =3D file_inode(iocb->ki_filp);
@@ -885,7 +898,7 @@ const struct inode_operations cifs_symlink_inode_ops =
=3D {
 const struct file_operations cifs_file_ops =3D {
 	.read =3D new_sync_read,
 	.write =3D new_sync_write,
-	.read_iter =3D generic_file_read_iter,
+	.read_iter =3D cifs_loose_read_iter,
 	.write_iter =3D cifs_file_write_iter,
 	.open =3D cifs_open,
 	.release =3D cifs_close,
@@ -943,7 +956,7 @@ const struct file_operations cifs_file_direct_ops =3D {
 const struct file_operations cifs_file_nobrl_ops =3D {
 	.read =3D new_sync_read,
 	.write =3D new_sync_write,
-	.read_iter =3D generic_file_read_iter,
+	.read_iter =3D cifs_loose_read_iter,
 	.write_iter =3D cifs_file_write_iter,
 	.open =3D cifs_open,
 	.release =3D cifs_close,
--=20
1.9.0




--Sig_/P7RrZww8mVxhq6zAEMUh5zD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcfjBAAoJEAAOaEEZVoIVMzMQAJltTMMG5bz4TPF1Iqvvu5bD
FRoJ/klV6GhqDOw7/48Da+jrYoWk6OMhYjY0vbyXE2g7G8QqrR2XHKXYPWfdDLYk
BpdUAgbpFRJLkHwebRXuXWAIhENzmv1J0JfJCRJTYZgpghRT68hlqkju0bqMXMii
oQae4MD6O8m/70+Nn5aTzGzLqvcMSOaRfdA63c9BDoW/pld5oy+2PanFssHuZO8h
zXAO9oXbOuUJUb962NoZdHaZxzrPNn1EE0lh5rafu988PsaapN5g+97PVPuItIEw
Y11o/4rTb8NCgE+H8iS5KANZyj7qODy5IJZ2GclRtMsdQC7R0f3qcHWCicMqdUpA
F6iownILJOAKc31IB4utMG+uY4IAvrWBNj5WmDs4Ke+8P3t/ab4RK5ClnyUl2NGr
v3tTm3XIeUxwEYpmVr0YMAZ4CzqYF8WSLiCX8Mt/LxHu88dNHVREcYWBu2c/Zr5a
b6nuADp7uu8rPNDHdBSWs4DHaXhMwtaOYixQ2xV2IFRF0N3MhxO/3b8nOHDowsU/
wtQ3kHwL43+Yid3OLWL+ZG3Abnh4XlQfz1S6voQSMVOiRGnFJmjugJraNFFcIUZy
7LCqx/JdE+j+KELduzO8cncLCeMmpHfCoY3TXRL/QTv02EL3ngP+swxWZdcyiEza
WUzipSsncrgN9ZpPc+0V
=V2Uj
-----END PGP SIGNATURE-----

--Sig_/P7RrZww8mVxhq6zAEMUh5zD--
