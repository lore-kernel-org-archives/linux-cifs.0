Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E63C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 15:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2E8206B7
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 15:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfC1PeG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:34:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:43560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfC1PeG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:34:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39585B02E;
        Thu, 28 Mar 2019 15:34:04 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v2] CIFS: keep FileInfo handle live during oplock break
Date:   Thu, 28 Mar 2019 16:34:00 +0100
Message-Id: <20190328153400.13596-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In the oplock break handler, writing pending changes from pages puts
the FileInfo handle. If the refcount reaches zero it closes the handle
and waits for any oplock break handler to return, thus causing a deadlock.

To prevent this situation:

* We add a wait flag to cifsFileInfo_put() to decide whether we should
  wait for running/pending oplock break handlers

* We keep an additionnal reference of the SMB FileInfo handle so that
  for the rest of the handler putting the handle won't close it.
  - The ref is bumped everytime we queue the handler via the
    cifs_queue_oplock() helper.
  - The ref is decremented at the end of the handler

This bug was triggered by xfstest 464.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsacl.c  |  2 +-
 fs/cifs/cifsglob.h |  3 ++-
 fs/cifs/cifssmb.c  |  2 +-
 fs/cifs/file.c     | 36 +++++++++++++++++++++++-------------
 fs/cifs/inode.c    |  4 ++--
 fs/cifs/misc.c     | 27 ++++++++++++++++++++++++---
 fs/cifs/smb1ops.c  |  2 +-
 fs/cifs/smb2misc.c |  6 +++---
 fs/cifs/smb2ops.c  |  2 +-
 9 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1d377b7f2860..3c03e3346744 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1069,7 +1069,7 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 		return get_cifs_acl_by_path(cifs_sb, path, pacllen);
 
 	pntsd = get_cifs_acl_by_fid(cifs_sb, &open_file->fid, pacllen);
-	cifsFileInfo_put(open_file);
+	cifsFileInfo_put(open_file, true);
 	return pntsd;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 38feae812b47..87751a9c947a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1325,7 +1325,7 @@ cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
 }
 
 struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
-void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
+void cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr);
 
 #define CIFS_CACHE_READ_FLG	1
 #define CIFS_CACHE_HANDLE_FLG	2
@@ -1847,6 +1847,7 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
 #endif /* CONFIG_CIFS_ACL */
 
 void cifs_oplock_break(struct work_struct *work);
+void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f43747c062a7..d17a697b86f9 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2067,7 +2067,7 @@ cifs_writedata_release(struct kref *refcount)
 #endif
 
 	if (wdata->cfile)
-		cifsFileInfo_put(wdata->cfile);
+		cifsFileInfo_put(wdata->cfile, true);
 
 	kvfree(wdata->pages);
 	kfree(wdata);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 89006e044973..3cea7bb5dac9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -360,12 +360,20 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 	return cifs_file;
 }
 
-/*
- * Release a reference on the file private data. This may involve closing
- * the filehandle out on the server. Must be called without holding
- * tcon->open_file_lock and cifs_file->file_info_lock.
+/**
+ * cifsFileInfo_put - release a reference of file priv data
+ *
+ * This may involve closing the filehandle @cifs_file out on the
+ * server. Must be called without holding tcon->open_file_lock and
+ * cifs_file->file_info_lock.
+ *
+ * If @wait_for_oplock_handler is true and we are releasing the last
+ * reference, wait for any running oplock break handler of the file
+ * and cancel any pending one. If calling this function from the
+ * oplock break handler, you need to pass false.
+ *
  */
-void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
+void cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
 {
 	struct inode *inode = d_inode(cifs_file->dentry);
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
@@ -414,7 +422,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 
 	spin_unlock(&tcon->open_file_lock);
 
-	oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
+	oplock_break_cancelled = wait_oplock_handler ?
+		cancel_work_sync(&cifs_file->oplock_break) : false;
 
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		struct TCP_Server_Info *server = tcon->ses->server;
@@ -772,7 +781,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 int cifs_close(struct inode *inode, struct file *file)
 {
 	if (file->private_data != NULL) {
-		cifsFileInfo_put(file->private_data);
+		cifsFileInfo_put(file->private_data, true);
 		file->private_data = NULL;
 	}
 
@@ -812,7 +821,7 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 		if (cifs_reopen_file(open_file, false /* do not flush */))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
-		cifsFileInfo_put(open_file);
+		cifsFileInfo_put(open_file, true);
 	}
 }
 
@@ -1934,7 +1943,7 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
 		spin_lock(&tcon->open_file_lock);
 		list_move_tail(&inv_file->flist, &cifs_inode->openFileList);
 		spin_unlock(&tcon->open_file_lock);
-		cifsFileInfo_put(inv_file);
+		cifsFileInfo_put(inv_file, true);
 		++refind;
 		inv_file = NULL;
 		spin_lock(&tcon->open_file_lock);
