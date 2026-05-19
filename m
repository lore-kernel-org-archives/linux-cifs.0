Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5EB4BC014
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186204; cv=none; b=YVZ8NWCxifoGXrpuvfl/Wrw8RrVQYNSJX6UlW9QC/8cpRhzjsHP5x9wH90w/TfAdsOc/9hU3ZFd3+1dY5MWN+fqZdwdTV2DqUyKnsdi6HkjX02SMMR7Bk8WD8I/IKnqPKdld7lkver9vgvfZjxLeG48iKzzy9hr4RjLbR6oBgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186204; c=relaxed/simple;
	bh=K3b5Dyat0A8f/elx3HTfTo8qt8eIWF6txSPsXm2YHTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxYcsc3TbAedtuKuIA3JRDTrsUDyr6GrpWD32Ag8d/gnG9b3Y11LTLddl0WDv6bKtbOxdAe3Ls6teF/ZiffmGtuF4rnLwcP508Ri0E26PWdUGkHWLH2wnvc3Ql0aW0yqkvl1C9OIeMvCPfIuK/qIo+avcjDgOzH1+3nEkzvTs14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnL6F/2l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnL6F/2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0AnFeCjYcDDfsH1O+KLQZ11YU9SELl0/imvW9W9ZBoc=;
	b=JnL6F/2lN7ZtQtZnzNspJPO+8hxrA/LlnYD3Nm7B9hVNOoJYGibeYapbsRdXc75vMdpzly
	QuxJYYsfp/JOo0XCqXVkQsIven3VMcyoQePe1sjXw6fZwu/pv+WsUk6t+2GrHQqiZIqm9T
	Sx8Y9gS2Oyt+qGZvAGk3dnqjQi3yi24=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-JEbCGXKHOt2HxxgowKq9Cg-1; Tue,
 19 May 2026 06:23:16 -0400
X-MC-Unique: JEbCGXKHOt2HxxgowKq9Cg-1
X-Mimecast-MFC-AGG-ID: JEbCGXKHOt2HxxgowKq9Cg_1779186195
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36D3118002E3;
	Tue, 19 May 2026 10:23:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC1FA30001A2;
	Tue, 19 May 2026 10:23:11 +0000 (UTC)
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
Subject: [RFC PATCH 14/36] cifs: Remove cifs_io_subrequest::got_bytes
Date: Tue, 19 May 2026 11:21:32 +0100
Message-ID: <20260519102158.592165-15-dhowells@redhat.com>
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

Remove cifs_io_subrequest::got_bytes as smb->resp_data_len can be used
instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 -
 fs/smb/client/cifssmb.c  | 27 +++++++++++++--------------
 fs/smb/client/smb2pdu.c  | 22 ++++++++++------------
 3 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7187e304c42e..2cb858495bc1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1467,7 +1467,6 @@ struct cifs_io_subrequest {
 		struct netfs_io_request *rreq;
 		struct cifs_io_request *req;
 	};
-	ssize_t				got_bytes;
 	unsigned int			xid;
 	int				result;
 	bool				have_xid;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 901f8aff6134..62f554f97a5c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1450,7 +1450,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		 __func__, smb->mid, smb->mid_state, rdata->result,
 		 rdata->subreq.len);
 
-	if (rdata->got_bytes)
+	if (smb->resp_data_len)
 		iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
 				    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
 				    rdata->subreq.content.offset, rdata->subreq.len);
@@ -1458,9 +1458,8 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
-		rdata->got_bytes = smb->resp_data_len;
 		if (server->sign) {
-			int rc = 0;
+			int rc;
 
 			iov_iter_truncate(&rqst.rq_iter, smb->resp_data_len);
 			rc = cifs_verify_signature(&rqst, server,
@@ -1470,8 +1469,8 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 					 rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->got_bytes);
-		cifs_stats_bytes_read(tcon, rdata->got_bytes);
+		task_io_account_read(smb->resp_data_len);
+		cifs_stats_bytes_read(tcon, smb->resp_data_len);
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
@@ -1481,12 +1480,12 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 do_retry:
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 		rdata->result = -EAGAIN;
-		if (server->sign && rdata->got_bytes)
+		if (server->sign && smb->resp_data_len)
 			/* reset bytes number since we can not check a sign */
-			rdata->got_bytes = 0;
+			smb->resp_data_len = 0;
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->got_bytes);
-		cifs_stats_bytes_read(tcon, rdata->got_bytes);
+		task_io_account_read(smb->resp_data_len);
+		cifs_stats_bytes_read(tcon, smb->resp_data_len);
 		break;
 	case MID_RESPONSE_MALFORMED:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_malformed);
