Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917388;
	b=XG33NBWC1wqEFsEgSOvc3uEU2Vifdl9u09Z0bcAZb0mRajM7PJWi9krtHnQXRo1o9Dck
	 1a/AXlTKSTOMdd6Gbdx3WCxqMg/zBdR0hOzVJ852/vkQk8S+vFMc0JDPn1dsEDGgBHehQ
	 vBRbE9ju1o/yVktsNBGUU/vP3ElZ+NMmo3XBo2MRsR3DJ9AB7ME+EaXvrtJ8oqHKOBLOg
	 5gwlV6MkmL2/HLtwPgWx0O8tTA06bfKtgB7VXrnLFWUutMcIEzqGcBRTz0UEQtEbzFHgN
	 lY+vMcTHO2qyJHM/Rch0SaSYGuD2iwnBrkrNP8Qsm1rJ65ltewCotZ1jV2si0qPIOAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917388;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=j9d7m2vNjSZx65V9S5xVkYGS6f19SMvDmdMFJm9nGTA=;
	b=DlvQMGCuHdkpr6rFCkXJxMGFJ3dWsF8WXm5sMQUOP13ZWGPgrgpMeb1/qSrpUuABIjcH
	 BtdkOAH/hX7dZYrY++AajMiTHFtxBvN+laneiLPNGei45SkhosLEmIAGj43FTXNOovZHF
	 nZhVs6BSVxfU8UHUgHcKCsmgcZmSOTN+CenyRJudNSfeQKBqUPJLkuMsxzmS32wX6eWfO
	 wu88BR2hpOV6azrKMGtA6C3IoyKx8Sd5DV/ZN5KszyRzm/uRx2zb5jZMMXZrQ+CAe9RN1
	 FOFvQdqWR0uQh4nRbSAQ+1pa/jwjBAmelIlADXzEf6mx6NaaiZjrE1c9Xl1THfMhZXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b="lN/+WIjd";
	arc=none smtp.remote-ip=95.215.58.176
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AA2606A31E
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12AA2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=lN/+WIjd
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YFvQQM0CHvpmsuN/cu5vubPIaNj80EQHVVl1lZsU+wc=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917386; v=1; x=1793522186;
 b=lN/+WIjdw2/JYpm+f45MpMXo9tRlcOgyCIFxqwfLsiMhollV4pmINap4U27Yiv0Zyy/2513k
 a5XJTMT9nGdHPGjxqo3euKWsmwq+mqptcPgdbtML2tBZ8HinH72aVjW2mYRvDilukoyREpjOnQd
 4mJm4yw1Tx+5yyzW8vK+v7/MMDUsQiSY6I6TH65L3uPGThaBIAMz+QQkUBTsXtvnNoi9bvOyXBO
 vN4svda3IuxOzq+FA6qUnzdUUAVf23HPFEweaoi21C6v4VGfzkyXeBQKfuBIANdhhj0ev9bh84/
 uAM6t7R+Ma2fVN5dcUgkcYnhWAQPAfkz22quWMjxmcj1Q==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ac7dbb1c9077977b;
	Sun, 25 Oct 2026 08:36:26 +0000
X-Mizu-Trace-ID: ac7dbb1c9077977b
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 11/13] smb/server: send notify events to the client
Date: Sun, 25 Oct 2026 08:34:48 +0000
Message-ID: <20261025083450.212604-12-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
 fs/smb/server/notify.c | 208 ++++++++++++++++++++++++++++++++++++++++-
 fs/smb/server/notify.h |   5 +
 2 files changed, 210 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index e93ce85cc3a4..7c8f36c0b951 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -25,6 +25,8 @@
 #include "vfs_cache.h"
 #include "mgmt/user_session.h"
 
+#define KSMBD_NOTIFY_BROADCAST_MSECS	1000
+#define KSMBD_NOTIFY_BROADCAST_MAX_EVENTS	100
 #define KSMBD_NOTIFY_MOVED_FROM_MSECS	100
 #define KSMBD_NOTIFY_EVENT_MASK		(FS_ACCESS | FS_ATTRIB | FS_MODIFY | \
 					 KSMBD_NOTIFY_NAME_EVENT_MASK)
@@ -112,6 +114,7 @@ static void ksmbd_notify_set_overflow(struct ksmbd_notify *notify)
 	spin_unlock(&notify->lock);
 
 	ksmbd_notify_free_events(notify, &discard);
+	mod_delayed_work(system_dfl_long_wq, &notify->broadcast_work, 0);
 }
 
 static bool ksmbd_notify_filter_match(struct ksmbd_notify *notify, u32 mask)
