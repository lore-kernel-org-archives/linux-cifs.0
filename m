Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A4217A310;
	Fri, 15 Aug 2025 03:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755228260; cv=none; b=GOrYdlniUXtQWhlfa4E9PKwzPX4+a1DmtctqF8VXrMged9+7N2CJ6nV3eTu8QUgpSSsJZBIn/G0z1NseaCW9wf8/xrnOFrVG9LJYExdR6fw4Gsya2gVCcLnxLtkubts6T05BTm2QIpIHJAK5TDSWuyDT5FPv2Q8ZFfw5CPIR+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755228260; c=relaxed/simple;
	bh=7CDzsalSvM+eE9NmMVshPuJKnICEntU14YPizv9tMAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jyLC8T/ezfMkaqylHVQsnbUYNfpNwndH9FpqqtTDN9Lh3zDqTT7BBbLsXobftx4Kf2mM37LLvc0Wka/xMuQOd3pyjKkOITJlTTYj86Wtmp8WgeDOwESXlRDVUkm5atXLyE1JeqEe9kA/1JQJ53PIzPPA9SYc2wNj0jiFf8ZgTEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c36sN2Tf3zKHMnb;
	Fri, 15 Aug 2025 11:24:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A5C441A17BA;
	Fri, 15 Aug 2025 11:24:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw9VqJ5oB1PoDg--.58085S4;
	Fri, 15 Aug 2025 11:24:07 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4] smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect
Date: Fri, 15 Aug 2025 11:16:18 +0800
Message-Id: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw9VqJ5oB1PoDg--.58085S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy3XrWUuF4fWrWktFyxZrb_yoW3KFW8pF
	ySyrWSgr48Gr1UWws7JF4ku34F934kCFy5Cr4xG3WvqayDZrWIgFWqkF1j9FySyayDt3s3
	Wr4Dt3y29F18ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
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

The essential condition for triggering the issue is that the API
iterate_supers_type() reacquires the s_umount lock. Therefore, one
possible solution is to avoid using iterate_supers_type() and instead
directly access the superblock through internal data structures.

This patch fixes the problem by:
- Add vfs_sb back-pointer to cifs_sb_info for direct access
- Protect list traversal with existing tcon->sb_list_lock
- Use atomic operations to safely manage super block references
- Remove complex callback-based iteration in favor of simple loop
- Rename cifs_put_tcp_super() to cifs_put_super() to avoid confusion

Fixes: 3ae872de4107 ("smb: client: fix shared DFS root mounts with different prefixes")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---

V4:
 - Perform a null pointer check on the return value of cifs_get_dfs_tcon_super()
   to prevent NULL ptr dereference with DFS multiuser mount

V3:
 - Adjust the trace diagram for the super_lock_shared() section to align with
   the latest mainline call flow. 
V2:
 - Adjust the trace diagram in the commit message to indicate when the lock
   is released

 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     |  1 +
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/dfs.c        |  4 +-
 fs/smb/client/misc.c       | 84 ++++++++++++++------------------------
 5 files changed, 35 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 5e8d163cb5f8..8c513e4c0efe 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -49,10 +49,11 @@
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
 	struct list_head tcon_sb_link;
 	spinlock_t tlink_tree_lock;
+	struct super_block *vfs_sb;
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
 	unsigned int mnt_cifs_flags;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 3bd85ab2deb1..383f651eb43f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -939,10 +939,11 @@ cifs_get_root(struct smb3_fs_context *ctx, struct super_block *sb)
 
 static int cifs_set_super(struct super_block *sb, void *data)
 {
 	struct cifs_mnt_data *mnt_data = data;
 	sb->s_fs_info = mnt_data->cifs_sb;
+	mnt_data->cifs_sb->vfs_sb = sb;
 	return set_anon_super(sb, NULL);
 }
 
 struct dentry *
 cifs_smb3_do_mount(struct file_system_type *fs_type,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..6415bb961c1e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -678,11 +678,11 @@ int copy_path_name(char *dst, const char *src);
 int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 			       int resp_buftype,
 			       struct cifs_search_info *srch_inf);
 
 struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon);
-void cifs_put_tcp_super(struct super_block *sb);
+void cifs_put_super(struct super_block *sb);
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index f65a8a90ba27..37d83aade843 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -429,11 +429,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
 				       tcon, tcon->ses->local_nls);
 		goto out;
 	}
 
 	sb = cifs_get_dfs_tcon_super(tcon);
-	if (!IS_ERR(sb))
+	if (!IS_ERR_OR_NULL(sb))
 		cifs_sb = CIFS_SB(sb);
 
 	/* Tree connect to last share in @tcon->tree_name if no DFS referral */
 	if (!server->leaf_fullpath ||
 	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
@@ -446,11 +446,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
 				     &tl);
 	free_dfs_info_param(&ref);
 
 out:
 	kfree(tree);
-	cifs_put_tcp_super(sb);
+	cifs_put_super(sb);
 
 	if (rc) {
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_NEED_TCON;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index da23cc12a52c..3b6920a52daa 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1108,84 +1108,60 @@ int copy_path_name(char *dst, const char *src)
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
+static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
 {
-	struct super_cb_data *sd = arg;
+	struct super_block *sb;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *t1 = sd->data, *t2;
 
-	if (sd->sb)
-		return;
+	if (!tcon)
+		return NULL;
 
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
+	spin_lock(&tcon->sb_list_lock);
+	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
 
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
+		if (!cifs_sb->vfs_sb)
+			continue;
+
+		sb = cifs_sb->vfs_sb;
+
+		/* Safely increment s_active only if it's not zero.
+		 *
+		 * When s_active == 0, the super block is being deactivated
+		 * and should not be used. This prevents UAF scenarios
+		 * where we might grab a reference to a super block that's
+		 * in the middle of destruction.
+		 */
+		if (!atomic_add_unless(&sb->s_active, 1, 0))
+			continue;
+
+		spin_unlock(&tcon->sb_list_lock);
+		return sb;
 	}
-	pr_warn_once("%s: could not find dfs superblock\n", __func__);
-	return ERR_PTR(-EINVAL);
-}
+	spin_unlock(&tcon->sb_list_lock);
 
-static void __cifs_put_super(struct super_block *sb)
-{
-	if (!IS_ERR_OR_NULL(sb))
-		cifs_sb_deactive(sb);
+	return NULL;
 }
 
 struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
 {
 	spin_lock(&tcon->tc_lock);
 	if (!tcon->origin_fullpath) {
 		spin_unlock(&tcon->tc_lock);
 		return ERR_PTR(-ENOENT);
 	}
 	spin_unlock(&tcon->tc_lock);
-	return __cifs_get_super(tcon_super_cb, tcon);
+
+	return cifs_get_tcon_super(tcon);
 }
 
-void cifs_put_tcp_super(struct super_block *sb)
+void cifs_put_super(struct super_block *sb)
 {
-	__cifs_put_super(sb);
+	if (!IS_ERR_OR_NULL(sb))
+		deactivate_super(sb);
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 int match_target_ip(struct TCP_Server_Info *server,
 		    const char *host, size_t hostlen,
-- 
2.39.2

