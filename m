Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A113B58A
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774915820; cv=none; b=lLYpNqB4zCNYapdfYoEz1G1YgZAKvaMHl2W3iCDODGbfoDN3e/oPMtQ8EpoRFDlc+JXbAEoLushTIf4X7Gcry4i+w+kmXtrG21tIvjaqSdPztNzU9Y0F9fC34XrceFr49nU59iDTYar1o/8o/YiHDnpPC4srbCAvTgKfap2H6BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774915820; c=relaxed/simple;
	bh=6hQN1OpICcA4yQqlpr+aTakbz7UHM9CVkKNIV3oboq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RS1EioPUbmdfEl4cCp1NKVct42o/iwiOntPcXt0mWKo3WT0IB4dVGbdiaVjA/maWhZaYIj+ZuqwQJeHzHDBy2VFoKVUtCc8BJvnaq3Mcvsja/IOI01Atp080rPE4NHIOx5K8k5jDNjkdWfdmFnpOuoLh3XxWdznRZsCrz45HjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=l6AEHfQC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dqAf6yCk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DGOEvkAw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dIWov5uZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="l6AEHfQC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dqAf6yCk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DGOEvkAw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dIWov5uZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E61C85BD68;
	Tue, 31 Mar 2026 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774915817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RVJyPKKdmS9R+Kpd6MaNUQ/wMl9LesyF/QDEgPQVANI=;
	b=l6AEHfQCT/jwXsnXVh7tPADsBO2oexad78KaBVlsm4H4hDi5vDgWbrHqpNAaUTL/x/BS6p
	izENq7WryiZMjolAO+umqFmqUhGU+4apTweQu/1VNluygjUNh8UbGj2tZhrcQGVhI83Hti
	/8fUws2yT/hRCVsRXi3/wRfxxbDt7+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774915817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RVJyPKKdmS9R+Kpd6MaNUQ/wMl9LesyF/QDEgPQVANI=;
	b=dqAf6yCkKbI9iUa1sIzuzFMuzK44QShPDJ8oklQD/ZT92ThIdrG3zdEtQr1yOh92aG28ko
	f9M6ZoOGjOBC/UDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DGOEvkAw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dIWov5uZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774915816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RVJyPKKdmS9R+Kpd6MaNUQ/wMl9LesyF/QDEgPQVANI=;
	b=DGOEvkAwZVjKZ2rKOMlDSfOu80rZT3NmTowlqeen9G3GW0Uotdk7TYnUdDl7ezaXZ2fePv
	ZrTZW9warGPBatiVTOLfp/K+EBMShy/+lNqXCSrzzhPS/s4LIE7CnHNAzP2+SMgUEime9o
	AjW2uc0ZKEtCWfMX76YaIe2+AeBonZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774915816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RVJyPKKdmS9R+Kpd6MaNUQ/wMl9LesyF/QDEgPQVANI=;
	b=dIWov5uZt6Y7qZtTWBvrraX/Ppkt2Tc9ZEj8okDi+FpQ5yix5fmRWhT8TzdZ601QWSGOcc
	Ty37ht8ppZ954ECA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 186804A0A2;
	Tue, 31 Mar 2026 00:10:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id trB+L+YQy2mJIwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 31 Mar 2026 00:10:14 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	David Disseldorp <ddiss@suse.de>,
	Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: [PATCH] mount.cifs: fix buffer overrun in set_password
Date: Tue, 31 Mar 2026 11:09:11 +1100
Message-ID: <20260331000911.16062-1-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.de,bierbaumer.net];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samba.org:url,suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E61C85BD68

The existing (j > pass_length) check is insufficient to avoid dst buffer
overrun into the start of the adjacent struct parsed_mount_info field.
Check for overrun before writing to dst, and account for comma-expansion
and null-termination.

Bug: https://bugzilla.samba.org/show_bug.cgi?id=16044

Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 mount.cifs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 1923913..d41ca6a 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
 	unsigned int i = 0, j = 0;
 
 	while (src[i]) {
-		if (src[i] == ',')
-			dst[j++] = ',';
-		dst[j++] = src[i++];
-		if (j > pass_length) {
+		if (j + 2 >= pass_length) {
 			fprintf(stderr, "Converted password too long!\n");
 			return EX_USAGE;
 		}
+		if (src[i] == ',')
+			dst[j++] = ',';
+		dst[j++] = src[i++];
 	}
 	dst[j] = '\0';
 	if (is_pass2)
-- 
2.51.0

