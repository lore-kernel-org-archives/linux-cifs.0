Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184BEEC0
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555625; cv=none; b=F/3kHaONRhUnhRje8yOlN+nF/rNdVlfQSDQWAL1QmDQS71kQfVktZBOQy3TRB/ylzuPAOfoFVIbW1EPBrbFGZMvdW3aCnCsgu5plCkj/DSAKEqw5e/2l6WqvGATNg70J9U4V3ExSvKyg1IsSBSp73CKojc2WDNrwK/f9A4mUjVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555625; c=relaxed/simple;
	bh=wXyf6t78VtFm15ls1H4HkTYQ7JE0r6MoLzBfGlY41G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB1Q18NVsjCEpQiO6nsCNxpT+6m4RJGl0GwWiFkRaEsl6CFrzlqa+dPBKDfKDVHKdmTg7e63qPEY6cOtnUg89eu53dutgBV0KV2wHJitvU/Goxn/NFJP0sVlqLeyrYSsZBq48QBSNkzvwdJ/QTAHXGn38A18PTjW8V1iJ/wwEHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xc8K2aLq; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xc8K2aLq"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b6f1b14bso5437015e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555622; x=1784160422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qzRmKe6GvN/v0ZyS0CUNUuiVQOaktV+HqgSNypSkw+s=;
        b=Xc8K2aLqF18ZWM2/0c/EjsULsI6u4tpohdpJ+lYP7CnQAOE4WMYm4kFN0Djgf//QGX
         h9qAW9PLhfO/bpu3iWX5fForqyl4oGKgF93aoutLEsXYerFCsL5sjgP5uDD+E4iO9+R3
         M0FftXQHu1RQNowB9iQD4iXCzOTHVZHnasQ4cCWqe046YpM3v7GVsqbgSf7EpNgq2Mgd
         LEHDij0Z8FjbODjLsSLgV2oE6MF08W/jgQ8GOw5xBxdtuV7H9tpAqW86wATllH7Okbik
         EzWDmU24/ueqHTS2jAW8UGL7ASGGL8bs6Rs84nbyiXfgGnrXn0hdjo4ri6FHF1vl7Bh9
         FInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555622; x=1784160422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qzRmKe6GvN/v0ZyS0CUNUuiVQOaktV+HqgSNypSkw+s=;
        b=NtNZ1geEW6HnvLOYI4mwn0Erk61TcessT8gBWxtwjnOeGDIDh3bi8dKU6SUuAEPYBU
         GYiWk0bTdBLE6dN7jVa6px0uDEbbYq90DiH9zauJk5I3R0POwOqZ/Un48oabeIMRDQIg
         sTGf2MV1tBepEVNT+nfBuSLhwDi9Lz9zLqhyGpxv6jnD0oJjNdux9yCLfHHbuhA/ZLby
         7sPFrPG4X0lnfQ8uY4SmEfkXcDGFwxIgVJj8B1AGdSCaprC4YW5A6ArySgmUIIMr6OSi
         ujxJsTkpVcs9WtTXa3tlyuEgSY9fRkKLYKcaG/33kNIftBQyf9/xS/Gz87VaEmvQknJ0
         0uOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnFhMxT6MQG7hO6aANXEwVbOKEsc5vYFI9O0WLv7Czl+XPPsDEB9Tbmg+3R3Jw7Ev1nc/QKO0vcQzO@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/iQnQ2Yur5qTRc55/mqCfrD38k9pY0HlSObKFVF457Z/CLhg5
	+mtrF1YHsoedey9DK+M7Ew4PHj38smX1FVhiiXCVgQFI07kJE/OrrceA
