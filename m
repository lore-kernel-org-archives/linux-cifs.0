Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E52F9C2D
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152576; cv=none; b=r9P4gxvCqJkuRpiF+1VK9qX3jl1VOvdpZ8qJ0Acqc4ItgjsF+cz0Ua0zYHUuCVdQFAeQN5eeUpltADMGtrk3DWKRQD21BQ6o1sjFOUtMyqMhW01nwvVRB7o9hbtOiCdeFd44/CfTKJMFVecGe7PENRlvgrCMh62/IGHvpGUXGUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152576; c=relaxed/simple;
	bh=iqGheamg0HKgbeOw0PG60Hxquhcny0GxDqXSRHeQfMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoqQI3uqhTq4vcWGdlt/L7pOwz1l5jhEz35IklEZNFXgIP1FHjmjgjmER93NEMo8koUsOPEM/Qf2lQCHARNLGwOQ0apyyzNIOY2HmvHuCeGOAnFJf4IQUm9Ir5nei4aklNxbxcbNA+QL9WEkZ3U07oHoomZ6JQPsZgYCcIxiMlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fbGQWRoY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JEcuMYCV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fbGQWRoY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JEcuMYCV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fbGQWRoY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JEcuMYCV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fbGQWRoY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JEcuMYCV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65DD5327E2;
	Mon, 29 Sep 2025 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rzpLq9lGVVuxiw4ooXlsUzL4C+ELKuvaMpQu60aLJ8=;
	b=fbGQWRoYU0WnMY7sA2wKm0sKlGNTzJhqRIRtbpLM3WuPIRMrJwroH+GcbSAjrCimI1BgYA
	KrlvAWU4m/cxIUpvat9FWKTz5yCmTpznqUl4Z1EJuveiUOkqYe9yA95LZRDAg/MpUlq82F
	qgAKVPxNvd27hgusBBl4kO+Fjp4GRk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rzpLq9lGVVuxiw4ooXlsUzL4C+ELKuvaMpQu60aLJ8=;
	b=JEcuMYCVYOt3RhGlcoWx5NB5THHg8qVWEks9j2gpGmoogrzGvN86DDP+DljQ8yQIJD+TvD
	0E0rU/+WSrvrIfBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rzpLq9lGVVuxiw4ooXlsUzL4C+ELKuvaMpQu60aLJ8=;
	b=fbGQWRoYU0WnMY7sA2wKm0sKlGNTzJhqRIRtbpLM3WuPIRMrJwroH+GcbSAjrCimI1BgYA
	KrlvAWU4m/cxIUpvat9FWKTz5yCmTpznqUl4Z1EJuveiUOkqYe9yA95LZRDAg/MpUlq82F
	qgAKVPxNvd27hgusBBl4kO+Fjp4GRk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rzpLq9lGVVuxiw4ooXlsUzL4C+ELKuvaMpQu60aLJ8=;
	b=JEcuMYCVYOt3RhGlcoWx5NB5THHg8qVWEks9j2gpGmoogrzGvN86DDP+DljQ8yQIJD+TvD
	0E0rU/+WSrvrIfBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E84DC13782;
	Mon, 29 Sep 2025 13:29:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WnFpK7aJ2mgDHAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:29:26 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 15/20] smb: client: remove cached_dirent->fattr
Date: Mon, 29 Sep 2025 10:28:00 -0300
Message-ID: <20250929132805.220558-16-ematsumiya@suse.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	R_RATELIMIT(0.00)[to_ip_from(RLfjfk8uratp77wzttmx99usr3)];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

Replace with ->unique_id and ->dtype -- the only fields used from
cifs_fattr.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cached_dir.h | 6 ++++--
 fs/smb/client/readdir.c    | 9 ++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index c45151446049..d5ad10a35ed7 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,13 +8,15 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
-
 struct cached_dirent {
 	struct list_head entry;
 	char *name;
 	int namelen;
 	loff_t pos;
-	struct cifs_fattr fattr;
+
+	/* filled from cifs_fattr */
+	u64 unique_id;
+	unsigned int dtype;
 };
 
 struct cached_dirents {
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 903919345df1..4b6e2632e8ed 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -850,9 +850,7 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 		 * initial scan.
 		 */
 		ctx->pos = dirent->pos;
-		rc = dir_emit(ctx, dirent->name, dirent->namelen,
-			      dirent->fattr.cf_uniqueid,
-			      dirent->fattr.cf_dtype);
+		rc = dir_emit(ctx, dirent->name, dirent->namelen, dirent->unique_id, dirent->dtype);
 		if (!rc)
 			return rc;
 		ctx->pos++;
@@ -901,9 +899,10 @@ static void add_cached_dirent(struct cached_dirents *cde, struct dir_context *ct
 		cde->is_failed = 1;
 		return;
 	}
-	de->pos = ctx->pos;
 
-	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
+	de->pos = ctx->pos;
+	de->unique_id = fattr->cf_uniqueid;
+	de->dtype = fattr->cf_dtype;
 
 	list_add_tail(&de->entry, &cde->entries);
 }
-- 
2.49.0

