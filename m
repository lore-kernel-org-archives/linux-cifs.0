Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7074ADDB2
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186209; cv=none; b=Avr1IJVua04ARRvkOsP4znQd3wP2cu3fXF4Ia5j9FCN2GxG4qLgqDJYe8aT7L/Azk7kS02YKF/0j0GWooO4o3dfmUnkemVhhFzUwfP9mjIaZBlRvPrnu8N7NzlGOKAlH87YnZzvhGMgxFWGGHIvxlhxv8ytNUO7TYFJNUhdguSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186209; c=relaxed/simple;
	bh=8jWa5UD6qXWED1La5NzDIlhGb8V4w6T4v1EVCHljhA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1fTi5oYzik7D9W+oaU8FMP6lBygoqr8ntsjw6enUXePemYv9rR7wL7b30zy5bXDDIiTxdQJPohZOwmIFTTqzLy0VvBuRIrqa2j12NAQVq0Po1qmiYmnBBUo9sNPqRrm7DG3E9OelcD3TQzIFsR8jfqmwfWSI/meDabKIc1u6Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOUlvoGp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOUlvoGp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VkysUk1MJocDAUy1EaC0Cxyx/GDmaeNWp9VU2xxTEok=;
	b=QOUlvoGpdZXaylpsXsBA1G2znb8+N5vMYvh9SCFN0q4Ip4fFjnKsCV7cTEU2Hc9UOd0fH8
	HQCjmG8c1h01Q1cRA7+IoO7d3zIMI4EREMRCU0m8frtJa+xa1OrtunXEb1TlgIzjEyzBOv
	4IclbXVE9oQWVdGKZyfI8/gGVOcnTxQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-NK3ItpY7NCi8nulgm2h-uw-1; Tue,
 19 May 2026 06:23:21 -0400
X-MC-Unique: NK3ItpY7NCi8nulgm2h-uw-1
X-Mimecast-MFC-AGG-ID: NK3ItpY7NCi8nulgm2h-uw_1779186200
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F198195608D;
	Tue, 19 May 2026 10:23:20 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4CC0180034E;
	Tue, 19 May 2026 10:23:16 +0000 (UTC)
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
Subject: [RFC PATCH 15/36] cifs: Pass smb_message to cifs_verify_signature()
Date: Tue, 19 May 2026 11:21:33 +0100
Message-ID: <20260519102158.592165-16-dhowells@redhat.com>
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

Pass smb_message to cifs_verify_signature() rather than an smb_rqst.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifssmb.c       | 13 +------------
 fs/smb/client/smb1encrypt.c   | 19 ++++++++++++++-----
 fs/smb/client/smb1proto.h     |  2 +-
 fs/smb/client/smb1transport.c | 16 ++++------------
 4 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 62f554f97a5c..c5b18e1c44ab 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1432,11 +1432,6 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct inode *inode = &ictx->inode;
-	struct kvec iov = {
-		.iov_base = smb->response,
-		.iov_len  = smb->resp_len,
-	};
-	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
 	struct cifs_credits credits = {
 		.value = 1,
 		.instance = 0,
@@ -1450,19 +1445,13 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		 __func__, smb->mid, smb->mid_state, rdata->result,
 		 rdata->subreq.len);
 
-	if (smb->resp_data_len)
-		iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
-				    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-				    rdata->subreq.content.offset, rdata->subreq.len);
-
 	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
 		if (server->sign) {
 			int rc;
 
-			iov_iter_truncate(&rqst.rq_iter, smb->resp_data_len);
-			rc = cifs_verify_signature(&rqst, server,
+			rc = cifs_verify_signature(smb, server,
 						   smb->sequence_number);
 			if (rc)
 				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
index 819c736c26e9..c61202ae54c6 100644
--- a/fs/smb/client/smb1encrypt.c
+++ b/fs/smb/client/smb1encrypt.c
@@ -106,14 +106,23 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	return rc;
 }
 
-int cifs_verify_signature(struct smb_rqst *rqst,
+int cifs_verify_signature(struct smb_message *smb,
 			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number)
 {
-	unsigned int rc;
-	char server_response_sig[8];
+	struct smb_hdr *cifs_pdu = smb->response;
+	struct kvec iov = {
+		.iov_base = smb->response,
+		.iov_len  = smb->resp_len,
+	};
+	struct smb_rqst rqst = {
+		.rq_iov = &iov,
+		.rq_nvec = 1,
+		.rq_iter = smb->response_iter
+	};
 	char what_we_think_sig_should_be[20];
-	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
+	char server_response_sig[8];
+	int rc;
 
 	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
@@ -145,7 +154,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	cifs_server_lock(server);
-	rc = cifs_calc_signature(rqst, server, what_we_think_sig_should_be);
+	rc = cifs_calc_signature(&rqst, server, what_we_think_sig_should_be);
 	cifs_server_unlock(server);
 
 	if (rc)
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index b2ad0ef64051..54a5261fabce 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -227,7 +227,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server);
  */
 int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number);
-int cifs_verify_signature(struct smb_rqst *rqst,
+int cifs_verify_signature(struct smb_message *smb,
 			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number);
 int cifs_verify_trans_signature(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 776d615f69d3..a6af5bd20847 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -156,22 +156,14 @@ int
 cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = smb->resp_len;
-
-	dump_smb(smb->response, min_t(u32, 92, len));
+	dump_smb(smb->response, min_t(u32, 92, smb->resp_len));
 
 	/* convert the length into a more usable form */
 	if (server->sign && !smb->sig_checked) {
-		struct kvec iov[1];
-		int rc = 0;
-		struct smb_rqst rqst = { .rq_iov = iov,
-					 .rq_nvec = ARRAY_SIZE(iov) };
-
-		iov[0].iov_base = smb->response;
-		iov[0].iov_len = len;
+		int rc;
 
-		rc = cifs_verify_signature(&rqst, server,
-					   smb->sequence_number);
+		/* FIXME: add code to kill session */
+		rc = cifs_verify_signature(smb, server, smb->sequence_number);
 		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);

