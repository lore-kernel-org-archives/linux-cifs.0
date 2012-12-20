From: Jeff Layton <jlayton@samba.org>
Subject: [PATCH v3 4/6] cifs-utils: add autoconf test for WBC_ID_TYPE_BOTH
Date: Thu, 20 Dec 2012 07:50:31 -0500
Message-ID: <1356007833-10893-5-git-send-email-jlayton@samba.org>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Cc: samba-technical@lists.samba.org
To: linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

WBC_ID_TYPE_BOTH is a new addition (in Samba 4.0 only). Add a test for
its presence. Because it's an enum, we have to jump through some extra
hoops here...

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 aclocal/idmap.m4 | 15 +++++++++++++++
 configure.ac     |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
index 70a0649..939a901 100644
--- a/aclocal/idmap.m4
+++ b/aclocal/idmap.m4
@@ -1,5 +1,6 @@
 dnl Check for wbclient package
 dnl
+
 AC_DEFUN([AC_TEST_WBCHL],[
 if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 	PKG_CHECK_MODULES(WBCLIENT, wbclient, , [
@@ -29,3 +30,17 @@ if test $enable_cifsacl != "no"; then
 			], [ ])
 fi
 ])
+
+AC_DEFUN([AC_TEST_WBC_IDMAP_BOTH],[
+	AC_MSG_CHECKING([whether WBC_ID_TYPE_BOTH enum value is defined])
+	AC_LANG_PUSH([C])
+	ac_wbc_save_CFLAGS="$CFLAGS"
+	CFLAGS="$CFLAGS $WBCLIENT_CFLAGS"
+	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <stdint.h>
+#include <stdbool.h>
+#include <wbclient.h>], [enum wbcIdType id = WBC_ID_TYPE_BOTH;])],
+			  AC_DEFINE(HAVE_WBC_ID_TYPE_BOTH, 1, [Does wbclient.h have a WBC_ID_TYPE_BOTH enum?])
+			  AC_MSG_RESULT([yes]), AC_MSG_RESULT([no]))
+	CFLAGS=$ac_wbc_save_CFLAGS
+	AC_LANG_POP([C])
+])
diff --git a/configure.ac b/configure.ac
index 9652ad2..209bff2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -197,6 +197,9 @@ fi
 # checks for wbclient.h and libwbclient.so library
 AC_TEST_WBCHL
 
+# test for presence of WBC_ID_TYPE_BOTH enum value
+AC_TEST_WBC_IDMAP_BOTH
+
 if test $enable_cifscreds != "no"; then
 	AC_CHECK_HEADERS([keyutils.h], , [
 
-- 
1.7.11.7
