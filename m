From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 5/6] CIFS: Do not permit write to a range mandatory locked with a read lock
Date: Wed, 28 Nov 2012 18:23:44 +0400
Message-ID: <1354112625-30315-6-git-send-email-piastry@etersoft.ru>
References: <1354112625-30315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354112625-30315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We don't need to permit a write to the area locked with a read lock
by any process including the process that issues the write.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/file.c      |   27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7e1562d..4883f95 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -187,7 +187,7 @@ extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
 extern bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 				    __u64 length, __u8 type,
 				    struct cifsLockInfo **conf_lock,
-				    bool rw_check);
+				    int rw_check);
 extern void cifs_add_pending_open(struct cifs_fid *fid,
 				  struct tcon_link *tlink,
 				  struct cifs_pending_open *open);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f8fe1bd..e7fc39c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -765,10 +765,15 @@ cifs_del_lock_waiters(struct cifsLockInfo *lock)
 	}
 }
 
+#define CIFS_LOCK_OP	0
+#define CIFS_READ_OP	1
+#define CIFS_WRITE_OP	2
+
+/* @rw_check : 0 - no op, 1 - read, 2 - write */
 static bool
 cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 			    __u64 length, __u8 type, struct cifsFileInfo *cfile,
-			    struct cifsLockInfo **conf_lock, bool rw_check)
+			    struct cifsLockInfo **conf_lock, int rw_check)
 {
 	struct cifsLockInfo *li;
 	struct cifsFileInfo *cur_cfile = fdlocks->cfile;
@@ -778,9 +783,13 @@ cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
-		if (rw_check && server->ops->compare_fids(cfile, cur_cfile) &&
-		    current->tgid == li->pid)
-			continue;
+		if (rw_check != CIFS_LOCK_OP && current->tgid == li->pid &&
+		    server->ops->compare_fids(cfile, cur_cfile)) {
+			/* shared lock prevents write op through the same fid */
+			if (!(li->type & server->vals->shared_lock_type) ||
+			    rw_check != CIFS_WRITE_OP)
+				continue;
+		}
 		if ((type & server->vals->shared_lock_type) &&
 		    ((server->ops->compare_fids(cfile, cur_cfile) &&
 		     current->tgid == li->pid) || type == li->type))
@@ -795,7 +804,7 @@ cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 bool
 cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 			__u8 type, struct cifsLockInfo **conf_lock,
-			bool rw_check)
+			int rw_check)
 {
 	bool rc = false;
 	struct cifs_fid_locks *cur;
@@ -831,7 +840,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
 	down_read(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, offset, length, type,
-					&conf_lock, false);
+					&conf_lock, CIFS_LOCK_OP);
 	if (exist) {
 		flock->fl_start = conf_lock->offset;
 		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
@@ -878,7 +887,7 @@ try_again:
 	down_write(&cinode->lock_sem);
 
 	exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
-					lock->type, &conf_lock, false);
+					lock->type, &conf_lock, CIFS_LOCK_OP);
 	if (!exist && cinode->can_cache_brlcks) {
 		list_add_tail(&lock->llist, &cfile->llist->locks);
 		up_write(&cinode->lock_sem);
@@ -2472,7 +2481,7 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 	down_read(&cinode->lock_sem);
 	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
 				     server->vals->exclusive_lock_type, NULL,
-				     true)) {
+				     CIFS_WRITE_OP)) {
 		mutex_lock(&inode->i_mutex);
 		rc = __generic_file_aio_write(iocb, iov, nr_segs,
 					       &iocb->ki_pos);
@@ -2907,7 +2916,7 @@ cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 	down_read(&cinode->lock_sem);
 	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
 				     tcon->ses->server->vals->shared_lock_type,
-				     NULL, true))
+				     NULL, CIFS_READ_OP))
 		rc = generic_file_aio_read(iocb, iov, nr_segs, pos);
 	up_read(&cinode->lock_sem);
 	return rc;
-- 
1.7.10.4
