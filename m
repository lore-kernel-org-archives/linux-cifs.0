From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: update multiplex loop to handle compounded responses
Date: Wed,  3 Jan 2018 09:35:24 +1100
Message-ID: <20180102223524.8389-3-lsahlber@redhat.com>
References: <20180102223524.8389-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102223524.8389-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/connect.c  | 18 +++++++++++++++---
 fs/cifs/smb2ops.c  | 12 ++++++++++++
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 14db722c4b0d..18a961d32e0c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -449,7 +449,7 @@ struct smb_version_operations {
 				 struct mid_q_entry **);
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
-
+	int (*next_header)(char *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 23d69657ca06..77b921f370f6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -840,6 +840,7 @@ cifs_demultiplex_thread(void *p)
 	int length;
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
+	unsigned int next_offset;
 	char *buf = NULL;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
@@ -877,17 +878,18 @@ cifs_demultiplex_thread(void *p)
 		 * so we can now interpret the length field.
 		 */
 		pdu_length = get_rfc1002_length(buf);
+next_pdu:
 		server->total_size = pdu_length;
 
-		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
+		cifs_dbg(FYI, "RFC1002 header 0x%x\n", server->total_size);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < HEADER_SIZE(server) - 1 -
+		if (server->total_size < HEADER_SIZE(server) - 1 -
 		    server->vals->header_preamble_size) {
 			cifs_dbg(VFS, "SMB response too short (%u bytes)\n",
-				 pdu_length);
+				 server->total_size);
 			cifs_reconnect(server);
 			wake_up(&server->response_q);
 			continue;
@@ -902,6 +904,12 @@ cifs_demultiplex_thread(void *p)
 			continue;
 		server->total_read += length;
 
+		if (server->ops->next_header) {
+			next_offset = server->ops->next_header(buf);
+			if (next_offset)
+				server->total_size = next_offset;
+		}
+
 		if (server->ops->is_transform_hdr &&
 		    server->ops->receive_transform &&
 		    server->ops->is_transform_hdr(buf)) {
@@ -947,6 +955,10 @@ cifs_demultiplex_thread(void *p)
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
+			if (pdu_length > server->total_size) {
+				pdu_length -= server->total_size;
+				goto next_pdu;
+			}
 		}
 	} /* end while !EXITING */
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 590c5e4b7b1d..ca3816cd0e35 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2710,6 +2710,14 @@ smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 				NULL, 0, 0);
 }
 
+static int
+smb2_next_header(char *buf)
+{
+	struct smb2_sync_hdr *hdr = (struct smb2_sync_hdr *)buf;
+
+	return le32_to_cpu(hdr->NextCommand);
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -2801,6 +2809,7 @@ struct smb_version_operations smb20_operations = {
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
+	.next_header = smb2_next_header,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -2895,6 +2904,7 @@ struct smb_version_operations smb21_operations = {
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
+	.next_header = smb2_next_header,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -2999,6 +3009,7 @@ struct smb_version_operations smb30_operations = {
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
+	.next_header = smb2_next_header,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -3099,6 +3110,7 @@ struct smb_version_operations smb311_operations = {
 	.query_all_EAs = smb2_query_eas,
 	.set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
+	.next_header = smb2_next_header,
 };
 #endif /* CIFS_SMB311 */
 
-- 
2.13.3
