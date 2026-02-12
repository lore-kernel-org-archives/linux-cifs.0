Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E481DC985
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 19:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770925598; cv=none; b=X559kgUdx6rU7BUuYvnMlm+4OkXK2w1mbIposuQnyc8N4fwq2/cUso0Xa9nrdXI5XjXJ5bAjUEqADuT0eel+iduFnVA+VfYTsNi9YLGMB8wNuz7/Knh22XjI2xuklYFUd3txrFEn7S6+dHXYZHaMLh8OS89RbCXokH1Eqcctlpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770925598; c=relaxed/simple;
	bh=R83Taa5dX+u0zwcltN6tPwx06lwAQzWD4QtHlmmptL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DMrg4S6OpN4dZUy4mv6y7dua9sqeLfd99WzlkaP+0fzgu1btdrYaFlf3HV89xibdj/FBVHCBwA3FqAMdhOFCV/1hjBNSJDCchdF5O8EWvFS5oAtofwZ/hWHQrDipFz0QsdWbZFdPsqZxk0DIEn81d6DusXMiNXYKjNpdaP69668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xQIBdzHi; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xQIBdzHi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gY0Qaf0I6mmghTEJZXTciglEmV2/bQsaKMn8F3+Rxzs=; b=xQIBdzHi6bexdBs6bMW0uw3Uny
	0qrXRjdqxKXaZm0Nm2fAsPwAqGhY7J1ECmhoIvp8oGEKlZs9YhrD7hp4rB1P/SzJo2bkTy8MB0HEo
	nt4u1Z+nyLkh2mB2zF1rATyHjwgkW5OCknOC4wwmKlxm8x2k42oA5lGl24nEzzfJmXpHm3WvOGrYr
	RhzqeSyKhnPTCleteGM6jx/N6eJi9vqo//aqveEBisJQ6CZ/xu0X7WwbN0slao6IoszT6OaHVwbgC
	HUOAU82uwKjpylKAT3Ol3nAcD1n92Eigjece36IeLTGiWg5mDXlq65Obc5bARIvh9eMqiu1xWRnfU
	tOyOp3gQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vqcdu-000000006oL-0uCr;
	Thu, 12 Feb 2026 16:46:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Frank Sorenson <sorenson@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix data corruption due to racy lease checks
Date: Thu, 12 Feb 2026 16:46:26 -0300
Message-ID: <20260212194626.879692-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customer reported data corruption in some of their files.  It turned
out the client would end up calling cacheless IO functions while
having RHW lease, bypassing the pagecache and then leaving gaps in the
file while writing to it.  It was related to concurrent opens changing
the lease state while having writes in flight.  Lease breaks and
re-opens due to reconnect could also cause same issue.

Fix this by serialising the lease updates with
cifsInodeInfo::open_file_lock.  When handling oplock break, make sure
to use the downgraded oplock value rather than one in cifsInodeinfo as
it could be changed concurrently.

Reported-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h  | 36 ++++++++++++++++++++-----
 fs/smb/client/file.c      | 57 ++++++++++++++++++++++++---------------
 fs/smb/client/smb1ops.c   | 16 ++++++++---
 fs/smb/client/smb2misc.c  | 10 +++----
 fs/smb/client/smb2ops.c   | 44 +++++++++++++++++-------------
 fs/smb/client/smb2proto.h |  2 +-
 6 files changed, 110 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7eb0131963dd..aab54daae3ac 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -515,8 +515,10 @@ struct smb_version_operations {
 	/* check for STATUS_NETWORK_SESSION_EXPIRED */
 	bool (*is_session_expired)(char *);
 	/* send oplock break response */
-	int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_fid, __u64 volatile_fid,
-			__u16 net_fid, struct cifsInodeInfo *cifs_inode);
+	int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_fid,
+			       __u64 volatile_fid, __u16 net_fid,
+			       struct cifsInodeInfo *cifs_inode,
+			       unsigned int oplock);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
 		       const char *, struct cifs_sb_info *, struct kstatfs *);
@@ -1531,10 +1533,6 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 #define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
 #define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
-#define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
-
 /*
  * One of these for each file inode
  */
@@ -2312,4 +2310,30 @@ static inline void cifs_requeue_server_reconn(struct TCP_Server_Info *server)
 	queue_delayed_work(cifsiod_wq, &server->reconnect, delay * HZ);
 }
 
