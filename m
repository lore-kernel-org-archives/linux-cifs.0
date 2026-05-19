Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3D4CA262
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186286; cv=none; b=GOB1OxiXItqf8K58SFT/9dFizCnULoCrUVEwFjolrzSLqrP3ilaWaHR2f7qUREv79PibfHy6uTUPBLrX2nE5i5U5IMJBcRFVSM8mtwVAFk0j+aSzc7bp26I9Ax66Uz4X8+tDcLY/D1hqugwmccuIsLdbZf24gPkHdi+VgL70DnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186286; c=relaxed/simple;
	bh=tnB03R0zqjSoco4Zsq6FYVHFFti6o0ay+Oa8IYZGGTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfiOUJXfEm2hGdHIh9a47U8iKCeQFF/sDzjkb8RkJEKu5AAl3Sfu8x3rVM+QPhpgXspMPr+gMw3O9D7IGBfFHC/9/tK/TBhGM+owTAmj0HK/jaf3gQIRor7YLsGOL8G31PDWm3881qQEqfnB2sU8G6grZbrFfejAnWr1UuztPY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bzeK9yuC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzeK9yuC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfHGEtE5AWzmVMEaBF0Gut3ba6+P3iVY14LGItT4uII=;
	b=bzeK9yuCjKzxgNOmv8o6HShwEYalQ8I/cKHzolQkotGlB+Z9d6Fa1Z4716y1LaD0OEYm0f
	zrozhBuKuL0tQZJ3Pg9NJdd6reCudHlX4Vg4WVLszMsX1HOEwjL2nkxTW5LiPUqMc5vIDe
	TmM0nNqa0V0Mx3JVoWzcaYFdm2FLTc4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-WERaetEpMJq161vot8g0aA-1; Tue,
 19 May 2026 06:24:40 -0400
