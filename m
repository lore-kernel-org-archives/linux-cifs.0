Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B754421B918
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152572; cv=none; b=G2mdNGnn0ys7A2LKdBSz66hxOJHlONic01Bbz8QOy6dccEAGaXpffWAu0BZpTFug5SVThFttmeHdON/g2Y6cVJzOKEisRdt0exNUOsoWoieLXmg3vdcvjPOsqIAtziDxcglTY0Kbkvg3UmfCedtozGko5ARiNhEQ79BTq6SKCdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152572; c=relaxed/simple;
	bh=vxUU7WUMYzQQu2EMppUT7oTE0zUB+pjjcgSJZJXCEP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht+IIxIk2Plco5sJgWHfGxuqh5ZfxY9ABxZAthnYWlQoDmc/Tz5BTxJPSPCYBBr20OCloRAirW0+nHz68slgZ6prdxsteNGfhg4w/cm+7ZDY5KMz/zV7tZFWgR6eAbq5Xlykz4DnenheOSJZs9MLoaPOfTx3If69Jkr0pSTwoxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ekkdqd4r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQno0XS5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ekkdqd4r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQno0XS5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ekkdqd4r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQno0XS5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ekkdqd4r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQno0XS5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4630335649;
	Mon, 29 Sep 2025 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pzj0dUkL7UESd/9KWCtT+EIHNnegNriOj+sy8Xk155E=;
	b=Ekkdqd4rnHs7AzVYvpKP2nlftiZvT2qOMWrCcEB80/GGLryqsDqRFqhy0qrADAL2NramxV
	VNnWX6Yg9RBWQ19glZupEe4yA/VM27TEtwNCeihpd+PNyJdjDOMzHmu6YmsrT8p/8VfkSK
	STKTpNzAzmIEdU7jvFHKfodKrSFopOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pzj0dUkL7UESd/9KWCtT+EIHNnegNriOj+sy8Xk155E=;
	b=JQno0XS5ukzeLTJy+9IgJkor7dfc2H5Sjso6eCNPnhi6kpqGhTa7zs3h1OToXVlujLlTFy
	IQIbPW8vBBIyyXCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pzj0dUkL7UESd/9KWCtT+EIHNnegNriOj+sy8Xk155E=;
	b=Ekkdqd4rnHs7AzVYvpKP2nlftiZvT2qOMWrCcEB80/GGLryqsDqRFqhy0qrADAL2NramxV
	VNnWX6Yg9RBWQ19glZupEe4yA/VM27TEtwNCeihpd+PNyJdjDOMzHmu6YmsrT8p/8VfkSK
	STKTpNzAzmIEdU7jvFHKfodKrSFopOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pzj0dUkL7UESd/9KWCtT+EIHNnegNriOj+sy8Xk155E=;
	b=JQno0XS5ukzeLTJy+9IgJkor7dfc2H5Sjso6eCNPnhi6kpqGhTa7zs3h1OToXVlujLlTFy
	IQIbPW8vBBIyyXCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8D9F13782;
	Mon, 29 Sep 2025 13:29:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c+SrI7OJ2mj/GwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:23 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 14/20] smb: client: wait for concurrent caching of dirents in cifs_readdir()
Date: Mon, 29 Sep 2025 10:27:59 -0300
Message-ID: <20250929132805.220558-15-ematsumiya@suse.de>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

The file struct passed down to cifs_readdir() is a stack variable, which
means it makes no sense to keep/track it across a cached dir lifetime.

Instead, use it to track concurrent accesses to the same cached path,
and wait for the previous one to finish filling/emitting.

Without this patch, virtually every 'ls' will issue a Find request,
even when we have both directory and dirents cached and valid.

With this patch, the chances of cache hits increases a lot, so on
highly concurrent scenarios, the amount of network calls are
drastically reduced.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.c |  3 ++
 fs/smb/client/readdir.c    | 66 +++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 9dd74268b2d8..ad455c067cba 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -595,6 +595,9 @@ static struct cached_fid *init_cached_dir(const char *path)
 	/* this is caller/lease ref */
 	kref_get(&cfid->refcount);
 
+	/* initial cached dirents position */
+	cfid->dirents.pos = 2;
+
 	return cfid;
 }
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 0b2efd680fe6..903919345df1 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -860,22 +860,16 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 	return true;
 }
 