+static inline bool __cifs_cache_state_check(struct cifsInodeInfo *cinode,
+					    unsigned int oplock_flags,
+					    unsigned int sb_flags)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cinode->netfs.inode.i_sb);
+	unsigned int oplock = READ_ONCE(cinode->oplock);
+	unsigned int sflags = cifs_sb->mnt_cifs_flags;
+
+	return (oplock & oplock_flags) || (sflags & sb_flags);
+}
+
+#define CIFS_CACHE_READ(cinode) \
+	__cifs_cache_state_check(cinode, CIFS_CACHE_READ_FLG, \
+				 CIFS_MOUNT_RO_CACHE)
+#define CIFS_CACHE_HANDLE(cinode) \
+	__cifs_cache_state_check(cinode, CIFS_CACHE_HANDLE_FLG, 0)
+#define CIFS_CACHE_WRITE(cinode) \
+	__cifs_cache_state_check(cinode, CIFS_CACHE_WRITE_FLG, \
+				 CIFS_MOUNT_RW_CACHE)
+
+static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
+{
+	guard(spinlock)(&cinode->open_file_lock);
+	WRITE_ONCE(cinode->oplock, 0);
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 51360d64b7b2..88273f82812b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -731,14 +731,14 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		oplock = fid->pending_open->oplock;
 	list_del(&fid->pending_open->olist);
 
-	fid->purge_cache = false;
-	server->ops->set_fid(cfile, fid, oplock);
-
 	list_add(&cfile->tlist, &tcon->openFileList);
 	atomic_inc(&tcon->num_local_opens);
 
 	/* if readable file instance put first in list*/
 	spin_lock(&cinode->open_file_lock);
+	fid->purge_cache = false;
+	server->ops->set_fid(cfile, fid, oplock);
+
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
 	else
@@ -1410,7 +1410,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		oplock = 0;
 	}
 
-	server->ops->set_fid(cfile, &cfile->fid, oplock);
+	scoped_guard(spinlock, &cinode->open_file_lock)
+		server->ops->set_fid(cfile, &cfile->fid, oplock);
 	if (oparms.reconnect)
 		cifs_relock_file(cfile);
 
@@ -1437,11 +1438,11 @@ smb2_can_defer_close(struct inode *inode, struct cifs_deferred_close *dclose)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	unsigned int oplock = READ_ONCE(cinode->oplock);
 
-	return (cifs_sb->ctx->closetimeo && cinode->lease_granted && dclose &&
-			(cinode->oplock == CIFS_CACHE_RHW_FLG ||
-			 cinode->oplock == CIFS_CACHE_RH_FLG) &&
-			!test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags));
+	return cifs_sb->ctx->closetimeo && cinode->lease_granted && dclose &&
+		(oplock == CIFS_CACHE_RHW_FLG || oplock == CIFS_CACHE_RH_FLG) &&
+		!test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags);
 
 }
 
@@ -2371,7 +2372,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 			cifs_zap_mapping(inode);
 			cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n",
 				 inode);
-			CIFS_I(inode)->oplock = 0;
+			cifs_reset_oplock(CIFS_I(inode));
 		}
 
 		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
@@ -2930,7 +2931,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 		cifs_zap_mapping(inode);
 		cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=%p after write\n",
 			 inode);
-		cinode->oplock = 0;
+		cifs_reset_oplock(cinode);
 	}
 out:
 	cifs_put_writer(cinode);
@@ -2966,7 +2967,7 @@ ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			cifs_dbg(FYI,
 				 "Set no oplock for inode=%p after a write operation\n",
 				 inode);
-			cinode->oplock = 0;
+			cifs_reset_oplock(cinode);
 		}
 		return written;
 	}
@@ -3154,9 +3155,11 @@ void cifs_oplock_break(struct work_struct *work)
 	struct super_block *sb = inode->i_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	bool cache_read, cache_write, cache_handle;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
+	unsigned int oplock;
 	int rc = 0;
 	bool purge_cache = false, oplock_break_cancelled;
 	__u64 persistent_fid, volatile_fid;
