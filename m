Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9664330DD22
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776696; cv=none; b=OQ6QIbQRypkrImmKg3Fz150y4nbJUfzy8SYK4jaqtYw1MtBrPfeh2DjEsvRbc79JgL8KA1/aYYZAFs83mDYvYSvfUtdKFIoDKV8sZxQUrSCWRXfqVkEz1J/tmgVut2kzsNi4PurwkPDyPR1/5XyDDzWEAyaDZ66yCS3VA7/LULU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776696; c=relaxed/simple;
	bh=RRMVwxopsbpQKDv87h6tDGKQfsQ+Yp6s4ielNOe+NPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5Gzoy7AvzIPTIHQauTAfP4vbwMdWUBWCiEKg/d1sguoxOgUw4wTnUuIhrlmvB3/8lsRCVxmy3SU7p/+JTWZDl4M6svrXZ1FkoZXiXt8D6ddlSmaHuveOT6hSRJDunS/MgVqmApeFSqJMczAzhoiW2abNJ3OcI/dabtD1N61Nzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=PGjQ1/Ne; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="PGjQ1/Ne"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUqUjQJ/ITyadSITDjr2W/RfML7QQIrjySoGWmS19d4=;
	b=PGjQ1/NeSDd1Z3iP3r/oZIcxiB5eGSqvq2qTKIoCxxFaxMya0Ast6MBkz+6FnW5LDPnhSv
	4/aN4toSsHXMK86De9kAUB6KY2ns+I0wykjL8ibOa2AWdqNmPKoSKDqz5/PK0iCDH6tua3
	O8+GJ4tXzw2uI0zZdV57TiuK9Uv+l+kCyDVSZ689cBBMweFG/VkFzd3onQtdFWbz81R5yW
	AfjhV1ExBXmon6+ZiZ1tEKmwKjMDRYVxYguCI/gSOQUXubSq2YzbbLSdunq4PNXnVAtF/I
	avs7Kh37rJYUHmlARh9Zlmsv6Frfu8EqTunKY4mX0sMHAV4SRFZE1msRUun7Gg==
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
Subject: [RFC PATCH 06/11] smb/server: save simple notify events
Date: Thu, 23 Jul 2026 03:16:34 +0000
Message-ID: <20260723031644.312866-7-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/notify.c | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 82de53963dc0..a873625555ea 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/fsnotify_backend.h>
+#include <linux/ktime.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 
@@ -26,12 +27,22 @@ struct ksmbd_notify_mark {
 	struct ksmbd_notify *notify;
 };
 
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
 	struct ksmbd_file *fp;
 	/* Protects filter, rename state and the queued events. */
 	spinlock_t lock;
+	struct list_head events;
+	unsigned int num_events;
 	u32 filter;
 	u32 mask;
 	u32 max_buffer_size;
@@ -43,6 +54,8 @@ struct ksmbd_notify_req {
 
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
+#define KSMBD_NOTIFY_EVENT_MASK		(FS_ATTRIB | FS_MODIFY | \
+					 KSMBD_NOTIFY_NAME_EVENT_MASK)
 
 static const struct {
 	u32 notify_mask;
@@ -77,6 +90,34 @@ static u32 ksmbd_notify_map(u32 filter)
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
 static void smb2_notify_cancel(void **argv)
 {
 	struct ksmbd_notify_req *notify_req = argv[0];
@@ -85,6 +126,44 @@ static void smb2_notify_cancel(void **argv)
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
 static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -92,9 +171,11 @@ static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 					   u32 cookie)
 {
 	struct ksmbd_notify_mark *notify_mark;
+	struct ksmbd_notify_event *event;
 	struct ksmbd_notify *notify;
 	struct inode *event_inode = dir ?: inode;
 	struct ksmbd_file *fp;
+	u32 action;
 
 	notify_mark = container_of(mark, struct ksmbd_notify_mark, mark);
 	notify = notify_mark->notify;
@@ -107,6 +188,29 @@ static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
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
 
@@ -206,6 +310,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 
 	notify->fp = fp;
 	spin_lock_init(&notify->lock);
+	INIT_LIST_HEAD(&notify->events);
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->max_buffer_size = max_buffer_size;
@@ -254,6 +359,7 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask);
 	ksmbd_notify_destroy_mark(notify->group, notify->mark);
+	ksmbd_notify_free_events(&notify->events);
 	kfree(notify);
 }
 
-- 
2.54.0

