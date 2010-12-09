From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: rewrite hardcoded paths in manpages
Date: Thu,  9 Dec 2010 09:37:20 -0500
Message-ID: <1291905440-12866-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the manpages (particularly cifs.upcall.8) have hardcoded
paths in them that need to be manually adjusted. Replace those
paths with @sbindir@ and add a makefile target that will use sed
to replace those paths with the ones set by autoconf.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am                       |    6 ++++++
 cifs.upcall.8 => cifs.upcall.8.in |    4 ++--
 configure.ac                      |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)
 rename cifs.upcall.8 => cifs.upcall.8.in (97%)

diff --git a/Makefile.am b/Makefile.am
index 38a16fe..cbfa846 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -13,6 +13,12 @@ sbin_PROGRAMS = cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
 cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
 man_MANS += cifs.upcall.8
+
+cifs.upcall.8: cifs.upcall.8.in
+	sed 's,\@sbindir\@,$(sbindir),' < $(srcdir)/cifs.upcall.8.in > cifs.upcall.8
+
+clean-local:
+	rm -f cifs.upcall.8
 endif
 
 if CONFIG_CIFSCREDS
diff --git a/cifs.upcall.8 b/cifs.upcall.8.in
similarity index 97%
rename from cifs.upcall.8
rename to cifs.upcall.8.in
index 3207f6f..bef1ee6 100644
--- a/cifs.upcall.8
+++ b/cifs.upcall.8.in
@@ -78,8 +78,8 @@ To make this program useful for CIFS, you\'ll need to set up entries for them in
 .nf
 #OPERATION  TYPE           D C PROGRAM ARG1 ARG2\&.\&.\&.
 #=========  =============  = = ================================
-create      cifs\&.spnego    * * /usr/local/sbin/cifs\&.upcall %k
-create      dns_resolver   * * /usr/local/sbin/cifs\&.upcall %k
+create      cifs\&.spnego    * * @sbindir@/cifs\&.upcall %k
+create      dns_resolver   * * @sbindir@/cifs\&.upcall %k
 .fi
 .if n \{\
 .RE
diff --git a/configure.ac b/configure.ac
index a04596c..093b48d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,6 +24,7 @@ AC_ARG_ENABLE(cifscreds,
 
 # Checks for programs.
 AC_PROG_CC
+AC_PROG_SED
 AC_GNU_SOURCE
 
 # Checks for header files.
-- 
1.7.3.2
