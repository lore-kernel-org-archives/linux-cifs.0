Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D0035F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199059; cv=none; b=SRTP8732BUOp69+k2Y1PE6wJtZFaUyeb9NSM4gsi/Zk71gasWd5niR88zCgjbd5B1SwapfHuADrzhLpKUqmp/1CKp3HPCkt9MHiF1mPMAl1iM2bnU+ZkHzIYUcxWAakeSEj9braqOoWlu/zVLBBM+H7k12xWZp0/7DvMzSgRnxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199059; c=relaxed/simple;
	bh=dPqLGa/z2TO1rWcniWZWtlOSH6KeEP9jt+bUeKxsVzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c8rs/IjBG/sRPeLTd7XC4ORbKC3FBn9ZZTQFqgjhMAnVkpjrLdESJaF907J+4CAh7mtDr8+H81bOqAwGANIrOsjvSTbdc3ZIwTn86TCIuvHv0EbBkJCa+MLftnzrq5mplQb3ljNhA+payiA9zXQHiy8vqPJzj2rNLvCA5zc8Z1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECkHHlP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECkHHlP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADA41F000C4;
	Sat, 17 Oct 2026 01:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199058;
	bh=hf9Hbq14F647+7eTK5XZ9rH34ef4xJr98zHf/YiX41E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECkHHlP7ZCPebi/F08elTvi4Nxql3blLiS0UY/DB9t7ILYvvWmSWPF/n359MKKnZK
	 nnfSZ1ekzVBS7bvsQZdflIFyWQGBtgveZXvdvdfnpTXY0GzBgOfzXep1Eu41K6NwJc
	 Lth3/qtmvKQ8EmiaO5U9GmihL7nVPk/sh0cV6a0ybrWoKBs+UovwhVD3Xy0/x8IhCu
	 Qx6ojxz9LxVZOg5mive5DvswxgzGjk9OfKHGDHBwMsb/TLX4NwEeIShce4ldJzQDFT
	 WGTEAkMFcQDjzbWsh+2mVjRR7EIYO8WD2Z/SUe1Tr1ta5cHY2PnpbbtV73wUw5AHwg
	 YSVx5JUmIjMmQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 09/22] ksmbd: expire unacknowledged oplock breaks
Date: Sat, 17 Oct 2026 10:03:31 +0900
Message-Id: <20261017010344.11478-9-linkinjeon@kernel.org>
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

Arm the oplock break acknowledgment timer once the common notification
path accepts a classic break for transmission. Preserve its shared retry
deadline when another channel is tried. Store a deadline per open and scan
the global open table when the earliest deadline expires. Drop expired
breaks to NONE and restart the timer while other breaks remain.

Serialize timer expiry with client acknowledgments and close using the
oplock state lock. Wake blocked requests when a break expires or sending
the notification fails, and invalidate durable reconnect for the open.
Use wake_up_all() for acknowledgment, timeout, close and send failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c    | 30 ++++++++++++++--
 fs/smb/server/oplock.h    |  3 ++
 fs/smb/server/smb2pdu.c   |  6 ++--
 fs/smb/server/vfs_cache.c | 74 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 5 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 96b36b8329a6..352a9e2293b5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -551,9 +551,10 @@ void close_id_del_oplock(struct ksmbd_file *fp)
 	 * takes the same lock before it acquires pending_break or sets ACK_WAIT.
 	 */
 	opinfo->op_state = OPLOCK_CLOSING;
+	opinfo->oplock_timeout_set = false;
 	clear_bit_unlock(0, &opinfo->pending_break);
 	spin_unlock(&opinfo->state_lock);
-	wake_up_interruptible_all(&opinfo->oplock_q);
+	wake_up_all(&opinfo->oplock_q);
 	if (opinfo->is_lease)
 		wake_up_interruptible_all(&opinfo->oplock_brk);
 	/* memory barrier is needed for wake_up_bit() */
@@ -744,6 +745,8 @@ static bool oplock_break_set_ack_wait(struct oplock_info *opinfo)
 	spin_lock(&opinfo->state_lock);
 	if (opinfo->op_state != OPLOCK_CLOSING) {
 		opinfo->op_state = OPLOCK_ACK_WAIT;
+		opinfo->oplock_timeout_set = false;
+		opinfo->oplock_timed_out = false;
 		ret = true;
 	}
 	spin_unlock(&opinfo->state_lock);
