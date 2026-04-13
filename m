Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912541A3166
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776107299; cv=none; b=clRKeajo1HYKyDFzLvbB0IG9JXTDGNy8GwJCF1ombyWsGNWhdRl9E9HsbnKNvAVLAaSMkD81trIGI8RfbTEr5s5Eb5YeS2vo3yda3qqehoeb5hfRTJ2x3nCwZOM/DeR3LSAk9Vr80epx3PocYm50VilpBDUULyDV3F4E8aolQwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776107299; c=relaxed/simple;
	bh=dlaX8MnrFI35YUNAuoemOBrbgxuU+rRc9OKW9U44tAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFnzWgvIYhamu3I+ttSrPkl6BLLrCIKuxjdwXI8ualnaKUWxmVw3L6BC5lZXJEO3MIfFwddVPN1rsiyQczoQPp2e0Uu1pWtcqxpyLzTH1lCSR2KmwJOxvoSujC1LBfiByzXhfiCcpKpjD0wt5A7Vaqa9H41pLdXGzkpDODMkhII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g7M3BHrd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B0b8vIER; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g7M3BHrd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=B0b8vIER; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g7M3BHrd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B0b8vIER";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g7M3BHrd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="B0b8vIER"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CFD3E5BDB1;
	Mon, 13 Apr 2026 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xttXmAaurVdwurMF9HUVNAG1SNwl+0Fa4fXhYY+62+w=;
	b=g7M3BHrdvjLEm9FPldAMddCW+k6m0Enyc3xOcH7/JVPVPRSve5geI1sF6a9MVQ75EHGnHQ
	V3+6+3pef8ZooFrY3/ZOx6hpHjHuG7bmRZ+HjZrZNUWtwinVLc6THbKpdE/i+6i2F37TPn
	1vlrbVgSMwbyyuKCOVDrQmI6AvUTgEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107292;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xttXmAaurVdwurMF9HUVNAG1SNwl+0Fa4fXhYY+62+w=;
	b=B0b8vIERWYfyA2OY4OswPjxDXZWUFgLWceO7hVALQK2EWj3tGemSeynfrOHxxqJ6q6qeKB
	Xw8qn770jemwudBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g7M3BHrd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=B0b8vIER
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776107292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xttXmAaurVdwurMF9HUVNAG1SNwl+0Fa4fXhYY+62+w=;
	b=g7M3BHrdvjLEm9FPldAMddCW+k6m0Enyc3xOcH7/JVPVPRSve5geI1sF6a9MVQ75EHGnHQ
	V3+6+3pef8ZooFrY3/ZOx6hpHjHuG7bmRZ+HjZrZNUWtwinVLc6THbKpdE/i+6i2F37TPn
	1vlrbVgSMwbyyuKCOVDrQmI6AvUTgEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776107292;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xttXmAaurVdwurMF9HUVNAG1SNwl+0Fa4fXhYY+62+w=;
	b=B0b8vIERWYfyA2OY4OswPjxDXZWUFgLWceO7hVALQK2EWj3tGemSeynfrOHxxqJ6q6qeKB
	Xw8qn770jemwudBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D9774B03B;
	Mon, 13 Apr 2026 19:08:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z4aUCRw/3WnHEAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Apr 2026 19:08:12 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 8/8] smb: common: add SMB3_COMPRESS_MAX_ALGS
Date: Mon, 13 Apr 2026 16:07:13 -0300
Message-ID: <20260413190713.283939-8-ematsumiya@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: CFD3E5BDB1
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Set it to number of currently defined algorithms (6 as of now).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/common/smb2pdu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index e482c86ceb00..cda71964ed01 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -510,6 +510,8 @@ struct smb2_encryption_neg_context {
 /* Pattern scanning algorithm See MS-SMB2 3.1.4.4.1 */
 #define SMB3_COMPRESS_PATTERN	cpu_to_le16(0x0004) /* Pattern_V1 */
 #define SMB3_COMPRESS_LZ4	cpu_to_le16(0x0005)
+/* Account for NONE for easier array indexing */
+#define SMB3_COMPRESS_MAX_ALGS	6
 
 /* Compression Flags */
 #define SMB2_COMPRESSION_CAPABILITIES_FLAG_NONE		cpu_to_le32(0x00000000)
-- 
2.53.0

