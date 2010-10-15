From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/13] cifs: move cifsFileInfo_put to file.c
Date: Fri, 15 Oct 2010 15:34:04 -0400
Message-ID: <1287171248-464-10-git-send-email-jlayton@redhat.com>
References: <1287171248-464-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287171248-464-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and make it non-inlined in preparation for the move of most of
cifs_close to it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsglob.h |   10 +---------
 fs/cifs/file.c     |   10 ++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 087bc4b..d5beb42 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -408,15 +408,7 @@ static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 	atomic_inc(&cifs_file->count);
 }
 
-/* Release a reference on the file private data */
-static inline void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
-{
-	if (atomic_dec_and_test(&cifs_file->count)) {
-		cifs_put_tlink(cifs_file->tlink);
-		dput(cifs_file->dentry);
-		kfree(cifs_file);
-	}
-}
+void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 /*
  * One of these for each file inode
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 26048dc..a3634e4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -266,6 +266,16 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	return pCifsFile;
 }
 
+/* Release a reference on the file private data */
+void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
+{
+	if (atomic_dec_and_test(&cifs_file->count)) {
+		cifs_put_tlink(cifs_file->tlink);
+		dput(cifs_file->dentry);
+		kfree(cifs_file);
+	}
+}
+
 int cifs_open(struct inode *inode, struct file *file)
 {
 	int rc = -EACCES;
-- 
1.7.2.3
