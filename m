From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] CIFS: Fix fast lease break after open problem
Date: Tue,  4 Sep 2012 20:24:07 +0400
Message-ID: <1346775847-7894-5-git-send-email-pshilovsky@etersoft.ru>
References: <1346775847-7894-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346775847-7894-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now we walk though cifsFileInfo's list for every incoming lease
break and look for an equivalent there. That approach misses lease
breaks that come just after an open response - we don't have time
to populate new cifsFileInfo structure to the list. Fix this by
adding new list of pending opens and look for a lease there if we
didn't find it in the list of cifsFileInfo structures.

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   12 ++++++++
 fs/cifs/cifsproto.h |    7 +++++
 fs/cifs/connect.c   |    1 +
 fs/cifs/dir.c       |    9 +++++-
 fs/cifs/file.c      |   35 +++++++++++++++++++++---
 fs/cifs/misc.c      |   30 ++++++++++++++++++++
 fs/cifs/smb2misc.c  |   74 +++++++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 158 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b6ec142..a39e5b7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -715,6 +715,7 @@ struct cifs_ses {
 	__u16 session_flags;
 #endif /* CONFIG_CIFS_SMB2 */
 };
+
 /* no more than one of the following three session flags may be set */
 #define CIFS_SES_NT4 1
 #define CIFS_SES_OS2 2
@@ -821,6 +822,7 @@ struct cifs_tcon {
 	u64 resource_id;		/* server resource id */
 	struct fscache_cookie *fscache;	/* cookie for share */
 #endif
+	struct list_head pending_opens;	/* list of incomplete opens */
 	/* BB add field for back pointer to sb struct(s)? */
 };
 
@@ -863,6 +865,15 @@ cifs_get_tlink(struct tcon_link *tlink)
 /* This function is always expected to succeed */
 extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 
+#define CIFS_OPLOCK_NO_CHANGE 0xfe
+
+struct cifs_pending_open {
+	struct list_head olist;
+	struct tcon_link *tlink;
+	__u8 lease_key[16];
+	__u32 oplock;
+};
+
 /*
  * This info hangs off the cifsFileInfo structure, pointed to by llist.
  * This is used to track byte stream locks on the file
@@ -903,6 +914,7 @@ struct cifs_fid {
 	__u64 volatile_fid;	/* volatile file id for smb2 */
 	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
 #endif
+	struct cifs_pending_open *pending_open;
 };
 
 struct cifs_fid_locks {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c758ee7..09ea632 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -184,6 +184,13 @@ extern bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 				    __u64 length, __u8 type,
 				    struct cifsLockInfo **conf_lock,
 				    bool rw_check);
+extern void cifs_add_pending_open(struct cifs_fid *fid,
+				  struct tcon_link *tlink,
+				  struct cifs_pending_open *open);
+extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
+					 struct tcon_link *tlink,
+					 struct cifs_pending_open *open);
+extern void cifs_del_pending_open(struct cifs_pending_open *open);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 443e396..59c595e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2645,6 +2645,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	tcon->retry = volume_info->retry;
 	tcon->nocase = volume_info->nocase;
 	tcon->local_lease = volume_info->local_lease;
+	INIT_LIST_HEAD(&tcon->pending_opens);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4f2147c..7c0a812 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -382,6 +382,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
+	struct cifs_pending_open open;
 	__u32 oplock;
 	struct cifsFileInfo *file_info;
 
@@ -423,16 +424,21 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	if (server->ops->new_lease_key)
 		server->ops->new_lease_key(&fid);
 
+	cifs_add_pending_open(&fid, tlink, &open);
+
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
 			    &oplock, &fid, opened);
 
-	if (rc)
+	if (rc) {
+		cifs_del_pending_open(&open);
 		goto out;
+	}
 
 	rc = finish_open(file, direntry, generic_file_open, opened);
 	if (rc) {
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
 		goto out;
 	}
 
@@ -440,6 +446,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	if (file_info == NULL) {
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
 		rc = -ENOMEM;
 	}
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index da7e3d4..2f79433 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -247,6 +247,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifsFileInfo *cfile;
 	struct cifs_fid_locks *fdlocks;
