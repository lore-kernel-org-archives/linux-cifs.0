From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] doc: update mailing list
Date: Sun, 13 May 2012 11:44:05 +0200
Message-ID: <1336902245-20046-1-git-send-email-luk@debian.org>
Cc: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 configure.ac          |    2 +-
 doc/cifs.upcall.8.xml |    2 +-
 doc/mount.cifs.8.xml  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2d2e15f..70708cd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 #                                               -*- Autoconf -*-
 # Process this file with autoconf to produce a configure script.
 
-AC_INIT([cifs-utils], [5.4.1], [cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org], [cifs-utils], [https://wiki.samba.org/index.php/LinuxCIFS_utils])
+AC_INIT([cifs-utils], [5.4.1], [linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org], [cifs-utils], [https://wiki.samba.org/index.php/LinuxCIFS_utils])
 AC_CONFIG_SRCDIR([replace.h])
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_FILES([Makefile contrib/Makefile contrib/request-key.d/Makefile])
diff --git a/doc/cifs.upcall.8.xml b/doc/cifs.upcall.8.xml
index 92d1454..77b9208 100644
--- a/doc/cifs.upcall.8.xml
+++ b/doc/cifs.upcall.8.xml
@@ -114,7 +114,7 @@ See <citerefentry><refentrytitle>request-key.conf<manvolnum>5</manvolnum></refen
 	<para>Igor Mammedov wrote the cifs.upcall program.</para>
 	<para>Jeff Layton authored this manpage.</para>
 	<para>The maintainer of the Linux CIFS VFS is Steve French.</para>
-        <para>The <ulink url="mailto:linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org">Linux
+        <para>The <ulink url="mailto:linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">Linux
 		CIFS Mailing list</ulink> is the preferred place to ask
 		questions regarding these programs.
 	</para>
diff --git a/doc/mount.cifs.8.xml b/doc/mount.cifs.8.xml
index af20c10..df3b9b5 100644
--- a/doc/mount.cifs.8.xml
+++ b/doc/mount.cifs.8.xml
@@ -742,7 +742,7 @@ server type you are trying to contact.
 
 	<para>The maintainer of the Linux cifs vfs and the userspace
 		tool <emphasis>mount.cifs</emphasis> is <ulink url="mailto:sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org">Steve French</ulink>.
-		The <ulink url="mailto:linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org">Linux CIFS Mailing list</ulink> 
+		The <ulink url="mailto:linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">Linux CIFS Mailing list</ulink> 
 		is the preferred place to ask questions regarding these programs. 
 	</para>
 
-- 
1.7.10
