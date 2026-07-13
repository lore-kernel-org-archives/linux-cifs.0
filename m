Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEF92ED870
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979240; cv=none; b=eOef6bOeWBg3e6VZ83Vlvf/SWT31QIVt5RGNaja01NBZYF69gvyTYkjBXLx0lY+w/Qm2Q/Y07Jz8zCNuG/YpH6//WwIekMvky/StjjTfRWkNIrMJePlwduWX9AngDi+yvOXV3QmZagaXkjsDYp2TVGmUoceZ9srDd9Irs7RBG4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979240; c=relaxed/simple;
	bh=y/hbcvYiz8GcP3HGGj/WbXvSLsSseXAw/grFl0HLqKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2ycjoVEntaaBDuSARxQO2XdhRVn+/hPd2aKD46e8JFbK7R2g8mAz723S6xmT8kVgryinGcb+WFSTWNKXbqybOBAaaUMGAP3Fu4O97H5lxOkDYnVcNSbQ44qHUXVmjcS3w85FK45TYlDgKDrOzqj4WUiYkeABm5mVA65bTHpEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tldAj8ho; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2KTOBWU6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tldAj8ho; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2KTOBWU6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tldAj8ho";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2KTOBWU6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tldAj8ho";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2KTOBWU6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 181363E13;
	Mon, 13 Jul 2026 21:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyVAWfpi+6sm4TfG9nB9hC63Rz9TtSjW2yaLprNH5Ng=;
	b=tldAj8hoxIt9b112Fp+08VQ8qVEiLSAxty+78vDlecKp2x1WS33ACrb725s0LqMVxOVBnp
	pwMMza5vx/Fgxq29fkrer2DXl7CNNaqIWQMW0xtpDCn4MjEdgQlLP0Qn70PXeNKOBF/vyu
	SfeagTHLMszIKGmO5n5Z2c2x3LS2h+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyVAWfpi+6sm4TfG9nB9hC63Rz9TtSjW2yaLprNH5Ng=;
	b=2KTOBWU6PbZw6Udu5KJDrZzDZW0SswEv/e7Fx4iLGYpRDsdtyS9ZGi2Gserw91oso4BrYz
	4KEAxgWVUP9EcQBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyVAWfpi+6sm4TfG9nB9hC63Rz9TtSjW2yaLprNH5Ng=;
	b=tldAj8hoxIt9b112Fp+08VQ8qVEiLSAxty+78vDlecKp2x1WS33ACrb725s0LqMVxOVBnp
	pwMMza5vx/Fgxq29fkrer2DXl7CNNaqIWQMW0xtpDCn4MjEdgQlLP0Qn70PXeNKOBF/vyu
	SfeagTHLMszIKGmO5n5Z2c2x3LS2h+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyVAWfpi+6sm4TfG9nB9hC63Rz9TtSjW2yaLprNH5Ng=;
	b=2KTOBWU6PbZw6Udu5KJDrZzDZW0SswEv/e7Fx4iLGYpRDsdtyS9ZGi2Gserw91oso4BrYz
	4KEAxgWVUP9EcQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97EED779AE;
	Mon, 13 Jul 2026 21:47:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X9/YF+RcVWqdUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:16 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 05/10] smb: client: compress: enable Pattern_V1 + chained compression
Date: Mon, 13 Jul 2026 18:46:40 -0300
Message-ID: <20260713214645.550580-5-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260713214645.550580-1-ematsumiya@suse.de>
References: <20260713214645.550580-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

Negotiate Pattern_V1 and LZ77 compression algorithms by default (if
'compress' mount option is set).

Changes:
- drop TCP_Server_Info::compression::requested, rely on ::enabled only
- add smb_compress_alloc_size() helper to compute compressed buffer
  size, to account for Pattern_V1 payloads as well
- call smb_compression_compress() with SMB2 header as @uncomp

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifs_debug.c        | 18 ++++++++++------
 fs/smb/client/cifsglob.h          |  1 -
 fs/smb/client/compress.c          | 36 ++++++++++++++-----------------
 fs/smb/client/connect.c           |  2 +-
 fs/smb/client/sess.c              |  2 +-
 fs/smb/client/smb2pdu.c           | 25 ++++++++++++++-------
 fs/smb/common/compress/compress.h | 28 ++++++++++++++++++++++++
 fs/smb/server/compress.c          |  5 +----
 8 files changed, 75 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..36b4b7345c04 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -552,14 +552,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		}
 
 		seq_puts(m, "\nCompression: ");
