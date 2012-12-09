From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] Do not send SMB2 signatures for SMB3 frames
Date: Sat, 8 Dec 2012 22:40:40 -0600
Message-ID: <CAH2r5muD5oDuwhrhEr0todU4FiANrw3eAQO7wQN4oPrFpRumWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[CIFS] Do not send SMB2 signatures for SMB3 frames

Restructure code to make SMB2 vs. SMB3 signing a protocol
specific op.  SMB3 signing (AES_CMAC) is not enabled yet,
but this restructuring at least makes sure we don't send
an smb2 signature on an smb3 signed connection. A followon
patch will add AES_CMAC and enable smb3 signing.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  4 ++-
 fs/cifs/connect.c       |  2 +-
 fs/cifs/smb2ops.c       | 68 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h     |  4 +++
 fs/cifs/smb2transport.c | 13 +++++++---
 5 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 74a07b6..dfab450 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -367,6 +367,8 @@ struct smb_version_operations {
 	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
+	int (*calc_signature)(struct smb_rqst *rqst,
+				   struct TCP_Server_Info *server);
 };

 struct smb_version_values {
@@ -1489,6 +1491,6 @@ extern struct smb_version_values smb20_values;
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
 #define SMB30_VERSION_STRING	"3.0"
-/*extern struct smb_version_operations smb30_operations; */ /* not
needed yet */
+extern struct smb_version_operations smb30_operations;
 extern struct smb_version_values smb30_values;
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 290c134..f327623 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1085,7 +1085,7 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		vol->vals = &smb21_values;
 		break;
 	case Smb_30:
-		vol->ops = &smb21_operations; /* currently identical with 2.1 */
+		vol->ops = &smb30_operations;
 		vol->vals = &smb30_values;
 		break;
 #endif
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ad4d96a..d79de7b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -623,6 +623,74 @@ struct smb_version_operations smb21_operations = {
 	.get_lease_key = smb2_get_lease_key,
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
+	.calc_signature = smb2_calc_signature,
+};
+
+
+struct smb_version_operations smb30_operations = {
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
+	.calc_signature = smb3_calc_signature,
 };

 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 7d25f8b..2aa3535 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -47,6 +47,10 @@ extern struct mid_q_entry
*smb2_setup_request(struct cifs_ses *ses,
 			      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
+extern int smb2_calc_signature(struct smb_rqst *rqst,
+				struct TCP_Server_Info *server);
+extern int smb3_calc_signature(struct smb_rqst *rqst,
+				struct TCP_Server_Info *server);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern __u8 smb2_map_lease_to_oplock(__le32 lease_state);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2a5fdf2..8dd73e6 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -39,7 +39,7 @@
 #include "smb2status.h"
 #include "smb2glob.h"

-static int
+int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int i, rc;
@@ -116,6 +116,13 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
TCP_Server_Info *server)
 	return rc;
 }

+int
+smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+{
+	cFYI(1, "smb3 signatures not supported yet");
+	return -EOPNOTSUPP;
+}
+
 /* must be called with server->srv_mutex held */
 static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
@@ -132,7 +139,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct
TCP_Server_Info *server)
 		return rc;
 	}

-	rc = smb2_calc_signature(rqst, server);
+	rc = server->ops->calc_signature(rqst, server);

 	return rc;
 }
@@ -168,7 +175,7 @@ smb2_verify_signature(struct smb_rqst *rqst,
struct TCP_Server_Info *server)
 	memset(smb2_pdu->Signature, 0, SMB2_SIGNATURE_SIZE);

 	mutex_lock(&server->srv_mutex);
-	rc = smb2_calc_signature(rqst, server);
+	rc = server->ops->calc_signature(rqst, server);
 	mutex_unlock(&server->srv_mutex);

 	if (rc)
-- 

-- 
Thanks,

Steve
