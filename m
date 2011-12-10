From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] contrib: add a set of sample /etc/request-key.d files
Date: Fri,  9 Dec 2011 21:37:03 -0500
Message-ID: <1323484623-15619-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a contrib directory, a set of sample /etc/request-key.d files and
a README that explains what they're for.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 contrib/request-key.d/README           |    7 +++++++
 contrib/request-key.d/cifs.idmapd.conf |    1 +
 contrib/request-key.d/cifs.spnego.conf |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 contrib/README
 create mode 100644 contrib/request-key.d/README
 create mode 100644 contrib/request-key.d/cifs.idmapd.conf
 create mode 100644 contrib/request-key.d/cifs.spnego.conf

diff --git a/contrib/README b/contrib/README
new file mode 100644
index 0000000..e69de29
diff --git a/contrib/request-key.d/README b/contrib/request-key.d/README
new file mode 100644
index 0000000..b605da7
--- /dev/null
+++ b/contrib/request-key.d/README
@@ -0,0 +1,7 @@
+As of version 1.5.5, prior to opening /etc/request-key.conf, the
+request-key utility will look first in /etc/request-key.d for a file of
+the key type name plus ".conf". These files are example config files
+that distro packagers can use to have request-key autoconfigured to
+use the cifs utilities that are installed. Typically, distro packagers
+will want to drop these into /etc/request-key.d.
+
diff --git a/contrib/request-key.d/cifs.idmapd.conf b/contrib/request-key.d/cifs.idmapd.conf
new file mode 100644
index 0000000..84d3d5e
--- /dev/null
+++ b/contrib/request-key.d/cifs.idmapd.conf
@@ -0,0 +1 @@
+create  cifs.idmap    * * /usr/sbin/cifs.idmap %k
diff --git a/contrib/request-key.d/cifs.spnego.conf b/contrib/request-key.d/cifs.spnego.conf
new file mode 100644
index 0000000..a94afd8
--- /dev/null
+++ b/contrib/request-key.d/cifs.spnego.conf
@@ -0,0 +1 @@
+create  cifs.spnego    * * /usr/sbin/cifs.upcall %k
-- 
1.7.7.3
