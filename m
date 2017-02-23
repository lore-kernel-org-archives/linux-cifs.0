From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH] replace.h: remove some stuff that just shouldn't be there
Date: Thu, 23 Feb 2017 18:44:08 -0500
Message-ID: <20170223234408.22882-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 replace.h | 69 ---------------------------------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/replace.h b/replace.h
index 03d293704a2e..6e45b236bd8d 100644
--- a/replace.h
+++ b/replace.h
@@ -119,75 +119,6 @@
 #include <stddef.h>
 #endif
 
-#ifndef HAVE_STRERROR
-extern char *sys_errlist[];
-#define strerror(i) sys_errlist[i]
-#endif
-
-#ifndef HAVE_STRDUP
-#define strdup rep_strdup
-char *rep_strdup(const char *s);
-#endif
-
-#ifndef HAVE_MEMMEM
-#define memmem rep_memmem
-void *rep_memmem(const void *haystack, size_t haystacklen,
-		 const void *needle, size_t needlelen);
-#endif
-
-#ifndef HAVE_MKTIME
-#define mktime rep_mktime
-/* prototype is in "system/time.h" */
-#endif
-
-#ifndef HAVE_TIMEGM
-#define timegm rep_timegm
-/* prototype is in "system/time.h" */
-#endif
-
-#ifndef HAVE_UTIME
-#define utime rep_utime
-/* prototype is in "system/time.h" */
-#endif
-
-#ifndef HAVE_UTIMES
-#define utimes rep_utimes
-/* prototype is in "system/time.h" */
-#endif
-
-#if !HAVE_DECL_ENVIRON
-#ifdef __APPLE__
-#include <crt_externs.h>
-#define environ (*_NSGetEnviron())
-#else
-extern char **environ;
-#endif
-#endif
-
-#ifndef HAVE_SETENV
-#define setenv rep_setenv
-int rep_setenv(const char *name, const char *value, int overwrite);
-#else
-#ifndef HAVE_SETENV_DECL
-int setenv(const char *name, const char *value, int overwrite);
-#endif
-#endif
-
-#ifndef HAVE_UNSETENV
-#define unsetenv rep_unsetenv
-int rep_unsetenv(const char *name);
-#endif
-
-#ifndef HAVE_SETEUID
-#define seteuid rep_seteuid
-int rep_seteuid(uid_t);
-#endif
-
-#ifndef HAVE_SETEGID
-#define setegid rep_setegid
-int rep_setegid(gid_t);
-#endif
-
 #if (defined(USE_SETRESUID) && !defined(HAVE_SETRESUID_DECL))
 /* stupid glibc */
 int setresuid(uid_t ruid, uid_t euid, uid_t suid);
-- 
2.9.3