X-MC-Unique: WERaetEpMJq161vot8g0aA-1
X-Mimecast-MFC-AGG-ID: WERaetEpMJq161vot8g0aA_1779186279
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D88141956095;
	Tue, 19 May 2026 10:24:38 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AEA2530001A2;
	Tue, 19 May 2026 10:24:35 +0000 (UTC)
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
Subject: [RFC PATCH 31/36] cifs: Convert SMB2 Read request
Date: Tue, 19 May 2026 11:21:49 +0100
Message-ID: <20260519102158.592165-32-dhowells@redhat.com>
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

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h |   1 -
 fs/smb/client/smb2pdu.c  | 232 +++++++++++++++++++--------------------
 2 files changed, 113 insertions(+), 120 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 9aa9eb72ec6b..ed7311637d81 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1455,7 +1455,6 @@ struct cifs_io_subrequest {
 	bool				replay;
 	unsigned int			retries;	/* number of retries so far */
 	unsigned int			cur_sleep;	/* time to sleep before replay */
-	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	struct smbdirect_mr_io		*mr;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f0b39c77f8ae..b2140cb1662e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4757,48 +4757,62 @@ static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
  * To form a chain of read requests, any read requests after the first should
  * have the end_of_chain boolean set to true.
  */
-static int
-smb2_new_read_req(void **buf, unsigned int *total_len,
-	struct cifs_io_parms *io_parms, struct cifs_io_subrequest *rdata,
-	unsigned int remaining_bytes, int request_type)
+static struct smb_message *
+smb2_new_read_req(struct cifs_io_parms *io_parms, struct cifs_io_subrequest *rdata,
+		  unsigned int remaining_bytes, int request_type)
 {
-	int rc = -EACCES;
-	struct smb2_read_req *req = NULL;
-	struct smb2_hdr *shdr;
 	struct TCP_Server_Info *server = io_parms->server;
+	struct smb2_read_req *req;
+	struct smb_message *smb;
+	struct smb2_hdr *shdr;
+	size_t proto_len = sizeof(*req) + 1;
 
-	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, server,
-				 (void **) &req, total_len);
-	if (rc)
-		return rc;
+	if (!server)
+		return ERR_PTR(-ECONNABORTED);
 
-	if (server == NULL)
-		return -ECONNABORTED;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	bool rdma_offload = rdata && smb3_use_rdma_offload(io_parms);
+
+	if (rdma_offload)
+		proto_len += sizeof(struct smbdirect_buffer_descriptor_v1);
+#endif
 
+	smb = smb2_create_request(SMB2_READ, server, io_parms->tcon,
+				  sizeof(*req), proto_len, 0,
+				  SMB2_REQ_DYNAMIC);
+	if (!smb)
+		return ERR_PTR(-ENOMEM);
+	req = smb->request;
 	shdr = &req->hdr;
-	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
-	req->PersistentFileId = io_parms->persistent_fid;
-	req->VolatileFileId = io_parms->volatile_fid;
-	req->ReadChannelInfoOffset = 0; /* reserved */
-	req->ReadChannelInfoLength = 0; /* reserved */
-	req->Channel = 0; /* reserved */
-	req->MinimumCount = 0;
-	req->Length = cpu_to_le32(io_parms->length);
-	req->Offset = cpu_to_le64(io_parms->offset);
+	if (rdata) {
+		smb->subreq		= rdata;
+		smb->credits		= rdata->credits;
+	}
 
-	trace_smb3_read_enter(rdata ? rdata->rreq->debug_id : 0,
-			      rdata ? rdata->subreq.debug_index : 0,
+	shdr->Id.SyncId.ProcessId	= cpu_to_le32(io_parms->pid);
+	req->PersistentFileId		= io_parms->persistent_fid;
+	req->VolatileFileId		= io_parms->volatile_fid;
+	req->ReadChannelInfoOffset	= 0; /* reserved */
+	req->ReadChannelInfoLength	= 0; /* reserved */
+	req->Channel			= 0; /* reserved */
+	req->MinimumCount		= 0;
+	req->Length			= cpu_to_le32(io_parms->length);
+	req->Offset			= cpu_to_le64(io_parms->offset);
+
+	trace_smb3_read_enter(smb->credits.rreq_debug_id,
+			      smb->credits.rreq_debug_index,
 			      rdata ? rdata->xid : 0,
 			      io_parms->persistent_fid,
 			      io_parms->tcon->tid, io_parms->tcon->ses->Suid,
 			      io_parms->offset, io_parms->length);
+
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a RDMA write, fill in and append
 	 * smbdirect_buffer_descriptor_v1 to the end of read request
 	 */
-	if (rdata && smb3_use_rdma_offload(io_parms)) {
+	if (rdma_offload) {
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		struct iov_iter iter;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
@@ -4808,8 +4822,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 				    rdata->subreq.content.offset, rdata->subreq.len);
 		rdata->mr = smbd_register_mr(server->smbd_conn, &iter,
 					     true, need_invalidate);
-		if (!rdata->mr)
-			return -EAGAIN;
+		if (!rdata->mr) {
+			smb_put_messages(smb);
+			return ERR_PTR(-EAGAIN);
+		}
 
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
@@ -4820,36 +4836,28 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 			cpu_to_le16(sizeof(struct smbdirect_buffer_descriptor_v1));
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
 		smbd_mr_fill_buffer_descriptor(rdata->mr, v1);
-
-		*total_len += sizeof(*v1);
 	}
 #endif
-	if (request_type & CHAINED_REQUEST) {
-		if (!(request_type & END_OF_CHAIN)) {
-			/* next 8-byte aligned request */
-			*total_len = ALIGN8(*total_len);
-			shdr->NextCommand = cpu_to_le32(*total_len);
-		} else /* END_OF_CHAIN */
-			shdr->NextCommand = 0;
-		if (request_type & RELATED_REQUEST) {
-			shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
-			/*
-			 * Related requests use info from previous read request
-			 * in chain.
-			 */
-			shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
-			shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
-			req->PersistentFileId = (u64)-1;
-			req->VolatileFileId = (u64)-1;
-		}
+
+	if ((request_type & CHAINED_REQUEST) &&
+	    (request_type & RELATED_REQUEST)) {
+		shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
+		/*
+		 * Related requests use info from previous read request in
+		 * chain.
+		 */
+		shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
+		shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
+		req->PersistentFileId = (u64)-1;
+		req->VolatileFileId = (u64)-1;
 	}
+
 	if (remaining_bytes > io_parms->length)
 		req->RemainingBytes = cpu_to_le32(remaining_bytes);
 	else
 		req->RemainingBytes = 0;
 
-	*buf = req;
-	return rc;
+	return smb;
 }
 
 static void
@@ -5004,13 +5012,12 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 {
 	struct netfs_io_subrequest *subreq = &rdata->subreq;
 	struct TCP_Server_Info *server;
+	struct smb2_read_req *req;
 	struct smb_message *smb;
-	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
-	unsigned int total_len;
-	void *buf;
+	struct smb2_hdr *shdr;
 	int credit_request;
-	int rc, flags = 0;
+	int rc;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%zu\n",
 		 __func__, subreq->start, subreq->len);
@@ -5029,30 +5036,19 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		.pid		= rdata->req->pid,
 	};
 
-	smb = smb_message_alloc(smb2_command_trace_read, GFP_NOFS);
-	if (!smb) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	rc = smb2_new_read_req(&buf, &total_len, &io_parms, rdata, 0, 0);
-	if (rc) {
-		mempool_free(smb, &smb_message_pool);
+	smb = smb2_new_read_req(&io_parms, rdata, 0, 0);
+	if (IS_ERR(smb)) {
+		rc = PTR_ERR(smb);
 		goto out;
 	}
+	req = smb->request;
+	shdr = &req->hdr;
 
 	if (smb3_encryption_required(io_parms.tcon))
-		flags |= CIFS_TRANSFORM_REQ;
+		smb->sr_flags |= CIFS_TRANSFORM_REQ;
 
-	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = total_len;
 	rdata->result = 0;
 
-	smb->rqst.rq_iov	= rdata->iov;
-	smb->rqst.rq_nvec	= 1;
-	smb->command		= SMB2_READ;
-	smb->request		= buf;
-	smb->total_len		= total_len;
 	smb->callback		= smb2_readv_callback;
 	smb->subreq		= rdata;
 	smb->copy_to_bufs	= true;
@@ -5061,19 +5057,19 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
 			    rdata->subreq.content.offset, rdata->subreq.len);
 
-	shdr = (struct smb2_hdr *)smb->request;
-
 	if (rdata->replay) {
 		/* Back-off before retry */
 		if (rdata->cur_sleep)
 			msleep(rdata->cur_sleep);
-		smb2_set_replay(server, &smb->rqst);
+		smb2_set_replay_smb(server, smb);
 	}
 
 	if (rdata->credits.value > 0) {
-		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(io_parms.length,
-						SMB2_MAX_BUFFER_SIZE));
-		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		unsigned int credit_charge =
+			DIV_ROUND_UP(io_parms.length, SMB2_MAX_BUFFER_SIZE);
+
+		shdr->CreditCharge = cpu_to_le16(credit_charge);
+		credit_request = credit_charge + 8;
 		if (server->credits >= server->max_credits)
 			shdr->CreditRequest = cpu_to_le16(0);
 		else
@@ -5085,10 +5081,14 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		if (rc)
 			goto async_readv_out;
 
-		flags |= CIFS_HAS_CREDITS;
+		smb->credits.value = rdata->credits.value;
+		smb->sr_flags |= CIFS_HAS_CREDITS;
 	}
 
