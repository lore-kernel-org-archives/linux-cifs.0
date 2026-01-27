Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075D359F90
	for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769521263; cv=none; b=vF95P90Rxv9h9tSGfKKBjp+CBc2AEK2QL6VEnbhDr4BRykR4wzaRD8nX+5+x+VA4R5h+DUzAaw/azBDbVJix0i/O21VOtV/KFJ++0VFjzE2ThDaCJw1YWn2CmKbRlrY4LL+pFSLCfjH+/4QHOqtZ0yQyUDisRgGsyyGCe9/K53Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769521263; c=relaxed/simple;
	bh=XGOWJXYbzDYgL1YTt3vxVzVoY/qjO/ysPSydfNVW94E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lk6b3RzulARwdUh99FQcEJZEGE7YJ1yM7O0IiOCA0HbryOw9BmSZInqGTL/w5Cy5c6ovowf1ehGsqACMQIMqSquotR509pDVu0s/vCGnzbBKrjugqc74kawh9jRgmiUMV7tfk1iBpHwWLl77GQTfOnuSxbSWvwiaTUJdv+a1qxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29efd139227so39838795ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 05:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769521260; x=1770126060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJ7dpZ0AkNSZ83bO6mtJcuyIlekYHpspRILtvK5TgeE=;
        b=CHx2W1ca3h2+GmffEElsVSJGQAxKbcEOyPr0OnyVZeUCLWT7afPYTUpls+fnNuPyfp
         bRJXqG5Nut9tXOpY1/HP4SZc9/0vqFYqX28GdlDZIf3rKcjlTEb67uoKU9qTKIwkPamH
         rwM/WG5+cuIvfiBfnYNRysoGlH7hfIcsdOTZgsjn/ygD5JTOCLE8tesNd/ZAn/uPIetI
         TWEsagbKaX/9KXGRWwQZzbxAt3tqgkqLq7TJBg7hiaJYig5H8wnEU5H9AdUvnPvqFP0O
         1kHseIFbARV/PM3h8ugOuYed1lrjfER2CEDJwMhWhu0Rtoca/jvHcHqfMVqYVAIPTszl
         s8ew==
X-Gm-Message-State: AOJu0Yw7cDUa+ITNUjijdtbvJKQkViLTSwRF0IqGwwk8Qq23eE7jLe8D
	5UMTsVuDDqVPR3t+mvhyXWYCBvn1igcz2nCDld9ye+VKjsa7wSbAzsHRVx1QnA==
X-Gm-Gg: AZuq6aIw97rw2iv6lvdfiGOp3l3fSjr+4hcWW+egsAAOsGjdQREDc49lR7pW39Or2u9
	yipeFFaZX9q7ktp29MHBa2/LbmRtT/KfP2lNe618gotdr2wp2Kfdexy2rslq6WFBusKKOQvEahi
	CvJM0e+MtOaeZxznP0YWse+iKbgDXhcfubL4Z7qADXPg9W2AAHU23WK45JE5VR8NMUUg4UGSSKG
	K1HiwBvqk4WZ6McsqEMY48QtSls/BpgFyRZOy9ADQ/DLFkmq1YLV29GLpc5H7NsmGiJ1R2Ubrmv
	74tS2HDhRJh+ARTL3TLBki4NAaM84GI3ynlY6xGPOjLG95/r9CjBMQzvIwYzWvt7cG8Yt1uOSl9
	4YZQOkSETfl7rzOKAHdDMY0pykqpPJZw4xm9gmP8OMdczRKbHJziaYjg3IM56yteEAOwNMPscJw
	D897nSp9VZ1yxiuflNOWfdZzMgpA==
X-Received: by 2002:a17:902:f605:b0:2a7:5ad3:79eb with SMTP id d9443c01a7336-2a870e31222mr20307755ad.35.1769521260072;
        Tue, 27 Jan 2026 05:41:00 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802daa719sm120483475ad.14.2026.01.27.05.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 05:40:58 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Bahubali B Gumaji <bahubali.bg@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Sang-Soo Lee <constant.lee@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add procfs interface for runtime monitoring and statistics
Date: Tue, 27 Jan 2026 22:40:28 +0900
Message-Id: <20260127134028.6162-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bahubali B Gumaji <bahubali.bg@samsung.com>

This patch introduces a /proc filesystem interface to ksmbd, providing
visibility into the internal state of the SMB server. This allows
administrators and developers to monitor active connections, user
sessions, and opened files in real-time without relying on external
tools or heavy debugging.

Key changes include:
 - Connection Monitoring (/proc/fs/ksmbd/clients): Displays a list of
   active network connections, including client IP addresses, SMB dialects,
   credits, and last active timestamps.

 - Session Management (/proc/fs/ksmbd/sessions/): Adds a global sessions
   file to list all authenticated users and their session IDs.

 - Creates individual session entries (e.g., /proc/fs/ksmbd/sessions/<id>)
   detailing capabilities (DFS, Multi-channel, etc.), signing/encryption
   algorithms, and connected tree shares.

 - File Tracking (/proc/fs/ksmbd/files): Shows all currently opened files
   across the server, including tree IDs, process IDs (PID), access modes
   (daccess/saccess), and oplock/lease states.

 - Statistics & Counters: Implements internal counters for global server
   metrics, such as the number of tree connections, total sessions, and
   processed read/write bytes.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Bahubali B Gumaji <bahubali.bg@samsung.com>
