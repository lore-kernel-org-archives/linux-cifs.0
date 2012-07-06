From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: remove bzero() redefinition from replace.h
Date: Fri,  6 Jul 2012 07:48:39 -0400
Message-ID: <1341575319-24524-1-git-send-email-jlayton@samba.org>
Cc: asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I borrowed replace.h from samba when I split off the package, and we
have a ton of definitions in there that we don't really need.  This is
one of them and it causes a warning when we build on RHEL5.

Reported-by: Andreas Schneider <asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 replace.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/replace.h b/replace.h
index ee4d618..a9fdf7e 100644
--- a/replace.h
+++ b/replace.h
@@ -269,10 +269,6 @@ int rep_ftruncate(int,off_t);
 int rep_initgroups(char *name, gid_t id);
 #endif
 
-#if !defined(HAVE_BZERO) && defined(HAVE_MEMSET)
-#define bzero(a,b) memset((a),'\0',(b))
-#endif
-
 #ifndef HAVE_DLERROR
 #define dlerror rep_dlerror
 char *rep_dlerror(void);
-- 
1.7.7.6
