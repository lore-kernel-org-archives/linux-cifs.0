From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 12/22] CIFS: Move informational tcon calls to ops struct
Date: Tue, 19 Jun 2012 16:40:01 +0400
Message-ID: <1340109611-7210-13-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
index e045c31..4f82900 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -213,6 +213,8 @@ struct smb_version_operations {
 	int (*get_dfs_refer)(const int, struct cifs_ses *, const char *,
 			     struct dfs_info3_param **, unsigned int *,
 			     const struct nls_table *, int);
+	/* informational QFS call */
+	void (*qfs_tcon)(const int, struct cifs_tcon *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5e62b3a..3f6b66a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3583,9 +3583,9 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
 	int rc;
 	int xid;
-	struct cifs_ses *pSesInfo;
+	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *srvTcp;
+	struct TCP_Server_Info *server;
 	char   *full_path;
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -3602,39 +3602,39 @@ try_mount_again:
 	if (referral_walks_count) {
 		if (tcon)
 			cifs_put_tcon(tcon);
-		else if (pSesInfo)
-			cifs_put_smb_ses(pSesInfo);
+		else if (ses)
+			cifs_put_smb_ses(ses);
 
 		FreeXid(xid);
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
 
 	xid = GetXid();
 
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
@@ -3655,11 +3655,9 @@ try_mount_again:
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
@@ -3677,8 +3675,8 @@ remote_path_check:
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
@@ -3716,8 +3714,7 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 
-		rc = expand_dfs_referral(xid, pSesInfo, volume_info, cifs_sb,
-					 true);
+		rc = expand_dfs_referral(xid, ses, volume_info, cifs_sb, true);
 
 		if (!rc) {
 			referral_walks_count++;
@@ -3739,7 +3736,7 @@ remote_path_check:
 		goto mount_fail_check;
 	}
 
-	tlink->tl_uid = pSesInfo->linux_uid;
+	tlink->tl_uid = ses->linux_uid;
 	tlink->tl_tcon = tcon;
 	tlink->tl_time = jiffies;
 	set_bit(TCON_LINK_MASTER, &tlink->tl_flags);
@@ -3760,10 +3757,10 @@ mount_fail_check:
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
index fc17951..00cae9e 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -421,6 +421,13 @@ cifs_get_dfs_refer(const int xid, struct cifs_ses *ses, const char *search_name,
 	/* BB map targetUNCs to dfs_info3 here or in CIFSGetDFSRefer. */
 }
 
+static void
+cifs_qfs_tcon(const int xid, struct cifs_tcon *tcon)
+{
+	CIFSSMBQFSDeviceInfo(xid, tcon);
+	CIFSSMBQFSAttributeInfo(xid, tcon);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -446,6 +453,7 @@ struct smb_version_operations smb1_operations = {
 	.tree_connect = CIFSTCon,
 	.tree_disconnect = CIFSSMBTDis,
 	.get_dfs_refer = cifs_get_dfs_refer,
+	.qfs_tcon = cifs_qfs_tcon,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
