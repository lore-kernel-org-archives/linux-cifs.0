Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A10D59
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:51 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cf6af8588fso5408355ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729150; x=1701333950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82MDmI6HOCDjxbBE3+Puhp3QcFIPtO0PJZRIbuoDrnk=;
        b=l8ud4Qzb3XnR9Ujt+/tJDTZ27oxV+0BMazJPS+mwvaUklSE7XtVYc59j4zlSMocihE
         /C1n+aV6S48IRLE1VH39sbpC5z/ap4RsGcuxbKkoz8tbglqEDEyFanDcVd+GSRH/xiD1
         Hq4ZX2zWJebR4w5FZyQQRaktMLiaQNpIPSxsjhD/yxoU+YHmYLSrnWBkVcZYTWZlqYPE
         UCi/rs/vgDUJjBx4+9VzYPTJLhUPGW8LWF2fCgi9uZvPqK7b6XD4aC/lVtmU2rPZASEu
         xhfcPTedAFnzPfJyKII5PQjIVxvxbE9aqCp50Nh3Kag+lTWOZJ88EVnwcf5unXYONWRQ
         89CA==
X-Gm-Message-State: AOJu0YzuOAsj8M1a95THqp58UenL6cKjT8U85bmU8a7DgM5fJQNTofgb
	/wb18Rc77SwnBVz9ZA+osQatMCYvKno=
X-Google-Smtp-Source: AGHT+IEtOwqns1O4D8e9gGi0rhJ/cBMWcezLGODsiDQzYShmVdxQ+LksB3sAnlDI+p0bqqihjlc4Jw==
X-Received: by 2002:a17:902:6b0a:b0:1ca:abe:a08b with SMTP id o10-20020a1709026b0a00b001ca0abea08bmr4229142plk.68.1700729150191;
        Thu, 23 Nov 2023 00:45:50 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:45:49 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/6] ksmbd: separately allocate ci per dentry
Date: Thu, 23 Nov 2023 17:45:03 +0900
Message-Id: <20231123084507.35584-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231123084507.35584-1-linkinjeon@kernel.org>
References: <20231123084507.35584-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfstests generic/002 test fail when enabling smb2 leases feature.
This test create hard link file, but removeal failed.
ci has a file open count to count file open through the smb client,
but in the case of hard link files, The allocation of ci per inode
cause incorrectly open count for file deletion. This patch allocate
ci per dentry to counts open counts for hard link.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   |  2 +-
 fs/smb/server/vfs.c       |  2 +-
 fs/smb/server/vfs_cache.c | 33 +++++++++++++--------------------
 fs/smb/server/vfs_cache.h |  6 +++---
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c996264db2c6..ac4204955a85 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3039,7 +3039,7 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
-	rc = ksmbd_query_inode_status(d_inode(path.dentry->d_parent));
+	rc = ksmbd_query_inode_status(path.dentry->d_parent);
 	if (rc == KSMBD_INODE_STATUS_PENDING_DELETE) {
 		rc = -EBUSY;
 		goto err_out;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 533257b46fc1..9091dcd7a310 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -719,7 +719,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out3;
 	}
 
