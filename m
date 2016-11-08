From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 2/6] fs/cifs: implement get_dfs_refer for smb2
Date: Tue,  8 Nov 2016 17:33:22 +0100
Message-ID: <1478622806-19636-3-git-send-email-aaptel@suse.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Few issues with the current situation

* the get_dfs_refer op is meant to be used from cifs thus the prototype
  of the operation is not adapted for smb2:

  - it passes a session as opposed to a tcon like other smb2 operations,
    which means we have to find the corresponding tcon ourselves. see
    new function find_session_tcon() which currently assumes the first one
    is the right one.

  - it doesn't pass a cifs_sb so we cannot use the usual utf16
    conversion function used in the rest of smb2 code

* the DFS request has to be made on the IPC tcon and i'm not really sure
  how to get to it since it doesnt seem to be part of the session tcon
  list.

* the function that extracts the data from the responce is almost
  entirely copied and adapted from the smb1 code. ideally they should be
  merged.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2ops.c | 206 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d456eb..677579b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1093,6 +1093,212 @@ smb2_new_lease_key(struct cifs_fid *fid)
 	generate_random_uuid(fid->lease_key);
 }
 
+/*
+ * XXX: Return the tcon currently used in the session
+ */
+static struct cifs_tcon *
+find_session_tcon (struct cifs_ses *ses)
+{
+	struct cifs_tcon *tcon = NULL, *it;
+	struct list_head *tmp;
+	int i = 0;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(tmp, &ses->tcon_list) {
+		it = list_entry(tmp, struct cifs_tcon, tcon_list);
+		cifs_dbg(FYI, "XXX: [%d] tcon %p\n", i, it);
+
+		/* XXX: Assumes the first one is always the right one. */
+		if (i == 0) {
+			tcon = it;
+		}
+		i++;
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	if (!tcon)
+		cifs_dbg(FYI, "XXX: cannot find our tcon\n");
+	return tcon;
+}
+
+/*
+ * XXX: Copied and adapted from parse_DFS_referrals in cifssmb.c
+ * TODO: extract logic in a SMB agnostic way
+ */
+static int
+smb2_parse_dfs_referrers_rsp(struct fsctl_get_dfs_referral_rsp *rsp, u32 rsp_size,
+			     unsigned int *num_of_nodes,
+			     struct dfs_info3_param **target_nodes,
+			     const struct nls_table *nls_codepage, int remap,
+			     const char *searchName)
+{
+	int i, rc = 0;
+	char *data_end;
+	bool is_unicode = true;
+	struct dfs_referral_level_3 *ref;
+
+	*num_of_nodes = le16_to_cpu(rsp->NumberOfReferrals);
+
+	if (*num_of_nodes < 1) {
+		cifs_dbg(VFS, "num_referrals: must be at least > 0, but we get num_referrals = %d\n",
+			 *num_of_nodes);
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
+	ref = (struct dfs_referral_level_3 *) &rsp->buffer[0];
+	if (ref->VersionNumber != cpu_to_le16(3)) {
+		cifs_dbg(VFS, "Referrals of V%d version are not supported, should be V3\n",
+			 le16_to_cpu(ref->VersionNumber));
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
+	/* get the upper boundary of the resp buffer */
+	data_end = (char *)(&(rsp->PathConsumed)) + rsp_size;
+
+	cifs_dbg(FYI, "num_referrals: %d dfs flags: 0x%x ...\n",
+		 *num_of_nodes, le32_to_cpu(rsp->ReferralHeaderFlags));
+
+	*target_nodes = kcalloc(*num_of_nodes, sizeof(struct dfs_info3_param),
+				GFP_KERNEL);
+	if (*target_nodes == NULL) {
+		rc = -ENOMEM;
+		goto parse_DFS_referrals_exit;
+	}
+
+	/* collect necessary data from referrals */
+	for (i = 0; i < *num_of_nodes; i++) {
+		char *temp;
+		int max_len;
+		__le16 *tmp;
+		struct dfs_info3_param *node = (*target_nodes)+i;
+
+		node->flags = le32_to_cpu(rsp->ReferralHeaderFlags);
+		tmp = kmalloc(strlen(searchName)*2 + 2,
+			      GFP_KERNEL);
+		if (tmp == NULL) {
+			rc = -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+		cifsConvertToUTF16((__le16 *) tmp, searchName,
+				   PATH_MAX, nls_codepage, remap);
+		node->path_consumed = cifs_utf16_bytes(tmp,
+						       le16_to_cpu(rsp->PathConsumed),
+						       nls_codepage);
+		kfree(tmp);
+
+		node->server_type = le16_to_cpu(ref->ServerType);
+		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
+
+		/* copy DfsPath */
+		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
+		max_len = data_end - temp;
+		node->path_name = cifs_strndup_from_utf16(temp, max_len,
+							  true /* is_unicode */, nls_codepage);
+		if (!node->path_name) {
+			rc = -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+
+		/* copy link target UNC */
+		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
+		max_len = data_end - temp;
+		node->node_name = cifs_strndup_from_utf16(temp, max_len,
+						is_unicode, nls_codepage);
+		if (!node->node_name) {
+			rc = -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+
+		ref++;
+	}
+
+parse_DFS_referrals_exit:
+	if (rc) {
+		free_dfs_info_array(*target_nodes, *num_of_nodes);
+		*target_nodes = NULL;
+		*num_of_nodes = 0;
+	}
+	return rc;
+}
+
+
+static int
+smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
+		   const char *search_name, struct dfs_info3_param **target_nodes,
+		   unsigned int *num_of_nodes,
+		   const struct nls_table *nls_codepage, int remap)
+{
+	int rc = -ENOSYS;
+	__le16 *utf16_path = NULL;
+	int utf16_path_len = 0;
+	struct cifs_tcon *tcon;
+	struct fsctl_get_dfs_referral_req *dfs_req = NULL;
+	struct fsctl_get_dfs_referral_rsp *dfs_rsp = NULL;
+	u32 dfs_req_size = 0, dfs_rsp_size = 0;
+
+	cifs_dbg(FYI, "XXX: In smb2_get_dfs_refer the path <%s> %d\n", search_name, (int)strlen(search_name));
+
+	/*
+	 * XXX: Find this session tcon. We shouldnt have to do this
+	 * proper solution would be to update get_dfs_refer op
+	 * prototype to pass it somehow.
+	 */
+	tcon = find_session_tcon(ses);
+	if (!tcon)
+		goto out;
+
+	/*
+	 * XXX: Should we use use cifs_convert_path_to_utf16(full_path, cifs_sb) instead?
+	 * it needs cifs_sb superblock pointer which we don't have...
+	 */
+
+	utf16_path_len = strlen(search_name) * 2;
+	utf16_path = kzalloc(utf16_path_len + 2, GFP_KERNEL);
+	if (!utf16_path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cifsConvertToUTF16(utf16_path,
+			   search_name, PATH_MAX, nls_codepage,
+			   remap);
+
+	dfs_req_size = sizeof(*dfs_req) + utf16_path_len + 2;
+	dfs_req = kzalloc(dfs_req_size, GFP_KERNEL);
+	if (!dfs_req) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* Highest DFS referral version understood (actually the only supported one) */
+	dfs_req->MaxReferralLevel = cpu_to_le16(DFS_VERSION);
+	/* Path to resolve in an UTF-16 null-terminated string */
+	memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
+
+	do {
+		rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
+				FSCTL_DFS_GET_REFERRALS, true /* is_fsctl */,
+				(char *)dfs_req, dfs_req_size,
+				(char **)&dfs_rsp, &dfs_rsp_size);
+		if (rc) {
+			cifs_dbg(FYI, "SMB2_ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
+			goto out;
+		}
+
+		rc = smb2_parse_dfs_referrers_rsp(dfs_rsp, dfs_rsp_size,
+						  num_of_nodes, target_nodes,
+						  nls_codepage, remap, search_name);
+		kfree(dfs_rsp);
+	} while (rc == -EAGAIN);
+
+ out:
+	kfree(utf16_path);
+	kfree(dfs_req);
+	return rc;
+}
+
 #define SMB2_SYMLINK_STRUCT_SIZE \
 	(sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
 
-- 
2.1.4
