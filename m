From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix offset handling in cifs_iovec_write
Date: Fri, 13 Apr 2012 17:16:59 -0400
Message-ID: <1334351819-29402-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the recent update of the cifs_iovec_write code to use async writes,
the handling of the file position was broken. That patch added a local
"offset" variable to handle the offset, and then only updated the
original "*poffset" before exiting.

Unfortunately, it copied off the original offset from the beginning,
instead of doing so after generic_write_checks had been called. Fix
this by moving the initialization of "offset" after that in the
function.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fae765d..81725e9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2178,7 +2178,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	unsigned long nr_pages, i;
 	size_t copied, len, cur_len;
 	ssize_t total_written = 0;
-	loff_t offset = *poffset;
+	loff_t offset;
 	struct iov_iter it;
 	struct cifsFileInfo *open_file;
 	struct cifs_tcon *tcon;
@@ -2200,6 +2200,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	open_file = file->private_data;
 	tcon = tlink_tcon(open_file->tlink);
+	offset = *poffset;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
-- 
1.7.7.6
