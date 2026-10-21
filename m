Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592873;
	b=DJxBImKLrMymrt68gwTgSMR5d7qqLYZRTfsLpnVc3NbteUufExh5+8Ia0vMj/+xrPETj
	 L5Ok4bAbfycj94JVSV1gOSavA8sDNP+kcldJKMMiQ19hXSzmsNAc61+DmdzPFpA7GDSEh
	 cxapToAfKyeJa1qcoMsThMRjJ0vtEt22xHrniW5mFHiKnnnccTBKgCdkGqNlWSyJGKuDc
	 aY7155ckrriopLFU/r/T2apKxt8ImbV1L+O0YqFx+mNzsHpeUaI8Cm9jIfo0VNWnuywDK
	 HmxiMDZXjvrVh3uMj5yW+bd0g5lAByYH/16yj8rRjZJD2lgY1K6rttCcBsWAPzE7gjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592873;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vkcONsDFV2ul6YAc5qH7dmQUSmGutsUjBJHhqFZ3LGs=;
	b=PIRTF6UMLWyk86vPhOGOQp0SHvj1KTCyffV7j7TeMvxVjU8dQ5c05Ng+7DBOkv5IcWp3
	 +nnU7qwEaQVQdtOA51PGWU8rwqIGYiIK2ku4HgqTmZiK6gsfWZWtHwx2pY2SKnqiW9XxN
	 iBAuxOpFviZIu+tzN0ULO758f4Pg5N8g6e5b9tt//Nr+WQvIuo49zaWfj1AdfOl42qH9N
	 9A2cfufDsk7NDCWQWw7YL4EtZFKZiJtl8slrhSsh+zaTzbq+9zxqeWyznRqq0RUyufdi0
	 1NBHD9FmEF8EocnBG5mY1tKFgYzIOE7ENilF8x7bqroO3fXSzCyhw6xgVJg22QH7D/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MBjYT9Gg;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5BB606A31B
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 14:27:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC5BB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MBjYT9Gg
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso1387163eec.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592872; x=1793197672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vkcONsDFV2ul6YAc5qH7dmQUSmGutsUjBJHhqFZ3LGs=;
        b=MBjYT9GgGVm5YR4SEnmOVa6s5fnRSe6Ow91vonBNzthE6O19ZguTtAtu7O7oQCabQP
         Dx1zH9N5VnnhLzsZUTQZnzuI2mD5C8f6oO61ARw5AWEEq/yZ3/bIW/9u5q9x54yvBJfe
         Of8vvN6HYxt8qSZskp8+JjYtwzDgfwwF7HapUCqK67+FR1UFKn1Ku19nK6HrxjkCAFM0
         fZ3Tgn7/bQQFUHd5cToSSGMEHhpjohMpLx9OxDEttwoCo1llqRxBImhoW5YUU/br5/kj
         KjXPmg+WkXmf1GckbhQkkfWiXomDxR47GwcVDSocIzzvVS6FB/mtu9XeL4YVBjHkiuvW
         pxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592872; x=1793197672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vkcONsDFV2ul6YAc5qH7dmQUSmGutsUjBJHhqFZ3LGs=;
        b=hdaWBZuTa5T+I+3Wo6ELZCuMzH6mDAfBhSjwuy9l/kIIdUdt/+JjmF5n+Ul3llFOA9
         5771YaH+bxwW0ENNscEYrBgIoyIeotTc/zF6oebpzY+JXhYrIipgBDF1A5djKuLy2U4q
         eByNdD5YtQTdW7aer6IRkkCUNU6+gjMrTCHN6rBFZ9+Ay7gUazM6fq3VQRzI4roK0Iyz
         oEc4dWWNUqeHy4q/NYRTtecfH3A50vW9kL97QNVDMmLZaKj2OmS4lMgkDJfIae/klmDK
         fRbGnb7Dv5FgKbtGDSEP4Xhh1jA+yYOh6faxBaQmiE79mjveWLy6tX7oIkvKGgdFGeIS
         jvsg==
X-Gm-Message-State: AFq9FYLbaVZVl0O0SLRABTs+2/dxxnp5N5LZXGgt2VGSvpjCbUr/YYge
	Fr1hG3U+n+BBil0do10Pf6YvgUY1kzF9+PWMsuICgQ3Zyvzt5SpE5ywX
