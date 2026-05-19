Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5294D2EC1
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186299; cv=none; b=WrUc3uOu+oFK2Z4IS6XxrlByJCQ/itUyDVSu1R+MHsvLEzkR6wS7rqFJ2KzfTn+1JHRqMJA9/75a5DwK3rM+NjBOmPZHN2YMcq00c6C2kGhviDkUIlz/P1C2GlB5CY9EHKQJvFM74F5atbvnPOdI6s1Pyau/wP0x5j++F5LxUtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186299; c=relaxed/simple;
	bh=oO6f4LRCHepH4qNLpLun8eTejWtJLMHsEwcBStKvMT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiHVHD3loUz0P47NE+2a3OjfxRs8Jb5AYtPq/GLz710XPZdCUPfNnQIRDqcz+LVcf7kBrftDCjBrsBYSXyG56/+7YSK7SJdi+Ij8ZH931WwUALLdJRjukA4NhUdBZ/3gB1gByNmxZhXS8l6UJ2vEqq0qWca/vsfOhid2jRYp/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=heYjlnds; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heYjlnds"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qTP+N02umNQMf6H6f6Beoe7O0wphfbf0XB/xACH6ZMs=;
	b=heYjlndsstlK1CMDEZalGZBDa3hI+C0j2m1Yagc6eQUS/Gnb4yTT3vklp91FCksY7R6jc0
	+IdshkrP2yfSkuLouub3Z1W6euqWHspmK0MH/RaNb1TGgYBZpSCTCGIxexZUEkP95+T4I2
	JUHocDXaYBKAQK8K8Ujjlb7Ubnnon4Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-JjvNWDUQN0m2IPFsi6zAYw-1; Tue,
 19 May 2026 06:24:50 -0400
X-MC-Unique: JjvNWDUQN0m2IPFsi6zAYw-1
X-Mimecast-MFC-AGG-ID: JjvNWDUQN0m2IPFsi6zAYw_1779186288
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCF421956053;
	Tue, 19 May 2026 10:24:48 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6749819560A2;
	Tue, 19 May 2026 10:24:45 +0000 (UTC)
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
Subject: [RFC PATCH 33/36] cifs: [WIP] Don't copy new-style smb_messages to a set of pages
Date: Tue, 19 May 2026 11:21:51 +0100
Message-ID: <20260519102158.592165-34-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Currently, smb_send_rqst() copies all the data it is given into a clean set
of pages and, if needed, a page fragment so that MSG_SPLICE_PAGES can be
passed to sendmsg() to make sendmsg() more efficient.

With the "new style" of smb_messages, however, the protocol data is placed
into its own fragment or fragments plus, optionally, a bundle of page
fragments supplied from higher up carrying data (e.g. for Write).  These
can be passed to MSG_SPLICE_PAGES without the need for copying, so don't do
that if we don't have to.

Note that we may still need to do this if encrypting or compressing and we
can't modify borrowed data in place (e.g. Write), though we *can* encrypt
the request in its fragment.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsencrypt.c   |   4 +-
 fs/smb/client/cifsglob.h      |  16 ++-
 fs/smb/client/cifssmb.c       |  12 +-
 fs/smb/client/compress.c      |  21 ++-
 fs/smb/client/compress.h      |   4 +-
 fs/smb/client/smb1encrypt.c   |   4 +-
 fs/smb/client/smb1transport.c |   8 +-
 fs/smb/client/smb2misc.c      |   4 +-
 fs/smb/client/smb2ops.c       |   2 +-
 fs/smb/client/smb2pdu.c       |  63 +++------
 fs/smb/client/smb2transport.c |  69 ++++++----
 fs/smb/client/transport.c     | 249 ++++++++++++++++++++++------------
 12 files changed, 274 insertions(+), 182 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 34804e9842a8..eb900cecbb37 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -87,7 +87,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	if (rc < 0)
 		return rc;
 
