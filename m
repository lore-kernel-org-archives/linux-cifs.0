Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6BD21773D
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776716; cv=none; b=RqeVLitAOPN7L+S633gzB0BqO10ZA8+u28sob+uxOZKMo+6xKsoT02LU5ID8ldoHQmwO3V4e88CNeq9KVnr2J4B9TkBRm5rAcyYmnyc60KfXBT+6iRUcgwQMCWZsOgmpPPEuBKecaHc7K8wclT41rlxpP/LYzGhzyWJqK+xwNK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776716; c=relaxed/simple;
	bh=qsJjwV1s3m8eZFmVGTQPUy17ejPI3QTN8wdRrgEIbL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXc+N+50nIyr+oUV42STHuxHfzg/3wHMOZW+yJb6KOEU09FLKqLiPPHzyVLwgPXyWgVZdezoRhKye8QEvFRnlh/GzzfhSYNX3nuVbEtV/YKN/XqQ2iwn6W981Yp/TpHtSJkiJKmlgHx3i+HgF3TL6GrBRjTw1AtPZTliZNqhnMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qWWMZPJC; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qWWMZPJC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y0uBqJ/+gpQ3CNHeeR4/9FY5B58+eg6VdTnpOynMunk=;
	b=qWWMZPJC2GJ+gHIy4+kVlFwi9nFBhDBj59OLT5AHLeM9yhHemfLKveX8tqJ4sI5ypQYbSq
	iVQgCltx48/mQaRaKcFUnwnWe12sf9C0f5Vxglmg2kHFkNtixcqVCHjS6ow2W/KvHXNgHG
	sni6nUvbCFUJtZ0fYy+zmNxieuavhrcEjrz2fyGl9koXfqc1wTZUbtJbssXcDc4c1c0io0
	TX9UtgZnMdxW9AifdpnWJI27BsWTX1wy8pnmAgadqUIjT4oHE2A7A5w4EKISQ0u+5p6NTy
	QAwKVlHDtc0a4tXyDJDWxNSHow8U4vly429Pgh23oixgTnYOtUBqqmwkfFkHUg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 10/11] smb/server: send notify events to the client
Date: Thu, 23 Jul 2026 03:16:38 +0000
Message-ID: <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Wake one pending request and send its saved events in the reply.

Example:

  smbinfo notify /mnt

  # server: touch /export/file1
  Notifications received, returned data_len is 48
  Action: 0x00000001, FileName: file1
  Action: 0x00000003, FileName: file1

  # server: mv /export/file1 /export/file2
  Notifications received, returned data_len is 48
  Action: 0x00000004, FileName: file1
  Action: 0x00000005, FileName: file2

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 171 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 6fff7b5584b9..63e7ed7d615c 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -53,12 +53,18 @@ struct ksmbd_notify {
 	u32 moved_from_mask;
 	u32 moved_from_cookie;
 	struct delayed_work moved_from_work;
+	struct delayed_work broadcast_work;
 };
 
 struct ksmbd_notify_req {
 	wait_queue_head_t wait;
+	struct list_head events;
+	unsigned int num_events;
+	bool notified;
 };
 
+#define KSMBD_NOTIFY_BROADCAST_MSECS	1000
+#define KSMBD_NOTIFY_BROADCAST_MAX_EVENTS	100
 #define KSMBD_NOTIFY_MOVED_FROM_MSECS	100
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
@@ -163,13 +169,28 @@ static void
 ksmbd_notify_queue_event(struct ksmbd_notify *notify,
 			 struct ksmbd_notify_event *event)
 {
+	unsigned long broadcast_delay = 0;
+	bool schedule_broadcast = false;
+
 	ksmbd_debug(NOTIFY, "Queueing notify event, action %u, name %s\n",
 		    event->action, event->name);
 
 	spin_lock(&notify->lock);
 	list_add_tail(&event->list, &notify->events);
 	notify->num_events++;
+	/* Start one timer per batch; reaching the limit flushes it early. */
+	if (notify->num_events == 1) {
+		broadcast_delay =
+			msecs_to_jiffies(KSMBD_NOTIFY_BROADCAST_MSECS);
+		schedule_broadcast = true;
+	} else if (notify->num_events >= KSMBD_NOTIFY_BROADCAST_MAX_EVENTS) {
+		schedule_broadcast = true;
+	}
 	spin_unlock(&notify->lock);
+
+	if (schedule_broadcast)
+		mod_delayed_work(system_dfl_long_wq, &notify->broadcast_work,
+				 broadcast_delay);
 }
 
 static void
