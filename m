Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0D4D990D
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186241; cv=none; b=JYNR76VJWw/b6+LD4kA+hby8wPnI/aph7R0leCMP8usedb16WoD3yG3/NPfXNFn44mTmJ4/s5bzM8GqqpowLa5z0BCeVSoFQRR4dVUyYXBfsZn3Ch7TPV4TICfbQSx9Ds/IM9YfB5XH856tfyo4t+MW+HZfu3jEMnAyJgfHsTYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186241; c=relaxed/simple;
	bh=mVWFy46cMuFVcIfL1nrCjVTLzeUSf+V0FaAHF5luz04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us9kP/1OR7MPCpBDjCYHyNE64gZom0oB5QClt/6rxXziIm+LTTbEOkZmhxK/ORbkdfM+sc60tenlJuPHP2a/PMNxXVVxSqnqFJn0Ia/REgUNBzpdY9PGejdpNAB/rFiKkorEdQUMctUwv+8axTmcKhSVi6+LEzYMIa2OvXlvtCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Src0Xvf4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Src0Xvf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+EZe3/Opbqn6AXMHL3mIwaioMxtPWw0a5KagCd/VnY=;
	b=Src0Xvf4x0xR7azwWH02Q6h3+aCqDwefuziYo2soxDFv3EcOBCgk+gaUcy3L/PDwDByv3G
	VN5+s7eQV0dx9D2WiBIFOneB4t+4u4PaE+2wNQP1YqORKfaMd4pPKahEPM5YJFZ8fsvi0V
	kiT6p3dPFiWyEeAf/ngnnS7beFuyfcY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-lRP78vTbNS21QD2-zxlSqw-1; Tue,
 19 May 2026 06:23:46 -0400
X-MC-Unique: lRP78vTbNS21QD2-zxlSqw-1
X-Mimecast-MFC-AGG-ID: lRP78vTbNS21QD2-zxlSqw_1779186224
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F5B418005B4;
	Tue, 19 May 2026 10:23:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE0D030001A2;
	Tue, 19 May 2026 10:23:40 +0000 (UTC)
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
Subject: [RFC PATCH 20/36] cifs: Pass smb_message structs down into the transport layer
Date: Tue, 19 May 2026 11:21:38 +0100
Message-ID: <20260519102158.592165-21-dhowells@redhat.com>
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

Institute the creation of smb_message structs at the layer above the
transport layer and pass them down into the transport layer.  This replaces
the handling of mid_q_structs entirely within the transport layer.

This includes the following changes:

 (1) The smb_rqst struct is partially absorbed into the smb_message struct.
     Because the latter is on a linked list, the fixed-size arrays of
     requests can be got rid of - along with the COMPOUND_MAX-1 limit that
     gets imposed by the encryption code because it needs to steal a slot
     for the transform header.

 (2) Hand smb_message structs into the message sending code in the
     transport rather than allocating them (as it did for mid_q_structs) in
     the ->setup_request/->setup_async_request functions.

     For the moment compound_send_rcv() does the generation of smb_message
     structs, stringing them together before passing them down.

 (3) Protocol Message IDs are allocated at the time of transmission and as
     the code to do that is called by protocol-specific code, we don't need
     a function pointer or so many wrapper functions for it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h      |  40 +---
 fs/smb/client/cifsproto.h     | 105 +---------
 fs/smb/client/cifssmb.c       | 155 ++++++++------
 fs/smb/client/compress.c      |  10 +-
 fs/smb/client/compress.h      |   4 +-
 fs/smb/client/connect.c       |  21 +-
 fs/smb/client/smb1misc.c      |   2 -
 fs/smb/client/smb1ops.c       |  25 +--
 fs/smb/client/smb1proto.h     |  17 +-
 fs/smb/client/smb1transport.c | 105 ++++------
 fs/smb/client/smb2misc.c      |  42 ++--
 fs/smb/client/smb2ops.c       |  13 +-
 fs/smb/client/smb2pdu.c       | 230 +++++++++++---------
 fs/smb/client/smb2proto.h     |  29 +--
 fs/smb/client/smb2transport.c | 242 ++++++++++-----------
 fs/smb/client/trace.h         |  26 ++-
 fs/smb/client/transport.c     | 382 ++++++++++++++++++++--------------
 17 files changed, 710 insertions(+), 738 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cd9bf550a144..c444b7d81c23 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -312,18 +312,16 @@ struct cifs_credits;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct cifs_ses *ses, struct TCP_Server_Info *server,
-			   struct smb_rqst *rqst, struct smb_message *smb,
-			   unsigned int xid);
+			   struct smb_message *smb, unsigned int xid);
 	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
-	/* setup request: allocate mid, sign message */
-	struct smb_message *(*setup_request)(struct cifs_ses *ses,
-					     struct TCP_Server_Info *server,
-					     struct smb_rqst *rqst);
+	/* setup request: set up mid, sign message */
+	int (*setup_request)(struct cifs_ses *ses,
+			     struct TCP_Server_Info *server,
+			     struct smb_message *smb);
 	/* setup async request: allocate mid, sign message */
-	struct smb_message *(*setup_async_request)(struct TCP_Server_Info *server,
-						   struct smb_rqst *rqst);
+	int (*setup_async_request)(struct TCP_Server_Info *server, struct smb_message *smb);
 	/* check response: verify signature, map error */
-	int (*check_receive)(struct smb_message *mid, struct TCP_Server_Info *server,
+	int (*check_receive)(struct smb_message *smb, struct TCP_Server_Info *server,
 			     bool log_error);
 	void (*add_credits)(struct TCP_Server_Info *server,
 			    struct cifs_credits *credits,
@@ -331,7 +329,6 @@ struct smb_version_operations {
 	void (*set_credits)(struct TCP_Server_Info *, const int);
 	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
 	unsigned int (*get_credits)(struct smb_message *smb);
-	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	void (*revert_current_mid)(struct TCP_Server_Info *server,
 				   const unsigned int val);
 	/* Finish receiving a PDU and decrypt and decompress and parse it. */
@@ -571,10 +568,8 @@ struct smb_version_operations {
 	long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
 			  loff_t);
 	/* init transform (compress/encrypt) request */
-	int (*init_transform_rq)(struct TCP_Server_Info *server,
-				 int num_rqst, const struct smb_rqst *rqst,
-				 struct smb2_transform_hdr *tr_hdr,
-				 struct iov_iter *iter);
+	int (*init_transform_rq)(struct TCP_Server_Info *server, struct smb_message *head_smb,
+				 struct smb2_transform_hdr *tr_hdr, struct iov_iter *iter);
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
 	int (*next_header)(struct TCP_Server_Info *server, char *buf,
@@ -898,23 +893,6 @@ adjust_credits(struct TCP_Server_Info *server, struct cifs_io_subrequest *subreq
 		server->ops->adjust_credits(server, subreq, trace) : 0;
 }
 
-static inline __le64
-get_next_mid64(struct TCP_Server_Info *server)
-{
-	return cpu_to_le64(server->ops->get_next_mid(server));
-}
-
-static inline __le16
-get_next_mid(struct TCP_Server_Info *server)
-{
-	__u16 mid = server->ops->get_next_mid(server);
-	/*
-	 * The value in the SMB header should be little endian for easy
-	 * on-the-wire decoding.
-	 */
-	return cpu_to_le16(mid);
-}
-
 static inline void
 revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 {
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1c9ac67b7294..47f78955796f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -92,10 +92,8 @@ char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
-int cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		    mid_callback_t callback, void *cbdata, const int flags,
-		    const struct cifs_credits *exist_credits,
-		    struct iov_iter *resp_buf);
+int cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
+		    const int flags, const struct cifs_credits *exist_credits);
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
 int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   struct TCP_Server_Info *server, struct smb_rqst *rqst,
@@ -114,11 +112,10 @@ int cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 
 static inline int
 send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-	    struct smb_rqst *rqst, struct smb_message *smb,
-	    unsigned int xid)
+	    struct smb_message *smb, unsigned int xid)
 {
 	return server->ops->send_cancel ?
-		server->ops->send_cancel(ses, server, rqst, smb, xid) : 0;
+		server->ops->send_cancel(ses, server, smb, xid) : 0;
 }
 
 int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb);
@@ -465,12 +462,6 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
-static inline void release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
-{
-	if (refcount_dec_and_test(&smb->ref))
-		__release_mid(server, smb);
-}
-
 static inline void cifs_free_open_info(struct cifs_open_info_data *data)
 {
 	kfree(data->symlink_target);
@@ -496,94 +487,6 @@ static inline int smb_EIO2(enum smb_eio_trace trace, unsigned long info, unsigne
 	return -EIO;
 }
 
-static inline int cifs_get_num_sgs(const struct smb_rqst *rqst,
-				   int num_rqst,
-				   const u8 *sig)
-{
-	unsigned int len, skip;
-	unsigned int nents = 0;
-	unsigned long addr;
-	size_t data_size;
-	int i, j;
-
-	/*
-	 * The first rqst has a transform header where the first 20 bytes are
-	 * not part of the encrypted blob.
-	 */
-	skip = 20;
-
-	/* Assumes the first rqst has a transform header as the first iov.
-	 * I.e.
-	 * rqst[0].rq_iov[0]  is transform header
-	 * rqst[0].rq_iov[1+] data to be encrypted/decrypted
-	 * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
-	 */
-	for (i = 0; i < num_rqst; i++) {
-		data_size = iov_iter_count(&rqst[i].rq_iter);
-
-		/* We really don't want a mixture of pinned and unpinned pages
-		 * in the sglist.  It's hard to keep track of which is what.
-		 * Instead, we convert to a BVEC-type iterator higher up.
-		 */
-		if (data_size &&
-		    WARN_ON_ONCE(user_backed_iter(&rqst[i].rq_iter)))
-			return smb_EIO(smb_eio_trace_user_iter);
-
-		/* We also don't want to have any extra refs or pins to clean
-		 * up in the sglist.
-		 */
-		if (data_size &&
-		    WARN_ON_ONCE(iov_iter_extract_will_pin(&rqst[i].rq_iter)))
-			return smb_EIO(smb_eio_trace_extract_will_pin);
-
-		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			struct kvec *iov = &rqst[i].rq_iov[j];
-
-			addr = (unsigned long)iov->iov_base + skip;
-			if (is_vmalloc_or_module_addr((void *)addr)) {
-				len = iov->iov_len - skip;
-				nents += DIV_ROUND_UP(offset_in_page(addr) + len,
-						      PAGE_SIZE);
-			} else {
-				nents++;
-			}
-			skip = 0;
-		}
-		if (data_size)
-			nents += iov_iter_npages(&rqst[i].rq_iter, INT_MAX);
-	}
-	nents += DIV_ROUND_UP(offset_in_page(sig) + SMB2_SIGNATURE_SIZE, PAGE_SIZE);
-	return nents;
-}
-
-/* We can not use the normal sg_set_buf() as we will sometimes pass a
- * stack object as buf.
- */
-static inline void cifs_sg_set_buf(struct sg_table *sgtable,
-				   const void *buf,
-				   unsigned int buflen)
-{
-	unsigned long addr = (unsigned long)buf;
-	unsigned int off = offset_in_page(addr);
-
-	addr &= PAGE_MASK;
-	if (is_vmalloc_or_module_addr((void *)addr)) {
-		do {
-			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
-
-			sg_set_page(&sgtable->sgl[sgtable->nents++],
-				    vmalloc_to_page((void *)addr), len, off);
-
-			off = 0;
-			addr += PAGE_SIZE;
-			buflen -= len;
-		} while (buflen);
-	} else {
-		sg_set_page(&sgtable->sgl[sgtable->nents++],
-			    virt_to_page((void *)addr), buflen, off);
-	}
-}
-
 static inline int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 					 unsigned int find_flags,
 					 struct cifsFileInfo **ret_file)
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c5b18e1c44ab..ebd95de2cd91 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -261,7 +261,6 @@ small_smb_init_no_tc(const int smb_command, const int wct,
 		return rc;
 
 	buffer = (struct smb_hdr *)*request_buf;
-	buffer->Mid = get_next_mid(ses->server);
 	if (ses->capabilities & CAP_UNICODE)
 		buffer->Flags2 |= SMBFLG2_UNICODE;
 	if (ses->capabilities & CAP_STATUS32)
@@ -411,7 +410,6 @@ CIFSSMBNegotiate(const unsigned int xid,
 		return rc;
 	in_len = rc;
 
-	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= SMBFLG2_ERR_STATUS;
 
 	if (ses->unicode != 0)
@@ -531,7 +529,6 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	in_len = header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
 				 NULL /*no tid */, 4 /*wct */);
 
-	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
 	pSMB = (TCONX_REQ *) smb_buffer;
 	pSMBr = (TCONX_RSP *) smb_buffer_response;
@@ -699,50 +696,55 @@ cifs_echo_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
-	release_mid(server, smb);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
 int
 CIFSSMBEcho(struct TCP_Server_Info *server)
 {
-	ECHO_REQ *smb;
+	struct smb_message *smb;
+	ECHO_REQ *req;
 	int rc = 0;
 	struct kvec iov[1];
-	struct smb_rqst rqst = {
-		.rq_iov = iov,
-		.rq_nvec = ARRAY_SIZE(iov),
-	};
 	unsigned int in_len;
 
 	cifs_dbg(FYI, "In echo request\n");
 
-	rc = small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&smb);
+	smb = smb_message_alloc(smb1_command_trace_echo, GFP_NOFS);
+	if (!smb)
+		return -ENOMEM;
+
+	rc = small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&req);
 	if (rc < 0)
 		return rc;
 	in_len = rc;
 
 	if (server->capabilities & CAP_UNICODE)
