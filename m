Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65633E555
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199057; cv=none; b=VEjuRnrX3nVyXFwwRjBoJVK/u910uwfsKO1BTJ56MBn4dXvMPHIFZBKQWk81/hykWfb37viswtWTdUUkH1CpIyPGz8DuDQUJ1rI+ZnaFHk1hPJRv5rmRhH7bLZYHKq6eYYlqYAnJ5CS/7xteyjkgUK2Nw8lNLeJz15sHjfECQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199057; c=relaxed/simple;
	bh=je3uwXbm72D3A436AxGLIx/UL/M5hBgrXafIijC9NS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FbsW742zBNPmu/GHwEO28mdX7huqHt0Wba3HYUkrnM/3VXb/KYBWI/3tovHUU32/1Y0mnGecpN0YARjpGwFWEoosN63K3c0DUP3jIFgeGwjytsNM3G3D1+ZtYJ1qZxva4oaOPhe2hUcfVx0YMX3G73gTOue3uUGD7wjPfM2zZnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iryXRGOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iryXRGOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13BC1F000C5;
	Sat, 17 Oct 2026 01:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199056;
	bh=1ayaWsVO7AelIfDniSI5TR2lskawG1bbnNVCK+r40FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iryXRGOoK2M8t40o49KbY8JV1s6+mtRbrjS/qizvJZxyxvCEHGVq8VqTjrxUMl/Y3
	 L3vF+ZLPtKkYtmEiamCWpY8rmZLWDvULY9EpnRjMg+uSwd9XTZtWrz1vH0HAEHVXEK
	 +CmAez7BCOAIgHkC5cEIE3KNNw/O7DQZycwwhMMDWPYG7+AofO71/zw9PcRI7usdhp
	 IsHWwpB+EB+MU5OHa7lx+8csVtotBsIJkloC6/+h0k7kiOAgmO8LWZ3UEhVsKoSt9o
	 ExSx4LWZ4eC0JZw6fSM/BRn5V0ORbUYiqETc/X0gS6w6raidIPgE5dt+F8jHuZfo0A
	 BQNA3aa+aoY3A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/22] ksmbd: track SMB2 locks above OFFSET_MAX in server lock table
Date: Sat, 17 Oct 2026 10:03:30 +0900
Message-Id: <20261017010344.11478-8-linkinjeon@kernel.org>
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

SMB2 lock ranges use unsigned 64-bit offsets, but file_lock stores signed
loff_t values. Track valid ranges above OFFSET_MAX in ksmbd's inode-based
lock index and arbitrate conflicts there. Keep these offsets out of
file_lock, and handle blocking requests, unlocks, rollback, close cleanup
and cancellation in the SMB layer.

Reserve large ranges under the index spinlock until the full request
commits. Keep lookup and ownership independent of the connection so
channel removal and hard-link opens use the same conflict checks.

Finish large-range unlocks in the SMB layer after unlocking any VFS
portion. Wake large-range lock waiters when normal locks are removed
by unlock or close.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 235 +++++++++++++++++++++++++++++++-------
 fs/smb/server/vfs_cache.c | 119 ++++++++++++++++++-
 fs/smb/server/vfs_cache.h |   9 ++
 3 files changed, 321 insertions(+), 42 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d2f02a0957a7..cdc214363d19 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10226,8 +10226,10 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 	return cmd;
 }
 
+/* Track SMB locks that cannot be represented by a signed loff_t. */
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 					 unsigned int cmd, int flags, bool zero_len,
+					 u64 start, u64 end, bool virtual_lock,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -10238,10 +10240,11 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 
 	lock->cmd = cmd;
 	lock->fl = flock;
-	lock->start = flock->fl_start;
-	lock->end = flock->fl_end;
+	lock->start = start;
+	lock->end = end;
 	lock->flags = flags;
 	lock->zero_len = zero_len;
+	lock->virtual_lock = virtual_lock;
 	INIT_HLIST_NODE(&lock->hlist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -10250,18 +10253,112 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	return lock;
 }
 
