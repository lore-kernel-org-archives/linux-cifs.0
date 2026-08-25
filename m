Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613753C276D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665923; cv=none; b=IEcIY6cLu8GzmiQ/S5fe7u9Xsl+3m9g5qeSsMYxF0ZdogbOqPUpo60s007iNPTAdC6TZwbVVhiXlAKImXKbJinIV1ByYtwA0jsTtCMQMAAqHqWnTyvQOBd0c/Q0f3fULBRo6SQYKS0tNVD73A7nmIvazS5KdKrs27bwXQrlcWyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665923; c=relaxed/simple;
	bh=kMShKaU6CCaa8mA5LEE6ai8cmpv6jaQWQdUgUbvs2SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtCZ/HlC7ycoEKxC2yBsBhpMUnLZ1MF1dB4kIJQJutoyVnDwCiT8WEpmXgYVISu2uwdsmu7FKyyG5qgMHQSeg30Xs4wrpT8TbtTqbBcdcf/is/875slW5kVf507f3rKSrb/phWx8rkXVLf3fy22TWvNzdFy40J85+O1aRRCWooY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RkEA20eU; arc=none smtp.client-ip=91.218.175.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RkEA20eU"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kMShKaU6CCaa8mA5LEE6ai8cmpv6jaQWQdUgUbvs2SM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665918; v=1; x=1788270718;
 b=RkEA20eUqfl/w/0j6IYaaiChtWlhQlnpWD0yuWgEBKnY19z0g+7BGMXBC4CUKTz7lcEAsm6l
 raieb456sC10skgpZUar6CbCpWI2HotY9abys9NtfSkSzIOAcShsEI8ktD1UEuGHU4TYspqLSta
 Vc9VUOaT4tY8wQPflUcHUwRZkF4eeCrM4LPU3nw9nnz24RgdZulcHRILm9sBu2XJYp0gibEYDb3
 O/D/WrOKLzBprduZHLnAGr/vieggVvzcnddKhcQYYSW0H24jJ3wqcNNyOn6HDzJ7oiCubD4wURp
 nu93vUjC2lMdp2JRkaa+5XAcToZKtxWrelhT0jySPlpxw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 04a407b0ccbcf930;
	Tue, 25 Aug 2026 13:51:58 +0000
X-Mizu-Trace-ID: 04a407b0ccbcf930
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Gael Blivet <gael.blivet@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 3/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Tue, 25 Aug 2026 13:51:08 +0000
Message-ID: <20260825135108.716663-4-chenxiaosong@chenxiaosong.com>
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
index f092c82d884b..8a18bba80d3d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11641,6 +11641,28 @@ int smb2_oplock_break(struct ksmbd_work *work)
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
@@ -11651,6 +11673,11 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
+	struct ksmbd_notify_req notify_req;
+	struct ksmbd_file *fp = NULL;
+	void **argv = NULL;
+	bool async_work = false;
+	int err = 0;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -11661,13 +11688,69 @@ int smb2_notify(struct ksmbd_work *work)
 
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
2.55.0

