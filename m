Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B830E3C7685
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 10:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784975271; cv=none; b=h9i8KmytKwwJnSF4Kl8qPk9genokLJ9pW62b7MatTISuZHDzSmPl6g/DRfbb3OZis2SEjgXUQoUsswHJKO3WQ3eV/0ZzJ0fu7DQMY0UoXMrX7HEjTxvLd6sLI37Pk7wx52/CfMuw7n6c0Yy8A5GjmmSVNN27XGBicjU0a2pGkj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784975271; c=relaxed/simple;
	bh=uB6Uzh+LIS8Ed3Czw6gRnouNPCapZ5GlbtjlUzqyCZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vC01++dfeoGPT3vU+AeQPsGJkA9++LYsiFylIbBCIvZyYq5GdJSwaNJaFQz9KndRYOb8vn/tOhZ6z9CEPpdwuJMNSBclxcm+Fk01KeNxfhzgpj6Fz5H5sQSbD5gw0Ym1oGX1sWSae276Wo8fQveJ7oqhkSU2FEoLNznh25J9jxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oNe+Xgwd; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNe+Xgwd"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f707e5d75so804763f8f.1
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 03:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784975261; x=1785580061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I0rJoBxYOESXF7MT+lVsD+1w2uZfvmxUU9MLcI4M/mw=;
        b=oNe+XgwdHM4TRj99aUa3fFdl8RhIKC4D2Qm6DTUAM3f9G98OL4uJIr1kqcW6aLBKlp
         VKwpIm3yNIGGLKtOcNTAz3swjpx7DDON9MFG08DlR5SD6uqByeZRQzd8PXoLchMDdJmO
         1dxIQ92l9ITw+Z7PGSQj1KpA0FgrcIpCIt22sq6aX9OdQ+qtMfEoYoZOUlitrfDQPSWJ
         90wpSkyWLT/IwUtN2dy/fagx7AtwB7qourlUMvlXPjcxv0swU5rbGPAzphUUQqDMaTZi
         xUl5ggfD1MPjHhkFWpvijB3PqJgc9F0qQ2NMHJq0pJFXG1qTtt5k1BwnqYJ+uXKdKTM3
         Jhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784975261; x=1785580061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I0rJoBxYOESXF7MT+lVsD+1w2uZfvmxUU9MLcI4M/mw=;
        b=Fp8/OPC1lF5mJwa9XoLdtOnNV4fMu9tDkgacxnicchBiktk5AxV0vYoa6l7QTjI9ha
         1ruQEwNGhLY6TyDq1VmiloAmb5xYXyio0v5zdfn/kgrmVWoL1To8p65o5TnSZESArt5Z
         mY3H/NlI9kFu7IjxRxJ+lKgJBw8zJZKl5N2DOG0082dE9qZ6jNoye8l5yQXU5Gnu2j+t
         Y/w0J/ylCS5uh2svX5IVlMH3VzLkTZFuy+OdbwjHTwgePRJ/fqoK3znieKV/VIQW1YG2
         2dQB1/BJznFghDx5dYnHl+wVFEKNL9+sDtMu7el0jXFYg9LYu60I5/YwDG1ZIeVNqgPk
         h/Bg==
X-Forwarded-Encrypted: i=1; AHgh+RpecAH8XfyKx5KtGoczUb9YagHz8nUjswV0oGcUz5gMKJ7C/90/LDVEroXXmqDaexTEttYg5P/TtbZl@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpk9HRqCVgBpG0ftYbAsX2VC+sW/tMehg9ep5LMgLoD4CktVn6
	zf5MIfWhi2Cfrc1ZsXue8/dQs4MgvMMHRHoXOkL+IGJKmQyvXuweZG3z
X-Gm-Gg: AR+sD10xjSkFQIcflBjKCnIktUobea4AHomfvJIxFEXeGjW/GzDQGCyAbzH95jgZ+gO
	URj66xrFV/DBs642ebX7vIVS/bVnWz5BPppY13gHxZ83Qc1QOiDfxwSyf7DVStQTddeq/nYFfxa
	jhcoMdHjp13vZxXqASuzgnj5MAyzeAOhmGvRj1h/au7J6m3LR4lFIHXhFHmcP8CugN0EDe1Ay/4
	WIWF6XVnGn8HJE4KIPzqtNI0+NPCxEyoCKF0DXNN1QPGJ5oPEwxR56qJ3BCEWeEG0RL+gKLMw4d
	22N0rq2oOY5Tpp4TkWOxG+sbo0j9CkJ4DR6CdQWMIC/dSd5T+vTBv2Sbrg6lk4oz0uC9I0NzhrS
	SzMiOHus1b+AAj0s02GxmwrR8qlTmxOI2hwUMsGESQm2Vo2g3nXqSbiYu1VSqeWOUJJn6H1SvpV
	nyBFHByg1+aqIf38MCsMEcRTKXKzR949X7QRU=
