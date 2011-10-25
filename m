From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 45/53] CIFS: Process oplock/lease break for SMB2/2.1
Date: Tue, 25 Oct 2011 10:12:18 +0400
Message-ID: <1319523146-2859-46-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +
 fs/cifs/cifsproto.h |    4 +-
 fs/cifs/connect.c   |    2 +-
 fs/cifs/file.c      |   24 +++++--
 fs/cifs/misc.c      |   11 ++-
 fs/cifs/smb2file.c  |   39 ++++++------
 fs/cifs/smb2misc.c  |  180 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c   |   90 ++++++++++++++++++++------
 fs/cifs/smb2pdu.h   |   35 ++++++++++
 fs/cifs/smb2proto.h |   14 +++-
 10 files changed, 348 insertions(+), 54 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3d950d9..56962a5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -697,6 +697,9 @@ struct cifsInodeInfo {
 #endif
 };
 
+typedef int (oplock_callback_t)(struct cifs_tcon *, struct cifsInodeInfo *,
+				struct cifsFileInfo *);
+
 static inline struct cifsInodeInfo *
 CIFS_I(struct inode *inode)
 {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2df7074..7622707 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -94,7 +94,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
-extern bool is_valid_oplock_break(struct smb_hdr *smb,
+extern bool is_valid_oplock_break(char *buffer,
 				  struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
@@ -132,6 +132,8 @@ extern struct cifsFileInfo *cifs_new_fileinfo(__u16 netfid, struct file *file,
 					      __u32 oplock);
 extern struct cifsFileInfo *cifs_new_fileinfo_generic(struct file *file,
 						      struct tcon_link *tlink);
+extern void cifs_oplock_break_generic(struct work_struct *work,
+				      oplock_callback_t *oplock_cb);
 extern int cifs_posix_open(const char *full_path, struct inode **pinode,
 			   struct super_block *sb, int mode,
 			   unsigned int f_flags, __u32 *poplock, __u16 *pnetfid,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0e188b9..03081f6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -962,7 +962,7 @@ cifs_demultiplex_thread(void *p)
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!is_valid_oplock_break((void *)buf, server)) {
+		} else if (!is_valid_oplock_break(buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf, buf_size);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 09655f7..a43856a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -257,6 +257,7 @@ cifs_new_fileinfo(__u16 netfid, struct file *file,
 	cifs_file->netfid = netfid;
 	cifs_set_oplock_level(cinode, oplock);
 	cinode->can_cache_brlcks = cinode->clientCanCacheAll;
+	INIT_WORK(&cifs_file->oplock_break, cifs_oplock_break);
 	return cifs_file;
 }
 
@@ -280,7 +281,6 @@ cifs_new_fileinfo_generic(struct file *file, struct tcon_link *tlink)
 	pCifsFile->invalidHandle = false;
 	pCifsFile->tlink = cifs_get_tlink(tlink);
 	mutex_init(&pCifsFile->fh_mutex);
-	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	spin_lock(&cifs_file_list_lock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
@@ -3088,7 +3088,8 @@ int cifs_launder_page(struct page *page)
 	return rc;
 }
 
-void cifs_oplock_break(struct work_struct *work)
+void cifs_oplock_break_generic(struct work_struct *work,
+			       oplock_callback_t *oplock_cb)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
@@ -3121,14 +3122,25 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!cfile->oplock_break_cancelled) {
-		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid,
-				 current->tgid, 0, 0, 0, 0,
-				 LOCKING_ANDX_OPLOCK_RELEASE, false,
-				 cinode->clientCanCacheRead ? 1 : 0);
+		rc = oplock_cb(tlink_tcon(cfile->tlink), cinode, cfile);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
 }
 
+static int
+cifs_oplock_cb(struct cifs_tcon *tcon, struct cifsInodeInfo *cinode,
+	       struct cifsFileInfo *cfile)
+{
+	return CIFSSMBLock(0, tcon, cfile->netfid, current->tgid, 0, 0, 0, 0,
+			   LOCKING_ANDX_OPLOCK_RELEASE, false,
+			   cinode->clientCanCacheRead ? 1 : 0);
+}
+
+void cifs_oplock_break(struct work_struct *work)
+{
+	cifs_oplock_break_generic(work, cifs_oplock_cb);
+}
+
 const struct address_space_operations cifs_addr_ops = {
 	.readpage = cifs_readpage,
 	.readpages = cifs_readpages,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d291463..88bede1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -29,6 +29,9 @@
 #include "smberr.h"
 #include "nterr.h"
 #include "cifs_unicode.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -505,8 +508,9 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int total_read)
 }
 
 bool
-is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
+is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 {
+	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
 	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
@@ -516,7 +520,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 
 #ifdef CONFIG_CIFS_SMB2
 	if (srv->is_smb2)
-		return false;
+		return smb2_is_valid_oplock_break(buffer, srv);
 #endif
 
 	cFYI(1, "Checking for oplock break or dnotify response");
@@ -592,9 +596,10 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 
 				cifs_set_oplock_level(pCifsInode,
 					pSMB->OplockLevel ? OPLOCK_READ : 0);
+				netfile->oplock_break_cancelled = false;
+
 				queue_work(system_nrt_wq,
 					   &netfile->oplock_break);
-				netfile->oplock_break_cancelled = false;
 
 				spin_unlock(&cifs_file_list_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index bd1f6fc..ba67306 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -178,25 +178,6 @@ const struct address_space_operations smb2_addr_ops_smallbuf = {
 	.launder_page = cifs_launder_page,
 };
 
-static void
-smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u8 oplock)
-{
-	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		cinode->clientCanCacheAll = true;
-		cinode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock granted on inode %p",
-		     &cinode->vfs_inode);
-	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = true;
-		cFYI(1, "Level II Oplock granted on inode %p",
-		    &cinode->vfs_inode);
-	} else {
-		cinode->clientCanCacheAll = false;
-		cinode->clientCanCacheRead = false;
-	}
-}
-
 struct cifsFileInfo *
 smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
 		  struct tcon_link *tlink, __u8 oplock)
