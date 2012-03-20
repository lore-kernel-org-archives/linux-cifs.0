From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 10/10] CIFS: Change mid_q_entry structure fields
Date: Tue, 20 Mar 2012 13:00:40 +0300
Message-ID: <1332237640-10145-11-git-send-email-piastry@etersoft.ru>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to be protocol-unspecific and big enough to keep both CIFS
and SMB2 values.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   20 +++++++++---------
 fs/cifs/cifsglob.h   |   10 ++++----
 fs/cifs/cifssmb.c    |   12 +++++-----
 fs/cifs/connect.c    |   22 ++++++++++----------
 fs/cifs/misc.c       |    2 +-
 fs/cifs/transport.c  |   52 +++++++++++++++++++++++++-------------------------
 6 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index bcd0db7..81be263 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -80,15 +80,15 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
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
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b213458..d5ccd46 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -731,8 +731,8 @@ typedef void (mid_callback_t)(struct mid_q_entry *mid);
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	__u16 mid;		/* multiplex id */
-	__u16 pid;		/* process id */
+	__u64 mid;		/* multiplex id */
+	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
 	unsigned long when_alloc;  /* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
@@ -743,9 +743,9 @@ struct mid_q_entry {
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	  /* general purpose pointer for callback */
 	void *resp_buf;		/* pointer to received SMB header */
-	int midState;	/* wish this were enum but can not pass to wait_event */
-	__u8 command;	/* smb command code */
-	bool largeBuf:1;	/* if valid response, is pointer to large buf */
+	int mid_state;	/* wish this were enum but can not pass to wait_event */
+	__le16 command;		/* smb command code */
+	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c45d445..f0b1c59 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1467,7 +1467,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	pgoff_t eof_index;
 	struct page *page, *tpage;
 
-	cFYI(1, "%s: mid=%u offset=%llu bytes=%u", __func__,
+	cFYI(1, "%s: mid=%llu offset=%llu bytes=%u", __func__,
 		mid->mid, rdata->offset, rdata->bytes);
 
 	/*
@@ -1665,10 +1665,10 @@ cifs_readv_callback(struct mid_q_entry *mid)
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
@@ -2086,7 +2086,7 @@ cifs_writedata_alloc(unsigned int nr_pages)
 }
 
 /*
- * Check the midState and signature on received buffer (if any), and queue the
+ * Check the mid_state and signature on received buffer (if any), and queue the
  * workqueue completion task.
  */
 static void
@@ -2097,7 +2097,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 	unsigned int written;
 	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
 
-	switch (mid->midState) {
+	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		wdata->result = cifs_check_receive(mid, tcon->ses->server, 0);
 		if (wdata->result != 0)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 07cf97e..b10c106 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -143,8 +143,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
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
@@ -575,8 +575,8 @@ find_mid(struct TCP_Server_Info *server, char *buffer)
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
@@ -593,9 +593,9 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
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
@@ -622,13 +622,13 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
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
@@ -684,8 +684,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
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
@@ -693,7 +693,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Callback mid 0x%x", mid_entry->mid);
+			cFYI(1, "Callback mid 0x%llx", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 		}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d2ccce8..425e4f2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -268,7 +268,7 @@ __u64 GetNextMid(struct TCP_Server_Info *server)
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
 			if (mid_entry->mid == cur_mid &&
-			    mid_entry->midState == MID_REQUEST_SUBMITTED) {
+			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 66b4ede..0961336 100644
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
@@ -97,8 +97,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	   something is wrong, unless it is quite a slow link or server */
 	if ((now - midEntry->when_alloc) > HZ) {
 		if ((cifsFYI & CIFS_TIMER) &&
-		   (midEntry->command != SMB_COM_LOCKING_ANDX)) {
-			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %d",
+		    (midEntry->command != cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
+			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
 			       now - midEntry->when_alloc,
@@ -341,7 +341,7 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	int error;
 
 	error = wait_event_freezekillable(server->response_q,
-				    midQ->midState != MID_REQUEST_SUBMITTED);
+				    midQ->mid_state != MID_REQUEST_SUBMITTED);
 	if (error < 0)
 		return -ERESTARTSYS;
 
@@ -404,7 +404,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
-	mid->midState = MID_REQUEST_SUBMITTED;
+	mid->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(server);
 	rc = smb_sendv(server, iov, nvec);
@@ -454,11 +454,11 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
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
@@ -473,8 +473,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
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
@@ -616,7 +616,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		return rc;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_sendv(ses->server, iov, n_vec);
 	cifs_in_send_dec(ses->server);
@@ -638,7 +638,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_nt_cancel(ses->server, (struct smb_hdr *)buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
@@ -656,7 +656,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		return rc;
 	}
 
-	if (!midQ->resp_buf || midQ->midState != MID_RESPONSE_RECEIVED) {
+	if (!midQ->resp_buf || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cFYI(1, "Bad MID state?");
 		goto out;
@@ -665,7 +665,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	buf = (char *)midQ->resp_buf;
 	iov[0].iov_base = buf;
 	iov[0].iov_len = get_rfc1002_length(buf) + 4;
-	if (midQ->largeBuf)
+	if (midQ->large_buf)
 		*pRespBufType = CIFS_LARGE_BUFFER;
 	else
 		*pRespBufType = CIFS_SMALL_BUFFER;
@@ -737,7 +737,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
@@ -755,7 +755,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->midState == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
@@ -772,7 +772,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	if (!midQ->resp_buf || !out_buf ||
-	    midQ->midState != MID_RESPONSE_RECEIVED) {
+	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
 		goto out;
@@ -871,7 +871,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	midQ->midState = MID_REQUEST_SUBMITTED;
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	cifs_in_send_dec(ses->server);
@@ -885,13 +885,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
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
 
@@ -921,7 +921,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) {
 			send_nt_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
-			if (midQ->midState == MID_REQUEST_SUBMITTED) {
+			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
@@ -939,7 +939,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	/* rcvd frame is ok */
-	if (out_buf == NULL || midQ->midState != MID_RESPONSE_RECEIVED) {
+	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
 		cERROR(1, "Bad MID state?");
 		goto out;
-- 
1.7.1
