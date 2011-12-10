From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] contrib: add a set of sample /etc/request-key.d files
Date: Sat, 10 Dec 2011 06:49:59 -0500
Message-ID: <1323517799-22756-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a contrib directory, a set of sample /etc/request-key.d files and
a README that explains what they're for. This version sets the path
to the upcall programs based on the configure options.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am                               |    2 ++
 configure.ac                              |    2 +-
 contrib/Makefile.am                       |    1 +
 contrib/request-key.d/Makefile.am         |    9 +++++++++
 contrib/request-key.d/README              |    7 +++++++
 contrib/request-key.d/cifs.idmap.conf.in  |    1 +
 contrib/request-key.d/cifs.spnego.conf.in |    1 +
 7 files changed, 22 insertions(+), 1 deletions(-)
 create mode 100644 contrib/Makefile.am
 create mode 100644 contrib/README
 create mode 100644 contrib/request-key.d/Makefile.am
 create mode 100644 contrib/request-key.d/README
 create mode 100644 contrib/request-key.d/cifs.idmap.conf.in
 create mode 100644 contrib/request-key.d/cifs.spnego.conf.in

diff --git a/Makefile.am b/Makefile.am
index 934ea6f..cb20442 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -69,3 +69,5 @@ clean-local-aclprogs:
 if CONFIG_CIFSACL
 	rm -f getcifsacl.8 getcifsacl.8-t setcifsacl.8 setcifsacl.8-t
 endif
+
+SUBDIRS = contrib
diff --git a/configure.ac b/configure.ac
index 474b3f4..8476f94 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@
 AC_INIT([cifs-utils], [5.2.1], [cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org], [cifs-utils], [http://linux-cifs.samba.org/cifs-utils/])
 AC_CONFIG_SRCDIR([replace.h])
 AC_CONFIG_HEADERS([config.h])
-AC_CONFIG_FILES([Makefile])
+AC_CONFIG_FILES([Makefile contrib/Makefile contrib/request-key.d/Makefile])
 AC_CONFIG_MACRO_DIR(aclocal)
 
 AM_INIT_AUTOMAKE
diff --git a/contrib/Makefile.am b/contrib/Makefile.am
new file mode 100644
index 0000000..4d4916a
--- /dev/null
+++ b/contrib/Makefile.am
@@ -0,0 +1 @@
+SUBDIRS = request-key.d
diff --git a/contrib/README b/contrib/README
new file mode 100644
index 0000000..e69de29
diff --git a/contrib/request-key.d/Makefile.am b/contrib/request-key.d/Makefile.am
new file mode 100644
index 0000000..5bda10d
--- /dev/null
+++ b/contrib/request-key.d/Makefile.am
@@ -0,0 +1,9 @@
+noinst_DATA = cifs.idmap.conf cifs.spnego.conf
+cifs.idmap.conf: cifs.idmap.conf.in
+	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+
+cifs.spnego.conf: cifs.spnego.conf.in
+	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+
+clean-local:
+	rm -f cifs.idmap.conf cifs.spnego.conf
diff --git a/contrib/request-key.d/README b/contrib/request-key.d/README
new file mode 100644
index 0000000..821f9ba
--- /dev/null
+++ b/contrib/request-key.d/README
@@ -0,0 +1,7 @@
+As of version 1.5.5, prior to opening /etc/request-key.conf, the
+request-key utility will look first in /etc/request-key.d for a file of
+the key type name plus ".conf". These files are example config files
+that distro packagers can use to have request-key autoconfigured to
+use the cifs utilities that are installed. Typically, distro packagers
+will want to drop the resulting .conf files into /etc/request-key.d.
+
diff --git a/contrib/request-key.d/cifs.idmap.conf.in b/contrib/request-key.d/cifs.idmap.conf.in
new file mode 100644
index 0000000..a0e25f1
--- /dev/null
+++ b/contrib/request-key.d/cifs.idmap.conf.in
@@ -0,0 +1 @@
+create  cifs.idmap    * * @sbindir@/cifs.idmap %k
diff --git a/contrib/request-key.d/cifs.spnego.conf.in b/contrib/request-key.d/cifs.spnego.conf.in
new file mode 100644
index 0000000..4ca47b0
--- /dev/null
+++ b/contrib/request-key.d/cifs.spnego.conf.in
@@ -0,0 +1 @@
+create  cifs.spnego    * * @sbindir@/cifs.upcall %k
-- 
1.7.7.3
