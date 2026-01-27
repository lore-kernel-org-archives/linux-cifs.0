Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4B52BCF4A;
	Tue, 27 Jan 2026 08:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502731; cv=none; b=gjYX8nh6F1hH5Ry0I5OLyDYsZuvy+bbZQZ4pW2OuoF4OS234VsCjHaTDk6axi9vaUMa7gJQ5yFXGw3sZsaBd0VOHjFnYfrrRh9ITHDrrMJZkOZVVWqHJQI9rRl5kgVRa9z2fIqkOXKa9fXtERuVt8LpdPWotx/MpTaWah4SGqoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502731; c=relaxed/simple;
	bh=7R/0y3r+kLaNah1uVZ+xLzGFJEfXNObb51z6mKttBuY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rXaiKRomi8GXb2t+cxhC1cnlApnMDEShXy4JT3jI+h0jumeCdUIzFbH6+VjhSjH2ZHd1q3e+/kTAtqkt6G7RqSn+9Xm1NSJQHYQyOLpq64Ap8dKopsG8ZjSzwPgfungYId/22h/LYHH5gaDksIngZ8ot58ZQfORROwdIhT9IPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=n9XI7u0V; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="n9XI7u0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=n9XI7u0V4MPYME59knGIekq7ypZg6um6ycLKJ1g+yZ/irZ+9pYxcjq0gp37RLqGMq9cPuuMANJRZ3
	 rVep8bkee4QpDza2bdGvrC0jDz4jBPEZ5+HPYZRnlk7yXJNdVEBO+tO8O6ITcUw42sMyf2yfZ9huKW
	 vRQA6ZP7H5FIWmGk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-43-12057 (RichMail) with SMTP id 2f19697877f71d1-011ea;
	Tue, 27 Jan 2026 16:31:53 +0800 (CST)
X-RM-TRANSID:2f19697877f71d1-011ea
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	sujana.subramaniam@sap.com,
	sashal@kernel.org,
	linux-cifs@vger.kernel.org,
	norbert@doyensec.com,
	stfrench@microsoft.com
Subject: [PATCH 6.6.y] ksmbd: fix use-after-free in ksmbd_session_rpc_open
Date: Tue, 27 Jan 2026 16:31:49 +0800
Message-Id: <20260127083149.3344689-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a1f46c99d9ea411f9bf30025b912d881d36fc709 ]

A UAF issue can occur due to a race condition between
ksmbd_session_rpc_open() and __session_rpc_close().
Add rpc_lock to the session to protect it.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ KSMBD_DEFAULT_GFP is introduced by commit 0066f623bce8 ("ksmbd: use __GFP_RETRY_MAYFAIL")
 after linux-6.13. Here we still use GFP_KERNEL. ]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/smb/server/mgmt/user_session.c | 20 ++++++++++++++------
 fs/smb/server/mgmt/user_session.h |  1 +
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 0ca788009c93..450a9f8ca7c7 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -59,10 +59,12 @@ static void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess)
 	struct ksmbd_session_rpc *entry;
 	long index;
 
+	down_write(&sess->rpc_lock);
 	xa_for_each(&sess->rpc_handle_list, index, entry) {
 		xa_erase(&sess->rpc_handle_list, index);
 		__session_rpc_close(sess, entry);
 	}
+	up_write(&sess->rpc_lock);
 
 	xa_destroy(&sess->rpc_handle_list);
 }
@@ -92,7 +94,7 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 {
 	struct ksmbd_session_rpc *entry, *old;
 	struct ksmbd_rpc_command *resp;
-	int method;
+	int method, id;
 
 	method = __rpc_method(rpc_name);
 	if (!method)
@@ -102,26 +104,29 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	if (!entry)
 		return -ENOMEM;
 
+	down_read(&sess->rpc_lock);
 	entry->method = method;
-	entry->id = ksmbd_ipc_id_alloc();
-	if (entry->id < 0)
+	entry->id = id = ksmbd_ipc_id_alloc();
+	if (id < 0)
 		goto free_entry;
-	old = xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	old = xa_store(&sess->rpc_handle_list, id, entry, GFP_KERNEL);
 	if (xa_is_err(old))
 		goto free_id;
 
-	resp = ksmbd_rpc_open(sess, entry->id);
+	resp = ksmbd_rpc_open(sess, id);
 	if (!resp)
 		goto erase_xa;
 
+	up_read(&sess->rpc_lock);
 	kvfree(resp);
-	return entry->id;
+	return id;
 erase_xa:
 	xa_erase(&sess->rpc_handle_list, entry->id);
 free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);
+	up_read(&sess->rpc_lock);
 	return -EINVAL;
 }
 
@@ -129,9 +134,11 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
 
+	down_write(&sess->rpc_lock);
 	entry = xa_erase(&sess->rpc_handle_list, id);
 	if (entry)
 		__session_rpc_close(sess, entry);
+	up_write(&sess->rpc_lock);
 }
 
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
@@ -438,6 +445,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	sess->sequence_number = 1;
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
+	init_rwsem(&sess->rpc_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index f21348381d59..c5749d6ec715 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -63,6 +63,7 @@ struct ksmbd_session {
 	rwlock_t			tree_conns_lock;
 
 	atomic_t			refcnt;
+	struct rw_semaphore		rpc_lock;
 };
 
 static inline int test_session_flag(struct ksmbd_session *sess, int bit)
-- 
2.34.1