-		if (!IS_ENABLED(CONFIG_CIFS_COMPRESSION))
+		if (!IS_ENABLED(CONFIG_CIFS_COMPRESSION)) {
 			seq_puts(m, "no built-in support");
-		else if (!server->compression.requested)
-			seq_puts(m, "disabled on mount");
-		else if (server->compression.enabled)
-			seq_printf(m, "enabled (%s)", compression_alg_str(server->compression.alg));
-		else
-			seq_puts(m, "disabled (not supported by this server)");
+		} else if (!server->compression.enabled) {
+			seq_puts(m, "disabled"); /* XXX: reason? */
+		} else {
+			seq_printf(m, "enabled, chained: %s, algs: ",
+				   str_yes_no(server->compression.chained));
+
+			seq_printf(m, "%s ", compression_alg_str(server->compression.alg));
+			if (server->compression.pattern)
+				seq_printf(m, "%s ", compression_alg_str(SMB3_COMPRESS_PATTERN));
+		}
 
 		/* Show negotiated encryption cipher, even if not required */
 		seq_puts(m, "\nEncryption: ");
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 99f9e6dca62b..a08aa7fc84f4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -787,7 +787,6 @@ struct TCP_Server_Info {
 	unsigned int	rdma_readwrite_threshold;
 	unsigned int	retrans;
 	struct {
-		bool requested; /* "compress" mount option set*/
 		bool enabled; /* actually negotiated with server */
 		bool chained; /* chained transforms were negotiated */
 		bool pattern; /* Pattern_V1 chained payloads were negotiated */
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 7c08e2b843c2..72ac727250f6 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -338,8 +338,9 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn)
 {
 	struct iov_iter iter;
-	u32 slen, dlen;
+	u32 slen, dlen, shdr_len;
 	void *src, *dst = NULL;
+	bool use_pattern;
 	int ret;
 
 	if (!server || !rq || !rq->rq_iov || !rq->rq_iov->iov_base)
@@ -380,32 +381,27 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
-	dlen = smb_lz77_compressed_alloc_size(slen);
+	use_pattern = server->compression.pattern;
+	shdr_len = rq->rq_iov[0].iov_len;
+	dlen = smb_compress_alloc_size(slen, use_pattern) + shdr_len;
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
 
-	ret = smb_lz77_compress(src, slen, dst, &dlen);
+	ret = smb_compression_compress(SMB3_COMPRESS_LZ77, server->compression.chained, use_pattern,
+				       src, slen, dst, &dlen, rq->rq_iov[0].iov_base, shdr_len);
 	if (!ret) {
-		struct smb2_compression_hdr hdr = { 0 };
-		struct smb_rqst comp_rq = { .rq_nvec = 3, };
-		struct kvec iov[3];
-
-		hdr.ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
-		hdr.OriginalCompressedSegmentSize = cpu_to_le32(slen);
-		hdr.CompressionAlgorithm = SMB3_COMPRESS_LZ77;
-		hdr.Flags = SMB2_COMPRESSION_FLAG_NONE;
-		hdr.Offset = cpu_to_le32(rq->rq_iov[0].iov_len);
-
-		iov[0].iov_base = &hdr;
-		iov[0].iov_len = sizeof(hdr);
-		iov[1] = rq->rq_iov[0];
-		iov[2].iov_base = dst;
-		iov[2].iov_len = dlen;
-
-		comp_rq.rq_iov = iov;
+		struct smb_rqst comp_rq = { .rq_nvec = 1, };
+		struct kvec iov = {
+			.iov_base = dst,
+			.iov_len = dlen,
+		};
+
+		iov.iov_base = dst;
+		iov.iov_len = dlen;
+		comp_rq.rq_iov = &iov;
 
 		ret = send_fn(server, 1, &comp_rq);
 	} else if (ret == -EMSGSIZE || dlen >= slen) {
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 324452bc0437..dd35abdac334 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1830,7 +1830,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->channel_sequence_num = 0; /* only tracked for primary channel */
 	tcp_ses->reconnect_instance = 1;
 	tcp_ses->lstrp = jiffies;
-	tcp_ses->compression.requested = ctx->compress;
+	tcp_ses->compression.enabled = ctx->compress;
 	spin_lock_init(&tcp_ses->req_lock);
 	spin_lock_init(&tcp_ses->srv_lock);
 	spin_lock_init(&tcp_ses->mid_queue_lock);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index de2012cc9cf3..83f4b5d107f6 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -552,7 +552,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->echo_interval = ses->server->echo_interval / HZ;
 	ctx->max_credits = ses->server->max_credits;
 	ctx->min_offload = ses->server->min_offload;
-	ctx->compress = ses->server->compression.requested;
+	ctx->compress = ses->server->compression.enabled;
 	ctx->dfs_conn = ses->server->dfs_conn;
 	ctx->ignore_signature = ses->server->ignore_signature;
 	ctx->leaf_fullpath = ses->server->leaf_fullpath;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d058584b8f05..41cdc9f5e692 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -785,7 +785,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	pneg_ctxt += sizeof(struct smb2_posix_neg_context);
 	neg_context_count++;
 
-	if (server->compression.requested) {
+	if (server->compression.enabled) {
 		build_compression_ctxt((struct smb2_compression_capabilities_context *)
 				pneg_ctxt);
 		ctxt_len = ALIGN(sizeof(struct smb2_compression_capabilities_context), 8);
@@ -835,11 +835,6 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 	unsigned int count, i;
 
-	server->compression.enabled = false;
-	server->compression.chained = false;
-	server->compression.pattern = false;
-	server->compression.alg = SMB3_COMPRESS_NONE;
-
 	/*
 	 * Caller checked that DataLength remains within SMB boundary. We still
 	 * need to confirm that one CompressionAlgorithms member is accounted
@@ -876,6 +871,12 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
 	/*
 	 * Pattern_V1 cannot appear in an unchained transform even if a broken
 	 * peer lists it in the algorithm array.
+	 *
+	 * OTOH, the chained flag might have been negotiated without either/both peers having not
+	 * advertised Pattern_V1 algorithm support.
+	 *
+	 * (which doesn't make much sense, but we'll still have to send compressed payloads with
+	 * the chained flag set in "chained && !pattern_v1" cases)
 	 */
 	server->compression.chained =
 		ctxt->Flags == SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
@@ -1336,11 +1337,19 @@ SMB2_negotiate(const unsigned int xid,
 	}
 
 	if (server->dialect == SMB311_PROT_ID) {
-		if (rsp->NegotiateContextCount)
+		bool compression_enabled = server->compression.enabled;
+
+		/* Reset compression settings in case of server not supporting it */
+		memset(&server->compression, 0, sizeof(server->compression));
+
+		if (rsp->NegotiateContextCount) {
 			rc = smb311_decode_neg_context(rsp, server,
 						       rsp_iov.iov_len);
-		else
+			if (!rc && compression_enabled && !server->compression.enabled)
+				cifs_server_dbg(VFS, "Server doesn't support compression, disabling\n");
+		} else {
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
+		}
 	}
 
 	if (server->cipher_type && !rc)
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 6760862de04c..e1fad498d567 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -145,6 +145,34 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 	return alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN;
 }
 
+/**
+ * smb_compress_alloc_size() - Compute total allocation size required for compressed (dst) buffer.
+ * @size:		uncompressed size
+ * @use_pattern:	if Pattern_V1 is enabled
+ *
+ * For any case:
+ * - SMB2 compression hdr
+ * - LZ* payload
+ *
+ * If @use_pattern, also account for:
+ * - 2x payload hdr for Pattern_V1
+ * - 2x Pattern_V1 payloads
+ * - 1x NONE payload hdr
+ *
+ * (possible uncompressed leftovers are included in LZ alloc size)
+ */
+static __always_inline u32 smb_compress_alloc_size(const u32 size, const bool use_pattern)
+{
+	u32 alloc_size;
+
+	alloc_size = sizeof(struct smb2_compression_hdr) + smb_lz77_compressed_alloc_size(size);
+	if (use_pattern)
+		alloc_size += (SMB2_COMPRESSION_PAYLOAD_BASE_LEN * 3) +
+			(sizeof(struct smb2_compression_pattern_v1) * 2);
+
+	return alloc_size;
+}
+
 int smb_compression_decompress(__le16 alg, bool allow_chained,
 			       const void *src, u32 slen, void *dst, u32 dlen);
 int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 32027a15f7ab..e5851d603469 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -132,10 +132,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		goto out;
 	}
 
-	max_dst_len = smb_lz77_compressed_alloc_size(src_len) +
-		sizeof(struct smb2_compression_hdr) +
-		3 * sizeof(struct smb2_compression_payload_hdr) +
-		2 * sizeof(struct smb2_compression_pattern_v1);
+	max_dst_len = smb_compress_alloc_size(src_len, work->conn->compress_pattern);
 	out = kvzalloc(sizeof(__be32) + max_dst_len,
 		       KSMBD_DEFAULT_GFP);
 	if (!out) {
-- 
2.54.0

