From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 1/6] cifs-utils: struct cifs_sid definition to new cifsidmap.h header
Date: Thu, 20 Dec 2012 07:50:28 -0500
Message-ID: <1356007833-10893-2-git-send-email-jlayton@samba.org>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

People who want to build a plugin for the idmapping routines will need a
header to describe the data types that they need. Add a cifsidmap.h file
and move the struct cifs_sid definition into it, along with the
constants needed to describe it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am |  1 +
 cifsacl.h   | 12 ++----------
 cifsidmap.h | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 10 deletions(-)
 create mode 100644 cifsidmap.h

diff --git a/Makefile.am b/Makefile.am
index ff7a726..8964b37 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -7,6 +7,7 @@ mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
 mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
 
 man_MANS = mount.cifs.8
+include_HEADERS = cifsidmap.h
 
 bin_PROGRAMS =
 sbin_PROGRAMS =
diff --git a/cifsacl.h b/cifsacl.h
index 68fe0fd..ca72dd4 100644
--- a/cifsacl.h
+++ b/cifsacl.h
@@ -20,6 +20,8 @@
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
 
+#include "cifsidmap.h"
+
 #ifndef _CIFSACL_H
 #define _CIFSACL_H
 
@@ -96,9 +98,6 @@
 #define COMPMASK 0x8
 #define COMPALL (COMPSID|COMPTYPE|COMPFLAG|COMPMASK)
 
-#define NUM_AUTHS (6)			/* number of authority fields */
-#define SID_MAX_SUB_AUTHORITIES (15)	/* max number of sub authority fields */
-
 /*
  * While not indicated here, the structs below represent on-the-wire data
  * structures. Any multi-byte values are expected to be little-endian!
@@ -114,13 +113,6 @@ struct cifs_ntsd {
 	uint32_t dacloffset;
 } __attribute__((packed));
 
-struct cifs_sid {
-	uint8_t revision; /* revision level */
-	uint8_t num_subauth;
-	uint8_t authority[NUM_AUTHS];
-	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
-} __attribute__((packed));
-
 struct cifs_ctrl_acl {
 	uint16_t revision; /* revision level */
 	uint16_t size;
diff --git a/cifsidmap.h b/cifsidmap.h
new file mode 100644
index 0000000..9907618
--- /dev/null
+++ b/cifsidmap.h
@@ -0,0 +1,37 @@
+/*
+ * ID Mapping Plugin interface for cifs-utils
+ * Copyright (C) 2012 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <stdint.h>
+
+#ifndef _CIFSIDMAP_H
+#define _CIFSIDMAP_H
+
+#define NUM_AUTHS (6)			/* number of authority fields */
+#define SID_MAX_SUB_AUTHORITIES (15)	/* max number of sub authority fields */
+
+/*
+ * Binary representation of a SID as presented to/from the kernel. Note that
+ * the sub_auth field is always stored in little-endian here.
+ */
+struct cifs_sid {
+	uint8_t revision; /* revision level */
+	uint8_t num_subauth;
+	uint8_t authority[NUM_AUTHS];
+	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
+} __attribute__((packed));
+
+#endif /* _CIFSIDMAP_H */
-- 
1.7.11.7
