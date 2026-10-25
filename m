Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.186
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917401;
	b=ka9arJsD8YIlAFL+met9rHr8m9EvU8wLc+BqP+r8CImZCX1h9i5iDnmI1zm3BMjmqBFE
	 /MvW6CU4/d+f+3LG4s6Pe/xj79lho/awsFSFFM1R6WvChpZZEvja7TBKk9z0an7Jz25nu
	 +3RGDR6S1NyAX+BS1k5waT0cEz92WkkVe8Tl4Sq8ed1Fp7H8yv1LPY575O2iCLhPPgq7n
	 V46YZAnIOZc8peTXlUFLRQLndEyJ/lns2W5TkP86Qh0aXNd5XwK7WJym6Q7KgZY4YvhSy
	 4fSysaYe7x3JhV7tN9prSgbgr/FCi8zlw24kabezaH8y1Vv0byIFeQXWSYRKUB88A5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917401;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ua6AJ1jqjbrPgQX+2QZX/9WigQDuqUJQjV0PZP1wwd4=;
	b=UlIBDWLnqS5MHvvr/HeFSNgDHWkYBv2r4D42KwZ673Y6XrNIwOXiejxOpO9weBQhFFh7
	 LFZxDNduPh7rtTAwU3kg+YzdL/wcwqmbjICbijJR2aFLTJpgaxpanx2FvspLybjsJSDl1
	 Q30I9g4SNSotUs8DW62IokWHO8E+l91+wspxgtD39sS/9+qfGC26IomAb4hdT61aShMU/
	 FTFpL37T/bNKg4V3WLDO1LvousmUPENDcrn0oIHtDoJZnp17uvgThGa8cfc+985w1H+Zg
	 iYZ2b8WNO/lLYOwSV4uVWOAxGad5i43uxEInlC5ajQBQYacpYsHKWbOl5j/FTUxKZEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=NpQeKDIx;
	arc=none smtp.remote-ip=95.215.58.186
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6233C606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6233C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=NpQeKDIx
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ehvqDsYFC8QDb/Vuu5cG4AClq4De8U+f4SaDpSKW2k4=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917398; v=1; x=1793522198;
 b=NpQeKDIxFRYVUCcRYtVp2Xe5OHxCMJK02xo00/SkrVvutytJiyX/fGf5lsZxwNOM2/3V0k0f
 OOse9F20IsR2ZegEPZcsjahkF96UXZhsrcJ2xyFEmgy/eTnRyguuFHhPBzAgAzh5GGvH9SX7tmm
 RZdc7WsUDczx/c1PM4/Gfwn8bB6hq3Lx+9UPyEMz+0WtE9lYdZL0RoK5Hf75Gk5WH25WKJOJiSZ
 /Ri5N6qTwy75I2j75T1Gf0mGWbPWAkusJKds9LahaUnLC9H+poM7VLCMsIPEWOLyqftqN4RaMbd
 v6vQlzhYKT9KMqpGnS4y9a1QDgoJ5MhkNkv2wBBZZo6HQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 912180c7f8351325;
	Sun, 25 Oct 2026 08:36:38 +0000
X-Mizu-Trace-ID: 912180c7f8351325
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 13/13] smb/server: support change notify for named streams
Date: Sun, 25 Oct 2026 08:34:50 +0000
Message-ID: <20261025083450.212604-14-chenxiaosong@chenxiaosong.com>
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

Example:

  mount -t cifs  -o nomapposix //${server_ip}/export /mnt
  smbinfo notify /mnt
  printf 'file data\n' > /mnt/file

  printf 'named stream\n' > /mnt/file:stream
  Notifications received, returned data_len is 112
  Action: 0x00000003, FileName: file
  Action: 0x00000006, FileName: file:stream
  Action: 0x00000003, FileName: file
  Action: 0x00000008, FileName: file:stream

  smbinfo filestreaminfo /mnt/file
  Name: stream
  Size: 13 bytes
  Allocation size: 13 bytes
  ...

  printf 'modify named stream\n' > /mnt/file:stream
  Notifications received, returned data_len is 56
  Action: 0x00000003, FileName: file
  Action: 0x00000008, FileName: file:stream

  rm -- /mnt/file:stream
  Notifications received, returned data_len is 56
  Action: 0x00000003, FileName: file
  Action: 0x00000007, FileName: file:stream

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 126 ++++++++++++++++++++++++++++++++++++++++-
 fs/smb/server/notify.h |   7 +++
 fs/smb/server/vfs.c    |  67 +++++++++++++++++++---
 3 files changed, 192 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 8db3fd59990a..5d331c0866be 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -24,6 +24,7 @@
 #include "smb_common.h"
 #include "smb2pdu.h"
 #include "vfs_cache.h"