+	struct cifs_tcon *tcon = tlink_tcon(tlink);
 
 	cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (cfile == NULL)
@@ -274,10 +275,15 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	cfile->tlink = cifs_get_tlink(tlink);
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	mutex_init(&cfile->fh_mutex);
-	tlink_tcon(tlink)->ses->server->ops->set_fid(cfile, fid, oplock);
 
 	spin_lock(&cifs_file_list_lock);
-	list_add(&cfile->tlist, &(tlink_tcon(tlink)->openFileList));
+	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE)
+		oplock = fid->pending_open->oplock;
+	list_del(&fid->pending_open->olist);
+
+	tlink_tcon(tlink)->ses->server->ops->set_fid(cfile, fid, oplock);
+
+	list_add(&cfile->tlist, &tcon->openFileList);
 	/* if readable file instance put first in list*/
 	if (file->f_mode & FMODE_READ)
 		list_add(&cfile->flist, &cinode->openFileList);
@@ -307,9 +313,12 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
 	struct inode *inode = cifs_file->dentry->d_inode;
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsLockInfo *li, *tmp;
+	struct cifs_fid fid;
+	struct cifs_pending_open open;
 
 	spin_lock(&cifs_file_list_lock);
 	if (--cifs_file->count > 0) {
@@ -317,6 +326,12 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		return;
 	}
 
+	if (server->ops->get_lease_key)
+		server->ops->get_lease_key(inode, &fid);
+
+	/* store open in pending opens to make sure we don't miss lease break */
+	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
+
 	/* remove it from the lists */
 	list_del(&cifs_file->flist);
 	list_del(&cifs_file->tlist);
@@ -348,6 +363,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		free_xid(xid);
 	}
 
+	cifs_del_pending_open(&open);
+
 	/*
 	 * Delete any outstanding lock records. We'll lose them when the file
 	 * is closed anyway.
@@ -368,6 +385,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 }
 
 int cifs_open(struct inode *inode, struct file *file)
+
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -380,6 +398,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	char *full_path = NULL;
 	bool posix_open_ok = false;
 	struct cifs_fid fid;
+	struct cifs_pending_open open;
 
 	xid = get_xid();
 
@@ -401,7 +420,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
 		 inode, file->f_flags, full_path);
 
-	if (tcon->ses->server->oplocks)
+	if (server->oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
@@ -434,20 +453,28 @@ int cifs_open(struct inode *inode, struct file *file)
 		 */
 	}
 
+	if (server->ops->get_lease_key)
+		server->ops->get_lease_key(inode, &fid);
+
+	cifs_add_pending_open(&fid, tlink, &open);
+
 	if (!posix_open_ok) {
 		if (server->ops->get_lease_key)
 			server->ops->get_lease_key(inode, &fid);
 
 		rc = cifs_nt_open(full_path, inode, cifs_sb, tcon,
 				  file->f_flags, &oplock, &fid, xid);
-		if (rc)
+		if (rc) {
+			cifs_del_pending_open(&open);
 			goto out;
+		}
 	}
 
 	cfile = cifs_new_fileinfo(&fid, file, tlink, oplock);
 	if (cfile == NULL) {
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a921b07..3a00c0d 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -579,3 +579,33 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 
 	return false;
 }
+
+void
+cifs_del_pending_open(struct cifs_pending_open *open)
+{
+	spin_lock(&cifs_file_list_lock);
+	list_del(&open->olist);
+	spin_unlock(&cifs_file_list_lock);
+}
+
+void
+cifs_add_pending_open_locked(struct cifs_fid *fid, struct tcon_link *tlink,
+			     struct cifs_pending_open *open)
+{
+#ifdef CONFIG_CIFS_SMB2
+	memcpy(open->lease_key, fid->lease_key, SMB2_LEASE_KEY_SIZE);
+#endif
+	open->oplock = CIFS_OPLOCK_NO_CHANGE;
+	open->tlink = tlink;
+	fid->pending_open = open;
+	list_add_tail(&open->olist, &tlink_tcon(tlink)->pending_opens);
+}
+
+void
+cifs_add_pending_open(struct cifs_fid *fid, struct tcon_link *tlink,
+		      struct cifs_pending_open *open)
+{
+	spin_lock(&cifs_file_list_lock);
+	cifs_add_pending_open_locked(fid, tlink, open);
+	spin_unlock(&cifs_file_list_lock);
+}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 3a7f8bd..cd31715 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -389,6 +389,27 @@ __u8 smb2_map_lease_to_oplock(__le32 lease_state)
 	return 0;
 }
 
