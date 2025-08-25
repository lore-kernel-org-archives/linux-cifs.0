Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAB11632C8
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155046; cv=none; b=RKNU8tMSOvs4IucgT4847QzcnHoEEpV/9Nxi3d8H5oovyBZfm7tcHT8NK/oeCdFcj7hCKjEJdTZRFmJKjHs9zPaIzyQL3QFMgV+eYramz1sYGGZnxLiQ8RfIQBxuqbH/lT7zvkBET+LljL90yYqXLrQJ1wgQ9bVQnQpUCmkLOpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155046; c=relaxed/simple;
	bh=KBGf3u23GoOX0vmfixYRDtgbvu2TCwH0ySNv+Qp1iPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF/uEalK+qXu5hp1EEdFFmxCVT28u/f5/zJ+OtUqimIiN9So7OealatyxZqIZozOjlwfi+Es4v5f+diuNFzvWeUxVob/XGzsTIrS1FpgPnrswOeYKliaUwX05Gj2Koia3kkwSlGC25aZI1KI/1u7Aj+Y0VlpaHmIfwZaUhbb2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OTpVKulM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OTpVKulM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=D6cndrSaDA5P5QgBe2kcwUM/Ppd+v9fXa3brfggdk9k=; b=OTpVKulM+7u9DQ68a8lyqbHmsA
	tuglZb9Mo1Mkb/HfB3cffePn4p5IWxC+vPrERr1WV2umyXEC0TdjjIaJov03GElXExy9hqzhD5xVF
	vRkN20ENE2xwzCkig2beBFH+3LFFZBRnaVc+yYPU+Ng/wMAAiIx9IUi1KpGws125b1rLdWx6RYHyY
	yqnYRl4CsCDEF+BOcWKT7B1SE9QOkGmUdxNR+EX5eEt9TLccBEOkUnBiqSmZ9Wy3e/MNEYqBfcu+u
	Jlm65j64fvW8mGJscaQWR69K//fU4sy9wNoLRqE16vs+AI0Ry7Yjy2BILNgPKAhk3sXfcznBUpVj5
	X89FrkURJmucu6/5d4RKP3/LBxp2mOpTFzyGXbDXxJqFWXmPUrd0TrfSnThApjip5BYq/Gijuq0tU
	ewumhb/O4SunZCH9BxPUPZJDVjvuRL/c2215SRwFtT1CLFRJGPEOLgsKxvUyy2XF0XWdz7eJn1aWr
	897mJJVqPKBXjwX32kMDNsug;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe9C-000kxi-1n;
	Mon, 25 Aug 2025 20:50:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 053/142] smb: client: make use of smbdirect_socket_parameters.max_frmr_depth
Date: Mon, 25 Aug 2025 22:40:14 +0200
Message-ID: <ab803fd8f71859eac13621f7296684c90bfdf4c0.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This make it easier to have common code later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/file.c       | 16 ++++++++++++----
 fs/smb/client/smbdirect.c  | 34 ++++++++++++++++++----------------
 fs/smb/client/smbdirect.h  |  2 --
 4 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index eca7bd0df7d3..060d47ccec2a 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -484,7 +484,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nMR responder_resources: %x "
 			"max_frmr_depth: %x mr_type: %x",
 			sp->responder_resources,
-			server->smbd_conn->max_frmr_depth,
+			sp->max_frmr_depth,
 			server->smbd_conn->mr_type);
 		seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
 			atomic_read(&server->smbd_conn->mr_ready_count),
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 186e061068be..f9a8790d3fe8 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -97,8 +97,12 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_write_prepare);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn)
-		stream->sreq_max_segs = server->smbd_conn->max_frmr_depth;
+	if (server->smbd_conn) {
+		const struct smbdirect_socket_parameters *sp =
+			smbd_get_parameters(server->smbd_conn);
+
+		stream->sreq_max_segs = sp->max_frmr_depth;
+	}
 #endif
 }
 
@@ -187,8 +191,12 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_read_submit);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn)
-		rreq->io_streams[0].sreq_max_segs = server->smbd_conn->max_frmr_depth;
+	if (server->smbd_conn) {
+		const struct smbdirect_socket_parameters *sp =
+			smbd_get_parameters(server->smbd_conn);
+
+		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
+	}
 #endif
 	return 0;
 }
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1a1acc0ee4b0..db6e8b5e8352 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -443,8 +443,6 @@ static bool process_negotiation_response(
 		struct smbdirect_recv_io *response, int packet_length)
 {
 	struct smbdirect_socket *sc = response->socket;
-	struct smbd_connection *info =
-		container_of(sc, struct smbd_connection, socket);
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_negotiate_resp *packet = smbdirect_recv_io_payload(response);
 
@@ -500,8 +498,8 @@ static bool process_negotiation_response(
 
 	sp->max_read_write_size = min_t(u32,
 			le32_to_cpu(packet->max_readwrite_size),
-			info->max_frmr_depth * PAGE_SIZE);
-	info->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
+			sp->max_frmr_depth * PAGE_SIZE);
+	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	return true;
@@ -791,6 +789,7 @@ static int smbd_ia_open(
 		struct sockaddr *dstaddr, int port)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
 
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_CREATED);
@@ -811,8 +810,8 @@ static int smbd_ia_open(
 		rc = -EPROTONOSUPPORT;
 		goto out2;
 	}
