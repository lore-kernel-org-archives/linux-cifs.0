Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917394;
	b=xTxPiAyJ2opbzFyF0+Rv3LTF32JjYE+cf+N8G5gHhZcGKIoK/YLyj/hlN3YF05lnrEpW
	 kpTJ6nv9EgDsHaUm+vjFcTYkeUsZo6yHYV8tPd5FziNQYqbFMuCR+4RK62t+xduXwFI/g
	 dC5KJb/VThioxUGd5aOf+kC9iWZf2JEOGVDemTziR2vQ+xgFcwLhRH/5Z8FmorK1aRuPM
	 aofczjJ1b8ymXQwuwcyLaAkZLm7SzHIOq3bbxvjp0X4S4zc+DfajYpkvWusXJ6j8y9MgL
	 QrraHzKSib0H7lBAkEyf7oVhLwzJaPBckI7kb8qhkf40Tyxj4kMjMcyCYVrUFlT/Ecg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917394;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EWeOKukq4SYjmnOeswVpeKcovy+S+01H8ZIuc5bQvzA=;
	b=oBQXHipBGVcgotnb1HHvefc5g/kRyfoBAyGojG3ss7LdZmXjuy5oKxDqW/ObM9Ow0l6g
	 ZcsnKfcYYLWP3DjR8G6VY27w0wdniapVdDqCP51A0KlreA7iY7IHh5S/0CJSQ0js0D484
	 FcidxfI1iPxnEjLCwa1LDQ0apkl2LjrPwKjT4rQ97MuOmwN6ffgA/i766Z0VKD8C7CZ6i
	 6pqg60fy+o9FLS8lqJkvxALwTLJjFa7/Ee1spxvhLLczGEnWO1Gf7iZikXjYWxEJg63xH
	 DuguiLSD/NOjHjRxOqvoZf2xcIv9czao15mSPsB+BtWR7VyvmfLBbgeRyeaLgV5schw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=YkNgfElV;
	arc=none smtp.remote-ip=91.218.175.74
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074F0606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 074F0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=YkNgfElV
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=r36aw4n4EeEMxQ1NvkSHmn0SEvawWDtCJtSYJeEHpko=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917392; v=1; x=1793522192;
 b=YkNgfElV5t5rTXuU705jOBtRFTFNc3I1DUhOVRBnHk9Pib4sXwufuLckbBnx39StGsZrjLb2
 ae80EgIavC2RIAHJ5mHv7ra22a1BlphxGzgUlOOOMnUqRACKGn3OCv5lgNz9u9xshf5sGwb+1Zb
 Mbv9BiDuy6IlgMPD7FnOkzUIwfxf9QjjPeUwyau+/ZUDHfI/aRFwbJkfPMovECceUN4ZbA2WX1T
 3c3DhZvKrqRnaxKHi3FLK3swJfvpQLqH4Qv63Ssk1GdFoTOCJ+LUBx/W0Kl3yNQVsTqnr0Kn1kc
 kzJdhMK7F8JUtG36fmAghuuMS9soH/J5s9lILfyzb8faw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8c1a9fe6b45334f7;
	Sun, 25 Oct 2026 08:36:32 +0000
X-Mizu-Trace-ID: 8c1a9fe6b45334f7
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 12/13] smb/server: break directory leases before sending notify events
Date: Sun, 25 Oct 2026 08:34:49 +0000
Message-ID: <20261025083450.212604-13-chenxiaosong@chenxiaosong.com>
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
index 7c8f36c0b951..8db3fd59990a 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -20,6 +20,7 @@
 #include "connection.h"
 #include "ksmbd_work.h"
 #include "notify.h"
+#include "oplock.h"
 #include "smb_common.h"
 #include "smb2pdu.h"
 #include "vfs_cache.h"
@@ -432,13 +433,34 @@ static void ksmbd_notify_broadcast(struct ksmbd_notify *notify)
 	spin_unlock(&notify->lock);
 }
 
+static bool ksmbd_notify_events_pending(struct ksmbd_notify *notify)
+{
+	bool pending;
+
+	spin_lock(&notify->lock);
+	pending = notify->overflow || !list_empty(&notify->events);
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
@@ -818,6 +840,12 @@ ksmbd_notify_take_events(struct ksmbd_notify *notify,
 {
 	bool pending;
 
+	if (!ksmbd_notify_events_pending(notify))
+		return false;
+
+	/* This path bypasses broadcast_work, so break directory leases here. */
+	smb_break_dir_lease(notify->fp);
+
 	spin_lock(&notify->lock);
 	pending = notify->overflow || notify->num_events;
 	if (pending && ksmbd_notify_wake_waiter(notify))
@@ -858,7 +886,7 @@ ksmbd_notify_requeue_events(struct ksmbd_notify *notify,
 	spin_unlock(&notify->lock);
 
 	ksmbd_notify_free_events(notify, &discard);
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 }
 
 static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
@@ -1133,7 +1161,7 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	read_unlock(&work->sess->file_table.lock);
 
 	/* Close the race between the synchronous check and queuing the waiter. */
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 
 	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
 		    work->async_id);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index d479508c06c5..9ded27df159f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1794,6 +1794,46 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
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
index d81013c514e3..00da63b6ae7e 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -130,6 +130,7 @@ int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 void destroy_lease_table(void);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx);
+void smb_break_dir_lease(struct ksmbd_file *fp);
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp);
 int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 			      struct ksmbd_share_config *share,
-- 
2.55.0

