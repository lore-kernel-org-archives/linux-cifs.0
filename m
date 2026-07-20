Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48CB3B2FC0
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576988; cv=none; b=SsX/zZ121RJd/QImn5KIA+8S8SUl7CbBcIYR+IEJlZOEfjZCi0Fv7+M5RZxjJvUzwRjJhb71Xb+O5+YnAXS4lXxFXYbUa1qL5+y110e6KCeu9hxGXauFynNyL6sAkVrEZt2jzh4vaVL78JuV0tqVGUJ/xBg3iMjGTf6JIHRrYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576988; c=relaxed/simple;
	bh=fPW7Srzy2t5s8IEZaSLEJivGL7OxRRBEuxX2Z9dkqBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwL726hrVJ3h/culYFZpZu8v+ORMBCsiU6soye2foutKmE2mrvjIAXbEzB7H03N3ncio+4L5bSqOrxcjsjQuL+9juSn3dGd41Chz8nro8lEwPArbylsTKRn4o8zQae3q63EWCT+wslfciY49HpyljmpBW0/hO6dIp64R+bN4clg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WZqZp3Uj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lCmAByqm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WZqZp3Uj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lCmAByqm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WZqZp3Uj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lCmAByqm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WZqZp3Uj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lCmAByqm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 395F07A183;
	Mon, 20 Jul 2026 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGQMrjIEZEJCb0v5ZUVMATmK2XPb6gRfu51XitKLDSo=;
	b=WZqZp3UjKXc3nD2D2vHTSmw8NUEf7AW+L8YXElW1STc3ckN0k0e44/PQTZaMcGEYzizTfN
	ypEFN4HxKwB7odYR1saAR1b2qnhtM0t5RV7ayIh9oUtcfMeIrlWiaOzX9Cgk70MSN++3CI
	KhThCQ2UfGe9/iJHiCDYYSyGtr0PnS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGQMrjIEZEJCb0v5ZUVMATmK2XPb6gRfu51XitKLDSo=;
	b=lCmAByqmP1726/FARjwvutAH3oZ9GzlM39RZIvuxx6vyaSEIbJZxqRonKcVQTBRmwIiC7J
	vn40ii5G0UKgoeAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784576982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGQMrjIEZEJCb0v5ZUVMATmK2XPb6gRfu51XitKLDSo=;
	b=WZqZp3UjKXc3nD2D2vHTSmw8NUEf7AW+L8YXElW1STc3ckN0k0e44/PQTZaMcGEYzizTfN
	ypEFN4HxKwB7odYR1saAR1b2qnhtM0t5RV7ayIh9oUtcfMeIrlWiaOzX9Cgk70MSN++3CI
	KhThCQ2UfGe9/iJHiCDYYSyGtr0PnS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784576982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aGQMrjIEZEJCb0v5ZUVMATmK2XPb6gRfu51XitKLDSo=;
	b=lCmAByqmP1726/FARjwvutAH3oZ9GzlM39RZIvuxx6vyaSEIbJZxqRonKcVQTBRmwIiC7J
	vn40ii5G0UKgoeAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0EC4C779AA;
	Mon, 20 Jul 2026 19:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MjMnMdN7XmohCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:49:39 +0000
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
Subject: [PATCH v2 04/14] smb: client: sync compression settings between channels
Date: Mon, 20 Jul 2026 16:49:15 -0300
Message-ID: <20260720194925.2108840-4-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -6.80