X-Gm-Gg: AfdE7clvhj3zeI0/lcBZgzWxuEUStZtHGETlooZBAdC0balgwcetD0ZZmHYEY5qZfdx
	9Rd4y0AEWU+MslbfKGmuZ1wsOVXA3jlTJrLc5Q/+Tp6UfQl5tFPw1Qkypd+xzCfq82QRGly3dEw
	sHQFgio0AdljmZKiC6UJjj4y1a9QetkFVENvaFz+875XmAJbFJQXQ8INBntEJneKiawfHE5gx84
	z8bCO+ws8a+UDsT3+2J2Me4tC1eggoHpUUc1enyx7x1vsg9dydRuYJhkVsXtyWYIloKvErdmJWM
	NjOMJMT5xWPQch04qGrpgxPVu3wqBHsadIqGBeSN5LY27d1WUzcAn+zsws1if6BoiqRcH+BYIoK
	/+MvG5iTlmER2pbjFML97H0+f64oJPnF7Ngtt5XJ/Cb6pqpsdbbCCQKkCNHt/F7m4Egb+G0To9P
	EWrCcYIRdZMxe8eW1924JjG8kPJFknLrQ5FX4=
X-Received: by 2002:a05:600c:3516:b0:492:3e66:6c84 with SMTP id 5b1f17b1804b1-493e68782cdmr47690405e9.30.1783555622096;
        Wed, 08 Jul 2026 17:07:02 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.07.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:07:01 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED
Date: Thu,  9 Jul 2026 02:06:10 +0200
Message-ID: <20260709000618.66534-5-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000618.66534-1-g.blivet@me.com>
References: <20260709000618.66534-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_notify() currently returns STATUS_NOT_IMPLEMENTED synchronously
for every CHANGE_NOTIFY request. Genuine SMB2 servers never complete a
CHANGE_NOTIFY spontaneously -- it's satisfied only by a real directory
change or with STATUS_NOTIFY_CLEANUP when the watched handle is
closed. macOS smbfs.kext depends on this deferred-completion contract:
receiving STATUS_NOT_IMPLEMENTED instead makes it hard-freeze on
unmount, since it never sees the cleanup it's waiting for.

