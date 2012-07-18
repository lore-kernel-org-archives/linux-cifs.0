From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 24/45] CIFS: Move async write to ops struct
Date: Wed, 18 Jul 2012 19:48:40 +0400
Message-ID: <1342626541-29872-25-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 +++
 fs/cifs/cifssmb.c  |    4 +++-
 fs/cifs/file.c     |   13 +++++++++++--
 fs/cifs/smb1ops.c  |    1 +
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9ce1353..61a013e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -173,6 +173,7 @@ struct cifs_fattr;
 struct smb_vol;
 struct cifs_fid;
 struct cifs_readdata;
+struct cifs_writedata;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -283,6 +284,8 @@ struct smb_version_operations {
 	int (*flush)(const unsigned int, struct cifs_tcon *, struct cifs_fid *);
 	/* async read from the server */
 	int (*async_readv)(struct cifs_readdata *);
+	/* async write to the server */
+	int (*async_writev)(struct cifs_writedata *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e37801c..715781a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1921,6 +1921,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 {
 	int i, rc;
 	struct inode *inode = wdata->cfile->dentry->d_inode;
+	struct TCP_Server_Info *server;
 
 	for (i = 0; i < wdata->nr_pages; i++) {
 		lock_page(wdata->pages[i]);
@@ -1928,7 +1929,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 	}
 
 	do {
-		rc = cifs_async_writev(wdata);
+		server = tlink_tcon(wdata->cfile->tlink)->ses->server;
+		rc = server->ops->async_writev(wdata);
 	} while (rc == -EAGAIN);
 
 	for (i = 0; i < wdata->nr_pages; i++) {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 81403ad..fd2c8bb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1747,6 +1747,7 @@ static int cifs_writepages(struct address_space *mapping,
 	bool done = false, scanned = false, range_whole = false;
 	pgoff_t end, index;
 	struct cifs_writedata *wdata;
+	struct TCP_Server_Info *server;
 	struct page *page;
 	int rc = 0;
 
@@ -1897,7 +1898,8 @@ retry:
 				break;
 			}
 			wdata->pid = wdata->cfile->pid;
-			rc = cifs_async_writev(wdata);
+			server = tlink_tcon(wdata->cfile->tlink)->ses->server;
+			rc = server->ops->async_writev(wdata);
 		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
 		for (i = 0; i < nr_pages; ++i)
@@ -2228,6 +2230,9 @@ static int
 cifs_uncached_retry_writev(struct cifs_writedata *wdata)
 {
 	int rc;
+	struct TCP_Server_Info *server;
+
+	server = tlink_tcon(wdata->cfile->tlink)->ses->server;
 
 	do {
 		if (wdata->cfile->invalidHandle) {
@@ -2235,7 +2240,7 @@ cifs_uncached_retry_writev(struct cifs_writedata *wdata)
 			if (rc != 0)
 				continue;
 		}
-		rc = cifs_async_writev(wdata);
+		rc = server->ops->async_writev(wdata);
 	} while (rc == -EAGAIN);
 
 	return rc;
@@ -2270,6 +2275,10 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	open_file = file->private_data;
 	tcon = tlink_tcon(open_file->tlink);
+
+	if (!tcon->ses->server->ops->async_writev)
+		return -ENOSYS;
+
 	offset = *poffset;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index e2dbd22..50c3697 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -786,6 +786,7 @@ struct smb_version_operations smb1_operations = {
 	.close = cifs_close_file,
 	.flush = cifs_flush_file,
 	.async_readv = cifs_async_readv,
+	.async_writev = cifs_async_writev,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
