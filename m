Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBF5156665
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727373048; cv=none; b=G5sE2DkYGJGSDX/1n1OMfkqEVA7bicTOLQgfCAXWotYtLW6YxSa7f2FonFjtLrcYBg9OTF19wAX3PISP5rLHKAD9BUzELZEAns62bUNUKLd5VljtAQL8/80b0R8SgiR9rLIz133+HDPA7rRcmcDOFvxxf/fLluX2s3+yWoF1OgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727373048; c=relaxed/simple;
	bh=d565MLdWQjHKqGltud8i+BrAqX2N1fUmPy7coPaUCKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwHbWi8+wb5ce2DdVYALOVTYEUz4yf/K2Q2JMeEb4uWAWae30ItgYXgeIbptkmwzN101JFiaUq1Mid/5H2ESNgKU5cc7Xj/7oKBfGwarLXjSSAxXPwbELGk6E3YQOsU0CFthimwKXRgPSr3r1eTBPjgsYi26Tq8ERc52Pw7RNyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xSV+w7nY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7digUa1I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xSV+w7nY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7digUa1I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xSV+w7nY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7digUa1I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xSV+w7nY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7digUa1I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A0C41FD02;
	Thu, 26 Sep 2024 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrml7ir18Xpd7Usj5+1kP+IHs1wv6Ghk9fZ689hud+M=;
	b=xSV+w7nY+zzR6UqNFT1nc6W0R1RmphWUeijjpfx7nxwVJh7RnnTGNPY4JBFunUWqI0Idcq
	7op4k/EjB11hEoXOuPznmd9wkSRPnTjxWtHQLOK+vUV7R5w1O6KcIDebyTbLT8Mm3Pq0si
	U8x4XZnpGh8OxtS3PhI4U0Q/dHbSa4s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373045;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrml7ir18Xpd7Usj5+1kP+IHs1wv6Ghk9fZ689hud+M=;
	b=7digUa1IlqT37zergbw+kjHAI+MPIviOKqE9Ix6K8cOC3eJqnO5WD3MJMxsdbSY+9DRD3K
	Mx5Gqg3tSYYDK/BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xSV+w7nY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7digUa1I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrml7ir18Xpd7Usj5+1kP+IHs1wv6Ghk9fZ689hud+M=;
	b=xSV+w7nY+zzR6UqNFT1nc6W0R1RmphWUeijjpfx7nxwVJh7RnnTGNPY4JBFunUWqI0Idcq
	7op4k/EjB11hEoXOuPznmd9wkSRPnTjxWtHQLOK+vUV7R5w1O6KcIDebyTbLT8Mm3Pq0si
	U8x4XZnpGh8OxtS3PhI4U0Q/dHbSa4s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373045;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrml7ir18Xpd7Usj5+1kP+IHs1wv6Ghk9fZ689hud+M=;
	b=7digUa1IlqT37zergbw+kjHAI+MPIviOKqE9Ix6K8cOC3eJqnO5WD3MJMxsdbSY+9DRD3K
	Mx5Gqg3tSYYDK/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF56713793;
	Thu, 26 Sep 2024 17:50:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7TM4KfSe9WZMMgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Sep 2024 17:50:44 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 2/4] smb: client: allocate crypto only for primary server
Date: Thu, 26 Sep 2024 14:46:14 -0300
Message-ID: <20240926174616.229666-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240926174616.229666-1-ematsumiya@suse.de>
References: <20240926174616.229666-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A0C41FD02
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
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

For extra channels, point ->secmech.{enc,dec} to the primary
server ones.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsencrypt.c | 17 +++++++++++------
 fs/smb/client/smb2pdu.c     | 10 +++++++---
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 7481b21a0489..15aa75e7f1c3 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -735,13 +735,18 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.sha512);
 	cifs_free_hash(&server->secmech.hmacmd5);
 
-	if (server->secmech.enc) {
-		crypto_free_aead(server->secmech.enc);
-		server->secmech.enc = NULL;
-	}
+	if (!SERVER_IS_CHAN(server)) {
+		if (server->secmech.enc) {
+			crypto_free_aead(server->secmech.enc);
+			server->secmech.enc = NULL;
+		}
 
-	if (server->secmech.dec) {
-		crypto_free_aead(server->secmech.dec);
+		if (server->secmech.dec) {
+			crypto_free_aead(server->secmech.dec);
+			server->secmech.dec = NULL;
+		}
+	} else {
+		server->secmech.enc = NULL;
 		server->secmech.dec = NULL;
 	}
 }
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a07327b704b5..12c7acae2905 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1268,9 +1268,13 @@ SMB2_negotiate(const unsigned int xid,
 	}
 
 	if (server->cipher_type && !rc) {
-		rc = smb3_crypto_aead_allocate(server);
-		if (rc)
-			cifs_server_dbg(VFS, "%s: crypto alloc failed, rc=%d\n", __func__, rc);
+		if (!SERVER_IS_CHAN(server)) {
+			rc = smb3_crypto_aead_allocate(server);
+		} else {
+			/* For channels, just reuse the primary server crypto secmech. */
+			server->secmech.enc = server->primary_server->secmech.enc;
+			server->secmech.dec = server->primary_server->secmech.dec;
+		}
 	}
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
-- 
2.46.0

