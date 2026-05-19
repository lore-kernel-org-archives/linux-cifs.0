Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736364F7965
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186288; cv=none; b=YW8PjQTUO9VWkyGfqqQXDDxFyuRSSGcClsso/KpQd5uQYslNBtM2dgcpqjvo5dSzqMYDUexbsdh+mA9+dRqVATkfjSzrETFsORARJwiwX4g0dlsdz5LnRgO8d9zBi1XdetS2r6pqf32r0W2V0XD8m7QZqeAjeXa/7AOzDlnhlyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186288; c=relaxed/simple;
	bh=Ai+FRz+YxmnewnzFGBNef8/oJSKhDE1wS40kGQ0amQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns3eUw5MQJBCzNYnahfl7Jy3qGeb+0GRhpfzcJ5QFxUhCP2PTsF5vtusD8WPbVcmuSRkqkLmscuYhXwHRkreRaEkc/gvTST0EGe1eh/KTfIvM7nZarJzGDLEiwZ4qREYVnzTC7i7BENtHn6sd9GYozSJw4IvGw52xtCIsCStM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nl+O/SK1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nl+O/SK1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjW4/e4KdjsDicDU4d5mNd29WjlSmju5BWwQwG8iuhI=;
	b=Nl+O/SK1OkyQfaeqwRXziAfstNVcsAWYSJNB5z0GKMqbYmb1oxb8fzA0xOEzJ+xb+OqFU7
	gohrlcd98SLANsqBjVpw5TWpBdGzragvMGhOLdaAQ88HvDeYtwCnG7ny5LM447CYeKk4bY
	vz8T3awL0YvRQ5wg1mqnEkSTrwrqAr4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-__CM1I27PL6m_3Bad0VSNQ-1; Tue,
 19 May 2026 06:24:45 -0400
X-MC-Unique: __CM1I27PL6m_3Bad0VSNQ-1
X-Mimecast-MFC-AGG-ID: __CM1I27PL6m_3Bad0VSNQ_1779186283
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2D56195608D;
	Tue, 19 May 2026 10:24:43 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 888211800352;
	Tue, 19 May 2026 10:24:40 +0000 (UTC)
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
Subject: [RFC PATCH 32/36] cifs: Convert SMB2 Write request
Date: Tue, 19 May 2026 11:21:50 +0100
Message-ID: <20260519102158.592165-33-dhowells@redhat.com>
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

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 69 +++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b2140cb1662e..b434aaf15dba 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5338,10 +5338,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	struct TCP_Server_Info *server = wdata->server;
-	struct kvec iov[1];
-	unsigned int total_len, xid = wdata->xid;
-	int credit_request;
-	int rc = -EACCES, flags = 0;
+	unsigned int xid = wdata->xid;
+	int rc = -EACCES;
 
 	/*
 	 * in future we may get cifs_io_parms passed in from the caller,
@@ -5357,41 +5355,39 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		.pid		= wdata->req->pid,
 	};
 
-	smb = smb_message_alloc(smb2_command_trace_write, GFP_NOFS);
+	size_t proto_len = sizeof(*req);
+
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	bool rdma_offload = smb3_use_rdma_offload(&io_parms);
+
+	if (rdma_offload)
+		proto_len += sizeof(struct smbdirect_buffer_descriptor_v1);
+#endif
+
+	smb = smb2_create_request(SMB2_WRITE, server, tcon,
+				  sizeof(*req), proto_len, wdata->subreq.len,
+				  SMB2_REQ_DYNAMIC);
 	if (!smb) {
 		rc = -ENOMEM;
 		goto out;
 	}
+	req = smb->request;
+	shdr = &req->hdr;
 
-	rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
-				 (void **) &req, &total_len);
-	if (rc) {
-		mempool_free(smb, &smb_message_pool);
-		goto out;
-	}
-
-	iov[0].iov_len	= total_len;
-	iov[0].iov_base	= (char *)req;
-	total_len += wdata->subreq.len;
-
-	smb->rqst.rq_iov	= iov;
-	smb->rqst.rq_nvec	= 1;
-	smb->command		= SMB2_WRITE;
+	smb->subreq		= wdata;
+	smb->credits		= wdata->credits;
 	smb->request		= req;
-	smb->total_len		= total_len;
 	smb->callback		= smb2_writev_callback;
 	smb->subreq		= wdata;
 
-	iov_iter_bvec_queue(&smb->rqst.rq_iter, ITER_SOURCE,
+	iov_iter_bvec_queue(&smb->data_iter, ITER_SOURCE,
 			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
 			    wdata->subreq.content.offset, wdata->subreq.len);
 
 	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	shdr = (struct smb2_hdr *)req;
-	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms.pid);
+		smb->sr_flags |= CIFS_TRANSFORM_REQ;
 
+	shdr->Id.SyncId.ProcessId	= cpu_to_le32(io_parms.pid);
 	req->PersistentFileId		= io_parms.persistent_fid;
 	req->VolatileFileId		= io_parms.volatile_fid;
 	req->WriteChannelInfoOffset	= 0;
@@ -5417,7 +5413,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbdirect_buffer_descriptor_v1 to the end of write request
 	 */
-	if (smb3_use_rdma_offload(&io_parms)) {
+	if (rdma_offload) {
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		struct iov_iter iter;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
@@ -5467,9 +5463,12 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		 io_parms.offset, io_parms.length, iov_iter_count(&smb->rqst.rq_iter));
 
 	if (wdata->credits.value > 0) {
-		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->subreq.len,
-						    SMB2_MAX_BUFFER_SIZE));
-		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		u32 credit_charge = DIV_ROUND_UP(wdata->subreq.len,
+						 SMB2_MAX_BUFFER_SIZE);
+		int credit_request;
+
+		shdr->CreditCharge = cpu_to_le16(credit_charge);
+		credit_request = credit_charge + 8;
 		if (server->credits >= server->max_credits)
 			shdr->CreditRequest = cpu_to_le16(0);
 		else
@@ -5481,15 +5480,18 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		if (rc)
 			goto async_writev_out;
 
-		flags |= CIFS_HAS_CREDITS;
+		smb->sr_flags |= CIFS_HAS_CREDITS;
 	}
 
 	/* XXX: compression + encryption is unsupported for now */
-	if (((flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) &&
+	if (((smb->sr_flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) &&
 	    should_compress(tcon, smb))
-		flags |= CIFS_COMPRESS_REQ;
+		smb->sr_flags |= CIFS_COMPRESS_REQ;
 
-	rc = cifs_call_async(server, smb, flags, &wdata->credits);
+	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
+			    smb->data_offset);
+
+	rc = cifs_call_async(server, smb, smb->sr_flags, &wdata->credits);
 	/* Can't touch wdata if rc == 0 */
 	if (rc) {
 		trace_smb3_write_err(wdata->rreq->debug_id,
@@ -5505,7 +5507,6 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 
 async_writev_out:
-	cifs_small_buf_release(req);
 	smb_put_messages(smb);
 out:
 	/* if the send error is retryable, let netfs know about it */

