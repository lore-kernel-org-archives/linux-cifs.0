Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C74030DD01;
	Thu, 22 Jan 2026 03:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769053598; cv=none; b=nntF2HJUUG0ocuFV42fx8e7gABb73SlWHJNi5IoEZVkybMhp8Sl8Ikk2vIm20TVaEaKW2lS+xZnPcxWAcD5L6/eZzu3GFW9kzcY502SV3oQxM/fF88FTWQe7s5hyVHEQA5iBlsBrfiuBuGY9bhdUgq3Jeq/K2a1ZNUwvzkhJ5wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769053598; c=relaxed/simple;
	bh=g744lz6iU9xFRdnsnHyyhaVQs6SpUU91JT0OadSyyg0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j90a5B0L9PhChCOn9q0WWxqQq58VNhXO5uk90cjbtagAHIB3cqIOWYA3VKS66bKln4mtATpWvK0wihRxX4c9vbQofUFJ+sLL6xR4Sitv9wPzmsCpomMZwLiWRrsQXyjdpcK6UPBZBFpXZg7cZD6sFwpy6qfnf+CBSspsbC+QCuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=Iy5h1HxG; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="Iy5h1HxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Iy5h1HxGWG96b8PvFjSXUudZazlxfy+k67BEtqx1SLvLNMIwNSLE27Mu5FU7NFR39rK78mLfFQMQU
	 M240QSrWo0WKBdlNq4Z06D4BtH9iAnKrROWn4bcOEebTj8myglpK6tehOaw1fX5wEfIKpjMIVXElcl
	 fQWW2TO4PmxwCLug=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-17-12016 (RichMail) with SMTP id 2ef069719c9511d-0a1eb;
	Thu, 22 Jan 2026 11:42:14 +0800 (CST)
X-RM-TRANSID:2ef069719c9511d-0a1eb
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	senozhatsky@chromium.org,
	sfrench@samba.org,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	pioooooooooip@gmail.com,
	liuzhitong1993@gmail.com,
	stfrench@microsoft.com
Subject: [PATCH 5.15.y] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Thu, 22 Jan 2026 11:42:12 +0800
Message-Id: <20260122034212.3111671-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b39a1833cc4a2755b02603eec3a71a85e9dff926 ]

Under high concurrency, A tree-connection object (tcon) is freed on
a disconnect path while another path still holds a reference and later
executes *_put()/write on it.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Rajani Kantha <681739313@139.com>
---
 fs/ksmbd/mgmt/tree_connect.c | 18 ++++--------------
 fs/ksmbd/mgmt/tree_connect.h |  1 -
 fs/ksmbd/smb2pdu.c           |  3 ---
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index d2c81a8a11dd..0b6847f04fcc 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -76,7 +76,6 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
-	init_waitqueue_head(&tree_conn->refcount_q);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      GFP_KERNEL));
@@ -98,14 +97,8 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
-	/*
-	 * Checking waitqueue to releasing tree connect on
-	 * tree disconnect. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&tcon->refcount) &&
-	    waitqueue_active(&tcon->refcount_q))
-		wake_up(&tcon->refcount_q);
+	if (atomic_dec_and_test(&tcon->refcount))
+		kfree(tcon);
 }
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
@@ -117,14 +110,11 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	write_unlock(&sess->tree_conns_lock);
 
-	if (!atomic_dec_and_test(&tree_conn->refcount))
-		wait_event(tree_conn->refcount_q,
-			   atomic_read(&tree_conn->refcount) == 0);
-
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_share_config_put(tree_conn->share_conf);
-	kfree(tree_conn);
+	if (atomic_dec_and_test(&tree_conn->refcount))
+		kfree(tree_conn);
 	return ret;
 }
 
diff --git a/fs/ksmbd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
index 6377a70b811c..bf47c3f65f03 100644
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -32,7 +32,6 @@ struct ksmbd_tree_connect {
 	int				maximal_access;
 	bool				posix_extensions;
 	atomic_t			refcount;
-	wait_queue_head_t		refcount_q;
 	unsigned int			t_state;
 };
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c0b5985701bf..b4a1aa1bc960 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2169,7 +2169,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	WARN_ON_ONCE(atomic_dec_and_test(&tcon->refcount));
 	tcon->t_state = TREE_DISCONNECTED;
 	write_unlock(&sess->tree_conns_lock);
 
@@ -2179,8 +2178,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	work->tcon = NULL;
-
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));
-- 
2.34.1