-	info->max_frmr_depth = min_t(int,
-		smbd_max_frmr_depth,
+	sp->max_frmr_depth = min_t(u32,
+		sp->max_frmr_depth,
 		sc->ib.dev->attrs.max_fast_reg_page_list_len);
 	info->mr_type = IB_MR_TYPE_MEM_REG;
 	if (sc->ib.dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG)
@@ -1706,6 +1705,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sp->max_send_size = smbd_max_send_size;
 	sp->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
 	sp->max_recv_size = smbd_max_receive_size;
+	sp->max_frmr_depth = smbd_max_frmr_depth;
 	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
 	sp->keepalive_timeout_msec = KEEPALIVE_RECV_TIMEOUT * 1000;
 
@@ -2191,6 +2191,7 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 	struct smbd_connection *info =
 		container_of(work, struct smbd_connection, mr_recovery_work);
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *smbdirect_mr;
 	int rc;
 
@@ -2209,11 +2210,11 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 
 			smbdirect_mr->mr = ib_alloc_mr(
 				sc->ib.pd, info->mr_type,
-				info->max_frmr_depth);
+				sp->max_frmr_depth);
 			if (IS_ERR(smbdirect_mr->mr)) {
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    info->mr_type,
-					    info->max_frmr_depth);
+					    sp->max_frmr_depth);
 				smbd_disconnect_rdma_connection(info);
 				continue;
 			}
@@ -2284,13 +2285,13 @@ static int allocate_mr_list(struct smbd_connection *info)
 		if (!smbdirect_mr)
 			goto cleanup_entries;
 		smbdirect_mr->mr = ib_alloc_mr(sc->ib.pd, info->mr_type,
-					info->max_frmr_depth);
+					sp->max_frmr_depth);
 		if (IS_ERR(smbdirect_mr->mr)) {
 			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
-				    info->mr_type, info->max_frmr_depth);
+				    info->mr_type, sp->max_frmr_depth);
 			goto out;
 		}
-		smbdirect_mr->sgt.sgl = kcalloc(info->max_frmr_depth,
+		smbdirect_mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
 						sizeof(struct scatterlist),
 						GFP_KERNEL);
 		if (!smbdirect_mr->sgt.sgl) {
@@ -2395,15 +2396,16 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 				 bool writing, bool need_invalidate)
 {
 	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_mr_io *smbdirect_mr;
 	int rc, num_pages;
 	enum dma_data_direction dir;
 	struct ib_reg_wr *reg_wr;
 
-	num_pages = iov_iter_npages(iter, info->max_frmr_depth + 1);
-	if (num_pages > info->max_frmr_depth) {
+	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
+	if (num_pages > sp->max_frmr_depth) {
 		log_rdma_mr(ERR, "num_pages=%d max_frmr_depth=%d\n",
-			num_pages, info->max_frmr_depth);
+			num_pages, sp->max_frmr_depth);
 		WARN_ON_ONCE(1);
 		return NULL;
 	}
@@ -2421,8 +2423,8 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 	smbdirect_mr->sgt.orig_nents = 0;
 
 	log_rdma_mr(INFO, "num_pages=0x%x count=0x%zx depth=%u\n",
-		    num_pages, iov_iter_count(iter), info->max_frmr_depth);
-	smbd_iter_to_mr(info, iter, &smbdirect_mr->sgt, info->max_frmr_depth);
+		    num_pages, iov_iter_count(iter), sp->max_frmr_depth);
+	smbd_iter_to_mr(info, iter, &smbdirect_mr->sgt, sp->max_frmr_depth);
 
 	rc = ib_dma_map_sg(sc->ib.dev, smbdirect_mr->sgt.sgl,
 			   smbdirect_mr->sgt.nents, dir);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 83e726967b2f..c88ba6e11dd1 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -41,8 +41,6 @@ struct smbd_connection {
 
 
 	/* Memory registrations */
-	/* Maximum number of pages in a single RDMA write/read on this connection */
-	int max_frmr_depth;
 	enum ib_mr_type mr_type;
 	struct list_head mr_list;
 	spinlock_t mr_list_lock;
-- 
2.43.0

