Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.66
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917364;
	b=qfc0QFez3KDKSNzI2LgOMdvYyvXi5P7sUvC2+zVjUsE0OFY1lfmUS+cpexW11EZcrMET
	 lDAK5v1kXb5UKhopddhD4sy6lf6Naz050CY3mrSsxjCuV62YsybO7gwr691n4lPHYE03p
	 z+at5/KpQcM6Z9OAy9CsIyIl6WkJweBC67N+V9Kl+ak+jET2WThMPx9vdBRQgmLhP4UP5
	 rteMOwLisyy5B4qimM9jF0jCzG6sTQ6cTvRWbhdJVEbr6DZKmutRXZPDHuVgMxma/htLz
	 eeWukoBPPmTjattqDCkQzBO/cKEVZXOfdJa9Nh6H+Y32pPgZXk4/8RJ3nB31TQaS6kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917364;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PbdEj41s+FzQ6up61K8OPjpKUivMTIPQ2v+BWfbM51g=;
	b=oBGtRRsevpSMsfqkBjfZne984kIlFQw499YZ8DNzyifPVBSR1O7+0jJDkl3dIliIazG8
	 ZP3QvGztno8wX0zBsXPgliXtXrPON7sljSbmmJAHtVIGr7ZbDPbfn1sT1bsoBLjNZ/44E
	 rEUNj//DiYyEjS6o0oPZRCQtJT/wysDWukylsnlzujubvz0bm3riv8fw984ONb0teqepc
	 roesCc16e0V9oo0bgULriXOlwaWGnhgUSe6LYyUTAEm9ffWkaN9XzChoVovjAyujaX5Hu
	 p6cFHICzZvxDKr0pf0fVREsxr7yAIBibh7jHQYWkIFtot6hzoJ/G0R9aOt+4gaeVgXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Sd5ZF8+d;
	arc=none smtp.remote-ip=91.218.175.66
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BA1606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91BA1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Sd5ZF8+d
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ICwipNXrhcBD7QqNF4kejDpRSYgWdPUTG2hwQSTq2Ng=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917361; v=1; x=1793522161;
 b=Sd5ZF8+dy/qfqmTXbReXJhk8NWsrmvtdw/u7ta+VT19YqE2CnKmvWuO6II6EpfBH6o86pfBg
 c6ELZiSdjebr1lotqorffnvN/saB1NRE7Tp4X1Sg2sBh9zTh+gLQDcg/x5qhQRqvpjjBUfEUYwW
 Sk47dsjwZXkfLDsqbthFWZQBlsgwD3HZOFFRZbOwP1Fg+vgZoyTwBy1hVpG3KzQFGXhuTaMSZH3
 4Wj7RqZu/p1zPVn7VG0vjnNsJdyxctDuSpn4lklAQzPoTOpcNHlDaVsCsa1bl0GBxGOYWYD5pNC
 5Nit+JxGOFQsOfFtLhgqVXe/0zCwhr26/Hg3iQsphqHAQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3521f3b693d40662;
	Sun, 25 Oct 2026 08:36:01 +0000
X-Mizu-Trace-ID: 3521f3b693d40662
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 07/13] smb/server: save simple notify events
Date: Sun, 25 Oct 2026 08:34:44 +0000
Message-ID: <20261025083450.212604-8-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/notify.c | 182 ++++++++++++++++++++++++++++++++++++++++-
 fs/smb/server/notify.h |  16 ++++
 2 files changed, 197 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 1d5301a7f9ea..a3ed26e1b631 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -12,6 +12,8 @@
 
 #include <linux/fsnotify_backend.h>
 #include <linux/dcache.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -22,6 +24,9 @@
 #include "vfs_cache.h"
 #include "mgmt/user_session.h"
 
