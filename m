From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: allow specifying rootsbindir at configure time
Date: Wed,  8 Feb 2012 12:02:59 -0500
Message-ID: <1328720579-31585-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...via the $ROOTSBINDIR environment variable, and AC_ARG_VAR macro.
The default is to use /sbin for this value, which only currently
affects the installation location of mount.cifs.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am  |    2 +-
 configure.ac |   10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 6182965..924c99e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 AM_CFLAGS = -Wall -Wextra
 ACLOCAL_AMFLAGS = -I aclocal
 
-root_sbindir = "/sbin"
+root_sbindir = $(ROOTSBINDIR)
 root_sbin_PROGRAMS = mount.cifs
 mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
 mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
diff --git a/configure.ac b/configure.ac
index 4c715ab..02b1ef2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -9,7 +9,7 @@ AC_CONFIG_MACRO_DIR(aclocal)
 
 AM_INIT_AUTOMAKE
 
-# "with" options
+# "enable" options
 AC_ARG_ENABLE(cifsupcall,
 	[AC_HELP_STRING([--enable-cifsupcall],
 			[Create cifs.upcall binary @<:@default=yes@:>@])],
@@ -34,6 +34,14 @@ AC_ARG_ENABLE(cifsacl,
 	enable_cifsacl=$enableval,
 	enable_cifsacl="maybe")
 
+# check for ROOTSBINDIR environment var
+if test -z $ROOTSBINDIR; then
+	ROOTSBINDIR="/sbin"
+	export ROOTSBINDIR
+fi
+
+AC_ARG_VAR(ROOTSBINDIR, [Location where files ordinarily under /sbin should be installed. Note: unaffected by --prefix. @<:@default=/sbin@:>@])
+
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_SED
-- 
1.7.7.6
