Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C070C327C08
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107264; cv=none; b=oAQNOCaDOFhFzpYVmaz6riDlIqK5Y/iybY4HhobM6eDfH/m/pNs9fiF8FBl1B+XI+Syja/5PdEo4n6Nrqkl0wyOfk+bhBL12HqhhoWGvOmd97PTqSS0NMq0t/aY55HBbjaWxyCgJzoow0936EmMMYdwOg4ZWZOVy1eEEiO4Q6yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107264; c=relaxed/simple;
	bh=3Xowdv2BvhLZ717GW43TwB1ow9mGeQa7xbjYK/8rGW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DClguklqqCxRyiq8M+NzvXWjnu1l7QcrW2Vrd8ZurgjkExqOxS8pR/luDwJtT0ZyEYQGLUpqqJe8yoQd1GaGcpAl3qMquCyDXZG9bI7eoSi9Br99ePGEkdQZ0Jbzwa6GTXoLrjMtJiLDx3HZxtZccbzYuGi1bhyU25pMAq5S5Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xT+rrlcj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=98VuPZTr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xT+rrlcj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=98VuPZTr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xT+rrlcj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="98VuPZTr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xT+rrlcj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="98VuPZTr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 146886A8B7;
	Mon, 13 Apr 2026 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMF5k9xlh64JtzVfTCCTVu0y6xLgrEG2XWvMV8dxisc=;
	b=xT+rrlcjKT8OyBHNrvL8rbKS9xW8Zkda9be+Jlb7VgZQmeoYptlExF06WNh7wQVoL7PsLM
	9gunUGnszmmOya5TjS+us6lUAvwCMzUtdJ5B5cEqJ857OYKhwZDC6Gpl+XIzPhXikzYfm9
	Fj67uuPa41y7eZ0Y0uMN8b5HtyRauEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMF5k9xlh64JtzVfTCCTVu0y6xLgrEG2XWvMV8dxisc=;
	b=98VuPZTr8ryuBPNbsSW//adWi4rErbiqydCk0SjGa2+vrj6Uefq+FE9ImNDAl/or6Cu5hi
	lmIiEmd8jeCpnGBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMF5k9xlh64JtzVfTCCTVu0y6xLgrEG2XWvMV8dxisc=;
	b=xT+rrlcjKT8OyBHNrvL8rbKS9xW8Zkda9be+Jlb7VgZQmeoYptlExF06WNh7wQVoL7PsLM
	9gunUGnszmmOya5TjS+us6lUAvwCMzUtdJ5B5cEqJ857OYKhwZDC6Gpl+XIzPhXikzYfm9
	Fj67uuPa41y7eZ0Y0uMN8b5HtyRauEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMF5k9xlh64JtzVfTCCTVu0y6xLgrEG2XWvMV8dxisc=;
	b=98VuPZTr8ryuBPNbsSW//adWi4rErbiqydCk0SjGa2+vrj6Uefq+FE9ImNDAl/or6Cu5hi
	lmIiEmd8jeCpnGBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93C8F4B038;
	Mon, 13 Apr 2026 19:07:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jwPOFvw+3WknEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:07:40 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 3/8] smb: client: compress: fix counting in LZ77 match finding
Date: Mon, 13 Apr 2026 16:07:08 -0300
Message-ID: <20260413190713.283939-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413190713.283939-1-ematsumiya@suse.de>
References: <20260413190713.283939-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

- lz77_match_len() increments @cur before checking for equality,
  leading to off-by-one match len in some cases.

  Fix by moving pointers increment to inside the loop.
  Also rename @wnd arg to @match (more accurate name).
- both lz77_match_len() and lz77_compress() checked for
  "buf + step < end" when the correct is "<=" for such cases.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/lz77.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index c1e7fada6e61..61cdf1c14612 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -48,17 +48,17 @@ static __always_inline void lz77_write32(u32 *ptr, u32 v)
 	put_unaligned_le32(v, ptr);
 }
 
-static __always_inline u32 lz77_match_len(const void *wnd, const void *cur, const void *end)
+static __always_inline u32 lz77_match_len(const void *match, const void *cur, const void *end)
 {
 	const void *start = cur;
 	u64 diff;
 
 	/* Safe for a do/while because otherwise we wouldn't reach here from the main loop. */
 	do {
-		diff = lz77_read64(cur) ^ lz77_read64(wnd);
+		diff = lz77_read64(cur) ^ lz77_read64(match);
 		if (!diff) {
 			cur += LZ77_STEP_SIZE;
-			wnd += LZ77_STEP_SIZE;
+			match += LZ77_STEP_SIZE;
 
 			continue;
 		}
@@ -67,10 +67,13 @@ static __always_inline u32 lz77_match_len(const void *wnd, const void *cur, cons
 		cur += count_trailing_zeros(diff) >> 3;
 
 		return (cur - start);
-	} while (likely(cur + LZ77_STEP_SIZE < end));
+	} while (likely(cur + LZ77_STEP_SIZE <= end));
 
-	while (cur < end && lz77_read8(cur++) == lz77_read8(wnd++))
-		;
+	/* Fallback to byte-by-byte comparison for last <8 bytes. */
+	while (cur < end && lz77_read8(cur) == lz77_read8(match)) {
+		cur++;
+		match++;
+	}
 
 	return (cur - start);
 }
@@ -195,7 +198,7 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 			flag_pos = dstp;
 			dstp += 4;
 		}
-	} while (likely(srcp + LZ77_STEP_SIZE < end));
+	} while (likely(srcp + LZ77_STEP_SIZE <= end));
 
 	while (srcp < end) {
 		u32 c = umin(end - srcp, 32 - flag_count);
-- 
2.53.0