Signed-off-by: Sang-Soo Lee  <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/Makefile            |   1 +
 fs/smb/server/connection.c        |  57 ++++++++
 fs/smb/server/connection.h        |   5 +-
 fs/smb/server/mgmt/tree_connect.c |   3 +
 fs/smb/server/mgmt/user_config.c  |   6 +-
 fs/smb/server/mgmt/user_config.h  |   2 +-
 fs/smb/server/mgmt/user_session.c | 216 ++++++++++++++++++++++++++++++
 fs/smb/server/mgmt/user_session.h |   5 +-
 fs/smb/server/misc.h              |  30 +++++
 fs/smb/server/proc.c              | 133 ++++++++++++++++++
 fs/smb/server/server.c            |  10 ++
 fs/smb/server/smb2ops.c           |   4 +
 fs/smb/server/smb2pdu.c           |   1 +
 fs/smb/server/smb_common.c        |  24 ++++
 fs/smb/server/smb_common.h        |   2 +
 fs/smb/server/stats.h             |  73 ++++++++++
 fs/smb/server/vfs.c               |   3 +
 fs/smb/server/vfs_cache.c         |  94 +++++++++++++
 18 files changed, 661 insertions(+), 8 deletions(-)
 create mode 100644 fs/smb/server/proc.c
 create mode 100644 fs/smb/server/stats.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 7d6337a7dee4..6407ba6b9340 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -18,3 +18,4 @@ $(obj)/ksmbd_spnego_negtokeninit.asn1.o: $(obj)/ksmbd_spnego_negtokeninit.asn1.c
 $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c $(obj)/ksmbd_spnego_negtokentarg.asn1.h
 
 ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
+ksmbd-$(CONFIG_PROC_FS) += proc.o
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 6cac48c8fbe8..236bfcb6db3d 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -14,6 +14,7 @@
 #include "connection.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
+#include "misc.h"
 
 static DEFINE_MUTEX(init_lock);
 
