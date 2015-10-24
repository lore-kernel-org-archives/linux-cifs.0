From: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 1/9] vfs: add COPY_FILE_CLONE_ONLY flag
Date: Sun, 25 Oct 2015 07:17:08 +0800
Message-ID: <1445728636-10109-2-git-send-email-tao.peng@primarydata.com>
References: <1445728636-10109-1-git-send-email-tao.peng@primarydata.com>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>,
	Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445728636-10109-1-git-send-email-tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To tell file system not to return partial success in the
.copy_file_range method. This is useful to implement the
clone (or reflink) functionality.

COPY_FILE_CLONE_ONLY is added only to include/linux/fs.h
and thus is not exposed to users. We can replace it with
something like Anna's COPY_FR_REFLINK in uapi/fs.h when
implementing new user visiable APIs like sys_clone.

Signed-off-by: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/read_write.c    | 9 +++++----
 include/linux/fs.h | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index d2da7e4..da11a7f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1349,8 +1349,9 @@ static ssize_t vfs_copy_fr_copy(struct file *file_in, loff_t pos_in,
 
 /*
  * copy_file_range() differs from regular file read and write in that it
- * specifically allows return partial success.  When it does so is up to
- * the copy_file_range method.
+ * specifically allows returning partial success when COPY_FILE_CLONE_ONLY
+ * is not set in the flags argument, in which case it is up to the file system
+ * to decide whether it wants to do so in the copy_file_range method.
  */
 ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
@@ -1360,7 +1361,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	ssize_t ret;
 
-	if (flags != 0)
+	if (flags && flags != COPY_FILE_CLONE_ONLY)
 		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
@@ -1385,7 +1386,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (file_out->f_op->copy_file_range)
 		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
-	if (ret == -EOPNOTSUPP)
+	if (ret == -EOPNOTSUPP && !(flags & COPY_FILE_CLONE_ONLY))
 		ret = vfs_copy_fr_copy(file_in, pos_in, file_out, pos_out, len);
 
 	if (ret > 0) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6220307..1c430fd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1610,6 +1610,9 @@ struct block_device_operations;
 
 struct iov_iter;
 
+/* Tell file system not to return partial success in copy_file_range method */
+#define COPY_FILE_CLONE_ONLY		(1 << 0)
+
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
-- 
1.8.3.1
