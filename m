From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 4/7] CIFS: Add brlock support for SMB2
Date: Mon, 10 Sep 2012 16:19:32 +0400
Message-ID: <1347279575-6071-5-git-send-email-pshilovsky@etersoft.ru>
References: <1347279575-6071-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347279575-6071-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++
 fs/cifs/file.c      |    8 ++---
 fs/cifs/smb2file.c  |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |   13 +++++++
 fs/cifs/smb2pdu.c   |   59 +++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   24 ++++++++++++
 fs/cifs/smb2proto.h |   10 +++++
 7 files changed, 210 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a7e238f..15e38dc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -190,6 +190,10 @@ extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
+extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
+extern void cifs_free_llist(struct list_head *llist);
+extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
+
 extern int cifs_negotiate_protocol(const unsigned int xid,
 				   struct cifs_ses *ses);
 extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fc65f07..affa001 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -288,8 +288,6 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	return cfile;
 }
 
-static void cifs_del_lock_waiters(struct cifsLockInfo *lock);
-
 struct cifsFileInfo *
 cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 {
@@ -696,7 +694,7 @@ cifs_lock_init(__u64 offset, __u64 length, __u8 type)
 	return lock;
 }
 
-static void
+void
 cifs_del_lock_waiters(struct cifsLockInfo *lock)
 {
 	struct cifsLockInfo *li, *tmp;
@@ -1229,7 +1227,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 	return 0;
 }
 
-static void
+void
 cifs_move_llist(struct list_head *source, struct list_head *dest)
 {
 	struct list_head *li, *tmp;
@@ -1237,7 +1235,7 @@ cifs_move_llist(struct list_head *source, struct list_head *dest)
 		list_move(li, dest);
 }
 
-static void
+void
 cifs_free_llist(struct list_head *llist)
 {
 	struct cifsLockInfo *li, *tmp;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 5ff25e0..a25ea02 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -104,3 +104,100 @@ out:
 	kfree(smb2_path);
 	return rc;
 }
+
+int
+smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
+		  const unsigned int xid)
+{
+	int rc = 0, stored_rc;
+	unsigned int max_num, num = 0, max_buf;
+	struct smb2_lock_element *buf, *cur;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifsLockInfo *li, *tmp;
+	__u64 length = 1 + flock->fl_end - flock->fl_start;
+	struct list_head tmp_llist;
+
+	INIT_LIST_HEAD(&tmp_llist);
+
+	/*
+	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * and check it for zero before using.
+	 */
+	max_buf = tcon->ses->server->maxBuf;
+	if (!max_buf)
+		return -EINVAL;
+
+	max_num = max_buf / sizeof(struct smb2_lock_element);
+	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	cur = buf;
+
+	mutex_lock(&cinode->lock_mutex);
+	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
+		if (flock->fl_start > li->offset ||
+		    (flock->fl_start + length) <
+		    (li->offset + li->length))
+			continue;
+		if (current->tgid != li->pid)
+			continue;
+		if (cinode->can_cache_brlcks) {
+			/*
+			 * We can cache brlock requests - simply remove a lock
+			 * from the file's list.
+			 */
+			list_del(&li->llist);
+			cifs_del_lock_waiters(li);
+			kfree(li);
+			continue;
+		}
+		cur->Length = cpu_to_le64(li->length);
+		cur->Offset = cpu_to_le64(li->offset);
+		cur->Flags = cpu_to_le32(SMB2_LOCKFLAG_UNLOCK);
+		/*
+		 * We need to save a lock here to let us add it again to the
+		 * file's list if the unlock range request fails on the server.
+		 */
+		list_move(&li->llist, &tmp_llist);
+		if (++num == max_num) {
+			stored_rc = smb2_lockv(xid, tcon,
+					       cfile->fid.persistent_fid,
+					       cfile->fid.volatile_fid,
+					       current->tgid, num, buf);
+			if (stored_rc) {
+				/*
+				 * We failed on the unlock range request - add
+				 * all locks from the tmp list to the head of
+				 * the file's list.
+				 */
+				cifs_move_llist(&tmp_llist,
+						&cfile->llist->locks);
+				rc = stored_rc;
+			} else
+				/*
+				 * The unlock range request succeed - free the
+				 * tmp list.
+				 */
+				cifs_free_llist(&tmp_llist);
+			cur = buf;
+			num = 0;
+		} else
+			cur++;
+	}
+	if (num) {
+		stored_rc = smb2_lockv(xid, tcon, cfile->fid.persistent_fid,
+				       cfile->fid.volatile_fid, current->tgid,
+				       num, buf);
+		if (stored_rc) {
+			cifs_move_llist(&tmp_llist, &cfile->llist->locks);
+			rc = stored_rc;
+		} else
+			cifs_free_llist(&tmp_llist);
+	}
+	mutex_unlock(&cinode->lock_mutex);
+
+	kfree(buf);
+	return rc;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e4a59d1..caed2c5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -544,6 +544,17 @@ smb2_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
 	       ob1->fid.volatile_fid == ob2->fid.volatile_fid;
 }
 