-static void smb2_remove_blocked_lock(void **argv)
+static void smb2_virtual_lock_cancel(void **argv)
 {
-	struct file_lock *flock = (struct file_lock *)argv[0];
+	(void)argv;
+	wake_up_all(&ksmbd_lock_wait);
+}
 
-	ksmbd_vfs_posix_lock_unblock(flock);
-	locks_wake_up(flock);
+static int smb2_virtual_lock_wait(struct ksmbd_work *work,
+				  struct ksmbd_file *fp,
+				  struct ksmbd_lock *smb_lock,
+				  struct smb2_lock_rsp *rsp)
+{
+	void **argv = NULL;
+	bool async = false;
+	int ret;
+
+	for (;;) {
+		ret = ksmbd_file_lock_reserve(fp, smb_lock);
+		if (ret != -EAGAIN ||
+		    (smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY))
+			break;
+
+		if (!async) {
+			argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
+			if (!argv)
+				return -ENOMEM;
+			argv[0] = NULL;
+			ret = setup_async_work(work, smb2_virtual_lock_cancel, argv);
+			if (ret) {
+				kfree(argv);
+				return ret;
+			}
+			async = true;
+
+			read_lock(&work->sess->file_table.lock);
+			if (fp->f_state != FP_INITED) {
+				read_unlock(&work->sess->file_table.lock);
+				release_async_work(work);
+				return -ENOENT;
+			}
+			spin_lock(&fp->f_lock);
+			list_add(&work->fp_entry, &fp->blocked_works);
+			spin_unlock(&fp->f_lock);
+			read_unlock(&work->sess->file_table.lock);
+			smb2_send_interim_resp(work, STATUS_PENDING);
+		}
+
+		wait_event(ksmbd_lock_wait,
+			   READ_ONCE(work->state) != KSMBD_WORK_ACTIVE ||
+			   !ksmbd_file_lock_conflict(smb_lock));
+
+		if (READ_ONCE(work->state) != KSMBD_WORK_ACTIVE) {
+			spin_lock(&fp->f_lock);
+			list_del_init(&work->fp_entry);
+			spin_unlock(&fp->f_lock);
+			if (work->state == KSMBD_WORK_CANCELLED) {
+				rsp->hdr.Status = STATUS_CANCELLED;
+				smb2_send_interim_resp(work, STATUS_CANCELLED);
+				work->send_no_response = 1;
+				ret = -ECANCELED;
+			} else {
+				rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
+				ret = -EIO;
+			}
+			release_async_work(work);
+			return ret;
+		}
+	}
+
+	if (async) {
+		bool cancelled;
+
+		spin_lock(&fp->f_lock);
+		list_del_init(&work->fp_entry);
+		cancelled = READ_ONCE(work->state) != KSMBD_WORK_ACTIVE;
+		spin_unlock(&fp->f_lock);
+		release_async_work(work);
+		if (cancelled) {
+			ksmbd_file_lock_remove(smb_lock);
+			if (work->state == KSMBD_WORK_CANCELLED) {
+				rsp->hdr.Status = STATUS_CANCELLED;
+				smb2_send_interim_resp(work, STATUS_CANCELLED);
+				work->send_no_response = 1;
+				return -ECANCELED;
+			}
+			rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
+			return -EIO;
+		}
+	}
+
+	return ret;
+}
+
+static void smb2_free_ksmbd_lock(struct ksmbd_lock *smb_lock)
+{
+	if (smb_lock->vfs_locked)
+		ksmbd_vfs_posix_lock_unblock(smb_lock->fl);
+	locks_free_lock(smb_lock->fl);
+	kfree(smb_lock);
 }
 
-static void smb2_free_lock(struct file_lock *flock)
+static void smb2_remove_blocked_lock(void **argv)
 {
+	struct file_lock *flock = (struct file_lock *)argv[0];
+
 	ksmbd_vfs_posix_lock_unblock(flock);
-	locks_free_lock(flock);
+	locks_wake_up(flock);
 }
 
 static void smb2_free_blocked_lock(struct file_lock *flock)
@@ -10289,13 +10386,14 @@ int smb2_lock(struct ksmbd_work *work)
 	int flags = 0;
 	int cmd = 0;
 	int err = -EIO, i, rc = 0;
