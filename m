Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32E437996C
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 06:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786171386; cv=none; b=pnvYDJXrDh9Dy8Z8rsBLEjCev0pfpUnRs6PnW+fmHctlmvXrXH0VpAZQ3SopCp7A7/UMf4XwAeRHlKh7pF6efvsvAJFmuf3DPDBVRkVUBA8l2G/pYSKl/Wh02gH2WtAtFxZWm8t4qEucN6j+NdlRmKqFUPVnc2KTJRYBoJdCzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786171386; c=relaxed/simple;
	bh=nz0xDEX7iK2M0JnxzKV4vzWn261VgJEnqf1vi/D8mn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTv96dtInRHuYMuovGBprUM5+Zebo2KhO80rAEqXSMbbw9wJc3s5LIk76ZL5T5Knlv0Fhg79DArFQQ94SQgfti5RA3DeSgvmYqNHyAlOj0vxPtQUtjc2cfLHWGE7gKcM5StZh2bVVMJQDddstc1MlNZwaSYxcsbT0leaTO0EW0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=W9SCg8dg; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="W9SCg8dg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786171380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZLgI9XE7aDT8sB/G9FYaRvroW0FnYT5Rggp4Yy6pbI=;
	b=W9SCg8dgTAlY9d+huyzT6+q0djM2lpzzKSCj4khjPz31OQeGa1RNHrSi0ywESangKTED9V
	+l86uMCJ5UcfB/iV5K70fqkg1VIVJLzj9/wf7yfKSNi6DLlIXuNoXlitjcIUctqTcqjyzV
	TUX5pLI8iwie9gjxr3dFkL5n/T8Tj4J2OsUBPcSqmcjPM41+kwBUPlN0INROhb5KRksWJ/
	QDmrZBK/gelyqqHRtshWAbTdrAvATTLQXOB0FRov4HPBvBTTlwD2+bM8coUkWfbEUwmBdY
	z+I8vq3BWpIcZAfp0cwZC/lAJhCkq5W7dBMyyV7E+JBAIPP90O3Fn2CP2UX2CQ==
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
Subject: [PATCH v3 2/3] ksmbd: temporarily remove interim-work change notify handling
Date: Sat,  8 Aug 2026 06:41:39 +0000
Message-ID: <20260808064145.1002261-3-chenxiaosong@chenxiaosong.com>
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

Prepare for the next patch. Split the removal of the old implementation
into this separate patch to make the next patch easier to review.

The current change notify path keeps a synthetic ksmbd_work, named
`in_work`, after the original request has returned. It also needs a
per-file notify_pendings list and special close, cancel, and connection
lifetime handling to complete and free that work.

Next patch replaces this design with a blocking wait in smb2_notify().

This patch reverts the following patches (or parts of them):

- Revert part of "ksmbd: expire SMB sessions when Kerberos tickets expire"
- Revert "ksmbd: retain connection for pending notify work"
- Revert part of "smb/server: avoid registering async requests during connection close"
- Revert "ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED"

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   4 -
 fs/smb/server/smb2pdu.c    | 258 +------------------------------------
 fs/smb/server/vfs_cache.c  |  48 -------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 4 insertions(+), 315 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index f35335307670..097de59f807c 100644
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
index 5f1d3ebab4fb..0b55ad457cd3 100644
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
 	bool				session_setup_reauth:1;
@@ -116,8 +114,6 @@ struct ksmbd_work {
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
 	struct list_head                fp_entry;
-	/* List head at ksmbd_file->notify_pendings */
-	struct list_head                notify_entry;
 };
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f729ee102a5b..2150526bbc6e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -56,10 +56,6 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 	}
 }
 
-static struct ksmbd_work *smb2_notify_cancel_claim(void **argv);
-static void smb2_notify_cancel_fn(void **argv);
-static void smb2_complete_notify_cancel(struct ksmbd_work *in_work);
-
 #define WORK_BUFFERS(w, rq, rs)	__wbuf((w), (void **)&(rq), (void **)&(rs))
 
 #define SMB2_CREATE_FILE_ATTRIBUTE_MASK \
