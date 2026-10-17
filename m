Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8FF22A4F1
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199052; cv=none; b=jEiy54yJYZkyMHuc7iEW7ipEpn7O+fvazqZDpSdsVZcMsnGxkRsxe8rdvbI9KphoCrrstmOLf5oqBO6SP+Rpo22SgPh1oGVyiFjnTO1jzU6s/FcU2Z64GBpyTHGCBLqaK2OAqGu5nOyTRjYlg1wcyv9Tq3mecC5d9USnPvDa5eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199052; c=relaxed/simple;
	bh=kh8cSaixC2KwkSQL32wkjkMt9vOUaiX5bHyVL2Q7pso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oSypOXAe9jycR/JVCPUenHMAE6G1iL3h8OZxixFKOfxlD6eoafZ7X2Lip21xZIuw5hbxPFFIopZopZy4zy6r6oG4jTeUxnto7idmIATfLmQiVXDo14kvkcua16Is4vIwSgODOEnWga+IfMX4DMEIL6RwZ+MGxCVA3acGjt9uC4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tm2NlZJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tm2NlZJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC811F000C5;
	Sat, 17 Oct 2026 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199050;
	bh=wLjuAqkLxRCAAlPAHbFeT+f1imT0okS4dtXgJ6sxC9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tm2NlZJjUICjFzleTH/OfGxmFKJzl8BzWLIb2bZPuCMMkucz7pRnW5WYMTlBchQfd
	 NmumeqJEjRYqClMAeNbmiVEFMi2DTgVB9IjBmbd/85frbgv/bvnN2uCDlKJrBoBrrn
	 AFTH/SIh5cVyYPfN1Uz5CQwzd1Lf/Mq7zqt+PaKf82C8fQrwb6TGZly6XFyR2u1tVv
	 eZXA70T5caNkdtNKrRwZfjXD0UCoGj8JJE6b9V/SEHjWTFTKn3cbMy9+MJmTM4vp+f
	 B+8xKsj/t6THqgUZ8fvR4gjxnAjWNgNz2+d6DY52xqD5uBIHGrqPaxZ6hSN5Ldi/Bt
	 QJqE00rjyXkcA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 06/22] ksmbd: index byte-range locks independently of their connection
Date: Sat, 17 Oct 2026 10:03:28 +0900
Message-Id: <20261017010344.11478-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB locks belong to an open, but the lock conflict and UNLOCK scan only
visits connections in conn_list. When a channel is removed, its locks
remain attached to live opens and become invisible to another channel.
An exact UNLOCK returns STATUS_RANGE_NOT_LOCKED, and zero-byte lock
conflicts are no longer detected. A request finishing on the old channel
after it is removed can publish another invisible lock.

Index granted SMB locks by VFS inode, with the open's lock_list retaining
ownership. Protect lookup, publication and removal with one spinlock.
Use the inode rather than the dentry-based ksmbd_inode so hard-link opens
still participate in the same conflict checks.

Keep these entries through durable detach and reconnect. Publish a batch
only after the existing LOCK handler commits it, and remove every entry
before final close drops the file reference. Drop the per-lock connection
references and connection-local lists; channel changes no longer require
moving lock entries or waiting for unrelated requests to finish.

Prefer an exclusive lock when several locks on an open match an UNLOCK.
This preserves stacked zero-byte lock behavior despite the inode hash
inserting newer locks before older entries.

Fixes: d63528eb0d43 ("ksmbd: free ksmbd_lock when file is closed")
Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c |   2 -
 fs/smb/server/connection.h |   2 -
 fs/smb/server/smb2pdu.c    | 104 ++-----------------------
 fs/smb/server/vfs_cache.c  | 150 ++++++++++++++++++++++++++-----------
 fs/smb/server/vfs_cache.h  |   7 +-
 5 files changed, 120 insertions(+), 145 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 19d32681bb92..0a4be9e423a3 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -327,8 +327,6 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	ida_init(&conn->async_ida);
 	xa_init(&conn->sessions);
 
