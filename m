Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E1F446075
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784905837; cv=none; b=kz8PyixcWgX5dxW63tiHgfqnCQ7pEN8/5NSsHq2xdwKwmZ+uSuUNsyp6hXEkQaKazlzHiGGak0eVGmDcbhe8wvMCuSRXHk+GTTZnuSTQLiN2S5mPC2K+4/mxMindahO+4rwG9+gUWHV+LVbgRmr/yl5chRMhzK5ekxRIMG2TQ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784905837; c=relaxed/simple;
	bh=w8TRmGifVMU0CBVHJXp93g2dZvSlQIK5NWmxwd+9VxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5GkQPTK9wMKKHeUG4HRhGdt2KXHgfPwVTXCguDOF7/KaVj6x3r/uDvVpxvtD9mBhpGuDgBZ89nA9qHsLo3Fd+Jq9P6vUYGZX0mgS+fsmwUs3HKoRnz1cWOowGFbj5j6af294QnNTShhcS3/ojGiXSiuNYrymJSPUz0jHdFhaF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyezGvqd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyezGvqd"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493f6de72faso4988365e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 08:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784905831; x=1785510631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wv6E4cgzGBymhaDj4q7QxJCtqYNoheX9C6zbx50dp84=;
        b=gyezGvqdfnKRS82awaQ2V7NdB2xDLCXkNTv7y3Kse2Kp2asdoP24JiTBLwyDtchTg0
         w0D+h/hg5fQyq3fbVeYY+sFTHE2TxM5rq1hEH5v2hmkNQaE4tF4cYkSwslDvWtVuQF3X
         XeNPExsfBSg9DXzflrUhI64WAtukXWJYfJZbuc8Wk9CjMexbGwmj3z5lORIUryjIIHgT
         PP2/OfWnzpUBThWp6YgTmOi+3sIJUgqoI5iTmzJ7jFZVIqoTDCceCkuH1AY5mk5J/RLU
         XvXw3LoezUyjlBa1YGTtMMPZqXydDOMTAA1TcwxlS8NXji5P2RdtAPHZH3GoIGOfFWqA
         mTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784905831; x=1785510631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wv6E4cgzGBymhaDj4q7QxJCtqYNoheX9C6zbx50dp84=;
        b=Fd9T2TSdxqe7Asf2cVkc9PRcQnWY3rMX9h+Np0yg0DJfx9RGUdI1/PdE1L8GiZ3xtS
         n2i+FWmhzc4n3+92Vrm++8hZPzNVe7IllmWKTPl1Gl6d0hlqwImapNctz43YYlXd47Cb
         BCjQ2J9c7AFsW3jMG8QEarTf68UdcxAzkHt6H4A/OW5wgLOkK14ERubzAEvNa0M5JRcx
         iXzI1GjV0WnVZiiqdplr4SwaQHMdr+HCG+tfx0guXN4AVZsp9qt+jZt/+49ycXo+4Fa0
         baUEKSK+lWgzVwDjU1umSKhTzBDPk/+UZHt5CARx/2SjwoNHnqSeuMyz0ZBDQWA/SQbY
         Ia7w==
X-Forwarded-Encrypted: i=1; AHgh+RoXP499LOU2TIhap+kIqAsTovyq99hUGb1DjoXtQRaYwIMbSyXDni+YvDXd90hyL4CXgGm2bYqiJCz3@vger.kernel.org
X-Gm-Message-State: AOJu0YyuUO/ErtbsY87vRCy2g5Ta9tVWKcrCmZvPXs9l4uusXlH4AXL0
	rAviQvfhqqLSHRlyQ/Hh2WU3iRSSM2nbGhhEEjGjp9626cX9S/Gm0Tp7