@@ -816,6 +819,23 @@ static bool lease_break_needed(struct oplock_info *opinfo, int req_op_level,
 	return opinfo->level > req_op_level;
 }
 
+static void smb2_break_start_timer(struct oplock_info *opinfo,
+				   unsigned long timeout)
+{
+	bool start = false;
+
+	spin_lock(&opinfo->state_lock);
+	if (!opinfo->is_lease && opinfo->op_state == OPLOCK_ACK_WAIT &&
+	    !opinfo->oplock_timeout_set) {
+		opinfo->oplock_timeout = timeout;
+		opinfo->oplock_timeout_set = true;
+		start = true;
+	}
+	spin_unlock(&opinfo->state_lock);
+	if (start)
+		ksmbd_schedule_oplock_break_timer(timeout);
+}
+
 struct smb2_break_channel {
 	struct list_head list;
 	struct ksmbd_conn *conn;
@@ -853,8 +873,10 @@ static int smb2_break_failed(struct oplock_info *opinfo, bool expect_ack)
 	}
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 	opinfo->op_state = OPLOCK_STATE_NONE;
+	opinfo->oplock_timeout_set = false;
+	opinfo->oplock_timed_out = true;
 	spin_unlock(&opinfo->state_lock);
-	wake_up_interruptible_all(&opinfo->oplock_q);
+	wake_up_all(&opinfo->oplock_q);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	return ksmbd_invalidate_durable_fd(opinfo->fid);
 }
@@ -1169,6 +1191,8 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 			continue;
 		}
 		channel->queued = true;
