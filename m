From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 1/3] aclocal: fix typo in idmap.m4
Date: Mon, 22 Aug 2016 08:29:20 -0400
Message-ID: <1471868962-7312-2-git-send-email-jlayton@samba.org>
References: <1471868962-7312-1-git-send-email-jlayton@samba.org>
Cc: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471868962-7312-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We really don't want to do the same check twice.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 aclocal/idmap.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
index 3ccdae3ab968..4e16a46568a1 100644
--- a/aclocal/idmap.m4
+++ b/aclocal/idmap.m4
@@ -19,7 +19,7 @@ if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 			])
 fi
 
-if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
+if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 	ac_wbc_save_LDFLAGS="$LDFLAGS"
 	ac_wbc_save_LIBS="$LIBS"
 	LDFLAGS="$LDFLAGS $WBCLIENT_LIBS"
-- 
2.7.4
