Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BA07710B
	for <linux-cifs@vger.kernel.org>; Thu,  2 May 2024 12:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652085; cv=none; b=KWF/TwqSX7KsDXkG7lY+o2tjDHOZJgnTlpZJoNCXyRNscs6j+b2pFdss/9EJIlbwbRu72WlQXWBBs0KkxDNenbLS9bPuPMldxMnWPJ11L9c+1r5HoFcX4PS76M+bMCGkT8xxFgVW5sMKMF94TUytPlaXpa56WsmaeXZEfwWC/ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652085; c=relaxed/simple;
	bh=BYsRo9AMSPuruZg4UQYNc5+Rs0EjN7ZuqD+IEXzJBOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qo7BQAt5Jqb3ny3yDAHuWB6vzTtk+AtIqetXRJXmclxmenk0ojC8Il2J4vXlqxiqFFzHFoXaVuP7nDOFX3oZBDXbr7uxYrat5QJ44w6SiEH2KakcjyLEL/fCuHBOfsk+QgeM84NW3JDNAHfSDiMopBiHtOqXpmUSyCdjq9XSVK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f074520c8cso7447733b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2024 05:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714652083; x=1715256883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jK9zvksjofSL4Wy6xphUstkl/TQdaKWKrQe1c/CNYZ8=;
        b=KusJfYaPhbvmJaWDBS/VmgTJfGIqkBwU7gyFaJHxSINJCcL9j9BPxH2xxK75l1B+RP
         op6ajnWiNuqF8pkyM6FB5rBYGyaMT6ZlUSXIaU2Zfk3Ru0FptD/YMl1/Iuva9SuEsNya
         9WwMRii5Kn3NlhJHuQzpEak7lHttBayYpoAwRuhPlPwSA6E0ppbhLLgCElxQ6XmHQXYi
         yWc1D7vl+MqOxdR0pIzgRQQ2xwOnocotFNryuwTxTo42DjyV2T1E3TEg3fsXnc0Z3lTx
         cCpdywA+pU2uC5eV3tQOkFO54BYK4AMnCmIxVmI5WOO6uPnWJX3HeWGYku2kfxZTfOA6
         2Z+A==
X-Gm-Message-State: AOJu0YzLqB55X/ilglyJNJgF8JcDokJBIrdFJyMDpOApSDAUcjdMaJzL
	A2VQkT1xY6QHpQjYD6aaNp3IvIWVxOdRi3ARGtgJ887hOOTa1ietd59mAA==
X-Google-Smtp-Source: AGHT+IFESgSblzHhZ0SJFdcxzjt+hAgR2NxmPTI2YHMuq/2g3NBBJPZpx4vx2IXRXIXz2Na86wKg5w==
X-Received: by 2002:a05:6a20:9499:b0:1af:5f84:2d87 with SMTP id hs25-20020a056a20949900b001af5f842d87mr1869867pzb.36.1714652083102;
        Thu, 02 May 2024 05:14:43 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id gx8-20020a056a001e0800b006edec30bbc2sm1069840pfb.49.2024.05.02.05.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 05:14:42 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/4] ksmbd: use rwsem instead of rwlock for lease break
Date: Thu,  2 May 2024 21:14:24 +0900
Message-Id: <20240502121425.5123-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240502121425.5123-1-linkinjeon@kernel.org>
References: <20240502121425.5123-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lease break wait for lease break acknowledgment.
rwsem is more suitable than unlock while traversing the list for parent
lease break in ->m_op_list.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c     | 30 +++++++++++-------------------
 fs/smb/server/smb2pdu.c    |  4 ++--
 fs/smb/server/smb_common.c |  4 ++--
 fs/smb/server/vfs_cache.c  | 28 ++++++++++++++--------------
 fs/smb/server/vfs_cache.h  |  2 +-
 5 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 6fd8cb7064dc..c2abf109010d 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -207,9 +207,9 @@ static void opinfo_add(struct oplock_info *opinfo)
 {
 	struct ksmbd_inode *ci = opinfo->o_fp->f_ci;
 
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_add_rcu(&opinfo->op_entry, &ci->m_op_list);
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 }
 
 static void opinfo_del(struct oplock_info *opinfo)
@@ -221,9 +221,9 @@ static void opinfo_del(struct oplock_info *opinfo)
 		lease_del_list(opinfo);
 		write_unlock(&lease_list_lock);
 	}
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_del_rcu(&opinfo->op_entry);
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 }
 
 static unsigned long opinfo_count(struct ksmbd_file *fp)
@@ -526,21 +526,18 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 	 * Compare lease key and client_guid to know request from same owner
 	 * of same client
 	 */
-	read_lock(&ci->m_lock);
+	down_read(&ci->m_lock);
 	list_for_each_entry(opinfo, &ci->m_op_list, op_entry) {
 		if (!opinfo->is_lease || !opinfo->conn)
 			continue;
-		read_unlock(&ci->m_lock);
 		lease = opinfo->o_lease;
 
 		ret = compare_guid_key(opinfo, client_guid, lctx->lease_key);
 		if (ret) {
 			m_opinfo = opinfo;
 			/* skip upgrading lease about breaking lease */
-			if (atomic_read(&opinfo->breaking_cnt)) {
-				read_lock(&ci->m_lock);
+			if (atomic_read(&opinfo->breaking_cnt))
 				continue;
-			}
 
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
@@ -570,9 +567,8 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				lease_none_upgrade(opinfo, lctx->req_state);
 			}
 		}
-		read_lock(&ci->m_lock);
 	}
-	read_unlock(&ci->m_lock);
+	up_read(&ci->m_lock);
 
 	return m_opinfo;
 }
