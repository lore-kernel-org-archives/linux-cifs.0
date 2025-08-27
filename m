Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1680FDF49
	for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 01:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756258267; cv=none; b=ThTAeVGscfV77WPWem5GP+5Ykyu9uOTgLEs+Hhg8yfRNJXXFkvxa1Cd/U6iNygP5IsoUsqsdrbwOrib5f0sqfj3zRDzOuGMDZJ2v5+HqbuYIceNeEfrnCcHWdEyO4KOqMeoAFet/xmguAx/PFmZxlOgqiVcU2wbFugkLr8mcPjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756258267; c=relaxed/simple;
	bh=VmN/Mg8Je09ikr2EE5FrjDzcXvfQRsmqVUWZlHh1pCk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C+yEYEzyvyOni3PJEYi8yuXNUgovUT6R9kft8UuLf025ocTm8PFEjmSRzvGdhcj3WjAwoaT9MNfs5Xg+DGicneGFIJZhoK+S1uOkxlT0hjMEUA124asIzxEYTWaZf9mbi89P8bdDfEscn26Ftj0+VBOofKB6P34m6ousa9BtZaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-770d7dafacdso3352560b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 18:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756258265; x=1756863065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1UO+B0Zprzoa2I/MX7ZuBsNkibnWgKd15oKkjzA7o0=;
        b=dvMCVGzTtnYmA64yJ5E3PGl+Vheuz9SQ3ukNUEIrrTyRV/BztNobkZZJFklYCvDXWo
         0BabooIsyJxOfTiI5PAK9/Onvh53jkam4PYIKeqaqOlUw4MsucQI5DZWwf77ar6F9LYj
         xHdMNd7WCcDjIWIp3NEO3Eb4C3kFhQLRcCPkQ4whD+uqyRvo9iMu74DZqb8OCoMeIo6g
         /6jleUE4d1g9cHyf5Lo+ckjoS6ZSnc1MHZjSKd/xDc1AKQa3qzXVKv+IWH8nRAMurFHE
         Wva3M94V+Oag6JgYpQd/71GBnS/8dTWh/iwMawqlEYIAxiUsoFCLDUAfYoiz+VP3abH2
         wwrA==
X-Gm-Message-State: AOJu0YzI2vnRyUmFwumwPd1z2UV7yZo+M83GDRJM0nElY5m/XV89cj7H
	+T8DpzTVHnVhSURaIK3gOw6ju8Fq3Vg7otnRkFxar158OBOku2dBDbm8JIPzyA==
X-Gm-Gg: ASbGncv7sOWWsbe5qI2zEL3YOVnqm4oIYAjW9B3GwpD/y0KBIWiWD7lU+ITMEzvDdlo
	2hd4lCsLAE4TJudX0jgtsrlmju3qoaAG2XlzYyBEbgdUiivdBDsSaMvZIRGpq79lfLNqwdU0RAK
	dq2XVu1kpuefeZgvUQc3zeHoZv9e1VDv+DNUsl2zES5kP8wIlq2kKnicJy+MIiQahLIPHZoLr4Y
	/GsTw81uvwvvwCZyVaQ5GurF/EUb4uib8Jnvx+DZ2I8/eiL5WSW+FCaWAoIFGkL3tCOf9PnS8IZ
	v+dkytouFLtPupq52YnKjUwCuPWvoCK4+P7kvPpRFjCdyQ882LS0n7zYyP2ZrFIjLPs4pBvPNNG
	vraSfYOfh+4fRdWBqbz60ZQBZj3BMQ10MN1bJaJ0gQ83r6ljA
X-Google-Smtp-Source: AGHT+IFpTGd32C/JDy4U2ZUneG6QaAG0v+uUTjRdHNS3ZI8syPutnAr6iEXaJjAob8BWWwLF+YUlIw==
X-Received: by 2002:a05:6a20:939e:b0:23d:8af5:13b9 with SMTP id adf61e73a8af0-24340b01709mr27708311637.2.1756258264592;
        Tue, 26 Aug 2025 18:31:04 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771ea45a022sm5852911b3a.95.2025.08.26.18.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 18:31:03 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: replace connection list with hash table
Date: Wed, 27 Aug 2025 10:30:37 +0900
Message-Id: <20250827013038.12253-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace connection list with hash table to improve lookup performance.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c     | 23 +++++++++++------------
 fs/smb/server/connection.h     |  6 ++++--
 fs/smb/server/smb2pdu.c        |  4 ++--
 fs/smb/server/transport_rdma.c |  5 +++++
 fs/smb/server/transport_tcp.c  | 21 +++++++++++++++++----
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 67c4f73398df..86cc31ebc648 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -19,7 +19,7 @@ static DEFINE_MUTEX(init_lock);
 
 static struct ksmbd_conn_ops default_conn_ops;
 
