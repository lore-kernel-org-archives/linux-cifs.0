Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518834;
	b=U8dikpzVLWbcaYX9GCxdfza1YoUWP4frE5/jWM02kiI3feVS11dhpEc7YMa3krPF5NBu
	 tG95SpmYh36xKhFK1tACQcAMi5rm/nbA6y1jwLI8zhRMHKIs8TltvEF4FIZ9OlFLqLO7l
	 BIROG6Zp20i/WZJj/NWbha0Ktt8UWguL9i37CipieLloRUvjVs/n8PVTcq0l51q2y8k/e
	 ycOWkgw4jSfejLDqACHbblysYNnYybLiK0tMK8m9m372/WHnIe0TJXK+kPp24zN60oltM
	 SoRkURwm/9W6U6jlh+hxH8wnsGEZK2eluG2majwaejgnP7ndFPvrIZJkjONXw0v2KLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Dj8ZuzR0ntDkMQXzMLuFYiD0v2CsY6Dsdijln7ftZSY=;
	b=UD/JnUrTGCQ8ItB6Uh5+jAhhLkRsWrsqOL6HCKxWVAV8VQ6Nl+hOVznL22+DHia4nFrE
	 uXucKvMotS/barpIlcbCPq5K/DPJFFDPvQWf8ccgB3wd8IvArYDprA+X8DCaIkzysXBhr
	 8tVlPv9H5Rg3QJX8ZoUBYGmNbEm2+PW4CnDQEqkAA4J77WD1aWVTZRvqgvmva8CJ7e51M
	 DAYQgwH45qLlni2eR5R9ke2N0uAAyzUUpLNSduDvxjkRXegPqpxQ8CPeYVuNmN1G1Q/k0
	 OlAxFPB/QcYKPZ8ZVQqh0kuFc/MgOxU4V7vAvUqzlka7/zC0qEu/WuYH4ZMY6XGVHPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g6zS3rOJ;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF81606A32D
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 17:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CF81606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g6zS3rOJ
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-35f1f76ea84so6294330eec.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 10:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792518833; x=1793123633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dj8ZuzR0ntDkMQXzMLuFYiD0v2CsY6Dsdijln7ftZSY=;
        b=g6zS3rOJpQuJvtDA8sYfgp6A7LNiaue9AYt/0pjC77emFhWsv/dk0om2+3FlLLWNEE
         AQH7Or2XdXonzaHS5NEhDsKEA4YBPDProezqmt9RXgUEv+Dt9445tj5giNwaJlqHyUj0
         VVRJw9YueG4SkZrfS7W8obBBqoKdXraz9AumV6iOFwwMFnXYfvLgTsA0r+9M6GkGntFV
         xTXibwayCygDTZ9udhzj0VA0VBIKiyS8r/xx/CzI6jxJWd6CqZOIZopeIAkF4MS7zVTU
         DSI0b7ry6bHogEpg4I1CeW5HWU+KYyyr0lnyMuCuClJU66xWcrOtNH2GaNJiTZ3ECeQT
         W/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792518833; x=1793123633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dj8ZuzR0ntDkMQXzMLuFYiD0v2CsY6Dsdijln7ftZSY=;
        b=lDmgnmUi0uZHiTcuNsXnLAqoKxmY/aI85dSm3Td36xmiKSyaIMeCQf/ETM7N3lAFHs
         yokWboZ4mLW1svk4OjAaBOZG5DvTRKTYolwLfxAsqYfatJm+hrRmmI/2URVxFxV2yOg/
         6QMyoMeiTH+J0qIG2xMtA0ZeJEvpAP/rZuAAfsR/hImcYj5GzzlzUcA81vBfEV8w0zA8
         t9cIRlj5uqHwSmAqQZHl8gn7xCZtmd6GYVmjkWK8/f+yBkmnUJgcnttYkUfj//TB5nXe
         YmkyulqO6H3GFw9ldObBpbwZ/wiOwLlz5tti7HGfojF4ZN8Cy8S4++MB7hODqNyHmVvx
         xjUQ==
X-Gm-Message-State: AFq9FYKafDANC9ppYsKJzvhoy7XgCA/xRc0kC8UIhexQk+d6uA5SWl7n
	aw9R6pkQ7VLfXSrEpkGsYEQbb6ErSzqWdqRCGZV/juLpanRjJzYpQ9S0
