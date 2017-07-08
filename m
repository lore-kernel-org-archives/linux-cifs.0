From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Reconnect expired SMB sessions
Date: Sat,  8 Jul 2017 14:32:00 -0700
Message-ID: <1499549520-113585-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

According to the MS-SMB2 spec (3.2.5.1.6) once the client receives
STATUS_NETWORK_SESSION_EXPIRED error code from a server it should
reconnect the current SMB session. Currently the client doesn't do
that. This can result in subsequent client requests failing by
the server. The patch adds an additional logic to the demultiplex
thread to identify expired sessions and reconnect them.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/cifssmb.c  |  7 +++++++
 fs/cifs/connect.c  |  7 +++++++
 fs/cifs/smb2ops.c  | 23 +++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bcc7d9a..fb48251 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -367,6 +367,8 @@ struct smb_version_operations {
 	unsigned int (*calc_smb_size)(void *);
 	/* check for STATUS_PENDING and process it in a positive case */
 	bool (*is_status_pending)(char *, struct TCP_Server_Info *, int);
+	/* check for STATUS_NETWORK_SESSION_EXPIRED */
+	bool (*is_session_expired)(char *);
 	/* send oplock break response */
 	int (*oplock_response)(struct cifs_tcon *, struct cifs_fid *,
 			       struct cifsInodeInfo *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index fbb0d4c..72a53bd 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1460,6 +1460,13 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return length;
 	server->total_read += length;
 
+	if (server->ops->is_session_expired &&
+	    server->ops->is_session_expired(buf)) {
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -1;
+	}
+
 	if (server->ops->is_status_pending &&
 	    server->ops->is_status_pending(buf, server, 0)) {
 		cifs_discard_remaining_data(server);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9365c0c..c59d77f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -812,6 +812,13 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
+	if (server->ops->is_session_expired &&
+	    server->ops->is_session_expired(buf)) {
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -1;
+	}
+
 	if (server->ops->is_status_pending &&
 	    server->ops->is_status_pending(buf, server, length))
 		return -1;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ccbb397..0866dda 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1036,6 +1036,18 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
 	return true;
 }
 
+static bool
+smb2_is_session_expired(char *buf)
+{
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+
+	if (shdr->Status != STATUS_NETWORK_SESSION_EXPIRED)
+		return false;
+
+	cifs_dbg(FYI, "Session expired\n");
+	return true;
+}
+
 static int
 smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 		     struct cifsInodeInfo *cinode)
@@ -2160,6 +2172,13 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		return -ENOTSUPP;
 	}
 
+	if (server->ops->is_session_expired &&
+	    server->ops->is_session_expired(buf)) {
+		cifs_reconnect(server);
+		wake_up(&server->response_q);
+		return -1;
+	}
+
 	if (server->ops->is_status_pending &&
 			server->ops->is_status_pending(buf, server, 0))
 		return -1;
@@ -2477,6 +2496,7 @@ struct smb_version_operations smb20_operations = {
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
+	.is_session_expired = smb2_is_session_expired,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -2565,6 +2585,7 @@ struct smb_version_operations smb21_operations = {
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
+	.is_session_expired = smb2_is_session_expired,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -2655,6 +2676,7 @@ struct smb_version_operations smb30_operations = {
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
+	.is_session_expired = smb2_is_session_expired,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -2755,6 +2777,7 @@ struct smb_version_operations smb311_operations = {
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
+	.is_session_expired = smb2_is_session_expired,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
-- 
2.7.4
