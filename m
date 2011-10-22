From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 PATCH 3/4] CIFS: Send as many mandatory unlock ranges at once as possible
Date: Sat, 22 Oct 2011 15:33:31 +0400
Message-ID: <1319283212-19024-4-git-send-email-piastry@etersoft.ru>
References: <1319283212-19024-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319283212-19024-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that reduces a traffic and increases a performance.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 +
 fs/cifs/cifssmb.c   |   40 +++++++++++++
 fs/cifs/file.c      |  160 +++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 167 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 67c26cf..ef4f631 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -368,6 +368,9 @@ extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *tcon,
 			const struct nls_table *nls_codepage,
 			int remap_special_chars);
 
+extern int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
+		      const __u8 lock_type, const __u32 num_unlock,
+		      const __u32 num_lock, LOCKING_ANDX_RANGE *buf);
 extern int CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 			const __u16 netfid, const __u32 netpid, const __u64 len,
 			const __u64 offset, const __u32 numUnlock,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6a45a17..6600aa2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2320,6 +2320,46 @@ CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
 	return rc;
 }
 
+int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
+	       const __u8 lock_type, const __u32 num_unlock,
+	       const __u32 num_lock, LOCKING_ANDX_RANGE *buf)
+{
+	int rc = 0;
+	LOCK_REQ *pSMB = NULL;
+	struct kvec iov[2];
+	int resp_buf_type;
+	__u16 count;
+
+	cFYI(1, "cifs_lockv num lock %d num unlock %d", num_lock, num_unlock);
+
+	rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
+	if (rc)
+		return rc;
+
+	pSMB->Timeout = 0;
+	pSMB->NumberOfLocks = cpu_to_le16(num_lock);
+	pSMB->NumberOfUnlocks = cpu_to_le16(num_unlock);
+	pSMB->LockType = lock_type;
+	pSMB->AndXCommand = 0xFF; /* none */
+	pSMB->Fid = netfid; /* netfid stays le */
+
+	count = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
+	inc_rfc1001_len(pSMB, count);
+	pSMB->ByteCount = cpu_to_le16(count);
+
+	iov[0].iov_base = (char *)pSMB;
+	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4 -
+			 (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
+	iov[1].iov_base = (char *)buf;
+	iov[1].iov_len = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
+
+	cifs_stats_inc(&tcon->num_locks);
+	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
+	if (rc)
+		cFYI(1, "Send error in cifs_lockv = %d", rc);
+
+	return rc;
+}
 
 int
 CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 805e2bd..569184e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1057,6 +1057,128 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u8 type,
 	return rc;
 }
 
