Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92914A8B;
	Sun, 12 Jan 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736695009; cv=none; b=rvMEmBeB3lUGC4L3+2vNt1mGWeyenRA5h8WPkfKebxxMyEHz0QRwQReE7XyCPRjlBNhqMptn5u8bi3w99ZH9QEFVHS6SbZHrySX3iZtJI5YTavZs5kT0mtX7EWAvTQKn9RgpSQA+NeIDkrUrI7d6Vv7Eo6I4FoBsw55IVXF5IvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736695009; c=relaxed/simple;
	bh=bHd4CknC46pqFA3EPRzbCIj0FZSUzusoE4Y3+QGpI/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4s9mHTsRT5HT23mSoKxQr0HWby0bG9EzMXXP7adJmzrZAzp6ENm7VUFcbLymU4Z5D4LbkHldEPGWrmXOPqDKA7uZRA/j8dZAJ05YwRtSTFLKo/1dza2XGBq0nBjUsnu3q4ofB+JNJUDRG7Bi0ZwtSBQGCWAh/q4Uum8CyTGnuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=laX8f18i; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="laX8f18i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=o4Hk1ER3vX4vB8BpoLIZWOLvqbOgav8WlZ34R/1uyY4=; b=laX8f18i5ZPPiX+A
	1GP80aad8e/SIbCeXCYrPji+0q02+RHJDprdAheZKXk/IyUkIJc6zA1QhjC7mH4tvDnVqvO0EhUOi
	WTrwW8Q3t230AqKJsRpzX8gfOiovih82L+J0RajOADFRTijGXLpSDnyNc2ZG6jX8IeUsZbVlZp1jg
	2EX8M4ORPWOWFj3UCMqjETHMdtt2c5/iR0YuroISpR47phFT7bTHoeCC2Jecss0xj7qx3rjEAfgcC
	YMlg9rUkg19qK9uFBWmFTTq/+js08qb/1ose2H41JVV4pM0ilCdEPufZ6B4INOl7GDDbE1y5jJxol
	L1YdL/APY2u1mFKvQQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tWzhe-009k0Y-0P;
	Sun, 12 Jan 2025 15:16:38 +0000
From: linux@treblig.org
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] ksmbd: Remove unused functions
Date: Sun, 12 Jan 2025 15:16:37 +0000
Message-ID: <20250112151637.275312-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ksmbd_rpc_rap() was added in 2021 as part of
commit 0626e6641f6b ("cifsd: add server handler for central processing and
tranport layers")

ksmbd_vfs_posix_lock_wait_timeout() was added in 2021 as part of
commit f44158485826 ("cifsd: add file operations")

both have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/smb/server/transport_ipc.c | 25 -------------------------
 fs/smb/server/transport_ipc.h |  2 --
 fs/smb/server/vfs.c           |  7 -------
 fs/smb/server/vfs.h           |  1 -
 4 files changed, 35 deletions(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index befaf42b84cc..e5049ea1d8b2 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -871,31 +871,6 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	return resp;
 }
 
-struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_session *sess, void *payload,
-					size_t payload_sz)
-{
-	struct ksmbd_ipc_msg *msg;
-	struct ksmbd_rpc_command *req;
-	struct ksmbd_rpc_command *resp;
-
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
-	if (!msg)
-		return NULL;
-
-	msg->type = KSMBD_EVENT_RPC_REQUEST;
-	req = (struct ksmbd_rpc_command *)msg->payload;
-	req->handle = ksmbd_acquire_id(&ipc_ida);
-	req->flags = rpc_context_flags(sess);
-	req->flags |= KSMBD_RPC_RAP_METHOD;
-	req->payload_sz = payload_sz;
-	memcpy(req->payload, payload, payload_sz);
-
-	resp = ipc_msg_send_request(msg, req->handle);
-	ipc_msg_handle_free(req->handle);
-	ipc_msg_free(msg);
-	return resp;
-}
-
 static int __ipc_heartbeat(void)
 {
 	unsigned long delta;
diff --git a/fs/smb/server/transport_ipc.h b/fs/smb/server/transport_ipc.h
index d9b6737f8cd0..e51850f1423b 100644
--- a/fs/smb/server/transport_ipc.h
+++ b/fs/smb/server/transport_ipc.h
@@ -41,8 +41,6 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 struct ksmbd_rpc_command *ksmbd_rpc_read(struct ksmbd_session *sess, int handle);
 struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle,
 					  void *payload, size_t payload_sz);
-struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_session *sess, void *payload,
-					size_t payload_sz);
 void ksmbd_ipc_release(void);
 void ksmbd_ipc_soft_reset(void);
 int ksmbd_ipc_init(void);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 40f08eac519c..6890016e1923 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1856,13 +1856,6 @@ void ksmbd_vfs_posix_lock_wait(struct file_lock *flock)
 	wait_event(flock->c.flc_wait, !flock->c.flc_blocker);
 }
 
-int ksmbd_vfs_posix_lock_wait_timeout(struct file_lock *flock, long timeout)
-{
-	return wait_event_interruptible_timeout(flock->c.flc_wait,
-						!flock->c.flc_blocker,
-						timeout);
-}
-
 void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock)
 {
 	locks_delete_block(flock);
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 06903024a2d8..2893f59803a6 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -140,7 +140,6 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 				struct dentry *dentry,
 				struct ksmbd_kstat *ksmbd_kstat);
 void ksmbd_vfs_posix_lock_wait(struct file_lock *flock);
-int ksmbd_vfs_posix_lock_wait_timeout(struct file_lock *flock, long timeout);
 void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock);
 int ksmbd_vfs_remove_acl_xattrs(struct mnt_idmap *idmap,
 				const struct path *path);
-- 
2.47.1

