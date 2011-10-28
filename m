From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 14/53] CIFS: Expand cifs mid structure to keep SMB2 related fields
Date: Fri, 28 Oct 2011 23:54:25 +0400
Message-ID: <1319831704-3572-15-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

and let it use the common wait_for_response call.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_debug.c    |   13 ++++---
 fs/cifs/cifsfs.c        |    2 +-
 fs/cifs/cifsglob.h      |   14 ++++----
 fs/cifs/cifsproto.h     |    2 +
 fs/cifs/cifssmb.c       |   12 +++---
 fs/cifs/connect.c       |   22 ++++++------
 fs/cifs/misc.c          |    2 +-
 fs/cifs/smb2glob.h      |   47 ------------------------
 fs/cifs/smb2transport.c |   44 +++++++---------------
 fs/cifs/transport.c     |   93 +++++++++++++++++++++++++----------------------
 10 files changed, 98 insertions(+), 153 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index add9975..1f91bc6 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -79,15 +79,15 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %d",
-			mid_entry->midState,
+		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu",
+			mid_entry->mid_state,
 			(int)mid_entry->command,
 			mid_entry->pid,
 			mid_entry->callback_data,
 			mid_entry->mid);
 #ifdef CONFIG_CIFS_STATS2
 		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
-			mid_entry->largeBuf,
+			mid_entry->large_buf,
 			mid_entry->resp_buf,
 			mid_entry->when_received,
 			jiffies);
@@ -188,9 +188,10 @@ static void dump_cifs_debug_info(int i, struct seq_file *m,
 		list_for_each(tmp3, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp3, struct mid_q_entry, qhead);
 			seq_printf(m, "\tState: %d com: %d pid:"
-					" %d cbdata: %p mid %d\n",
-					mid_entry->midState,
-					(int)mid_entry->command, mid_entry->pid,
+					" %d cbdata: %p mid %llu\n",
+					mid_entry->mid_state,
+					le16_to_cpu(mid_entry->command),
+					mid_entry->pid,
 					mid_entry->callback_data,
 					mid_entry->mid);
 		}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 04fd74e..fce81fc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1076,7 +1076,7 @@ cifs_init_mids(void)
 
 #ifdef CONFIG_CIFS_SMB2
 	smb2_mid_cachep = kmem_cache_create("smb2_mpx_ids",
-					    sizeof(struct smb2_mid_entry), 0,
+					    sizeof(struct mid_q_entry), 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
 	if (smb2_mid_cachep == NULL) {
 		mempool_destroy(cifs_mid_poolp);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4ccd893..a2b14d8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -734,7 +734,7 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	int midState;	/* wish this were enum but can not pass to wait_event */
+	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	unsigned long when_alloc;  /* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long when_sent; /* time when smb send finished */
@@ -742,13 +742,13 @@ struct mid_q_entry {
 #endif
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
-	void *callback_data;	  /* general purpose pointer for callback */
-	bool largeBuf:1;	/* if valid response, is pointer to large buf */
-	__u16 mid;		/* multiplex id */
+	void *callback_data;	/* general purpose pointer for callback */
+	bool large_buf:1;	/* if valid response, is pointer to large buf */
+	__u64 mid;		/* multiplex id */
+	__le16 command;		/* smb command code */
+	__u32 pid;		/* process id */
+	void *resp_buf;		/* response buffer */
 	__u32 sequence_number;  /* for CIFS signing */
-	__u8 command;		/* smb command code */
-	__u16 pid;		/* process id */
-	struct smb_hdr *resp_buf;	/* response buffer */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 };
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 5109925..5a2d6ef 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -71,6 +71,8 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int wait_for_free_request(struct TCP_Server_Info *sv, const int long_op);
+extern int wait_for_response(struct TCP_Server_Info *server,
+			     struct mid_q_entry *midQ);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b029cc7..bc13c8b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1443,7 +1443,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	pgoff_t eof_index;
 	struct page *page, *tpage;
 
-	cFYI(1, "%s: mid=%u offset=%llu bytes=%u", __func__,
+	cFYI(1, "%s: mid=%llu offset=%llu bytes=%u", __func__,
 		mid->mid, rdata->offset, rdata->bytes);
 
 	/*
@@ -1643,10 +1643,10 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 
-	cFYI(1, "%s: mid=%u state=%d result=%d bytes=%u", __func__,
-		mid->mid, mid->midState, rdata->result, rdata->bytes);
+	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
+		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
 
-	switch (mid->midState) {
+	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
 		if (server->sec_mode &
@@ -2065,7 +2065,7 @@ cifs_writedata_alloc(unsigned int nr_pages)
 }
 
 /*
- * Check the midState and signature on received buffer (if any), and queue the
+ * Check the mid_state and signature on received buffer (if any), and queue the
  * workqueue completion task.
  */
 static void
@@ -2076,7 +2076,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 	unsigned int written;
 	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
 
-	switch (mid->midState) {
+	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		wdata->result = cifs_check_receive(mid, tcon->ses->server, 0);
 		if (wdata->result != 0)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 557ba67..680017d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -144,8 +144,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		if (mid_entry->midState == MID_REQUEST_SUBMITTED)
-			mid_entry->midState = MID_RETRY_NEEDED;
+		if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
+			mid_entry->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid_entry->qhead, &retry_list);
 	}
 	spin_unlock(&GlobalMid_Lock);
@@ -546,8 +546,8 @@ find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if (mid->mid == buf->Mid &&
-		    mid->midState == MID_REQUEST_SUBMITTED &&
-		    mid->command == buf->Command) {
+		    mid->mid_state == MID_REQUEST_SUBMITTED &&
+		    le16_to_cpu(mid->command) == buf->Command) {
 			spin_unlock(&GlobalMid_Lock);
 			return mid;
 		}
@@ -564,9 +564,9 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 #endif
 	spin_lock(&GlobalMid_Lock);
 	if (!malformed)
-		mid->midState = MID_RESPONSE_RECEIVED;
+		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		mid->midState = MID_RESPONSE_MALFORMED;
+		mid->mid_state = MID_RESPONSE_MALFORMED;
 	list_del_init(&mid->qhead);
 	spin_unlock(&GlobalMid_Lock);
 }
@@ -593,13 +593,13 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		} else {
 			/* Have first buffer */
 			mid->resp_buf = buf;
-			mid->largeBuf = true;
+			mid->large_buf = true;
 			server->bigbuf = NULL;
 		}
 		return;
 	}
 	mid->resp_buf = buf;
