From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Fri, 10 Jun 2016 17:16:49 +0200
Message-ID: <20160610171649.3e12b95c@aaptelpc>
References: <20160527194346.08416d79@aaptelpc>
	<20160609185027.7349f260@aaptelpc>
	<5759C326.5040508@fu-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pFooELJ0g+oLseyMZQtgxIz"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5759C326.5040508-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/pFooELJ0g+oLseyMZQtgxIz
Content-Type: multipart/mixed; boundary="MP_/xvJFk3kmpnS.V=uT+UaTC1M"

--MP_/xvJFk3kmpnS.V=uT+UaTC1M
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 9 Jun 2016 21:27:34 +0200 Marcus Hoffmann
<marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org> wrote:
> Hey Aur=C3=A9lien,
> with your script I can reproduce the bug locally now.

Good.

> I can mount the share (which is on a Windows 8.1 vm) with a Windows 7
> PC with the restricted user account. (Even in hard mode.)
> I can mount the share from Linux-cifs using the admin user but not the
> restricted user.

I've moved some things around. All of the prefix path components are
now checked for accessibility in cifs_do_mount(). This is more
robust and it lets us set the CIFS_MOUNT_USE_PREFIX_PATH flag earlier.

I've updated the cifs_root_iget() to use the prefix path when necessary
which should take care of the last case (hard mode).

Please test my latest patch (attached).

> (I noticed though that no user has access to the file in the shared
> dir. But this doesn't really matter for the test.)

Indeed.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/xvJFk3kmpnS.V=uT+UaTC1M
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-fs-cifs-make-share-unaccessible-at-root-level-mounta.patch

=46rom e858c28b7bf9b1c76c0a9703727c7bd02bf4a434 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Wed, 25 May 2016 19:59:09 +0200
Subject: [PATCH] fs/cifs: make share unaccessible at root level mountable

if, when mounting //HOST/share/sub/dir/foo we can query /sub/dir/foo but
not any of the path components above:

- store the /sub/dir/foo prefix in the cifs super_block info
- in the superblock, set root dentry to the subpath dentry (instead of
  the share root)
- set a flag in the superblock to remember it
- use prefixpath when building path from a dentry

fixes bso#8950

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |  2 ++
 fs/cifs/cifsfs.c     | 15 ++++++++++++++-
 fs/cifs/connect.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/dir.c        | 19 +++++++++++++++++--
 fs/cifs/inode.c      | 17 +++++++++++++++--
 5 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 3182273..02b9ac3 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -46,6 +46,7 @@
 #define CIFS_MOUNT_CIFS_BACKUPUID 0x200000 /* backup intent bit for a user=
 */
 #define CIFS_MOUNT_CIFS_BACKUPGID 0x400000 /* backup intent bit for a grou=
p */
 #define CIFS_MOUNT_MAP_SFM_CHR	0x800000 /* SFM/MAC mapping for illegal cha=
rs */
+#define CIFS_MOUNT_USE_PREFIX_PATH 0x1000000 /* make subpath with unaccess=
ible root mountable */
=20
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
@@ -67,5 +68,6 @@ struct cifs_sb_info {
 	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
+	char *prepath;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5d8b7ed..c75d80c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -649,6 +649,7 @@ cifs_get_root(struct smb_vol *vol, struct super_block *=
sb)
 		dentry =3D child;
 	} while (!IS_ERR(dentry));
 	kfree(full_path);
+
 	return dentry;
 }
=20
@@ -688,6 +689,14 @@ cifs_do_mount(struct file_system_type *fs_type,
 		goto out_cifs_sb;
 	}
=20
+	if (volume_info->prepath) {
+		cifs_sb->prepath =3D kstrdup(volume_info->prepath, GFP_KERNEL);
+		if (cifs_sb->prepath =3D=3D NULL) {
+			root =3D ERR_PTR(-ENOMEM);
+			goto out_cifs_sb;
+		}
+	}
+
 	cifs_setup_cifs_sb(volume_info, cifs_sb);
=20
 	rc =3D cifs_mount(cifs_sb, volume_info);
