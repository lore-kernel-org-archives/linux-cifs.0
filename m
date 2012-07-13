From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 26/32] CIFS: Add SMB2 support for build_path_to_root
Date: Fri, 13 Jul 2012 11:53:39 +0400
Message-ID: <1342166025-29377-27-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bcf310c..2f9950e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -190,6 +190,23 @@ smb2_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 	return 0;
 }
 
+static char *
+smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
+			struct cifs_tcon *tcon)
+{
+	int pplen = vol->prepath ? strlen(vol->prepath) : 0;
+	char *full_path = NULL;
+
+	/* if no prefix path, simply set path to the root of share to "" */
+	if (pplen == 0) {
+		full_path = kzalloc(2, GFP_KERNEL);
+		return full_path;
+	}
+
+	cERROR(1, "prefixpath is not supported for SMB2 now");
+	return NULL;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -210,6 +227,7 @@ struct smb_version_operations smb21_operations = {
 	.is_path_accessible = smb2_is_path_accessible,
 	.query_path_info = smb2_query_path_info,
 	.get_srv_inum = smb2_get_srv_inum,
+	.build_path_to_root = smb2_build_path_to_root,
 };
 
 struct smb_version_values smb21_values = {
-- 
1.7.1
