Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55A1DFE0A;
	Mon, 31 Mar 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743428364; cv=none; b=BoPZ3TqGnP0IPEYgGfYQAO0EVD3oXetXW1fn0puHAgZmCNxV1T6UkbOW3iAQCV83todHYIN3ax1VZrZ4sA7TO4vJTInyuzssZ66e/zjqW1FHKmifwxuEJskAH7CzJVGpThRhkhLxqYT/mygXf6XCvOWepWexWSyqBmNh+2++Tm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743428364; c=relaxed/simple;
	bh=dOx95MuekbEMi2IU+RmUOmcI3GSosGWmUni5Knb+IqQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUFv2ft3lcb5Twc+D7NVfFPW4A2RYb4DhM4ZAOhqY6DbLxnhCvRpZserxH9WUKpChUnXXyiWLMzzagjQ+PGR8TWrUsVsArtWbrR0/UfJc7HdPrcObdVs5lPwu9FvE0edfn4R6LQ0U6Blcyo6M2j0xFTWVIPt00U0iagXajZyIno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZRBzs4LrNz1d14d;
	Mon, 31 Mar 2025 21:38:49 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id DAB1B1400DC;
	Mon, 31 Mar 2025 21:39:18 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 31 Mar
 2025 21:39:17 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <linkinjeon@kernel.org>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH next 1/3] smb:client: smb: client: Add reverse mapping from tcon to superblocks
Date: Mon, 31 Mar 2025 21:33:13 +0800
Message-ID: <20250331133315.117666-2-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250331133315.117666-1-wangzhaolong1@huawei.com>
References: <20250331133315.117666-1-wangzhaolong1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Currently, when a SMB connection is reset and renegotiated with the
server, there's no way to update all related mount points with new
negotiated sizes. This is because while superblocks (cifs_sb_info)
maintain references to tree connections (tcon) through tcon_link
structures, there is no reverse mapping from a tcon back to all the
superblocks using it.

This patch adds a bidirectional relationship between tcon and
cifs_sb_info structures by:

1. Adding a cifs_sb_list to tcon structure with appropriate locking
2. Adding tcon_sb_link to cifs_sb_info to join the list
3. Managing the list entries during mount and umount operations

The bidirectional relationship enables future functionality to locate and
update all superblocks connected to a specific tree connection, such as:

- Updating negotiated parameters after reconnection
- Efficiently notifying all affected mounts of capability changes

This is the first part of a series to improve connection resilience
by keeping all mount parameters in sync with server capabilities
after reconnection.

Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsglob.h   |  3 ++-
 fs/smb/client/connect.c    | 15 +++++++++++++++
 fs/smb/client/misc.c       |  2 ++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 651759192280..5e8d163cb5f8 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -47,10 +47,11 @@
 #define CIFS_MOUNT_RW_CACHE	0x40000000  /* assumes only client accessing */
 #define CIFS_MOUNT_SHUTDOWN	0x80000000
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
+	struct list_head tcon_sb_link;
 	spinlock_t tlink_tree_lock;
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cddeb2adbf4a..be1760ceca6c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1317,11 +1317,12 @@ struct cifs_tcon {
 	struct fscache_volume *fscache;	/* cookie for share */
 	struct mutex fscache_lock;	/* Prevent regetting a cookie */
 #endif
 	struct list_head pending_opens;	/* list of incomplete opens */
 	struct cached_fids *cfids;
-	/* BB add field for back pointer to sb struct(s)? */
+	struct list_head cifs_sb_list;
+	spinlock_t sb_list_lock;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct delayed_work dfs_cache_work;
 	struct list_head dfs_ses_list;
 #endif
 	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 73f93a35eedd..409b4e0dac26 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3336,10 +3336,11 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 {
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
 
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
+	INIT_LIST_HEAD(&cifs_sb->tcon_sb_link);
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
@@ -3568,10 +3569,14 @@ static int mount_setup_tlink(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	cifs_sb->master_tlink = tlink;
 	spin_lock(&cifs_sb->tlink_tree_lock);
 	tlink_rb_insert(&cifs_sb->tlink_tree, tlink);
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
+	spin_lock(&tcon->sb_list_lock);
+	list_add(&cifs_sb->tcon_sb_link, &tcon->cifs_sb_list);
+	spin_unlock(&tcon->sb_list_lock);
+
 	queue_delayed_work(cifsiod_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
 	return 0;
 }
 
@@ -3909,13 +3914,23 @@ void
 cifs_umount(struct cifs_sb_info *cifs_sb)
 {
 	struct rb_root *root = &cifs_sb->tlink_tree;
 	struct rb_node *node;
 	struct tcon_link *tlink;
+	struct cifs_tcon *tcon = NULL;
 
 	cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
 
+	if (cifs_sb->master_tlink) {
+		tcon = cifs_sb->master_tlink->tl_tcon;
+		if (tcon) {
+			spin_lock(&tcon->sb_list_lock);
+			list_del_init(&cifs_sb->tcon_sb_link);
+			spin_unlock(&tcon->sb_list_lock);
+		}
+	}
+
 	spin_lock(&cifs_sb->tlink_tree_lock);
 	while ((node = rb_first(root))) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 		cifs_get_tlink(tlink);
 		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index b328dc5c7988..7b6ed9b23e71 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -135,12 +135,14 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 	ret_buf->debug_id = atomic_inc_return(&tcon_debug_id);
 	ret_buf->tc_count = 1;
 	spin_lock_init(&ret_buf->tc_lock);
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
+	INIT_LIST_HEAD(&ret_buf->cifs_sb_list);
 	spin_lock_init(&ret_buf->open_file_lock);
 	spin_lock_init(&ret_buf->stat_lock);
+	spin_lock_init(&ret_buf->sb_list_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
 	ret_buf->stats_from_time = ktime_get_real_seconds();
 #ifdef CONFIG_CIFS_FSCACHE
 	mutex_init(&ret_buf->fscache_lock);
-- 
2.39.2

