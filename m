Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB53242B2
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979261; cv=none; b=qTTvyOgAd9AUNktL0jkOCI5okDKXwHbO5Ky/V/kSwd7Y2040a7qS/Rui4bIU1+PMQFUV1KNeYEAzQ6joUzHB4Mge6pZWehVpOKtkBWM3uhiv0DJIOJH1ODMLl98QRcSk9OaEDWbnwDEKCRivt/m6ReEGiWz9GJtDP52zCJ+w83E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979261; c=relaxed/simple;
	bh=xOaKN4f+0xUp5n/PxekQCQfMr+xff9nRUFllfPsN704=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zky3cd1AqjskePhqLcqEDW6ZbNQWc2cqPRemZ35WHQbl1GJ/X8tTL2wQhxFYuHvZ5QRfmbtGEbHIT8B8tN5jMOttpwikloWaXUkvsFWaq0iuNnuB3RPWgw2qAvcLzXJLWXQ145aGCvMJRQQiZJkNSkeyUUMxzmanBVr/hYe7FsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WzluAkaG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F/My2anm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WzluAkaG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F/My2anm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WzluAkaG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F/My2anm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WzluAkaG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F/My2anm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 135AA77AD7;
	Mon, 13 Jul 2026 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuhGbPThqHT2pf+a56jeh2EMqy7bsvbnnbjtUF6LE2c=;
	b=WzluAkaGD+KLcmIYwhcQuh4bqOLhnl6EsKmDi55Ke+TpT6MmZrvhE0+k18q9yspo/9N1ds
	f02ykD4r/AFdgk2zSWjNItWnxdu5hHvh4ywYcUa4aurGK6YrYt9Futwl4NqCO48VEKRac/
	hdQaVQiitTMMFkGxtd8UaP++9JgeN/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuhGbPThqHT2pf+a56jeh2EMqy7bsvbnnbjtUF6LE2c=;
	b=F/My2anmIdGtPOdZnKUY9EBg52ZVNmnJUMuzWCRRXkJOql3u0wcAp/48yYO8DMIT4wY5r+
	IIsvw690P36/YpDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuhGbPThqHT2pf+a56jeh2EMqy7bsvbnnbjtUF6LE2c=;
	b=WzluAkaGD+KLcmIYwhcQuh4bqOLhnl6EsKmDi55Ke+TpT6MmZrvhE0+k18q9yspo/9N1ds
	f02ykD4r/AFdgk2zSWjNItWnxdu5hHvh4ywYcUa4aurGK6YrYt9Futwl4NqCO48VEKRac/
	hdQaVQiitTMMFkGxtd8UaP++9JgeN/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VuhGbPThqHT2pf+a56jeh2EMqy7bsvbnnbjtUF6LE2c=;
	b=F/My2anmIdGtPOdZnKUY9EBg52ZVNmnJUMuzWCRRXkJOql3u0wcAp/48yYO8DMIT4wY5r+
	IIsvw690P36/YpDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93207779AE;
	Mon, 13 Jul 2026 21:47:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FfldFvhcVWrLUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:36 +0000
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
Subject: [PATCH 10/10] smb: client: mark compression as supported on 64-bit LE only
Date: Mon, 13 Jul 2026 18:46:45 -0300
Message-ID: <20260713214645.550580-10-ematsumiya@suse.de>
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

Other architectures require more tuning + tests, even more so to
maintain the same performance.

So for now, mark SMB2 compression as supported only on 64-bit little
endian architectures.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/fs_context.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index abc29500a664..022d12da809c 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1289,8 +1289,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "CONFIG_CIFS_COMPRESSION kernel config option is unset\n");
 			goto cifs_parse_mount_err;
 		}
-		ctx->compress = true;
-		cifs_dbg(VFS, "SMB3 compression support is experimental\n");
+
+		/* This is more of a "TODO" than a final statement */
+		if (BITS_PER_LONG < 64 || 0x1234 != cpu_to_le16(0x1234)) {
+			cifs_dbg(VFS, "SMB3 compression is currently only supported on 64-bit little endian architectures, disabling\n");
+		} else {
+			ctx->compress = true;
+			cifs_dbg(VFS, "SMB3 compression support is experimental\n");
+		}
 		break;
 	case Opt_nodfs:
 		ctx->nodfs = 1;
-- 
2.54.0

