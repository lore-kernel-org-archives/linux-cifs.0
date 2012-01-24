From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifscreds: build it by default
Date: Tue, 24 Jan 2012 08:34:39 -0500
Message-ID: <1327412079-5818-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...but either error out or disable it if keyutils.h isn't present.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8476f94..ebea5c1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -18,9 +18,9 @@ AC_ARG_ENABLE(cifsupcall,
 
 AC_ARG_ENABLE(cifscreds,
 	[AC_HELP_STRING([--enable-cifscreds],
-			[Create cifscreds utility @<:@default=no@:>@])],
+			[Create cifscreds utility @<:@default=yes@:>@])],
 	enable_cifscreds=$enableval,
-	enable_cifscreds="no")
+	enable_cifscreds="maybe")
 
 AC_ARG_ENABLE(cifsidmap,
 	[AC_HELP_STRING([--enable-cifsidmap],
@@ -152,8 +152,16 @@ fi
 # checks for wbclient.h and libwbclient.so library
 AC_TEST_WBCHL
 
-if test $enable_cifscreds = "yes"; then
-	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
+if test $enable_cifscreds != "no"; then
+	AC_CHECK_HEADERS([keyutils.h], , [
+
+				if test $enable_cifscreds = "yes"; then
+					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
+				else
+					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifscreds.])
+					enable_cifscreds="no"
+				fi
+			])
 fi
 
 
@@ -175,7 +183,7 @@ fi
 LIBS=$cu_saved_libs
 
 AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
-AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
+AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
 AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
 
-- 
1.7.7.5
