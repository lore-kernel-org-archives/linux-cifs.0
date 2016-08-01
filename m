From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Add full_path_type arg to cifs_build_path_to_root()
Date: Mon, 1 Aug 2016 14:32:04 +0200
Message-ID: <20160801143204.7377b5a4@aaptelpc>
References: <20160420181634.1a9ed866@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/79JDaEQHjMsqgyAmYG_kC=7"; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160420181634.1a9ed866@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/79JDaEQHjMsqgyAmYG_kC=7
Content-Type: multipart/mixed; boundary="MP_/TCtAzio.pbwq1CUgJjYuODK"

--MP_/TCtAzio.pbwq1CUgJjYuODK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 20 Apr 2016 18:16:34 +0200 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
wrote:
> There are 2 ways to fix this:
> - never prefix an UNC path, even when using a DFS link i.e. remove all
>   code dealing with DFS from cifs_build_path_to_root)
> - add a new arg to decide the behaviour of cifs_build_path_to_root().

We have 2 customers reporting a bug involving this problem
internally at SUSE. I'm letting you know the first solution (patch
attached) will be in the next update of SUSE (SLE) kernels.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/TCtAzio.pbwq1CUgJjYuODK
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-fs-cifs-remove-DFS-handling-from-cifs_build_path_to_.patch

=46rom df54ca09437a11438e1ec880c80c92e93ba98d71 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Tue, 26 Apr 2016 17:59:06 +0200
Subject: [PATCH] fs/cifs: remove DFS handling from cifs_build_path_to_root()

This function is called from:
    - cifs_mount()
    - cifs_get_root()

The later expects a full path from the root, even in the presence of
a DFS link.

e.g. in the case of a DFS link like

    //A/shareA/link -> //B/shareB/sub/dir/

When doing a "cd link", cifs_get_root() was getting

    "//B/shareB//sub/dir"

Instead of

    "/sub/dir"

Resulting in

    sh: cd: link: No such file or directory

Thanks to Josef Cejka <jcejka-IBi9RG/b67k@public.gmane.org> for finding the bug&fix.

Reported-by: Fons Jongh <fons.dejongh-/y5eVf3Am6FByuSxxbvQtw@public.gmane.org>
Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/dir.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fb0903f..05f7480 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -49,31 +49,16 @@ char *
 cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			struct cifs_tcon *tcon)
 {
-	int pplen =3D vol->prepath ? strlen(vol->prepath) + 1 : 0;
-	int dfsplen;
+	int pplen =3D vol->prepath ? strlen(vol->prepath) : 0;
 	char *full_path =3D NULL;
=20
-	/* if no prefix path, simply set path to the root of share to "" */
-	if (pplen =3D=3D 0) {
-		full_path =3D kzalloc(1, GFP_KERNEL);
-		return full_path;
-	}
-
-	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
-		dfsplen =3D strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
-	else
-		dfsplen =3D 0;
-
-	full_path =3D kmalloc(dfsplen + pplen + 1, GFP_KERNEL);
+	full_path =3D kmalloc(pplen + 1, GFP_KERNEL);
 	if (full_path =3D=3D NULL)
 		return full_path;
=20
-	if (dfsplen)
-		strncpy(full_path, tcon->treeName, dfsplen);
-	full_path[dfsplen] =3D CIFS_DIR_SEP(cifs_sb);
-	strncpy(full_path + dfsplen + 1, vol->prepath, pplen);
+	strncpy(full_path, vol->prepath, pplen);
 	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
-	full_path[dfsplen + pplen] =3D 0; /* add trailing null */
+	full_path[pplen] =3D 0; /* add trailing null */
 	return full_path;
 }
=20
--=20
2.1.4


--MP_/TCtAzio.pbwq1CUgJjYuODK--

--Sig_/79JDaEQHjMsqgyAmYG_kC=7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXn0FGAAoJEDIGO5Hchq/8IpwP/jjPHKTN05gmqFTbuvDocv4N
Pul0hKsRnTvhrltOUmKRFSgKqCosQd3+ylZKwnAMG5XwAWZDsz3pkDR37zyW3cHc
yNtzKnecxU3/lfxNLu0sheRLYB37nXvHb3b7wcx/69sAq5BMyN3vJvS5zQTj4khb
9fq/lfVDaDRvGg8E17Zg4XWWYKmI/ozUrMdU8JvWwIJBHn7plx6NdoP6FjYl7b0d
uJZB/B6Lrg/mryNeRmF9JNt7FdNpejmDFpTrptcJVweW95fcEpXaIg7aUYl1oaVF
E/+PdGWxFbMGqe5WF/GOW741Xxg/Job7O1s3GWEa0hg/tsHZSTZ+GRAQbx78Q28f
XIiPWH1xsO+bT0hQpofV4yoy3N56BX/iIHZ2VDwEgJ20GjuF3JPq8Gzldm3SwRdn
DdyXHAdw6kMwLNxO+fb+VushZwP2i6VKEccgDVA5JPwO3miTGWnbYqelOcqCmfYG
FknRCecitKFxlvCBJybwYZg4qTRfjAtUEMdH+NLflTTcs+cDItMh+4eTeYunAMLD
eeod3OQ/adyAFSE7vmYaJB1/wgiE8ERbHR2CYBfTd/OV52Bx16/gm8dquXAWT21n
ADEFT4+zjcSGmDbypuLN3vzUtFVZNO1QobWh4ozEW3dCyB2VQ/+jHOf7/QlKx8xj
SWXK6AJWq+Y05w9BFq23
=Er0d
-----END PGP SIGNATURE-----

--Sig_/79JDaEQHjMsqgyAmYG_kC=7--
