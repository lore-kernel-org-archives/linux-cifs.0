From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 7/7] CIFS: Move protocol specific tcon/tdis code to ops struct
Date: Tue, 29 May 2012 20:19:04 +0400
Message-ID: <1338308344-29149-8-git-send-email-pshilovsky@samba.org>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338308344-29149-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and rename variables around the code changes.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    6 ++++++
 fs/cifs/cifsproto.h |    5 ++---
 fs/cifs/connect.c   |   47 ++++++++++++++++++++++++-----------------------
 fs/cifs/smb1ops.c   |    2 ++
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 665c04e..8660d28 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -160,6 +160,7 @@ struct mid_q_entry;
 struct TCP_Server_Info;
 struct cifsFileInfo;
 struct cifs_ses;
+struct cifs_tcon;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -201,6 +202,11 @@ struct smb_version_operations {
 			  const struct nls_table *);
 	/* close smb session */
 	int (*logoff)(const int, struct cifs_ses *);
+	/* connect to a server share */
+	int (*tree_connect)(const int, struct cifs_ses *, const char *,
+			    struct cifs_tcon *, const struct nls_table *);
+	/* close tree connecion */
+	int (*tree_disconnect)(const int, struct cifs_tcon *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 62e9c5b..43d8ae6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -183,9 +183,8 @@ extern int cifs_setup_session(const int xid, struct cifs_ses *ses,
 			      struct nls_table *nls_info);
 extern int CIFSSMBNegotiate(const int xid, struct cifs_ses *ses);
 
-extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
-			const char *tree, struct cifs_tcon *tcon,
-			const struct nls_table *);
+extern int CIFSTCon(const int xid, struct cifs_ses *ses, const char *tree,
+		    struct cifs_tcon *tcon, const struct nls_table *);
 
 extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
 		const char *searchName, const struct nls_table *nls_codepage,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7285c4f..72b0496 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2549,7 +2549,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	xid = GetXid();
-	CIFSSMBTDis(xid, tcon);
+	S_OPV(ses->server, tree_disconnect, xid, tcon);
 	_FreeXid(xid);
 
 	cifs_fscache_release_super_cookie(tcon);
@@ -2596,13 +2596,15 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		goto out_fail;
 	}
 
-	/* BB Do we need to wrap session_mutex around
-	 * this TCon call and Unix SetFS as
-	 * we do on SessSetup and reconnect? */
+	/*
+	 * BB Do we need to wrap session_mutex around this TCon call and Unix
+	 * SetFS as we do on SessSetup and reconnect?
+	 */
 	xid = GetXid();
-	rc = CIFSTCon(xid, ses, volume_info->UNC, tcon, volume_info->local_nls);
+	rc = S_OP(ses->server, tree_connect, -ENOSYS, xid, ses,
+		  volume_info->UNC, tcon, volume_info->local_nls);
 	FreeXid(xid);
-	cFYI(1, "CIFS Tcon rc = %d", rc);
+	cFYI(1, "Tcon rc = %d", rc);
 	if (rc)
 		goto out_fail;
 
@@ -2748,35 +2750,34 @@ out:
 }
 
 int
-get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
-	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
-	     struct dfs_info3_param **preferrals, int remap)
+get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
+	     const struct nls_table *nls_codepage, unsigned int *num_referrals,
+	     struct dfs_info3_param **referrals, int remap)
 {
 	char *temp_unc;
 	int rc = 0;
 
-	*pnum_referrals = 0;
-	*preferrals = NULL;
+	*num_referrals = 0;
+	*referrals = NULL;
 
-	if (pSesInfo->ipc_tid == 0) {
+	if (ses->ipc_tid == 0) {
 		temp_unc = kmalloc(2 /* for slashes */ +
-			strnlen(pSesInfo->serverName,
-				SERVER_NAME_LEN_WITH_NULL * 2)
-				 + 1 + 4 /* slash IPC$ */  + 2,
-				GFP_KERNEL);
+			strnlen(ses->serverName, SERVER_NAME_LEN_WITH_NULL * 2)
+				+ 1 + 4 /* slash IPC$ */ + 2, GFP_KERNEL);
 		if (temp_unc == NULL)
 			return -ENOMEM;
 		temp_unc[0] = '\\';
 		temp_unc[1] = '\\';
-		strcpy(temp_unc + 2, pSesInfo->serverName);
-		strcpy(temp_unc + 2 + strlen(pSesInfo->serverName), "\\IPC$");
-		rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
-		cFYI(1, "CIFS Tcon rc = %d ipc_tid = %d", rc, pSesInfo->ipc_tid);
+		strcpy(temp_unc + 2, ses->serverName);
+		strcpy(temp_unc + 2 + strlen(ses->serverName), "\\IPC$");
+		rc = S_OP(ses->server, tree_connect, -ENOSYS, xid, ses,
+			  temp_unc, NULL, nls_codepage);
+		cFYI(1, "Tcon rc = %d ipc_tid = %d", rc, ses->ipc_tid);
 		kfree(temp_unc);
 	}
 	if (rc == 0)
-		rc = CIFSGetDFSRefer(xid, pSesInfo, old_path, preferrals,
-				     pnum_referrals, nls_codepage, remap);
+		rc = CIFSGetDFSRefer(xid, ses, old_path, referrals,
+				     num_referrals, nls_codepage, remap);
 	/* BB map targetUNCs to dfs_info3 structures, here or
 		in CIFSGetDFSRefer BB */
 
@@ -3755,7 +3756,7 @@ out:
  * pointer may be NULL.
  */
 int
-CIFSTCon(unsigned int xid, struct cifs_ses *ses,
+CIFSTCon(const int xid, struct cifs_ses *ses,
 	 const char *tree, struct cifs_tcon *tcon,
 	 const struct nls_table *nls_codepage)
 {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index ba3071f..1a3f08c 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -432,6 +432,8 @@ struct smb_version_operations smb1_operations = {
 	.negotiate = cifs_negotiate,
 	.sess_setup = CIFS_SessSetup,
 	.logoff = CIFSSMBLogoff,
+	.tree_connect = CIFSTCon,
+	.tree_disconnect = CIFSSMBTDis,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
