From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] autoconf: work around broken wbclient.h file
Date: Thu, 25 Aug 2011 16:31:03 -0400
Message-ID: <1314304263-2153-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some versions of wbclient.h have function declarations with bool type
args, but they don't include wbclient.h themselves. Make sure that
we can deal with that by telling the autoconf test to include stdbool.h
explicitly.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac |   59 +++++++++++++++++++++++++++++++--------------------------
 1 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2541f39..2607fb1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,33 @@ AC_PROG_CC
 AC_PROG_SED
 AC_GNU_SOURCE
 
+# Checks for typedefs, structures, and compiler characteristics.
+AC_HEADER_STDBOOL
+AC_TYPE_UID_T
+AC_TYPE_OFF_T
+AC_TYPE_PID_T
+AC_TYPE_SIZE_T
+AC_CHECK_TYPES([ptrdiff_t, ssize_t, uint32_t, uint8_t])
+
+# Checks for library functions.
+AC_FUNC_GETMNTENT
+AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
+AC_FUNC_MALLOC
+AC_FUNC_REALLOC
+AC_FUNC_STRNLEN
+
+# check for required functions
+AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday inet_ntop memset realpath setenv strchr strcmp strdup strerror strncasecmp strndup strpbrk strrchr strstr strtol strtoul tolower uname], , [AC_MSG_ERROR([necessary functions(s) not found])])
+
+AC_CHECK_FUNCS(clock_gettime, [], [
+  AC_CHECK_LIB(rt, clock_gettime, [
+      AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
+	AC_DEFINE(HAVE_CLOCK_GETTIME,1,
+		[Whether the clock_gettime func is there])
+      LIBS="$LIBS -lrt"
+        ])
+  ])
+
 # Checks for header files.
 AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
 
@@ -108,6 +135,11 @@ if test $enable_cifsacl != "no"; then
 					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling getcifsacl.])
 					enable_cifsacl="no"
 				fi
+			],
+			[AC_INCLUDES_DEFAULT]
+			[#ifdef HAVE_STDBOOL_H
+			    #include <stdbool.h>
+			    #endif
 			])
 fi
 if test $enable_cifsupcall != "no"; then
@@ -124,33 +156,6 @@ if test $enable_cifscreds = "yes"; then
 	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
 fi
 
-# Checks for typedefs, structures, and compiler characteristics.
-AC_HEADER_STDBOOL
-AC_TYPE_UID_T
-AC_TYPE_OFF_T
-AC_TYPE_PID_T
-AC_TYPE_SIZE_T
-AC_CHECK_TYPES([ptrdiff_t, ssize_t, uint32_t, uint8_t])
-
-# Checks for library functions.
-AC_FUNC_GETMNTENT
-AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
-AC_FUNC_MALLOC
-AC_FUNC_REALLOC
-AC_FUNC_STRNLEN
-
-# check for required functions
-AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday inet_ntop memset realpath setenv strchr strcmp strdup strerror strncasecmp strndup strpbrk strrchr strstr strtol strtoul tolower uname], , [AC_MSG_ERROR([necessary functions(s) not found])])
-
-AC_CHECK_FUNCS(clock_gettime, [], [
-  AC_CHECK_LIB(rt, clock_gettime, [
-      AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
-	AC_DEFINE(HAVE_CLOCK_GETTIME,1,
-		[Whether the clock_gettime func is there])
-      LIBS="$LIBS -lrt"
-        ])
-  ])
-
 
 # ugly, but I'm not sure how to check for functions in a library that's not in $LIBS
 cu_saved_libs=$LIBS
-- 
1.7.6
