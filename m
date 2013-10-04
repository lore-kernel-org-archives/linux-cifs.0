From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH][cifs-utils] autoconf: update configure.ac a'la autoupdate
Date: Fri,  4 Oct 2013 07:18:15 -0400
Message-ID: <1380885495-17897-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/configure.ac b/configure.ac
index c69ede4..e9eb162 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 #                                               -*- Autoconf -*-
 # Process this file with autoconf to produce a configure script.
 
-AC_INIT([cifs-utils], [6.1.1], [linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org], [cifs-utils], [https://wiki.samba.org/index.php/LinuxCIFS_utils])
+AC_INIT([cifs-utils],[6.1.1],[linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org],[cifs-utils],[https://wiki.samba.org/index.php/LinuxCIFS_utils])
 AC_CONFIG_SRCDIR([replace.h])
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_FILES([Makefile contrib/Makefile contrib/request-key.d/Makefile])
@@ -11,51 +11,43 @@ AM_INIT_AUTOMAKE
 
 # "enable" options
 AC_ARG_ENABLE(pie,
-	[AC_HELP_STRING([--enable-pie],
-			[Produce position independent executables @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-pie],[Produce position independent executables @<:@default=yes@:>@])],
 	enable_pie=$enableval,
 	enable_pie="maybe")
 
 AC_ARG_ENABLE(relro,
-	[AC_HELP_STRING([--enable-relro],
-			[Enable relocations read-only support @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-relro],[Enable relocations read-only support @<:@default=yes@:>@])],
 	enable_relro=$enableval,
 	enable_relro="maybe")
 
 AC_ARG_ENABLE(cifsupcall,
-	[AC_HELP_STRING([--enable-cifsupcall],
-			[Create cifs.upcall binary @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-cifsupcall],[Create cifs.upcall binary @<:@default=yes@:>@])],
 	enable_cifsupcall=$enableval,
 	enable_cifsupcall="maybe")
 
 AC_ARG_ENABLE(cifscreds,
-	[AC_HELP_STRING([--enable-cifscreds],
-			[Create cifscreds utility @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-cifscreds],[Create cifscreds utility @<:@default=yes@:>@])],
 	enable_cifscreds=$enableval,
 	enable_cifscreds="maybe")
 
 AC_ARG_ENABLE(cifsidmap,
-	[AC_HELP_STRING([--enable-cifsidmap],
-			[Create cifs.idmap binary @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-cifsidmap],[Create cifs.idmap binary @<:@default=yes@:>@])],
 	enable_cifsidmap=$enableval,
 	enable_cifsidmap="maybe")
 
 AC_ARG_ENABLE(cifsacl,
-	[AC_HELP_STRING([--enable-cifsacl],
-			[Create get/set cifsacl binary @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-cifsacl],[Create get/set cifsacl binary @<:@default=yes@:>@])],
 	enable_cifsacl=$enableval,
 	enable_cifsacl="maybe")
 
 AC_ARG_ENABLE(systemd,
-	[AC_HELP_STRING([--enable-systemd],
-			[Enable systemd specific behavior for mount.cifs @<:@default=yes@:>@])],
+	[AS_HELP_STRING([--enable-systemd],[Enable systemd specific behavior for mount.cifs @<:@default=yes@:>@])],
 	enable_systemd=$enableval,
 	enable_systemd="maybe")
 
 # "with" options
 AC_ARG_WITH(idmap-plugin,
-	[AC_HELP_STRING([--with-idmap-plugin=/path/to/plugin],
-			[Define the path to the plugin that the idmapping infrastructure should use @<:@default=/etc/cifs-utils/idmap-plugin@:>@])],
+	[AS_HELP_STRING([--with-idmap-plugin=/path/to/plugin],[Define the path to the plugin that the idmapping infrastructure should use @<:@default=/etc/cifs-utils/idmap-plugin@:>@])],
 	pluginpath=$withval,
 	pluginpath="/etc/cifs-utils/idmap-plugin")
 AC_DEFINE_UNQUOTED(IDMAP_PLUGIN_PATH, "$pluginpath", [Location of plugin that ID mapping infrastructure should use. (usually a symlink to real plugin)])
@@ -71,7 +63,7 @@ AC_ARG_VAR(ROOTSBINDIR, [Location where files ordinarily under /sbin should be i
 
 # Checks for programs.
 AC_PROG_CC
-AC_GNU_SOURCE
+AC_USE_SYSTEM_EXTENSIONS
 AM_PROG_CC_C_O
 
 # AC_PROG_SED is only avaliable in recent autoconf versions.
@@ -153,10 +145,7 @@ if test $enable_cifsupcall != "no"; then
 
 	AC_CACHE_CHECK([for keyvalue in krb5_keyblock],
 		[ac_cv_have_krb5_keyblock_keyvalue],[
-			AC_TRY_COMPILE([$krb5_include],
-			[krb5_keyblock key; key.keyvalue.data = NULL;],
-			ac_cv_have_krb5_keyblock_keyvalue=yes,
-			ac_cv_have_krb5_keyblock_keyvalue=no)])
+			AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[$krb5_include]], [[krb5_keyblock key; key.keyvalue.data = NULL;]])],[ac_cv_have_krb5_keyblock_keyvalue=yes],[ac_cv_have_krb5_keyblock_keyvalue=no])])
 	if test x"$ac_cv_have_krb5_keyblock_keyvalue" = x"yes" ; then
 		AC_DEFINE(HAVE_KRB5_KEYBLOCK_KEYVALUE,1,
 			[Whether the krb5_keyblock struct has a keyvalue property])
-- 
1.8.3.1
