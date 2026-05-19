Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F14BC03E
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186240; cv=none; b=WKH2UQbRuJvswabPdgGKCJyWPway0FkyMbxxFKlBPRBwPAOUQL0JfpG+p+QJForGbi42HHQWYr7zfz7QXepEaxpxCEMMPUC6dB+WbHVdKO/rMnUtR3vi9puKL3lQaNHXv/Hsgdl9lN9ohe7VrqaMOLrZBhlL+mSMUT3U3K0fVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186240; c=relaxed/simple;
	bh=lf0xJA10ZF1np6bpfINkHyQYEJMIrla0lxLV9B2lpug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V300WQ0WOrzLymlKwimfzSQZ+g0h/HuKMxYgqzm3jhXRj5LLPGOELM7Kiy+hqd35ih8E/EHcKw6DpBuO2h9OuDPrut0RaKsLRrSth2WbYYLUW+uuvGXPJ3Wm9EHSSxJJqKjWZbScBBPTJauMR7JJ/wiLhywnjQDAR7wZOHaFr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5BcpZPu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5BcpZPu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwtmtV+/BP9WRUWfkBmBVGjokBH4hjCTpxEToiEclRI=;
	b=h5BcpZPuOuf2xcagkf+F+4z2eOcoDBGBg82FXz2pUd+sLJhd8nPE3VFAtb+OWB35oCNnJs
	abEB9o/SqkObAApjDcI6osGjQTRH/287TU0d4SQUXz820RkbKs+25YBrL4EqbBvg7asfjK
	T48oy0aNBKUrGC0PacemKLIGI1Z5v80=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-wDgwadrONoGGemrHhjhj9A-1; Tue,
 19 May 2026 06:23:51 -0400
X-MC-Unique: wDgwadrONoGGemrHhjhj9A-1
X-Mimecast-MFC-AGG-ID: wDgwadrONoGGemrHhjhj9A_1779186229
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A30991800283;
	Tue, 19 May 2026 10:23:49 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D3ED30001A2;
	Tue, 19 May 2026 10:23:46 +0000 (UTC)
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
Subject: [RFC PATCH 21/36] cifs: Add a tracepoint to trace the smb_message refcount
Date: Tue, 19 May 2026 11:21:39 +0100
Message-ID: <20260519102158.592165-22-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add a tracepoint to trace the smb_message refcount and to log the various
different reasons that things that can happen to it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h      |  1 +
 fs/smb/client/cifsproto.h     |  5 ++-
 fs/smb/client/cifssmb.c       |  6 +--
 fs/smb/client/connect.c       | 11 +++--
 fs/smb/client/smb1ops.c       |  2 +-
 fs/smb/client/smb1transport.c | 10 ++---
 fs/smb/client/smb2ops.c       |  2 +-
 fs/smb/client/smb2pdu.c       | 10 ++---
 fs/smb/client/smb2transport.c | 25 ++++++------
 fs/smb/client/trace.h         | 77 ++++++++++++++++++++++++++++++++---
 fs/smb/client/transport.c     | 50 +++++++++++++++++++----
 11 files changed, 151 insertions(+), 48 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index c444b7d81c23..6b90f17ae0fa 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1669,6 +1669,7 @@ struct smb_message {
 	struct cifs_credits	credits;	/* Credit requirements for this message */
 	void			*request;	/* Pointer to request message body */
 	refcount_t		ref;
+	unsigned int		debug_id;	/* Debugging ID for tracing */
 	bool			sensitive;	/* Request contains sensitive data */
 	bool			cancelled;	/* T if cancelled */
 	unsigned int		sr_flags;	/* Flags passed to send_recv() */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 47f78955796f..72ee5c5fd8b7 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -82,8 +82,9 @@ char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 char *cifs_build_devname(char *nodename, const char *prepath);
 void delete_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp);