@@ -208,6 +211,10 @@ ksmbd_notify_queue_events(struct ksmbd_notify *notify,
 			  struct ksmbd_notify_event *event,
 			  struct ksmbd_notify_event *next)
 {
+	unsigned long broadcast_delay = 0;
+	bool schedule_broadcast = false;
+	bool first;
+
 	if (!event && !next)
 		return;
 
@@ -218,6 +225,7 @@ ksmbd_notify_queue_events(struct ksmbd_notify *notify,
 		ksmbd_notify_free_event(notify, next);
 		return;
 	}
+	first = !notify->num_events;
 	if (event) {
 		list_add_tail(&event->list, &notify->events);
 		notify->num_events++;
@@ -226,7 +234,19 @@ ksmbd_notify_queue_events(struct ksmbd_notify *notify,
 		list_add_tail(&next->list, &notify->events);
 		notify->num_events++;
 	}
+	/* Start one timer per batch; reaching the limit flushes it early. */
+	if (first) {
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
@@ -361,6 +381,66 @@ ksmbd_notify_handle_rename(struct ksmbd_notify *notify, u32 mask,
 	return true;
 }
 
+/* The caller holds notify->lock; ownership changes do not release memory. */
+static void ksmbd_notify_transfer_events(struct ksmbd_notify *notify,
+					 struct ksmbd_notify_req *notify_req)
+{
+	list_splice_tail_init(&notify->events, &notify_req->events);
+	notify_req->num_events = notify->num_events;
+	notify_req->overflow = notify->overflow;
+	notify->num_events = 0;
+	notify->overflow = false;
+}
+
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
+		ksmbd_notify_transfer_events(notify, notify_req);
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
+	if (notify->overflow || !list_empty(&notify->events))
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
@@ -649,6 +729,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->watch_tree = watch_tree;
 	INIT_DELAYED_WORK(&notify->moved_from_work,
 			  ksmbd_notify_moved_from_timeout);
+	INIT_DELAYED_WORK(&notify->broadcast_work,
+			  ksmbd_notify_broadcast_work);
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -724,11 +806,61 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
 	cancel_delayed_work_sync(&notify->moved_from_work);
+	cancel_delayed_work_sync(&notify->broadcast_work);
 	ksmbd_notify_free_event(notify, notify->moved_from_event);
 	ksmbd_notify_free_events(notify, &notify->events);
 	kfree(notify);
 }
 
+static bool
+ksmbd_notify_take_events(struct ksmbd_notify *notify,
+			 struct ksmbd_notify_req *notify_req)
+{
+	bool pending;
+
+	spin_lock(&notify->lock);
+	pending = notify->overflow || notify->num_events;
+	if (pending && ksmbd_notify_wake_waiter(notify))
+		pending = false;
+	else if (pending)
+		ksmbd_notify_transfer_events(notify, notify_req);
+	spin_unlock(&notify->lock);
+
+	if (pending)
+		ksmbd_debug(NOTIFY,
+			    "Take %u queued notify events, overflow %d, for synchronous reply\n",
+			    notify_req->num_events, notify_req->overflow);
+	return pending;
+}
+
+static void
+ksmbd_notify_requeue_events(struct ksmbd_notify *notify,
+			    struct ksmbd_notify_req *notify_req)
+{
+	LIST_HEAD(discard);
+
+	if (!notify_req->num_events && !notify_req->overflow)
+		return;
+
+	spin_lock(&notify->lock);
+	if (notify_req->overflow || notify->overflow) {
+		/* Cancellation must not consume an undelivered overflow. */
+		notify->overflow = true;
+		ksmbd_notify_discard_events(notify, &discard);
+		list_splice_tail_init(&notify_req->events, &discard);
+	} else {
+		/* These events are already charged to this open's budget. */
+		list_splice_init(&notify_req->events, &notify->events);
+		notify->num_events += notify_req->num_events;
+	}
+	notify_req->num_events = 0;
+	notify_req->overflow = false;
+	spin_unlock(&notify->lock);
+
+	ksmbd_notify_free_events(notify, &discard);
+	ksmbd_notify_broadcast(notify);
+}
+
 static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
 				  const struct list_head *b)
 {
@@ -834,6 +966,52 @@ static void *ksmbd_notify_encode_events(struct ksmbd_work *work,
 	return NULL;
 }
 
+static int ksmbd_notify_reply(struct ksmbd_work *work,
+			      struct smb2_change_notify_req *req,
+			      struct smb2_change_notify_rsp *rsp,
+			      struct ksmbd_notify *notify,
+			      struct ksmbd_notify_req *notify_req)
+{
+	u32 max_len = le32_to_cpu(req->OutputBufferLength);
+	size_t data_len = 0;
+	void *data = NULL;
+	int err;
+
+	if (!notify_req->overflow)
+		data = ksmbd_notify_encode_events(work, &notify_req->events,
+						  max_len, &data_len);
+	ksmbd_notify_free_events(notify, &notify_req->events);
+	notify_req->num_events = 0;
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
@@ -954,11 +1132,15 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
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
@@ -1012,6 +1194,13 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		goto out;
 	}
 
+	/* Changes which arrived without a waiter are returned synchronously. */
+	INIT_LIST_HEAD(&notify_req.events);
+	if (ksmbd_notify_take_events(notify, &notify_req)) {
+		err = ksmbd_notify_reply(work, req, rsp, notify, &notify_req);
+		goto out;
+	}
+
 	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
 	if (!argv) {
 		pr_err("Failed to allocate notify cancel arguments\n");
@@ -1037,16 +1226,29 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
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
+		err = ksmbd_notify_reply(work, req, rsp, notify, &notify_req);
+		if (!err)
+			ksmbd_debug(NOTIFY,
+				    "Completed notify request, async id %d\n",
+				    work->async_id);
 	}
-	smb2_send_interim_resp(work, rsp->hdr.Status);
-	work->send_no_response = 1;
 
 out:
 	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index d6da2e45cfcc..b7d8df4bef1d 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -50,10 +50,15 @@ struct ksmbd_notify {
 	u32 moved_from_mask;
 	u32 moved_from_cookie;
 	struct delayed_work moved_from_work;
+	struct delayed_work broadcast_work;
 };
 
 struct ksmbd_notify_req {
 	wait_queue_head_t wait;
+	struct list_head events;
+	unsigned int num_events;
+	bool overflow;
+	bool notified;
 };
 
 #define KSMBD_NOTIFY_MAX_BYTES		SZ_64K
-- 
2.55.0

