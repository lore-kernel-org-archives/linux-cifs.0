Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57792E764D
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418501; cv=none; b=Jnjflq8xyq7RjEdklJPCJL1M2kX8Lyk1quKjYfhRh2TqALq6n8FWY/nGjuEc+JNd3V6QmYUxsMQz2BVPCddwBKXVBnQCCREEDP4Gh7pdKbX7rC196Yq/LzAjq4T8NVHWethPDMLOyri2dJqkEwqYD7JVTKmyBXEZTYDo1zfYH5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418501; c=relaxed/simple;
	bh=ZRapCMHL/GAdc+GEoyeKsASLmAdoxNihpp16EDDBiWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG4oLfFXa7M04B8MzLJja8ZLxjLx+tZV5H1YuwhzQyI7gtDCFHMPAjQK9NfK8C6Sf8fScQI+9tEylEEZnLjRymg+t99om7FxqXSBNLkLSD1QGB5lpvk/BdGy+xHhBiWMYq68JU+5YTyeKJQbz21YKnTFSoL8DxYgGKjxqRLbV84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=By6bM9Hu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="By6bM9Hu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so27577385e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418498; x=1784023298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LdwB6t4dx+ZAGA7pPzahryP70o7778niXyHHlOS+jFA=;
        b=By6bM9Hu+xiwUoBu5rTemOewOKx8/w2laIApKxSccRiOIncjNludAapDSuqBYvLx1g
         ZNFcywvkCxq3JKDkWrsBAs0m3OjVkBlKMQnjZp/t10htD1A1NnHgLwk2D8vk6po5j1y6
         Re3r7CVCjX53fDumfGSVzrOrcOEWNR1hxdwREJq9nqyGtcbgEub7Mvg3V8wb8qZpvRvb
         v0C0Kan6Aoqbieh4JeLWtqtJYThOrEyPVuQFH/ysFOZpCBUZFPh9mTxzldFXA2L9dXXf
         vX91lffdsjBhQZScsd7Pk8yzqs+f8zW0yNaU1BMgIen6yFakVfChaflfH4H9i7Ci3aOC
         A1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418498; x=1784023298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LdwB6t4dx+ZAGA7pPzahryP70o7778niXyHHlOS+jFA=;
        b=Y2q5fAIDyd696qGCZ1hCYP7bph+mmwDvJhoHqfZaS7Yx79wlVoR8t/vE4zcOJa9Ko4
         hkL+sN8fFo1WVHyiTt5W4qtKoN+HH2UgM3vD7zeoLDIWbASfpypuStbwl2i+nFa/Qlsj
         wgRMNr5RM4anK1W/+NzBZ6cG2BBVmnDVqtTZxGZzC7Kpu/R+zPf7YNxQQ8HRsgaBnvsR
         yfqNqhQbB5svZRu1pFctZ0tuYf6GlId4n4O/ZlLi8WBDa8e4FVNqj0aqdSno0kEAhiGY
         oakoIVyH3HL59TXyD4LqjTER5xtSmJbVWAhlT0YHfr+u/93iEU5hJnhqT4xg7hAgYUVf
         IRdA==
X-Forwarded-Encrypted: i=1; AHgh+RqAgMUmIPFN4IV8r5dPys4+KcKWFIjyNcDm8Rn6IeJP9NXuae1Hhqghbf8f36lDca1O3qyYSZieCUtu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0i+8BioyiECWHOncpzF2h5Dd3U7DXE4r3+Ft4lnEUExuRNe0K
	gJEv7KseeaY1XcI4zs6gG5UfTD+gd64SnPktvD066Gs+mM0/6oGsiQfu
X-Gm-Gg: AfdE7cl0fyh6BkxS2pd53+7BtO/JIIFIew1q0NkXPjonFP6V5s/WUuFNSM4Z5WunLg4
	4+A7EgubIzX+TJ0l6L3HtN+xPBHa4hEC82P2WgrxyaVtTWuF0FBNM+RbodFC7EnwxQLrrX1sFlB
	WK16KbFUel9pHBpaQ7nIrdh4a2Gg/vvu+vUxWOPuceV3x+aT47fDj0bWs2mQNZhffmqDfFcfXmQ
	N1HqEDuKLEokTFi98QXINQ7ia7YIyGoCPNvCxTBTxBmjv9WUX8SS9Ep26Eqb5knd83MDCjnlzqO
	3nFP65Gd369CbOTnUDnCGAScAxuB/CwNliFgQLNEJS/TFtTrSwQo7PWuxK9GYM+BPst5ScZ/xsU
	1WaUsstrLfYIWkGU+aXfxnlYDSQt4O9tbBlMjhLw60tyoFTzsR+hu02nbJmWRgqubkv3HSoaQ8F
	LY6pOOQBwQ5yN/QnE71uwvUmbN5o2vgnHSeiI=
