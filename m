Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A5374A19
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413599; cv=none; b=oiXgpvjEtYNK+n5KFM/eRG9s+lOKb2HpkF0ey9XrzThNGEpQQ5zuYGRqziS3+CZ2XeodmFZhXrHByLmV7Ozj0JjrpV6Nt4bT4ReCgwmudEwDQH09V7BkIrdV2mTs/05/Ga3DPox4IW4EuIUmUI/5jl5rCgUPxIJXIfg0yVIdMes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413599; c=relaxed/simple;
	bh=9jVITEZH09xpljqsrdxqJK1bCXJmHCUbznd6T56vdHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfgF5hW/eZnJtEH2vovjiUT+3II1XE7vZTJClH31pzVpbTc3SascBMK6IS79xCNB/pbXJ8QzLQL8bZ0ONAJTNQY0wwn/5ZwZNnpIK8qXOseuUawygNrcKFPUJo93braWxB2cIueYL2MnNalAonV/CzDpYqI46tUq+4BhW8dOGgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=i1caAgA4; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="i1caAgA4"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9jVITEZH09xpljqsrdxqJK1bCXJmHCUbznd6T56vdHE=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413594; v=1; x=1791018394;
 b=i1caAgA41D8ERl31BLeLLtUERJ6AdErZYyrJ6wamJqfjP4vKYzvBto0d9cqac+L9chREy02E
 ntEmgpvI8U2RVmgJUCUrKy2IUyA4bDD0xVGLrqieXYGhh+AGlmYVSONOPd6eFHlKKGDEq1DQ9hg
 nILQ7foxs8gFk+AY1+tPtIaWRDiz9xHkrY8N6tm0GMlJF/KOYwctIybMyZ3M+NOgk2yDGKZRukx
 B/eisMJwIc0VFd6axanvKRmhqMkFu3MzmmLkpNdkWnLz5RNJN0n4h3P8YVuLHYpMVFeXVK7+bIo
 8s/v7YqPU+Pd/Tx9Fr2yJeu5ItTu0MmfryvTAjb1ET66A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c13fbc9b8a7b2b95;
	Sat, 26 Sep 2026 09:06:33 +0000
X-Mizu-Trace-ID: c13fbc9b8a7b2b95
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 05/12] smb/server: support recursive directory change watches
Date: Sat, 26 Sep 2026 09:05:11 +0000
Message-ID: <20260926090518.78547-6-chenxiaosong@chenxiaosong.com>
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

Support SMB2 CHANGE_NOTIFY requests with SMB2_WATCH_TREE set.

Example:

  1. client: smbinfo notify /mnt
  2. server: ksmbd.control --debug=notify
  3. server: mkdir /export/dir; touch /export/dir/file
  4. server debug log:
     ksmbd: fid 1:1, notify event: mask=0x00000100 inode=11 name=dir\file cookie=0
     ksmbd: fid 1:1, notify event: mask=0x00000004 inode=11 name=dir\file cookie=0

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 155 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 149 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index b85f5fdb5066..b34f2f9b6d3f 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/fsnotify_backend.h>
+#include <linux/dcache.h>
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -24,11 +25,13 @@
 struct ksmbd_notify {
 	struct fsnotify_group *group;
 	struct fsnotify_mark *mark;
+	struct fsnotify_mark *tree_mark;
 	struct ksmbd_file *fp;
 	/* Protects filter, rename state and the queued events. */
 	spinlock_t lock;
 	u32 filter;
 	u32 mask;
+	bool watch_tree;
 };
 
 struct ksmbd_notify_req {
@@ -112,6 +115,100 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
 	return 0;
 }
 
+static char *ksmbd_notify_tree_name(struct ksmbd_notify *notify,
+				    const void *data, int data_type,
+				    struct inode *dir,
+				    const struct qstr *file_name,
+				    struct qstr *tree_name)
+{
+	struct dentry *root = file_dentry(notify->fp->filp);
+	struct inode *inode = fsnotify_data_inode(data, data_type);
+	struct dentry *dentry;
+	char *buf = NULL, *root_buf = NULL, *name = NULL;
+	char *path, *root_path, *relative;
+	size_t file_name_len = file_name ? file_name->len : 0;
+	size_t prefix_len, root_len, len, i;
+
+	/* Name events refer to @file_name below @dir. */
+	if (file_name && dir) {
+		dentry = d_find_alias(dir);
+	} else {
+		dentry = fsnotify_data_dentry(data, data_type);
+		if (dentry)
+			dget(dentry);
+		else
+			dentry = inode ? d_find_alias(inode) : NULL;
+	}
+	if (!dentry)
+		return ERR_PTR(-ENOENT);
+
+	/* A superblock mark also reports events outside the watched tree. */
+	if (!is_subdir(dentry, root)) {
+		name = ERR_PTR(-EXDEV);
+		goto out_dput;
+	}
+
+	buf = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
+	root_buf = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
+	if (!buf || !root_buf) {
+		name = ERR_PTR(-ENOMEM);
+		goto out_free_bufs;
+	}
+
+	path = dentry_path_raw(dentry, buf, PATH_MAX);
+	root_path = dentry_path_raw(root, root_buf, PATH_MAX);
+	if (IS_ERR(path) || IS_ERR(root_path)) {
+		name = ERR_PTR(IS_ERR(path) ? PTR_ERR(path) : PTR_ERR(root_path));
+		goto out_free_bufs;
+	}
+
+	root_len = strlen(root_path);
+	if (root_len == 1 && root_path[0] == '/') {
+		relative = path + 1;
+	} else if (!strncmp(path, root_path, root_len) &&
+		   (path[root_len] == '/' || path[root_len] == '\0')) {
+		relative = path + root_len;
+		if (*relative == '/')
+			relative++;
+	} else {
+		/* The watched directory was renamed between the two snapshots. */
+		name = ERR_PTR(-EAGAIN);
+		goto out_free_bufs;
+	}
+
+	prefix_len = strlen(relative);
+	if (prefix_len > SIZE_MAX - file_name_len - 2) {
+		name = ERR_PTR(-EOVERFLOW);
+		goto out_free_bufs;
+	}
+	len = prefix_len + file_name_len + (prefix_len && file_name ? 1 : 0);
+	name = kmalloc(len + 1, KSMBD_DEFAULT_GFP);
+	if (!name) {
+		name = ERR_PTR(-ENOMEM);
+		goto out_free_bufs;
+	}
+
+	memcpy(name, relative, prefix_len);
+	if (prefix_len && file_name)
+		name[prefix_len++] = '\\';
+	if (file_name_len)
+		memcpy(name + prefix_len, file_name->name, file_name_len);
+	name[len] = '\0';
+	for (i = 0; i < len; i++) {
+		if (name[i] == '/')
+			name[i] = '\\';
+	}
+	tree_name->name = name;
+	tree_name->len = len;
+
+out_free_bufs:
+	kfree(root_buf);
+	kfree(buf);
+out_dput:
+	dput(dentry);
+	return name;
+}
+
 static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
 				     const void *data, int data_type,
 				     struct inode *dir,
