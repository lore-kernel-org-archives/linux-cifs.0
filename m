Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EB13F7AAA
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195849; cv=none; b=nlM7kL97yLcyeyOpnm3tQm96SfdikWcc/ERozdJwDWvtkD+2nR8LBobYoUWk8zM9aXV5/jOW5LG0KaA3LNVjbKPR/hDZ9xLopx+Psub3U4fFAJaq8w8D3yAkqLxg9Ewsi9+YTcVHoksoumwveq808KnFiC7XoIuLJqvBJVELGzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195849; c=relaxed/simple;
	bh=btFIsKcot8x5zlioOT/rVnIsgGhAr7TBdzXjgi83fS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ENVNbMwQ5tz494x0GMzOwMVZpd20DtCGRlWo3E0jvEB+/j9N9fmxKIh6T6yrh22nF+EJTUMOQkV3+ZtoBNrCBa099o4jCv2xqz/18dDL8AspyRxQDkwfyy9u53brPYCMafbY5LdkbvBw53NhN2Zs8RlH4I01i2v3V0sG5ZiqHjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+9PyzjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+9PyzjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193941F00A3A;
	Thu, 16 Jul 2026 09:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195847;
	bh=sT5NCmU0l8/0oXYpxnniHc4dzwsideNDnEqQphwsFsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+9PyzjIA8PdfgBoZCj5N1JRGRRLdOjjgCEUFv9oSkQ++9Bbn5mR/Ozt/oSRajSNp
	 eW8Dv+unHfV1FvR4D22uSTHKhvrSEFUNrrQPE+ntgEsu0akFgmnbiZg9XbPERphE+r
	 Kv2f4hILn7R3XofiZLt5vd3RMPlTrqrI1GGJVTtWYsQZDdbAy/uX/yuLolu5gkqks/
	 fT8qUtiAHKnQe83oI1uMXegssxmWfh1eW75D1L7bDAv1WqlCwJT5RQyTB9VT7yQdSe
	 Wbjq3FGYss3Ynyqxak3AHf24ZMYbDzh/K1IK6Jd5IppeUk5pBHhYaoJU1JrsU4WPqb
	 LFnUAOSqJ/o0A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6/7] ksmbd: add procfs monitoring for active shares
Date: Thu, 16 Jul 2026 18:57:09 +0900
Message-Id: <20260716095711.6228-6-linkinjeon@kernel.org>
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

There is no kernel-side view of the share configurations currently cached
by active tree connections.

Add a shares proc entry that reports each active share name, type,
tree-connection count, create masks, and descriptive configuration flags.
Maintain a per-share tree-connection counter with the existing global
counter so the value can be read without walking every session.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 57 +++++++++++++++++++++++++++++++
 fs/smb/server/mgmt/share_config.h | 25 ++++++++++++++
 fs/smb/server/mgmt/tree_connect.c |  2 ++
 fs/smb/server/server.c            |  1 +
 4 files changed, 85 insertions(+)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 6f97f8d39657..1cb58bec0903 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -28,6 +28,62 @@ struct ksmbd_veto_pattern {
 	struct list_head	list;
 };
 