+#define KSMBD_NOTIFY_EVENT_MASK		(FS_ACCESS | FS_ATTRIB | FS_MODIFY | \
+					 KSMBD_NOTIFY_NAME_EVENT_MASK)
+
 static const struct {
 	u32 notify_mask;
 	u32 fsnotify_mask;
@@ -56,6 +61,69 @@ static u32 ksmbd_notify_map(u32 filter)
 	return mask;
 }
 
+static void ksmbd_notify_free_event(struct ksmbd_notify *notify,
+				    struct ksmbd_notify_event *event)
+{
+	size_t alloc_size;
+
+	if (!event)
+		return;
+	alloc_size = event->alloc_size;
+	kfree(event);
+	spin_lock(&notify->lock);
+	notify->event_bytes -= alloc_size;
+	spin_unlock(&notify->lock);
+}
+
+static void ksmbd_notify_free_events(struct ksmbd_notify *notify,
+				     struct list_head *events)
+{
+	struct ksmbd_notify_event *event, *tmp;
+
+	list_for_each_entry_safe(event, tmp, events, list) {
+		list_del(&event->list);
+		ksmbd_notify_free_event(notify, event);
+	}
+}
+
+/* The caller holds notify->lock. Keep charges until the events are freed. */
+static void ksmbd_notify_discard_events(struct ksmbd_notify *notify,
+					struct list_head *discard)
+{
+	list_splice_tail_init(&notify->events, discard);
+	notify->num_events = 0;
+}
+
+static void ksmbd_notify_set_overflow(struct ksmbd_notify *notify)
+{
+	LIST_HEAD(discard);
+
+	spin_lock(&notify->lock);
+	notify->overflow = true;
+	ksmbd_notify_discard_events(notify, &discard);
+	spin_unlock(&notify->lock);
+
+	ksmbd_notify_free_events(notify, &discard);
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
@@ -75,14 +143,86 @@ static void smb2_notify_cancel(void **argv)
 	wake_up(&notify_req->wait);
 }
 
+static struct ksmbd_notify_event *
+ksmbd_notify_alloc_event(struct ksmbd_notify *notify, u32 action,
+			 const struct qstr *file_name, gfp_t gfp)
+{
+	struct ksmbd_notify_event *event;
+	size_t name_len = file_name ? file_name->len : 0;
+	size_t alloc_size;
+
+	if (name_len > KSMBD_NOTIFY_MAX_BYTES - sizeof(*event) - 1)
+		goto overflow;
+	alloc_size = kmalloc_size_roundup(sizeof(*event) + name_len + 1);
+
+	/* Reserve before allocating so concurrent callbacks share one budget. */
+	spin_lock(&notify->lock);
+	if (notify->overflow) {
+		spin_unlock(&notify->lock);
+		return NULL;
+	}
+	if (alloc_size > KSMBD_NOTIFY_MAX_BYTES - notify->event_bytes) {
+		spin_unlock(&notify->lock);
+		goto overflow;
+	}
+	notify->event_bytes += alloc_size;
+	spin_unlock(&notify->lock);
+
+	event = kmalloc(alloc_size, gfp);
+	if (!event) {
+		pr_err("Failed to allocate notify event, action %u, name %.*s\n",
+		       action, file_name ? file_name->len : 0,
+		       file_name ? (const char *)file_name->name : "");
+		spin_lock(&notify->lock);
+		notify->event_bytes -= alloc_size;
+		spin_unlock(&notify->lock);
+		goto overflow;
+	}
+
+	INIT_LIST_HEAD(&event->list);
+	event->action = action;
+	event->when = ktime_get_ns();
+	event->name_len = name_len;
+	event->alloc_size = alloc_size;
+	if (name_len)
+		memcpy(event->name, file_name->name, name_len);
+	event->name[name_len] = '\0';
+
+	return event;
+
+overflow:
+	ksmbd_notify_set_overflow(notify);
+	return NULL;
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
+	if (notify->overflow) {
+		spin_unlock(&notify->lock);
+		ksmbd_notify_free_event(notify, event);
+		return;
+	}
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
 
@@ -93,6 +233,30 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 		    file_name ? file_name->len : 0,
 		    file_name ? (const char *)file_name->name : "", cookie);
 