@@ -119,10 +216,32 @@ static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
 				     struct fsnotify_iter_info *iter_info)
 {
 	struct ksmbd_notify *notify = group->private;
-	struct inode *inode = fsnotify_data_inode(data, data_type);
+	struct qstr tree_name = {};
+	struct inode *inode;
+	char *name = NULL;
+	int err;
+
+	if (!READ_ONCE(notify->watch_tree)) {
+		/* Non-tree watches accept events from the root inode mark only. */
+		if (!fsnotify_iter_inode_mark(iter_info) &&
+		    !fsnotify_iter_parent_mark(iter_info))
+			return 0;
+	} else {
+		name = ksmbd_notify_tree_name(notify, data, data_type, dir,
+					      file_name, &tree_name);
+		if (IS_ERR(name)) {
+			if (PTR_ERR(name) == -ENOMEM)
+				pr_err("Failed to allocate tree notify event name\n");
+			return 0;
+		}
+		file_name = &tree_name;
+	}
 
-	return ksmbd_notify_handle_inode_event(notify, mask, inode, dir,
+	inode = fsnotify_data_inode(data, data_type);
+	err = ksmbd_notify_handle_inode_event(notify, mask, inode, dir,
 					      file_name, cookie);
+	kfree(name);
+	return err;
 }
 
 static void ksmbd_notify_free_mark(struct fsnotify_mark *mark)
@@ -166,6 +285,10 @@ ksmbd_notify_add_mark(struct ksmbd_notify *notify, u32 mask, void *obj,
 
 static void ksmbd_notify_destroy_marks(struct ksmbd_notify *notify)
 {
+	if (notify->tree_mark) {
+		fsnotify_destroy_mark(notify->tree_mark, notify->group);
+		fsnotify_put_mark(notify->tree_mark);
+	}
 	if (notify->mark) {
 		fsnotify_destroy_mark(notify->mark, notify->group);
 		fsnotify_put_mark(notify->mark);
@@ -175,10 +298,11 @@ static void ksmbd_notify_destroy_marks(struct ksmbd_notify *notify)
 }
 
 static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
+			    bool watch_tree,
 			    struct ksmbd_notify **notify_out)
 {
 	struct ksmbd_notify *notify;
-	struct fsnotify_mark *mark;
+	struct fsnotify_mark *mark, *tree_mark;
 	int err = 0;
 
 	notify = kzalloc_obj(*notify, KSMBD_DEFAULT_GFP);
@@ -192,6 +316,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	spin_lock_init(&notify->lock);
 	notify->filter = filter;
 	notify->mask = mask;
+	notify->watch_tree = watch_tree;
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -210,11 +335,27 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	}
 	notify->mark = mark;
 
+	if (watch_tree) {
+		/*
+		 * FS_EVENT_ON_CHILD covers only one level. A filesystem mark
+		 * supplies recursive events; the callback limits them to the
+		 * directory rooted at fp.
+		 */
+		tree_mark = ksmbd_notify_add_mark(notify, mask,
+						  file_inode(fp->filp)->i_sb,
+						  FSNOTIFY_OBJ_TYPE_SB);
+		if (IS_ERR(tree_mark)) {
+			err = PTR_ERR(tree_mark);
+			goto err_destroy_marks;
+		}
+		notify->tree_mark = tree_mark;
+	}
+
 	*notify_out = notify;
 	ksmbd_debug(NOTIFY,
-		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x\n",
+		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x, watch tree %d\n",
 		    (unsigned long long)file_inode(fp->filp)->i_ino, mark->mask,
-		    filter);
+		    filter, watch_tree);
 	goto out;
 
 err_destroy_marks:
@@ -309,7 +450,9 @@ ksmbd_notify_setup_watch(struct ksmbd_file *fp,
 		ksmbd_debug(NOTIFY,
 			    "No mapped completion filter bits; request will remain pending\n");
 
-	err = ksmbd_notify_add(fp, mask, filter, &notify);
+	err = ksmbd_notify_add(fp, mask, filter,
+			       le16_to_cpu(req->Flags) & SMB2_WATCH_TREE,
+			       &notify);
 	if (err) {
 		pr_err("Failed to add notify watch, fid %llu:%llu: %d\n",
 		       fp->persistent_id, fp->volatile_id, err);
-- 
2.55.0