X-Received: by 2002:a05:6000:1ac5:b0:47f:91f0:9a8 with SMTP id ffacd0b85a97d-47f9fc90311mr2251262f8f.23.1784975260539;
        Sat, 25 Jul 2026 03:27:40 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a596sm30978293f8f.4.2026.07.25.03.27.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 03:27:39 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: linkinjeon@kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org,
	chenxiaosong@kylinos.cn
Subject: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait, matching smb2_lock()
Date: Sat, 25 Jul 2026 12:26:44 +0200
Message-ID: <20260725102737.33616-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
v1 -> v2:
- Shortened the smb2_notify() kerneldoc to @work/Return only.
- FileId sentinel path: use smb2_set_err_rsp() + STATUS_INVALID_PARAMETER
  instead of STATUS_PENDING/STATUS_NOTIFY_CLEANUP.
- Removed dead owns_conn_ref field from struct ksmbd_work.
- Removed the CHANGE_NOTIFY-wake comment in __ksmbd_close_fd().

 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   5 +-
 fs/smb/server/smb2pdu.c    | 242 ++++++++-----------------------------
 fs/smb/server/vfs_cache.c  |  48 --------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 51 insertions(+), 253 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index f35335307..097de59f8 100644
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
@@ -87,8 +86,6 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
-	if (work->owns_conn_ref)
-		ksmbd_conn_put(work->conn);
 	ksmbd_fd_put(work, work->request_open);
 	kmem_cache_free(work_cache, work);
 }
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 52d0c4dee..9723f3cc9 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -91,8 +91,6 @@ struct ksmbd_work {
 	bool                            compress_response:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
 	bool                            asynchronous:1;
-	/* Work owns a reference to @conn. */
-	bool				owns_conn_ref:1;
 	bool                            need_invalidate_rkey:1;
 	bool				request_open_chseq_tracked:1;
 
@@ -114,9 +112,8 @@ struct ksmbd_work {
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
index 2038de315..8e5dfb079 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10857,86 +10857,26 @@ int smb2_oplock_break(struct ksmbd_work *work)
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
-{
-	struct notify_cancel_ctx *ctx =
-		container_of(w, struct notify_cancel_ctx, work);
-	struct ksmbd_work *in_work = ctx->in_work;
-	struct smb2_hdr *in_hdr;
-
-	in_hdr = smb_get_msg(in_work->response_buf);
-	in_hdr->Status = STATUS_CANCELLED;
-	ksmbd_conn_write(in_work);
-	ksmbd_free_work_struct(in_work);
-	kfree(ctx);
-}
-
-static void smb2_notify_cancel_fn(void **argv)
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
+	struct ksmbd_notify_wait *notify_wait = (struct ksmbd_notify_wait *)argv[0];
 
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
@@ -10949,9 +10889,10 @@ int smb2_notify(struct ksmbd_work *work)
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
 
@@ -10967,56 +10908,17 @@ int smb2_notify(struct ksmbd_work *work)
 	}
 
 	/*
-	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
-	 * sentinel) to watch for changes on the share root without holding an
-	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
-	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
+	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF
+	 * (share-root sentinel) to watch for changes on the share root
+	 * without holding an open handle.
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
-		if (setup_async_work(work, NULL, NULL)) {
-			ksmbd_free_work_struct(in_work);
-			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-			smb2_set_err_rsp(work);
-			return 0;
-		}
-		smb2_send_interim_resp(work, STATUS_PENDING);
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
-		release_async_work(work);
-		ksmbd_conn_write(in_work);
-		ksmbd_free_work_struct(in_work);
-		work->send_no_response = 1;
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		smb2_set_err_rsp(work);
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
@@ -11024,96 +10926,52 @@ int smb2_notify(struct ksmbd_work *work)
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
index c28e3d65d..f11f322fe 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -616,7 +616,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
-	struct ksmbd_work *cn_work;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -649,52 +648,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		kfree(smb_lock);
 	}
 
-	/*
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
-	 */
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
-
 	/*
 	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
 	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
@@ -1221,7 +1174,6 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
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