-void smb_get_message(struct smb_message *smb);
-void smb_put_message(struct smb_message *smb);
+void smb_see_message(struct smb_message *smb, enum smb_message_trace trace);
+void smb_get_message(struct smb_message *smb, enum smb_message_trace trace);
+void smb_put_message(struct smb_message *smb, enum smb_message_trace trace);
 void smb_put_messages(struct smb_message *smb);
 void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 void cifs_wake_up_task(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index ebd95de2cd91..ca6410e1f39e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -744,7 +744,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
 	cifs_small_buf_release(req);
-	smb_put_message(smb);
+	smb_put_message(smb, smb_message_trace_put_end);
 	return rc;
 }
 
@@ -1614,7 +1614,7 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
 put_smb:
-	smb_put_message(smb);
+	smb_put_message(smb, smb_message_trace_put_end);
 	return rc;
 }
 
@@ -2022,7 +2022,7 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 async_writev_out:
 	cifs_small_buf_release(req);
 out_put:
-	smb_put_message(smb);
+	smb_put_message(smb, smb_message_trace_put_end);
 out:
 	if (rc) {
 		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd092f0a0515..99b7c3f165cb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -364,6 +364,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
+		smb_see_message(smb, smb_message_trace_see_abort_conn);
 		if (smb->mid_state == MID_REQUEST_SUBMITTED)
 			smb->mid_state = MID_RETRY_NEEDED;
 		list_move(&smb->qhead, &retry_list);
@@ -376,7 +377,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	list_for_each_entry_safe(smb, nsmb, &retry_list, qhead) {
 		list_del_init(&smb->qhead);
 		mid_execute_callback(server, smb);
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_abort_conn);
 	}
 }
 
@@ -821,6 +822,7 @@ static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 			 */
 			spin_lock(&server->mid_queue_lock);
 			list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
+				smb_see_message(smb, smb_message_trace_see_is_smb_resp);
 				list_move(&smb->qhead, &dispose_list);
 				smb->deleted_from_q = true;
 			}
@@ -854,7 +856,7 @@ static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 				smb->mid_rc = mid_rc;
 				smb->mid_state = MID_RC;
 				mid_execute_callback(server, smb);
-				smb_put_message(smb);
+				smb_put_message(smb, smb_message_trace_put_is_smb_resp);
 			}
 
 			/*
@@ -908,7 +910,7 @@ dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb, bool malfor
 		spin_unlock(&server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_dequeue_mid);
 		list_del_init(&smb->qhead);
 		smb->deleted_from_q = true;
 		spin_unlock(&server->mid_queue_lock);
@@ -1015,6 +1017,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_entry_safe(smb, smb2, &server->pending_mid_q, qhead) {
 			cifs_dbg(FYI, "Clearing mid %llu\n", smb->mid);
+			smb_see_message(smb, smb_message_trace_see_clean_demux);
 			smb->mid_state = MID_SHUTDOWN;
 			list_move(&smb->qhead, &dispose_list);
 			smb->deleted_from_q = true;
@@ -1026,7 +1029,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 			cifs_dbg(FYI, "Callback mid %llu\n", smb->mid);
 			list_del_init(&smb->qhead);
 			mid_execute_callback(server, smb);
-			smb_put_message(smb);
+			smb_put_message(smb, smb_message_trace_put_clean_demux);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index fb3529a79c6b..a2a2167c0e22 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -236,7 +236,7 @@ cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr)
 		if (smb->mid == mid &&
 		    smb->mid_state == MID_REQUEST_SUBMITTED &&
 		    smb->command == shdr->Command) {
-			smb_get_message(smb);
+			smb_get_message(smb, smb_message_trace_get_find_mid);
 			spin_unlock(&server->mid_queue_lock);
 			return smb;
 		}
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 1bbfa0844e6f..ba887284fadd 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -58,7 +58,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_message *smb)
 	}
 	spin_unlock(&ses->ses_lock);
 
-	smb_get_message(smb);
+	smb_get_message(smb, smb_message_trace_get_enqueue_sync);
 	spin_lock(&ses->server->mid_queue_lock);
 	list_add_tail(&smb->qhead, &ses->server->pending_mid_q);
 	spin_unlock(&ses->server->mid_queue_lock);
@@ -85,7 +85,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_message *smb
 
 	rc = cifs_sign_rqst(&smb->rqst, server, &smb->sequence_number);
 	if (rc) {
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_end);
 		return rc;
 	}
 
@@ -891,7 +891,7 @@ static void smb1_parse_one_message(struct TCP_Server_Info *server,
 			 __func__, le16_to_cpu(shdr->Mid));
 		rxq->msg_id = 0;
 	} else {
-		rxq->msg_id = 0; /* TODO: smb->debug_id */
+		rxq->msg_id = smb->debug_id;
 	}
 
 	/* No session expiry check. */
