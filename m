From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/2] common: add a directory tree for cifs tests
Date: Sat, 23 Aug 2014 12:16:03 +0400
Message-ID: <1408781763-30127-3-git-send-email-pshilovsky@samba.org>
References: <1408781763-30127-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408781763-30127-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 tests/cifs/Makefile | 14 ++++++++++++++
 tests/cifs/group    |  5 +++++
 2 files changed, 19 insertions(+)
 create mode 100644 tests/cifs/Makefile
 create mode 100644 tests/cifs/group

diff --git a/tests/cifs/Makefile b/tests/cifs/Makefile
new file mode 100644
index 0000000..37e868b
--- /dev/null
+++ b/tests/cifs/Makefile
@@ -0,0 +1,14 @@
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+CIFS_DIR = cifs
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CIFS_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/cifs/group b/tests/cifs/group
new file mode 100644
index 0000000..4e01f0c
--- /dev/null
+++ b/tests/cifs/group
@@ -0,0 +1,5 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
-- 
1.9.1
