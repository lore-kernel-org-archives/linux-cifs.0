From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] cifs-utils: add autoconf test to make sure that libwbclient is usable
Date: Sat,  2 Feb 2013 05:17:49 -0500
Message-ID: <1359800269-27502-1-git-send-email-jlayton@samba.org>
References: <CADT32eLPrepCyAV-KQrdWfnLN0QEaNRqbpd7GRYkGVKc10UUjw@mail.gmail.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLPrepCyAV-KQrdWfnLN0QEaNRqbpd7GRYkGVKc10UUjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The idmapwb plugin requires a usable wbcSidsToUnixIds() function. Check
to ensure that the wbclient library provides that symbol, and handle
it appropriately if it doesn't.

If someone were so inclined they probably could fix idmapwb to fall
back to the older mapping functions if that symbol doesn't exist,
but for now this patch just makes it refuse to build the plugin.

Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 aclocal/idmap.m4 | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
index 939a901..c5727f6 100644
--- a/aclocal/idmap.m4
+++ b/aclocal/idmap.m4
@@ -19,6 +19,26 @@ if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 			])
 fi
 
+if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
+	ac_wbc_save_LDFLAGS="$LDFLAGS"
+	LDFLAGS="$LDFLAGS $WBCLIENT_LIBS"
+	AC_CHECK_LIB(wbclient, wbcSidsToUnixIds, , [
+				if test "$enable_cifsidmap" = "yes"; then
+					AC_MSG_ERROR([wbclient library lacks wbcSidsToUnixIds().])
+				else
+					AC_MSG_WARN([wbclient library lacks wbcSidsToUnixIds(). Disabling cifs.idmap.])
+					enable_cifsidmap="no"
+				fi
+				if test "$enable_cifsacl" = "yes"; then
+					AC_MSG_ERROR([wbclient library lacks wbcSidsToUnixIds.])
+				else
+					AC_MSG_WARN([wbclient library lacks wbcSidsToUnixIds(). Disabling cifsacl tools.])
+					enable_cifsacl="no"
+				fi
+			])
+	LDFLAGS=$ac_wbc_save_LDFLAGS
+fi
+
 if test $enable_cifsacl != "no"; then
 	AC_CHECK_HEADERS([sys/xattr.h], , [
 				if test "$enable_cifsacl" = "yes"; then
-- 
1.7.11.7