-	u64 lock_start, lock_length;
+	u64 lock_start, lock_length, lock_end;
 	struct ksmbd_lock *smb_lock = NULL, *cmp_lock, *tmp;
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
 	int prior_lock = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	bool lock_replayed;
+	bool virtual_lock;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -10358,23 +10456,29 @@ int smb2_lock(struct ksmbd_work *work)
 
 		lock_start = le64_to_cpu(lock_ele[i].Offset);
 		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_start > OFFSET_MAX ||
-		    (lock_length &&
-		     lock_length - 1 > OFFSET_MAX - lock_start)) {
+		if (lock_length && lock_length - 1 > U64_MAX - lock_start) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
 			locks_free_lock(flock);
 			goto out;
 		}
 
-		flock->fl_start = lock_start;
-		flock->fl_end = lock_length ?
-			flock->fl_start + lock_length - 1 : flock->fl_start;
+		lock_end = lock_length ? lock_start + lock_length - 1 : lock_start;
+		virtual_lock = lock_end > OFFSET_MAX;
+
+		/* Lock the representable portion in VFS as well. */
+		if (lock_start > OFFSET_MAX) {
+			flock->fl_start = 0;
+			flock->fl_end = 0;
+		} else {
+			flock->fl_start = lock_start;
+			flock->fl_end = min_t(u64, lock_end, OFFSET_MAX);
+		}
 
 		/* Check conflict locks in one request */
 		list_for_each_entry(cmp_lock, &lock_list, llist) {
-			if (cmp_lock->fl->fl_start <= flock->fl_start &&
-			    cmp_lock->fl->fl_end >= flock->fl_end) {
+			if (cmp_lock->start <= lock_start &&
+			    cmp_lock->end >= lock_end) {
 				if (cmp_lock->fl->c.flc_type != F_UNLCK &&
 				    flock->c.flc_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
@@ -10386,6 +10490,7 @@ int smb2_lock(struct ksmbd_work *work)
 		}
 
 		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   lock_start, lock_end, virtual_lock,
 					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
@@ -10422,6 +10527,22 @@ int smb2_lock(struct ksmbd_work *work)
 
 		prior_lock = smb_lock->flags;
 
+		/* The SMB lock table stores ranges that file_lock cannot express. */
+		if (smb_lock->virtual_lock &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK))
+			goto no_check_cl;
+		if (smb_lock->virtual_lock &&
+		    (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK)) {
+			err = ksmbd_file_lock_unlock(smb_lock);
+			if (err) {
+				rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
+				goto out;
+			}
+			list_del(&smb_lock->llist);
+			smb2_free_ksmbd_lock(smb_lock);
+			continue;
+		}
+
 		if (!(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) &&
 		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY))
 			goto no_check_cl;
@@ -10437,7 +10558,21 @@ int smb2_lock(struct ksmbd_work *work)
 		flock = smb_lock->fl;
 		list_del(&smb_lock->llist);
 
+		if (smb_lock->virtual_lock &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK)) {
+			rc = smb2_virtual_lock_wait(work, fp, smb_lock, rsp);
+			if (rc) {
+				err = rc;
+				smb2_free_ksmbd_lock(smb_lock);
+				goto out;
+			}
+			list_add(&smb_lock->llist, &rollback_list);
+			if (smb_lock->start > OFFSET_MAX)
+				continue;
+		}
+
 		if (smb_lock->zero_len) {
+			rc = 0;
 			err = 0;
 			goto skip;
 		}
