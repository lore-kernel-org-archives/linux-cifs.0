Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6BC1BA867
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726671528; cv=none; b=pFZ99gTuYxGf3cZi/MVmRRQgCMhNi4peemIm/bRVba0L0Ko9i+3L3idlS2mf+pqqGeBrH+Tooyy4Px7NEcV5sPr2b+xNC1n0fp+pocuOTaGYfqFCN5bBReDh5Xqbn1qNK1/Z04XmB2C62+tZBtZXsTgB1fzVZXHuY9n47FdDrf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726671528; c=relaxed/simple;
	bh=5s6xgUUEVWpoPX1q9UP0P1TqLuL4Mo2khBbEBk3JQHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AHtcUxa2yXQcQJKosEd9McRS5SHlWrOoIR8E7F/jCmZdGKgqdRLb7+1K3AlbCnJhPg68Q7RqwpFHO003ZAi3G6EWwyRAkgfd+yaAdXZtgBEQloEQN9mOqexMECp7adEjWIb8Zqh/fk2GovuRSjZ2A+RnHtm30ySN7AMdXNn0MuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=flcWCe6r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GPeZ7fQj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=flcWCe6r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GPeZ7fQj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="flcWCe6r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GPeZ7fQj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="flcWCe6r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GPeZ7fQj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F72720507;
	Wed, 18 Sep 2024 14:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726671525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eZCbJbU0G8EaNGlCy27HJTluwdw1PQVpsKbaX2wI1S4=;
	b=flcWCe6rL31wrOE8cVlFvNHvpzaUUuuwyIhFOt8vfBTZ1cOHqBSSe0tWt0StZHhO/h1o7c
	DDLGEBmFb44d8OIj+Q3JjxAaT8dfuRHy2mJGBiTgvrgTalhZ74S/qbYailPeeR32TwdaAh
	M7o5pF4QCmf61U1d2yjaQANtiPp6CAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726671525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eZCbJbU0G8EaNGlCy27HJTluwdw1PQVpsKbaX2wI1S4=;
	b=GPeZ7fQjqfxoObeXkBqIIXYEFVaz5B8KqVYvSjJTbIfjVDXfdvyO6qkujkCtlL+pDDhhvK
	v3D7bg5mE6Vr8ABw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=flcWCe6r;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GPeZ7fQj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726671525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eZCbJbU0G8EaNGlCy27HJTluwdw1PQVpsKbaX2wI1S4=;
	b=flcWCe6rL31wrOE8cVlFvNHvpzaUUuuwyIhFOt8vfBTZ1cOHqBSSe0tWt0StZHhO/h1o7c
	DDLGEBmFb44d8OIj+Q3JjxAaT8dfuRHy2mJGBiTgvrgTalhZ74S/qbYailPeeR32TwdaAh
	M7o5pF4QCmf61U1d2yjaQANtiPp6CAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726671525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eZCbJbU0G8EaNGlCy27HJTluwdw1PQVpsKbaX2wI1S4=;
	b=GPeZ7fQjqfxoObeXkBqIIXYEFVaz5B8KqVYvSjJTbIfjVDXfdvyO6qkujkCtlL+pDDhhvK
	v3D7bg5mE6Vr8ABw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92D6113A57;
	Wed, 18 Sep 2024 14:58:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGr1FqTq6mbrVAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 18 Sep 2024 14:58:44 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH] smb: client: fix sparse warning in should_compress()
Date: Wed, 18 Sep 2024 11:59:04 -0300
Message-ID: <20240918145904.750318-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F72720507
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Use le32_to_cpu() to read wreq->Length.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index baaa6a470f53..a9db6cddc219 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -306,7 +306,7 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 	if (shdr->Command == SMB2_WRITE) {
 		const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
 
-		if (wreq->Length < SMB_COMPRESS_MIN_LEN)
+		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)
 			return false;
 
 		return is_compressible(&rq->rq_iter);
-- 
2.46.0

