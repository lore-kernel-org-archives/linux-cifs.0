Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046222A4F1
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199055; cv=none; b=Pp184Ds+vxkpU142Ig3nGDmBErvoyJb/s8EcJp1CKti+iEx/NSirXGL4shF4snF8rfrUbwmJcYrp3G2mnCaHFZT2UXNo97ctnye3inmWGJ9QuxnQ3wgqyMTUP/WmXLDbtmbA+J3Q26UOHtLBBHlimvDXA1heUpXnmC9YERWZEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199055; c=relaxed/simple;
	bh=7gPd0WL+jTUcPXtMRVWj4CrkQov8ifK3EGhItFeAPtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OOgYg8GqTAALEywXf9nQSDbyhpyn3vpM9rBnKXYjnAHMIS4MydMo2S6zuvLKjuRbsoEtmdAhk5Wxll0fCIgIR86MlOjgoPkxayPHNpzErRqJPxm6Y8Fw/CIivDoKX8V/WN8dTvm0Vo9hapS4BHvrFbk8+qJW4XGMyfLPO9SPOAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDKCmVol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDKCmVol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242821F000C4;
	Sat, 17 Oct 2026 01:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199053;
	bh=YR2m1X1ozy6XhNuGr7q/R2e3mW5sa+UxO+l0QoTV+70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDKCmVolNsk5nCUjuusLN9gtnDEprorhmfCZUSm48NuQvu3b5WaQrb4PxfcwktuxL
	 tyVJsWjS92adHCW0+zwRWDJ+9IQXtvGtPqbnTaa/ZUq6EWDBjQwmLrwnbUoXt7kSxu
	 dNz14PdAGrkWUHT6LmdVn/C0JeX3d7fx7+JhG7/QYG5aM+jD/nnjgQHdh47coo4nWd
	 KtF2oYwQhRdUd2k0mbmGWoRQqlQcbM6w73TipeV0r73t8pmg1NvDJKdg+QqjYhfZGB
	 n9plxhRWLK1jLp0QSZIOcqOhvkeSnbpksDMSS27u+rO7w4BNbDG+ZeVzUydgZvVq6L
	 jlS0PWaHew88Q==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 07/22] ksmbd: rebind completed CREATE replays without draining the old channel
Date: Sat, 17 Oct 2026 10:03:29 +0900
Message-Id: <20261017010344.11478-7-linkinjeon@kernel.org>
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

A completed DurableHandleReqV2 CREATE can be replayed through another
channel while its original channel is exiting. The existing replay path
returns the open but leaves its connection and oplock references pointing
at the old channel. Its open count also stays on that channel, and a
later CLOSE through the surviving channel decrements the wrong counter.

After checking the owner, lease key and persistent flag, verify that an
active open is still published in the requesting session's file table.
Do this even when no oplock was granted, and before processing a consumed
replay. Do not read a borrowed opinfo session pointer for this check.

Keep a healthy original binding. If the original channel is exiting or
releasing, move the open and its own oplock references to the requesting
channel. Serialize this with CLOSE using the session file-table lock,
and with detach, reconnect and notification snapshots using m_lock.
The earlier lock index and lease-table changes make their lifetimes
independent of this connection change. No old-channel r_count wait is
needed, including when an unrelated request remains active there.

Account final close against fp->conn in one place, balance durable detach
and reconnect, and transfer the count with a replay binding change. A
final global lookup put may run after CLOSE has removed the volatile id;
unlink the open from the inode list on that final close as well.

A live completed CREATE replay may follow a break that lowered the
durable open's batch oplock. Apply the batch eligibility check only to
detached reconnects, while retaining the owner, lease key and persistent
flag checks for active replays.