@@ -726,7 +735,11 @@ cifs_do_mount(struct file_system_type *fs_type,
 		sb->s_flags |=3D MS_ACTIVE;
 	}
=20
-	root =3D cifs_get_root(volume_info, sb);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) {
+		root =3D dget(sb->s_root);
+	} else {
+		root =3D cifs_get_root(volume_info, sb);
+	}
 	if (IS_ERR(root))
 		goto out_super;
=20
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 66736f5..b82d7b4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3481,6 +3481,42 @@ cifs_get_volume_info(char *mount_data, const char *d=
evname)
 	return volume_info;
 }
=20
+static int
+cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
+					unsigned int xid,
+					struct cifs_tcon *tcon,
+					struct cifs_sb_info *cifs_sb,
+					char *full_path)
+{
+	int rc;
+	char *s;
+	char sep, tmp;
+
+	sep =3D CIFS_DIR_SEP(cifs_sb);
+	s =3D full_path;
+
+	rc =3D server->ops->is_path_accessible(xid, tcon, cifs_sb, "");
+	while (rc =3D=3D 0) {
+		/* skip separators */
+		while (*s =3D=3D sep)
+			s++;
+		if (!*s)
+			break;
+
+		/* next separator */
+		while (*s && *s !=3D sep)
+			s++;
+
+		/* temporarily null-terminate the path at the end of
+		 * the current component */
+		tmp =3D *s;
+		*s =3D 0;
+		rc =3D server->ops->is_path_accessible(xid, tcon, cifs_sb, full_path);
+		*s =3D tmp;
+	}
+	return rc;
+}
+
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
@@ -3618,6 +3654,14 @@ remote_path_check:
 			kfree(full_path);
 			goto mount_fail_check;
 		}
+
+		rc =3D cifs_are_all_path_components_accessible(server, xid, tcon, cifs_s=
b, full_path);
+		if (rc !=3D 0) {
+			cifs_dbg(VFS, "cannot query directories between root and final path, "
+				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
+			cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_USE_PREFIX_PATH;
+			rc =3D 0;
+		}
 		kfree(full_path);
 	}
=20
@@ -3887,6 +3931,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
=20
 	bdi_destroy(&cifs_sb->bdi);
 	kfree(cifs_sb->mountdata);
+	if (cifs_sb->prepath) {
+		kfree(cifs_sb->prepath);
+	}
 	call_rcu(&cifs_sb->rcu, delayed_free);
 }
=20
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c3eb998..5374253 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -84,6 +84,7 @@ build_path_from_dentry(struct dentry *direntry)
 	struct dentry *temp;
 	int namelen;
 	int dfsplen;
+	int pplen =3D 0;
 	char *full_path;
 	char dirsep;
 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(direntry->d_sb);
@@ -95,8 +96,12 @@ build_path_from_dentry(struct dentry *direntry)
 		dfsplen =3D strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen =3D 0;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
+		pplen =3D cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
+
 cifs_bp_rename_retry:
-	namelen =3D dfsplen;
+	namelen =3D dfsplen + pplen;
 	seq =3D read_seqbegin(&rename_lock);
 	rcu_read_lock();
 	for (temp =3D direntry; !IS_ROOT(temp);) {
@@ -137,7 +142,7 @@ cifs_bp_rename_retry:
 		}
 	}
 	rcu_read_unlock();
