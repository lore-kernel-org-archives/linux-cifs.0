From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/8] CIFS: Store lease state itself rather than a mapped oplock value
Date: Fri,  6 Sep 2013 00:14:59 +0400
Message-ID: <1378412103-29047-5-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and separate smb20_operations struct.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   16 +++---
 fs/cifs/connect.c   |    2 +-
 fs/cifs/file.c      |    3 +-
 fs/cifs/smb1ops.c   |    8 ++-
 fs/cifs/smb2file.c  |   23 --------
 fs/cifs/smb2misc.c  |   30 ++++-------
 fs/cifs/smb2ops.c   |  146 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.c   |    2 +-
 fs/cifs/smb2pdu.h   |    4 ++
 fs/cifs/smb2proto.h |    2 -
 10 files changed, 173 insertions(+), 63 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 30f91e1..6eef2e1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -370,12 +370,12 @@ struct smb_version_operations {
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
 	/* The next two functions will need to be changed to per smb session */
-	void (*generate_signingkey)(struct TCP_Server_Info *server);
-	int (*calc_signature)(struct smb_rqst *rqst,
-				   struct TCP_Server_Info *server);
-	int (*query_mf_symlink)(const unsigned char *path, char *pbuf,
-			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
-			unsigned int xid);
+	void (*generate_signingkey)(struct TCP_Server_Info *);
+	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *);
+	int (*query_mf_symlink)(const unsigned char *, char *, unsigned int *,
+				struct cifs_sb_info *, unsigned int);
+	bool (*is_read_op)(__u32);
+	void (*set_oplock_level)(struct cifsInodeInfo *, __u32);
 };
 
 struct smb_version_values {
@@ -393,7 +393,6 @@ struct smb_version_values {
 	unsigned int	cap_unix;
 	unsigned int	cap_nt_find;
 	unsigned int	cap_large_files;
-	unsigned int	oplock_read;
 	__u16		signing_enabled;
 	__u16		signing_required;
 };
@@ -1040,6 +1039,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_WRITE_FLG	4
 
 #define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
+#define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
 #define CIFS_CACHE_WRITE(cinode) (cinode->oplock & CIFS_CACHE_WRITE_FLG)
 
 /*
@@ -1511,7 +1511,7 @@ extern mempool_t *cifs_mid_poolp;
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
 #define SMB20_VERSION_STRING	"2.0"
-/*extern struct smb_version_operations smb20_operations; */ /* not needed yet */
+extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
 #define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d67c550..d14bb74 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1114,7 +1114,7 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		break;
 #ifdef CONFIG_CIFS_SMB2
 	case Smb_20:
-		vol->ops = &smb21_operations; /* currently identical with 2.1 */
+		vol->ops = &smb20_operations;
 		vol->vals = &smb20_values;
 		break;
 	case Smb_21:
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d933539..9546821 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -313,8 +313,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	 * If the server returned a read oplock and we have mandatory brlocks,
 	 * set oplock level to None.
 	 */
-	if (oplock == server->vals->oplock_read &&
-						cifs_has_mand_locks(cinode)) {
+	if (server->ops->is_read_op(oplock) && cifs_has_mand_locks(cinode)) {
 		cifs_dbg(FYI, "Reset oplock val from read to None due to mand locks\n");
 		oplock = 0;
 	}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 6fd0677..8233b17 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -912,6 +912,12 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static bool
+cifs_is_read_op(__u32 oplock)
+{
+	return oplock == OPLOCK_READ;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -977,6 +983,7 @@ struct smb_version_operations smb1_operations = {
 	.mand_unlock_range = cifs_unlock_range,
 	.push_mand_locks = cifs_push_mandatory_locks,
 	.query_mf_symlink = open_query_close_cifs_symlink,
+	.is_read_op = cifs_is_read_op,
 };
 
 struct smb_version_values smb1_values = {
@@ -992,7 +999,6 @@ struct smb_version_values smb1_values = {
 	.cap_unix = CAP_UNIX,
 	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
 	.cap_large_files = CAP_LARGE_FILES,
-	.oplock_read = OPLOCK_READ,
 	.signing_enabled = SECMODE_SIGN_ENABLED,
 	.signing_required = SECMODE_SIGN_REQUIRED,
 };
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 4564787..3f17b45 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -34,29 +34,6 @@
 #include "fscache.h"
 #include "smb2proto.h"
 
-void
-smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
-{
-	oplock &= 0xFF;
-	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
-		return;
-	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG |
-				 CIFS_CACHE_HANDLE_FLG;
-		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
-	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG;
-		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
-	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
-		cinode->oplock = CIFS_CACHE_READ_FLG;
-		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
-			 &cinode->vfs_inode);
-	} else
-		cinode->oplock = 0;
-}
-
 int
 smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	       __u32 *oplock, FILE_ALL_INFO *buf)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 8d1a889..4aa59b3 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -380,23 +380,15 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 __le32
 smb2_get_lease_state(struct cifsInodeInfo *cinode)
 {
-	if (CIFS_CACHE_WRITE(cinode))
-		return SMB2_LEASE_WRITE_CACHING | SMB2_LEASE_READ_CACHING;
-	else if (CIFS_CACHE_READ(cinode))
-		return SMB2_LEASE_READ_CACHING;
-	return 0;
-}
+	__le32 lease = 0;
 
-__u8 smb2_map_lease_to_oplock(__le32 lease_state)
-{
-	if (lease_state & SMB2_LEASE_WRITE_CACHING) {
-		if (lease_state & SMB2_LEASE_HANDLE_CACHING)
-			return SMB2_OPLOCK_LEVEL_BATCH;
-		else
-			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (lease_state & SMB2_LEASE_READ_CACHING)
-		return SMB2_OPLOCK_LEVEL_II;
-	return 0;
+	if (CIFS_CACHE_WRITE(cinode))
+		lease |= SMB2_LEASE_WRITE_CACHING;
+	if (CIFS_CACHE_HANDLE(cinode))
+		lease |= SMB2_LEASE_HANDLE_CACHING;
+	if (CIFS_CACHE_READ(cinode))
+		lease |= SMB2_LEASE_READ_CACHING;
+	return lease;
 }
 
 struct smb2_lease_break_work {
@@ -433,7 +425,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
 
-	lease_state = smb2_map_lease_to_oplock(rsp->NewLeaseState);
+	lease_state = le32_to_cpu(rsp->NewLeaseState);
 
 	list_for_each(tmp, &tcon->openFileList) {
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
@@ -447,7 +439,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
-		smb2_set_oplock_level(cinode, lease_state);
+		tcon->ses->server->ops->set_oplock_level(cinode, lease_state);
 
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
@@ -582,7 +574,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				else
 					cfile->oplock_break_cancelled = false;
 
-				smb2_set_oplock_level(cinode,
+				server->ops->set_oplock_level(cinode,
 				  rsp->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0);
 
 				queue_work(cifsiod_wq, &cfile->oplock_break);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 96c9d3d..4656656 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -377,9 +377,11 @@ static void
 smb2_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 oplock)
 {
 	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
+	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
+
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
-	smb2_set_oplock_level(cinode, oplock);
+	server->ops->set_oplock_level(cinode, oplock);
 	cinode->can_cache_brlcks = CIFS_CACHE_WRITE(cinode);
 }
 
@@ -648,7 +650,71 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-struct smb_version_operations smb21_operations = {
+static void
+smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
+{
+	oplock &= 0xFF;
+	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
+		return;
+	if (oplock == SMB2_OPLOCK_LEVEL_BATCH) {
+		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG |
+				 CIFS_CACHE_HANDLE_FLG;
+		cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
+		cinode->oplock = CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG;
+		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
+	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
+		cinode->oplock = CIFS_CACHE_READ_FLG;
+		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
+	} else
+		cinode->oplock = 0;
+}
+
+static void
+smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
+{
+	char message[5] = {0};
+
+	oplock &= 0xFF;
+	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
+		return;
+
+	cinode->oplock = 0;
+	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
+		cinode->oplock |= CIFS_CACHE_READ_FLG;
+		strcat(message, "R");
+	}
+	if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
+		cinode->oplock |= CIFS_CACHE_HANDLE_FLG;
+		strcat(message, "H");
+	}
+	if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
+		cinode->oplock |= CIFS_CACHE_WRITE_FLG;
+		strcat(message, "W");
+	}
+	if (!cinode->oplock)
+		strcat(message, "None");
+	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
+		 &cinode->vfs_inode);
+}
+
+static bool
+smb2_is_read_op(__u32 oplock)
+{
+	return oplock == SMB2_OPLOCK_LEVEL_II;
+}
+
+static bool
+smb21_is_read_op(__u32 oplock)
+{
+	return (oplock & SMB2_LEASE_READ_CACHING_HE) &&
+	       !(oplock & SMB2_LEASE_WRITE_CACHING_HE);
+}
+
+struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -713,8 +779,78 @@ struct smb_version_operations smb21_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.calc_signature = smb2_calc_signature,
+	.is_read_op = smb2_is_read_op,
+	.set_oplock_level = smb2_set_oplock_level,
 };
 
