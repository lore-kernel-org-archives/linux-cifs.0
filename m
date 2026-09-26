Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129034250E
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413576; cv=none; b=UeXrQAQInboNUpSG6c9gZS4XAZPnU2H9zJMhGIIMlHeHMiKE+vzBAcvQkyEzPI/luYC8x0trErGqe22E6O6Xxqz7jP5/u8FbtYmJiXyYu6FAvJX5U8OneRk0UN45LXZTQF0YwVBZ8NZg+y3VKXwtbmZEAyQ96bXClu9GQP/HNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413576; c=relaxed/simple;
	bh=UCCyxr3w+kA/h8vNRrvaEkhEIyMdbgXhqKo1EPduvr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRs8jU5548T2BcwGU4wYyv94ixZft3pvfmpII2i+83CsJaMQE44Mjv8rTxWOsEZ24QmQItO/9mDXvtnkL4IGupYn+Q77AIa2+4lxz4u0XXpug1zQmNN+no0w9uPDaVHXFz64iCeuJq5UGe3k0d1Es3BhNlqsHnUwMQaah1nJDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=pLeii/pC; arc=none smtp.client-ip=91.218.175.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="pLeii/pC"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UCCyxr3w+kA/h8vNRrvaEkhEIyMdbgXhqKo1EPduvr0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413567; v=1; x=1791018367;
 b=pLeii/pCjvQYHFdpCJU4gLliEu+ZQ/0rUMhtu6lPJAuBdfc3VnIGMAv1gn/491oijDi1HGKV
 KNQvuiKPQ196P9tjs57EHahd7pW/pMiVkpQFu+oBxjru/02wc0BH0qw1SKavWR7JDXrF3pVmi8+
 mNUhR1K2biVaot6QRNiq67FoWjfoEFQghs0f0zOHw65i1I5ePGZdvveQCm+K2gspxqXPPwG9VtK
 sxVYu3zFzsKElv713WykRRCEJ2iRXDYjmp51osSxz1zfr0KD6YOWbHYavTaAxZMYFZnbwOYi+HV
 ligqmGn2bWwQK5vJWXNeciMmYF1UyqlE+mw5hFt0iu2QQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ff395344ff36bd0e;
	Sat, 26 Sep 2026 09:06:07 +0000
X-Mizu-Trace-ID: ff395344ff36bd0e
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 01/12] smb/server: move change notify handling into notify.c
Date: Sat, 26 Sep 2026 09:05:07 +0000
Message-ID: <20260926090518.78547-2-chenxiaosong@chenxiaosong.com>
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

Move the SMB2 CHANGE_NOTIFY implementation out of smb2pdu.c into a
dedicated notify.c file.

Factor out two helper functions ksmbd_notify_validate_req() and
ksmbd_notify_wait().

No functional change.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Makefile  |   3 +-
 fs/smb/server/notify.c  | 183 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h  |  24 ++++++
 fs/smb/server/smb2pdu.c | 110 +-----------------------
 4 files changed, 213 insertions(+), 107 deletions(-)
 create mode 100644 fs/smb/server/notify.c
 create mode 100644 fs/smb/server/notify.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 9bc87695a53c..5daae1727b32 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -10,7 +10,8 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
 		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
-		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o
+		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o \
+		notify.o
 
 $(obj)/asn1.o: $(obj)/ksmbd_spnego_negtokeninit.asn1.h $(obj)/ksmbd_spnego_negtokentarg.asn1.h
 
diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
new file mode 100644
index 000000000000..7e324af36b47
--- /dev/null
+++ b/fs/smb/server/notify.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *
+ *   SMB2 CHANGE_NOTIFY
+ *
+ *   Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ *
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *              Gael Blivet <gael.blivet@gmail.com>
+ *
+ */
+
+#include "glob.h"
+#include "../common/smb2status.h"
+#include "connection.h"
+#include "ksmbd_work.h"
+#include "notify.h"
+#include "smb_common.h"
+#include "smb2pdu.h"
+#include "vfs_cache.h"
+#include "mgmt/user_session.h"
+
+struct ksmbd_notify_req {
+	wait_queue_head_t wait;
+};
+
+/*
+ * Cancel handler for a pending CHANGE_NOTIFY. Called either by
+ * smb2_cancel() (conn->request_lock held, work->state already set to
+ * KSMBD_WORK_CANCELLED by the caller) or by
+ * set_close_state_blocked_works() (vfs_cache.c, fp->f_lock held,
+ * work->state already set to KSMBD_WORK_CLOSED by the caller) -- both
+ * callers hold a spinlock across this call, so it must not sleep.
+ * wake_up() only wakes the waiter in smb2_notify(); it does not touch
+ * fp->blocked_works itself, matching smb2_remove_blocked_lock()'s same
+ * non-mutating style for the equivalent byte-range-lock wait.
+ */
+static void smb2_notify_cancel(void **argv)
+{
+	struct ksmbd_notify_req *notify_req = argv[0];
+
+	wake_up(&notify_req->wait);
+}
+
+static struct ksmbd_file *
+ksmbd_notify_validate_req(struct ksmbd_work *work,
+			  struct smb2_change_notify_req *req,
+			  struct smb2_change_notify_rsp *rsp)
+{
+	struct ksmbd_file *fp;
+
+	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
+		pr_err("Notify request is not the last compound command\n");
+		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
+		return ERR_PTR(-EIO);
+	}
+
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId,
+				  req->PersistentFileId);
+	if (!fp) {
+		pr_err("Invalid file id for notify, fid %llu:%llu\n",
+		       le64_to_cpu(req->PersistentFileId),
+		       le64_to_cpu(req->VolatileFileId));
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		return ERR_PTR(-ENOENT);
+	}
+
+	return fp;
+}
+
+static int ksmbd_notify_wait(struct ksmbd_work *work,
+			     struct ksmbd_file *fp,
+			     struct ksmbd_notify_req *notify_req)
+{
+	int err;
+
+	/*
+	 * Handle close holds the file-table write lock while it marks the
+	 * handle closed and walks blocked_works.  Hold the matching read lock
+	 * across the state check and registration so close cannot finish its
+	 * walk between the lookup above and this list insertion.
+	 */
+	read_lock(&work->sess->file_table.lock);
+	if (fp->f_state != FP_INITED) {
+		read_unlock(&work->sess->file_table.lock);
+		return -ENOENT;
+	}
+	spin_lock(&fp->f_lock);
+	list_add_tail(&work->fp_entry, &fp->blocked_works);
+	spin_unlock(&fp->f_lock);
+	read_unlock(&work->sess->file_table.lock);
+
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	err = wait_event_interruptible(notify_req->wait,
+				       READ_ONCE(work->state) !=
+					       KSMBD_WORK_ACTIVE);
+	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
+		pr_err("Notify wait interrupted, async id %d: %d\n",
+		       work->async_id, err);
+		/*
+		 * Woken by a signal, not a real cancel/close. There is no
+		 * notification backend yet to report anything else against,
+		 * so treat this the same as a client-side cancel.
+		 */
+		WRITE_ONCE(work->state, KSMBD_WORK_CANCELLED);
+	}
+
+	spin_lock(&fp->f_lock);
+	list_del_init(&work->fp_entry);
+	spin_unlock(&fp->f_lock);
+
+	return err;
+}
+
+/**
+ * ksmbd_handle_notify() - handle an SMB2 change notify request
+ * @work: smb work containing notify command buffer
+ * @req: SMB2 change notify request
+ * @rsp: SMB2 change notify response
+ *
+ * Return: 0 on success, otherwise error
+ */
+int ksmbd_handle_notify(struct ksmbd_work *work,
+			struct smb2_change_notify_req *req,
+			struct smb2_change_notify_rsp *rsp)
+{
+	struct ksmbd_notify_req notify_req = {};
+	struct ksmbd_file *fp = NULL;
+	void **argv = NULL;
+	bool async_work = false;
+	int err = 0;
+
+	fp = ksmbd_notify_validate_req(work, req, rsp);
+	if (IS_ERR(fp)) {
+		err = PTR_ERR(fp);
+		fp = NULL;
+		goto out;
+	}
+
+	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
+	if (!argv) {
+		pr_err("Failed to allocate notify cancel arguments\n");
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		err = -ENOMEM;
+		goto out;
+	}
+	init_waitqueue_head(&notify_req.wait);
+	argv[0] = &notify_req;
+
+	err = setup_async_work(work, smb2_notify_cancel, argv);
+	if (err) {
+		pr_err("Failed to set up asynchronous notify work: %d\n", err);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		goto out;
+	}
+	async_work = true;
+
+	err = ksmbd_notify_wait(work, fp, &notify_req);
+	if (err == -ENOENT) {
+		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
+		goto out;
+	}
+
+	if (work->state == KSMBD_WORK_CLOSED) {
+		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
+	} else {
+		rsp->hdr.Status = STATUS_CANCELLED;
+	}
+	smb2_send_interim_resp(work, rsp->hdr.Status);
+	work->send_no_response = 1;
+
+out:
+	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
+		smb2_set_err_rsp(work);
+	if (async_work)
+		release_async_work(work);
+	else
+		kfree(argv);
+	if (fp)
+		ksmbd_fd_put(work, fp);
+	return err;
+}
diff --git a/fs/smb/server/notify.h b/fs/smb/server/notify.h
new file mode 100644
index 000000000000..8de46e07b02e
--- /dev/null
+++ b/fs/smb/server/notify.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *
+ *   SMB2 CHANGE_NOTIFY
+ *
+ *   Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ *
+ *   Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *              Gael Blivet <gael.blivet@gmail.com>
+ *
+ */
+
+#ifndef __SMB_SERVER_NOTIFY_H__
+#define __SMB_SERVER_NOTIFY_H__
+
+struct ksmbd_work;
+struct smb2_change_notify_req;
+struct smb2_change_notify_rsp;
+
+int ksmbd_handle_notify(struct ksmbd_work *work,
+			struct smb2_change_notify_req *req,
+			struct smb2_change_notify_rsp *rsp);
+
+#endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7b9080508a3f..1f45a0836fe9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -33,6 +33,7 @@
 #include "vfs.h"
 #include "vfs_cache.h"
 #include "misc.h"
