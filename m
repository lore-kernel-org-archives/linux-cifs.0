Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18873DA7D1
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 09:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195847; cv=none; b=HT165ObZ20FJwRUqFJlIWblNFoPxvrtjlBvQ9ei+ocdBwEK65poRh///Nf3F0WRU1T3JtCCH4vxiirAYRxiGgcTYtVqQyRJM3aTdY0gs+PwNYsemKo973J+DCL8rbxbq0zhBVAD3OTgUXjbyJBDG+K/ZzJdh6L6Gwd7zNnGqm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195847; c=relaxed/simple;
	bh=lUHa2C9F3uV7lfjECEhFcKHwCFB+V53xlY3A8HYVWCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fXcWWjPpgWxEaHzi8X/g7kISL0St6QsVrWMGkFZ7bhT9zoBQfQ7i2KYxZw0LYPGRD7ABfmddH1q3VVVDm4GESPirMZQCxlFR8CK4CtARJJEoyUvyRU6wchOyQJTb2jGk8lNwOW4k45YSvntkLcHOJtsrqOMcJNLgJuBLBQlKqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lkexsfa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lkexsfa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481941F000E9;
	Thu, 16 Jul 2026 09:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195845;
	bh=qH2UNO9VB7WSzUUmbKrRg6LweuGi9hPRrWFRGH4XDjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lkexsfa3AymaQe+t//hN9WwV0nOedgt3uzvrfI/E+wky8Kwyk2vDoELe/fTZQOrHf
	 /O+petyAQS8lHHjHEU0EFPjxqrJuzuPZcjFb4HByFh/j5FGeZCIrl/VieBBuAxgizH
	 YsF9EOehONypTyrjkDQOeynxWhaQa1Bmvy4stZY8uuOLEJejw6iZMCFc3Ci14UwZ2l
	 rQP3nJ8otZ3S6g6wx7HN+wopPGVe5oqGB47kmqE7QvIyUSpqAot55bz79eJ/kyCgkN
	 +BOsBgj19EoBcn414GvHZA4tJyT09d7ptAYWnYQ9PU5/LYn4bUEoKOqZy+vfGz2mHZ
	 3GpSTQu0q82wQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/7] ksmbd: report session and open file details in procfs
Date: Thu, 16 Jul 2026 18:57:08 +0900
Message-Id: <20260716095711.6228-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716095711.6228-1-linkinjeon@kernel.org>
References: <20260716095711.6228-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Session and file proc entries lack the state needed to correlate inactive
sessions with durable or delete-pending opens.

Add the account type, dialect, idle time, open-file count, tree-connect
count, and per-channel POSIX negotiation state to session entries. Extend
the open-file table with the file state, durable timeout, create options,
share access, and descriptive flags for durable, persistent, resilient,
delete-on-close, stream, POSIX, and attribute-only opens.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 82 ++++++++++++++++++++----------
 fs/smb/server/vfs_cache.c         | 84 +++++++++++++++++++++++++------
 2 files changed, 123 insertions(+), 43 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 09c944a67141..b2bc8119984f 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -78,6 +78,28 @@ static const char *session_user_name(struct ksmbd_session *session)
 	return session->user->name;
 }
 
