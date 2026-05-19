Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9EF3A962B
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186178; cv=none; b=a/sKfgGVS/RcQV3SGta3GK+MRJ9rEO4fCrJKIwJvIXwmertBZKDm1WjQMJzHniUABtmcITH9AuVq+hZrIWrLsn0Kt7kEJG3MnjUiTOReA+I9e8aiY1ciDMHyT2AksL1ghOnt5HNOyHw8w7haZfDfGHQzA0ovhNnP1/Cn9k9s1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186178; c=relaxed/simple;
	bh=IFI/NWmdMMC+KvK7r97V6VdqnXUhZU1xg+qh2gUWSJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8CmSur9PsrpNQgjptLh+Hsig4I7Bds4oZ/k7VDntl3A61gDgyn4PMQJWH5Q/OcT4E/R/1ZXxZffFR6fw5s/8bc0QS93OyBe5Xy4ZHBTbTci6Jhrwpq5D905uRm05LkfKZK64cnyjrI8WEQMVsVNaPp+WNAl2m4OkJwIoteJck0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YeiQsz9p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeiQsz9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1FKNP+/i6bUXYcLLW3klf3x7a+ni5hzdhBlCQcUPUeQ=;
	b=YeiQsz9p1zwKVsZZwLq2F3dhDtpgpVhEtsKA01RyZvW603wyRlOZcRLrzyiRFgzhGUuY7L
	9maPDXXeqfMZW80r9vUhL2gF1IuHWVScPrYH9KD3oHfz+fonjgXvrurjzULzKDMcuQYkSg
	k55YA63VYBv3w6sohqrZ6EDtuiUYvzA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-jmtsLVISM0CA9OLkZ2---g-1; Tue,
 19 May 2026 06:22:51 -0400
X-MC-Unique: jmtsLVISM0CA9OLkZ2---g-1
X-Mimecast-MFC-AGG-ID: jmtsLVISM0CA9OLkZ2---g_1779186170
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16518195609E;
	Tue, 19 May 2026 10:22:50 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BA41E180034E;
	Tue, 19 May 2026 10:22:46 +0000 (UTC)
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
Subject: [RFC PATCH 09/36] cifs: Institute message managing struct
Date: Tue, 19 May 2026 11:21:27 +0100
Message-ID: <20260519102158.592165-10-dhowells@redhat.com>
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

Turn the smb_message struct into a message handling struct to aid in
building an SMB message, queuing them and holding the resources and
buffers.  It has absorbed the mid_q_struct and now other fields are added.

The idea is that the smb_message struct will be allocated and filled in
much higher up (typically in the PDU encoding code) and passed down to the
transport.

In particular, the following fields:

 (*) ->next: This is used to link together messages into compounds and then
     walk through the message list.

 (*) ->credits: The credit requirements for the message.

 (*) ->request: Pointer to the smb_hdr struct for the request.

 (*) ->command_trace: An ID of the command type for use in tracing.

 (*) ->total_len: The total length of the request message, not including
     rfc1002 or transform headers.

 (*) ->response: Pointer to the smb_hdr struct for the response.

 (*) ->rqst, ->resp_buf_type, ->resp_iov: The old request info stuff.

