Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E814DC536
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186253; cv=none; b=IdoiZ5pGYEKYLFnlGR85rHHmMmVPawSuD6fC8At3ppMl8OlhmaSFNe1ne+XE0qdBZ6ZS03dUQX1TVGci03n+xHMZo3zoJfNx8cYakmAAfGGdRHYXguGBvAFFYCk+2FpiRTkL+bGGWqGQYoHrsusUOBK+dIO65G+NrnudUYwr4Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186253; c=relaxed/simple;
	bh=faGQwSUM6yKBa2MK0bDX+e2+5HxnYhgUgJ/1CbQpodo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P33ytld9gzrFO/AXgg59keOQTsT/9W84pfL2RoS6JvSDJgDeJMTIgptC5NpXZJQqbTC88Us2mBTPeNm0EBd858Fko8/pQHR+rO7fgYsqBKIBp7cuSd92TM+6QfKFRePXQ5QjVXewcl4kwxkzaDNJhsBscoPeS3N6lI600fXvKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MOcs7Nrb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MOcs7Nrb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3jXBvMO59PswYv8ZOap0e6qgARMkc/adUXKXvMftmQ=;
	b=MOcs7NrbQFTXQQ23/HsHW/u3PJYxyD4IpUwm7CcrZkYMryaUbnvPcsQ29IH6RZ247wsR4N
	QTf6/mCaNp7a42M49PZ7BYKZx79bfOTT7IKWYHIc0Xq7xRyyz+V46Upx9duaAT243JCD4c
	0MCc6xadY7Ac2ae/n+bkYEEOEDFECRI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-8En05Y8GNeuIRCIk4Cm67Q-1; Tue,
 19 May 2026 06:24:02 -0400
X-MC-Unique: 8En05Y8GNeuIRCIk4Cm67Q-1
X-Mimecast-MFC-AGG-ID: 8En05Y8GNeuIRCIk4Cm67Q_1779186239
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 585C41956050;
	Tue, 19 May 2026 10:23:59 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 324C51800576;
	Tue, 19 May 2026 10:23:55 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 23/36] cifs: Clean up mid->callback_data and kill off mid->creator
Date: Tue, 19 May 2026 11:21:41 +0100
Message-ID: <20260519102158.592165-24-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

We shouldn't really be pinning a task_struct on the mid_q_struct.  Better
to provide a wait queue there and have the waiter wait on it.  For
synchronous operations, this allows them to remove themselves from it once
this is absorbed into smb_message and smb_message is generated higher up
the stack.  This also gets rid of one of the uses of mid->callback_data.

We can also get rid of the need for callback_data for the Echo command
callback by passing a server pointer down into ->callback() from the
callers (all of which have it available).  This can also be used in the
Read and Write callbacks.

