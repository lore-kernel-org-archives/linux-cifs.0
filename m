From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: remove an potentially confusing, obsolete comment
Date: Tue,  6 Jul 2010 18:03:36 +0530
Message-ID: <1278419616-8368-1-git-send-email-sjayaraman@suse.de>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The recent commit 6ca9f3bae8b1854794dfa63cdd3b88b7dfe24c13 modified the code so
that filp is full instantiated whenever the file is created and passed back.
The below comment is no longer true, remove it.

Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/dir.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e7ae78b..a7de5e9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -130,12 +130,6 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
-/*
- * When called with struct file pointer set to NULL, there is no way we could
- * update file->private_data, but getting it stuck on openFileList provides a
- * way to access it from cifs_fill_filedata and thereby set file->private_data
- * from cifs_open.
- */
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 		  struct file *file, struct vfsmount *mnt, unsigned int oflags)