-	rc = cifs_sig_iter(&rqst->rq_iter, iov_iter_count(&rqst->rq_iter), ctx);
+	iov_iter_bvec_queue(&iter, ITER_SOURCE, rqst->rq_data, 0, 0, rqst->rq_data_len);
+
+	rc = cifs_sig_iter(&iter, iov_iter_count(&iter), ctx);
 	if (rc < 0)
 		return rc;
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ed7311637d81..e5972ac80240 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -290,8 +290,8 @@ struct cifs_open_info_data {
 struct smb_rqst {
 	struct kvec	*rq_iov;	/* array of kvecs */
 	unsigned int	rq_nvec;	/* number of kvecs in array */
-	struct iov_iter	rq_iter;	/* Data iterator */
-	struct bvecq	*rq_buffer;	/* Buffer for encryption */
+	unsigned int	rq_data_len;	/* Amount of data in ->rq_data */
+	struct bvecq	*rq_data;	/* Data content */
 };
 
 struct smb_message;
@@ -1706,6 +1706,7 @@ struct smb_message {
 	bool			decrypted:1;	/* decrypted entry */
 	bool			sig_checked:1;	/* T if sig already checked */
 	bool			copy_to_bufs:1;	/* Copy to prepared buffer in response_iter */
+	bool			req_data_nomodify:1; /* T if req_data cannot be modified */
 
 	/* Request details */
 	u8			command_trace;	/* enum smb_command_trace - Command trace ID */
@@ -1716,8 +1717,8 @@ struct smb_message {
 	u16			offset;		/* Running offset during assembly */
 	u16			data_offset;	/* Offset of data in message (maybe in ->body) */
 	unsigned int		total_len;	/* Total length of from hdr_offset onwards */
-	struct iov_iter		data_iter;	/* Data iterator */
-	struct iov_iter		req_iter;	/* Request iterator */
+	unsigned int		req_data_len;	/* Amount of data in ->data_bq */
+	struct bvecq		*req_data;	/* Data content */
 	/* Response */
 	//u32			response_pdu_len; /* Size of response PDU */
 	void			*response;	/* Protocol part of response */
@@ -1726,8 +1727,11 @@ struct smb_message {
 	u32			resp_data_offset; /* Offset of response data (or 0) */
 	__le32			status;		/* Completion status */
 	short			error;		/* Linux error */
-	struct iov_iter		response_iter;	/* Data part of response */
-	struct bvecq		*response_data;	/* Storage for response data (or NULL) */
+	struct iov_iter		resp_extra_iter;
+	struct bvecq		*resp_buffer;	/* Storage for response data */
+	unsigned int		resp_buffer_slot;
+	unsigned int		resp_buffer_offset;
+	unsigned int		resp_buffer_len; /* Capacity of resp->buffer */
 	/* Compat with old code */
 	struct smb_rqst		rqst;
 	/* Variable-length request fragment list - must be last! */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e36828359f67..80fc4e89f3df 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1595,10 +1595,10 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 	smb->total_len		= in_len;
 	smb->callback		= cifs_readv_callback;
 	smb->copy_to_bufs	= true;
-
-	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
+	smb->resp_buffer	= bvecq_get(rdata->subreq.content.bvecq);
+	smb->resp_buffer_slot	= rdata->subreq.content.slot;
+	smb->resp_buffer_offset	= rdata->subreq.content.offset;
+	smb->resp_buffer_len	= rdata->subreq.len;
 
 	trace_smb3_read_enter(rdata->rreq->debug_id,
 			      rdata->subreq.debug_index,
@@ -1968,7 +1968,9 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 
 	smb->rqst.rq_iov	= iov;
 	smb->rqst.rq_nvec	= 1;
-	smb->command		= SMB2_WRITE;
+	smb->req_data		= wdata->subreq.content;
+	smb->req_data_len	= wdata->len;
+	smb->req_data_nomodify	= true;
 	smb->request		= req;
 	smb->total_len		= in_len + 1;
 	smb->total_len		+= wdata->subreq.len;
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 36eb8a604603..67305b1e82a6 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -329,9 +329,8 @@ static void *vmap_bvecq(struct iov_iter *iter, pgprot_t prot)
 }
 
 int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
-		 struct bvecq **bq)
+		 struct bvecq **bq, struct smb2_compression_hdr *z_hdr)
 {
-	struct smb2_compression_hdr *z_hdr;
 	struct smb2_write_req *w_hdr;
 	struct smb2_hdr *shdr;
 	struct iov_iter tmp;
@@ -363,9 +362,8 @@ int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 	 * This is just overprovisioning, as the algorithm will error out if @dst reaches 7/8
 	 * of @slen.
 	 */
-	dlen = lz77_compressed_alloc_size(slen);
-	dlen = sizeof(*z_hdr) + slen;
-	dbq = bvecq_alloc_buffer(dlen, GFP_NOFS);
+	dlen = slen;
+	dbq = bvecq_alloc_buffer2(dlen, 1, GFP_NOFS);
 	if (!dbq) {
 		ret = -ENOMEM;
 		goto err_free;
@@ -378,16 +376,15 @@ int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 		dst = NULL;
 		goto err_free;
 	}
-	z_hdr = dst;
-	dst  += sizeof(*z_hdr) + hlen;
-	dlen -= sizeof(*z_hdr) + hlen;
+	dst  += hlen;
+	dlen -= hlen;
 
 	ret = lz77_compress(src + hlen, slen - hlen, dst, &dlen);
 	if (ret)
 		goto err_free;
 
-	dlen += sizeof(*z_hdr) + hlen;
-	dst -= hlen;
+	dlen += hlen;
+	dst  -= hlen;
 	memcpy(dst, src, hlen);
 
 	z_hdr->ProtocolId			= SMB2_COMPRESSION_TRANSFORM_ID;
@@ -396,7 +393,7 @@ int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 	z_hdr->Flags				= SMB2_COMPRESSION_FLAG_NONE;
 	z_hdr->Offset				= cpu_to_le32(hlen);
 
-	vunmap(z_hdr);
+	vunmap(dst);
 	vunmap(src);
 
 	dbq->bv[0] = sbq->bv[0];
@@ -409,7 +406,7 @@ int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 	return dlen;
 
 err_free:
-	vunmap(z_hdr);
+	vunmap(dst);
 	vunmap(src);
 	bvecq_put(dbq);
 	return ret;
diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index d03f7342b4bd..ba45f0681ab1 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -31,7 +31,7 @@ typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *
 
 
 int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
-		 struct bvecq **bq);
+		 struct bvecq **bq, struct smb2_compression_hdr *z_hdr);
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_message *smb);
 bool is_compressible(const struct iov_iter *data);
 
