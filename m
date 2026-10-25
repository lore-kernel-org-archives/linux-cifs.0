Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917350;
	b=xPlxJ6dnm8LaUbHbtG7RStxCur0NTRAJFn7ATIj2J+dONjGYgb3jO2HSK3CszZ12rYzl
	 4pMRJYM0QXZM890PQ4RBZk06OfLVKF8VCnhb0R0jGqTUSPCG4CpvA8/z98VnV+AAwCYAn
	 +a5oL1veCACIbr5SdhfZP1IPGA0Hm93dSJ5rYkRrE2HckYaDCs72NRwTzsd/hMzD6FWmV
	 mSLBsTNDBfLcxNp9OMk/vx+1UT5YtmuR1aWBuJQ1Yrqbfvf7M5Sk9ZDMGUfyHnJ1/UT27
	 bNIYdemfwnO/quLBH5XWVo+93D5lY48CUv+s+Z4ZJYCCy2vpyHC4jPRUcopqHDwXlNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917350;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MSfLp+QPZuXJiLuA0N4gYawL6fdXOBM8TJRxKyTlreI=;
	b=rCke8FPcH5lnX3/pm+y0EEgHd8rwzRkrQ4rkiiFWfJdExdYZbDRzcshuyynUybpT8eSF
	 9kcU7l+A8HM5ln0Ztcm1P+NvUHsSVIHRR5LULtsU/6vEZHXAMmajHh7TOc9yNXaVAqHE7
	 9EWGXRL3KlfRfTPKQegvDw8O5KKUswyGHoObLzTb17qmPef+i8ug3aUc1i6wdBLh7u5bJ
	 vQCnoUQtHxPIQl6gL54TPvlMAEuRbZp8fqUcVLLzrXdBpQU0O9dsfnDc91Zo6uN0fAjnq
	 LyErRCCsFHvi9+jqHzcbSF9C56mHAhsCIoghJkPKTD781Hgcr67Vkt2sYgykoXm2xQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=OH0KFw1F;
	arc=none smtp.remote-ip=95.215.58.152
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF5606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54DF5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=OH0KFw1F
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JmJtq6y6AkBqnMEJTO4vxVp3YEZ2AQ8XyE0XJe//10M=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917346; v=1; x=1793522146;
 b=OH0KFw1FCBhsbigDflwyuwiqzqWJ7cQynO37xouflC8iT4ZVfETojP2YfADi39UGxX3qW3AH
 N/pG//7w7vAf+6vuef1+SM7aWkB/Ij/MRXwQXYB//EOv8Reeh08/aoMo7/JY93yKYuv39PnOjgT
 jGvQjIUyyJy4kdH1RTYxi9D5cx/PkUucMjJ6Ai2XP8mocs3FWiBj9g7JnLkIEUk/HJfHWpUCX/w
 IKiGxQUAwoFUS7d36I3ScVewEZZ2ooIQKCoyN/VZmZ/tXs5AO3AzIosYWIeBV7bpKWQdy8q/RRp
 /IfmNx5TyZ/379Ny/woBXhFHCW15yclXJFnzKrOe7gF+A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1bdc2efdf33cf475;
	Sun, 25 Oct 2026 08:35:46 +0000
X-Mizu-Trace-ID: 1bdc2efdf33cf475
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 04/13] smb/server: support non-recursive directory change watches
Date: Sun, 25 Oct 2026 08:34:41 +0000
Message-ID: <20261025083450.212604-5-chenxiaosong@chenxiaosong.com>
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

Use fsnotify to watch a directory for changes. Add one watch for each
SMB2 CHANGE_NOTIFY request with SMB2_WATCH_TREE unset.

Example:

  1. client: smbinfo notify /mnt
  2. server: ksmbd.control --debug=notify
  3. server: touch /export/file
  4. server debug log:
     ksmbd: fid 4:4, notify event: mask=0x00000100 inode=2 name=file cookie=0
     ksmbd: fid 4:4, notify event: mask=0x08000004 inode=2 name=file cookie=0

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Kconfig  |   1 +
 fs/smb/server/notify.c | 219 ++++++++++++++++++++++++++++++++++++++++-
 fs/smb/server/notify.h |  15 ++-
 3 files changed, 232 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index f8b03605db59..7b8ec245b12f 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -20,6 +20,7 @@ config SMB_SERVER
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
+	select FSNOTIFY
 	default n
 	help
 	  Choose Y here if you want to allow SMB3 compliant clients
diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 744dacc070c6..57a8e29bfb09 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/fsnotify_backend.h>
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -20,6 +21,40 @@
 #include "vfs_cache.h"
 #include "mgmt/user_session.h"
 
