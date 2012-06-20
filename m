From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 13/24] CIFS: Move getting dfs referalls to ops struct
Date: Wed, 20 Jun 2012 18:30:53 +0400
Message-ID: <1340202664-28696-14-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 +++++
 fs/cifs/cifsproto.h |   15 +++++++--------
 fs/cifs/cifssmb.c   |   13 ++++++-------
 fs/cifs/connect.c   |   15 ++++++++-------
 fs/cifs/smb1ops.c   |    1 +
 5 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 04100c7..8b66fb8 100644
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
 	int (*tree_disconnect)(const unsigned int, struct cifs_tcon *);
+	/* get DFS referrals */
+	int (*get_dfs_refer)(const unsigned int, struct cifs_ses *,
+			     const char *, struct dfs_info3_param **,
+			     unsigned int *, const struct nls_table *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 16adcaa..416d820 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -226,17 +226,16 @@ extern int CIFSSMBUnixQPathInfo(const unsigned int xid,
 			const struct nls_table *nls_codepage, int remap);
 
 extern int CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
-			const unsigned char *searchName,
-			struct dfs_info3_param **target_nodes,
-			unsigned int *number_of_nodes_in_array,
-			const struct nls_table *nls_codepage, int remap);
+			   const char *search_name,
+			   struct dfs_info3_param **target_nodes,
+			   unsigned int *num_of_nodes,
+			   const struct nls_table *nls_codepage, int remap);
 
-extern int get_dfs_path(unsigned int xid, struct cifs_ses *pSesInfo,
+extern int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 			const char *old_path,
 			const struct nls_table *nls_codepage,
-			unsigned int *pnum_referrals,
-			struct dfs_info3_param **preferrals,
-			int remap);
+			unsigned int *num_referrals,
+			struct dfs_info3_param **referrals, int remap);
 extern void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 				 struct cifs_sb_info *cifs_sb,
 				 struct smb_vol *vol);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f7a3402..df0652a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4747,8 +4747,7 @@ parse_DFS_referrals_exit:
 
 int
 CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
-		const unsigned char *searchName,
-		struct dfs_info3_param **target_nodes,
+		const char *search_name, struct dfs_info3_param **target_nodes,
 		unsigned int *num_of_nodes,
 		const struct nls_table *nls_codepage, int remap)
 {
@@ -4762,7 +4761,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 	*num_of_nodes = 0;
 	*target_nodes = NULL;
 
-	cFYI(1, "In GetDFSRefer the path %s", searchName);
+	cFYI(1, "In GetDFSRefer the path %s", search_name);
 	if (ses == NULL)
 		return -ENODEV;
 getDFSRetry:
@@ -4785,14 +4784,14 @@ getDFSRetry:
 		pSMB->hdr.Flags2 |= SMBFLG2_UNICODE;
 		name_len =
 		    cifsConvertToUTF16((__le16 *) pSMB->RequestFileName,
-				       searchName, PATH_MAX, nls_codepage,
+				       search_name, PATH_MAX, nls_codepage,
 				       remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
 	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(searchName, PATH_MAX);
+		name_len = strnlen(search_name, PATH_MAX);
 		name_len++;	/* trailing null */
-		strncpy(pSMB->RequestFileName, searchName, name_len);
+		strncpy(pSMB->RequestFileName, search_name, name_len);
 	}
 
 	if (ses->server) {
@@ -4848,7 +4847,7 @@ getDFSRetry:
 	/* parse returned result into more usable form */
 	rc = parse_DFS_referrals(pSMBr, num_of_nodes,
 				 target_nodes, nls_codepage, remap,
-				 searchName);
+				 search_name);
 
 GetDFSRefExit:
 	cifs_buf_release(pSMB);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9dc0d92..1306fb5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2766,14 +2766,14 @@ out:
 }
 
 int
-get_dfs_path(unsigned int xid, struct cifs_ses *ses, const char *old_path,
+get_dfs_path(const unsigned int xid, struct cifs_ses *ses, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *num_referrals,
 	     struct dfs_info3_param **referrals, int remap)
 {
 	char *temp_unc;
 	int rc = 0;
 
-	if (!ses->server->ops->tree_connect)
+	if (!ses->server->ops->tree_connect || !ses->server->ops->get_dfs_refer)
 		return -ENOSYS;
 
 	*num_referrals = 0;
@@ -2795,11 +2795,12 @@ get_dfs_path(unsigned int xid, struct cifs_ses *ses, const char *old_path,
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
@@ -3472,7 +3473,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
  * determine whether there were referrals.
  */
 static int
-expand_dfs_referral(unsigned int xid, struct cifs_ses *pSesInfo,
+expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 		    struct smb_vol *volume_info, struct cifs_sb_info *cifs_sb,
 		    int check_prefix)
 {
@@ -3488,7 +3489,7 @@ expand_dfs_referral(unsigned int xid, struct cifs_ses *pSesInfo,
 	/* For DFS paths, skip the first '\' of the UNC */
 	ref_path = check_prefix ? full_path + 1 : volume_info->UNC + 1;
 
-	rc = get_dfs_path(xid, pSesInfo , ref_path, cifs_sb->local_nls,
+	rc = get_dfs_path(xid, ses, ref_path, cifs_sb->local_nls,
 			  &num_referrals, &referrals,
 			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8f87386..6d9025b 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -434,6 +434,7 @@ struct smb_version_operations smb1_operations = {
 	.logoff = CIFSSMBLogoff,
 	.tree_connect = CIFSTCon,
 	.tree_disconnect = CIFSSMBTDis,
+	.get_dfs_refer = CIFSGetDFSRefer,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