+struct smb_version_operations smb21_operations = {
+	.compare_fids = smb2_compare_fids,
+	.setup_request = smb2_setup_request,
+	.setup_async_request = smb2_setup_async_request,
+	.check_receive = smb2_check_receive,
+	.add_credits = smb2_add_credits,
+	.set_credits = smb2_set_credits,
+	.get_credits_field = smb2_get_credits_field,
+	.get_credits = smb2_get_credits,
+	.get_next_mid = smb2_get_next_mid,
+	.read_data_offset = smb2_read_data_offset,
+	.read_data_length = smb2_read_data_length,
+	.map_error = map_smb2_to_linux_error,
+	.find_mid = smb2_find_mid,
+	.check_message = smb2_check_message,
+	.dump_detail = smb2_dump_detail,
+	.clear_stats = smb2_clear_stats,
+	.print_stats = smb2_print_stats,
+	.is_oplock_break = smb2_is_valid_oplock_break,
+	.need_neg = smb2_need_neg,
+	.negotiate = smb2_negotiate,
+	.negotiate_wsize = smb2_negotiate_wsize,
+	.negotiate_rsize = smb2_negotiate_rsize,
+	.sess_setup = SMB2_sess_setup,
+	.logoff = SMB2_logoff,
+	.tree_connect = SMB2_tcon,
+	.tree_disconnect = SMB2_tdis,
+	.is_path_accessible = smb2_is_path_accessible,
+	.can_echo = smb2_can_echo,
+	.echo = SMB2_echo,
+	.query_path_info = smb2_query_path_info,
+	.get_srv_inum = smb2_get_srv_inum,
+	.query_file_info = smb2_query_file_info,
+	.set_path_size = smb2_set_path_size,
+	.set_file_size = smb2_set_file_size,
+	.set_file_info = smb2_set_file_info,
+	.mkdir = smb2_mkdir,
+	.mkdir_setinfo = smb2_mkdir_setinfo,
+	.rmdir = smb2_rmdir,
+	.unlink = smb2_unlink,
+	.rename = smb2_rename_path,
+	.create_hardlink = smb2_create_hardlink,
+	.query_symlink = smb2_query_symlink,
+	.open = smb2_open_file,
+	.set_fid = smb2_set_fid,
+	.close = smb2_close_file,
+	.flush = smb2_flush_file,
+	.async_readv = smb2_async_readv,
+	.async_writev = smb2_async_writev,
+	.sync_read = smb2_sync_read,
+	.sync_write = smb2_sync_write,
+	.query_dir_first = smb2_query_dir_first,
+	.query_dir_next = smb2_query_dir_next,
+	.close_dir = smb2_close_dir,
+	.calc_smb_size = smb2_calc_size,
+	.is_status_pending = smb2_is_status_pending,
+	.oplock_response = smb2_oplock_response,
+	.queryfs = smb2_queryfs,
+	.mand_lock = smb2_mand_lock,
+	.mand_unlock_range = smb2_unlock_range,
+	.push_mand_locks = smb2_push_mandatory_locks,
+	.get_lease_key = smb2_get_lease_key,
+	.set_lease_key = smb2_set_lease_key,
+	.new_lease_key = smb2_new_lease_key,
+	.calc_signature = smb2_calc_signature,
+	.is_read_op = smb21_is_read_op,
+	.set_oplock_level = smb21_set_oplock_level,
+};
 
 struct smb_version_operations smb30_operations = {
 	.compare_fids = smb2_compare_fids,
@@ -783,6 +919,8 @@ struct smb_version_operations smb30_operations = {
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb3signingkey,
 	.calc_signature = smb3_calc_signature,
+	.is_read_op = smb21_is_read_op,
+	.set_oplock_level = smb21_set_oplock_level,
 };
 
 struct smb_version_values smb20_values = {
@@ -800,7 +938,6 @@ struct smb_version_values smb20_values = {
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
-	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
@@ -820,7 +957,6 @@ struct smb_version_values smb21_values = {
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
-	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
@@ -840,7 +976,6 @@ struct smb_version_values smb30_values = {
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
-	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
@@ -860,7 +995,6 @@ struct smb_version_values smb302_values = {
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
-	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5a49861..17862fe 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -921,7 +921,7 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 	if (!found)
 		return 0;
 
-	return smb2_map_lease_to_oplock(lc->lcontext.LeaseState);
+	return le32_to_cpu(lc->lcontext.LeaseState);
 }
 
 static int
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 40baeae..a2ec65a 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -476,6 +476,10 @@ struct create_context {
 	__u8 Buffer[0];
 } __packed;
 
+#define SMB2_LEASE_READ_CACHING_HE	0x01
+#define SMB2_LEASE_HANDLE_CACHING_HE	0x02
+#define SMB2_LEASE_WRITE_CACHING_HE	0x04
+
 #define SMB2_LEASE_NONE			__constant_cpu_to_le32(0x00)
 #define SMB2_LEASE_READ_CACHING		__constant_cpu_to_le32(0x01)
 #define SMB2_LEASE_HANDLE_CACHING	__constant_cpu_to_le32(0x02)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 1db89fd..e3fb480 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -53,7 +53,6 @@ extern int smb3_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
-extern __u8 smb2_map_lease_to_oplock(__le32 lease_state);
 extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
 
@@ -87,7 +86,6 @@ extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_open_file(const unsigned int xid,
 			  struct cifs_open_parms *oparms,
 			  __u32 *oplock, FILE_ALL_INFO *buf);
-extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
-- 
1.7.10.4
