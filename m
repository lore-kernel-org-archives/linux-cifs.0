From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] setcifsacl: remove unused rc var from build_cmdline_aces
Date: Fri, 23 Sep 2011 12:52:00 -0400
Message-ID: <1316796720-7023-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=2E..and eliminate this build warning:

setcifsacl.c: In function =E2=80=98build_cmdline_aces=E2=80=99:
setcifsacl.c:582:9: warning: variable =E2=80=98rc=E2=80=99 set but not =
used [-Wunused-but-set-variable]

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index d0da34a..502c839 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -579,7 +579,7 @@ verify_ace_mask(char *maskstr, uint32_t *maskval)
 static struct cifs_ace **
 build_cmdline_aces(char **arrptr, int numcaces)
 {
-	int i, rc =3D 0;
+	int i;
 	char *acesid, *acetype, *aceflag, *acemask;
 	struct cifs_ace **cacesptr;
=20
@@ -598,41 +598,35 @@ build_cmdline_aces(char **arrptr, int numcaces)
=20
 		if (!acesid || !acetype || !aceflag || !acemask) {
 			printf("%s: Incomplete ACE: %s\n", __func__, arrptr[i]);
-			rc =3D 1;
 			goto build_cmdline_aces_ret;
 		}
=20
 		cacesptr[i] =3D malloc(sizeof(struct cifs_ace));
 		if (!cacesptr[i]) {
 			printf("%s: ACE alloc error %d\n", __func__, errno);
-			rc =3D errno;
 			goto build_cmdline_aces_ret;
 		}
=20
 		if (verify_ace_sid(acesid, &cacesptr[i]->sid)) {
 			printf("%s: Invalid SID: %s\n", __func__, arrptr[i]);
-			rc =3D 1;
 			goto build_cmdline_aces_ret;
 		}
=20
 		if (verify_ace_type(acetype, &cacesptr[i]->type)) {
 			printf("%s: Invalid ACE type: %s\n",
 					__func__, arrptr[i]);
-			rc =3D 1;
 			goto build_cmdline_aces_ret;
 		}
=20
 		if (verify_ace_flags(aceflag, &cacesptr[i]->flags)) {
 			printf("%s: Invalid ACE flag: %s\n",
 				__func__, arrptr[i]);
-			rc =3D 1;
 			goto build_cmdline_aces_ret;
 		}
=20
 		if (verify_ace_mask(acemask, &cacesptr[i]->access_req)) {
 			printf("%s: Invalid ACE mask: %s\n",
 				__func__, arrptr[i]);
-			rc =3D 1;
 			goto build_cmdline_aces_ret;
 		}
=20
--=20
1.7.6.2