X-Gm-Gg: AR+sD11CJvZU3xTAjXE6yzhvbqdwXL1aQVG6sVNK13cWTbAKRG9H+ck0vV2t79+wfe4
	SPbZOt6D1el4jKqJE/h9jCl1fm22+3TAKbFtyU/E7RbneaIYgeKFvK1KAbVANX4oixV/Qe/FHhV
	ndIRrMGfuBfPJOr1NcUMrF6pcoro553E3YIYwU9tE09R/HxCL4x14tHxLRviAnfnAMevy0EMOSf
	c2sYnv947VCxGl2OP4/uSAstI1j7W+iY2v8u3qUu0qIaohrH6QOhVYYPBzcxgRCNcIjb6xPX8HD
	8IvkIiBWeH+dtTb3hXmt/iw4fcokpRg18ID1XXEyDpbwZPpvWJ6uHMLl6rgBvYQhvzrWRGmtrOu
	ic5I92abQpz79ZDpthQBsalwIpuui0Vb63h9M1Q+yKGSOz+NZ+CJzuDVuUC/9CODV9Jw/TefHCe
	AcQUF1iaUHVL7XZgMd5ugocs9+
X-Received: by 2002:a05:600c:1987:b0:493:b240:6a8b with SMTP id 5b1f17b1804b1-49690d6f406mr11168745e9.14.1784905830577;
        Fri, 24 Jul 2026 08:10:30 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bc62basm24915708f8f.13.2026.07.24.08.10.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Jul 2026 08:10:30 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: linkinjeon@kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org,
	chenxiaosong@kylinos.cn
Subject: [PATCH] ksmbd: refactor smb2_notify() to a blocking wait, matching smb2_lock()
Date: Fri, 24 Jul 2026 17:05:25 +0200
Message-ID: <20260724150528.1762-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

This refactors the design "ksmbd: defer CHANGE_NOTIFY completion
instead of STATUS_NOT_IMPLEMENTED" introduced. That patch hand-rolled
its own async registration, id lifecycle, and workqueue-deferred
response send around a synthetic work struct (in_work) that outlived
the calling worker, instead of reusing setup_async_work(),
release_async_work(), and smb2_send_interim_resp().

Replace it with the same blocking-wait pattern smb2_lock() already
uses for a pending byte-range lock: setup_async_work() on the calling
work directly, registered on fp->blocked_works, woken by cancel or by
the handle closing via the already-generic
set_close_state_blocked_works() (vfs_cache.c). This drops the
synthetic work struct, the separate notify_pendings list and its
close-time drain, and the deferred workqueue send. It also makes the
skeleton compatible with a planned real event-delivery implementation
built on the same blocking wait. The tradeoff: the worker now stays
blocked on ksmbd_wq for as long as the watch stays open, instead of
returning immediately. wait_event_interruptible() is used rather than
smb2_lock()'s plain wait_event(), since a watch can stay pending
indefinitely where a lock wait normally doesn't.

No real notify event source exists yet, so the wait ends only on a
cancel or a close (a signal is treated as a cancel); report
STATUS_CANCELLED or STATUS_NOTIFY_CLEANUP accordingly, same contract
as before.

Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
---
 fs/smb/server/ksmbd_work.c |   1 -
 fs/smb/server/ksmbd_work.h |   3 +-
 fs/smb/server/smb2pdu.c    | 262 +++++++++++--------------------------
 fs/smb/server/vfs_cache.c  |  53 ++------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 89 insertions(+), 236 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index f35335307..9cccccc40 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -57,7 +57,6 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 		INIT_LIST_HEAD(&work->request_entry);
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
-		INIT_LIST_HEAD(&work->notify_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
 		work->iov_alloc_cnt = ARRAY_SIZE(work->iov_inline);
 		work->iov = work->iov_inline;
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 52d0c4dee..12313ee85 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -114,9 +114,8 @@ struct ksmbd_work {
 	struct list_head                request_entry;
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
+	/* List head at ksmbd_file->blocked_works */
 	struct list_head                fp_entry;
-	/* List head at ksmbd_file->notify_pendings */
-	struct list_head                notify_entry;
 };
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2038de315..8ac074265 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10857,101 +10857,71 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	return 0;
 }
 