@@ -3177,29 +3180,40 @@ void cifs_oplock_break(struct work_struct *work)
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
-				      cfile->oplock_epoch, &purge_cache);
+	scoped_guard(spinlock, &cinode->open_file_lock) {
+		unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 
-	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
-						cifs_has_mand_locks(cinode)) {
+		server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
+					      cfile->oplock_epoch, &purge_cache);
+		oplock = READ_ONCE(cinode->oplock);
+		cache_read = (oplock & CIFS_CACHE_READ_FLG) ||
+			(sbflags & CIFS_MOUNT_RO_CACHE);
+		cache_write = (oplock & CIFS_CACHE_WRITE_FLG) ||
+			(sbflags & CIFS_MOUNT_RW_CACHE);
+		cache_handle = oplock & CIFS_CACHE_HANDLE_FLG;
+	}
+
+	if (!cache_write && cache_read && cifs_has_mand_locks(cinode)) {
 		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
 			 inode);
-		cinode->oplock = 0;
+		cifs_reset_oplock(cinode);
+		oplock = 0;
+		cache_read = cache_write = cache_handle = false;
 	}
 
 	if (S_ISREG(inode->i_mode)) {
-		if (CIFS_CACHE_READ(cinode))
+		if (cache_read)
 			break_lease(inode, O_RDONLY);
 		else
 			break_lease(inode, O_WRONLY);
 		rc = filemap_fdatawrite(inode->i_mapping);
-		if (!CIFS_CACHE_READ(cinode) || purge_cache) {
+		if (!cache_read || purge_cache) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_zap_mapping(inode);
 		}
 		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
-		if (CIFS_CACHE_WRITE(cinode))
+		if (cache_write)
 			goto oplock_break_ack;
 	}
 
@@ -3214,7 +3228,7 @@ void cifs_oplock_break(struct work_struct *work)
 	 * So, new open will not use cached handle.
 	 */
 
-	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
+	if (!cache_handle && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
 
 	persistent_fid = cfile->fid.persistent_fid;
@@ -3232,7 +3246,8 @@ void cifs_oplock_break(struct work_struct *work)
 	if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
 		spin_unlock(&cinode->open_file_lock);
 		rc = server->ops->oplock_response(tcon, persistent_fid,
-						  volatile_fid, net_fid, cinode);
+						  volatile_fid, net_fid,
+						  cinode, oplock);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	} else
 		spin_unlock(&cinode->open_file_lock);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9c3b97d2a20a..970aeffe936e 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -395,6 +395,7 @@ cifs_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
 		      __u16 epoch, bool *purge_cache)
 {
+	lockdep_assert_held(&cinode->open_file_lock);
 	cifs_set_oplock_level(cinode, oplock);
 }
 
@@ -894,6 +895,9 @@ static void
 cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
+
+	lockdep_assert_held(&cinode->open_file_lock);
+
 	cfile->fid.netfid = fid->netfid;
 	cifs_set_oplock_level(cinode, oplock);
 	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
@@ -1139,12 +1143,16 @@ cifs_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 	return CIFSFindClose(xid, tcon, fid->netfid);
 }
 
-static int
-cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
-		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
+static int cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+				__u64 volatile_fid, __u16 net_fid,
+				struct cifsInodeInfo *cinode, unsigned int oplock)
 {
+	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
+	__u8 op;
+
+	op = !!((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT_RO_CACHE));
 	return CIFSSMBLock(0, tcon, net_fid, current->tgid, 0, 0, 0, 0,
-			   LOCKING_ANDX_OPLOCK_RELEASE, false, CIFS_CACHE_READ(cinode) ? 1 : 0);
+			   LOCKING_ANDX_OPLOCK_RELEASE, false, op);
 }
 
 static int
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 0871b9f1f86a..d1ae839e4863 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -484,16 +484,16 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 	return to;
 }
 
-__le32
-smb2_get_lease_state(struct cifsInodeInfo *cinode)
+__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock)
 {
+	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
 	__le32 lease = 0;
 
-	if (CIFS_CACHE_WRITE(cinode))
+	if ((oplock & CIFS_CACHE_WRITE_FLG) || (sbflags & CIFS_MOUNT_RW_CACHE))
 		lease |= SMB2_LEASE_WRITE_CACHING_LE;
-	if (CIFS_CACHE_HANDLE(cinode))
+	if (oplock & CIFS_CACHE_HANDLE_FLG)
 		lease |= SMB2_LEASE_HANDLE_CACHING_LE;
-	if (CIFS_CACHE_READ(cinode))
+	if ((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT_RO_CACHE))
 		lease |= SMB2_LEASE_READ_CACHING_LE;
 	return lease;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 262df6d2c2c8..1e13dd0a24c3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1460,6 +1460,8 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 
+	lockdep_assert_held(&cinode->open_file_lock);
+
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
 	cfile->fid.access = fid->access;
@@ -2684,16 +2686,19 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 	return false;
 }
 
