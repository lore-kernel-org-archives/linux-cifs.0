Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C878725F984
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659687; cv=none; b=PWmjDTUjepJlmxRIqGFHntotNJkwflT6dTf3/e7bMqDp8zzD95pP7pnh02idEmzI/qMeuB+LM3hqYM79AOlh5NYhvx15MRIJHCQzwPy76TY6s1Yb/Afui2aBJSvG1FGXLCWjfTC5gz5X2wD3+m+pYVHUrw7NOzpSbI5hN51fYnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659687; c=relaxed/simple;
	bh=uW5tKQ+f2Xf6dN5fI3wopsswMwQI5cGYat6wCHBRekw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtSUVKZOP8lCmoIQN4eh6uBkiDTDqjdi6MtzuiA4QaCryESRkrGfS5uUY6cFvYIOUtBIhyN6RmnpDfSR/GUvj9Js3YXSDnpFJRxu+L5fWc/Ln2hXfFbX1tzp2JwQlB2iM/tZft7ylgXbG/qB4qVh1CNQtQXauL0581j8CvSQ9HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEqcyMU1; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEqcyMU1"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-81ecbdfdcebso2189644b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Feb 2026 09:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770659687; x=1771264487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x579W78puk2J7viePwNvGcMeO83v1ceQH2g54H75Lgk=;
        b=JEqcyMU1qS0VQyU4SmSQqi5+ABMfKqys0KaOrHtLMejzUqU6p2QDQq0bCI8J0Kwo81
         466WZIieurAK7CmZ7gCY18yR8iq90kEA8/nYYdpsNINO/k1kSYnY1wl9jRWbDuX2uVsB
         TSDy/Nfi7oT5pMK3usStGW/pXDnvH8Cobhm1Il+m7zytqX+fwDQ5Koyrl1NClRhNDEht
         PjXE5zu/FDDBP+RUASh2CuJPeuRHaCN99aNaA1L9zDAXPmsUWOdzyVUdF+NCaiQXt+X9
         WH6rMuQuVokmmzgH77hSZur13Byc5WeLl8p3tImqbZE7zrJ4VGme/UfcaYlMu0tTxU23
         EFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659687; x=1771264487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x579W78puk2J7viePwNvGcMeO83v1ceQH2g54H75Lgk=;
        b=Trv/ocyGVr6Rs1A6TYdU++HNU+39lBLogb0M+BxV2PKJEOIi3o+uOd09xqh9w39v0e
         lJgIfuOPqqnbT3Z9PxexTRjb2JezpNKHqfQGzWJsSsGtWNzOGTUGuyZaaJ5gqpbPupfq
         cHHA048v3G36CfEBd34I3KpTotUY+eRxHchByrDvjFof/bv6WrE+spP8J8QV5NgA4oHO
         Wo4SC5Zu8vwLOBonhrGC4NsKjTspQf5j9Mhdrfdc6MBoGPMEy/wla4MwngWyO504Gt8C
         P3+H9xnnBgU7tsrIC9ItA2ZfG+eHXXoPofyyD0swLY08Y3loGRMFLaJ+sCg6navugWS/
         jjyA==
X-Forwarded-Encrypted: i=1; AJvYcCVoX+pp9hIqL3O6WvCBDZ7s9Dsc2HZ6VI13Vp4Kg4S634BQR5itEM8P7b47k+ei/Lv68casL/jnwOlb@vger.kernel.org
X-Gm-Message-State: AOJu0YxkwfNsjnK/YwEq/MWN1x9bDaOS9sfjkmKQnewo0T6qkPsBxnsm
	He98wSFTEePAIK48JvzOEwjc+YnDCXDGNcyVuJkkGrFN2OW0dslH3njYzLBFnw==
X-Gm-Gg: AZuq6aKmSe24GnOfMsZ4CnLNbs/uLXCrBP6HXrxDXRVVavVLJLQsaThg32bu+1KuzPm
	Dw7b0VhlqD3o4uoY3gpt9Jzx4uBwRTIOaQU0xFfndxFcZ4lwmAEazzXoIS0kZIGrrKhfRdKZuTD
	HCuRFtRYTKx+VxOM44hkhXPBns04A++V3gEEdiOscEIeRi9ZYmFc/0VAzGyChodKK1OPvz9DodL
	Wll4TEpVGmPRtr/BTFMVnBJWFv8xwomSBTHmWqjDwQjDd0gBCnYgCX8LNpgO7lAt0/Ymoc12cM4
	D6Fd8uHep2I2kz7Uh0a1pJX/6w6PzjE9zCrJN2WwnXoL0BO45aGBdazZkn+0p42iT4kBaXJin6p
	3W8NCoXR9Ijn1TrAeEPN3+7SP5oZoGdNCkPJk5VYtGcehqYWxsblEHXpAyp9No2cKpk+Ufgj2AI
	92qluXiKm9cU78
X-Received: by 2002:a05:6a00:12de:b0:823:1580:790e with SMTP id d2e1a72fcca58-824417b006dmr10560937b3a.56.1770659686885;
        Mon, 09 Feb 2026 09:54:46 -0800 (PST)
