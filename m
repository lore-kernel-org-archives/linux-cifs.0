Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABC3C433E3
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6FA20708
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="skCv42qp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgGFPcE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:32:04 -0400
Received: from mx.cjr.nz ([51.158.111.142]:53944 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgGFPcE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:32:04 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8DBC0807C5;
        Mon,  6 Jul 2020 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594049128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3am+YryJ17NQqqouKEe3/bjGDiNYyfHi7r+fCzMkV8k=;
        b=skCv42qpGDZYo88C149vGfJaggbWfExko0ibubozxl0g2OBQsLryV0ikWVrYW1RsZVIEqq
        KS18mydckN/7nqNUGOdcwHT+yeWbSGs4JU/YZBliYoiy/A6zuiAN7v2NE0Wvfw1z+bAUbh
        Zf0o6ZZ7AXb72EHouFcTcxDyWQXSOZKzfg72zV8LU4FeoMHuDzQESWB1PKP+mvlCQKG2xm
        0jl44lvz4APlGeR4jhxcPXJ3xO6kT775CCJQMRoOFnsiP6bbN1gpEi0LjEmrckhevmqNEw
        9hoWDqcfIWDXDQ1RvP4ocuDRHjxpsJZ2p2YGdrBpdWxhBr0q8BVmgsgnRFf99Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 5/7] cifs: handle RESP_GET_DFS_REFERRAL.PathConsumed in reconnect
Date:   Mon,  6 Jul 2020 12:24:00 -0300
Message-Id: <20200706152402.5721-6-pc@cjr.nz>
In-Reply-To: <20200706152402.5721-1-pc@cjr.nz>
References: <20200706152402.5721-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use PathConsumed field when parsing prefixes of referral paths that
either match a cache entry or are a complete prefix path of an
existing entry.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsproto.h |  3 +--
 fs/cifs/connect.c   | 13 +++++++----
 fs/cifs/dfs_cache.c | 57 ++++++++++++++++++++++++++++++++++-----------
 fs/cifs/dfs_cache.h |  7 +++---
 fs/cifs/misc.c      |  7 +++---
 5 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 93b018723abf..577084487b1a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -616,8 +616,7 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 
 struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
 void cifs_put_tcp_super(struct super_block *sb);
-int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
-			 size_t prefix_len);
+int update_super_prepath(struct cifs_tcon *tcon, char *prefix);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 721ef2a53f65..2abef1c8feb3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5548,6 +5548,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	size_t tcp_host_len;
 	const char *dfs_host;
 	size_t dfs_host_len;
+	char *share = NULL, *prefix = NULL;
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
 	if (!tree)
@@ -5570,11 +5571,12 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
 	for (it = dfs_cache_get_tgt_iterator(&tl); it; it = dfs_cache_get_next_tgt(&tl, it)) {
-		const char *share, *prefix;
-		size_t share_len, prefix_len;
 		bool target_match;
 
-		rc = dfs_cache_get_tgt_share(it, &share, &share_len, &prefix, &prefix_len);
+		kfree(share);
+		kfree(prefix);
+
+		rc = dfs_cache_get_tgt_share(tcon->dfs_path + 1, it, &share, &prefix);
 		if (rc) {
 			cifs_dbg(VFS, "%s: failed to parse target share %d\n",
 				 __func__, rc);
@@ -5607,7 +5609,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 			scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
 			if (!rc) {
-				rc = update_super_prepath(tcon, prefix, prefix_len);
+				rc = update_super_prepath(tcon, prefix);
 				break;
 			}
 		}
@@ -5615,6 +5617,9 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 			break;
 	}
 
+	kfree(share);
+	kfree(prefix);
+
 	if (!rc) {
 		if (it)
 			rc = dfs_cache_noreq_update_tgthint(tcon->dfs_path + 1, it);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index dae2f41e4f21..a44f58bbf7ab 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -29,6 +29,7 @@
 
 struct cache_dfs_tgt {
 	char *name;
+	int path_consumed;
 	struct list_head list;
 };
 
@@ -350,7 +351,7 @@ static inline struct timespec64 get_expire_time(int ttl)
 }
 
 /* Allocate a new DFS target */
-static struct cache_dfs_tgt *alloc_target(const char *name)
+static struct cache_dfs_tgt *alloc_target(const char *name, int path_consumed)
 {
 	struct cache_dfs_tgt *t;
 
@@ -362,6 +363,7 @@ static struct cache_dfs_tgt *alloc_target(const char *name)
 		kfree(t);
 		return ERR_PTR(-ENOMEM);
 	}
+	t->path_consumed = path_consumed;
 	INIT_LIST_HEAD(&t->list);
 	return t;
 }
