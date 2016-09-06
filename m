From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] cifs/dir.c: use correct path separator
Date: Tue, 06 Sep 2016 20:04:28 +0200
Message-ID: <mps60q8sy4z.fsf@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain


Current code hardcodes the path separator to backslash. The loop after
it that switches the slashes direction only operates on the dfs prefix,
not the whole path. Use CIFS_DIR_SEP instead.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-fs-cifs-dir.c-use-correct-path-separator.patch
Content-Transfer-Encoding: quoted-printable

From=20cf6070073e817e48efc5ec72639eaeb848d6c002 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Tue, 6 Sep 2016 19:58:28 +0200
Subject: [PATCH] fs/cifs/dir.c: use correct path separator

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
=2D--
 fs/cifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4716c54..c753748 100644
=2D-- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -163,7 +163,7 @@ cifs_bp_rename_retry:
=20
 		cifs_dbg(FYI, "using cifs_sb prepath <%s>\n", cifs_sb->prepath);
 		memcpy(full_path+dfsplen+1, cifs_sb->prepath, pplen-1);
=2D		full_path[dfsplen] =3D '\\';
+		full_path[dfsplen] =3D CIFS_DIR_SEP(cifs_sb);
 		for (i =3D 0; i < pplen-1; i++)
 			if (full_path[dfsplen+1+i] =3D=3D '/')
 				full_path[dfsplen+1+i] =3D CIFS_DIR_SEP(cifs_sb);
=2D-=20
2.1.4


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


=2D-=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXzwUuAAoJEDIGO5Hchq/8makP/jndGrssINdjXP2nbOvx8Y0O
IvrGDbHVOAmOEdxcnkRZaAgmceB1Aq8T9WhZAcwpM19DSShN2oa5tjXoDXsFGcZZ
uhCn3F5RseOuui/N+4a3hOjWDD2SvrKX6D14V4gaF13GzCTIzbOovbDF4Enwabjx
zCQsFYOgzwKo2cwzOK8JYsKgwJ4Bj4lpkvMprAGcjhquC9+LjknE4Kru+vkWhqpU
6sD/BkjsCCXSzCmNWV8I/6d3hI/aX50wU9GkMEY+LsIxKVaAxzQu3UXQdOjIOVki
ABx2cdSza62wbpFlVq61LcwUB5UBewBn9znk9p8zmJKrlaM6x6ZMB1IEuhCAwf+u
GG34A+BFxfV/KMkWwzndi0kR5nZWGVZ4bbXDQOSmjk29DWpwaccOJRGpAo9M9Qto
wuxZLC6hRaPD7QixShCCY7KQhmE+VxxrMSgb6kA/j7IgEFG/1R6FzZDzJx175RVg
SqayPXH467UW56G3G1VSIrSgw4ohfgcr9WTAon/y3MtEq9Uo7aIHNvdbPSXXzttJ
foZo5wXrVnrJeVPtAyejcNIrbU0hVk19IElt02Iad19tuL+w283ziVupuW5gzzZE
hnTN7LrcQKFOXSvBugKZIKSdVVx5iWUbEWJcp8+7tIswqXXtpZAeMFeWO+ieemjN
egI7s5AyyIKEYVajGvR6
=Hz8h
-----END PGP SIGNATURE-----
--==-=-=--
