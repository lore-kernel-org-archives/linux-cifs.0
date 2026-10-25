Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.67
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917370;
	b=38+UVrFsqKoagJpIOCGe8iSrwiWyMrFDmhtrYU8CuI5E80Vr1og5Txb3GLZ037JRg2CL
	 q6tWb5uZPvCP7Eh8skZlWJluD8JSsVfxoeD2D6K/I1uYifu4/c2KS5SjYxbdZq+/Y2kIG
	 gutMjLUdcDVGcNj13BEMOm+uDMIl1kAz+YUxY12Z4fMGQudCY3hChChJMcfSt/vJrAxiX
	 N95E2p5r4vRkKmePJrkUmNyQLa6Yx0xwNwy7ADgnIPwybZby7vXJ8k2tylPMya2H8TaLN
	 HDnNsjPFE5FSnHHwmP/jx1Lz+tMjDbQcjrRLV98L08mU5EeS1Ig2aVTOETMQOqPJIxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917370;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uLnIIONw0k3ZVXiRqVgo1zhJpZ7rpZQXIzitb29SrcQ=;
	b=NE5VRjRVchehYRxK0Gw5GUiMEVwEEJfqK2uPi/kGn6m0qdxJXkLA0GrN/eGTkZ4Qh2gF
	 Zrn1p6dw0323UuAJ57dN7A61NteNzutRPteCosAsbyi5IQo/H3TOgLDNoIqdERRxRmOKV
	 tDkvsedBNjPz/8M3tj6Fg5w0Fwb8TMDxHEMLQXUPtsYt0YMVnzYs546d9b1VoJd8YW+8C
	 BS3nBJFBTKrG8zOkIy40FPYgmLSD+r0qulTOeum5xARtx/dQH+dGC9UYkZ2yRBSn4GD2F
	 irSnGfuZm0qT+2DWRcVzGrUgXH7Oy4N+8qscUzGE5KY4jKFeUOaimn+8Namgz0z7RBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=XUqeaEca;
	arc=none smtp.remote-ip=91.218.175.67
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658A606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5658A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=XUqeaEca
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nyIwTHCIMBKxNnFZAdfYWkLJJHOAcT1pppGhTVl/1UI=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917367; v=1; x=1793522167;
 b=XUqeaEcaL983c84Ntvp9VPayWDNBq+3vs9WoO5h2FbOnnSy9eAxY7gu0rM1Sm2QTWk83PMou
 M0BjhlnDwawOFlAKVMVmqrYt8HGabZeUckOjpqlrRLekmUS1AS7+ep80AsCRIL5swCjpQzx2pvi
 kzRa4fED3+umeLd9Q9ccerdcKgqGYxgntw5d8JVluQ1vUWHPFYD1EUef6qcTEDYAFAvGY+mRKsJ
 pO4lOd6P1D/sm6+Y+HU8xiMcVHKs0wvOqXKAi4/Co8W8VqLcseBQaCnll+h1PUoEZt4nbypJl5f
 7bAhKxDRU7SlBD56wvJ/iE2xvGAN6GRSE6TwtM4CwtGbg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0859aadc6befcea0;
	Sun, 25 Oct 2026 08:36:07 +0000
X-Mizu-Trace-ID: 0859aadc6befcea0
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 08/13] smb/server: save old names for rename notify events
Date: Sun, 25 Oct 2026 08:34:45 +0000
Message-ID: <20261025083450.212604-9-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/notify.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h |  5 +++
 2 files changed, 88 insertions(+)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index a3ed26e1b631..77cb58ba950f 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -24,6 +24,7 @@
 #include "vfs_cache.h"
 #include "mgmt/user_session.h"
 
+#define KSMBD_NOTIFY_MOVED_FROM_MSECS	100
 #define KSMBD_NOTIFY_EVENT_MASK		(FS_ACCESS | FS_ATTRIB | FS_MODIFY | \
 					 KSMBD_NOTIFY_NAME_EVENT_MASK)
 
@@ -92,6 +93,12 @@ static void ksmbd_notify_discard_events(struct ksmbd_notify *notify,
 {
 	list_splice_tail_init(&notify->events, discard);
 	notify->num_events = 0;
+	if (notify->moved_from_event) {
+		list_add_tail(&notify->moved_from_event->list, discard);
+		notify->moved_from_event = NULL;
+	}
+	notify->moved_from_mask = 0;
+	notify->moved_from_cookie = 0;
 }
 
 static void ksmbd_notify_set_overflow(struct ksmbd_notify *notify)
@@ -213,6 +220,70 @@ ksmbd_notify_queue_event(struct ksmbd_notify *notify,
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
+	event = ksmbd_notify_alloc_event(notify, FILE_ACTION_RENAMED_OLD_NAME,
+					 file_name, KSMBD_DEFAULT_GFP);
+	if (!event)
+		return;
+
+	spin_lock(&notify->lock);
+	if (notify->overflow) {
+		spin_unlock(&notify->lock);
+		ksmbd_notify_free_event(notify, event);
+		return;
+	}
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
@@ -242,6 +313,14 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 	if (!ksmbd_notify_filter_match(notify, mask))
 		return 0;
 
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
@@ -489,6 +568,8 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	notify->filter = filter;
 	notify->mask = mask;
 	notify->watch_tree = watch_tree;
+	INIT_DELAYED_WORK(&notify->moved_from_work,
+			  ksmbd_notify_moved_from_timeout);
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -563,6 +644,8 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
 		    notify->mark->mask, notify->watch_tree);
 	ksmbd_notify_destroy_marks(notify);
+	cancel_delayed_work_sync(&notify->moved_from_work);
+	ksmbd_notify_free_event(notify, notify->moved_from_event);
 	ksmbd_notify_free_events(notify, &notify->events);
 	kfree(notify);
 }
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index a80775bd1163..d6da2e45cfcc 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -15,6 +15,7 @@
 
 #include <linux/fsnotify_backend.h>
 #include <linux/sizes.h>
+#include <linux/workqueue.h>
 
 struct ksmbd_work;
 struct ksmbd_file;
@@ -45,6 +46,10 @@ struct ksmbd_notify {
 	u32 filter;
 	u32 mask;
 	bool watch_tree;
+	struct ksmbd_notify_event *moved_from_event;
+	u32 moved_from_mask;
+	u32 moved_from_cookie;
+	struct delayed_work moved_from_work;
 };
 
 struct ksmbd_notify_req {
-- 
2.55.0

