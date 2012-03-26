From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 16/16] CIFS: Get SMB2 mount work
Date: Mon, 26 Mar 2012 13:21:43 +0400
Message-ID: <1332753703-4315-17-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by disabling DFS, prefixpath and ipc functions.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |   29 +++++++++++++++++++++++++----
 fs/cifs/inode.c   |   16 +++++++++++++---
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 77e6520..8a9bd44 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -523,7 +523,14 @@ cifs_echo_request(struct work_struct *work)
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-	rc = CIFSSMBEcho(server);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		/* temporarilly disable echo requests for SMB2 */
+		rc = 0;
+	else
+#endif
+		rc = CIFSSMBEcho(server);
+
 	if (rc)
 		cFYI(1, "Unable to send echo request to server: %s",
 			server->hostname);
@@ -2940,6 +2947,12 @@ get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
 	char *temp_unc;
 	int rc = 0;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (pSesInfo->server->is_smb2) {
+		/* add missing smb2 dfs code here */
+		return -EREMOTE;
+	}
+#endif
 	*pnum_referrals = 0;
 	*preferrals = NULL;
 
@@ -3846,10 +3859,18 @@ try_mount_again:
 		tcon->unix_ext = 0; /* server does not support them */
 
 	/* do not care if following two calls succeed - informational */
-	if (!tcon->ipc) {
-		CIFSSMBQFSDeviceInfo(xid, tcon);
-		CIFSSMBQFSAttributeInfo(xid, tcon);
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2) {
+		/* add missing calls here */
+	} else {
+#endif
+		if (!tcon->ipc) {
+			CIFSSMBQFSDeviceInfo(xid, tcon);
+			CIFSSMBQFSAttributeInfo(xid, tcon);
+		}
+#ifdef CONFIG_CIFS_SMB2
 	}
+#endif
 
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
 	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ad0b7b7..182adf2 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -780,12 +780,22 @@ char *cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	/* if no prefix path, simply set path to the root of share to "" */
 	if (pplen == 0) {
-		full_path = kmalloc(1, GFP_KERNEL);
-		if (full_path)
-			full_path[0] = 0;
+		int len = 1;
+#ifdef CONFIG_CIFS_SMB2
+		if (vol->use_smb2)
+			len = 2;
+#endif
+		full_path = kzalloc(len, GFP_KERNEL);
 		return full_path;
 	}
 
+#ifdef CONFIG_CIFS_SMB2
+	if (vol->use_smb2) {
+		cERROR(1, "prefixpath is not supported for smb2 now");
+		return NULL;
+	}
+#endif
+
 	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
 		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
 	else
-- 
1.7.1
