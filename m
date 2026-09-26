Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428B03A1D01
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413647; cv=none; b=RJLbdL7n90YDinWQcvsSYUr4xpxW/imrOg7zvwXdml1fc90Itg36oCigW+eiyIQeBw/ByT7+UVNS6fsFAPTmitwbMCQHg+H61MiahRVlvqs9lZrS86e+jRKONIT7t0193dw66dTvu2j8M/a2oa1+gloTkFEhyK6E+zNHyZwcqaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413647; c=relaxed/simple;
	bh=fszzHDdu4RttQdSOur0FMvx1mXM9EZgOIuFAlOZ10jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/qvryAQAoSu5EHzmJIhd036z4W+LF9aVGuzyjxvFQ1YUQ+jL5R2yH1S87x3m8mf3mKO69qt5sNWxHUxzPRPApjp0OZWcrm6gNMH/6nTib9TtCr1b72OhO0GOZxeUVcf+YwGiXor3TtR6tABPl0tNpD9oeg1meXBDkb2hNRAfdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GkW/pj2V; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GkW/pj2V"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fszzHDdu4RttQdSOur0FMvx1mXM9EZgOIuFAlOZ10jU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413643; v=1; x=1791018443;
 b=GkW/pj2VCRRAqWA/7SvgWEB6jv/ukgr1QH07xOCgz1ykrU+BJO6I5HfdXC4wDICf5M5XbW5y
 E7jOIe5RBl+X2p8T9wREyNZ4xDLMA4S/IYIWJNK0RB20+ZTYtVve9bVMQp0bB4iV3oDPc095KAX
 /8CeM8Xcj771wkLVXrKsjHJUNMIE/wUqK9xnnEk9vCOFzHNgclxuUvBcQKgI2SCrZEXjlJ+JZeC
 aY2XjLjE6ZRx9n/q3rpznpi/gxhY4AwO3YMPUCXPW/AkNYzDeiIwPD2pXId+hJXGxRLX2eVcsEo
 6BGvEQgRGu8FjfmLR1zOPSnsTDJ2VT/vB7CKD6gfCal5Q==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a3b25fb74849f06b;
	Sat, 26 Sep 2026 09:07:23 +0000
X-Mizu-Trace-ID: a3b25fb74849f06b
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 12/12] smb/server: break directory leases before sending notify events
Date: Sat, 26 Sep 2026 09:05:18 +0000
Message-ID: <20260926090518.78547-13-chenxiaosong@chenxiaosong.com>
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

Reproducer:

  1. ksmbd: `ksmbd.conf`:
     [global]
             smb2 leases = yes
  2. ksmbd: systemctl start ksmbd
  3. Windows 11 File Explorer:
     Mount the share and enter the top-level directory of the mount point.
  4. ksmbd: touch /export/file
  5. Windows 11 File Explorer:
     `file` does not appear in the top-level directory of the mount point.

Windows can keep directory data in a cache while it has a directory
lease. A file change made on the server does not use the SMB request
path, so the lease is not broken.

The server sends a notify event, but Windows may still use the old data.
Some new files are then not shown in File Explorer.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 34 +++++++++++++++++++++++++++++++---
 fs/smb/server/oplock.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/oplock.h |  1 +
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index dc62b5d6d17d..ff014f856ac9 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -18,6 +18,7 @@
 #include "connection.h"
 #include "ksmbd_work.h"
 #include "notify.h"
+#include "oplock.h"
 #include "smb_common.h"
 #include "smb2pdu.h"
 #include "vfs_cache.h"
@@ -361,13 +362,34 @@ static void ksmbd_notify_broadcast(struct ksmbd_notify *notify)
 	spin_unlock(&notify->lock);
 }
 
+static bool ksmbd_notify_events_pending(struct ksmbd_notify *notify)
+{
+	bool pending;
+
+	spin_lock(&notify->lock);
+	pending = !list_empty(&notify->events);
+	spin_unlock(&notify->lock);
+
+	return pending;
+}
+
+/* Invalidate directory caches before making the change visible to a client. */
+static void ksmbd_notify_dispatch(struct ksmbd_notify *notify)
+{
+	if (!ksmbd_notify_events_pending(notify))
+		return;
+
+	smb_break_dir_lease(notify->fp);
+	ksmbd_notify_broadcast(notify);
+}
+
 static void ksmbd_notify_broadcast_work(struct work_struct *work)
 {
 	struct ksmbd_notify *notify;
 
 	notify = container_of(to_delayed_work(work), struct ksmbd_notify,
 			      broadcast_work);
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 }
 
 static int ksmbd_notify_handle_inode_event(struct ksmbd_notify *notify,
@@ -731,6 +753,12 @@ ksmbd_notify_take_events(struct ksmbd_notify *notify, struct list_head *events)
 {
 	unsigned int num_events;
 
+	if (!ksmbd_notify_events_pending(notify))
+		return 0;
+
+	/* This path bypasses broadcast_work, so break directory leases here. */
+	smb_break_dir_lease(notify->fp);
+
 	spin_lock(&notify->lock);
 	num_events = notify->num_events;
 	if (num_events && ksmbd_notify_wake_waiter(notify)) {
@@ -762,7 +790,7 @@ ksmbd_notify_requeue_events(struct ksmbd_notify *notify,
 	notify_req->num_events = 0;
 	spin_unlock(&notify->lock);
 
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 }
 
 static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
@@ -1033,7 +1061,7 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	read_unlock(&work->sess->file_table.lock);
 
 	/* Close the race between the synchronous check and queuing the waiter. */
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 
 	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
 		    work->async_id);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 1b8c3482d1e4..ec2ee2acca35 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1526,6 +1526,46 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	ksmbd_inode_put(p_ci);
 }
 
+/**
+ * smb_break_dir_lease() - break leases when a directory changes
+ * @fp: open directory that changed
+ *
+ * Some directory changes do not go through the SMB request path. fsnotify
+ * reports these changes. Break the directory leases before sending the
+ * changes to the SMB client.
+ *
+ * This function can sleep while it waits for a reply from the client. Do not
+ * call it from the fsnotify callback.
+ */
+void smb_break_dir_lease(struct ksmbd_file *fp)
+{
+	struct ksmbd_inode *ci = fp->f_ci;
+	struct oplock_info *opinfo;
+	LIST_HEAD(brk_list);
+
+	down_read(&ci->m_lock);
+	list_for_each_entry(opinfo, &ci->m_op_list, op_entry) {
+		if (!opinfo->conn || !opinfo->is_lease ||
+		    !opinfo->o_lease->is_dir ||
+		    opinfo->o_lease->state == SMB2_LEASE_NONE_LE)
+			continue;
+
+		if (!atomic_inc_not_zero(&opinfo->refcount))
+			continue;
+
+		if (ksmbd_conn_releasing(opinfo->conn)) {
+			opinfo_put(opinfo);
+			continue;
+		}
+
+		if (oplock_break_add(&brk_list, opinfo))
+			opinfo_put(opinfo);
+	}
+	up_read(&ci->m_lock);
+
+	oplock_break_drain_none(&brk_list, ci);
+}
+
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index b08d21758e07..72ebcbacd2be 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -137,6 +137,7 @@ int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx);
+void smb_break_dir_lease(struct ksmbd_file *fp);
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp);
 int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 			      struct ksmbd_share_config *share,
-- 
2.55.0

