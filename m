Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872830DD22
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776691; cv=none; b=fDIcx4E818m+Lr2PEoqM/8jTRpGG0r1tzYZs7YUeNP6iNvnHYLeGN3PEpEIN++e92/rjFiX2KAnH7Tegsd2bvBHEkHGvH6DW4OTd3YEXFhfBLK4Vk15L7aFcbx4BCB7YKxzdMM/N9clGWKFjpcpFuJq7ZZBm564ZRkbmALKdm/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776691; c=relaxed/simple;
	bh=wXOZ69/KNc/VbWMMUE06qxcZuuWkucLW9zpUWjTNdsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG06azWCXmJxAxAy8heE8LQ7E7YpCC8MKetmitnqXvi+XaN3M6QrEz9EODhQLdUIrRHkQ7cySSgRo/MD9t/K668uGUyytbZoxbPh1x3mu2KdLN95OOVE48khzcIC8VDVeCCDTcorzM5GzgDTKjfz5QVpznV2k8LXXCI47XPaw0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=nKiX2X7m; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="nKiX2X7m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYUDLzQ97w4hF1sBD68wAPjY3AOoTiNjGZCOq86tDHA=;
	b=nKiX2X7m0uTtHijDxEt+B976EdAov3JPBA3DJAY9C6EzWWDUjzIGCjfMduCHq/Rr2xn6kN
	2R9n6RqoL9kVkZw0NuB+G8XA+xxgTGm/NuMjV4vSukbdn/uO5d+2PhD0Kz1YjBdDXnigMM
	gg0J0q5S1p6rLtxEmgkJgT1BrVlePm6AjXFVNXiAaP88jUtjD2Kk6X7lyEmllsY0hXFTYi
	pK8xthhohgi6ivfnt3b7LYZM9QKYWg1UlygLE+EiYz60W97otbcnSBwNRGBX8tXO8rUblQ
	yKMCncivk+OZUTCoPa3EbZD0qTWDQgLb6vY/wBSg2up02My84PcUEhBDdxefPA==
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
Subject: [RFC PATCH 05/11] smb/server: keep notify watches on file handles
Date: Thu, 23 Jul 2026 03:16:33 +0000
Message-ID: <20260723031644.312866-6-chenxiaosong@chenxiaosong.com>
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

Keep one notify watch on each file handle. Reuse it for later requests,
and remove it when the handle is closed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c    | 47 +++++++++++++++++++++++++++++++++++----
 fs/smb/server/notify.h    |  2 ++
 fs/smb/server/vfs_cache.c |  3 +++
 fs/smb/server/vfs_cache.h |  4 ++++
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index 1c020752a8ed..82de53963dc0 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -182,6 +182,21 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	struct fsnotify_mark *mark;
 	int err = 0;
 
+	mutex_lock(&fp->notify_lock);
+	if (fp->notify) {
+		spin_lock(&fp->notify->lock);
+		fp->notify->filter |= filter;
+		fp->notify->mask |= mask;
+		spin_unlock(&fp->notify->lock);
+		fsnotify_modify_mark_mask(fp->notify->mark, mask, 0);
+		ksmbd_debug(NOTIFY,
+			    "Updated fsnotify mark, inode %llu, mask 0x%x\n",
+			    (unsigned long long)file_inode(fp->filp)->i_ino,
+			    fp->notify->mark->mask);
+		*notify_out = fp->notify;
+		goto out;
+	}
+
 	notify = kzalloc_obj(*notify, KSMBD_DEFAULT_GFP);
 	if (!notify) {
 		pr_err("Failed to allocate notify watch\n");
@@ -203,6 +218,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 	}
 
 	notify->mark = mark;
+	fp->notify = notify;
 	*notify_out = notify;
 	ksmbd_debug(NOTIFY,
 		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x, "
@@ -211,9 +227,36 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 		    filter, max_buffer_size);
 
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
+		    "Removing fsnotify mark, inode %llu, mask 0x%x\n",
+		    (unsigned long long)file_inode(fp->filp)->i_ino,
+		    notify->mark->mask);
+	ksmbd_notify_destroy_mark(notify->group, notify->mark);
+	kfree(notify);
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
@@ -417,10 +460,6 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 		kfree(argv);
 	if (notify_req)
 		kfree(notify_req);
-	if (notify) {
-		ksmbd_notify_destroy_mark(notify->group, notify->mark);
-		kfree(notify);
-	}
 	if (fp)
 		ksmbd_fd_put(work, fp);
 	return err;
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
index 3118ad09c841..9d022ba9090f 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -12,11 +12,13 @@
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
index d0fd954e9ec8..64bef7ce5fd2 100644
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
@@ -625,6 +626,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	close_id_del_oplock(fp);
 	filp = fp->filp;
 
+	ksmbd_notify_remove(fp);
 	__ksmbd_inode_close(fp);
 	if (!IS_ERR_OR_NULL(filp))
 		fput(filp);
@@ -1175,6 +1177,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
 	spin_lock_init(&fp->f_lock);
+	mutex_init(&fp->notify_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 11bfbb981004..aff7db9127e0 100644
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
2.54.0