X-Gm-Gg: AYBFou3SEY5eKYnMJgbV6Ih1RVFWrey+M9OCoukm5/RotUSGZxXDqBcsYYzeZptlG34
	iEf3yKuVijvOH9we+dkjCMeM5utN+4MlUYn3v/aXNFmo23HQIZbjR02l8fdyxdhNSg0HNVTGqvJ
	swkXPix8KCQgLOeLXMi3WPao6hS+vIk3Kt8PjL09v5P7aFvyVp6PGZmuoVPT9pp2mgiOY3VmA1K
	RXGW0jv2J+X5mSOk0nKrZyJX1dm4P7psMYYCdlFtQZiYZQU1Lus1+MnQbZmNYXqGTJwMuMvwnDE
	l0g+59IDE49kK5JtgmiGhnI98FPH8HNkKHHJ84AvqF5C4w880+mBrw+mkuBIY4kd8wkopbUpAM/
	F677A5JBICbCenmN8OMnvB3okZccQaOHfLErgSqKEd2iSFDC0qoT0mgbm9iTb8HQoxoO2XqmC3X
	iyqEd4e8az04IjvlFIIjuy9NsafDTitXtaUWsDDJRN63NO1mSFl84h+TcgsuwpgyY4OneeOYvE/
	o6nxvcXxYu/jCG8NSID35tTI61PfePF9r959ojRpr9mkkzTtQvkCucNSa1STowoZ6vsFzRAxROw
	APGBKZPtu0c15+nPc8oadW+QaAnNKRgltvQIoqzrJDClopCqzQ==
X-Received: by 2002:a05:693c:41d6:10b0:351:515b:4e85 with SMTP id 5a478bee46e88-3674d758112mr3565723eec.16.1792592871837;
        Wed, 21 Oct 2026 07:27:51 -0700 (PDT)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e15353csm14524660eec.2.2026.10.21.07.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:27:50 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	co+d531129f2f9fbf88@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2] smb/server: prevent file publication after tree disconnect
Date: Wed, 21 Oct 2026 07:17:57 -0700
Message-ID: <20261021141757.3917073-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
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

TREE_DISCONNECT closes the tree's published file handles before marking and
removing the tree connection. A concurrent CREATE that already holds a tree
reference can therefore publish its file after the close pass. When CREATE
drops its reference, the tree can be freed while the published file still
points to it.

Mark and remove the tree connection before closing its files, and serialize
both new-open and durable-reconnect volatile ID publication with that state
transition. An opener is then either published in time for the close pass
or rejected after disconnect with STATUS_NETWORK_NAME_DELETED.

Keep a tree reference while a file carries its tree pointer. This protects
asynchronous users that can defer the file's final destruction past tree
disconnect.

The close pass can race the successful FP_NEW to FP_INITED transition.
Take the opening request's file reference atomically with that transition.
This keeps the file alive until request completion even if teardown removes
the ID immediately.

  BUG: KASAN: slab-use-after-free in proc_show_files (fs/smb/server/vfs_cache.c:126)
  Read of size 4 at addr ff11000101540f80 by task poc/153

  Call Trace:
    proc_show_files (fs/smb/server/vfs_cache.c:126)
    seq_read_iter (fs/seq_file.c:231)
    proc_reg_read_iter (fs/proc/inode.c:299)
    vfs_read (fs/read_write.c:574)
    ksys_read (fs/read_write.c:716)
    do_syscall_64 (arch/x86/entry/syscall_64.c:84)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  Allocated by:
    ksmbd_tree_conn_connect (fs/smb/server/mgmt/tree_connect.c:35)
    smb2_tree_connect (fs/smb/server/smb2pdu.c:2819)
    handle_ksmbd_work (fs/smb/server/server.c:368)

  Freed by:
    kfree (mm/slub.c:6801)
    handle_ksmbd_work (fs/smb/server/server.c:332)

Fixes: f44158485826 ("cifsd: add file operations")
Cc: stable@vger.kernel.org
Reported-by: <co+d531129f2f9fbf88@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---

Changes in v2:
- Rebase onto ksmbd-for-next at f75c93278608.

 fs/smb/server/mgmt/tree_connect.c |  7 ++++
 fs/smb/server/mgmt/tree_connect.h |  2 ++
 fs/smb/server/smb2pdu.c           | 37 ++++++++++++++-----
 fs/smb/server/vfs_cache.c         | 60 +++++++++++++++++++++----------
 4 files changed, 80 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index dd1db35..837175a 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -103,6 +103,13 @@ out_error:
 	return status;
 }
 
