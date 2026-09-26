Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716F63A4535
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413604; cv=none; b=F6a+KD0sc9mqWoRAtCWcsKAr9FYLsux3WB8/tRrw+ADrLkvwhV61lnDp6grMjHxTZrEm4lY+cCxzCLeBfj1+WkJHvR+WA0IlOAYsGIaZuTXHhSLqu8JhDO4luDFX+dckyJ2Q29HXc1wyw6QysJIOvq2CfkXWOBICWOjcRgyZ2tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413604; c=relaxed/simple;
	bh=3OezSaPtmEIievgrJ8ZkRX2hrLq3vKYyR3NkYpKbDuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/Z3z/uyU+e7l54uc+tKhww0R0CImvOHXLU/ep1uCnA00B6m9Ybq5OIXDEDYPiUEKXY4E3g4OlKQ1wRO+8fxQ96KC5jgDzK/C9S6JGf9FdyylClItEnPy0IPC6Yczf5pfnzoo+CKh6N95H3R6sO82SF22tZglRP/VPapK14TxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Yy3xoZ+h; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Yy3xoZ+h"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3OezSaPtmEIievgrJ8ZkRX2hrLq3vKYyR3NkYpKbDuA=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413600; v=1; x=1791018400;
 b=Yy3xoZ+h4XKIcdv3tA6VgAEuLT8RJYicCopWL71AGLYsp4CjsLyF4q8Gcb7QPcW8GGUbZFBt
 10XG9KQRP6TaP9XpmU9nIIRvdTpxwTSDT6QrzXnOlfMPBrPG6NhCcYHaNyk4pp/1Bgsp2oohkDk
 dKItKuOZN7p2LpZr2kgOdNBO3fvHjobncZysPDfytvdi9UCuvojxUcA+B+ucZ3YT6+l51BomSWk
 +GKowVSiAXb0Iz91d3nwfs7HUnU1hgfkucagirqJFRHeYtMoLqmllzchuyodrYNiwCseZnv85It
 NuAygQzRxhziQE4rF9SQ730uPV1Of5hJGurf3pR90Cq9g==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b5842735eee3ee7e;
	Sat, 26 Sep 2026 09:06:40 +0000
X-Mizu-Trace-ID: b5842735eee3ee7e
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 06/12] smb/server: keep notify watches on file handles
Date: Sat, 26 Sep 2026 09:05:12 +0000
Message-ID: <20260926090518.78547-7-chenxiaosong@chenxiaosong.com>
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

Keep one notify watch on each file handle. Reuse it for later requests,
and remove it when the handle is closed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c    | 44 +++++++++++++++++++++++++++++++++++----
 fs/smb/server/notify.h    |  2 ++
 fs/smb/server/vfs_cache.c |  3 +++
 fs/smb/server/vfs_cache.h |  4 ++++
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index b34f2f9b6d3f..b49c0ec5117d 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -305,6 +305,18 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	struct fsnotify_mark *mark, *tree_mark;
 	int err = 0;
 
+	mutex_lock(&fp->notify_lock);
+	if (fp->notify) {
+		/* Further requests on this open use the first request's options. */
+		ksmbd_debug(NOTIFY,
+			    "Reusing fsnotify mark, inode %llu, mask 0x%x, filter 0x%x, watch tree %d\n",
+			    (unsigned long long)file_inode(fp->filp)->i_ino,
+			    fp->notify->mark->mask, fp->notify->filter,
+			    fp->notify->watch_tree);
+		*notify_out = fp->notify;
+		goto out;
+	}
+
 	notify = kzalloc_obj(*notify, KSMBD_DEFAULT_GFP);
 	if (!notify) {
 		pr_err("Failed to allocate notify watch\n");
@@ -351,6 +363,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 		notify->tree_mark = tree_mark;
 	}
 
+	fp->notify = notify;
 	*notify_out = notify;
 	ksmbd_debug(NOTIFY,
 		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x, watch tree %d\n",
@@ -363,9 +376,36 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	kfree(notify);
 
 out:
+	mutex_unlock(&fp->notify_lock);
 	return err;
 }
 
+/**
+ * ksmbd_notify_remove() - remove the notify watch for a closing handle
+ * @fp: file handle whose watch is being removed
+ *
+ * A cancelled CHANGE_NOTIFY request leaves this watch installed. The watch is
+ * owned by @fp and removed only when the file handle is finally closed.
+ */
+void ksmbd_notify_remove(struct ksmbd_file *fp)
+{
+	struct ksmbd_notify *notify;
+
+	mutex_lock(&fp->notify_lock);
+	notify = fp->notify;
+	fp->notify = NULL;
+	mutex_unlock(&fp->notify_lock);
+	if (!notify)
+		return;
+
+	ksmbd_debug(NOTIFY,
+		    "Removing fsnotify mark, inode %llu, mask 0x%x, watch tree %d\n",
+		    (unsigned long long)file_inode(fp->filp)->i_ino,
+		    notify->mark->mask, notify->watch_tree);
+	ksmbd_notify_destroy_marks(notify);
+	kfree(notify);
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
@@ -587,10 +627,6 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		release_async_work(work);
 	else
 		kfree(argv);
-	if (notify) {
-		ksmbd_notify_destroy_marks(notify);
-		kfree(notify);
-	}
 	if (fp)
 		ksmbd_fd_put(work, fp);
 	return err;
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index 8de46e07b02e..1132b91c1d54 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -14,11 +14,13 @@
 #define __SMB_SERVER_NOTIFY_H__
 
 struct ksmbd_work;
+struct ksmbd_file;
 struct smb2_change_notify_req;
 struct smb2_change_notify_rsp;
 
 int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_req *req,
 			struct smb2_change_notify_rsp *rsp);
+void ksmbd_notify_remove(struct ksmbd_file *fp);
 
 #endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a96b764c4db5..b242babf5771 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -18,6 +18,7 @@
 #include "vfs.h"
 #include "connection.h"
 #include "misc.h"
+#include "notify.h"
 #include "mgmt/tree_connect.h"
 #include "mgmt/user_session.h"
 #include "mgmt/user_config.h"
@@ -626,6 +627,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	close_id_del_oplock(fp);
 	filp = fp->filp;
 
+	ksmbd_notify_remove(fp);
 	__ksmbd_inode_close(fp);
 	if (!IS_ERR_OR_NULL(filp))
 		fput(filp);
@@ -1220,6 +1222,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
 	spin_lock_init(&fp->f_lock);
+	mutex_init(&fp->notify_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 732ae26dd6a7..fe8a01b062cd 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -33,6 +33,7 @@
 #define SMB2_NO_FID		(0xFFFFFFFFFFFFFFFFULL)
 
 struct ksmbd_conn;
+struct ksmbd_notify;
 struct ksmbd_session;
 
 struct ksmbd_lock {
@@ -96,6 +97,9 @@ struct ksmbd_file {
 	u64				durable_volatile_id;
 
 	spinlock_t			f_lock;
+	/* Protects notify watch creation and removal. */
+	struct mutex			notify_lock;
+	struct ksmbd_notify		*notify;
 
 	struct ksmbd_inode		*f_ci;
 	struct ksmbd_inode		*f_parent_ci;
-- 
2.55.0