@@ -10464,6 +10599,11 @@ int smb2_lock(struct ksmbd_work *work)
 				argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
 				if (!argv) {
 					err = -ENOMEM;
+					if (smb_lock->virtual_lock) {
+						ksmbd_vfs_posix_lock_unblock(flock);
+						locks_wake_up(flock);
+						goto out;
+					}
 					smb2_free_blocked_lock(flock);
 					kfree(smb_lock);
 					goto out;
@@ -10476,11 +10616,17 @@ int smb2_lock(struct ksmbd_work *work)
 				if (rc) {
 					kfree(argv);
 					err = -ENOMEM;
+					if (smb_lock->virtual_lock) {
+						ksmbd_vfs_posix_lock_unblock(flock);
+						locks_wake_up(flock);
+						goto out;
+					}
 					smb2_free_blocked_lock(flock);
 					kfree(smb_lock);
 					goto out;
 				}
-				list_add(&smb_lock->llist, &rollback_list);
+				if (!smb_lock->virtual_lock)
+					list_add(&smb_lock->llist, &rollback_list);
 				spin_lock(&fp->f_lock);
 				list_add(&work->fp_entry, &fp->blocked_works);
 				spin_unlock(&fp->f_lock);
@@ -10493,16 +10639,19 @@ int smb2_lock(struct ksmbd_work *work)
 				list_del(&work->fp_entry);
 				spin_unlock(&fp->f_lock);
 
-				list_del(&smb_lock->llist);
+				if (!smb_lock->virtual_lock)
+					list_del(&smb_lock->llist);
 
 				if (work->state == KSMBD_WORK_CANCELLED) {
 					rsp->hdr.Status = STATUS_CANCELLED;
-					kfree(smb_lock);
 					smb2_send_interim_resp(work,
 							STATUS_CANCELLED);
 					release_async_work(work);
-					locks_free_lock(flock);
 					work->send_no_response = 1;
+					if (!smb_lock->virtual_lock) {
+						kfree(smb_lock);
+						locks_free_lock(flock);
+					}
 					goto out;
 				}
 
@@ -10511,20 +10660,25 @@ int smb2_lock(struct ksmbd_work *work)
 				if (work->state == KSMBD_WORK_ACTIVE)
 					goto retry;
 
-				locks_free_lock(flock);
-
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
-				kfree(smb_lock);
+				if (!smb_lock->virtual_lock) {
+					locks_free_lock(flock);
+					kfree(smb_lock);
+				}
 				/* rollback_list may still hold earlier grants */
 				goto out;
 			} else if (!rc) {
-				list_add(&smb_lock->llist, &rollback_list);
+				smb_lock->vfs_locked = !smb_lock->zero_len;
+				if (!smb_lock->virtual_lock)
+					list_add(&smb_lock->llist, &rollback_list);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
-				locks_free_lock(flock);
-				kfree(smb_lock);
 				err = rc;
+				if (!smb_lock->virtual_lock) {
+					locks_free_lock(flock);
+					kfree(smb_lock);
+				}
 				goto out;
 			}
 		}
@@ -10561,24 +10715,27 @@ int smb2_lock(struct ksmbd_work *work)
 	list_for_each_entry_safe(smb_lock, tmp, &rollback_list, llist) {
 		struct file_lock *rlock = NULL;
 
-		rlock = smb_flock_init(filp);
-		if (rlock) {
-			rlock->c.flc_type = F_UNLCK;
-			rlock->fl_start = smb_lock->start;
-			rlock->fl_end = smb_lock->end;
+		if (smb_lock->vfs_locked) {
+			rlock = smb_flock_init(filp);
+			if (rlock) {
+				rlock->c.flc_type = F_UNLCK;
+				rlock->fl_start = smb_lock->fl->fl_start;
+				rlock->fl_end = smb_lock->fl->fl_end;
 
-			rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
-			if (rc)
-				pr_err("rollback unlock fail : %d\n", rc);
-		} else {
-			pr_err("rollback unlock alloc failed\n");
+				rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
+				if (rc)
+					pr_err("rollback unlock fail : %d\n", rc);
+			} else {
+				pr_err("rollback unlock alloc failed\n");
+			}
 		}
+		if (smb_lock->virtual_lock)
+			ksmbd_file_lock_remove(smb_lock);
 
 		list_del(&smb_lock->llist);
-		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
-		kfree(smb_lock);
+		smb2_free_ksmbd_lock(smb_lock);
 	}
 out2:
 	ksmbd_debug(SMB, "failed in taking lock(flags : %x), err : %d\n", flags, err);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c5217433299e..e5dbc8e41bfb 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -38,6 +38,7 @@ static DEFINE_RWLOCK(inode_hash_lock);
 static struct ksmbd_file_table global_ft;
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
+DECLARE_WAIT_QUEUE_HEAD(ksmbd_lock_wait);
 
 /* Both the inode hash and each open's lock_list use this lock. */
 static DEFINE_SPINLOCK(file_locks_lock);
@@ -618,6 +619,109 @@ static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp
 	write_unlock(&ft->lock);
 }
 
