Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949E4DD6E3
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186257; cv=none; b=RBVZSOBcUHCj/Z7vO66mebLzLyZF08kIqXrEEGHM9gVFs0k3+hmzL/KWI7vYF5rXC6aUYRk9DN3le6kaJc0V7JiuEXV1LjV2WHjDHgCeLSPsBMMZMI0PzDgQ8fkOxU4eoLEDoHYhStbt1OgUhkQdkAQBYDQfhFqJjoPoHbHA6pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186257; c=relaxed/simple;
	bh=f4WRxdG84N2etKy2a2qq15CIkzWzlT8hx2eMOULwSn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzqWqAzhmzdH1y6wgETxs+Z3mz6vQ4zvAzNS9aUTMa4VJlcjYvyvFqsaZfXZmfmmEHHdHlIZK0p6RK52fgjFeT0babGgUcBosfStjxnrmJYYwXzgFOUakDotsmCI0yEN3EmwIbU4HoK7FBfBWJaU4bnMBIx1VUZKg5HNQw/CdPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZkURQvC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZkURQvC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRBRzV+xax35OqnhgX9Zi8VtyvNmu1xd2MyN2serIt0=;
	b=WZkURQvCPxIRh4Hk+7ecYloiF3U/ECstrP5ISBx5+aHWqe7Gb2cGMNsQry0LPpO5GByWWD
	Zf24iJhFlRTp9EhzTo3RUXBdVWbYousI7X0XZIhJfcCrENLEjkZBe/t36E//g8e9dl9sxk
	sOIqWMl0fynlqK4dRNgB21Oz4R3NTYA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-_Rg32EOZPjK8yVRB3LAadQ-1; Tue,
 19 May 2026 06:24:11 -0400
X-MC-Unique: _Rg32EOZPjK8yVRB3LAadQ-1
X-Mimecast-MFC-AGG-ID: _Rg32EOZPjK8yVRB3LAadQ_1779186249
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 659AC1956053;
	Tue, 19 May 2026 10:24:09 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF9351800352;
	Tue, 19 May 2026 10:24:05 +0000 (UTC)
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
Subject: [RFC PATCH 25/36] cifs: Add more pieces to smb_message
Date: Tue, 19 May 2026 11:21:43 +0100
Message-ID: <20260519102158.592165-26-dhowells@redhat.com>
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

