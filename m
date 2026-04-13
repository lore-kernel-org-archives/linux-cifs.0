Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2B236165E
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107261; cv=none; b=P3SUnRnxzllqSAzSyi7r1Tqi1/oUxoUCHQhLDWynmeG3LTKz9/1YCHF1Rs7ZjulYvxdO6JricJsHGct8y57HJy9Yzn9fuKbfjkxYDqTpECnHh6IXWE14TvG2zB6GW5hmPW1/vZZA2X2JRZH5rbvNNqdkGKfDF/2KLosJCppWBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107261; c=relaxed/simple;
	bh=KubO8D+iefzWr1kpBREH6U+jDK2uj4RHXgwRfFx9T7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E00N46TjeYbB9EhP2EjQBaHunWvKEDedbmhdJR/6IY3pK+UBLUM3uXSgf1g9dPEiRMq5BVx5sjBajg/lSx1M5o3Fe+Rx02xYOTOYHAAQDo0rY2C2woCZ4sB5E4tuUgA6l8Sx72ydiIoXv+klWg2nIlS/Oewmpa/Eg0oIsrfJw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GQkgQViX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z+IztFmU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GQkgQViX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z+IztFmU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GQkgQViX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z+IztFmU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GQkgQViX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z+IztFmU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F020C5BD94;
	Mon, 13 Apr 2026 19:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vepmT7bQh8HLcs0gykVzJI3rzGeEsWuJk1inXskEvJA=;
	b=GQkgQViXP8kxNX00bCbWjhKiUZlo6mPPci3cjj9APpNtEwhXXSXWfGnBlUHeE0Pj7jGFdH
	L6WM5plnhgbmJGGqOZJqArPNLdDr07vYAlmGQh61aD3OtyYwNiiBvr18Ak5E9lOz0Hm/Gp
	6wPlNoEAgpjYZiwIwTCUTYyc1awM42Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vepmT7bQh8HLcs0gykVzJI3rzGeEsWuJk1inXskEvJA=;
	b=Z+IztFmUR2Z/VJgEjCA62bw7t/2qR6sZ+BmrPnXcSdp4tx4auN22zphMxZFBXAaDP09N7d
	fBrFqTHNO76//LCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GQkgQViX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Z+IztFmU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vepmT7bQh8HLcs0gykVzJI3rzGeEsWuJk1inXskEvJA=;
	b=GQkgQViXP8kxNX00bCbWjhKiUZlo6mPPci3cjj9APpNtEwhXXSXWfGnBlUHeE0Pj7jGFdH
	L6WM5plnhgbmJGGqOZJqArPNLdDr07vYAlmGQh61aD3OtyYwNiiBvr18Ak5E9lOz0Hm/Gp
	6wPlNoEAgpjYZiwIwTCUTYyc1awM42Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vepmT7bQh8HLcs0gykVzJI3rzGeEsWuJk1inXskEvJA=;
	b=Z+IztFmUR2Z/VJgEjCA62bw7t/2qR6sZ+BmrPnXcSdp4tx4auN22zphMxZFBXAaDP09N7d
	fBrFqTHNO76//LCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A6BE4B038;
	Mon, 13 Apr 2026 19:07:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MzYtEPk+3WkiEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:07:37 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 2/8] smb: client: compress: fix bad encoding on last LZ77 flag
Date: Mon, 13 Apr 2026 16:07:07 -0300
Message-ID: <20260413190713.283939-2-ematsumiya@suse.de>
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
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	DKIM_TRACE(0.00)[suse.de:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: F020C5BD94
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

End-of-stream flag could lead to UB because of int promotion
(overwriting signed bit).

Fix it by changing operand from '1' to '1UL'.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress/lz77.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/compress/lz77.c b/fs/smb/client/compress/lz77.c
index 16c7d8f3ef17..c1e7fada6e61 100644
--- a/fs/smb/client/compress/lz77.c
+++ b/fs/smb/client/compress/lz77.c
@@ -216,7 +216,7 @@ noinline int lz77_compress(const void *src, u32 slen, void *dst, u32 *dlen)
 	}
 
 	flag <<= (32 - flag_count);
-	flag |= (1 << (32 - flag_count)) - 1;
+	flag |= (1UL << (32 - flag_count)) - 1;
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
-- 
2.53.0

