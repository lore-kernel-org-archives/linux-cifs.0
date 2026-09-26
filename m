Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693ED374A19
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413611; cv=none; b=hzVRv8D7DbTKDDCyQgSlZfG5ryoq5dRjbEr0DWGHNkcmjqFl4O5lvfH5UsywKLiEPCTxJiGefMYakJLUYUK7BYMOocspYPNJ2qRK1j/Brru+CJ0FxJ6Q5vui078xgAc3sjk+waC1jyzFl+6jsq6MpeYAkSmOlDUen16kvG41R+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413611; c=relaxed/simple;
	bh=391l7XUcrMfchwWgJdLDegc0w5kQQHEs8Qu7LwYYZ4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4ynO3paOFOjQynGrpFk7oBnixPGUjnDj5yE9u7OLOaztnxXNx4b9Qecl1dsQjnIo9EqtDjfTGuNdHa8cznT+pWfHpvS0ke0J0ztIu6pgfXvR9GLT6a5crldPaCO76KWeC7/NTl+2I3afG75btRJ7mIKr0+gwBUs4vyJJ2cGnGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NzCOksgG; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NzCOksgG"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=391l7XUcrMfchwWgJdLDegc0w5kQQHEs8Qu7LwYYZ4M=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413607; v=1; x=1791018407;
 b=NzCOksgGLiJwKYaxgorwKFhSS7NH9XL+9VbiWqAYyj6ynMOa0kvN8pqzusVzhLcq0AdYa6u7
 Gwi6EXiUm2V78vb0khzALUCcjFfFmtveW44LjDsCcK4ugkY0r99hdoj1+sfy9lRCAxEijmeUM5M
 ERCW1arOrYZZd1Ju7CKNNH2i4i41jgabccvvCFUsYojfgjWy7WkkGnHj/9zttR8DW0LwNl80YFP
 vauGY3CO4jBu6lC7eFxxe5DZRBj5pZ7EozWR3k58KuF7cpqDDL17hbMmjBZy9JJ8ya76WztHNue
 avZiGS3za6FHL8ccJoUMVWHddfXwGa9VYQDPKDoaKjCVA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 36e5e0a717b46cfd;
	Sat, 26 Sep 2026 09:06:47 +0000
X-Mizu-Trace-ID: 36e5e0a717b46cfd
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 07/12] smb/server: save simple notify events
Date: Sat, 26 Sep 2026 09:05:13 +0000
Message-ID: <20260926090518.78547-8-chenxiaosong@chenxiaosong.com>
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

Save create, delete, and change events.

Example:

  1. client: smbinfo notify /mnt
  2. server: ksmbd.control --debug=notify
  3. server: touch /export/file
     server debug log:
       ksmbd: Queueing notify event, action 1, name file
       ksmbd: Queueing notify event, action 3, name file
  4. server: rm /export/file
     server debug log:
       ksmbd: Queueing notify event, action 2, name file

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 105 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index b49c0ec5117d..355370c66de0 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -22,6 +22,14 @@
 #include "vfs_cache.h"
 #include "mgmt/user_session.h"
 