-		smb->hdr.Flags2 |= SMBFLG2_UNICODE;
+		req->hdr.Flags2 |= SMBFLG2_UNICODE;
 
 	/* set up echo request */
-	smb->hdr.Tid = 0xffff;
-	smb->hdr.WordCount = 1;
-	put_unaligned_le16(1, &smb->EchoCount);
-	put_bcc(1, &smb->hdr);
-	smb->Data[0] = 'a';
+	req->hdr.Tid = 0xffff;
+	req->hdr.WordCount = 1;
+	put_unaligned_le16(1, &req->EchoCount);
+	put_bcc(1, &req->hdr);
+	req->Data[0] = 'a';
 	in_len += 3;
 
-	iov[0].iov_len = in_len;
-	iov[0].iov_base = smb;
+	iov[0].iov_len	= in_len;
+	iov[0].iov_base	= req;
+	smb->rqst.rq_iov	= iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->request		= req;
+	smb->total_len		= in_len;
+	smb->callback		= cifs_echo_callback;
+	smb->callback_data	= server;
 
-	rc = cifs_call_async(server, &rqst, cifs_echo_callback, server,
-			     CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL, NULL);
+	rc = cifs_call_async(server, smb, CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
-	cifs_small_buf_release(smb);
-
+	cifs_small_buf_release(req);
+	smb_put_message(smb);
 	return rc;
 }
 
@@ -779,8 +781,6 @@ CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses)
 	}
 	in_len = rc;
 
-	pSMB->hdr.Mid = get_next_mid(ses->server);
-
 	if (ses->server->sign)
 		pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
@@ -1526,7 +1526,6 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	rdata->subreq.transferred += smb->resp_data_len;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
-	release_mid(server, smb);
 	add_credits(server, &credits, 0);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
@@ -1538,12 +1537,10 @@ int
 cifs_async_readv(struct cifs_io_subrequest *rdata)
 {
 	int rc;
-	READ_REQ *smb = NULL;
+	READ_REQ *req = NULL;
 	int wct;
+	struct smb_message *smb;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 1 };
-	struct iov_iter iter;
 	unsigned int in_len;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%zu\n",
@@ -1559,35 +1556,52 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 		}
 	}
 
-	rc = small_smb_init(SMB_COM_READ_ANDX, wct, tcon, (void **)&smb);
+	smb = smb_message_alloc(smb1_command_trace_read, GFP_NOFS);
+	if (!smb)
+		return -ENOMEM;
+
+	rc = small_smb_init(SMB_COM_READ_ANDX, wct, tcon, (void **)&req);
 	if (rc < 0)
-		return rc;
+		goto put_smb;
 	in_len = rc;
 
-	smb->hdr.Pid = cpu_to_le16((__u16)rdata->req->pid);
-	smb->hdr.PidHigh = cpu_to_le16((__u16)(rdata->req->pid >> 16));
+	req->hdr.Pid = cpu_to_le16((__u16)rdata->req->pid);
+	req->hdr.PidHigh = cpu_to_le16((__u16)(rdata->req->pid >> 16));
 
-	smb->AndXCommand = 0xFF;	/* none */
-	smb->Fid = rdata->req->cfile->fid.netfid;
-	smb->OffsetLow = cpu_to_le32(rdata->subreq.start & 0xFFFFFFFF);
+	req->AndXCommand = 0xFF;	/* none */
+	req->Fid = rdata->req->cfile->fid.netfid;
+	req->OffsetLow = cpu_to_le32(rdata->subreq.start & 0xFFFFFFFF);
 	if (wct == 12)
-		smb->OffsetHigh = cpu_to_le32(rdata->subreq.start >> 32);
-	smb->Remaining = 0;
-	smb->MaxCount = cpu_to_le16(rdata->subreq.len & 0xFFFF);
-	smb->MaxCountHigh = cpu_to_le32(rdata->subreq.len >> 16);
+		req->OffsetHigh = cpu_to_le32(rdata->subreq.start >> 32);
+	req->Remaining = 0;
+	req->MaxCount = cpu_to_le16(rdata->subreq.len & 0xFFFF);
+	req->MaxCountHigh = cpu_to_le32(rdata->subreq.len >> 16);
 	if (wct == 12)
-		smb->ByteCount = 0;
+		req->ByteCount = 0;
 	else {
 		/* old style read */
-		struct smb_com_readx_req *smbr =
-			(struct smb_com_readx_req *)smb;
-		smbr->ByteCount = 0;
+		struct smb_com_readx_req *reqr =
+			(struct smb_com_readx_req *)req;
+		reqr->ByteCount = 0;
 	}
 
 	/* 4 for RFC1001 length + 1 for BCC */
-	rdata->iov[0].iov_base = smb;
+	rdata->iov[0].iov_base = req;
 	rdata->iov[0].iov_len = in_len;
 
+	smb->rqst.rq_iov	= rdata->iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->command		= SMB2_READ;
+	smb->request		= req;
+	smb->total_len		= in_len;
+	smb->callback		= cifs_readv_callback;
+	smb->callback_data	= rdata;
+	smb->copy_to_bufs	= true;
+
+	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
+			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
+			    rdata->subreq.content.offset, rdata->subreq.len);
+
 	trace_smb3_read_enter(rdata->rreq->debug_id,
 			      rdata->subreq.debug_index,
 			      rdata->xid,
@@ -1595,16 +1609,12 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 			      tcon->tid, tcon->ses->Suid,
 			      rdata->subreq.start, rdata->subreq.len);
 
-	iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
-
-	rc = cifs_call_async(tcon->ses->server, &rqst,
-			     cifs_readv_callback, rdata, 0, NULL, &iter);
+	rc = cifs_call_async(tcon->ses->server, smb, 0, NULL);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
-	cifs_small_buf_release(smb);
+put_smb:
+	smb_put_message(smb);
 	return rc;
 }
 
@@ -1915,7 +1925,6 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 			      0, cifs_trace_rw_credits_write_response_clear);
 	wdata->credits.value = 0;
 	cifs_write_subrequest_terminated(wdata, result);
-	release_mid(server, smb);
 	trace_smb3_rw_credits(credits.rreq_debug_id, credits.rreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
@@ -1929,9 +1938,9 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 	int rc = -EACCES;
 	WRITE_REQ *req = NULL;
 	int wct;
+	struct smb_message *smb;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	struct kvec iov[1];
-	struct smb_rqst rqst = { };
 	unsigned int in_len;
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
@@ -1945,11 +1954,33 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 		}
 	}
 
+	smb = smb_message_alloc(smb1_command_trace_write, GFP_NOFS);
+	if (!smb) {
+		rc = -ENOMEM;
+		goto out_put;
+	}
+
 	rc = small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (void **)&req);
 	if (rc < 0)
 		goto async_writev_out;
 	in_len = rc;
 
+	iov[0].iov_base	= req;
+	iov[0].iov_len	= in_len + 1; /* +1 for BCC */
+
+	smb->rqst.rq_iov	= iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->command		= SMB2_WRITE;
+	smb->request		= req;
+	smb->total_len		= in_len + 1;
+	smb->total_len		+= wdata->subreq.len;
+	smb->callback		= cifs_writev_callback;
+	smb->callback_data	= wdata;
+
+	iov_iter_bvec_queue(&smb->rqst.rq_iter, ITER_DEST,
+			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
+			    wdata->subreq.content.offset, wdata->subreq.len);
+
 	req->hdr.Pid = cpu_to_le16((__u16)wdata->req->pid);
 	req->hdr.PidHigh = cpu_to_le16((__u16)(wdata->req->pid >> 16));
 
@@ -1965,16 +1996,6 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 	req->DataOffset =
 	    cpu_to_le16(offsetof(struct smb_com_write_req, Data));
 
-	iov[0].iov_base = req;
-	iov[0].iov_len = in_len + 1; /* +1 for BCC */
-
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 1;
-
-	iov_iter_bvec_queue(&rqst.rq_iter, ITER_SOURCE,
-			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
-			    wdata->subreq.content.offset, wdata->subreq.len);
-
 	cifs_dbg(FYI, "async write at %llu %zu bytes\n",
 		 wdata->subreq.start, wdata->subreq.len);
 
@@ -1993,14 +2014,15 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 		iov[0].iov_len += 4; /* pad bigger by four bytes */
 	}
 
-	rc = cifs_call_async(tcon->ses->server, &rqst,
-			     cifs_writev_callback, wdata, 0, NULL, NULL);
+	rc = cifs_call_async(tcon->ses->server, smb, 0, NULL);
 	/* Can't touch wdata if rc == 0 */
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 
 async_writev_out:
 	cifs_small_buf_release(req);
+out_put:
+	smb_put_message(smb);
 out:
 	if (rc) {
 		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
@@ -4750,7 +4772,6 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 
 	/* server pointer checked in called function,
 	but should never be null here anyway */
-	pSMB->hdr.Mid = get_next_mid(ses->server);
 	pSMB->hdr.Tid = ses->tcon_ipc->tid;
 	pSMB->hdr.Uid = ses->Suid;
 	if (ses->capabilities & CAP_STATUS32)
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index a9496983ac56..36eb8a604603 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -277,10 +277,8 @@ bool is_compressible(const struct iov_iter *data)
  *
  * Return false otherwise.
  */
-bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
+bool should_compress(const struct cifs_tcon *tcon, const struct smb_message *smb)
 {
-	const struct smb2_hdr *shdr = rq->rq_iov->iov_base;
-
 	if (unlikely(!tcon || !tcon->ses || !tcon->ses->server))
 		return false;
 
@@ -290,8 +288,8 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 	if (!(tcon->share_flags & SMB2_SHAREFLAG_COMPRESS_DATA))
 		return false;
 
-	if (shdr->Command == SMB2_WRITE) {
-		const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
+	if (smb->command == SMB2_WRITE) {
+		const struct smb2_write_req *wreq = smb->request;
 
 		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)
 			return false;
@@ -299,7 +297,7 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 		return true;
 	}
 
-	return (shdr->Command == SMB2_READ);
+	return smb->command == SMB2_READ;
 }
 
 /*
diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index 48812b0e7476..d03f7342b4bd 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -32,7 +32,7 @@ typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *
 
 int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 		 struct bvecq **bq);
-bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
+bool should_compress(const struct cifs_tcon *tcon, const struct smb_message *smb);
 bool is_compressible(const struct iov_iter *data);
 
 /*
@@ -67,7 +67,7 @@ int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
 }
 
 static inline bool is_compressible(const struct iov_iter *data) { return false; }
-static inline bool should_compress(void *unused1, void *unused2)
+static inline bool should_compress(const struct cifs_tcon *tcon, const struct smb_message *smb)
 {
 	return false;
 }
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 1d6a18390a25..dd092f0a0515 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -364,7 +364,6 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
-		smb_get_message(smb);
 		if (smb->mid_state == MID_REQUEST_SUBMITTED)
 			smb->mid_state = MID_RETRY_NEEDED;
 		list_move(&smb->qhead, &retry_list);
@@ -377,7 +376,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	list_for_each_entry_safe(smb, nsmb, &retry_list, qhead) {
 		list_del_init(&smb->qhead);
 		mid_execute_callback(server, smb);
-		release_mid(server, smb);
+		smb_put_message(smb);
 	}
 }
 
@@ -807,9 +806,9 @@ static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 		    server->tcpStatus == CifsInNegotiate &&
 		    !server->with_rfc1001 &&
 		    server->rfc1001_sessinit != 0) {
-			int rc, mid_rc;
 			struct smb_message *smb, *nsmb;
 			LIST_HEAD(dispose_list);
+			int rc, mid_rc;
 
 			cifs_dbg(FYI, "RFC 1002 negative session response during SMB Negotiate, retrying with NetBIOS session\n");
 
@@ -822,7 +821,6 @@ static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 			 */
 			spin_lock(&server->mid_queue_lock);
 			list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
-				smb_get_message(smb);
 				list_move(&smb->qhead, &dispose_list);
 				smb->deleted_from_q = true;
 			}