-	rc = cifs_call_async(server, smb, flags, &rdata->credits);
+	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
+			    smb->data_offset);
+
+	rc = cifs_call_async(server, smb, smb->sr_flags, &rdata->credits);
 	if (rc) {
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
 		trace_smb3_read_err(rdata->rreq->debug_id,
@@ -5101,8 +5101,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	}
 
 async_readv_out:
-	cifs_small_buf_release(buf);
-
+	smb_put_messages(smb);
 out:
 	/* if the send error is retryable, let netfs know about it */
 	if (is_replayable_error(rc) &&
@@ -5113,7 +5112,6 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 	}
 
-	smb_put_messages(smb);
 	return rc;
 }
 
@@ -5121,63 +5119,56 @@ int
 SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	  unsigned int *nbytes, char **buf, int *buf_type)
 {
-	struct smb_rqst rqst;
-	int resp_buftype, rc;
-	struct smb2_read_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
-	struct kvec iov[1];
-	struct kvec rsp_iov;
-	unsigned int total_len;
-	int flags = CIFS_LOG_ERROR;
+	struct smb_message *smb;
 	struct cifs_ses *ses = io_parms->tcon->ses;
+	int rc;
 
 	if (!io_parms->server)
 		io_parms->server = cifs_pick_channel(io_parms->tcon->ses);
 
 	*nbytes = 0;
-	rc = smb2_new_read_req((void **)&req, &total_len, io_parms, NULL, 0, 0);
-	if (rc)
-		return rc;
+	smb = smb2_new_read_req(io_parms, NULL, 0, 0);
+	if (IS_ERR(smb))
+		return PTR_ERR(smb);
 
+	smb->sr_flags = CIFS_LOG_ERROR;
 	if (smb3_encryption_required(io_parms->tcon))
-		flags |= CIFS_TRANSFORM_REQ;
+		smb->sr_flags |= CIFS_TRANSFORM_REQ;
 
-	iov[0].iov_base = (char *)req;
-	iov[0].iov_len = total_len;
+	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
+			    smb->data_offset);
 