-	mid->largeBuf = server->large_buf;
+	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
 	if (!mid->multiRsp) {
 		/* smb buffer will be freed by user thread */
@@ -663,8 +663,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Clearing mid 0x%x", mid_entry->mid);
-			mid_entry->midState = MID_SHUTDOWN;
+			cFYI(1, "Clearing mid 0x%llx", mid_entry->mid);
+			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -672,7 +672,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Callback mid 0x%x", mid_entry->mid);
+			cFYI(1, "Callback mid 0x%llx", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 		}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 464ebee..4ead6f9 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -264,7 +264,7 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
 			if (mid_entry->mid == server->CurrentMid &&
-			    mid_entry->midState == MID_REQUEST_SUBMITTED) {
+			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 225b250..0e9fba7 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -160,53 +160,6 @@ struct page_req {
 	struct mid_q_entry *midq; /* queue structure for demultiplex */
 };
 
-struct smb2_mid_entry;
-
-typedef void (smb2_mid_callback_t)(struct smb2_mid_entry *mid);
-
-/* one of these for every pending SMB2 request to the server */
-struct smb2_mid_entry {
-	struct list_head qhead;	/* mids waiting on reply from this server */
-	int mid_state;	/* wish this were enum but can not pass to wait_event */
-	unsigned long when_alloc;  /* when mid was created */
-#ifdef CONFIG_CIFS_STATS2
-	unsigned long when_sent; /* time when smb send finished */
-	unsigned long when_received; /* when demux complete (taken off wire) */
-#endif
-	bool large_buf:1;	/* if valid response, is pointer to large buf */
-	smb2_mid_callback_t *callback;
-	void *callback_data;
-	__u64 mid;		/* multiplex id(s), bigger for smb2 */
-	__le16 command;		/* smb2 command code */
-	__u32 pid;		/* process id - bigger for smb2 than cifs */
-	struct smb2_hdr *resp_buf;	/* response buffer */
-
-	/* Additional fields below needed for handling async smb2 responses
-	and for asynchronous smb2_writepages support have been temporarily
-	removed from the port and will be reenabled as that gets merged in */
-
-#if 0 /* Fields needed for smb2_writepages, compound ops, async support */
-	char **pagebuf_list;	        /* response buffer */
-	int num_pages;
-	bool async_resp_rcvd:1; /* if server has responded with interim resp */
-	bool is_kmap_buf:1;
-	__u64 *mid_list;	/* multiplex id(s) */
-	int *mid_state_list;
-	short int *large_buf_list;
-	unsigned int num_mid;
-	unsigned int act_num_mid;
-	unsigned int num_received;
-	unsigned int cur_id;
-	struct smb2_hdr **resp_buf_list;	/* response buffer */
-	__le16 *command_list;
-	bool async:1;
-	bool complex_mid:1; /* complex entry - consists of several messages */
-	int result;
-	unsigned long last_rsp_time;
-#endif
-};
-
-
 #define   SMB2SEC_DEF (SMB2SEC_MAY_SIGN | SMB2SEC_MAY_NTLM | SMB2SEC_MAY_NTLMV2)
 #define   SMB2SEC_MAX (SMB2SEC_MUST_SIGN | SMB2SEC_MUST_NTLMV2)
 #define   SMB2SEC_AUTH_MASK (SMB2SEC_MAY_NTLM | SMB2SEC_MAY_NTLMV2 | \
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index adf24c4..68cbba9 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -102,16 +102,16 @@ smb2_sendrcv_blocking(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static void
-wake_up_smb2_task(struct smb2_mid_entry *mid)
+wake_up_smb2_task(struct mid_q_entry *mid)
 {
 	wake_up_process(mid->callback_data);
 }
 
-static struct smb2_mid_entry *
+static struct mid_q_entry *
 smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 		     struct TCP_Server_Info *server)
 {
-	struct smb2_mid_entry *temp;
+	struct mid_q_entry *temp;
 
 	if (server == NULL) {
 		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
@@ -122,7 +122,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 	if (temp == NULL)
 		return temp;
 	else {
-		memset(temp, 0, sizeof(struct smb2_mid_entry));
+		memset(temp, 0, sizeof(struct mid_q_entry));
 		temp->mid = smb_buffer->MessageId;	/* always LE */
 		temp->pid = current->pid;
 		temp->command = smb_buffer->Command;	/* Always LE */
@@ -142,7 +142,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 }
 
 static int get_smb2_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
-			struct smb2_mid_entry **ppmidQ)
+			struct mid_q_entry **ppmidQ)
 {
 	if (ses->server->tcpStatus == CifsExiting)
 		return -ENOENT;
@@ -169,7 +169,7 @@ static int get_smb2_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
 }
 
 static void
-smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
+smb2_mid_entry_free(struct mid_q_entry *mid_entry)
 {
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long now;
@@ -220,24 +220,9 @@ smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
 	mempool_free(mid_entry, smb2_mid_poolp);
 }
 
-/* This is similar to cifs's wait_for_response but obviously for smb2 mids */
-static int
-wait_for_smb2_response(struct TCP_Server_Info *server,
-			struct smb2_mid_entry *midq)
-{
-	int error;
-
-	error = wait_event_freezekillable(server->response_q,
-				    midq->mid_state != MID_REQUEST_SUBMITTED);
-	if (error < 0)
-		return -ERESTARTSYS;
-
-	return 0;
-}
-
 /* This is similar to cifs's sync_mid_result but for smb2 mids */
 static int
-sync_smb2_mid_result(struct smb2_mid_entry *mid, struct TCP_Server_Info *server)
+sync_smb2_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
@@ -279,7 +264,7 @@ sync_smb2_mid_result(struct smb2_mid_entry *mid, struct TCP_Server_Info *server)
 }
 
 static void
-free_smb2_mid(struct smb2_mid_entry *mid)
+free_smb2_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
 	list_del(&mid->qhead);
@@ -289,7 +274,7 @@ free_smb2_mid(struct smb2_mid_entry *mid)
 }
 
 static int
