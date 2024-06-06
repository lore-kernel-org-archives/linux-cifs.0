Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D790919A2A7
	for <linux-cifs@vger.kernel.org>; Thu,  6 Jun 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690449; cv=none; b=msGKw7Iq+uL49BI2k96Lq0WpGTxHhgYdoAJFVR4X+aJlYQHBMWayX/0+NbceLtX4t16AETVWfaWIiQBBRVk1w6Fb+JTpyRe/9gld5Ob81E8jTnjNK9bXaUG7Qc9rFLROsDdgsLXEr1rcA4RriqV5WwMElvV01zEplaONMAnlgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690449; c=relaxed/simple;
	bh=0RulEnq9guJU7+LtzS2kXmHpsCN6HC+dXbm2Sy8oZIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JocPSl4/CXsYmEC7QOJU1Kmk0GuQtw7wMhzUBWzHJ2l7lFVwGKtYCfQNMhsM5StT64h/pRhkPeqjaluFRk6Rg0l5WYGjJzNpG/rIT92Am1v0cw93zdfSwNjtmkDN7ivtGexPz2L/1NRZScPxZOZaP+gHsa1xU0z+uvHL4m8v8ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nkWpYPQC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y8Ox3RZo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nkWpYPQC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y8Ox3RZo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nkWpYPQC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y8Ox3RZo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nkWpYPQC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y8Ox3RZo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E3181FB3C;
	Thu,  6 Jun 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717690446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2EzfZ+/QKwMjiDV96fyfQhG5Lx7Dly0FsbaPIe81zdY=;
	b=nkWpYPQCBYfI2lH407CRH22lVK1gSmU3p3ELyxPZu3irBq6nrCCDthPBsUc8xtFUJquQYB
	djJtjt3Zq/k98oWmvwKi/pVhIyelhyoRA1icNuzNzYwzpTjEhCfbkqoxTC89vGZj8ncYkc
	jmfL2alVEQrKn0HXPDQR6/lIx3wg9PY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717690446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2EzfZ+/QKwMjiDV96fyfQhG5Lx7Dly0FsbaPIe81zdY=;
	b=Y8Ox3RZo22vnr0GoinoO2yR/pUl3LIHQ8AxKWUdUM4luwpp0Bdg9YXmaVHB8VIk6vpLpUf
	TSUvKooY7bPmGECg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717690446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2EzfZ+/QKwMjiDV96fyfQhG5Lx7Dly0FsbaPIe81zdY=;
	b=nkWpYPQCBYfI2lH407CRH22lVK1gSmU3p3ELyxPZu3irBq6nrCCDthPBsUc8xtFUJquQYB
	djJtjt3Zq/k98oWmvwKi/pVhIyelhyoRA1icNuzNzYwzpTjEhCfbkqoxTC89vGZj8ncYkc
	jmfL2alVEQrKn0HXPDQR6/lIx3wg9PY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717690446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2EzfZ+/QKwMjiDV96fyfQhG5Lx7Dly0FsbaPIe81zdY=;
	b=Y8Ox3RZo22vnr0GoinoO2yR/pUl3LIHQ8AxKWUdUM4luwpp0Bdg9YXmaVHB8VIk6vpLpUf
	TSUvKooY7bPmGECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9116E13A1E;
	Thu,  6 Jun 2024 16:14:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IRN4Fk3gYWYdfwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 06 Jun 2024 16:14:05 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Subject: [PATCH] smb: client: fix deadlock in smb2_find_smb_tcon()
Date: Thu,  6 Jun 2024 13:13:13 -0300
Message-ID: <20240606161313.25521-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.09
X-Spam-Level: 
X-Spamd-Result: default: False [-2.09 / 50.00];
	BAYES_HAM(-2.29)[96.68%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Unlock cifs_tcp_ses_lock before calling cifs_put_smb_ses() to avoid such
deadlock.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 02135a605305..1476c445cadc 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -216,8 +216,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
 	if (!tcon) {
-		cifs_put_smb_ses(ses);
 		spin_unlock(&cifs_tcp_ses_lock);
+		cifs_put_smb_ses(ses);
 		return NULL;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-- 
2.45.1

