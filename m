Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02F6D5
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:46:09 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ce28faa92dso14089225ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:46:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697569; x=1702302369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1V3BBHUDe5wlUwf17zpEJsBAPH4fz2a0zWRBcLWuOX8=;
        b=uN8o/vkYWGA55zxJFGZlvcOjRONBmxIj5FBJAXvvzOH4j1TQJ0ZezxYPezXAx4mDpN
         1CYF65Q87xdDXgTXa9l7uLWDwsmBDFDPWd7ce7eaA87sBsNMnhyNY4Cn+kDOe6XoJVkw
         ojUe62KgIf4GINZOjSArTexYkvESbM0ZzPjs1wAVL5ZLp35wsXul+FuGKnesGEzEq8DF
         /wxF/Yk3WAZWSJ/A+dc0rnvIrYsc46ohi89PYyF2Wtos08rN/J4MzsDZbKuA+gklZGGm
         Y/rpRDX4HxzojEMzIibduapba9nSL8bEXyIZSFJiL8SRP5y59rEB1kPduU1YKrMyQhKV
         wn7w==
X-Gm-Message-State: AOJu0Yyq2bAafnB6TP8fYIuFsq6gTp06Xc+IZi9LXWq9JAa9VAj76Qij
	tN7PNXEjaEE8jBtWk50PigImTmf3Ynk=
X-Google-Smtp-Source: AGHT+IFvj8Dq4arn+w+W4mbREYBqzGpaVfj4TXkodgqdfBSZqoOJvMeL4J5UUNFVb2fAa4eDdcDI0g==
X-Received: by 2002:a17:903:11d2:b0:1cf:aeeb:919a with SMTP id q18-20020a17090311d200b001cfaeeb919amr1447639plh.19.1701697547512;
        Mon, 04 Dec 2023 05:45:47 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:45:46 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/7] ksmbd: send v2 lease break notification for directory
Date: Mon,  4 Dec 2023 22:45:06 +0900
Message-Id: <20231204134509.11413-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231204134509.11413-1-linkinjeon@kernel.org>
References: <20231204134509.11413-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If client send different parent key, different client guid, or there is
no parent lease key flags in create context v2 lease, ksmbd send lease
break to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/smb2pdu.h   |  1 +
 fs/smb/server/oplock.c    | 41 ++++++++++++++++++++++++++++++++++-----
 fs/smb/server/oplock.h    |  4 ++++
 fs/smb/server/smb2pdu.c   |  7 +++++++
 fs/smb/server/vfs_cache.c | 13 ++++++++++++-
 fs/smb/server/vfs_cache.h |  2 ++
 6 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 8983f45f8430..e373018259e5 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1250,6 +1250,7 @@ struct create_mxac_rsp {
 #define SMB2_LEASE_WRITE_CACHING_LE		cpu_to_le32(0x04)
 
 #define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE	cpu_to_le32(0x02)
+#define SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE	cpu_to_le32(0x04)
 
 #define SMB2_LEASE_KEY_SIZE			16
 
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index ac327258506a..55ebce4e91c0 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -102,6 +102,7 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	lease->new_state = 0;
 	lease->flags = lctx->flags;
 	lease->duration = lctx->duration;
+	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
 	lease->epoch = le16_to_cpu(lctx->epoch);
@@ -543,12 +544,13 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
-				if (lease->state ==
-				    (lctx->req_state & lease->state)) {
+				if (lease->state != SMB2_LEASE_NONE_LE &&
+				    lease->state == (lctx->req_state & lease->state)) {
 					lease->state |= lctx->req_state;
 					if (lctx->req_state &
 						SMB2_LEASE_WRITE_CACHING_LE)
 						lease_read_to_write(opinfo);
+
 				}
 			} else if ((atomic_read(&ci->op_count) +
 				    atomic_read(&ci->sop_count)) > 1) {
@@ -900,7 +902,8 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
 					lease->new_state =
 						SMB2_LEASE_READ_CACHING_LE;
 			} else {
-				if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE)
+				if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE &&
+						!lease->is_dir)
 					lease->new_state =
 						SMB2_LEASE_READ_CACHING_LE;
 				else
