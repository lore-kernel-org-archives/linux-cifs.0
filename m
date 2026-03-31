Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131231AF2D
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 01:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774920343; cv=none; b=S2OH0XfYe63e8G6FVPDwM0MkVoRGWSN2+k+icpYU/yn+ggzOmBxnNtpnvhs/NYXYueMqKUfvYIvd5jfcMsLVlU6Ic0L4iWC4ARFDVIj+O18ZZBygd9iY5dc4rKA46d6x0lG3lRJDH2NEJWEZVQ5qRjYqI8AKMdOKnhjB5Nfgk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774920343; c=relaxed/simple;
	bh=LWz5esiwB/9kMnmrkPPNwVFOSJAyHpexKRRRViQER3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enP88uZCnqh3hrfiuSFwB4Yn59xRp8rOALKx/IGJWO6tlBGaN/s4dATg6LaPUgpRLhHHqii+R+gB17Q/ufSVg+PWgHLsI7Id13owFylsVEcraXX6EMAmS1vX/16UrafRQPS56gVbEoJQX4RzLwzkKQA+JF5mqSK3zkkGce4Bh90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mLiYqpb2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qrWPYeLd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mLiYqpb2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qrWPYeLd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mLiYqpb2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qrWPYeLd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mLiYqpb2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qrWPYeLd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1504B4D635;
	Tue, 31 Mar 2026 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/wtcZMY4V0XiILQfZPcG0rCbNUMcvfGDxltiO6Mj3w=;
	b=mLiYqpb2H0UnNuYSi9nNNq4/nqTKcD9dqCu07hJqSlD5g/DW/8qaowyeD32CQ5PVUx/rVQ
	zSEynxGv+x2v7BQnRww6iisRZY2tTcVxHm0I54Ftz5Ot8gFuzI6NnRuqp9deWE1mzANu0g
	O4zjeumqWEVxbkfWKLVqp1u+LRJcSn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/wtcZMY4V0XiILQfZPcG0rCbNUMcvfGDxltiO6Mj3w=;
	b=qrWPYeLdmN5RyUJv/FLggFYTZ5b5pSBUQUFJ0nHvXXEWbhyfBtwDGW130sVBGsJGRAc0Nx
	OChbL1lLEOC3AlBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/wtcZMY4V0XiILQfZPcG0rCbNUMcvfGDxltiO6Mj3w=;
	b=mLiYqpb2H0UnNuYSi9nNNq4/nqTKcD9dqCu07hJqSlD5g/DW/8qaowyeD32CQ5PVUx/rVQ
	zSEynxGv+x2v7BQnRww6iisRZY2tTcVxHm0I54Ftz5Ot8gFuzI6NnRuqp9deWE1mzANu0g
	O4zjeumqWEVxbkfWKLVqp1u+LRJcSn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/wtcZMY4V0XiILQfZPcG0rCbNUMcvfGDxltiO6Mj3w=;
	b=qrWPYeLdmN5RyUJv/FLggFYTZ5b5pSBUQUFJ0nHvXXEWbhyfBtwDGW130sVBGsJGRAc0Nx
	OChbL1lLEOC3AlBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86A594A0A2;
	Tue, 31 Mar 2026 01:25:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OvFDo4iy2mpbgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 31 Mar 2026 01:25:34 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 2/3] mount.cifs: adjust get_password_from_file() buf size
Date: Tue, 31 Mar 2026 11:37:52 +1100
Message-ID: <20260331012508.17410-3-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260331012508.17410-1-ddiss@suse.de>
References: <20260331012508.17410-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

The parsed_mount_info password and password2 fields are both zero
terminated and sized MOUNT_PASSWD_SIZE + 1.
The get_password_from_file() buf adds one to this size, presumably to
account for (extra) zero termination. This is unnecessary, so use a
consistent size across all buffers.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 mount.cifs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index d41ca6a..945196f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -684,7 +684,7 @@ get_password_from_file(int file_descript, char *filename,
 	int is_pass2 = which_pass == OPT_PASS2;
 	unsigned int pass_length = is_pass2 ?
 					  sizeof(parsed_info->password2) : sizeof(parsed_info->password);
-	char buf[pass_length + 1];
+	char buf[pass_length];
 
 	if (filename != NULL) {
 		rc = toggle_dac_capability(0, 1);
-- 
2.51.0

