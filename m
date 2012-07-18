From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 15/45] CIFS: Add SMB2 support for query_file_info
Date: Wed, 18 Jul 2012 19:48:31 +0400
Message-ID: <1342626541-29872-16-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index eba12b3..0fd5801 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -190,6 +190,26 @@ smb2_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 	return 0;
 }
 
+static int
+smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
+		     struct cifs_fid *fid, FILE_ALL_INFO *data)
+{
+	int rc;
+	struct smb2_file_all_info *smb2_data;
+
+	smb2_data = kzalloc(sizeof(struct smb2_file_all_info) + MAX_NAME * 2,
+			    GFP_KERNEL);
+	if (smb2_data == NULL)
+		return -ENOMEM;
+
+	rc = SMB2_query_info(xid, tcon, fid->persistent_fid, fid->volatile_fid,
+			     smb2_data);
+	if (!rc)
+		move_smb2_info_to_cifs(data, smb2_data);
+	kfree(smb2_data);
+	return rc;
+}
+
 static char *
 smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			struct cifs_tcon *tcon)
@@ -334,6 +354,7 @@ struct smb_version_operations smb21_operations = {
 	.echo = SMB2_echo,
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
+	.query_file_info = smb2_query_file_info,
 	.build_path_to_root = smb2_build_path_to_root,
 	.mkdir = smb2_mkdir,
 	.mkdir_setinfo = smb2_mkdir_setinfo,
-- 
1.7.1
