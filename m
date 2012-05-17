From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/5] CIFS: Move header_size/max_header_size to ops structure
Date: Thu, 17 May 2012 19:43:41 +0400
Message-ID: <1337269424-9494-3-git-send-email-piastry@etersoft.ru>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h |   17 +++++------------
 fs/cifs/cifssmb.c  |    7 ++++---
 fs/cifs/connect.c  |   17 +++++++++--------
 fs/cifs/smb1ops.c  |    2 ++
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ff06211..94657e2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -175,8 +175,13 @@ struct smb_version_values {
 	__u32		exclusive_lock_type;
 	__u32		shared_lock_type;
 	__u32		unlock_lock_type;
+	size_t		header_size;
+	size_t		max_header_size;
 };
 
+#define HEADER_SIZE(server) (server->vals->header_size)
+#define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
+
 struct smb_vol {
 	char *username;
 	char *password;
@@ -372,18 +377,6 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 	return num > 0;
 }
 
-static inline size_t
-header_size(void)
-{
-	return sizeof(struct smb_hdr);
-}
-
-static inline size_t
-max_header_size(void)
-{
-	return MAX_CIFS_HDR_SIZE;
-}
-
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3563c93..77463f7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1400,7 +1400,7 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 		length = cifs_read_from_socket(server, server->bigbuf,
 				min_t(unsigned int, remaining,
-					CIFSMaxBufSize + max_header_size()));
+				    CIFSMaxBufSize + MAX_HEADER_SIZE(server)));
 		if (length < 0)
 			return length;
 		server->total_read += length;
@@ -1449,9 +1449,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * can if there's not enough data. At this point, we've read down to
 	 * the Mid.
 	 */
-	len = min_t(unsigned int, buflen, read_rsp_size()) - header_size() + 1;
+	len = min_t(unsigned int, buflen, read_rsp_size()) -
+							HEADER_SIZE(server) + 1;
 
-	rdata->iov[0].iov_base = buf + header_size() - 1;
+	rdata->iov[0].iov_base = buf + HEADER_SIZE(server) - 1;
 	rdata->iov[0].iov_len = len;
 
 	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5ac20fc..65ec6ef 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -568,7 +568,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		}
 	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, header_size());
+		memset(server->bigbuf, 0, HEADER_SIZE(server));
 	}
 
 	if (!server->smallbuf) {
@@ -582,7 +582,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, header_size());
+		memset(server->smallbuf, 0, HEADER_SIZE(server));
 	}
 
 	return true;
@@ -953,7 +953,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	unsigned int pdu_length = get_rfc1002_length(buf);
 
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + max_header_size() - 4) {
+	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) - 4) {
 		cERROR(1, "SMB response too long (%u bytes)",
 			pdu_length);
 		cifs_reconnect(server);
@@ -969,8 +969,8 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server, buf + header_size() - 1,
-				       pdu_length - header_size() + 1 + 4);
+	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
+				pdu_length - HEADER_SIZE(server) + 1 + 4);
 	if (length < 0)
 		return length;
 	server->total_read += length;
@@ -1044,7 +1044,7 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < header_size() - 1 - 4) {
+		if (pdu_length < HEADER_SIZE(server) - 1 - 4) {
 			cERROR(1, "SMB response too short (%u bytes)",
 				pdu_length);
 			cifs_reconnect(server);
@@ -1054,7 +1054,7 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server, buf + 4,
-					       header_size() - 1 - 4);
+					       HEADER_SIZE(server) - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
@@ -1079,7 +1079,8 @@ cifs_demultiplex_thread(void *p)
 		} else if (!is_valid_oplock_break(buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", buf, header_size());
+			cifs_dump_mem("Received Data is: ", buf,
+				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
 			cifs_dump_detail(buf);
 			cifs_dump_mids(server);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3b7cf89..5dc365f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -80,4 +80,6 @@ struct smb_version_values smb1_values = {
 	.exclusive_lock_type = 0,
 	.shared_lock_type = LOCKING_ANDX_SHARED_LOCK,
 	.unlock_lock_type = 0,
+	.header_size = sizeof(struct smb_hdr),
+	.max_header_size = MAX_CIFS_HDR_SIZE,
 };
-- 
1.7.1
