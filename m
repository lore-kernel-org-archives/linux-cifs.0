Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917356;
	b=uSgUu17nbBSf/mUSTQaESee1C/AE2xHD6wI+9LP4FS3Usv7TDZprrALoiVVhf2eiq7ns
	 A9ConK9kWK+WzV5KXaR6fus4hP9X4dz3FdLktU4SEtHvoQ0OyKJV1LnVj1eb5msNJ+99i
	 5Rm1dH13hZi7qQBVpW74Dh7Gd15+6hTp9ZOSgqSe3+2+DoUwhi1/FEgol4RJUO8D9g4Uu
	 3JI6tuAVc7Ogb4zWopyLm4rEvUUooOq5JMK0iIV+epHjoxUfSBf/PkHYI6Jd/q5eE8s3m
	 fHmtA+1k7eWYpmHszfhTz7LxSzl089Jt0oCEnWSvgMMp1IRm+7YRyvM/xzOGCm9Lcgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917356;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o4laQf5NP0m+/m3qtNFutFlNn680i3Y4d/4gtbInVAg=;
	b=kWjYQgseh/73ColW+ClczR/Ldhfsx+iNXonJtgLPhNDMj12d0Z6FJPu8wF+POjsol4C3
	 iw9K3efmnHWazKEMJnSmPsuMie7+M6PNal06LLyZ5gL7h+QNlBjHvRodDfNaih7HRb9qI
	 pglTgTNMKQ1P4i9+7lM7zf8+fTaRmegNJ7M3TxU+xft/JcEbajpNpo8BUivPVOFa97jr+
	 JE1B4/R/SNkOeafhgiVWFSz5VlQ+dVGhnAq87utTeCDBfS+LSAV+cm+N2yMylZPNcJYLu
	 kOks08njEWGlrAQi9yg+9TdxVlHAVA5bTvctxUTBIuYy93MfW09CTZ2tRSaWNZLWhkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b="i/tGMC6C";
	arc=none smtp.remote-ip=91.218.175.61
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F322606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F322606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=i/tGMC6C
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aroOWp4HRZsQ0CDRN/qo7R/OTuCZyFjJ67ILv6VK7ZU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917353; v=1; x=1793522153;
 b=i/tGMC6CVWVDTFp85mtTpV5eHRKWXzyn2AHnHU3j9EP/+Qqy3Shdm4Bq38fv+/ez9XzK8Ouv
 g9/d/VTnQzbUjyMxguoVScgV1XAyRxrW/nKFtG452jsHu+Y1L+IP2sCpVIEZQ2r9VIsl3J+sNf0
 yrYt6wZ5b2mvOsG9Zx2NB5r132192vY5Y6CG85ty0I0gza/iKcXxs4bXnhQ0kO3jRA1cWC3ITCm
 3GDXnWYgp6a4bPMZjDJFWl3OdPV5F6LYNNSQUnYhgVqrqvSH/ybr/3phQnCYJ7sz8EcJr6CtTml
 G4DYJzuIi6sVAMfIVconVtg2+4YoOU1QhDnpd8UnvrUuQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cc90ab29d2d22bc8;
	Sun, 25 Oct 2026 08:35:52 +0000
X-Mizu-Trace-ID: cc90ab29d2d22bc8
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 05/13] smb/server: support recursive directory change watches
Date: Sun, 25 Oct 2026 08:34:42 +0000
Message-ID: <20261025083450.212604-6-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/notify.c | 153 +++++++++++++++++++++++++++++++++++++++--
 fs/smb/server/notify.h |   2 +
 2 files changed, 149 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 57a8e29bfb09..a9175b864e19 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/fsnotify_backend.h>
+#include <linux/dcache.h>
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -95,6 +96,100 @@ static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
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
@@ -102,10 +197,32 @@ static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
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
@@ -149,6 +266,10 @@ ksmbd_notify_add_mark(struct ksmbd_notify *notify, u32 mask, void *obj,
 
 static void ksmbd_notify_destroy_marks(struct ksmbd_notify *notify)
 {
+	if (notify->tree_mark) {
+		fsnotify_destroy_mark(notify->tree_mark, notify->group);
+		fsnotify_put_mark(notify->tree_mark);
+	}
 	if (notify->mark) {
 		fsnotify_destroy_mark(notify->mark, notify->group);
 		fsnotify_put_mark(notify->mark);
@@ -158,10 +279,11 @@ static void ksmbd_notify_destroy_marks(struct ksmbd_notify *notify)
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
@@ -175,6 +297,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	spin_lock_init(&notify->lock);
 	notify->filter = filter;
 	notify->mask = mask;
+	notify->watch_tree = watch_tree;
 
 	notify->group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
 	if (IS_ERR(notify->group)) {
@@ -193,11 +316,27 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
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
@@ -292,7 +431,9 @@ ksmbd_notify_setup_watch(struct ksmbd_file *fp,
 		ksmbd_debug(NOTIFY,
 			    "No mapped completion filter bits; request will remain pending\n");
 
-	err = ksmbd_notify_add(fp, mask, filter, &notify);
+	err = ksmbd_notify_add(fp, mask, filter,
+			       le16_to_cpu(req->Flags) & SMB2_WATCH_TREE,
+			       &notify);
 	if (err) {
 		pr_err("Failed to add notify watch, fid %llu:%llu: %d\n",
 		       fp->persistent_id, fp->volatile_id, err);
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index 185ce93b01cc..e899a0ed5721 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -22,11 +22,13 @@ struct smb2_change_notify_rsp;
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
-- 
2.55.0

