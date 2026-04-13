Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDE93914E8
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107271; cv=none; b=WyG402wRHTy86Ex7ddSjSYYnOBliLTXAG6A7OILsN+trl/0kCMKIXZmorJueDLYC2453FRaQkbx/znF8do3Lj8T2T8MJO6MzGpE4/fLVqRjNliSgODlZDyM27ijF/t+R55ispiSoPL19+WxmcCq9FANuQeAEdExo8hW5t+5bYVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107271; c=relaxed/simple;
	bh=moBmrrUFrQhF1bnyl4w8rK27LAoH5D4GpmEdbB5NiGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CikkVbmOpdce9ROYbaHndYXystoMx+whrrxUmtc1yXhXQ3Ocox2WRyYm2w50MkKJvQahe4ufSfuORXqdnsE6Ke/1APTOLWxjiJlV1jp44HtINJau7eZCuqbC1vRgd1OzzfzNO34s+m2GJtpXs/89+pSmwOGdOazdyHNGYL9cyHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qr1vj1vC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jl7xTLdb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qr1vj1vC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jl7xTLdb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qr1vj1vC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jl7xTLdb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qr1vj1vC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jl7xTLdb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 301E05BDA7;
	Mon, 13 Apr 2026 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bcy3W0iQ/MgtF/lgtbsYvi7UpvHn398spjBkKGRhHE=;
	b=Qr1vj1vCoE0oBFcoiw+2kSwO9ZYh9CrZmd1Hvg26VT1c2qe2fo7jZOxM+IK23P6KdSNZ0L
	G1JlYGEH3umWaHg3KsBFwa8oO6cW3feifPQd1QOer0u5I+byvxLD0jGqWEQ2LUvLlouM+1
	2e8zhiIIhFeiSaP6gSxX0BtIqHrhMR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bcy3W0iQ/MgtF/lgtbsYvi7UpvHn398spjBkKGRhHE=;
	b=Jl7xTLdb/sxWJJ/22oL2/taTAH3hGgQAUAM1sGQaglaBuQ+iW2Wp+4F00j9dxUbdgk+f7R
	pSci/H9T+A2TGiAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107268; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bcy3W0iQ/MgtF/lgtbsYvi7UpvHn398spjBkKGRhHE=;
	b=Qr1vj1vCoE0oBFcoiw+2kSwO9ZYh9CrZmd1Hvg26VT1c2qe2fo7jZOxM+IK23P6KdSNZ0L
	G1JlYGEH3umWaHg3KsBFwa8oO6cW3feifPQd1QOer0u5I+byvxLD0jGqWEQ2LUvLlouM+1
	2e8zhiIIhFeiSaP6gSxX0BtIqHrhMR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107268;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bcy3W0iQ/MgtF/lgtbsYvi7UpvHn398spjBkKGRhHE=;
	b=Jl7xTLdb/sxWJJ/22oL2/taTAH3hGgQAUAM1sGQaglaBuQ+iW2Wp+4F00j9dxUbdgk+f7R
	pSci/H9T+A2TGiAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0A8A4B039;
	Mon, 13 Apr 2026 19:07:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iSbTHQM/3WmwEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:07:47 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 4/8] smb: client: compress: increase LZ77_MATCH_MAX_DIST
Date: Mon, 13 Apr 2026 16:07:09 -0300
Message-ID: <20260413190713.283939-4-ematsumiya@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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

Increase max distance (i.e. window size) from 1k to 8k.
This allows better compression and is just as fast.

Other:
- drop LZ77_MATCH_MIN_DIST as it's nused -- main loop
  already checks if dist > 0

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/lz77.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 61cdf1c14612..480927dcd4c6 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -17,8 +17,7 @@
  * Compression parameters.
  */
 #define LZ77_MATCH_MIN_LEN	4
-#define LZ77_MATCH_MIN_DIST	1
-#define LZ77_MATCH_MAX_DIST	SZ_1K
+#define LZ77_MATCH_MAX_DIST	SZ_8K
 #define LZ77_HASH_LOG		15
 #define LZ77_HASH_SIZE		(1 << LZ77_HASH_LOG)
 #define LZ77_STEP_SIZE		sizeof(u64)
-- 
2.53.0

