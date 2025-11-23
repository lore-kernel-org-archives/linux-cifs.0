Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986782BEFF6;
	Sun, 23 Nov 2025 10:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763894303; cv=none; b=omD+mnk5mVfcy6HQt21V2Fr+p3E4tOKXFmyj+RS4e1TUccvoJeEITocZJgcWCNExJAEBbddZDB5ZU4yzAQccU+Pr7BhIytKrWdFK4PNi9ieJSmrlGyWoXpAj/qJaxXIy/2Ilf1o4ZbIn5vq5jWXyoYgU8Jetz3UfE5bo71JV8N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763894303; c=relaxed/simple;
	bh=drF2/MAxuMNgx8DcgY+p0/2w6tUrXJKfHIkkOoY/oME=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=f650VVKuhHIM0tvuGj+UweEDTJR9sx9s/1WOGSuY1m4nSarMH4gj6pxadsQtu3KfWCkIgrb8v13+XVpZ0GOerdFmrDVwtQpTv566YXK7J+xrx+WKXhsUNXZWglE3VLH/y7X6og795Lxu5Sh0FOlsyi8WsWrmqpEVUQwqLN3gJgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dDll95HwvzYQtdx;
	Sun, 23 Nov 2025 18:37:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 75A5C1A07BD;
	Sun, 23 Nov 2025 18:38:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHpXsU5CJpsCLzBg--.58186S4;
	Sun, 23 Nov 2025 18:38:12 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v6] smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect
Date: Sun, 23 Nov 2025 18:28:44 +0800
Message-Id: <20251123102845.456273-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHpXsU5CJpsCLzBg--.58186S4
X-Coremail-Antispam: 1UD129KBjvAXoW3ZFWxJFWDWr4xJF4xXFWDJwb_yoW8JF4rWo
	W3Xayfu348Gr1jqrWqkrn3KFWDWa4DKF47Xa1Y9FsxKF9Yya4rC3yxta17JFW3uwn3tw1Y
	vrWxt34kCa1xGrZ8n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYj7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28I
	cxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
	IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
	42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42
	IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
	aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1wiSPUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

An AA deadlock occurs when network interruption during mount triggers
DFS reconnection logic that calls iterate_supers_type().

The detailed call process is as follows:

   mount.cifs
-------------------------
path_mount
 do_new_mount
  vfs_get_tree
   smb3_get_tree
    cifs_smb3_do_mount
     sget
      alloc_super
       down_write_nested(&s->s_umount, ..);  // Hold lock
     cifs_root_iget
      cifs_get_inode_info
       smb2_query_path_info
        smb2_compound_op
         SMB2_open_init
          smb2_plain_req_init
           smb2_reconnect           // Trigger reconnection
            cifs_tree_connect
             cifs_get_dfs_tcon_super
              __cifs_get_super
               iterate_supers_type
                super_lock_shared
                 super_lock
                  __super_lock
                   down_read(&sb->s_umount); // Deadlock
  do_new_mount_fc
   up_write(&sb->s_umount);  // Release lock

During mount phase, if reconnection is triggered, the foreground mount
process may enter smb2_reconnect prior to the reconnect worker being
scheduled, leading to a deadlock when subsequent DFS tree connect
attempts reacquire the s_umount lock.

The root cause is that cifs_get_dfs_tcon_super() uses
iterate_supers_type() to locate a matching DFS super block, which
reacquires s_umount while it is already held by the mount code.

Fix this by avoiding global super block iteration in the DFS reconnect
path and only using the existing CIFS hierarchy:

  - First, walk tcon->cifs_sb_list under tcon->sb_list_lock and update
    all attached cifs_sb using cifs_update_super_prepath().  This covers
    the "master" tcon case.

  - If that list is empty, fall back to walking all sessions and tcons
    on the same server that share the same dfs_root_ses and
    origin_fullpath, and update their cifs_sb lists instead.

This keeps all DFS prepath updates within the server → ses → tcon →
cifs_sb structures protected by CIFS locks and removes the dependency
on iterate_supers_type(), so the reconnect path no longer touches
s_umount and the deadlock is avoided.

As a minor optimization, avoid updating the super block prepath if it
is already set to the same value.

Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---

V6:
 - Refine update_tcon_super_prepaths() to handle non-master (multiuser) tcons
   by walking server->smb_ses_list / ses->tcon_list and matching on
   dfs_root_ses + origin_fullpath, then updating all attached cifs_sb
 - Completely drop cifs_get_dfs_tcon_super() / iterate_supers_type()-based
   lookup from the DFS reconnect path
 - Add a cheap early-return in cifs_update_super_prepath() when prepath is
   unchanged.

V5:
 - Extract update logic into update_tcon_super_prepaths() function
 - Add error logging for prepath update failures
 - Leverage existing tcon->cifs_sb_list infrastructure instead of iterate_supers_type()
 - Remove now-unused cifs_get_dfs_tcon_super() and related callback code