+struct ksmbd_notify_event {
+	struct list_head list;
+	u32 action;
+	u64 when;
+	size_t name_len;
+	char name[];
+};
+
 struct ksmbd_notify {
 	struct fsnotify_group *group;
 	struct fsnotify_mark *mark;
@@ -29,6 +37,8 @@ struct ksmbd_notify {
 	struct ksmbd_file *fp;
 	/* Protects filter, rename state and the queued events. */
 	spinlock_t lock;
+	struct list_head events;
+	unsigned int num_events;
 	u32 filter;
 	u32 mask;
 	bool watch_tree;
@@ -40,6 +50,8 @@ struct ksmbd_notify_req {
 
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
+#define KSMBD_NOTIFY_EVENT_MASK		(FS_ATTRIB | FS_MODIFY | \
+					 KSMBD_NOTIFY_NAME_EVENT_MASK)
 
 static const struct {
 	u32 notify_mask;
@@ -75,6 +87,34 @@ static u32 ksmbd_notify_map(u32 filter)
 	return mask;
 }
 
+static void ksmbd_notify_free_events(struct list_head *events)
+{
+	struct ksmbd_notify_event *event, *tmp;
+
+	list_for_each_entry_safe(event, tmp, events, list) {
+		list_del(&event->list);
+		kfree(event);
+	}
+}
+
+static bool ksmbd_notify_filter_match(struct ksmbd_notify *notify, u32 mask)
+{
+	u32 filter, notify_mask;
+
+	spin_lock(&notify->lock);
+	filter = notify->filter;
+	notify_mask = notify->mask;
+	spin_unlock(&notify->lock);
+
+	if (mask & KSMBD_NOTIFY_NAME_EVENT_MASK) {
+		if (mask & FS_ISDIR)
+			return filter & FILE_NOTIFY_CHANGE_DIR_NAME;
+		return filter & FILE_NOTIFY_CHANGE_FILE_NAME;
+	}
+
+	return mask & notify_mask;
+}
+
 /*
  * Cancel handler for a pending CHANGE_NOTIFY. Called either by
  * smb2_cancel() (conn->request_lock held, work->state already set to
@@ -94,14 +134,54 @@ static void smb2_notify_cancel(void **argv)
 	wake_up(&notify_req->wait);
 }
 
+static struct ksmbd_notify_event *
+ksmbd_notify_alloc_event(u32 action, const struct qstr *file_name, gfp_t gfp)
+{
+	struct ksmbd_notify_event *event;
+	size_t name_len = file_name ? file_name->len : 0;
+
+	event = kmalloc(sizeof(*event) + name_len + 1, gfp);
+	if (!event) {
+		pr_err("Failed to allocate notify event, action %u, name %.*s\n",
+		       action, file_name ? file_name->len : 0,
+		       file_name ? (const char *)file_name->name : "");
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&event->list);
+	event->action = action;
+	event->when = ktime_get_ns();
+	event->name_len = name_len;
+	if (name_len)
+		memcpy(event->name, file_name->name, name_len);
+	event->name[name_len] = '\0';
+
+	return event;
+}
+
+static void
+ksmbd_notify_queue_event(struct ksmbd_notify *notify,
+			 struct ksmbd_notify_event *event)
+{
+	ksmbd_debug(NOTIFY, "Queueing notify event, action %u, name %s\n",
+		    event->action, event->name);
+
+	spin_lock(&notify->lock);
+	list_add_tail(&event->list, &notify->events);
+	notify->num_events++;
+	spin_unlock(&notify->lock);
+}
+
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
 					   const struct qstr *file_name,
 					   u32 cookie)
 {
+	struct ksmbd_notify_event *event;
 	struct inode *event_inode = dir ?: inode;
 	struct ksmbd_file *fp;
+	u32 action;
 
 	fp = notify->fp;
 
@@ -112,6 +192,29 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 		    file_name ? file_name->len : 0,
 		    file_name ? (const char *)file_name->name : "", cookie);
 
+	if (!(mask & KSMBD_NOTIFY_EVENT_MASK)) {
+		ksmbd_debug(NOTIFY, "Ignored notify event mask 0x%x\n", mask);
+		return 0;
+	}
+
+	if (mask & FS_CREATE) {
+		action = FILE_ACTION_ADDED;
+	} else if (mask & FS_DELETE) {
+		action = FILE_ACTION_REMOVED;
+	} else {
+		action = FILE_ACTION_MODIFIED;
+	}
+
+	if (!ksmbd_notify_filter_match(notify, mask))
+		return 0;
+
+	event = ksmbd_notify_alloc_event(action, file_name,
+					 KSMBD_DEFAULT_GFP);
+	if (!event)
+		return 0;
+
+	ksmbd_notify_queue_event(notify, event);
+
 	return 0;
 }
 
@@ -326,6 +429,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 
 	notify->fp = fp;
 	spin_lock_init(&notify->lock);
+	INIT_LIST_HEAD(&notify->events);
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->watch_tree = watch_tree;
@@ -403,6 +507,7 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
+	ksmbd_notify_free_events(&notify->events);
 	kfree(notify);
 }
 
-- 
2.55.0