Add more pieces to the smb_message struct to facilitate future changes.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h      |  10 ++
 fs/smb/client/cifsproto.h     |  18 +++
 fs/smb/client/smb2misc.c      |  15 +++
 fs/smb/client/smb2ops.c       |  10 ++
 fs/smb/client/smb2pdu.c       | 202 ++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2proto.h     |   1 +
 fs/smb/client/smb2transport.c | 122 ++++++++++++++------
 fs/smb/client/transport.c     |  89 +++++++++++----
 8 files changed, 413 insertions(+), 54 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3a2f684cede9..9aa9eb72ec6b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1672,6 +1672,7 @@ struct smb_message {
 	wait_queue_head_t	waitq;		/* Wait queue for message events */
 	refcount_t		ref;
 	unsigned int		debug_id;	/* Debugging ID for tracing */
+	bool			new_style;	/* New style request (not using ->rqst) */
 	bool			sensitive;	/* Request contains sensitive data */
 	bool			cancelled;	/* T if cancelled */
 	unsigned int		sr_flags;	/* Flags passed to send_recv() */
@@ -1711,7 +1712,13 @@ struct smb_message {
 	u8			command_trace;	/* enum smb_command_trace - Command trace ID */
 	__le16			command;	/* smb command code */
 	s16			pre_offset;	/* Offset of pre-headers from ->body (negative) */
+	u16			ext_offset;	/* Offset of extensions from ->body */
+	u16			latest_record;	/* Offset of latest context record (or 0) */
+	u16			offset;		/* Running offset during assembly */
+	u16			data_offset;	/* Offset of data in message (maybe in ->body) */
 	unsigned int		total_len;	/* Total length of from hdr_offset onwards */
+	struct iov_iter		data_iter;	/* Data iterator */
+	struct iov_iter		req_iter;	/* Request iterator */
 	/* Response */
 	//u32			response_pdu_len; /* Size of response PDU */
 	void			*response;	/* Protocol part of response */
@@ -1724,6 +1731,9 @@ struct smb_message {
 	struct bvecq		*response_data;	/* Storage for response data (or NULL) */
 	/* Compat with old code */
 	struct smb_rqst		rqst;
+	/* Variable-length request fragment list - must be last! */
+	struct bvecq		bvecq;		/* List of request frags (passed to socket) */
+	struct bio_vec		__bvecq_bv[3];
 };
 
 struct close_cancelled_open {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3067056f8ef9..bbb59761fb9f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -86,6 +86,7 @@ void smb_see_message(struct smb_message *smb, enum smb_message_trace trace);
 void smb_get_message(struct smb_message *smb, enum smb_message_trace trace);
 void smb_put_message(struct smb_message *smb, enum smb_message_trace trace);
 void smb_put_messages(struct smb_message *smb);
+void smb_clear_request(struct smb_message *smb);
 void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 void cifs_wake_up_task(struct TCP_Server_Info *server,
 		       struct smb_message *smb);
@@ -93,6 +94,9 @@ char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
+int smb_send_recv_messages(const unsigned int xid, struct cifs_ses *ses,
+			   struct TCP_Server_Info *server,
+			   struct smb_message *head_smb, const int flags);
 int cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
 		    const int flags, const struct cifs_credits *exist_credits);
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
@@ -511,4 +515,18 @@ int smb_rxqueue_consume(struct TCP_Server_Info *server, struct netfs_rxqueue *rx
 void *cifs_allocate_tx_buf(struct TCP_Server_Info *server, size_t size);
 void cifs_free_tx_buf(void *p);
 
+/*
+ * Add a segment to a message.  This should be allocated with
+ * cifs_allocate_tx_buf() so that it can be used with MSG_SPLICE_PAGES.
+ */
+static inline void smb_add_segment_to_tx_buf(struct smb_message *smb,
+					     void *buf, size_t size)
+{
+	unsigned int nr = smb->bvecq.nr_slots;
+
+	bvec_set_virt(&smb->bvecq.bv[nr], buf, size);
+	smb->bvecq.nr_slots = nr + 1;
+	smb->total_len += size;
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index d28812107e8f..7c9dc3ede8b8 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -9,6 +9,7 @@
  */
 #include <crypto/sha2.h>
 #include <linux/ctype.h>
+#include <linux/iov_iter.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -836,6 +837,15 @@ smb2_handle_cancelled_mid(struct smb_message *smb, struct TCP_Server_Info *serve
 	return rc;
 }
 
+static size_t smb_sha512_step(void *iter_base, size_t progress, size_t len,
+			      void *priv, void *priv2)
+{
+	struct sha512_ctx *ctx = priv;
+
+	sha512_update(ctx, iter_base, len);
+	return 0;
+}
+
 /**
  * smb311_update_preauth_hash - update @ses hash from the message
  * @ses:	server session structure
@@ -878,6 +888,11 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 
 	if (hash_resp) {
 		sha512_update(&sha_ctx,  smb->response, smb->resp_len);
+	} else if (smb->new_style) {
+		struct iov_iter tmp = smb->req_iter;
+
+		iterate_and_advance_kernel(&tmp, smb->total_len,
+					   &sha_ctx, NULL, smb_sha512_step);
 	} else {
 		struct kvec *iov = smb->rqst.rq_iov;
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b655c0f626f5..f9cefc47d084 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2729,6 +2729,16 @@ smb2_set_replay(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	shdr->Flags |= SMB2_FLAGS_REPLAY_OPERATION;
 }
 
+void smb2_set_replay_smb(struct TCP_Server_Info *server, struct smb_message *smb)
+{
+	struct smb2_hdr *shdr = smb->request;
+
+	if (server->dialect < SMB30_PROT_ID)
+		return;
+
+	shdr->Flags |= SMB2_FLAGS_REPLAY_OPERATION;
+}
+
 void
 smb2_set_related(struct smb_rqst *rqst)
 {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f4ea7256b09d..f907ee4faa3a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -91,6 +91,208 @@ int smb3_encryption_required(const struct cifs_tcon *tcon)
 	return 0;
 }
 
+static void smb2_enc_header(struct smb_message *smb,
+			    const struct cifs_tcon *tcon,
+			    struct TCP_Server_Info *server)
+{
+	struct smb2_hdr *shdr = smb->request;
+	struct smb3_hdr_req *smb3_hdr = (struct smb3_hdr_req *)shdr;
+
+	shdr->ProtocolId	= SMB2_PROTO_NUMBER;
+	shdr->StructureSize	= cpu_to_le16(64);
+	shdr->CreditCharge	= 0;
+	shdr->Status		= 0; /* ChanSeq for smb3 */
+	shdr->Command		= smb->command;
+	shdr->CreditRequest	= cpu_to_le16(2);
+	shdr->Flags		= 0;
+	shdr->NextCommand	= 0;
+	shdr->MessageId		= 0;
+	shdr->Id.SyncId.ProcessId = cpu_to_le32((__u16)current->tgid);
+	shdr->SessionId		= 0;
+
+	if (server) {
+		/* After reconnect SMB3 must set ChannelSequence on subsequent reqs */
+		if (server->dialect >= SMB30_PROT_ID) {
+			/*
+			 * if primary channel is not set yet, use default
+			 * channel for chan sequence num
+			 */
+			if (SERVER_IS_CHAN(server))
+				smb3_hdr->ChannelSequence =
+					cpu_to_le16(server->primary_server->channel_sequence_num);
+			else
+				smb3_hdr->ChannelSequence =
+					cpu_to_le16(server->channel_sequence_num);
+		}
+		spin_lock(&server->req_lock);
+		/* Request up to 10 credits but don't go over the limit. */
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, 10));
+		spin_unlock(&server->req_lock);
+	}
+
+	if (tcon) {
+		/* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
+		/* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
+		if (server && (server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
+			shdr->CreditCharge = cpu_to_le16(1);
+		/* else CreditCharge MBZ */
+
+		shdr->Id.SyncId.TreeId = cpu_to_le32(tcon->tid);
+		/* Uid is not converted */
+		if (tcon->ses)
+			shdr->SessionId = cpu_to_le64(tcon->ses->Suid);
+
+		/*
+		 * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also
+		 * would have to pass the path on the Open SMB prefixed by
+		 * \\server\share.  Not sure when we would need to do the
+		 * augmented path (if ever) and setting this flag breaks the
+		 * SMB2 open operation since it is illegal to send an empty
+		 * path name (without \\server\share prefix) when the DFS flag
+		 * is set in the SMB open header. We could consider setting the
+		 * flag on all operations other than open but it is safer to
+		 * net set it for now.
+		 */
+/*	if (tcon->share_flags & SHI1005_FLAGS_DFS)
+	shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+
+		if (server && server->sign && !smb3_encryption_required(tcon))
+			shdr->Flags |= SMB2_FLAGS_SIGNED;
+	}
+}
+
+/* Flags for smb2_create_request() */
+#define SMB2_REQ_DYNAMIC	0x01	/* Dynamic request */
+#define SMB2_REQ_HEAD		0x02	/* Head of compound */
+#define SMB2_REQ_SENSITIVE	0x04	/* May contain sensitive crypto data */
+
+/*
+ * smb2_create_request: Allocate and set up a request
+ * @command: The command type we're going to issue
+ * @server: The server the command is going to go to
+ * @header_size: The size of the base protocol structure
+ * @protocol_size: The size of the header plus extensions
+ * @data_size: The size of the data payload
+ * @head: If this is the head of a compound
+ * @flags: Mask of SMB2_REQ_* flags
+ *
+ * Create a request and allocate netmem memory to hold the netbios header (if
+ * appropriate) and the protocol part of the message.  Memory will also be
+ * allocated for the data part of the message if this is to be encrypted by the
+ * CPU.  The allocated buffers will be attached to a bvec-queue struct so that
+ * they can be chained together and passed to the socket.
+ */
+static struct smb_message *smb2_create_request(__le16 command,
+					       struct TCP_Server_Info *server,
+					       struct cifs_tcon *tcon,
+					       size_t header_size,
+					       size_t protocol_size,
+					       size_t data_size,
+					       unsigned int flags)
+{
+	struct smb_message *smb;
+	const size_t max_slots = ARRAY_SIZE(smb->__bvecq_bv); // Preallocated slots
+	size_t pre_size;
+	void *body;
+	bool encrypted = false; //, rdma = false;
+	u16 ssize;
+
+	smb = smb_message_alloc(command, GFP_NOFS);
+	if (!smb)
+		return NULL;
+
+	smb->new_style = true; /* I.e. we're not using smb->rqst. */
+	smb->command = command;
+	smb->command_trace = command;
+	smb->sensitive = flags & SMB2_REQ_SENSITIVE;
+
+	/* We allocate space for inter-SMB padding or rfc1002 header plus
+	 * transform headers (as needed), but don't add them in at this time.
+	 */
+	pre_size = 8;
+	if (encrypted)
+		pre_size += sizeof(struct smb2_transform_hdr);
+	smb->pre_offset = -pre_size;
+
+	if (encrypted)
+		/* We want the encrypted blob to be correctly aligned. */
+		pre_size = round_up(pre_size, 16);
+
+	/* Allocate space for the SMB header, the request struct (both in
+	 * header_size) plus any extension bits, bearing in mind that some bits
+	 * may follow the header directly (header_added_size) and some may have
+	 * to be padded to an 8-byte alignment first (extension_size).  The
+	 * Negotiate Request has both.
+	 */
+	smb->ext_offset	 = header_size;
+	smb->offset	 = header_size;
+	smb->data_offset = protocol_size;
+	smb->total_len	 = data_size;
+
+	body = cifs_allocate_tx_buf(server, pre_size + protocol_size);
+	if (!body) {
+		kfree(smb);
+		return NULL;
+	}
+
+	smb->bvecq.max_slots = max_slots;
+	smb_add_segment_to_tx_buf(smb, body + pre_size, protocol_size);
+	smb->request = body + pre_size;
+
+	struct smb2_pdu *spdu = smb->request;
+	memset(spdu, 0, header_size);
+
+	smb2_enc_header(smb, tcon, server);
+	ssize = header_size - sizeof(spdu->hdr);
+	if (flags & SMB2_REQ_DYNAMIC)
+		ssize |= SMB2_STRUCT_HAS_DYNAMIC_PART;
+	spdu->StructureSize2 = cpu_to_le16(ssize);
+
+	if (tcon) {
+		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[command]);
+		cifs_stats_inc(&tcon->num_smbs_sent);
+	}
+
+#if 0
+	/* Include the buffer from the start of the RFC1002 header in the
+	 * iterator, but may need to adjust it later.
+	 */
+	iov_iter_bvec_queue(&smb->iter, ITER_SOURCE, &smb->bvecq, 0,
+			    pre_size, protocol_size);
+#endif
+	return smb;
+}
+
+static void cifs_pad_to_8(struct smb_message *smb)
+{
+	size_t offset = smb->offset;
+	u8 *p = smb->request;
+
+	while (offset & 7)
+		p[offset++] = 0;
+	smb->offset = offset;
+}
+
+/*
+ * Begin adding an extension to a message.  The offset is padded to an 8-byte
+ * alignment;
+ */
+static void *cifs_begin_extension(struct smb_message *smb)
+{
+	cifs_pad_to_8(smb);
+	return smb->request + smb->offset;
+}
+
+static void cifs_end_extension(struct smb_message *smb, size_t size)
+{
+	smb->offset += size;
+}
+
 static void
 smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 		  const struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index bac01d15b94a..6571a6a7b147 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -121,6 +121,7 @@ unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 void smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst);
 void smb2_set_related(struct smb_rqst *rqst);
 void smb2_set_replay(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+void smb2_set_replay_smb(struct TCP_Server_Info *server, struct smb_message *smb);
 bool smb2_should_replay(struct cifs_tcon *tcon, int *pretries,
 			int *pcur_sleep);
 void smb2_add_credits_from_hdr(struct smb2_hdr *shdr,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 14ee09b33f2c..f63eaff4935a 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -207,16 +207,24 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 	return tcon;
 }
 
+static inline size_t smb2_hmac_sha256_step(void *iter_base, size_t progress,
+					   size_t len, void *priv, void *priv2)
+{
+	struct hmac_sha256_ctx *hmac_ctx = priv;
+
+	hmac_sha256_update(hmac_ctx, iter_base, len);
+	return 0;
+}
+
 static int
 smb2_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 		    bool for_recv)
 {
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
-	struct kvec *iov = smb->rqst.rq_iov;
 	struct smb2_hdr *shdr = for_recv ? smb->response : smb->request;
 	struct hmac_sha256_ctx hmac_ctx;
-	struct smb_rqst drqst;
+	size_t size, did;
 	__u64 sid = le64_to_cpu(shdr->SessionId);
 	u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
 
@@ -232,27 +240,32 @@ smb2_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 
 	hmac_sha256_init_usingrawkey(&hmac_ctx, key, sizeof(key));
 
-	/*
-	 * For SMB2+, __cifs_calc_signature() expects to sign only the actual
-	 * data, that is, iov[0] should not contain a rfc1002 length.
-	 *
-	 * Sign the rfc1002 length prior to passing the data (iov[1-N]) down to
-	 * __cifs_calc_signature().
-	 */
-	drqst = smb->rqst;
-	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
-		hmac_sha256_update(&hmac_ctx, iov[0].iov_base, iov[0].iov_len);
-		drqst.rq_iov++;
-		drqst.rq_nvec--;
+	if (smb->new_style) {
+		struct iov_iter req_iter = smb->req_iter;
+
+		size = iov_iter_count(&req_iter);
+		did = iterate_and_advance_kernel(&req_iter, size, &hmac_ctx, NULL,
+						 smb2_hmac_sha256_step);
+		if (did != size)
+			return smb_EIO2(smb_eio_trace_sig_iter, did, size);
+	} else {
+		for (int i = 0; i < smb->rqst.rq_nvec; i++)
+			hmac_sha256_update(&hmac_ctx,
+					   smb->rqst.rq_iov[i].iov_base,
+					   smb->rqst.rq_iov[i].iov_len);
 	}
 
-	rc = __cifs_calc_signature(
-		&drqst, server, smb2_signature,
-		&(struct cifs_calc_sig_ctx){ .hmac = &hmac_ctx });
-	if (!rc)
-		memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
+	struct iov_iter data_iter = smb->data_iter;
 
-	return rc;
+	size = iov_iter_count(&data_iter);
+	did = iterate_and_advance_kernel(&data_iter, size, &hmac_ctx, NULL,
+					 smb2_hmac_sha256_step);
+	if (did != size)
+		return smb_EIO2(smb_eio_trace_sig_iter, did, size);
+
+	hmac_sha256_final(&hmac_ctx, smb2_signature);
+	memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
+	return 0;
 }
 
 static void generate_key(struct cifs_ses *ses, struct kvec label,
@@ -460,17 +473,25 @@ generate_smb311signingkey(struct cifs_ses *ses,
 	return generate_smb3signingkey(ses, server, &triplet);
 }
 
+static inline size_t smb3_aes_cmac_step(void *iter_base, size_t progress,
+					size_t len, void *priv, void *priv2)
+{
+	struct aes_cmac_ctx *cmac_ctx = priv;
+
+	aes_cmac_update(cmac_ctx, iter_base, len);
+	return 0;
+}
+
 static int
 smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 		    bool for_recv)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