+struct ksmbd_tree_connect *
+ksmbd_tree_connect_get(struct ksmbd_tree_connect *tcon)
+{
+	atomic_inc(&tcon->refcount);
+	return tcon;
+}
+
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
 	if (atomic_dec_and_test(&tcon->refcount)) {
diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index f0023d8..82891ff 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -51,6 +51,8 @@ struct ksmbd_session;
 
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name);
+struct ksmbd_tree_connect *
+ksmbd_tree_connect_get(struct ksmbd_tree_connect *tcon);
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon);
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4533649..da82d80 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3175,9 +3175,10 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	err = ksmbd_tree_conn_disconnect(sess, tcon);
+
 	ksmbd_close_tree_conn_fds(work);
 
-	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		goto err_out;
@@ -4502,8 +4503,12 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 
 			rc = ksmbd_reopen_durable_fd(work, dh_info.fp);
-			if (rc)
+			if (rc) {
+				if (rc == -ENOTCONN)
+					rsp->hdr.Status =
+						STATUS_NETWORK_NAME_DELETED;
 				goto err_out2;
+			}
 
 			fp = dh_info.fp;
 
@@ -4940,6 +4945,8 @@ resolve_path:
 	if (IS_ERR(fp)) {
 		fput(filp);
 		rc = PTR_ERR(fp);
+		if (rc == -ENOTCONN)
+			rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		fp = NULL;
 		goto err_out;
 	}
@@ -5544,11 +5551,20 @@ err_out1:
 
 err_out2:
 	if (!rc) {
-		if (!dh_info.replay)
+		if (!dh_info.replay) {
+			smb2_complete_request_open(work);
 			rc = ksmbd_update_fstate(&work->sess->file_table, fp,
 						 FP_INITED);
-		if (!rc)
+			if (rc == -ENOENT)
+				rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
+			if (!rc) {
+				work->request_open = fp;
+				work->request_open_chseq =
+					smb3_hdr_channel_sequence(&req->hdr);
+			}
+		} else {
 			rc = smb2_set_request_open(work, fp, &req->hdr, false, false);
+		}
 		if (!rc)
 			rc = ksmbd_iov_pin_rsp(work, (void *)rsp, iov_len);
 	}
@@ -5563,8 +5579,7 @@ err_out2:
 				rsp->hdr.Status = STATUS_PRIVILEGE_NOT_HELD;
 			else
 				rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		}
-		else if (rc == -ENOENT)
+		} else if (rc == -ENOENT && !rsp->hdr.Status)
 			rsp->hdr.Status = STATUS_OBJECT_NAME_INVALID;
 		else if (rc == -EPERM)
 			rsp->hdr.Status = STATUS_SHARING_VIOLATION;
@@ -5587,8 +5602,14 @@ err_out2:
 		if (!rsp->hdr.Status)
 			rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 
-		if (fp && !dh_info.replay)
-			ksmbd_fd_put(work, fp);
+		if (fp && !dh_info.replay) {
+			if (work->request_open == fp) {
+				ksmbd_close_fd(work, fp->volatile_id);
+				smb2_complete_request_open(work);
+			} else {
+				ksmbd_fd_put(work, fp);
+			}
+		}
 		smb2_set_err_rsp(work);
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 452ce05..7a0f132 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -919,16 +919,18 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		fput(filp);
 
 	/*
-	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
-	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
-	 * scavenger have already had fp->conn cleared by session_fd_check(),
-	 * in which case there is nothing to drop here.
+	 * Drop fp's strong connection references.  Durable fps that reached
+	 * the scavenger have already had these cleared by session_fd_check().
 	 */
 	if (fp->conn) {
 		atomic_dec(&fp->conn->stats.open_files_count);
 		ksmbd_conn_put(fp->conn);
 		fp->conn = NULL;
 	}
+	if (fp->tcon) {
+		ksmbd_tree_connect_put(fp->tcon);
+		fp->tcon = NULL;
+	}
 
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
@@ -1494,14 +1496,13 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 
 	fp->filp		= filp;
 	/*
-	 * fp owns a strong reference on fp->conn for as long as fp->conn is
-	 * non-NULL, so session_fd_check() and __ksmbd_close_fd() never
-	 * dereference a dangling pointer.  Paired with ksmbd_conn_put() in
-	 * session_fd_check() (durable preserve), in __ksmbd_close_fd()
-	 * (final close), and on the error paths below.
+	 * fp owns strong references on fp->conn and fp->tcon for as long as
+	 * they are non-NULL.  Paired with the puts in session_fd_check()
+	 * (durable preserve), in __ksmbd_close_fd() (final close), and on the
+	 * error paths below.
 	 */
 	fp->conn		= ksmbd_conn_get(work->conn);
-	fp->tcon		= work->tcon;
+	fp->tcon		= ksmbd_tree_connect_get(work->tcon);
 	fp->share_conf		= work->tcon->share_conf;
 	atomic_inc(&fp->share_conf->refcount);
 	fp->volatile_id		= KSMBD_NO_FID;