@@ -856,7 +854,7 @@ static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 				smb->mid_rc = mid_rc;
 				smb->mid_state = MID_RC;
 				mid_execute_callback(server, smb);
-				release_mid(server, smb);
+				smb_put_message(smb);
 			}
 
 			/*
@@ -910,6 +908,7 @@ dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb, bool malfor
 		spin_unlock(&server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
+		smb_put_message(smb);
 		list_del_init(&smb->qhead);
 		smb->deleted_from_q = true;
 		spin_unlock(&server->mid_queue_lock);
@@ -1010,15 +1009,12 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	}
 
 	if (!list_empty(&server->pending_mid_q)) {
-		struct smb_message *smb;
-		struct list_head *tmp, *tmp2;
+		struct smb_message *smb, *smb2;
 		LIST_HEAD(dispose_list);
 
 		spin_lock(&server->mid_queue_lock);
-		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
-			smb = list_entry(tmp, struct smb_message, qhead);
+		list_for_each_entry_safe(smb, smb2, &server->pending_mid_q, qhead) {
 			cifs_dbg(FYI, "Clearing mid %llu\n", smb->mid);
-			smb_get_message(smb);
 			smb->mid_state = MID_SHUTDOWN;
 			list_move(&smb->qhead, &dispose_list);
 			smb->deleted_from_q = true;
@@ -1026,12 +1022,11 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_unlock(&server->mid_queue_lock);
 
 		/* now walk dispose list and issue callbacks */
-		list_for_each_safe(tmp, tmp2, &dispose_list) {
-			smb = list_entry(tmp, struct smb_message, qhead);
+		list_for_each_entry_safe(smb, smb2, &dispose_list, qhead) {
 			cifs_dbg(FYI, "Callback mid %llu\n", smb->mid);
 			list_del_init(&smb->qhead);
 			mid_execute_callback(server, smb);
-			release_mid(server, smb);
+			smb_put_message(smb);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
diff --git a/fs/smb/client/smb1misc.c b/fs/smb/client/smb1misc.c
index 357850e9691f..a765b18fcab8 100644
--- a/fs/smb/client/smb1misc.c
+++ b/fs/smb/client/smb1misc.c
@@ -45,8 +45,6 @@ header_assemble(struct smb_hdr *buffer, char smb_command,
 
 			/* Uid is not converted */
 			buffer->Uid = treeCon->ses->Suid;
-			if (treeCon->ses->server)
-				buffer->Mid = get_next_mid(treeCon->ses->server);
 		}
 		if (treeCon->Flags & SMB_SHARE_IS_IN_DFS)
 			buffer->Flags2 |= SMBFLG2_DFS;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 8477440bbcc2..fb3529a79c6b 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -139,11 +139,10 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
  */
 static int
 send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-	       struct smb_rqst *rqst, struct smb_message *smb,
-	       unsigned int xid)
+	       struct smb_message *smb, unsigned int xid)
 {
 	struct iov_iter iter;
-	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb_hdr *in_buf = (struct smb_hdr *)smb->rqst.rq_iov[0].iov_base;
 	struct kvec iov[1];
 	struct smb_rqst crqst = { .rq_iov = iov, .rq_nvec = 1 };
 	int rc = 0;
@@ -189,11 +188,10 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
  */
 static int
 send_lock_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		 struct smb_rqst *rqst, struct smb_message *smb,
-		 unsigned int xid)
+		 struct smb_message *smb, unsigned int xid)
 {
-	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
-	unsigned int in_len = rqst->rq_iov[0].iov_len;
+	struct smb_hdr *in_buf = (struct smb_hdr *)smb->rqst.rq_iov[0].iov_base;
+	unsigned int in_len = smb->rqst.rq_iov[0].iov_len;
 	LOCK_REQ *pSMB = (LOCK_REQ *)in_buf;
 	int rc;
 
@@ -204,7 +202,6 @@ send_lock_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	 */
 	pSMB->LockType = LOCKING_ANDX_CANCEL_LOCK|LOCKING_ANDX_LARGE_FILES;
 	pSMB->Timeout = 0;
-	pSMB->hdr.Mid = get_next_mid(ses->server);
 
 	rc = SendReceive(xid, ses, in_buf, in_len, NULL, NULL, 0);
 	if (rc == -ENOLCK)
@@ -215,12 +212,11 @@ send_lock_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
 }
 
 static int cifs_send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-			    struct smb_rqst *rqst, struct smb_message *smb,
-			    unsigned int xid)
+			    struct smb_message *smb, unsigned int xid)
 {
 	if (smb->sr_flags & CIFS_WINDOWS_LOCK)
-		return send_lock_cancel(ses, server, rqst, smb, xid);
-	return send_nt_cancel(ses, server, rqst, smb, xid);
+		return send_lock_cancel(ses, server, smb, xid);
+	return send_nt_cancel(ses, server, smb, xid);
 }
 
 static bool
@@ -233,7 +229,7 @@ struct smb_message *
 cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr)
 {
 	struct smb_message *smb;
-	u16 mid = le16_to_cpu(shdr->Mid);
+	u64 mid = le16_to_cpu(shdr->Mid);
 
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
@@ -302,7 +298,7 @@ cifs_get_credits(struct smb_message *smb)
  * to somewhat less than 64K-1 although it is hard to imagine
  * so many threads being in the vfs at one time.
  */
-static __u64
+u16
 cifs_get_next_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid = 0;
@@ -1380,7 +1376,6 @@ struct smb_version_operations smb1_operations = {
 	.get_credits_field = cifs_get_credits_field,
 	.get_credits = cifs_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
-	.get_next_mid = cifs_get_next_mid,
 	.clear_stats = cifs_clear_stats,
 	.print_stats = cifs_print_stats,
 	.downgrade_oplock = cifs_downgrade_oplock,
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 54a5261fabce..ac0ba1fa2b74 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -287,16 +287,18 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 /*
  * smb1transport.c
  */
-struct smb_message *cifs_setup_async_request(struct TCP_Server_Info *server,
-					     struct smb_rqst *rqst);
+u16 cifs_get_next_mid(struct TCP_Server_Info *server);
+struct smb_message *cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr);
+bool cifs_is_network_name_deleted(const struct smb_hdr *shdr, struct TCP_Server_Info *server);
+int cifs_setup_async_request(struct TCP_Server_Info *server,
+			     struct smb_message *smb);
 int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 		     char *in_buf, unsigned int in_len, int flags);
 int checkSMB(const struct TCP_Server_Info *server, struct cifs_receive *recv);
 int cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		       bool log_error);
-struct smb_message *cifs_setup_request(struct cifs_ses *ses,
-				       struct TCP_Server_Info *server,
-				       struct smb_rqst *rqst);
+int cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		       struct smb_message *smb);
 int SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		 struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
 		 const int flags, struct kvec *resp_iov);
@@ -304,6 +306,7 @@ int SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		struct smb_hdr *in_buf, unsigned int in_len,
 		struct smb_hdr *out_buf, int *pbytes_returned,
 		const int flags);
+int smb1_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
 
 #define GETU16(var)  (*((__u16 *)var))	/* BB check for endian issues */
 #define GETU32(var)  (*((__u32 *)var))	/* BB check for endian issues */
@@ -336,10 +339,6 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
 	put_unaligned_le16(count, bc_ptr);
 }
 
-struct smb_message *cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr);
-bool cifs_is_network_name_deleted(const struct smb_hdr *shdr, struct TCP_Server_Info *server);
-int smb1_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
-
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 #endif /* _SMB1PROTO_H */
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index a6af5bd20847..1bbfa0844e6f 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -30,52 +30,18 @@
 #include "smbdirect.h"
 #include "compress.h"
 
-/* Max number of iovectors we can use off the stack when sending requests. */
-#define CIFS_MAX_IOV_SIZE 8
-
-static struct smb_message *
-alloc_mid(const struct smb_hdr *shdr, struct TCP_Server_Info *server)
+static int allocate_mid(struct cifs_ses *ses, struct smb_message *smb)
 {
-	struct smb_message *smb;
-
-	if (server == NULL) {
-		cifs_dbg(VFS, "%s: null TCP session\n", __func__);
-		return NULL;
-	}
+	struct smb_hdr *hdr = smb->request;
+	u16 mid = cifs_get_next_mid(ses->server);
 
-	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
-	memset(smb, 0, sizeof(struct smb_message));
-	refcount_set(&smb->ref, 1);
-	spin_lock_init(&smb->mid_lock);
-	smb->mid	= le16_to_cpu(shdr->Mid);
-	smb->pid	= current->pid;
-	smb->command	= cpu_to_le16(shdr->Command);
-	cifs_dbg(FYI, "For smb_command %d\n", shdr->Command);
-	/* easier to use jiffies */
-	/* when mid allocated can be before when sent */
-	smb->when_alloc	= jiffies;
+	smb->mid = mid;
+	hdr->Mid = cpu_to_le16(mid);
 
-	/*
-	 * The default is for the mid to be synchronous, so the
-	 * default callback just wakes up the current task.
-	 */
-	get_task_struct(current);
-	smb->creator = current;
-	smb->callback = cifs_wake_up_task;
-	smb->callback_data = current;
-
-	atomic_inc(&mid_count);
-	smb->mid_state = MID_REQUEST_ALLOCATED;
-	return smb;
-}
-
-static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
-			struct smb_message **ppmidQ)
-{
 	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_NEW) {
-		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
-			(in_buf->Command != SMB_COM_NEGOTIATE)) {
+		if ((hdr->Command != SMB_COM_SESSION_SETUP_ANDX) &&
+		    (hdr->Command != SMB_COM_NEGOTIATE)) {
 			spin_unlock(&ses->ses_lock);
 			return -EAGAIN;
 		}
@@ -84,7 +50,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 
 	if (ses->ses_status == SES_EXITING) {
 		/* check if SMB session is bad because we are setting it up */
-		if (in_buf->Command != SMB_COM_LOGOFF_ANDX) {
+		if (hdr->Command != SMB_COM_LOGOFF_ANDX) {
 			spin_unlock(&ses->ses_lock);
 			return -EAGAIN;
 		}
@@ -92,37 +58,38 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	}
 	spin_unlock(&ses->ses_lock);
 
-	*ppmidQ = alloc_mid(in_buf, ses->server);
-	if (*ppmidQ == NULL)
-		return -ENOMEM;
+	smb_get_message(smb);
 	spin_lock(&ses->server->mid_queue_lock);
-	list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q);
+	list_add_tail(&smb->qhead, &ses->server->pending_mid_q);
 	spin_unlock(&ses->server->mid_queue_lock);
 	return 0;
 }
 
-struct smb_message *
-cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int
+cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_message *smb)
 {
+	struct smb_hdr *shdr = smb->request;
+	u16 mid;
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
-	struct smb_message *smb;
 
 	/* enable signing if server requires it */
 	if (server->sign)
-		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+		shdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	smb = alloc_mid(hdr, server);
-	if (smb == NULL)
-		return ERR_PTR(-ENOMEM);
+	mid = cifs_get_next_mid(server);
+	shdr->Mid = cpu_to_le16(mid);
+	smb->mid = mid;
+	smb->command = shdr->Command;
+	cifs_dbg(FYI, "For smb_command %d\n", smb->command);
+	atomic_inc(&mid_count);
 
-	rc = cifs_sign_rqst(rqst, server, &smb->sequence_number);
+	rc = cifs_sign_rqst(&smb->rqst, server, &smb->sequence_number);
 	if (rc) {
-		release_mid(server, smb);
-		return ERR_PTR(rc);
+		smb_put_message(smb);
+		return rc;
 	}
 
-	return smb;
+	return 0;
 }
 
 /*
@@ -179,23 +146,21 @@ cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 	return map_and_check_smb_error(server, smb, log_error);
 }
 
-struct smb_message *
+int
 cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		   struct smb_rqst *rqst)
+		   struct smb_message *smb)
 {
 	int rc;
-	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
-	struct smb_message *smb;
 
-	rc = allocate_mid(ses, hdr, &smb);
+	rc = allocate_mid(ses, smb);
 	if (rc)
-		return ERR_PTR(rc);
-	rc = cifs_sign_rqst(rqst, server, &smb->sequence_number);
+		return rc;
+	rc = cifs_sign_rqst(&smb->rqst, server, &smb->sequence_number);
 	if (rc) {
-		delete_mid(server, smb);
-		return ERR_PTR(rc);
+		dequeue_mid(server, smb, false);
+		return rc;
 	}
-	return smb;
+	return 0;
 }
 
 int
@@ -956,7 +921,7 @@ static void smb1_parse_one_message(struct TCP_Server_Info *server,
 			/* Handle multipart trans2-class messages. */
 			rc = smb1_trans2_receive(server, smb, recv, rxq);
 			if (rc == 1) {
-				release_mid(server, smb);
+				smb_put_message(smb);
 				return; /* Multipart, incomplete. */
 			}
 			if (rc < 0)