+#include "notify.h"
 
 #include "server.h"
 #include "smb_common.h"
@@ -11818,28 +11819,6 @@ int smb2_oplock_break(struct ksmbd_work *work)
 	return 0;
 }
 
-struct ksmbd_notify_req {
-	wait_queue_head_t wait;
-};
-
-/*
- * Cancel handler for a pending CHANGE_NOTIFY. Called either by
- * smb2_cancel() (conn->request_lock held, work->state already set to
- * KSMBD_WORK_CANCELLED by the caller) or by
- * set_close_state_blocked_works() (vfs_cache.c, fp->f_lock held,
- * work->state already set to KSMBD_WORK_CLOSED by the caller) -- both
- * callers hold a spinlock across this call, so it must not sleep.
- * wake_up() only wakes the waiter in smb2_notify(); it does not touch
- * fp->blocked_works itself, matching smb2_remove_blocked_lock()'s same
- * non-mutating style for the equivalent byte-range-lock wait.
- */
-static void smb2_notify_cancel(void **argv)
-{
-	struct ksmbd_notify_req *notify_req = argv[0];
-
-	wake_up(&notify_req->wait);
-}
-
 /**
  * smb2_notify() - handler for smb2 notify request
  * @work:   smb work containing notify command buffer
@@ -11850,98 +11829,17 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
-	struct ksmbd_notify_req notify_req;
-	struct ksmbd_file *fp = NULL;
-	void **argv = NULL;
-	bool async_work = false;
-	int err = 0;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
 	WORK_BUFFERS(work, req, rsp);
 
-	if (smb2_compound_has_failed(work, &rsp->hdr))
+	if (smb2_compound_has_failed(work, &rsp->hdr)) {
+		pr_err("Failed compound notify request\n");
 		return -EACCES;
-
-	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
-		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
-		err = -EIO;
-		goto out;
-	}
-
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
-	if (!fp) {
-		rsp->hdr.Status = STATUS_FILE_CLOSED;
-		err = -ENOENT;
-		goto out;
-	}
-
-	argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
-	if (!argv) {
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-		err = -ENOMEM;
-		goto out;
-	}
-	init_waitqueue_head(&notify_req.wait);
-	argv[0] = &notify_req;
-
-	err = setup_async_work(work, smb2_notify_cancel, argv);
-	if (err) {
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-		goto out;
-	}
-	async_work = true;
-
-	/*
-	 * Handle close holds the file-table write lock while it marks the
-	 * handle closed and walks blocked_works.  Hold the matching read lock
-	 * across the state check and registration so close cannot finish its
-	 * walk between the lookup above and this list insertion.
-	 */
-	read_lock(&work->sess->file_table.lock);
-	if (fp->f_state != FP_INITED) {
-		read_unlock(&work->sess->file_table.lock);
-		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
-		err = -ENOENT;
-		goto out;
 	}
-	spin_lock(&fp->f_lock);
-	list_add_tail(&work->fp_entry, &fp->blocked_works);
-	spin_unlock(&fp->f_lock);
-	read_unlock(&work->sess->file_table.lock);
 
-	smb2_send_interim_resp(work, STATUS_PENDING);
-
-	err = wait_event_interruptible(notify_req.wait,
-				       READ_ONCE(work->state) != KSMBD_WORK_ACTIVE);
-	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
-		/*
-		 * Woken by a signal, not a real cancel/close. There is no
-		 * notification backend yet to report anything else against,
-		 * so treat this the same as a client-side cancel.
-		 */
-		WRITE_ONCE(work->state, KSMBD_WORK_CANCELLED);
-	}
-
-	spin_lock(&fp->f_lock);
-	list_del_init(&work->fp_entry);
-	spin_unlock(&fp->f_lock);
-
-	rsp->hdr.Status = work->state == KSMBD_WORK_CLOSED ?
-			  STATUS_NOTIFY_CLEANUP : STATUS_CANCELLED;
-	smb2_send_interim_resp(work, rsp->hdr.Status);
-	work->send_no_response = 1;
-
-out:
-	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
-		smb2_set_err_rsp(work);
-	if (async_work)
-		release_async_work(work);
-	else
-		kfree(argv);
-	if (fp)
-		ksmbd_fd_put(work, fp);
-	return err;
+	return ksmbd_handle_notify(work, req, rsp);
 }
 
 /**
-- 
2.55.0

