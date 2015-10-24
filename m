From: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 4/9] vfs: pull btrfs clone API to vfs layer
Date: Sun, 25 Oct 2015 07:17:11 +0800
Message-ID: <1445728636-10109-5-git-send-email-tao.peng@primarydata.com>
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

Now that a few file systems are adding clone functionality, namingly
btrfs, CIFS, NFS (in another series) and XFS
(ttp://oss.sgi.com/archives/xfs/2015-06/msg00407.html), it makes sense
to pull the ioctl to common code.

Signed-off-by: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/ioctl.c              | 40 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  9 +++++++++
 2 files changed, 49 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5d01d26..9a78426 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -215,6 +215,40 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
+			     u64 off, u64 olen, u64 destoff)
+{
+	struct fd src_file = fdget(srcfd);
+	struct inode *src_inode;
+	int ret;
+
+	if (!src_file.file)
+		return -EBADF;
+	/* olen == 0 means src off to eof */
+	if (olen == 0) {
+		src_inode = file_inode(src_file.file);
+		olen = i_size_read(src_inode) - off;
+	}
+	ret = vfs_copy_file_range(src_file.file, off, dst_file,
+				  destoff, olen, COPY_FILE_CLONE_ONLY);
+	/* vfs_copy_file_range returns bytes copied */
+	if (ret > 0)
+		ret = 0;
+
+	fdput(src_file);
+	return ret;
+}
+
+static long ioctl_file_clone_range(struct file *file, void __user *argp)
+{
+	struct file_clone_range args;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	return ioctl_file_clone(file, args.src_fd, args.src_offset,
+				args.src_length, args.dest_offset);
+}
+
 #ifdef CONFIG_BLOCK
 
 static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
@@ -600,6 +634,12 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FICLONE:
+		return ioctl_file_clone(filp, arg, 0, 0, 0);
+
+	case FICLONERANGE:
+		return ioctl_file_clone_range(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5..ac7f1c5 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -39,6 +39,13 @@
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 
+struct file_clone_range {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
 struct fstrim_range {
 	__u64 start;
 	__u64 len;
@@ -159,6 +166,8 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FICLONE		_IOW(0x94, 9, int)	/* Clone */
+#define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)	/* Clone range */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
-- 
1.8.3.1
