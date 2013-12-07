From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH] autoconf: fix link of libwbclient
Date: Sat,  7 Dec 2013 09:00:38 -0500
Message-ID: <1386424838-31685-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's currently getting added to $LIBS and being linked into places that
we don't need it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 aclocal/idmap.m4 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
index c5727f6..3ccdae3 100644
--- a/aclocal/idmap.m4
+++ b/aclocal/idmap.m4
@@ -21,6 +21,7 @@ fi
 
 if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
 	ac_wbc_save_LDFLAGS="$LDFLAGS"
+	ac_wbc_save_LIBS="$LIBS"
 	LDFLAGS="$LDFLAGS $WBCLIENT_LIBS"
 	AC_CHECK_LIB(wbclient, wbcSidsToUnixIds, , [
 				if test "$enable_cifsidmap" = "yes"; then
@@ -37,6 +38,7 @@ if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
 				fi
 			])
 	LDFLAGS=$ac_wbc_save_LDFLAGS
+	LIBS=$ac_wbc_save_LIBS
 fi
 
 if test $enable_cifsacl != "no"; then
-- 
1.8.4.2
