From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: add ver=2.1 option support
Date: Fri, 11 May 2012 14:47:00 -0400
Message-ID: <1336762021-6954-3-git-send-email-jlayton@redhat.com>
References: <1336762021-6954-1-git-send-email-jlayton@redhat.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336762021-6954-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have ver=2.1 set the server->ops struct to one for SMB2.1

In this patch I'm avoiding the ambiguous "ver=2" syntax since it's not
clear what specific version you're actually selecting in that case.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Makefile   |    2 ++
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/connect.c  |    6 ++++++
 fs/cifs/smb2ops.c  |   24 ++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 fs/cifs/smb2ops.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 0fe7025..4b41275 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -15,3 +15,5 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
+
+cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 64a9085..3eae273 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -152,6 +152,7 @@ struct cifs_cred {
 
 enum smb_version {
 	Smb_1 = 1,
+	Smb_21,
 };
 
 struct smb_version_operations {
@@ -1081,4 +1082,5 @@ extern struct workqueue_struct *cifsiod_wq;
 
 /* Operations for different SMB versions */
 extern struct smb_version_operations smb1_version_operations;
+extern struct smb_version_operations smb21_version_operations;
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0f1be6f..e51a0a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -280,6 +280,7 @@ static const match_table_t cifs_cacheflavor_tokens = {
 
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, "1" },
+	{ Smb_21, "2.1" },
 };
 
 static int ip_connect(struct TCP_Server_Info *server);
@@ -1253,6 +1254,11 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 	case Smb_1:
 		vol->ops = &smb1_version_operations;
 		break;
+#ifdef CONFIG_CIFS_SMB2
+	case Smb_21:
+		vol->ops = &smb21_version_operations;
+		break;
+#endif
 	default:
 		cERROR(1, "Unknown ver= option specified: %s", value);
 		return 1;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
new file mode 100644
index 0000000..2ac672e
--- /dev/null
+++ b/fs/cifs/smb2ops.c
@@ -0,0 +1,24 @@
+/*
+ *  SMB2 version specific operations
+ *
+ *  Copyright (c) 2012, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *
+ *  This library is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License v2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This library is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *  the GNU Lesser General Public License for more details.
+ *
+ *  You should have received a copy of the GNU Lesser General Public License
+ *  along with this library; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include "cifsglob.h"
+
+struct smb_version_operations smb21_version_operations = {
+	.version_string = "2.1",
+};
-- 
1.7.7.6
