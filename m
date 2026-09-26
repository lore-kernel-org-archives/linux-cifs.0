Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C07374A19
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413619; cv=none; b=uZnX3qYhJx/2Asa+IFO2IHjDd8VCS2lZlebNic9ZosMlTpKS5CQUkYfotMoE4Q2yRNrb+VYtSt1WnQqf+LCxaPsEyz7r4fMd+3Kq6/p6Fn7W5fszo9XMCnc1eQ5ZvKA+I64Evfp/t1/MOufHOMAI9N0OF3+rIZ2FwW1UE5ZlWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413619; c=relaxed/simple;
	bh=Jj9gka/zN5Tgc4VSIyp/EdEpZzTMLntLNNazTP0JArg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2m2N9XFpfoOY6e2smCS9WubKQBjIHJs99R8QUujnUh86fvbs8XizilSHaVrbQbUXge0X5IyzCA+vs6338U3Bw1m1xfJ+bvMefV9Fub1wXF9/s3C7r4W6rH/+sMeICYqGyL2eQ11gsQEBcOlvwYQ/mOUuvdLSrmd1KG4YBzZd+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=b8HIEJ/P; arc=none smtp.client-ip=91.218.175.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="b8HIEJ/P"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Jj9gka/zN5Tgc4VSIyp/EdEpZzTMLntLNNazTP0JArg=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413614; v=1; x=1791018414;
 b=b8HIEJ/PtaHLQxPjBS+sPJaEMb2mioD9Zr+7TUEPh8V9pCYPfIiGXgCRWucbbwpY/WnEOlK9
 C8ghg4in474aIheua+N7L885wlDoXH+i/7Pz7Lt7kYEon3dVeK1ixhQ62Zw7o4ucNjNKu6uCCe1
 24uy1jIPQcnP0fd+Cs48Tc6XFclSyJyooMwwtACftFJtlW62XhdmURQkFuWink9Ynmk+IC4iqBi
 LgtDa5n5f3gxiXOPHqSpltpLaBrRPVSHnh/cyKjQS3AbW0s2SI1rwWykqs8KtLEK8bChCBdGq9x
 umySYP8NZVz2KBqkGE+fnsJAliL+fWGVO3Rk1hmKbREmw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3dcc63905092319a;
	Sat, 26 Sep 2026 09:06:54 +0000
X-Mizu-Trace-ID: 3dcc63905092319a
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 08/12] smb/server: save old names for rename notify events
Date: Sat, 26 Sep 2026 09:05:14 +0000
Message-ID: <20260926090518.78547-9-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/notify.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 355370c66de0..ab1867033f26 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -42,12 +42,17 @@ struct ksmbd_notify {
 	u32 filter;
 	u32 mask;
 	bool watch_tree;
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
@@ -172,6 +177,65 @@ ksmbd_notify_queue_event(struct ksmbd_notify *notify,
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
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 					   u32 mask, struct inode *inode,
 					   struct inode *dir,
@@ -197,6 +261,14 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
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
@@ -433,6 +505,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->watch_tree = watch_tree;
+	INIT_DELAYED_WORK(&notify->moved_from_work,
+			  ksmbd_notify_moved_from_timeout);
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -507,6 +581,8 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
+	cancel_delayed_work_sync(&notify->moved_from_work);
+	kfree(notify->moved_from_event);
 	ksmbd_notify_free_events(&notify->events);
 	kfree(notify);
 }
-- 
2.55.0

