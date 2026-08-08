Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BA0165F1A
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 06:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786171388; cv=none; b=DMSL+nZLXa6gGMGriKnVti9wlF8piNSw03Yuyq2BX1kr0TKio6wayOlbTrohkB2KTNGzCb3VnHR9mBzh3PuVgSzQuWxYuQrJCbMbfnX6hQxC7w/gySOzeKv4hRZTSQIUIV76MGL01iajSPqgOawI9hIVYRRc2hM0vkBws9PJq64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786171388; c=relaxed/simple;
	bh=y0FUcJNRyqCHjtTJhdzS9IGjmzEF5On0IckoS+vOFMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPeYOUGNBRNMZXI7VmZ/FuWYw3aOT8KXDmaGcTTmlaMV4voE8bDfhYYyCSTJW3lSVH9R4g2vRILJ22cR+kZESMtTS4lpWwgiC2rCvvSjwZM72a5CQiG+rKxULjbL0p5wAhiYl2c36VN/Auu9XLkaa5LKQHoSZF7ALhECpXV1tqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=UwUqrLty; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="UwUqrLty"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786171383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWxj7sj/zf0VqnHra4N+uu7uIFW0IYrpXzBhZGzNIbw=;
	b=UwUqrLty8MwHBvOzFsKTaC43clnc2+wWO8EL9eQFQNuwDOlZm9kgbczMGxt6eCQafJPZX8
	98jf+nYMDkb88tkofmAMazNTr4xN7/LMrsQBrbEBxFvo43S9CZ75pAh6WVySwS3+s9ZJ+q
	hSP4KgzK23/XmBAiJ16MDVLicf0nNHtO8RSNLQFn1hKHt3G7+XFG/7mvHilRbrS8oztOx7
	yjRPAdGo5dg2ySQS3kYLefr2mXN+pAjlDk1W/7tsa13L/dS+mmvH0+B59zMDzU3yqGZFsT
	x9mMIVhT2NrXVaPBFg6Tl6+Zn6fjrEeFtUVJdvlHKYGbiByZJTR69ZCGBmSzGg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 3/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Sat,  8 Aug 2026 06:41:40 +0000
Message-ID: <20260808064145.1002261-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260808064145.1002261-1-chenxiaosong@chenxiaosong.com>
References: <20260808064145.1002261-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Gael Blivet <gael.blivet@gmail.com>

The previous design registered a synthetic work struct (in_work)
directly on conn->async_requests and deferred the response to a
workqueue -- a bespoke async/cancel implementation duplicating what
setup_async_work(), release_async_work(), and smb2_send_interim_resp()
already provide for smb2_lock()'s pending byte-range lock.

Replace it with that same pattern: setup_async_work() on the calling
work itself, registered on fp->blocked_works, woken by cancel or by
the handle closing via the existing set_close_state_blocked_works().
This removes the synthetic work struct, the notify_pendings list and
its close-time drain, and the deferred workqueue send, leaving
smb2_notify() sharing the same async/cancel machinery as smb2_lock()
instead of its own separate copy.

The worker now blocks on ksmbd_wq for as long as the watch stays
open, instead of returning immediately. This also makes the skeleton
ready for a future event-delivery implementation on the same
blocking wait.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/ksmbd_work.h |  1 +
 fs/smb/server/smb2pdu.c    | 83 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 0b55ad457cd3..4c0b7b2535b9 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -113,6 +113,7 @@ struct ksmbd_work {
 	struct list_head                request_entry;
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
+	/* List head at ksmbd_file->blocked_works */
 	struct list_head                fp_entry;
 };
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2150526bbc6e..7aac32a7fadb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10977,6 +10977,28 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	return 0;
 }
 
+struct ksmbd_notify_wait {
+	wait_queue_head_t wait;
+};
+
+/*
+ * Cancel handler for a pending CHANGE_NOTIFY. Called either by
+ * smb2_cancel() (conn->request_lock held, work->state already set to
+ * KSMBD_WORK_CANCELLED by the caller) or by
+ * set_close_state_blocked_works() (vfs_cache.c, fp->f_lock held,
+ * work->state already set to KSMBD_WORK_CLOSED by the caller) -- both
+ * callers hold a spinlock across this call, so it must not sleep.
+ * wake_up() only wakes the waiter in smb2_notify(); it does not touch
+ * fp->blocked_works itself, matching smb2_remove_blocked_lock()'s same
+ * non-mutating style for the equivalent byte-range-lock wait.
+ */
+static void smb2_notify_cancel(void **argv)
+{
+	struct ksmbd_notify_wait *notify_wait = (struct ksmbd_notify_wait *)argv[0];
+
+	wake_up(&notify_wait->wait);
+}
+
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -10987,6 +11009,10 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
+	struct ksmbd_notify_wait notify_wait;
+	struct ksmbd_file *fp;
+	void **argv;
+	int err;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -11001,9 +11027,60 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
 	}
 
-	smb2_set_err_rsp(work);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return -EOPNOTSUPP;
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	if (!fp) {
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
+	if (!argv) {
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+	init_waitqueue_head(&notify_wait.wait);
+	argv[0] = &notify_wait;
+
+	if (setup_async_work(work, smb2_notify_cancel, argv)) {
+		kfree(argv);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	spin_lock(&fp->f_lock);
+	list_add_tail(&work->fp_entry, &fp->blocked_works);
+	spin_unlock(&fp->f_lock);
+
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	err = wait_event_interruptible(notify_wait.wait,
+				       READ_ONCE(work->state) != KSMBD_WORK_ACTIVE);
+	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
+		/*
+		 * Woken by a signal, not a real cancel/close. There is no
+		 * notification backend yet to report anything else against,
+		 * so treat this the same as a client-side cancel.
+		 */
+		WRITE_ONCE(work->state, KSMBD_WORK_CANCELLED);
+	}
+
+	spin_lock(&fp->f_lock);
+	list_del_init(&work->fp_entry);
+	spin_unlock(&fp->f_lock);
+
+	rsp->hdr.Status = work->state == KSMBD_WORK_CLOSED ?
+			  STATUS_NOTIFY_CLEANUP : STATUS_CANCELLED;
+	smb2_send_interim_resp(work, rsp->hdr.Status);
+	release_async_work(work);
+	work->send_no_response = 1;
+
+	ksmbd_fd_put(work, fp);
+	return 0;
 }
 
 /**
-- 
2.54.0

