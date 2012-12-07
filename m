From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: only link in -lrt to binaries that need it
Date: Fri,  7 Dec 2012 10:41:06 -0500
Message-ID: <1354894866-319-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=2E..which is really only mount.cifs.

Cc:  Bj=C3=B6rn Jacke <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am  | 2 +-
 configure.ac | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 73f756f..ff7a726 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,7 +4,7 @@ ACLOCAL_AMFLAGS =3D -I aclocal
 root_sbindir =3D $(ROOTSBINDIR)
 root_sbin_PROGRAMS =3D mount.cifs
 mount_cifs_SOURCES =3D mount.cifs.c mtab.c resolve_host.c util.c
-mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
+mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
=20
 man_MANS =3D mount.cifs.8
=20
diff --git a/configure.ac b/configure.ac
index 78acd43..b6791ab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -94,9 +94,10 @@ AC_CHECK_FUNCS(clock_gettime, [], [
       AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
 	AC_DEFINE(HAVE_CLOCK_GETTIME,1,
 		[Whether the clock_gettime func is there])
-      LIBS=3D"$LIBS -lrt"
+      RT_LDADD=3D"-lrt"
         ])
   ])
+AC_SUBST(RT_LDADD)
=20
 # Checks for header files.
 AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mnte=
nt.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h strin=
g.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h =
unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
--=20
1.7.11.7