-	parent_fp = ksmbd_lookup_fd_inode(d_inode(old_child->d_parent));
+	parent_fp = ksmbd_lookup_fd_inode(old_child->d_parent);
 	if (parent_fp) {
 		if (parent_fp->daccess & FILE_DELETE_LE) {
 			pr_err("parent dir is opened with delete access\n");
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c91eac6514dd..ddf233994ddb 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -66,14 +66,14 @@ static unsigned long inode_hash(struct super_block *sb, unsigned long hashval)
 	return tmp & inode_hash_mask;
 }
 
-static struct ksmbd_inode *__ksmbd_inode_lookup(struct inode *inode)
+static struct ksmbd_inode *__ksmbd_inode_lookup(struct dentry *de)
 {
 	struct hlist_head *head = inode_hashtable +
-		inode_hash(inode->i_sb, inode->i_ino);
+		inode_hash(d_inode(de)->i_sb, (unsigned long)de);
 	struct ksmbd_inode *ci = NULL, *ret_ci = NULL;
 
 	hlist_for_each_entry(ci, head, m_hash) {
-		if (ci->m_inode == inode) {
+		if (ci->m_de == de) {
 			if (atomic_inc_not_zero(&ci->m_count))
 				ret_ci = ci;
 			break;
@@ -84,26 +84,16 @@ static struct ksmbd_inode *__ksmbd_inode_lookup(struct inode *inode)
 
 static struct ksmbd_inode *ksmbd_inode_lookup(struct ksmbd_file *fp)
 {
-	return __ksmbd_inode_lookup(file_inode(fp->filp));
+	return __ksmbd_inode_lookup(fp->filp->f_path.dentry);
 }
 
-static struct ksmbd_inode *ksmbd_inode_lookup_by_vfsinode(struct inode *inode)
-{
-	struct ksmbd_inode *ci;
-
-	read_lock(&inode_hash_lock);
-	ci = __ksmbd_inode_lookup(inode);
-	read_unlock(&inode_hash_lock);
-	return ci;
-}
-
-int ksmbd_query_inode_status(struct inode *inode)
+int ksmbd_query_inode_status(struct dentry *dentry)
 {
 	struct ksmbd_inode *ci;
 	int ret = KSMBD_INODE_STATUS_UNKNOWN;
 
 	read_lock(&inode_hash_lock);
-	ci = __ksmbd_inode_lookup(inode);
+	ci = __ksmbd_inode_lookup(dentry);
 	if (ci) {
 		ret = KSMBD_INODE_STATUS_OK;
 		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
@@ -143,7 +133,7 @@ void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
 {
 	struct hlist_head *b = inode_hashtable +
-		inode_hash(ci->m_inode->i_sb, ci->m_inode->i_ino);
+		inode_hash(d_inode(ci->m_de)->i_sb, (unsigned long)ci->m_de);
 
 	hlist_add_head(&ci->m_hash, b);
 }
@@ -157,7 +147,6 @@ static void ksmbd_inode_unhash(struct ksmbd_inode *ci)
 
 static int ksmbd_inode_init(struct ksmbd_inode *ci, struct ksmbd_file *fp)
 {
-	ci->m_inode = file_inode(fp->filp);
 	atomic_set(&ci->m_count, 1);
 	atomic_set(&ci->op_count, 0);
 	atomic_set(&ci->sop_count, 0);
@@ -166,6 +155,7 @@ static int ksmbd_inode_init(struct ksmbd_inode *ci, struct ksmbd_file *fp)
 	INIT_LIST_HEAD(&ci->m_fp_list);
 	INIT_LIST_HEAD(&ci->m_op_list);
 	rwlock_init(&ci->m_lock);
+	ci->m_de = fp->filp->f_path.dentry;
 	return 0;
 }
 
@@ -488,12 +478,15 @@ struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid)
 	return fp;
 }
 
-struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
+struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 {
 	struct ksmbd_file	*lfp;
 	struct ksmbd_inode	*ci;
+	struct inode		*inode = d_inode(dentry);
 
-	ci = ksmbd_inode_lookup_by_vfsinode(inode);
+	read_lock(&inode_hash_lock);
+	ci = __ksmbd_inode_lookup(dentry);
+	read_unlock(&inode_hash_lock);
 	if (!ci)
 		return NULL;
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 03d0bf941216..8325cf4527c4 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -51,7 +51,7 @@ struct ksmbd_inode {
 	atomic_t			op_count;
 	/* opinfo count for streams */
 	atomic_t			sop_count;
-	struct inode			*m_inode;
+	struct dentry			*m_de;
 	unsigned int			m_flags;
 	struct hlist_node		m_hash;
 	struct list_head		m_fp_list;
@@ -140,7 +140,7 @@ struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,
 void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
-struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode);
+struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_close_tree_conn_fds(struct ksmbd_work *work);
@@ -164,7 +164,7 @@ enum KSMBD_INODE_STATUS {
 	KSMBD_INODE_STATUS_PENDING_DELETE,
 };
 
-int ksmbd_query_inode_status(struct inode *inode);
+int ksmbd_query_inode_status(struct dentry *dentry);
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp);
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp);
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp);
-- 
2.25.1

