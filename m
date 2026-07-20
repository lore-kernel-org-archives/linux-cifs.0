Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67762FFFB5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577008; cv=none; b=bWYhuvCW0Xe3Zliiy2itr5Kkn/wZYYERG5MlNqXi00NlE+ei6OsovOWne+CABBBdyFuz2y3YZ7Kb79LachHfHZaxGIaB9MrMI9XlOtfWDe8QpaqLCyq9bR8j40Kd+dGU90nwCvcvqB8b+ZF1X8buzU6WvyXQHarpppatFvBDuxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577008; c=relaxed/simple;
	bh=hBX/BRi7AcX2wxeQULhP2yi9ZKi6TparlVQhb/HOKuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTXzLbnt6+RhrjnKCqgGk/yYTgeRAGyn+KQzYCf+SxcmBoRzZeKn4gy9D7NeDWuez0St2HCfyTle0vJQr+thdERu+K8X7gW6srtLbbVkmJomsqgKr2kzoRvHx9/2JHuQ6EU4Y5iNrt2lM4Fs9QmQ+duxRtfCD8RYFUsJlFJQf0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wx3tkDIc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dgAxnYnS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wx3tkDIc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dgAxnYnS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wx3tkDIc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dgAxnYnS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wx3tkDIc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dgAxnYnS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D9537A138;
	Mon, 20 Jul 2026 19:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784577001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mmbabS2AiXUzXkgA4BA1ws14/bxTcv4LLeS2wUZfJ3g=;
	b=wx3tkDIcpLhyQym1EkUpxCfEMI1reQZv/sftZ+7fCw04Pe3017/o8iOhzZMoAItQcYdsOa
	dSndm/n4l24ahujzKZzMcDoqjIcAkkeELHSH9q2pt0RHDd7WPqrfd6Ee5VBtZIJkez9kII
	uCXj2ilSd85JuylGXeseqf6OQyXGa4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784577001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mmbabS2AiXUzXkgA4BA1ws14/bxTcv4LLeS2wUZfJ3g=;
	b=dgAxnYnSr6rZZwM50C84gqyPp74jGD8XhGBucEAz/URSV03/YY7c3aq15xTeajC4cxEA1g
	NDaSuAhQ9rzWDCCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784577001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mmbabS2AiXUzXkgA4BA1ws14/bxTcv4LLeS2wUZfJ3g=;
	b=wx3tkDIcpLhyQym1EkUpxCfEMI1reQZv/sftZ+7fCw04Pe3017/o8iOhzZMoAItQcYdsOa
	dSndm/n4l24ahujzKZzMcDoqjIcAkkeELHSH9q2pt0RHDd7WPqrfd6Ee5VBtZIJkez9kII
	uCXj2ilSd85JuylGXeseqf6OQyXGa4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784577001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mmbabS2AiXUzXkgA4BA1ws14/bxTcv4LLeS2wUZfJ3g=;
	b=dgAxnYnSr6rZZwM50C84gqyPp74jGD8XhGBucEAz/URSV03/YY7c3aq15xTeajC4cxEA1g
	NDaSuAhQ9rzWDCCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A096E779AA;
	Mon, 20 Jul 2026 19:50:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HzBvGuh7Xmq4CAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:00 +0000
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
Subject: [PATCH v2 08/14] smb: server: compress: use generic smb_compression_compress()
Date: Mon, 20 Jul 2026 16:49:19 -0300
Message-ID: <20260720194925.2108840-8-ematsumiya@suse.de>
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

Rework ksmbd_compress_response() to use smb_compression_compress()
that's suitable for both chained and unchained cases now.

Changes:
- remove no longer used local variables

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/server/compress.c | 55 +++++++++-------------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index a64fbc278ad3..999b7b11de85 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -94,11 +94,10 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
  */
 int ksmbd_compress_response(struct ksmbd_work *work)
 {
-	struct smb2_compression_hdr *chdr;
 	struct smb2_hdr *req_hdr;
-	u32 src_len, dst_len, compressed_pdu_len, max_dst_len;
 	u8 *src = NULL, *out = NULL, *p;
 	bool chained, pattern;
+	u32 src_len, dst_len;
 	int i, rc;
 
 	if (!work->compress_response || work->encrypted ||
@@ -140,54 +139,24 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		goto out;
 	}
 
-	max_dst_len = smb_compress_alloc_size(src_len, chained, pattern);
-	out = kvzalloc(sizeof(__be32) + max_dst_len,
+	dst_len = smb_compress_alloc_size(src_len, chained, pattern);
+	out = kvzalloc(sizeof(__be32) + dst_len,
 		       KSMBD_DEFAULT_GFP);
 	if (!out) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	if (chained) {
-		dst_len = max_dst_len;
-		rc = smb_compression_compress(SMB3_COMPRESS_LZ77, chained, pattern,
-					      src, src_len,
-					      out + sizeof(__be32),
-					      &dst_len);
-		if (rc == -EMSGSIZE || dst_len >= src_len) {
-			rc = 0;
-			goto out;
-		}
-		if (rc)
-			goto out;
-		compressed_pdu_len = dst_len;
-	} else {
-		/*
-		 * Peers which did not negotiate chained compression still use
-		 * the original 16-byte unchained transform format.
-		 */
-		dst_len = smb_lz77_compressed_alloc_size(src_len);
-		rc = smb_lz77_compress(src, src_len,
-				       out + sizeof(__be32) + sizeof(*chdr),
-				       &dst_len);
-		if (rc == -EMSGSIZE ||
-		    dst_len + sizeof(*chdr) >= src_len) {
-			rc = 0;
-			goto out;
-		}
-		if (rc)
-			goto out;
-
-		compressed_pdu_len = sizeof(*chdr) + dst_len;
-		chdr = (struct smb2_compression_hdr *)(out + sizeof(__be32));
-		chdr->ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
-		chdr->OriginalCompressedSegmentSize = cpu_to_le32(src_len);
-		chdr->CompressionAlgorithm = SMB3_COMPRESS_LZ77;
-		chdr->Flags = cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE);
-		chdr->Offset = 0;
+	rc = smb_compression_compress(SMB3_COMPRESS_LZ77, chained, pattern,
+				      src, src_len,
+				      out + sizeof(__be32),
+				      &dst_len);
+	if (rc == -EMSGSIZE || dst_len >= src_len) {
+		rc = 0;
+		goto out;
 	}
 
-	*(__be32 *)out = cpu_to_be32(compressed_pdu_len);
+	*(__be32 *)out = cpu_to_be32(dst_len);
 
 	/*
 	 * Keep the transform in work->compress_buf until send completion.
@@ -198,7 +167,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 	work->iov[0].iov_base = out;
 	work->iov[0].iov_len = sizeof(__be32);
 	work->iov[1].iov_base = out + sizeof(__be32);
-	work->iov[1].iov_len = compressed_pdu_len;
+	work->iov[1].iov_len = dst_len;
 	work->iov_cnt = 2;
 	work->iov_idx = 1;
 	out = NULL;
-- 
2.54.0

