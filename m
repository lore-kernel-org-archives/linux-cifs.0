From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 1/7] CIFS: Introduce S_OP/S_OPV macros for a safe access to ops struct field
Date: Mon, 28 May 2012 13:30:08 +0400
Message-ID: <1338197414-22340-2-git-send-email-pshilovsky@samba.org>
References: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338197414-22340-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   22 ++++++++++++++++++++--
 fs/cifs/cifssmb.c   |    6 +++---
 fs/cifs/connect.c   |    8 ++++----
 fs/cifs/file.c      |    2 +-
 fs/cifs/transport.c |   13 +++++++------
 5 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 20350a9..168be60 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -367,6 +367,24 @@ struct TCP_Server_Info {
 #endif
 };
 
+/*
+ * The macro is used for safe access to ops field.
+ *
+ * @server - pointer to the server.
+ * @op - name of ops field.
+ * @miss_code - return code.
+ * @... - ops field arguments.
+ *
+ * Return miss_code if server->ops doesn't have op field. Otherwise - return
+ * servr->ops->op(...).
+ */
+
+#define S_OP(server, op, miss_code, ...) \
+	(server->ops->op ? server->ops->op(__VA_ARGS__) : miss_code)
+
+/* Void returned version of S_OP macro */
+#define S_OPV(server, op, ...) S_OP(server, op, 0, __VA_ARGS__)
+
 static inline unsigned int
 in_flight(struct TCP_Server_Info *server)
 {
@@ -390,13 +408,13 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 static inline void
 add_credits(struct TCP_Server_Info *server, const unsigned int add)
 {
-	server->ops->add_credits(server, add);
+	S_OPV(server, add_credits, server, add);
 }
 
 static inline void
 set_credits(struct TCP_Server_Info *server, const int val)
 {
-	server->ops->set_credits(server, val);
+	S_OPV(server, set_credits, server, val);
 }
 
 /*
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b5ad716..2d73db8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1440,7 +1440,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 
 	/* Was the SMB read successful? */
-	rdata->result = server->ops->map_error(buf, false);
+	rdata->result = S_OP(server, map_error, -ENOSYS, buf, false);
 	if (rdata->result != 0) {
 		cFYI(1, "%s: server returned error %d", __func__,
 			rdata->result);
@@ -1456,7 +1456,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		return cifs_readv_discard(server, mid);
 	}
 
-	data_offset = server->ops->read_data_offset(buf) + 4;
+	data_offset = S_OP(server, read_data_offset, 0, buf) + 4;
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
@@ -1495,7 +1495,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 
 	/* how much data is in the response? */
-	data_len = server->ops->read_data_length(buf);
+	data_len = S_OP(server, read_data_length, 0, buf);
 	if (data_offset + data_len > buflen) {
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccafded..cba90e2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -968,7 +968,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = server->ops->check_message(buf, server->total_read);
+	length = S_OP(server, check_message, -ENOSYS, buf, server->total_read);
 	if (length != 0)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
@@ -1041,7 +1041,7 @@ cifs_demultiplex_thread(void *p)
 			continue;
 		server->total_read += length;
 
-		mid_entry = server->ops->find_mid(server, buf);
+		mid_entry = S_OP(server, find_mid, NULL, server, buf);
 
 		if (!mid_entry || !mid_entry->receive)
 			length = standard_receive3(server, mid_entry);
@@ -1058,13 +1058,13 @@ cifs_demultiplex_thread(void *p)
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!server->ops->is_oplock_break(buf, server)) {
+		} else if (!S_OP(server, is_oplock_break, false, buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
 				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
-			server->ops->dump_detail(buf);
+			S_OPV(server, dump_detail, buf);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 253170d..ab2ce7a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -682,7 +682,7 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 		    offset >= li->offset + li->length)
 			continue;
 		else if ((type & server->vals->shared_lock_type) &&
-			 ((server->ops->compare_fids(cur, cfile) &&
+			 ((S_OP(server, compare_fids, false, cur, cfile) &&
 			   current->tgid == li->pid) || type == li->type))
 			continue;
 		else {
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1b36ffe..9e2123b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -305,7 +305,9 @@ static int
 wait_for_free_request(struct TCP_Server_Info *server, const int optype)
 {
 	return wait_for_free_credits(server, optype,
-				     server->ops->get_credits_field(server));
+				     S_OP(server, get_credits_field,
+					  &server->credits /* def ret */,
+					  server));
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
@@ -487,8 +489,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 static inline int
 send_cancel(struct TCP_Server_Info *server, void *buf, struct mid_q_entry *mid)
 {
-	return server->ops->send_cancel ?
-				server->ops->send_cancel(server, buf, mid) : 0;
+	return S_OP(server, send_cancel, 0, server, buf, mid);
 }
 
 int
@@ -578,7 +579,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	rc = ses->server->ops->setup_request(ses, iov, n_vec, &midQ);
+	rc = S_OP(ses->server, setup_request, -ENOSYS, ses, iov, n_vec, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
@@ -641,8 +642,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
 
-	rc = ses->server->ops->check_receive(midQ, ses->server,
-					     flags & CIFS_LOG_ERROR);
+	rc = S_OP(ses->server, check_receive, -ENOSYS, midQ, ses->server,
+		  flags & CIFS_LOG_ERROR);
 
 	/* mark it so buf will not be freed by delete_mid */
 	if ((flags & CIFS_NO_RESP) == 0)
-- 
1.7.1
