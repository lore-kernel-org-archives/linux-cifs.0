From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 8/8] CIFS: Respect epoch value from create lease context v2
Date: Fri,  6 Sep 2013 00:15:03 +0400
Message-ID: <1378412103-29047-9-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that force a client to purge cache pages when a server requests it.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 +
 fs/cifs/cifsglob.h |   11 +++++++++--
 fs/cifs/file.c     |    4 ++++
 fs/cifs/smb2misc.c |    6 ++++--
 fs/cifs/smb2ops.c  |   56 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2pdu.c  |    7 ++++---
 6 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ab88efe..a16b4e5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -255,6 +255,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cifs_inode->server_eof = 0;
 	cifs_inode->uniqueid = 0;
 	cifs_inode->createtime = 0;
+	cifs_inode->epoch = 0;
 #ifdef CONFIG_CIFS_SMB2
 	get_random_bytes(cifs_inode->lease_key, SMB2_LEASE_KEY_SIZE);
 #endif
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 471d8f9..0c27c47 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -375,9 +375,10 @@ struct smb_version_operations {
 	int (*query_mf_symlink)(const unsigned char *, char *, unsigned int *,
 				struct cifs_sb_info *, unsigned int);
 	bool (*is_read_op)(__u32);
-	void (*set_oplock_level)(struct cifsInodeInfo *, __u32);
+	void (*set_oplock_level)(struct cifsInodeInfo *, __u32, unsigned int,
+				 bool *);
 	char * (*create_lease_buf)(u8 *, u8);
-	__u8 (*parse_lease_buf)(void *);
+	__u8 (*parse_lease_buf)(void *, unsigned int *);
 };
 
 struct smb_version_values {
@@ -940,6 +941,8 @@ struct cifs_fid {
 	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
 #endif
 	struct cifs_pending_open *pending_open;
+	unsigned int epoch;
+	bool purge_cache;
 };
 
 struct cifs_fid_locks {
@@ -1039,7 +1042,10 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 #define CIFS_CACHE_READ_FLG	1
 #define CIFS_CACHE_HANDLE_FLG	2
+#define CIFS_CACHE_RH_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_HANDLE_FLG)
 #define CIFS_CACHE_WRITE_FLG	4
+#define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
+#define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
 
 #define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
@@ -1057,6 +1063,7 @@ struct cifsInodeInfo {
 	struct list_head openFileList;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
+	unsigned int epoch;
 	bool delete_pending;		/* DELETE_ON_CLOSE is set */
 	bool invalid_mapping;		/* pagecache is invalid */
 	unsigned long time;		/* jiffies of last update of inode */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9546821..503e7e8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -323,6 +323,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		oplock = fid->pending_open->oplock;
 	list_del(&fid->pending_open->olist);
 
+	fid->purge_cache = false;
 	server->ops->set_fid(cfile, fid, oplock);
 
 	list_add(&cfile->tlist, &tcon->openFileList);
@@ -333,6 +334,9 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		list_add_tail(&cfile->flist, &cinode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
+	if (fid->purge_cache)
+		cifs_invalidate_mapping(inode);
+
 	file->private_data = cfile;
 	return cfile;
 }
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 4aa59b3..fb39662 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -420,6 +420,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
@@ -439,7 +440,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
-		tcon->ses->server->ops->set_oplock_level(cinode, lease_state);
+		server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
 
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
@@ -575,7 +576,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 					cfile->oplock_break_cancelled = false;
 
 				server->ops->set_oplock_level(cinode,
-				  rsp->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0);
+				  rsp->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0,
+				  0, NULL);
 
 				queue_work(cifsiod_wq, &cfile->oplock_break);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a9256bd..4c2a627 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -381,7 +381,8 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
-	server->ops->set_oplock_level(cinode, oplock);
+	server->ops->set_oplock_level(cinode, oplock, fid->epoch,
+				      &fid->purge_cache);
 	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
 }
 
@@ -651,18 +652,18 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static void
-smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
+smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
 {
 	oplock &= 0xFF;
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG |
-				 CIFS_CACHE_HANDLE_FLG;
+		cinode->oplock = CIFS_CACHE_RHW_FLG;
 		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG;
+		cinode->oplock = CIFS_CACHE_RW_FLG;
 		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
 			 &cinode->vfs_inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
@@ -674,7 +675,8 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 }
 
 static void
-smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
+smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
+		       unsigned int epoch, bool *purge_cache)
 {
 	char message[5] = {0};
 
@@ -701,6 +703,41 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 		 &cinode->vfs_inode);
 }
 
