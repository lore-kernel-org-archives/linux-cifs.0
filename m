From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 22/45] CIFS: Move async read to ops struct
Date: Wed, 18 Jul 2012 19:48:38 +0400
Message-ID: <1342626541-29872-23-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h     |    3 +++
 fs/cifs/file.c         |    8 +++++++-
 fs/cifs/smb1ops.c      |    1 +
 fs/cifs/smb2maperror.c |    3 ++-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 797c17a..e71ab49 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -172,6 +172,7 @@ struct dfs_info3_param;
 struct cifs_fattr;
 struct smb_vol;
 struct cifs_fid;
+struct cifs_readdata;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -280,6 +281,8 @@ struct smb_version_operations {
 	int (*close)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
 	/* send a flush request to the server */
 	int (*flush)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
+	/* async read from the server */
+	int (*async_readv)(struct cifs_readdata *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3f2cfb3..81403ad 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2481,6 +2481,9 @@ static int
 cifs_retry_async_readv(struct cifs_readdata *rdata)
 {
 	int rc;
+	struct TCP_Server_Info *server;
+
+	server = tlink_tcon(rdata->cfile->tlink)->ses->server;
 
 	do {
 		if (rdata->cfile->invalidHandle) {
@@ -2488,7 +2491,7 @@ cifs_retry_async_readv(struct cifs_readdata *rdata)
 			if (rc != 0)
 				continue;
 		}
-		rc = cifs_async_readv(rdata);
+		rc = server->ops->async_readv(rdata);
 	} while (rc == -EAGAIN);
 
 	return rc;
@@ -2640,6 +2643,9 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	open_file = file->private_data;
 	tcon = tlink_tcon(open_file->tlink);
 
+	if (!tcon->ses->server->ops->async_readv)
+		return -ENOSYS;
+
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 7e8a2bd..e2dbd22 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -785,6 +785,7 @@ struct smb_version_operations smb1_operations = {
 	.set_fid = cifs_set_fid,
 	.close = cifs_close_file,
 	.flush = cifs_flush_file,
+	.async_readv = cifs_async_readv,
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index be41478..eaf5466 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2455,7 +2455,8 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		return 0;
 
 	/* mask facility */
-	if (log_err && (smb2err != (STATUS_MORE_PROCESSING_REQUIRED)))
+	if (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
+	    (smb2err != STATUS_END_OF_FILE))
 		smb2_print_status(smb2err);
 	else if (cifsFYI & CIFS_RC)
 		smb2_print_status(smb2err);
-- 
1.7.1