-LIST_HEAD(conn_list);
+DEFINE_HASHTABLE(conn_list, CONN_HASH_BITS);
 DECLARE_RWSEM(conn_list_lock);
 
 /**
@@ -33,7 +33,7 @@ DECLARE_RWSEM(conn_list_lock);
 void ksmbd_conn_free(struct ksmbd_conn *conn)
 {
 	down_write(&conn_list_lock);
-	list_del(&conn->conns_list);
+	hash_del(&conn->hlist);
 	up_write(&conn_list_lock);
 
 	xa_destroy(&conn->sessions);
@@ -77,7 +77,6 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 
 	init_waitqueue_head(&conn->req_running_q);
 	init_waitqueue_head(&conn->r_count_q);
-	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
 	spin_lock_init(&conn->request_lock);
@@ -90,19 +89,17 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 
 	init_rwsem(&conn->session_lock);
 
-	down_write(&conn_list_lock);
-	list_add(&conn->conns_list, &conn_list);
-	up_write(&conn_list_lock);
 	return conn;
 }
 
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c)
 {
 	struct ksmbd_conn *t;
+	int bkt;
 	bool ret = false;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(t, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, t, hlist) {
 		if (memcmp(t->ClientGUID, c->ClientGUID, SMB2_CLIENT_GUID_SIZE))
 			continue;
 
@@ -163,9 +160,10 @@ void ksmbd_conn_unlock(struct ksmbd_conn *conn)
 void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
 {
 	struct ksmbd_conn *conn;
+	int bkt;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		if (conn->binding || xa_load(&conn->sessions, sess_id))
 			WRITE_ONCE(conn->status, status);
 	}
@@ -181,14 +179,14 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 {
 	struct ksmbd_conn *conn;
 	int rc, retry_count = 0, max_timeout = 120;
-	int rcount = 1;
+	int rcount = 1, bkt;
 
 retry_idle:
 	if (retry_count >= max_timeout)
 		return -EIO;
 
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
 			if (conn == curr_conn)
 				rcount = 2;
@@ -480,10 +478,11 @@ static void stop_sessions(void)
 {
 	struct ksmbd_conn *conn;
 	struct ksmbd_transport *t;
+	int bkt;
 
 again:
 	down_read(&conn_list_lock);
-	list_for_each_entry(conn, &conn_list, conns_list) {
+	hash_for_each(conn_list, bkt, conn, hlist) {
 		t = conn->transport;
 		ksmbd_conn_set_exiting(conn);
 		if (t->ops->shutdown) {
@@ -494,7 +493,7 @@ static void stop_sessions(void)
 	}
 	up_read(&conn_list_lock);
 
-	if (!list_empty(&conn_list)) {
+	if (!hash_empty(conn_list)) {
 		msleep(100);
 		goto again;
 	}
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 2aa8084bb593..78633ad1175c 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -52,11 +52,12 @@ struct ksmbd_conn {
 		u8			inet6_addr[16];
 #endif
 	};
+	unsigned int			inet_hash;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
 	struct unicode_map		*um;
-	struct list_head		conns_list;
+	struct hlist_node		hlist;
 	struct rw_semaphore		session_lock;
 	/* smb session 1 per user */
 	struct xarray			sessions;
@@ -151,7 +152,8 @@ struct ksmbd_transport {
 #define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
 #define KSMBD_TCP_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
 
-extern struct list_head conn_list;
+#define CONN_HASH_BITS	12
+extern DECLARE_HASHTABLE(conn_list, CONN_HASH_BITS);
 extern struct rw_semaphore conn_list_lock;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a565fc36cee6..848a621247d9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7352,7 +7352,7 @@ int smb2_lock(struct ksmbd_work *work)
 	int nolock = 0;
 	LIST_HEAD(lock_list);
 	LIST_HEAD(rollback_list);
-	int prior_lock = 0;
+	int prior_lock = 0, bkt;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -7462,7 +7462,7 @@ int smb2_lock(struct ksmbd_work *work)
 		nolock = 1;
 		/* check locks in connection list */
 		down_read(&conn_list_lock);
-		list_for_each_entry(conn, &conn_list, conns_list) {
+		hash_for_each(conn_list, bkt, conn, hlist) {
 			spin_lock(&conn->llist_lock);
 			list_for_each_entry_safe(cmp_lock, tmp2, &conn->lock_list, clist) {
 				if (file_inode(cmp_lock->fl->c.flc_file) !=
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5466aa8c39b1..e221efc5eaf5 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -375,6 +375,11 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	conn = ksmbd_conn_alloc();
 	if (!conn)
 		goto err;
+
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, 0);
+	up_write(&conn_list_lock);
+
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_smb_direct_transport_ops;
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4337df97987d..bbde4560fb8a 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -86,13 +86,20 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	}
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (client_sk->sk->sk_family == AF_INET6)
+	if (client_sk->sk->sk_family == AF_INET6) {
 		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
-	else
+		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+	} else {
 		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
+		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+	}
 #else
 	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 #endif
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, conn->inet_hash);
+	up_write(&conn_list_lock);
+
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
@@ -237,7 +244,7 @@ static int ksmbd_kthread_fn(void *p)
 	struct socket *client_sk = NULL;
 	struct interface *iface = (struct interface *)p;
 	struct ksmbd_conn *conn;
-	int ret;
+	int ret, inet_hash;
 
 	while (!kthread_should_stop()) {
 		mutex_lock(&iface->sock_release_lock);
@@ -258,8 +265,13 @@ static int ksmbd_kthread_fn(void *p)
 		/*
 		 * Limits repeated connections from clients with the same IP.
 		 */
+		if (client_sk->sk->sk_family == AF_INET6)
+			inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+		else
+			inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
+
 		down_read(&conn_list_lock);
-		list_for_each_entry(conn, &conn_list, conns_list)
+		hash_for_each_possible(conn_list, conn, hlist, inet_hash) {
 #if IS_ENABLED(CONFIG_IPV6)
 			if (client_sk->sk->sk_family == AF_INET6) {
 				if (memcmp(&client_sk->sk->sk_v6_daddr,
@@ -279,6 +291,7 @@ static int ksmbd_kthread_fn(void *p)
 				break;
 			}
 #endif
+		}
 		up_read(&conn_list_lock);
 		if (ret == -EAGAIN)
 			continue;
-- 
2.25.1

