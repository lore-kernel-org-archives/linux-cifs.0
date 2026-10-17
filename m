Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7666E555
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199062; cv=none; b=oUqXi5Bwlu05jQtBSCvDlAf4BBcWQGdflWIe34sfkbsoqdxfFNlz9o94Oz3PLVl/Sa390E2s1LaIUgOxZMEOTl/pEW0WBYKK8rtkV0Yt9YPo04HtNR7lWzi4K05yqz9tWcA7SRy+rmmrbBl/honMl+zIadcGwXvYH5mlWWfTsx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199062; c=relaxed/simple;
	bh=5w4OoiLBLNwoOKGwCXwpOZun1Sw2F+ZDX9lAh55qXcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bRTIfq1Y4zTMDSLCMqDSel7Va1l0hKmvDeOSD4zAe0+OtruZY+PHa8zzknYH23wkqwIJWTs4ORbsEyGLTmSKMkyCiXvElcMUW0rjD/+qYOyFyr6hxk+LllTjJZCoEb9XjzjjoGjifF521Dmc+HvHL/i3wjtNUQSYc/TQyslfF8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPNvIwXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPNvIwXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5631F000C5;
	Sat, 17 Oct 2026 01:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199060;
	bh=BUONWoc2MZQyLud+35pcmEYGHiZehNyEn/LI0dT21rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPNvIwXngK7sILtCff4nMufb1uBmPFcUq/UwVxNjqgrLzYUU2835Il6YWK+TQe/GF
	 F4i2iphhAkqjQkDhEffv9cNm7mAzHTGjR8PQMfgqMDmw3nKc4yjrkCBdZ9ovUQK5dg
	 OO2m2cUH21cFEgir68l8POHdo9Xvn/XuyeT5GGfLNseJxT1xvajufm990e3OEiqfy5
	 Dbkd0M95sh4yufvIvsKSaM/QXWapiojK+VTC94wlutp55AMqlxgxHMV66sg/Pjb0vX
	 BgazJFDGY/LHWhLuIacn08uJzLE+MOtuRis1Ybn/vSovhq1DYxoDzStplcTohKKTo/
	 ooyYstsLOiC0Q==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 10/22] ksmbd: expire unacknowledged lease breaks
Date: Sat, 17 Oct 2026 10:03:32 +0900
Message-Id: <20261017010344.11478-10-linkinjeon@kernel.org>
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

Arm a lease break acknowledgment timer once the common notification path
accepts an ACK-required notification for transmission. Keep the deadline
on the lease across channel retries and scan every lease in the global
lease tables when the timer expires. Set timed-out leases and all their
opens to NONE, then rearm for the next deadline.

Serialize client acknowledgments, notification state and timer expiry
under the lease lock, taking each open's state lock after it. Update every
open before publishing break completion so a late acknowledgment cannot
restore an expired lease. Wake blocked opens on timeout, send failure and
global lease-table teardown, and cancel the timer at teardown.

Keep the existing connection-independent lease-table lifetime and use the
notifier's opinfo reference to retain the lease. Stop after selecting one
open during lease-key lookup.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 184 +++++++++++++++++++++++++++++++++++-----
 fs/smb/server/oplock.h  |   3 +
 fs/smb/server/smb2pdu.c |  30 +++++--
 3 files changed, 191 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 352a9e2293b5..5873bd349e08 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -20,6 +20,11 @@
 
 static LIST_HEAD(lease_table_list);
 static DEFINE_RWLOCK(lease_list_lock);
+static DEFINE_MUTEX(lease_break_timer_lock);
+static unsigned long lease_break_timer_next;
+static bool lease_break_timer_pending;
+static void lease_break_timer(struct work_struct *work);
+static DECLARE_DELAYED_WORK(lease_break_timer_work, lease_break_timer);
 
 #define SMB2_LEASE_STATE_MASK_LE	(SMB2_LEASE_READ_CACHING_LE | \
 					 SMB2_LEASE_HANDLE_CACHING_LE | \
@@ -116,6 +121,82 @@ static void lease_put(struct lease *lease)
 		kfree(lease);
 }
 
