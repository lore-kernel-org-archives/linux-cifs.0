From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/9] CIFS: Separate writing from iovec write
Date: Mon, 23 Jun 2014 18:58:35 +0400
Message-ID: <1403535517-8301-8-git-send-email-pshilovsky@samba.org>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c |   75 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 89d647b..887c18c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2470,41 +2470,19 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *it,
 	return rc;
 }
 
-static ssize_t
-cifs_iovec_write(struct file *file, const struct iovec *iov,
-		 unsigned long nr_segs, loff_t *poffset)
+static int
+cifs_write_from_iovec(loff_t offset, size_t len, const struct iovec *iov,
+		      unsigned long nr_segs, struct cifsFileInfo *open_file,
+		      struct cifs_sb_info *cifs_sb,
+		      struct list_head *wdata_list)
 {
+	int rc = 0;
+	size_t cur_len;
 	unsigned long nr_pages, i;
-	size_t len, cur_len;
-	ssize_t total_written = 0;
-	loff_t offset;
+	struct cifs_writedata *wdata;
 	struct iov_iter it;
-	struct cifsFileInfo *open_file;
-	struct cifs_tcon *tcon;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_writedata *wdata, *tmp;
-	struct list_head wdata_list;
-	int rc;
 	pid_t pid;
 
-	len = iov_length(iov, nr_segs);
-	if (!len)
-		return 0;
-
-	rc = generic_write_checks(file, poffset, &len, 0);
-	if (rc)
-		return rc;
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
@@ -2549,11 +2527,46 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
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
+cifs_iovec_write(struct file *file, const struct iovec *iov,
+		 unsigned long nr_segs, loff_t *poffset)
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
+	len = iov_length(iov, nr_segs);
+	if (!len)
+		return 0;
+
+	rc = generic_write_checks(file, poffset, &len, 0);
+	if (rc)
+		return rc;
+
+	INIT_LIST_HEAD(&wdata_list);
+	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	open_file = file->private_data;
+	tcon = tlink_tcon(open_file->tlink);
+
+	if (!tcon->ses->server->ops->async_writev)
+		return -ENOSYS;
+
+	rc = cifs_write_from_iovec(*poffset, len, iov, nr_segs, open_file,
+				   cifs_sb, &wdata_list);
+
 	/*
 	 * If at least one write was successfully sent, then discard any rc
 	 * value from the later writes. If the other write succeeds, then
-- 
1.7.10.4
