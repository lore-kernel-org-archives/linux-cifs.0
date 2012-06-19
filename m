From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 11/22] CIFS: Move getting dfs referalls to ops struct
Date: Tue, 19 Jun 2012 16:40:00 +0400
Message-ID: <1340109611-7210-12-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 +++++
 fs/cifs/cifsproto.h |    8 ++++----
 fs/cifs/cifssmb.c   |    3 +--
 fs/cifs/connect.c   |    9 +++++----
 fs/cifs/smb1ops.c   |   12 ++++++++++++
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3215026..e045c31 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -162,6 +162,7 @@ struct TCP_Server_Info;
 struct cifsFileInfo;
 struct cifs_ses;
 struct cifs_tcon;
+struct dfs_info3_param;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -208,6 +209,10 @@ struct smb_version_operations {
 			    struct cifs_tcon *, const struct nls_table *);
 	/* close tree connecion */
 	int (*tree_disconnect)(const int, struct cifs_tcon *);
+	/* get DFS referrals */
+	int (*get_dfs_refer)(const int, struct cifs_ses *, const char *,
+			     struct dfs_info3_param **, unsigned int *,
+			     const struct nls_table *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6152571..8b5f2a6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -223,10 +223,10 @@ extern int CIFSSMBUnixQPathInfo(const int xid,
 			const struct nls_table *nls_codepage, int remap);
 
 extern int CIFSGetDFSRefer(const int xid, struct cifs_ses *ses,
-			const unsigned char *searchName,
-			struct dfs_info3_param **target_nodes,
-			unsigned int *number_of_nodes_in_array,
-			const struct nls_table *nls_codepage, int remap);
+			   const char *searchName,
+			   struct dfs_info3_param **target_nodes,
+			   unsigned int *num_of_nodes,
+			   const struct nls_table *nls_codepage, int remap);
 
 extern int get_dfs_path(int xid, struct cifs_ses *pSesInfo,
 			const char *old_path,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c3bfe9a..13e1c7f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4741,8 +4741,7 @@ parse_DFS_referrals_exit:
 }
 
 int
-CIFSGetDFSRefer(const int xid, struct cifs_ses *ses,
-		const unsigned char *searchName,
+CIFSGetDFSRefer(const int xid, struct cifs_ses *ses, const char *searchName,
 		struct dfs_info3_param **target_nodes,
 		unsigned int *num_of_nodes,
 		const struct nls_table *nls_codepage, int remap)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d6fc429..5e62b3a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2772,7 +2772,7 @@ get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
 	char *temp_unc;
 	int rc = 0;
 
-	if (!ses->server->ops->tree_connect)
+	if (!ses->server->ops->tree_connect || !ses->server->ops->get_dfs_refer)
 		return -ENOSYS;
 
 	*num_referrals = 0;
@@ -2794,11 +2794,12 @@ get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
 		kfree(temp_unc);
 	}
 	if (rc == 0)
-		rc = CIFSGetDFSRefer(xid, ses, old_path, referrals,
-				     num_referrals, nls_codepage, remap);
+		rc = ses->server->ops->get_dfs_refer(xid, ses, old_path,
+						     referrals, num_referrals,
+						     nls_codepage, remap);
 	/*
 	 * BB - map targetUNCs to dfs_info3 structures, here or in
-	 * CIFSGetDFSRefer.
+	 * ses->server->ops->get_dfs_refer.
 	 */
 
 	return rc;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index cd7fbfd..fc17951 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -410,6 +410,17 @@ cifs_negotiate(const int xid, struct cifs_ses *ses)
 	return rc;
 }
 
+static int
+cifs_get_dfs_refer(const int xid, struct cifs_ses *ses, const char *search_name,
+		   struct dfs_info3_param **target_nodes,
+		   unsigned int *num_of_nodes,
+		   const struct nls_table *nls_codepage, int remap)
+{
+	return CIFSGetDFSRefer(xid, ses, search_name, target_nodes,
+			       num_of_nodes, nls_codepage, remap);
+	/* BB map targetUNCs to dfs_info3 here or in CIFSGetDFSRefer. */
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -434,6 +445,7 @@ struct smb_version_operations smb1_operations = {
 	.logoff = CIFSSMBLogoff,
 	.tree_connect = CIFSTCon,
 	.tree_disconnect = CIFSSMBTDis,
+	.get_dfs_refer = cifs_get_dfs_refer,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