@@ -1082,6 +1085,33 @@ static void set_oplock_level(struct oplock_info *opinfo, int level,
 	}
 }
 
+void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
+				      struct lease_ctx_info *lctx)
+{
+	struct oplock_info *opinfo;
+	struct ksmbd_inode *p_ci = NULL;
+
+	if (lctx->version != 2)
+		return;
+
+	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
+	if (!p_ci)
+		return;
+
+	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
+		if (!opinfo->is_lease)
+			continue;
+
+		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
+		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
+				      lctx->parent_lease_key)))
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+	}
+
+	ksmbd_inode_put(p_ci);
+}
+
 /**
  * smb_grant_oplock() - handle oplock/lease request on file open
  * @work:		smb work
@@ -1419,10 +1449,11 @@ struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-		if (is_dir)
+		if (is_dir) {
 			lreq->req_state = lc->lcontext.LeaseState &
 				~SMB2_LEASE_WRITE_CACHING_LE;
-		else
+			lreq->is_dir = true;
+		} else
 			lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 672127318c75..b64d1536882a 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -36,6 +36,7 @@ struct lease_ctx_info {
 	__u8			parent_lease_key[SMB2_LEASE_KEY_SIZE];
 	__le16			epoch;
 	int			version;
+	bool			is_dir;
 };
 
 struct lease_table {
@@ -54,6 +55,7 @@ struct lease {
 	__u8			parent_lease_key[SMB2_LEASE_KEY_SIZE];
 	int			version;
 	unsigned short		epoch;
+	bool			is_dir;
 	struct lease_table	*l_lb;
 };
 
@@ -125,4 +127,6 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
+void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
+				      struct lease_ctx_info *lctx);
 #endif /* __KSMBD_OPLOCK_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2d3b8acb21e7..45fc4bc3ac19 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3225,6 +3225,13 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	} else {
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+			/*
+			 * Compare parent lease using parent key. If there is no
+			 * a lease that has same parent key, Send lease break
+			 * notification.
+			 */
+			smb_send_parent_lease_break_noti(fp, lc);
+
 			req_op_level = smb2_map_lease_to_oplock(lc->req_state);
 			ksmbd_debug(SMB,
 				    "lease req for(%s) req oplock state 0x%x, lease state 0x%x\n",
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index ddf233994ddb..4e82ff627d12 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -87,6 +87,17 @@ static struct ksmbd_inode *ksmbd_inode_lookup(struct ksmbd_file *fp)
 	return __ksmbd_inode_lookup(fp->filp->f_path.dentry);
 }
 
+struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d)
+{
+	struct ksmbd_inode *ci;
+
+	read_lock(&inode_hash_lock);
+	ci = __ksmbd_inode_lookup(d);
+	read_unlock(&inode_hash_lock);
+
+	return ci;
+}
+
 int ksmbd_query_inode_status(struct dentry *dentry)
 {
 	struct ksmbd_inode *ci;
@@ -199,7 +210,7 @@ static void ksmbd_inode_free(struct ksmbd_inode *ci)
 	kfree(ci);
 }
 
-static void ksmbd_inode_put(struct ksmbd_inode *ci)
+void ksmbd_inode_put(struct ksmbd_inode *ci)
 {
 	if (atomic_dec_and_test(&ci->m_count))
 		ksmbd_inode_free(ci);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 8325cf4527c4..4d4938d6029b 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -138,6 +138,8 @@ struct ksmbd_file *ksmbd_lookup_foreign_fd(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,
 					u64 pid);
 void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
+struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d);
+void ksmbd_inode_put(struct ksmbd_inode *ci);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-- 
2.25.1