-	struct kvec kv;
 	struct smb2_hdr *shdr = for_recv ? smb->response : smb->request;
 	struct aes_cmac_key cmac_key;
 	struct aes_cmac_ctx cmac_ctx;
-	struct smb_rqst drqst;
+	size_t size, did;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
 	if (server->vals->protocol_id <= SMB21_PROT_ID)
@@ -494,22 +515,55 @@ smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 	aes_cmac_init(&cmac_ctx, &cmac_key);
 
 	if (for_recv) {
-		kv.iov_base = smb->response;
-		kv.iov_len  = smb->resp_len;
-		drqst.rq_nvec = 1;
-		drqst.rq_iov  = &kv;
-		drqst.rq_iter = smb->response_iter;
-		iov_iter_truncate(&drqst.rq_iter, smb->resp_data_len);
+		struct iov_iter resp_iter = smb->response_iter;
+
+		size = smb->resp_len;
+		did = 0;
+
+		aes_cmac_update(&cmac_ctx, smb->response, size);
+		rc = -EIO;
+		size = iov_iter_count(&resp_iter);
+		did = iterate_and_advance_kernel(&resp_iter, size, &cmac_ctx,
+						  NULL, smb3_aes_cmac_step);
+		if (did != size)
+			goto eio;
 	} else {
-		drqst = smb->rqst;
+		if (smb->new_style) {
+			struct iov_iter req_iter = smb->req_iter;
+
+			size = iov_iter_count(&req_iter);
+			did = iterate_and_advance_kernel(&req_iter, size,
+							 &cmac_ctx, NULL,
+							 smb3_aes_cmac_step);
+			if (did != size)
+				goto eio;
+		} else {
+			for (int i = 0; i < smb->rqst.rq_nvec; i++) {
+				size = smb->rqst.rq_iov[i].iov_len;
+				aes_cmac_update(&cmac_ctx,
+						smb->rqst.rq_iov[i].iov_base,
+						size);
+			}
+		}
+
+		struct iov_iter data_iter = smb->data_iter;
+
+		size = iov_iter_count(&data_iter);
+		did = iterate_and_advance_kernel(&data_iter, size, &cmac_ctx,
+						 NULL, smb3_aes_cmac_step);
+		if (did != size)
+			return smb_EIO2(smb_eio_trace_sig_iter, did, size);
 	}
 
