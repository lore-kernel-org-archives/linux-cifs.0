Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DDF345740
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979230; cv=none; b=T5rV5DKoaBpaL4hNtxVbDuTYvboHzPp5rSpO5/AocWNGCB5iPpSNX3k/Tg5yxRgmipI1D4iH4yPZLqYkXCtRj8X+VuSVGkuwkIm2LPvAUZx74hQAeaR1jffW5O5epqCizifbeNG+u4BpCZWjNulBeTC4Z+vak10Va5aPtdqu9jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979230; c=relaxed/simple;
	bh=ZQaFINnaXdqMohTGBHDraczAWKXfyp5UELP6ndbQjuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovmwm92Ff0aUPtn1Bb1E5By886lApIRvbCU2asrF0yYeW7Stv10Pw/Tk47Qxy/5LIZfR6a4Ntyf3zlqsMOgQZ15AGtam3KHqDk7S/fy7RjyDmf50X/2Q8DUX/Q+f18coMEMyAImuq7lFj7twQoJdky1HzrIo1i1ooy0qV7enSWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ba6x0Clc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xSAU9U3i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ba6x0Clc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xSAU9U3i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ba6x0Clc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xSAU9U3i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ba6x0Clc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xSAU9U3i"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D063B77AD2;
	Mon, 13 Jul 2026 21:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QJiL7zNUdDmbwkrkcyonapx7gKWHljmHAlYqxLaKhk=;
	b=ba6x0ClcTW5ATmajhkCi1tF1Mggzb/dJzUruKmHIJOLGXjnMnGThjlEbUpTiCxI15T/61H
	8n9GAwtt7jcE6steOozBoR5wQtGwzA74m37drIetWPZpgF1ovhhL3a9a4WD2BW+vVjAXTf
	hvEHl8rybqnqQUEvPmyJAiqkFEtbWpY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QJiL7zNUdDmbwkrkcyonapx7gKWHljmHAlYqxLaKhk=;
	b=xSAU9U3i6qf+yq1of7hRWBRiNCER9Ql/ABM5A4QUbk3Yf5w6kKllpRgJfCdXyZc9/VZLZJ
	mZApWojINDEwcMDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QJiL7zNUdDmbwkrkcyonapx7gKWHljmHAlYqxLaKhk=;
	b=ba6x0ClcTW5ATmajhkCi1tF1Mggzb/dJzUruKmHIJOLGXjnMnGThjlEbUpTiCxI15T/61H
	8n9GAwtt7jcE6steOozBoR5wQtGwzA74m37drIetWPZpgF1ovhhL3a9a4WD2BW+vVjAXTf
	hvEHl8rybqnqQUEvPmyJAiqkFEtbWpY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QJiL7zNUdDmbwkrkcyonapx7gKWHljmHAlYqxLaKhk=;
	b=xSAU9U3i6qf+yq1of7hRWBRiNCER9Ql/ABM5A4QUbk3Yf5w6kKllpRgJfCdXyZc9/VZLZJ
	mZApWojINDEwcMDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 594C4779AE;
	Mon, 13 Jul 2026 21:47:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ulURCNpcVWqSUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:06 +0000
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
Subject: [PATCH 03/10] smb: client: compress: disable compression on reconnects
Date: Mon, 13 Jul 2026 18:46:38 -0300
Message-ID: <20260713214645.550580-3-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

Windows Server resets the connection if it gets a compressed request
that it couldn't decompress.

Some encoded payloads might decode differently on the server, or
vice-versa, due to different implementation details (not really a bug),
or an actual bug on either implementation.

To prevent an infinite retry on such failed sends, simply disable
compression for that server when a reconnect is about to happen.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/connect.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..324452bc0437 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -401,6 +401,20 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 		try_to_freeze();
 		cifs_server_lock(server);
 
+		/*
+		 * Servers might disconnect us when they can't decompress a compressed request we
+		 * sent.
+		 * When this happens, as a failsafe measure, disable compression entirely to avoid
+		 * an endless retry.
+		 *
+		 * TODO: implement a more flexible alternative, e.g. identify and retry sending the
+		 * failed request uncompressed, without having to disable compression entirely.
+		 */
+		if (server->compression.enabled) {
+			cifs_server_dbg(VFS | ONCE, "disabling compression (failsafe)\n");
+			memset(&server->compression, 0, sizeof(server->compression));
+		}
+
 		if (!cifs_swn_set_server_dstaddr(server) &&
 		    !SERVER_IS_CHAN(server)) {
 			/* resolve the hostname again to make sure that IP address is up-to-date */
-- 
2.54.0