+static void
+cifs_move_llist(struct list_head *source, struct list_head *dest)
+{
+	struct list_head *li, *tmp;
+	list_for_each_safe(li, tmp, source)
+		list_move(li, dest);
+}
+
+static void
+cifs_free_llist(struct list_head *llist)
+{
+	struct cifsLockInfo *li, *tmp;
+	list_for_each_entry_safe(li, tmp, llist, llist) {
+		cifs_del_lock_waiters(li);
+		list_del(&li->llist);
+		kfree(li);
+	}
+}
+
+static int
+cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock, int xid)
+{
+	int rc = 0, stored_rc;
+	int types[] = {LOCKING_ANDX_LARGE_FILES,
+		       LOCKING_ANDX_SHARED_LOCK | LOCKING_ANDX_LARGE_FILES};
+	unsigned int i;
+	unsigned int max_num, num;
+	LOCKING_ANDX_RANGE *buf, *cur;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifsLockInfo *li, *tmp;
+	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	struct list_head tmp_llist;
+
+	INIT_LIST_HEAD(&tmp_llist);
+
+	max_num = (tcon->ses->server->maxBuf - sizeof(struct smb_hdr)) /
+		  sizeof(LOCKING_ANDX_RANGE);
+	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&cinode->lock_mutex);
+	for (i = 0; i < 2; i++) {
+		cur = buf;
+		num = 0;
+		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
+			if (flock->fl_start > li->offset ||
+			    (flock->fl_start + length) <
+			    (li->offset + li->length))
+				continue;
+			if (current->tgid != li->pid)
+				continue;
+			if (cfile->netfid != li->netfid)
+				continue;
+			if (types[i] != li->type)
+				continue;
+			if (!cinode->can_cache_brlcks) {
+				cur->Pid = cpu_to_le16(li->pid);
+				cur->LengthLow = cpu_to_le32((u32)li->length);
+				cur->LengthHigh =
+					cpu_to_le32((u32)(li->length>>32));
+				cur->OffsetLow = cpu_to_le32((u32)li->offset);
+				cur->OffsetHigh =
+					cpu_to_le32((u32)(li->offset>>32));
+				/*
+				 * We need to save a lock here to let us add
+				 * it again to the inode list if the unlock
+				 * range request fails on the server.
+				 */
+				list_move(&li->llist, &tmp_llist);
+				if (++num == max_num) {
+					stored_rc = cifs_lockv(xid, tcon,
+							       cfile->netfid,
+							       li->type, num,
+							       0, buf);
+					if (stored_rc) {
+						/*
+						 * We failed on the unlock range
+						 * request - add all locks from
+						 * the tmp list to the head of
+						 * the inode list.
+						 */
+						cifs_move_llist(&tmp_llist,
+								&cinode->llist);
+						rc = stored_rc;
+					} else
+						/*
+						 * The unlock range request
+						 * succeed - free the tmp list.
+						 */
+						cifs_free_llist(&tmp_llist);
+					cur = buf;
+					num = 0;
+				} else
+					cur++;
+			} else {
+				/*
+				 * We can cache brlock requests - simply remove
+				 * a lock from the inode list.
+				 */
+				list_del(&li->llist);
+				cifs_del_lock_waiters(li);
+				kfree(li);
+			}
+		}
+		if (num) {
+			stored_rc = cifs_lockv(xid, tcon, cfile->netfid,
+					       types[i], num, 0, buf);
+			if (stored_rc) {
+				cifs_move_llist(&tmp_llist, &cinode->llist);
+				rc = stored_rc;
+			} else
+				cifs_free_llist(&tmp_llist);
+		}
+	}
+
+	mutex_unlock(&cinode->lock_mutex);
+	kfree(buf);
+	return rc;
+}
+
 static int
 cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 	   bool wait_flag, bool posix_lck, int lock, int unlock, int xid)
@@ -1104,43 +1226,9 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u8 type,
 			rc = cifs_lock_add(cinode, length, flock->fl_start,
 					   type, netfid);
 		}
-	} else if (unlock) {
-		/*
-		 * For each stored lock that this unlock overlaps completely,
-		 * unlock it.
-		 */
-		int stored_rc = 0;
-		struct cifsLockInfo *li, *tmp;
-
-		mutex_lock(&cinode->lock_mutex);
-		list_for_each_entry_safe(li, tmp, &cinode->llist, llist) {
-			if (flock->fl_start > li->offset ||
-			    (flock->fl_start + length) <
-			    (li->offset + li->length))
-				continue;
-			if (current->tgid != li->pid)
-				continue;
-			if (cfile->netfid != li->netfid)
-				continue;
-
-			if (!cinode->can_cache_brlcks)
-				stored_rc = CIFSSMBLock(xid, tcon, netfid,
-							current->tgid,
-							li->length, li->offset,
-							1, 0, li->type, 0, 0);
-			else
-				stored_rc = 0;
+	} else if (unlock)
+		rc = cifs_unlock_range(cfile, flock, xid);
 
-			if (stored_rc)
-				rc = stored_rc;
-			else {
-				list_del(&li->llist);
-				cifs_del_lock_waiters(li);
-				kfree(li);
-			}
-		}
-		mutex_unlock(&cinode->lock_mutex);
-	}
 out:
 	if (flock->fl_flags & FL_POSIX)
 		posix_lock_file_wait(file, flock);
-- 
1.7.1
