Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2634A794
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577023; cv=none; b=p5h4C1jJl4+YOz+J+iSguweMfgmHuDCzRaavcAQ2dIPclZMMPXcHZXLDExpJscwBdRH0KUG3jUy8ou6LE7vx0mJnrnkA477pyov+VpNqRfmz/WqZcHa/8Xbt9FaJKDrRWeloPxqdJke2lZMx652u2hpe0c5bUSoAHGpQfFjMOTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577023; c=relaxed/simple;
	bh=aZG2nJR7AcKmJn+DYedECoyf9udkzrkZyhgBntQruW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXpS61/pfwIJoZl7ZSj50SL2X62I5/ZoODBhWVPBRKVVE3Nb+neXmZmJtBmrinkTuGx+LBsgKnUP+U425sc+oTWrX9Fz8eKxOlG8iBfLxDV9WBKwBWBKw1a5/2ZcmDMQLmD6ftSsbEKMMZ51ZTGGH6ZKlV7W8yvU42DgdIm17NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28A663E96;
	Mon, 20 Jul 2026 19:50:17 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC236779AA;
	Mon, 20 Jul 2026 19:50:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aS/gHPh7XmrUCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:16 +0000
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
Subject: [PATCH v2 13/14] smb: server: use smb_decompress_alloc_size() in ksmbd_decompress_request()
Date: Mon, 20 Jul 2026 16:49:24 -0300
Message-ID: <20260720194925.2108840-13-ematsumiya@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 28A663E96
X-Rspamd-Action: no action

Use common helper to validate compress header and get decompressed size.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/server/compress.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 46974499dddf..485caae4c038 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -24,11 +24,9 @@
  */
 int ksmbd_decompress_request(struct ksmbd_conn *conn)
 {
-	struct smb2_compression_hdr *hdr;
 	unsigned int pdu_size = get_rfc1002_len(conn->request_buf);
-	u32 orig_size, offset, out_size;
-	u32 max_allowed_pdu_size;
 	char *buf, *out;
+	u32 out_size;
 	int rc;
 
 	if (pdu_size < sizeof(struct smb2_compression_hdr))
@@ -38,30 +36,17 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	    !smb_compress_alg_valid(conn->compress_algorithm, false))
 		return -EINVAL;
 
-	hdr = smb_get_msg(conn->request_buf);
-	if (hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
-		return -EINVAL;
-
-	orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
-	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) {
-		out_size = orig_size;
-	} else {
-		offset = le32_to_cpu(hdr->Offset);
-		if (offset > pdu_size - sizeof(*hdr) ||
-		    check_add_overflow(orig_size, offset, &out_size))
-			return -EINVAL;
-	}
-
-	max_allowed_pdu_size = SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
-	if (out_size > max_allowed_pdu_size ||
-	    out_size > MAX_STREAM_PROT_LEN)
+	buf = smb_get_msg(conn->request_buf);
+	out_size = smb_decompress_alloc_size(buf, pdu_size, 0,
+					     SMB3_MAX_MSGSIZE + conn->vals->max_write_size,
+					     conn->compress_chained);
+	if (out_size == 0 || out_size > MAX_STREAM_PROT_LEN)
 		return -EINVAL;
 
 	out = kvmalloc(out_size + 4 + 1, KSMBD_DEFAULT_GFP);
 	if (!out)
 		return -ENOMEM;
 
-	buf = (char *)hdr;
 	*(__be32 *)out = cpu_to_be32(out_size);
 	rc = smb_compression_decompress(conn->compress_algorithm,
 					conn->compress_chained,
-- 
2.54.0