X-Gm-Gg: AYBFou3jxNxffjzOQvjRzBOKu4ECZJLDpl1QV7l9rSIJyRVtQ1GkkVG4TSdO/YzetEx
	trpO+2SjbpGufeLKbQ+nrZNVESbFqoFstobUxqnYEC/KpOSP2WHHHcC4B7JkiecH4VYJnhymgWK
	+KymfeneyCHJ7RiNrFVZ2M8sck4mW5DQppjIrybwKvgLt7hL76/ssHcoYFn9gOD1t20vk/7jpY8
	672i7pMTM6+v0ChB4V51RfGoK4zB3tEfdi+5rBBZwKi1ihoDRgDDMWkNh8lTjXPOmaGptdD+Gso
	NQC4YPR/lamUUD9xkuSIofFcfmOsdotRsQeDdW7nYHnpJ2pEj0TBOXP6/dme1cNMRpAVXYNEJyS
	N0lmUdTpnHZmXnaa/m1z7NegPYoOZfXP8uyvnbk45RYRmQsNqsygsQ9nbCTRJq4R62EPBfz1x7H
	8ZHLZMS35Qpp8W+cGNWbNKRCnbtdkRS9htjkaDSUbuPnaFgGXLKi4jMEdItSpfi9mRuImp8d/QG
	govSAlqhYJRHt4awmTpH29dNmkSgrv6YobLxDIqySgzNK/cApWQoXfuA+eQixQWL4t9oZmu9dZt
	qMehOzQHOlmdymQ2e1ZUIj0ray3e
X-Received: by 2002:a05:7023:b0f:b0:14d:c53a:f6a0 with SMTP id a92af1059eb24-18512c3833dmr23334898c88.13.1792518832978;
        Tue, 20 Oct 2026 10:53:52 -0700 (PDT)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903b3d0530sm200831c88.11.2026.10.20.10.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 10:53:52 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org,
	co+d531129f2f9fbf88@bugs.sh
Subject: [PATCH] smb/server: prevent file publication after tree disconnect
Date: Tue, 20 Oct 2026 10:52:55 -0700
Message-ID: <20261020175254.900284-2-bestswngs@gmail.com>
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
 fs/smb/server/mgmt/tree_connect.c |  7 ++++
 fs/smb/server/mgmt/tree_connect.h |  2 +
 fs/smb/server/smb2pdu.c           | 37 ++++++++++++++----
 fs/smb/server/vfs_cache.c         | 65 +++++++++++++++++++++----------
 4 files changed, 83 insertions(+), 28 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index dd1db3554cae..837175ac5ce8 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -103,6 +103,13 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
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
index f0023d86716f..82891ff9b7b9 100644
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
index b7ce67094626..d4d8840a92b1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3041,9 +3041,10 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	err = ksmbd_tree_conn_disconnect(sess, tcon);
+
 	ksmbd_close_tree_conn_fds(work);
 
-	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		goto err_out;
@@ -4280,8 +4281,12 @@ int smb2_open(struct ksmbd_work *work)
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
 
@@ -4702,6 +4707,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (IS_ERR(fp)) {
 		fput(filp);
 		rc = PTR_ERR(fp);
+		if (rc == -ENOTCONN)
+			rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		fp = NULL;
 		goto err_out;
 	}
@@ -5302,11 +5309,20 @@ int smb2_open(struct ksmbd_work *work)
 
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
@@ -5321,8 +5337,7 @@ int smb2_open(struct ksmbd_work *work)
 				rsp->hdr.Status = STATUS_PRIVILEGE_NOT_HELD;
 			else
 				rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		}
-		else if (rc == -ENOENT)
+		} else if (rc == -ENOENT && !rsp->hdr.Status)
 			rsp->hdr.Status = STATUS_OBJECT_NAME_INVALID;
 		else if (rc == -EPERM)
 			rsp->hdr.Status = STATUS_SHARING_VIOLATION;