-	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
+	rc = smb_send_recv_messages(xid, ses, io_parms->server, smb, smb->sr_flags);
+	smb_clear_request(smb);
 
-	rc = cifs_send_recv(xid, ses, io_parms->server,
-			    &rqst, &resp_buftype, flags, &rsp_iov);
-	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
+	rsp = (struct smb2_read_rsp *)smb->response;
 
 	if (rc) {
 		if (rc != -ENODATA) {
 			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
 			cifs_dbg(VFS, "Send error in read = %d\n", rc);
 			trace_smb3_read_err(0, 0, xid,
-					    req->PersistentFileId,
+					    io_parms->persistent_fid,
 					    io_parms->tcon->tid, ses->Suid,
 					    io_parms->offset, io_parms->length,
 					    rc);
-		} else
+		} else {
 			trace_smb3_read_done(0, 0, xid,
-					     req->PersistentFileId, io_parms->tcon->tid,
+					     io_parms->persistent_fid,
+					     io_parms->tcon->tid,
 					     ses->Suid, io_parms->offset, 0);
-		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-		cifs_small_buf_release(req);
-		return rc == -ENODATA ? 0 : rc;
-	} else
-		trace_smb3_read_done(0, 0, xid,
-				     req->PersistentFileId,
-				     io_parms->tcon->tid, ses->Suid,
-				     io_parms->offset, io_parms->length);
+			rc = 0;
+		}
+		goto out;
+	}
 
-	cifs_small_buf_release(req);
+	trace_smb3_read_done(0, 0, xid,
+			     io_parms->persistent_fid,
+			     io_parms->tcon->tid, ses->Suid,
+			     io_parms->offset, io_parms->length);
 
-	*nbytes = le32_to_cpu(rsp->DataLength);
+	*nbytes = smb->resp_data_len;
 	if ((*nbytes > CIFS_MAX_MSGSIZE) ||
 	    (*nbytes > io_parms->length)) {
 		cifs_dbg(FYI, "bad length %d for count %d\n",
@@ -5188,15 +5179,18 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	}
 
 	if (*buf) {
-		memcpy(*buf, (char *)rsp + rsp->DataOffset, *nbytes);
-		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-	} else if (resp_buftype != CIFS_NO_BUFFER) {
-		*buf = rsp_iov.iov_base;
-		if (resp_buftype == CIFS_SMALL_BUFFER)
+		memcpy(*buf, (char *)rsp + smb->resp_data_offset, *nbytes);
+	} else if (smb->response) {
+		*buf = smb->response;
+		smb->response = NULL;
+		if (!smb->large_buf)
 			*buf_type = CIFS_SMALL_BUFFER;
-		else if (resp_buftype == CIFS_LARGE_BUFFER)
+		else
 			*buf_type = CIFS_LARGE_BUFFER;
 	}
+
+out:
+	smb_put_messages(smb);
 	return rc;
 }
 