@@ -1030,7 +995,7 @@ static void smb1_parse_one_message(struct TCP_Server_Info *server,
 		dequeue_mid(server, smb, recv->malformed);
 		mid_execute_callback(server, smb);
 
-		release_mid(server, smb);
+		smb_put_message(smb);
 	} else if (smb1_is_valid_oplock_break(h, recv->msg_len, server)) {
 		cifs_dbg(FYI, "Received oplock break\n");
 		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 249606e5680e..d28812107e8f 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -837,27 +837,20 @@ smb2_handle_cancelled_mid(struct smb_message *smb, struct TCP_Server_Info *serve
 }
 
 /**
- * smb311_update_preauth_hash - update @ses hash with the packet data in @iov
- *
- * Assumes @iov does not contain the rfc1002 length and iov[0] has the
- * SMB2 header.
- *
+ * smb311_update_preauth_hash - update @ses hash from the message
  * @ses:	server session structure
  * @server:	pointer to server info
- * @iov:	array containing the SMB request we will send to the server
- * @nvec:	number of array entries for the iov
+ * @smb:	the SMB request we will send to the server
+ * @hash_resp:	T if we're hashing a response
  */
 void
 smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
-			   struct kvec *iov, int nvec)
+			   struct smb_message *smb, bool hash_resp)
 {
-	int i;
-	struct smb2_hdr *hdr;
 	struct sha512_ctx sha_ctx;
 
-	hdr = (struct smb2_hdr *)iov[0].iov_base;
 	/* neg prot are always taken */
-	if (hdr->Command == SMB2_NEGOTIATE)
+	if (smb->command == SMB2_NEGOTIATE)
 		goto ok;
 
 	/*
@@ -868,20 +861,29 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	if (server->dialect != SMB311_PROT_ID)
 		return;
 
-	if (hdr->Command != SMB2_SESSION_SETUP)
+	if (smb->command != SMB2_SESSION_SETUP)
 		return;
 
 	/* skip last sess setup response */
-	if ((hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
-	    && (hdr->Status == NT_STATUS_OK
-		|| (hdr->Status !=
-		    cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))))
-		return;
+	if (hash_resp) {
+		struct smb2_hdr *resp = smb->response;
+		if (resp->Status == NT_STATUS_OK ||
+		    resp->Status != cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))
+			return;
+	}
 
 ok:
 	sha512_init(&sha_ctx);
 	sha512_update(&sha_ctx, ses->preauth_sha_hash, SMB2_PREAUTH_HASH_SIZE);
-	for (i = 0; i < nvec; i++)
-		sha512_update(&sha_ctx, iov[i].iov_base, iov[i].iov_len);
+
+	if (hash_resp) {
+		sha512_update(&sha_ctx,  smb->response, smb->resp_len);
+	} else {
+		struct kvec *iov = smb->rqst.rq_iov;
+
+		for (int i = 0; i < smb->rqst.rq_nvec; i++)
+			sha512_update(&sha_ctx, iov[i].iov_base, iov[i].iov_len);
+	}
+
 	sha512_final(&sha_ctx, ses->preauth_sha_hash);
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6125184d9826..93ec64d67d54 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -402,13 +402,14 @@ smb2_add_credits_from_hdr(struct smb2_hdr *shdr, struct TCP_Server_Info *server)
 	}
 }
 
-static __u64
-smb2_get_next_mid(struct TCP_Server_Info *server)
+u64
+smb2_get_next_mid(struct TCP_Server_Info *server, unsigned int count)
 {
-	__u64 mid;
+	u64 mid;
 	/* for SMB2 we need the current value */
 	spin_lock(&server->mid_counter_lock);
-	mid = server->current_mid++;
+	mid = server->current_mid;
+	server->current_mid = mid + umax(count, 1);
 	spin_unlock(&server->mid_counter_lock);
 	return mid;
 }
@@ -4559,7 +4560,6 @@ struct smb_version_operations smb20_operations = {
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
-	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
@@ -4650,7 +4650,6 @@ struct smb_version_operations smb21_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
-	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
 	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
@@ -4743,7 +4742,6 @@ struct smb_version_operations smb30_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
-	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
 	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
@@ -4846,7 +4844,6 @@ struct smb_version_operations smb311_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
-	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
 	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 48f56ce73cd3..5919cd99dec6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4192,7 +4192,6 @@ smb2_echo_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		credits.instance = server->reconnect_instance;
 	}
 
-	release_mid(server, smb);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -4350,10 +4349,9 @@ int
 SMB2_echo(struct TCP_Server_Info *server)
 {
 	struct smb2_echo_req *req;
+	struct smb_message *smb;
 	int rc = 0;
 	struct kvec iov[1];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 1 };
 	unsigned int total_len;
 
 	cifs_dbg(FYI, "In echo request for conn_id %lld\n", server->conn_id);
@@ -4368,22 +4366,36 @@ SMB2_echo(struct TCP_Server_Info *server)
 	}
 	spin_unlock(&server->srv_lock);
 
+	smb = smb_message_alloc(smb2_command_trace_echo, GFP_NOFS);
+	if (!smb)
+		return -ENOMEM;
+
 	rc = smb2_plain_req_init(SMB2_ECHO, NULL, server,
 				 (void **)&req, &total_len);
-	if (rc)
+	if (rc) {
+		mempool_free(smb, &smb_message_pool);
 		return rc;
-
-	req->hdr.CreditRequest = cpu_to_le16(1);
+	}
 
 	iov[0].iov_len = total_len;
 	iov[0].iov_base = (char *)req;
 
-	rc = cifs_call_async(server, &rqst, smb2_echo_callback, server,
-			     CIFS_ECHO_OP, NULL, NULL);
+	smb->rqst.rq_iov	= iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->command		= SMB2_ECHO;
+	smb->request		= req;
+	smb->total_len		= total_len;
+	smb->callback		= smb2_echo_callback;
+	smb->callback_data	= server;
+
+	req->hdr.CreditRequest = cpu_to_le16(1);
+
+	rc = cifs_call_async(server, smb, CIFS_ECHO_OP, NULL);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
 	cifs_small_buf_release(req);
+	smb_put_message(smb);
 	return rc;
 }
 
@@ -4628,21 +4640,10 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		.rreq_debug_id = rdata->rreq->debug_id,
 		.rreq_debug_index = rdata->subreq.debug_index,
 	};
-	struct kvec kv = {
-		.iov_base = smb->response,
-		.iov_len  = smb->resp_len,
-	};
-	struct smb_rqst rqst = {
-		.rq_iov  = &kv,
-		.rq_nvec = 1
-	};
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
 
-	iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
-
+	rdata->result = smb->error;
 	WARN_ONCE(rdata->server != server,
 		  "rdata server %p != mid server %p",
 		  rdata->server, server);
@@ -4659,7 +4660,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		if (server->sign && !smb->decrypted) {
 			int rc;
 
-			rc = smb2_verify_signature(&rqst, server);
+			rc = smb2_verify_signature(smb, server);
 			if (rc) {
 				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
 					      rc);
@@ -4765,7 +4766,6 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	rdata->subreq.transferred += smb->resp_data_len;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
-	release_mid(server, smb);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_read_response_add);
@@ -4776,41 +4776,44 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 int
 smb2_async_readv(struct cifs_io_subrequest *rdata)
 {
-	int rc, flags = 0;
-	char *buf;
 	struct netfs_io_subrequest *subreq = &rdata->subreq;
-	struct smb2_hdr *shdr;
-	struct cifs_io_parms io_parms;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 1 };
-	struct iov_iter iter;
 	struct TCP_Server_Info *server;
+	struct smb_message *smb;
+	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	unsigned int total_len;
+	void *buf;
 	int credit_request;
+	int rc, flags = 0;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%zu\n",
 		 __func__, subreq->start, subreq->len);
 
