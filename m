From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4] readdir cf_nlink initialization
Date: Thu, 19 Sep 2013 10:39:27 -0700
Message-ID: <523B36CF.5020700@samba.org>
References: <CAFneQccAzKRE1O31528S4T4rsHZ7Wn+acV6Cmr1+QAwd+JmNPg@mail.gmail.com> <20130919081808.7aa63e90@tlielax.poochiereds.net> <523B3358.2070802@samba.org>
Reply-To: jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Ix7JCBJMhFxh21cGTpFoUS0k2XaQHahjf"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <523B3358.2070802-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ix7JCBJMhFxh21cGTpFoUS0k2XaQHahjf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sigh, more comment fixup...

=46rom b575840809eb8fdad7c595202300414e25b7d286 Mon Sep 17 00:00:00 2001
From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date: Thu, 19 Sep 2013 17:22:00 -0700
Subject: Provide sane values for nlink

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/inode.c    | 45 +++++++++++++++++++++++++++++++++++++++------
 fs/cifs/readdir.c  |  3 +++
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 52ca861..750dbfa 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1253,6 +1253,7 @@ struct dfs_info3_param {
 #define CIFS_FATTR_DELETE_PENDING	0x2
 #define CIFS_FATTR_NEED_REVAL		0x4
 #define CIFS_FATTR_INO_COLLISION	0x8
+#define CIFS_FATTR_UNKNOWN_NLINK	0x10

 struct cifs_fattr {
 	u32		cf_flags;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 449b6cf..b2f4831 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -120,6 +120,33 @@ cifs_revalidate_cache(struct inode *inode, struct
cifs_fattr *fattr)
 	cifs_i->invalid_mapping =3D true;
 }

+/*
+ * copy nlink to the inode, unless it wasn't provided.  Provide
+ * sane values if we don't have an existing one and none was provided
+ */
+static void
+cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)=

+{
+	/*
+	 * if we're in a situation where we can't trust what we
+	 * got from the server (readdir, some non-unix cases)
+	 * fake reasonable values
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) {
+		/* only provide fake values on a new inode */
+		if (inode->i_state & I_NEW) {
+			if (fattr->cf_cifsattrs & ATTR_DIRECTORY)
+				set_nlink(inode, 2);
+			else
+				set_nlink(inode, 1);
+		}
+		return;
+	}
+
+	/* we trust the server, so update it */
+	set_nlink(inode, fattr->cf_nlink);
+}
+
 /* populate an inode with info from a cifs_fattr struct */
 void
 cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
@@ -134,7 +161,7 @@ cifs_fattr_to_inode(struct inode *inode, struct
cifs_fattr *fattr)
 	inode->i_mtime =3D fattr->cf_mtime;
 	inode->i_ctime =3D fattr->cf_ctime;
 	inode->i_rdev =3D fattr->cf_rdev;
-	set_nlink(inode, fattr->cf_nlink);
+	cifs_nlink_fattr_to_inode(inode, fattr);
 	inode->i_uid =3D fattr->cf_uid;
 	inode->i_gid =3D fattr->cf_gid;

@@ -541,6 +568,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
 	fattr->cf_bytes =3D le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime =3D le64_to_cpu(info->CreationTime);

+	fattr->cf_nlink =3D le32_to_cpu(info->NumberOfLinks);
 	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode =3D S_IFDIR | cifs_sb->mnt_dir_mode;
 		fattr->cf_dtype =3D DT_DIR;
@@ -548,7 +576,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
 		 * Server can return wrong NumberOfLinks value for directories
 		 * when Unix extensions are disabled - fake it.
 		 */
-		fattr->cf_nlink =3D 2;
+		if (!tcon->unix_ext)
+			fattr->cf_flags |=3D CIFS_FATTR_UNKNOWN_NLINK;
 	} else {
 		fattr->cf_mode =3D S_IFREG | cifs_sb->mnt_file_mode;
 		fattr->cf_dtype =3D DT_REG;
@@ -557,11 +586,15 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
 		if (fattr->cf_cifsattrs & ATTR_READONLY)
 			fattr->cf_mode &=3D ~(S_IWUGO);

-		fattr->cf_nlink =3D le32_to_cpu(info->NumberOfLinks);
-		if (fattr->cf_nlink < 1) {
-			cifs_dbg(1, "replacing bogus file nlink value %u\n",
+		/*
+		 * Don't accept zero nlink from non-unix servers unless
+		 * delete is pending.  Instead mark it as unknown.
+		 */
+		if ((fattr->cf_nlink < 1) && !tcon->unix_ext &&
+		    !info->DeletePending) {
+			cifs_dbg(1, "bogus file nlink value %u\n",
 				fattr->cf_nlink);
-			fattr->cf_nlink =3D 1;
+			fattr->cf_flags |=3D CIFS_FATTR_UNKNOWN_NLINK;
 		}
 	}

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 69d2c82..b1f67dc 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -177,6 +177,9 @@ cifs_fill_common_info(struct cifs_fattr *fattr,
struct cifs_sb_info *cifs_sb)
 		fattr->cf_dtype =3D DT_REG;
 	}

+	/* non-unix readdir doesn't provide nlink */
+	fattr->cf_flags |=3D CIFS_FATTR_UNKNOWN_NLINK;
+
 	if (fattr->cf_cifsattrs & ATTR_READONLY)
 		fattr->cf_mode &=3D ~S_IWUGO;

--=20
1.8.1.4



--Ix7JCBJMhFxh21cGTpFoUS0k2XaQHahjf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI7NtAACgkQS1UwptheLJf45QCgwph9a6SpEn0OXKlNze4Bsnnm
2aEAn31RHdr7IrkeoW8IynGwBD45sBgH
=zoro
-----END PGP SIGNATURE-----

--Ix7JCBJMhFxh21cGTpFoUS0k2XaQHahjf--