+#include "xattr.h"
 #include "mgmt/user_session.h"
 
 #define KSMBD_NOTIFY_BROADCAST_MSECS	1000
@@ -32,6 +33,16 @@
 #define KSMBD_NOTIFY_EVENT_MASK		(FS_ACCESS | FS_ATTRIB | FS_MODIFY | \
 					 KSMBD_NOTIFY_NAME_EVENT_MASK)
 
+/* Protect the watch list and notify->fp during event delivery. */
+static DECLARE_RWSEM(ksmbd_notify_stream_lock);
+static LIST_HEAD(ksmbd_notify_stream_watches);
+
+/* Only a hint; list traversal still needs ksmbd_notify_stream_lock. */
+bool ksmbd_notify_has_stream_watches(void)
+{
+	return !list_empty(&ksmbd_notify_stream_watches);
+}
+
 static const struct {
 	u32 notify_mask;
 	u32 fsnotify_mask;
@@ -614,6 +625,109 @@ static char *ksmbd_notify_tree_name(struct ksmbd_notify *notify,
 	return name;
 }
 
+static void ksmbd_notify_stream_event(struct ksmbd_notify *notify,
+				      const struct path *path,
+				      const char *stream, size_t stream_len,
+				      u32 action, u32 filter)
+{
+	struct dentry *root = file_dentry(notify->fp->filp);
+	struct ksmbd_notify_event *event;
+	struct qstr file_name = {}, stream_name;
+	char *name, *full_name;
+
+	if (!(notify->filter & filter) || root->d_sb != path->dentry->d_sb ||
+	    d_inode(root) == d_inode(path->dentry))
+		return;
+
+	if (!notify->watch_tree) {
+		struct dentry *parent = dget_parent(path->dentry);
+		bool match = parent == root;
+
+		dput(parent);
+		if (!match)
+			return;
+	}
+
+	name = ksmbd_notify_tree_name(notify, path, FSNOTIFY_EVENT_PATH,
+				      NULL, NULL, &file_name);
+	if (IS_ERR(name)) {
+		if (PTR_ERR(name) != -EXDEV)
+			ksmbd_notify_set_overflow(notify);
+		return;
+	}
+	/* Unknown old size: cannot tell add from modify. */
+	if (!action) {
+		ksmbd_notify_set_overflow(notify);
+		goto out;
+	}
+
+	/* MS-FSA: relative file name + ':' + stream name. */
+	full_name = kasprintf(KSMBD_DEFAULT_GFP, "%s:%.*s", name,
+			      (int)stream_len, stream);
+	if (!full_name) {
+		ksmbd_notify_set_overflow(notify);
+		goto out;
+	}
+	stream_name.name = full_name;
+	stream_name.len = file_name.len + 1 + stream_len;
+	event = ksmbd_notify_alloc_event(notify, action, &stream_name,
+					 KSMBD_DEFAULT_GFP);
+	kfree(full_name);
+	if (event)
+		ksmbd_notify_queue_event(notify, event);
+out:
+	kfree(name);
+}
+
+/**
+ * ksmbd_notify_stream() - report a stream change
+ * @path: base file or directory
+ * @xattr_name: stream xattr name, including the type
+ * @old_size: old length, or -ENODATA for a new stream
+ * @new_size: new length, or -ENODATA for a deleted stream
+ *
+ * FS_ATTRIB has no xattr name or old size. Call this after a successful
+ * stream xattr change.
+ */
+void ksmbd_notify_stream(const struct path *path, const char *xattr_name,
+			 ssize_t old_size, ssize_t new_size)
+{
+	struct ksmbd_notify *notify;
+	const char *stream, *type;
+	u32 action, filter;
+
+	if (strncmp(xattr_name, XATTR_NAME_STREAM, XATTR_NAME_STREAM_LEN))
+		return;
+	stream = xattr_name + XATTR_NAME_STREAM_LEN;
+	type = strrchr(stream, ':');
+	if (!type || type == stream ||
+	    (strcasecmp(type, ":$DATA") &&
+	     strcasecmp(type, ":$INDEX_ALLOCATION")))
+		return;
+
+	if (new_size == -ENODATA) {
+		action = FILE_ACTION_REMOVED_STREAM;
+		filter = FILE_NOTIFY_CHANGE_STREAM_NAME;
+	} else if (old_size == -ENODATA) {
+		action = FILE_ACTION_ADDED_STREAM;
+		filter = FILE_NOTIFY_CHANGE_STREAM_NAME;
+	} else if (old_size < 0) {
+		action = 0;
+		filter = KSMBD_NOTIFY_STREAM_MASK;
+	} else {
+		action = FILE_ACTION_MODIFIED_STREAM;
+		filter = FILE_NOTIFY_CHANGE_STREAM_WRITE;
+		if (old_size != new_size)
+			filter |= FILE_NOTIFY_CHANGE_STREAM_SIZE;
+	}
+
+	down_read(&ksmbd_notify_stream_lock);
+	list_for_each_entry(notify, &ksmbd_notify_stream_watches, stream_list)
+		ksmbd_notify_stream_event(notify, path, stream, type - stream,
+					  action, filter);
+	up_read(&ksmbd_notify_stream_lock);
+}
+
 static int ksmbd_notify_handle_event(struct fsnotify_group *group, u32 mask,
 				     const void *data, int data_type,
 				     struct inode *dir,
@@ -744,6 +858,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	}
 
 	notify->fp = fp;
+	INIT_LIST_HEAD(&notify->stream_list);
 	spin_lock_init(&notify->lock);
 	INIT_LIST_HEAD(&notify->events);
 	notify->filter = filter;
@@ -787,6 +902,11 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 		notify->tree_mark = tree_mark;
 	}
 
