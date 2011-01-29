From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: fix two compiler warning about uninitialized vars
Date: Sat, 29 Jan 2011 07:03:02 -0500
Message-ID: <1296302582-18953-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fs/cifs/link.c: In function =E2=80=98symlink_hash=E2=80=99:
fs/cifs/link.c:58:3: warning: =E2=80=98rc=E2=80=99 may be used uninitia=
lized in this
function [-Wuninitialized]

fs/cifs/smbencrypt.c: In function =E2=80=98mdfour=E2=80=99:
fs/cifs/smbencrypt.c:61:3: warning: =E2=80=98rc=E2=80=99 may be used un=
initialized in this
function [-Wuninitialized]

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/link.c       |    3 ++-
 fs/cifs/smbencrypt.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 02cd60a..e8804d3 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -55,8 +55,9 @@ symlink_hash(unsigned int link_len, const char *link_=
str, u8 *md5_hash)
=20
 	md5 =3D crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(md5)) {
+		rc =3D PTR_ERR(md5);
 		cERROR(1, "%s: Crypto md5 allocation error %d\n", __func__, rc);
-		return PTR_ERR(md5);
+		return rc;
 	}
 	size =3D sizeof(struct shash_desc) + crypto_shash_descsize(md5);
 	sdescmd5 =3D kmalloc(size, GFP_KERNEL);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index b5450e9..b5041c8 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -58,8 +58,9 @@ mdfour(unsigned char *md4_hash, unsigned char *link_s=
tr, int link_len)
=20
 	md4 =3D crypto_alloc_shash("md4", 0, 0);
 	if (IS_ERR(md4)) {
+		rc =3D PTR_ERR(md4);
 		cERROR(1, "%s: Crypto md4 allocation error %d\n", __func__, rc);
-		return PTR_ERR(md4);
+		return rc;
 	}
 	size =3D sizeof(struct shash_desc) + crypto_shash_descsize(md4);
 	sdescmd4 =3D kmalloc(size, GFP_KERNEL);
--=20
1.7.3.4