-	rc = __cifs_calc_signature(
-		&drqst, server, smb3_signature,
-		&(struct cifs_calc_sig_ctx){ .cmac = &cmac_ctx });
-	if (!rc)
-		memcpy(shdr->Signature, smb3_signature, SMB2_SIGNATURE_SIZE);
+	aes_cmac_final(&cmac_ctx, smb3_signature);
+
+	memcpy(shdr->Signature, smb3_signature, SMB2_SIGNATURE_SIZE);
+	rc = 0;
+out:
 	return rc;
+eio:
+	smb_EIO2(smb_eio_trace_sig_iter, did, size);
+	goto out;
 }
 
 /* must be called with server->srv_mutex held */
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 1599afb9e5cf..212894c8d2bd 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -67,6 +67,7 @@ struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 		smb->command_trace = cmd;
 		smb->when_alloc	= jiffies;
 		smb->pid	= current->pid;
+		smb->bvecq.bv	= smb->__bvecq_bv;
 
 		/*
 		 * The default is for the mid to be synchronous, so the default
@@ -97,9 +98,26 @@ static void smb_free_message(struct smb_message *smb)
 {
 	trace_smb3_message(smb->debug_id, refcount_read(&smb->ref),
 			   smb_message_trace_free);
+	if (smb->new_style)
+		cifs_free_tx_buf(smb->request + smb->pre_offset);
 	mempool_free(smb, &smb_message_pool);
 }
 
+/*
+ * Clear the request parts of a message.
+ */
+void smb_clear_request(struct smb_message *smb)
+{
+	for (; smb; smb = smb->next) {
+		if (smb->request) {
+			if (smb->sensitive)
+				memzero_explicit(smb->request, smb->data_offset);
+			cifs_free_tx_buf(smb->request);
+			smb->request = NULL;
+		}
+	}
+}
+
 /*
  * Drop a ref on a message.  This does not touch the chained messages.
  */
