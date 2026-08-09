Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DCB37FF66
	for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2026 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786292432; cv=none; b=k/JW97YhRwL3Tr0tpKl3FUQ8aSBX30rSmozW2tKp5LDjHT9tpzcidVuL8+wyr5ttpeuf8HJwhOdP8qOTRrRAd11W4N/h77DvDru0HswCvkZksmRdkl7plSyC4hFwEr0VTrW3hmTZUA7Y/Y3UW00Pn6xZwLNMvZGvKQnyrKFj7fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786292432; c=relaxed/simple;
	bh=x1aPdeHsJFTD0ObEZW7n/h+Lfo2o276u1iekq45VRuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tunj2b3oOk3NPym7x5mCEHPlKI+NWNNe/DBQgbJAd9UCjkrVAMaIMl17oRsV5uTqnQWXeKPDaMiUEvPrl3P2jbnkn1h5o9XoX6NUcLZXLZDmuB63/VFUoc9IFrBG4IhOAbUVuI+O5YuBq6KH8+rDIgg4oKWmI5zgoRwQhV2ry9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ZNSoVzjL; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ZNSoVzjL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786292428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kj8bjSBQjRCVr+aG/LdlXLSwJeBB4wTBmQOWXPfIZpg=;
	b=ZNSoVzjLaF3+9fa8WMDWSNXgEoOJdynyDv83VD5pn5r7jDJ8t7c7chgjFpNqRoLpkLfhf2
	olHEA2pM6Jx2lmd/gP0OIxoHBJF9lkoHg4W9uIeQjB+Rdq4Olo1cwM2OhnCGtLsAcaz+n2
	WTCiunpwbEPL7ghcnqV35dnj79APghKbBRvGJLyBgrL7AV3hiDeZFHLHUSOzvZxCqmMd9U
	yfuR29VsOgQe2u8yIXx6TNY2/1/KiNLIVPJ7O/PBoZa9+8euwVlQCQL5NNQMG8MgtsvZtY
	qi3dShGAU2J/Z9haPx9MKXoea5KEdo2ph87Bi6iJ1pnaYXsKegRHUFlblEcFWQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 3/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Sun,  9 Aug 2026 16:19:16 +0000
Message-ID: <20260809161916.1071530-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/smb2pdu.c    | 93 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

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
index 81a4dd232b6d..1e17fcd7d60a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10977,6 +10977,28 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	return 0;
 }
 
+struct ksmbd_notify_req {
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
+	struct ksmbd_notify_req *notify_req = argv[0];
+
+	wake_up(&notify_req->wait);
+}
+
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -10987,6 +11009,11 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
+	struct ksmbd_notify_req notify_req;
+	struct ksmbd_file *fp = NULL;
+	void **argv = NULL;
+	bool async_work = false;
+	int err = 0;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -10997,13 +11024,69 @@ int smb2_notify(struct ksmbd_work *work)
 
 	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
 		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
-		smb2_set_err_rsp(work);
-		return -EIO;
+		err = -EIO;
+		goto out;
 	}
 
-	smb2_set_err_rsp(work);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return -EOPNOTSUPP;
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	if (!fp) {
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		err = -ENOENT;
+		goto out;
+	}
+
+	argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
+	if (!argv) {
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		err = -ENOMEM;
+		goto out;
+	}
+	init_waitqueue_head(&notify_req.wait);
+	argv[0] = &notify_req;
+
+	err = setup_async_work(work, smb2_notify_cancel, argv);
+	if (err) {
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		goto out;
+	}
+	async_work = true;
+
+	spin_lock(&fp->f_lock);
+	list_add_tail(&work->fp_entry, &fp->blocked_works);
+	spin_unlock(&fp->f_lock);
+
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	err = wait_event_interruptible(notify_req.wait,
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
+	work->send_no_response = 1;
+
+out:
+	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
+		smb2_set_err_rsp(work);
+	if (async_work)
+		release_async_work(work);
+	else
+		kfree(argv);
+	if (fp)
+		ksmbd_fd_put(work, fp);
+	return err;
 }
 
 /**
-- 
2.54.0

