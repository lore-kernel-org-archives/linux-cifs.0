Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA820381E96;
	Fri,  3 Jul 2026 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060061; cv=none; b=U7Jn5Auf/GORAhrP9y5beGjYBXgeT6n6B4BIy4UCDnYH+Tu0gJqf5ItR9pn4wl6KOhWMuTVa6NoywPNZ8+Nc0rFotCxw2G3vnN2GF4ktFd9wTjv4TWYWgULfAVBHRN7fFJ1iZWUO9tRz3f5pfYmmOCkgPvz1XhGBTzFxrsdVBK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060061; c=relaxed/simple;
	bh=mb4u0007nQXcvzNkHlkR6HyfIkB+IDyICoWFxTFlQJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I0PFdAUD80NkSFvAu4dYCw1EaArqckUEaB1ZxliLcsk5PQpIRe3nC45PTIZ05FhHIB3Cpv7RLpHlESoOuIjP2wpptvBa1+3V2NlIHiPwaN2HO+WnVR6JSu4JJ6emR9Qxlha065TPfceL52qPkxxLaZV1/z4CZT6aoigbM4fujbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gs3hB2d5LzKHLtZ;
	Fri,  3 Jul 2026 14:27:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CEF5D40590;
	Fri,  3 Jul 2026 14:27:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgB3SodVVkdq5sO8Ag--.1655S4;
	Fri, 03 Jul 2026 14:27:34 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	wozizhi@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com
Subject: [PATCH] smb: client: fix busy dentry warning on unmount after DIO
Date: Fri,  3 Jul 2026 14:20:04 +0800
Message-ID: <20260703062004.2122221-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3SodVVkdq5sO8Ag--.1655S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww43JFykGF47tr15KFW7urg_yoW7ury7pF
	WSyFW5Kr4rGryUWws5J3W8Xa4Fvr4kAa43ur4xWwnxJa15ArZ2gF1ktF1qgrWSyrWkAr4x
	KF4v9ayjqF1jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
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
all relevant cfile puts are queued on fileinfo_put_wq. Then drain
fileinfo_put_wq so the dentry refs are dropped.

This is a targeted wait, not a flush of the system-wide system_dfl_wq.

Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     | 11 +++++++++++
 fs/smb/client/connect.c    |  1 +
 fs/smb/client/file.c       |  5 +++++
 4 files changed, 18 insertions(+)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 84e7e366b0ff..d6494e1d93cc 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -54,10 +54,11 @@ struct cifs_sb_info {
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
 	atomic_t active;
 	atomic_t mnt_cifs_flags;
+	atomic_t outstanding_rreq;	/* nr of rreqs not yet fully deinitialized */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
 	/* only used when CIFS_MOUNT_USE_PREFIX_PATH is set */
 	char *prepath;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ea4fc0fa68ca..6696893d522f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -309,10 +309,21 @@ static void cifs_kill_sb(struct super_block *sb)
 		/* Wait for all pending oplock breaks to complete */
 		flush_workqueue(cifsoplockd_wq);
 		/* Wait for all opened files to release */
 		flush_workqueue(deferredclose_wq);
 
+		/*
+		 * Wait for all in-flight netfs I/O requests to finish their
+		 * cleanup_work so that any cifsFileInfo final puts they queue
+		 * to fileinfo_put_wq have been queued, then drain that
+		 * workqueue so the cfile dentry refs are dropped to avoid the
+		 * busy dentry warning.
+		 */
+		wait_var_event(&cifs_sb->outstanding_rreq,
+			       !atomic_read(&cifs_sb->outstanding_rreq));
+		flush_workqueue(fileinfo_put_wq);
+
 		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..a187398fbabd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3483,10 +3483,11 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 	INIT_LIST_HEAD(&cifs_sb->tcon_sb_link);
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
+	atomic_set(&cifs_sb->outstanding_rreq, 0);
 
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 ctx->file_mode, ctx->dir_mode);
 
 	/* this is needed for ASCII cp to Unicode converts */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8b25d6c9ec5e..d2116d934466 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -285,10 +285,11 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 	} else if (rreq->origin != NETFS_WRITEBACK) {
 		WARN_ON_ONCE(1);
 		return smb_EIO1(smb_eio_trace_not_netfs_writeback, rreq->origin);
 	}
 
+	atomic_inc(&cifs_sb->outstanding_rreq);
 	return 0;
 }
 
 /*
  * Completion of a request operation.
@@ -306,13 +307,17 @@ static void cifs_rreq_done(struct netfs_io_request *rreq)
 }
 
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
 {
 	struct cifs_io_subrequest *rdata =
-- 
2.52.0

