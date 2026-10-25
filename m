Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.160
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917357;
	b=NcsLipSDADxcZvvdvdfXSbpBJukoi7R/lWv/PQf+hx7A7iosKDFjMQoQ3tNgS/w8zRXn
	 9onmnMb4BobMY99plZLro+2EQRwyIGbQ0U9CiG3compZHWvi83BzlDwg+A8/DRWpHlkY1
	 ADVSZeGLgaP7L4B5EMBRLCuIhrIbwTAqOAFBq6hEMrhXZ/eNuh9AYgBsuo6NUOJKuwl6v
	 fHXdjxan7OBPhDOZn88AlClBxnijpyyqR5FBRdNs06ADLTbHNUkiGDHAoPBTK21++3j+f
	 INaGs20jgKpnQO7lvdjwdR10eKPRJ2DRxwepZ8XZBgUFbqmiJ3iE6+JlJ0+tAgNOpOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917357;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4XG92TaJb4ktHqCSd4XCdtZGr/fosHQh4vDsw22zYBA=;
	b=s1vgoEE/o4Us3BOqfu1XnFjSGbarD7HrmYuzaaJNwOfBnfXMnlioOu66KGux7z59HHmE
	 KssRL5kxPxnNP23MHNeEscopfa2kDq4OsMkGubdyJPsxdH3LigjUxK1rQvlEQ51yVDV5X
	 ABE86JA90NLxdlMhKJQ1WQXiJNQxA+ykqqiuJUMEFc/b2/xYH5Y+WwOHlgLLzUrFUFram
	 nKbDPRq1KBa3N/IQN+gHpB37thezuuYwyBY5V1/uZIAmhkakjPaDLEouYUQ00xDTVbDjz
	 2SFp0raTNG/gtGJadw6x1bPbs/ffTUKmD+H58Bh8rJVhTPV08FG3ep/9xijcliPasag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=PsbJEIAo;
	arc=none smtp.remote-ip=95.215.58.160
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2ED606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B2ED606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=PsbJEIAo
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/GzOik294kLmfrCLJaiugFlSTZz78mv3fdR2IfwEFDM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917355; v=1; x=1793522155;
 b=PsbJEIAo048h1ERukf9Hn/Ofn66q16iRlLH015uJ1z+rdY9EHwUpZI14RpPAJuQEq91Fop09
 1+u1eZJajGcsh5Nsdb8mCuKRyAfQe6XJBMRyxjNXPQbpNJqKMQjZvTinMUhg1+PUpPx1KPNzo6Y
 5fWSqFgefevdbhXJ26qg7IGaCFpacpmE8Fp9RkYFo3sEovs62960IdtCv4SvmajaJC/NrnIY5Zr
 CQQMOLLnzAJXPwpprmP0RtZoNqDmB9PrpwcLaBUeBmS+jcrWpY5EfoPao2L3bpeSLfvExWCKCKy
 oSJcq1sNfIssgWjazEanoqrnS94ZEfaaRb5zt61IAV3Ow==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d5c83f468e63148d;
	Sun, 25 Oct 2026 08:35:54 +0000
X-Mizu-Trace-ID: d5c83f468e63148d
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 06/13] smb/server: keep notify watches on file handles
Date: Sun, 25 Oct 2026 08:34:43 +0000
Message-ID: <20261025083450.212604-7-chenxiaosong@chenxiaosong.com>
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
index a9175b864e19..1d5301a7f9ea 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -286,6 +286,18 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
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
@@ -332,6 +344,7 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
 		notify->tree_mark = tree_mark;
 	}
 
+	fp->notify = notify;
 	*notify_out = notify;
 	ksmbd_debug(NOTIFY,
 		    "Added fsnotify mark, inode %llu, mask 0x%x, filter 0x%x, watch tree %d\n",
@@ -344,9 +357,36 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
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
@@ -568,10 +608,6 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
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
index e899a0ed5721..ace9afc022b7 100644
--- a/fs/smb/server/notify.h
+++ b/fs/smb/server/notify.h
@@ -16,6 +16,7 @@
 #include <linux/fsnotify_backend.h>
 
 struct ksmbd_work;
+struct ksmbd_file;
 struct smb2_change_notify_req;
 struct smb2_change_notify_rsp;
 
@@ -41,5 +42,6 @@ struct ksmbd_notify_req {
 int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_req *req,
 			struct smb2_change_notify_rsp *rsp);
+void ksmbd_notify_remove(struct ksmbd_file *fp);
 
 #endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 7a0f13277ec0..e4922c1731b2 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -20,6 +20,7 @@
 #include "vfs.h"
 #include "connection.h"
 #include "misc.h"
+#include "notify.h"
 #include "mgmt/tree_connect.h"
 #include "mgmt/user_session.h"
 #include "mgmt/user_config.h"
@@ -914,6 +915,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 
 	/* Remove lookup entries before dropping the file's inode reference. */
 	ksmbd_file_lock_clear(fp);
+	ksmbd_notify_remove(fp);
 	__ksmbd_inode_close(fp);
 	if (!IS_ERR_OR_NULL(filp))
 		fput(filp);
@@ -1491,6 +1493,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
 	spin_lock_init(&fp->f_lock);
+	mutex_init(&fp->notify_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index c00d92fdf94a..25721c257791 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -34,6 +34,7 @@
 #define SMB2_NO_FID		(0xFFFFFFFFFFFFFFFFULL)
 
 struct ksmbd_conn;
+struct ksmbd_notify;
 struct ksmbd_session;
 struct ksmbd_file;
 
@@ -108,6 +109,9 @@ struct ksmbd_file {
 	u64				durable_volatile_id;
 
 	spinlock_t			f_lock;
+	/* Protects notify watch creation and removal. */
+	struct mutex			notify_lock;
+	struct ksmbd_notify		*notify;
 
 	struct ksmbd_inode		*f_ci;
 	struct ksmbd_inode		*f_parent_ci;
-- 
2.55.0