Add a notify_pendings list on struct ksmbd_file (protected by the
existing f_lock) and a notify_entry list_head on struct ksmbd_work to
link onto it. smb2_notify() now replies STATUS_PENDING immediately and
queues a deferred STATUS_NOTIFY_CLEANUP response on the watched
handle; __ksmbd_close_fd() drains and sends any pending notifications
when the handle is actually closed. The drain splices the list out
under fp->f_lock first, then processes the detached copy without the
lock -- smb2_notify() on another connection can be adding to the same
list at the same time a close happens on this one, and
ksmbd_conn_write() can sleep (it takes the connection's write mutex),
so it must not be called while the spinlock is held.

Also handle the FileId=FFFF...FFFF share-root sentinel that macOS
backupd sends to watch for changes without holding an open handle --
without an immediate STATUS_PENDING/STATUS_NOTIFY_CLEANUP reply here,
backupd aborts Time Machine setup with STATUS_FILE_CLOSED.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Addressed the CANCEL deadlock concern raised in review:
smb2_notify_cancel_fn() now does only lock-protected list/state
manipulation inline under conn->request_lock (matching every other
cancel_fn in this file), deferring the one sleeping operation
(sending STATUS_CANCELLED via ksmbd_conn_write()) to a workqueue.
The close-time drain in __ksmbd_inode_close() changed to match: it
pops one entry at a time via list_del_init() under fp->f_lock rather
than a bulk list_splice_init(), so a racing cancel_fn can tell if it
lost the race the same way, and both sides can never free the same
ksmbd_work.

 fs/smb/server/ksmbd_work.c |   1 +
 fs/smb/server/ksmbd_work.h |   2 +
 fs/smb/server/smb2pdu.c    | 226 ++++++++++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.c  |  48 ++++++++
 fs/smb/server/vfs_cache.h  |   6 +
 5 files changed, 280 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index e2c2f4526..97502273a 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -56,6 +56,7 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 		INIT_LIST_HEAD(&work->request_entry);
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
+		INIT_LIST_HEAD(&work->notify_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
 		work->iov_alloc_cnt = ARRAY_SIZE(work->iov_inline);
 		work->iov = work->iov_inline;
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 88104f0cf..50c4aa779 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -104,6 +104,8 @@ struct ksmbd_work {
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
 	struct list_head                fp_entry;
+	/* List head at ksmbd_file->notify_pendings */
+	struct list_head                notify_entry;
 };
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 120c2c80d..ed5b132b8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10070,6 +10070,88 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	return 0;
 }
 
+/*
+ * Cancel handler for a deferred CHANGE_NOTIFY. Races against
+ * __ksmbd_close_fd()'s notify_pendings drain (vfs_cache.c), which can run
+ * concurrently on a different connection closing the same handle -- only
+ * one of the two may claim and free in_work, so both sides check
+ * list_empty() under fp->f_lock before touching it (list_del_init()
+ * leaves a node empty, so whichever side removes it first is the owner;
+ * the loser must not touch in_work again, since the winner may already be
+ * freeing it).
+ *
+ * smb2_cancel() holds conn->request_lock (a spinlock) for the entire
+ * time it walks conn->async_requests and calls this function -- so this
+ * runs with preemption disabled and must not sleep or re-acquire that
+ * same lock. release_async_work() does both (it takes conn->request_lock
+ * itself, and frees things that can involve sleeping paths), so calling
+ * it from here would self-deadlock the very thread processing the
+ * client's CANCEL command. ksmbd_conn_write() can also sleep (it takes
+ * conn's write mutex). So: do only the non-sleeping, no-relock cleanup
+ * inline here (the async_requests removal itself is safe without
+ * re-locking, since the caller already holds that lock), and defer the
+ * actual response send + work-struct free to a workqueue, matching the
+ * minimal, non-blocking style of the existing smb2_remove_blocked_lock()
+ * cancel_fn (which only wakes a waiter, never sends network data itself).
+ */
+struct notify_cancel_ctx {
+	struct work_struct	work;
+	struct ksmbd_work	*in_work;
+};
+
+static void smb2_notify_cancel_deferred(struct work_struct *w)
+{
+	struct notify_cancel_ctx *ctx =
+		container_of(w, struct notify_cancel_ctx, work);
+	struct ksmbd_work *in_work = ctx->in_work;
+	struct smb2_hdr *in_hdr;
+
+	in_hdr = smb_get_msg(in_work->response_buf);
+	in_hdr->Status = STATUS_CANCELLED;
+	ksmbd_conn_write(in_work);
+	ksmbd_free_work_struct(in_work);
+	kfree(ctx);
+}
+
+static void smb2_notify_cancel_fn(void **argv)
+{
+	struct ksmbd_work *in_work = (struct ksmbd_work *)argv[0];
+	struct ksmbd_file *fp = (struct ksmbd_file *)argv[1];
+	struct ksmbd_conn *conn = in_work->conn;
+	struct notify_cancel_ctx *ctx;
+	bool claimed;
+
+	spin_lock(&fp->f_lock);
+	claimed = !list_empty(&in_work->notify_entry);
+	if (claimed)
+		list_del_init(&in_work->notify_entry);
+	spin_unlock(&fp->f_lock);
+
+	if (!claimed)
+		return;
+
+	/* conn->request_lock is already held by the caller (smb2_cancel()). */
+	list_del_init(&in_work->async_request_entry);
+	in_work->asynchronous = false;
+	in_work->cancel_fn = NULL;
+	kfree(in_work->cancel_argv);
+	in_work->cancel_argv = NULL;
+	if (in_work->async_id) {
+		ksmbd_release_id(&conn->async_ida, in_work->async_id);
+		in_work->async_id = 0;
+	}
+
+	ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
+	if (!ctx) {
+		/* Can't defer the response -- free without sending one. */
+		ksmbd_free_work_struct(in_work);
+		return;
+	}
+	ctx->in_work = in_work;
+	INIT_WORK(&ctx->work, smb2_notify_cancel_deferred);
+	schedule_work(&ctx->work);
+}
+
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -10080,6 +10162,9 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
+	struct ksmbd_work *in_work;
+	struct smb2_hdr *in_hdr;
+	struct ksmbd_file *fp;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -10094,9 +10179,144 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
 	}
 
