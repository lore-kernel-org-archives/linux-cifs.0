From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 14/24] CIFS: Move informational tcon calls to ops struct
Date: Wed, 20 Jun 2012 18:30:54 +0400
Message-ID: <1340202664-28696-15-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and rename variables in cifs_mount.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/connect.c  |   51 ++++++++++++++++++++++++---------------------------
 fs/cifs/smb1ops.c  |    8 ++++++++
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8b66fb8..c294e67 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -213,6 +213,8 @@ struct smb_version_operations {
 	int (*get_dfs_refer)(const unsigned int, struct cifs_ses *,
 			     const char *, struct dfs_info3_param **,
 			     unsigned int *, const struct nls_table *, int);
+	/* informational QFS call */
+	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1306fb5..fe883a0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3584,9 +3584,9 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
 	int rc;
 	unsigned int xid;
-	struct cifs_ses *pSesInfo;
+	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *srvTcp;
+	struct TCP_Server_Info *server;
 	char   *full_path;
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -3603,39 +3603,39 @@ try_mount_again:
 	if (referral_walks_count) {
 		if (tcon)
 			cifs_put_tcon(tcon);
-		else if (pSesInfo)
-			cifs_put_smb_ses(pSesInfo);
+		else if (ses)
+			cifs_put_smb_ses(ses);
 
 		free_xid(xid);
 	}
 #endif
 	rc = 0;
 	tcon = NULL;
-	pSesInfo = NULL;
-	srvTcp = NULL;
+	ses = NULL;
+	server = NULL;
 	full_path = NULL;
 	tlink = NULL;
 
 	xid = get_xid();
 
 	/* get a reference to a tcp session */
-	srvTcp = cifs_get_tcp_session(volume_info);
-	if (IS_ERR(srvTcp)) {
-		rc = PTR_ERR(srvTcp);
+	server = cifs_get_tcp_session(volume_info);
+	if (IS_ERR(server)) {
+		rc = PTR_ERR(server);
 		bdi_destroy(&cifs_sb->bdi);
 		goto out;
 	}
 
 	/* get a reference to a SMB session */
-	pSesInfo = cifs_get_smb_ses(srvTcp, volume_info);
-	if (IS_ERR(pSesInfo)) {
-		rc = PTR_ERR(pSesInfo);
-		pSesInfo = NULL;
+	ses = cifs_get_smb_ses(server, volume_info);
+	if (IS_ERR(ses)) {
+		rc = PTR_ERR(ses);
+		ses = NULL;
 		goto mount_fail_check;
 	}
 
 	/* search for existing tcon to this server share */
-	tcon = cifs_get_tcon(pSesInfo, volume_info);
+	tcon = cifs_get_tcon(ses, volume_info);
 	if (IS_ERR(tcon)) {
 		rc = PTR_ERR(tcon);
 		tcon = NULL;
@@ -3656,11 +3656,9 @@ try_mount_again:
 	} else
 		tcon->unix_ext = 0; /* server does not support them */
 
-	/* do not care if following two calls succeed - informational */
-	if (!tcon->ipc) {
-		CIFSSMBQFSDeviceInfo(xid, tcon);
-		CIFSSMBQFSAttributeInfo(xid, tcon);
-	}
+	/* do not care if a following call succeed - informational */
+	if (!tcon->ipc && server->ops->qfs_tcon)
+		server->ops->qfs_tcon(xid, tcon);
 
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
 	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
@@ -3678,8 +3676,8 @@ remote_path_check:
 	 * Chase the referral if found, otherwise continue normally.
 	 */
 	if (referral_walks_count == 0) {
-		int refrc = expand_dfs_referral(xid, pSesInfo, volume_info,
-						cifs_sb, false);
+		int refrc = expand_dfs_referral(xid, ses, volume_info, cifs_sb,
+						false);
 		if (!refrc) {
 			referral_walks_count++;
 			goto try_mount_again;
@@ -3717,8 +3715,7 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 
-		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
-					 true);
+		rc = expand_dfs_referral(xid, ses, volume_info, cifs_sb, true);
 
 		if (!rc) {
 			referral_walks_count++;
@@ -3740,7 +3737,7 @@ remote_path_check:
 		goto mount_fail_check;
 	}
 
-	tlink->tl_uid = pSesInfo->linux_uid;
+	tlink->tl_uid = ses->linux_uid;
 	tlink->tl_tcon = tcon;
 	tlink->tl_time = jiffies;
 	set_bit(TCON_LINK_MASTER, &tlink->tl_flags);
@@ -3761,10 +3758,10 @@ mount_fail_check:
 		/* up accidentally freeing someone elses tcon struct */
 		if (tcon)
 			cifs_put_tcon(tcon);
-		else if (pSesInfo)
-			cifs_put_smb_ses(pSesInfo);
+		else if (ses)
+			cifs_put_smb_ses(ses);
 		else
-			cifs_put_tcp_session(srvTcp);
+			cifs_put_tcp_session(server);
 		bdi_destroy(&cifs_sb->bdi);
 	}
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6d9025b..96eb06f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -410,6 +410,13 @@ cifs_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
+static void
+cifs_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+{
+	CIFSSMBQFSDeviceInfo(xid, tcon);
+	CIFSSMBQFSAttributeInfo(xid, tcon);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -435,6 +442,7 @@ struct smb_version_operations smb1_operations = {
 	.tree_connect = CIFSTCon,
 	.tree_disconnect = CIFSSMBTDis,
 	.get_dfs_refer = CIFSGetDFSRefer,
+	.qfs_tcon = cifs_qfs_tcon,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