@@ -1511,15 +1510,15 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 				    rdata->subreq.len   - rdata->subreq.transferred,
 				    rdata->result);
 	} else {
-		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
+		size_t trans = rdata->subreq.transferred + smb->resp_data_len;
 		if (trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
 			rdata->result = 0;
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
-		} else if (rdata->got_bytes > 0) {
+		} else if (smb->resp_data_len > 0) {
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
 		}
-		if (rdata->got_bytes)
+		if (smb->resp_data_len)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
 		trace_smb3_read_done(rdata->rreq->debug_id,
 				     rdata->subreq.debug_index,
@@ -1527,7 +1526,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 				     rdata->req->cfile->fid.persistent_fid,
 				     tcon->tid, tcon->ses->Suid,
 				     rdata->subreq.start + rdata->subreq.transferred,
-				     rdata->got_bytes);
+				     smb->resp_data_len);
 	}
 
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
@@ -1535,7 +1534,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 			      0, cifs_trace_rw_credits_read_response_clear);
 	rdata->credits.value = 0;
 	rdata->subreq.error = rdata->result;
-	rdata->subreq.transferred += rdata->got_bytes;
+	rdata->subreq.transferred += smb->resp_data_len;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
 	release_mid(server, smb);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ab193f84c1ab..ddf127dc27bb 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4671,10 +4671,9 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 		}
 
-		rdata->got_bytes = smb->resp_data_len;
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->got_bytes);
-		cifs_stats_bytes_read(tcon, rdata->got_bytes);
+		task_io_account_read(smb->resp_data_len);
+		cifs_stats_bytes_read(tcon, smb->resp_data_len);
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
@@ -4684,12 +4683,12 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 do_retry:
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 		rdata->result = -EAGAIN;
-		if (server->sign && rdata->got_bytes)
+		if (server->sign && smb->resp_data_len)
 			/* reset bytes number since we can not check a sign */
-			rdata->got_bytes = 0;
+			smb->resp_data_len = 0;
 		/* FIXME: should this be counted toward the initiating task? */
-		task_io_account_read(rdata->got_bytes);
-		cifs_stats_bytes_read(tcon, rdata->got_bytes);
+		task_io_account_read(smb->resp_data_len);
+		cifs_stats_bytes_read(tcon, smb->resp_data_len);
 		break;
 	case MID_RESPONSE_MALFORMED:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_malformed);
@@ -4731,19 +4730,19 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 				     rdata->req->cfile->fid.persistent_fid,
 				     tcon->tid, tcon->ses->Suid,
 				     rdata->subreq.start + rdata->subreq.transferred,
-				     rdata->got_bytes);
+				     smb->resp_data_len);
 
 	if (rdata->result == -ENODATA) {
 		__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 		rdata->result = 0;
 	} else {
-		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
+		size_t trans = rdata->subreq.transferred + smb->resp_data_len;
 		if (trans < rdata->subreq.len &&
 		    rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
 		}
-		if (rdata->got_bytes)
+		if (smb->resp_data_len)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
 	}
 
@@ -4759,7 +4758,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 			      0, cifs_trace_rw_credits_read_response_clear);
 	rdata->credits.value = 0;
 	rdata->subreq.error = rdata->result;
-	rdata->subreq.transferred += rdata->got_bytes;
+	rdata->subreq.transferred += smb->resp_data_len;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
 	release_mid(server, smb);
@@ -4814,7 +4813,6 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
 	rdata->iov[0].iov_base = buf;
 	rdata->iov[0].iov_len = total_len;
-	rdata->got_bytes = 0;
 	rdata->result = 0;
 
 	shdr = (struct smb2_hdr *)buf;