@@ -209,6 +190,7 @@ smb2_new_fileinfo(__u64 persist_fid, __u64 volatile_fid, struct file *file,
 	cifs_file->persist_fid = persist_fid;
 	cifs_file->volatile_fid = volatile_fid;
 	smb2_set_oplock_level(CIFS_I(file->f_path.dentry->d_inode), oplock);
+	INIT_WORK(&cifs_file->oplock_break, smb2_oplock_break);
 	return cifs_file;
 }
 
@@ -514,3 +496,22 @@ int smb2_strict_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return cifs_strict_fsync_generic(file, start, end, datasync,
 					 smb2_fsync_cb);
 }
+
+static int
+smb2_oplock_cb(struct cifs_tcon *tcon, struct cifsInodeInfo *cinode,
+	       struct cifsFileInfo *cfile)
+{
+	if (tcon->ses->server->smb2_dialect_revision == cpu_to_le16(0x0210))
+		return SMB2_lease_break(0, tlink_tcon(cfile->tlink),
+					cinode->lease_key,
+					smb2_get_lease_state(cinode));
+
+	return SMB2_oplock_break(0, tlink_tcon(cfile->tlink),
+				 cfile->persist_fid, cfile->volatile_fid,
+				 cinode->clientCanCacheRead ? 1 : 0);
+}
+
+void smb2_oplock_break(struct work_struct *work)
+{
+	cifs_oplock_break_generic(work, smb2_oplock_cb);
+}
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6f7afdc..e24e954 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -151,12 +151,19 @@ checkSMB2(struct smb2_hdr *smb, __u64 mid, unsigned int length)
 
 	if (smb2_rsp_struct_sizes[command] !=
 	    le16_to_cpu(smb2->StructureSize2)) {
-		if ((smb->Status == 0) ||
-		    (le16_to_cpu(smb2->StructureSize2) != 9)) {
+		if (command != SMB2_OPLOCK_BREAK && ((smb->Status == 0) ||
+		    (le16_to_cpu(smb2->StructureSize2) != 9))) {
 			/* error packets have 9 byte structure size */
 			cERROR(1, "Illegal response size %d for command %d",
 				   le16_to_cpu(smb2->StructureSize2), command);
 			return 1;
+		} else if (command == SMB2_OPLOCK_BREAK && (smb->Status == 0)
+			   && (le16_to_cpu(smb2->StructureSize2) != 44)
+			   && (le16_to_cpu(smb2->StructureSize2) != 36)) {
+			/* special case for SMB2.1 lease break message */
+			cERROR(1, "Illegal response size %d for oplock break",
+				   le16_to_cpu(smb2->StructureSize2));
+			return 1;
 		}
 	}
 
@@ -171,6 +178,8 @@ checkSMB2(struct smb2_hdr *smb, __u64 mid, unsigned int length)
 	if (4 + len != clc_len) {
 		cFYI(1, "Calculated size %d length %d mismatch for mid %lld",
 			 clc_len, 4 + len, smb->MessageId);
+		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK)
+			return 0; /* Windows 7 server returns 24 bytes more */
 		if (clc_len == 4 + len + 1) /* BB FIXME (fix samba) */
 			return 0; /* BB workaround Samba 3 bug SessSetup rsp */
 		return 1;
@@ -345,3 +354,170 @@ calc_size_exit:
 	cFYI(1, "smb2 len %d", len);
 	return len;
 }