+static const char *session_account_type(struct ksmbd_session *session)
+{
+	if (user_guest(session->user))
+		return "guest";
+	if (ksmbd_anonymous_user(session->user))
+		return "anonymous";
+	return "user";
+}
+
+static unsigned int session_open_file_count(struct ksmbd_session *session)
+{
+	struct ksmbd_file *fp;
+	unsigned int count = 0;
+	unsigned int id;
+
+	read_lock(&session->file_table.lock);
+	idr_for_each_entry(session->file_table.idr, fp, id)
+		count++;
+	read_unlock(&session->file_table.lock);
+	return count;
+}
+
 static int show_proc_session(struct seq_file *m, void *v)
 {
 	struct ksmbd_session *sess;
@@ -90,9 +112,16 @@ static int show_proc_session(struct seq_file *m, void *v)
 	sess = (struct ksmbd_session *)m->private;
 	ksmbd_user_session_get(sess);
 
-	seq_printf(m, "%-20s\t%s\n", "user", session_user_name(sess));
-	seq_printf(m, "%-20s\t%llu\n", "id", sess->id);
-	seq_printf(m, "%-20s\t%s\n", "state", session_state_string(sess));
+	seq_printf(m, "user:\t%s\n", session_user_name(sess));
+	seq_printf(m, "account_type:\t%s\n",
+		   session_account_type(sess));
+	seq_printf(m, "id:\t%llu\n", sess->id);
+	seq_printf(m, "state:\t%s\n", session_state_string(sess));
+	seq_printf(m, "dialect:\t0x%04x\n", sess->dialect);
+	seq_printf(m, "last_active_seconds:\t%lu\n",
+		   jiffies_to_msecs(jiffies - sess->last_active) / MSEC_PER_SEC);
+	seq_printf(m, "open_files:\t%u\n",
+		   session_open_file_count(sess));
 
 	i = 0;
 	down_read(&sess->chann_lock);
@@ -101,21 +130,23 @@ static int show_proc_session(struct seq_file *m, void *v)
 
 #if IS_ENABLED(CONFIG_IPV6)
 		if (chan->conn->inet_addr)
-			seq_printf(m, "%-20s\t%pI4\n", "client",
+			seq_printf(m, "client:\t%pI4\n",
 					&chan->conn->inet_addr);
 		else
-			seq_printf(m, "%-20s\t%pI6c\n", "client",
+			seq_printf(m, "client:\t%pI6c\n",
 					&chan->conn->inet6_addr);
 #else
-		seq_printf(m, "%-20s\t%pI4\n", "client",
+		seq_printf(m, "client:\t%pI4\n",
 				&chan->conn->inet_addr);
 #endif
-		seq_printf(m, "%-20s\t", "capabilities");
+		seq_puts(m, "capabilities:\t");
 		ksmbd_proc_show_flag_names(m,
 				ksmbd_sess_cap_const_names,
 				ARRAY_SIZE(ksmbd_sess_cap_const_names),
 				chan->conn->vals->req_capabilities);
 		seq_putc(m, '\n');
+		seq_printf(m, "posix_extensions:\t%s\n",
+			   chan->conn->posix_ext_supported ? "yes" : "no");
 
 		if (sess->sign) {
 			unsigned int algorithm =
@@ -125,9 +156,9 @@ static int show_proc_session(struct seq_file *m, void *v)
 						     ARRAY_SIZE(ksmbd_signing_const_names),
 						     algorithm);
 			if (name)
-				seq_printf(m, "%-20s\t%s\n", "signing", name);
+				seq_printf(m, "signing:\t%s\n", name);
 			else
-				seq_printf(m, "%-20s\t0x%04x\n", "signing",
+				seq_printf(m, "signing:\t0x%04x\n",
 					   algorithm);
 		}
 		if (sess->enc) {
@@ -137,30 +168,30 @@ static int show_proc_session(struct seq_file *m, void *v)
 						     ARRAY_SIZE(ksmbd_cipher_const_names),
 						     cipher);
 			if (name)
-				seq_printf(m, "%-20s\t%s\n", "encryption", name);
+				seq_printf(m, "encryption:\t%s\n", name);
 			else
-				seq_printf(m, "%-20s\t0x%04x\n", "encryption",
+				seq_printf(m, "encryption:\t0x%04x\n",
 					   cipher);
 		}
 		i++;
 	}
 	up_read(&sess->chann_lock);
 
-	seq_printf(m, "%-20s\t%d\n", "channels", i);
+	seq_printf(m, "channels:\t%d\n", i);
 
 	i = 0;
 	down_read(&sess->tree_conns_lock);
 	xa_for_each(&sess->tree_conns, id, tree_conn) {
 		share_conf = tree_conn->share_conf;
-		seq_printf(m, "%-20s\t%s\t%8d", "share",
-			   share_conf->name, tree_conn->id);
-		if (test_share_config_flag(share_conf, KSMBD_SHARE_FLAG_PIPE))
-			seq_printf(m, " %s ", "pipe");
-		else
-			seq_printf(m, " %s ", "disk");
-		seq_putc(m, '\n');
+		seq_printf(m, "share:\t%s\n", share_conf->name);
+		seq_printf(m, "tree_id:\t%d\n", tree_conn->id);
+		seq_printf(m, "share_type:\t%s\n",
+			   test_share_config_flag(share_conf, KSMBD_SHARE_FLAG_PIPE) ?
+			   "pipe" : "disk");
+		i++;
 	}
 	up_read(&sess->tree_conns_lock);
+	seq_printf(m, "tree_connects:\t%d\n", i);
 
 	ksmbd_user_session_put(sess);
 	return 0;
@@ -189,9 +220,6 @@ static int show_proc_sessions(struct seq_file *m, void *v)
 	int i;
 	unsigned long id;
 
-	seq_printf(m, "#%-40s %-15s %-10s %-10s\n",
-		   "<client>", "<user>", "<sess_id>", "<state>");
-
 	down_read(&sessions_table_lock);
 	hash_for_each(sessions_table, i, session, hlist) {
 		down_read(&session->chann_lock);
@@ -201,13 +229,13 @@ static int show_proc_sessions(struct seq_file *m, void *v)
 
 #if IS_ENABLED(CONFIG_IPV6)
 			if (!chan->conn->inet_addr)
-				seq_printf(m, " %-40pI6c", &chan->conn->inet6_addr);
+				seq_printf(m, "client:\t%pI6c\n", &chan->conn->inet6_addr);
 			else
 #endif
-				seq_printf(m, " %-40pI4", &chan->conn->inet_addr);
-			seq_printf(m, " %-15s %-10llu %-10s\n",
-				   session_user_name(session),
-				   session->id,
+				seq_printf(m, "client:\t%pI4\n", &chan->conn->inet_addr);
+			seq_printf(m, "user:\t%s\n", session_user_name(session));
+			seq_printf(m, "id:\t%llu\n", session->id);
+			seq_printf(m, "state:\t%s\n\n",
 				   session_state_string(session));
 
 			ksmbd_user_session_put(session);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c867cf32ae9c..5c1929a81234 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -70,24 +70,63 @@ static const struct ksmbd_const_name ksmbd_oplock_const_names[] = {
 	{SMB2_OPLOCK_LEVEL_BATCH, "OPLOCK_BATCH"},
 };
 
+static const struct ksmbd_const_name ksmbd_file_state_names[] = {
+	{FP_NEW, "new"},
+	{FP_INITED, "open"},
+	{FP_CLOSED, "closed"},
+};
+
+#define KSMBD_PROC_FILE_DURABLE		BIT(0)
+#define KSMBD_PROC_FILE_PERSISTENT	BIT(1)
+#define KSMBD_PROC_FILE_RESILIENT	BIT(2)
+#define KSMBD_PROC_FILE_DELETE_ON_CLOSE	BIT(3)
+#define KSMBD_PROC_FILE_STREAM		BIT(4)
+#define KSMBD_PROC_FILE_POSIX		BIT(5)
+#define KSMBD_PROC_FILE_ATTRIB_ONLY	BIT(6)
+
+static const struct ksmbd_const_name ksmbd_file_flag_names[] = {
+	{KSMBD_PROC_FILE_DURABLE, "durable"},
+	{KSMBD_PROC_FILE_PERSISTENT, "persistent"},
+	{KSMBD_PROC_FILE_RESILIENT, "resilient"},
+	{KSMBD_PROC_FILE_DELETE_ON_CLOSE, "delete-on-close"},
+	{KSMBD_PROC_FILE_STREAM, "stream"},
+	{KSMBD_PROC_FILE_POSIX, "posix"},
+	{KSMBD_PROC_FILE_ATTRIB_ONLY, "attrib-only"},
+};
+
+static unsigned int ksmbd_proc_file_flags(struct ksmbd_file *fp)
+{
+	unsigned int flags = 0;
+
+	if (fp->is_durable)
+		flags |= KSMBD_PROC_FILE_DURABLE;
+	if (fp->is_persistent)
+		flags |= KSMBD_PROC_FILE_PERSISTENT;
+	if (fp->is_resilient)
+		flags |= KSMBD_PROC_FILE_RESILIENT;
+	if (fp->coption & FILE_DELETE_ON_CLOSE_LE)
+		flags |= KSMBD_PROC_FILE_DELETE_ON_CLOSE;
+	if (fp->stream.name)
+		flags |= KSMBD_PROC_FILE_STREAM;
+	if (fp->is_posix_ctxt)
+		flags |= KSMBD_PROC_FILE_POSIX;
+	if (fp->attrib_only)
+		flags |= KSMBD_PROC_FILE_ATTRIB_ONLY;
+	return flags;
+}
+
 static int proc_show_files(struct seq_file *m, void *v)
 {
 	struct ksmbd_file *fp = NULL;
 	unsigned int id;
 	struct oplock_info *opinfo;
 
-	seq_printf(m, "#%-10s %-18s %-18s %-10s %-16s %-10s %-10s %s\n",
-		   "<tree id>", "<pid>", "<vid>", "<refcnt>",
-		   "<oplock>", "<daccess>", "<saccess>",
-		   "<name>");
-
 	read_lock(&global_ft.lock);
 	idr_for_each_entry(global_ft.idr, fp, id) {
-		seq_printf(m, " %#-10x %#-18llx %#-18llx %#-10x",
-			   fp->tcon ? fp->tcon->id : 0,
-			   fp->persistent_id,
-			   fp->volatile_id,
-			   atomic_read(&fp->refcount));
+		seq_printf(m, "tree_id:\t0x%x\n", fp->tcon ? fp->tcon->id : 0);
+		seq_printf(m, "persistent_id:\t0x%llx\n", fp->persistent_id);
+		seq_printf(m, "volatile_id:\t0x%llx\n", fp->volatile_id);
+		seq_printf(m, "refcount:\t%d\n", atomic_read(&fp->refcount));
 
 		rcu_read_lock();
 		opinfo = rcu_dereference(fp->f_opinfo);
@@ -109,17 +148,30 @@ static int proc_show_files(struct seq_file *m, void *v)
 			rcu_read_unlock();
 			name = ksmbd_proc_const_name(const_names, count, level);
 			if (name)
-				seq_printf(m, " %-16s", name);
+				seq_printf(m, "oplock:\t%s\n", name);
 			else
-				seq_printf(m, " 0x%-14x", level);
+				seq_printf(m, "oplock:\t0x%x\n", level);
 		} else {
 			rcu_read_unlock();
-			seq_printf(m, " %-16s", " ");
+			seq_puts(m, "oplock:\tnone\n");
 		}
 
-		seq_printf(m, " %#010x %#010x %s\n",
-			   le32_to_cpu(fp->daccess),
-			   le32_to_cpu(fp->saccess),
+		seq_printf(m, "state:\t%s\n",
+			   ksmbd_proc_const_name(ksmbd_file_state_names,
+						 ARRAY_SIZE(ksmbd_file_state_names),
+						 fp->f_state));
+		seq_printf(m, "durable_timeout:\t%u\n", fp->durable_timeout);
+		seq_printf(m, "create_options:\t0x%08x\n",
+			   le32_to_cpu(fp->coption));
+		seq_printf(m, "desired_access:\t0x%08x\n",
+			   le32_to_cpu(fp->daccess));
+		seq_printf(m, "share_access:\t0x%08x\n",
+			   le32_to_cpu(fp->saccess));
+		seq_puts(m, "flags:\t");
+		ksmbd_proc_show_flag_names(m, ksmbd_file_flag_names,
+					   ARRAY_SIZE(ksmbd_file_flag_names),
+					   ksmbd_proc_file_flags(fp));
+		seq_printf(m, "\nname:\t%s\n\n",
 			   fp->filp->f_path.dentry->d_name.name);
 	}
 	read_unlock(&global_ft.lock);
-- 
2.25.1