@@ -921,7 +921,7 @@ static void smb1_parse_one_message(struct TCP_Server_Info *server,
 			/* Handle multipart trans2-class messages. */
 			rc = smb1_trans2_receive(server, smb, recv, rxq);
 			if (rc == 1) {
-				smb_put_message(smb);
+				smb_put_message(smb, smb_message_trace_put_incomplete);
 				return; /* Multipart, incomplete. */
 			}
 			if (rc < 0)
@@ -995,7 +995,7 @@ static void smb1_parse_one_message(struct TCP_Server_Info *server,
 		dequeue_mid(server, smb, recv->malformed);
 		mid_execute_callback(server, smb);
 
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_delivered);
 	} else if (smb1_is_valid_oplock_break(h, recv->msg_len, server)) {
 		cifs_dbg(FYI, "Received oplock break\n");
 		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 93ec64d67d54..0aaefe901fbd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -439,7 +439,7 @@ smb2_find_mid(struct TCP_Server_Info *server, struct smb2_hdr *shdr, bool dequeu
 		if ((smb->mid == wire_mid) &&
 		    (smb->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (smb->command == shdr->Command)) {
-			smb_get_message(smb);
+			smb_get_message(smb, smb_message_trace_get_find_mid);
 			if (dequeue) {
 				list_del_init(&smb->qhead);
 				smb->deleted_from_q = true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5919cd99dec6..2a234df2fad5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4395,7 +4395,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
 	cifs_small_buf_release(req);
-	smb_put_message(smb);
+	smb_put_messages(smb);
 	return rc;
 }
 
@@ -4662,8 +4662,8 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 
 			rc = smb2_verify_signature(smb, server);
 			if (rc) {
-				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
-					      rc);
+				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d (MSG=%x)\n",
+					 rc, smb->debug_id);
 				rdata->subreq.error = rc;
 				rdata->result = rc;
 
@@ -4887,7 +4887,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 	}
 
-	smb_put_message(smb);
+	smb_put_messages(smb);
 	return rc;
 }
 
@@ -5286,7 +5286,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 
 async_writev_out:
 	cifs_small_buf_release(req);
-	smb_put_message(smb);
+	smb_put_messages(smb);
 out:
 	/* if the send error is retryable, let netfs know about it */
 	if (is_replayable_error(rc) &&
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 543b26135085..404bb8b1b3c3 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -579,13 +579,12 @@ int smb2_verify_signature(struct smb_message *smb, struct TCP_Server_Info *serve
 	if (rc)
 		return rc;
 
-	if (crypto_memneq(server_response_sig, shdr->Signature,
-			  SMB2_SIGNATURE_SIZE)) {
-		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
-			shdr->Command, shdr->MessageId);
-		return -EACCES;
-	} else
+	if (crypto_memneq(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE))
 		return 0;
+
+	cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx MSG=%x\n",
+		 shdr->Command, shdr->MessageId, smb->debug_id);
+	return -EACCES;
 }
 
 /*
@@ -662,7 +661,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 
 	smb2_init_mid(smb, server);
 
-	smb_get_message(smb);
+	smb_get_message(smb, smb_message_trace_get_enqueue_sync);
 	spin_lock(&server->mid_queue_lock);
 	list_add_tail(&smb->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
@@ -682,8 +681,8 @@ smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 
 		rc = smb2_verify_signature(smb, server);
 		if (rc)
-			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
-					rc);
+			cifs_server_dbg(VFS, "SMB signature verification returned error = %d (MSG=%x)\n",
+					rc, smb->debug_id);
 	}
 
 	return smb->error;
@@ -1300,7 +1299,7 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 			 __func__, le64_to_cpu(shdr->MessageId));
 		rxq->msg_id = 0;
 	} else {
-		rxq->msg_id = 0; /* TODO: smb->debug_id */
+		rxq->msg_id = smb->debug_id;
 		smb->decrypted = decrypted;
 	}
 