+/* The caller holds lease->lock. */
+static void lease_break_to_none_locked(struct lease *lease)
+{
+	struct oplock_info *opinfo;
+	bool wake;
+
+	lease->state = SMB2_LEASE_NONE_LE;
+	lease->new_state = SMB2_LEASE_NONE_LE;
+	lease->breaking = false;
+	lease->break_timeout_set = false;
+	list_for_each_entry(opinfo, &lease->open_list, lease_entry) {
+		spin_lock(&opinfo->state_lock);
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		wake = opinfo->op_state == OPLOCK_ACK_WAIT;
+		if (wake) {
+			opinfo->op_state = OPLOCK_STATE_NONE;
+			opinfo->oplock_timed_out = true;
+			atomic_set(&opinfo->breaking_cnt, 0);
+		}
+		spin_unlock(&opinfo->state_lock);
+		if (wake) {
+			wake_up_all(&opinfo->oplock_q);
+			wake_up_interruptible_all(&opinfo->oplock_brk);
+		}
+	}
+}
+
+static void lease_break_timer(struct work_struct *work)
+{
+	struct lease_table *lb;
+	struct lease *lease;
+	unsigned long next = 0, now;
+	bool pending = false;
+
+	mutex_lock(&lease_break_timer_lock);
+	now = jiffies;
+	read_lock(&lease_list_lock);
+	list_for_each_entry(lb, &lease_table_list, l_entry) {
+		list_for_each_entry(lease, &lb->lease_list, l_entry) {
+			spin_lock(&lease->lock);
+			if (lease->breaking && lease->break_timeout_set) {
+				if (time_after_eq(now, lease->break_timeout)) {
+					lease_break_to_none_locked(lease);
+				} else if (!pending ||
+					   time_before(lease->break_timeout, next)) {
+					next = lease->break_timeout;
+					pending = true;
+				}
+			}
+			spin_unlock(&lease->lock);
+		}
+	}
+	read_unlock(&lease_list_lock);
+
+	lease_break_timer_pending = pending;
+	if (pending) {
+		lease_break_timer_next = next;
+		mod_delayed_work(system_wq, &lease_break_timer_work,
+				 time_after_eq(jiffies, next) ? 0 : next - jiffies);
+	}
+	mutex_unlock(&lease_break_timer_lock);
+}
+
+static void schedule_lease_break_timer(unsigned long timeout)
+{
+	mutex_lock(&lease_break_timer_lock);
+	if (!lease_break_timer_pending ||
+	    time_before(timeout, lease_break_timer_next)) {
+		lease_break_timer_pending = true;
+		lease_break_timer_next = timeout;
+		mod_delayed_work(system_wq, &lease_break_timer_work,
+				 time_after_eq(jiffies, timeout) ? 0 : timeout - jiffies);
+	}
+	mutex_unlock(&lease_break_timer_lock);
+}
+
 static void lease_add_table(struct lease *lease, struct lease_table *lb)
 {
 	lease_get(lease);
@@ -190,6 +271,8 @@ static struct lease *alloc_lease(struct lease_ctx_info *lctx,
 	lease->epoch = lctx->version == 2 ? le16_to_cpu(lctx->epoch) + 1 : 0;
 	lease->ci = ci;
 	lease->reuse_epoch = false;
+	lease->breaking = false;
+	lease->break_timeout_set = false;
 	lease->l_lb = NULL;
 	INIT_LIST_HEAD(&lease->l_entry);
 	INIT_LIST_HEAD(&lease->open_list);
@@ -822,11 +905,38 @@ static bool lease_break_needed(struct oplock_info *opinfo, int req_op_level,
 static void smb2_break_start_timer(struct oplock_info *opinfo,
 				   unsigned long timeout)
 {
-	bool start = false;
+	struct lease *lease = opinfo->o_lease;
+	struct oplock_info *open;
+	bool start = false, waiting;
+
+	if (opinfo->is_lease) {
+		read_lock(&lease_list_lock);
+		spin_lock(&lease->lock);
+		if (!lease->l_lb) {
+			lease_break_to_none_locked(lease);
+		} else if (!lease->breaking) {
+			list_for_each_entry(open, &lease->open_list, lease_entry) {
+				spin_lock(&open->state_lock);
+				waiting = open->op_state == OPLOCK_ACK_WAIT;
+				spin_unlock(&open->state_lock);
+				if (!waiting)
+					continue;
+				lease->break_timeout = timeout;
+				lease->break_timeout_set = true;
+				lease->breaking = true;
+				start = true;
+				break;
+			}
+		}
+		spin_unlock(&lease->lock);
+		read_unlock(&lease_list_lock);
+		if (start)
+			schedule_lease_break_timer(timeout);
+		return;
+	}
 
 	spin_lock(&opinfo->state_lock);
-	if (!opinfo->is_lease && opinfo->op_state == OPLOCK_ACK_WAIT &&
-	    !opinfo->oplock_timeout_set) {
+	if (opinfo->op_state == OPLOCK_ACK_WAIT && !opinfo->oplock_timeout_set) {
 		opinfo->oplock_timeout = timeout;
 		opinfo->oplock_timeout_set = true;
 		start = true;
@@ -858,25 +968,33 @@ static bool smb2_break_complete(struct oplock_info *opinfo, bool expect_ack)
 
 static int smb2_break_failed(struct oplock_info *opinfo, bool expect_ack)
 {
+	struct lease *lease = opinfo->o_lease;
+	bool timed_out;
+
+	if (opinfo->is_lease)
+		spin_lock(&lease->lock);
 	spin_lock(&opinfo->state_lock);
 	/* An ACK or close which won the race has already completed the break. */
 	if (opinfo->op_state == OPLOCK_CLOSING ||
 	    (expect_ack && opinfo->op_state == OPLOCK_STATE_NONE)) {
+		timed_out = opinfo->oplock_timed_out;
 		spin_unlock(&opinfo->state_lock);
-		return 0;
+		if (opinfo->is_lease)
+			spin_unlock(&lease->lock);
+		return timed_out ? ksmbd_invalidate_durable_fd(opinfo->fid) : 0;
 	}
 	if (opinfo->is_lease) {
-		opinfo->o_lease->state = SMB2_LEASE_NONE_LE;
-		opinfo->o_lease->new_state = SMB2_LEASE_NONE_LE;
-		lease_update_oplock_levels(opinfo->o_lease);
-		atomic_set(&opinfo->breaking_cnt, 0);
+		spin_unlock(&opinfo->state_lock);
+		lease_break_to_none_locked(lease);
+		spin_unlock(&lease->lock);
+	} else {
+		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+		opinfo->op_state = OPLOCK_STATE_NONE;
+		opinfo->oplock_timeout_set = false;
+		opinfo->oplock_timed_out = true;
+		spin_unlock(&opinfo->state_lock);
+		wake_up_all(&opinfo->oplock_q);
 	}
-	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	opinfo->oplock_timeout_set = false;
-	opinfo->oplock_timed_out = true;
-	spin_unlock(&opinfo->state_lock);
-	wake_up_all(&opinfo->oplock_q);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	return ksmbd_invalidate_durable_fd(opinfo->fid);
 }
@@ -1096,6 +1214,7 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 	struct smb2_oplock_break *oplock_rsp;
 	struct smb2_lease_break *lease_rsp;
 	struct lease *lease = opinfo->o_lease;
+	struct oplock_info *open;
 	unsigned long deadline, retry_at;
 	int ret, size;
 	LIST_HEAD(channels);
@@ -1122,10 +1241,14 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 	if (ret)
 		goto failed;
 
+	if (opinfo->is_lease)
+		spin_lock(&lease->lock);
 	spin_lock(&opinfo->state_lock);
 	if (opinfo->op_state == OPLOCK_CLOSING ||
 	    (expect_ack && opinfo->op_state == OPLOCK_STATE_NONE)) {
 		spin_unlock(&opinfo->state_lock);
+		if (opinfo->is_lease)
+			spin_unlock(&lease->lock);
 		ret = 0;
 		goto out;
 	}
@@ -1159,6 +1282,8 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 		size = sizeof(*oplock_rsp);
 	}
 	spin_unlock(&opinfo->state_lock);
+	if (opinfo->is_lease)
+		spin_unlock(&lease->lock);
 	ret = ksmbd_iov_pin_rsp(work, oplock_rsp, size);
 	if (ret)
 		goto failed;
@@ -1222,12 +1347,16 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 	if (ret)
 		goto failed;
 	if (!expect_ack && opinfo->is_lease) {
-		spin_lock(&opinfo->state_lock);
-		if (opinfo->op_state != OPLOCK_CLOSING) {
+		spin_lock(&lease->lock);
+		if (READ_ONCE(opinfo->op_state) != OPLOCK_CLOSING) {
 			lease->state = lease->new_state;
-			lease_update_oplock_levels(lease);
+			list_for_each_entry(open, &lease->open_list, lease_entry) {
+				spin_lock(&open->state_lock);
+				open->level = smb2_map_lease_to_oplock(lease->state);
+				spin_unlock(&open->state_lock);
+			}
 		}
-		spin_unlock(&opinfo->state_lock);
+		spin_unlock(&lease->lock);
 	}
 	goto out;
 failed:
@@ -1379,6 +1508,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 			open_trunc = brk_opinfo->open_trunc;
 
 again:
+		spin_lock(&lease->lock);
 		atomic_inc(&brk_opinfo->breaking_cnt);
 		if (open_trunc) {
 			/*
@@ -1413,6 +1543,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 					     SMB2_LEASE_HANDLE_CACHING_LE);
 		if (expect_ack) {
 			if (!oplock_break_set_ack_wait(brk_opinfo)) {
+				spin_unlock(&lease->lock);
 				atomic_dec_if_positive(&brk_opinfo->breaking_cnt);
 				clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 				return -ENOENT;
@@ -1427,6 +1558,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 			inc_epoch = false;
 			lease->reuse_epoch = false;
 		}
+		spin_unlock(&lease->lock);
 		err = smb2_break_notify_with_interim(brk_opinfo, ci, expect_ack,
 						    wait_ack, inc_epoch,
 						    sent_interim ? NULL : in_work,
@@ -1524,11 +1656,20 @@ void destroy_lease_table(void)
 	struct lease_table *lb;
 	struct lease *lease;
 
+	cancel_delayed_work_sync(&lease_break_timer_work);
+	mutex_lock(&lease_break_timer_lock);
+	lease_break_timer_pending = false;
+	mutex_unlock(&lease_break_timer_lock);
+
 	write_lock(&lease_list_lock);
 	while (!list_empty(&lease_table_list)) {
 		lb = list_first_entry(&lease_table_list, struct lease_table,
 				      l_entry);
 		lease = list_first_entry(&lb->lease_list, struct lease, l_entry);
+		spin_lock(&lease->lock);
+		if (lease->breaking)
+			lease_break_to_none_locked(lease);
+		spin_unlock(&lease->lock);
 		lease_del_table(lease);
 	}
 	write_unlock(&lease_list_lock);
@@ -2551,11 +2692,13 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 	list_for_each_entry(lease, &lt->lease_list, l_entry) {
 		if (memcmp(lease->lease_key, lease_key, SMB2_LEASE_KEY_SIZE))
 			continue;
+		spin_lock(&lease->lock);
 		if (!(lease->state & (SMB2_LEASE_HANDLE_CACHING_LE |
-				      SMB2_LEASE_WRITE_CACHING_LE)))
+				      SMB2_LEASE_WRITE_CACHING_LE))) {
+			spin_unlock(&lease->lock);
 			break;
+		}
 
-		spin_lock(&lease->lock);
 		list_for_each_entry(opinfo, &lease->open_list, lease_entry) {
 			if (!opinfo->op_state ||
 			    opinfo->op_state == OPLOCK_CLOSING)
@@ -2563,6 +2706,7 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 			ret_op = opinfo;
+			break;
 		}
 		spin_unlock(&lease->lock);
 		if (ret_op) {
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 03a5b93da2ec..d81013c514e3 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -50,6 +50,9 @@ struct lease {
 	unsigned short		epoch;
 	bool			is_dir;
 	bool			reuse_epoch;
+	bool			breaking;
+	bool			break_timeout_set;
+	unsigned long		break_timeout;
 	struct ksmbd_inode	*ci;
 	struct lease_table	*l_lb;
 	struct list_head	l_entry;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 77f3b9a5cdfc..9d6426450827 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12086,10 +12086,12 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
-	struct oplock_info *opinfo;
+	struct oplock_info *opinfo, *open;
 	int ret;
 	__le32 lease_state;
 	struct lease *lease;
+	u8 level;
+	bool wake;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -12105,6 +12107,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	lease = opinfo->o_lease;
 
 	/* Publish NONE only after the lease state and all open levels are updated. */
+	spin_lock(&lease->lock);
 	spin_lock(&opinfo->state_lock);
 	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
 		if (opinfo->op_state == OPLOCK_STATE_NONE &&
@@ -12132,17 +12135,31 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	lease_state = req->LeaseState;
 	lease->state = lease_state;
 	lease->new_state = SMB2_LEASE_NONE_LE;
-	lease_update_oplock_levels(lease);
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	atomic_dec_if_positive(&opinfo->breaking_cnt);
+	lease->breaking = false;
+	lease->break_timeout_set = false;
+	level = smb2_map_lease_to_oplock(lease_state);
 	spin_unlock(&opinfo->state_lock);
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	wake_up_interruptible_all(&opinfo->oplock_brk);
+	list_for_each_entry(open, &lease->open_list, lease_entry) {
+		spin_lock(&open->state_lock);
+		open->level = level;
+		wake = open->op_state == OPLOCK_ACK_WAIT;
+		if (wake) {
+			open->op_state = OPLOCK_STATE_NONE;
+			atomic_set(&open->breaking_cnt, 0);
+		}
+		spin_unlock(&open->state_lock);
+		if (wake) {
+			wake_up_all(&open->oplock_q);
+			wake_up_interruptible_all(&open->oplock_brk);
+		}
+	}
+	spin_unlock(&lease->lock);
 	goto response;
 
 replay_rsp:
 	lease_state = lease->state;
 	spin_unlock(&opinfo->state_lock);
+	spin_unlock(&lease->lock);
 response:
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -12158,6 +12175,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 
 err_unlock:
 	spin_unlock(&opinfo->state_lock);
+	spin_unlock(&lease->lock);
 err_out:
 	smb2_set_err_rsp(work);
 	opinfo_put(opinfo);
-- 
2.25.1