If there are any errors or inconsistencies on negotiated compression
settings for a channel, disable compression globally (primary server).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/smb2pdu.c | 95 ++++++++++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d058584b8f05..e1ed23b3dd2c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -832,56 +832,103 @@ static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
 static void decode_compress_ctx(struct TCP_Server_Info *server,
 			 struct smb2_compression_capabilities_context *ctxt)
 {
+	struct TCP_Server_Info *pserver;
 	unsigned int len = le16_to_cpu(ctxt->DataLength);
 	unsigned int count, i;
+	bool pattern, chained;
+	__le16 alg;
 
-	server->compression.enabled = false;
-	server->compression.chained = false;
-	server->compression.pattern = false;
-	server->compression.alg = SMB3_COMPRESS_NONE;
+	/*
+	 * This is a bug and should never happen -- we're either on first Negotiate (mount) or
+	 * reconnecting (disable_compression() was called), where ->enabled is false in both cases.
+	 */
+	if (WARN_ON_ONCE(server->compression.enabled)) {
+		cifs_dbg(VFS, "compression enabled unexpectedly\n");
+		goto out;
+	}
 
 	/*
+	 * Do not overwrite any settings until we've fully validated them.
+	 *
 	 * Caller checked that DataLength remains within SMB boundary. We still
 	 * need to confirm that one CompressionAlgorithms member is accounted
 	 * for.
 	 */
-	if (len < 10) {
-		pr_warn_once("server sent bad compression cntxt\n");
-		return;
+	if (unlikely(len < 10)) {
+		cifs_dbg(VFS, "server sent bad compression context (len %u)\n", len);
+		goto out;
 	}
 
 	count = le16_to_cpu(ctxt->CompressionAlgorithmCount);
-	if (!count || count > ARRAY_SIZE(ctxt->CompressionAlgorithms) ||
-	    len < 8 + count * sizeof(__le16)) {
-		pr_warn_once("invalid SMB3 compress algorithm count\n");
-		return;
+	if (unlikely(!count || count > ARRAY_SIZE(ctxt->CompressionAlgorithms) ||
+	    len < 8 + count * sizeof(__le16))) {
+		cifs_dbg(VFS, "invalid SMB3 compress algorithm count (%u)\n", count);
+		goto out;
 	}
 
-	if (ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE &&
-	    ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED) {
-		pr_warn_once("invalid SMB3 compression flags\n");
-		return;
+	if (unlikely(ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE &&
+		     ctxt->Flags != SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED)) {
+		cifs_dbg(VFS, "invalid SMB3 compression flags 0x%x\n", ctxt->Flags);
+		goto out;
 	}
 
+	alg = SMB3_COMPRESS_NONE;
+	chained = false;
+	pattern = false;
+
 	for (i = 0; i < count; i++) {
 		/* Record the intersection supported by the shared SMB codec. */
 		if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_LZ77)
-			server->compression.alg = SMB3_COMPRESS_LZ77;
+			alg = SMB3_COMPRESS_LZ77;
 		else if (ctxt->CompressionAlgorithms[i] == SMB3_COMPRESS_PATTERN)
-			server->compression.pattern = true;
+			pattern = true;
+	}
+
+	if (unlikely(alg != SMB3_COMPRESS_LZ77)) {
+		cifs_dbg(VFS, "invalid LZ algorithm negotiated 0x%x\n", alg);
+		goto out;
 	}
-	if (server->compression.alg != SMB3_COMPRESS_LZ77)
-		return;
 
 	/*
 	 * Pattern_V1 cannot appear in an unchained transform even if a broken
 	 * peer lists it in the algorithm array.
 	 */
-	server->compression.chained =
-		ctxt->Flags == SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED;
-	if (!server->compression.chained)
-		server->compression.pattern = false;
-	server->compression.enabled = true;
+	chained = (ctxt->Flags == SMB2_COMPRESSION_CAPABILITIES_FLAG_CHAINED);
+	if (!chained)
+		pattern = false;
+
+	/*
+	 * Regardless of that, if @server is a channel, we must check if the negotiated parameters
+	 * match the primary server ones.  If there's a mismatch and compression is enabled in
+	 * primary server, disable it (to avoid operations with mixed settings).
+	 */
+	pserver = server;
+	if (SERVER_IS_CHAN(server)) {
+		pserver = server->primary_server;
+		if (unlikely(chained != pserver->compression.chained ||
+			     pattern != pserver->compression.pattern ||
+			     alg != pserver->compression.alg)) {
+			cifs_dbg(VFS, "channel compression settings mismatch\n");
+			goto out;
+		}
+	}
+
+	/*
+	 * We may only enable compression for @server if we entered this function with @pserver
+	 * ->alg == NONE and ->enabled == false, otherwise it means disable_compression() was
+	 * called.
+	 */
+	if (!pserver->compression.enabled && pserver->compression.alg == SMB3_COMPRESS_NONE)
+		server->compression.enabled = true;
+
+	server->compression.chained = chained;
+	server->compression.pattern = pattern;
+	server->compression.alg = alg;
+
+	/* Compression was just enabled, or previously disabled on primary server, just leave */
+	return;
+out:
+	disable_compression(server);
 }
 
 static int decode_encrypt_ctx(struct TCP_Server_Info *server,
-- 
2.54.0