-	spin_lock_init(&conn->llist_lock);
-	INIT_LIST_HEAD(&conn->lock_list);
 
 	init_rwsem(&conn->session_lock);
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 85e2d2073cd2..53eb91f618b4 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -112,8 +112,6 @@ struct ksmbd_conn {
 	char				ClientGUID[SMB2_CLIENT_GUID_SIZE];
 	struct ntlmssp_auth		ntlmssp;
 
-	spinlock_t			llist_lock;
-	struct list_head		lock_list;
 
 	struct preauth_integrity_info	*preauth_info;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b45453a29fbb..853a892e2ad5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10271,7 +10271,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->end = flock->fl_end;
 	lock->flags = flags;
 	lock->zero_len = zero_len;
-	INIT_LIST_HEAD(&lock->clist);
+	INIT_HLIST_NODE(&lock->hlist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
 	list_add_tail(&lock->llist, lock_list);
@@ -10300,12 +10300,6 @@ static void smb2_free_blocked_lock(struct file_lock *flock)
 	locks_free_lock(flock);
 }
 
-static inline bool lock_defer_pending(struct file_lock *fl)
-{
-	/* check pending lock waiters */
-	return waitqueue_active(&fl->c.flc_wait);
-}
-
 /**
  * smb2_lock() - handler for smb2 file lock command
  * @work:	smb work containing lock command buffer
@@ -10325,12 +10319,10 @@ int smb2_lock(struct ksmbd_work *work)
 	int cmd = 0;
 	int err = -EIO, i, rc = 0;
 	u64 lock_start, lock_length;
-	struct ksmbd_lock *smb_lock = NULL, *cmp_lock, *tmp, *tmp2;
-	struct ksmbd_conn *conn;
-	int nolock = 0;
+	struct ksmbd_lock *smb_lock = NULL, *cmp_lock, *tmp;
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
-	int prior_lock = 0, bkt;
+	int prior_lock = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	bool lock_replayed;
 
@@ -10463,79 +10455,10 @@ int smb2_lock(struct ksmbd_work *work)
 		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY))
 			goto no_check_cl;
 
-		nolock = 1;
-		/* check locks in connection list */
-		down_read(&conn_list_lock);
-		hash_for_each(conn_list, bkt, conn, hlist) {
-			spin_lock(&conn->llist_lock);
-			list_for_each_entry_safe(cmp_lock, tmp2, &conn->lock_list, clist) {
-				if (file_inode(cmp_lock->fl->c.flc_file) !=
-				    file_inode(smb_lock->fl->c.flc_file))
-					continue;
-
-				if (lock_is_unlock(smb_lock->fl)) {
-					if (cmp_lock->fl->c.flc_file == smb_lock->fl->c.flc_file &&
-					    cmp_lock->start == smb_lock->start &&
-					    cmp_lock->end == smb_lock->end &&
-					    !lock_defer_pending(cmp_lock->fl)) {
-						nolock = 0;
-						list_del_init(&cmp_lock->flist);
-						list_del_init(&cmp_lock->clist);
-						cmp_lock->conn = NULL;
-						spin_unlock(&conn->llist_lock);
-						up_read(&conn_list_lock);
-
-						ksmbd_conn_put(conn);
-						smb2_free_lock(cmp_lock->fl);
-						kfree(cmp_lock);
-						goto out_check_cl;
-					}
-					continue;
-				}
-
-				if (cmp_lock->fl->c.flc_file == smb_lock->fl->c.flc_file) {
-					if (smb_lock->flags & SMB2_LOCKFLAG_SHARED)
-						continue;
-				} else {
-					if (cmp_lock->flags & SMB2_LOCKFLAG_SHARED)
-						continue;
-				}
-
-				/* check zero byte lock range */
-				if (cmp_lock->zero_len && !smb_lock->zero_len &&
-				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start <= smb_lock->end) {
-					spin_unlock(&conn->llist_lock);
-					up_read(&conn_list_lock);
-					pr_err("previous lock conflict with zero byte lock range\n");
-					goto out;
-				}
-
-				if (smb_lock->zero_len && !cmp_lock->zero_len &&
-				    smb_lock->start > cmp_lock->start &&
-				    smb_lock->start <= cmp_lock->end) {
-					spin_unlock(&conn->llist_lock);
-					up_read(&conn_list_lock);
-					pr_err("current lock conflict with zero byte lock range\n");
-					goto out;
-				}
-
-				if (cmp_lock->start <= smb_lock->end &&
-				    smb_lock->start <= cmp_lock->end &&
-				    !cmp_lock->zero_len && !smb_lock->zero_len) {
-					spin_unlock(&conn->llist_lock);
-					up_read(&conn_list_lock);
-					pr_err("Not allow lock operation on exclusive lock range\n");
-					goto out;
-				}
-			}
-			spin_unlock(&conn->llist_lock);
-		}
-		up_read(&conn_list_lock);
-out_check_cl:
-		if (lock_is_unlock(smb_lock->fl) && nolock) {
-			pr_err("Try to unlock nolocked range\n");
-			rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
+		err = ksmbd_file_lock_check(smb_lock);
+		if (err) {
+			if (err == -ENOENT)
+				rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
 			goto out;
 		}
 
@@ -10649,18 +10572,7 @@ int smb2_lock(struct ksmbd_work *work)
 		goto out;
 
 	/* publish only once the whole batch has committed */
-	if (!list_empty(&rollback_list)) {
-		spin_lock(&work->conn->llist_lock);
-		list_for_each_entry_safe(smb_lock, tmp, &rollback_list, llist) {
-			list_del_init(&smb_lock->llist);
-			smb_lock->conn = ksmbd_conn_get(work->conn);
-			list_add_tail(&smb_lock->clist,
-				      &work->conn->lock_list);
-			list_add_tail(&smb_lock->flist,
-				      &fp->lock_list);
-		}
-		spin_unlock(&work->conn->llist_lock);
-	}
+	ksmbd_file_lock_add(fp, &rollback_list);
 
 	if (!lock_replayed)
 		smb2_update_lock_sequence(work, fp, req);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 11c123673f9a..459783910c04 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/dcache.h>
+#include <linux/hashtable.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -38,6 +39,10 @@ static struct ksmbd_file_table global_ft;
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
 
+/* Both the inode hash and each open's lock_list use this lock. */
+static DEFINE_SPINLOCK(file_locks_lock);
+static DEFINE_HASHTABLE(file_locks, 8);
+
 static int ksmbd_mark_fp_closed(struct ksmbd_file *fp);
 
 #define OPLOCK_NONE      0
@@ -613,10 +618,109 @@ static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp
 	write_unlock(&ft->lock);
 }
 
+/**
+ * ksmbd_file_lock_check() - check conflicts or remove an exact unlock match
+ * @lock: unregistered lock from the current request
+ *
+ * Return: 0 on success, -ENOENT for an unmatched unlock, or -EAGAIN on conflict.
+ */
+int ksmbd_file_lock_check(struct ksmbd_lock *lock)
+{
+	struct inode *inode = file_inode(lock->fl->c.flc_file);
+	struct ksmbd_lock *cmp, *lock_to_remove = NULL;
+	int ret = lock_is_unlock(lock->fl) ? -ENOENT : 0;
+
+	spin_lock(&file_locks_lock);
+	hash_for_each_possible(file_locks, cmp, hlist, (unsigned long)inode) {
+		if (file_inode(cmp->fl->c.flc_file) != inode)
+			continue;
+
+		if (lock_is_unlock(lock->fl)) {
+			if (cmp->fl->c.flc_file != lock->fl->c.flc_file ||
+			    cmp->start != lock->start || cmp->end != lock->end)
+				continue;
+			if (waitqueue_active(&cmp->fl->c.flc_wait)) /* VFS waiters */
+				continue;
+
+			/* Prefer an exclusive lock over matching shared locks. */
+			lock_to_remove = cmp;
+			if (cmp->flags & SMB2_LOCKFLAG_EXCLUSIVE)
+				break;
+			continue;
+		}
+
+		if (cmp->fl->c.flc_file == lock->fl->c.flc_file) {
+			if (lock->flags & SMB2_LOCKFLAG_SHARED)
+				continue;
+		} else if (cmp->flags & SMB2_LOCKFLAG_SHARED) {
+			continue;
+		}
+
+		if ((cmp->zero_len && !lock->zero_len &&
+		     cmp->start > lock->start && cmp->start <= lock->end) ||
+		    (lock->zero_len && !cmp->zero_len &&
+		     lock->start > cmp->start && lock->start <= cmp->end) ||
+		    (!cmp->zero_len && !lock->zero_len &&
+		     cmp->start <= lock->end && lock->start <= cmp->end)) {
+			ret = -EAGAIN;
+			break;
+		}
+	}
+	if (lock_to_remove) {
+		hash_del(&lock_to_remove->hlist);
+		list_del_init(&lock_to_remove->flist);
+		ret = 0;
+	}
+	spin_unlock(&file_locks_lock);
+	if (lock_to_remove) {
+		ksmbd_vfs_posix_lock_unblock(lock_to_remove->fl);
+		locks_free_lock(lock_to_remove->fl);
+		kfree(lock_to_remove);
+	}
+	return ret;
+}
+
+/**
+ * ksmbd_file_lock_add() - publish a committed batch independently of its channel
+ * @fp: open holding the locks
+ * @locks: granted locks awaiting publication
+ */
+void ksmbd_file_lock_add(struct ksmbd_file *fp, struct list_head *locks)
+{
+	struct ksmbd_lock *lock, *tmp;
+
+	spin_lock(&file_locks_lock);
+	list_for_each_entry_safe(lock, tmp, locks, llist) {
+		list_del_init(&lock->llist);
+		hash_add(file_locks, &lock->hlist,
+			 (unsigned long)file_inode(fp->filp));
+		list_add_tail(&lock->flist, &fp->lock_list);
+	}
+	spin_unlock(&file_locks_lock);
+}
+
+static void ksmbd_file_lock_clear(struct ksmbd_file *fp)
+{
+	struct ksmbd_lock *lock, *tmp;
+	LIST_HEAD(dispose);
+
+	spin_lock(&file_locks_lock);
+	list_for_each_entry(lock, &fp->lock_list, flist)
+		hash_del(&lock->hlist);
+	list_splice_init(&fp->lock_list, &dispose);
+	spin_unlock(&file_locks_lock);
+
+	list_for_each_entry_safe(lock, tmp, &dispose, flist) {
+		list_del_init(&lock->flist);
+		ksmbd_vfs_posix_lock_unblock(lock->fl);
+		locks_free_lock(lock->fl);
+		kfree(lock);
+	}
+}
+
 static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
-	struct ksmbd_lock *smb_lock, *tmp_lock;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -626,31 +730,12 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	close_id_del_oplock(fp);
 	filp = fp->filp;
 
+	/* Remove lookup entries before dropping the file's inode reference. */
+	ksmbd_file_lock_clear(fp);
 	__ksmbd_inode_close(fp);
 	if (!IS_ERR_OR_NULL(filp))
 		fput(filp);
 
-	/*
-	 * The zero fp reference count serializes access to fp->lock_list, but
-	 * the VFS may still have blocked requests chained below these locks.
-	 */
-	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		struct ksmbd_conn *conn = smb_lock->conn;
-
-		if (conn) {
-			spin_lock(&conn->llist_lock);
-			list_del_init(&smb_lock->clist);
-			smb_lock->conn = NULL;
-			spin_unlock(&conn->llist_lock);
-			ksmbd_conn_put(conn);
-		}
-
-		list_del_init(&smb_lock->flist);
-		ksmbd_vfs_posix_lock_unblock(smb_lock->fl);
-		locks_free_lock(smb_lock->fl);
-		kfree(smb_lock);
-	}
-
 	/*
 	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
 	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
@@ -1738,7 +1823,6 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
 	struct ksmbd_conn *conn;
-	struct ksmbd_lock *smb_lock, *tmp_lock;
 
 	if (!is_reconnectable(fp))
 		return false;
@@ -1771,18 +1855,6 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	}
 	up_write(&ci->m_lock);
 
-	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		struct ksmbd_conn *lock_conn = smb_lock->conn;
-
-		if (!lock_conn)
-			continue;
-		spin_lock(&lock_conn->llist_lock);
-		list_del_init(&smb_lock->clist);
-		smb_lock->conn = NULL;
-		spin_unlock(&lock_conn->llist_lock);
-		ksmbd_conn_put(lock_conn);
-	}
-
 	spin_lock(&fp->f_lock);
 	fp->conn = NULL;
 	fp->tcon = NULL;
@@ -1889,7 +1961,6 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	struct oplock_info *op;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *old_share;
-	struct ksmbd_lock *smb_lock;
 	unsigned int old_f_state;
 
 	write_lock(&global_ft.lock);
@@ -1939,13 +2010,6 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		return -EBADF;
 	}
 
-	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
-		smb_lock->conn = ksmbd_conn_get(conn);
-		spin_lock(&conn->llist_lock);
-		list_add_tail(&smb_lock->clist, &conn->lock_list);
-		spin_unlock(&conn->llist_lock);
-	}
-
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 706633bb0419..6df48ae04548 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -34,11 +34,11 @@
 
 struct ksmbd_conn;
 struct ksmbd_session;
+struct ksmbd_file;
 
 struct ksmbd_lock {
 	struct file_lock *fl;
-	struct ksmbd_conn *conn;
-	struct list_head clist;
+	struct hlist_node hlist;
 	struct list_head flist;
 	struct list_head llist;
 	unsigned int flags;
@@ -48,6 +48,9 @@ struct ksmbd_lock {
 	unsigned long long end;
 };
 
+int ksmbd_file_lock_check(struct ksmbd_lock *lock);
+void ksmbd_file_lock_add(struct ksmbd_file *fp, struct list_head *locks);
+
 struct stream {
 	char *name;
 	ssize_t size;
-- 
2.25.1

