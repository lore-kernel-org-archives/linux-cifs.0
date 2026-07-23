Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B03019A9
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776721; cv=none; b=qe8t/5cRfvjkC+U0z2ApeCfoyCEAkXf5DEl0PugxT4W0ZEFlrNJiKWo+bNAy9upOBFHJLhDRuLDohywHrRCWcgqs6xzjE7XMTDmC5auj7m2tJIHzKarzHiaCSnc1sFaw9Od+vLjg9Mct584QmcrR6kVQONnO37clBJEPtHJfUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776721; c=relaxed/simple;
	bh=8V900e12M6ykLtlLtz+EQELaKDLnbxyuAEltCQtcS1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0HSY5FjcjUTE6qKPlA7j82J+o5sGDpMd7kBAAPBTFxxKHBp0Cq9I9fd6OjXFJxyd5GWRarCECJe1jsaGXuLYAKMi0L041aWOKIRRXAyQZmNDMF9G2p0+IaNKQTEv3cF6AzOiorMP9kiF5lCt6Mc5PlG7j0rHA1LeWLWA2x46oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=W8v0PREN; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="W8v0PREN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9l9J+6+KLO2jaKSLwtBUfXnZV7eTqa74vr6xjv972yc=;
	b=W8v0PRENjIkKLD2MiAqrHhLqSHrkwmU1SR6tvdVM1i0ZhwvjxU6VX0qGqGVFVhrvA++t6d
	jUt2ddXio+hMm4gQtr0eSLXeHTdiPZpoAM6IJa1Tmg2VwCc+lw/vjqE8h/DBx+iwBygr0Y
	JzrxwLJCcmMxByT3Zsg7rUanSIHyaccnzZ5k4FAFy2Yx2m5+1xnY4KD1xIO+ePaGhC/NPU
	QIgcIu42RAzOICv8/GwHdgb4s10QlqRR795b+xKV6d8QkVqy20WrgYGY15Z+Uyey5cMIOX
	P3DrgHVykDzNxR6kBEPNIAwky4LHSGhfhV/slHE+O6nS3s6didOqdqj0MJ+v3w==
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
Subject: [RFC PATCH 11/11] smb/server: break directory leases before sending notify events
Date: Thu, 23 Jul 2026 03:16:39 +0000
Message-ID: <20260723031644.312866-12-chenxiaosong@chenxiaosong.com>
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
index 63e7ed7d615c..1b27c17a8aef 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -21,6 +21,7 @@
 #include "connection.h"
 #include "ksmbd_work.h"
 #include "notify.h"
+#include "oplock.h"
 #include "smb_common.h"
 #include "smb2pdu.h"
 #include "vfs_cache.h"
@@ -346,13 +347,34 @@ static void ksmbd_notify_broadcast(struct ksmbd_notify *notify)
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
 
 static int ksmbd_notify_handle_inode_event(struct fsnotify_mark *mark,
@@ -576,6 +598,12 @@ ksmbd_notify_take_events(struct ksmbd_notify *notify, struct list_head *events)
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
 	if (num_events) {
@@ -605,7 +633,7 @@ ksmbd_notify_requeue_events(struct ksmbd_notify *notify,
 	notify_req->num_events = 0;
 	spin_unlock(&notify->lock);
 
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 }
 
 static int ksmbd_notify_event_cmp(void *priv, const struct list_head *a,
@@ -847,7 +875,7 @@ static int ksmbd_notify_wait(struct ksmbd_work *work,
 	spin_unlock(&fp->f_lock);
 
 	/* Close the race between the synchronous check and queuing the waiter. */
-	ksmbd_notify_broadcast(notify);
+	ksmbd_notify_dispatch(notify);
 
 	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
 		    work->async_id);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 591b2fca1d4e..6bd870e84cf6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1404,6 +1404,46 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
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
+	oplock_break_drain_none(&brk_list);
+}
+
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 23274b645ede..3f05fd684640 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -136,6 +136,7 @@ int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx);
+void smb_break_dir_lease(struct ksmbd_file *fp);
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp);
 int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 			      struct ksmbd_share_config *share,
-- 
2.54.0

