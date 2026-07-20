Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C16322DAF
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 19:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577009; cv=none; b=BkcYmITJE8bn0myFuDvcWGfxTzWQzpFLFS5fE0QsexMp+HYVFPMwVtS42uc3rlRZzSAyStVnL3YP0gibIWZsgwwrfROnLHAFutehPT01y8pVwaqzOQ4LLuA29bZCWTA7Ulv7I3+mIG3g5d7ig8MJEtK8Hrc56G4uVfDxZvVYnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577009; c=relaxed/simple;
	bh=4He3Dqn5snKkqDw9lHj1X/1qLARfimOBj7QJEbad0n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhNUFs76UttO95xBlgB7BLw7tz48BTELVG42lM9G0lfH1WRmginZEQH8MVhp5Q63DdVXetl9Zo2Z3M3G0KgXCihDLsskea3XwniOjFDMIsE8PQK4KUofz2fA6O2WBJ1dZPsRr9Qv/t32Snrv2R7JmmOFg2E4FdFh+FDoEqPzehY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F75E3E93;
	Mon, 20 Jul 2026 19:50:04 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D70F6779AA;
	Mon, 20 Jul 2026 19:50:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2dJJut7XmrACAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 20 Jul 2026 19:50:03 +0000
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
Subject: [PATCH v2 09/14] smb: common: compress: allow smb_lz77_compress() to overcompress
Date: Mon, 20 Jul 2026 16:49:20 -0300
Message-ID: <20260720194925.2108840-9-ematsumiya@suse.de>
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
X-Rspamd-Queue-Id: 5F75E3E93
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

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
 fs/smb/client/compress.c      | 4 ++--
 fs/smb/common/compress/lz77.c | 7 ++-----
 fs/smb/server/compress.c      | 5 ++---
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 37e92e2bc816..363ad58ad798 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -406,7 +406,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 
 	ret = smb_compression_compress(SMB3_COMPRESS_LZ77, chained, use_pattern,
 				       src, slen, dst, &dlen);
-	if (!ret) {
+	if (!ret && dlen < slen) {
 		struct smb2_compression_hdr *hdrp = dst, hdr = {};
 		struct smb_rqst comp_rq = { .rq_nvec = 3, };
 		struct kvec iov[3];
@@ -453,7 +453,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 		comp_rq.rq_iov = iov;
 
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
index 999b7b11de85..59e78c3b042c 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -151,10 +151,9 @@ int ksmbd_compress_response(struct ksmbd_work *work)
 				      src, src_len,
 				      out + sizeof(__be32),
 				      &dst_len);
-	if (rc == -EMSGSIZE || dst_len >= src_len) {
-		rc = 0;
+	/* if dst_len >= src_len, rc is 0 */
+	if (rc || dst_len >= src_len)
 		goto out;
-	}
 
 	*(__be32 *)out = cpu_to_be32(dst_len);
 
-- 
2.54.0

