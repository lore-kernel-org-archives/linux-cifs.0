Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45AD22157E;
	Wed, 20 Aug 2025 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690170; cv=none; b=jGlh+bf7Y4w0aeVDMFgjTxQjxL9ZsfsujfigA14SvBlasEnoBcLzuYJxqXRolDohiaWlSQUuCwRd5JNGMq+xTFhHLMDfnDYAjHvpBy3Xt1/1D0A0YrmMPRhXkFWoaeC2+YTRCk/HmNLDMfGZl1nSwKhgsKRjelYXsBmJGWa9pXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690170; c=relaxed/simple;
	bh=08hWmsnpKuPHGc0W2ptimoNLac3qMRxZ2PynpHYBnZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MPwQiNyfq8/xTm0ZRzlonGbSBCEca1qC6cUbWrf9kyqoM//V21xsnCDZxgekTvIiU8BQZYEsGkzgjvX3H2uJs+8XX5aR60sLXvKP7/albfoBW222To6iM5yGNGa+COzej565LxweUJPpovMq/ABxOfjIkgYtq0x0Scfanj2jxWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c6PhP18SYzKHN2T;
	Wed, 20 Aug 2025 19:42:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 97A4C1A0CC8;
	Wed, 20 Aug 2025 19:42:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxSytKVo4ltJEQ--.58853S4;
	Wed, 20 Aug 2025 19:42:44 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V5] smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect
Date: Wed, 20 Aug 2025 19:34:35 +0800
Message-Id: <20250820113435.2319994-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxSytKVo4ltJEQ--.58853S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy3XrWUuF4fWrWktFyxZrb_yoWfCr1DpF
	yYyrWSqr48Grn8Wwn7JFWkuw1Fvr1kAa4Ykrn3uas7Xa9rZ3yIqFWqkF1UuF93t3ykt3sr
	WF4qq3yIka18ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
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
                                down_read(&sb->s_umount); // Deadlock
    do_new_mount_fc
      up_write(&sb->s_umount);  // Release lock

During mount phase, if reconnection is triggered, the foreground mount
process may enter smb2_reconnect prior to the reconnect worker being
scheduled, leading to a deadlock when subsequent DFS tree connect
attempts reacquire the s_umount lock.

The issue stems from cifs_get_dfs_tcon_super() using iterate_supers_type()
which reacquires the s_umount lock that's already held by the mount
process.

However, after commit a091d9711bde ("smb:client: smb: client: Add reverse
mapping from tcon to superblocks"), we have a more direct way to access
associated superblocks through tcon->cifs_sb_list, which was originally
introduced to update I/O sizes after reconnection.

This patch leverages the existing tcon->cifs_sb_list infrastructure to
directly update DFS mount prepaths without needing to search through all
superblocks.

The key changes are:
- Add update_tcon_super_prepaths() to update all related superblocks
- Remove now-unused cifs_get_dfs_tcon_super() and related callback code
- Update tree_connect_dfs_target() to use the new direct approach

Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---

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

 fs/smb/client/cifsproto.h |  2 --
 fs/smb/client/dfs.c       | 32 +++++++++++------
 fs/smb/client/misc.c      | 76 ---------------------------------------
 3 files changed, 21 insertions(+), 89 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..6b55582b427a 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -677,12 +677,10 @@ void extract_unc_hostname(const char *unc, const char **h, size_t *len);
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
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index f65a8a90ba27..cb0532e3868f 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -331,13 +331,30 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	}
 	cifs_server_unlock(server);
 	return rc;
 }
 
+static int update_tcon_super_prepaths(struct cifs_tcon *tcon, const char *prefix)
+{
+	struct cifs_sb_info *cifs_sb;
+	int rc = 0;
+
+	spin_lock(&tcon->sb_list_lock);
+	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
+		rc = cifs_update_super_prepath(cifs_sb, (char *)prefix);
+		if (rc) {
+			cifs_dbg(VFS, "Failed to update prepath for superblock: %d\n", rc);
+			break;
+		}
+	}
+	spin_unlock(&tcon->sb_list_lock);
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
@@ -370,12 +387,12 @@ static int tree_connect_dfs_target(const unsigned int xid,
 
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
@@ -387,12 +404,10 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
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
@@ -428,29 +443,24 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
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
index da23cc12a52c..3eedcca0d7f9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1108,86 +1108,10 @@ int copy_path_name(char *dst, const char *src)
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
-- 
2.39.2

