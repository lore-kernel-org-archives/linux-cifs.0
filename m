Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568723BCF0
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748963270; cv=none; b=Fjr2wZYNV1MOGHTmcComtZvnFlKA+inhwDJmTvIY/5NuiFS8I2STiRa77jzjLimc3tgddUuOY7KRsN7+UZU0fp7HruiWAbKjCJwxtFhtAfMqnIUbfvbQKBMgOvE3oAYu70gmmQj45tfQMgbCtLuw4KxlgpPG4Vg+efvSdNBqaCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748963270; c=relaxed/simple;
	bh=Ini34z1F5WEKDGzQceDghW6XHhdeROoOIsbqigAqroA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nmkQJid3LYX60WCyMuwEs5NUPhIL0oKYprN8Ko62v0xYDTE3G2Z4A0Dwo77n/GsZgypS+BWnKWf2QzTVGi11/xICVBbOrza3/HexPkYgGUoQ+jVfWxxznd83lP4gCKQJ+3ogY8vqzT1hAGIPjs/rX11bLJzN13JplP0sDU0fpPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LQ73fSVN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j7EeZ7l0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LQ73fSVN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=j7EeZ7l0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LQ73fSVN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j7EeZ7l0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LQ73fSVN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="j7EeZ7l0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D9B121BA9;
	Tue,  3 Jun 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748963266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f+sULT1C92ZFGki4Cs7phG6NDqXEMK5wh3qz48h0MXs=;
	b=LQ73fSVNTik78uHADiu6zaiUdRkIcePyQYP1FwkNlfP0OpA7vxtL1Goegv3DM85fwvNVww
	JyhbCQELoSyXlbLB7TendIX3F33yohLVMRY6AR+iv83Vom37K1S4RtTEYFXaY5cCWsZ1/o
	vhLEntZibht1+KN9z66Z1Vl2nNWZDDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748963266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f+sULT1C92ZFGki4Cs7phG6NDqXEMK5wh3qz48h0MXs=;
	b=j7EeZ7l0BnurCURp4VIpzwzui1WZ1xW/AAtjaRNBL+C5hK7kSUo/oTdCjFbSaUDpCiV3+y
	w+ALEQBhdWtm59AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LQ73fSVN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j7EeZ7l0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748963266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f+sULT1C92ZFGki4Cs7phG6NDqXEMK5wh3qz48h0MXs=;
	b=LQ73fSVNTik78uHADiu6zaiUdRkIcePyQYP1FwkNlfP0OpA7vxtL1Goegv3DM85fwvNVww
	JyhbCQELoSyXlbLB7TendIX3F33yohLVMRY6AR+iv83Vom37K1S4RtTEYFXaY5cCWsZ1/o
	vhLEntZibht1+KN9z66Z1Vl2nNWZDDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748963266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f+sULT1C92ZFGki4Cs7phG6NDqXEMK5wh3qz48h0MXs=;
	b=j7EeZ7l0BnurCURp4VIpzwzui1WZ1xW/AAtjaRNBL+C5hK7kSUo/oTdCjFbSaUDpCiV3+y
	w+ALEQBhdWtm59AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D96E13A1D;
	Tue,  3 Jun 2025 15:07:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d86AMcEPP2jUMAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 03 Jun 2025 15:07:45 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH cifs-utils] mount.cifs: retry mount on -EINPROGRESS
Date: Tue,  3 Jun 2025 12:07:36 -0300
Message-ID: <20250603150736.134709-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 8D9B121BA9
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -3.01

cifs.ko mount might return -EINPROGRESS even for blocking sockets.

This patch makes mount.cifs retry mount when DNS resolution
returns >1 IP addresses for a server and such error occurs.

It's ok to retry because cifs.ko will consider it a hard error and abort
the mount anyway, so there's no risk of duplicate mounts.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 mount.cifs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mount.cifs.c b/mount.cifs.c
index 6edd96eb222a..192391360bca 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2373,6 +2373,7 @@ mount_retry:
 		switch (errno) {
 		case ECONNREFUSED:
 		case EHOSTUNREACH:
+		case EINPROGRESS:
 			if (currentaddress) {
 				fprintf(stderr, "mount error(%d): could not connect to %s",
 					errno, currentaddress);
-- 
2.49.0