V4:
 - Perform a null pointer check on the return value of cifs_get_dfs_tcon_super()
   to prevent NULL ptr dereference with DFS multiuser mount

V3:
 - Adjust the trace diagram for the super_lock_shared() section to align with
   the latest mainline call flow.

V2:
 - Adjust the trace diagram in the commit message to indicate when the lock
   is released

 fs/smb/client/cifsproto.h |  2 -
 fs/smb/client/connect.c   |  2 +-
 fs/smb/client/dfs.c       | 97 ++++++++++++++++++++++++++++++++++-----
 fs/smb/client/misc.c      | 79 ++-----------------------------
 4 files changed, 89 insertions(+), 91 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3528c365a452..a28942f53653 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -684,12 +684,10 @@ void extract_unc_hostname(const char *unc, const char **h, size_t *len);
 int copy_path_name(char *dst, const char *src);
 int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 			       int resp_buftype,
 			       struct cifs_search_info *srch_inf);
 
-struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon);
-void cifs_put_tcp_super(struct super_block *sb);
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 55cb4b0cbd48..f4761d381b44 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4434,11 +4434,11 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	}
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (origin_fullpath) {
 		spin_lock(&tcon->tc_lock);
-		tcon->origin_fullpath = origin_fullpath;
+		WRITE_ONCE(tcon->origin_fullpath, origin_fullpath);
 		spin_unlock(&tcon->tc_lock);
 		origin_fullpath = NULL;
 		queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 				   dfs_cache_get_ttl() * HZ);
 	}
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index f65a8a90ba27..a61144be1142 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -227,11 +227,11 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	if (rc)
 		goto out;
 
 	tcon = mnt_ctx->tcon;
 	spin_lock(&tcon->tc_lock);
-	tcon->origin_fullpath = origin_fullpath;
+	WRITE_ONCE(tcon->origin_fullpath, origin_fullpath);
 	origin_fullpath = NULL;
 	ref_walk_set_tcon(rw, tcon);
 	spin_unlock(&tcon->tc_lock);
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 			   dfs_cache_get_ttl() * HZ);
@@ -331,13 +331,93 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	}
 	cifs_server_unlock(server);
 	return rc;
 }
 
+static int update_tcon_super_prepaths(struct cifs_tcon *tcon, const char *prefix)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *scan_tcon;
+	struct cifs_sb_info *cifs_sb;
+	const char *origin;
+	int rc = 0;
+	bool updated = false;
+
+	/* Fast path: master tcon */
+	spin_lock(&tcon->sb_list_lock);
+	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
+		updated = true;
+		rc = cifs_update_super_prepath(cifs_sb, (char *)prefix);
+		if (rc) {
+			cifs_dbg(VFS,
+				 "Failed to update prepath for superblock: %d\n",
+				 rc);
+			break;
+		}
+	}
+	spin_unlock(&tcon->sb_list_lock);
+
+	if (updated || rc)
+		return rc;
+
+	/* Slow path: non-master tcon */
+	origin = READ_ONCE(tcon->origin_fullpath);
+	if (!origin)
+		return 0;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&server->srv_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		spin_lock(&ses->ses_lock);
+
+		if (ses->dfs_root_ses != tcon->ses->dfs_root_ses) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
+
+		list_for_each_entry(scan_tcon, &ses->tcon_list, tcon_list) {
+			const char *scan_origin;
+
+			scan_origin = READ_ONCE(scan_tcon->origin_fullpath);
+			if (!scan_origin)
+				continue;
+
+			if (!dfs_src_pathname_equal(scan_origin, origin))
+				continue;
+
+			spin_lock(&scan_tcon->sb_list_lock);
+			list_for_each_entry(cifs_sb, &scan_tcon->cifs_sb_list,
+					    tcon_sb_link) {
+				rc = cifs_update_super_prepath(cifs_sb,
+							       (char *)prefix);
+				if (rc) {
+					cifs_dbg(VFS,
+						 "Failed to update prepath for superblock: %d\n",
+						 rc);
+					break;
+				}
+			}
+			spin_unlock(&scan_tcon->sb_list_lock);
+
+			if (rc) {
+				spin_unlock(&ses->ses_lock);
+				goto out_srv_unlock;
+			}
+		}
+
+		spin_unlock(&ses->ses_lock);
+	}
+out_srv_unlock:
+	spin_unlock(&server->srv_lock);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return rc;
+}
+
 static int tree_connect_dfs_target(const unsigned int xid,
 				   struct cifs_tcon *tcon,
-				   struct cifs_sb_info *cifs_sb,
 				   char *tree, bool islink,
 				   struct dfs_cache_tgt_list *tl)
 {
 	const struct smb_version_operations *ops = tcon->ses->server->ops;
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -370,12 +450,12 @@ static int tree_connect_dfs_target(const unsigned int xid,
 
 		dfs_cache_noreq_update_tgthint(server->leaf_fullpath + 1, tit);
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
 		rc = ops->tree_connect(xid, tcon->ses, tree,
 				       tcon, tcon->ses->local_nls);
-		if (islink && !rc && cifs_sb)
-			rc = cifs_update_super_prepath(cifs_sb, prefix);
+		if (islink && !rc && READ_ONCE(tcon->origin_fullpath))
+			rc = update_tcon_super_prepaths(tcon, prefix);
 		break;
 	}
 
 	kfree(share);
 	kfree(prefix);
@@ -387,12 +467,10 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
 {
 	int rc;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
 	DFS_CACHE_TGT_LIST(tl);
-	struct cifs_sb_info *cifs_sb = NULL;
-	struct super_block *sb = NULL;
 	struct dfs_info3_param ref = {0};
 	char *tree;
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
@@ -428,29 +506,24 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
 		rc = ops->tree_connect(xid, tcon->ses, tree,
 				       tcon, tcon->ses->local_nls);
 		goto out;
 	}
 
-	sb = cifs_get_dfs_tcon_super(tcon);
-	if (!IS_ERR(sb))
-		cifs_sb = CIFS_SB(sb);
-
 	/* Tree connect to last share in @tcon->tree_name if no DFS referral */
 	if (!server->leaf_fullpath ||
 	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
 		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name,
 				       tcon, tcon->ses->local_nls);
 		goto out;
 	}
 
