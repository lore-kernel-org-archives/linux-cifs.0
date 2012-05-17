From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Introduce SMB2 mounts as vers=2.1
Date: Thu, 17 May 2012 23:07:53 +0400
Message-ID: <1337281673-13665-1-git-send-email-piastry@etersoft.ru>
Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

This is a slightly modified version of Jeff's patch that merged
into Steve's original patch.

---
As with Linux nfs client, which uses "nfsvers=" or "vers=" to
indicate which protocol to use for mount, specifying

"vers=2.1"

will force an SMB2 mount. When vers is not specified CIFS is used

"vers=1"

We can eventually autonegotiate down from SMB2 to CIFS
when SMB2 is stable enough to make it the default, but this
is for the future. At that time we could also implement a
"maxprotocol" mount option as smbclient and Samba have today,
but that would be premature until SMB2 is stable.

Intially the SMB2 Kconfig option will depend on "BROKEN"
until the merge is complete, and then be "EXPERIMENTAL"
When it is no longer experimental we can consider changing
the default protocol to attempt first.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Makefile   |    2 ++
 fs/cifs/cifsglob.h |    4 ++++
 fs/cifs/connect.c  |    9 ++++++++-
 fs/cifs/smb2ops.c  |   27 +++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 1 deletions(-)
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
index d17db87..21b00e9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -152,6 +152,7 @@ struct cifs_cred {
 
 enum smb_version {
 	Smb_1 = 1,
+	Smb_21,
 };
 
 struct mid_q_entry;
@@ -1117,4 +1118,7 @@ extern struct workqueue_struct *cifsiod_wq;
 #define SMB1_VERSION_STRING	"1.0"
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
+#define SMB21_VERSION_STRING	"2.1"
+extern struct smb_version_operations smb21_operations;
+extern struct smb_version_values smb21_values;
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ce033d7..1168be6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/connect.c
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2009
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -278,6 +278,7 @@ static const match_table_t cifs_cacheflavor_tokens = {
 
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, SMB1_VERSION_STRING },
+	{ Smb_21, SMB21_VERSION_STRING },
 };
 
 static int ip_connect(struct TCP_Server_Info *server);
@@ -1221,6 +1222,12 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		vol->ops = &smb1_operations;
 		vol->vals = &smb1_values;
 		break;
+#ifdef CONFIG_CIFS_SMB2
+	case Smb_21:
+		vol->ops = &smb21_operations;
+		vol->vals = &smb21_values;
+		break;
+#endif
 	default:
 		cERROR(1, "Unknown vers= option specified: %s", value);
 		return 1;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
new file mode 100644
index 0000000..f065e89
--- /dev/null
+++ b/fs/cifs/smb2ops.c
@@ -0,0 +1,27 @@
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
+struct smb_version_operations smb21_operations = {
+};
+
+struct smb_version_values smb21_values = {
+	.version_string = SMB21_VERSION_STRING,
+};
-- 
1.7.1