+#ifdef CONFIG_PROC_FS
+static const struct ksmbd_const_name ksmbd_share_flag_names[] = {
+	{KSMBD_SHARE_FLAG_AVAILABLE, "available"},
+	{KSMBD_SHARE_FLAG_BROWSEABLE, "browseable"},
+	{KSMBD_SHARE_FLAG_WRITEABLE, "writeable"},
+	{KSMBD_SHARE_FLAG_READONLY, "read-only"},
+	{KSMBD_SHARE_FLAG_GUEST_OK, "guest-ok"},
+	{KSMBD_SHARE_FLAG_GUEST_ONLY, "guest-only"},
+	{KSMBD_SHARE_FLAG_STORE_DOS_ATTRS, "store-dos-attrs"},
+	{KSMBD_SHARE_FLAG_OPLOCKS, "oplocks"},
+	{KSMBD_SHARE_FLAG_PIPE, "pipe"},
+	{KSMBD_SHARE_FLAG_HIDE_DOT_FILES, "hide-dot-files"},
+	{KSMBD_SHARE_FLAG_INHERIT_OWNER, "inherit-owner"},
+	{KSMBD_SHARE_FLAG_STREAMS, "streams"},
+	{KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS, "follow-symlinks"},
+	{KSMBD_SHARE_FLAG_ACL_XATTR, "acl-xattr"},
+	{KSMBD_SHARE_FLAG_UPDATE, "update"},
+	{KSMBD_SHARE_FLAG_CROSSMNT, "crossmnt"},
+	{KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY, "continuous-availability"},
+};
+
+static int proc_show_shares(struct seq_file *m, void *v)
+{
+	struct ksmbd_share_config *share;
+	int i;
+
+	down_read(&shares_table_lock);
+	hash_for_each(shares_table, i, share, hlist) {
+		seq_printf(m, "name:\t%s\n", share->name);
+		seq_printf(m, "type:\t%s\n",
+			   test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE) ?
+			   "pipe" : "disk");
+		seq_printf(m, "tree_connects:\t%d\n",
+			   atomic_read(&share->tree_connections));
+		seq_printf(m, "file_mask:\t0%07o\n", share->create_mask);
+		seq_printf(m, "directory_mask:\t0%07o\n", share->directory_mask);
+		seq_puts(m, "flags:\t");
+		ksmbd_proc_show_flag_names(m, ksmbd_share_flag_names,
+					   ARRAY_SIZE(ksmbd_share_flag_names),
+					   share->flags);
+		seq_puts(m, "\n\n");
+	}
+	up_read(&shares_table_lock);
+	return 0;
+}
+
+int create_proc_shares(void)
+{
+	if (!ksmbd_proc_create("shares", proc_show_shares, NULL))
+		return -ENOMEM;
+	return 0;
+}
+#else
+int create_proc_shares(void) { return 0; }
+#endif
+
 static unsigned int share_name_hash(const char *name)
 {
 	return jhash(name, strlen(name), 0);
@@ -156,6 +212,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 
 	share->flags = resp->flags;
 	atomic_set(&share->refcount, 1);
+	ksmbd_share_tree_conn_init(share);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, KSMBD_DEFAULT_GFP);
 
diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index d4ac2dd4de20..d157545fe7d1 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -24,6 +24,9 @@ struct ksmbd_share_config {
 	struct path		vfs_path;
 
 	atomic_t		refcount;
+#ifdef CONFIG_PROC_FS
+	atomic_t		tree_connections;
+#endif
 	struct hlist_node	hlist;
 	unsigned short		create_mask;
 	unsigned short		directory_mask;
@@ -60,6 +63,27 @@ static inline int test_share_config_flag(struct ksmbd_share_config *share,
 	return share->flags & flag;
 }
 
+#ifdef CONFIG_PROC_FS
+static inline void ksmbd_share_tree_conn_init(struct ksmbd_share_config *share)
+{
+	atomic_set(&share->tree_connections, 0);
+}
+
+static inline void ksmbd_share_tree_conn_inc(struct ksmbd_share_config *share)
+{
+	atomic_inc(&share->tree_connections);
+}
+
+static inline void ksmbd_share_tree_conn_dec(struct ksmbd_share_config *share)
+{
+	atomic_dec(&share->tree_connections);
+}
+#else
+static inline void ksmbd_share_tree_conn_init(struct ksmbd_share_config *share) {}
+static inline void ksmbd_share_tree_conn_inc(struct ksmbd_share_config *share) {}
+static inline void ksmbd_share_tree_conn_dec(struct ksmbd_share_config *share) {}
+#endif
+
 void ksmbd_share_config_del(struct ksmbd_share_config *share);
 void __ksmbd_share_config_put(struct ksmbd_share_config *share);
 
@@ -74,4 +98,5 @@ struct ksmbd_share_config *ksmbd_share_config_get(struct ksmbd_work *work,
 						  const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
+int create_proc_shares(void);
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index 58e5b8592da4..5f63e236267a 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -88,6 +88,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 		goto out_error;
 	}
 	ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS);
+	ksmbd_share_tree_conn_inc(sc);
 	kvfree(resp);
 	return status;
 
@@ -116,6 +117,7 @@ static int __ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_counter_dec(KSMBD_COUNTER_TREE_CONNS);
+	ksmbd_share_tree_conn_dec(tree_conn->share_conf);
 	if (atomic_dec_and_test(&tree_conn->refcount)) {
 		ksmbd_share_config_put(tree_conn->share_conf);
 		kfree(tree_conn);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index b0e9689fd3c8..7a2730e71fd2 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -604,6 +604,7 @@ static int __init ksmbd_server_init(void)
 
 	ksmbd_proc_init();
 	create_proc_sessions();
+	create_proc_shares();
 
 	ksmbd_server_tcp_callbacks_init();
 
-- 
2.25.1