@@ -61,7 +61,7 @@ static __always_inline int smb_compress_alg_valid(__le16 alg, bool valid_none)
 #else /* !CONFIG_CIFS_COMPRESSION */
 static inline
 int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
-		 struct bvecq **bq)
+		 struct bvecq **bq, struct smb2_compression_hdr *z_hdr)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
index c61202ae54c6..a9b5884fd790 100644
--- a/fs/smb/client/smb1encrypt.c
+++ b/fs/smb/client/smb1encrypt.c
@@ -118,7 +118,9 @@ int cifs_verify_signature(struct smb_message *smb,
 	struct smb_rqst rqst = {
 		.rq_iov = &iov,
 		.rq_nvec = 1,
-		.rq_iter = smb->response_iter
+		.rq_data = smb->resp_buffer,
+		.rq_data_len = umin(smb->resp_buffer_len, smb->resp_data_len),
+		
 	};
 	char what_we_think_sig_should_be[20];
 	char server_response_sig[8];
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 598579b564ae..df26eb3cf0e0 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -799,10 +799,16 @@ static void smb1_copy_to_prepped_buffers(struct TCP_Server_Info *server,
 					 struct cifs_receive *recv)
 {
 	const union smb1_response_hdr *h = recv->response;
-	struct iov_iter dest = smb->response_iter;
+	struct iov_iter dest;
 	unsigned int to_copy, skip;
 	int rc;
 
+	iov_iter_bvec_queue(&dest, ITER_DEST,
+			    smb->resp_buffer,
+			    smb->resp_buffer_slot,
+			    smb->resp_buffer_offset,
+			    smb->resp_buffer_len);
+
 	switch (h->hdr.Command) {
 	case SMB_COM_READ_ANDX:
 		to_copy = recv->data_len;
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 7c9dc3ede8b8..3f0f1e46bb06 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -889,7 +889,9 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	if (hash_resp) {
 		sha512_update(&sha_ctx,  smb->response, smb->resp_len);
 	} else if (smb->new_style) {
-		struct iov_iter tmp = smb->req_iter;
+		struct iov_iter tmp;
+
+		iov_iter_bvec_queue(&tmp, ITER_SOURCE, &smb->bvecq, 0, 0, smb->total_len);
 
 		iterate_and_advance_kernel(&tmp, smb->total_len,
 					   &sha_ctx, NULL, smb_sha512_step);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f9cefc47d084..0e212a3e883d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2769,7 +2769,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 
 	for (int i = 0; i < rqst->rq_nvec; i++)
 		len += rqst->rq_iov[i].iov_len;
-	len += iov_iter_count(&rqst->rq_iter);
+	len += rqst->rq_data_len;
 
 	/* SMB headers in a compound are 8 byte aligned. */
 	if (IS_ALIGNED(len, 8))
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b434aaf15dba..01d84f9ece82 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1450,9 +1450,6 @@ SMB2_negotiate(const unsigned int xid,
 	smb->total_len   = smb->offset;
 	smb->bvecq.bv[0].bv_len = smb->offset;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	rc = smb_send_recv_messages(xid, ses, server, smb, flags);
 	smb_clear_request(smb);
 
@@ -1513,13 +1510,14 @@ SMB2_negotiate(const unsigned int xid,
 			break;
 		}
 		break;
+	case SPEC:
+		/* if requested single dialect ensure returned dialect matched */
+		if (dialect == server->vals->protocol_id)
+			break;
+		fallthrough;
 	default:
-		if (dialect != server->vals->protocol_id) {
-			/* if requested single dialect ensure returned dialect matched */
-			cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
-					dialect);
-			goto neg_exit;
-		}
+		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
+				dialect);
 		rc = smb_EIO2(smb_eio_trace_neg_unreq_dialect,
 			      dialect, server->vals->protocol_id);
 		goto neg_exit;
@@ -1895,9 +1893,6 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data,
 	req->SecurityBufferLength = cpu_to_le16(smb->total_len - sizeof(*req));
 	smb->sr_flags = CIFS_LOG_ERROR | CIFS_SESS_OP;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->total_len);
-
 	/* BB add code to build os and lm fields */
 	rc = smb_send_recv_messages(sess_data->xid, sess_data->ses, sess_data->server,
 				    smb, CIFS_LOG_ERROR | CIFS_SESS_OP);
@@ -2331,9 +2326,6 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	else if (server->sign)
 		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	smb->sr_flags = flags;
 	rc = smb_send_recv_messages(xid, ses, ses->server, smb, flags);
 	/*
@@ -2423,9 +2415,6 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		req->hdr.CreditRequest = cpu_to_le16(
 			min_t(int, server->max_credits - server->credits, 64));
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	smb->sr_flags = flags;
 	rc = smb_send_recv_messages(xid, ses, server, smb, flags);
 	smb_clear_request(smb);
@@ -2522,9 +2511,6 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	smb->sr_flags = flags;
 	rc = smb_send_recv_messages(xid, ses, server, smb, flags);
 	smb_clear_request(smb);
@@ -5052,10 +5038,10 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	smb->callback		= smb2_readv_callback;
 	smb->subreq		= rdata;
 	smb->copy_to_bufs	= true;
-
-	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
+	smb->resp_buffer	= bvecq_get(subreq->content.bvecq);
+	smb->resp_buffer_slot	= subreq->content.slot;
+	smb->resp_buffer_offset	= subreq->content.offset;
+	smb->resp_buffer_len	= subreq->len - subreq->transferred;
 
 	if (rdata->replay) {
 		/* Back-off before retry */
@@ -5085,9 +5071,6 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		smb->sr_flags |= CIFS_HAS_CREDITS;
 	}
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	rc = cifs_call_async(server, smb, smb->sr_flags, &rdata->credits);
 	if (rc) {
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
@@ -5136,9 +5119,6 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (smb3_encryption_required(io_parms->tcon))
 		smb->sr_flags |= CIFS_TRANSFORM_REQ;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
-
 	rc = smb_send_recv_messages(xid, ses, io_parms->server, smb, smb->sr_flags);
 	smb_clear_request(smb);
 
@@ -5379,6 +5359,10 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	smb->request		= req;
 	smb->callback		= smb2_writev_callback;
 	smb->subreq		= wdata;
+	smb->bvecq.next		= wdata->subreq.content.bvecq;
+	smb->req_data		= bvecq_get(wdata->subreq.content.bvecq);
+	smb->req_data_len	= wdata->subreq.len;
+	smb->req_data_nomodify	= true;
 
 	iov_iter_bvec_queue(&smb->data_iter, ITER_SOURCE,
 			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
@@ -5443,12 +5427,6 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		smbd_mr_fill_buffer_descriptor(wdata->mr, v1);
 
 		smb->rqst.rq_iov[0].iov_len += sizeof(*v1);
-
-		/*
-		 * We keep wdata->subreq.io_iter,
-		 * but we have to truncate rqst.rq_iter
-		 */
-		iov_iter_truncate(&smb->rqst.rq_iter, 0);
 	}
 #endif
 
@@ -5485,11 +5463,14 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 
 	/* XXX: compression + encryption is unsupported for now */
 	if (((smb->sr_flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) &&
-	    should_compress(tcon, smb))
-		smb->sr_flags |= CIFS_COMPRESS_REQ;
+	    should_compress(tcon, smb)) {
+		struct iov_iter ziter;
 
-	iov_iter_bvec_queue(&smb->req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
-			    smb->data_offset);
+		iov_iter_bvec_queue(&ziter, ITER_SOURCE, smb->req_data, 0, 0,
+				    smb->req_data_len);
+		if (is_compressible(&ziter))
+			smb->sr_flags |= CIFS_COMPRESS_REQ;
+	}
 
 	rc = cifs_call_async(server, smb, smb->sr_flags, &wdata->credits);
 	/* Can't touch wdata if rc == 0 */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index f63eaff4935a..72311ec8746b 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -241,7 +241,8 @@ smb2_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 	hmac_sha256_init_usingrawkey(&hmac_ctx, key, sizeof(key));
 
 	if (smb->new_style) {
-		struct iov_iter req_iter = smb->req_iter;
+		struct iov_iter req_iter;
+		iov_iter_bvec_queue(&req_iter, ITER_SOURCE, &smb->bvecq, 0, 0, smb->total_len);
 
 		size = iov_iter_count(&req_iter);
 		did = iterate_and_advance_kernel(&req_iter, size, &hmac_ctx, NULL,
@@ -255,7 +256,8 @@ smb2_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 					   smb->rqst.rq_iov[i].iov_len);
 	}
 
-	struct iov_iter data_iter = smb->data_iter;
+	struct iov_iter data_iter;
+	iov_iter_bvec_queue(&data_iter, ITER_SOURCE, smb->req_data, 0, 0, smb->total_len);
 
 	size = iov_iter_count(&data_iter);
 	did = iterate_and_advance_kernel(&data_iter, size, &hmac_ctx, NULL,
@@ -515,21 +517,28 @@ smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 	aes_cmac_init(&cmac_ctx, &cmac_key);
 
 	if (for_recv) {
-		struct iov_iter resp_iter = smb->response_iter;
-
 		size = smb->resp_len;
 		did = 0;
 
 		aes_cmac_update(&cmac_ctx, smb->response, size);
-		rc = -EIO;
-		size = iov_iter_count(&resp_iter);
-		did = iterate_and_advance_kernel(&resp_iter, size, &cmac_ctx,
-						  NULL, smb3_aes_cmac_step);
-		if (did != size)
-			goto eio;
+
+		if (smb->resp_buffer_len) {
+			struct iov_iter resp_iter;
+
+			size = umin(smb->resp_buffer_len, smb->resp_data_len);
+			iov_iter_bvec_queue(&resp_iter, ITER_SOURCE,
+					    smb->resp_buffer, 0, 0, size);
+			did = iterate_and_advance_kernel(&resp_iter, size, &cmac_ctx,
+							 NULL, smb3_aes_cmac_step);
+			if (did != size)
+				goto eio;
+		}
 	} else {
 		if (smb->new_style) {
-			struct iov_iter req_iter = smb->req_iter;
+			struct iov_iter req_iter;
+
+			iov_iter_bvec_queue(&req_iter, ITER_SOURCE, &smb->bvecq, 0, 0,
+					    smb->total_len);
 
 			size = iov_iter_count(&req_iter);
 			did = iterate_and_advance_kernel(&req_iter, size,
@@ -544,15 +553,18 @@ smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 						smb->rqst.rq_iov[i].iov_base,
 						size);
 			}
-		}
 
-		struct iov_iter data_iter = smb->data_iter;
+			struct iov_iter data_iter;
+			iov_iter_bvec_queue(&data_iter, ITER_SOURCE, smb->req_data, 0, 0,
+					    smb->req_data_len);
 
-		size = iov_iter_count(&data_iter);
-		did = iterate_and_advance_kernel(&data_iter, size, &cmac_ctx,
-						 NULL, smb3_aes_cmac_step);
-		if (did != size)
-			return smb_EIO2(smb_eio_trace_sig_iter, did, size);
+			size = iov_iter_count(&data_iter);
+			did = iterate_and_advance_kernel(&data_iter, size,
+							 &cmac_ctx, NULL,
+							 smb3_aes_cmac_step);
+			if (did != size)
+				return smb_EIO2(smb_eio_trace_sig_iter, did, size);
+		}
 	}
 
 	aes_cmac_final(&cmac_ctx, smb3_signature);
@@ -562,7 +574,7 @@ smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
 out:
 	return rc;
 eio:
-	smb_EIO2(smb_eio_trace_sig_iter, did, size);
+	rc = smb_EIO2(smb_eio_trace_sig_iter, did, size);
 	goto out;
 }
 
