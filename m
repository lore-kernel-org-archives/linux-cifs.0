From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/16] cifs: move cifsFileInfo_put to file.c
Date: Mon, 11 Oct 2010 15:07:29 -0400
Message-ID: <1286824053-12084-13-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
index c29ef5f..01e2f56 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -406,15 +406,7 @@ static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
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
index cae80da..558cdbd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -262,6 +262,16 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
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