We then only need the callback_data for the Read and Write commands - and
in both cases, it points to a cifs_io_subrequest struct.  So replace
callback_data with a specifically typed pointer in a union that other users
can be added to as the need arises.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifs_debug.c    |  3 +--
 fs/smb/client/cifsglob.h      | 11 ++++++++---
 fs/smb/client/cifssmb.c       |  7 ++-----
 fs/smb/client/smb1debug.c     |  7 ++++---
 fs/smb/client/smb2ops.c       |  5 +++--
 fs/smb/client/smb2pdu.c       |  9 ++++-----
 fs/smb/client/smb2transport.c |  6 ------
 fs/smb/client/transport.c     |  7 +++----
 8 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 47dadab67440..0e3e790bbdbc 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -659,11 +659,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					   chan_server->conn_id);
 				spin_lock(&chan_server->mid_queue_lock);
 				list_for_each_entry(smb, &chan_server->pending_mid_q, qhead) {
-					seq_printf(m, "\n\t\tState: %d com: %d pid: %d cbdata: %p mid %llu",
+					seq_printf(m, "\n\t\tState: %d com: %d pid: %d mid %llu",
 						   smb->mid_state,
 						   le16_to_cpu(smb->command),
 						   smb->pid,
-						   smb->callback_data,
 						   smb->mid);
 				}
 				spin_unlock(&chan_server->mid_queue_lock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6b90f17ae0fa..3a2f684cede9 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1636,7 +1636,8 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
  */
-typedef void (*mid_callback_t)(struct TCP_Server_Info *srv, struct smb_message *smb);
+typedef void (*mid_callback_t)(struct TCP_Server_Info *server,
+			       struct smb_message *smb);
 
 /*
  * Definition of an SMB request message to be transmitted.  These may be
@@ -1668,12 +1669,18 @@ struct smb_message {
 	struct smb_message	*next;		/* Next message in compound */
 	struct cifs_credits	credits;	/* Credit requirements for this message */
 	void			*request;	/* Pointer to request message body */
+	wait_queue_head_t	waitq;		/* Wait queue for message events */
 	refcount_t		ref;
 	unsigned int		debug_id;	/* Debugging ID for tracing */
 	bool			sensitive;	/* Request contains sensitive data */
 	bool			cancelled;	/* T if cancelled */
 	unsigned int		sr_flags;	/* Flags passed to send_recv() */
 
+	/* PDU-type specific data */
+	union {
+		struct cifs_io_subrequest *subreq; /* Read/write subrequest */
+	};
+
 	/* Queue state */
 	struct list_head	qhead;		/* mids waiting on reply from this server */
 	__u64			mid;		/* multiplex id */
@@ -1687,8 +1694,6 @@ struct smb_message {
 	unsigned long		when_received;	/* when demux complete (taken off wire) */
 #endif
 	mid_callback_t		callback;	/* call completion callback */
-	void			*callback_data;	/* general purpose pointer for callback */
-	struct task_struct	*creator;
 	int			mid_state;	/* wish this were enum but can not pass to wait_event */
 	int			mid_rc;		/* rc for MID_RC */
 	unsigned int		optype;		/* operation type */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index ca6410e1f39e..e36828359f67 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -737,7 +737,6 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	smb->request		= req;
 	smb->total_len		= in_len;
 	smb->callback		= cifs_echo_callback;
-	smb->callback_data	= server;
 
 	rc = cifs_call_async(server, smb, CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL);
 	if (rc)
@@ -1428,7 +1427,7 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 static void
 cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *rdata = smb->callback_data;
+	struct cifs_io_subrequest *rdata = smb->subreq;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct inode *inode = &ictx->inode;
@@ -1595,7 +1594,6 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 	smb->request		= req;
 	smb->total_len		= in_len;
 	smb->callback		= cifs_readv_callback;
-	smb->callback_data	= rdata;
 	smb->copy_to_bufs	= true;
 
 	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
@@ -1860,7 +1858,7 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 static void
 cifs_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *wdata = smb->callback_data;
+	struct cifs_io_subrequest *wdata = smb->subreq;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	WRITE_RSP *rsp = (WRITE_RSP *)smb->response;
 	struct cifs_credits credits = {
@@ -1975,7 +1973,6 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 	smb->total_len		= in_len + 1;
 	smb->total_len		+= wdata->subreq.len;
 	smb->callback		= cifs_writev_callback;
-	smb->callback_data	= wdata;
 
 	iov_iter_bvec_queue(&smb->rqst.rq_iter, ITER_DEST,
 			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
diff --git a/fs/smb/client/smb1debug.c b/fs/smb/client/smb1debug.c
index 048fe6303bc1..6eb87852bce7 100644
--- a/fs/smb/client/smb1debug.c
+++ b/fs/smb/client/smb1debug.c
@@ -40,11 +40,12 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 			.data_offset	= smb->resp_data_offset,
 		};
 
-		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
+		cifs_dbg(VFS, "State: %d Cmd: %x Pid: %d R=%x[%x] Mid %llu\n",
 			 smb->mid_state,
-			 le16_to_cpu(smb->command),
+			 le32_to_cpu(smb->command),
 			 smb->pid,
-			 smb->callback_data,
+			 smb->subreq ? smb->subreq->rreq->debug_id : 0,
+			 smb->subreq ? smb->subreq->subreq.debug_index : 0,
 			 smb->mid);
 #ifdef CONFIG_CIFS_STATS2
 		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0aaefe901fbd..b655c0f626f5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -485,11 +485,12 @@ void smb2_dump_mids(struct TCP_Server_Info *server)
 			.data_offset	= smb->resp_data_offset,
 		};
 
-		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
+		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d R=%x[%x] Mid %llu\n",
 			 smb->mid_state,
 			 smb->command,
 			 smb->pid,
-			 smb->callback_data,
+			 smb->subreq ? smb->subreq->rreq->debug_id : 0,
+			 smb->subreq ? smb->subreq->subreq.debug_index : 0,
 			 smb->mid);
 #ifdef CONFIG_CIFS_STATS2
 		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2a234df2fad5..f4ea7256b09d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4386,7 +4386,6 @@ SMB2_echo(struct TCP_Server_Info *server)
 	smb->request		= req;
 	smb->total_len		= total_len;
 	smb->callback		= smb2_echo_callback;
-	smb->callback_data	= server;
 
 	req->hdr.CreditRequest = cpu_to_le16(1);
 
@@ -4629,7 +4628,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 static void
 smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *rdata = smb->callback_data;
+	struct cifs_io_subrequest *rdata = smb->subreq;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct smb2_hdr *shdr = smb->response;
@@ -4828,7 +4827,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	smb->request		= buf;
 	smb->total_len		= total_len;
 	smb->callback		= smb2_readv_callback;
-	smb->callback_data	= rdata;
+	smb->subreq		= rdata;
 	smb->copy_to_bufs	= true;
 
 	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
@@ -4981,7 +4980,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 static void
 smb2_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *wdata = smb->callback_data;
+	struct cifs_io_subrequest *wdata = smb->subreq;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)smb->response;
 	struct cifs_credits credits = {
@@ -5160,7 +5159,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	smb->request		= req;
 	smb->total_len		= total_len;
 	smb->callback		= smb2_writev_callback;
-	smb->callback_data	= wdata;
+	smb->subreq		= wdata;
 
 	iov_iter_bvec_queue(&smb->rqst.rq_iter, ITER_SOURCE,
 			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 73db90ab8a52..14ee09b33f2c 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -611,12 +611,6 @@ static void smb2_init_mid(struct smb_message *smb,
 
 	smb->credits_consumed = credits > 0 ? credits : 1;
 
-	/*
-	 * The default is for the mid to be synchronous, so the
-	 * default callback just wakes up the current task.
-	 */
-	smb->creator = get_task_struct(current);
-
 	atomic_inc(&mid_count);
 	trace_smb3_cmd_enter(le32_to_cpu(shdr->Id.SyncId.TreeId),
 			     le64_to_cpu(shdr->SessionId),
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 0a7b2e7922cf..68536de2c1a0 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -53,8 +53,8 @@ struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 		 * callback just wakes up the current task.
 		 */
 		smb->callback		= cifs_wake_up_task;
-		smb->callback_data	= current;
 		smb->mid_state		= MID_REQUEST_ALLOCATED;
+		init_waitqueue_head(&smb->waitq);
 		trace_smb3_message(smb->debug_id, 1, (enum smb_message_trace)cmd);
 	}
 	return smb;
@@ -122,7 +122,7 @@ cifs_wake_up_task(struct TCP_Server_Info *server, struct smb_message *smb)
 	if (smb->mid_state == MID_RESPONSE_RECEIVED)
 		smb->mid_state = MID_RESPONSE_READY;
 	smb_see_message(smb, smb_message_trace_see_wake_up_task);
-	wake_up_process(smb->callback_data);
+	wake_up_all(&smb->waitq);
 }
 
 static void smb_clear_mid(struct TCP_Server_Info *server, struct smb_message *smb)
@@ -199,7 +199,6 @@ static void smb_clear_mid(struct TCP_Server_Info *server, struct smb_message *sm
 		}
 	}
 #endif
-	put_task_struct(smb->creator);
 }
 
 static bool discard_message(struct TCP_Server_Info *server, struct smb_message *smb)
@@ -901,7 +900,7 @@ int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb)
 	if (smb->sr_flags & CIFS_INTERRUPTIBLE_WAIT)
 		sleep_state = TASK_INTERRUPTIBLE;
 
-	error = wait_event_state(server->response_q,
+	error = wait_event_state(smb->waitq,
 				 smb->mid_state != MID_REQUEST_SUBMITTED &&
 				 smb->mid_state != MID_RESPONSE_RECEIVED,
 				 (sleep_state | TASK_FREEZABLE_UNSAFE));