+struct smb2_lease_break_work {
+	struct work_struct lease_break;
+	struct tcon_link *tlink;
+	__u8 lease_key[16];
+	__le32 lease_state;
+};
+
+static void
+cifs_ses_oplock_break(struct work_struct *work)
+{
+	struct smb2_lease_break_work *lw = container_of(work,
+				struct smb2_lease_break_work, lease_break);
+	int rc;
+
+	rc = SMB2_lease_break(0, tlink_tcon(lw->tlink), lw->lease_key,
+			      lw->lease_state);
+	cFYI(1, "Lease release rc %d", rc);
+	cifs_put_tlink(lw->tlink);
+	kfree(lw);
+}
+
 static bool
 smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 {
@@ -398,6 +419,19 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
+	struct cifs_pending_open *open;
+	struct smb2_lease_break_work *lw;
+	bool found;
+	int ack_req = rsp->Flags & SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED;
+
+	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
+	if (!lw) {
+		cERROR(1, "Memory allocation failed during lease break check");
+		return false;
+	}
+
+	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
+	lw->lease_state = rsp->NewLeaseState;
 
 	cFYI(1, "Checking for lease break");
 
@@ -405,28 +439,29 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+
+		spin_lock(&cifs_file_list_lock);
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 
 			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
-			spin_lock(&cifs_file_list_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				cfile = list_entry(tmp2, struct cifsFileInfo,
-						     tlist);
+						   tlist);
 				cinode = CIFS_I(cfile->dentry->d_inode);
 
 				if (memcmp(cinode->lease_key, rsp->LeaseKey,
 					   SMB2_LEASE_KEY_SIZE))
 					continue;
 
+				cFYI(1, "found in the open list");
 				cFYI(1, "lease key match, lease break 0x%d",
 				     le32_to_cpu(rsp->NewLeaseState));
 
 				smb2_set_oplock_level(cinode,
 				  smb2_map_lease_to_oplock(rsp->NewLeaseState));
 
-				if (rsp->Flags &
-				    SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED)
+				if (ack_req)
 					cfile->oplock_break_cancelled = false;
 				else
 					cfile->oplock_break_cancelled = true;
@@ -437,10 +472,39 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 				spin_unlock(&cifs_tcp_ses_lock);
 				return true;
 			}
-			spin_unlock(&cifs_file_list_lock);
+
+			found = false;
+			list_for_each_entry(open, &tcon->pending_opens, olist) {
+				if (memcmp(open->lease_key, rsp->LeaseKey,
+					   SMB2_LEASE_KEY_SIZE))
+					continue;
+
+				if (!found && ack_req) {
+					found = true;
+					memcpy(lw->lease_key, open->lease_key,
+					       SMB2_LEASE_KEY_SIZE);
+					lw->tlink = cifs_get_tlink(open->tlink);
+					queue_work(cifsiod_wq,
+						   &lw->lease_break);
+				}
+
+				cFYI(1, "found in the pending open list");
+				cFYI(1, "lease key match, lease break 0x%d",
+				     le32_to_cpu(rsp->NewLeaseState));
+
+				open->oplock =
+				  smb2_map_lease_to_oplock(rsp->NewLeaseState);
+			}
+			if (found) {
+				spin_unlock(&cifs_file_list_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				return true;
+			}
 		}
+		spin_unlock(&cifs_file_list_lock);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
+	kfree(lw);
 	cFYI(1, "Can not process lease break - no lease matched");
 	return false;
 }
-- 
1.7.1