+/* file_locks_lock protects both committed locks and pending reservations. */
+static bool __ksmbd_file_lock_conflict(struct ksmbd_lock *lock)
+{
+	struct inode *inode = file_inode(lock->fl->c.flc_file);
+	struct ksmbd_lock *cmp;
+
+	hash_for_each_possible(file_locks, cmp, hlist, (unsigned long)inode) {
+		if (cmp == lock || file_inode(cmp->fl->c.flc_file) != inode)
+			continue;
+		if ((cmp->flags & SMB2_LOCKFLAG_SHARED) &&
+		    (lock->flags & SMB2_LOCKFLAG_SHARED))
+			continue;
+		if ((cmp->zero_len && !lock->zero_len &&
+		     cmp->start > lock->start && cmp->start <= lock->end) ||
+		    (lock->zero_len && !cmp->zero_len &&
+		     lock->start > cmp->start && lock->start <= cmp->end) ||
+		    (!cmp->zero_len && !lock->zero_len &&
+		     cmp->start <= lock->end && lock->start <= cmp->end))
+			return true;
+	}
+	return false;
+}
+
+bool ksmbd_file_lock_conflict(struct ksmbd_lock *lock)
+{
+	bool conflict;
+
+	spin_lock(&file_locks_lock);
+	conflict = __ksmbd_file_lock_conflict(lock);
+	spin_unlock(&file_locks_lock);
+	return conflict;
+}
+
+int ksmbd_file_lock_reserve(struct ksmbd_file *fp, struct ksmbd_lock *lock)
+{
+	int ret = 0;
+
+	spin_lock(&file_locks_lock);
+	if (__ksmbd_file_lock_conflict(lock)) {
+		ret = -EAGAIN;
+	} else {
+		/* Reserve the range until the whole LOCK request commits. */
+		lock->pending = true;
+		hash_add(file_locks, &lock->hlist,
+			 (unsigned long)file_inode(fp->filp));
+		list_add_tail(&lock->flist, &fp->lock_list);
+	}
+	spin_unlock(&file_locks_lock);
+	return ret;
+}
+
+void ksmbd_file_lock_remove(struct ksmbd_lock *lock)
+{
+	spin_lock(&file_locks_lock);
+	if (!hlist_unhashed(&lock->hlist)) {
+		hash_del(&lock->hlist);
+		list_del_init(&lock->flist);
+	}
+	spin_unlock(&file_locks_lock);
+	wake_up_all(&ksmbd_lock_wait);
+}
+
+/* Unlock a large range, including any portion represented by a VFS lock. */
+int ksmbd_file_lock_unlock(struct ksmbd_lock *lock)
+{
+	struct inode *inode = file_inode(lock->fl->c.flc_file);
+	struct ksmbd_lock *cmp, *match = NULL;
+	int ret = 0;
+
+	spin_lock(&file_locks_lock);
+	hash_for_each_possible(file_locks, cmp, hlist, (unsigned long)inode) {
+		if (cmp->fl->c.flc_file != lock->fl->c.flc_file ||
+		    cmp->start != lock->start || cmp->end != lock->end ||
+		    cmp->pending)
+			continue;
+		if (waitqueue_active(&cmp->fl->c.flc_wait)) /* VFS waiters */
+			continue;
+		match = cmp;
+		if (cmp->flags & SMB2_LOCKFLAG_EXCLUSIVE)
+			break;
+	}
+	if (match)
+		match->pending = true;
+	spin_unlock(&file_locks_lock);
+	if (!match)
+		return -ENOENT;
+
+	if (match->vfs_locked)
+		ret = vfs_lock_file(lock->fl->c.flc_file, F_SETLK, lock->fl, NULL);
+	if (ret) {
+		spin_lock(&file_locks_lock);
+		match->pending = false;
+		spin_unlock(&file_locks_lock);
+		return ret;
+	}
+	ksmbd_file_lock_remove(match);
+	if (match->vfs_locked)
+		ksmbd_vfs_posix_lock_unblock(match->fl);
+	locks_free_lock(match->fl);
+	kfree(match);
+	return 0;
+}
+
 /**
  * ksmbd_file_lock_check() - check conflicts or remove an exact unlock match
  * @lock: unregistered lock from the current request
@@ -637,7 +741,8 @@ int ksmbd_file_lock_check(struct ksmbd_lock *lock)
 
 		if (lock_is_unlock(lock->fl)) {
 			if (cmp->fl->c.flc_file != lock->fl->c.flc_file ||
-			    cmp->start != lock->start || cmp->end != lock->end)
+			    cmp->start != lock->start || cmp->end != lock->end ||
+			    cmp->pending)
 				continue;
 			if (waitqueue_active(&cmp->fl->c.flc_wait)) /* VFS waiters */
 				continue;
