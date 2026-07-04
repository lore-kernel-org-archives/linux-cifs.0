Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9AE1A9F87;
	Sat,  4 Jul 2026 02:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130460; cv=none; b=uswojHusplvQAq1cUIC4CT0uz1NNfygp7543CZIkU1aRY2sKojJSnVdd9zjSVJ4jhO6Zh3aD6BG92RuyQ9Zum65tPoboUzxK6P92iJNfxAMBSaQkZrXIxc+V2fVr0Jr5Z8ffXnz7zuoyNhEMQdgXxZ3nKTjW59IJf0IJqq8En4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130460; c=relaxed/simple;
	bh=OgcPrAJvt7jGuUn3qFJJUVuftPWCw6hkxJdrKH+vKPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t29mY065ngVQi1MOSCy+KxbEIkFjSvqNpHErQ7m/5v8tgf2CvI8k1hcfI/yR5xYFa9PVVUgSJcB/QHs/0//cwKKMN709+VzKTOn1GxlzUVlvKWZaQ23sT9nTqNbahoJ9OXY0ksM9aIF7BnmkELps+W9ElJV1LzixICAA7xP5NHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gsYk024rBzKHLyh;
	Sat,  4 Jul 2026 10:00:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1596C4058C;
	Sat,  4 Jul 2026 10:00:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgB3mIVUaUhq6aseAw--.63554S4;
	Sat, 04 Jul 2026 10:00:53 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	wozizhi@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com
Subject: [PATCH V2] smb: client: fix busy dentry warning on unmount after DIO
Date: Sat,  4 Jul 2026 09:53:20 +0800
Message-ID: <20260704015320.390545-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3mIVUaUhq6aseAw--.63554S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww43JFykGF47tr15KFW7urg_yoW7Cr13pF
	WSyFW5Kr4rGryUWws5J3WUXa4Fvr4kAa43urWxWwnxJa15ArZ2gF1ktF1qgrW3ArWkCr40
	gF4q9ayjqF1jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit c68337442f03 ("cifs: Fix busy dentry used after unmounting") fixed
the issue in cifs where deferred close of a file led to a dentry reference
count not being released in umount, by flushing deferredclose_wq in
cifs_kill_sb() to solve it.

However, the cifs DIO path suffers from the same busy-dentry problem caused
by a delayed dentry reference-count release:

	[dio]			[cifsd]			[close + umount]
netfs_unbuffered_write_iter_locked
...
				cifs_demultiplex_thread
 netfs_unbuffered_write
  cifs_issue_write
  netfs_wait_for_in_progress_stream [1]
				...
				 netfs_write_subrequest_terminated
				  netfs_subreq_clear_in_progress
				   netfs_wake_collector // wake [1]
				  netfs_put_subrequest
 netfs_put_request
  queue_work(system_dfl_wq, xxx) [2]
 // dio write return					cifs_close
							 _cifsFileInfo_put
							  // cfile->count 2->1
							  --cfile->count [3]

							// umount
							cifs_kill_sb
							 kill_anon_super
							  // warning triggered!
							  shrink_dcache_for_umount [4]
[system_dfl_wq] [5]
netfs_free_request
 ...
 _cifsFileInfo_put
  // cfile->count 1->0
  --cfile->count
  queue_work(fileinfo_put_wq, xxx)

[fileinfo_put_wq] [6]
cifsFileInfo_put_work
 cifsFileInfo_put_final
  dput

If the umount path is triggered before [5], it results warning:
BUG: Dentry 00000000eab1f070{i=9a917b66ae404fec,n=test}  still in use (1)
[unmount of cifs cifs]

The existing per-inode ictx->io_count wait in cifs_evict_inode() does not
help: it lives in the inode eviction path, which runs after
shrink_dcache_for_umount() has already warned about the busy dentries.

Fix it by adding a per-superblock outstanding-rreq counter that is
incremented in cifs_init_request() and decremented in cifs_free_request().
In cifs_kill_sb(), before kill_anon_super(), wait for this counter to reach
0 - which guarantees that all cleanup_work for this sb have run and thus
all relevant cfile puts are queued on fileinfo_put_wq or serverclose_wq.
Then drain the workqueue so the dentry refs are dropped.

This is a targeted wait, not a flush of the system-wide system_dfl_wq.

Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
v2: Added flush_workqueue(serverclose_wq) to ensure the dput in the error
path of _cifsFileInfo_put() is released.

v1: https://lore.kernel.org/all/20260703062004.2122221-1-wozizhi@huaweicloud.com/
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     | 12 ++++++++++++
 fs/smb/client/connect.c    |  1 +
 fs/smb/client/file.c       |  5 +++++
 4 files changed, 19 insertions(+)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 84e7e366b0ff..d6494e1d93cc 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -56,6 +56,7 @@ struct cifs_sb_info {
 	struct smb3_fs_context *ctx;
 	atomic_t active;
 	atomic_t mnt_cifs_flags;
+	atomic_t outstanding_rreq;	/* nr of rreqs not yet fully deinitialized */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ea4fc0fa68ca..4df6ca03a8de 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -311,6 +311,18 @@ static void cifs_kill_sb(struct super_block *sb)
 		/* Wait for all opened files to release */
 		flush_workqueue(deferredclose_wq);
 
+		/*
+		 * Wait for all in-flight netfs I/O requests to finish their
+		 * cleanup_work so that any cifsFileInfo final puts they queue
+		 * to fileinfo_put_wq/serverclose_wq have been queued, then
+		 * drain the workqueue so the cfile dentry refs are dropped to
+		 * avoid the busy dentry warning.
+		 */
+		wait_var_event(&cifs_sb->outstanding_rreq,
+			       !atomic_read(&cifs_sb->outstanding_rreq));
+		flush_workqueue(serverclose_wq);
+		flush_workqueue(fileinfo_put_wq);
+
 		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..a187398fbabd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3485,6 +3485,7 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
+	atomic_set(&cifs_sb->outstanding_rreq, 0);
 
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 ctx->file_mode, ctx->dir_mode);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8b25d6c9ec5e..d2116d934466 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -287,6 +287,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		return smb_EIO1(smb_eio_trace_not_netfs_writeback, rreq->origin);
 	}
 
+	atomic_inc(&cifs_sb->outstanding_rreq);
 	return 0;
 }
 
@@ -308,9 +309,13 @@ static void cifs_rreq_done(struct netfs_io_request *rreq)
 static void cifs_free_request(struct netfs_io_request *rreq)
 {
 	struct cifs_io_request *req = container_of(rreq, struct cifs_io_request, rreq);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
 
 	if (req->cfile)
 		cifsFileInfo_put(req->cfile);
+
+	if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+		wake_up_var(&cifs_sb->outstanding_rreq);
 }
 
 static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
-- 
2.52.0

