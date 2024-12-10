Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DDD1A256B
	for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 13:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733837054; cv=none; b=Akz31G3qSPleWkW1rxbyOGpdconmIP4hDeFrHEdsn646mmqUs0nCzpz8Rc9yXxSB6dOcdSPwdoIxwi57B3RTb7N4v/w5zr5En9f5eaxu3VxIBxAgPhyVlDWu7zeSO9YWP02FhQeEaZ2DVJZ2HfKj3J1eF8LsrUxGaRuWwendw+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733837054; c=relaxed/simple;
	bh=jxfy3loTrCXPEYvbEDexIbMa+iM3+hiONGwnX9Mx1mI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z/J7Hv4jhjftvivarLmYG4WIACOm/lmXF2gdgXYVZrz0e27l2C7Vm2C/kIJAj1QkYrf9IxBDAiv1Jq6EhTnWUDDXKI7usMkuVDQ59hLrayRxjywk44xePDyxS6LiSVb6JrIJTcWLuHV+epC9Pd2hZZ+/PR/oTIH2uMplhF+ZQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W1OzMWSK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=taWJ6gr5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vacfZt3c; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KZCLHqn4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W1OzMWSK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="taWJ6gr5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vacfZt3c";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KZCLHqn4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32BA221161;
	Tue, 10 Dec 2024 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733837050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F3KgD2X3BEXnztKBLQfbTPRgkZTwsLGVyEJ40KqcXd4=;
	b=W1OzMWSKChzTyQfB1yk05RrGy8QjY85lBxh0TdKtYotpsZ1LF36vng3w51H6Stt5pTpSlT
	98J9Wlk9xBWfvAy0AMS0138aI3X5qXr/pL0Rrq/J/i/E0Bae4eFlkmXpqxUQFexOrCG646
	NyHmytAy1mf3PeVw9QPYTxRrMim/4Nc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733837050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F3KgD2X3BEXnztKBLQfbTPRgkZTwsLGVyEJ40KqcXd4=;
	b=taWJ6gr5rhnz7tWG6eIc+GpD4Wu8lJBf4wy/UziyLE5+AUQdhKxna4peotLtvEyjmR18ek
	mzeWMvUBSjV9wsCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733837049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F3KgD2X3BEXnztKBLQfbTPRgkZTwsLGVyEJ40KqcXd4=;
	b=vacfZt3czOJ2RyKo5JRYReeGDPW4e11uYN8B3Iqtx+dyr4zzhnwXMIHf9jxgNmQOCEOkKy
	wqhuQYOZA8GoDZirMHoEoM4Xo5TdGj/VuFcpgb/PNmt5uEqZRtnY60QMXlrhDjI/PETLmZ
	0y7FnmF7wsnr6g6+aPCpWv4VmgXMoNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733837049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F3KgD2X3BEXnztKBLQfbTPRgkZTwsLGVyEJ40KqcXd4=;
	b=KZCLHqn4CvLXEEMWb71cfA/eK3swlrkJbR3kOiVby+qwEO3uAowVIgAI5dMxmpj3gfoDE9
	UPiY0p/ndZyiGEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5322138D2;
	Tue, 10 Dec 2024 13:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IIU6H/hAWGfjfgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 10 Dec 2024 13:24:08 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH] smb: client: destroy cfid_put_wq on module exit
Date: Tue, 10 Dec 2024 10:21:48 -0300
Message-ID: <20241210132148.2935-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.65
X-Spamd-Result: default: False [-2.65 / 50.00];
	BAYES_HAM(-2.85)[99.36%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c9f9b6e97964..9d96b833015c 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2043,6 +2043,7 @@ exit_cifs(void)
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
+	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
-- 
2.43.0

