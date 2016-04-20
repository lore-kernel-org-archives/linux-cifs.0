From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] Add full_path_type arg to cifs_build_path_to_root()
Date: Wed, 20 Apr 2016 18:16:34 +0200
Message-ID: <20160420181634.1a9ed866@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qUxejVNvsuHLmaumA4ueifZ"; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/qUxejVNvsuHLmaumA4ueifZ
Content-Type: multipart/mixed; boundary="MP_/3mn5Zsfe6EUWXx1xChgCGLI"

--MP_/3mn5Zsfe6EUWXx1xChgCGLI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

When cifs_get_root() calls cifs_build_path_to_root(), it expects a full
path from the root, even in the presence of a DFS link.

e.g. in the case of a DFS link like

    //A/shareA/link -> //B/shareB/sub/dir/

When mounting shareA and doing a "cd link", cifs_get_root() was getting

    "//B/shareB//sub/dir"

Instead of

    "/sub/dir"

Resulting in

    sh: cd: link: No such file or directory

When the DFS link points to a share without a sub-dir suffix
(e.g. //A/shareA/link -> //B/shareB/) cifs_build_path_to_root() returns
an empty string which seems inconsistent. I would expect it have the
same behaviour as when there is a sub-dir and prefix the whole DFS UNC
path (it returns "" where I would expect "//B/shareB/"). This might be
a bug? I will try to return the expected path to see what happens.

I would like to know what you think.

There are 2 ways to fix this:
- never prefix an UNC path, even when using a DFS link i.e. remove all
  code dealing with DFS from cifs_build_path_to_root)
- add a new arg to decide the behaviour of cifs_build_path_to_root().

The attached patch implements the second solution and fixes the problem.
- lets the caller of cifs_build_path_to_root() decide the behaviour via
  a new argument.
- make cifs_get_root() always use a simple path.
- keep old behaviour on the other code paths (only one, in
  cifs_do_mount)

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/3mn5Zsfe6EUWXx1xChgCGLI
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-fs-cifs-Add-full_path_type-enum.patch

=46rom 3f877b42d8d2850b4c384e0c394dc7b71fca491b Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Wed, 20 Apr 2016 16:32:46 +0200
Subject: [PATCH 1/2] fs/cifs: Add full_path_type enum

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsglob.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f2cc0b3..2b5b796 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1644,4 +1644,10 @@ extern struct smb_version_values smb302_values;
 #define ALT_SMB311_VERSION_STRING "3.11"
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
+
+enum full_path_type {
+	CIFS_NO_PREFIX,
+	CIFS_WITH_DFS_UNC_PREFIX,
+};
+
 #endif	/* _CIFS_GLOB_H */
--=20
2.1.4


--MP_/3mn5Zsfe6EUWXx1xChgCGLI
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0002-fs-cifs-Add-full_path_type-arg-to-cifs_build_path_to.patch

=46rom 1caea1e53763df316b6c7b4cc9dc7b54c3f3300e Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Wed, 20 Apr 2016 16:34:01 +0200
Subject: [PATCH 2/2] fs/cifs: Add full_path_type arg to
 cifs_build_path_to_root()

Only add the server prefix in the case of a DFS link when explicitely
asked.

This function is called from:
- cifs_mount()
- cifs_get_root()

The later expects a full path from the root, even in the presence of a
DFS link.

e.g. in the case of a DFS link like

    //A/shareA/link -> //B/shareB/sub/dir/

When doing a "cd link", cifs_get_root() was getting

    "//B/shareB//sub/dir"

Instead of

    "/sub/dir"

Resulting in

    sh: cd: link: No such file or directory

This commit
- lets the caller of cifs_build_path_to_root() decide the behaviour via
  a new argument.
- make cifs_get_root() always use a simple path.

Thanks to Josef Cejka <jcejka-IBi9RG/b67k@public.gmane.org> for finding the bug&fix.

Reported-by: Fons Jongh <fons.dejongh-/y5eVf3Am6FByuSxxbvQtw@public.gmane.org>
Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsfs.c    | 3 ++-
 fs/cifs/cifsproto.h | 3 ++-
 fs/cifs/connect.c   | 2 +-
 fs/cifs/dir.c       | 6 ++++--
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8920156..d56a5ed 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -607,7 +607,8 @@ cifs_get_root(struct smb_vol *vol, struct super_block *=
sb)
 	char sep;
