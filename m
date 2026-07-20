Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4286449B3A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577002; cv=none; b=oLinte6UrdCJY5GUNu+PIkSTwnzr3cKAEluQxHK9vj3M155YxZBrq8U1ST4Lhnce4SUlc7jt5DZqxIw/82HplpH8sIiENgL2OVbRIdGqvRfw1QeAXBlsX+Mc4MbfAOLOzMt94mHQdp/wTr+2N6Ju4WqWpFrtsXbVTSHuQZf/gxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577002; c=relaxed/simple;
	bh=fTgEtWIB+LYN7H84lw7MewQF9bd9o5AdUxH1FQnKGW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5MEghYi+dPb1nZGUDj9bAZ5HSizN6AQvLvRGnNH50QQ/hysXde4txmx55LFYC7XzdQSebmWjhU/o/jNTDRw6YsPN8MpzOQ/wNyJj1ZJ/C1B2WrYolU5aHg5P1Q54i9+OY0lJr2zAEiOm16QeLpOd0Vp4r+FyPsAXXp66c4B9Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BM7OYRFN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ockn1Tqy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BM7OYRFN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ockn1Tqy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BM7OYRFN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ockn1Tqy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BM7OYRFN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ockn1Tqy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D03C3E80;
	Mon, 20 Jul 2026 19:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amv4oNUcb9cXuk2ctw+hJH2PQz+iC8lMbqtysUamKbY=;
	b=BM7OYRFNG+JK3cdnI1M46tmqZfQvoBbuHgUfIkRVJ27lkrJ7p1Z5lT8zbY1S0e8eD1z5w2
	UdH4aEPdbud1R1bIYpXQ8SGZ2CsewFgFsnKF50FtWhUnVwpr902OshUInQpTeCfcNWcACU
	I+/lpjaNU0N3vn38CTI4SauDJN2gYms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amv4oNUcb9cXuk2ctw+hJH2PQz+iC8lMbqtysUamKbY=;
	b=ockn1TqyNItoLvCOvscpZfB6a180qY2AIKGHMqnz0YnPcPPot+9qW6jyOtnJYk7jWf8sX0
	3uOjvM5bENkBA2Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amv4oNUcb9cXuk2ctw+hJH2PQz+iC8lMbqtysUamKbY=;
	b=BM7OYRFNG+JK3cdnI1M46tmqZfQvoBbuHgUfIkRVJ27lkrJ7p1Z5lT8zbY1S0e8eD1z5w2
	UdH4aEPdbud1R1bIYpXQ8SGZ2CsewFgFsnKF50FtWhUnVwpr902OshUInQpTeCfcNWcACU
	I+/lpjaNU0N3vn38CTI4SauDJN2gYms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amv4oNUcb9cXuk2ctw+hJH2PQz+iC8lMbqtysUamKbY=;
	b=ockn1TqyNItoLvCOvscpZfB6a180qY2AIKGHMqnz0YnPcPPot+9qW6jyOtnJYk7jWf8sX0
	3uOjvM5bENkBA2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AD9C779AA;
	Mon, 20 Jul 2026 19:49:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 59scFOV7Xmq1CAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:49:57 +0000
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
Subject: [PATCH v2 07/14] smb: client: compress: enable Pattern_V1 + chained compression
Date: Mon, 20 Jul 2026 16:49:18 -0300
Message-ID: <20260720194925.2108840-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720194925.2108840-1-ematsumiya@suse.de>
References: <20260720194925.2108840-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Negotiate Pattern_V1 and LZ77 compression algorithms by default (if
'compress' mount option is set).

Changes:
- add smb_compress_alloc_size() helper to compute compressed buffer
  size, to account for Pattern_V1 payloads as well
- adjust server/compress.c to use smb_compress_alloc_size()
- adjust client/compress.c to use smb_compression_compress(), and fixup
  the compression header (as client sends the SMB2 header uncompressed)

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifs_debug.c        | 18 ++++++---
 fs/smb/client/compress.c          | 61 +++++++++++++++++++++++--------
 fs/smb/client/smb2pdu.c           | 17 +++++++++
 fs/smb/common/compress/compress.h | 38 +++++++++++++++++++
 fs/smb/server/compress.c          | 19 ++++++----
 5 files changed, 124 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..165fc4b25f8f 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -552,14 +552,20 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		}
 
 		seq_puts(m, "\nCompression: ");
