From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: consolidate error handling in several functions
Date: Thu,  5 Aug 2010 10:18:35 -0400
Message-ID: <1281017916-31380-3-git-send-email-jlayton@redhat.com>
References: <1281017916-31380-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281017916-31380-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs has a lot of complicated functions that have to clean up things on
error, but some of them don't have all of the cleanup code
well-consolidated. Clean up and consolidate error handling in several
functions.

This is in preparation of later patches that will need to put references
to the tcon link container.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c  |   14 +++++++-------
 fs/cifs/file.c |    3 +--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f8d02f0..90d1f53 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -197,8 +197,10 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	cFYI(1, "posix open %s", full_path);
 
 	presp_data = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
-	if (presp_data == NULL)
-		return -ENOMEM;
+	if (presp_data == NULL) {
+		rc = -ENOMEM;
+		goto posix_open_ret;
+	}
 
 /* So far cifs posix extensions can only map the following flags.
    There are other valid fmode oflags such as FMODE_LSEEK, FMODE_PREAD, but
@@ -305,8 +307,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	full_path = build_path_from_dentry(direntry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto cifs_create_out;
 	}
 
 	if (oplockEnabled)
@@ -365,9 +366,8 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (buf == NULL) {
-		kfree(full_path);
-		FreeXid(xid);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto cifs_create_out;
 	}
 
 	/*
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa04a00d..55ced02 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -242,8 +242,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	full_path = build_path_from_dentry(file->f_path.dentry);
 	if (full_path == NULL) {
 		rc = -ENOMEM;
-		FreeXid(xid);
-		return rc;
+		goto out;
 	}
 
 	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
-- 
1.7.2
