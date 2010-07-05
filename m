From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 02/09] cifs: register CIFS for caching
Date: Mon,  5 Jul 2010 18:11:50 +0530
Message-ID: <1278333710-30557-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Define CIFS for FS-Cache and register for caching. Upon registration the
top-level index object cookie will be stuck to the netfs definition by
FS-Cache.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/Makefile  |    2 ++
 fs/cifs/cache.c   |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.c  |    8 ++++++++
 fs/cifs/fscache.h |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+)
 create mode 100644 fs/cifs/cache.c
 create mode 100644 fs/cifs/fscache.h

Index: cifs-2.6/fs/cifs/Makefile
===================================================================
--- cifs-2.6.orig/fs/cifs/Makefile
+++ cifs-2.6/fs/cifs/Makefile
@@ -11,3 +11,5 @@ cifs-y := cifsfs.o cifssmb.o cifs_debug.
 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
+
+cifs-$(CONFIG_CIFS_FSCACHE) += cache.o
Index: cifs-2.6/fs/cifs/cache.c
===================================================================
--- /dev/null
+++ cifs-2.6/fs/cifs/cache.c
@@ -0,0 +1,46 @@
+/*
+ *   fs/cifs/cache.c - CIFS filesystem cache index structure definitions
+ *
+ *   Copyright (c) 2010 Novell, Inc.
+ *   Authors(s): Suresh Jayaraman (sjayaraman-l3A5Bk7waGM@public.gmane.org>
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include "fscache.h"
+
+/*
+ * CIFS filesystem definition for FS-Cache
+ */
+struct fscache_netfs cifs_fscache_netfs = {
+	.name = "cifs",
+	.version = 0,
+};
+
+/*
+ * Register CIFS for caching with FS-Cache
+ */
+int cifs_fscache_register(void)
+{
+	return fscache_register_netfs(&cifs_fscache_netfs);
+}
+
+/*
+ * Unregister CIFS for caching
+ */
+void cifs_fscache_unregister(void)
+{
+	fscache_unregister_netfs(&cifs_fscache_netfs);
+}
+
Index: cifs-2.6/fs/cifs/cifsfs.c
===================================================================
--- cifs-2.6.orig/fs/cifs/cifsfs.c
+++ cifs-2.6/fs/cifs/cifsfs.c
@@ -47,6 +47,7 @@
 #include <linux/key-type.h>
 #include "dns_resolve.h"
 #include "cifs_spnego.h"
+#include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
 int cifsFYI = 0;
@@ -902,6 +903,10 @@ init_cifs(void)
 		cFYI(1, "cifs_max_pending set to max of 256");
 	}
 
+	rc = cifs_fscache_register();
+	if (rc)
+		goto out;
+
 	rc = cifs_init_inodecache();
 	if (rc)
 		goto out_clean_proc;
@@ -951,6 +956,8 @@ init_cifs(void)
 	cifs_destroy_inodecache();
  out_clean_proc:
 	cifs_proc_clean();
+	cifs_fscache_unregister();
+ out:
 	return rc;
 }
 
@@ -959,6 +966,7 @@ exit_cifs(void)
 {
 	cFYI(DBG2, "exit_cifs");
 	cifs_proc_clean();
+	cifs_fscache_unregister();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
 	unregister_key_type(&key_type_dns_resolver);
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- /dev/null
+++ cifs-2.6/fs/cifs/fscache.h
@@ -0,0 +1,39 @@
+/*
+ *   fs/cifs/fscache.h - CIFS filesystem cache interface definitions
+ *
+ *   Copyright (c) 2010 Novell, Inc.
+ *   Authors(s): Suresh Jayaraman (sjayaraman-l3A5Bk7waGM@public.gmane.org>
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _CIFS_FSCACHE_H
+#define _CIFS_FSCACHE_H
+
+#include <linux/fscache.h>
+
+#ifdef CONFIG_CIFS_FSCACHE
+
+extern struct fscache_netfs cifs_fscache_netfs;
+
+extern int cifs_fscache_register(void);
+extern void cifs_fscache_unregister(void);
+
+#else /* CONFIG_CIFS_FSCACHE */
+static inline int cifs_fscache_register(void) { return 0; }
+static inline void cifs_fscache_unregister(void) {}
+
+#endif /* CONFIG_CIFS_FSCACHE */
+
+#endif /* _CIFS_FSCACHE_H */