@@ -8995,7 +8991,6 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
 	struct ksmbd_work *iter;
-	struct ksmbd_work *cancelled_notify = NULL;
 	struct list_head *command_list;
 
 	if (work->next_smb2_rcv_hdr_off)
@@ -9033,23 +9028,11 @@ int smb2_cancel(struct ksmbd_work *work)
 				    le64_to_cpu(hdr->Id.AsyncId),
 				    le16_to_cpu(chdr->Command));
 			iter->state = KSMBD_WORK_CANCELLED;
-			if (iter->cancel_fn == smb2_notify_cancel_fn)
-				cancelled_notify =
-					smb2_notify_cancel_claim(iter->cancel_argv);
-			else if (iter->cancel_fn)
+			if (iter->cancel_fn)
 				iter->cancel_fn(iter->cancel_argv);
 			break;
 		}
 		spin_unlock(&conn->request_lock);
-
-		/*
-		 * Complete a cancelled notify before this CANCEL handler returns.
-		 * Deferring it to the system workqueue lets a following request and
-		 * its response overtake STATUS_CANCELLED, leaving clients waiting
-		 * for the original notify even though the cancellation was accepted.
-		 */
-		if (cancelled_notify)
-			smb2_complete_notify_cancel(cancelled_notify);
 	} else {
 		command_list = &conn->requests;
 
@@ -10994,127 +10977,6 @@ int smb2_oplock_break(struct ksmbd_work *work)
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
- * inline here. smb2_cancel() sends and frees the claimed notify after it
- * drops request_lock, preserving response order for a client CANCEL. The
- * connection teardown caller has no such post-unlock path, so its wrapper
- * defers the send and free to a workqueue.
- */
-struct notify_cancel_ctx {
-	struct work_struct	work;
-	struct ksmbd_work	*in_work;
-};
-
-static void smb2_send_notify_cancelled(struct ksmbd_work *work)
-{
-	struct smb2_hdr *hdr = smb_get_msg(work->response_buf);
-	struct ksmbd_conn *conn = work->conn;
-	struct ksmbd_session *sess;
-
-	sess = ksmbd_session_lookup(conn, le64_to_cpu(hdr->SessionId));
-	if (sess) {
-		work->sess = sess;
-		if (work->encrypted && sess->enc && conn->ops->encrypt_resp) {
-			conn->ops->encrypt_resp(work);
-		} else if (conn->ops->is_sign_req && conn->ops->set_sign_rsp &&
-			   conn->ops->is_sign_req(work,
-						 conn->ops->get_cmd_val(work))) {
-			conn->ops->set_sign_rsp(work);
-		}
-	}
-
-	ksmbd_conn_write(work);
-	if (sess) {
-		ksmbd_user_session_put(sess);
-		work->sess = NULL;
-	}
-}
-
-static void smb2_notify_cancel_deferred(struct work_struct *w)
-{
-	struct notify_cancel_ctx *ctx =
-		container_of(w, struct notify_cancel_ctx, work);
-
-	smb2_complete_notify_cancel(ctx->in_work);
-	kfree(ctx);
-}
-
-static struct ksmbd_work *smb2_notify_cancel_claim(void **argv)
-{
-	struct ksmbd_work *in_work = (struct ksmbd_work *)argv[0];
-	struct ksmbd_file *fp = (struct ksmbd_file *)argv[1];
-	bool claimed;
-
-	spin_lock(&fp->f_lock);
-	claimed = !list_empty(&in_work->notify_entry);
-	if (claimed)
-		list_del_init(&in_work->notify_entry);
-	spin_unlock(&fp->f_lock);
-
-	if (!claimed)
-		return NULL;
-
-	/* conn->request_lock is held by smb2_cancel() or connection teardown. */
-	in_work->cancel_fn = NULL;
-	kfree(in_work->cancel_argv);
-	in_work->cancel_argv = NULL;
-	return in_work;
-}
-
-static void smb2_complete_notify_cancel(struct ksmbd_work *in_work)
-{
-	struct smb2_hdr *in_hdr = smb_get_msg(in_work->response_buf);
-
-	in_hdr->Status = STATUS_CANCELLED;
-	smb2_send_notify_cancelled(in_work);
-	release_async_work(in_work);
-	ksmbd_free_work_struct(in_work);
-}
-
-static void smb2_notify_cancel_fn(void **argv)
-{
-	struct ksmbd_work *in_work = smb2_notify_cancel_claim(argv);
-	struct ksmbd_conn *conn;
-	struct notify_cancel_ctx *ctx;
-
-	if (!in_work)
-		return;
-	conn = in_work->conn;
-
-	ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
-	if (!ctx) {
-		/* Can't defer the response -- free without sending one. */
-		list_del_init(&in_work->async_request_entry);
-		in_work->asynchronous = false;
-		if (in_work->async_id) {
-			ksmbd_release_id(&conn->async_ida, in_work->async_id);
-			in_work->async_id = 0;
-		}
-		ksmbd_free_work_struct(in_work);
-		return;
-	}
-	ctx->in_work = in_work;
-	INIT_WORK(&ctx->work, smb2_notify_cancel_deferred);
-	schedule_work(&ctx->work);
-}
-
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -11125,9 +10987,6 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
-	struct ksmbd_work *in_work;
-	struct smb2_hdr *in_hdr;
-	struct ksmbd_file *fp;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -11142,118 +11001,9 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
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
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
-	if (!fp) {
-		rsp->hdr.Status = STATUS_FILE_CLOSED;
-		smb2_set_err_rsp(work);
-		return 0;
-	}
-
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
-		ksmbd_fd_put(work, fp);
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-		smb2_set_err_rsp(work);
-		return 0;
-	}
-	memcpy(smb_get_msg(in_work->request_buf), req,
-	       __SMB2_HEADER_STRUCTURE_SIZE);
-
-	if (setup_async_work(work, NULL, NULL)) {
-		ksmbd_free_work_struct(in_work);
-		ksmbd_fd_put(work, fp);
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-		smb2_set_err_rsp(work);
-		return 0;
-	}
-
-	smb2_send_interim_resp(work, STATUS_PENDING);
-
-	/* Keep the async IDA alive until the deferred work is released. */
-	in_work->conn = ksmbd_conn_get(work->conn);
-	in_work->owns_conn_ref = true;
-	in_work->encrypted = work->encrypted;
-	in_hdr = smb_get_msg(in_work->response_buf);
-	memcpy(in_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
-	in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-	in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
-	smb2_set_err_rsp(in_work);
-	in_hdr->Status = STATUS_NOTIFY_CLEANUP;
-
-	/*
-	 * Transfer ownership of the async id to in_work; it stays reserved
-	 * until in_work is freed after the deferred response is sent on
-	 * close, so it can't be reused for an unrelated async response.
-	 */
-	in_work->async_id = work->async_id;
-	work->async_id = 0;
-	release_async_work(work);
-
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
-	}
-
-	spin_lock(&fp->f_lock);
-	list_add_tail(&in_work->notify_entry, &fp->notify_pendings);
-	spin_unlock(&fp->f_lock);
-
-	ksmbd_fd_put(work, fp);
-	work->send_no_response = 1;
-	return 0;
+	smb2_set_err_rsp(work);
+	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
+	return -EOPNOTSUPP;
 }
 
 /**
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 90348a409162..0cb96c6543f0 100644
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
@@ -1251,7 +1204,6 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->blocked_works);
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
-	INIT_LIST_HEAD(&fp->notify_pendings);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5cac022b540b..7c5a874adecc 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -158,12 +158,6 @@ struct ksmbd_file {
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
-- 
2.54.0