@@ -123,6 +141,8 @@ void smb_put_messages(struct smb_message *smb)
 {
 	struct smb_message *next;
 
+	smb_clear_request(smb);
+
 	for (; smb; smb = next) {
 		unsigned int debug_id = smb->debug_id;
 		bool dead;
@@ -561,8 +581,7 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
 
 	for (smb = head_smb; smb; smb = smb->next) {
-		size_t size = iov_iter_count(&smb->rqst.rq_iter);
-		size_t got;
+		size_t size, got;
 
 		if (offset & 7) {
 			unsigned int tmp = offset;
@@ -570,25 +589,54 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 			iov_iter_zero(offset - tmp, iter);
 		}
 
-		for (int i = 0; i < smb->rqst.rq_nvec; i++) {
-			size_t len = smb->rqst.rq_iov[i].iov_len;
-			got = copy_to_iter(smb->rqst.rq_iov[i].iov_base, len, iter);
-			if (got != len) {
-				rc = smb_EIO2(smb_eio_trace_tx_copy_to_buf, got, size);
+		if (smb->new_style) {
+			struct iov_iter req_iter = smb->req_iter;
+
+			size = iov_iter_count(&req_iter);
+			got = iterate_and_advance_kernel(&req_iter,
+							 size, iter, NULL,
+							 smb3_copy_data_iter);
+			if (got != size) {
+				rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
 				goto error;
 			}
-			offset += len;
-		}
+			offset += size;
 
-		got = iterate_and_advance_kernel(&smb->rqst.rq_iter,
-						 size, iter, NULL,
-						 smb3_copy_data_iter);
-		if (got != size) {
-			rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
-			goto error;
-		}
+			struct iov_iter data_iter = smb->data_iter;
 
-		offset += size;
+			size = iov_iter_count(&data_iter);
+			got = iterate_and_advance_kernel(&data_iter,
+							 size, iter, NULL,
+							 smb3_copy_data_iter);
+			if (got != size) {
+				rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
+				goto error;
+			}
+			offset += size;
+		} else {
+			/* Old-style with an rqst. */
+			size = iov_iter_count(&smb->rqst.rq_iter);
+
+			for (int i = 0; i < smb->rqst.rq_nvec; i++) {
+				size_t len = smb->rqst.rq_iov[i].iov_len;
+				got = copy_to_iter(smb->rqst.rq_iov[i].iov_base,
+						   len, iter);
+				if (got != len) {
+					rc = smb_EIO2(smb_eio_trace_tx_copy_to_buf, got, size);
+					goto error;
+				}
+				offset += len;
+			}
+
+			got = iterate_and_advance_kernel(&smb->rqst.rq_iter,
+							 size, iter, NULL,
+							 smb3_copy_data_iter);
+			if (got != size) {
+				rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
+				goto error;
+			}
+			offset += size;
+		}
 	}
 
 	if (WARN_ONCE(offset != total_len,
@@ -1139,9 +1187,9 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 /*
  * Send a single message or a string of messages as a compound.
  */
-static int smb_send_recv_messages(const unsigned int xid, struct cifs_ses *ses,
-				  struct TCP_Server_Info *server,
-				  struct smb_message *head_smb, const int flags)
+int smb_send_recv_messages(const unsigned int xid, struct cifs_ses *ses,
+			   struct TCP_Server_Info *server,
+			   struct smb_message *head_smb, const int flags)
 {
 	unsigned int instance;
 	int nr_reqs, i, optype, rc = 0;
@@ -1384,6 +1432,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb->request		= request;
 		smb->rqst		= *rq;
 		smb->sr_flags		= flags;
+		smb->data_iter		= rq->rq_iter;
 
 		if (is_smb1(server)) {
 			smb->command = 0;

