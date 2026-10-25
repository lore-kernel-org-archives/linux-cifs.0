Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917315;
	b=Yb0DAzQz0c4eu59SIJ0LjS1qHFxTFZ8+Dlbj82+O1L0pSDy8dtWu0ILz1N6o5FV76+VO
	 kanAkYS4KRY3ErjfXklMwbU1MQm3ZmoWeg5xHhEWn9EskS5Tc7Xd1EgM0n1dOCQDO1RbZ
	 oG2c8ALw7zCpW9kkjZG/mmk+zJjWt7xjqefj9HaY9orUYT4wCQ65na70fWf5CIg8fXtKe
	 QdpcO8DrG0ZPWz84RvRT9iO4lw4llUEWP2d+N/Q1g7FrSUuDDHv3ttZAiAuf6TdlpPH8Y
	 0G6p8AJwz7BKKRc9/MYsBci1V84uDiwdoRHnbMfXZPtZElLBKljgavD0+pYu/6YimEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917315;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QMi77ra/rEK4WUj+58tS+1QB73FcOShBiXVQrvxEtlc=;
	b=YJE18utE0p0IWq+RXAiL/UQU3UfvnBI2j12b3CMYsCRvI30B2c13PcbM8uRtlscKLS1b
	 /9qgjcwApSMbV0qUYX5IWdGOYjQIX3HJ6mK3Ac7GJ6JhqhJ50VAt1dAV/+XErumazaOKH
	 FeyLdKPpQ6WMpEorLxCZY34VWN4amOmY3DXKcL3ba/I04QO+5b09T/ZpNxpYx181oA/9b
	 stCP88OSwH2nrUHMeZfvt0Hdj2j9YZFMNUUyKmlNlLSGa6IalGHMEmkjx9upOe0FqNGgD
	 AASz6ynvOwOch38g6WEyvqzTb5MYWkAw2O/8/+hMzyzgxYVzlqHz/mtmRk62pv5yKQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=XZvpvDQF;
	arc=none smtp.remote-ip=95.215.58.134
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B112F606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B112F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=XZvpvDQF
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1M/T6/joFf9+812iDtZeGX949ErPfVHN1A5YchqjRl0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917312; v=1; x=1793522112;
 b=XZvpvDQFnHEGxHFBuYevWg3dsyuXbkVtFvQQv7Bfoinriv/yk1Rqx9yDREiL0a9i4aXLUOmw
 M6QekCrqr+NYEmzSNBFQNvnjE2AsAHSepaKObt9MZg7rholMw2w9PX77RWHbm2U/ES8qZ0+gZ4T
 +ouGdO4FCAvgiSw5nHzdwHQ4+yAvDyuPFAdKqAGM93bRLKyijY+DQ7LOaI9bbBrO+999I0+LfHW
 QoOohJSa2KflIay/sllOf275EHWktjMc0oLwodjQHUzXayPhOmWdb6LwcBlW8QlsHcOXnkYj3Ve
 4Jv25p7oZOiwhKlAlSEVdAV8KJYLeM/X0t9hMkeNV3D4w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6a90ae9644cf7f96;
	Sun, 25 Oct 2026 08:35:10 +0000
X-Mizu-Trace-ID: 6a90ae9644cf7f96
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 01/13] smb/server: move change notify handling into notify.c
Date: Sun, 25 Oct 2026 08:34:38 +0000
Message-ID: <20261025083450.212604-2-chenxiaosong@chenxiaosong.com>
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

Move the SMB2 CHANGE_NOTIFY implementation out of smb2pdu.c into a
dedicated notify.c file.

Factor out two helper functions ksmbd_notify_validate_req() and
ksmbd_notify_wait().

No functional change.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/Makefile  |   3 +-
 fs/smb/server/notify.c  | 179 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h  |  30 +++++++
 fs/smb/server/smb2pdu.c | 110 +-----------------------
 4 files changed, 215 insertions(+), 107 deletions(-)
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
index 000000000000..7bf55ee633c3
--- /dev/null
+++ b/fs/smb/server/notify.c
@@ -0,0 +1,179 @@
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
index 000000000000..eb2fc646208f
--- /dev/null
+++ b/fs/smb/server/notify.h
@@ -0,0 +1,30 @@
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
+#include <linux/wait.h>
+
+struct ksmbd_work;
+struct smb2_change_notify_req;
+struct smb2_change_notify_rsp;
+
+struct ksmbd_notify_req {
+	wait_queue_head_t wait;
+};
+
+int ksmbd_handle_notify(struct ksmbd_work *work,
+			struct smb2_change_notify_req *req,
+			struct smb2_change_notify_rsp *rsp);
+
+#endif /* __SMB_SERVER_NOTIFY_H__ */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5fe3cf8ba32..5ad78e3eee2d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -33,6 +33,7 @@
 #include "vfs.h"
 #include "vfs_cache.h"
 #include "misc.h"
+#include "notify.h"
 
 #include "server.h"
 #include "smb_common.h"
@@ -12466,28 +12467,6 @@ int smb2_oplock_break(struct ksmbd_work *work)
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
@@ -12498,98 +12477,17 @@ int smb2_notify(struct ksmbd_work *work)
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
 	}
 
-	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
-	if (!fp) {
-		rsp->hdr.Status = STATUS_FILE_CLOSED;
-		err = -ENOENT;
-		goto out;
-	}
-
-	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
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
-	}
-	spin_lock(&fp->f_lock);
-	list_add_tail(&work->fp_entry, &fp->blocked_works);
-	spin_unlock(&fp->f_lock);
-	read_unlock(&work->sess->file_table.lock);
-
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