@@ -1335,12 +1334,12 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 				       le64_to_cpu(shdr->MessageId));
 		cifs_dbg(FYI, "Session expired or deleted\n");
 		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_session_expired);
 		return;
 	case STATUS_PENDING:
 		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
 		smb2_status_pending(shdr, server);
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_pending);
 		return;
 	case STATUS_IO_TIMEOUT:
 		int iotimo = atomic_inc_return(&server->num_io_timeout);
@@ -1434,7 +1433,7 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 		dequeue_mid(server, smb, recv->malformed);
 		mid_execute_callback(server, smb);
 
-		smb_put_message(smb);
+		smb_put_message(smb, smb_message_trace_put_delivered);
 	} else if (shdr->Command == cpu_to_le32(SMB2_OPLOCK_BREAK)) {
 		smb2_is_valid_oplock_break(server, h);
 		smb2_add_credits_from_hdr(shdr, server);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 03ed4925df08..2cdbd8249af0 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -178,6 +178,50 @@
 	EM(smb_eio_trace_write_rsp_malformed,		"write_rsp_malformed") \
 	E_(smb_eio_trace_write_too_far,			"write_too_far")
 
+#define smb_message_traces \
+	EM(smb_message_trace_alloc_cancel,		"AL Cancel    ") \
+	EM(smb_message_trace_alloc_change_notify,	"AL Change-Nfy") \
+	EM(smb_message_trace_alloc_close,		"AL Close     ") \
+	EM(smb_message_trace_alloc_create,		"AL Create    ") \
+	EM(smb_message_trace_alloc_echo,		"AL Echo      ") \
+	EM(smb_message_trace_alloc_flush,		"AL Flush     ") \
+	EM(smb_message_trace_alloc_ioctl,		"AL Ioctl     ") \
+	EM(smb_message_trace_alloc_lock,		"AL Lock      ") \
+	EM(smb_message_trace_alloc_logoff,		"AL Logoff    ") \
+	EM(smb_message_trace_alloc_negotiate,		"AL Negotiate ") \
+	EM(smb_message_trace_alloc_oplock_break,	"AL Oplock-Brk") \
+	EM(smb_message_trace_alloc_query_directory,	"AL Query-Dir ") \
+	EM(smb_message_trace_alloc_query_info,		"AL Query-Info") \
+	EM(smb_message_trace_alloc_read,		"AL Read      ") \
+	EM(smb_message_trace_alloc_session_setup,	"AL Sess-setup") \
+	EM(smb_message_trace_alloc_set_info,		"AL Set-Info  ") \
+	EM(smb_message_trace_alloc_srv_to_cln_notif,	"AL s2c-Notify") \
+	EM(smb_message_trace_alloc_tree_connect,	"AL Tree-conn ") \
+	EM(smb_message_trace_alloc_tree_disconnect,	"AL Tree-disc ") \
+	EM(smb_message_trace_alloc_write,		"AL Write     ") \
+	EM(smb_message_trace_free,			"FREE         ") \
+	EM(smb_message_trace_get_call_async,		"GET call-asyn") \
+	EM(smb_message_trace_get_enqueue_sync,		"GET enq-sync ") \
+	EM(smb_message_trace_get_find_mid,		"GET find-mid ") \
+	EM(smb_message_trace_put_abort_conn,		"PUT abrt-conn") \
+	EM(smb_message_trace_put_clean_demux,		"PUT cln-demux") \
+	EM(smb_message_trace_put_decrypt_offload,	"PUT decrypt-o") \
+	EM(smb_message_trace_put_delivered,		"PUT delivered") \
+	EM(smb_message_trace_put_demux,			"PUT demux    ") \
+	EM(smb_message_trace_put_demux_cb,		"PUT demux-cb ") \
+	EM(smb_message_trace_put_dequeue_mid,		"SEE deque-mid") \
+	EM(smb_message_trace_put_discard_message,	"PUT disc-msg ") \
+	EM(smb_message_trace_put_end,			"PUT end      ") \
+	EM(smb_message_trace_put_incomplete,		"PUT incomplet") \
+	EM(smb_message_trace_put_is_smb_resp,		"PUT is-s-resp") \
+	EM(smb_message_trace_put_messages,		"PUT messages ") \
+	EM(smb_message_trace_put_pending,		"PUT pending  ") \
+	EM(smb_message_trace_put_session_expired,	"PUT sess-exp ") \
+	EM(smb_message_trace_see_abort_conn,		"SEE abrt-conn") \
+	EM(smb_message_trace_see_clean_demux,		"SEE cln-demux") \
+	EM(smb_message_trace_see_is_smb_resp,		"SEE is-s-resp") \
+	E_(smb_message_trace_see_wake_up_task,		"SEE wake-task")
+
 #define smb3_rw_credits_traces \
 	EM(cifs_trace_rw_credits_call_readv_adjust,	"rd-call-adj") \
 	EM(cifs_trace_rw_credits_call_writev_adjust,	"wr-call-adj") \
@@ -241,6 +285,7 @@
 
 enum smb_command_trace		{ smb_command_traces } __mode(byte);
 enum smb_eio_trace		{ smb_eio_traces } __mode(byte);
+enum smb_message_trace		{ smb_message_traces } __mode(byte);
 enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
 enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 
@@ -256,6 +301,7 @@ enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 
 smb_command_traces;
 smb_eio_traces;
+smb_message_traces;
 smb3_rw_credits_traces;
 smb3_tcon_ref_traces;
 
@@ -2030,26 +2076,47 @@ TRACE_EVENT(smb3_reply,
 	    TP_ARGS(smb, recv),
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	msg_id)
-		    __field(unsigned int,	cmd)
+		    __field(enum smb_command_trace, cmd)
 		    __field(unsigned int,	doff)
 		    __field(unsigned int,	dlen)
 		    __field(unsigned int,	len)
 		    __field(unsigned int,	extr)
 			     ),
 	    TP_fast_assign(
-		    __entry->msg_id	= 0; /* TODO: fill in */
-		    __entry->cmd	= smb->command;
+		    __entry->msg_id	= smb->debug_id;
+		    __entry->cmd	= smb->command_trace;
 		    __entry->doff	= recv->data_offset;
 		    __entry->dlen	= recv->data_len;
 		    __entry->len	= recv->msg_len;
 		    __entry->extr	= recv->extracted;
 			   ),
