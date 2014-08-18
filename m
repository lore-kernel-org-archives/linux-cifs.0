From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH 1/2] CIFS: Fix SMB2 readdir error handling
Date: Mon, 18 Aug 2014 20:49:57 +0400
Message-ID: <1408380598-11737-1-git-send-email-pshilovsky@samba.org>
Cc: <stable@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

SMB2 servers indicates the end of a directory search with
STATUS_NO_MORE_FILE error code that is not processed now.
This causes generic/257 xfstest to fail. Fix this by triggering
the end of search by this error code in SMB2_query_directory.

Also when negotiating CIFS protocol we tell the server to close
the search automatically at the end and there is no need to do
it itself. In the case of SMB2 protocol, we need to close it
explicitly - separate close directory checks for different
protocols.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
---
 fs/cifs/cifsglob.h     | 2 ++
 fs/cifs/file.c         | 2 +-
 fs/cifs/readdir.c      | 2 +-
 fs/cifs/smb1ops.c      | 7 +++++++
 fs/cifs/smb2maperror.c | 2 +-
 fs/cifs/smb2ops.c      | 9 +++++++++
 fs/cifs/smb2pdu.c      | 9 ++++-----
 7 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0012e1e..365a752 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -409,6 +409,8 @@ struct smb_version_operations {
 	/* get mtu credits */
 	int (*wait_mtu_credits)(struct TCP_Server_Info *, unsigned int,
 				unsigned int *, unsigned int *);
+	/* check if we need to issue closedir */
+	bool (*dir_needs_close)(struct cifsFileInfo *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 12b64e0..a8ca44d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -762,7 +762,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 
 	cifs_dbg(FYI, "Freeing private data in close dir\n");
 	spin_lock(&cifs_file_list_lock);
-	if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+	if (server->ops->dir_needs_close(cfile)) {
 		cfile->invalidHandle = true;
 		spin_unlock(&cifs_file_list_lock);
 		if (server->ops->close_dir)
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index b15862e..798c80a 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -593,7 +593,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		/* close and restart search */
 		cifs_dbg(FYI, "search backing up - close and restart search\n");
 		spin_lock(&cifs_file_list_lock);
-		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+		if (server->ops->dir_needs_close(cfile)) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
 			if (server->ops->close)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5e8c22d..1a6df4b 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1015,6 +1015,12 @@ cifs_wp_retry_size(struct inode *inode)
 	return CIFS_SB(inode->i_sb)->wsize;
 }
 
+static bool
+cifs_dir_needs_close(struct cifsFileInfo *cfile)
+{
+	return !cfile->srch_inf.endOfSearch && !cfile->invalidHandle;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -1086,6 +1092,7 @@ struct smb_version_operations smb1_operations = {
 	.create_mf_symlink = cifs_create_mf_symlink,
 	.is_read_op = cifs_is_read_op,
 	.wp_retry_size = cifs_wp_retry_size,
+	.dir_needs_close = cifs_dir_needs_close,
 #ifdef CONFIG_CIFS_XATTR
 	.query_all_EAs = CIFSSMBQAllEAs,
 	.set_EA = CIFSSMBSetEA,
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index e31a9df..a689514 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -214,7 +214,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_BREAKPOINT, -EIO, "STATUS_BREAKPOINT"},
 	{STATUS_SINGLE_STEP, -EIO, "STATUS_SINGLE_STEP"},
 	{STATUS_BUFFER_OVERFLOW, -EIO, "STATUS_BUFFER_OVERFLOW"},
-	{STATUS_NO_MORE_FILES, -EIO, "STATUS_NO_MORE_FILES"},
+	{STATUS_NO_MORE_FILES, -ENODATA, "STATUS_NO_MORE_FILES"},
 	{STATUS_WAKE_SYSTEM_DEBUGGER, -EIO, "STATUS_WAKE_SYSTEM_DEBUGGER"},
 	{STATUS_HANDLES_CLOSED, -EIO, "STATUS_HANDLES_CLOSED"},
 	{STATUS_NO_INHERITANCE, -EIO, "STATUS_NO_INHERITANCE"},
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 77f8aeb..272c531 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1161,6 +1161,12 @@ smb2_wp_retry_size(struct inode *inode)
 		     SMB2_MAX_BUFFER_SIZE);
 }
 
+static bool
+smb2_dir_needs_close(struct cifsFileInfo *cfile)
+{
+	return !cfile->invalidHandle;
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -1236,6 +1242,7 @@ struct smb_version_operations smb20_operations = {
 	.parse_lease_buf = smb2_parse_lease_buf,
 	.clone_range = smb2_clone_range,
 	.wp_retry_size = smb2_wp_retry_size,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -1313,6 +1320,7 @@ struct smb_version_operations smb21_operations = {
 	.parse_lease_buf = smb2_parse_lease_buf,
 	.clone_range = smb2_clone_range,
 	.wp_retry_size = smb2_wp_retry_size,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -1393,6 +1401,7 @@ struct smb_version_operations smb30_operations = {
 	.clone_range = smb2_clone_range,
 	.validate_negotiate = smb3_validate_negotiate,
 	.wp_retry_size = smb2_wp_retry_size,
+	.dir_needs_close = smb2_dir_needs_close,
 };
 
 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 42ebc1a..bf8a17b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2177,6 +2177,10 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
 
 	if (rc) {
+		if (rc == -ENODATA && rsp->hdr.Status == STATUS_NO_MORE_FILES) {
+			srch_inf->endOfSearch = true;
+			rc = 0;
+		}
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
 		goto qdir_exit;
 	}
@@ -2214,11 +2218,6 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifs_dbg(VFS, "illegal search buffer type\n");
 
-	if (rsp->hdr.Status == STATUS_NO_MORE_FILES)
-		srch_inf->endOfSearch = 1;
-	else
-		srch_inf->endOfSearch = 0;
-
 	return rc;
 
 qdir_exit:
-- 
1.8.3.2
