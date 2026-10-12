Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7936DA0D;
	Mon, 12 Oct 2026 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812496; cv=none; b=q312GeiDOT1+m1i0aPIMtnGlSUqOoMVchTZGvym3tecrhTjQwVtI0XIy7SSELqoF9G594PqVWsOsL/U8+c5/7IfnR7OMG9g49+0T+inv9OsNxjf6n9GKp/4Ej9FSUExQ0jw299Q8tobaSf9EufkCgxHBxfp9niVlsNQEhfPrZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812496; c=relaxed/simple;
	bh=24sDrju+y2ikeqv6Uudjl+a0VtceSqSgG/hO99eU0zk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SFG0bxr8f9v2de4or/lQnBIN0eqZAtUBFZ0QU4MyAcFrWkgIkv6BWLHwz+JHUGO9bHFUb7zbs1ot0i+aYr4rftAsAvqky0FX4APQqm2OE+D26RgcYcmCWu9MRJhLVUndaHOyBwc2Yooclt8PxAk/WaYUZGvaId3uj8qBsTl53II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g12qFGIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g12qFGIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA531F0089B;
	Mon, 12 Oct 2026 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812495;
	bh=vncTLL2WhgPFsDyYZqLSKQgE2f5x8/rk+40ZNiAa/to=;
	h=Date:From:To:Cc:Subject;
	b=g12qFGIUgDZQDEfs6CczI8DuB6OkiM8YBZHvtpukQYiWNSf19N+oNBvcMK6XRxkm6
	 NIhoKq+VtEHWK2IE/gSaCcGUBqR6R2nTtWbI5vpKug8guBvnJjLxan/FGd8RXzWli+
	 ODAsVMkH8mxAGqKInqbsCVVZ7/7hl0qjmAOuji/wQGftyC3dA2WI7xkLb5gDIUFfcO
	 jWLb3pb3mnxW3iKVcAljnSIqkC0oCU+NefsEDHBopQoleZqj41RDLEkHFe6uBhLPvE
	 HmttljFQ9jhj572Fv+NkOOhgQiSlVfO1Vb92zDqBtJ3EtT88OZV+PRFPvfoFqCd36E
	 uNgYTcwcaUeqQ==
Date: Mon, 12 Oct 2026 14:41:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>,
	CIFS <linux-cifs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the vfs-brauner tree
Message-ID: <aszji59b6B79a3Hi@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wYytuotjRGy3pYJc"
Content-Disposition: inline


--wYytuotjRGy3pYJc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the vfs-brauner tree, today's linux-next build (x86_64
allmodconfig) failed like this:

/tmp/next/build/fs/smb/client/cifsfs.c:1258:18: error: incompatible functio=
n pointer types initializing 'int (*)(const struct mnt_idmap *, struct dent=
ry *, struct file_kattr *)' with an expression of type 'int (struct mnt_idm=
ap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-point=
er-types]
 1258 |         .fileattr_set =3D cifs_fileattr_set,
      |                         ^~~~~~~~~~~~~~~~~
/tmp/next/build/fs/smb/client/cifsfs.c:1270:18: error: incompatible functio=
n pointer types initializing 'int (*)(const struct mnt_idmap *, struct dent=
ry *, struct file_kattr *)' with an expression of type 'int (struct mnt_idm=
ap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-point=
er-types]
 1270 |         .fileattr_set =3D cifs_fileattr_set,
      |                         ^~~~~~~~~~~~~~~~~
2 errors generated.
make[6]: *** [/tmp/next/build/scripts/Makefile.build:290: fs/smb/client/cif=
sfs.o] Error 1
make[6]: *** Waiting for unfinished jobs....
make[5]: *** [/tmp/next/build/scripts/Makefile.build:551: fs/smb/client] Er=
ror 2
make[5]: *** Waiting for unfinished jobs....
/tmp/next/build/fs/ntfs/namei.c:793:40: error: passing 'const struct mnt_id=
map *' to parameter of type 'struct mnt_idmap *' discards qualifiers [-Werr=
or,-Wincompatible-pointer-types-discards-qualifiers]
  793 |                 stream_vi =3D ntfs_create_named_stream(idmap, dir, =
base_name,
      |                                                      ^~~~~
/tmp/next/build/fs/ntfs/stream.h:35:58: note: passing argument to parameter=
 'idmap' here
   35 | struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
      |                                                          ^
1 error generated.


Caused by the constification series for mnt_idmap interacting with:

   2de2cdd9cc08f (ntfs: add pathname access for named streams)
   121e0c35720b2 (smb: client: implement fileattr_set for compression flags)

=66rom the cifs and ntfs trees.  I have applied the fixup below and can
carry as needed.

=46rom 6b75090639b332f5fa52a558edbba295d8bb42fc Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@kernel.org>
Date: Mon, 12 Oct 2026 13:55:24 +0100
Subject: [PATCH] cifs: Fix semantic conflict with const mnt_idmap

/tmp/next/build/fs/smb/client/cifsfs.c:1258:18: error: incompatible functio=
n pointer types initializing 'int (*)(const struct mnt_idmap *, struct dent=
ry *, struct file_kattr *)' with an expression of type 'int (struct mnt_idm=
ap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-point=
er-types]
 1258 |         .fileattr_set =3D cifs_fileattr_set,
      |                         ^~~~~~~~~~~~~~~~~