+static const struct {
+	u32 notify_mask;
+	u32 fsnotify_mask;
+} ksmbd_notify_mapping[] = {
+	{ FILE_NOTIFY_CHANGE_FILE_NAME,
+	  KSMBD_NOTIFY_NAME_EVENT_MASK },
+	{ FILE_NOTIFY_CHANGE_DIR_NAME,
+	  KSMBD_NOTIFY_NAME_EVENT_MASK },
+	{ FILE_NOTIFY_CHANGE_ATTRIBUTES,
+	  FS_ATTRIB | FS_MOVED_FROM | FS_MOVED_TO | FS_MODIFY },
+	{ FILE_NOTIFY_CHANGE_SIZE, FS_MODIFY },
+	{ FILE_NOTIFY_CHANGE_LAST_WRITE, FS_ATTRIB | FS_MODIFY },
+	{ FILE_NOTIFY_CHANGE_LAST_ACCESS, FS_ATTRIB | FS_ACCESS },
+	{ FILE_NOTIFY_CHANGE_EA, FS_ATTRIB },
+	{ FILE_NOTIFY_CHANGE_SECURITY, FS_ATTRIB },
+};
+
+static u32 ksmbd_notify_map(u32 filter)
+{
+	size_t i;
+	u32 mask = 0;
+
+	for (i = 0; i < ARRAY_SIZE(ksmbd_notify_mapping); i++) {
+		if (ksmbd_notify_mapping[i].notify_mask & filter)
+			mask |= ksmbd_notify_mapping[i].fsnotify_mask;
+	}
+
+	ksmbd_debug(NOTIFY,
+		    "Mapped completion filter 0x%x to fsnotify mask 0x%x\n",
+		    filter, mask);
+
+	return mask;
+}
+
 /*
  * Cancel handler for a pending CHANGE_NOTIFY. Called either by
  * smb2_cancel() (conn->request_lock held, work->state already set to
@@ -39,6 +74,140 @@ static void smb2_notify_cancel(void **argv)
 	wake_up(&notify_req->wait);
 }
 
+static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
+					   u32 mask, struct inode *inode,
+					   struct inode *dir,
+					   const struct qstr *file_name,
+					   u32 cookie)
+{
+	struct inode *event_inode = dir ?: inode;
+	struct ksmbd_file *fp;
+
+	fp = notify->fp;
+
+	ksmbd_debug(NOTIFY,
+		    "fid %llu:%llu, notify event: mask=0x%08x inode=%llu name=%.*s cookie=%u\n",
+		    fp->persistent_id, fp->volatile_id, mask,
+		    event_inode ? (unsigned long long)event_inode->i_ino : 0,
+		    file_name ? file_name->len : 0,
+		    file_name ? (const char *)file_name->name : "", cookie);
+
+	return 0;
+}
+
+static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
+				     const void *data, int data_type,
+				     struct inode *dir,
+				     const struct qstr *file_name, u32 cookie,
+				     struct fsnotify_iter_info *iter_info)
+{
+	struct ksmbd_notify *notify = group->private;
+	struct inode *inode = fsnotify_data_inode(data, data_type);
+
+	return ksmbd_notify_handle_inode_event(notify, mask, inode, dir,
+					      file_name, cookie);
+}
+
+static void ksmbd_notify_free_mark(struct fsnotify_mark *mark)
+{
+	kfree(mark);
+}
+
+static const struct fsnotify_ops ksmbd_notify_fsnotify_ops = {
+	.handle_event = ksmbd_notify_handle_event,
+	.free_mark = ksmbd_notify_free_mark,
+};
+
+static struct fsnotify_mark *
+ksmbd_notify_add_mark(struct ksmbd_notify *notify, u32 mask, void *obj,
+		      unsigned int obj_type)
+{
+	struct fsnotify_mark *mark;
+	int err;
+
+	mark = kzalloc_obj(*mark, KSMBD_DEFAULT_GFP);
+	if (!mark) {
+		pr_err("Failed to allocate fsnotify mark\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fsnotify_init_mark(mark, notify->group);
+	mark->mask = mask | FS_EVENT_ON_CHILD;
+	err = fsnotify_add_mark(mark, obj, obj_type, 0);
+	if (err) {
+		pr_err("Failed to add fsnotify mark, type %u: %d\n",
+		       obj_type, err);
+		goto err_put_mark;
+	}
+
+	return mark;
+
+err_put_mark:
+	fsnotify_put_mark(mark);
+	return ERR_PTR(err);
+}
+
+static void ksmbd_notify_destroy_marks(struct ksmbd_notify *notify)
+{
+	if (notify->mark) {
+		fsnotify_destroy_mark(notify->mark, notify->group);
+		fsnotify_put_mark(notify->mark);
+	}
+	fsnotify_wait_marks_destroyed();
+	fsnotify_put_group(notify->group);
+}
+
+static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
+			    struct ksmbd_notify **notify_out)
+{
+	struct ksmbd_notify *notify;
+	struct fsnotify_mark *mark;
+	int err = 0;
+
+	notify = kzalloc_obj(*notify, KSMBD_DEFAULT_GFP);
+	if (!notify) {
+		pr_err("Failed to allocate notify watch\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	notify->fp = fp;
+	spin_lock_init(&notify->lock);
+	notify->filter = filter;
+	notify->mask = mask;
+
+	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
+	if (IS_ERR(notify->group)) {
+		err = PTR_ERR(notify->group);
+		pr_err("Failed to allocate fsnotify group: %d\n", err);
+		kfree(notify);
+		goto out;
+	}
+	notify->group->private = notify;
+
+	mark = ksmbd_notify_add_mark(notify, mask, file_inode(fp->filp),
+				     FSNOTIFY_OBJ_TYPE_INODE);
+	if (IS_ERR(mark)) {
+		err = PTR_ERR(mark);
+		goto err_destroy_marks;
+	}
+	notify->mark = mark;
+
+	*notify_out = notify;
+	ksmbd_debug(NOTIFY,
+		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x\n",
+		    (unsigned long long)file_inode(fp->filp)->i_ino, mark->mask,
+		    filter);
+	goto out;
+
+err_destroy_marks:
+	ksmbd_notify_destroy_marks(notify);
+	kfree(notify);
+
+out:
+	return err;
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
@@ -78,6 +247,13 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 		goto err_put_fp;
 	}
 
+	if (le16_to_cpu(req->Flags) & ~SMB2_WATCH_TREE) {
+		pr_err("Invalid notify flags 0x%x\n", le16_to_cpu(req->Flags));
+		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		err = -EINVAL;
+		goto err_put_fp;
+	}
+
 	if (!S_ISDIR(file_inode(fp->filp)->i_mode)) {
 		pr_err("Notify file id is not a directory, fid %llu:%llu\n",
 		       fp->persistent_id, fp->volatile_id);
@@ -101,10 +277,37 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 	return ERR_PTR(err);
 }
 
+static struct ksmbd_notify *
+ksmbd_notify_setup_watch(struct ksmbd_file *fp,
+			 struct smb2_change_notify_req *req,
+			 struct smb2_change_notify_rsp *rsp)
+{
+	struct ksmbd_notify *notify;
+	u32 filter, mask;
+	int err;
+
+	filter = le32_to_cpu(req->CompletionFilter);
+	mask = ksmbd_notify_map(filter);
+	if (!mask)
+		ksmbd_debug(NOTIFY,
+			    "No mapped completion filter bits; request will remain pending\n");
+
+	err = ksmbd_notify_add(fp, mask, filter, &notify);
+	if (err) {
+		pr_err("Failed to add notify watch, fid %llu:%llu: %d\n",
+		       fp->persistent_id, fp->volatile_id, err);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		return ERR_PTR(err);
+	}
+
+	return notify;
+}
+
 static int ksmbd_notify_wait(struct ksmbd_work *work,
-			     struct ksmbd_file *fp,
+			     struct ksmbd_notify *notify,
 			     struct ksmbd_notify_req *notify_req)
 {
+	struct ksmbd_file *fp = notify->fp;
 	int err;
 
 	/*
@@ -161,6 +364,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_rsp *rsp)
 {
 	struct ksmbd_notify_req notify_req = {};
+	struct ksmbd_notify *notify = NULL;
 	struct ksmbd_file *fp = NULL;
 	void **argv = NULL;
 	bool async_work = false;
@@ -173,6 +377,13 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		goto out;
 	}
 
+	notify = ksmbd_notify_setup_watch(fp, req, rsp);
+	if (IS_ERR(notify)) {
+		err = PTR_ERR(notify);
+		notify = NULL;
+		goto out;
+	}
+
 	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
 	if (!argv) {
 		pr_err("Failed to allocate notify cancel arguments\n");
@@ -191,7 +402,7 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 	}
 	async_work = true;
 
-	err = ksmbd_notify_wait(work, fp, &notify_req);
+	err = ksmbd_notify_wait(work, notify, &notify_req);
 	if (err == -ENOENT) {
 		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
 		goto out;
@@ -216,6 +427,10 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		release_async_work(work);
 	else
 		kfree(argv);
+	if (notify) {
+		ksmbd_notify_destroy_marks(notify);
+		kfree(notify);
+	}
 	if (fp)
 		ksmbd_fd_put(work, fp);
 	return err;
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index eb2fc646208f..185ce93b01cc 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -13,16 +13,29 @@
 #ifndef __SMB_SERVER_NOTIFY_H__
 #define __SMB_SERVER_NOTIFY_H__
 
-#include <linux/wait.h>
+#include <linux/fsnotify_backend.h>
 
 struct ksmbd_work;
 struct smb2_change_notify_req;
 struct smb2_change_notify_rsp;
 
+struct ksmbd_notify {
+	struct fsnotify_group *group;
+	struct fsnotify_mark *mark;
+	struct ksmbd_file *fp;
+	/* Protects filter, rename state and the queued events. */
+	spinlock_t lock;
+	u32 filter;
+	u32 mask;
+};
+
 struct ksmbd_notify_req {
 	wait_queue_head_t wait;
 };
 
+#define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
+					 FS_MOVED_FROM | FS_MOVED_TO)
+
 int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_req *req,
 			struct smb2_change_notify_rsp *rsp);
-- 
2.55.0