@@ -292,6 +313,48 @@ ksmbd_notify_handle_rename(struct ksmbd_notify *notify, u32 mask,
 	return true;
 }
 
+static void ksmbd_notify_broadcast(struct ksmbd_notify *notify)
+{
+	struct ksmbd_notify_req *notify_req;
+	struct ksmbd_work *work;
+
+	spin_lock(&notify->lock);
+	if (list_empty(&notify->events))
+		goto out_unlock;
+
+	spin_lock(&notify->fp->f_lock);
+	list_for_each_entry(work, &notify->fp->blocked_works, fp_entry) {
+		if (READ_ONCE(work->state) != KSMBD_WORK_ACTIVE ||
+		    work->cancel_fn != smb2_notify_cancel ||
+		    !work->cancel_argv)
+			continue;
+
+		notify_req = work->cancel_argv[0];
+		if (READ_ONCE(notify_req->notified))
+			continue;
+
+		list_splice_tail_init(&notify->events, &notify_req->events);
+		notify_req->num_events = notify->num_events;
+		notify->num_events = 0;
+		WRITE_ONCE(notify_req->notified, true);
+		wake_up(&notify_req->wait);
+		break;
+	}
+	spin_unlock(&notify->fp->f_lock);
+
+out_unlock:
+	spin_unlock(&notify->lock);
+}
+
+static void ksmbd_notify_broadcast_work(struct work_struct *work)
+{
+	struct ksmbd_notify *notify;
+
+	notify = container_of(to_delayed_work(work), struct ksmbd_notify,
+			      broadcast_work);
+	ksmbd_notify_broadcast(notify);
+}
+
 static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -454,6 +517,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->max_buffer_size = max_buffer_size;
 	INIT_DELAYED_WORK(&notify->moved_from_work,
 			  ksmbd_notify_moved_from_timeout);
+	INIT_DELAYED_WORK(&notify->broadcast_work,
+			  ksmbd_notify_broadcast_work);
 
 	mark = ksmbd_notify_add_mark(notify, mask, &notify->group);
 	if (IS_ERR(mark)) {
@@ -500,11 +565,49 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    notify->mark->mask);
 	ksmbd_notify_destroy_mark(notify->group, notify->mark);
 	cancel_delayed_work_sync(&notify->moved_from_work);
+	cancel_delayed_work_sync(&notify->broadcast_work);
 	kfree(notify->moved_from_event);
 	ksmbd_notify_free_events(&notify->events);
 	kfree(notify);
 }
 
