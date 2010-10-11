From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/16] cifs: convert cifsFileInfo->count to non-atomic counter
Date: Mon, 11 Oct 2010 15:07:31 -0400
Message-ID: <1286824053-12084-15-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The count for cifsFileInfo is currently an atomic, but that just adds
complexity for little value. We generally need to hold cifs_file_list_lock
to traverse the lists anyway so we might as well make this counter
non-atomic and simply use the cifs_file_list_lock to protect it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsglob.h |    9 ++++++---
 fs/cifs/file.c     |    8 +++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c928e39..2327dcb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -393,16 +393,19 @@ struct cifsFileInfo {
 	struct list_head llist; /* list of byte range locks we have. */
 	bool invalidHandle:1;	/* file closed via session abend */
 	bool oplock_break_cancelled:1;
-	atomic_t count;		/* reference count */
+	int count;		/* refcount -- protected by cifs_file_list_lock */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 };
 
-/* Take a reference on the file private data */
+/*
+ * Take a reference on the file private data. Must be called with
+ * cifs_file_list_lock held.
+ */
 static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 {
-	atomic_inc(&cifs_file->count);
+	++cifs_file->count;
 }
 
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cca560c..f286cb9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -232,6 +232,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	if (pCifsFile == NULL)
 		return pCifsFile;
 
+	pCifsFile->count = 1;
 	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
 	pCifsFile->uid = current_fsuid();
@@ -242,7 +243,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
-	atomic_set(&pCifsFile->count, 1);
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	spin_lock(&cifs_file_list_lock);
@@ -263,7 +263,8 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 
 /*
  * Release a reference on the file private data. This may involve closing
- * the filehandle out on the server.
+ * the filehandle out on the server. Must be called without holding
+ * cifs_file_list_lock.
  */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
@@ -272,7 +273,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct cifsLockInfo *li, *tmp;
 
 	spin_lock(&cifs_file_list_lock);
-	if (!atomic_dec_and_test(&cifs_file->count)) {
+	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file_list_lock);
 		return;
 	}
@@ -2317,6 +2318,7 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_oplock_break_put(cfile);
 }
 
+/* must be called while holding cifs_file_list_lock */
 void cifs_oplock_break_get(struct cifsFileInfo *cfile)
 {
 	cifs_sb_active(cfile->dentry->d_sb);
-- 
1.7.2.3