+	if (!(mask & KSMBD_NOTIFY_EVENT_MASK)) {
+		ksmbd_debug(NOTIFY, "Ignored notify event mask 0x%x\n", mask);
+		return 0;
+	}
+
+	/* Only matching changes may consume the budget or signal overflow. */
+	if (!ksmbd_notify_filter_match(notify, mask))
+		return 0;
+
+	if (mask & FS_CREATE) {
+		action = FILE_ACTION_ADDED;
+	} else if (mask & FS_DELETE) {
+		action = FILE_ACTION_REMOVED;
+	} else {
+		action = FILE_ACTION_MODIFIED;
+	}
+
+	event = ksmbd_notify_alloc_event(notify, action, file_name,
+					 KSMBD_DEFAULT_GFP);
+	if (!event)
+		return 0;
+
+	ksmbd_notify_queue_event(notify, event);
+
 	return 0;
 }
 
@@ -202,6 +366,21 @@ static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
 	char *name = NULL;
 	int err;
 
+	/*
+	 * fsnotify_access() reports reads and directory enumeration as path
+	 * events, even when atime is unchanged. Keep the dentry-based FS_ACCESS
+	 * events from fsnotify_change() for explicit atime updates.
+	 */
+	if (data_type == FSNOTIFY_EVENT_PATH)
+		mask &= ~FS_ACCESS;
+	if (!(mask & KSMBD_NOTIFY_EVENT_MASK))
+		return 0;
+
+	inode = fsnotify_data_inode(data, data_type);
+	/* CHANGE_NOTIFY reports changes below the watched directory. */
+	if (inode == file_inode(notify->fp->filp))
+		return 0;
+
 	if (!READ_ONCE(notify->watch_tree)) {
 		/* Non-tree watches accept events from the root inode mark only. */
 		if (!fsnotify_iter_inode_mark(iter_info) &&
@@ -218,7 +397,6 @@ static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
 		file_name = &tree_name;
 	}
 
-	inode = fsnotify_data_inode(data, data_type);
 	err = ksmbd_notify_handle_inode_event(notify, mask, inode, dir,
 					      file_name, cookie);
 	kfree(name);
@@ -307,6 +485,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 
 	notify->fp = fp;
 	spin_lock_init(&notify->lock);
+	INIT_LIST_HEAD(&notify->events);
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->watch_tree = watch_tree;
@@ -384,6 +563,7 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
+	ksmbd_notify_free_events(notify, &notify->events);
 	kfree(notify);
 }
 
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index ace9afc022b7..a80775bd1163 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -14,12 +14,22 @@
 #define __SMB_SERVER_NOTIFY_H__
 
 #include <linux/fsnotify_backend.h>
+#include <linux/sizes.h>
 
 struct ksmbd_work;
 struct ksmbd_file;
 struct smb2_change_notify_req;
 struct smb2_change_notify_rsp;
 
+struct ksmbd_notify_event {
+	struct list_head list;
+	u32 action;
+	u64 when;
+	size_t name_len;
+	size_t alloc_size;
+	char name[];
+};
+
 struct ksmbd_notify {
 	struct fsnotify_group *group;
 	struct fsnotify_mark *mark;
@@ -27,6 +37,11 @@ struct ksmbd_notify {
 	struct ksmbd_file *fp;
 	/* Protects filter, rename state and the queued events. */
 	spinlock_t lock;
+	struct list_head events;
+	unsigned int num_events;
+	/* Includes reservations, rename state and events owned by requests. */
+	size_t event_bytes;
+	bool overflow;
 	u32 filter;
 	u32 mask;
 	bool watch_tree;
@@ -36,6 +51,7 @@ struct ksmbd_notify_req {
 	wait_queue_head_t wait;
 };
 
+#define KSMBD_NOTIFY_MAX_BYTES		SZ_64K
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
 
-- 
2.55.0

