From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v4 2/7] CIFS: Move get_next_mid to ops struct
Date: Thu, 31 May 2012 16:50:52 +0400
Message-ID: <1338468657-29742-4-git-send-email-pshilovsky@samba.org>
References: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338468657-29742-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    7 ++++
 fs/cifs/cifsproto.h |    1 -
 fs/cifs/cifssmb.c   |    8 ++--
 fs/cifs/connect.c   |    2 +-
 fs/cifs/misc.c      |   89 +--------------------------------------------------
 fs/cifs/smb1ops.c   |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |    2 +-
 7 files changed, 103 insertions(+), 95 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 20350a9..6df0cbe 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -174,6 +174,7 @@ struct smb_version_operations {
 	void (*add_credits)(struct TCP_Server_Info *, const unsigned int);
 	void (*set_credits)(struct TCP_Server_Info *, const int);
 	int * (*get_credits_field)(struct TCP_Server_Info *);
+	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
 	/* data length from read response message */
@@ -399,6 +400,12 @@ set_credits(struct TCP_Server_Info *server, const int val)
 	server->ops->set_credits(server, val);
 }
 
+static inline __u64
+get_next_mid(struct TCP_Server_Info *server)
+{
+	return server->ops->get_next_mid(server);
+}
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 5ec21ec..0a6cbfe 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -114,7 +114,6 @@ extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				void **request_buf);
 extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *nls_cp);
-extern __u64 GetNextMid(struct TCP_Server_Info *server);
 extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
 extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b5ad716..5b40073 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -268,7 +268,7 @@ small_smb_init_no_tc(const int smb_command, const int wct,
 		return rc;
 
 	buffer = (struct smb_hdr *)*request_buf;
-	buffer->Mid = GetNextMid(ses->server);
+	buffer->Mid = get_next_mid(ses->server);
 	if (ses->capabilities & CAP_UNICODE)
 		buffer->Flags2 |= SMBFLG2_UNICODE;
 	if (ses->capabilities & CAP_STATUS32)
@@ -402,7 +402,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 
 	cFYI(1, "secFlags 0x%x", secFlags);
 
-	pSMB->hdr.Mid = GetNextMid(server);
+	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
 
 	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
@@ -782,7 +782,7 @@ CIFSSMBLogoff(const int xid, struct cifs_ses *ses)
 		return rc;
 	}
 
-	pSMB->hdr.Mid = GetNextMid(ses->server);
+	pSMB->hdr.Mid = get_next_mid(ses->server);
 
 	if (ses->server->sec_mode &
 		   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
@@ -4762,7 +4762,7 @@ getDFSRetry:
 
 	/* server pointer checked in called function,
 	but should never be null here anyway */
-	pSMB->hdr.Mid = GetNextMid(ses->server);
+	pSMB->hdr.Mid = get_next_mid(ses->server);
 	pSMB->hdr.Tid = ses->ipc_tid;
 	pSMB->hdr.Uid = ses->Suid;
 	if (ses->capabilities & CAP_STATUS32)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3647b1a..78db68a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3940,7 +3940,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
 			NULL /*no tid */ , 4 /*wct */ );
 
-	smb_buffer->Mid = GetNextMid(ses->server);
+	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
 	pSMB = (TCONX_REQ *) smb_buffer;
 	pSMBr = (TCONX_RSP *) smb_buffer_response;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index e2552d2..557506a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -212,93 +212,6 @@ cifs_small_buf_release(void *buf_to_free)
 	return;
 }
 
-/*
- * Find a free multiplex id (SMB mid). Otherwise there could be
- * mid collisions which might cause problems, demultiplexing the
- * wrong response to this request. Multiplex ids could collide if
- * one of a series requests takes much longer than the others, or
- * if a very large number of long lived requests (byte range
- * locks or FindNotify requests) are pending. No more than
- * 64K-1 requests can be outstanding at one time. If no
- * mids are available, return zero. A future optimization
- * could make the combination of mids and uid the key we use
- * to demultiplex on (rather than mid alone).
- * In addition to the above check, the cifs demultiplex
- * code already used the command code as a secondary
- * check of the frame and if signing is negotiated the
- * response would be discarded if the mid were the same
- * but the signature was wrong. Since the mid is not put in the
- * pending queue until later (when it is about to be dispatched)
- * we do have to limit the number of outstanding requests
- * to somewhat less than 64K-1 although it is hard to imagine
- * so many threads being in the vfs at one time.
- */
-__u64 GetNextMid(struct TCP_Server_Info *server)
-{
-	__u64 mid = 0;
-	__u16 last_mid, cur_mid;
-	bool collision;
-
-	spin_lock(&GlobalMid_Lock);
-
-	/* mid is 16 bit only for CIFS/SMB */
-	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
-	/* we do not want to loop forever */
-	last_mid = cur_mid;
-	cur_mid++;
-
-	/*
-	 * This nested loop looks more expensive than it is.
-	 * In practice the list of pending requests is short,
-	 * fewer than 50, and the mids are likely to be unique
-	 * on the first pass through the loop unless some request
-	 * takes longer than the 64 thousand requests before it
-	 * (and it would also have to have been a request that
-	 * did not time out).
-	 */
-	while (cur_mid != last_mid) {
-		struct mid_q_entry *mid_entry;
-		unsigned int num_mids;
-
-		collision = false;
-		if (cur_mid == 0)
-			cur_mid++;
-
-		num_mids = 0;
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
-			++num_mids;
-			if (mid_entry->mid == cur_mid &&
-			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
-				/* This mid is in use, try a different one */
-				collision = true;
-				break;
-			}
-		}
-
-		/*
-		 * if we have more than 32k mids in the list, then something
-		 * is very wrong. Possibly a local user is trying to DoS the
-		 * box by issuing long-running calls and SIGKILL'ing them. If
-		 * we get to 2^16 mids then we're in big trouble as this
-		 * function could loop forever.
-		 *
-		 * Go ahead and assign out the mid in this situation, but force
-		 * an eventual reconnect to clean out the pending_mid_q.
-		 */
-		if (num_mids > 32768)
-			server->tcpStatus = CifsNeedReconnect;
-
-		if (!collision) {
-			mid = (__u64)cur_mid;
-			server->CurrentMid = mid;
-			break;
-		}
-		cur_mid++;
-	}
-	spin_unlock(&GlobalMid_Lock);
-	return mid;
-}
-
 /* NB: MID can not be set if treeCon not passed in, in that
    case it is responsbility of caller to set the mid */
 void