-	iov_iter_bvec_queue(&iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
-
-	if (!rdata->server)
-		rdata->server = cifs_pick_channel(tcon->ses);
+	server = rdata->server;
+	if (!server)
+		server = rdata->server = cifs_pick_channel(tcon->ses);
+
+	struct cifs_io_parms io_parms = {
+		.tcon		= tlink_tcon(rdata->req->cfile->tlink),
+		.server		= server,
+		.offset		= subreq->start + subreq->transferred,
+		.length		= subreq->len   - subreq->transferred,
+		.persistent_fid	= rdata->req->cfile->fid.persistent_fid,
+		.volatile_fid	= rdata->req->cfile->fid.volatile_fid,
+		.pid		= rdata->req->pid,
+	};
 
-	io_parms.tcon = tlink_tcon(rdata->req->cfile->tlink);
-	io_parms.server = server = rdata->server;
-	io_parms.offset = subreq->start + subreq->transferred;
-	io_parms.length = subreq->len   - subreq->transferred;
-	io_parms.persistent_fid = rdata->req->cfile->fid.persistent_fid;
-	io_parms.volatile_fid = rdata->req->cfile->fid.volatile_fid;
-	io_parms.pid = rdata->req->pid;
+	smb = smb_message_alloc(smb2_command_trace_read, GFP_NOFS);
+	if (!smb) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
-	rc = smb2_new_read_req(
-		(void **) &buf, &total_len, &io_parms, rdata, 0, 0);
-	if (rc)
+	rc = smb2_new_read_req(&buf, &total_len, &io_parms, rdata, 0, 0);
+	if (rc) {
+		mempool_free(smb, &smb_message_pool);
 		goto out;
+	}
 
 	if (smb3_encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -4819,13 +4822,26 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	rdata->iov[0].iov_len = total_len;
 	rdata->result = 0;
 
-	shdr = (struct smb2_hdr *)buf;
+	smb->rqst.rq_iov	= rdata->iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->command		= SMB2_READ;
+	smb->request		= buf;
+	smb->total_len		= total_len;
+	smb->callback		= smb2_readv_callback;
+	smb->callback_data	= rdata;
+	smb->copy_to_bufs	= true;
+
+	iov_iter_bvec_queue(&smb->response_iter, ITER_DEST,
+			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
+			    rdata->subreq.content.offset, rdata->subreq.len);
+
+	shdr = (struct smb2_hdr *)smb->request;
 
 	if (rdata->replay) {
 		/* Back-off before retry */
 		if (rdata->cur_sleep)
 			msleep(rdata->cur_sleep);
-		smb2_set_replay(server, &rqst);
+		smb2_set_replay(server, &smb->rqst);
 	}
 
 	if (rdata->credits.value > 0) {
@@ -4846,8 +4862,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		flags |= CIFS_HAS_CREDITS;
 	}
 
-	rc = cifs_call_async(server, &rqst, smb2_readv_callback, rdata, flags,
-			     &rdata->credits, &iter);
+	rc = cifs_call_async(server, smb, flags, &rdata->credits);
 	if (rc) {
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
 		trace_smb3_read_err(rdata->rreq->debug_id,
@@ -4872,6 +4887,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 	}
 
+	smb_put_message(smb);
 	return rc;
 }
 
@@ -5087,7 +5103,6 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		wdata->replay = true;
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
-	release_mid(server, smb);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
@@ -5098,79 +5113,91 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 void
 smb2_async_writev(struct cifs_io_subrequest *wdata)
 {
-	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
+	struct smb_message *smb;
 	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	struct TCP_Server_Info *server = wdata->server;
 	struct kvec iov[1];
-	struct smb_rqst rqst = { };
 	unsigned int total_len, xid = wdata->xid;
-	struct cifs_io_parms _io_parms;
-	struct cifs_io_parms *io_parms = NULL;
 	int credit_request;
+	int rc = -EACCES, flags = 0;
 
 	/*
 	 * in future we may get cifs_io_parms passed in from the caller,
 	 * but for now we construct it here...
 	 */
-	_io_parms = (struct cifs_io_parms) {
-		.tcon = tcon,
-		.server = server,
-		.offset = wdata->subreq.start,
-		.length = wdata->subreq.len,
-		.persistent_fid = wdata->req->cfile->fid.persistent_fid,
-		.volatile_fid = wdata->req->cfile->fid.volatile_fid,
-		.pid = wdata->req->pid,
+	struct cifs_io_parms io_parms = {
+		.tcon		= tcon,
+		.server		= server,
+		.offset		= wdata->subreq.start,
+		.length		= wdata->subreq.len,
+		.persistent_fid	= wdata->req->cfile->fid.persistent_fid,
+		.volatile_fid	= wdata->req->cfile->fid.volatile_fid,
+		.pid		= wdata->req->pid,
 	};
-	io_parms = &_io_parms;
+
+	smb = smb_message_alloc(smb2_command_trace_write, GFP_NOFS);
+	if (!smb) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
 				 (void **) &req, &total_len);
-	if (rc)
+	if (rc) {
+		mempool_free(smb, &smb_message_pool);
 		goto out;
+	}
 
-	rqst.rq_iov = iov;
-	iov_iter_bvec_queue(&rqst.rq_iter, ITER_SOURCE,
+	iov[0].iov_len	= total_len;
+	iov[0].iov_base	= (char *)req;
+	total_len += wdata->subreq.len;
+
+	smb->rqst.rq_iov	= iov;
+	smb->rqst.rq_nvec	= 1;
+	smb->command		= SMB2_WRITE;
+	smb->request		= req;
+	smb->total_len		= total_len;
+	smb->callback		= smb2_writev_callback;
+	smb->callback_data	= wdata;
+
+	iov_iter_bvec_queue(&smb->rqst.rq_iter, ITER_SOURCE,
 			    wdata->subreq.content.bvecq, wdata->subreq.content.slot,
 			    wdata->subreq.content.offset, wdata->subreq.len);
 
-	rqst.rq_iov[0].iov_len = total_len - 1;
-	rqst.rq_iov[0].iov_base = (char *)req;
-	rqst.rq_nvec += 1;
-
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	shdr = (struct smb2_hdr *)req;
-	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
-
-	req->PersistentFileId = io_parms->persistent_fid;
-	req->VolatileFileId = io_parms->volatile_fid;
-	req->WriteChannelInfoOffset = 0;
-	req->WriteChannelInfoLength = 0;
-	req->Channel = SMB2_CHANNEL_NONE;
-	req->Length = cpu_to_le32(io_parms->length);
-	req->Offset = cpu_to_le64(io_parms->offset);
-	req->DataOffset = cpu_to_le16(
-				offsetof(struct smb2_write_req, Buffer));
-	req->RemainingBytes = 0;
+	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms.pid);
+
+	req->PersistentFileId		= io_parms.persistent_fid;
+	req->VolatileFileId		= io_parms.volatile_fid;
+	req->WriteChannelInfoOffset	= 0;
+	req->WriteChannelInfoLength	= 0;
+	req->Channel			= SMB2_CHANNEL_NONE;
+	req->Length			= cpu_to_le32(io_parms.length);
+	req->Offset			= cpu_to_le64(io_parms.offset);
+	req->DataOffset			=
+		cpu_to_le16(offsetof(struct smb2_write_req, Buffer));
+	req->RemainingBytes		= 0;
 
 	trace_smb3_write_enter(wdata->rreq->debug_id,
 			       wdata->subreq.debug_index,
 			       wdata->xid,
-			       io_parms->persistent_fid,
-			       io_parms->tcon->tid,
-			       io_parms->tcon->ses->Suid,
-			       io_parms->offset,
-			       io_parms->length);
+			       io_parms.persistent_fid,
+			       io_parms.tcon->tid,
+			       io_parms.tcon->ses->Suid,
+			       io_parms.offset,
+			       io_parms.length);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	/*
 	 * If we want to do a server RDMA read, fill in and append
 	 * smbdirect_buffer_descriptor_v1 to the end of write request
 	 */
-	if (smb3_use_rdma_offload(io_parms)) {
+	if (smb3_use_rdma_offload(&io_parms)) {
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		struct iov_iter iter;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
@@ -5199,13 +5226,13 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		v1 = (struct smbdirect_buffer_descriptor_v1 *) &req->Buffer[0];
 		smbd_mr_fill_buffer_descriptor(wdata->mr, v1);
 
-		rqst.rq_iov[0].iov_len += sizeof(*v1);
+		smb->rqst.rq_iov[0].iov_len += sizeof(*v1);
 
 		/*
 		 * We keep wdata->subreq.io_iter,
 		 * but we have to truncate rqst.rq_iter
 		 */
-		iov_iter_truncate(&rqst.rq_iter, 0);
+		iov_iter_truncate(&smb->rqst.rq_iter, 0);
 	}
 #endif
 
@@ -5213,11 +5240,11 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		/* Back-off before retry */
 		if (wdata->cur_sleep)
 			msleep(wdata->cur_sleep);
-		smb2_set_replay(server, &rqst);
+		smb2_set_replay(server, &smb->rqst);
 	}
 
-	cifs_dbg(FYI, "async write at %llu %u bytes len=%zx\n",
-		 io_parms->offset, io_parms->length, wdata->subreq.len);
+	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
+		 io_parms.offset, io_parms.length, iov_iter_count(&smb->rqst.rq_iter));
 
 	if (wdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->subreq.len,
@@ -5238,27 +5265,28 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 
 	/* XXX: compression + encryption is unsupported for now */
-	if (((flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) && should_compress(tcon, &rqst))
+	if (((flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) &&
+	    should_compress(tcon, smb))
 		flags |= CIFS_COMPRESS_REQ;
 
-	rc = cifs_call_async(server, &rqst, smb2_writev_callback, wdata, flags,
-			     &wdata->credits, NULL);
+	rc = cifs_call_async(server, smb, flags, &wdata->credits);
 	/* Can't touch wdata if rc == 0 */
 	if (rc) {
 		trace_smb3_write_err(wdata->rreq->debug_id,
 				     wdata->subreq.debug_index,
 				     xid,
-				     io_parms->persistent_fid,
-				     io_parms->tcon->tid,
-				     io_parms->tcon->ses->Suid,
-				     io_parms->offset,
-				     io_parms->length,
+				     io_parms.persistent_fid,
+				     io_parms.tcon->tid,
+				     io_parms.tcon->ses->Suid,
+				     io_parms.offset,
+				     io_parms.length,
 				     rc);
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 	}
 
 async_writev_out:
 	cifs_small_buf_release(req);
+	smb_put_message(smb);
 out:
 	/* if the send error is retryable, let netfs know about it */
 	if (is_replayable_error(rc) &&
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 3b4bc946d1bb..bac01d15b94a 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -35,16 +35,9 @@ char *smb2_get_data_area_len(struct cifs_receive *recv);
 __le16 *cifs_convert_path_to_utf16(const char *from,
 				   struct cifs_sb_info *cifs_sb);
 
-int smb2_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
-int smb2_verify_signature(struct smb_rqst *rqst,
-			  struct TCP_Server_Info *server);
-int smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
-		       bool log_error);
-struct smb_message *smb2_setup_request(struct cifs_ses *ses,
-				       struct TCP_Server_Info *server,
-				       struct smb_rqst *rqst);
-struct smb_message *smb2_setup_async_request(struct TCP_Server_Info *server,
-					     struct smb_rqst *rqst);
+int smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
+		       struct smb_message *smb);
+int smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_message *smb);
 struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 				     __u64 ses_id, __u32  tid);
 __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock);
@@ -52,6 +45,10 @@ void smb2_is_valid_oplock_break(struct TCP_Server_Info *server,
 				union smb2_response_hdr *h);
 int smb3_handle_read_data(struct TCP_Server_Info *server,
 			  struct smb_message *smb);
+int smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
+		       bool log_error);
+int smb2_verify_signature(struct smb_message *smb, struct TCP_Server_Info *server);
+int smb2_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
 struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 					struct super_block *sb,
 					const unsigned int xid,
@@ -116,7 +113,7 @@ int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
 void smb2_reconnect_server(struct work_struct *work);
 int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
 int smb3_init_transform_rq(struct TCP_Server_Info *server,
-			   int num_rqst, const struct smb_rqst *rqst,
+			   struct smb_message *head_smb,
 			   struct smb2_transform_hdr *tr_hdr,
 			   struct iov_iter *iter);
 unsigned long smb_rqst_len(struct TCP_Server_Info *server,
@@ -128,6 +125,7 @@ bool smb2_should_replay(struct cifs_tcon *tcon, int *pretries,
 			int *pcur_sleep);
 void smb2_add_credits_from_hdr(struct smb2_hdr *shdr,
 			       struct TCP_Server_Info *server);
+u64 smb2_get_next_mid(struct TCP_Server_Info *server, unsigned int count);
 struct smb_message *smb2_find_mid(struct TCP_Server_Info *server,
 				  struct smb2_hdr *shdr, bool dequeue);
 #ifdef CONFIG_CIFS_DEBUG2
@@ -274,7 +272,7 @@ void smb2_copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
 				  struct kstatfs *kst);
 void smb311_update_preauth_hash(struct cifs_ses *ses,
 				struct TCP_Server_Info *server,
-				struct kvec *iov, int nvec);
+				struct smb_message *smb, bool hash_resp);
 int smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *path, u32 desired_access, u32 class,
 			     u32 type, u32 output_len, struct kvec *rsp,
@@ -288,4 +286,11 @@ int posix_info_sid_size(const void *beg, const void *end);
 int smb2_rename_pending_delete(const char *full_path, struct dentry *dentry,
 			       const unsigned int xid);
 
+/*
+ * SMB2 Worker functions - most of protocol specific implementation details
+ * are contained within these calls.
+ */
+
+/* query path info from the server using SMB311 POSIX extensions*/
+
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 874956515322..543b26135085 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -31,7 +31,7 @@
 #include "smb2glob.h"
 
 static void smb2_parse_pdu(struct TCP_Server_Info *server,
-			   struct netfs_rxqueue *rxq);
+			   struct netfs_rxqueue *rxq, bool decrypted);
 
 static
 int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
@@ -208,12 +208,13 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 }
 
 static int
-smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+smb2_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
+		    bool for_recv)
 {
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
-	struct kvec *iov = rqst->rq_iov;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct kvec *iov = smb->rqst.rq_iov;
+	struct smb2_hdr *shdr = for_recv ? smb->response : smb->request;
 	struct hmac_sha256_ctx hmac_ctx;
 	struct smb_rqst drqst;
 	__u64 sid = le64_to_cpu(shdr->SessionId);
@@ -238,7 +239,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	 * Sign the rfc1002 length prior to passing the data (iov[1-N]) down to
 	 * __cifs_calc_signature().
 	 */
-	drqst = *rqst;
+	drqst = smb->rqst;
 	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
 		hmac_sha256_update(&hmac_ctx, iov[0].iov_base, iov[0].iov_len);
 		drqst.rq_iov++;
@@ -460,19 +461,20 @@ generate_smb311signingkey(struct cifs_ses *ses,
 }
 
 static int
-smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+smb3_calc_signature(struct smb_message *smb, struct TCP_Server_Info *server,
+		    bool for_recv)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
-	struct kvec *iov = rqst->rq_iov;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct kvec kv;
+	struct smb2_hdr *shdr = for_recv ? smb->response : smb->request;
 	struct aes_cmac_key cmac_key;
 	struct aes_cmac_ctx cmac_ctx;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
 	if (server->vals->protocol_id <= SMB21_PROT_ID)
-		return smb2_calc_signature(rqst, server);
+		return smb2_calc_signature(smb, server, for_recv);
 
 	rc = smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (unlikely(rc)) {
@@ -491,18 +493,15 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 	aes_cmac_init(&cmac_ctx, &cmac_key);
 
-	/*
-	 * For SMB2+, __cifs_calc_signature() expects to sign only the actual
-	 * data, that is, iov[0] should not contain a rfc1002 length.
-	 *
-	 * Sign the rfc1002 length prior to passing the data (iov[1-N]) down to
-	 * __cifs_calc_signature().
-	 */
-	drqst = *rqst;
-	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
-		aes_cmac_update(&cmac_ctx, iov[0].iov_base, iov[0].iov_len);
-		drqst.rq_iov++;
-		drqst.rq_nvec--;
+	if (for_recv) {
+		kv.iov_base = smb->response;
+		kv.iov_len  = smb->resp_len;
+		drqst.rq_nvec = 1;
+		drqst.rq_iov  = &kv;
+		drqst.rq_iter = smb->response_iter;
+		iov_iter_truncate(&drqst.rq_iter, smb->resp_data_len);
+	} else {
+		drqst = smb->rqst;
 	}
 
 	rc = __cifs_calc_signature(
@@ -515,22 +514,21 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 /* must be called with server->srv_mutex held */
 static int
-smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+smb2_sign_rqst(struct smb_message *smb, struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *shdr;
 	struct smb2_sess_setup_req *ssr;
+	struct smb2_hdr *shdr = smb->request;
 	bool is_binding;
 	bool is_signed;
 
-	shdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	ssr = (struct smb2_sess_setup_req *)shdr;
 
-	is_binding = shdr->Command == SMB2_SESSION_SETUP &&
+	is_binding = smb->command == SMB2_SESSION_SETUP &&
 		(ssr->Flags & SMB2_SESSION_REQ_FLAG_BINDING);
 	is_signed = shdr->Flags & SMB2_FLAGS_SIGNED;
-
 	if (!is_signed)
 		return 0;
+
 	spin_lock(&server->srv_lock);
 	if (server->ops->need_neg &&
 	    server->ops->need_neg(server)) {
@@ -543,22 +541,20 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return 0;
 	}
 
-	return smb3_calc_signature(rqst, server);
+	return smb3_calc_signature(smb, server, false);
 }
 
-int
-smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+int smb2_verify_signature(struct smb_message *smb, struct TCP_Server_Info *server)
 {
-	int rc;
+	struct smb2_hdr *shdr = smb->response;
 	char server_response_sig[SMB2_SIGNATURE_SIZE];
-	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	int rc;
 
-	if ((shdr->Command == SMB2_NEGOTIATE) ||
-	    (shdr->Command == SMB2_SESSION_SETUP) ||
-	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
+	if (smb->command == SMB2_NEGOTIATE ||
+	    smb->command == SMB2_SESSION_SETUP ||
+	    smb->command == SMB2_OPLOCK_BREAK ||
 	    server->ignore_signature ||
-	    (!server->session_estab))
+	    !server->session_estab)
 		return 0;
 
 	/*
@@ -579,8 +575,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
-	rc = smb3_calc_signature(rqst, server);
-
+	rc = smb3_calc_signature(smb, server, true);
 	if (rc)
 		return rc;
 
@@ -599,59 +594,42 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
  */
 static inline void
 smb2_seq_num_into_buf(struct TCP_Server_Info *server,
-		      struct smb2_hdr *shdr)
+		      struct smb_message *smb)
 {
-	unsigned int i, num = le16_to_cpu(shdr->CreditCharge);
+	struct smb2_hdr *shdr = smb->request;
+	unsigned int num = le16_to_cpu(shdr->CreditCharge);
 
-	shdr->MessageId = get_next_mid64(server);
 	/* skip message numbers according to CreditCharge field */
-	for (i = 1; i < num; i++)
-		get_next_mid(server);
+	smb->mid = smb2_get_next_mid(server, num);
+	shdr->MessageId = cpu_to_le64(smb->mid);
 }
 
-static struct smb_message *
-smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
-		     struct TCP_Server_Info *server)
+static void smb2_init_mid(struct smb_message *smb,
+			  struct TCP_Server_Info *server)
 {
-	struct smb_message *smb;
+	const struct smb2_hdr *shdr = smb->request;
 	unsigned int credits = le16_to_cpu(shdr->CreditCharge);
 
-	if (server == NULL) {
-		cifs_dbg(VFS, "Null TCP session in smb2_mid_entry_alloc\n");
-		return NULL;
-	}
-
-	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
-	memset(smb, 0, sizeof(*smb));
-	refcount_set(&smb->ref, 1);
-	spin_lock_init(&smb->mid_lock);
-	smb->mid = le64_to_cpu(shdr->MessageId);
 	smb->credits_consumed = credits > 0 ? credits : 1;
-	smb->pid = current->pid;
-	smb->command = shdr->Command; /* Always LE */
-	smb->when_alloc = jiffies;
 
 	/*
 	 * The default is for the mid to be synchronous, so the
 	 * default callback just wakes up the current task.
 	 */
-	get_task_struct(current);
-	smb->creator = current;
-	smb->callback = cifs_wake_up_task;
-	smb->callback_data = current;
+	smb->creator = get_task_struct(current);
 
 	atomic_inc(&mid_count);
-	smb->mid_state = MID_REQUEST_ALLOCATED;
 	trace_smb3_cmd_enter(le32_to_cpu(shdr->Id.SyncId.TreeId),
 			     le64_to_cpu(shdr->SessionId),
 			     le16_to_cpu(shdr->Command), smb->mid);
-	return smb;
 }
 
 static int
 smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		   struct smb2_hdr *shdr, struct smb_message **smb)
+		   struct smb_message *smb)
 {
+	const struct smb2_hdr *shdr = smb->request;
+
 	switch (READ_ONCE(server->tcpStatus)) {
 	case CifsExiting:
 		return -ENOENT;
@@ -682,13 +660,12 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		break;
 	}
 
-	*smb = smb2_mid_entry_alloc(shdr, server);
-	if (*smb == NULL)
-		return -ENOMEM;
+	smb2_init_mid(smb, server);
+
+	smb_get_message(smb);
 	spin_lock(&server->mid_queue_lock);
-	list_add_tail(&(*smb)->qhead, &server->pending_mid_q);
+	list_add_tail(&smb->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
-
 	return 0;
 }
 
@@ -697,86 +674,66 @@ smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
 	unsigned int len = smb->resp_len;
-	struct kvec iov[1];
-	struct smb_rqst rqst = { .rq_iov = iov,
-				 .rq_nvec = 1 };
-
-	iov[0].iov_base = (char *)smb->response;
-	iov[0].iov_len = len;
 
 	dump_smb(smb->response, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
 	if (len > 24 && server->sign && !smb->decrypted) {
 		int rc;
 
-		rc = smb2_verify_signature(&rqst, server);
+		rc = smb2_verify_signature(smb, server);
 		if (rc)
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 					rc);
 	}
 
-	return map_smb2_to_linux_error(smb->response, log_error);
+	return smb->error;
 }
 
-struct smb_message *
+int
 smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		   struct smb_rqst *rqst)
+		   struct smb_message *smb)
 {
+	struct smb2_hdr *shdr = smb->request;
 	int rc;
-	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
-	struct smb_message *smb;
 
-	smb2_seq_num_into_buf(server, shdr);
+	smb2_seq_num_into_buf(server, smb);
 
-	rc = smb2_get_mid_entry(ses, server, shdr, &smb);
+	rc = smb2_get_mid_entry(ses, server, smb);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		return ERR_PTR(rc);
+		return rc;
 	}
 
-	rc = smb2_sign_rqst(rqst, server);
-	if (rc) {
+	rc = smb2_sign_rqst(smb, server);
+	if (rc)
 		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(server, smb);
-		return ERR_PTR(rc);
-	}
-
-	return smb;
+	return rc;
 }
 
-struct smb_message *
-smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+int
+smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_message *smb)
 {
+	struct smb2_hdr *shdr = smb->request;
 	int rc;
-	struct smb2_hdr *shdr =
-			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
-	struct smb_message *smb;
 
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate &&
-	   shdr->Command != SMB2_NEGOTIATE) {
+	   smb->command != SMB2_NEGOTIATE) {
 		spin_unlock(&server->srv_lock);
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 	}
 	spin_unlock(&server->srv_lock);
 
-	smb2_seq_num_into_buf(server, shdr);
-
-	smb = smb2_mid_entry_alloc(shdr, server);
-	if (smb == NULL) {
-		revert_current_mid_from_hdr(server, shdr);
-		return ERR_PTR(-ENOMEM);
-	}
+	smb2_seq_num_into_buf(server, smb);
+	smb2_init_mid(smb, server);
 
-	rc = smb2_sign_rqst(rqst, server);
+	rc = smb2_sign_rqst(smb, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		release_mid(server, smb);
-		return ERR_PTR(rc);
+		return rc;
 	}
 
-	return smb;
+	return 0;
 }
 
 int
@@ -817,6 +774,33 @@ smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
 	return 0;
 }
 
+/* We can not use the normal sg_set_buf() as we will sometimes pass a
+ * stack object as buf.
+ */
+static void cifs_sg_set_buf(struct sg_table *sgtable,
+			    const void *buf, unsigned int buflen)
+{
+	unsigned long addr = (unsigned long)buf;
+	unsigned int off = offset_in_page(addr);
+
+	addr &= PAGE_MASK;
+	if (is_vmalloc_or_module_addr((void *)addr)) {
+		do {
+			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
+
+			sg_set_page(&sgtable->sgl[sgtable->nents++],
+				    vmalloc_to_page((void *)addr), len, off);
+
+			off = 0;
+			addr += PAGE_SIZE;
+			buflen -= len;
+		} while (buflen);
+	} else {
+		sg_set_page(&sgtable->sgl[sgtable->nents++],
+			    virt_to_page((void *)addr), buflen, off);
+	}
+}
+
 /*
  * Allocate the context info needed for the encryption operation, along with a
  * scatterlist to point to the buffer.
@@ -958,10 +942,12 @@ encrypt_message(struct TCP_Server_Info *server,
 }
 
 static void
-fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
-		   const struct smb_rqst *old_rq, __le16 cipher_type)
+fill_transform_hdr(struct smb2_transform_hdr *tr_hdr,
+		   struct smb_message *head_smb,
+		   unsigned int orig_len,
+		   __le16 cipher_type)
 {
-	struct smb2_hdr *shdr = (struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr = head_smb->request;
 
 	*tr_hdr = (struct smb2_transform_hdr){
 		.ProtocolId		= SMB2_TRANSFORM_PROTO_NUM,
@@ -983,14 +969,14 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
  */
 int
 smb3_init_transform_rq(struct TCP_Server_Info *server,
-		       int num_rqst, const struct smb_rqst *rqst,
+		       struct smb_message *head_smb,
 		       struct smb2_transform_hdr *tr_hdr,
 		       struct iov_iter *iter)
 {
 	size_t orig_len = iov_iter_count(iter) - sizeof(*tr_hdr);
 	int rc;
 
-	fill_transform_hdr(tr_hdr, orig_len, rqst, server->cipher_type);
+	fill_transform_hdr(tr_hdr, head_smb, orig_len, server->cipher_type);
 
 	iov_iter_advance(iter, offsetof(struct smb2_transform_hdr, Nonce));
 
@@ -1105,7 +1091,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 		goto out;
 	}
 
-	smb2_parse_pdu(dw->server, rxq);
+	smb2_parse_pdu(dw->server, rxq, true);
 out:
 	netfs_put_rx_bvecq(rxq->take_from);
 	kfree(dw);
@@ -1189,7 +1175,7 @@ static int smb3_reverse_transform(struct TCP_Server_Info *server,
 
 	rxq->refillable = false;
 	decrypt_pdu(server, &tr_hdr, rxq);
-	smb2_parse_pdu(server, rxq);
+	smb2_parse_pdu(server, rxq, true);
 	return 0;
 }
 
@@ -1300,7 +1286,8 @@ static void smb2_copy_to_prepped_buffers(struct TCP_Server_Info *server,
  */
 static void smb2_parse_one_message(struct TCP_Server_Info *server,
 				   struct cifs_receive *recv,
-				   struct netfs_rxqueue *rxq)
+				   struct netfs_rxqueue *rxq,
+				   bool decrypted)
 {
 	union smb2_response_hdr *h = recv->response;
 	struct smb_message *smb;
@@ -1314,6 +1301,7 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 		rxq->msg_id = 0;
 	} else {
 		rxq->msg_id = 0; /* TODO: smb->debug_id */
+		smb->decrypted = decrypted;
 	}
 
 	/*
@@ -1347,12 +1335,12 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 				       le64_to_cpu(shdr->MessageId));
 		cifs_dbg(FYI, "Session expired or deleted\n");
 		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
-		release_mid(server, smb);
+		smb_put_message(smb);
 		return;
 	case STATUS_PENDING:
 		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
 		smb2_status_pending(shdr, server);
-		release_mid(server, smb);
+		smb_put_message(smb);
 		return;
 	case STATUS_IO_TIMEOUT:
 		int iotimo = atomic_inc_return(&server->num_io_timeout);
@@ -1446,7 +1434,7 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
 		dequeue_mid(server, smb, recv->malformed);
 		mid_execute_callback(server, smb);
 
-		release_mid(server, smb);
+		smb_put_message(smb);
 	} else if (shdr->Command == cpu_to_le32(SMB2_OPLOCK_BREAK)) {
 		smb2_is_valid_oplock_break(server, h);
 		smb2_add_credits_from_hdr(shdr, server);
@@ -1474,7 +1462,7 @@ static void smb2_parse_one_message(struct TCP_Server_Info *server,
  * though some may yet to be received.
  */
 static void smb2_parse_pdu(struct TCP_Server_Info *server,
-			   struct netfs_rxqueue *rxq)
+			   struct netfs_rxqueue *rxq, bool decrypted)
 {
 	u32 next_command, ssize2, next_len;
 	int rc;
@@ -1569,7 +1557,7 @@ static void smb2_parse_pdu(struct TCP_Server_Info *server,
 		recv.hdr_len += ssize2;
 		recv.extracted += ssize2;
 
-		smb2_parse_one_message(server, &recv, rxq);
+		smb2_parse_one_message(server, &recv, rxq, decrypted);
 
 		WARN(rxq->pdu_remain > 0, "MSG=%08x pdu_remain=%x",
 		     rxq->msg_id, rxq->pdu_remain);
@@ -1612,6 +1600,6 @@ int smb2_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len)
 	 */
 	if (protocol_id == SMB2_TRANSFORM_PROTO_NUM)
 		return smb3_reverse_transform(server, rxq);
-	smb2_parse_pdu(server, rxq);
+	smb2_parse_pdu(server, rxq, false);
 	return 0;
 }
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 7bd04ebbce5d..03ed4925df08 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -21,7 +21,31 @@
  * Specify enums for tracing information.
  */
 #define smb_command_traces \