-static int
-smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
-		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
+static int smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+				__u64 volatile_fid, __u16 net_fid,
+				struct cifsInodeInfo *cinode, unsigned int oplock)
 {
+	unsigned int sbflags = CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags;
+	__u8 op;
+
 	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		return SMB2_lease_break(0, tcon, cinode->lease_key,
-					smb2_get_lease_state(cinode));
+					smb2_get_lease_state(cinode, oplock));
 
-	return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid,
-				 CIFS_CACHE_READ(cinode) ? 1 : 0);
+	op = !!((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT_RO_CACHE));
+	return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid, op);
 }
 
 void
@@ -4053,6 +4058,7 @@ smb2_downgrade_oplock(struct TCP_Server_Info *server,
 		      struct cifsInodeInfo *cinode, __u32 oplock,
 		      __u16 epoch, bool *purge_cache)
 {
+	lockdep_assert_held(&cinode->open_file_lock);
 	server->ops->set_oplock_level(cinode, oplock, 0, NULL);
 }
 
@@ -4093,19 +4099,19 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		cinode->oplock = CIFS_CACHE_RHW_FLG;
+		WRITE_ONCE(cinode->oplock, CIFS_CACHE_RHW_FLG);
 		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
 			 &cinode->netfs.inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		cinode->oplock = CIFS_CACHE_RW_FLG;
+		WRITE_ONCE(cinode->oplock, CIFS_CACHE_RW_FLG);
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
 			 &cinode->netfs.inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
-		cinode->oplock = CIFS_CACHE_READ_FLG;
+		WRITE_ONCE(cinode->oplock, CIFS_CACHE_READ_FLG);
 		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
 			 &cinode->netfs.inode);
 	} else
-		cinode->oplock = 0;
+		WRITE_ONCE(cinode->oplock, 0);
 }
 
 static void
@@ -4140,7 +4146,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	if (!new_oplock)
 		strscpy(message, "None");
 
-	cinode->oplock = new_oplock;
+	WRITE_ONCE(cinode->oplock, new_oplock);
 	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
 		 &cinode->netfs.inode);
 }
@@ -4149,30 +4155,32 @@ static void
 smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		      __u16 epoch, bool *purge_cache)
 {
-	unsigned int old_oplock = cinode->oplock;
+	unsigned int old_oplock = READ_ONCE(cinode->oplock);
+	unsigned int new_oplock;
 
 	smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
+	new_oplock = READ_ONCE(cinode->oplock);
 
 	if (purge_cache) {
 		*purge_cache = false;
 		if (old_oplock == CIFS_CACHE_READ_FLG) {
-			if (cinode->oplock == CIFS_CACHE_READ_FLG &&
+			if (new_oplock == CIFS_CACHE_READ_FLG &&
 			    (epoch - cinode->epoch > 0))
 				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RH_FLG &&
+			else if (new_oplock == CIFS_CACHE_RH_FLG &&
 				 (epoch - cinode->epoch > 1))
 				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
+			else if (new_oplock == CIFS_CACHE_RHW_FLG &&
 				 (epoch - cinode->epoch > 1))
 				*purge_cache = true;
-			else if (cinode->oplock == 0 &&
+			else if (new_oplock == 0 &&
 				 (epoch - cinode->epoch > 0))
 				*purge_cache = true;
 		} else if (old_oplock == CIFS_CACHE_RH_FLG) {
-			if (cinode->oplock == CIFS_CACHE_RH_FLG &&
+			if (new_oplock == CIFS_CACHE_RH_FLG &&
 			    (epoch - cinode->epoch > 0))
 				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
+			else if (new_oplock == CIFS_CACHE_RHW_FLG &&
 				 (epoch - cinode->epoch > 1))
 				*purge_cache = true;
 		}
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c7759e37d975..881e42cf66ce 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -42,7 +42,7 @@ struct mid_q_entry *smb2_setup_async_request(struct TCP_Server_Info *server,
 					     struct smb_rqst *rqst);
 struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 				     __u64 ses_id, __u32  tid);
-__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
+__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock);
 bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server);
 int smb3_handle_read_data(struct TCP_Server_Info *server,
 			  struct mid_q_entry *mid);
-- 
2.53.0

