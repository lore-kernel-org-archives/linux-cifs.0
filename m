From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: silence unused parameter warning
Date: Sun, 13 Nov 2011 20:03:02 -0500
Message-ID: <1321232582-13298-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs.upcall.c: In function =E2=80=98cifs_krb5_principal_get_realm=E2=80=
=99:
cifs.upcall.c:80:57: warning: unused parameter =E2=80=98context=E2=80=99=
 [-Wunused-parameter]

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index de92092..51af37a 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -76,7 +76,7 @@ typedef enum _sectype {
  *
  */
=20
-static char *cifs_krb5_principal_get_realm(krb5_context context,
+static char *cifs_krb5_principal_get_realm(krb5_context context __attr=
ibute__ ((unused)),
 					   krb5_principal principal)
 {
 #ifdef HAVE_KRB5_PRINCIPAL_GET_REALM	/* Heimdal */
--=20
1.7.6.4
