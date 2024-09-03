Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31155195
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 11:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363148; cv=none; b=tWIOmcbteG3daoMLydrTGZ368F9d8LisM3UyNGShkABZXosCFKYGizxlx4oU/askTgcTKj2gy79WYBodWm188X13C0sCLd9XIWv5UPBwgEYNIEidwBcwBIeNKuV5WvHrk+H2+Q4q4dH6cQ0Pjj04UWmAkFlSHBI6SNQ3NMlQL4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363148; c=relaxed/simple;
	bh=/mraVcar/k6zUdg7z33QCkL8oVaStdo5reFgBdkz7yY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KWRw/bL2mYx24TMOPoIMbT6DBXQzJ6XunblKywjBHLCiG1zbZ6/J7LOUqCwVmIlJlctOKsGq1Aql6aU6eHzQDcPEBqAeDYL0O2LErob5oxxSHFh4kzGq9FmDK3vM85VHkTeQoa6YwjWl4cAR6PTL5iWrpFrucEFNxzFn6df47Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7142a30e3bdso4469201b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2024 04:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725363146; x=1725967946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiXOAUueeyAaTiLJr+m1KLIf0uiq/Ugo2aE+aUWLNR0=;
        b=YGKOH3FVWsJ8SxsKelmyw5KbONWFnbGzrMiNYneBn3vuSwkTKWVAzfkGcFOZt63nWr
         VOj1I8CtKiPz10ugN41/gj2cYJ9hlVtpzw4ZWcG+fI/7thHPGBgrQmbrD9w/+0ZOm3pG
         8hlX0ERCdSqMeabjRqxd0QLPd7i+lK1bB8UEbAc460BUW6DnR1ZkKpW3xdS/gBLJLMeo
         GwkKZVAE2dDKLwSJRFBBZFkdIESq3d6ucH6yFg6DYOnDDCcJ8NGN6A0HKshAQq7bCSyK
         BEkW62PvmhXSzc9AOKXoXFnlD7XP6Z/ifNMbWG5D+AXloaT4SSXbERMUOc7ZNj/IiF9w
         TWEg==
X-Gm-Message-State: AOJu0YxKYNQSTazLFhYn5t5+ed024NtJdajQiPCbI/gs84OBX2k2it+V
	rrNM1lPXvYylTu9fBXYv7+QnOBiZ3THQdFIKFhNWl/D3785zIGxdexD2HA==
X-Google-Smtp-Source: AGHT+IF4/BhlkZxKjEAko2GJaIVBAdElzgKjjEiYz/61o4EjjrfWV+bQMzLKqxjQN/HP0t4Y7Jyyzg==
X-Received: by 2002:a05:6a21:1690:b0:1ca:ccfc:edc8 with SMTP id adf61e73a8af0-1ccee8874a3mr19522451637.22.1725363146180;
        Tue, 03 Sep 2024 04:32:26 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e56d8889sm8574021b3a.143.2024.09.03.04.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 04:32:25 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add refcnt to ksmbd_conn struct
Date: Tue,  3 Sep 2024 20:31:47 +0900
Message-Id: <20240903113147.6886-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240903113147.6886-1-linkinjeon@kernel.org>
References: <20240903113147.6886-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When sending an oplock break request, opinfo->conn is used,
But freed ->conn can be used on multichannel.
This patch add a reference count to the ksmbd_conn struct
so that it can be freed when it is no longer used.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c |  4 ++-
 fs/smb/server/connection.h |  1 +
 fs/smb/server/oplock.c     | 55 +++++++++++---------------------------
 fs/smb/server/vfs_cache.c  |  3 +++
 4 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 7889df8112b4..cac80e7bfefc 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,7 +39,8 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
