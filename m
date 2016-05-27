From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Fri, 27 May 2016 19:43:46 +0200
Message-ID: <20160527194346.08416d79@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l8.oHqAElhSqHcJFU.DBEGD"; protocol="application/pgp-signature"
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/l8.oHqAElhSqHcJFU.DBEGD
Content-Type: multipart/mixed; boundary="MP_/ZMuO4d3nwmQ8_KxI.Bxmxnm"

--MP_/ZMuO4d3nwmQ8_KxI.Bxmxnm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

I've come up with a new solution for the problem (attached). Between
the long, old and irrelevant comments on the bug report and the various
mailing-list threads it was getting hard to understand. So I've written
a summary which explains the problem in details and the 2 proposed
solutions.

http://diobla.info/stuff/bugs/bsc799133/

The new solution is basically switching to the old prefixpath system
when the normal method of querying intermediary path fails. It's much
more simpler.

*Any* feedback would be nice. I haven't noticed any problems so far but
I haven't run the xfs test suite (I still have to figure out how
to make it play nice with cifs...). I'm sending to samba-tech too in
hopes of reviews/comments.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/ZMuO4d3nwmQ8_KxI.Bxmxnm
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-fs-cifs-make-share-unaccessible-at-root-level-mounta.patch

=46rom 3e9af75bea055bf88a4700fced50a7ba38b39b6f Mon Sep 17 00:00:00 2001
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
 fs/cifs/cifsfs.c     | 19 +++++++++++++++++++
 fs/cifs/connect.c    |  3 +++
 fs/cifs/dir.c        | 19 +++++++++++++++++--
 4 files changed, 41 insertions(+), 2 deletions(-)

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
index 5d8b7ed..d1fc593 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -649,6 +649,17 @@ cifs_get_root(struct smb_vol *vol, struct super_block =
*sb)
 		dentry =3D child;
 	} while (!IS_ERR(dentry));
 	kfree(full_path);
+
+	if (IS_ERR(dentry) /* && path accessible */) {
+		/* we know the path is accessible (it is tested
+		 * earlier in cifs_do_mount()) so there must be a perm
+		 * problem */
+		cifs_dbg(VFS, "cannot query directories between root and final path, "
+			 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
+		cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_USE_PREFIX_PATH;
+		dentry =3D dget(sb->s_root);
+	}
+
 	return dentry;
 }
=20
@@ -688,6 +699,14 @@ cifs_do_mount(struct file_system_type *fs_type,
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
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 66736f5..90e57ee 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3887,6 +3887,9 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
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
--=20
2.1.4


--MP_/ZMuO4d3nwmQ8_KxI.Bxmxnm--

--Sig_/l8.oHqAElhSqHcJFU.DBEGD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXSIdUAAoJEDIGO5Hchq/8yvoP/2BbRspk5TEUPgwE5JDe+96E
+dxB3PidP1LqA9oCr2XkBoXMjGDyL7Ll4KYyoqN4rvnlsirGaLHQfGnuevo55YKv
rIEWtXo4DLRQRLYQ+TNO0wwLYOYb1DSw0hPwiUjaOII1D88K/tcgMdDk25x5I2Nf
Tn5STrM9jwIOrGlIYUDqDSnHOhEkNQSA2HI/eQKtJ2DPC3ULBmm03egeKRVr/Fr6
RqA8gBluUO5qaxwOdqgSpIIhj4X8ZbVwpYUR6fd/tsAOEsRvXnm6He2p7Ey88FM0
JaTesMf7MsvUJIuo3egCrlGu1J+fg4Ucf0TjaM3gNU9aqEJlUpiUAkciL2KpDzJD
LW6NtRwxloZ/Rk/KLX961u2IC45Hwlk9H+A+fFJZm9Wk6voIOWqnLhCAbqXXbB4X
zBgsJaRcqmSb8sID5ioOooYWKTvAEbY/Vd3qAyhKYq/tpZbGMG/bISd1E3tSQdJa
sQhSASS3ifpD6ka0paUXKilyQbqh+C6Ex/YzSi8HAyIkFAmpL1Z5pbspGxbbYUUI
K3Mq+jNqCb7pWetmvKSA89Zv7yY883SrO8onGqRYxMu8knmxi6ryVCgw0s6tdQxf
qwIQCQIhCij6CygOuiVA5MngtPVT5ALjxs7pqXvK98z4Cvw7yy+wuLhsdv6Ooz9k
OSNnqjOFMKkM/OL4mzpu
=TY2p
-----END PGP SIGNATURE-----

--Sig_/l8.oHqAElhSqHcJFU.DBEGD--