+
+__le32
+smb2_get_lease_state(struct cifsInodeInfo *cinode)
+{
+	if (cinode->clientCanCacheAll)
+		return cpu_to_le32(SMB2_LEASE_WRITE_CACHING);
+	else if (cinode->clientCanCacheRead)
+		return cpu_to_le32(SMB2_LEASE_READ_CACHING);
+	return 0;
+}
+
+void
+smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u8 oplock)
+{
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		cinode->clientCanCacheAll = true;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+		     &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock granted on inode %p",
+		    &cinode->vfs_inode);
+	} else {
+		cinode->clientCanCacheAll = false;
+		cinode->clientCanCacheRead = false;
+	}
+}
+
+__u8 smb2_map_lease_to_oplock(__le32 lease_state)
+{
+	if (lease_state & SMB2_LEASE_WRITE_CACHING) {
+		if (lease_state & SMB2_LEASE_HANDLE_CACHING)
+			return SMB2_OPLOCK_LEVEL_BATCH;
+		else
+			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (lease_state & SMB2_LEASE_READ_CACHING)
+		return SMB2_OPLOCK_LEVEL_II;
+	return 0;
+}
+
+static bool
+smb2_is_valid_lease_break(struct smb2_hdr *buf, struct TCP_Server_Info *srv)
+{
+	struct lease_break *pSMB = (struct lease_break *)buf;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+	struct cifsFileInfo *cfile;
+
+	cFYI(1, "Checking for lease break");
+
+	/* look up tcon based on tid & uid */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(tmp, &srv->smb_ses_list) {
+		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		list_for_each(tmp1, &ses->tcon_list) {
+			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+
+			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
+			spin_lock(&cifs_file_list_lock);
+			list_for_each(tmp2, &tcon->openFileList) {
+				cfile = list_entry(tmp2, struct cifsFileInfo,
+						     tlist);
+				cinode = CIFS_I(cfile->dentry->d_inode);
+
+				if (memcmp(cinode->lease_key, pSMB->LeaseKey,
+					   16))
+					continue;
+
+				cFYI(1, "lease key match, lease break 0x%d",
+				     le32_to_cpu(pSMB->NewLeaseState));
+
+				smb2_set_oplock_level(cinode,
+				 smb2_map_lease_to_oplock(pSMB->NewLeaseState));
+
+				if (pSMB->Flags &
+				    SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED)
+					cfile->oplock_break_cancelled = false;
+				else
+					cfile->oplock_break_cancelled = true;
+
+				queue_work(system_nrt_wq,
+					   &cfile->oplock_break);
+
+				spin_unlock(&cifs_file_list_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				return true;
+			}
+			spin_unlock(&cifs_file_list_lock);
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	cFYI(1, "Can not process oplock break for non-existent connection");
+	return false;
+}
+
+bool
+smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
+{
+	struct smb2_hdr *buf = (struct smb2_hdr *)buffer;
+	struct oplock_break *pSMB = (struct oplock_break *)buf;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+	struct cifsFileInfo *cfile;
+
+	cFYI(1, "Checking for oplock break");
+
+	if (pSMB->hdr.Command != SMB2_OPLOCK_BREAK)
+		return false;
+
+	if (le16_to_cpu(pSMB->StructureSize) !=
+				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK]) {
+		if (le16_to_cpu(pSMB->StructureSize) == 44)
+			return smb2_is_valid_lease_break(buf, srv);
+		else
+			return false;
+	}
+
+	cFYI(1, "oplock level 0x%d", pSMB->OplockLevel);
+
+	/* look up tcon based on tid & uid */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(tmp, &srv->smb_ses_list) {
+		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		list_for_each(tmp1, &ses->tcon_list) {
+			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+
+			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
+			spin_lock(&cifs_file_list_lock);
+			list_for_each(tmp2, &tcon->openFileList) {
+				cfile = list_entry(tmp2, struct cifsFileInfo,
+						     tlist);
+				if (pSMB->PersistentFid != cfile->persist_fid)
+					continue;
+
+				if (pSMB->VolatileFid != cfile->volatile_fid)
+					continue;
+
+				cFYI(1, "file id match, oplock break");
+				cinode = CIFS_I(cfile->dentry->d_inode);
+
+				smb2_set_oplock_level(cinode,
+				  pSMB->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0);
+				cfile->oplock_break_cancelled = false;
+
+				queue_work(system_nrt_wq,
+					   &cfile->oplock_break);
+
+				spin_unlock(&cifs_file_list_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				return true;
+			}
+			spin_unlock(&cifs_file_list_lock);
+			spin_unlock(&cifs_tcp_ses_lock);
+			cFYI(1, "No matching file for oplock break");
+			return true;
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	cFYI(1, "Can not process oplock break for non-existent connection");
+	return false;
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d9a0244..c9db5e8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1088,7 +1088,6 @@ parse_lease_state(struct create_rsp *smb)
 {
 	char *data_offset;
 	struct create_lease *lc;
-	__u8 oplock = 0;
 	bool found = false;
 
 	data_offset = (char *)smb;
@@ -1111,19 +1110,9 @@ parse_lease_state(struct create_rsp *smb)
 	} while (le32_to_cpu(lc->ccontext.Next) != 0);
 
 	if (!found)
-		return oplock;
-
-	if (le32_to_cpu(lc->lcontext.LeaseState) & SMB2_LEASE_WRITE_CACHING) {
-		if (le32_to_cpu(lc->lcontext.LeaseState) &
-						SMB2_LEASE_HANDLE_CACHING)
-			oplock = SMB2_OPLOCK_LEVEL_BATCH;
-		else
-			oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (le32_to_cpu(lc->lcontext.LeaseState) &
-						SMB2_LEASE_READ_CACHING)
-		oplock = SMB2_OPLOCK_LEVEL_II;
+		return 0;
 
-	return oplock;
+	return smb2_map_lease_to_oplock(lc->lcontext.LeaseState);
 }
 
 int SMB2_open(const int xid, struct cifs_tcon *tcon, __le16 *path,
@@ -1900,12 +1889,6 @@ qfsdev_exit:
 	return rc;
 }
 
-int SMB2_oplock_break(struct cifs_tcon *ptcon, __u64 netfid)
-{
-	/* BB FIXME BB */
-	return -EOPNOTSUPP;
-}
-
 int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 		    u64 persistent_fid, u64 volatile_fid,
 		    FILE_ALL_INFO_SMB2 *pdata)
@@ -2783,3 +2766,72 @@ int SMB2_lock(const int xid, struct cifs_tcon *tcon,
 	 */
 	return rc;
 }
+
+int
+SMB2_oplock_break(const int xid, struct cifs_tcon *tcon,
+		 const u64 persistent_fid, const u64 volatile_fid,
+		 __u8 oplock_level)
+{
+	int rc = 0, buf_type, status;
+	struct oplock_break *pSMB2 = NULL;
+	struct kvec iov[1];
+
+	cFYI(1, "SMB2_oplock_break");
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &pSMB2);
+
+	if (rc)
+		return rc;
+
+	pSMB2->VolatileFid = volatile_fid;
+	pSMB2->PersistentFid = persistent_fid;
+	pSMB2->OplockLevel = oplock_level;
+
+	iov->iov_base = (char *)pSMB2;
+	iov->iov_len = get_rfc1002_length(pSMB2) + 4;
+
+	rc = smb2_sendrcv2(xid, tcon->ses, iov, 1, &buf_type, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	/* SMB2 buffer freed by function above */
+
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2OPLOCK_BREAK);
+		cFYI(1, "Send error in Oplock Break = %d", rc);
+	}
+
+	return rc;
+}
+
+int
+SMB2_lease_break(const int xid, struct cifs_tcon *tcon, __u8 *lease_key,
+		 const __le32 lease_state)
+{
+	int rc = 0, buf_type, status;
+	struct lease_ack *pSMB2 = NULL;
+	struct kvec iov[1];
+
+	cFYI(1, "SMB2_lease_break");
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &pSMB2);
+
+	if (rc)
+		return rc;
+
+	pSMB2->StructureSize = cpu_to_le16(36);
+	inc_rfc1001_len(&pSMB2->hdr, 12);
+
+	memcpy(pSMB2->LeaseKey, lease_key, 16);
+	pSMB2->LeaseState = lease_state;
+
+	iov->iov_base = (char *)pSMB2;
+	iov->iov_len = get_rfc1002_length(pSMB2) + 4;
+
+	rc = smb2_sendrcv2(xid, tcon->ses, iov, 1, &buf_type, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	/* SMB2 buffer freed by function above */
+
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2OPLOCK_BREAK);
+		cFYI(1, "Send error in Oplock Break = %d", rc);
+	}
+
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 1bc59ba..8dceea0 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -740,6 +740,41 @@ struct ioctl_rsp {
 	__u8   Buffer[1];
 }  __attribute__((packed));
 
+struct oplock_break {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 24 */
+	__u8 OplockLevel;
+	__u8 Reserved;
+	__le32 Reserved2;
+	__u64 PersistentFid;
+	__u64 VolatileFid;
+}  __attribute__((packed));
+
+#define SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED cpu_to_le32(0x01)
+
+struct lease_break {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 44 */
+	__le16 Reserved;
+	__le32 Flags;
+	__u8 LeaseKey[16];
+	__le32 CurrentLeaseState;
+	__le32 NewLeaseState;
+	__le32 BreakReason;
+	__le32 AccessMaskHint;
+	__le32 ShareMaskHint;
+}  __attribute__((packed));
+
+struct lease_ack {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 36 */
+	__le16 Reserved;
+	__le32 Flags;
+	__u8 LeaseKey[16];
+	__le32 LeaseState;
+	__le64 LeaseDuration;
+}  __attribute__((packed));
+
 /*****************************************************************
  * All constants go here
  *****************************************************************
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 1f8dc9a..0bff335 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -200,7 +200,6 @@ extern int SMB2_QFS_attribute_info(const int xid, struct cifs_tcon *tcon,
 				   u64 persistent_fid, u64 volatile_fid);
 extern int SMB2_QFS_device_info(const int xid, struct cifs_tcon *tcon,
 				u64 persistent_fid, u64 volatile_fid);
-extern int SMB2_oplock_break(struct cifs_tcon *ptcon, __u64 netfid);
 extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   FILE_ALL_INFO_SMB2 *pFindData);
@@ -252,6 +251,11 @@ extern int SMB2_set_ea_info(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_lock(const int xid, struct cifs_tcon *tcon,
 		     const u64 persistent_fid, const u64 volatile_fid,
 		     u64 length, u64 offset, u32 lockFlags, int wait);
+extern int SMB2_oplock_break(const int xid, struct cifs_tcon *tcon,
+			     const u64 persistent_fid, const u64 volatile_fid,
+			     const __u8 oplock_level);
+extern int SMB2_lease_break(const int xid, struct cifs_tcon *tcon,
+			    __u8 *lease_key, const __le32 lease_state);
 extern void DeleteMidQEntryComplex(struct mid_q_entry *midEntry);
 extern int new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
 			unsigned int remaining_bytes, int request_type);
@@ -262,7 +266,11 @@ extern int smb2_wait_on_complex_mid(struct cifs_ses *ses,
 				    unsigned long timeout,
 				    unsigned long time_to_wait);
 extern int smb2_readresp(struct TCP_Server_Info *server, bool cleanup);
-/* extern void smb2_oplock_break(struct work_struct *);
-extern bool is_smb2_oplock_break(struct smb2_hdr *, struct TCP_Server_Info *);*/
+extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
+extern __u8 smb2_map_lease_to_oplock(__le32 lease_state);
+extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u8 oplock);
+extern bool smb2_is_valid_oplock_break(char *buffer,
+				       struct TCP_Server_Info *srv);
+extern void smb2_oplock_break(struct work_struct *work);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
