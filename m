From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 02/12] cifscreds: add unused attribute to argv parm in cifscreds_clearall
Date: Thu, 15 Dec 2011 13:12:06 -0500
Message-ID: <1323972736-15804-3-git-send-email-jlayton@samba.org>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323972736-15804-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=2E..to eliminate this warning:

cifscreds.c: In function =E2=80=98cifscreds_clearall=E2=80=99:
cifscreds.c:422:47: warning: unused parameter =E2=80=98argv=E2=80=99

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index f21a47f..d771056 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -419,7 +419,7 @@ static int cifscreds_clear(int argc, char *argv[])
 }
=20
 /* clearall command handler */
-static int cifscreds_clearall(int argc, char *argv[])
+static int cifscreds_clearall(int argc, char *argv[] __attribute__ ((u=
nused)))
 {
 	key_serial_t key;
 	int count =3D 0, errors =3D 0;
--=20
1.7.1