-	if (namelen !=3D dfsplen || read_seqretry(&rename_lock, seq)) {
+	if (namelen !=3D dfsplen + pplen || read_seqretry(&rename_lock, seq)) {
 		cifs_dbg(FYI, "did not end path lookup where expected. namelen=3D%ddfspl=
en=3D%d\n",
 			 namelen, dfsplen);
 		/* presumably this is only possible if racing with a rename
@@ -153,6 +158,16 @@ cifs_bp_rename_retry:
 	   those safely to '/' if any are found in the middle of the prepath */
 	/* BB test paths to Windows with '/' in the midst of prepath */
=20
+	if (pplen) {
+		int i;
+		cifs_dbg(FYI, "using cifs_sb prepath <%s>\n", cifs_sb->prepath);
+		memcpy(full_path+dfsplen+1, cifs_sb->prepath, pplen-1);
+		full_path[dfsplen] =3D '\\';
+		for (i =3D 0; i < pplen-1; i++)
+			if (full_path[dfsplen+1+i] =3D=3D '/')
+				full_path[dfsplen+1+i] =3D CIFS_DIR_SEP(cifs_sb);
+	}
+
 	if (dfsplen) {
 		strncpy(full_path, tcon->treeName, dfsplen);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 514dadb..7c6edd7 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1002,10 +1002,21 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	struct inode *inode =3D NULL;
 	long rc;
 	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
+	char *path =3D NULL;
+	int len;
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) && cifs_sb->pr=
epath) {
+		len =3D strlen(cifs_sb->prepath);
+		path =3D kzalloc(len + 2 /* leading sep + null */, GFP_KERNEL);
+		path[0] =3D '/';
+		memcpy(path+1, cifs_sb->prepath, len);
+	} else {
+		path =3D kstrdup("", GFP_KERNEL);
+	}
=20
 	xid =3D get_xid();
 	if (tcon->unix_ext) {
-		rc =3D cifs_get_inode_info_unix(&inode, "", sb, xid);
+		rc =3D cifs_get_inode_info_unix(&inode, path, sb, xid);
 		/* some servers mistakenly claim POSIX support */
 		if (rc !=3D -EOPNOTSUPP)
 			goto iget_no_retry;
@@ -1013,7 +1024,8 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		tcon->unix_ext =3D false;
 	}
=20
-	rc =3D cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
+	convert_delimiter(path, CIFS_DIR_SEP(cifs_sb));
+	rc =3D cifs_get_inode_info(&inode, path, NULL, sb, xid, NULL);
=20
 iget_no_retry:
 	if (!inode) {
@@ -1042,6 +1054,7 @@ iget_no_retry:
 	}
=20
 out:
+	kfree(path);
 	/* can not call macro free_xid here since in a void func
 	 * TODO: This is no longer true
 	 */
--=20
2.1.4


--MP_/xvJFk3kmpnS.V=uT+UaTC1M--

--Sig_/pFooELJ0g+oLseyMZQtgxIz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXWtnjAAoJEDIGO5Hchq/8Sq4QAIcZSjpTT3vJEEXHJQ4e2rVd
f34yOiKtSERQPC74cD+U/mvLjaNHxU0q8+WmIJSZjAG5QToTMkN55aEzyYPCV8Qb
Akaa5RWJ1KSpeYPHQY+lO+/5RM2SQntlpc7veIIWyRBE1ltwtxbzNamaXOqysYQW
0m0G/GZpDgJIgnASCmsRDE0kHJFy74kf7gF99Fnz2AAjix2kKAc31xXnXsr5LlMC
jWmOUfIIRX176pOsNNpBWqzFTsEkimCkjEcVkiYxLD2/FrvDYK8lQCSEsMuLbDt1
EOlhikn85GfmsUviH4nPQn9p0TSMEUNVWWhxk8CfQj6cfm0bnDmooZekEtCDRPsq
paUIYbcUhydO8hTUHzn1NvAK3bz1GJkhxpji/ntZ+9eA2l8wlbEAyuR8p2balnel
8JatLuwVX25MTJ3kAzD/31QxL4HK6R7UfRgHGd5KxacjTj5pYNbxl28mZyTrjM7S
8Tq66j+oy08uAc9CzSkzC0pxyGrdse5hpZ6IjJBWvqI+rZDIYukkEw1g2BLytRxK
ytYsDqwboF8eKAmG4xMHuZ3mEqU8jEDuch7GNxcmyb327tFTl0zPzb9SWKNmoolh
YtAr3dopFBb05d1kNh33wAPg3NS/9k7Zp6fBfv0wPLz3IIPBWtg4zXwJVuG+/LvC
C1fqSulebkZlW4WGMkWJ
=qqUZ
-----END PGP SIGNATURE-----

--Sig_/pFooELJ0g+oLseyMZQtgxIz--
