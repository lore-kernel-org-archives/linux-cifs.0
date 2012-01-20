From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 01/50] CIFS: Expand cifs mid structure to keep SMB2 related fields
Date: Fri, 20 Jan 2012 12:34:22 +0400
Message-ID: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This lets us use the existing transport code to send both CIFS and
SMB2 protocol messages.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   20 ++++++------
 fs/cifs/cifsfs.c     |    2 +-
 fs/cifs/cifsglob.h   |   16 +++++-----
 fs/cifs/cifssmb.c    |   12 ++++----
 fs/cifs/connect.c    |   22 +++++++-------
 fs/cifs/misc.c       |    2 +-
 fs/cifs/transport.c  |   82 +++++++++++++++++++++++++++----------------------
 7 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 84e8c07..0308b52 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -79,15 +79,15 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %d",
-			mid_entry->midState,
-			(int)mid_entry->command,
+		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu",
+			mid_entry->mid_state,
+			le16_to_cpu(mid_entry->command),
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
@@ -218,12 +218,12 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				mid_entry = list_entry(tmp3, struct mid_q_entry,
 					qhead);
 				seq_printf(m, "\tState: %d com: %d pid:"
-						" %d cbdata: %p mid %d\n",
-						mid_entry->midState,
-						(int)mid_entry->command,
-						mid_entry->pid,
-						mid_entry->callback_data,
-						mid_entry->mid);
+					      " %d cbdata: %p mid %llu\n",
+					      mid_entry->mid_state,
+					      le16_to_cpu(mid_entry->command),
+					      mid_entry->pid,
+					      mid_entry->callback_data,
+					      mid_entry->mid);
 			}
 			spin_unlock(&GlobalMid_Lock);
 		}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8f1fe32..8169387 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifsfs.c
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   Common Internet FileSystem (CIFS) client
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8238aa1..1e1b54b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -685,9 +685,7 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	__u16 mid;		/* multiplex id */
-	__u16 pid;		/* process id */
-	__u32 sequence_number;  /* for CIFS signing */
+	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	unsigned long when_alloc;  /* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long when_sent; /* time when smb send finished */
@@ -695,11 +693,13 @@ struct mid_q_entry {
 #endif
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
-	void *callback_data;	  /* general purpose pointer for callback */
-	struct smb_hdr *resp_buf;	/* pointer to received SMB header */
-	int midState;	/* wish this were enum but can not pass to wait_event */
-	__u8 command;	/* smb command code */
-	bool largeBuf:1;	/* if valid response, is pointer to large buf */
+	void *callback_data;	/* general purpose pointer for callback */
+	bool large_buf:1;	/* if valid response, is pointer to large buf */
+	__u64 mid;		/* multiplex id */
+	__le16 command;		/* smb command code */
+	__u32 pid;		/* process id */
+	void *resp_buf;		/* response buffer */
+	__u32 sequence_number;  /* for CIFS signing */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8b7794c..abf7fbd 100644
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
index 2838195..d64ab48 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -142,8 +142,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
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
index 703ef5c..dad14d1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -261,7 +261,7 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
 			if (mid_entry->mid == server->CurrentMid &&
-			    mid_entry->midState == MID_REQUEST_SUBMITTED) {
+			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0cc9584..f3f98ad 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -60,8 +60,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		memset(temp, 0, sizeof(struct mid_q_entry));
 		temp->mid = smb_buffer->Mid;	/* always LE */
 		temp->pid = current->pid;
-		temp->command = smb_buffer->Command;
-		cFYI(1, "For smb_command %d", temp->command);
+		temp->command = cpu_to_le16(smb_buffer->Command);
+		cFYI(1, "For smb_command %d", smb_buffer->Command);
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
 		temp->when_alloc = jiffies;
@@ -75,7 +75,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	}
 
 	atomic_inc(&midCount);
-	temp->midState = MID_REQUEST_ALLOCATED;
+	temp->mid_state = MID_REQUEST_ALLOCATED;
 	return temp;
 }
 
