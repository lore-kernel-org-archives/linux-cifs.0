Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C52E8B9F
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759859058; cv=none; b=b0ni1PTZPbSQaEQs+tI5Gl8oZtZDgcX7u0eCsX8oOsdBknm+7LdIMnuX8p9HmIm0LvO4OGd+g21uCW2Lqh+mbmbYUIMGpoOrCeXpLc5+SRtXJ++GoLAOGKhuUU8pTrrImtgOSBHWRtVeYARgF/n4IkL/fATEam3Hk3NaL8ayiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759859058; c=relaxed/simple;
	bh=O7mN9sqy+dovwlJ/uHO7v7ssVAvUrk0vbdZCB4VuOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTjkAq5fVoysxoLUDfp8J97L/pTFqTIwqqQoqu1VpRV0sHHEFKO9LQzeUb6V8gP0MRiwVE2aY7gSmNAYK9Wzcd/FVd1eWpQLzjiD1Q0Rz00xjFTkqe2NtYpfvGjOLp+biRjllJMoTck/AFQ9LuuDQoqdlGyatGgwmc5JLXp+ClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qZa9yydo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rbHHKwCO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qZa9yydo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rbHHKwCO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qZa9yydo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rbHHKwCO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qZa9yydo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rbHHKwCO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A514420AC1;
	Tue,  7 Oct 2025 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4foxP1tsj3MW0AoK8pyMnRJoD0JiXdl2N7+TP3u3l8E=;
	b=qZa9yydoGyIWvNJwTZjb8Tm6ZrDWM7WkY67YOwJJiXW2OA8avPlyQSFB/9ivHX3JrS5NIS
	kZptJC00fCQTvCJHqQ1le5534aTgQ1TFTH6Rrt3vKDhHnoYslFlW4AS1MdOHDXmi+dAuaF
	iwvrPc2IkhAC60OuDi1sG23XB7CDwUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4foxP1tsj3MW0AoK8pyMnRJoD0JiXdl2N7+TP3u3l8E=;
	b=rbHHKwCOP862rQcvoNYHnq0RDgSziEJC0H9hS7AKDToZPOG06071CcbwGCJAJyX+89oKep
	Y6D63rp1lYy2k5Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qZa9yydo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rbHHKwCO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759859040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4foxP1tsj3MW0AoK8pyMnRJoD0JiXdl2N7+TP3u3l8E=;
	b=qZa9yydoGyIWvNJwTZjb8Tm6ZrDWM7WkY67YOwJJiXW2OA8avPlyQSFB/9ivHX3JrS5NIS
	kZptJC00fCQTvCJHqQ1le5534aTgQ1TFTH6Rrt3vKDhHnoYslFlW4AS1MdOHDXmi+dAuaF
	iwvrPc2IkhAC60OuDi1sG23XB7CDwUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759859040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4foxP1tsj3MW0AoK8pyMnRJoD0JiXdl2N7+TP3u3l8E=;
	b=rbHHKwCOP862rQcvoNYHnq0RDgSziEJC0H9hS7AKDToZPOG06071CcbwGCJAJyX+89oKep
	Y6D63rp1lYy2k5Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31E6213693;
	Tue,  7 Oct 2025 17:43:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A4N4Ol9R5WgmeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:59 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 14/20] smb: client: wait for concurrent caching of dirents in cifs_readdir()
Date: Tue,  7 Oct 2025 14:42:58 -0300
Message-ID: <20251007174304.1755251-15-ematsumiya@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007174304.1755251-1-ematsumiya@suse.de>
References: <20251007174304.1755251-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: A514420AC1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL73jpmmudngk8cygugnauyh74)];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

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
 fs/smb/client/readdir.c    | 61 +++++++++++++++++++++++---------------
 2 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 22709b0bfb3d..96c7154d8031 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -649,6 +649,9 @@ static struct cached_fid *init_cached_dir(const char *path)
 	/* this is caller ref */
 	kref_get(&cfid->refcount);
 
+	/* initial cached dirents position */
+	cfid->dirents.pos = 2;
+
 	return cfid;
 }
 
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 9470723a4579..32dcbb702b14 100644
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
@@ -929,8 +923,8 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 			  struct file *file)
 {
 	size_t delta_bytes = 0;
-	bool rc, added = false;
 	ino_t ino = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
+	bool rc;
 
 	rc = dir_emit(ctx, name, namelen, ino, fattr->cf_dtype);
 	if (!rc)
@@ -941,11 +935,10 @@ static bool cifs_dir_emit(struct dir_context *ctx,
 		delta_bytes = sizeof(struct cached_dirent) + (size_t)namelen + 1;
 
 		mutex_lock(&cfid->dirents.de_mutex);
-		added = add_cached_dirent(&cfid->dirents, ctx, name, namelen,
-					  fattr, file);
+		rc = add_cached_dirent(&cfid->dirents, ctx, name, namelen, fattr, file);
 		mutex_unlock(&cfid->dirents.de_mutex);
 
-		if (added) {
+		if (rc) {
 			/* per-tcon then global for consistency with free path */
 			atomic64_add((long long)delta_bytes, &cfid->cfids->total_dirents_bytes);
 			atomic_long_inc(&cfid->cfids->total_dirents_entries);
@@ -1092,19 +1085,13 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	cifs_put_tlink(tlink);
-	if (rc)
+retry_cached:
+	if (!cfid || !is_valid_cached_dir(cfid)) {
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
@@ -1118,10 +1105,32 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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
@@ -1171,7 +1180,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	} else {
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			finished_cached_dirents_count(&cfid->dirents, ctx, file);
+			finished_cached_dirents_count(&cfid->dirents, ctx);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 		cifs_dbg(FYI, "Could not find entry\n");
@@ -1212,7 +1221,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos++;
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
-			update_cached_dirents_count(&cfid->dirents, file);
+			update_cached_dirents_count(&cfid->dirents);
 			mutex_unlock(&cfid->dirents.de_mutex);
 		}
 
@@ -1231,8 +1240,12 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
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
2.51.0