@@ -1514,7 +1515,13 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 		goto err_out;
 	}
 
-	ret = __open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
+	down_read(&work->sess->tree_conns_lock);
+	if (work->tcon->t_state == TREE_CONNECTED)
+		ret = __open_id(&work->sess->file_table, fp,
+				OPEN_ID_TYPE_VOLATILE_ID);
+	else
+		ret = -ENOTCONN;
+	up_read(&work->sess->tree_conns_lock);
 	if (ret) {
 		ksmbd_inode_put(fp->f_ci);
 		goto err_out;
@@ -1524,7 +1531,8 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	return fp;
 
 err_out:
-	/* fp->conn was set and refcounted before every branch here. */
+	/* fp->conn and fp->tcon were refcounted before every branch here. */
+	ksmbd_tree_connect_put(fp->tcon);
 	ksmbd_conn_put(fp->conn);
 	ksmbd_share_config_put(fp->share_conf);
 	kmem_cache_free(filp_cache, fp);
@@ -1541,8 +1549,9 @@ err_fd_limit:
  *
  * Return: 0 on success.  The FP_NEW -> FP_INITED transition is special:
  * -ENOENT if teardown already unpublished @fp by advancing the state or
- * clearing the volatile id.  Other state updates preserve the historical
- * fire-and-forget behavior.
+ * clearing the volatile id.  On success it also takes a reference for the
+ * opening request, which must be released with ksmbd_fd_put().  Other state
+ * updates preserve the historical fire-and-forget behavior.
  */
 int ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 			unsigned int state)
@@ -1558,6 +1567,8 @@ int ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 		ret = -ENOENT;
 	} else {
 		fp->f_state = state;
+		if (state == FP_INITED)
+			atomic_inc(&fp->refcount);
 		ret = 0;
 	}
 	write_unlock(&ft->lock);
@@ -1977,6 +1988,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
 	struct ksmbd_conn *conn;
+	struct ksmbd_tree_connect *tree_conn;
 
 	if (!is_reconnectable(fp))
 		return false;
@@ -1998,6 +2010,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
 	conn = fp->conn;
+	tree_conn = fp->tcon;
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
 				lockdep_is_held(&ci->m_lock)) {
 		if (op->o_fp != fp)
@@ -2021,6 +2034,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 
 	/* Drop fp's own reference on conn. */
 	ksmbd_conn_put(conn);
+	ksmbd_tree_connect_put(tree_conn);
 	return true;
 }
 
@@ -2133,7 +2147,8 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	 * concurrent teardown that iterates the table can observe a valid
 	 * volatile_id with fp->conn == NULL and preserve a
 	 * partially-initialized fp.  fp owns a strong reference on the new
-	 * conn (see ksmbd_open_fd()); undo it on __open_id() failure.
+	 * conn (see ksmbd_open_fd()); undo it on __open_id() failure.  Serialize
+	 * publication with tree disconnect just as ksmbd_open_fd() does.
 	 */
 	spin_lock(&fp->f_lock);
 	old_f_state = fp->f_state;
@@ -2142,13 +2157,19 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	fp->share_conf = work->tcon->share_conf;
 	atomic_inc(&fp->share_conf->refcount);
 	fp->conn = ksmbd_conn_get(conn);
-	fp->tcon = work->tcon;
+	fp->tcon = ksmbd_tree_connect_get(work->tcon);
 	spin_unlock(&fp->f_lock);
 	atomic_inc(&conn->stats.open_files_count);
 	write_unlock(&global_ft.lock);
 
-	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
-	if (!has_file_id(fp->volatile_id)) {
+	down_read(&work->sess->tree_conns_lock);
+	if (work->tcon->t_state == TREE_CONNECTED)
+		ret = __open_id(&work->sess->file_table, fp,
+				OPEN_ID_TYPE_VOLATILE_ID);
+	else
+		ret = -ENOTCONN;
+	up_read(&work->sess->tree_conns_lock);
+	if (ret) {
 		write_lock(&global_ft.lock);
 		spin_lock(&fp->f_lock);
 		fp->conn = NULL;
@@ -2159,7 +2180,10 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		atomic_dec(&conn->stats.open_files_count);
 		write_unlock(&global_ft.lock);
 		ksmbd_conn_put(conn);
+		ksmbd_tree_connect_put(work->tcon);
 		ksmbd_share_config_put(work->tcon->share_conf);
+		if (ret != -ENOTCONN)
+			ret = -EBADF;
 		goto out;
 	}
 
-- 
2.56.0