@@ -384,7 +386,7 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 	for (i = 0; i < numrefs; i++) {
 		struct cache_dfs_tgt *t;
 
-		t = alloc_target(refs[i].node_name);
+		t = alloc_target(refs[i].node_name, refs[i].path_consumed);
 		if (IS_ERR(t)) {
 			free_tgts(ce);
 			return PTR_ERR(t);
@@ -830,6 +832,7 @@ static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
+		it->it_path_consumed = t->path_consumed;
 
 		if (ce->tgthint == t)
 			list_add(&it->it_list, head);
@@ -1320,23 +1323,26 @@ void dfs_cache_del_vol(const char *fullpath)
 /**
  * dfs_cache_get_tgt_share - parse a DFS target
  *
+ * @path: DFS full path
  * @it: DFS target iterator.
  * @share: tree name.
- * @share_len: length of tree name.
  * @prefix: prefix path.
- * @prefix_len: length of prefix path.
  *
  * Return zero if target was parsed correctly, otherwise non-zero.
  */
-int dfs_cache_get_tgt_share(const struct dfs_cache_tgt_iterator *it,
-			    const char **share, size_t *share_len,
-			    const char **prefix, size_t *prefix_len)
+int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
+			    char **share, char **prefix)
 {
-	char *s, sep;
+	char *s, sep, *p;
+	size_t len;
+	size_t plen1, plen2;
 
-	if (!it || !share || !share_len || !prefix || !prefix_len)
+	if (!it || !path || !share || !prefix || strlen(path) < it->it_path_consumed)
 		return -EINVAL;
 
+	*share = NULL;
+	*prefix = NULL;
+
 	sep = it->it_name[0];
 	if (sep != '\\' && sep != '/')
 		return -EINVAL;
@@ -1345,13 +1351,38 @@ int dfs_cache_get_tgt_share(const struct dfs_cache_tgt_iterator *it,
 	if (!s)
 		return -EINVAL;
 
+	/* point to prefix in target node */
 	s = strchrnul(s + 1, sep);
 
-	*share = it->it_name;
-	*share_len = s - it->it_name;
-	*prefix = *s ? s + 1 : s;
-	*prefix_len = &it->it_name[strlen(it->it_name)] - *prefix;
+	/* extract target share */
+	*share = kstrndup(it->it_name, s - it->it_name, GFP_KERNEL);
+	if (!*share)
+		return -ENOMEM;
 
+	/* skip separator */
+	if (*s)
+		s++;
+	/* point to prefix in DFS path */
+	p = path + it->it_path_consumed;
+	if (*p == sep)
+		p++;
+
+	/* merge prefix paths from DFS path and target node */
+	plen1 = it->it_name + strlen(it->it_name) - s;
+	plen2 = path + strlen(path) - p;
+	if (plen1 || plen2) {
+		len = plen1 + plen2 + 2;
+		*prefix = kmalloc(len, GFP_KERNEL);
+		if (!*prefix) {
+			kfree(*share);
+			*share = NULL;
+			return -ENOMEM;
+		}
+		if (plen1)
+			scnprintf(*prefix, len, "%.*s%c%.*s", (int)plen1, s, sep, (int)plen2, p);
+		else
+			strscpy(*prefix, p, len);
+	}
 	return 0;
 }
 
diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
index bf94d08cfb5a..3d7c05194536 100644
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -19,6 +19,7 @@ struct dfs_cache_tgt_list {
 
 struct dfs_cache_tgt_iterator {
 	char *it_name;
+	int it_path_consumed;
 	struct list_head it_list;
 };
 
@@ -48,10 +49,8 @@ extern int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol,
 extern int dfs_cache_update_vol(const char *fullpath,
 				struct TCP_Server_Info *server);
 extern void dfs_cache_del_vol(const char *fullpath);
-
-extern int dfs_cache_get_tgt_share(const struct dfs_cache_tgt_iterator *it,
-				   const char **share, size_t *share_len,
-				   const char **prefix, size_t *prefix_len);
+extern int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it,
+				   char **share, char **prefix);
 
 static inline struct dfs_cache_tgt_iterator *
 dfs_cache_get_next_tgt(struct dfs_cache_tgt_list *tl,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index e44d049142d0..764234803071 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1164,8 +1164,7 @@ static inline void cifs_put_tcon_super(struct super_block *sb)
 }
 #endif
 
-int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
-			 size_t prefix_len)
+int update_super_prepath(struct cifs_tcon *tcon, char *prefix)
 {
 	struct super_block *sb;
 	struct cifs_sb_info *cifs_sb;
@@ -1179,8 +1178,8 @@ int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
 
 	kfree(cifs_sb->prepath);
 
-	if (*prefix && prefix_len) {
-		cifs_sb->prepath = kstrndup(prefix, prefix_len, GFP_ATOMIC);
+	if (prefix && *prefix) {
+		cifs_sb->prepath = kstrndup(prefix, strlen(prefix), GFP_ATOMIC);
 		if (!cifs_sb->prepath) {
 			rc = -ENOMEM;
 			goto out;
-- 
2.27.0

