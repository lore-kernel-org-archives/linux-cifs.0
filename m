Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664343A1D01
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413642; cv=none; b=jec36FFm7l4RZIHwaVRrtxpFXMMlDYWGWHSCkItIRgf4N75ZNk/b+36abeFYzB6m1wNQfqVg7v83VApAjwayQJoto34W04hYJ3onxaLMvNS4n0p9M27lSYqxA6sI+uYtr1PerppPjofU8yKUWZX1cH34xR4B++H2nLq6q+khc0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413642; c=relaxed/simple;
	bh=zjEhjUAhi1QR8uNA/RcthEtDn52wxQOg1A5Zk/j50HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJs1aOLdrT9xfnNNE1noHE0gCGTfLlo40mS4Xz0SVwkbcZ2Gg/YzzQSrG8qrBPNhpps69vrBPIsS4jyAhdfd2ujtBXsiOpE4MWg8XJl0ZALCRg0HSzInoDrUMWx5WSh4fkr/qc3fD9+huAtmJstAQLtjkQhAn6RbuyGcU20UGpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=TgFZKJhb; arc=none smtp.client-ip=91.218.175.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="TgFZKJhb"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zjEhjUAhi1QR8uNA/RcthEtDn52wxQOg1A5Zk/j50HM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413637; v=1; x=1791018437;
 b=TgFZKJhbsHc8TreUig9adkLMXtnUl4FbUaM3cnBeJcwFS8pZPKSBdM8YlZcAELD77engtQ4V
 aTQMHZMf+MIysAyyu+rTetV0J50QbOZuvjX753hM7B/+/RMp0RnajjJE4FhP/pziWx4qtCZICKp
 QtHkgC+dUbVKBKD9UCLUsray7tI9gwfkio5e0+oTrSdO/bs75YmOys+bftpNrD/5pbHyM7uURBU
 Ypn5jX3/KyM12t7EOWZ9lhoPsppSqYSBXBPxH7ojgpn6/mupDapHHOx28yd36gOXdugwdBNC8yV
 ChcbV2Fzf0rZuZM+GHkyUc6u0zH+Uk2hssC41ODcZMgRA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a3838244c40c0653;
	Sat, 26 Sep 2026 09:07:17 +0000
X-Mizu-Trace-ID: a3838244c40c0653
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 11/12] smb/server: send notify events to the client
Date: Sat, 26 Sep 2026 09:05:17 +0000
Message-ID: <20260926090518.78547-12-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 188 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 185 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index da30cc058d78..dc62b5d6d17d 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -47,12 +47,18 @@ struct ksmbd_notify {
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
@@ -169,13 +175,28 @@ static void
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
@@ -298,6 +319,57 @@ ksmbd_notify_handle_rename(struct ksmbd_notify *notify, u32 mask,
 	return true;
 }
 
+/*
+ * Give queued events to the oldest pending notify request. The caller holds
+ * notify->lock so this lookup and transfer are atomic with synchronous takes.
+ */
+static bool ksmbd_notify_wake_waiter(struct ksmbd_notify *notify)
+{
+	struct ksmbd_notify_req *notify_req;
+	struct ksmbd_work *work;
+	bool found = false;
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
+		found = true;
+		break;
+	}
+	spin_unlock(&notify->fp->f_lock);
+
+	return found;
+}
+
+static void ksmbd_notify_broadcast(struct ksmbd_notify *notify)
+{
+	spin_lock(&notify->lock);
+	if (!list_empty(&notify->events))
+		ksmbd_notify_wake_waiter(notify);
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
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -571,6 +643,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->watch_tree = watch_tree;
 	INIT_DELAYED_WORK(&notify->moved_from_work,
 			  ksmbd_notify_moved_from_timeout);
+	INIT_DELAYED_WORK(&notify->broadcast_work,
+			  ksmbd_notify_broadcast_work);
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -646,11 +720,51 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
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
+	if (num_events && ksmbd_notify_wake_waiter(notify)) {
+		num_events = 0;
+	} else if (num_events) {
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
@@ -756,6 +870,48 @@ static void *ksmbd_notify_encode_events(struct ksmbd_work *work,
 	return NULL;
 }
 
+static int ksmbd_notify_reply(struct ksmbd_work *work,
+			      struct smb2_change_notify_req *req,
+			      struct smb2_change_notify_rsp *rsp,
+			      struct list_head *events)
+{
+	u32 max_len = le32_to_cpu(req->OutputBufferLength);
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
@@ -876,11 +1032,15 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	spin_unlock(&fp->f_lock);
 	read_unlock(&work->sess->file_table.lock);
 
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
@@ -916,6 +1076,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	struct ksmbd_notify_req notify_req = {};
 	struct ksmbd_notify *notify = NULL;
 	struct ksmbd_file *fp = NULL;
+	LIST_HEAD(events);
 	void **argv = NULL;
 	bool async_work = false;
 	int err = 0;
@@ -934,6 +1095,12 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		goto out;
 	}
 
+	/* Changes which arrived without a waiter are returned synchronously. */
+	if (ksmbd_notify_take_events(notify, &events)) {
+		err = ksmbd_notify_reply(work, req, rsp, &events);
+		goto out;
+	}
+
 	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
 	if (!argv) {
 		pr_err("Failed to allocate notify cancel arguments\n");
@@ -942,6 +1109,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		goto out;
 	}
 	init_waitqueue_head(&notify_req.wait);
+	INIT_LIST_HEAD(&notify_req.events);
 	argv[0] = &notify_req;
 
 	err = setup_async_work(work, smb2_notify_cancel, argv);
@@ -959,16 +1127,30 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	}
 
 	if (work->state == KSMBD_WORK_CLOSED) {
+		ksmbd_notify_requeue_events(notify, &notify_req);
 		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
 		ksmbd_debug(NOTIFY, "Notify handle closed, async id %d\n",
 			    work->async_id);
-	} else {
+		smb2_send_interim_resp(work, rsp->hdr.Status);
+		work->send_no_response = 1;
+	} else if (work->state == KSMBD_WORK_CANCELLED) {
+		ksmbd_notify_requeue_events(notify, &notify_req);
 		rsp->hdr.Status = STATUS_CANCELLED;
 		ksmbd_debug(NOTIFY, "Notify request cancelled, async id %d\n",
 			    work->async_id);
+		smb2_send_interim_resp(work, rsp->hdr.Status);
+		work->send_no_response = 1;
+	} else {
+		/* Complete the request using the AsyncId sent in STATUS_PENDING. */
+		rsp->hdr.Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+		rsp->hdr.Id.AsyncId = cpu_to_le64(work->async_id);
+		err = ksmbd_notify_reply(work, req, rsp,
+					 &notify_req.events);
+		if (!err)
+			ksmbd_debug(NOTIFY,
+				    "Completed notify request, async id %d\n",
+				    work->async_id);
 	}
-	smb2_send_interim_resp(work, rsp->hdr.Status);
-	work->send_no_response = 1;
 
 out:
 	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
-- 
2.55.0

