From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 08/16] CIFS: Separate writing from iovec write
Date: Mon, 21 Jul 2014 19:45:50 +0400
Message-ID: <1405957558-18476-9-git-send-email-pshilovsky@samba.org>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 76 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f96f61c..6660698 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2465,41 +2465,17 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
 	return 0;
 }
 
-static ssize_t
-cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
+static int
+cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
+		     struct cifsFileInfo *open_file,
+		     struct cifs_sb_info *cifs_sb, struct list_head *wdata_list)
 {
+	int rc = 0;
+	size_t cur_len;
 	unsigned long nr_pages, num_pages, i;
-	size_t len, cur_len;
-	ssize_t total_written = 0;
-	loff_t offset;
-	struct cifsFileInfo *open_file;
-	struct cifs_tcon *tcon;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_writedata *wdata, *tmp;
-	struct list_head wdata_list;
-	int rc;
+	struct cifs_writedata *wdata;
 	pid_t pid;
 
-	len = iov_iter_count(from);
-	rc = generic_write_checks(file, poffset, &len, 0);
-	if (rc)
-		return rc;
-
-	if (!len)
-		return 0;
-
-	iov_iter_truncate(from, len);
-
-	INIT_LIST_HEAD(&wdata_list);
-	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	open_file = file->private_data;
-	tcon = tlink_tcon(open_file->tlink);
-
-	if (!tcon->ses->server->ops->async_writev)
-		return -ENOSYS;
-
-	offset = *poffset;
-
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
 	else
@@ -2551,11 +2527,47 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
 			break;
 		}
 
-		list_add_tail(&wdata->list, &wdata_list);
+		list_add_tail(&wdata->list, wdata_list);
 		offset += cur_len;
 		len -= cur_len;
 	} while (len > 0);
 
+	return rc;
+}
+
+static ssize_t
+cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
+{
+	size_t len;
+	ssize_t total_written = 0;
+	struct cifsFileInfo *open_file;
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_writedata *wdata, *tmp;
+	struct list_head wdata_list;
+	int rc;
+
+	len = iov_iter_count(from);
+	rc = generic_write_checks(file, poffset, &len, 0);
+	if (rc)
+		return rc;
+
+	if (!len)
+		return 0;
+
+	iov_iter_truncate(from, len);
+
+	INIT_LIST_HEAD(&wdata_list);
+	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	open_file = file->private_data;
+	tcon = tlink_tcon(open_file->tlink);
+
+	if (!tcon->ses->server->ops->async_writev)
+		return -ENOSYS;
+
+	rc = cifs_write_from_iter(*poffset, len, from, open_file, cifs_sb,
+				  &wdata_list);
+
 	/*
 	 * If at least one write was successfully sent, then discard any rc
 	 * value from the later writes. If the other write succeeds, then
-- 
1.8.1.2