+		if (expect_ack)
+			smb2_break_start_timer(opinfo, deadline);
 		if (interim_work) {
 			ksmbd_queue_io_work(interim_work);
 			interim_work = NULL;
@@ -1209,6 +1233,8 @@ static int smb2_break_notify(struct oplock_info *opinfo, struct ksmbd_inode *ci,
 failed:
 	ret = smb2_break_failed(opinfo, expect_ack);
 out:
+	if (expect_ack && READ_ONCE(opinfo->oplock_timed_out))
+		ret = ksmbd_invalidate_durable_fd(opinfo->fid);
 	ksmbd_free_work_struct(work);
 	list_for_each_entry_safe(channel, tmp, &channels, list) {
 		list_del(&channel->list);
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 5ef05166e502..03a5b93da2ec 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -67,6 +67,9 @@ struct oplock_info {
 	int                     level;
 	int                     op_state;
 	spinlock_t		state_lock;
+	unsigned long		oplock_timeout;
+	bool			oplock_timeout_set;
+	bool			oplock_timed_out;
 	unsigned long		pending_break;
 	u64			fid;
 	atomic_t		breaking_cnt;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cdc214363d19..77f3b9a5cdfc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12030,8 +12030,9 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 
 	opinfo->level = rsp_oplevel;
 	opinfo->op_state = OPLOCK_STATE_NONE;
+	opinfo->oplock_timeout_set = false;
 	spin_unlock(&opinfo->state_lock);
-	wake_up_interruptible_all(&opinfo->oplock_q);
+	wake_up_all(&opinfo->oplock_q);
 
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
@@ -12048,8 +12049,9 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 err_out:
 	if (opinfo->op_state != OPLOCK_CLOSING)
 		opinfo->op_state = OPLOCK_STATE_NONE;
+	opinfo->oplock_timeout_set = false;
 	spin_unlock(&opinfo->state_lock);
-	wake_up_interruptible_all(&opinfo->oplock_q);
+	wake_up_all(&opinfo->oplock_q);
 	rsp->hdr.Status = status;
 	smb2_set_err_rsp(work);
 out_no_state_change:
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index e5dbc8e41bfb..d63fed289c79 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -12,6 +12,7 @@
 #include <linux/freezer.h>
 #include <linux/dcache.h>
 #include <linux/hashtable.h>
+#include <linux/jiffies.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -36,6 +37,75 @@ static struct hlist_head *inode_hashtable __read_mostly;
 static DEFINE_RWLOCK(inode_hash_lock);
 
 static struct ksmbd_file_table global_ft;
+static DEFINE_MUTEX(oplock_break_timer_lock);
+static struct delayed_work oplock_break_timer_work;
+static unsigned long oplock_break_timer_next;
+static bool oplock_break_timer_pending;
+
+static void ksmbd_oplock_break_timer(struct work_struct *work)
+{
+	struct ksmbd_file *fp;
+	struct oplock_info *opinfo;
+	unsigned long next = 0, now;
+	unsigned int id;
+	bool pending = false;
+	bool expired;
+
+	mutex_lock(&oplock_break_timer_lock);
+	now = jiffies;
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		opinfo = opinfo_get(fp);
+		if (!opinfo)
+			continue;
+
+		expired = false;
+		spin_lock(&opinfo->state_lock);
+		if (!opinfo->is_lease &&
+		    opinfo->op_state == OPLOCK_ACK_WAIT &&
+		    opinfo->oplock_timeout_set) {
+			if (time_after_eq(now, opinfo->oplock_timeout)) {
+				/* ksmbd owns the oplock state for the local file. */
+				opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
+				opinfo->op_state = OPLOCK_STATE_NONE;
+				opinfo->oplock_timeout_set = false;
+				opinfo->oplock_timed_out = true;
+				expired = true;
+			} else if (!pending ||
+				   time_before(opinfo->oplock_timeout, next)) {
+				next = opinfo->oplock_timeout;
+				pending = true;
+			}
+		}
+		spin_unlock(&opinfo->state_lock);
+		if (expired)
+			wake_up_all(&opinfo->oplock_q);
+		opinfo_put(opinfo);
+	}
+	read_unlock(&global_ft.lock);
+
+	oplock_break_timer_pending = pending;
+	if (pending) {
+		oplock_break_timer_next = next;
+		mod_delayed_work(system_wq, &oplock_break_timer_work,
+				 time_after_eq(jiffies, next) ? 0 : next - jiffies);
+	}
+	mutex_unlock(&oplock_break_timer_lock);
+}
+
+void ksmbd_schedule_oplock_break_timer(unsigned long timeout)
+{
+	mutex_lock(&oplock_break_timer_lock);
+	if (!oplock_break_timer_pending ||
+	    time_before(timeout, oplock_break_timer_next)) {
+		oplock_break_timer_pending = true;
+		oplock_break_timer_next = timeout;
+		mod_delayed_work(system_wq, &oplock_break_timer_work,
+				 time_after_eq(jiffies, timeout) ? 0 : timeout - jiffies);
+	}
+	mutex_unlock(&oplock_break_timer_lock);
+}
+
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
 DECLARE_WAIT_QUEUE_HEAD(ksmbd_lock_wait);
@@ -1965,6 +2035,8 @@ void ksmbd_close_session_fds(struct ksmbd_work *work)
 
 int ksmbd_init_global_file_table(void)
 {
+	INIT_DELAYED_WORK(&oplock_break_timer_work, ksmbd_oplock_break_timer);
+	oplock_break_timer_pending = false;
 	if (create_proc_files())
 		pr_warn("Unable to create files procfs entry\n");
 	return ksmbd_init_file_table(&global_ft);
@@ -1975,6 +2047,8 @@ void ksmbd_free_global_file_table(void)
 	struct ksmbd_file	*fp = NULL;
 	unsigned int		id;
 
+	cancel_delayed_work_sync(&oplock_break_timer_work);
+
 	idr_for_each_entry(global_ft.idr, fp, id) {
 		ksmbd_remove_durable_fd(fp);
 		__ksmbd_close_fd(NULL, fp);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 6831aca22cff..9de41b6e28ba 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -242,6 +242,7 @@ void ksmbd_wake_session_blocked_works(struct ksmbd_session *sess);
 int ksmbd_close_inode_fds(struct ksmbd_work *work, struct inode *inode);
 int ksmbd_init_global_file_table(void);
 void ksmbd_free_global_file_table(void);
+void ksmbd_schedule_oplock_break_timer(unsigned long timeout);
 void ksmbd_set_fd_limit(unsigned long limit);
 int ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 			unsigned int state);
-- 
2.25.1

