Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD19C3FE648
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186227; cv=none; b=FbJnGTyY4WJkvolxbWntIxnIyQHl380f+PBt2B1cjVMoVueAfjVDOmvK60txw0gurHaVGb1LXbwIJOt7odOmkgUtnTwNqkVjLreRxNXsqEzSbR0ZUgf1p7Y7hDXXzdR5hhk0lnLgeN3aeVoYgQl51cOANd9JC29KDxYHvMcaAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186227; c=relaxed/simple;
	bh=gSlyQr+6Tkys+p9IDrNUZdWNOCbh6M97dN95Etkro44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFfp2OCr200vAQnI9SF1d97jwqu6ojBAE5EtXURs1WmIIR5IAZw1ZwkJA0q1POvGiekHCxj2+IZ3umsss5GNriutxcl0dKlReRy37wkXEZa+F4+fOMTUCazAqmXO4c3AwEqxs7aLkzGWGXce1c/xPAsWbF6MXYplz7CXI+cv4SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNv+VbUn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNv+VbUn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OT0DIRL21C4YaGMi0su8gLYisllUKrenId+PISlFG4=;
	b=FNv+VbUnHxUACr9EQKKUjhtIRk3UaUm+oZAP1RW61n4osLR/Gxdxj6I1RPNglnpxgkiXcJ
	gj0pOKrbS/ARQLEyGvD7axyDK5liR9KoKXhf/vlbpnz88RI5rCcDqdH4k0RIkDqn9fqZL+
	qMRXaaQ+7DVVip92Frb0A59PP6LxsZk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-LyeGPw__PlmdJOCcskBn5Q-1; Tue,
 19 May 2026 06:23:36 -0400
X-MC-Unique: LyeGPw__PlmdJOCcskBn5Q-1
X-Mimecast-MFC-AGG-ID: LyeGPw__PlmdJOCcskBn5Q_1779186214
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFAB319560B4;
	Tue, 19 May 2026 10:23:34 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C278B1800352;
	Tue, 19 May 2026 10:23:31 +0000 (UTC)
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
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 18/36] cifs: Use page frag allocator for Tx buffers
Date: Tue, 19 May 2026 11:21:36 +0100
Message-ID: <20260519102158.592165-19-dhowells@redhat.com>
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

Use a per-TCP connection page fragment allocator for transmission buffers
rather than using whole pages for messages less than half a page in size.
Currently, the data is copied into there, but we should allocate these in
future up front instead of kmalloc'd bits and avoid that copy too.

Note that these page fragments can be used with MSG_SPLICE_PAGES and thus
avoid a copy inside the TCP stack.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  2 ++
 fs/smb/client/connect.c   |  3 +++
 fs/smb/client/transport.c | 38 ++++++++++++++++++++++++++++++++------
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f7c12d24e2ea..cd9bf550a144 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -662,6 +662,8 @@ struct TCP_Server_Info {
 	/* updates to tcpStatus protected by cifs_tcp_ses_lock */
 	enum statusEnum tcpStatus; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
+	struct page_frag_cache tx_alloc; /* Transmission buffer allocator */
+	struct mutex tx_alloc_lock; /* Lock for ->tx_alloc */
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
 	struct sockaddr_storage srcaddr; /* locally bind to this IP */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 4a3ebbd6d71b..1d6a18390a25 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1054,6 +1054,8 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
+	page_frag_cache_drain(&server->tx_alloc);
+
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server->hostname);
@@ -1694,6 +1696,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
+	mutex_init(&tcp_ses->tx_alloc_lock);
 	memcpy(&tcp_ses->srcaddr, &ctx->srcaddr,
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &ctx->dstaddr,
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index e43fce1099a9..98dca2524376 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -445,7 +445,8 @@ static size_t smb3_copy_data_iter(void *iter_from, size_t progress, size_t len,
  */
 static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 				     int num_rqst, struct smb_rqst *rqst,
-				     struct iov_iter *iter, struct bvecq **_bq)
+				     struct iov_iter *iter, struct bvecq **_bq,
+				     unsigned int flags)
 {
 	struct bvecq *bq;
 	size_t total_len = 0, offset = 0;
@@ -460,9 +461,31 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 		total_len += size;
 	}
 
-	bq = bvecq_alloc_buffer(total_len, GFP_NOFS);
-	if (!bq)
-		return -ENOMEM;
+	if (total_len <= PAGE_SIZE / 2) {
+		/* TODO: Choose algo-based alignment. */
+		unsigned int align = (flags & CIFS_TRANSFORM_REQ) ? 32 : 1;
+		size_t alen = (flags & CIFS_TRANSFORM_REQ) ?
+			round_up(total_len, align) : total_len;
+
+		bq = bvecq_alloc_chain(2, GFP_NOFS);
+		if (!bq)
+			return -ENOMEM;
+		mutex_lock(&server->tx_alloc_lock);
+		void *p = page_frag_alloc_align(&server->tx_alloc, alen,
+						GFP_NOFS, align);
+		mutex_unlock(&server->tx_alloc_lock);
+		if (!p) {
+			bvecq_put(bq);
+			return -ENOMEM;
+		}
+		bvec_set_virt(&bq->bv[1], p, total_len);
+		bq->nr_slots = 2;
+		bq->mem_type = BVECQ_MEM_PAGECACHE;
+	} else {
+		bq = bvecq_alloc_buffer2(total_len, 1, GFP_NOFS);
+		if (!bq)
+			return -ENOMEM;
+	}
 
 	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
 
@@ -495,6 +518,7 @@ static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
 		      "offset=%zx total_len=%zx\n", offset, total_len)) {
 		goto error;
 	}
+
 	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
 	*_bq = bq;
 	return 0;
@@ -519,7 +543,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		return smb_EIO(smb_eio_trace_tx_need_transform);
 	}
 
-	rc = smb_copy_data_into_buffer(server, num_rqst, rqst, &iter, &bq);
+	rc = smb_copy_data_into_buffer(server, num_rqst, rqst, &iter, &bq, flags);
 	if (rc)
 		return rc;
 	content_len = iov_iter_count(&iter);
@@ -537,7 +561,9 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 
 		/* TODO: Allocate netmem here */
 		rc = -ENOMEM;
-		hdr_blob = (void *)__get_free_page(GFP_NOFS);
+		mutex_lock(&server->tx_alloc_lock);
+		hdr_blob = page_frag_alloc(&server->tx_alloc, hdr_len, GFP_NOFS);
+		mutex_unlock(&server->tx_alloc_lock);
 		if (!hdr_blob)
 			goto error;
 		bvec_set_virt(&bq->bv[0], hdr_blob, hdr_len);