+static unsigned int
+ksmbd_notify_take_events(struct ksmbd_notify *notify, struct list_head *events)
+{
+	unsigned int num_events;
+
+	spin_lock(&notify->lock);
+	num_events = notify->num_events;
+	if (num_events) {
+		list_splice_tail_init(&notify->events, events);
+		notify->num_events = 0;
+	}
+	spin_unlock(&notify->lock);
+
+	if (num_events)
+		ksmbd_debug(NOTIFY,
+			    "Take %u queued notify events for synchronous reply\n",
+			    num_events);
+	return num_events;
+}
+
+static void
+ksmbd_notify_requeue_events(struct ksmbd_notify *notify,
+			    struct ksmbd_notify_req *notify_req)
+{
+	if (!notify_req->num_events)
+		return;
+
+	spin_lock(&notify->lock);
+	/* These events happened before any events already on the queue. */
+	list_splice_init(&notify_req->events, &notify->events);
+	notify->num_events += notify_req->num_events;
+	notify_req->num_events = 0;
+	spin_unlock(&notify->lock);
+
+	ksmbd_notify_broadcast(notify);
+}
+
 static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
 				  const struct list_head *b)
 {
@@ -603,6 +706,50 @@ static void *ksmbd_notify_encode_events(struct ksmbd_work *work,
 	return NULL;
 }
 
+static int ksmbd_notify_reply(struct ksmbd_work *work,
+			      struct ksmbd_notify *notify,
+			      struct smb2_change_notify_req *req,
+			      struct smb2_change_notify_rsp *rsp,
+			      struct list_head *events)
+{
+	u32 max_len = min(le32_to_cpu(req->OutputBufferLength),
+			  notify->max_buffer_size);
+	size_t data_len = 0;
+	void *data;
+	int err;
+
+	data = ksmbd_notify_encode_events(work, events, max_len, &data_len);
+	ksmbd_notify_free_events(events);
+
+	/* Maps a successful zero-length notify reply to ENUM_DIR. */
+	if (!data_len) {
+		ksmbd_debug(NOTIFY,
+			    "Return notify enum directory, output buffer length %u\n",
+			    max_len);
+		rsp->hdr.Status = STATUS_NOTIFY_ENUM_DIR;
+		return 0;
+	}
+
+	rsp->StructureSize = cpu_to_le16(9);
+	rsp->OutputBufferOffset = cpu_to_le16(72);
+	rsp->OutputBufferLength = cpu_to_le32(data_len);
+	err = ksmbd_iov_pin_rsp_read(work, rsp,
+				     offsetof(struct smb2_change_notify_rsp, Buffer),
+				     data, data_len);
+	if (err) {
+		pr_err("Failed to pin notify response data, length %zu: %d\n",
+		       data_len, err);
+		kvfree(data);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+	} else {
+		ksmbd_debug(NOTIFY,
+			    "Prepared notify response, data length %zu\n",
+			    data_len);
+	}
+
+	return err;
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
@@ -699,11 +846,15 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	list_add_tail(&work->fp_entry, &fp->blocked_works);
 	spin_unlock(&fp->f_lock);
 
+	/* Close the race between the synchronous check and queuing the waiter. */
+	ksmbd_notify_broadcast(notify);
+
 	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
 		    work->async_id);
 	smb2_send_interim_resp(work, STATUS_PENDING);
 
 	err = wait_event_interruptible(notify_req->wait,
+				       READ_ONCE(notify_req->notified) ||
 				       READ_ONCE(work->state) !=
 					       KSMBD_WORK_ACTIVE);
 	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
@@ -734,6 +885,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	struct ksmbd_notify_req *notify_req = NULL;
 	struct ksmbd_notify *notify = NULL;
 	struct ksmbd_file *fp = NULL;
+	LIST_HEAD(events);
 	void **argv = NULL;
 	bool async_work = false;
 	int err = 0;
@@ -752,6 +904,12 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		goto out;
 	}
 
+	/* Changes which arrived without a waiter are returned synchronously. */
+	if (ksmbd_notify_take_events(notify, &events)) {
+		err = ksmbd_notify_reply(work, notify, req, rsp, &events);
+		goto out;
+	}
+
 	notify_req = kzalloc_obj(*notify_req, KSMBD_DEFAULT_GFP);
 	if (!notify_req) {
 		pr_err("Failed to allocate notify request\n");
@@ -769,6 +927,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	}
 
 	init_waitqueue_head(&notify_req->wait);
+	INIT_LIST_HEAD(&notify_req->events);
 	argv[0] = notify_req;
 	err = setup_async_work(work, smb2_notify_cancel, argv);
 	if (err) {
@@ -781,17 +940,29 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	err = ksmbd_notify_wait(work, notify, notify_req);
 
 	if (work->state == KSMBD_WORK_CANCELLED) {
+		ksmbd_notify_requeue_events(notify, notify_req);
 		ksmbd_debug(NOTIFY, "Notify request cancelled, async id %d\n",
 			    work->async_id);
 		rsp->hdr.Status = STATUS_CANCELLED;
 		smb2_send_interim_resp(work, STATUS_CANCELLED);
 		work->send_no_response = 1;
 	} else if (work->state == KSMBD_WORK_CLOSED) {
+		ksmbd_notify_requeue_events(notify, notify_req);
 		ksmbd_debug(NOTIFY, "Notify handle closed, async id %d\n",
 			    work->async_id);
 		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
 		smb2_send_interim_resp(work, STATUS_NOTIFY_CLEANUP);
 		work->send_no_response = 1;
+	} else {
+		/* Complete the request using the AsyncId sent in STATUS_PENDING. */
+		rsp->hdr.Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+		rsp->hdr.Id.AsyncId = cpu_to_le64(work->async_id);
+		err = ksmbd_notify_reply(work, notify, req, rsp,
+					 &notify_req->events);
+		if (!err)
+			ksmbd_debug(NOTIFY,
+				    "Completed notify request, async id %d\n",
+				    work->async_id);
 	}
 
 out:
-- 
2.54.0