+	if (filter & KSMBD_NOTIFY_STREAM_MASK) {
+		down_write(&ksmbd_notify_stream_lock);
+		list_add_tail(&notify->stream_list, &ksmbd_notify_stream_watches);
+		up_write(&ksmbd_notify_stream_lock);
+	}
 	fp->notify = notify;
 	*notify_out = notify;
 	ksmbd_debug(NOTIFY,
@@ -822,6 +942,10 @@ void ksmbd_notify_remove(struct ksmbd_file *fp)
 	if (!notify)
 		return;
 
+	down_write(&ksmbd_notify_stream_lock);
+	list_del_init(&notify->stream_list);
+	up_write(&ksmbd_notify_stream_lock);
+
 	ksmbd_debug(NOTIFY,
 		    "Removing fsnotify mark, inode %llu, mask 0x%x, watch tree %d\n",
 		    (unsigned long long)file_inode(fp->filp)->i_ino,
@@ -1120,7 +1244,7 @@ ksmbd_notify_setup_watch(struct ksmbd_file *fp,
 
 	filter = le32_to_cpu(req->CompletionFilter);
 	mask = ksmbd_notify_map(filter);
-	if (!mask)
+	if (!mask && !(filter & KSMBD_NOTIFY_STREAM_MASK))
 		ksmbd_debug(NOTIFY,
 			    "No mapped completion filter bits; request will remain pending\n");
 
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index b7d8df4bef1d..c8840e46c60f 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -32,6 +32,7 @@ struct ksmbd_notify_event {
 };
 
 struct ksmbd_notify {
+	struct list_head stream_list;
 	struct fsnotify_group *group;
 	struct fsnotify_mark *mark;
 	struct fsnotify_mark *tree_mark;
@@ -64,10 +65,16 @@ struct ksmbd_notify_req {
 #define KSMBD_NOTIFY_MAX_BYTES		SZ_64K
 #define KSMBD_NOTIFY_NAME_EVENT_MASK	(FS_CREATE | FS_DELETE | \
 					 FS_MOVED_FROM | FS_MOVED_TO)
+#define KSMBD_NOTIFY_STREAM_MASK		(FILE_NOTIFY_CHANGE_STREAM_NAME | \
+					 FILE_NOTIFY_CHANGE_STREAM_SIZE | \
+					 FILE_NOTIFY_CHANGE_STREAM_WRITE)
 
 int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_req *req,
 			struct smb2_change_notify_rsp *rsp);
 void ksmbd_notify_remove(struct ksmbd_file *fp);
+bool ksmbd_notify_has_stream_watches(void);
+void ksmbd_notify_stream(const struct path *path, const char *xattr_name,
+			 ssize_t old_size, ssize_t new_size);
 
 #endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 4ee72eda9bc0..989e749a035c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -34,6 +34,7 @@
 #include "auth.h"
 #include "misc.h"
 #include "stats.h"
+#include "notify.h"
 
 #include "smb_common.h"
 #include "mgmt/share_config.h"
@@ -942,6 +943,39 @@ ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
 	return xattr_len;
 }
 
+/*
+ * Read the old size and update the xattr under the same inode lock.
+ * Queue the notification before unlocking to keep events in order.
+ */
+static int ksmbd_vfs_set_stream_xattr(const struct mnt_idmap *idmap,
+				      const struct path *path, const char *name,
+				      void *value, size_t size, int flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	struct delegated_inode delegated_inode = {};
+	ssize_t old_size;
+	int err;
+
+retry_deleg:
+	inode_lock(inode);
+	/* A new watch may need a rescan if the old size was not read. */
+	old_size = -EAGAIN;
+	if (ksmbd_notify_has_stream_watches())
+		old_size = __vfs_getxattr(path->dentry, inode, name, NULL, 0);
+	err = __vfs_setxattr_locked(idmap, path->dentry, name, value, size,
+				    flags, &delegated_inode);
+	if (!err && ksmbd_notify_has_stream_watches())
+		ksmbd_notify_stream(path, name, old_size, size);
+	inode_unlock(inode);
+
+	if (is_delegated(&delegated_inode)) {
+		err = break_deleg_wait(&delegated_inode);
+		if (!err)
+			goto retry_deleg;
+	}
+	return err;
+}
+
 /**
  * ksmbd_vfs_setxattr() - vfs helper for smb set extended attributes value
  * @idmap:	idmap of the relevant mount
@@ -967,12 +1001,12 @@ int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
 			return err;
 	}
 
-	err = vfs_setxattr(idmap,
-			   path->dentry,
-			   attr_name,
-			   attr_value,
-			   attr_size,
-			   flags);
+	if (!strncmp(attr_name, XATTR_NAME_STREAM, XATTR_NAME_STREAM_LEN))
+		err = ksmbd_vfs_set_stream_xattr(idmap, path, attr_name,
+						 attr_value, attr_size, flags);
+	else
+		err = vfs_setxattr(idmap, path->dentry, attr_name, attr_value,
+				   attr_size, flags);
 	if (err)
 		ksmbd_debug(VFS, "setxattr failed, err %d\n", err);
 	if (get_write == true)
@@ -1251,6 +1285,8 @@ int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
 			   const struct path *path, char *attr_name,
 			   bool get_write)
 {
+	struct inode *inode = d_inode(path->dentry);
+	struct delegated_inode delegated_inode = {};
 	int err;
 
 	if (get_write == true) {
@@ -1259,8 +1295,25 @@ int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
 			return err;
 	}
 
-	err = vfs_removexattr(idmap, path->dentry, attr_name);
+	if (strncmp(attr_name, XATTR_NAME_STREAM, XATTR_NAME_STREAM_LEN)) {
+		err = vfs_removexattr(idmap, path->dentry, attr_name);
+		goto out;
+	}
+
+retry_deleg:
+	inode_lock(inode);
+	err = __vfs_removexattr_locked(idmap, path->dentry, attr_name,
+				       &delegated_inode);
+	if (!err && ksmbd_notify_has_stream_watches())
+		ksmbd_notify_stream(path, attr_name, 0, -ENODATA);
+	inode_unlock(inode);
+	if (is_delegated(&delegated_inode)) {
+		err = break_deleg_wait(&delegated_inode);
+		if (!err)
+			goto retry_deleg;
+	}
 
+out:
 	if (get_write == true)
 		mnt_drop_write(path->mnt);
 
-- 
2.55.0