-smb2_check_receive(struct smb2_mid_entry *mid, struct TCP_Server_Info *server,
+smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   unsigned int receive_len, bool log_error)
 {
 	unsigned int len = get_rfc1002_length(mid->resp_buf);
@@ -322,7 +307,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 	int rc = 0;
 	int long_op;
 	unsigned int receive_len;
-	struct smb2_mid_entry *midQ;
+	struct mid_q_entry *midQ;
 	struct smb2_hdr *buf = iov[0].iov_base;
 	unsigned int credits = 1;
 
@@ -371,7 +356,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 	/* rc = sign_smb2(iov, n_vec, ses->server); BB
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	} */
 
@@ -393,9 +378,9 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	rc = wait_for_smb2_response(ses->server, midQ);
+	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		/* send_nt_cancel(ses->server, in_buf, midQ); BB */
+		/* send_nt_cancel(ses->server, buf, midQ); BB */
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = free_smb2_mid;
@@ -424,7 +409,7 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	buf = (struct smb2_hdr *)midQ->resp_buf;
-	receive_len = be32_to_cpu(buf->smb2_buf_length);
+	receive_len = get_rfc1002_length(buf);
 
 	if (receive_len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
 		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
@@ -437,7 +422,6 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 
 	iov[0].iov_base = (char *)buf;
 	iov[0].iov_len = receive_len + 4;
-
 	if (midQ->large_buf)
 		*presp_buftype = CIFS_LARGE_BUFFER;
 	else
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ee8a1f8..bfae7d9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -60,7 +60,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		memset(temp, 0, sizeof(struct mid_q_entry));
 		temp->mid = smb_buffer->Mid;	/* always LE */
 		temp->pid = current->pid;
-		temp->command = smb_buffer->Command;
+		temp->command = cpu_to_le16(smb_buffer->Command);
 		cFYI(1, "For smb_command %d", temp->command);
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
@@ -75,7 +75,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	}
 
 	atomic_inc(&midCount);
-	temp->midState = MID_REQUEST_ALLOCATED;
+	temp->mid_state = MID_REQUEST_ALLOCATED;
 	return temp;
 }
 