X-Received: by 2002:a05:600c:6990:b0:493:bc4a:fb50 with SMTP id 5b1f17b1804b1-493df0777e5mr44273915e9.38.1783418495974;
        Tue, 07 Jul 2026 03:01:35 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm32203122f8f.8.2026.07.07.03.01.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:35 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 4/5] ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED
Date: Tue,  7 Jul 2026 12:01:27 +0200
Message-ID: <20260707100129.47563-5-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100129.47563-1-g.blivet@me.com>
References: <20260707100129.47563-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_notify() currently returns STATUS_NOT_IMPLEMENTED synchronously
for every CHANGE_NOTIFY request. Genuine SMB2 servers never complete a
CHANGE_NOTIFY spontaneously -- it's satisfied only by a real directory
change or with STATUS_NOTIFY_CLEANUP when the watched handle is
closed. macOS smbfs.kext depends on this deferred-completion contract:
receiving STATUS_NOT_IMPLEMENTED instead makes it hard-freeze on
unmount, since it never sees the cleanup it's waiting for.

Add a notify_pendings list on struct ksmbd_file (protected by the
existing f_lock) and a notify_entry list_head on struct ksmbd_work to
link onto it. smb2_notify() now replies STATUS_PENDING immediately and
queues a deferred STATUS_NOTIFY_CLEANUP response on the watched
handle; __ksmbd_close_fd() drains and sends any pending notifications
when the handle is actually closed. The drain splices the list out
under fp->f_lock first, then processes the detached copy without the
lock -- smb2_notify() on another connection can be adding to the same
list at the same time a close happens on this one, and
ksmbd_conn_write() can sleep (it takes the connection's write mutex),
so it must not be called while the spinlock is held.

Also handle the FileId=FFFF...FFFF share-root sentinel that macOS
backupd sends to watch for changes without holding an open handle --
without an immediate STATUS_PENDING/STATUS_NOTIFY_CLEANUP reply here,
backupd aborts Time Machine setup with STATUS_FILE_CLOSED.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/ksmbd_work.c |   1 +
 fs/smb/server/ksmbd_work.h |   2 +
 fs/smb/server/smb2pdu.c    | 108 +++++++++++++++++++++++++++++++++++--
 fs/smb/server/vfs_cache.c  |  30 +++++++++++
 fs/smb/server/vfs_cache.h  |   6 +++
 5 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index e2c2f4526..97502273a 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -56,6 +56,7 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 		INIT_LIST_HEAD(&work->request_entry);
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
+		INIT_LIST_HEAD(&work->notify_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
 		work->iov_alloc_cnt = ARRAY_SIZE(work->iov_inline);
 		work->iov = work->iov_inline;
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 88104f0cf..50c4aa779 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -104,6 +104,8 @@ struct ksmbd_work {
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
 	struct list_head                fp_entry;
+	/* List head at ksmbd_file->notify_pendings */
+	struct list_head                notify_entry;
 };
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b1be4df04..63beb2bcd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9966,6 +9966,9 @@ int smb2_notify(struct ksmbd_work *work)
 {
 	struct smb2_change_notify_req *req;
 	struct smb2_change_notify_rsp *rsp;
+	struct ksmbd_work *in_work;
+	struct smb2_hdr *in_hdr;
+	struct ksmbd_file *fp;
 
 	ksmbd_debug(SMB, "Received smb2 notify\n");
 
@@ -9980,9 +9983,108 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
 	}
 
-	smb2_set_err_rsp(work);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	return -EOPNOTSUPP;
+	/*
+	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
+	 * sentinel) to watch for changes on the share root without holding an
+	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
+	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
+	 */
+	if (req->VolatileFileId == SMB2_NO_FID &&
+	    req->PersistentFileId == SMB2_NO_FID) {
+		in_work = ksmbd_alloc_work_struct();
+		if (!in_work || allocate_interim_rsp_buf(in_work)) {
+			if (in_work)
+				ksmbd_free_work_struct(in_work);
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+			smb2_set_err_rsp(work);
+			return 0;
+		}
+		if (setup_async_work(work, NULL, NULL)) {
+			ksmbd_free_work_struct(in_work);
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+			smb2_set_err_rsp(work);
+			return 0;
+		}
+		smb2_send_interim_resp(work, STATUS_PENDING);
+		in_work->conn = work->conn;
+		in_hdr = smb_get_msg(in_work->response_buf);
+		memcpy(in_hdr, ksmbd_resp_buf_next(work),
+		       __SMB2_HEADER_STRUCTURE_SIZE);
+		in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+		in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
+		smb2_set_err_rsp(in_work);
+		in_hdr->Status = STATUS_NOTIFY_CLEANUP;
+		in_work->async_id = work->async_id;
+		work->async_id = 0;
+		release_async_work(work);
+		ksmbd_conn_write(in_work);
+		ksmbd_free_work_struct(in_work);
+		work->send_no_response = 1;
+		return 0;
+	}
+
+	/*
+	 * KSMBD does not implement a real change-notification backend.
+	 * Genuine SMB2 servers (and macOS smbfs) never complete a
+	 * CHANGE_NOTIFY spontaneously: it is satisfied only by a real
+	 * directory change, or with STATUS_NOTIFY_CLEANUP when the watched
+	 * handle is closed. Completing it early (e.g. on a timer) makes
+	 * Finder treat the cleanup as "directory changed" and re-enumerate
+	 * the directory forever, leaving items unopenable. Returning
+	 * STATUS_NOT_IMPLEMENTED here (like stock ksmbd) makes macOS smbfs
+	 * hard-freeze on unmount, so this must stay deferred.
+	 */
+	fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
+	if (!fp) {
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	in_work = ksmbd_alloc_work_struct();
+	if (!in_work || allocate_interim_rsp_buf(in_work)) {
+		if (in_work)
+			ksmbd_free_work_struct(in_work);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	if (setup_async_work(work, NULL, NULL)) {
+		ksmbd_free_work_struct(in_work);
+		ksmbd_fd_put(work, fp);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	in_work->conn = work->conn;
+	in_hdr = smb_get_msg(in_work->response_buf);
+	memcpy(in_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
+	in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+	in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
+	smb2_set_err_rsp(in_work);
+	in_hdr->Status = STATUS_NOTIFY_CLEANUP;
+
+	/*
+	 * Transfer ownership of the async id to in_work; it stays reserved
+	 * until in_work is freed after the deferred response is sent on
+	 * close, so it can't be reused for an unrelated async response.
+	 */
+	in_work->async_id = work->async_id;
+	work->async_id = 0;
+	release_async_work(work);
+
+	spin_lock(&fp->f_lock);
+	list_add_tail(&in_work->notify_entry, &fp->notify_pendings);
+	spin_unlock(&fp->f_lock);
+
+	ksmbd_fd_put(work, fp);
+	work->send_no_response = 1;
+	return 0;
 }
 
 /**
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 2543dd7e8..76ca47ca0 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -529,6 +529,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 {
 	struct file *filp;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
+	struct ksmbd_work *cn_work, *cn_tmp;
 
 	fd_limit_close();
 	ksmbd_remove_durable_fd(fp);
@@ -561,6 +562,34 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		kfree(smb_lock);
 	}
 
+	/*
+	 * Complete any CHANGE_NOTIFY left pending on this handle now that
+	 * it is closed. KSMBD never completes CHANGE_NOTIFY spontaneously
+	 * (no real change-notification backend), only on close -- matching
+	 * genuine SMB2/macOS smbfs semantics and avoiding the Finder
+	 * "directory changed, re-enumerate everything" loop.
+	 *
+	 * smb2_notify() on another connection can be adding to
+	 * notify_pendings under fp->f_lock at the same time this handle is
+	 * closed. Splice the list out under that same lock before touching
+	 * it, instead of walking it unlocked -- ksmbd_conn_write() can sleep
+	 * (it takes conn's write mutex), so it must not be called while
+	 * fp->f_lock is held.
+	 */
+	{
+		LIST_HEAD(cn_dispose);
+
+		spin_lock(&fp->f_lock);
+		list_splice_init(&fp->notify_pendings, &cn_dispose);
+		spin_unlock(&fp->f_lock);
+
+		list_for_each_entry_safe(cn_work, cn_tmp, &cn_dispose, notify_entry) {
+			list_del_init(&cn_work->notify_entry);
+			ksmbd_conn_write(cn_work);
+			ksmbd_free_work_struct(cn_work);
+		}
+	}
+
 	/*
 	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
 	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
@@ -1080,6 +1109,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->blocked_works);
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
+	INIT_LIST_HEAD(&fp->notify_pendings);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 111a4e315..2d722c43c 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -135,6 +135,12 @@ struct ksmbd_file {
 
 	bool                            is_posix_ctxt;
 	struct durable_owner		owner;
+
+	/*
+	 * Pending CHANGE_NOTIFY completions for this handle, sent with
+	 * STATUS_NOTIFY_CLEANUP when the handle is closed.
+	 */
+	struct list_head		notify_pendings;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
-- 
2.43.0

