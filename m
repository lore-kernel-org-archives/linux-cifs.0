From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH][cifs-utils] setcifsacl: fix bad bit-shift in raw_str_to_sid
Date: Tue,  8 Oct 2013 21:09:39 -0400
Message-ID: <1381280979-18571-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A Coverity scan turned up this warning:

1. cifs-utils-6.2/setcifsacl.c:578:result_independent_of_operands =E2=80=
=93 "(x & 0xff0000000000ULL) >> 48" is 0 regardless of the values of it=
s operands. This occurs as the operand of assignment.

=2E..which is entirely true. That shift should be 40 bits, not 48.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index ce708eb..7eeeaa6 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -575,7 +575,7 @@ raw_str_to_sid(const char *str, struct cifs_sid *cs=
id)
 	csid->authority[3] =3D (x & 0x000000ff0000ULL) >> 16;
 	csid->authority[2] =3D (x & 0x0000ff000000ULL) >> 24;
 	csid->authority[1] =3D (x & 0x00ff00000000ULL) >> 32;
-	csid->authority[0] =3D (x & 0xff0000000000ULL) >> 48;
+	csid->authority[0] =3D (x & 0xff0000000000ULL) >> 40;
=20
 	/* now read the the subauthorities and store as __le32 vals */
 	p =3D q + 1;
--=20
1.8.3.1