@@ -85,9 +85,9 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long now;
 #endif
-	midEntry->midState = MID_FREE;
+	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);
-	if (midEntry->largeBuf)
+	if (midEntry->large_buf)
 		cifs_buf_release(midEntry->resp_buf);
 	else
 		cifs_small_buf_release(midEntry->resp_buf);
@@ -98,7 +98,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	if ((now - midEntry->when_alloc) > HZ) {
 		if ((cifsFYI & CIFS_TIMER) &&
 		   (midEntry->command != SMB_COM_LOCKING_ANDX)) {
-			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %d",
+			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
 			       now - midEntry->when_alloc,
@@ -351,13 +351,13 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	return 0;
 }
 
-static int
+int
 wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 {
 	int error;
 
 	error = wait_event_freezekillable(server->response_q,
-				    midQ->midState != MID_REQUEST_SUBMITTED);
+				    midQ->mid_state != MID_REQUEST_SUBMITTED);
 	if (error < 0)
 		return -ERESTARTSYS;
 
@@ -409,7 +409,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
-	mid->midState = MID_REQUEST_SUBMITTED;
+	mid->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(server);
 	rc = smb_sendv(server, iov, nvec);
@@ -459,11 +459,11 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
-	cFYI(1, "%s: cmd=%d mid=%d state=%d", __func__, mid->command,
-		mid->mid, mid->midState);
+	cFYI(1, "%s: cmd=%d mid=%llu state=%d", __func__, mid->command,
+		mid->mid, mid->mid_state);
 
 	spin_lock(&GlobalMid_Lock);
-	switch (mid->midState) {
+	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
@@ -478,8 +478,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	default:
 		list_del_init(&mid->qhead);
-		cERROR(1, "%s: invalid mid state mid=%d state=%d", __func__,
-			mid->mid, mid->midState);
+		cERROR(1, "%s: invalid mid state mid=%llu state=%d", __func__,
+			mid->mid, mid->mid_state);
 		rc = -EIO;
 	}
 	spin_unlock(&GlobalMid_Lock);
@@ -529,7 +529,7 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = be32_to_cpu(mid->resp_buf->smb_buf_length) + 4;
+	unsigned int len = get_rfc1002_length(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -557,20 +557,20 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	int rc = 0;
 	int long_op;
 	struct mid_q_entry *midQ;
-	struct smb_hdr *in_buf = iov[0].iov_base;
+	struct smb_hdr *buf = iov[0].iov_base;
 
 	long_op = flags & CIFS_TIMEOUT_MASK;
 
 	*pRespBufType = CIFS_NO_BUFFER;  /* no response buf yet */
 
 	if ((ses == NULL) || (ses->server == NULL)) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		cERROR(1, "Null session");
 		return -EIO;
 	}
 
 	if (ses->server->tcpStatus == CifsExiting) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		return -ENOENT;
 	}
 
@@ -580,7 +580,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_free_request(ses->server, long_op);
 	if (rc) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		return rc;
 	}
 