-	    TP_printk("MSG=%08x cmd=%x d=%x-%x l=%x/%x",
-		      __entry->msg_id, __entry->cmd,
+	    TP_printk("MSG=%08x cmd=%s d=%x-%x l=%x/%x",
+		      __entry->msg_id,
+		      __print_symbolic(__entry->cmd, smb_command_traces),
 		      __entry->doff, __entry->doff + __entry->dlen,
 		      __entry->extr, __entry->len)
 	    );
 
+TRACE_EVENT(smb3_message,
+	    TP_PROTO(unsigned int smb_message_debug_id, int ref,
+		     enum smb_message_trace trace),
+	    TP_ARGS(smb_message_debug_id, ref, trace),
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		smb_message)
+		    __field(int,			ref)
+		    __field(enum smb_message_trace,	trace)
+			     ),
+	    TP_fast_assign(
+		    __entry->smb_message = smb_message_debug_id;
+		    __entry->ref	= ref;
+		    __entry->trace	= trace;
+			   ),
+	    TP_printk("MSG=%08x %s r=%d",
+		      __entry->smb_message,
+		      __print_symbolic(__entry->trace, smb_message_traces),
+		      __entry->ref)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _CIFS_TRACE_H */
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index d0bbd38970db..0a7b2e7922cf 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -35,6 +35,7 @@
 
 struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 {
+	static atomic_t debug_ids;
 	struct smb_message *smb;
 
 	smb = mempool_alloc(&smb_message_pool, gfp);
@@ -42,6 +43,7 @@ struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 		memset(smb, 0, sizeof(*smb));
 		refcount_set(&smb->ref, 1);
 		spin_lock_init(&smb->mid_lock);
+		smb->debug_id	= atomic_inc_return(&debug_ids);
 		smb->command_trace = cmd;
 		smb->when_alloc	= jiffies;
 		smb->pid	= current->pid;
@@ -53,22 +55,44 @@ struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 		smb->callback		= cifs_wake_up_task;
 		smb->callback_data	= current;
 		smb->mid_state		= MID_REQUEST_ALLOCATED;
+		trace_smb3_message(smb->debug_id, 1, (enum smb_message_trace)cmd);
 	}
 	return smb;
 }
 
