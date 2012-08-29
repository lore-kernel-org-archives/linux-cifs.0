From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] CIFS: Use brlock cache for SMB2
Date: Wed, 29 Aug 2012 18:35:07 +0400
Message-ID: <1346250908-16832-6-git-send-email-pshilovsky@etersoft.ru>
References: <1346250908-16832-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346250908-16832-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2file.c  |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |    3 +-
 fs/cifs/smb2proto.h |    1 +
 3 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index a25ea02..827d42d 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -201,3 +201,86 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	kfree(buf);
 	return rc;
 }
+
+static int
+__smb2_push_mandatory_locks(struct cifs_fid_locks *fdlocks,
+			    const unsigned int xid)
+{
+	int rc = 0, stored_rc;
+	struct cifsFileInfo *cfile = fdlocks->cfile;
+	struct cifsLockInfo *li;
+	unsigned int max_num, num = 0, max_buf;
+	struct smb2_lock_element *buf, *cur;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
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
+	list_for_each_entry(li, &fdlocks->locks, llist) {
+		cur->Length = cpu_to_le64(li->length);
+		cur->Offset = cpu_to_le64(li->offset);
+		cur->Flags = cpu_to_le32(li->type |
+						SMB2_LOCKFLAG_FAIL_IMMEDIATELY);
+		if (++num == max_num) {
+			stored_rc = smb2_lockv(xid, tcon,
+					       cfile->fid.persistent_fid,
+					       cfile->fid.volatile_fid,
+					       current->tgid, num, buf);
+			if (stored_rc)
+				rc = stored_rc;
+			cur = buf;
+			num = 0;
+		} else
+			cur++;
+	}
+	if (num) {
+		stored_rc = smb2_lockv(xid, tcon,
+				       cfile->fid.persistent_fid,
+				       cfile->fid.volatile_fid,
+				       current->tgid, num, buf);
+		if (stored_rc)
+			rc = stored_rc;
+	}
+
+	return rc;
+}
+
+int
+smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
+{
+	int rc = 0, stored_rc;
+	unsigned int xid;
+	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct cifs_fid_locks *cur, *tmp;
+
+	xid = get_xid();
+	mutex_lock(&cinode->lock_mutex);
+	if (!cinode->can_cache_brlcks) {
+		mutex_unlock(&cinode->lock_mutex);
+		free_xid(xid);
+		return rc;
+	}
+
+	list_for_each_entry_safe(cur, tmp, &cinode->llist, llist) {
+		stored_rc = __smb2_push_mandatory_locks(cur, xid);
+		if (stored_rc)
+			rc = stored_rc;
+	}
+
+	cinode->can_cache_brlcks = false;
+	mutex_unlock(&cinode->lock_mutex);
+	free_xid(xid);
+	return rc;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index caed2c5..0808b23 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -371,7 +371,7 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
 	smb2_set_oplock_level(cinode, oplock);
-	/* cinode->can_cache_brlcks = cinode->clientCanCacheAll; */
+	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
 }
 
 static int
@@ -615,6 +615,7 @@ struct smb_version_operations smb21_operations = {
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
 	.mand_unlock_range = smb2_unlock_range,
+	.push_mand_locks = smb2_push_mandatory_locks,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ab19152..8b4d371 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -86,6 +86,7 @@ extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
 extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
+extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
