Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FB83F6C3D
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690675; cv=none; b=qkWM4ICd4M1std3JX+3lUVGtQTV1F9lWlZ10yos0p0jsR9/blcMeiCYHNdHeQQbyXa37MGacPNgGei1C4wblZ6zEDyniLT40RvX2vZhWZVeS9KYaJ7uPRIrazzvN0o93NQ9v6VNgmb+G5acUhFTJpG8JBzaVR9Pe4iYdG6DSRY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690675; c=relaxed/simple;
	bh=AYwL4x85KBfBnJQXr4uZFfgLpw+1sPN3KOzzjaCdiIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUGsadoQm04yRo25wZNbcdj71Lbn+1J6fRsrqZ10nnCdVZ72iuWG4ZcZLDNvcxcT8QFZFTWH8HTPXV+MFUb/vCT4ZLIp3V55C/YppZoaFrhuaBe1c23u5ACjw5T4+CJxKA7Bljn+lijddQJ4NrTec1m5WOuW12J/EecblCUqnN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nHpz+Bwt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tsn9rKas; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g2r0T7Sa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FZrrm9w6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nHpz+Bwt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tsn9rKas";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g2r0T7Sa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FZrrm9w6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB6EB764BA;
	Fri, 10 Jul 2026 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783690671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NszUrF+11F6wgI8xRukhU0/iZ4lQg7H8KugXg4ZdQ=;
	b=nHpz+BwturNMp8LGsL6y61NS1niOzIbo+g31aDgnWlbaM0LzUx+TXPzqdjy9DlXLFPzhVf
	rAyW4D4BIHRX5Nz4BHgqbRGhXe9tCNM9C8MLGZ3EqYt4k0VF68MG6sqRTRUdSg2Vb6HZBo
	GtoRZivcOwrZtqKVkjVgkhwPKz3b2Co=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783690671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NszUrF+11F6wgI8xRukhU0/iZ4lQg7H8KugXg4ZdQ=;
	b=Tsn9rKas66xINKIMrac9JYFqkezyzU+Bob+CfaNu2G8oYns5Ad0WEgpEXXVhF7U+UkLjSA
	pDZz2YLAO/CouKBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783690669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NszUrF+11F6wgI8xRukhU0/iZ4lQg7H8KugXg4ZdQ=;
	b=g2r0T7Saz4CT+dfYqhKpqlXLM8PzyAg7oUjWaylnlzeV3ynoruNY7r5Ju0cTtit2tJAK3d
	R1OMnLb2bfbUR1cug8Oo77PCpgXqtRsNUMsmwJUZnMN5Xy2lPeI0XWg7lGth9tfLg0hmTq
	T7LQkhoo3iQ47+n64la6pvRNbXx7mMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783690669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NszUrF+11F6wgI8xRukhU0/iZ4lQg7H8KugXg4ZdQ=;
	b=FZrrm9w66zcgF7FdQ/V5TgCkopRnGpoaS7of7tAltX6aEvil10lwDSuUZkStLMEJOF1l5Q
	l96xYwnRx6xffvDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63A42779BD;
	Fri, 10 Jul 2026 13:37:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oHGQCq31UGo0FQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 10 Jul 2026 13:37:49 +0000
Date: Fri, 10 Jul 2026 10:37:39 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: common: fix undefined shifts in LZ77 flag encoding
Message-ID: <alDzjYsJpxPPNXVr@suse.de>
References: <20260709173019.36808-1-acharyalaxman8848@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260709173019.36808-1-acharyalaxman8848@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,kernel.org,gmail.com,vger.kernel.org,lists.samba.org];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -4.30

Hi,

Thanks for the patch.

On 07/09, Laxman Acharya Padhya wrote:
>The LZ77 encoder emits flags in 32-bit words, but keeps the
>accumulator in a long and can shift it by 32 bits.
>
>This happens when lz77_encode_literals() emits a full all-literal flag
>word, and again when smb_lz77_compress() pads an empty final flag word.
>On 32-bit builds

SMB2 compression code is supposed to be supported on 64-bit (and
little endian) architectures only.

I was going to send a patch to make such checks at build-time (to make
that an explicit "statement"), but I'm waiting for Steve's input on it.


Cheers,

Enzo

>these shift counts are equal to the width of the
>shifted type, so UBSAN can report a runtime error and the encoded flag
>word is undefined.
>
>Use a u32 accumulator and special-case the full-word states so the same
>flag words are emitted without issuing 32-bit shifts.
>
>Fixes: d14bbfff259c ("smb3: mark compression as CONFIG_EXPERIMENTAL and fix missing compression operation")
>Cc: stable@vger.kernel.org
>Assisted-by: Codex:gpt-5
>Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
>---
> fs/smb/common/compress/lz77.c | 19 +++++++++++++------
> 1 file changed, 13 insertions(+), 6 deletions(-)
>
>diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
>index 9216d973d87..be6853ad576 100644
>--- a/fs/smb/common/compress/lz77.c
>+++ b/fs/smb/common/compress/lz77.c
>@@ -188,7 +188,7 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
>  * MS-XCA 2.3.4 "Plain LZ77 Compression Algorithm Details" - "Processing"
>  */
> static __always_inline void *lz77_encode_literals(const void *start, const void *end, void *dst,
>-						  long *f, u32 *fc, void **fp)
>+						  u32 *f, u32 *fc, void **fp)
> {
> 	if (start >= end)
> 		return dst;
>@@ -201,7 +201,10 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
> 		dst += len;
> 		start += len;
>
>-		*f <<= len;
>+		if (len == LZ77_FLAG_MAX)
>+			*f = 0;
>+		else
>+			*f <<= len;
> 		*fc += len;
> 		if (*fc == LZ77_FLAG_MAX) {
> 			lz77_write32(*fp, *f);
>@@ -225,7 +228,7 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
> 	const void *srcp, *rlim, *end, *anchor;
> 	u32 *htable, hash, flag_count = 0;
> 	void *dstp, *nib, *flag_pos;
>-	long flag = 0;
>+	u32 flag = 0;
>
> 	/* This is probably a bug, so throw a warning. */
> 	if (WARN_ON_ONCE(*dlen < smb_lz77_compressed_alloc_size(slen)))
>@@ -327,9 +330,13 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
> out:
> 	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
>
>-	flag_count = LZ77_FLAG_MAX - flag_count;
>-	flag <<= flag_count;
>-	flag |= (1UL << flag_count) - 1;
>+	if (flag_count) {
>+		flag_count = LZ77_FLAG_MAX - flag_count;
>+		flag <<= flag_count;
>+		flag |= (1U << flag_count) - 1;
>+	} else {
>+		flag = ~0U;
>+	}
> 	lz77_write32(flag_pos, flag);
>
> 	*dlen = dstp - dst;
>-- 
>2.53.0
>