-	E_(smb_unknown_command,				"unknown-command")
+	EM(smb2_command_trace_negotiate,	"smb2-negotiate") \
+	EM(smb2_command_trace_session_setup,	"smb2-session_setup") \
+	EM(smb2_command_trace_logoff,		"smb2-logoff") \
+	EM(smb2_command_trace_tree_connect,	"smb2-tree_connect") \
+	EM(smb2_command_trace_tree_disconnect,	"smb2-tree_disconnect") \
+	EM(smb2_command_trace_create,		"smb2-create") \
+	EM(smb2_command_trace_close,		"smb2-close") \
+	EM(smb2_command_trace_flush,		"smb2-flush") \
+	EM(smb2_command_trace_read,		"smb2-read") \
+	EM(smb2_command_trace_write,		"smb2-write") \
+	EM(smb2_command_trace_lock,		"smb2-lock") \
+	EM(smb2_command_trace_ioctl,		"smb2-ioctl") \
+	EM(smb2_command_trace_cancel,		"smb2-cancel") \
+	EM(smb2_command_trace_echo,		"smb2-echo") \
+	EM(smb2_command_trace_query_directory,	"smb2-query_directory") \
+	EM(smb2_command_trace_change_notify,	"smb2-change_notify") \
+	EM(smb2_command_trace_query_info,	"smb2-query_info") \
+	EM(smb2_command_trace_set_info,		"smb2-set_info") \
+	EM(smb2_command_trace_oplock_break,	"smb2-oplock_break") \
+	EM(smb2_command_trace_s2c_notification,	"smb2-s2c-notification") \
+	EM(smb1_command_trace_read,		"smb1-read") \
+	EM(smb1_command_trace_write,		"smb1-write") \
+	EM(smb1_command_trace_echo,		"smb1-echo") \
+	EM(smb1_command_trace_unknown,		"smb1-unknown") \
+	E_(smb_command_trace_unknown,		"unknown-command")
 
 #define smb_eio_traces \
 	EM(smb_eio_trace_compress_copy,			"compress_copy") \
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 98dca2524376..d0bbd38970db 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -41,7 +41,18 @@ struct smb_message *smb_message_alloc(enum smb_command_trace cmd, gfp_t gfp)
 	if (smb) {
 		memset(smb, 0, sizeof(*smb));
 		refcount_set(&smb->ref, 1);
+		spin_lock_init(&smb->mid_lock);
 		smb->command_trace = cmd;
+		smb->when_alloc	= jiffies;
+		smb->pid	= current->pid;
+
+		/*
+		 * The default is for the mid to be synchronous, so the default
+		 * callback just wakes up the current task.
+		 */
+		smb->callback		= cifs_wake_up_task;
+		smb->callback_data	= current;
+		smb->mid_state		= MID_REQUEST_ALLOCATED;
 	}
 	return smb;
 }
@@ -61,7 +72,8 @@ void smb_put_message(struct smb_message *smb)
 }
 
 /*
- * Dispose of a chain of compound messages.
+ * Dispose of a chain of compound messages.  This should only be called by the
+ * caller of smb_send_recv_messages().
  */
 void smb_put_messages(struct smb_message *smb)
 {
@@ -81,7 +93,7 @@ cifs_wake_up_task(struct TCP_Server_Info *server, struct smb_message *smb)
 	wake_up_process(smb->callback_data);
 }
 
-void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
+static void smb_clear_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 #ifdef CONFIG_CIFS_STATS2
 	__le16 command = server->vals->lock_cmd;
@@ -156,22 +168,33 @@ void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 	}
 #endif
 	put_task_struct(smb->creator);
-
-	mempool_free(smb, &smb_message_pool);
 }
 
-void
-delete_mid(struct TCP_Server_Info *server, struct smb_message *smb)
+static bool discard_message(struct TCP_Server_Info *server, struct smb_message *smb)
 {
+	bool got_ref = false;
+
 	spin_lock(&server->mid_queue_lock);
 
 	if (!smb->deleted_from_q) {
 		list_del_init(&smb->qhead);
 		smb->deleted_from_q = true;
+		got_ref = true;
 	}
+
 	spin_unlock(&server->mid_queue_lock);
+	return got_ref;
+}
+
+static void smb_discard_messages(struct TCP_Server_Info *server, struct smb_message *head_smb)
+{
+	struct smb_message *smb, *next;
 
-	release_mid(server, smb);
+	for (smb = head_smb; smb; smb = next) {
+		next = smb->next;
+		if (discard_message(server, smb))
+			smb_put_message(smb);
+	}
 }
 
 /*
@@ -444,21 +467,18 @@ static size_t smb3_copy_data_iter(void *iter_from, size_t progress, size_t len,
  * TODO: In future, the buffers should be allocated by the marshalling code.
  */
 static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
-				     int num_rqst, struct smb_rqst *rqst,
+				     struct smb_message *head_smb,
 				     struct iov_iter *iter, struct bvecq **_bq,
 				     unsigned int flags)
 {
+	struct smb_message *smb;
 	struct bvecq *bq;
 	size_t total_len = 0, offset = 0;
+	int rc;
 
-	for (int i = 0; i < num_rqst; i++) {
-		struct smb_rqst *req = &rqst[i];
-		size_t size = iov_iter_count(&req->rq_iter);
-
-		for (int j = 0; j < req->rq_nvec; j++)
-			size += req->rq_iov[j].iov_len;
+	for (smb = head_smb; smb; smb = smb->next) {
 		total_len = ALIGN8(total_len);
-		total_len += size;
+		total_len += smb->total_len;
 	}
 
 	if (total_len <= PAGE_SIZE / 2) {
@@ -489,9 +509,9 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 
 	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
 
-	for (int i = 0; i < num_rqst; i++) {
-		struct smb_rqst *req = &rqst[i];
-		size_t size = iov_iter_count(&req->rq_iter);
+	for (smb = head_smb; smb; smb = smb->next) {
+		size_t size = iov_iter_count(&smb->rqst.rq_iter);
+		size_t got;
 
 		if (offset & 7) {
 			unsigned int tmp = offset;
@@ -499,23 +519,30 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 			iov_iter_zero(offset - tmp, iter);
 		}
 
-		for (int j = 0; j < req->rq_nvec; j++) {
-			size_t len = req->rq_iov[j].iov_len;
-			if (copy_to_iter(req->rq_iov[j].iov_base, len, iter) != len)
+		for (int i = 0; i < smb->rqst.rq_nvec; i++) {
+			size_t len = smb->rqst.rq_iov[i].iov_len;
+			got = copy_to_iter(smb->rqst.rq_iov[i].iov_base, len, iter);
+			if (got != len) {
+				rc = smb_EIO2(smb_eio_trace_tx_copy_to_buf, got, size);
 				goto error;
+			}
 			offset += len;
 		}
 
-		if (iterate_and_advance_kernel(&req->rq_iter,
-					       size, iter, NULL,
-					       smb3_copy_data_iter) != size)
+		got = iterate_and_advance_kernel(&smb->rqst.rq_iter,
+						 size, iter, NULL,
+						 smb3_copy_data_iter);
+		if (got != size) {
+			rc = smb_EIO2(smb_eio_trace_tx_copy_iter_to_buf, got, size);
 			goto error;
+		}
 
 		offset += size;
 	}
 
 	if (WARN_ONCE(offset != total_len,
 		      "offset=%zx total_len=%zx\n", offset, total_len)) {
+		rc = smb_EIO2(smb_eio_trace_tx_miscopy_to_buf, offset, total_len);
 		goto error;
 	}
 
@@ -525,12 +552,11 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 error:
 	bvecq_put(bq);
 	*_bq = NULL;
-	return -EIO;
+	return rc;
 }
 
 static int
-smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
-	      struct smb_rqst *rqst, int flags)
+smb_send_rqst(struct TCP_Server_Info *server, struct smb_message *head_smb, int flags)
 {
 	struct iov_iter iter;
 	struct bvecq *bq;
@@ -543,7 +569,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		return smb_EIO(smb_eio_trace_tx_need_transform);
 	}
 
-	rc = smb_copy_data_into_buffer(server, num_rqst, rqst, &iter, &bq, flags);
+	rc = smb_copy_data_into_buffer(server, head_smb, &iter, &bq, flags);
 	if (rc)
 		return rc;
 	content_len = iov_iter_count(&iter);
@@ -586,7 +612,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 					/* Fall back to uncompressed. */
 				} else {
 					if (rc == 0)
-						rc = -EIO;
+						rc = smb_EIO(smb_eio_trace_tx_compress_failed);
 					goto error;
 				}
 			}
@@ -598,7 +624,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			iov_iter_advance(&iter, troff);
 			tr_hdr = hdr_blob + troff;
 
-			rc = server->ops->init_transform_rq(server, num_rqst, rqst, tr_hdr, &iter);
+			rc = server->ops->init_transform_rq(server, head_smb, tr_hdr, &iter);
 			if (rc)
 				goto error;
 			content_len += sizeof(*tr_hdr);
@@ -858,16 +884,16 @@ int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb)
  * the result. Caller is responsible for dealing with timeouts.
  */
 int
-cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		mid_callback_t callback, void *cbdata, const int flags,
-		const struct cifs_credits *exist_credits,
-		struct iov_iter *resp_buf)
+cifs_call_async(struct TCP_Server_Info *server, struct smb_message *smb,
+		const int flags, const struct cifs_credits *exist_credits)
 {
-	int rc;
-	struct smb_message *smb;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	unsigned int instance;
 	int optype;
+	int rc;
+
+	if (WARN_ON_ONCE(smb->next))
+		return smb_EIO(smb_eio_trace_tx_chained_async);
 
 	optype = flags & CIFS_OP_MASK;
 
@@ -893,23 +919,18 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		return -EAGAIN;
 	}
 
