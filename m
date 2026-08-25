Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F863C276D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665918; cv=none; b=R0LwwbIcByuTxYjWV3Y2Bi1834e0aJ6Y4dANQjP6LaDcK02JzNqbEkibhQkoC6/J99zoudSJUhjDiwB+Ugq+iaWjxYPTxeFNbLBZGAmPW7eC7O1kXmdnby0e53K0VHmR3DInPioNSv28pLjVGwnhE6BD8tZ1UhThhsr3iaMcq84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665918; c=relaxed/simple;
	bh=yGneJ+kJ1vhTfhoZ8QzZRHUZA1zDyxZpoflXF4w98Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js9iL2erGuw20C/L8puAYNNFNtyLvsxX3qm7j+zAm49kzQ8xUI9u++sZg+NysC0iQeolJ0We64WUwjWrW2TiCUtjdOB8aphnRhgsCm0TY3ozdCyxCd0QO0sRf1JCTwlHmnBCm2ey+SmrqQcANXamfR3w+OnI1Cgty07E3J0SyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=HejNSeYs; arc=none smtp.client-ip=95.215.58.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="HejNSeYs"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yGneJ+kJ1vhTfhoZ8QzZRHUZA1zDyxZpoflXF4w98Jo=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665912; v=1; x=1788270712;
 b=HejNSeYsy7XC5l/mBuAJPZP9es/tJwnU/GENakfL6oh28n0R5y7Yk96+0XQgmhdhVOiHNBg5
 lQTkHIKE3HATkRdzTNbc7cv28kDAU96Q3ixANCreypJ1pUI7pNJau5caBNv9Zh/dVVrQ1QIvPPJ
 xTbz7i6TuvjHFl0k+cDeAcyf0L2S+dhgqopxRovxfjcQY1IruoMXt5/0Rn+GV7mqPjgv/Tao+ou
 /yys8Tu856A6/xARBqOS/o+PySSXM6iuJTfvjyvQ0WX1eN5ZrhoGQ4YJl8JxR73VR1tWD3M6SLs
 IjIbPy0CogSLIWwgUexasD/DPqf7ijZNCgnkSmg8UwfCg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 3ccd2d2bbfdfc102;
	Tue, 25 Aug 2026 13:51:52 +0000
X-Mizu-Trace-ID: 3ccd2d2bbfdfc102
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Gael Blivet <gael.blivet@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 2/3] ksmbd: temporarily remove interim-work change notify handling
Date: Tue, 25 Aug 2026 13:51:07 +0000
Message-ID: <20260825135108.716663-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
References: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Prepare for the next patch. Split the removal of the old implementation
into this separate patch to make the next patch easier to review.

The current change notify path keeps a synthetic ksmbd_work, named
`in_work`, after the original request has returned. It also needs a
per-file notify_pendings list and special close, cancel, and connection
lifetime handling to complete and free that work.

Next patch replaces this design with a blocking wait in smb2_notify().

This patch reverts the following patches (or parts of them):

- Revert part of 2a0e037648da ("ksmbd: encrypt interim responses to encrypted requests")
- Revert 4818df5aaac0 ("ksmbd: wait for deferred notify cancellation")
- Revert part of a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets expire")
- Revert f495154703cb ("ksmbd: retain connection for pending notify work")
- Revert part of 528af7cf69f3 ("smb/server: avoid registering async requests during connection close")
- Revert 152036e875e8 ("ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED")

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   4 -
 fs/smb/server/smb2pdu.c    | 271 +------------------------------------
 fs/smb/server/vfs_cache.c  |  48 -------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 4 insertions(+), 328 deletions(-)

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
index 86f93f81cdfd..f092c82d884b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -58,10 +58,6 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 	}
 }
 
-static struct ksmbd_work *smb2_notify_cancel_claim(void **argv);
-static void smb2_notify_cancel_fn(void **argv);
-static void smb2_complete_notify_cancel(struct ksmbd_work *in_work);
-
 #define WORK_BUFFERS(w, rq, rs)	__wbuf((w), (void **)&(rq), (void **)&(rs))
 
 #define SMB2_CREATE_FILE_ATTRIBUTE_MASK \
@@ -9652,7 +9648,6 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
 	struct ksmbd_work *iter;
-	struct ksmbd_work *cancelled_notify = NULL;
 	struct list_head *command_list;
 
 	if (work->next_smb2_rcv_hdr_off)
@@ -9690,23 +9685,11 @@ int smb2_cancel(struct ksmbd_work *work)
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
 
@@ -11658,139 +11641,6 @@ int smb2_oplock_break(struct ksmbd_work *work)
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
-	struct ksmbd_conn *conn = ctx->in_work->conn;
-
-	smb2_complete_notify_cancel(ctx->in_work);
-	kfree(ctx);
-	/*
-	 * The connection teardown waits for r_count before destroying
-	 * connection sessions and their proc entries.
-	 */
-	ksmbd_conn_r_count_dec(conn);
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
-	/*
-	 * This deferred work can outlive the connection handler's receive loop.
-	 * Keep teardown from destroying the connection's sessions until the
-	 * deferred response has finished using them.
-	 */
-	ksmbd_conn_r_count_inc(conn);
-	schedule_work(&ctx->work);
-}
-
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -11801,9 +11651,6 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
-	struct ksmbd_work *in_work;
-	struct smb2_hdr *in_hdr;
-	struct ksmbd_file *fp;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -11818,119 +11665,9 @@ int smb2_notify(struct ksmbd_work *work)
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
-		if (smb2_send_interim_work(in_work, work, false))
-			ksmbd_debug(SMB, "failed to send notify cleanup\n");
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
index 81626d204249..9157a5531308 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -617,7 +617,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
-	struct ksmbd_work *cn_work;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -652,52 +651,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
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
@@ -1253,7 +1206,6 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->blocked_works);
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
-	INIT_LIST_HEAD(&fp->notify_pendings);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 502efb16f05f..e86e3cbe3bf2 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -162,12 +162,6 @@ struct ksmbd_file {
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
2.55.0