@@ -334,7 +247,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 
 			/* Uid is not converted */
 			buffer->Uid = treeCon->ses->Suid;
-			buffer->Mid = GetNextMid(treeCon->ses->server);
+			buffer->Mid = get_next_mid(treeCon->ses->server);
 		}
 		if (treeCon->Flags & SMB_SHARE_IS_IN_DFS)
 			buffer->Flags2 |= SMBFLG2_DFS;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index d9d615f..6dec38f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -125,6 +125,94 @@ cifs_get_credits_field(struct TCP_Server_Info *server)
 	return &server->credits;
 }
 
+/*
+ * Find a free multiplex id (SMB mid). Otherwise there could be
+ * mid collisions which might cause problems, demultiplexing the
+ * wrong response to this request. Multiplex ids could collide if
+ * one of a series requests takes much longer than the others, or
+ * if a very large number of long lived requests (byte range
+ * locks or FindNotify requests) are pending. No more than
+ * 64K-1 requests can be outstanding at one time. If no
+ * mids are available, return zero. A future optimization
+ * could make the combination of mids and uid the key we use
+ * to demultiplex on (rather than mid alone).
+ * In addition to the above check, the cifs demultiplex
+ * code already used the command code as a secondary
+ * check of the frame and if signing is negotiated the
+ * response would be discarded if the mid were the same
+ * but the signature was wrong. Since the mid is not put in the
+ * pending queue until later (when it is about to be dispatched)
+ * we do have to limit the number of outstanding requests
+ * to somewhat less than 64K-1 although it is hard to imagine
+ * so many threads being in the vfs at one time.
+ */
+static __u64
+cifs_get_next_mid(struct TCP_Server_Info *server)
+{
+	__u64 mid = 0;
+	__u16 last_mid, cur_mid;
+	bool collision;
+
+	spin_lock(&GlobalMid_Lock);
+
+	/* mid is 16 bit only for CIFS/SMB */
+	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
+	/* we do not want to loop forever */
+	last_mid = cur_mid;
+	cur_mid++;
+
+	/*
+	 * This nested loop looks more expensive than it is.
+	 * In practice the list of pending requests is short,
+	 * fewer than 50, and the mids are likely to be unique
+	 * on the first pass through the loop unless some request
+	 * takes longer than the 64 thousand requests before it
+	 * (and it would also have to have been a request that
+	 * did not time out).
+	 */
+	while (cur_mid != last_mid) {
+		struct mid_q_entry *mid_entry;
+		unsigned int num_mids;
+
+		collision = false;
+		if (cur_mid == 0)
+			cur_mid++;
+
+		num_mids = 0;
+		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+			++num_mids;
+			if (mid_entry->mid == cur_mid &&
+			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
+				/* This mid is in use, try a different one */
+				collision = true;
+				break;
+			}
+		}
+
+		/*
+		 * if we have more than 32k mids in the list, then something
+		 * is very wrong. Possibly a local user is trying to DoS the
+		 * box by issuing long-running calls and SIGKILL'ing them. If
+		 * we get to 2^16 mids then we're in big trouble as this
+		 * function could loop forever.
+		 *
+		 * Go ahead and assign out the mid in this situation, but force
+		 * an eventual reconnect to clean out the pending_mid_q.
+		 */
+		if (num_mids > 32768)
+			server->tcpStatus = CifsNeedReconnect;
+
+		if (!collision) {
+			mid = (__u64)cur_mid;
+			server->CurrentMid = mid;
+			break;
+		}
+		cur_mid++;
+	}
+	spin_unlock(&GlobalMid_Lock);
+	return mid;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -133,6 +221,7 @@ struct smb_version_operations smb1_operations = {
 	.add_credits = cifs_add_credits,
 	.set_credits = cifs_set_credits,
 	.get_credits_field = cifs_get_credits_field,
+	.get_next_mid = cifs_get_next_mid,
 	.read_data_offset = cifs_read_data_offset,
 	.read_data_length = cifs_read_data_length,
 	.map_error = map_smb_to_linux_error,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1b36ffe..3097ee5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -779,7 +779,7 @@ send_lock_cancel(const unsigned int xid, struct cifs_tcon *tcon,
 
 	pSMB->LockType = LOCKING_ANDX_CANCEL_LOCK|LOCKING_ANDX_LARGE_FILES;
 	pSMB->Timeout = 0;
-	pSMB->hdr.Mid = GetNextMid(ses->server);
+	pSMB->hdr.Mid = get_next_mid(ses->server);
 
 	return SendReceive(xid, ses, in_buf, out_buf,
 			&bytes_returned, 0);
-- 
1.7.1