-static void update_cached_dirents_count(struct cached_dirents *cde,
-					struct file *file)
+static void update_cached_dirents_count(struct cached_dirents *cde)
 {
-	if (cde->file != file)
-		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
 
 	cde->pos++;
 }
 
-static void finished_cached_dirents_count(struct cached_dirents *cde,
-					struct dir_context *ctx, struct file *file)
+static void finished_cached_dirents_count(struct cached_dirents *cde, struct dir_context *ctx)
 {
-	if (cde->file != file)
-		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
 	if (ctx->pos != cde->pos)
@@ -884,16 +878,11 @@ static void finished_cached_dirents_count(struct cached_dirents *cde,
 	cde->is_valid = 1;
 }
 
-static void add_cached_dirent(struct cached_dirents *cde,
-			      struct dir_context *ctx,
-			      const char *name, int namelen,
-			      struct cifs_fattr *fattr,
-				  struct file *file)
+static void add_cached_dirent(struct cached_dirents *cde, struct dir_context *ctx,
+			      const char *name, int namelen, struct cifs_fattr *fattr)
 {
 	struct cached_dirent *de;
 
-	if (cde->file != file)
-		return;
 	if (cde->is_valid || cde->is_failed)
 		return;
 	if (ctx->pos != cde->pos) {
@@ -934,8 +923,7 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 
 	if (cfid) {
 		mutex_lock(&cfid->dirents.de_mutex);
-		add_cached_dirent(&cfid->dirents, ctx, name, namelen,
-				  fattr, file);
+		add_cached_dirent(&cfid->dirents, ctx, name, namelen, fattr);
 		mutex_unlock(&cfid->dirents.de_mutex);
 	}
 
@@ -1076,19 +1064,13 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	cifs_put_tlink(tlink);
-	if (rc)
+retry_cached:
+	if (!cfid || !cfid_is_valid(cfid)) {
+		rc = -ENOENT;
 		goto cache_not_found;
+	}
 
 	mutex_lock(&cfid->dirents.de_mutex);
-	/*
-	 * If this was reading from the start of the directory
-	 * we need to initialize scanning and storing the
-	 * directory content.
-	 */
-	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
-		cfid->dirents.file = file;
-		cfid->dirents.pos = 2;
-	}
 	/*
 	 * If we already have the entire directory cached then
 	 * we can just serve the cache.
@@ -1102,10 +1084,32 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		mutex_unlock(&cfid->dirents.de_mutex);
 		goto rddir2_exit;
 	}
+
+	if (cfid->dirents.is_failed) {
+		rc = -ENOENT;
+		mutex_unlock(&cfid->dirents.de_mutex);
+		goto cache_not_found;
+	}
+
+	if (!cfid->dirents.file)
+		cfid->dirents.file = file;
+	else if (cfid->dirents.file != file)
+		rc = -EAGAIN;
 	mutex_unlock(&cfid->dirents.de_mutex);
 
+	/* someone else is filling up the dirents for this cfid, wait for them to finish */
+	if (rc == -EAGAIN) {
+		rc = 0;
+		goto retry_cached;
+	}
+
 	/* keep our cfid ref, but check if still valid after network calls */
 cache_not_found:
+	if (rc && cfid) {
+		close_cached_dir(cfid);
+		cfid = NULL;
+	}
+
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
@@ -1155,7 +1159,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	} else {
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			finished_cached_dirents_count(&cfid->dirents, ctx, file);
+			finished_cached_dirents_count(&cfid->dirents, ctx);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 		cifs_dbg(FYI, "Could not find entry\n");
@@ -1196,7 +1200,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos++;
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			update_cached_dirents_count(&cfid->dirents, file);
+			update_cached_dirents_count(&cfid->dirents);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 
@@ -1215,8 +1219,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
 rddir2_exit:
 	if (cfid) {
+		if (rc || cfid->dirents.is_failed || !cifsFile || cifsFile->srch_inf.endOfSearch)
+			cfid->dirents.file = NULL;
+
 		if (cifsFile)
 			cifsFile->invalidHandle = true;
+
 		close_cached_dir(cfid);
 	}
 	free_dentry_path(page);
-- 
2.49.0

