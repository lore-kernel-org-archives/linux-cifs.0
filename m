From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] ioctl: add and ship public header
Date: Thu,  5 Jun 2014 19:27:49 +0200
Message-ID: <1401989269-13855-1-git-send-email-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The header currently only exposes the CIFS_IOC_COPYCHUNK_FILE interface,
but is still useful.

Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 Makefile.am |  2 ++
 ioctl.h     | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 ioctl.h

diff --git a/Makefile.am b/Makefile.am
index 92da8b1..3d1bd3a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,6 +8,8 @@ mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
 
 man_MANS = mount.cifs.8
 include_HEADERS = cifsidmap.h
+cifsincludedir = $(includedir)/cifs
+cifsinclude_HEADERS = ioctl.h
 
 bin_PROGRAMS =
 sbin_PROGRAMS =
diff --git a/ioctl.h b/ioctl.h
new file mode 100644
index 0000000..0ae831c
--- /dev/null
+++ b/ioctl.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __CIFS_IOCTL_
+#define __CIFS_IOCTL_
+#include <asm/types.h>
+#include <linux/ioctl.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define CIFS_IOCTL_MAGIC        0xCF
+#define CIFS_IOC_COPYCHUNK_FILE _IOW(CIFS_IOCTL_MAGIC, 3, int)
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
-- 
1.8.4.5