@@ -590,10 +590,10 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	mutex_lock(&ses->server->srv_mutex);
 
-	rc = allocate_mid(ses, in_buf, &midQ);
+	rc = allocate_mid(ses, buf, &midQ);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
 		atomic_dec(&ses->server->inFlight);
 		wake_up(&ses->server->request_q);
@@ -602,11 +602,11 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_sign_smb2(iov, n_vec, ses->server, &midQ->sequence_number);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_sendv(ses->server, iov, n_vec);
 	cifs_in_send_dec(ses->server);
@@ -615,23 +615,23 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	}
 
 	if (long_op == CIFS_ASYNC_OP) {
-		cifs_small_buf_release(in_buf);
+		cifs_small_buf_release(buf);
 		goto out;
 	}
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
-		send_nt_cancel(ses->server, in_buf, midQ);
+		send_nt_cancel(ses->server, buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			cifs_small_buf_release(in_buf);
+			cifs_small_buf_release(buf);
 			atomic_dec(&ses->server->inFlight);
 			wake_up(&ses->server->request_q);
 			return rc;
@@ -639,7 +639,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&GlobalMid_Lock);
 	}
 
-	cifs_small_buf_release(in_buf);
+	cifs_small_buf_release(buf);
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
@@ -648,15 +648,16 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		return rc;
 	}
 
-	if (!midQ->resp_buf || midQ->midState != MID_RESPONSE_RECEIVED) {
+	if (!midQ->resp_buf || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cFYI(1, "Bad MID state?");
 		goto out;
 	}
 
-	iov[0].iov_base = (char *)midQ->resp_buf;
-	iov[0].iov_len = be32_to_cpu(midQ->resp_buf->smb_buf_length) + 4;
-	if (midQ->largeBuf)
+	buf = (struct smb_hdr *)midQ->resp_buf;
+	iov[0].iov_base = (char *)buf;
+	iov[0].iov_len = be32_to_cpu(buf->smb_buf_length) + 4;
+	if (midQ->large_buf)
 		*pRespBufType = CIFS_LARGE_BUFFER;
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
@@ -681,6 +682,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc = 0;
 	struct mid_q_entry *midQ;
+	struct smb_hdr *buf;
 
 	if (ses == NULL) {
 		cERROR(1, "Null smb session");
@@ -730,7 +732,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
@@ -748,7 +750,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
@@ -767,14 +769,15 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	if (!midQ->resp_buf || !out_buf ||
-	    midQ->midState != MID_RESPONSE_RECEIVED) {
+	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
 		goto out;
 	}
 
-	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
-	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
+	buf = (struct smb_hdr *)midQ->resp_buf;
+	*pbytes_returned = be32_to_cpu(buf->smb_buf_length);
+	memcpy(out_buf, buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
@@ -818,6 +821,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int rstart = 0;
 	struct mid_q_entry *midQ;
 	struct cifs_ses *ses;
+	struct smb_hdr *buf;
 
 	if (tcon == NULL || tcon->ses == NULL) {
 		cERROR(1, "Null smb session");
@@ -867,7 +871,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	cifs_in_send_dec(ses->server);
@@ -881,13 +885,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(ses->server->response_q,
-		(!(midQ->midState == MID_REQUEST_SUBMITTED)) ||
+		(!(midQ->mid_state == MID_REQUEST_SUBMITTED)) ||
 		((ses->server->tcpStatus != CifsGood) &&
 		 (ses->server->tcpStatus != CifsNew)));
 
 	/* Were we interrupted by a signal ? */
 	if ((rc == -ERESTARTSYS) &&
-		(midQ->midState == MID_REQUEST_SUBMITTED) &&
+		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
 		((ses->server->tcpStatus == CifsGood) ||
 		 (ses->server->tcpStatus == CifsNew))) {
 
@@ -917,7 +921,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) {
 			send_nt_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
-			if (midQ->midState == MID_REQUEST_SUBMITTED) {
+			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
@@ -935,14 +939,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	/* rcvd frame is ok */
-	if (out_buf == NULL || midQ->midState != MID_RESPONSE_RECEIVED) {
+	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
 		goto out;
 	}
 
-	*pbytes_returned = be32_to_cpu(midQ->resp_buf->smb_buf_length);
-	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
+	buf = (struct smb_hdr *)midQ->resp_buf;
+	*pbytes_returned = be32_to_cpu(buf->smb_buf_length);
+	memcpy(out_buf, buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-- 
1.7.1
