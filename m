From: Steve French <smfrench@gmail.com>
Subject: [PATCH 1/5] Add SMB3.11 mount option synonym for new dialect
Date: Sun, 28 Jun 2015 18:36:06 -0500
Message-ID: <1435534570-10864-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, Steve French <smfrench@gmail.com>,
	Steve French <steve.french@primarydata.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Steve French <smfrench@gmail.com>

Most people think of SMB 3.1.1 as SMB version 3.11 so add synonym
for "vers=3.1.1" of "vers=3.11" on mount.

Also make sure that unlike SMB3.0 and 3.02 we don't send
validate negotiate on mount (it is handled by negotiate contexts) -
add list of SMB3.11 specific functions (distinct from 3.0 dialect).

Signed-off-by: Steve French <steve.french@primarydata.com>w
---
 fs/cifs/cifsglob.h |  3 +-
 fs/cifs/connect.c  |  3 +-
 fs/cifs/smb2ops.c  | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 71bf86e..a0212ec 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1622,6 +1622,7 @@ extern struct smb_version_values smb30_values;
 /*extern struct smb_version_operations smb302_operations;*/ /* not needed yet */
 extern struct smb_version_values smb302_values;
 #define SMB311_VERSION_STRING	"3.1.1"
-/*extern struct smb_version_operations smb311_operations;*/ /* not needed yet */
+#define ALT_SMB311_VERSION_STRING "3.11"
+extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9300b98..247f4dd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -282,6 +282,7 @@ static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_302, SMB302_VERSION_STRING },
 #ifdef CONFIG_CIFS_SMB311
 	{ Smb_311, SMB311_VERSION_STRING },
+	{ Smb_311, ALT_SMB311_VERSION_STRING },
 #endif /* SMB311 */
 	{ Smb_version_err, NULL }
 };
@@ -1139,7 +1140,7 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		break;
 #ifdef CONFIG_CIFS_SMB311
 	case Smb_311:
-		vol->ops = &smb30_operations; /* currently identical with 3.0 */
+		vol->ops = &smb311_operations;
 		vol->vals = &smb311_values;
 		break;
 #endif /* SMB311 */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a7d520c..c7d228c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1635,6 +1635,92 @@ struct smb_version_operations smb30_operations = {
 	.fallocate = smb3_fallocate,
 };
 
+#ifdef CONFIG_CIFS_SMB311
+struct smb_version_operations smb311_operations = {
+	.compare_fids = smb2_compare_fids,
+	.setup_request = smb2_setup_request,
+	.setup_async_request = smb2_setup_async_request,
+	.check_receive = smb2_check_receive,
+	.add_credits = smb2_add_credits,
+	.set_credits = smb2_set_credits,
+	.get_credits_field = smb2_get_credits_field,
+	.get_credits = smb2_get_credits,
+	.wait_mtu_credits = smb2_wait_mtu_credits,
+	.get_next_mid = smb2_get_next_mid,
+	.read_data_offset = smb2_read_data_offset,
+	.read_data_length = smb2_read_data_length,
+	.map_error = map_smb2_to_linux_error,
+	.find_mid = smb2_find_mid,
+	.check_message = smb2_check_message,
+	.dump_detail = smb2_dump_detail,
+	.clear_stats = smb2_clear_stats,
+	.print_stats = smb2_print_stats,
+	.dump_share_caps = smb2_dump_share_caps,
+	.is_oplock_break = smb2_is_valid_oplock_break,
+	.downgrade_oplock = smb2_downgrade_oplock,
+	.need_neg = smb2_need_neg,
+	.negotiate = smb2_negotiate,
+	.negotiate_wsize = smb2_negotiate_wsize,
+	.negotiate_rsize = smb2_negotiate_rsize,
+	.sess_setup = SMB2_sess_setup,
+	.logoff = SMB2_logoff,
+	.tree_connect = SMB2_tcon,
+	.tree_disconnect = SMB2_tdis,
+	.qfs_tcon = smb3_qfs_tcon,
+	.is_path_accessible = smb2_is_path_accessible,
+	.can_echo = smb2_can_echo,
+	.echo = SMB2_echo,
+	.query_path_info = smb2_query_path_info,
+	.get_srv_inum = smb2_get_srv_inum,
+	.query_file_info = smb2_query_file_info,
+	.set_path_size = smb2_set_path_size,
+	.set_file_size = smb2_set_file_size,
+	.set_file_info = smb2_set_file_info,
+	.set_compression = smb2_set_compression,
+	.mkdir = smb2_mkdir,
+	.mkdir_setinfo = smb2_mkdir_setinfo,
+	.rmdir = smb2_rmdir,
+	.unlink = smb2_unlink,
+	.rename = smb2_rename_path,
+	.create_hardlink = smb2_create_hardlink,
+	.query_symlink = smb2_query_symlink,
+	.query_mf_symlink = smb3_query_mf_symlink,
+	.create_mf_symlink = smb3_create_mf_symlink,
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
+	.generate_signingkey = generate_smb3signingkey,
+	.calc_signature = smb3_calc_signature,
+	.is_read_op = smb21_is_read_op,
+	.set_oplock_level = smb3_set_oplock_level,
+	.create_lease_buf = smb3_create_lease_buf,
+	.parse_lease_buf = smb3_parse_lease_buf,
+	.clone_range = smb2_clone_range,
+/*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
+	.wp_retry_size = smb2_wp_retry_size,
+	.dir_needs_close = smb2_dir_needs_close,
+	.fallocate = smb3_fallocate,
+};
+#endif /* CIFS_SMB311 */
+
 struct smb_version_values smb20_values = {
 	.version_string = SMB20_VERSION_STRING,
 	.protocol_id = SMB20_PROT_ID,
-- 
2.1.4