@@ -85,20 +85,22 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
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
 #ifdef CONFIG_CIFS_STATS2
 	now = jiffies;
-	/* commands taking longer than one second are indications that
-	   something is wrong, unless it is quite a slow link or server */
+	/*
+	 * Commands taking longer than one second are indications that
+	 * something is wrong, unless it is quite a slow link or server.
+	 */
 	if ((now - midEntry->when_alloc) > HZ) {
 		if ((cifsFYI & CIFS_TIMER) &&
-		   (midEntry->command != SMB_COM_LOCKING_ANDX)) {
-			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %d",
+		    (midEntry->command != cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
+			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
 			       now - midEntry->when_alloc,
@@ -254,8 +256,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }
 
-static int wait_for_free_request(struct TCP_Server_Info *server,
-				 const int long_op)
+static int
+wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 {
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
@@ -326,7 +328,7 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	int error;
 
 	error = wait_event_freezekillable(server->response_q,
-				    midQ->midState != MID_REQUEST_SUBMITTED);
+				    midQ->mid_state != MID_REQUEST_SUBMITTED);
 	if (error < 0)
 		return -ERESTARTSYS;
 
@@ -378,7 +380,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
-	mid->midState = MID_REQUEST_SUBMITTED;
+	mid->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(server);
 	rc = smb_sendv(server, iov, nvec);
@@ -428,11 +430,11 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
-	cFYI(1, "%s: cmd=%d mid=%d state=%d", __func__, mid->command,
-		mid->mid, mid->midState);
+	cFYI(1, "%s: cmd=%d mid=%llu state=%d", __func__,
+	     le16_to_cpu(mid->command), mid->mid, mid->mid_state);
 
 	spin_lock(&GlobalMid_Lock);
-	switch (mid->midState) {
+	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
@@ -447,8 +449,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	default:
 		list_del_init(&mid->qhead);
-		cERROR(1, "%s: invalid mid state mid=%d state=%d", __func__,
-			mid->mid, mid->midState);
+		cERROR(1, "%s: invalid mid state mid=%llu state=%d", __func__,
+		       mid->mid, mid->mid_state);
 		rc = -EIO;
 	}
 	spin_unlock(&GlobalMid_Lock);
@@ -498,7 +500,8 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = be32_to_cpu(mid->resp_buf->smb_buf_length) + 4;
+	struct smb_hdr *hdr = (struct smb_hdr *)mid->resp_buf;
+	unsigned int len = be32_to_cpu(hdr->smb_buf_length) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
@@ -575,7 +578,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_sendv(ses->server, iov, n_vec);
 	cifs_in_send_dec(ses->server);
@@ -597,7 +600,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
@@ -617,15 +620,16 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
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
+	in_buf = (struct smb_hdr *)midQ->resp_buf;
+	iov[0].iov_base = (char *)in_buf;
+	iov[0].iov_len = be32_to_cpu(in_buf->smb_buf_length) + 4;
+	if (midQ->large_buf)
 		*pRespBufType = CIFS_LARGE_BUFFER;
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
@@ -650,6 +654,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc = 0;
 	struct mid_q_entry *midQ;
+	struct smb_hdr *buf;
 
 	if (ses == NULL) {
 		cERROR(1, "Null smb session");
@@ -699,7 +704,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
@@ -717,7 +722,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
@@ -736,14 +741,15 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
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
@@ -787,6 +793,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int rstart = 0;
 	struct mid_q_entry *midQ;
 	struct cifs_ses *ses;
+	struct smb_hdr *buf;
 
 	if (tcon == NULL || tcon->ses == NULL) {
 		cERROR(1, "Null smb session");
@@ -836,7 +843,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	cifs_in_send_dec(ses->server);
@@ -850,13 +857,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
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
 
@@ -886,7 +893,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) {
 			send_nt_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
-			if (midQ->midState == MID_REQUEST_SUBMITTED) {
+			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
@@ -904,14 +911,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
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
