From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: monotonic time for mount.cifs timeouts
Date: Tue, 24 Aug 2010 18:16:19 +0200
Message-ID: <E1OnwAo-008Rzd-Bd@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--H1spWtNR+x+ondvy
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

attached are patches to spot the clock_gettime function and to use that and=
 the
monotonic clock for timeout handling if possible.

If there are no objections, can you please apply them, Jeff?

Thanks
Bj=F6rn

--y0ulUmNC+osPPQO6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-autoconf-add-checks-for-clock_gettime.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 250d5b5df23d93ebed66a4c39bccf3a3614c54ad Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Bj=3DC3=3DB6rn=3D20Jacke?=3D <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Tue, 24 Aug 2010 09:39:32 +0200
Subject: [PATCH 1/2] autoconf: add checks for clock_gettime

---
 configure.ac |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index c7d420d..7f82cd6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -110,6 +110,16 @@ AC_FUNC_STRNLEN
 # check for required functions
 AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday inet_=
ntop memset realpath setenv strchr strcmp strdup strerror strncasecmp strnd=
up strpbrk strrchr strstr strtol strtoul tolower uname], , [AC_MSG_ERROR([n=
ecessary functions(s) not found])])
=20
+AC_CHECK_FUNCS(clock_gettime, [], [
+  AC_CHECK_LIB(rt, clock_gettime, [
+      AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
+	AC_DEFINE(HAVE_CLOCK_GETTIME,1,
+		[Whether the clock_gettime func is there])
+      LIBS=3D"$LIBS -lrt"
+        ])
+  ])
+
+
 # ugly, but I'm not sure how to check for functions in a library that's no=
t in $LIBS
 cu_saved_libs=3D$LIBS
 LIBS=3D"$LIBS $KRB5_LDADD"
--=20
1.7.1


--y0ulUmNC+osPPQO6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-mount.cifs-use-monotonic-time-for-timeouts.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 4e8d243b9b0a5eb7bf4619c4cddbd9d3a8f4eb2d Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Bj=3DC3=3DB6rn=3D20Jacke?=3D <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Tue, 24 Aug 2010 09:41:01 +0200
Subject: [PATCH 2/2] mount.cifs: use monotonic time for timeouts

this is especially important during the boot process, where the clock is of=
ten
being set initially and clock jumps are more common.
---
 mtab.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/mtab.c b/mtab.c
index de1aabd..64e7250 100644
--- a/mtab.c
+++ b/mtab.c
@@ -39,6 +39,7 @@
 #include <stdlib.h>
 #include <signal.h>
 #include "mount.h"
+#include "config.h"
=20
=20
 /* Updating mtab ----------------------------------------------*/
@@ -60,6 +61,22 @@ setlkw_timeout (int sig __attribute__((unused))) {
      /* nothing, fcntl will fail anyway */
 }
=20
+/* use monotonic time for timeouts */
+struct timeval
+mono_time(void) {
+	struct timeval ret;
+#if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
+	struct timespec ts;
+	if (clock_gettime(CLOCK_MONOTONIC, &ts) =3D=3D 0) {
+		ret.tv_sec =3D ts.tv_sec;
+		ret.tv_usec =3D ts.tv_nsec/1000;
+		return ret;
+	}
+#endif
+	gettimeofday(&ret,NULL);
+	return ret;
+}
+
 /* Remove lock file.  */
 void
 unlock_mtab (void) {
@@ -150,7 +167,7 @@ lock_mtab (void) {
 	}
 	close(i);
=20
-	gettimeofday(&maxtime, NULL);
+	maxtime =3D mono_time();
 	maxtime.tv_sec +=3D MOUNTLOCK_MAXTIME;
=20
 	waittime.tv_sec =3D 0;
@@ -177,7 +194,7 @@ lock_mtab (void) {
=20
 		if (lockfile_fd < 0) {
 			/* Strange... Maybe the file was just deleted? */
-			gettimeofday(&now, NULL);
+			now =3D mono_time();
 			if (errno =3D=3D ENOENT && now.tv_sec < maxtime.tv_sec) {
 				we_created_lockfile =3D 0;
 				continue;
@@ -199,7 +216,7 @@ lock_mtab (void) {
 			(void) unlink(linktargetfile);
 		} else {
 			/* Someone else made the link. Wait. */
-			gettimeofday(&now, NULL);
+			now =3D mono_time();
 			if (now.tv_sec < maxtime.tv_sec) {
 				alarm(maxtime.tv_sec - now.tv_sec);
 				if (fcntl (lockfile_fd, F_SETLKW, &flock) =3D=3D -1) {
--=20
1.7.1


--y0ulUmNC+osPPQO6--

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEAREDAAYFAkxz8FMACgkQdoo0s+hIejkuzgCgucit0Va7eMQl7khr8aEhRVGO
WCAAnjNlDj+ewhyCljw8e62IBoUfnuly
=BhDF
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