-/*
- * Cancel handler for a deferred CHANGE_NOTIFY. Races against
- * __ksmbd_close_fd()'s notify_pendings drain (vfs_cache.c), which can run
- * concurrently on a different connection closing the same handle -- only
- * one of the two may claim and free in_work, so both sides check
- * list_empty() under fp->f_lock before touching it (list_del_init()
- * leaves a node empty, so whichever side removes it first is the owner;
- * the loser must not touch in_work again, since the winner may already be
- * freeing it).
- *
- * smb2_cancel() holds conn->request_lock (a spinlock) for the entire
- * time it walks conn->async_requests and calls this function -- so this
- * runs with preemption disabled and must not sleep or re-acquire that
- * same lock. release_async_work() does both (it takes conn->request_lock
- * itself, and frees things that can involve sleeping paths), so calling
- * it from here would self-deadlock the very thread processing the
- * client's CANCEL command. ksmbd_conn_write() can also sleep (it takes
- * conn's write mutex). So: do only the non-sleeping, no-relock cleanup
- * inline here (the async_requests removal itself is safe without
- * re-locking, since the caller already holds that lock), and defer the
- * actual response send + work-struct free to a workqueue, matching the
- * minimal, non-blocking style of the existing smb2_remove_blocked_lock()
- * cancel_fn (which only wakes a waiter, never sends network data itself).
- */
-struct notify_cancel_ctx {
-	struct work_struct	work;
-	struct ksmbd_work	*in_work;
+struct ksmbd_notify_wait {
+	wait_queue_head_t wait;
 };
 
-static void smb2_notify_cancel_deferred(struct work_struct *w)
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
 {
-	struct notify_cancel_ctx *ctx =
-		container_of(w, struct notify_cancel_ctx, work);
-	struct ksmbd_work *in_work = ctx->in_work;
-	struct smb2_hdr *in_hdr;
+	struct ksmbd_notify_wait *notify_wait = (struct ksmbd_notify_wait *)argv[0];
 
-	in_hdr = smb_get_msg(in_work->response_buf);
-	in_hdr->Status = STATUS_CANCELLED;
-	ksmbd_conn_write(in_work);
-	ksmbd_free_work_struct(in_work);
-	kfree(ctx);
-}
-
-static void smb2_notify_cancel_fn(void **argv)
-{
-	struct ksmbd_work *in_work = (struct ksmbd_work *)argv[0];
-	struct ksmbd_file *fp = (struct ksmbd_file *)argv[1];
-	struct ksmbd_conn *conn = in_work->conn;
-	struct notify_cancel_ctx *ctx;
-	bool claimed;
-
-	spin_lock(&fp->f_lock);
-	claimed = !list_empty(&in_work->notify_entry);
-	if (claimed)
-		list_del_init(&in_work->notify_entry);
-	spin_unlock(&fp->f_lock);
-
-	if (!claimed)
-		return;
-
-	/* conn->request_lock is already held by the caller (smb2_cancel()). */
-	list_del_init(&in_work->async_request_entry);
-	in_work->asynchronous = false;
-	in_work->cancel_fn = NULL;
-	kfree(in_work->cancel_argv);
-	in_work->cancel_argv = NULL;
-	if (in_work->async_id) {
-		ksmbd_release_id(&conn->async_ida, in_work->async_id);
-		in_work->async_id = 0;
-	}
-
-	ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
-	if (!ctx) {
-		/* Can't defer the response -- free without sending one. */
-		ksmbd_free_work_struct(in_work);
-		return;
-	}
-	ctx->in_work = in_work;
-	INIT_WORK(&ctx->work, smb2_notify_cancel_deferred);
-	schedule_work(&ctx->work);
+	wake_up(&notify_wait->wait);
 }
 
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
  *
+ * KSMBD does not implement a real change-notification backend yet.
+ * Genuine SMB2 servers (and macOS smbfs) never complete a CHANGE_NOTIFY
+ * spontaneously: it is satisfied only by a real directory change, or
+ * with STATUS_NOTIFY_CLEANUP when the watched handle is closed.
+ * Completing it early (e.g. on a timer) makes Finder treat the cleanup
+ * as "directory changed" and re-enumerate the directory forever,
+ * leaving items unopenable. Returning STATUS_NOT_IMPLEMENTED here (like
+ * stock ksmbd) makes macOS smbfs hard-freeze on unmount, so this must
+ * stay deferred.
+ *
+ * The calling worker registers on fp->blocked_works and blocks on a
+ * local wait queue, the same pattern smb2_lock() uses for a pending
+ * byte-range lock (setup_async_work() on work directly, no separate
+ * synthetic work struct), until woken by smb2_notify_cancel() -- either
+ * from an explicit client CANCEL or from the handle closing
+ * (set_close_state_blocked_works() already covers both generically over
+ * fp->blocked_works, no changes needed there). This is deliberately a
+ * blocking design, unlike the deferred/workqueue design this replaces:
+ * the worker stays unavailable to ksmbd_wq for as long as the watch
+ * stays open. Accepted for now to keep the skeleton compatible with a
+ * planned real event-delivery patch built on the same blocking wait;
+ * revisit if this proves to exhaust the worker pool in practice.
+ *
+ * Also uses wait_event_interruptible() rather than smb2_lock()'s plain
+ * wait_event(): a byte-range lock wait is only ever woken by an
+ * explicit, targeted signal (lock availability or cancel), but a
+ * CHANGE_NOTIFY watch can stay pending indefinitely, so allowing the
+ * wait to be interrupted matters more here.
+ *
  * Return:      0 on success, otherwise error
  */
 int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
-	struct ksmbd_work *in_work;
-	struct smb2_hdr *in_hdr;
+	struct ksmbd_notify_wait notify_wait;
 	struct ksmbd_file *fp;
+	void **argv;
+	int err;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -10969,54 +10939,26 @@ int smb2_notify(struct ksmbd_work *work)
 	/*
 	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
 	 * sentinel) to watch for changes on the share root without holding an
-	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
-	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
+	 * open handle. There is no fp to block on for this case, so report the
+	 * watch as already cleaned up immediately instead of joining the wait
+	 * below; without this, backupd aborts Time Machine setup on
+	 * STATUS_FILE_CLOSED.
 	 */
 	if (req->VolatileFileId == SMB2_NO_FID &&
 	    req->PersistentFileId == SMB2_NO_FID) {
-		in_work = ksmbd_alloc_work_struct();
-		if (!in_work || allocate_interim_rsp_buf(in_work)) {
-			if (in_work)
-				ksmbd_free_work_struct(in_work);
-			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-			smb2_set_err_rsp(work);
-			return 0;
-		}
 		if (setup_async_work(work, NULL, NULL)) {
-			ksmbd_free_work_struct(in_work);
 			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			smb2_set_err_rsp(work);
 			return 0;
 		}
 		smb2_send_interim_resp(work, STATUS_PENDING);
-		in_work->conn = work->conn;
-		in_hdr = smb_get_msg(in_work->response_buf);
-		memcpy(in_hdr, ksmbd_resp_buf_next(work),
-		       __SMB2_HEADER_STRUCTURE_SIZE);
-		in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-		in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
-		smb2_set_err_rsp(in_work);
-		in_hdr->Status = STATUS_NOTIFY_CLEANUP;
-		in_work->async_id = work->async_id;
-		work->async_id = 0;
+		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
+		smb2_send_interim_resp(work, STATUS_NOTIFY_CLEANUP);
 		release_async_work(work);
-		ksmbd_conn_write(in_work);
-		ksmbd_free_work_struct(in_work);
 		work->send_no_response = 1;
 		return 0;
 	}
 
-	/*
-	 * KSMBD does not implement a real change-notification backend.
-	 * Genuine SMB2 servers (and macOS smbfs) never complete a
-	 * CHANGE_NOTIFY spontaneously: it is satisfied only by a real
-	 * directory change, or with STATUS_NOTIFY_CLEANUP when the watched
-	 * handle is closed. Completing it early (e.g. on a timer) makes
-	 * Finder treat the cleanup as "directory changed" and re-enumerate
-	 * the directory forever, leaving items unopenable. Returning
-	 * STATUS_NOT_IMPLEMENTED here (like stock ksmbd) makes macOS smbfs
-	 * hard-freeze on unmount, so this must stay deferred.
-	 */
 	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
 	if (!fp) {
 		rsp->hdr.Status = STATUS_FILE_CLOSED;
@@ -11024,96 +10966,52 @@ int smb2_notify(struct ksmbd_work *work)
 		return 0;
 	}
 
-	in_work = ksmbd_alloc_work_struct();
-	if (!in_work || allocate_interim_rsp_buf(in_work)) {
-		if (in_work)
-			ksmbd_free_work_struct(in_work);
-		ksmbd_fd_put(work, fp);
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-		smb2_set_err_rsp(work);
-		return 0;
-	}
-	/*
-	 * in_work is synthetic (not from the normal request-receiving
-	 * pipeline), so it has no request_buf of its own. It gets registered
-	 * into conn->async_requests below, and smb2_cancel() unconditionally
-	 * computes smb_get_msg(iter->request_buf) for every entry in that
-	 * list while searching for a match -- give it its own small buffer
-	 * (not an alias of response_buf: ksmbd_free_work_struct() kvfree()s
-	 * both separately, so aliasing them would double-free) so that stays
-	 * a harmless read instead of a near-NULL dereference.
-	 */
-	in_work->request_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, KSMBD_DEFAULT_GFP);
-	if (!in_work->request_buf) {
-		ksmbd_free_work_struct(in_work);
+	argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
+	if (!argv) {
 		ksmbd_fd_put(work, fp);
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 		smb2_set_err_rsp(work);
 		return 0;
 	}
+	init_waitqueue_head(&notify_wait.wait);
+	argv[0] = &notify_wait;
 
-	if (setup_async_work(work, NULL, NULL)) {
-		ksmbd_free_work_struct(in_work);
+	if (setup_async_work(work, smb2_notify_cancel, argv)) {
+		kfree(argv);
 		ksmbd_fd_put(work, fp);
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 		smb2_set_err_rsp(work);
 		return 0;
 	}
 
-	smb2_send_interim_resp(work, STATUS_PENDING);
-
-	/* Keep the async IDA alive until the deferred work is released. */
-	in_work->conn = ksmbd_conn_get(work->conn);
-	in_work->owns_conn_ref = true;
-	in_hdr = smb_get_msg(in_work->response_buf);
-	memcpy(in_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
-	in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-	in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
-	smb2_set_err_rsp(in_work);
-	in_hdr->Status = STATUS_NOTIFY_CLEANUP;
+	spin_lock(&fp->f_lock);
+	list_add_tail(&work->fp_entry, &fp->blocked_works);
+	spin_unlock(&fp->f_lock);
 
-	/*
-	 * Transfer ownership of the async id to in_work; it stays reserved
-	 * until in_work is freed after the deferred response is sent on
-	 * close, so it can't be reused for an unrelated async response.
-	 */
-	in_work->async_id = work->async_id;
-	work->async_id = 0;
-	release_async_work(work);
+	smb2_send_interim_resp(work, STATUS_PENDING);
 
-	/*
-	 * work itself is about to be recycled by the normal request-processing
-	 * pipeline, so it can't stay the target of a future CANCEL -- register
-	 * in_work instead, reusing the same async_id, so a client-sent CANCEL
-	 * for this notify actually finds something to cancel instead of
-	 * silently doing nothing until the handle eventually closes.
-	 */
-	in_work->asynchronous = true;
-	in_work->cancel_argv = kmalloc_array(2, sizeof(void *), KSMBD_DEFAULT_GFP);
-	if (in_work->cancel_argv) {
-		in_work->cancel_argv[0] = in_work;
-		in_work->cancel_argv[1] = fp;
-		in_work->cancel_fn = smb2_notify_cancel_fn;
-	}
-
-	if (!ksmbd_conn_link_async_request(work->conn, in_work)) {
-		kfree(in_work->cancel_argv);
-		in_work->cancel_argv = NULL;
-		in_work->cancel_fn = NULL;
-		in_work->asynchronous = false;
-		ksmbd_fd_put(work, fp);
-		ksmbd_conn_write(in_work);
-		ksmbd_free_work_struct(in_work);
-		work->send_no_response = 1;
-		return 0;
+	err = wait_event_interruptible(notify_wait.wait,
+				       READ_ONCE(work->state) != KSMBD_WORK_ACTIVE);
+	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
+		/*
+		 * Woken by a signal, not a real cancel/close. There is no
+		 * notification backend yet to report anything else against,
+		 * so treat this the same as a client-side cancel.
+		 */
+		WRITE_ONCE(work->state, KSMBD_WORK_CANCELLED);
 	}
 
 	spin_lock(&fp->f_lock);
-	list_add_tail(&in_work->notify_entry, &fp->notify_pendings);
+	list_del_init(&work->fp_entry);
 	spin_unlock(&fp->f_lock);
 
-	ksmbd_fd_put(work, fp);
+	rsp->hdr.Status = work->state == KSMBD_WORK_CLOSED ?
+			  STATUS_NOTIFY_CLEANUP : STATUS_CANCELLED;
+	smb2_send_interim_resp(work, rsp->hdr.Status);
+	release_async_work(work);
 	work->send_no_response = 1;
+
+	ksmbd_fd_put(work, fp);
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c28e3d65d..2e1096ae0 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -616,7 +616,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
-	struct ksmbd_work *cn_work;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -650,50 +649,15 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	}
 
 	/*
-	 * Complete any CHANGE_NOTIFY left pending on this handle now that
-	 * it is closed. KSMBD never completes CHANGE_NOTIFY spontaneously
-	 * (no real change-notification backend), only on close -- matching
-	 * genuine SMB2/macOS smbfs semantics and avoiding the Finder
-	 * "directory changed, re-enumerate everything" loop.
-	 *
-	 * smb2_notify() on another connection can be adding to
-	 * notify_pendings under fp->f_lock at the same time this handle is
-	 * closed, and a client-sent CANCEL can concurrently be racing to
-	 * claim the same entry via smb2_notify_cancel_fn() (smb2pdu.c).
-	 * Pop one entry at a time under the lock via list_del_init() rather
-	 * than a bulk list_splice_init(): list_del_init() leaves the node
-	 * self-linked ("empty"), which is what the cancel path checks under
-	 * the same lock to tell whether it lost the race -- a bulk splice
-	 * would instead relink every entry into a shared local list, so an
-	 * entry claimed here would still read as "not empty" to a racing
-	 * cancel_fn, and both sides could end up freeing the same work.
-	 * ksmbd_conn_write() can sleep (it takes conn's write mutex), so it
-	 * must not be called while fp->f_lock is held -- release the lock
-	 * before processing each popped entry, then reacquire it for the
-	 * next.
+	 * Any CHANGE_NOTIFY blocked on this handle is woken by
+	 * set_close_state_blocked_works() (via ksmbd_close_fd()/
+	 * ksmbd_mark_fp_closed(), both called before __ksmbd_close_fd() is
+	 * ever reached), the same generic fp->blocked_works mechanism
+	 * smb2_lock() uses for a pending byte-range lock -- nothing further
+	 * to do here. The waiter holds its own reference on fp (from
+	 * ksmbd_lookup_fd_slow()) until it finishes handling the wake and
+	 * calls ksmbd_fd_put(), so fp can't be freed out from under it.
 	 */
-	for (;;) {
-		spin_lock(&fp->f_lock);
-		if (list_empty(&fp->notify_pendings)) {
-			spin_unlock(&fp->f_lock);
-			break;
-		}
-		cn_work = list_first_entry(&fp->notify_pendings,
-					   struct ksmbd_work, notify_entry);
-		list_del_init(&cn_work->notify_entry);
-		spin_unlock(&fp->f_lock);
-
-		ksmbd_conn_write(cn_work);
-		/*
-		 * release_async_work() removes cn_work from
-		 * conn->async_requests, frees cancel_argv, and releases+zeroes
-		 * async_id -- all needed before ksmbd_free_work_struct(), which
-		 * only releases async_id itself if still nonzero (i.e. if this
-		 * hadn't already been done).
-		 */
-		release_async_work(cn_work);
-		ksmbd_free_work_struct(cn_work);
-	}
 
 	/*
 	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
@@ -1221,7 +1185,6 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->blocked_works);
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
-	INIT_LIST_HEAD(&fp->notify_pendings);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5fac4b0b4..11bfbb981 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -157,12 +157,6 @@ struct ksmbd_file {
 	unsigned int			outstanding_requests;
 	unsigned int			outstanding_pre_requests;
 	struct ksmbd_lock_sequence	lock_seq[KSMBD_LOCK_SEQ_ARRAY_SIZE];
-
-	/*
-	 * Pending CHANGE_NOTIFY completions for this handle, sent with
-	 * STATUS_NOTIFY_CLEANUP when the handle is closed.
-	 */
-	struct list_head		notify_pendings;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,

base-commit: e3ebfe6d5045a2365caae7f8cb988b1d087bbbef
-- 
2.43.0