@@ -1114,7 +1110,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	if (!p_ci)
 		return;
 
-	read_lock(&p_ci->m_lock);
+	down_read(&p_ci->m_lock);
 	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
 		if (opinfo->conn == NULL || !opinfo->is_lease)
 			continue;
@@ -1132,13 +1128,11 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				continue;
 			}
 
-			read_unlock(&p_ci->m_lock);
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
 			opinfo_conn_put(opinfo);
-			read_lock(&p_ci->m_lock);
 		}
 	}
-	read_unlock(&p_ci->m_lock);
+	up_read(&p_ci->m_lock);
 
 	ksmbd_inode_put(p_ci);
 }
@@ -1159,7 +1153,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	if (!p_ci)
 		return;
 
-	read_lock(&p_ci->m_lock);
+	down_read(&p_ci->m_lock);
 	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
 		if (opinfo->conn == NULL || !opinfo->is_lease)
 			continue;
@@ -1173,13 +1167,11 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 				atomic_dec(&opinfo->conn->r_count);
 				continue;
 			}
-			read_unlock(&p_ci->m_lock);
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
 			opinfo_conn_put(opinfo);
-			read_lock(&p_ci->m_lock);
 		}
 	}
-	read_unlock(&p_ci->m_lock);
+	up_read(&p_ci->m_lock);
 
 	ksmbd_inode_put(p_ci);
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 30229161b346..b6c5a8ea3887 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3376,9 +3376,9 @@ int smb2_open(struct ksmbd_work *work)
 	 * after daccess, saccess, attrib_only, and stream are
 	 * initialized.
 	 */
-	write_lock(&fp->f_ci->m_lock);
+	down_write(&fp->f_ci->m_lock);
 	list_add(&fp->node, &fp->f_ci->m_fp_list);
-	write_unlock(&fp->f_ci->m_lock);
+	up_write(&fp->f_ci->m_lock);
 
 	/* Check delete pending among previous fp before oplock break */
 	if (ksmbd_inode_pending_delete(fp)) {
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index fcaf373cc008..474dadf6b7b8 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -646,7 +646,7 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 	 * Lookup fp in master fp list, and check desired access and
 	 * shared mode between previous open and current open.
 	 */
-	read_lock(&curr_fp->f_ci->m_lock);
+	down_read(&curr_fp->f_ci->m_lock);
 	list_for_each_entry(prev_fp, &curr_fp->f_ci->m_fp_list, node) {
 		if (file_inode(filp) != file_inode(prev_fp->filp))
 			continue;
@@ -722,7 +722,7 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 			break;
 		}
 	}
-	read_unlock(&curr_fp->f_ci->m_lock);
+	up_read(&curr_fp->f_ci->m_lock);
 
 	return rc;
 }
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 030f70700036..6cb599cd287e 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -165,7 +165,7 @@ static int ksmbd_inode_init(struct ksmbd_inode *ci, struct ksmbd_file *fp)
 	ci->m_fattr = 0;
 	INIT_LIST_HEAD(&ci->m_fp_list);
 	INIT_LIST_HEAD(&ci->m_op_list);
-	rwlock_init(&ci->m_lock);
+	init_rwsem(&ci->m_lock);
 	ci->m_de = fp->filp->f_path.dentry;
 	return 0;
 }
@@ -261,14 +261,14 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
-		write_lock(&ci->m_lock);
+		down_write(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			write_unlock(&ci->m_lock);
+			up_write(&ci->m_lock);
 			ksmbd_vfs_unlink(filp);
-			write_lock(&ci->m_lock);
+			down_write(&ci->m_lock);
 		}
-		write_unlock(&ci->m_lock);
+		up_write(&ci->m_lock);
 
 		ksmbd_inode_free(ci);
 	}
@@ -289,9 +289,9 @@ static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp
 	if (!has_file_id(fp->volatile_id))
 		return;
 
-	write_lock(&fp->f_ci->m_lock);
+	down_write(&fp->f_ci->m_lock);
 	list_del_init(&fp->node);
-	write_unlock(&fp->f_ci->m_lock);
+	up_write(&fp->f_ci->m_lock);
 
 	write_lock(&ft->lock);
 	idr_remove(ft->idr, fp->volatile_id);
@@ -523,17 +523,17 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	if (!ci)
 		return NULL;
 
-	read_lock(&ci->m_lock);
+	down_read(&ci->m_lock);
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
 			lfp = ksmbd_fp_get(lfp);
-			read_unlock(&ci->m_lock);
+			up_read(&ci->m_lock);
 			return lfp;
 		}
 	}
 	atomic_dec(&ci->m_count);
-	read_unlock(&ci->m_lock);
+	up_read(&ci->m_lock);
 	return NULL;
 }
 
@@ -705,13 +705,13 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 
 	conn = fp->conn;
 	ci = fp->f_ci;
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn != conn)
 			continue;
 		op->conn = NULL;
 	}
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 
 	fp->conn = NULL;
 	fp->tcon = NULL;
@@ -801,13 +801,13 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	fp->tcon = work->tcon;
 
 	ci = fp->f_ci;
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn)
 			continue;
 		op->conn = fp->conn;
 	}
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (!has_file_id(fp->volatile_id)) {
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index ed44fb4e18e7..5a225e7055f1 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -47,7 +47,7 @@ struct stream {
 };
 
 struct ksmbd_inode {
-	rwlock_t			m_lock;
+	struct rw_semaphore		m_lock;
 	atomic_t			m_count;
 	atomic_t			op_count;
 	/* opinfo count for streams */
-- 
2.25.1

