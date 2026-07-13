Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D342356771
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979243; cv=none; b=AYquZMcepKqFQMp9TQq/Vkpr+LjiNO8mSP+h8WNav1YT7zMdyCMVSfn7UlLsAK9uAeAaccGLTKSbBWXKNxlcb4XAybZhCQ6RAWHPFY+mVxs5C5cH+SUME9qalxIb1BTfZBc0vv3gl28OB9xNIGfRZcxl2uDwaCACuTIzSawcbyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979243; c=relaxed/simple;
	bh=Z05y0Rb7tRXIerCqR4XEMxnuH5aYkbIoT2Y3MAGgzJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izlZzrxd8TsHICi75fdNsimXHKQ7hS6qWw+yyM/BON0ugnzFNpyjGv5mjNIK3HiSCTC17M4CR3yYbaAug5Sp5sYUrMLNdBxxdVYMPYaPVaR8xg7JSKskRKbK4g6YTVL/oYxEIWKKi2tzOJdY3qoNTuvA+DaMf2ePuTsd8rsweFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ON+Viwak; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c7rXhpxG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ON+Viwak; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c7rXhpxG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ON+Viwak";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c7rXhpxG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ON+Viwak";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c7rXhpxG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3975A77AD2;
	Mon, 13 Jul 2026 21:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=noc7WfGU1zZhaNhg2i9cCL9Ww2eSIEpExpggOWJPkcc=;
	b=ON+Viwakn7HsYH31zYgrbXFEXAQ5eGcjXQsZVRdojnF0A1ijToNGrB9qSPl1QzHsw3nRIS
	LNTnhrf0y+sjmNn01N7mC51p0GUp92gjJEKSsMfxhi04lnShfXiYpEuLqG1I3oqgWKwo/a
	IHx9fcvL5rb/m0Z2aVzrFRI4Yd05HVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=noc7WfGU1zZhaNhg2i9cCL9Ww2eSIEpExpggOWJPkcc=;
	b=c7rXhpxGAGQYB/sIhZY7gb3lu7+PrIws0+O2bPuzmZVz5mtOgzYB/7St4xr8LTY3ZmV5Re
	GzuUXzVNVx9BkfAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=noc7WfGU1zZhaNhg2i9cCL9Ww2eSIEpExpggOWJPkcc=;
	b=ON+Viwakn7HsYH31zYgrbXFEXAQ5eGcjXQsZVRdojnF0A1ijToNGrB9qSPl1QzHsw3nRIS
	LNTnhrf0y+sjmNn01N7mC51p0GUp92gjJEKSsMfxhi04lnShfXiYpEuLqG1I3oqgWKwo/a
	IHx9fcvL5rb/m0Z2aVzrFRI4Yd05HVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979240;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=noc7WfGU1zZhaNhg2i9cCL9Ww2eSIEpExpggOWJPkcc=;
	b=c7rXhpxGAGQYB/sIhZY7gb3lu7+PrIws0+O2bPuzmZVz5mtOgzYB/7St4xr8LTY3ZmV5Re
	GzuUXzVNVx9BkfAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8D95779AE;
	Mon, 13 Jul 2026 21:47:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DrXEH+dcVWqhUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:19 +0000
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
Subject: [PATCH 06/10] smb: common: compress: allow smb_lz77_compress() to overcompress
Date: Mon, 13 Jul 2026 18:46:41 -0300
Message-ID: <20260713214645.550580-6-ematsumiya@suse.de>
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
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLkmoi5kqpkgjx3hbiagnu7sfh)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Change smb_lz77_compress() to return 0 on successful compression,
leaving it up to callers to decide if @dlen >= @slen is an error
(currently returns -EMSGSIZE on such cases).

This allows better compression in certain cases where Pattern_V1 got a
good compression already, but LZ77 chunk was overcompressed (which
usually yields good compressed data as a whole)

Other changes:
- adjust client and server callers to correctly interpret the
  new return value

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c      |  4 ++--
 fs/smb/common/compress/lz77.c |  7 ++-----
 fs/smb/server/compress.c      | 15 ++++-----------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 72ac727250f6..d94bacf3edbd 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -392,7 +392,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 
 	ret = smb_compression_compress(SMB3_COMPRESS_LZ77, server->compression.chained, use_pattern,
 				       src, slen, dst, &dlen, rq->rq_iov[0].iov_base, shdr_len);
-	if (!ret) {
+	if (!ret && dlen < slen) {
 		struct smb_rqst comp_rq = { .rq_nvec = 1, };
 		struct kvec iov = {
 			.iov_base = dst,
@@ -404,7 +404,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		comp_rq.rq_iov = &iov;
 
 		ret = send_fn(server, 1, &comp_rq);
-	} else if (ret == -EMSGSIZE || dlen >= slen) {
+	} else if (!ret) {
 		ret = send_fn(server, 1, rq);
 	}
 err_free:
diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
index e32e2f3040d8..f88f49e01629 100644
--- a/fs/smb/common/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -248,19 +248,16 @@ noinline int smb_lz77_compress(const void *src, const u32 slen, void *dst, u32 *
 	} while (srcp < end);
 out:
 	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
-
 	flag_count = LZ77_FLAG_MAX - flag_count;
 	flag <<= flag_count;
 	flag |= (1UL << flag_count) - 1;
 	mem_write32(flag_pos, flag);
 
+	/* Compression is successful from our POV -- let caller decide if @dlen suits them. */
 	*dlen = dstp - dst;
 	kvfree(htable);
 
-	if (*dlen < slen)
-		return 0;
-
-	return -EMSGSIZE;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(smb_lz77_compress);
 
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index e5851d603469..648660f8bfab 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -148,12 +148,10 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 					      src, src_len,
 					      out + sizeof(__be32), &dst_len,
 					      NULL, 0);
-		if (rc == -EMSGSIZE || dst_len >= src_len) {
-			rc = 0;
-			goto out;
-		}
-		if (rc)
+		/* if dst_len >= src_len, rc is 0 */
+		if (rc || dst_len >= src_len)
 			goto out;
+
 		compressed_pdu_len = dst_len;
 	} else {
 		/*
@@ -164,12 +162,7 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 		rc = smb_lz77_compress(src, src_len,
 				       out + sizeof(__be32) + sizeof(*chdr),
 				       &dst_len);
-		if (rc == -EMSGSIZE ||
-		    dst_len + sizeof(*chdr) >= src_len) {
-			rc = 0;
-			goto out;
-		}
-		if (rc)
+		if (rc || dst_len + sizeof(*chdr) >= src_len)
 			goto out;
 
 		compressed_pdu_len = sizeof(*chdr) + dst_len;
-- 
2.54.0

