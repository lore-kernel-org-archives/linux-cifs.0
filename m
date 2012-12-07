From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] autoconf: enable full RELRO in cifs-utils binaries
Date: Fri,  7 Dec 2012 10:40:25 -0500
Message-ID: <1354894825-32726-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is safer since it also protects the GOT from getting clobbered.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index d97c51b..78acd43 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,7 +114,7 @@ fi
 AC_SUBST([PIE_CFLAGS])
 
 if test $enable_relro != "no"; then
-	RELRO_CFLAGS="-Wl,-z,relro"
+	RELRO_CFLAGS="-Wl,-z,relro,-z,now"
 else
 	RELRO_CFLAGS=""
 fi
-- 
1.7.11.7