@@ -5345,8 +5360,14 @@ int smb2_open(struct ksmbd_work *work)
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
index fd2c595f0486..b72fd915f1e5 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -699,15 +699,17 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	}
 
 	/*
-	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
-	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
-	 * scavenger have already had fp->conn cleared by session_fd_check(),
-	 * in which case there is nothing to drop here.
+	 * Drop fp's strong connection references.  Durable fps that reached
+	 * the scavenger have already had these cleared by session_fd_check().
 	 */
 	if (fp->conn) {
 		ksmbd_conn_put(fp->conn);
 		fp->conn = NULL;
 	}
+	if (fp->tcon) {
+		ksmbd_tree_connect_put(fp->tcon);
+		fp->tcon = NULL;
+	}
 
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
@@ -1273,14 +1275,13 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 
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
 	fp->volatile_id		= KSMBD_NO_FID;
 	fp->persistent_id	= KSMBD_NO_FID;
 	fp->f_state		= FP_NEW;
@@ -1291,7 +1292,13 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
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
@@ -1301,7 +1308,8 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	return fp;
 
 err_out:
-	/* fp->conn was set and refcounted before every branch here. */
+	/* fp->conn and fp->tcon were refcounted before every branch here. */
+	ksmbd_tree_connect_put(fp->tcon);
 	ksmbd_conn_put(fp->conn);
 	kmem_cache_free(filp_cache, fp);
 	return ERR_PTR(ret);
@@ -1315,8 +1323,9 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
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
@@ -1332,6 +1341,8 @@ int ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 		ret = -ENOENT;
 	} else {
 		fp->f_state = state;
+		if (state == FP_INITED)
+			atomic_inc(&fp->refcount);
 		ret = 0;
 	}
 	write_unlock(&ft->lock);
@@ -1763,6 +1774,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
 	struct ksmbd_conn *conn;
+	struct ksmbd_tree_connect *tree_conn;
 	struct ksmbd_lock *smb_lock, *tmp_lock;
 
 	if (!is_reconnectable(fp))
@@ -1783,6 +1795,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	 * body of this function regardless of any op->conn puts below.
 	 */
 	conn = fp->conn;
+	tree_conn = fp->tcon;
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
@@ -1807,9 +1820,11 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 		ksmbd_conn_put(lock_conn);
 	}
 
+	/* Synchronize pointer removal with global file-table readers. */
+	write_lock(&global_ft.lock);
 	fp->conn = NULL;
 	fp->tcon = NULL;
-	fp->volatile_id = KSMBD_NO_FID;
+	write_unlock(&global_ft.lock);
 
 	if (fp->durable_timeout)
 		fp->durable_scavenger_timeout =
@@ -1817,6 +1832,7 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 
 	/* Drop fp's own reference on conn. */
 	ksmbd_conn_put(conn);
+	ksmbd_tree_connect_put(tree_conn);
 	return true;
 }
 
@@ -1894,6 +1910,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_lock *smb_lock;
 	unsigned int old_f_state;
+	int ret;
 
 	write_lock(&global_ft.lock);
 	if ((!fp->is_durable && !fp->is_persistent) || fp->conn || fp->tcon) {
@@ -1914,24 +1931,32 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	 * concurrent teardown that iterates the table can observe a valid
 	 * volatile_id with fp->conn == NULL and preserve a
 	 * partially-initialized fp.  fp owns a strong reference on the new
-	 * conn (see ksmbd_open_fd()); undo it on __open_id() failure.
+	 * conn (see ksmbd_open_fd()); undo it on __open_id() failure.  Serialize
+	 * publication with tree disconnect just as ksmbd_open_fd() does.
 	 */
 	fp->conn = ksmbd_conn_get(conn);
-	fp->tcon = work->tcon;
+	fp->tcon = ksmbd_tree_connect_get(work->tcon);
 	write_unlock(&global_ft.lock);
 
 	old_f_state = fp->f_state;
 	fp->f_state = FP_NEW;
 
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
 		fp->conn = NULL;
 		fp->tcon = NULL;
 		write_unlock(&global_ft.lock);
 		ksmbd_conn_put(conn);
+		ksmbd_tree_connect_put(work->tcon);
 		fp->f_state = old_f_state;
-		return -EBADF;
+		return ret == -ENOTCONN ? ret : -EBADF;
 	}
 
 	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
-- 
2.56.0