Functions are provided to get and put refs upon the struct and also to drop
all the refs on a compound string of structs.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h      | 104 ++++++++++++++++++++++++----------
 fs/smb/client/cifsproto.h     |  11 ++--
 fs/smb/client/connect.c       |   6 +-
 fs/smb/client/smb1ops.c       |   2 +-
 fs/smb/client/smb1transport.c |   2 +-
 fs/smb/client/smb2ops.c       |   2 +-
 fs/smb/client/smb2transport.c |   4 +-
 fs/smb/client/transport.c     |  42 +++++++++++++-
 8 files changed, 127 insertions(+), 46 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a5e12a2eefdd..0f876feb0dbf 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1701,40 +1701,82 @@ typedef void (*mid_callback_t)(struct TCP_Server_Info *srv, struct smb_message *
 typedef int (*mid_handle_t)(struct TCP_Server_Info *server,
 			    struct smb_message *smb);
 
-/* one of these for every pending CIFS request to the server */
+/*
+ * Definition of an SMB request message to be transmitted.  These may be
+ * chained together and will automatically be turned into compound messages if
+ * they are.
+ *
+ *	+-----------------------+
+ *	| NetBIOS/padding	|
+ *	+-----------------------+ <--- smb->request + pre_offset
+ *	| (Transform header)	|
+ *	+-----------------------+ <--- smb->request
+ *	| SMB2 Header		| }				 }
+ *	+-----------------------+ } header_size			 }
+ *	| Req/Rsp struct	| }				 }
+ *	+-----------------------+ <--- smb->request + ext_offset } protocol_size
+ *	|			|				 }
+ *	| Extra protocol data	|				 }
+ *	|			|				 }
+ *	+-----------------------+ <--- smb->request + smb->data_offset
+ *	|			|
+ *	| Data Payload		|  data_size
+ *	|			|
+ *	+-----------------------+
+ *
+ *
+ * If the data is to be RDMA'd, it will be kept separate from the protocol.
+ */
 struct smb_message {
-	struct list_head qhead;	/* mids waiting on reply from this server */
-	refcount_t refcount;
-	__u64 mid;		/* multiplex id */
-	__u16 credits;		/* number of credits consumed by this mid */
-	__u16 credits_received;	/* number of credits from the response */
-	__u32 pid;		/* process id */
-	__u32 sequence_number;  /* for CIFS signing */
-	unsigned int sr_flags;	/* Flags passed to send_recv() */
-	unsigned long when_alloc;  /* when mid was created */
+	struct smb_message	*next;		/* Next message in compound */
+	struct cifs_credits	credits;	/* Credit requirements for this message */
+	void			*request;	/* Pointer to request message body */
+	refcount_t		ref;
+	bool			sensitive;	/* Request contains sensitive data */
+	bool			cancelled;	/* T if cancelled */
+	unsigned int		sr_flags;	/* Flags passed to send_recv() */
+
+	/* Queue state */
+	struct list_head	qhead;		/* mids waiting on reply from this server */
+	__u64			mid;		/* multiplex id */
+	__u16			credits_consumed; /* number of credits consumed by this op */
+	__u16			credits_received; /* number of credits from the response */
+	__u32			pid;		/* process id */
+	__u32			sequence_number;  /* for CIFS signing */
+	unsigned long		when_alloc;	/* when mid was created */
 #ifdef CONFIG_CIFS_STATS2
-	unsigned long when_sent; /* time when smb send finished */
-	unsigned long when_received; /* when demux complete (taken off wire) */
+	unsigned long		when_sent;	/* time when smb send finished */
+	unsigned long		when_received;	/* when demux complete (taken off wire) */
 #endif
-	mid_receive_t receive;	/* call receive callback */
-	mid_callback_t callback; /* call completion callback */
-	mid_handle_t handle;	/* call handle mid callback */
-	void *callback_data;	  /* general purpose pointer for callback */
-	struct task_struct *creator;
-	void *resp_buf;		/* pointer to received SMB header */
-	unsigned int resp_buf_size;
-	u32 response_pdu_len;
-	int mid_state;	/* wish this were enum but can not pass to wait_event */
-	int mid_rc;		/* rc for MID_RC */
-	__le16 command;		/* smb command code */
-	unsigned int optype;	/* operation type */
-	spinlock_t mid_lock;
-	bool wait_cancelled:1;  /* Cancelled while waiting for response */
-	bool deleted_from_q:1;  /* Whether Mid has been dequeued frem pending_mid_q */
-	bool large_buf:1;	/* if valid response, is pointer to large buf */
-	bool multiRsp:1;	/* multiple trans2 responses for one request  */
-	bool multiEnd:1;	/* both received */
-	bool decrypted:1;	/* decrypted entry */
+	mid_receive_t		receive;	/* call receive callback */
+	mid_callback_t		callback;	/* call completion callback */
+	mid_handle_t		handle;		/* call handle mid callback */
+	void			*callback_data;	/* general purpose pointer for callback */
+	struct task_struct	*creator;
+	void			*resp_buf;	/* pointer to received SMB header */
+	unsigned int		resp_buf_size;
+	int			mid_state;	/* wish this were enum but can not pass to wait_event */
+	int			mid_rc;		/* rc for MID_RC */
+	unsigned int		optype;		/* operation type */
+	spinlock_t		mid_lock;
+	bool			wait_cancelled:1;  /* Cancelled while waiting for response */
+	bool			deleted_from_q:1;  /* Mid has been dequeued from pending_mid_q */
+	bool			large_buf:1;	/* if valid response, is pointer to large buf */
+	bool			multiRsp:1;	/* multiple trans2 responses for one request  */
+	bool			multiEnd:1;	/* both received */
+	bool			decrypted:1;	/* decrypted entry */
+
+	/* Request details */
+	u8			command_trace;	/* enum smb_command_trace - Command trace ID */
+	__le16			command;	/* smb command code */
+	s16			pre_offset;	/* Offset of pre-headers from ->body (negative) */
+	unsigned int		total_len;	/* Total length of from hdr_offset onwards */
+	/* Response */
+	u32			response_pdu_len; /* Size of response PDU */
+	/* Compat with old code */
+	struct smb_rqst		rqst;
+	int			*resp_buf_type;
+	struct kvec		*resp_iov;
 };
 
 struct close_cancelled_open {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f88ae04af85d..9c60fffcf53d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -81,6 +81,10 @@ char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 			      struct cifs_tcon *tcon, int add_treename);
 char *cifs_build_devname(char *nodename, const char *prepath);
 void delete_mid(struct TCP_Server_Info *server, struct smb_message *smb);
+struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp);
+void smb_get_message(struct smb_message *smb);
+void smb_put_message(struct smb_message *smb);
+void smb_put_messages(struct smb_message *smb);
 void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 void cifs_wake_up_task(struct TCP_Server_Info *server,
 		       struct smb_message *smb);