-		if (!IS_ENABLED(CONFIG_CIFS_COMPRESSION))
+		if (!IS_ENABLED(CONFIG_CIFS_COMPRESSION)) {
 			seq_puts(m, "no built-in support");
-		else if (!server->compression.requested)
+		} else if (!server->compression.requested) {
 			seq_puts(m, "disabled on mount");
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
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 925b01a4d0a5..37e92e2bc816 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -352,8 +352,9 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn)
 {
 	struct iov_iter iter;
-	u32 slen, dlen;
+	bool chained, use_pattern;
 	void *src, *dst = NULL;
+	u32 slen, dlen;
 	int ret;
 
 	if (!server || !rq || !rq->rq_iov || !rq->rq_iov->iov_base)
@@ -394,30 +395,60 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		goto err_free;
 	}
 
-	dlen = smb_lz77_compressed_alloc_size(slen);
+	chained = server->compression.chained;
+	use_pattern = server->compression.pattern;
+	dlen = smb_compress_alloc_size(slen, chained, use_pattern);
 	dst = kvzalloc(dlen, GFP_KERNEL);
 	if (!dst) {
 		ret = -ENOMEM;
 		goto err_free;
 	}
 
-	ret = smb_lz77_compress(src, slen, dst, &dlen);
+	ret = smb_compression_compress(SMB3_COMPRESS_LZ77, chained, use_pattern,
+				       src, slen, dst, &dlen);
 	if (!ret) {
-		struct smb2_compression_hdr hdr = { 0 };
+		struct smb2_compression_hdr *hdrp = dst, hdr = {};
 		struct smb_rqst comp_rq = { .rq_nvec = 3, };
 		struct kvec iov[3];
+		u32 payload_offset = sizeof(hdr);
+		u32 shdr_len = rq->rq_iov[0].iov_len;
+
+		/*
+		 * smb_compression_compress() already setup a compression header in @dst, but we're
+		 * sending the SMB2 header uncompressed, so we need to adjust our iovs layout to
+		 * accommodate that when @chained (iov[2] always points to the start of compressed
+		 * data, regardless of @chained).
+		 *
+		 * Sneak in a "NONE" payload header (that corresponds to our uncompressed SMB2
+		 * header) as the first one, and point iov[2] to the original first payload header
+		 * created (which now becomes the second payload header).
+		 *
+		 * If unchained, we can just use the created header.
+		 */
+		hdr = *hdrp;
+		if (chained) {
+			struct smb2_compression_payload_hdr *phdr;
+
+			payload_offset = SMB2_COMPRESSION_CHAINED_HDR_LEN;
+			le32_add_cpu(&hdr.OriginalCompressedSegmentSize, shdr_len);
+			hdr.CompressionAlgorithm = SMB3_COMPRESS_NONE;
+			hdrp = &hdr;
+
+			/*
+			 * Only the first payload header must have the CHAINED flag set, so strip
+			 * the original one.
+			 */
+			phdr = dst + payload_offset;
+			phdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
+		}
+
+		hdrp->Offset = cpu_to_le32(shdr_len);
 
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
+		iov[0].iov_base = hdrp;
+		iov[0].iov_len = sizeof(*hdrp);
+		iov[1] = rq->rq_iov[0]; /* this is the SMB2 header */
+		iov[2].iov_base = dst + payload_offset;
+		iov[2].iov_len = dlen - payload_offset;
 
 		comp_rq.rq_iov = iov;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e1ed23b3dd2c..cc20d9b6638f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -892,6 +892,12 @@ static void decode_compress_ctx(struct TCP_Server_Info *server,
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
 	chained = (ctxt->Flags == SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED);
 	if (!chained)
@@ -1382,6 +1388,12 @@ SMB2_negotiate(const unsigned int xid,
 			rc = smb_EIO1(smb_eio_trace_neg_decode_token, rc);
 	}
 
+	/*
+	 * Disable compression until we decode negcontext -- keep other settings as they are, in
+	 * case there are channels doing compression concurrently.
+	 */
+	server->compression.enabled = false;
+
 	if (server->dialect == SMB311_PROT_ID) {
 		if (rsp->NegotiateContextCount)
 			rc = smb311_decode_neg_context(rsp, server,
@@ -1390,6 +1402,11 @@ SMB2_negotiate(const unsigned int xid,
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
 	}
 
+	if (server->compression.requested && !server->compression.enabled) {
+		cifs_server_dbg(VFS, "Server doesn't support SMB2 compression\n");
+		disable_compression(server);
+	}
+
 	if (server->cipher_type && !rc)
 		rc = smb3_crypto_aead_allocate(server);
 neg_exit:
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index ade37d552067..601ccb789fa4 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -145,6 +145,44 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 	return alg == SMB3_COMPRESS_LZ77 || alg == SMB3_COMPRESS_PATTERN;
 }
 
+/**
+ * smb_compress_alloc_size() - Compute total allocation size required for compressed (dst) buffer.
+ * @size:		uncompressed size
+ * @chained:		if chained compression is enabled
+ * @use_pattern:	if Pattern_V1 is enabled
+ *
+ * For any case:
+ * - SMB2 compression hdr
+ * - LZ* payload
+ *
+ * If @chained, account for:
+ * - 1x payload hdr
+ *
+ * If @use_pattern, also account for:
+ * - 2x payload hdr for Pattern_V1
+ * - 2x Pattern_V1 payloads
+ *
+ * (possible uncompressed leftovers are included in LZ alloc size)
+ *
+ * This helper assumes that the invalid combination (!@chained && @use_pattern) was previously
+ * checked by the caller.
+ */
+static __always_inline u32 smb_compress_alloc_size(const u32 size, const bool chained,
+						   const bool use_pattern)
+{
+	u32 alloc_size;
+
+	alloc_size = sizeof(struct smb2_compression_hdr) + smb_lz77_compressed_alloc_size(size);
+	if (chained) {
+		alloc_size += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
+		if (use_pattern)
+			alloc_size += (SMB2_COMPRESSION_PAYLOAD_BASE_LEN * 2) +
+				(sizeof(struct smb2_compression_pattern_v1) * 2);
+	}
+
+	return alloc_size;
+}
+
 int smb_compression_decompress(__le16 alg, bool allow_chained,
 			       const void *src, u32 slen, void *dst, u32 dlen);
 int smb_compression_compress(__le16 alg, bool chained, bool allow_pattern,
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index da7dea58c5a7..a64fbc278ad3 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -98,6 +98,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr;
 	u32 src_len, dst_len, compressed_pdu_len, max_dst_len;
 	u8 *src = NULL, *out = NULL, *p;
+	bool chained, pattern;
 	int i, rc;
 
 	if (!work->compress_response || work->encrypted ||
@@ -132,10 +133,14 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		goto out;
 	}
 
-	max_dst_len = smb_lz77_compressed_alloc_size(src_len) +
-		sizeof(struct smb2_compression_hdr) +
-		3 * sizeof(struct smb2_compression_payload_hdr) +
-		2 * sizeof(struct smb2_compression_pattern_v1);
+	chained = work->conn->compress_chained;
+	pattern = work->conn->compress_pattern;
+	if (unlikely(!chained && pattern)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	max_dst_len = smb_compress_alloc_size(src_len, chained, pattern);
 	out = kvzalloc(sizeof(__be32) + max_dst_len,
 		       KSMBD_DEFAULT_GFP);
 	if (!out) {
@@ -143,11 +148,9 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		goto out;
 	}
 
-	if (work->conn->compress_chained) {
+	if (chained) {
 		dst_len = max_dst_len;
-		rc = smb_compression_compress(SMB3_COMPRESS_LZ77,
-					      work->conn->compress_chained,
-					      work->conn->compress_pattern,
+		rc = smb_compression_compress(SMB3_COMPRESS_LZ77, chained, pattern,
 					      src, src_len,
 					      out + sizeof(__be32),
 					      &dst_len);
-- 
2.54.0

