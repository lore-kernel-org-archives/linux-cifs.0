From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/8] cifs: rename pTcon to tcon in cifs_iovec_write
Date: Fri,  3 Feb 2012 09:32:56 -0500
Message-ID: <1328279581-21889-4-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5e758d8..febf32e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2051,9 +2051,8 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct iov_iter it;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_io_parms io_parms;
 	int xid, rc;
 	__u32 pid;
 
@@ -2093,7 +2092,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	else
 		pid = current->tgid;
 
-	pTcon = tlink_tcon(open_file->tlink);
+	tcon = tlink_tcon(open_file->tlink);
 	inode = file->f_path.dentry->d_inode;
 
 	iov_iter_init(&it, iov, nr_segs, len, 0);
@@ -2121,7 +2120,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 			}
 			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
+			io_parms.tcon = tcon;
 			io_parms.offset = *poffset;
 			io_parms.length = cur_len;
 			rc = CIFSSMBWrite2(xid, &io_parms, &written, to_send,
@@ -2153,7 +2152,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		spin_unlock(&inode->i_lock);
 	}
 
-	cifs_stats_bytes_written(pTcon, total_written);
+	cifs_stats_bytes_written(tcon, total_written);
 	mark_inode_dirty_sync(inode);
 
 	for (i = 0; i < num_pages; i++)
-- 
1.7.7.6
