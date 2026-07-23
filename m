Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B530DD22
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776700; cv=none; b=fbGnN+tm9G0Yzbe+ueMWGO/fFQU263yMZkQMwLCQzvXo0b/mQKziDZAPk6cVWA16f5KGbYsABogY/Nr8/aGdbID/dKiHtGg5PBVUk33AjkzpD7Q88CpumV77pqu5y0Dyom87ez9iiTsT4/VPRssEIqpE7pG5hvx59oVV9XR9C1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776700; c=relaxed/simple;
	bh=EKobwn1qQ85gjEBnOv1EJXcUCyFimgFFoHi2skIaREM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDcdAeme5KfJgS1+QXN9LhcR06uvHvBE1cR/IaCaR7d3Yh6HNCrmygSKtYjRn79MgSFg4ZJm9IFg0H0cV97k3c9tlV2TZMGkob+1DLp7obM63Y2kzZM7BBE9V+cEj75B5fR8iHBo/7HyyrHpjI/KT9mlA03Eu+mrw4DUQ2bzUCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Fhs3TMbA; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Fhs3TMbA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IsImTsz10GbSP8sApb2OoLJ1y4xpfqf+/XsSPbXXtRw=;
	b=Fhs3TMbA1xY/qx29K+2I4NcCIYwLC4i9owoVzLMp/NBVNLQCx1ZGaJ80xGycExUqW4TDG+
	ysADoOqQ2KboBODMQlRczEX6E0n5/ZSmeoCXJRGK14vU5+ukyTKQ9V6dvJ+Mw0L5sz+9Dc
	f8eD9CJkgkjq+Z88nw0Kc0f/3aNA70aTsvk+0nMzKIwXMss21KOfbyXhiZHJT/KZVtz+KN
	dTV5P0tmNwYhMwrVswr7lVl9hBAqk2V/GPj6/P2Z4RApnrlGC8+WOWCIkaVKcrFxxrRu2X
	hnMkOjXYru6hBkR83+myypx1n2WRTaXDhgPTN8K8iaBGwt+H6DmU7MI0qqYcBQ==
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
Subject: [RFC PATCH 07/11] smb/server: save old names for rename notify events
Date: Thu, 23 Jul 2026 03:16:35 +0000
Message-ID: <20260723031644.312866-8-chenxiaosong@chenxiaosong.com>
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

Save the old name from FS_MOVED_FROM events for matching with a subsequent
FS_MOVED_TO event. Queue unmatched events as removals after a short delay.

Example:

  1. client: smbinfo notify /mnt
  2. server: ksmbd.control --debug=notify
  3. server: mkdir /export/dir/; touch /export/file
  4. server: mv /export/file /export/dir/
     server debug log:
       [40622.865858] ksmbd: Saved moved from, mask 0x40, name file, cookie 1134
       [40622.975906] ksmbd: Queue moved from as removed, name file

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index a873625555ea..80c1eb089b60 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -9,9 +9,11 @@
  */
 
 #include <linux/fsnotify_backend.h>
+#include <linux/jiffies.h>
 #include <linux/ktime.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include "glob.h"
 #include "../common/smb2status.h"
@@ -46,12 +48,17 @@ struct ksmbd_notify {
 	u32 filter;
 	u32 mask;
 	u32 max_buffer_size;
+	struct ksmbd_notify_event *moved_from_event;
+	u32 moved_from_mask;
+	u32 moved_from_cookie;
+	struct delayed_work moved_from_work;
 };
 
 struct ksmbd_notify_req {
 	wait_queue_head_t wait;
 };
 
+#define KSMBD_NOTIFY_MOVED_FROM_MSECS	100
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
 #define KSMBD_NOTIFY_EVENT_MASK		(FS_ATTRIB | FS_MODIFY | \
@@ -164,6 +171,65 @@ ksmbd_notify_queue_event(struct ksmbd_notify *notify,
 	spin_unlock(&notify->lock);
 }
 
+static void
+ksmbd_notify_trigger_removed(struct ksmbd_notify *notify,
+			     struct ksmbd_notify_event *event)
+{
+	ksmbd_debug(NOTIFY,
+		    "Queue moved from as removed, name %s\n",
+		    event->name);
+	event->action = FILE_ACTION_REMOVED;
+	event->when = ktime_get_ns();
+	ksmbd_notify_queue_event(notify, event);
+}
+
+static void ksmbd_notify_moved_from_timeout(struct work_struct *work)
+{
+	struct ksmbd_notify_event *event;
+	struct ksmbd_notify *notify;
+
+	notify = container_of(to_delayed_work(work), struct ksmbd_notify,
+			      moved_from_work);
+
+	spin_lock(&notify->lock);
+	event = notify->moved_from_event;
+	notify->moved_from_event = NULL;
+	spin_unlock(&notify->lock);
+
+	if (!event)
+		return;
+	ksmbd_notify_trigger_removed(notify, event);
+}
+
+static void ksmbd_notify_save_moved_from(struct ksmbd_notify *notify,
+					 u32 mask, u32 cookie,
+					 const struct qstr *file_name)
+{
+	struct ksmbd_notify_event *event, *old_event;
+
+	event = ksmbd_notify_alloc_event(FILE_ACTION_RENAMED_OLD_NAME,
+					 file_name, KSMBD_DEFAULT_GFP);
+	if (!event)
+		return;
+
+	spin_lock(&notify->lock);
+	old_event = notify->moved_from_event;
+	notify->moved_from_event = event;
+	notify->moved_from_mask = mask;
+	notify->moved_from_cookie = cookie;
+	spin_unlock(&notify->lock);
+
+	ksmbd_debug(NOTIFY,
+		    "Saved moved from, mask 0x%x, name %.*s, cookie %u\n",
+		    mask, file_name ? file_name->len : 0,
+		    file_name ? (const char *)file_name->name : "", cookie);
+	if (old_event)
+		ksmbd_notify_trigger_removed(notify, old_event);
+
+	mod_delayed_work(system_dfl_wq, &notify->moved_from_work,
+			 msecs_to_jiffies(KSMBD_NOTIFY_MOVED_FROM_MSECS));
+}
+
 static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -193,6 +259,14 @@ static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
 		return 0;
 	}
 
+	if (mask & FS_MOVED_FROM) {
+		ksmbd_notify_save_moved_from(notify, mask, cookie, file_name);
+		return 0;
+	}
+
+	if (mask & FS_MOVED_TO)
+		return 0;
+
 	if (mask & FS_CREATE) {
 		action = FILE_ACTION_ADDED;
 	} else if (mask & FS_DELETE) {
@@ -314,6 +388,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->max_buffer_size = max_buffer_size;
+	INIT_DELAYED_WORK(&notify->moved_from_work,
+			  ksmbd_notify_moved_from_timeout);
 
 	mark = ksmbd_notify_add_mark(notify, mask, &notify->group);
 	if (IS_ERR(mark)) {
@@ -359,6 +435,8 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask);
 	ksmbd_notify_destroy_mark(notify->group, notify->mark);
+	cancel_delayed_work_sync(&notify->moved_from_work);
+	kfree(notify->moved_from_event);
 	ksmbd_notify_free_events(&notify->events);
 	kfree(notify);
 }
-- 
2.54.0