@@ -470,14 +474,9 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
-static inline void smb_get_mid(struct smb_message *smb)
-{
-	refcount_inc(&smb->refcount);
-}
-
 static inline void release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	if (refcount_dec_and_test(&smb->refcount))
+	if (refcount_dec_and_test(&smb->ref))
 		__release_mid(server, smb);
 }
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 97de3ae68d7a..3d7e279ba149 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -327,7 +327,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
-		smb_get_mid(smb);
+		smb_get_message(smb);
 		if (smb->mid_state == MID_REQUEST_SUBMITTED)
 			smb->mid_state = MID_RETRY_NEEDED;
 		list_move(&smb->qhead, &retry_list);
@@ -884,7 +884,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 */
 			spin_lock(&server->mid_queue_lock);
 			list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
-				smb_get_mid(smb);
+				smb_get_message(smb);
 				list_move(&smb->qhead, &dispose_list);
 				smb->deleted_from_q = true;
 			}
@@ -1103,7 +1103,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			smb = list_entry(tmp, struct smb_message, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", smb->mid);
-			smb_get_mid(smb);
+			smb_get_message(smb);
 			smb->mid_state = MID_SHUTDOWN;
 			list_move(&smb->qhead, &dispose_list);
 			smb->deleted_from_q = true;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index c1c16f6346fb..df74975374ee 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -254,7 +254,7 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 		if (compare_mid(smb->mid, buf) &&
 		    smb->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(smb->command) == buf->Command) {
-			smb_get_mid(smb);
+			smb_get_message(smb);
 			spin_unlock(&server->mid_queue_lock);
 			return smb;
 		}
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index c2d211a62577..f38fe262c7ea 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -45,7 +45,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
 	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
 	memset(smb, 0, sizeof(struct smb_message));
-	refcount_set(&smb->refcount, 1);
+	refcount_set(&smb->ref, 1);
 	spin_lock_init(&smb->mid_lock);
 	smb->mid = get_mid(smb_buffer);
 	smb->pid = current->pid;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 236eb560bdff..f39074d0e4a0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -416,7 +416,7 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 		if ((smb->mid == wire_mid) &&
 		    (smb->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (smb->command == shdr->Command)) {
-			smb_get_mid(smb);
+			smb_get_message(smb);
 			if (dequeue) {
 				list_del_init(&smb->qhead);
 				smb->deleted_from_q = true;
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index a28b66ead690..f5b676802ce7 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -619,10 +619,10 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 
 	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
 	memset(smb, 0, sizeof(*smb));
-	refcount_set(&smb->refcount, 1);
+	refcount_set(&smb->ref, 1);
 	spin_lock_init(&smb->mid_lock);
 	smb->mid = le64_to_cpu(shdr->MessageId);
-	smb->credits = credits > 0 ? credits : 1;
+	smb->credits_consumed = credits > 0 ? credits : 1;
 	smb->pid = current->pid;
 	smb->command = shdr->Command; /* Always LE */
 	smb->when_alloc = jiffies;
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 622f63779de0..3ea52cf4a64b 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -30,6 +30,46 @@
 #include "smbdirect.h"
 #include "compress.h"
 
+struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
+{
+	struct smb_message *smb;
+
+	smb = mempool_alloc(&smb_message_pool, gfp);
+	if (smb) {
+		memset(smb, 0, sizeof(*smb));
+		refcount_set(&smb->ref, 1);
+		smb->command_trace = cmd;
+	}
+	return smb;
+}
+
+void smb_get_message(struct smb_message *smb)
+{
+	refcount_inc(&smb->ref);
+}
+
+/*
+ * Drop a ref on a message.  This does not touch the chained messages.
+ */
+void smb_put_message(struct smb_message *smb)
+{
+	if (refcount_dec_and_test(&smb->ref))
+		mempool_free(smb, &smb_message_pool);
+}
+
+/*
+ * Dispose of a chain of compound messages.
+ */
+void smb_put_messages(struct smb_message *smb)
+{
+	struct smb_message *next;
+
+	for (; smb; smb = next) {
+		next = smb->next;
+		smb_put_message(smb);
+	}
+}
+
 void
 cifs_wake_up_task(struct TCP_Server_Info *server, struct smb_message *smb)
 {
@@ -722,7 +762,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	rc = smb_send_rqst(server, 1, rqst, flags);
 
 	if (rc < 0) {
-		revert_current_mid(server, smb->credits);
+		revert_current_mid(server, smb->credits_consumed);
 		server->sequence_number -= 2;
 		delete_mid(server, smb);
 	}