Received: from archlinux ([103.208.68.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244166f3e2sm11232882b3a.10.2026.02.09.09.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 09:54:46 -0800 (PST)
From: Adarsh Das <adarshdas950@gmail.com>
To: sfrench@samba.org,
	linkinjeon@kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adarsh Das <adarshdas950@gmail.com>
Subject: [PATCH 1/2] smb: remove redundant == true comparisons
Date: Mon,  9 Feb 2026 23:24:20 +0530
Message-ID: <20260209175421.66469-2-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209175421.66469-1-adarshdas950@gmail.com>
References: <20260209175421.66469-1-adarshdas950@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove "== true" comparisons with boolean variables. Should improve
readability.

Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
---
 fs/smb/client/connect.c   |  4 ++--
 fs/smb/client/misc.c      |  2 +-
 fs/smb/client/smb2ops.c   |  4 ++--
 fs/smb/server/server.c    |  2 +-
 fs/smb/server/smb2pdu.c   | 12 ++++++------
 fs/smb/server/vfs.c       |  8 ++++----
 fs/smb/server/vfs_cache.c |  2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ce620503e9f7..75137359757d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -962,7 +962,7 @@ dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid, bool malfor
 	 * Trying to handle/dequeue a mid after the send_recv()
 	 * function has finished processing it is a bug.
 	 */
-	if (mid->deleted_from_q == true) {
+	if (mid->deleted_from_q) {
 		spin_unlock(&server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
@@ -3675,7 +3675,7 @@ int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx)
 		goto out;
 	}
 
-	if ((ctx->persistent == true) && (!(ses->server->capabilities &
+	if (ctx->persistent && (!(ses->server->capabilities &
 					    SMB2_GLOBAL_CAP_PERSISTENT_HANDLES))) {
 		cifs_server_dbg(VFS, "persistent handles not supported by server\n");
 		rc = -EOPNOTSUPP;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 9529fa385938..bc5b74bdcb4e 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -122,7 +122,7 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 	if (!ret_buf)
 		return NULL;
 
-	if (dir_leases_enabled == true) {
+	if (dir_leases_enabled) {
 		ret_buf->cfids = init_cached_dirs();
 		if (!ret_buf->cfids) {
 			kfree(ret_buf);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c1aaf77e187b..edf5afb2ddd2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3681,7 +3681,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	if (keep_size == true) {
+	if (keep_size) {
 		/*
 		 * We can not preallocate pages beyond the end of the file
 		 * in SMB2
@@ -3699,7 +3699,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+	if (keep_size || (i_size_read(inode) >= off + len)) {
 		/*
 		 * At this point, we are trying to fallocate an internal
 		 * regions of a sparse file. Since smb2 does not have a
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 554ae90df906..78e68a7a618a 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -235,7 +235,7 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 		    (work->sess->sign || smb3_11_final_sess_setup_resp(work) ||
 		     conn->ops->is_sign_req(work, command)))
 			conn->ops->set_sign_rsp(work);
-	} while (is_chained == true);
+	} while (is_chained);
 
 send:
 	if (work->tcon)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fcd0d4d1fb0..de40ef7ac26a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2601,7 +2601,7 @@ static int smb2_creat(struct ksmbd_work *work,
 		return -EBADF;
 
 	ksmbd_debug(SMB, "file does not exist, so creating\n");
-	if (is_dir == true) {
+	if (is_dir) {
 		ksmbd_debug(SMB, "creating directory\n");
 
 		mode = share_config_directory_mode(share, posix_mode);
@@ -2987,7 +2987,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out2;
 		}
 
-		if (dh_info.reconnected == true) {
+		if (dh_info.reconnected) {
 			rc = smb2_check_durable_oplock(conn, share, dh_info.fp, lc, name);
 			if (rc) {
 				ksmbd_put_durable_fd(dh_info.fp);
@@ -6222,7 +6222,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
-	if (ksmbd_stream_fd(fp) == true)
+	if (ksmbd_stream_fd(fp))
 		return 0;
 
 	rc = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
@@ -6779,7 +6779,7 @@ int smb2_read(struct ksmbd_work *work)
 		}
 	}
 
-	if (is_rdma_channel == true) {
+	if (is_rdma_channel) {
 		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
 
 		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
@@ -6849,7 +6849,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
 		    nbytes, offset, mincount);
 
-	if (is_rdma_channel == true) {
+	if (is_rdma_channel) {
 		/* write data to the client using rdma channel */
 		remain_bytes = smb2_read_rdma_channel(work, req,
 						      aux_payload_buf,
@@ -7043,7 +7043,7 @@ int smb2_write(struct ksmbd_work *work)
 		length = le32_to_cpu(req->RemainingBytes);
 	}
 
-	if (is_rdma_channel == true) {
+	if (is_rdma_channel) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
 
 		if (req->Length != 0 || req->DataOffset != 0 ||
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b8e648b8300f..6e6ad5eda9ea 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -877,7 +877,7 @@ int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 {
 	int err;
 
-	if (get_write == true) {
+	if (get_write) {
 		err = mnt_want_write(path->mnt);
 		if (err)
 			return err;
@@ -891,7 +891,7 @@ int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 			   flags);
 	if (err)
 		ksmbd_debug(VFS, "setxattr failed, err %d\n", err);
-	if (get_write == true)
+	if (get_write)
 		mnt_drop_write(path->mnt);
 	return err;
 }
@@ -1001,7 +1001,7 @@ int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
 {
 	int err;
 
-	if (get_write == true) {
+	if (get_write) {
 		err = mnt_want_write(path->mnt);
 		if (err)
 			return err;
@@ -1009,7 +1009,7 @@ int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
 
 	err = vfs_removexattr(idmap, path->dentry, attr_name);
 
-	if (get_write == true)
+	if (get_write)
 		mnt_drop_write(path->mnt);
 
 	return err;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 6ef116585af6..ea9c237b2bca 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -863,7 +863,7 @@ void ksmbd_launch_ksmbd_durable_scavenger(void)
 		return;
 
 	mutex_lock(&durable_scavenger_lock);
-	if (durable_scavenger_running == true) {
+	if (durable_scavenger_running) {
 		mutex_unlock(&durable_scavenger_lock);
 		return;
 	}
-- 
2.53.0