@@ -1995,7 +2004,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	if (!rc) {
 		bytes_written = cifs_write(open_file, open_file->pid,
 					   write_data, to - from, &offset);
-		cifsFileInfo_put(open_file);
+		cifsFileInfo_put(open_file, true);
 		/* Does mm or vfs already set times? */
 		inode->i_atime = inode->i_mtime = current_time(inode);
 		if ((bytes_written > 0) && (offset))
@@ -2182,7 +2191,7 @@ static int cifs_writepages(struct address_space *mapping,
 		int get_file_rc = 0;
 
 		if (cfile)
-			cifsFileInfo_put(cfile);
+			cifsFileInfo_put(cfile, true);
 
 		rc = cifs_get_writable_file(CIFS_I(inode), false, &cfile);
 
@@ -2296,7 +2305,7 @@ static int cifs_writepages(struct address_space *mapping,
 		mapping->writeback_index = index;
 
 	if (cfile)
-		cifsFileInfo_put(cfile);
+		cifsFileInfo_put(cfile, true);
 	free_xid(xid);
 	return rc;
 }
@@ -3184,7 +3193,7 @@ cifs_readdata_release(struct kref *refcount)
 	}
 #endif
 	if (rdata->cfile)
-		cifsFileInfo_put(rdata->cfile);
+		cifsFileInfo_put(rdata->cfile, true);
 
 	kvfree(rdata->pages);
 	kfree(rdata);
@@ -4603,6 +4612,7 @@ void cifs_oplock_break(struct work_struct *work)
 							     cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
+	cifsFileInfo_put(cfile, false /* do not wait for ourself */);
 	cifs_done_oplock_break(cinode);
 }
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 53fdb5df0d2e..713188cda2cd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2172,7 +2172,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 							attrs->ia_size, false);
 		else
 			rc = -ENOSYS;
-		cifsFileInfo_put(open_file);
+		cifsFileInfo_put(open_file, true);
 		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
 	} else
 		rc = -EINVAL;
@@ -2319,7 +2319,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		u32 npid = open_file->pid;
 		pTcon = tlink_tcon(open_file->tlink);
 		rc = CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npid);
-		cifsFileInfo_put(open_file);
+		cifsFileInfo_put(open_file, true);
 	} else {
 		tlink = cifs_sb_tlink(cifs_sb);
 		if (IS_ERR(tlink)) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index bee203055b30..48bcc4459d0f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -501,8 +501,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 					   &pCifsInode->flags);
 
-				queue_work(cifsoplockd_wq,
-					   &netfile->oplock_break);
+				cifs_queue_oplock_break(netfile);
 				netfile->oplock_break_cancelled = false;
 
 				spin_unlock(&tcon->open_file_lock);
@@ -607,6 +606,28 @@ void cifs_put_writer(struct cifsInodeInfo *cinode)
 	spin_unlock(&cinode->writers_lock);
 }
 
+/**
+ * cifs_queue_oplock_break - queue the oplock break handler for cfile
+ *
+ * This function is called from the demultiplex thread when it
+ * receives an oplock break for @cfile.
+ *
+ * Assumes the tcon->open_file_lock is held.
+ * Assumes cfile->file_info_lock is NOT held.
+ */
+void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
+{
+	/*
+	 * Bump the handle refcount now while we hold the
+	 * open_file_lock to enforce the validity of it for the oplock
+	 * break handler. The matching put is done at the end of the
+	 * handler.
+	 */
+	cifsFileInfo_get(cfile);
+
+	queue_work(cifsoplockd_wq, &cfile->oplock_break);
+}
+
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
 {
 	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
@@ -785,7 +806,7 @@ cifs_aio_ctx_release(struct kref *refcount)
 	struct cifs_aio_ctx *ctx = container_of(refcount,
 					struct cifs_aio_ctx, refcount);
 
-	cifsFileInfo_put(ctx->cfile);
+	cifsFileInfo_put(ctx->cfile, true);
 	kvfree(ctx->bv);
 	kfree(ctx);
 }
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index c711f1f39bf2..a5edf08644bf 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -828,7 +828,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 	if (open_file == NULL)
 		CIFSSMBClose(xid, tcon, fid.netfid);
 	else
-		cifsFileInfo_put(open_file);
+		cifsFileInfo_put(open_file, true);
 out:
 	if (tlink != NULL)
 		cifs_put_tlink(tlink);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0e3570e40ff8..e311f58dc1c8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -555,7 +555,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 				  &cinode->flags);
 
-		queue_work(cifsoplockd_wq, &cfile->oplock_break);
+		cifs_queue_oplock_break(cfile);
 		kfree(lw);
 		return true;
 	}
@@ -712,8 +712,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
 					   &cinode->flags);
 				spin_unlock(&cfile->file_info_lock);
-				queue_work(cifsoplockd_wq,
-					   &cfile->oplock_break);
+
+				cifs_queue_oplock_break(cfile);
 
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e755236af8ff..e496d6287da0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2584,7 +2584,7 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 		return get_smb2_acl_by_path(cifs_sb, path, pacllen);
 
 	pntsd = get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen);
-	cifsFileInfo_put(open_file);
+	cifsFileInfo_put(open_file, true);
 	return pntsd;
 }
 #endif
-- 
2.16.4