-	smb2_set_err_rsp(work);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return -EOPNOTSUPP;
+	/*
+	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
+	 * sentinel) to watch for changes on the share root without holding an
+	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
+	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
+	 */
+	if (req->VolatileFileId == SMB2_NO_FID &&
+	    req->PersistentFileId == SMB2_NO_FID) {
+		in_work = ksmbd_alloc_work_struct();
+		if (!in_work || allocate_interim_rsp_buf(in_work)) {
+			if (in_work)
+				ksmbd_free_work_struct(in_work);
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+			smb2_set_err_rsp(work);
+			return 0;
+		}
+		if (setup_async_work(work, NULL, NULL)) {
+			ksmbd_free_work_struct(in_work);
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+			smb2_set_err_rsp(work);
+			return 0;
+		}
+		smb2_send_interim_resp(work, STATUS_PENDING);
+		in_work->conn = work->conn;
+		in_hdr = smb_get_msg(in_work->response_buf);
+		memcpy(in_hdr, ksmbd_resp_buf_next(work),
+		       __SMB2_HEADER_STRUCTURE_SIZE);
+		in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+		in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
+		smb2_set_err_rsp(in_work);
+		in_hdr->Status = STATUS_NOTIFY_CLEANUP;
+		in_work->async_id = work->async_id;
+		work->async_id = 0;
+		release_async_work(work);
+		ksmbd_conn_write(in_work);
+		ksmbd_free_work_struct(in_work);
+		work->send_no_response = 1;
+		return 0;
+	}
+
+	/*
+	 * KSMBD does not implement a real change-notification backend.
+	 * Genuine SMB2 servers (and macOS smbfs) never complete a
+	 * CHANGE_NOTIFY spontaneously: it is satisfied only by a real
+	 * directory change, or with STATUS_NOTIFY_CLEANUP when the watched
+	 * handle is closed. Completing it early (e.g. on a timer) makes
+	 * Finder treat the cleanup as "directory changed" and re-enumerate
+	 * the directory forever, leaving items unopenable. Returning
+	 * STATUS_NOT_IMPLEMENTED here (like stock ksmbd) makes macOS smbfs
+	 * hard-freeze on unmount, so this must stay deferred.
+	 */
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	if (!fp) {
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	in_work = ksmbd_alloc_work_struct();
+	if (!in_work || allocate_interim_rsp_buf(in_work)) {
+		if (in_work)
+			ksmbd_free_work_struct(in_work);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+	/*
+	 * in_work is synthetic (not from the normal request-receiving
+	 * pipeline), so it has no request_buf of its own. It gets registered
+	 * into conn->async_requests below, and smb2_cancel() unconditionally
+	 * computes smb_get_msg(iter->request_buf) for every entry in that
+	 * list while searching for a match -- give it its own small buffer
+	 * (not an alias of response_buf: ksmbd_free_work_struct() kvfree()s
+	 * both separately, so aliasing them would double-free) so that stays
+	 * a harmless read instead of a near-NULL dereference.
+	 */
+	in_work->request_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, KSMBD_DEFAULT_GFP);
+	if (!in_work->request_buf) {
+		ksmbd_free_work_struct(in_work);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	if (setup_async_work(work, NULL, NULL)) {
+		ksmbd_free_work_struct(in_work);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	in_work->conn = work->conn;
+	in_hdr = smb_get_msg(in_work->response_buf);
+	memcpy(in_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
+	in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+	in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
+	smb2_set_err_rsp(in_work);
+	in_hdr->Status = STATUS_NOTIFY_CLEANUP;
+
+	/*
+	 * Transfer ownership of the async id to in_work; it stays reserved
+	 * until in_work is freed after the deferred response is sent on
+	 * close, so it can't be reused for an unrelated async response.
+	 */
+	in_work->async_id = work->async_id;
+	work->async_id = 0;
+	release_async_work(work);
+
+	/*
+	 * work itself is about to be recycled by the normal request-processing
+	 * pipeline, so it can't stay the target of a future CANCEL -- register
+	 * in_work instead, reusing the same async_id, so a client-sent CANCEL
+	 * for this notify actually finds something to cancel instead of
+	 * silently doing nothing until the handle eventually closes.
+	 */
+	in_work->asynchronous = true;
+	in_work->cancel_argv = kmalloc_array(2, sizeof(void *), KSMBD_DEFAULT_GFP);
+	if (in_work->cancel_argv) {
+		in_work->cancel_argv[0] = in_work;
+		in_work->cancel_argv[1] = fp;
+		in_work->cancel_fn = smb2_notify_cancel_fn;
+	}
+	spin_lock(&work->conn->request_lock);
+	list_add_tail(&in_work->async_request_entry, &work->conn->async_requests);
+	spin_unlock(&work->conn->request_lock);
+
+	spin_lock(&fp->f_lock);
+	list_add_tail(&in_work->notify_entry, &fp->notify_pendings);
+	spin_unlock(&fp->f_lock);
+
+	ksmbd_fd_put(work, fp);
+	work->send_no_response = 1;
+	return 0;
 }
 
 /**
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 2543dd7e8..89a43ca18 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -529,6 +529,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
+	struct ksmbd_work *cn_work;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -561,6 +562,52 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		kfree(smb_lock);
 	}
 
+	/*
+	 * Complete any CHANGE_NOTIFY left pending on this handle now that
+	 * it is closed. KSMBD never completes CHANGE_NOTIFY spontaneously
+	 * (no real change-notification backend), only on close -- matching
+	 * genuine SMB2/macOS smbfs semantics and avoiding the Finder
+	 * "directory changed, re-enumerate everything" loop.
+	 *
+	 * smb2_notify() on another connection can be adding to
+	 * notify_pendings under fp->f_lock at the same time this handle is
+	 * closed, and a client-sent CANCEL can concurrently be racing to
+	 * claim the same entry via smb2_notify_cancel_fn() (smb2pdu.c).
+	 * Pop one entry at a time under the lock via list_del_init() rather
+	 * than a bulk list_splice_init(): list_del_init() leaves the node
+	 * self-linked ("empty"), which is what the cancel path checks under
+	 * the same lock to tell whether it lost the race -- a bulk splice
+	 * would instead relink every entry into a shared local list, so an
+	 * entry claimed here would still read as "not empty" to a racing
+	 * cancel_fn, and both sides could end up freeing the same work.
+	 * ksmbd_conn_write() can sleep (it takes conn's write mutex), so it
+	 * must not be called while fp->f_lock is held -- release the lock
+	 * before processing each popped entry, then reacquire it for the
+	 * next.
+	 */
+	for (;;) {
+		spin_lock(&fp->f_lock);
+		if (list_empty(&fp->notify_pendings)) {
+			spin_unlock(&fp->f_lock);
+			break;
+		}
+		cn_work = list_first_entry(&fp->notify_pendings,
+					   struct ksmbd_work, notify_entry);
+		list_del_init(&cn_work->notify_entry);
+		spin_unlock(&fp->f_lock);
+
+		ksmbd_conn_write(cn_work);
+		/*
+		 * release_async_work() removes cn_work from
+		 * conn->async_requests, frees cancel_argv, and releases+zeroes
+		 * async_id -- all needed before ksmbd_free_work_struct(), which
+		 * only releases async_id itself if still nonzero (i.e. if this
+		 * hadn't already been done).
+		 */
+		release_async_work(cn_work);
+		ksmbd_free_work_struct(cn_work);
+	}
+
 	/*
 	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
 	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
@@ -1080,6 +1127,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->blocked_works);
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
+	INIT_LIST_HEAD(&fp->notify_pendings);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 111a4e315..2d722c43c 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -135,6 +135,12 @@ struct ksmbd_file {
 
 	bool                            is_posix_ctxt;
 	struct durable_owner		owner;
+
+	/*
+	 * Pending CHANGE_NOTIFY completions for this handle, sent with
+	 * STATUS_NOTIFY_CLEANUP when the handle is closed.
+	 */
+	struct list_head		notify_pendings;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
-- 
2.43.0