-void smb_get_message(struct smb_message *smb)
+void smb_see_message(struct smb_message *smb, enum smb_message_trace trace)
 {
-	refcount_inc(&smb->ref);
+	trace_smb3_message(smb->debug_id, refcount_read(&smb->ref), trace);
+}
+
+void smb_get_message(struct smb_message *smb, enum smb_message_trace trace)
+{
+	int r;
+
+	__refcount_inc(&smb->ref, &r);
+	trace_smb3_message(smb->debug_id, r + 1, trace);
+}
+
+static void smb_free_message(struct smb_message *smb)
+{
+	trace_smb3_message(smb->debug_id, refcount_read(&smb->ref),
+			   smb_message_trace_free);
+	mempool_free(smb, &smb_message_pool);
 }
 
 /*
  * Drop a ref on a message.  This does not touch the chained messages.
  */
-void smb_put_message(struct smb_message *smb)
+void smb_put_message(struct smb_message *smb, enum smb_message_trace trace)
 {
-	if (refcount_dec_and_test(&smb->ref))
-		mempool_free(smb, &smb_message_pool);
+	unsigned int debug_id = smb->debug_id;
+	bool dead;
+	int r;
+
+	dead = __refcount_dec_and_test(&smb->ref, &r);
+	trace_smb3_message(debug_id, r - 1, trace);
+	if (dead)
+		smb_free_message(smb);
 }
 
 /*
@@ -80,8 +104,15 @@ void smb_put_messages(struct smb_message *smb)
 	struct smb_message *next;
 
 	for (; smb; smb = next) {
+		unsigned int debug_id = smb->debug_id;
+		bool dead;
+		int r;
+
 		next = smb->next;
-		smb_put_message(smb);
+		dead = __refcount_dec_and_test(&smb->ref, &r);
+		trace_smb3_message(debug_id, r - 1, smb_message_trace_put_messages);
+		if (dead)
+			smb_free_message(smb);
 	}
 }
 
@@ -90,6 +121,7 @@ cifs_wake_up_task(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	if (smb->mid_state == MID_RESPONSE_RECEIVED)
 		smb->mid_state = MID_RESPONSE_READY;
+	smb_see_message(smb, smb_message_trace_see_wake_up_task);
 	wake_up_process(smb->callback_data);
 }
 
@@ -193,7 +225,7 @@ static void smb_discard_messages(struct TCP_Server_Info *server, struct smb_mess
 	for (smb = head_smb; smb; smb = next) {
 		next = smb->next;
 		if (discard_message(server, smb))
-			smb_put_message(smb);
+			smb_put_message(smb, smb_message_trace_put_discard_message);
 	}
 }
 
@@ -930,7 +962,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
 	smb->mid_state = MID_REQUEST_SUBMITTED;
 
 	/* put it on the pending_mid_q */
-	smb_get_message(smb);
+	smb_get_message(smb, smb_message_trace_get_call_async);
 	spin_lock(&server->mid_queue_lock);
 	list_add_tail(&smb->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
@@ -946,7 +978,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
 		revert_current_mid(server, smb->credits_consumed);
 		server->sequence_number -= 2;
 		if (discard_message(server, smb))
-			smb_put_message(smb);
+			smb_put_message(smb, smb_message_trace_put_discard_message);
 	}
 
 	cifs_server_unlock(server);

