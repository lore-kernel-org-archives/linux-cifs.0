Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B708E326951
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199049; cv=none; b=p/obDisQINTx89+LBhzMo3o5zzRiecm48amcAFJvBxcEb9Dae2sOJXGwwr23kr+tPkN0VMgLGseJI758X5Dkhl/Pxemq+vwxy0B7fZ1ykoWBSvZhou63rDLwBfXDR7ZTXuj2Rkle0WopNSe6Xw0TCkLHbCo3Vqog6dq44KwY5O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199049; c=relaxed/simple;
	bh=gBpMy6XCopBMkrGRLb7Sk27HQX6BsbYpP1hUkuH5D1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dtsEzvlC5IgRES3OI/i3y2pQA4lwgzStUBU2GYEBwX0Be+n0Kcin0Zd6N+y7fF8QpgpGWzYpXa+QG4kRXVP29WjcTkobfQFgDZxIKDEM54WnbO9xDrxupBdy0Y91v1P0M2g/dZirVHV/IMOOt8N4s6kRQCfNn0esL9r1Wbqi85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFqts2Uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFqts2Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B0B1F000C4;
	Sat, 17 Oct 2026 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199048;
	bh=Xg4theeSTR0DBYvUgeLcGW5lF9VRwb7DsHLwE/An518=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFqts2UjD572NQKU2SyGTKKPWjjhL+q1NuGUcHXvRvVpXcoQ0DY97OJwaV0bgJACX
	 Z71BuqIhgv4bWngPnpV8XhZ0zyHpwAX1LDjpUJXznAl/tu91xpcDMzCePwdLzLSzQ0
	 7/0RpSTKa/EmO8vHUw+cJ/KeA3vEzzhq91oU05jMjJQ/y/qEYjzZSawwlQeXcIWgIP
	 AwxgDG7hUyyLGWgk9KZ6QZen/qduGRhmQf+CsEv0K4wLP40QzHDmLFQ9yMFnxkLJlF
	 P/Whu/vtXa2iRdwbeZE+cVmkcXXZ7jsBe2V14z3hI2gMJpS0176z9v7X2Ew9OllKLt
	 4EQIkhFMKMjmw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 05/22] ksmbd: keep lease tables until their last lease is closed
Date: Sat, 17 Oct 2026 10:03:27 +0900
Message-Id: <20261017010344.11478-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disconnecting one channel destroys the lease table for its ClientGuid,
even when another channel still uses the same opens. A lease break ACK
on the surviving channel can no longer find the lease. Detached durable
opens also lose their lease lookup entries before reconnect or expiry.

Tie a client table to its lease entries instead of the connection which
created it. Remove the table when its last lease is removed, and release
any remaining entries at server shutdown. Do not destroy client tables
from connection teardown or keep a connection reference in each table.

For a detached lease, collect break candidates using the table's
ClientGuid directly. The existing notification retry path takes its own
references on matching live connections.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 46 +++++++++++++++++-------------------------
 fs/smb/server/oplock.h |  3 +--
 fs/smb/server/server.c |  3 +--
 3 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 313bf01ad350..96b36b8329a6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -125,6 +125,12 @@ static void lease_add_table(struct lease *lease, struct lease_table *lb)
 	spin_unlock(&lb->lb_lock);
 }
 
+static void free_lease_table(struct lease_table *lb)
+{
+	kfree(lb);
+}
+
+/* The caller holds lease_list_lock for write. */
 static void lease_del_table(struct lease *lease)
 {
 	struct lease_table *lb = lease->l_lb;
@@ -143,6 +149,10 @@ static void lease_del_table(struct lease *lease)
 	spin_unlock(&lb->lb_lock);
 
 	lease_put(lease);
+	if (list_empty(&lb->lease_list)) {
+		list_del(&lb->l_entry);
+		free_lease_table(lb);
+	}
 }
 
 static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
@@ -155,21 +165,11 @@ static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
 
 	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
 	       SMB2_CLIENT_GUID_SIZE);
-	lb->conn = ksmbd_conn_get(opinfo->conn);
 	INIT_LIST_HEAD(&lb->lease_list);
 	spin_lock_init(&lb->lb_lock);
 	return lb;
 }
 
-static void free_lease_table(struct lease_table *lb)
-{
-	if (!lb)
-		return;
-
-	ksmbd_conn_put(lb->conn);
-	kfree(lb);
-}
-
 static struct lease *alloc_lease(struct lease_ctx_info *lctx,
 				 struct ksmbd_inode *ci)
 {
@@ -927,8 +927,6 @@ static int smb2_break_collect_channels(struct oplock_info *opinfo,
 		if (lb) {
 			memcpy(guid, lb->client_guid, sizeof(guid));
 			have_guid = true;
-			if (lb->conn)
-				owner->conn = ksmbd_conn_get(lb->conn);
 		}
 		read_unlock(&lease_list_lock);
 	}
@@ -1495,25 +1493,17 @@ static void oplock_break_drain_none(struct list_head *head,
 	}
 }
 
-void destroy_lease_table(struct ksmbd_conn *conn)
+void destroy_lease_table(void)
 {
-	struct lease_table *lb, *lbtmp;
-	struct lease *lease, *ltmp;
+	struct lease_table *lb;
+	struct lease *lease;
 
 	write_lock(&lease_list_lock);
-	if (list_empty(&lease_table_list)) {
-		write_unlock(&lease_list_lock);
-		return;
-	}
-
-	list_for_each_entry_safe(lb, lbtmp, &lease_table_list, l_entry) {
-		if (conn && memcmp(lb->client_guid, conn->ClientGUID,
-				   SMB2_CLIENT_GUID_SIZE))
-			continue;
-		list_for_each_entry_safe(lease, ltmp, &lb->lease_list, l_entry)
-			lease_del_table(lease);
-		list_del(&lb->l_entry);
-		free_lease_table(lb);
+	while (!list_empty(&lease_table_list)) {
+		lb = list_first_entry(&lease_table_list, struct lease_table,
+				      l_entry);
+		lease = list_first_entry(&lb->lease_list, struct lease, l_entry);
+		lease_del_table(lease);
 	}
 	write_unlock(&lease_list_lock);
 }
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index e114e2148c30..5ef05166e502 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -34,7 +34,6 @@ struct lease_ctx_info {
 
 struct lease_table {
 	char			client_guid[SMB2_CLIENT_GUID_SIZE];
-	struct ksmbd_conn	*conn;
 	struct list_head	lease_list;
 	struct list_head	l_entry;
 	spinlock_t		lb_lock;
@@ -122,7 +121,7 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
 int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
-void destroy_lease_table(struct ksmbd_conn *conn);
+void destroy_lease_table(void);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx);
 void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 1cb995a36b21..effc539548dc 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -436,7 +436,6 @@ static int ksmbd_server_process_request(struct ksmbd_conn *conn)
 static int ksmbd_server_terminate_conn(struct ksmbd_conn *conn)
 {
 	ksmbd_conn_sessions_cleanup(conn);
-	destroy_lease_table(conn);
 	return 0;
 }
 
@@ -664,7 +663,7 @@ static int ksmbd_server_shutdown(void)
 	ksmbd_proc_cleanup();
 	ksmbd_crypto_destroy();
 	ksmbd_free_global_file_table();
-	destroy_lease_table(NULL);
+	destroy_lease_table();
 	ksmbd_work_pool_destroy();
 	ksmbd_exit_file_cache();
 	server_conf_free();
-- 
2.25.1