@@ -22,6 +23,60 @@ static struct ksmbd_conn_ops default_conn_ops;
 DEFINE_HASHTABLE(conn_list, CONN_HASH_BITS);
 DECLARE_RWSEM(conn_list_lock);
 
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry *proc_clients;
+
+static int proc_show_clients(struct seq_file *m, void *v)
+{
+	struct ksmbd_conn *conn;
+	struct timespec64 now, t;
+	int i;
+
+	seq_printf(m, "#%-20s %-10s %-10s %-10s %-10s %-10s\n",
+			"<name>", "<dialect>", "<credits>", "<open files>",
+			"<requests>", "<last active>");
+
+	down_read(&conn_list_lock);
+	hash_for_each(conn_list, i, conn, hlist) {
+		jiffies_to_timespec64(jiffies - conn->last_active, &t);
+		ktime_get_real_ts64(&now);
+		t = timespec64_sub(now, t);
+		if (conn->inet_addr)
+			seq_printf(m, "%-20pI4c", &conn->inet_addr);
+		else
+			seq_printf(m, "%-20pI6c", &conn->inet6_addr);
+		seq_printf(m, "   0x%-10x %-10u %-12d %-10d %ptT\n",
+			   conn->dialect,
+			   conn->total_credits,
+			   atomic_read(&conn->stats.open_files_count),
+			   atomic_read(&conn->req_running),
+			   &t);
+	}
+	up_read(&conn_list_lock);
+	return 0;
+}
+
+static int create_proc_clients(void)
+{
+	proc_clients = ksmbd_proc_create("clients",
+					 proc_show_clients, NULL);
+	if (!proc_clients)
+		return -ENOMEM;
+	return 0;
+}
+
+static void delete_proc_clients(void)
+{
+	if (proc_clients) {
+		proc_remove(proc_clients);
+		proc_clients = NULL;
+	}
+}
+#else
+static int create_proc_clients(void) { return 0; }
+static void delete_proc_clients(void) {}
+#endif
+
 /**
  * ksmbd_conn_free() - free resources of the connection instance
  *
@@ -472,6 +527,7 @@ int ksmbd_conn_transport_init(void)
 	}
 out:
 	mutex_unlock(&init_lock);
+	create_proc_clients();
 	return ret;
 }
 
@@ -502,6 +558,7 @@ static void stop_sessions(void)
 
 void ksmbd_conn_transport_destroy(void)
 {
+	delete_proc_clients();
 	mutex_lock(&init_lock);
 	ksmbd_tcp_destroy();
 	ksmbd_rdma_stop_listening();
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 7f9bcd9817b5..1e2587036bca 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -7,6 +7,7 @@
 #define __KSMBD_CONNECTION_H__
 
 #include <linux/list.h>
+#include <linux/inet.h>
 #include <linux/ip.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -33,7 +34,7 @@ enum {
 	KSMBD_SESS_RELEASING
 };
 
-struct ksmbd_stats {
+struct ksmbd_conn_stats {
 	atomic_t			open_files_count;
 	atomic64_t			request_served;
 };
@@ -78,7 +79,7 @@ struct ksmbd_conn {
 	struct list_head		requests;
 	struct list_head		async_requests;
 	int				connection_type;
-	struct ksmbd_stats		stats;
+	struct ksmbd_conn_stats		stats;
 	char				ClientGUID[SMB2_CLIENT_GUID_SIZE];
 	struct ntlmssp_auth		ntlmssp;
 
diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index d3483d9c757c..62b97936b545 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -9,6 +9,7 @@
 
 #include "../transport_ipc.h"
 #include "../connection.h"
+#include "../stats.h"
 
 #include "tree_connect.h"
 #include "user_config.h"
@@ -85,6 +86,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 		status.ret = -ENOMEM;
 		goto out_error;
 	}
+	ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS);
 	kvfree(resp);
 	return status;
 
@@ -115,6 +117,7 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_share_config_put(tree_conn->share_conf);
+	ksmbd_counter_dec(KSMBD_COUNTER_TREE_CONNS);
 	if (atomic_dec_and_test(&tree_conn->refcount))
 		kfree(tree_conn);
 	return ret;
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index 56c9a38ca878..3267b86b8c16 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -90,11 +90,9 @@ void ksmbd_free_user(struct ksmbd_user *user)
 	kfree(user);
 }
 
-int ksmbd_anonymous_user(struct ksmbd_user *user)
+bool ksmbd_anonymous_user(struct ksmbd_user *user)
 {
-	if (user->name[0] == '\0')
-		return 1;
-	return 0;
+	return user->name[0] == '\0';
 }
 
 bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2)
diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index 8c227b8d4954..cc460b4ff7d3 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -65,6 +65,6 @@ struct ksmbd_user *ksmbd_login_user(const char *account);
 struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		struct ksmbd_login_response_ext *resp_ext);
 void ksmbd_free_user(struct ksmbd_user *user);
-int ksmbd_anonymous_user(struct ksmbd_user *user);
+bool ksmbd_anonymous_user(struct ksmbd_user *user);
 bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2);
 #endif /* __USER_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 7d880ff34402..1471d027b012 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -12,9 +12,12 @@
 #include "user_session.h"
 #include "user_config.h"
 #include "tree_connect.h"
+#include "share_config.h"
 #include "../transport_ipc.h"
 #include "../connection.h"
 #include "../vfs_cache.h"
+#include "../misc.h"
+#include "../stats.h"
 
 static DEFINE_IDA(session_ida);
 
@@ -27,6 +30,215 @@ struct ksmbd_session_rpc {
 	unsigned int		method;
 };
 
+#ifdef CONFIG_PROC_FS
+
+static const struct ksmbd_const_name ksmbd_sess_cap_const_names[] = {
+	{SMB2_GLOBAL_CAP_DFS, "dfs"},
+	{SMB2_GLOBAL_CAP_LEASING, "lease"},
+	{SMB2_GLOBAL_CAP_LARGE_MTU, "large-mtu"},
+	{SMB2_GLOBAL_CAP_MULTI_CHANNEL, "multi-channel"},
+	{SMB2_GLOBAL_CAP_PERSISTENT_HANDLES, "persistent-handles"},
+	{SMB2_GLOBAL_CAP_DIRECTORY_LEASING, "dir-lease"},
+	{SMB2_GLOBAL_CAP_ENCRYPTION, "encryption"}
+};
+
+static const struct ksmbd_const_name ksmbd_cipher_const_names[] = {
+	{le16_to_cpu(SMB2_ENCRYPTION_AES128_CCM), "aes128-ccm"},
+	{le16_to_cpu(SMB2_ENCRYPTION_AES128_GCM), "aes128-gcm"},
+	{le16_to_cpu(SMB2_ENCRYPTION_AES256_CCM), "aes256-ccm"},
+	{le16_to_cpu(SMB2_ENCRYPTION_AES256_GCM), "aes256-gcm"},
+};
+
+static const struct ksmbd_const_name ksmbd_signing_const_names[] = {
+	{SIGNING_ALG_HMAC_SHA256, "hmac-sha256"},
+	{SIGNING_ALG_AES_CMAC, "aes-cmac"},
+	{SIGNING_ALG_AES_GMAC, "aes-gmac"},
+};
+
+static const char *session_state_string(struct ksmbd_session *session)
+{
+	switch (session->state) {
+	case SMB2_SESSION_VALID:
+		return "valid";
+	case SMB2_SESSION_IN_PROGRESS:
+		return "progress";
+	case SMB2_SESSION_EXPIRED:
+		return "expired";
+	default:
+		return "";
+	}
+}
+
+static const char *session_user_name(struct ksmbd_session *session)
+{
+	if (user_guest(session->user))
+		return "(Guest)";
+	else if (ksmbd_anonymous_user(session->user))
+		return "(Anonymous)";
+	return session->user->name;
+}
+
+static int show_proc_session(struct seq_file *m, void *v)
+{
+	struct ksmbd_session *sess;
+	struct ksmbd_tree_connect *tree_conn;
+	struct ksmbd_share_config *share_conf;
+	struct channel *chan;
+	unsigned long id;
+	int i = 0;
+
+	sess = (struct ksmbd_session *)m->private;
+	ksmbd_user_session_get(sess);
+
+	i = 0;
+	xa_for_each(&sess->ksmbd_chann_list, id, chan) {
+#if IS_ENABLED(CONFIG_IPV6)
+		if (chan->conn->inet_addr)
+			seq_printf(m, "%-20s\t%pI4c\n", "client",
+					&chan->conn->inet_addr);
+		else
+			seq_printf(m, "%-20s\t%pI6c\n", "client",
+					&chan->conn->inet6_addr);
+#else
+		seq_printf(m, "%-20s\t%pI4c\n", "client",
+				&chan->conn->inet_addr);
+#endif
+		seq_printf(m, "%-20s\t%s\n", "user", session_user_name(sess));
+		seq_printf(m, "%-20s\t%llu\n", "id", sess->id);
+		seq_printf(m, "%-20s\t%s\n", "state",
+				session_state_string(sess));
+
+		seq_printf(m, "%-20s\t", "capabilities");
+		ksmbd_proc_show_flag_names(m,
+				ksmbd_sess_cap_const_names,
+				ARRAY_SIZE(ksmbd_sess_cap_const_names),
+				chan->conn->vals->req_capabilities);
+
+		if (sess->sign) {
+			seq_printf(m, "%-20s\t", "signing");
+			ksmbd_proc_show_const_name(m, "%s\t",
+					ksmbd_signing_const_names,
+					ARRAY_SIZE(ksmbd_signing_const_names),
+					le16_to_cpu(chan->conn->signing_algorithm));
+		} else if (sess->enc) {
+			seq_printf(m, "%-20s\t", "encryption");
+			ksmbd_proc_show_const_name(m, "%s\t",
+					ksmbd_cipher_const_names,
+					ARRAY_SIZE(ksmbd_cipher_const_names),
+					le16_to_cpu(chan->conn->cipher_type));
+		}
+		i++;
+	}
+
+	seq_printf(m, "%-20s\t%d\n", "channels", i);
+
+	i = 0;
+	xa_for_each(&sess->tree_conns, id, tree_conn) {
+		share_conf = tree_conn->share_conf;
+		seq_printf(m, "%-20s\t%s\t%8d", "share",
+			   share_conf->name, tree_conn->id);
+		if (test_share_config_flag(share_conf, KSMBD_SHARE_FLAG_PIPE))
+			seq_printf(m, " %s ", "pipe");
+		else
+			seq_printf(m, " %s ", "disk");
+		seq_putc(m, '\n');
+	}
+
+	ksmbd_user_session_put(sess);
+	return 0;
+}
+
+void ksmbd_proc_show_flag_names(struct seq_file *m,
+				const struct ksmbd_const_name *table,
+				int count,
+				unsigned int flags)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (table[i].const_value & flags)
+			seq_printf(m, "0x%08x\t", table[i].const_value);
+	}
+	seq_putc(m, '\n');
+}
+
+void ksmbd_proc_show_const_name(struct seq_file *m,
+				const char *format,
+				const struct ksmbd_const_name *table,
+				int count,
+				unsigned int const_value)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (table[i].const_value & const_value)
+			seq_printf(m, format, table[i].name);
+	}
+	seq_putc(m, '\n');
+}
+
+static int create_proc_session(struct ksmbd_session *sess)
+{
+	char name[30];
+
+	snprintf(name, sizeof(name), "sessions/%llu", sess->id);
+	sess->proc_entry = ksmbd_proc_create(name,
+					     show_proc_session, sess);
+	return 0;
+}
+
+static void delete_proc_session(struct ksmbd_session *sess)
+{
+	if (sess->proc_entry)
+		proc_remove(sess->proc_entry);
+}
+
+static int show_proc_sessions(struct seq_file *m, void *v)
+{
+	struct ksmbd_session *session;
+	struct channel *chan;
+	int i;
+	unsigned long id;
+
+	seq_printf(m, "#%-40s %-15s %-10s %-10s\n",
+		   "<client>", "<user>", "<sess_id>", "<state>");
+
+	down_read(&sessions_table_lock);
+	hash_for_each(sessions_table, i, session, hlist) {
+		xa_for_each(&session->ksmbd_chann_list, id, chan) {
+		down_read(&chan->conn->session_lock);
+		ksmbd_user_session_get(session);
+
+		if (chan->conn->inet_addr)
+			seq_printf(m, " %-40pI4c", &chan->conn->inet_addr);
+		else
+			seq_printf(m, " %-40pI6c", &chan->conn->inet6_addr);
+		seq_printf(m, " %-15s %-10llu %-10s\n",
+			   session_user_name(session),
+			   session->id,
+			   session_state_string(session));
+
+		ksmbd_user_session_put(session);
+		up_read(&chan->conn->session_lock);
+	}
+	}
+	up_read(&sessions_table_lock);
+	return 0;
+}
+
+int create_proc_sessions(void)
+{
+	if (!ksmbd_proc_create("sessions/sessions",
+			       show_proc_sessions, NULL))
+		return -ENOMEM;
+	return 0;
+}
+#else
+int create_proc_sessions(void) { return 0; }
+static int create_proc_session(struct ksmbd_session *sess) { return 0; }
+static void delete_proc_session(struct ksmbd_session *sess) {}
+#endif
+
 static void free_channel_list(struct ksmbd_session *sess)
 {
 	struct channel *chann;
@@ -159,6 +371,8 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	if (!sess)
 		return;
 
+	delete_proc_session(sess);
+
 	if (sess->user)
 		ksmbd_free_user(sess->user);
 
@@ -465,6 +679,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
 
+	create_proc_session(sess);
+	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	return sess;
 
 error:
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index c5749d6ec715..176d800c2490 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -41,7 +41,6 @@ struct ksmbd_session {
 
 	bool				sign;
 	bool				enc;
-	bool				is_anonymous;
 
 	int				state;
 	__u8				*Preauth_HashValue;
@@ -62,6 +61,9 @@ struct ksmbd_session {
 	unsigned long			last_active;
 	rwlock_t			tree_conns_lock;
 
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry		*proc_entry;
+#endif
 	atomic_t			refcnt;
 	struct rw_semaphore		rpc_lock;
 };
@@ -111,4 +113,5 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id);
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id);
 void ksmbd_user_session_get(struct ksmbd_session *sess);
 void ksmbd_user_session_put(struct ksmbd_session *sess);
+int create_proc_sessions(void);
 #endif /* __USER_SESSION_MANAGEMENT_H__ */
diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index 1facfcd21200..13423696ae8c 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -6,6 +6,9 @@
 #ifndef __KSMBD_MISC_H__
 #define __KSMBD_MISC_H__
 
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
+#endif
 struct ksmbd_share_config;
 struct nls_table;
 struct kstat;
@@ -34,4 +37,31 @@ char *ksmbd_convert_dir_info_name(struct ksmbd_dir_info *d_info,
 struct timespec64 ksmbd_NTtimeToUnix(__le64 ntutc);
 u64 ksmbd_UnixTimeToNT(struct timespec64 t);
 long long ksmbd_systime(void);
+
+#ifdef CONFIG_PROC_FS
+struct ksmbd_const_name {
+	unsigned int const_value;
+	const char *name;
+};
+
+void ksmbd_proc_init(void);
+void ksmbd_proc_cleanup(void);
+void ksmbd_proc_reset(void);
+struct proc_dir_entry *ksmbd_proc_create(const char *name,
+					 int (*show)(struct seq_file *m, void *v),
+			     void *v);
+void ksmbd_proc_show_flag_names(struct seq_file *m,
+				const struct ksmbd_const_name *table,
+				int count,
+				unsigned int flags);
+void ksmbd_proc_show_const_name(struct seq_file *m,
+				const char *format,
+				const struct ksmbd_const_name *table,
+				int count,
+				unsigned int const_value);
+#else
+static inline void ksmbd_proc_init(void) {}
+static inline void ksmbd_proc_cleanup(void) {}
+static inline void ksmbd_proc_reset(void) {}
+#endif
 #endif /* __KSMBD_MISC_H__ */
diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
new file mode 100644
index 000000000000..a6d51e72a5ec
--- /dev/null
+++ b/fs/smb/server/proc.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2025, LG Electronics.
+ *   Author(s): Hyunchul Lee <hyc.lee@gmail.com>
+ *   Copyright (C) 2025, Samsung Electronics.
+ *   Author(s): Vedansh Bhardwaj <v.bhardwaj@samsung.com>
+ */
+
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+#include "misc.h"
+#include "server.h"
+#include "stats.h"
+#include "smb_common.h"
+#include "smb2pdu.h"
+
+static struct proc_dir_entry *ksmbd_proc_fs;
+
+struct proc_dir_entry *ksmbd_proc_create(const char *name,
+					 int (*show)(struct seq_file *m, void *v),
+						 void *v)
+{
+	return proc_create_single_data(name, 0400, ksmbd_proc_fs,
+			   show, v);
+}
+
+struct ksmbd_const_smb2_process_req {
+	unsigned int const_value;
+	const char *name;
+};
+
+static const struct ksmbd_const_smb2_process_req smb2_process_req[KSMBD_COUNTER_MAX_REQS] = {
+	{le16_to_cpu(SMB2_NEGOTIATE), "SMB2_NEGOTIATE"},
+	{le16_to_cpu(SMB2_SESSION_SETUP), "SMB2_SESSION_SETUP"},
+	{le16_to_cpu(SMB2_LOGOFF), "SMB2_LOGOFF"},
+	{le16_to_cpu(SMB2_TREE_CONNECT), "SMB2_TREE_CONNECT"},
+	{le16_to_cpu(SMB2_TREE_DISCONNECT), "SMB2_TREE_DISCONNECT"},
+	{le16_to_cpu(SMB2_CREATE), "SMB2_CREATE"},
+	{le16_to_cpu(SMB2_CLOSE), "SMB2_CLOSE"},
+	{le16_to_cpu(SMB2_FLUSH), "SMB2_FLUSH"},
+	{le16_to_cpu(SMB2_READ), "SMB2_READ"},
+	{le16_to_cpu(SMB2_WRITE), "SMB2_WRITE"},
+	{le16_to_cpu(SMB2_LOCK), "SMB2_LOCK"},
+	{le16_to_cpu(SMB2_IOCTL), "SMB2_IOCTL"},
+	{le16_to_cpu(SMB2_CANCEL), "SMB2_CANCEL"},
+	{le16_to_cpu(SMB2_ECHO), "SMB2_ECHO"},
+	{le16_to_cpu(SMB2_QUERY_DIRECTORY), "SMB2_QUERY_DIRECTORY"},
+	{le16_to_cpu(SMB2_CHANGE_NOTIFY), "SMB2_CHANGE_NOTIFY"},
+	{le16_to_cpu(SMB2_QUERY_INFO), "SMB2_QUERY_INFO"},
+	{le16_to_cpu(SMB2_SET_INFO), "SMB2_SET_INFO"},
+	{le16_to_cpu(SMB2_OPLOCK_BREAK), "SMB2_OPLOCK_BREAK"},
+};
+
+static int proc_show_ksmbd_stats(struct seq_file *m, void *v)
+{
+	int i;
+
+	seq_puts(m, "Server\n");
+	seq_printf(m, "name: %s\n", ksmbd_server_string());
+	seq_printf(m, "netbios: %s\n", ksmbd_netbios_name());
+	seq_printf(m, "work group: %s\n", ksmbd_work_group());
+	seq_printf(m, "min protocol: %s\n", ksmbd_get_protocol_string(server_conf.min_protocol));
+	seq_printf(m, "max protocol: %s\n", ksmbd_get_protocol_string(server_conf.max_protocol));
+	seq_printf(m, "flags: 0x%08x\n", server_conf.flags);
+	seq_printf(m, "share_fake_fscaps: 0x%08x\n",
+		   server_conf.share_fake_fscaps);
+	seq_printf(m, "sessions: %lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_SESSIONS));
+	seq_printf(m, "tree connects: %lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_TREE_CONNS));
+	seq_printf(m, "read bytes: %lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_READ_BYTES));
+	seq_printf(m, "written bytes: %lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_WRITE_BYTES));
+
+	seq_puts(m, "\nSMB2\n");
+	for (i = 0; i < KSMBD_COUNTER_MAX_REQS; i++)
+		seq_printf(m, "%-20s:\t%lld\n", smb2_process_req[i].name,
+			   ksmbd_counter_sum(KSMBD_COUNTER_FIRST_REQ + i));
+	return 0;
+}
+
+void ksmbd_proc_cleanup(void)
+{
+	int i;
+
+	if (!ksmbd_proc_fs)
+		return;
+
+	proc_remove(ksmbd_proc_fs);
+
+	for (i = 0; i < ARRAY_SIZE(ksmbd_counters.counters); i++)
+		percpu_counter_destroy(&ksmbd_counters.counters[i]);
+
+	ksmbd_proc_fs = NULL;
+}
+
+void ksmbd_proc_reset(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ksmbd_counters.counters); i++)
+		percpu_counter_set(&ksmbd_counters.counters[i], 0);
+}
+
+void ksmbd_proc_init(void)
+{
+	int i;
+	int retval;
+
+	ksmbd_proc_fs = proc_mkdir("fs/ksmbd", NULL);
+	if (!ksmbd_proc_fs)
+		return;
+
+	if (!proc_mkdir_mode("sessions", 0400, ksmbd_proc_fs))
+		goto err_out;
+
+	for (i = 0; i < ARRAY_SIZE(ksmbd_counters.counters); i++) {
+		retval = percpu_counter_init(&ksmbd_counters.counters[i], 0, GFP_KERNEL);
+		if (retval)
+			goto err_out;
+	}
+
+	if (!ksmbd_proc_create("server", proc_show_ksmbd_stats, NULL))
+		goto err_out;
+
+	ksmbd_proc_reset();
+	return;
+err_out:
+	ksmbd_proc_cleanup();
+}
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index d2410a3f163a..02e86a7cedc3 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -21,11 +21,14 @@
 #include "mgmt/user_session.h"
 #include "crypto_ctx.h"
 #include "auth.h"
+#include "misc.h"
+#include "stats.h"
 
 int ksmbd_debug_types;
 
 struct ksmbd_server_config server_conf;
 
+struct ksmbd_counters ksmbd_counters;
 enum SERVER_CTRL_TYPE {
 	SERVER_CTRL_TYPE_INIT,
 	SERVER_CTRL_TYPE_RESET,
@@ -145,6 +148,8 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	}
 
 	ret = cmds->proc(work);
+	if (conn->ops->inc_reqs)
+		conn->ops->inc_reqs(command);
 
 	if (ret < 0)
 		ksmbd_debug(CONN, "Failed to process %u [%d]\n", command, ret);
@@ -359,6 +364,7 @@ static void server_ctrl_handle_init(struct server_ctrl_struct *ctrl)
 {
 	int ret;
 
+	ksmbd_proc_reset();
 	ret = ksmbd_conn_transport_init();
 	if (ret) {
 		server_queue_ctrl_reset_work();
@@ -531,6 +537,7 @@ static int ksmbd_server_shutdown(void)
 {
 	WRITE_ONCE(server_conf.state, SERVER_STATE_SHUTTING_DOWN);
 
+	ksmbd_proc_cleanup();
 	class_unregister(&ksmbd_control_class);
 	ksmbd_workqueue_destroy();
 	ksmbd_ipc_release();
@@ -554,6 +561,9 @@ static int __init ksmbd_server_init(void)
 		return ret;
 	}
 
+	ksmbd_proc_init();
+	create_proc_sessions();
+
 	ksmbd_server_tcp_callbacks_init();
 
 	ret = server_conf_init();
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index edd7eca0714a..c9a32ee096b5 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -11,6 +11,7 @@
 #include "connection.h"
 #include "smb_common.h"
 #include "server.h"
+#include "stats.h"
 
 static struct smb_version_values smb21_server_values = {
 	.version_string = SMB21_VERSION_STRING,
@@ -121,6 +122,7 @@ static struct smb_version_values smb311_server_values = {
 
 static struct smb_version_ops smb2_0_server_ops = {
 	.get_cmd_val		=	get_smb2_cmd_val,
+	.inc_reqs		=	ksmbd_counter_inc_reqs,
 	.init_rsp_hdr		=	init_smb2_rsp_hdr,
 	.set_rsp_status		=	set_smb2_rsp_status,
 	.allocate_rsp_buf       =       smb2_allocate_rsp_buf,
@@ -134,6 +136,7 @@ static struct smb_version_ops smb2_0_server_ops = {
 
 static struct smb_version_ops smb3_0_server_ops = {
 	.get_cmd_val		=	get_smb2_cmd_val,
+	.inc_reqs		=	ksmbd_counter_inc_reqs,
 	.init_rsp_hdr		=	init_smb2_rsp_hdr,
 	.set_rsp_status		=	set_smb2_rsp_status,
 	.allocate_rsp_buf       =       smb2_allocate_rsp_buf,
@@ -152,6 +155,7 @@ static struct smb_version_ops smb3_0_server_ops = {
 
 static struct smb_version_ops smb3_11_server_ops = {
 	.get_cmd_val		=	get_smb2_cmd_val,
+	.inc_reqs		=	ksmbd_counter_inc_reqs,
 	.init_rsp_hdr		=	init_smb2_rsp_hdr,
 	.set_rsp_status		=	set_smb2_rsp_status,
 	.allocate_rsp_buf       =       smb2_allocate_rsp_buf,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fcd0d4d1fb0..4d3154cc493e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -39,6 +39,7 @@
 #include "mgmt/user_session.h"
 #include "mgmt/ksmbd_ida.h"
 #include "ndr.h"
+#include "stats.h"
 #include "transport_tcp.h"
 
 static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 1cd7e738434d..741aabdfcef5 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -98,6 +98,30 @@ inline int ksmbd_max_protocol(void)
 	return SMB311_PROT;
 }
 
+static const struct {
+	int version;
+	const char *string;
+} version_strings[] = {
+#ifdef CONFIG_SMB_INSECURE_SERVER
+	{SMB1_PROT, SMB1_VERSION_STRING},
+#endif
+	{SMB2_PROT, SMB20_VERSION_STRING},
+	{SMB21_PROT, SMB21_VERSION_STRING},
+	{SMB30_PROT, SMB30_VERSION_STRING},
+	{SMB302_PROT, SMB302_VERSION_STRING},
+	{SMB311_PROT, SMB311_VERSION_STRING},
+};
+
+const char *ksmbd_get_protocol_string(int version)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(version_strings); i++) {
+		if (version_strings[i].version == version)
+			return version_strings[i].string;
+	}
+	return "";
+}
 int ksmbd_lookup_protocol_idx(char *str)
 {
 	int offt = ARRAY_SIZE(smb1_protos) - 1;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index ddd6867c50b2..ca7e3610d074 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -143,6 +143,7 @@ struct file_id_both_directory_info {
 
 struct smb_version_ops {
 	u16 (*get_cmd_val)(struct ksmbd_work *swork);
+	void (*inc_reqs)(unsigned int cmd);
 	int (*init_rsp_hdr)(struct ksmbd_work *swork);
 	void (*set_rsp_status)(struct ksmbd_work *swork, __le32 err);
 	int (*allocate_rsp_buf)(struct ksmbd_work *work);
@@ -165,6 +166,7 @@ struct smb_version_cmds {
 
 int ksmbd_min_protocol(void);
 int ksmbd_max_protocol(void);
+const char *ksmbd_get_protocol_string(int version);
 
 int ksmbd_lookup_protocol_idx(char *str);
 
diff --git a/fs/smb/server/stats.h b/fs/smb/server/stats.h
new file mode 100644
index 000000000000..e59292603bf3
--- /dev/null
+++ b/fs/smb/server/stats.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2025, LG Electronics.
+ *   Author(s): Hyunchul Lee <hyc.lee@gmail.com>
+ *   Copyright (C) 2025, Samsung Electronics.
+ *   Author(s): Vedansh Bhardwaj <v.bhardwaj@samsung.com>
+ */
+
+#ifndef __KSMBD_STATS_H__
+#define __KSMBD_STATS_H__
+
+#define KSMBD_COUNTER_MAX_REQS	19
+
+enum {
+	KSMBD_COUNTER_SESSIONS = 0,
+	KSMBD_COUNTER_TREE_CONNS,
+	KSMBD_COUNTER_REQUESTS,
+	KSMBD_COUNTER_READ_BYTES,
+	KSMBD_COUNTER_WRITE_BYTES,
+	KSMBD_COUNTER_FIRST_REQ,
+	KSMBD_COUNTER_LAST_REQ = KSMBD_COUNTER_FIRST_REQ +
+				KSMBD_COUNTER_MAX_REQS - 1,
+	KSMBD_COUNTER_MAX,
+};
+
+extern struct ksmbd_counters ksmbd_counters;
+
+#ifdef CONFIG_PROC_FS
+struct ksmbd_counters {
+	struct percpu_counter	counters[KSMBD_COUNTER_MAX];
+};
+
+static inline void ksmbd_counter_inc(int type)
+{
+	percpu_counter_inc(&ksmbd_counters.counters[type]);
+}
+
+static inline void ksmbd_counter_dec(int type)
+{
+	percpu_counter_dec(&ksmbd_counters.counters[type]);
+}
+
+static inline void ksmbd_counter_add(int type, s64 value)
+{
+	percpu_counter_add(&ksmbd_counters.counters[type], value);
+}
+
+static inline void ksmbd_counter_sub(int type, s64 value)
+{
+	percpu_counter_sub(&ksmbd_counters.counters[type], value);
+}
+
+static inline void ksmbd_counter_inc_reqs(unsigned int cmd)
+{
+	if (cmd < KSMBD_COUNTER_MAX_REQS)
+		percpu_counter_inc(&ksmbd_counters.counters[KSMBD_COUNTER_FIRST_REQ + cmd]);
+}
+
+static inline s64 ksmbd_counter_sum(int type)
+{
+	return percpu_counter_sum_positive(&ksmbd_counters.counters[type]);
+}
+#else
+
+static inline void ksmbd_counter_inc(int type) {}
+static inline void ksmbd_counter_dec(int type) {}
+static inline void ksmbd_counter_add(int type, s64 value) {}
+static inline void ksmbd_counter_sub(int type, s64 value) {}
+static inline void ksmbd_counter_inc_reqs(unsigned int cmd) {}
+static inline s64 ksmbd_counter_sum(int type) { return 0; }
+#endif
+
+#endif
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b8e648b8300f..50cb772d38f2 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -31,6 +31,7 @@
 #include "ndr.h"
 #include "auth.h"
 #include "misc.h"
+#include "stats.h"
 
 #include "smb_common.h"
 #include "mgmt/share_config.h"
@@ -384,6 +385,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	}
 
 	filp->f_pos = *pos;
+	ksmbd_counter_add(KSMBD_COUNTER_READ_BYTES, (s64)nbytes);
 	return nbytes;
 }
 
@@ -521,6 +523,7 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 			pr_err("fsync failed for filename = %pD, err = %d\n",
 			       fp->filp, err);
 	}
+	ksmbd_counter_add(KSMBD_COUNTER_WRITE_BYTES, (s64)*written);
 
 out:
 	return err;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 6ef116585af6..e302e403e55a 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -16,10 +16,12 @@
 #include "oplock.h"
 #include "vfs.h"
 #include "connection.h"
+#include "misc.h"
 #include "mgmt/tree_connect.h"
 #include "mgmt/user_session.h"
 #include "smb_common.h"
 #include "server.h"
+#include "smb2pdu.h"
 
 #define S_DEL_PENDING			1
 #define S_DEL_ON_CLS			2
@@ -34,6 +36,97 @@ static struct ksmbd_file_table global_ft;
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
 
+#define OPLOCK_NONE      0
+#define OPLOCK_EXCLUSIVE 1
+#define OPLOCK_BATCH     2
+#define OPLOCK_READ      3  /* level 2 oplock */
+
+#ifdef CONFIG_PROC_FS
+
+static const struct ksmbd_const_name ksmbd_lease_const_names[] = {
+	{le32_to_cpu(SMB2_LEASE_NONE_LE), "LEASE_NONE"},
+	{le32_to_cpu(SMB2_LEASE_READ_CACHING_LE), "LEASE_R"},
+	{le32_to_cpu(SMB2_LEASE_HANDLE_CACHING_LE), "LEASE_H"},
+	{le32_to_cpu(SMB2_LEASE_WRITE_CACHING_LE), "LEASE_W"},
+	{le32_to_cpu(SMB2_LEASE_READ_CACHING_LE |
+		     SMB2_LEASE_HANDLE_CACHING_LE), "LEASE_RH"},
+	{le32_to_cpu(SMB2_LEASE_READ_CACHING_LE |
+		     SMB2_LEASE_WRITE_CACHING_LE), "LEASE_RW"},
+	{le32_to_cpu(SMB2_LEASE_HANDLE_CACHING_LE |
+		     SMB2_LEASE_WRITE_CACHING_LE), "LEASE_WH"},
+	{le32_to_cpu(SMB2_LEASE_READ_CACHING_LE |
+		     SMB2_LEASE_HANDLE_CACHING_LE |
+		     SMB2_LEASE_WRITE_CACHING_LE), "LEASE_RWH"},
+};
+
+static const struct ksmbd_const_name ksmbd_oplock_const_names[] = {
+	{SMB2_OPLOCK_LEVEL_NONE, "OPLOCK_NONE"},
+	{SMB2_OPLOCK_LEVEL_II, "OPLOCK_II"},
+	{SMB2_OPLOCK_LEVEL_EXCLUSIVE, "OPLOCK_EXECL"},
+	{SMB2_OPLOCK_LEVEL_BATCH, "OPLOCK_BATCH"},
+};
+
+static int proc_show_files(struct seq_file *m, void *v)
+{
+	struct ksmbd_file *fp = NULL;
+	unsigned int id;
+	struct oplock_info *opinfo;
+
+	seq_printf(m, "#%-10s %-10s %-10s %-10s %-15s %-10s %-10s %s\n",
+		   "<tree id>", "<pid>", "<vid>", "<refcnt>",
+		   "<oplock>", "<daccess>", "<saccess>",
+		   "<name>");
+
+	read_lock(&global_ft.lock);
+	idr_for_each_entry(global_ft.idr, fp, id) {
+		seq_printf(m, "%#-10x %#-10llx %#-10llx %#-10x",
+			   fp->tcon->id,
+			   fp->persistent_id,
+			   fp->volatile_id,
+			   atomic_read(&fp->refcount));
+
+		rcu_read_lock();
+		opinfo = rcu_dereference(fp->f_opinfo);
+		rcu_read_unlock();
+
+		if (!opinfo) {
+			seq_printf(m, " %-15s", " ");
+		} else {
+			const struct ksmbd_const_name *const_names;
+			int count;
+			unsigned int level;
+
+			if (opinfo->is_lease) {
+				const_names = ksmbd_lease_const_names;
+				count = ARRAY_SIZE(ksmbd_lease_const_names);
+				level = le32_to_cpu(opinfo->o_lease->state);
+			} else {
+				const_names = ksmbd_oplock_const_names;
+				count = ARRAY_SIZE(ksmbd_oplock_const_names);
+				level = opinfo->level;
+			}
+			ksmbd_proc_show_const_name(m, " %-15s",
+						   const_names, count, level);
+		}
+
+		seq_printf(m, " %#010x %#010x %s\n",
+			   le32_to_cpu(fp->daccess),
+			   le32_to_cpu(fp->saccess),
+			   fp->filp->f_path.dentry->d_name.name);
+	}
+	read_unlock(&global_ft.lock);
+	return 0;
+}
+
+static int create_proc_files(void)
+{
+	ksmbd_proc_create("files", proc_show_files, NULL);
+	return 0;
+}
+#else
+static int create_proc_files(void) { return 0; }
+#endif
+
 static bool durable_scavenger_running;
 static DEFINE_MUTEX(durable_scavenger_lock);
 static wait_queue_head_t dh_wq;
@@ -949,6 +1042,7 @@ void ksmbd_close_session_fds(struct ksmbd_work *work)
 
 int ksmbd_init_global_file_table(void)
 {
+	create_proc_files();
 	return ksmbd_init_file_table(&global_ft);
 }
 
-- 
2.25.1

