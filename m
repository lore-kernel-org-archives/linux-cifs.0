From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 03/15] CIFS: Make send_cancel take rqst as argument
Date: Tue,  6 Dec 2016 14:02:26 -0800
Message-ID: <1481061758-52020-4-git-send-email-pshilov@microsoft.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/smb1ops.c   |  4 ++--
 fs/cifs/transport.c | 33 +++++++++++++++++++--------------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 59ab5a2..4f4fffd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -208,7 +208,7 @@ struct cifsInodeInfo;
 struct cifs_open_parms;
 
 struct smb_version_operations {
-	int (*send_cancel)(struct TCP_Server_Info *, void *,
+	int (*send_cancel)(struct TCP_Server_Info *, struct smb_rqst *,
 			   struct mid_q_entry *);
 	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
 	/* setup request: allocate mid, sign message */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index fc537c2..67a987e 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -36,11 +36,11 @@
  * SMB_COM_NT_CANCEL request and then sends it.
  */
 static int
-send_nt_cancel(struct TCP_Server_Info *server, void *buf,
+send_nt_cancel(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	       struct mid_q_entry *mid)
 {
 	int rc = 0;
-	struct smb_hdr *in_buf = (struct smb_hdr *)buf;
+	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
 
 	/* -4 for RFC1001 length and +2 for BCC field */
 	in_buf->smb_buf_length = cpu_to_be32(sizeof(struct smb_hdr) - 4  + 2);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b9fad50..d59ebd0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -595,10 +595,11 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 }
 
 static inline int
-send_cancel(struct TCP_Server_Info *server, void *buf, struct mid_q_entry *mid)
+send_cancel(struct TCP_Server_Info *server, struct smb_rqst *rqst,
+	    struct mid_q_entry *mid)
 {
 	return server->ops->send_cancel ?
-				server->ops->send_cancel(server, buf, mid) : 0;
+				server->ops->send_cancel(server, rqst, mid) : 0;
 }
 
 int
@@ -718,7 +719,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_cancel(ses->server, buf, midQ);
+		send_cancel(ses->server, &rqst, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
@@ -771,6 +772,9 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc = 0;
 	struct mid_q_entry *midQ;
+	unsigned int len = be32_to_cpu(in_buf->smb_buf_length);
+	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
+	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
 
 	if (ses == NULL) {
 		cifs_dbg(VFS, "Null smb session\n");
@@ -788,10 +792,9 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */
 
-	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
-			MAX_CIFS_HDR_SIZE - 4) {
+	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 		cifs_dbg(VFS, "Illegal length, greater than maximum frame, %d\n",
-			 be32_to_cpu(in_buf->smb_buf_length));
+			 len);
 		return -EIO;
 	}
 
@@ -822,7 +825,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(ses->server);
-	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
+	rc = smb_send(ses->server, in_buf, len);
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
 
@@ -839,7 +842,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_cancel(ses->server, in_buf, midQ);
+		send_cancel(ses->server, &rqst, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
@@ -908,6 +911,9 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int rstart = 0;
 	struct mid_q_entry *midQ;
 	struct cifs_ses *ses;
+	unsigned int len = be32_to_cpu(in_buf->smb_buf_length);
+	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
+	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
 
 	if (tcon == NULL || tcon->ses == NULL) {
 		cifs_dbg(VFS, "Null smb session\n");
@@ -927,10 +933,9 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */
 
-	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
-			MAX_CIFS_HDR_SIZE - 4) {
+	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 		cifs_dbg(VFS, "Illegal length, greater than maximum frame, %d\n",
-			 be32_to_cpu(in_buf->smb_buf_length));
+			 len);
 		return -EIO;
 	}
 
@@ -959,7 +964,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
-	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
+	rc = smb_send(ses->server, in_buf, len);
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
 
@@ -988,7 +993,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
 			   blocking lock to return. */
-			rc = send_cancel(ses->server, in_buf, midQ);
+			rc = send_cancel(ses->server, &rqst, midQ);
 			if (rc) {
 				cifs_delete_mid(midQ);
 				return rc;
@@ -1009,7 +1014,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 		rc = wait_for_response(ses->server, midQ);
 		if (rc) {
-			send_cancel(ses->server, in_buf, midQ);
+			send_cancel(ses->server, &rqst, midQ);
 			spin_lock(&GlobalMid_Lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
-- 
2.7.4