@@ -673,9 +778,11 @@ int ksmbd_file_lock_check(struct ksmbd_lock *lock)
 	}
 	spin_unlock(&file_locks_lock);
 	if (lock_to_remove) {
-		ksmbd_vfs_posix_lock_unblock(lock_to_remove->fl);
+		if (lock_to_remove->vfs_locked)
+			ksmbd_vfs_posix_lock_unblock(lock_to_remove->fl);
 		locks_free_lock(lock_to_remove->fl);
 		kfree(lock_to_remove);
+		wake_up_all(&ksmbd_lock_wait);
 	}
 	return ret;
 }
@@ -692,6 +799,10 @@ void ksmbd_file_lock_add(struct ksmbd_file *fp, struct list_head *locks)
 	spin_lock(&file_locks_lock);
 	list_for_each_entry_safe(lock, tmp, locks, llist) {
 		list_del_init(&lock->llist);
+		if (!hlist_unhashed(&lock->hlist)) {
+			lock->pending = false;
+			continue;
+		}
 		hash_add(file_locks, &lock->hlist,
 			 (unsigned long)file_inode(fp->filp));
 		list_add_tail(&lock->flist, &fp->lock_list);
@@ -712,10 +823,12 @@ static void ksmbd_file_lock_clear(struct ksmbd_file *fp)
 
 	list_for_each_entry_safe(lock, tmp, &dispose, flist) {
 		list_del_init(&lock->flist);
-		ksmbd_vfs_posix_lock_unblock(lock->fl);
+		if (lock->vfs_locked)
+			ksmbd_vfs_posix_lock_unblock(lock->fl);
 		locks_free_lock(lock->fl);
 		kfree(lock);
 	}
+	wake_up_all(&ksmbd_lock_wait);
 }
 
 static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 694453c75ec4..6831aca22cff 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -12,6 +12,7 @@
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
+#include <linux/wait.h>
 #include <linux/workqueue.h>
 
 #include "vfs.h"
@@ -44,12 +45,20 @@ struct ksmbd_lock {
 	unsigned int flags;
 	int cmd;
 	int zero_len;
+	bool virtual_lock;
+	bool vfs_locked;
+	bool pending;
 	unsigned long long start;
 	unsigned long long end;
 };
 
 int ksmbd_file_lock_check(struct ksmbd_lock *lock);
 void ksmbd_file_lock_add(struct ksmbd_file *fp, struct list_head *locks);
+bool ksmbd_file_lock_conflict(struct ksmbd_lock *lock);
+int ksmbd_file_lock_reserve(struct ksmbd_file *fp, struct ksmbd_lock *lock);
+void ksmbd_file_lock_remove(struct ksmbd_lock *lock);
+int ksmbd_file_lock_unlock(struct ksmbd_lock *lock);
+extern wait_queue_head_t ksmbd_lock_wait;
 
 struct stream {
 	char *name;
-- 
2.25.1