-	smb = server->ops->setup_async_request(server, rqst);
-	if (IS_ERR(smb)) {
+	rc = server->ops->setup_async_request(server, smb);
+	if (rc) {
 		cifs_server_unlock(server);
 		add_credits_and_wake_if(server, &credits, optype);
-		return PTR_ERR(smb);
+		return rc;
 	}
 
 	smb->sr_flags = flags;
-	smb->callback = callback;
-	smb->callback_data = cbdata;
 	smb->mid_state = MID_REQUEST_SUBMITTED;
-	if (resp_buf) {
-		smb->copy_to_bufs = true;
-		smb->response_iter = *resp_buf;
-	}
 
 	/* put it on the pending_mid_q */
+	smb_get_message(smb);
 	spin_lock(&server->mid_queue_lock);
 	list_add_tail(&smb->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
@@ -919,12 +940,13 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(smb);
-	rc = smb_send_rqst(server, 1, rqst, flags);
+	rc = smb_send_rqst(server, smb, flags);
 
 	if (rc < 0) {
 		revert_current_mid(server, smb->credits_consumed);
 		server->sequence_number -= 2;
-		delete_mid(server, smb);
+		if (discard_message(server, smb))
+			smb_put_message(smb);
 	}
 
 	cifs_server_unlock(server);
@@ -974,19 +996,24 @@ int cifs_sync_mid_result(struct smb_message *smb, struct TCP_Server_Info *server
 	spin_unlock(&server->mid_queue_lock);
 
 sync_mid_done:
-	release_mid(server, smb);
+	smb_clear_mid(server, smb);
 	return rc;
 }
 
 static void
 cifs_compound_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_credits credits = {
-		.value = server->ops->get_credits(smb),
-		.instance = server->reconnect_instance,
-	};
+	if (server) {
+		struct cifs_credits credits = {
+			.value = 1,
+			.instance = server->reconnect_instance,
+		};
+
+		if (!is_smb1(server))
+			credits.value = server->ops->get_credits(smb);
 
-	add_credits(server, &credits, smb->optype);
+		add_credits(server, &credits, smb->optype);
+	}
 
 	if (smb->mid_state == MID_RESPONSE_RECEIVED)
 		smb->mid_state = MID_RESPONSE_READY;
@@ -1003,7 +1030,6 @@ static void
 cifs_cancelled_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	cifs_compound_callback(server, smb);
-	release_mid(server, smb);
 }
 
 /*
@@ -1059,30 +1085,28 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 	return server;
 }
 
-int
-compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
-		   struct TCP_Server_Info *server,
-		   const int flags, const int num_rqst, struct smb_rqst *rqst,
-		   int *resp_buf_type, struct kvec *resp_iov)
+/*
+ * Send a single message or a string of messages as a compound.
+ */
+static int smb_send_recv_messages(const unsigned int xid, struct cifs_ses *ses,
+				  struct TCP_Server_Info *server,
+				  struct smb_message *head_smb, const int flags)
 {
-	int i, j, optype, rc = 0;
-	struct smb_message *smb[MAX_COMPOUND];
-	bool cancelled_smb[MAX_COMPOUND] = {false};
-	struct cifs_credits credits[MAX_COMPOUND] = {
-		{ .value = 0, .instance = 0 }
-	};
 	unsigned int instance;
-
-	optype = flags & CIFS_OP_MASK;
-
-	for (i = 0; i < num_rqst; i++)
-		resp_buf_type[i] = CIFS_NO_BUFFER;  /* no response buf yet */
+	int nr_reqs, i, optype, rc = 0;
 
 	if (!ses || !ses->server || !server) {
 		cifs_dbg(VFS, "Null session\n");
 		return smb_EIO(smb_eio_trace_null_pointers);
 	}
 
+	optype = flags & CIFS_OP_MASK;
+
+	/* TODO: Stitch together the messages in a compound. */
+	nr_reqs = 0;
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+		nr_reqs++;
+
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsExiting) {
 		spin_unlock(&server->srv_lock);
@@ -1098,14 +1122,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * other requests.
 	 * This can be handled by the eventual session reconnect.
 	 */
-	rc = wait_for_compound_request(server, num_rqst, flags,
-				       &instance);
+	rc = wait_for_compound_request(server, nr_reqs, flags, &instance);
 	if (rc)
 		return rc;
 
-	for (i = 0; i < num_rqst; i++) {
-		credits[i].value = 1;
-		credits[i].instance = instance;
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next) {
+		smb->credits.value	= 1;
+		smb->credits.instance	= instance;
 	}
 
 	/*
@@ -1125,45 +1148,46 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	if (instance != server->reconnect_instance) {
 		cifs_server_unlock(server);
-		for (j = 0; j < num_rqst; j++)
-			add_credits(server, &credits[j], optype);
+		for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+			add_credits(server, &smb->credits, optype);
 		return -EAGAIN;
 	}
 
-	for (i = 0; i < num_rqst; i++) {
-		smb[i] = server->ops->setup_request(ses, server, &rqst[i]);
-		if (IS_ERR(smb[i])) {
-			revert_current_mid(server, i);
-			for (j = 0; j < i; j++)
-				delete_mid(server, smb[j]);
-			cifs_server_unlock(server);
-
-			/* Update # of requests on wire to server */
-			for (j = 0; j < num_rqst; j++)
-				add_credits(server, &credits[j], optype);
-			return PTR_ERR(smb[i]);
-		}
-
-		smb[i]->sr_flags = flags;
-		smb[i]->mid_state = MID_REQUEST_SUBMITTED;
-		smb[i]->optype = optype;
+	i = 0;
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next) {
+		smb->optype = optype;
 		/*
 		 * Invoke callback for every part of the compound chain
 		 * to calculate credits properly. Wake up this thread only when
 		 * the last element is received.
 		 */
-		if (i < num_rqst - 1)
-			smb[i]->callback = cifs_compound_callback;
+		if (smb->next)
+			smb->callback = cifs_compound_callback;
 		else
-			smb[i]->callback = cifs_compound_last_callback;
+			smb->callback = cifs_compound_last_callback;
+
+		rc = server->ops->setup_request(ses, server, smb);
+		if (rc) {
+			revert_current_mid(server, i);
+			smb_discard_messages(server, head_smb);
+			cifs_server_unlock(server);
+
+			/* Update # of requests on wire to server */
+			for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+				add_credits(server, &smb->credits, optype);
+			return rc;
+		}
+
+		smb->mid_state = MID_REQUEST_SUBMITTED;
 	}
-	rc = smb_send_rqst(server, num_rqst, rqst, flags);
 
-	for (i = 0; i < num_rqst; i++)
-		cifs_save_when_sent(smb[i]);
+	rc = smb_send_rqst(server, head_smb, flags);
+
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+		cifs_save_when_sent(smb);
 
 	if (rc < 0) {
-		revert_current_mid(server, num_rqst);
+		revert_current_mid(server, nr_reqs);
 		server->sequence_number -= 2;
 	}
 
@@ -1174,8 +1198,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * will not receive a response to - return credits back
 	 */
 	if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
-		for (i = 0; i < num_rqst; i++)
-			add_credits(server, &credits[i], optype);
+		for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+			add_credits(server, &smb->credits, optype);
 		goto out;
 	}
 
@@ -1194,72 +1218,60 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		spin_unlock(&ses->ses_lock);
 
-		if (WARN_ON_ONCE(num_rqst != 1 || !resp_iov))
+		if (WARN_ON_ONCE(head_smb->next))
 			return -EINVAL;
 
 		cifs_server_lock(server);
-		smb311_update_preauth_hash(ses, server, rqst[0].rq_iov, rqst[0].rq_nvec);
+		smb311_update_preauth_hash(ses, server, head_smb, false);
 		cifs_server_unlock(server);
-
-		spin_lock(&ses->ses_lock);
+	} else {
+		spin_unlock(&ses->ses_lock);
 	}
-	spin_unlock(&ses->ses_lock);
 
-	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_response(server, smb[i]);
-		if (rc != 0)
-			break;
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next) {
+		if (!smb->next) {
+			rc = wait_for_response(server, smb);
+			if (rc != 0)
+				break;
+		}
 	}
 	if (rc != 0) {
-		for (; i < num_rqst; i++) {
+		for (struct smb_message *smb = head_smb; smb; smb = smb->next) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
-				 smb[i]->mid, le16_to_cpu(smb[i]->command));
-			send_cancel(ses, server, &rqst[i], smb[i], xid);
-			spin_lock(&smb[i]->mid_lock);
-			smb[i]->wait_cancelled = true;
-			if (smb[i]->mid_state == MID_REQUEST_SUBMITTED ||
-			    smb[i]->mid_state == MID_RESPONSE_RECEIVED) {
-				smb[i]->callback = cifs_cancelled_callback;
-				cancelled_smb[i] = true;
-				credits[i].value = 0;
+					smb->mid, le32_to_cpu(smb->command));
+			send_cancel(ses, server, smb, xid);
+			spin_lock(&smb->mid_lock);
+			smb->wait_cancelled = true;
+			if (smb->mid_state == MID_REQUEST_SUBMITTED ||
+			    smb->mid_state == MID_RESPONSE_RECEIVED) {
+				smb->callback = cifs_cancelled_callback;
+				smb->cancelled = true;
+				smb->credits.value = 0;
 			}
-			spin_unlock(&smb[i]->mid_lock);
+			spin_unlock(&smb->mid_lock);
 		}
 	}
 
-	for (i = 0; i < num_rqst; i++) {
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next) {
 		if (rc < 0)
 			goto out;
 
-		rc = cifs_sync_mid_result(smb[i], server);
+		rc = cifs_sync_mid_result(smb, server);
 		if (rc != 0) {
 			/* mark this mid as cancelled to not free it below */
-			cancelled_smb[i] = true;
+			smb->cancelled = true;
 			goto out;
 		}
 
-		if (!smb[i]->response ||
-		    smb[i]->mid_state != MID_RESPONSE_READY) {
-			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, smb[i]->mid_state);
+		if (!smb->response ||
+		    smb->mid_state != MID_RESPONSE_READY) {
+			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, smb->mid_state);
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
 		}
 
-		rc = server->ops->check_receive(smb[i], server,
+		rc = server->ops->check_receive(smb, server,
 						flags & CIFS_LOG_ERROR);
-		if (resp_iov) {
-			resp_iov[i].iov_base = smb[i]->response;
-			resp_iov[i].iov_len = smb[i]->resp_len;
-
-			if (smb[i]->large_buf)
-				resp_buf_type[i] = CIFS_LARGE_BUFFER;
-			else
-				resp_buf_type[i] = CIFS_SMALL_BUFFER;
-
-			/* mark it so buf will not be freed by delete_mid */
-			if ((flags & CIFS_NO_RSP_BUF) == 0)
-				smb[i]->response = NULL;
-		}
 	}
 
 	/*
@@ -1267,17 +1279,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	spin_lock(&ses->ses_lock);
 	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
-		struct kvec iov = {
-			.iov_base = resp_iov[0].iov_base,
-			.iov_len = resp_iov[0].iov_len
-		};
 		spin_unlock(&ses->ses_lock);
 		cifs_server_lock(server);
-		smb311_update_preauth_hash(ses, server, &iov, 1);
+		smb311_update_preauth_hash(ses, server, head_smb, true);
 		cifs_server_unlock(server);
-		spin_lock(&ses->ses_lock);
+	} else {
+		spin_unlock(&ses->ses_lock);
 	}
-	spin_unlock(&ses->ses_lock);
 
 out:
 	/*
@@ -1286,11 +1294,79 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * This is prevented above by using a noop callback that will not
 	 * wake this thread except for the very last PDU.
 	 */
-	for (i = 0; i < num_rqst; i++) {
-		if (!cancelled_smb[i])
-			delete_mid(server, smb[i]);
+	for (struct smb_message *smb = head_smb; smb; smb = smb->next)
+		if (!smb->cancelled)
+			discard_message(server, smb);
+
+	return rc;
+}
+
+int
+compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
+		   struct TCP_Server_Info *server,
+		   const int flags, const int num_rqst, struct smb_rqst *rqst,
+		   int *resp_buf_type, struct kvec *resp_iov)
+{
+	struct smb_message *head_smb = NULL, **ppsmb = &head_smb, *smb;
+	int rc = -ENOMEM;
+
+	if (!ses || !ses->server || !server) {
+		cifs_dbg(VFS, "Null session\n");
+		return smb_EIO(smb_eio_trace_null_pointers);
 	}
 
+	for (int i = 0; i < num_rqst; i++) {
+		struct smb_rqst *rq = &rqst[i];
+		void *request = rq->rq_iov[0].iov_base;
+		struct smb2_hdr *hdr = request;
+		enum smb_command_trace cmd = smb_command_trace_unknown;
+
+		if (!is_smb1(server))
+			cmd = le32_to_cpu(hdr->Command);
+
+		smb = smb_message_alloc(cmd, GFP_NOFS);
+		if (!smb)
+			goto error;
+
+		*ppsmb = smb;
+		ppsmb = &smb->next;
+		smb->request		= request;
+		smb->rqst		= *rq;
+		smb->sr_flags		= flags;
+
+		if (is_smb1(server)) {
+			smb->command = 0;
+			smb->command_trace = smb1_command_trace_unknown;
+		}
+
+		for (int j = 0; j < rq->rq_nvec; j++)
+			smb->total_len += rq->rq_iov[j].iov_len;
+		smb->total_len += iov_iter_count(&rq->rq_iter);
+	}
+
+	rc = smb_send_recv_messages(xid, ses, server, head_smb, flags);
+
+	smb = head_smb;
+	for (int i = 0; i < num_rqst; i++) {
+		if (smb->response && !(flags & CIFS_NO_RSP_BUF)) {
+			resp_iov[i].iov_base = smb->response;
+			resp_iov[i].iov_len  = smb->resp_len;
+			smb->response = NULL;
+
+			if (smb->large_buf)
+				resp_buf_type[i] = CIFS_LARGE_BUFFER;
+			else
+				resp_buf_type[i] = CIFS_SMALL_BUFFER;
+		} else {
+			resp_iov[i].iov_base	= NULL;
+			resp_buf_type[i]	= 0;
+			resp_buf_type[i]	= CIFS_NO_BUFFER;
+		}
+		smb = smb->next;
+	}
+
+error:
+	smb_put_messages(head_smb);
 	return rc;
 }
 