-	kfree(conn);
+	if (atomic_dec_and_test(&conn->refcnt))
+		kfree(conn);
 }
 
 /**
@@ -68,6 +69,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		conn->um = NULL;
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
+	atomic_set(&conn->refcnt, 1);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 5b947175c048..b379ae4fdcdf 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -106,6 +106,7 @@ struct ksmbd_conn {
 	bool				signing_negotiated;
 	__le16				signing_algorithm;
 	bool				binding;
+	atomic_t			refcnt;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index e546ffa57b55..8ee86478287f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -51,6 +51,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
 	atomic_set(&opinfo->breaking_cnt, 0);
+	atomic_inc(&opinfo->conn->refcnt);
 
 	return opinfo;
 }
@@ -124,6 +125,8 @@ static void free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
+	if (opinfo->conn && atomic_dec_and_test(&opinfo->conn->refcnt))
+		kfree(opinfo->conn);
 	kfree(opinfo);
 }
 
@@ -163,9 +166,7 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 		    !atomic_inc_not_zero(&opinfo->refcount))
 			opinfo = NULL;
 		else {
-			atomic_inc(&opinfo->conn->r_count);
 			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
 				atomic_dec(&opinfo->refcount);
 				opinfo = NULL;
 			}
@@ -177,26 +178,11 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 	return opinfo;
 }
 
-static void opinfo_conn_put(struct oplock_info *opinfo)
+void opinfo_put(struct oplock_info *opinfo)
 {
-	struct ksmbd_conn *conn;
-
 	if (!opinfo)
 		return;
 
-	conn = opinfo->conn;
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
-	opinfo_put(opinfo);
-}
-
-void opinfo_put(struct oplock_info *opinfo)
-{
 	if (!atomic_dec_and_test(&opinfo->refcount))
 		return;
 
@@ -1127,14 +1113,11 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			atomic_inc(&opinfo->conn->r_count);
-			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
-			}
 
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
-			opinfo_conn_put(opinfo);
+			opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
@@ -1167,13 +1150,10 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			atomic_inc(&opinfo->conn->r_count);
-			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
-			}
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
-			opinfo_conn_put(opinfo);
+			opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
@@ -1252,7 +1232,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	prev_opinfo = opinfo_get_list(ci);
 	if (!prev_opinfo ||
 	    (prev_opinfo->level == SMB2_OPLOCK_LEVEL_NONE && lctx)) {
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto set_lev;
 	}
 	prev_op_has_lease = prev_opinfo->is_lease;
@@ -1262,19 +1242,19 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (share_ret < 0 &&
 	    prev_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		err = share_ret;
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto err_out;
 	}
 
 	if (prev_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    prev_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto op_break_not_needed;
 	}
 
 	list_add(&work->interim_entry, &prev_opinfo->interim_list);
 	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_conn_put(prev_opinfo);
+	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
 	/* Check all oplock was freed by close */
@@ -1337,14 +1317,14 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
 		return;
 	if (brk_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    brk_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_conn_put(brk_opinfo);
+		opinfo_put(brk_opinfo);
 		return;
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
 	list_add(&work->interim_entry, &brk_opinfo->interim_list);
 	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_conn_put(brk_opinfo);
+	opinfo_put(brk_opinfo);
 }
 
 /**
@@ -1376,11 +1356,8 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (!atomic_inc_not_zero(&brk_op->refcount))
 			continue;
 
-		atomic_inc(&brk_op->conn->r_count);
-		if (ksmbd_conn_releasing(brk_op->conn)) {
-			atomic_dec(&brk_op->conn->r_count);
+		if (ksmbd_conn_releasing(brk_op->conn))
 			continue;
-		}
 
 		rcu_read_unlock();
 		if (brk_op->is_lease && (brk_op->o_lease->state &
@@ -1411,7 +1388,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		brk_op->open_trunc = is_trunc;
 		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE);
 next:
-		opinfo_conn_put(brk_op);
+		opinfo_put(brk_op);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 4d4ee696e37c..d51788462e21 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -863,6 +863,8 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn != conn)
 			continue;
+		if (atomic_dec_and_test(&op->conn->refcnt))
+			kfree(op->conn);
 		op->conn = NULL;
 	}
 	up_write(&ci->m_lock);
@@ -965,6 +967,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		if (op->conn)
 			continue;
 		op->conn = fp->conn;
+		atomic_inc(&op->conn->refcnt);
 	}
 	up_write(&ci->m_lock);
 
-- 
2.25.1

