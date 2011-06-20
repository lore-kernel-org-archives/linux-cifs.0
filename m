From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: simplify refcounting for oplock breaks
Date: Mon, 20 Jun 2011 14:31:06 -0400
Message-ID: <1308594666-28900-1-git-send-email-jlayton@redhat.com>
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we take a sb->s_active reference and a cifsFileInfo reference
when an oplock break workqueue job is queued. This is unnecessary and
more complicated than it needs to be. Also as Al points out,
deactivate_super has non-trivial locking implications so it's best to
avoid that if we can.

Instead, just cancel any pending oplock breaks for this filehandle
synchronously in cifsFileInfo_put after taking it off the lists.
That should ensure that this job doesn't outlive the structures it
depends on.

Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |   18 ------------------
 fs/cifs/cifsfs.h   |    4 ----
 fs/cifs/cifsglob.h |    2 --
 fs/cifs/file.c     |   27 ++-------------------------
 fs/cifs/misc.c     |   11 ++---------
 5 files changed, 4 insertions(+), 58 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 097ad49..2110eeb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -85,24 +85,6 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
-void
-cifs_sb_active(struct super_block *sb)
-{
-	struct cifs_sb_info *server = CIFS_SB(sb);
-
-	if (atomic_inc_return(&server->active) == 1)
-		atomic_inc(&sb->s_active);
-}
-
-void
-cifs_sb_deactive(struct super_block *sb)
-{
-	struct cifs_sb_info *server = CIFS_SB(sb);
-
-	if (atomic_dec_and_test(&server->active))
-		deactivate_super(sb);
-}
-
 static int
 cifs_read_super(struct super_block *sb)
 {
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 0900e16..19b0792 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -41,10 +41,6 @@ extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
-/* Functions related to super block operations */
-extern void cifs_sb_active(struct super_block *sb);
-extern void cifs_sb_deactive(struct super_block *sb);
-
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6255fa8..75740e6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -942,8 +942,6 @@ GLOBAL_EXTERN spinlock_t siduidlock;
 GLOBAL_EXTERN spinlock_t sidgidlock;
 
 void cifs_oplock_break(struct work_struct *work);
-void cifs_oplock_break_get(struct cifsFileInfo *cfile);
-void cifs_oplock_break_put(struct cifsFileInfo *cfile);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bb71471..2e8eede 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -314,6 +314,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	}
 	spin_unlock(&cifs_file_list_lock);
 
+	cancel_work_sync(&cifs_file->oplock_break);
+
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		int xid, rc;
 
@@ -2404,31 +2406,6 @@ void cifs_oplock_break(struct work_struct *work)
 				 cinode->clientCanCacheRead ? 1 : 0);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
-
-	/*
-	 * We might have kicked in before is_valid_oplock_break()
-	 * finished grabbing reference for us.  Make sure it's done by
-	 * waiting for cifs_file_list_lock.
-	 */
-	spin_lock(&cifs_file_list_lock);
-	spin_unlock(&cifs_file_list_lock);
-
-	cifs_oplock_break_put(cfile);
-}
-
-/* must be called while holding cifs_file_list_lock */
-void cifs_oplock_break_get(struct cifsFileInfo *cfile)
-{
-	cifs_sb_active(cfile->dentry->d_sb);
-	cifsFileInfo_get(cfile);
-}
-
-void cifs_oplock_break_put(struct cifsFileInfo *cfile)
-{
-	struct super_block *sb = cfile->dentry->d_sb;
-
-	cifsFileInfo_put(cfile);
-	cifs_sb_deactive(sb);
 }
 
 const struct address_space_operations cifs_addr_ops = {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 03a1f49..7c16933 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -585,15 +585,8 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 
 				cifs_set_oplock_level(pCifsInode,
 					pSMB->OplockLevel ? OPLOCK_READ : 0);
-				/*
-				 * cifs_oplock_break_put() can't be called
-				 * from here.  Get reference after queueing
-				 * succeeded.  cifs_oplock_break() will
-				 * synchronize using cifs_file_list_lock.
-				 */
-				if (queue_work(system_nrt_wq,
-					       &netfile->oplock_break))
-					cifs_oplock_break_get(netfile);
+				queue_work(system_nrt_wq,
+					   &netfile->oplock_break);
 				netfile->oplock_break_cancelled = false;
 
 				spin_unlock(&cifs_file_list_lock);
-- 
1.7.5.4