+static int
+smb2_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
+	       __u64 length, __u32 type, int lock, int unlock, bool wait)
+{
+	if (unlock && !lock)
+		type = SMB2_LOCKFLAG_UNLOCK;
+	return SMB2_lock(xid, tlink_tcon(cfile->tlink),
+			 cfile->fid.persistent_fid, cfile->fid.volatile_fid,
+			 current->tgid, length, offset, type, wait);
+}
+
 struct smb_version_operations smb21_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -602,6 +613,8 @@ struct smb_version_operations smb21_operations = {
 	.is_status_pending = smb2_is_status_pending,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
+	.mand_lock = smb2_mand_lock,
+	.mand_unlock_range = smb2_unlock_range,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1b44761..d3e1cfc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2047,3 +2047,62 @@ qinf_exit:
 	free_rsp_buf(resp_buftype, iov.iov_base);
 	return rc;
 }
+
+int
+smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
+	   const __u64 persist_fid, const __u64 volatile_fid, const __u32 pid,
+	   const __u32 num_lock, struct smb2_lock_element *buf)
+{
+	int rc = 0;
+	struct smb2_lock_req *req = NULL;
+	struct kvec iov[2];
+	int resp_buf_type;
+	unsigned int count;
+
+	cFYI(1, "smb2_lockv num lock %d", num_lock);
+
+	rc = small_smb2_init(SMB2_LOCK, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	req->hdr.ProcessId = cpu_to_le32(pid);
+	req->LockCount = cpu_to_le16(num_lock);
+
+	req->PersistentFileId = persist_fid;
+	req->VolatileFileId = volatile_fid;
+
+	count = num_lock * sizeof(struct smb2_lock_element);
+	inc_rfc1001_len(req, count - sizeof(struct smb2_lock_element));
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field and count for all locks */
+	iov[0].iov_len = get_rfc1002_length(req) + 4 - count;
+	iov[1].iov_base = (char *)buf;
+	iov[1].iov_len = count;
+
+	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
+	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
+	if (rc) {
+		cFYI(1, "Send error in smb2_lockv = %d", rc);
+		cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
+	}
+
+	return rc;
+}
+
+int
+SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
+	  const __u64 persist_fid, const __u64 volatile_fid, const __u32 pid,
+	  const __u64 length, const __u64 offset, const __u32 lock_flags,
+	  const bool wait)
+{
+	struct smb2_lock_element lock;
+
+	lock.Offset = cpu_to_le64(offset);
+	lock.Length = cpu_to_le64(length);
+	lock.Flags = cpu_to_le32(lock_flags);
+	if (!wait && lock_flags != SMB2_LOCKFLAG_UNLOCK)
+		lock.Flags |= cpu_to_le32(SMB2_LOCKFLAG_FAIL_IMMEDIATELY);
+
+	return smb2_lockv(xid, tcon, persist_fid, volatile_fid, pid, 1, &lock);
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d2d132e..889ee5e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -531,6 +531,30 @@ struct smb2_write_rsp {
 #define SMB2_LOCKFLAG_UNLOCK		0x0004
 #define SMB2_LOCKFLAG_FAIL_IMMEDIATELY	0x0010
 
+struct smb2_lock_element {
+	__le64 Offset;
+	__le64 Length;
+	__le32 Flags;
+	__le32 Reserved;
+} __packed;
+
+struct smb2_lock_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 48 */
+	__le16 LockCount;
+	__le32 Reserved;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	/* Followed by at least one */
+	struct smb2_lock_element locks[1];
+} __packed;
+
+struct smb2_lock_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
 struct smb2_echo_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index aeb30db..ab19152 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -84,6 +84,8 @@ extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_fid *fid, __u32 *oplock,
 			  FILE_ALL_INFO *buf, struct cifs_sb_info *cifs_sb);
 extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
+extern int smb2_unlock_range(struct cifsFileInfo *cfile,
+			     struct file_lock *flock, const unsigned int xid);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
@@ -140,5 +142,13 @@ extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
 			 struct kstatfs *FSData);
+extern int SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
+		     const __u64 persist_fid, const __u64 volatile_fid,
+		     const __u32 pid, const __u64 length, const __u64 offset,
+		     const __u32 lockFlags, const bool wait);
+extern int smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
+		      const __u64 persist_fid, const __u64 volatile_fid,
+		      const __u32 pid, const __u32 num_lock,
+		      struct smb2_lock_element *buf);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