@@ -1239,10 +1251,16 @@ static void smb2_copy_to_prepped_buffers(struct TCP_Server_Info *server,
 					 struct cifs_receive *recv)
 {
 	const union smb2_response_hdr *h = recv->response;
-	struct iov_iter dest = smb->response_iter;
+	struct iov_iter dest;
 	unsigned int to_copy, skip;
 	int rc;
 
+	iov_iter_bvec_queue(&dest, ITER_DEST,
+			    smb->resp_buffer,
+			    smb->resp_buffer_slot,
+			    smb->resp_buffer_offset,
+			    smb->resp_buffer_len);
+	
 	switch (smb->command) {
 	case SMB2_READ:
 		to_copy = recv->data_len;
@@ -1288,7 +1306,7 @@ static void smb2_copy_to_prepped_buffers(struct TCP_Server_Info *server,
 	if (!rxq->refillable) {
 		size_t got;
 
-		got = netfs_rxqueue_read_iter(rxq, &smb->response_iter, 0, to_copy);
+		got = netfs_rxqueue_read_iter(rxq, &dest, 0, to_copy);
 		if (got > 0)
 			netfs_rxqueue_discard(rxq, got);
 		recv->extracted += got;
@@ -1468,12 +1486,13 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 			} else if (smb->copy_to_bufs) {
 				smb2_copy_to_prepped_buffers(server, smb, rxq,
 							     recv);
-			} else if (rxq->pdu_remain) {
-				iov_iter_bvec_queue(&smb->response_iter, ITER_SOURCE,
+			} else if (rxq->pdu_remain && !smb->resp_buffer) {
+				smb->resp_buffer = rxq->take_from;
+				smb->resp_buffer_len = rxq->pdu_remain;
+				iov_iter_bvec_queue(&smb->resp_extra_iter, ITER_SOURCE,
 						    rxq->take_from, rxq->take_slot,
 						    rxq->take_offset, rxq->pdu_remain);
-				smb->response_data = rxq->take_from;
-				refcount_inc(&smb->response_data->ref);
+				refcount_inc(&smb->resp_buffer->ref);
 			}
 		} else {
 			netfs_rxqueue_discard(rxq, recv->extracted);
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 212894c8d2bd..b01502c38d05 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -112,6 +112,8 @@ void smb_clear_request(struct smb_message *smb)
 		if (smb->request) {
 			if (smb->sensitive)
 				memzero_explicit(smb->request, smb->data_offset);
+			bvecq_put(smb->req_data);
+			smb->req_data = NULL;
 			cifs_free_tx_buf(smb->request);
 			smb->request = NULL;
 		}
@@ -186,8 +188,11 @@ static void smb_clear_mid(struct TCP_Server_Info *server, struct smb_message *sm
 		cifs_buf_release(smb->response);
 	else
 		cifs_small_buf_release(smb->response);
-	if (smb->response_data)
-		netfs_put_rx_bvecq(smb->response_data);
+	if (smb->resp_extra_iter.count)
+		netfs_put_rx_bvecq(smb->resp_buffer);
+	else
+		bvecq_put(smb->resp_buffer);
+	bvecq_put(smb->req_data);
 #ifdef CONFIG_CIFS_STATS2
 	now = jiffies;
 	if (now < smb->when_alloc)
@@ -532,15 +537,14 @@ static size_t smb3_copy_data_iter(void *iter_from, size_t progress, size_t len,
 /*
  * Copy the data into a buffer that we can use for encryption in place and also
  * pass to sendmsg() with MSG_SPLICE_PAGES.  This avoids a lot of copies in TCP
- * at the expense of doing it upfront here.  A spare slot is left in the bvec
- * queue at the front for the header(s).
+ * at the expense of doing it upfront here.
  *
  * TODO: In future, the buffers should be allocated by the marshalling code.
  */
 static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 				     struct smb_message *head_smb,
-				     struct iov_iter *iter, struct bvecq **_bq,
-				     unsigned int flags)
+				     struct iov_iter *iter,
+				     struct bvecq *head_bq)
 {
 	struct smb_message *smb;
 	struct bvecq *bq;
@@ -554,11 +558,11 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 
 	if (total_len <= PAGE_SIZE / 2) {
 		/* TODO: Choose algo-based alignment. */
-		unsigned int align = (flags & CIFS_TRANSFORM_REQ) ? 32 : 1;
-		size_t alen = (flags & CIFS_TRANSFORM_REQ) ?
+		unsigned int align = (head_smb->sr_flags & CIFS_TRANSFORM_REQ) ? 32 : 1;
+		size_t alen = (head_smb->sr_flags & CIFS_TRANSFORM_REQ) ?
 			round_up(total_len, align) : total_len;
 
-		bq = bvecq_alloc_chain(2, GFP_NOFS);
+		bq = bvecq_alloc_chain(1, GFP_NOFS);
 		if (!bq)
 			return -ENOMEM;
 		mutex_lock(&server->tx_alloc_lock);
@@ -569,16 +573,16 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 			bvecq_put(bq);
 			return -ENOMEM;
 		}
-		bvec_set_virt(&bq->bv[1], p, total_len);
-		bq->nr_slots = 2;
+		bvec_set_virt(&bq->bv[0], p, total_len);
+		bq->nr_slots = 1;
 		bq->mem_type = BVECQ_MEM_PAGECACHE;
 	} else {
-		bq = bvecq_alloc_buffer2(total_len, 1, GFP_NOFS);
+		bq = bvecq_alloc_buffer(total_len, GFP_NOFS);
 		if (!bq)
 			return -ENOMEM;
 	}
 
-	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
+	iov_iter_bvec_queue(iter, ITER_DEST, bq, 0, 0, total_len);
 
 	for (smb = head_smb; smb; smb = smb->next) {
 		size_t size, got;
@@ -590,9 +594,26 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 		}
 
 		if (smb->new_style) {
-			struct iov_iter req_iter = smb->req_iter;
+			struct iov_iter req_iter;
+
+			if (smb->req_data_len)
+				smb->bvecq.next = smb->req_data;
+
+			iov_iter_bvec_queue(&req_iter, ITER_SOURCE,
+					    &smb->bvecq, 0, 0, smb->total_len);
+			got = iterate_and_advance_kernel(&req_iter,
+							 smb->total_len, iter, NULL,
+							 smb3_copy_data_iter);
+			if (got != size) {
+				rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
+				goto error;
+			}
+			offset += smb->total_len;
 
+#if 0
+			struct iov_iter req_iter = smb->req_iter;
 			size = iov_iter_count(&req_iter);
+
 			got = iterate_and_advance_kernel(&req_iter,
 							 size, iter, NULL,
 							 smb3_copy_data_iter);
@@ -612,10 +633,12 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 				rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
 				goto error;
 			}
+
 			offset += size;
+#endif
 		} else {
 			/* Old-style with an rqst. */
-			size = iov_iter_count(&smb->rqst.rq_iter);
+			size = smb->rqst.rq_data_len;
 
 			for (int i = 0; i < smb->rqst.rq_nvec; i++) {
 				size_t len = smb->rqst.rq_iov[i].iov_len;
@@ -628,7 +651,12 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 				offset += len;
 			}
 
-			got = iterate_and_advance_kernel(&smb->rqst.rq_iter,
+			struct iov_iter data_iter;
+			iov_iter_bvec_queue(&data_iter, ITER_SOURCE,
+					    smb->rqst.rq_data, 0, 0,
+					    smb->rqst.rq_data_len);
+
+			got = iterate_and_advance_kernel(&data_iter,
 							 size, iter, NULL,
 							 smb3_copy_data_iter);
 			if (got != size) {
@@ -645,101 +673,152 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 		goto error;
 	}
 
-	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
-	*_bq = bq;
+	head_bq->next = bq;
 	return 0;
 error:
 	bvecq_put(bq);
-	*_bq = NULL;
 	return rc;
 }
 
 static int
-smb_send_rqst(struct TCP_Server_Info *server, struct smb_message *head_smb, int flags)
+smb_send_rqst(struct TCP_Server_Info *server, struct smb_message *head_smb)
 {
+	struct smb2_compression_hdr *z_hdr;
+	struct smb2_transform_hdr *tr_hdr;
+	struct smb_message *smb;
 	struct iov_iter iter;
-	struct bvecq *bq;
-	u32 content_len;
+	struct bvecq *copy_bq = NULL;
+	struct bio_vec head_bv = {};
+	unsigned int troff = 0, zoff = 0;
+	__be32 *rfc1002;
+	void *hdr_blob = NULL;
+	bool must_copy = false;
+	u32 hdr_len, content_len = 0;
 	int rc;
 
-	if ((flags & CIFS_TRANSFORM_REQ) &&
+	if ((head_smb->sr_flags & CIFS_TRANSFORM_REQ) &&
 	    !server->ops->init_transform_rq) {
 		cifs_server_dbg(VFS, "Encryption requested but transform callback is missing\n");
 		return smb_EIO(smb_eio_trace_tx_need_transform);
 	}
 
-	rc = smb_copy_data_into_buffer(server, head_smb, &iter, &bq, flags);
-	if (rc)
-		return rc;
-	content_len = iov_iter_count(&iter);
+	/* We start with a buffer segment that just contains the header.  This
+	 * then links on to first message in a compound for new-style buffer
+	 * handling.  We end up with a sequence:
+	 *
+	 *    pduhdr->smb1->data1->smb2->data2->smb3->data3->...
+	 *
+	 * Where dataN only exists for something like Write.
+	 */
+	struct bvecq head_bq = {
+		.ref		= REFCOUNT_INIT(1),
+		.nr_slots	= 1,
+		.max_slots	= 1,
+		.bv		= &head_bv,
+	};
 
-	{
-		struct smb2_transform_hdr *tr_hdr;
-		unsigned int hdr_len = 4, troff = 0;
-		__le32 *rfc1002;
-		void *hdr_blob;
+	/* Allocate space to store the RFC1002, Transform and Compress headers
+	 * as needed.  The latter part of the Transform header needs to be
+	 * accessed by the encryption routine for inclusion in the checksum.
+	 * The Compress header gets encrypted.
+	 */
+	hdr_len = sizeof(*rfc1002);
+	if (head_smb->sr_flags & CIFS_TRANSFORM_REQ) {
+		troff = hdr_len;
+		hdr_len += sizeof(*tr_hdr);
+	}
+	if (head_smb->sr_flags & CIFS_COMPRESS_REQ) {
+		zoff = hdr_len;
+		hdr_len += sizeof(*z_hdr);
+	}
 
-		if (flags & CIFS_TRANSFORM_REQ) {
-			troff = hdr_len;
-			hdr_len += sizeof(*tr_hdr);
-		}
+	rc = -ENOMEM;
+	hdr_blob = cifs_allocate_tx_buf(server, hdr_len);
+	if (!hdr_blob)
+		goto error;
+	bvec_set_virt(&head_bv, hdr_blob, hdr_len);
 
-		/* TODO: Allocate netmem here */
-		rc = -ENOMEM;
-		mutex_lock(&server->tx_alloc_lock);
-		hdr_blob = page_frag_alloc(&server->tx_alloc, hdr_len, GFP_NOFS);
-		mutex_unlock(&server->tx_alloc_lock);
-		if (!hdr_blob)
-			goto error;
-		bvec_set_virt(&bq->bv[0], hdr_blob, hdr_len);
-
-		if (flags & CIFS_COMPRESS_REQ) {
-			struct smb2_write_req *whdr = bvec_virt(&bq->bv[1]);
-			size_t doff = le16_to_cpu(whdr->DataOffset);
-
-			iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 1, doff,
-					    content_len - doff);
-
-			if (is_compressible(&iter)) {
-				iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 1, 0,
-						    content_len);
-
-				rc = smb_compress(server, &iter, &bq);
-				if (rc > 0) {
-					content_len = rc;
-				} else if (rc == -EMSGSIZE) {
-					/* Fall back to uncompressed. */
-				} else {
-					if (rc == 0)
-						rc = smb_EIO(smb_eio_trace_tx_compress_failed);
-					goto error;
-				}
-			}
+	/* Work out whether we need to copy some or all of the protocol and the
+	 * data.  For old-style (smb_rqst) buffering, we copy everything and
+	 * also for compression; for encryption, we only really need to copy
+	 * any data that can't be modified in-place (e.g. for Write ops).
+	 */
+	for (smb = head_smb; smb; smb = smb->next) {
+		content_len += smb->total_len;
+		if (smb->sr_flags & CIFS_COMPRESS_REQ) {
+			must_copy = true;
+			continue;
+		}
+		if (!smb->new_style) {
+			must_copy = true;
+			continue;
 		}
+		if ((smb->sr_flags & CIFS_TRANSFORM_REQ) &&
+		    smb->req_data_nomodify &&
+		    smb->req_data_len > 0) {
+			must_copy = true;
+			continue;
+		}
+	}
 
-		if (flags & CIFS_TRANSFORM_REQ) {
-			iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 0, 0,
-					    hdr_len + content_len);
-			iov_iter_advance(&iter, troff);
-			tr_hdr = hdr_blob + troff;
+	if (must_copy) {
+		rc = smb_copy_data_into_buffer(server, head_smb, &iter, &head_bq);
+		if (rc)
+			return rc;
+		copy_bq = head_bq.next;
+	} else {
+		head_bq.next = &head_smb->bvecq;
+	}
 
-			rc = server->ops->init_transform_rq(server, head_smb, tr_hdr, &iter);
-			if (rc)
-				goto error;
-			content_len += sizeof(*tr_hdr);
+	/* Attempt to do compression.  This may fail at this point if the data
+	 * isn't sufficiently compressible.  Note that the signature hash is
+	 * calculated over the decompressed content.
+	 */
+	if (head_smb->sr_flags & CIFS_COMPRESS_REQ) {
+		iov_iter_bvec_queue(&iter, ITER_SOURCE, copy_bq, 0, 0,
+				    content_len);
+
+		z_hdr = hdr_blob + zoff;
+		rc = smb_compress(server, &iter, &copy_bq, z_hdr);
+		if (rc > 0) {
+			content_len = rc;
+		} else if (rc == -EMSGSIZE) {
+			/* Fall back to uncompressed. */
+			hdr_len -= sizeof(*z_hdr);
+			head_bv.bv_len = hdr_len;
 		} else {
-			bvec_set_virt(&bq->bv[0], hdr_blob, hdr_len);
+			if (rc == 0)
+				rc = smb_EIO(smb_eio_trace_tx_compress_failed);
+			goto error;
 		}
+	}
 
-		/* Set the RFC1002 header at the front. */
-		rfc1002 = hdr_blob;
-		*rfc1002 = cpu_to_be32(RFC1002_SESSION_MESSAGE << 24 | content_len);
+	/* We can now encrypt the data - which includes the Compress header.
+	 * The buffer will have been fixed up so that we can encrypt in-place.
+	 * TODO: We could use async crypto or offload, but we will have to make
+	 * sure the PDUs get transmitted in the right order.
+	 */
+	if (head_smb->sr_flags & CIFS_TRANSFORM_REQ) {
+		iov_iter_bvec_queue(&iter, ITER_SOURCE, copy_bq, 0, 0,
+				    hdr_len + content_len);
+		iov_iter_advance(&iter, troff);
+		tr_hdr = hdr_blob + troff;
 
-		iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 0, 0, 4 + content_len);
+		rc = server->ops->init_transform_rq(server, head_smb, tr_hdr, &iter);
+		if (rc)
+			goto error;
 	}
+
+	/* Set the RFC1002 header at the front. */
+	rfc1002 = hdr_blob;
+	*rfc1002 = cpu_to_be32(RFC1002_SESSION_MESSAGE << 24 |
+			       (hdr_len - sizeof(*rfc1002) + content_len));
+
+	iov_iter_bvec_queue(&iter, ITER_SOURCE, &head_bq, 0, 0, hdr_len + content_len);
 	rc = __smb_send_rqst(server, &iter);
 error:
-	bvecq_put(bq);
+	cifs_free_tx_buf(hdr_blob);
+	bvecq_put(copy_bq);
 	return rc;
 }
 
@@ -1039,7 +1118,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(smb);
-	rc = smb_send_rqst(server, smb, flags);
+	rc = smb_send_rqst(server, smb);
 
 	if (rc < 0) {
 		revert_current_mid(server, smb->credits_consumed);
@@ -1280,7 +1359,7 @@ int smb_send_recv_messages(const unsigned int xid, struct cifs_ses *ses,
 		smb->mid_state = MID_REQUEST_SUBMITTED;
 	}
 
-	rc = smb_send_rqst(server, head_smb, flags);
+	rc = smb_send_rqst(server, head_smb);
 
 	for (struct smb_message *smb = head_smb; smb; smb = smb->next)
 		cifs_save_when_sent(smb);
@@ -1432,7 +1511,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		smb->request		= request;
 		smb->rqst		= *rq;
 		smb->sr_flags		= flags;
-		smb->data_iter		= rq->rq_iter;
 
 		if (is_smb1(server)) {
 			smb->command = 0;
@@ -1441,7 +1519,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		for (int j = 0; j < rq->rq_nvec; j++)
 			smb->total_len += rq->rq_iov[j].iov_len;
-		smb->total_len += iov_iter_count(&rq->rq_iter);
 	}
 
 	rc = smb_send_recv_messages(xid, ses, server, head_smb, flags);