+static void
+smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
+		      unsigned int epoch, bool *purge_cache)
+{
+	unsigned int old_oplock = cinode->oplock;
+
+	smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
+
+	if (purge_cache) {
+		*purge_cache = false;
+		if (old_oplock == CIFS_CACHE_READ_FLG) {
+			if (cinode->oplock == CIFS_CACHE_READ_FLG &&
+			    (epoch - cinode->epoch > 0))
+				*purge_cache = true;
+			else if (cinode->oplock == CIFS_CACHE_RH_FLG &&
+				 (epoch - cinode->epoch > 1))
+				*purge_cache = true;
+			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
+				 (epoch - cinode->epoch > 1))
+				*purge_cache = true;
+			else if (cinode->oplock == 0 &&
+				 (epoch - cinode->epoch > 0))
+				*purge_cache = true;
+		} else if (old_oplock == CIFS_CACHE_RH_FLG) {
+			if (cinode->oplock == CIFS_CACHE_RH_FLG &&
+			    (epoch - cinode->epoch > 0))
+				*purge_cache = true;
+			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
+				 (epoch - cinode->epoch > 1))
+				*purge_cache = true;
+		}
+		cinode->epoch = epoch;
+	}
+}
+
 static bool
 smb2_is_read_op(__u32 oplock)
 {
@@ -780,7 +817,7 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
 }
 
 static __u8
-smb2_parse_lease_buf(void *buf)
+smb2_parse_lease_buf(void *buf, unsigned int *epoch)
 {
 	struct create_lease *lc = (struct create_lease *)buf;
 
@@ -790,10 +827,11 @@ smb2_parse_lease_buf(void *buf)
 }
 
 static __u8
-smb3_parse_lease_buf(void *buf)
+smb3_parse_lease_buf(void *buf, unsigned int *epoch)
 {
 	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
 
+	*epoch = le32_to_cpu(lc->lcontext.Epoch);
 	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
 		return SMB2_OPLOCK_LEVEL_NOCHANGE;
 	return le32_to_cpu(lc->lcontext.LeaseState);
@@ -1009,7 +1047,7 @@ struct smb_version_operations smb30_operations = {
 	.generate_signingkey = generate_smb3signingkey,
 	.calc_signature = smb3_calc_signature,
 	.is_read_op = smb21_is_read_op,
-	.set_oplock_level = smb21_set_oplock_level,
+	.set_oplock_level = smb3_set_oplock_level,
 	.create_lease_buf = smb3_create_lease_buf,
 	.parse_lease_buf = smb3_parse_lease_buf,
 };
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 603d311..3f45090 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -861,7 +861,8 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 }
 
 static __u8
-parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp)
+parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp,
+		  unsigned int *epoch)
 {
 	char *data_offset;
 	struct create_context *cc;
@@ -878,7 +879,7 @@ parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp)
 			next = le32_to_cpu(cc->Next);
 			continue;
 		}
-		return server->ops->parse_lease_buf(cc);
+		return server->ops->parse_lease_buf(cc, epoch);
 	} while (next != 0);
 
 	return 0;
@@ -1063,7 +1064,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	}
 
 	if (rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
-		*oplock = parse_lease_state(server, rsp);
+		*oplock = parse_lease_state(server, rsp, &oparms->fid->epoch);
 	else
 		*oplock = rsp->OplockLevel;
 creat_exit:
-- 
1.7.10.4