-	rc = tree_connect_dfs_target(xid, tcon, cifs_sb, tree, ref.server_type == DFS_TYPE_LINK,
+	rc = tree_connect_dfs_target(xid, tcon, tree, ref.server_type == DFS_TYPE_LINK,
 				     &tl);
 	free_dfs_info_param(&ref);
 
 out:
 	kfree(tree);
-	cifs_put_tcp_super(sb);
 
 	if (rc) {
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index e10123d8cd7d..ee26168d17b9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1119,86 +1119,10 @@ int copy_path_name(char *dst, const char *src)
 	/* we count the trailing nul */
 	name_len++;
 	return name_len;
 }
 
-struct super_cb_data {
-	void *data;
-	struct super_block *sb;
-};
-
-static void tcon_super_cb(struct super_block *sb, void *arg)
-{
-	struct super_cb_data *sd = arg;
-	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *t1 = sd->data, *t2;
-
-	if (sd->sb)
-		return;
-
-	cifs_sb = CIFS_SB(sb);
-	t2 = cifs_sb_master_tcon(cifs_sb);
-
-	spin_lock(&t2->tc_lock);
-	if ((t1->ses == t2->ses ||
-	     t1->ses->dfs_root_ses == t2->ses->dfs_root_ses) &&
-	    t1->ses->server == t2->ses->server &&
-	    t2->origin_fullpath &&
-	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
-		sd->sb = sb;
-	spin_unlock(&t2->tc_lock);
-}
-
-static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void *),
-					    void *data)
-{
-	struct super_cb_data sd = {
-		.data = data,
-		.sb = NULL,
-	};
-	struct file_system_type **fs_type = (struct file_system_type *[]) {
-		&cifs_fs_type, &smb3_fs_type, NULL,
-	};
-
-	for (; *fs_type; fs_type++) {
-		iterate_supers_type(*fs_type, f, &sd);
-		if (sd.sb) {
-			/*
-			 * Grab an active reference in order to prevent automounts (DFS links)
-			 * of expiring and then freeing up our cifs superblock pointer while
-			 * we're doing failover.
-			 */
-			cifs_sb_active(sd.sb);
-			return sd.sb;
-		}
-	}
-	pr_warn_once("%s: could not find dfs superblock\n", __func__);
-	return ERR_PTR(-EINVAL);
-}
-
-static void __cifs_put_super(struct super_block *sb)
-{
-	if (!IS_ERR_OR_NULL(sb))
-		cifs_sb_deactive(sb);
-}
-
-struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
-{
-	spin_lock(&tcon->tc_lock);
-	if (!tcon->origin_fullpath) {
-		spin_unlock(&tcon->tc_lock);
-		return ERR_PTR(-ENOENT);
-	}
-	spin_unlock(&tcon->tc_lock);
-	return __cifs_get_super(tcon_super_cb, tcon);
-}
-
-void cifs_put_tcp_super(struct super_block *sb)
-{
-	__cifs_put_super(sb);
-}
-
 #ifdef CONFIG_CIFS_DFS_UPCALL
 int match_target_ip(struct TCP_Server_Info *server,
 		    const char *host, size_t hostlen,
 		    bool *result)
 {
@@ -1223,10 +1147,13 @@ int match_target_ip(struct TCP_Server_Info *server,
 
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 {
 	int rc;
 
+	if (cifs_sb->prepath && prefix && !strcmp(cifs_sb->prepath, prefix))
+		return 0;
+
 	kfree(cifs_sb->prepath);
 	cifs_sb->prepath = NULL;
 
 	if (prefix && *prefix) {
 		cifs_sb->prepath = cifs_sanitize_prepath(prefix, GFP_ATOMIC);
-- 
2.39.2