=20
 	full_path =3D cifs_build_path_to_root(vol, cifs_sb,
-					    cifs_sb_master_tcon(cifs_sb));
+					    cifs_sb_master_tcon(cifs_sb), CIFS_NO_PREFIX);
+
 	if (full_path =3D=3D NULL)
 		return ERR_PTR(-ENOMEM);
=20
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index eed7ff50..f6a0902 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -63,7 +63,8 @@ extern void exit_cifs_idmap(void);
 extern char *build_path_from_dentry(struct dentry *);
 extern char *cifs_build_path_to_root(struct smb_vol *vol,
 				     struct cifs_sb_info *cifs_sb,
-				     struct cifs_tcon *tcon);
+				     struct cifs_tcon *tcon,
+	                             enum full_path_type);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6f62ac8..b054218 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3660,7 +3660,7 @@ remote_path_check:
 		/*
 		 * cifs_build_path_to_root works only when we have a valid tcon
 		 */
-		full_path =3D cifs_build_path_to_root(volume_info, cifs_sb, tcon);
+		full_path =3D cifs_build_path_to_root(volume_info, cifs_sb, tcon, CIFS_S=
ERVER_PREFIX);
 		if (full_path =3D=3D NULL) {
 			rc =3D -ENOMEM;
 			goto mount_fail_check;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c3eb998..b5fe596 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -47,7 +47,7 @@ renew_parental_timestamps(struct dentry *direntry)
=20
 char *
 cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
-			struct cifs_tcon *tcon)
+			struct cifs_tcon *tcon, enum full_path_type prefix)
 {
 	int pplen =3D vol->prepath ? strlen(vol->prepath) + 1 : 0;
 	int dfsplen;
@@ -59,7 +59,8 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_=
sb_info *cifs_sb,
 		return full_path;
 	}
=20
-	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+
+	if (prefix =3D=3D CIFS_WITH_DFS_UNC_PREFIX && (tcon->Flags & SMB_SHARE_IS=
_IN_DFS))
 		dfsplen =3D strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
 		dfsplen =3D 0;
@@ -68,6 +69,7 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_=
sb_info *cifs_sb,
 	if (full_path =3D=3D NULL)
 		return full_path;
=20
+
 	if (dfsplen)
 		strncpy(full_path, tcon->treeName, dfsplen);
 	full_path[dfsplen] =3D CIFS_DIR_SEP(cifs_sb);
--=20
2.1.4


--MP_/3mn5Zsfe6EUWXx1xChgCGLI--

--Sig_/qUxejVNvsuHLmaumA4ueifZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXF6tpAAoJEDIGO5Hchq/8B5MP/2TexO4qDLBNmXiDW0s/0g3s
cycqoKFUdH1p8TuEcOOsbFOqY3wwjUFTChrj7kogb4Pxi7lhzgqEKywFwfVk9wmy
RHJ9E3AmLaxYM90FqGYqdq8rPCZBIORVupU1wV9P9T0zxcphAKZxhYvtJMSMhvXc
kpzhIQWOI3Mx/dmOv4nyu3A05HPhXqQrbwLDCqphsgGExO25w3MCbV9f5BBgAR/Z
r/QhMvirlCclCE4Ikj59oEw+YWx4TQJHWzwkj5uH/18jrjanCaCwQY/1mD7aenIE
iKpG6e3m8THReTTyFbBK2npdXtWdz2270aNR4RFSdKDqPwiqAIUNF16u6wGLspIn
MHWCU29SpZYgWj8/+P6t1Vh+AeONbBkDAeobfOoEVXIUV4iOpxeJZ5BBIgi43E6f
5UoMqpv2ji+yyHh6bMh+lTweXgbPuTZ6Kqh9VpoljDwGsyLktRVT0xmi02FALhEp
+JXIufN/LCQFJXO7a28ege9QkVpcK1DYzRKfRZO3J4+Anf8s9e4U2z0PKWpUfUuj
zMl2Is3GE5IrXjK2QBpN45L0x/bjqmiXk1oHctCy0IOc3UF/2rwoNt4sQh1hOKVw
Nnu/MqOrz2EHRkP7CE+SZ7VYj1lconD2SGEPWfNTwH+teQgU7lgSv/Nfennas5PR
cP7ZHqVzUzNndMJYVw4n
=QQOa
-----END PGP SIGNATURE-----

--Sig_/qUxejVNvsuHLmaumA4ueifZ--