/tmp/next/build/fs/smb/client/cifsfs.c:1270:18: error: incompatible functio=
n pointer types initializing 'int (*)(const struct mnt_idmap *, struct dent=
ry *, struct file_kattr *)' with an expression of type 'int (struct mnt_idm=
ap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-point=
er-types]
 1270 |         .fileattr_set =3D cifs_fileattr_set,
      |                         ^~~~~~~~~~~~~~~~~
2 errors generated.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 fs/ntfs/named_stream.c | 6 +++---
 fs/ntfs/stream.h       | 2 +-
 fs/smb/client/cifsfs.h | 2 +-
 fs/smb/client/ioctl.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
index d74bebf90966b..95a3c05f98211 100644
--- a/fs/ntfs/named_stream.c
+++ b/fs/ntfs/named_stream.c
@@ -553,7 +553,7 @@ int ntfs_stream_path_names(struct ntfs_volume *vol,
  *
  * Return: Referenced stream inode on success, or ERR_PTR() on failure.
  */
-struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
+struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 		struct inode *dir, __le16 *base_name, int base_len,
 		__le16 *stream_name, int stream_len)
 {
@@ -988,13 +988,13 @@ static ssize_t ntfs_stream_listxattr(struct dentry *d=
entry, char *buffer,
 }
=20
 #ifdef CONFIG_NTFS_FS_POSIX_ACL
-static struct posix_acl *ntfs_stream_get_acl(struct mnt_idmap *idmap,
+static struct posix_acl *ntfs_stream_get_acl(const struct mnt_idmap *idmap,
 		struct dentry *dentry, int type)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
=20
-static int ntfs_stream_set_acl(struct mnt_idmap *idmap,
+static int ntfs_stream_set_acl(const struct mnt_idmap *idmap,
 		struct dentry *dentry, struct posix_acl *acl, int type)
 {
 	return -EOPNOTSUPP;
diff --git a/fs/ntfs/stream.h b/fs/ntfs/stream.h
index 5cbf6e8f6b681..76b6c9cca5cc0 100644
--- a/fs/ntfs/stream.h
+++ b/fs/ntfs/stream.h
@@ -32,7 +32,7 @@ struct inode *ntfs_stream_lookup_inode_by_name(struct ino=
de *dir,
 		__le16 *name, int name_len);
 struct dentry *ntfs_lookup_stream(struct inode *dir, struct dentry *dentry,
 		const struct ntfs_stream_path *path);
-struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
+struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 		struct inode *dir, __le16 *base_name, int base_len,
 		__le16 *stream_name, int stream_len);
 int ntfs_unlink_named_stream(struct inode *dir, struct dentry *dentry);
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 7600467babb67..e54d3798eb2f7 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -91,7 +91,7 @@ extern const struct inode_operations cifs_namespace_inode=
_operations;
=20
 struct file_kattr;
 int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
-int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
+int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct file_kattr *fa);
=20
=20
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index af4664f5b1202..bb8808289a468 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -181,7 +181,7 @@ static int cifs_set_compression(unsigned int xid, struc=
t dentry *dentry,
 					    compression_state);
 }
=20
-int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
+int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct file_kattr *fa)
 {
 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry);
--=20
2.47.3


--wYytuotjRGy3pYJc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrM44oACgkQJNaLcl1U
h9Cw9wf/St+OkogMQAK8WC5mWFoBvECPesBeX1RrsSKgM1lCig+xXdpCm1YFNbcl
yxzbr5Etu6zWX0DWBah5ink3+8goi50+ZVEs0SmkdxO9COXcknKkjJytGgcXTPFF
1js1fjzFWej4KGpT1MOezmORbGYU3BZu16VeshDPu3bDSj5aX6UkRlFChoOPpiTh
vAjvkdwg27qTUDvn9XmndFIilG0IlRTBUd6Y1mlkhFumeVHvBkUSd6vrOi7O4lHD
u4rThSMsvCpdk46Zy7o8tZx+z9hi05S9lBK6Ve9sdyTgpR0MB1G9UfKewrdm659K
xQ55E+B2Cf9NglabCgVkvDLblEU7Rg==
=C+Px
-----END PGP SIGNATURE-----

--wYytuotjRGy3pYJc--
