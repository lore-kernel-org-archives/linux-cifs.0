From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 44/45] CIFS: Move statfs to ops struct
Date: Wed, 18 Jul 2012 19:49:00 +0400
Message-ID: <1342626541-29872-45-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c   |   29 ++++-------------------------
 fs/cifs/cifsglob.h |    5 +++++
 fs/cifs/smb1ops.c  |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 65f8b05..4dde869 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -51,7 +51,6 @@
 #ifdef CONFIG_CIFS_SMB2
 #include "smb2pdu.h"
 #endif
-#define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
 int cifsFYI = 0;
 int cifsERROR = 1;
@@ -162,13 +161,12 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb = dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	int rc = -EOPNOTSUPP;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int xid;
+	int rc = 0;
 
 	xid = get_xid();
 
-	buf->f_type = CIFS_MAGIC_NUMBER;
-
 	/*
 	 * PATH_MAX may be too long - it would presumably be total path,
 	 * but note that some servers (includinng Samba 3) have a shorter
@@ -180,27 +178,8 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = 0;	/* undefined */
 	buf->f_ffree = 0;	/* unlimited */
 
-	/*
-	 * We could add a second check for a QFS Unix capability bit
-	 */
-	if ((tcon->ses->capabilities & CAP_UNIX) &&
-	    (CIFS_POSIX_EXTENSIONS & le64_to_cpu(tcon->fsUnixInfo.Capability)))
-		rc = CIFSSMBQFSPosixInfo(xid, tcon, buf);
-
-	/*
-	 * Only need to call the old QFSInfo if failed on newer one,
-	 * e.g. by OS/2.
-	 **/
-	if (rc && (tcon->ses->capabilities & CAP_NT_SMBS))
-		rc = CIFSSMBQFSInfo(xid, tcon, buf);
-
-	/*
-	 * Some old Windows servers also do not support level 103, retry with
-	 * older level one if old server failed the previous call or we
-	 * bypassed it because we detected that this was an older LANMAN sess
-	 */
-	if (rc)
-		rc = SMBOldQFSInfo(xid, tcon, buf);
+	if (server->ops->queryfs)
+		rc = server->ops->queryfs(xid, tcon, buf);
 
 	free_xid(xid);
 	return 0;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a8f424f..46bbbe4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -32,6 +32,8 @@
 #include "smb2pdu.h"
 #endif
 
+#define CIFS_MAGIC_NUMBER 0xFF534D42      /* the first four bytes of SMB PDUs */
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -333,6 +335,9 @@ struct smb_version_operations {
 	/* send oplock break response */
 	int (*oplock_response)(struct cifs_tcon *, struct cifs_fid *,
 			       struct cifsInodeInfo *);
+	/* query remote filesystem */
+	int (*queryfs)(const unsigned int, struct cifs_tcon *,
+		       struct kstatfs *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f55b2e3..f6c7a1c 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/vfs.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -872,6 +873,38 @@ cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 			   cinode->clientCanCacheRead ? 1 : 0);
 }
 
+static int
+cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
+	     struct kstatfs *buf)
+{
+	int rc = -EOPNOTSUPP;
+
+	buf->f_type = CIFS_MAGIC_NUMBER;
+
+	/*
+	 * We could add a second check for a QFS Unix capability bit
+	 */
+	if ((tcon->ses->capabilities & CAP_UNIX) &&
+	    (CIFS_POSIX_EXTENSIONS & le64_to_cpu(tcon->fsUnixInfo.Capability)))
+		rc = CIFSSMBQFSPosixInfo(xid, tcon, buf);
+
+	/*
+	 * Only need to call the old QFSInfo if failed on newer one,
+	 * e.g. by OS/2.
+	 **/
+	if (rc && (tcon->ses->capabilities & CAP_NT_SMBS))
+		rc = CIFSSMBQFSInfo(xid, tcon, buf);
+
+	/*
+	 * Some old Windows servers also do not support level 103, retry with
+	 * older level one if old server failed the previous call or we
+	 * bypassed it because we detected that this was an older LANMAN sess
+	 */
+	if (rc)
+		rc = SMBOldQFSInfo(xid, tcon, buf);
+	return rc;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -932,6 +965,7 @@ struct smb_version_operations smb1_operations = {
 	.close_dir = cifs_close_dir,
 	.calc_smb_size = smbCalcSize,
 	.oplock_response = cifs_oplock_response,
+	.queryfs = cifs_queryfs,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
