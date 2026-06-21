Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D3472621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046136; cv=none; b=gT/xMFkdDhhDJD9vDPXJzq2+0GoWXkJGzVVcRgZWzmu1EY/4vsLtnsMgEzjg1zT3AeYphZdIt3wggtbS94ghoKYX9JxTsYZIZeV2qcQT1fS8/I4a5/Iq/7UhBJW5hvlf96We4akuUhB1Q1liD9v/zrkNg6AJHvOHcIuwAiHy2Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046136; c=relaxed/simple;
	bh=4VMvJMXX3n4zeTGscNYRIXTtd5wOYpXUEbgC9LQRIQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vvhu1wuw0MAhpPTMpPZmcLFyoGTT4TLd2ZjYgyEcSEfFIGuw0/K57fh4bCgoxPqzjks7smDqzqstq+SMwZ4HSLvQFjd5o4urG02fKid+2syGpEQRCKE/uBU2gcnQoEH5Hdw3VMBgVEwbdTCR0bLpGrNuZfMFTkoKP6nt0ap1UXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njrmm0Az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njrmm0Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B591F00A3A;
	Sun, 21 Jun 2026 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046134;
	bh=LwwXlgFYQrR2HgVLJLnzeeh+Pj6qZOy8YOOUB2K2Xdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njrmm0AzT39aegMz53wD9ldox8SXhQVdayHHAGrvg6RsQ/+Tj1dpTfOcNrV1kzN7p
	 NVPf9nvRHXYfxHO7nJMPhw9RxYY7Gc1OpPf4CpBuKm1GrO3GoEJoQOQphDixtCqekb
	 M2+89eY/vNAAzHXSdr8xyV++xaOh0aNTlYCwMMbFlPBkFkX2woCzAeG04WQjotET63
	 kjp9BhUcgt08betxCTqvHPjjDiwwsjQJ4qfkdaQVaSZjiyPR114W5jDh0SeEYUFqv8
	 TKLw/lHZ8fg/HsMM9Xa+7bVItDAN+iTOY2ZJcl8NrvjoSwvoQSfsnmBqbRozOrLrr0
	 aOXgtjQN+rZ+Q==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/29] ksmbd: supersede disconnected delete-on-close durable handle
Date: Sun, 21 Jun 2026 21:48:17 +0900
Message-Id: <20260621124844.6235-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A durable handle opened with FILE_DELETE_ON_CLOSE is preserved across a
disconnect so it can be reclaimed by a durable reconnect.
smb2.durable-open.delete_on_close2 disconnects such a handle and then
reconnects it, expecting the reconnect to succeed.

When the client does not reconnect but instead opens the same name with a
new delete-on-close create, the preserved handle keeps the file present
with delete-on-close set. ksmbd then rejects the new open with
STATUS_ACCESS_DENIED on the file_present + FILE_DELETE_ON_CLOSE +
OPEN_IF/OVERWRITE_IF path. smb2.durable-open.delete_on_close1 expects this
open to create a fresh, empty file instead, i.e. the disconnected handle's
delete-on-close must take effect first.

Add ksmbd_close_disconnected_durable_delete_on_close(), which closes
disconnected (conn == NULL) durable handles that keep a delete-on-close
file present. The final close promotes S_DEL_ON_CLS to S_DEL_PENDING and
unlinks the file, so a re-resolved path is absent and the new open creates
it fresh. Call it from smb2_open() before the delete-on-close conflict
check, only for the conflicting open shapes. A live (connected) handle
still keeps the file and blocks the open as before.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 17 ++++++++++++
 fs/smb/server/vfs_cache.c | 57 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 75 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2bc275ed450a..37a20c5740cd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3272,6 +3272,23 @@ int smb2_open(struct ksmbd_work *work)
 
 	rc = ksmbd_vfs_kern_path(work, name, LOOKUP_NO_SYMLINKS,
 				 &path, 1);
+
+	/*
+	 * A durable handle opened with delete-on-close is preserved across a
+	 * disconnect so it can be reclaimed by a durable reconnect.  When a new
+	 * delete-on-close open for the same name arrives instead, the
+	 * disconnected handle must give way: close it so its delete-on-close
+	 * removes the file, then re-resolve so this open can create a fresh one.
+	 */
+	if (!rc && (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) &&
+	    (req->CreateDisposition == FILE_OVERWRITE_IF_LE ||
+	     req->CreateDisposition == FILE_OPEN_IF_LE) &&
+	    ksmbd_close_disconnected_durable_delete_on_close(path.dentry)) {
+		path_put(&path);
+		rc = ksmbd_vfs_kern_path(work, name, LOOKUP_NO_SYMLINKS,
+					 &path, 1);
+	}
+
 	if (!rc) {
 		file_present = true;
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 39c56942ae44..96fa3f160d5b 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -517,6 +517,63 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	kmem_cache_free(filp_cache, fp);
 }
 
+/**
+ * ksmbd_close_disconnected_durable_delete_on_close() - drop a delete-on-close
+ *	file kept present only by disconnected durable handles
+ * @dentry:	dentry of the file being opened
+ *
+ * A durable handle opened with delete-on-close is preserved across a
+ * disconnect so it can be reclaimed by a durable reconnect.  When a new
+ * (non-reconnect) open arrives for the same name instead, the disconnected
+ * handle has to give way.  Close such handles so their delete-on-close is
+ * applied and the file is removed once the last handle is gone, letting the
+ * new open create a fresh file.
+ *
+ * The caller's inode reference is dropped before closing so that the final
+ * close can promote S_DEL_ON_CLS to S_DEL_PENDING and unlink the file.
+ *
+ * Return:	true if a disconnected durable handle was closed.
+ */
+bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry)
+{
+	struct ksmbd_inode *ci;
+	struct ksmbd_file *fp, *tmp;
+	LIST_HEAD(dispose);
+	bool closed = false;
+
+	ci = ksmbd_inode_lookup_lock(dentry);
+	if (!ci)
+		return false;
+
+	down_write(&ci->m_lock);
+	if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_ON_CLS_STREAM | S_DEL_PENDING)) {
+		list_for_each_entry_safe(fp, tmp, &ci->m_fp_list, node) {
+			if (fp->conn || !fp->is_durable ||
+			    fp->f_state != FP_INITED)
+				continue;
+			list_move_tail(&fp->node, &dispose);
+		}
+	}
+	up_write(&ci->m_lock);
+
+	/*
+	 * Drop our lookup reference before closing so the last __ksmbd_close_fd()
+	 * can drop m_count to zero and unlink the delete-on-close file.  The
+	 * collected handles still hold references, so ci stays valid until they
+	 * are closed below.
+	 */
+	ksmbd_inode_put(ci);
+
+	while (!list_empty(&dispose)) {
+		fp = list_first_entry(&dispose, struct ksmbd_file, node);
+		list_del_init(&fp->node);
+		__ksmbd_close_fd(NULL, fp);
+		closed = true;
+	}
+
+	return closed;
+}
+
 static struct ksmbd_file *ksmbd_fp_get(struct ksmbd_file *fp)
 {
 	if (fp->f_state != FP_INITED)
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index a3a9fda6de91..21c24956c7c2 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -160,6 +160,7 @@ struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,
 void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
 struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d);
 void ksmbd_inode_put(struct ksmbd_inode *ci);
+bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry);
 struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
-- 
2.25.1