Fixes: bb8bf7eb13b5 ("ksmbd: add SMB3 request replay support")
Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   |  59 ++++----------
 fs/smb/server/vfs_cache.c | 164 ++++++++++++++++++++++----------------
 fs/smb/server/vfs_cache.h |   1 +
 3 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 853a892e2ad5..d2f02a0957a7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3747,7 +3747,7 @@ static int smb2_check_durable_replay(struct ksmbd_work *work,
 	struct oplock_info *opinfo;
 	int ret = 0;
 
-	if (!fp->is_durable && !fp->is_persistent)
+	if (!fp->conn && !fp->is_durable && !fp->is_persistent)
 		return -EACCES;
 
 	if (ksmbd_vfs_compare_durable_owner(fp, work->sess->user) == false)
@@ -3760,11 +3760,6 @@ static int smb2_check_durable_replay(struct ksmbd_work *work,
 	if (!opinfo)
 		return 0;
 
-	if (opinfo->sess && opinfo->sess->id != work->sess->id) {
-		ret = -ENOEXEC;
-		goto out;
-	}
-
 	if (opinfo->is_lease) {
 		if (!lc ||
 		    memcmp(opinfo->o_lease->lease_key, lc->lease_key,
@@ -3778,7 +3773,9 @@ static int smb2_check_durable_replay(struct ksmbd_work *work,
 			goto out;
 		}
 
-		if (fp->is_durable && opinfo->level != SMB2_OPLOCK_LEVEL_BATCH)
+		/* A live CREATE replay may follow a completed oplock break. */
+		if (!fp->conn && fp->is_durable &&
+		    opinfo->level != SMB2_OPLOCK_LEVEL_BATCH)
 			ret = -EACCES;
 	}
 out:
@@ -3982,35 +3979,18 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 						goto out;
 					}
 
-					if (!dh_info->fp->is_durable &&
-					    !dh_info->fp->is_persistent) {
-						/*
-						 * A DurableHandleReqV2 CREATE can complete
-						 * without granting durability (for example, if
-						 * it requested no oplock).  Its CreateGuid still
-						 * identifies a completed CREATE for replay.
-						 */
-						if (dh_info->fp->conn &&
-						    ksmbd_vfs_compare_durable_owner(
-							    dh_info->fp, work->sess->user)) {
-							if (smb2_durable_replay_consumed(
-								    dh_info->fp)) {
-								ksmbd_put_durable_fd(dh_info->fp);
-								dh_info->fp = NULL;
-								dh_info->type = dh_idx;
-								dh_info->replay_consumed = true;
-								break;
-							}
-							if (smb2_durable_replay_differs(
-								    dh_info->fp, req))
-								smb2_mark_durable_replay_consumed(
-									dh_info->fp);
-							dh_info->replay = true;
-							dh_info->type = dh_idx;
-							goto out;
-						}
+					err = smb2_check_durable_replay(work,
+									dh_info->fp,
+									lc,
+									dh_info->persistent);
+					if (err) {
+						ksmbd_put_durable_fd(dh_info->fp);
+						goto out;
+					}
+
+					err = ksmbd_rebind_replay_fd(work, dh_info->fp);
+					if (err) {
 						ksmbd_put_durable_fd(dh_info->fp);
-						err = -EACCES;
 						goto out;
 					}
 
@@ -4023,15 +4003,6 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 						break;
 					}
 
-					err = smb2_check_durable_replay(work,
-									dh_info->fp,
-									lc,
-									dh_info->persistent);
-					if (err) {
-						ksmbd_put_durable_fd(dh_info->fp);
-						goto out;
-					}
-
 					if (dh_info->fp->conn) {
 						if (smb2_durable_replay_differs(dh_info->fp,
 									       req))
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 459783910c04..c5217433299e 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -610,7 +610,7 @@ static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp
 	list_del_init(&fp->node);
 	up_write(&fp->f_ci->m_lock);
 
-	if (!has_file_id(fp->volatile_id))
+	if (!ft || !has_file_id(fp->volatile_id))
 		return;
 
 	write_lock(&ft->lock);
@@ -724,8 +724,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
-	if (ft)
-		__ksmbd_remove_fd(ft, fp);
+	__ksmbd_remove_fd(ft, fp);
 
 	close_id_del_oplock(fp);
 	filp = fp->filp;
@@ -743,6 +742,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	 * in which case there is nothing to drop here.
 	 */
 	if (fp->conn) {
+		atomic_dec(&fp->conn->stats.open_files_count);
 		ksmbd_conn_put(fp->conn);
 		fp->conn = NULL;
 	}
@@ -860,22 +860,7 @@ static struct ksmbd_file *__ksmbd_lookup_fd(struct ksmbd_file_table *ft,
 
 static void __put_fd_final(struct ksmbd_work *work, struct ksmbd_file *fp)
 {
-	/*
-	 * Detached durable fp -- session_fd_check() cleared fp->conn at
-	 * preserve, so this fp is no longer tracked by any conn's
-	 * stats.open_files_count.  This happens when
-	 * ksmbd_scavenger_dispose_dh() hands the final close off to an
-	 * m_fp_list walker (e.g. ksmbd_lookup_fd_inode()) whose work->conn
-	 * is unrelated to the conn that originally opened the handle; close
-	 * via the NULL-ft path so we do not underflow that unrelated
-	 * counter.
-	 */
-	if (!fp->conn) {
-		__ksmbd_close_fd(NULL, fp);
-		return;
-	}
-	__ksmbd_close_fd(&work->sess->file_table, fp);
-	atomic_dec(&work->conn->stats.open_files_count);
+	__ksmbd_close_fd(fp->conn ? &work->sess->file_table : NULL, fp);
 }
 
 static void set_close_state_blocked_works(struct ksmbd_file *fp)
@@ -1127,11 +1112,8 @@ int ksmbd_close_fd_app_instance_id(struct ksmbd_work *work,
 	up_write(&fp->f_ci->m_lock);
 
 	*closed = true;
-	if (atomic_sub_and_test(n_to_drop, &fp->refcount)) {
-		if (fp->conn)
-			atomic_dec(&fp->conn->stats.open_files_count);
+	if (atomic_sub_and_test(n_to_drop, &fp->refcount))
 		__ksmbd_close_fd(NULL, fp);
-	}
 	return 0;
 
 out:
@@ -1421,7 +1403,7 @@ static int ksmbd_mark_fp_closed(struct ksmbd_file *fp)
 	return 1;
 }
 
-static int
+static void
 __close_file_table_ids(struct ksmbd_session *sess,
 		       struct ksmbd_tree_connect *tcon,
 		       bool (*skip)(struct ksmbd_tree_connect *tcon,
@@ -1432,7 +1414,6 @@ __close_file_table_ids(struct ksmbd_session *sess,
 	struct ksmbd_file_table *ft = &sess->file_table;
 	struct ksmbd_file *fp;
 	unsigned int id = 0;
-	int num = 0;
 
 	while (1) {
 		int n_to_drop;
@@ -1516,10 +1497,8 @@ __close_file_table_ids(struct ksmbd_session *sess,
 		}
 
 		/*
-		 * fp->volatile_id is already cleared to prevent stale idr
-		 * removal from a deferred final close.  Remove fp from
-		 * m_fp_list here because __ksmbd_remove_fd() will skip the
-		 * list unlink when volatile_id is KSMBD_NO_FID.
+		 * Stop inode walkers from finding the open after close is committed.
+		 * Final close also unlinks fp if a global lookup owns the last put.
 		 */
 		down_write(&fp->f_ci->m_lock);
 		list_del_init(&fp->node);
@@ -1538,22 +1517,13 @@ __close_file_table_ids(struct ksmbd_session *sess,
 		 *     the original reference until ksmbd_update_fstate()
 		 *     observes the cleared volatile id.
 		 *
-		 * If we end up as the final putter, finalize fp and
-		 * account the open_files_count decrement via the caller's
-		 * atomic_sub(num, ...).  Otherwise the remaining user's
-		 * ksmbd_fd_put() reaches __put_fd_final(), which does its
-		 * own atomic_dec(&open_files_count), so we must not count
-		 * this fp here -- doing so would double-decrement the
-		 * connection-wide counter.
+		 * The final close accounts the open against fp->conn,
+		 * including when an in-flight user drops the last reference.
 		 */
-		if (atomic_sub_and_test(n_to_drop, &fp->refcount)) {
+		if (atomic_sub_and_test(n_to_drop, &fp->refcount))
 			__ksmbd_close_fd(NULL, fp);
-			num++;
-		}
 		id++;
 	}
-
-	return num;
 }
 
 static inline bool is_reconnectable(struct ksmbd_file *fp)
@@ -1841,29 +1811,29 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	 * / ksmbd_reopen_durable_fd()), so conn stays valid for the whole
 	 * body of this function regardless of any op->conn puts below.
 	 */
-	conn = fp->conn;
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
+	conn = fp->conn;
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
 				lockdep_is_held(&ci->m_lock)) {
-		if (op->conn != conn)
+		if (op->o_fp != fp)
 			continue;
 		ksmbd_conn_put(op->conn);
 		op->conn = NULL;
 		op->sess = NULL;
 		op->session_id = 0;
 	}
-	up_write(&ci->m_lock);
-
-	spin_lock(&fp->f_lock);
+	write_lock(&global_ft.lock);
 	fp->conn = NULL;
 	fp->tcon = NULL;
 	fp->volatile_id = KSMBD_NO_FID;
-	spin_unlock(&fp->f_lock);
 
 	if (fp->durable_timeout)
 		fp->durable_scavenger_timeout =
 			jiffies_to_msecs(jiffies) + fp->durable_timeout;
+	atomic_dec(&conn->stats.open_files_count);
+	write_unlock(&global_ft.lock);
+	up_write(&ci->m_lock);
 
 	/* Drop fp's own reference on conn. */
 	ksmbd_conn_put(conn);
@@ -1872,22 +1842,12 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 
 void ksmbd_close_tree_conn_fds(struct ksmbd_work *work)
 {
-	int num = __close_file_table_ids(work->sess,
-					 work->tcon,
-					 tree_conn_fd_check,
-					 false);
-
-	atomic_sub(num, &work->conn->stats.open_files_count);
+	__close_file_table_ids(work->sess, work->tcon, tree_conn_fd_check, false);
 }
 
 void ksmbd_close_session_fds(struct ksmbd_work *work)
 {
-	int num = __close_file_table_ids(work->sess,
-					 work->tcon,
-					 session_fd_check,
-					 true);
-
-	atomic_sub(num, &work->conn->stats.open_files_count);
+	__close_file_table_ids(work->sess, work->tcon, session_fd_check, true);
 }
 
 int ksmbd_init_global_file_table(void)
@@ -1957,23 +1917,26 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 
 int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 {
-	struct ksmbd_inode *ci;
+	struct ksmbd_inode *ci = fp->f_ci;
 	struct oplock_info *op;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *old_share;
 	unsigned int old_f_state;
+	int ret = -EBADF;
 
+	down_write(&ci->m_lock);
 	write_lock(&global_ft.lock);
-	if ((!fp->is_durable && !fp->is_persistent) || fp->conn || fp->tcon) {
+	if ((!fp->is_durable && !fp->is_persistent) || fp->conn || fp->tcon ||
+	    fp->f_state != FP_INITED) {
 		write_unlock(&global_ft.lock);
 		pr_err("Invalid durable fd [%p:%p]\n", fp->conn, fp->tcon);
-		return -EBADF;
+		goto out;
 	}
 
 	if (has_file_id(fp->volatile_id)) {
 		write_unlock(&global_ft.lock);
 		pr_err("Still in use durable fd: %llu\n", fp->volatile_id);
-		return -EBADF;
+		goto out;
 	}
 
 	/*
@@ -1993,6 +1956,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	fp->conn = ksmbd_conn_get(conn);
 	fp->tcon = work->tcon;
 	spin_unlock(&fp->f_lock);
+	atomic_inc(&conn->stats.open_files_count);
 	write_unlock(&global_ft.lock);
 
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
@@ -2004,14 +1968,13 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		fp->share_conf = old_share;
 		fp->f_state = old_f_state;
 		spin_unlock(&fp->f_lock);
+		atomic_dec(&conn->stats.open_files_count);
 		write_unlock(&global_ft.lock);
 		ksmbd_conn_put(conn);
 		ksmbd_share_config_put(work->tcon->share_conf);
-		return -EBADF;
+		goto out;
 	}
 
-	ci = fp->f_ci;
-	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
 				lockdep_is_held(&ci->m_lock)) {
 		if (op->conn || op->o_fp != fp)
@@ -2020,7 +1983,6 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		op->sess = work->sess;
 		op->session_id = work->sess->id;
 	}
-	up_write(&ci->m_lock);
 
 	spin_lock(&fp->f_lock);
 	fp->owner.uid = fp->owner.gid = 0;
@@ -2029,7 +1991,73 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	spin_unlock(&fp->f_lock);
 	ksmbd_share_config_put(old_share);
 
-	return 0;
+	ret = 0;
+out:
+	up_write(&ci->m_lock);
+	return ret;
+}
+
+/**
+ * ksmbd_rebind_replay_fd() - bind a completed replay to a surviving channel
+ * @work: replay request, with a referenced session
+ * @fp: referenced open whose owner and lease key have been checked
+ *
+ * Return: 0 on success, -ENOEXEC for another session, or -EBADF for a closed open.
+ */
+int ksmbd_rebind_replay_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
+{
+	struct ksmbd_file_table *ft = &work->sess->file_table;
+	struct ksmbd_inode *ci = fp->f_ci;
+	struct ksmbd_conn *old_conn = NULL;
+	struct oplock_info *op;
+	int ret = 0;
+
+	/* CLOSE unpublishes under ft->lock. Detach takes m_lock afterward. */
+	down_write(&ci->m_lock);
+	read_lock(&ft->lock);
+	if (fp->f_state != FP_INITED) {
+		ret = -EBADF;
+		goto out;
+	}
+	/* Detached durable opens follow the existing reconnect path. */
+	if (!fp->conn)
+		goto out;
+	if (!has_file_id(fp->volatile_id)) {
+		ret = -EBADF;
+		goto out;
+	}
+	if (idr_find(ft->idr, fp->volatile_id) != fp) {
+		ret = -ENOEXEC;
+		goto out;
+	}
+	if (fp->conn == work->conn ||
+	    (!ksmbd_conn_exiting(fp->conn) && !ksmbd_conn_releasing(fp->conn)))
+		goto out;
+
+	write_lock(&global_ft.lock);
+	old_conn = fp->conn;
+	fp->conn = ksmbd_conn_get(work->conn);
+	atomic_inc(&fp->conn->stats.open_files_count);
+	atomic_dec(&old_conn->stats.open_files_count);
+	write_unlock(&global_ft.lock);
+
+	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
+				lockdep_is_held(&ci->m_lock)) {
+		struct ksmbd_conn *conn;
+
+		if (op->o_fp != fp)
+			continue;
+		conn = op->conn;
+		op->conn = ksmbd_conn_get(fp->conn);
+		op->sess = work->sess;
+		op->session_id = work->sess->id;
+		ksmbd_conn_put(conn);
+	}
+out:
+	read_unlock(&ft->lock);
+	up_write(&ci->m_lock);
+	ksmbd_conn_put(old_conn);
+	return ret;
 }
 
 int ksmbd_init_file_table(struct ksmbd_file_table *ft)
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 6df48ae04548..694453c75ec4 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -260,6 +260,7 @@ void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 void ksmbd_fd_set_delete_pending(struct ksmbd_file *fp);
 void ksmbd_fd_clear_delete_pending(struct ksmbd_file *fp);
 int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp);
+int ksmbd_rebind_replay_fd(struct ksmbd_work *work, struct ksmbd_file *fp);
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 				  struct ksmbd_file *fp, char *name);
 int ksmbd_init_file_cache(void);
-- 
2.25.1

