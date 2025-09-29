Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE521B918
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152542; cv=none; b=X9tErnKmcRFp8G+Onrwgq8smbdV1pIHiBFZHdMeqZqAofmxHvQIvLr+lveDhKiqcdsSl/Q1ZbK5ItwF9t7pQTQ1YObsm0OGv9IAiGEEYqIQdvOdW05dmKq5ja/Hda6iMSeK9CEf/JGwueMyI+AXN8CJiZZVqLM/ESzFf9liwSfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152542; c=relaxed/simple;
	bh=qi1+8TATazi/8MOpViZXyvBUc3280eIO/rq70ThYa7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCxpKAMqjZXDV7TOWKcUijQ3Sca3k53QZgfVJ9Rr+96UuqDGf5H0FJQ6j5rKCVmuL5i2195VfdSqSgN6HDEbw9/G14rnubMBWAyFI750tHtylmT1EF1bWRrc8dgLUP9veXrXoG8PdEUOZh/x94r6nGklamExryn/TI6vlmC85DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UhKu00fG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z5LmcSMp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UhKu00fG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z5LmcSMp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UhKu00fG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z5LmcSMp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UhKu00fG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z5LmcSMp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78B77327CE;
	Mon, 29 Sep 2025 13:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIr/Zqmz/wgHXwfsVfoRt+ClprxOa6qxpBXIDVNyAzg=;
	b=UhKu00fG/oKtUn7jfDouGgDw1LF2GVNSDO3oaZsRODRAN5qmIPGclA2YI1eiyLTQpIX+DV
	6P1r0x4V+xUIrvH+Q8su7nui8QYAKCDeo1jpKgtb/FGagSN3m/B2AUGTnQkbzSbZdznPdN
	PZPrFhLLxr8GOHaHswBC1LUocEiDQO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIr/Zqmz/wgHXwfsVfoRt+ClprxOa6qxpBXIDVNyAzg=;
	b=z5LmcSMpbuoKfZ2G/eTnJ4jON8+hDpcFaXx2Ba9lqRC2YMSQ/YnYZ93RM5GS4+3hQM+Shq
	rC/zkKerOQg2ufBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UhKu00fG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z5LmcSMp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIr/Zqmz/wgHXwfsVfoRt+ClprxOa6qxpBXIDVNyAzg=;
	b=UhKu00fG/oKtUn7jfDouGgDw1LF2GVNSDO3oaZsRODRAN5qmIPGclA2YI1eiyLTQpIX+DV
	6P1r0x4V+xUIrvH+Q8su7nui8QYAKCDeo1jpKgtb/FGagSN3m/B2AUGTnQkbzSbZdznPdN
	PZPrFhLLxr8GOHaHswBC1LUocEiDQO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIr/Zqmz/wgHXwfsVfoRt+ClprxOa6qxpBXIDVNyAzg=;
	b=z5LmcSMpbuoKfZ2G/eTnJ4jON8+hDpcFaXx2Ba9lqRC2YMSQ/YnYZ93RM5GS4+3hQM+Shq
	rC/zkKerOQg2ufBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06EE713782;
	Mon, 29 Sep 2025 13:28:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y7z9L5mJ2mjaGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:57 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 07/20] smb: client: merge free_cached_dir in release callback
Date: Mon, 29 Sep 2025 10:27:52 -0300
Message-ID: <20250929132805.220558-8-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250929132805.220558-1-ematsumiya@suse.de>
References: <20250929132805.220558-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 78B77327CE
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01

free_cached_dir() is no longer used anywhere else.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 36a1e1436502..8c8ead6e96bd 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -13,7 +13,6 @@
 #include "cached_dir.h"
 
 static struct cached_fid *init_cached_dir(const char *path);
-static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 
 static inline void invalidate_cfid(struct cached_fid *cfid)
@@ -456,6 +455,7 @@ static void
 smb2_close_cached_fid(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid, refcount);
+	struct cached_dirent *de, *q;
 
 	/*
 	 * There's no way a valid cfid can reach here.
@@ -474,7 +474,17 @@ smb2_close_cached_fid(struct kref *ref)
 		list_del(&cfid->entry);
 
 	drop_cfid(cfid);
-	free_cached_dir(cfid);
+
+	/* Delete all cached dirent names */
+	list_for_each_entry_safe(de, q, &cfid->dirents.entries, entry) {
+		list_del(&de->entry);
+		kfree(de->name);
+		kfree(de);
+	}
+
+	kfree(cfid->path);
+	cfid->path = NULL;
+	kfree(cfid);
 }
 
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
@@ -613,24 +623,6 @@ static struct cached_fid *init_cached_dir(const char *path)
 	return cfid;
 }
 
-static void free_cached_dir(struct cached_fid *cfid)
-{
-	struct cached_dirent *dirent, *q;
-
-	/*
-	 * Delete all cached dirent names
-	 */
-	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
-		list_del(&dirent->entry);
-		kfree(dirent->name);
-		kfree(dirent);
-	}
-
-	kfree(cfid->path);
-	cfid->path = NULL;
-	kfree(cfid);
-}
-
 static void cfids_laundromat_worker(struct work_struct *work)
 {
 	struct cached_fids *cfids;
-- 
2.49.0

